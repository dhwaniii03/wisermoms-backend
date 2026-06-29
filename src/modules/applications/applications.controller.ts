import { Request, Response, NextFunction } from 'express';
import { ApplicationsService } from './applications.service';
import { UnauthorizedError } from '../../utils/errors';
import { safeLogger } from '../../middleware/sanitize';
import { requestContext } from '../../utils/controllerLog';

const applicationsService = new ApplicationsService();

export class ApplicationsController {
  async listApplications(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const applications = await applicationsService.listApplications(req.user.id, req.user.role, {
        quarter: req.query.quarter as string | undefined,
        year:
          req.query.year != null && req.query.year !== '' && req.query.year !== 'all'
            ? Number(req.query.year)
            : undefined,
        filter_pdfs_by_quarter: req.query.filter_pdfs_by_quarter as boolean | undefined,
      });
      res.status(200).json({ success: true, data: applications });
    } catch (error) {
      next(error);
    }
  }

  async getApplicationById(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const application = await applicationsService.getApplicationById(req.params.id, req.user.id, req.user.role);
      res.status(200).json({ success: true, data: application });
    } catch (error) {
      next(error);
    }
  }

  async createApplication(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const application = await applicationsService.createApplication(req.user.id, req.body);
      res.status(201).json({ success: true, data: application });
    } catch (error) {
      next(error);
    }
  }

  async updateApplication(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const application = await applicationsService.updateApplication(
        req.params.id,
        req.user.id,
        req.user.role,
        req.body
      );
      res.status(200).json({ success: true, data: application });
    } catch (error) {
      next(error);
    }
  }

  async deleteApplication(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      await applicationsService.deleteApplication(req.params.id, req.user.id, req.user.role);
      res.status(200).json({ success: true, message: 'Application deleted successfully' });
    } catch (error) {
      next(error);
    }
  }

  async generateDraft(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const { automationService } = require('../automation/automation.service');
      const draft = await automationService.composeApplicationEmail(req.params.id, req.user.id);
      res.status(200).json({ success: true, data: draft });
    } catch (error) {
      next(error);
    }
  }

  async applyApplication(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const { automationService } = require('../automation/automation.service');
      const { subject, body, to, attach_pdf, document_ids } = req.body;

      const application = await applicationsService.updateApplication(
        req.params.id,
        req.user.id,
        req.user.role,
        { status: 'submitted', notes: 'Secure application package sent to agency.' }
      );

      // Execute background task without BullMQ, pass custom subject/body/to and attach_pdf if edited, along with document_ids
      automationService
        .processApplication(req.params.id, req.user.id, body, subject, to, attach_pdf, document_ids)
        .catch((err: unknown) => {
          safeLogger.error(
            { ...requestContext(req), applicationId: req.params.id, err },
            'applications.applyApplication background processing failed'
          );
        });

      res.status(200).json({ success: true, message: 'Application queued for processing', data: application });
    } catch (error) {
      next(error);
    }
  }
}
