import { Request, Response, NextFunction } from 'express';
import { PartnerCasesService } from './partner-cases.service';
import { toAccessContext } from './partner-access';
import { UnauthorizedError } from '../../utils/errors';

const svc = new PartnerCasesService();

export class PartnerCasesController {
  async createCase(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const ctx = toAccessContext(req.orgUser);
      const data = await svc.createCase(ctx, req.body);
      res.status(201).json({ success: true, data });
    } catch (error) {
      next(error);
    }
  }

  async listCases(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const ctx = toAccessContext(req.orgUser);
      const data = await svc.listCases(ctx, {
        quarter: req.query.quarter as string | undefined,
        year: req.query.year ? Number(req.query.year) : undefined,
        search: req.query.search as string | undefined,
        status: req.query.status as string | undefined,
        program: req.query.program as string | undefined,
        funderType: req.query.funderType as string | undefined,
        caseworker: req.query.caseworker as string | undefined,
        limit: req.query.limit ? Number(req.query.limit) : undefined,
      });
      res.status(200).json({ success: true, data });
    } catch (error) {
      next(error);
    }
  }

  async getCase(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const ctx = toAccessContext(req.orgUser);
      const data = await svc.getCaseDetail(ctx, req.params.id);
      res.status(200).json({ success: true, data });
    } catch (error) {
      next(error);
    }
  }

  async getSummary(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const ctx = toAccessContext(req.orgUser);
      const data = await svc.getDashboardSummary(
        ctx,
        req.query.quarter as string | undefined,
        req.query.year ? Number(req.query.year) : undefined
      );
      res.status(200).json({ success: true, data });
    } catch (error) {
      next(error);
    }
  }

  async getFilters(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const ctx = toAccessContext(req.orgUser);
      const data = await svc.getFilterOptions(ctx);
      res.status(200).json({ success: true, data });
    } catch (error) {
      next(error);
    }
  }

  async sendReminder(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const ctx = toAccessContext(req.orgUser);
      const data = await svc.sendReminder(ctx, req.params.id);
      res.status(200).json({ success: true, data });
    } catch (error) {
      next(error);
    }
  }
}
