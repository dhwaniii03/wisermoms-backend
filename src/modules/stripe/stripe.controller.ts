import { Request, Response, NextFunction } from 'express';
import { StripeService } from './stripe.service';
import { UnauthorizedError, BadRequestError } from '../../utils/errors';

const stripeService = new StripeService();

export class StripeController {
  /**
   * Endpoint to create a Stripe Checkout Session
   */
  async createCheckoutSession(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const { plan, successUrl, cancelUrl } = req.body;
      const result = await stripeService.createCheckoutSession(req.user.id, plan, successUrl, cancelUrl);
      res.status(200).json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  /**
   * Endpoint to create a Stripe Customer Portal Session
   */
  async createPortalSession(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const { returnUrl } = req.body;
      const result = await stripeService.createPortalSession(req.user.id, returnUrl);
      res.status(200).json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  /**
   * Endpoint to handle incoming Stripe Webhooks
   */
  async webhook(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const signature = req.headers['stripe-signature'];
      if (!signature || typeof signature !== 'string') {
        throw new BadRequestError('Missing or invalid stripe-signature header');
      }

      // req.body must be parsed as raw Buffer for constructEvent to succeed
      const result = await stripeService.handleWebhook(signature, req.body);
      res.status(200).json(result);
    } catch (error) {
      next(error);
    }
  }
}
