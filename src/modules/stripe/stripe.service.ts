import { stripe } from '../../config/stripe';
import { env } from '../../config/env';
import { prisma } from '../../config/prisma';
import { NotFoundError, BadRequestError } from '../../utils/errors';
import { UserPlan } from '@prisma/client';
import Stripe from 'stripe';

export class StripeService {
  /**
   * Create a Stripe Checkout Session for a subscription plan
   */
  async createCheckoutSession(
    userId: string,
    plan: UserPlan,
    successUrl?: string,
    cancelUrl?: string
  ) {
    if (plan === UserPlan.community) {
      throw new BadRequestError('Cannot create a checkout session for the free plan');
    }

    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: { id: true, email: true, stripe_customer_id: true },
    });

    if (!user) {
      throw new NotFoundError('User not found');
    }

    // Determine pricing configuration
    const unitAmount = plan === UserPlan.network ? 898800 : 358800;
    const productName = plan === UserPlan.network ? 'MomPlan Network Plan' : 'MomPlan Partner Org Plan';
    const productDescription =
      plan === UserPlan.network
        ? 'Multi-site organization and coalition features'
        : 'Full caseworker dashboard and organization admin features';

    const defaultSuccessUrl = `${env.FRONTEND_URL}/dashboard?checkout=success`;
    const defaultCancelUrl = `${env.FRONTEND_URL}/pricing?checkout=cancel`;

    // Configure the session parameters
    const sessionParams: Stripe.Checkout.SessionCreateParams = {
      payment_method_types: ['card'],
      mode: 'subscription',
      line_items: [
        {
          price_data: {
            currency: 'usd',
            product_data: {
              name: productName,
              description: productDescription,
            },
            unit_amount: unitAmount,
            recurring: {
              interval: 'month',
            },
          },
          quantity: 1,
        },
      ],
      success_url: successUrl || defaultSuccessUrl,
      cancel_url: cancelUrl || defaultCancelUrl,
      subscription_data: {
        metadata: {
          userId: user.id,
          plan: plan,
        },
      },
      metadata: {
        userId: user.id,
        plan: plan,
      },
    };

    // Attach customer ID if exists, otherwise provide email to prepopulate
    if (user.stripe_customer_id) {
      sessionParams.customer = user.stripe_customer_id;
    } else {
      sessionParams.customer_email = user.email;
    }

    const session = await stripe.checkout.sessions.create(sessionParams);

    return {
      sessionId: session.id,
      url: session.url,
    };
  }

  /**
   * Create a Stripe Customer Portal Session for managing subscriptions
   */
  async createPortalSession(userId: string, returnUrl?: string) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: { stripe_customer_id: true },
    });

    if (!user || !user.stripe_customer_id) {
      throw new BadRequestError('No active Stripe subscription or customer record found');
    }

    const defaultReturnUrl = `${env.FRONTEND_URL}/dashboard`;

    const portalSession = await stripe.billingPortal.sessions.create({
      customer: user.stripe_customer_id,
      return_url: returnUrl || defaultReturnUrl,
    });

    return {
      url: portalSession.url,
    };
  }

  /**
   * Process incoming Stripe Webhooks securely
   */
  async handleWebhook(signature: string, payload: Buffer) {
    let event: Stripe.Event;

    try {
      event = stripe.webhooks.constructEvent(
        payload,
        signature,
        env.STRIPE_WEBHOOK_SECRET
      );
    } catch (err: any) {
      throw new BadRequestError(`Webhook Error: ${err.message}`);
    }

    switch (event.type) {
      case 'checkout.session.completed': {
        const session = event.data.object as Stripe.Checkout.Session;
        const userId = session.metadata?.userId;
        const planStr = session.metadata?.plan;

        if (userId && planStr) {
          const customerId = typeof session.customer === 'string' ? session.customer : undefined;
          const subscriptionId = typeof session.subscription === 'string' ? session.subscription : undefined;

          // Validate plan string maps to enum safely
          const planEnum = Object.values(UserPlan).includes(planStr as UserPlan)
            ? (planStr as UserPlan)
            : undefined;

          if (planEnum) {
            await prisma.user.update({
              where: { id: userId },
              data: {
                stripe_customer_id: customerId,
                stripe_subscription_id: subscriptionId,
              },
            });
          }
        }
        break;
      }

      case 'customer.subscription.updated': {
        const subscription = event.data.object as Stripe.Subscription;
        const subscriptionId = subscription.id;
        const customerId = typeof subscription.customer === 'string' ? subscription.customer : undefined;
        
        // If status becomes inactive/canceled/past_due, we can optionally handle downgrade
        if (subscription.status === 'canceled' || subscription.status === 'unpaid') {
          if (customerId) {
            await prisma.user.updateMany({
              where: { stripe_customer_id: customerId },
              data: {
                stripe_subscription_id: null,
              },
            });
          }
        }
        break;
      }

      case 'customer.subscription.deleted': {
        const subscription = event.data.object as Stripe.Subscription;
        const customerId = typeof subscription.customer === 'string' ? subscription.customer : undefined;

        if (customerId) {
          await prisma.user.updateMany({
            where: { stripe_customer_id: customerId },
            data: {
              stripe_subscription_id: null,
            },
          });
        }
        break;
      }

      default:
        // Unhandled event type
        break;
    }

    return { received: true };
  }
}
