import { Request, Response, NextFunction } from 'express';
import { SessionsService } from './sessions.service';
import { UnauthorizedError } from '../../utils/errors';

const sessionsService = new SessionsService();

export class SessionsController {
  async listSessions(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const sessions = await sessionsService.listSessions(req.user.id, req.user.role);
      res.status(200).json({ success: true, data: sessions });
    } catch (error) {
      next(error);
    }
  }

  async bookSession(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const session = await sessionsService.bookSession(req.user.id, req.body);
      res.status(201).json({ success: true, data: session });
    } catch (error) {
      next(error);
    }
  }

  async updateSession(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const session = await sessionsService.updateSession(req.params.id, req.user.id, req.user.role, req.body);
      res.status(200).json({ success: true, data: session });
    } catch (error) {
      next(error);
    }
  }

  async deleteSession(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      await sessionsService.deleteSession(req.params.id, req.user.id, req.user.role);
      res.status(200).json({ success: true, message: 'Session cancelled and deleted successfully' });
    } catch (error) {
      next(error);
    }
  }
}
