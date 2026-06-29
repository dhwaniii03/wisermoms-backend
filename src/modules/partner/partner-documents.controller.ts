import { Request, Response, NextFunction } from 'express';
import { PartnerDocumentsService } from './partner-documents.service';
import { toAccessContext } from './partner-access';
import { UnauthorizedError } from '../../utils/errors';

const svc = new PartnerDocumentsService();

export class PartnerDocumentsController {
  async listDocuments(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const ctx = toAccessContext(req.orgUser);
      const data = await svc.listSubmissionDocuments(ctx, {
        type: req.query.type as string | undefined,
        limit: req.query.limit != null ? Number(req.query.limit) : undefined,
      });
      res.status(200).json({ success: true, data });
    } catch (error) {
      next(error);
    }
  }
}
