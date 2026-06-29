import { Resend } from 'resend';
import { env } from './env';
import fs from 'fs';
import path from 'path';

const resend = new Resend(env.RESEND_API_KEY);

interface SendEmailOptions {
  to: string;
  subject: string;
  html: string;
  attachments?: Array<{ filename: string; path?: string; content?: string | Buffer }>;
}

async function ensureLocalFileExists(filePath: string): Promise<string | null> {
  if (fs.existsSync(filePath)) {
    return filePath;
  }
  const uploadsIndex = filePath.indexOf('uploads');
  let relativePath = '';
  let resolvedPath = '';
  let resolvedPathSub = '';

  if (uploadsIndex !== -1) {
    relativePath = filePath.substring(uploadsIndex);
    resolvedPath = path.join(process.cwd(), relativePath);
    if (fs.existsSync(resolvedPath)) {
      return resolvedPath;
    }
    resolvedPathSub = path.join(process.cwd(), 'backend', relativePath);
    if (fs.existsSync(resolvedPathSub)) {
      return resolvedPathSub;
    }
  }

  // If not found, check if it's a PDF in the uploads/pdfs/ directory
  if (filePath.toLowerCase().endsWith('.pdf')) {
    try {
      const { prisma } = require('./prisma');
      // Search for any generated PDF matching the file_url or path
      const targetQuery = relativePath || filePath;
      const pdf = await prisma.generatedPdf.findFirst({
        where: {
          file_url: {
            contains: targetQuery,
          },
        },
      });

      if (pdf) {
        console.log(`[Email Service] PDF file not found at ${filePath}. Attempting dynamic regeneration for PDF ID: ${pdf.id}`);
        const { PdfService } = require('../modules/pdf/pdf.service');
        const pdfService = new PdfService();
        await pdfService.regenerateLocalPdf(pdf.id);

        // Re-check paths after regeneration
        if (fs.existsSync(filePath)) {
          return filePath;
        }
        if (resolvedPath && fs.existsSync(resolvedPath)) {
          return resolvedPath;
        }
        if (resolvedPathSub && fs.existsSync(resolvedPathSub)) {
          return resolvedPathSub;
        }
        if (fs.existsSync(pdf.file_url)) {
          return pdf.file_url;
        }
      }
    } catch (err) {
      console.error(`[Email Service] Error regenerating missing PDF attachment:`, err);
    }
  }

  return null;
}

export const sendEmail = async ({ to, subject, html, attachments }: SendEmailOptions): Promise<void> => {
  const isPlaceholder = env.RESEND_API_KEY.includes('placeholder');

  let processedAttachments: any[] | undefined = undefined;
  if (attachments && attachments.length > 0) {
    processedAttachments = await Promise.all(attachments.map(async (att) => {
      if (att.path && !att.path.startsWith('http://') && !att.path.startsWith('https://')) {
        const resolved = await ensureLocalFileExists(att.path);
        if (resolved) {
          try {
            const content = fs.readFileSync(resolved);
            return {
              filename: att.filename,
              content,
            };
          } catch (err) {
            console.error(`❌ Failed to read local attachment: ${resolved}`, err);
          }
        } else {
          console.warn(`⚠️ Could not resolve local attachment path: ${att.path}`);
        }
      }
      return att;
    }));
  }

  if (isPlaceholder) {
    console.log(`✉️ [MOCK EMAIL] To: ${to} | Subject: ${subject}`);
    console.log(`Content: ${html}`);
    if (processedAttachments && processedAttachments.length > 0) {
      console.log(`Attachments: ${processedAttachments.length} files attached.`);
      processedAttachments.forEach(att => {
        console.log(` - ${att.filename} (${att.content ? 'Buffer' : att.path})`);
      });
    }
    return;
  }

  try {
    const data = await resend.emails.send({
      from: env.RESEND_FROM_EMAIL,
      to,
      subject,
      html,
      attachments: processedAttachments,
    });
    console.log('✅ Email sent successfully:', data);
  } catch (error) {
    console.error('❌ Failed to send email:', error);
  }
};
