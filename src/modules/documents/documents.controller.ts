import { Request, Response, NextFunction } from 'express';
import { DocumentsService } from './documents.service';
import { UnauthorizedError, BadRequestError } from '../../utils/errors';
import { pipeline } from 'stream/promises';

const documentsService = new DocumentsService();

// Whitelist allowed MIME types for document upload validation
const ALLOWED_MIME_TYPES = new Set([
  'application/pdf',
  'image/jpeg',
  'image/png',
  'image/jpg',
]);

export class DocumentsController {
  async listDocuments(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const documents = await documentsService.listDocuments(req.user.id, req.user.role);
      res.status(200).json({ success: true, data: documents });
    } catch (error) {
      next(error);
    }
  }

  async getDocumentById(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const document = await documentsService.getDocumentById(req.params.id, req.user.id, req.user.role);
      res.status(200).json({ success: true, data: document });
    } catch (error) {
      next(error);
    }
  }

  async downloadDocument(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      
      const { stream, mimeType, fileName, size } = await documentsService.downloadDocument(req.params.id, req.user.id, req.user.role);
      
      res.setHeader('Content-Type', mimeType || 'application/octet-stream');
      res.setHeader('Content-Disposition', `inline; filename="${fileName}"`);
      if (size !== null && size !== undefined) {
        res.setHeader('Content-Length', size.toString());
      }
      
      await pipeline(stream as any, res);
    } catch (error) {
      next(error);
    }
  }

  async uploadDocument(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      if (!req.file) {
        throw new BadRequestError('No file provided for upload');
      }

      // Check mime type whitelist
      if (!ALLOWED_MIME_TYPES.has(req.file.mimetype)) {
        throw new BadRequestError('Invalid file type. Only PDF, JPEG, and PNG files are accepted.');
      }

      // Check max size: 10MB
      const MAX_SIZE = 10 * 1024 * 1024;
      if (req.file.size > MAX_SIZE) {
        throw new BadRequestError('File size exceeds the maximum limit of 10MB.');
      }

      const document = await documentsService.uploadDocument(req.user.id, req.file, {
        document_type: req.body.document_type,
        application_id: req.body.application_id,
      });

      res.status(201).json({ success: true, data: document });
    } catch (error) {
      next(error);
    }
  }

  async deleteDocument(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      await documentsService.deleteDocument(req.params.id, req.user.id, req.user.role);
      res.status(200).json({ success: true, message: 'Document deleted successfully' });
    } catch (error) {
      next(error);
    }
  }

  async renameDocument(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const { name } = req.body;
      if (!name) throw new BadRequestError('New document name is required');
      const document = await documentsService.renameDocument(req.params.id, req.user.id, req.user.role, name);
      res.status(200).json({ success: true, data: document });
    } catch (error) {
      next(error);
    }
  }
}
