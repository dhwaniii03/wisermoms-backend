import { Request, Response, NextFunction } from 'express';
import { PartnerAnalyticsService } from './partner-analytics.service';
import { toAccessContext } from './partner-access';
import { UnauthorizedError } from '../../utils/errors';

const svc = new PartnerAnalyticsService();

export class PartnerAnalyticsController {
  async getAnalytics(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const ctx = toAccessContext(req.orgUser);
      const { quarter, year } = req.query;
      const data = await svc.getAnalytics(ctx, {
        quarter: quarter ? String(quarter) : undefined,
        year: year ? Number(year) : undefined,
      });
      res.status(200).json({ success: true, data });
    } catch (error) {
      next(error);
    }
  }

  async getCaseworkerCards(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const ctx = toAccessContext(req.orgUser);
      const data = await svc.getCaseworkerCards(ctx);
      res.status(200).json({ success: true, data });
    } catch (error) {
      next(error);
    }
  }
}
