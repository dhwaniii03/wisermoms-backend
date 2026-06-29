import { Request, Response, NextFunction } from 'express';
import { PartnerOrgService } from './partner-org.service';
import { UnauthorizedError } from '../../utils/errors';

const svc = new PartnerOrgService();

export class PartnerOrgController {
  async completeOnboarding(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const result = await svc.completeOnboarding(req.orgUser.orgId, req.body);
      res.status(200).json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  async getOrganization(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const org = await svc.getOrganization(req.orgUser.orgId);
      res.status(200).json({ success: true, data: { organization: org } });
    } catch (error) {
      next(error);
    }
  }

  async updateOrganization(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const org = await svc.updateOrganization(req.orgUser.orgId, req.body);
      res.status(200).json({ success: true, data: { organization: org } });
    } catch (error) {
      next(error);
    }
  }
}
