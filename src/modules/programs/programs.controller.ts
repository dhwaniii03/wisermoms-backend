import { Request, Response, NextFunction } from 'express';
import { ProgramsService } from './programs.service';
import { UnauthorizedError } from '../../utils/errors';

const programsService = new ProgramsService();

export class ProgramsController {
  async listPrograms(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const filters = {
        state: req.query.state as string | undefined,
        type: req.query.type as string | undefined,
        search: req.query.search as string | undefined,
        level: req.query.level as string | undefined,
        page: req.query.page ? Number(req.query.page) : undefined,
        limit: req.query.limit ? Number(req.query.limit) : undefined,
      };
      const data = await programsService.listPrograms(filters);
      res.status(200).json({ success: true, data });
    } catch (error) {
      next(error);
    }
  }

  async listDocumentsChecklist(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const filters = {
        state: req.query.state as string | undefined,
        level: req.query.level as string | undefined,
        search: req.query.search as string | undefined,
        page: req.query.page ? Number(req.query.page) : undefined,
        limit: req.query.limit ? Number(req.query.limit) : undefined,
      };
      const data = await programsService.listDocumentsChecklist(filters);
      res.status(200).json({ success: true, data });
    } catch (error) {
      next(error);
    }
  }

  async getProgramById(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const program = await programsService.getProgramById(req.params.id);
      res.status(200).json({ success: true, data: program });
    } catch (error) {
      next(error);
    }
  }

  async createProgram(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const program = await programsService.createProgram(req.user.id, req.body);
      res.status(201).json({ success: true, data: program });
    } catch (error) {
      next(error);
    }
  }

  async updateProgram(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const program = await programsService.updateProgram(req.user.id, req.params.id, req.body);
      res.status(200).json({ success: true, data: program });
    } catch (error) {
      next(error);
    }
  }

  async deleteProgram(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      await programsService.deleteProgram(req.user.id, req.params.id);
      res.status(200).json({ success: true, message: 'Program deleted successfully' });
    } catch (error) {
      next(error);
    }
  }

  async getProgramQuarterDueDates(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const year = req.query.year ? Number(req.query.year) : undefined;
      const quarters = await programsService.getProgramQuarterDueDates(req.params.id, year);
      res.status(200).json({ success: true, data: quarters });
    } catch (error) {
      next(error);
    }
  }

  async backfillQuarterDueDates(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const year = req.body?.year as number | undefined;
      const summary = await programsService.backfillQuarterDueDates(year);
      res.status(200).json({ success: true, data: summary });
    } catch (error) {
      next(error);
    }
  }
}
