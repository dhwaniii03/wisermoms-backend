import { Request, Response, NextFunction } from 'express';
import { BillingService } from './billing.service';
import { UnauthorizedError, BadRequestError } from '../../utils/errors';

const billingService = new BillingService();

export class BillingController {
  async checkout(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const session = await billingService.createCheckoutSession(
        req.user.id,
        req.body.plan,
        req.body.interval
      );
      res.status(200).json({ success: true, data: session });
    } catch (error) {
      next(error);
    }
  }

  async activateCommunity(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const subscription = await billingService.activateCommunityPlan(req.user.id);
      res.status(200).json({ success: true, data: { plan: 'community', subscription } });
    } catch (error) {
      next(error);
    }
  }

  async upgrade(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const result = await billingService.upgradeSubscription(
        req.user.id,
        req.body.plan,
        req.body.interval
      );
      res.status(200).json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  async cancel(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const result = await billingService.cancelSubscription(req.user.id);
      res.status(200).json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  async reactivate(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const result = await billingService.reactivateSubscription(req.user.id);
      res.status(200).json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  async portal(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const session = await billingService.createPortalSession(req.user.id);
      res.status(200).json({ success: true, data: session });
    } catch (error) {
      next(error);
    }
  }

  async subscription(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const status = await billingService.getSubscriptionStatus(req.user.id);
      res.status(200).json({ success: true, data: status });
    } catch (error) {
      next(error);
    }
  }

  async webhook(req: Request, res: Response, next: NextFunction): Promise<void> {
    const signature = req.headers['stripe-signature'];

    if (!signature || typeof signature !== 'string') {
      next(new BadRequestError('Missing stripe-signature header'));
      return;
    }

    try {
      const result = await billingService.handleWebhook(signature, req.body);
      res.status(200).json(result);
    } catch (error) {
      next(error);
    }
  }
}
