import { Request, Response, NextFunction } from 'express';
import { AdminService } from './admin.service';
import { PdfService } from '../pdf/pdf.service';
import { UnauthorizedError } from '../../utils/errors';
import { UserRole, UserStatus, ApplicationPriority } from '@prisma/client';

const adminService = new AdminService();
const pdfService = new PdfService();

export class AdminController {
  async listUsers(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const filters = {
        page: req.query.page ? parseInt(req.query.page as string, 10) : undefined,
        limit: req.query.limit ? parseInt(req.query.limit as string, 10) : undefined,
        search: req.query.search as string | undefined,
        role: req.query.role as UserRole | undefined,
        status: req.query.status as UserStatus | undefined,
      };
      const result = await adminService.listUsers(filters);
      res.status(200).json({ success: true, ...result });
    } catch (error) {
      next(error);
    }
  }

  async getUserById(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const user = await adminService.getUserById(req.params.id);
      res.status(200).json({ success: true, data: user });
    } catch (error) {
      next(error);
    }
  }

  async updateUserStatus(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const user = await adminService.updateUserStatus(req.user.id, req.params.id, req.body.status);
      res.status(200).json({ success: true, data: user });
    } catch (error) {
      next(error);
    }
  }

  async listApplications(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const filters = {
        status: req.query.status as string | undefined,
        program_id: req.query.program_id as string | undefined,
        priority: req.query.priority as ApplicationPriority | undefined,
      };
      const applications = await adminService.listApplications(filters);
      res.status(200).json({ success: true, data: applications });
    } catch (error) {
      next(error);
    }
  }

  async updateApplication(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const application = await adminService.updateApplication(req.user.id, req.params.id, req.body);
      res.status(200).json({ success: true, data: application });
    } catch (error) {
      next(error);
    }
  }

  async getAnalyticsOverview(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const overview = await adminService.getAnalyticsOverview();
      res.status(200).json({ success: true, data: overview });
    } catch (error) {
      next(error);
    }
  }

  async getUsersTimeseries(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const timeseries = await adminService.getUsersTimeseries();
      res.status(200).json({ success: true, data: timeseries });
    } catch (error) {
      next(error);
    }
  }

  async getApplicationsTimeseries(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const timeseries = await adminService.getApplicationsTimeseries();
      res.status(200).json({ success: true, data: timeseries });
    } catch (error) {
      next(error);
    }
  }

  async getProgramsAnalytics(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const analytics = await adminService.getProgramsAnalytics();
      res.status(200).json({ success: true, data: analytics });
    } catch (error) {
      next(error);
    }
  }

  async listAuditLogs(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const logs = await adminService.listAuditLogs();
      res.status(200).json({ success: true, data: logs });
    } catch (error) {
      next(error);
    }
  }

  async listPdfs(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const pdfs = await adminService.listAllPdfs();
      res.status(200).json({ success: true, data: pdfs });
    } catch (error) {
      next(error);
    }
  }

  async downloadPdf(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const url = await pdfService.getDownloadUrl(req.params.id, req.user.id, req.user.role);
      res.status(200).json({ success: true, data: { url } });
    } catch (error) {
      next(error);
    }
  }
}
