import { env } from '../../config/env';
import { prisma } from '../../config/prisma';
import { stripe } from '../../config/stripe';
import { sendEmail } from '../../config/email';
import { isMockStripeMode } from '../../modules/billing/billing.plans';
import { formatUserName } from '../../utils/name.utils';

export const runSubscriptionSyncTask = async () => {
  try {
    console.log('💳 Running daily subscription-sync background job...');

    if (isMockStripeMode()) {
      console.log('⚠️ Skipping active Stripe remote API polling (mock/placeholder mode).');
      return;
    }

    const subscriptions = await prisma.subscription.findMany({
      where: {
        plan: { in: ['partner', 'network'] },
        status: { in: ['active', 'past_due', 'trialing'] },
        stripe_subscription_id: { not: null },
      },
      include: {
        user: {
          select: {
            id: true,
            email: true,
            first_name: true,
            middle_name: true,
            last_name: true,
          },
        },
      },
    });

    for (const record of subscriptions) {
      const user = record.user;
      if (!record.stripe_subscription_id) continue;

      try {
        const subscription = await stripe.subscriptions.retrieve(record.stripe_subscription_id);

        if (subscription.status === 'canceled' || subscription.status === 'unpaid') {
          await prisma.subscription.updateMany({
            where: { stripe_subscription_id: record.stripe_subscription_id },
            data: { status: 'canceled' },
          });

          await prisma.user.update({
            where: { id: user.id },
            data: { stripe_subscription_id: null },
          });

          await prisma.notification.create({
            data: {
              user_id: user.id,
              type: 'system',
              title: 'Subscription Cancelled or Past Due',
              message:
                'Your MomPlan paid membership has been deactivated. Your account is now on the Community plan.',
            },
          });

          await sendEmail({
            to: user.email,
            subject: 'MomPlan Subscription Update',
            html: `<h1>Subscription Deactivated</h1>
            <p>Hello ${formatUserName(user)},</p>
            <p>We were unable to verify an active status for your subscription. Your account has been moved to the Community plan.</p>
            <p>You can review or update your payment credentials via your dashboard anytime.</p>`,
          });
        } else {
          await prisma.subscription.updateMany({
            where: { stripe_subscription_id: record.stripe_subscription_id },
            data: {
              status: subscription.status === 'past_due' ? 'past_due' : 'active',
              current_period_end: new Date(subscription.current_period_end * 1000),
              cancel_at_period_end: subscription.cancel_at_period_end,
            },
          });
        }
      } catch (err: unknown) {
        const message = err instanceof Error ? err.message : 'Unknown error';
        console.error(`Failed to sync subscription for user ${user.id}:`, message);
      }
    }

    console.log('✅ Daily subscription-sync job finished successfully.');
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : 'Unknown error';
    console.error('❌ Subscription sync job failed with error:', message);
  }
};
