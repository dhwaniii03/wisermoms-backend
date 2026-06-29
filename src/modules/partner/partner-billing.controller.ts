import { Request, Response, NextFunction } from 'express';
import { PartnerBillingService } from './partner-billing.service';
import { ForbiddenError } from '../../utils/errors';

const partnerBillingService = new PartnerBillingService();

function requireOrgAdmin(req: Request): string {
  if (!req.orgUser) throw new ForbiddenError('Not authenticated');
  if (req.orgUser.role !== 'admin') {
    throw new ForbiddenError('Only organization admins can manage billing');
  }
  return req.orgUser.orgId;
}

export class PartnerBillingController {
  async checkout(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const orgId = requireOrgAdmin(req);
      const session = await partnerBillingService.createCheckout(
        orgId,
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
      const orgId = requireOrgAdmin(req);
      const subscription = await partnerBillingService.activateCommunity(orgId);
      res.status(200).json({ success: true, data: { plan: 'community', subscription } });
    } catch (error) {
      next(error);
    }
  }

  async upgrade(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const orgId = requireOrgAdmin(req);
      const result = await partnerBillingService.upgrade(
        orgId,
        req.body.plan,
        req.body.interval
      );
      res.status(200).json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  async downgrade(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const orgId = requireOrgAdmin(req);
      const result = await partnerBillingService.downgrade(
        orgId,
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
      const orgId = requireOrgAdmin(req);
      const result = await partnerBillingService.cancel(orgId);
      res.status(200).json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  async reactivate(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const orgId = requireOrgAdmin(req);
      const result = await partnerBillingService.reactivate(orgId);
      res.status(200).json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  async portal(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const orgId = requireOrgAdmin(req);
      const session = await partnerBillingService.portal(orgId);
      res.status(200).json({ success: true, data: session });
    } catch (error) {
      next(error);
    }
  }

  async subscription(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const orgId = requireOrgAdmin(req);
      const status = await partnerBillingService.subscription(orgId);
      res.status(200).json({ success: true, data: status });
    } catch (error) {
      next(error);
    }
  }
}
