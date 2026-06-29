import { Request, Response, NextFunction } from 'express';
import { DeadlinesService, DeadlineDashboardFilters } from './deadlines.service';
import { getQuarterForMonth } from '../programs/quarterDueDates.service';
import { Quarter } from '../programs/quarterDueDates.types';
import { UnauthorizedError } from '../../utils/errors';

const deadlinesService = new DeadlinesService();

function parseDashboardFilters(req: Request): DeadlineDashboardFilters {
  const type = (req.query.type as 'all' | 'federal' | 'state') || 'all';
  const quarterParam = req.query.quarter;
  const quarter: Quarter =
    typeof quarterParam === 'string' && ['Q1', 'Q2', 'Q3', 'Q4'].includes(quarterParam)
      ? (quarterParam as Quarter)
      : getQuarterForMonth(new Date().getUTCMonth() + 1);
  const yearParam = req.query.year;
  let year: number | 'all' = 'all';
  if (yearParam !== 'all' && yearParam !== undefined && yearParam !== '') {
    const parsed = Number.parseInt(String(yearParam), 10);
    if (Number.isFinite(parsed) && parsed > 0) {
      year = parsed;
    }
  }
  return { type, year, quarter };
}

export class DeadlinesController {
  async getDashboard(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const filters = parseDashboardFilters(req);
      const data = await deadlinesService.getDashboard(req.user.id, filters);
      res.status(200).json({ success: true, data });
    } catch (error) {
      next(error);
    }
  }

  async getSubmittedApplicationsDashboard(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const filters = parseDashboardFilters(req);
      const data = await deadlinesService.getSubmittedApplicationsDashboard(req.user.id, filters);
      res.status(200).json({ success: true, data });
    } catch (error) {
      next(error);
    }
  }

  async listDeadlines(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const deadlines = await deadlinesService.listDeadlines(req.user.id, req.user.role);
      res.status(200).json({ success: true, data: deadlines });
    } catch (error) {
      next(error);
    }
  }

  async createDeadline(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const deadline = await deadlinesService.createDeadline(req.user.id, req.user.role, req.body);
      res.status(201).json({ success: true, data: deadline });
    } catch (error) {
      next(error);
    }
  }

  async completeDeadline(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const deadline = await deadlinesService.completeDeadline(req.params.id, req.user.id, req.user.role);
      res.status(200).json({ success: true, data: deadline });
    } catch (error) {
      next(error);
    }
  }

  async deleteDeadline(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      await deadlinesService.deleteDeadline(req.params.id, req.user.id, req.user.role);
      res.status(200).json({ success: true, message: 'Due date deleted' });
    } catch (error) {
      next(error);
    }
  }
}
