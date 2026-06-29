import { prisma } from '../../config/prisma';
import { userNameSelect } from '../../utils/name.utils';
import { s3Client } from '../../config/s3';
import { env } from '../../config/env';
import { PutObjectCommand, DeleteObjectCommand, GetObjectCommand } from '@aws-sdk/client-s3';
import { NotFoundError, ForbiddenError } from '../../utils/errors';
import { sendEmail } from '../../config/email';
import { UserRole } from '@prisma/client';
import crypto from 'crypto';
import fs from 'fs';
import path from 'path';

function classifyDocumentType(fileName: string, currentType: string = 'other'): string {
  const lowerName = fileName.toLowerCase();
  
  if (
    lowerName.includes('license') || 
    lowerName.includes('licence') || 
    lowerName.includes('passport') || 
    lowerName.includes('govt') || 
    lowerName.includes('government') ||
    /\bid\b/.test(lowerName) ||
    /\bdl\b/.test(lowerName) ||
    lowerName.includes('driver') ||
    lowerName.includes('state_id') ||
    lowerName.includes('state-id')
  ) {
    return 'government_id';
  }
  
  if (
    lowerName.includes('income') || 
    lowerName.includes('paystub') || 
    lowerName.includes('pay_stub') || 
    lowerName.includes('pay-stub') || 
    lowerName.includes('stub') || 
    lowerName.includes('w2') || 
    lowerName.includes('w-2') || 
    lowerName.includes('salary') || 
    lowerName.includes('earning') ||
    lowerName.includes('payslip')
  ) {
    return 'proof_of_income';
  }

  if (
    lowerName.includes('birth') || 
    lowerName.includes('certificate') || 
    lowerName.includes('baby') || 
    lowerName.includes('child_cert')
  ) {
    return 'birth_certificate';
  }

  if (
    lowerName.includes('lease') || 
    lowerName.includes('rental') || 
    lowerName.includes('rent') || 
    lowerName.includes('tenancy')
  ) {
    return 'lease_agreement';
  }

  if (
    lowerName.includes('utility') || 
    lowerName.includes('bill') || 
    lowerName.includes('electric') || 
    lowerName.includes('gas') || 
    lowerName.includes('water') || 
    lowerName.includes('heating') || 
    lowerName.includes('sewer')
  ) {
    return 'utility_bill';
  }

  if (
    lowerName.includes('bank') || 
    lowerName.includes('statement') || 
    lowerName.includes('checking') || 
    lowerName.includes('savings') ||
    lowerName.includes('financial')
  ) {
    return 'bank_statement';
  }

  if (
    lowerName.includes('medical') || 
    lowerName.includes('health') || 
    lowerName.includes('doctor') || 
    lowerName.includes('disability') || 
    lowerName.includes('clinical') ||
    lowerName.includes('vaccin') ||
    lowerName.includes('immuniz')
  ) {
    return 'medical_record';
  }

  if (
    lowerName.includes('childcare') || 
    lowerName.includes('provider') || 
    lowerName.includes('nanny') || 
    lowerName.includes('daycare') ||
    lowerName.includes('ccdf')
  ) {
    return 'childcare_record';
  }

  if (
    lowerName.includes('ssn') || 
    lowerName.includes('social security') || 
    lowerName.includes('social_security') || 
    lowerName.includes('ssc')
  ) {
    return 'social_security_card';
  }

  if (
    lowerName.includes('immigration') || 
    lowerName.includes('green card') || 
    lowerName.includes('greencard') || 
    lowerName.includes('visa') || 
    lowerName.includes('ead') || 
    lowerName.includes('permanent resident')
  ) {
    return 'immigration_document';
  }

  if (
    lowerName.includes('school') || 
    lowerName.includes('enrollment') || 
    lowerName.includes('student') || 
    lowerName.includes('class') || 
    lowerName.includes('transcript')
  ) {
    return 'school_enrollment';
  }

  if (
    lowerName.includes('tax') || 
    lowerName.includes('return') || 
    lowerName.includes('1040') || 
    lowerName.includes('irs')
  ) {
    return 'tax_return';
  }

  if (
    lowerName.includes('pregnant') || 
    lowerName.includes('pregnancy') || 
    lowerName.includes('due date') || 
    lowerName.includes('due_date') || 
    lowerName.includes('ultrasound')
  ) {
    return 'proof_of_pregnancy';
  }

  if (
    lowerName.includes('custody') || 
    lowerName.includes('divorce') || 
    lowerName.includes('guardianship') || 
    lowerName.includes('court order') || 
    lowerName.includes('court_order')
  ) {
    return 'custody_order';
  }

  return currentType;
}

export class DocumentsService {
  async listDocuments(userId: string, role: UserRole) {
    if (role === 'admin' || role === 'counselor') {
      return prisma.document.findMany({
        include: {
          user: { select: { ...userNameSelect, email: true } },
          application: { include: { program: { select: { name: true } } } },
        },
        orderBy: { uploaded_at: 'desc' },
      });
    }

    return prisma.document.findMany({
      where: { user_id: userId },
      include: {
        application: { include: { program: { select: { name: true } } } },
      },
      orderBy: { uploaded_at: 'desc' },
    });
  }

  async getDocumentById(id: string, userId: string, role: UserRole) {
    const doc = await prisma.document.findUnique({
      where: { id },
      include: {
        application: true,
      },
    });

    if (!doc) {
      throw new NotFoundError('Document not found');
    }

    if (role === 'user' && doc.user_id !== userId) {
      throw new ForbiddenError('Access denied to view this document');
    }

    return doc;
  }

  async uploadDocument(
    userId: string,
    file: Express.Multer.File,
    data: { document_type: string; application_id?: string }
  ) {
    const fileExtension = file.originalname.split('.').pop() || '';
    const uniqueKey = `documents/${userId}/${crypto.randomUUID()}.${fileExtension}`;
    const isPlaceholder = env.AWS_ACCESS_KEY_ID.includes('placeholder');

    let file_url = '';

    if (isPlaceholder) {
      console.log('⚠️ [MOCK S3 UPLOAD] Saving file locally due to placeholder credentials.');
      const uploadDir = path.join(process.cwd(), 'uploads', 'documents', userId);
      fs.mkdirSync(uploadDir, { recursive: true });
      const localPath = path.join(uploadDir, `${crypto.randomUUID()}.${fileExtension}`);
      fs.writeFileSync(localPath, file.buffer);
      file_url = localPath;
    } else {
      file_url = `https://${env.S3_BUCKET_NAME}.s3.${env.AWS_REGION}.amazonaws.com/${uniqueKey}`;
      await s3Client.send(
        new PutObjectCommand({
          Bucket: env.S3_BUCKET_NAME,
          Key: uniqueKey,
          Body: file.buffer,
          ContentType: file.mimetype,
        })
      );
    }

    let documentType = data.document_type || 'other';
    if (documentType === 'other') {
      documentType = classifyDocumentType(file.originalname, documentType);
    }

    const document = await prisma.document.create({
      data: {
        user_id: userId,
        application_id: data.application_id || null,
        document_type: documentType,
        original_file_name: file.originalname,
        display_name: file.originalname,
        file_url,
        file_size: file.size,
        mime_type: file.mimetype,
      },
    });

    return document;
  }

  async downloadDocument(id: string, userId: string, role: UserRole) {
    const doc = await prisma.document.findUnique({ where: { id } });
    if (!doc) throw new NotFoundError('Document not found');
    if (role === 'user' && doc.user_id !== userId) throw new ForbiddenError('Access denied to view this document');

    const isPlaceholder = env.AWS_ACCESS_KEY_ID.includes('placeholder');

    if (isPlaceholder) {
      let filePath = doc.file_url;
      if (!fs.existsSync(filePath)) {
        // Fallback: try to resolve relative to process.cwd()
        const docsIndex = doc.file_url.indexOf('uploads');
        if (docsIndex !== -1) {
          const relativePath = doc.file_url.substring(docsIndex);
          const resolvedPath = path.join(process.cwd(), relativePath);
          if (fs.existsSync(resolvedPath)) {
            filePath = resolvedPath;
          } else {
            const resolvedPathSub = path.join(process.cwd(), 'backend', relativePath);
            if (fs.existsSync(resolvedPathSub)) {
              filePath = resolvedPathSub;
            } else {
              throw new NotFoundError(`Local file not found at ${filePath} or ${resolvedPath}`);
            }
          }
        } else {
          throw new NotFoundError('Local file not found');
        }
      }

      return {
        stream: fs.createReadStream(filePath),
        mimeType: doc.mime_type,
        fileName: doc.display_name,
        size: doc.file_size,
      };
    } else {
      try {
        const urlObj = new URL(doc.file_url);
        const key = urlObj.pathname.substring(1);
        const s3Obj = (await s3Client.send(
          new GetObjectCommand({
            Bucket: env.S3_BUCKET_NAME,
            Key: key,
          })
        )) as { Body?: NodeJS.ReadableStream | null };
        return {
          stream: s3Obj.Body ?? null,
          mimeType: doc.mime_type,
          fileName: doc.display_name,
          size: doc.file_size,
        };
      } catch (err) {
        console.error('Failed to stream S3 file:', err);
        throw new NotFoundError('Document file not found in storage');
      }
    }
  }

  async deleteDocument(id: string, userId: string, role: UserRole) {
    const doc = await prisma.document.findUnique({
      where: { id },
    });

    if (!doc) {
      throw new NotFoundError('Document not found');
    }

    if (role === 'user' && doc.user_id !== userId) {
      throw new ForbiddenError('Access denied to delete this document');
    }

    const isPlaceholder = env.AWS_ACCESS_KEY_ID.includes('placeholder');

    if (isPlaceholder) {
      try {
        if (fs.existsSync(doc.file_url)) {
          fs.unlinkSync(doc.file_url);
        }
      } catch (err) {
        console.error('Failed to delete local file:', err);
      }
    } else {
      try {
        const urlObj = new URL(doc.file_url);
        const key = urlObj.pathname.substring(1);
        await s3Client.send(
          new DeleteObjectCommand({
            Bucket: env.S3_BUCKET_NAME,
            Key: key,
          })
        );
      } catch (err) {
        console.error('Failed to delete S3 file:', err);
      }
    }

    await prisma.document.delete({
      where: { id },
    });
  }

  async renameDocument(id: string, userId: string, role: UserRole, newName: string) {
    const doc = await prisma.document.findUnique({
      where: { id },
    });

    if (!doc) {
      throw new NotFoundError('Document not found');
    }

    if (role === 'user' && doc.user_id !== userId) {
      throw new ForbiddenError('Access denied to rename this document');
    }

    // Optional: Validate extension. For simplicity, we just save the exact display_name given
    // assuming frontend handles extension logic if needed, or we just trust the string.
    
    const updated = await prisma.document.update({
      where: { id },
      data: { display_name: newName },
    });

    return updated;
  }
}
