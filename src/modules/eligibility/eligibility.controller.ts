import { Request, Response, NextFunction } from 'express';
import { EligibilityService } from './eligibility.service';
import { parseEligibilityResultsFilters } from './eligibility.filters';
import { UnauthorizedError } from '../../utils/errors';

const eligibilityService = new EligibilityService();

export class EligibilityController {
  async runScan(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const profileUpdates = req.body?.profile as Record<string, unknown> | undefined;
      const { results, aiStatus } = await eligibilityService.runScan(
        req.user.id,
        profileUpdates
      );

      let profile = null;
      if (profileUpdates && Object.keys(profileUpdates).length > 0) {
        const { UserService } = await import('../user/user.service');
        const userService = new UserService();
        profile = await userService.getProfile(req.user.id);
      }

      res.status(200).json({ success: true, data: { results, aiStatus, profile } });
    } catch (error) {
      next(error);
    }
  }

  async getResults(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const filters = parseEligibilityResultsFilters(req.query as Record<string, unknown>);
      const results = await eligibilityService.getResults(req.user.id, filters);
      res.status(200).json({ success: true, data: results });
    } catch (error) {
      next(error);
    }
  }

  async getResultByProgramId(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const result = await eligibilityService.getResultByProgramId(req.user.id, req.params.programId);
      res.status(200).json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }
}
