import { Request, Response, NextFunction } from 'express';
import { PdfService, buildPdfFilename } from './pdf.service';
import { UnauthorizedError, NotFoundError, ForbiddenError } from '../../utils/errors';
import { env } from '../../config/env';
import fs from 'fs';
import path from 'path';

const pdfService = new PdfService();

export class PdfController {
  async validateForProgram(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const report = await pdfService.validateForProgram(req.user.id, req.body.program_id);
      res.status(200).json({ success: true, data: report });
    } catch (error) {
      next(error);
    }
  }

  async generatePdf(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const pdf = await pdfService.generateApplicationPdf(
        req.user.id,
        req.body.program_id,
        req.body.application_id,
        req.body.quarter,
        req.body.year
      );
      res.status(201).json({ success: true, data: pdf });
    } catch (error) {
      next(error);
    }
  }

  async listPdfs(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const pdfs = await pdfService.listPdfs(req.user.id, req.user.role, {
        quarter: req.query.quarter as string | undefined,
        year: req.query.year != null ? Number(req.query.year) : undefined,
      });
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

  async streamLocalPdf(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const pdfs = await pdfService.listPdfs(req.user.id, req.user.role);
      const pdf = pdfs.find(p => p.id === req.params.id);
      
      if (!pdf) {
        throw new NotFoundError('PDF not found');
      }

      // Check access control
      if (req.user.role !== 'admin' && req.user.role !== 'counselor' && pdf.user_id !== req.user.id) {
        throw new ForbiddenError('Access denied');
      }

      const recordDownload = req.query.record_download === 'true';
      let fileName = buildPdfFilename(
        pdf.program?.name || 'Application',
        pdf.quarter,
        pdf.year,
        pdf.version
      );

      if (recordDownload) {
        const { version, filename } = await pdfService.recordDownload(pdf.id);
        fileName = filename;
        res.setHeader('X-Pdf-Version', String(version));
      }

      res.setHeader('Content-Type', 'application/pdf');
      res.setHeader(
        'Content-Disposition',
        `${recordDownload ? 'attachment' : 'inline'}; filename="${fileName}"`
      );

      // If it is an S3 URL, stream from S3
      if (pdf.file_url.startsWith('http://') || pdf.file_url.startsWith('https://')) {
        const { GetObjectCommand } = require('@aws-sdk/client-s3');
        const { s3Client } = require('../../config/s3');
        const urlObj = new URL(pdf.file_url);
        const key = urlObj.pathname.substring(1); // remove leading slash

        try {
          const s3Response = await s3Client.send(new GetObjectCommand({
            Bucket: env.S3_BUCKET_NAME,
            Key: key,
          }));
          
          if (s3Response.Body) {
            res.setHeader('Content-Length', s3Response.ContentLength?.toString() || pdf.file_size.toString());
            (s3Response.Body as any).pipe(res);
            return;
          } else {
            throw new NotFoundError('S3 PDF stream body is empty');
          }
        } catch (s3Err) {
          console.error('Failed to stream PDF from S3:', s3Err);
          throw new NotFoundError('PDF file not found in S3 storage');
        }
      }

      // Otherwise, it is a local path
      let filePath = pdf.file_url;
      if (!fs.existsSync(filePath)) {
        // Fallback: try to resolve relative to process.cwd() to handle multi-environment paths
        const pdfsIndex = pdf.file_url.indexOf('uploads/pdfs/');
        if (pdfsIndex !== -1) {
          const relativePath = pdf.file_url.substring(pdfsIndex);
          const resolvedPath = path.join(process.cwd(), relativePath);
          if (fs.existsSync(resolvedPath)) {
            filePath = resolvedPath;
          } else {
            // Check if running from root with a backend directory
            const resolvedPathSub = path.join(process.cwd(), 'backend', relativePath);
            if (fs.existsSync(resolvedPathSub)) {
              filePath = resolvedPathSub;
            } else {
              console.log(`PDF file not found at local paths. Attempting dynamic regeneration for PDF ID: ${pdf.id}`);
              try {
                await pdfService.regenerateLocalPdf(pdf.id);
                // After regeneration, re-verify paths
                if (fs.existsSync(resolvedPath)) {
                  filePath = resolvedPath;
                } else if (fs.existsSync(resolvedPathSub)) {
                  filePath = resolvedPathSub;
                } else if (fs.existsSync(pdf.file_url)) {
                  filePath = pdf.file_url;
                } else {
                  throw new NotFoundError(`Failed to find PDF on disk even after regeneration`);
                }
              } catch (regenError: any) {
                console.error(`Dynamic PDF regeneration failed for ID ${pdf.id}:`, regenError);
                throw new NotFoundError(`Local PDF file not found on disk, and regeneration failed: ${regenError.message}`);
              }
            }
          }
        } else {
          console.log(`PDF file not found. Attempting dynamic regeneration for path: ${filePath}`);
          try {
            await pdfService.regenerateLocalPdf(pdf.id);
            if (fs.existsSync(filePath)) {
              // Path found now
            } else {
              throw new NotFoundError(`Failed to find PDF at ${filePath} even after regeneration`);
            }
          } catch (regenError: any) {
            console.error(`Dynamic PDF regeneration failed for ID ${pdf.id}:`, regenError);
            throw new NotFoundError(`Local PDF file not found on disk, and regeneration failed: ${regenError.message}`);
          }
        }
      }

      const stats = fs.statSync(filePath);
      res.setHeader('Content-Length', stats.size.toString());

      const stream = fs.createReadStream(filePath);
      stream.pipe(res);
    } catch (error) {
      next(error);
    }
  }

  async syncVaultDocument(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      await pdfService.ensureVaultDocument(req.params.id, req.user.id);
      res.status(200).json({ success: true, message: 'PDF synced to document vault' });
    } catch (error) {
      next(error);
    }
  }

  async deletePdf(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      // Admin/counselors can delete any PDF, users can only delete their own
      const pdfs = await pdfService.listPdfs(req.user.id, req.user.role);
      const pdf = pdfs.find(p => p.id === req.params.id);

      if (!pdf) {
        throw new NotFoundError('PDF not found');
      }

      if (req.user.role !== 'admin' && req.user.role !== 'counselor' && pdf.user_id !== req.user.id) {
        throw new ForbiddenError('Access denied to delete this PDF');
      }

      // Delete file from disk if placeholder mode
      const isPlaceholder = env.AWS_ACCESS_KEY_ID.includes('placeholder');
      if (isPlaceholder) {
        try {
          if (fs.existsSync(pdf.file_url)) {
            fs.unlinkSync(pdf.file_url);
          }
        } catch (err) {
          console.error('Failed to delete local PDF file:', err);
        }
      } else {
        // AWS S3 DeleteObjectCommand
        const { DeleteObjectCommand } = require('@aws-sdk/client-s3');
        const { s3Client } = require('../../config/s3');
        try {
          const urlObj = new URL(pdf.file_url);
          const key = urlObj.pathname.substring(1);
          await s3Client.send(new DeleteObjectCommand({
            Bucket: env.S3_BUCKET_NAME,
            Key: key,
          }));
        } catch (err) {
          console.error('Failed to delete S3 PDF file:', err);
        }
      }

      // Delete from Prisma
      const { prisma } = require('../../config/prisma');
      await prisma.generatedPdf.delete({ where: { id: req.params.id } });

      res.status(200).json({ success: true, message: 'PDF deleted successfully' });
    } catch (error) {
      next(error);
    }
  }
}
