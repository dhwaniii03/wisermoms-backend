import { Request, Response, NextFunction } from 'express';
import { TeamService } from './team.service';
import { UnauthorizedError } from '../../utils/errors';

const svc = new TeamService();

export class TeamController {
  async listMembers(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const members = await svc.listMembers(req.orgUser.orgId);
      res.status(200).json({ success: true, data: members });
    } catch (error) {
      next(error);
    }
  }

  async bulkCreate(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const { emails, password, caseload_capacity } = req.body;
      const result = await svc.bulkCreateMembers(
        req.orgUser.orgId,
        emails,
        password,
        caseload_capacity
      );
      res.status(201).json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  async deleteMember(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      await svc.deleteMember(req.orgUser.orgId, req.params.id, req.orgUser.orgUserId);
      res.status(200).json({ success: true, message: 'Team member deleted' });
    } catch (error) {
      next(error);
    }
  }

  async resetPassword(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const result = await svc.resetPassword(req.orgUser.orgId, req.params.id);
      res.status(200).json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  async updateStatus(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const member = await svc.updateMemberStatus(
        req.orgUser.orgId,
        req.params.id,
        req.body.is_active,
        req.orgUser.orgUserId
      );
      res.status(200).json({ success: true, data: member });
    } catch (error) {
      next(error);
    }
  }

  async updateCapacity(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const member = await svc.updateMemberCapacity(
        req.orgUser.orgId,
        req.params.id,
        req.body.caseload_capacity
      );
      res.status(200).json({ success: true, data: member });
    } catch (error) {
      next(error);
    }
  }
}
