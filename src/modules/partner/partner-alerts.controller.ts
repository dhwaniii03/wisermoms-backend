import { Request, Response, NextFunction } from 'express';
import { PartnerAlertsService } from './partner-alerts.service';
import { toAccessContext } from './partner-access';
import { UnauthorizedError } from '../../utils/errors';

const svc = new PartnerAlertsService();

export class PartnerAlertsController {
  async getSummary(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const ctx = toAccessContext(req.orgUser);
      const data = await svc.getSummary(ctx, req.query.quarter as string | undefined);
      res.status(200).json({ success: true, data });
    } catch (error) {
      next(error);
    }
  }

  async listAlerts(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const ctx = toAccessContext(req.orgUser);
      const data = await svc.listAlerts(ctx, {
        quarter: req.query.quarter as string | undefined,
        search: req.query.search as string | undefined,
        alertType: req.query.type as string | undefined,
        program: req.query.program as string | undefined,
        caseworker: req.query.caseworker as string | undefined,
        showSnoozed: req.query.show_snoozed === 'true',
      });
      res.status(200).json({ success: true, data });
    } catch (error) {
      next(error);
    }
  }

  async snoozeAlert(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const ctx = toAccessContext(req.orgUser);
      const days = req.body?.days ? Number(req.body.days) : 3;
      const data = await svc.snoozeAlert(ctx, req.params.id, days);
      res.status(200).json({ success: true, data });
    } catch (error) {
      next(error);
    }
  }
}
