import { Request, Response, NextFunction } from 'express';
import { MothersService } from './mothers.service';
import { toAccessContext } from '../partner/partner-access';
import { UnauthorizedError } from '../../utils/errors';

const svc = new MothersService();

export class MothersController {
  async listMothers(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const ctx = toAccessContext(req.orgUser);
      const data = await svc.listMothers(ctx, {
        caseworker: req.query.caseworker as string | undefined,
        search: req.query.search as string | undefined,
      });
      res.status(200).json({ success: true, data });
    } catch (error) {
      next(error);
    }
  }

  async getMother(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const ctx = toAccessContext(req.orgUser);
      const data = await svc.getMother(ctx, req.params.id);
      res.status(200).json({ success: true, data });
    } catch (error) {
      next(error);
    }
  }

  async assignCaseworker(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const data = await svc.assignCaseworker(
        req.orgUser.orgId,
        req.params.id,
        req.body.caseworkerId
      );
      res.status(200).json(data);
    } catch (error) {
      next(error);
    }
  }

  async unassignCaseworker(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const data = await svc.unassignCaseworker(req.orgUser.orgId, req.params.id);
      res.status(200).json(data);
    } catch (error) {
      next(error);
    }
  }

  async listCaseworkers(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const data = await svc.listAssignableCaseworkers(req.orgUser.orgId);
      res.status(200).json({ success: true, data });
    } catch (error) {
      next(error);
    }
  }
}
