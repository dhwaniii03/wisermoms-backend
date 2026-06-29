import { prisma } from '../../config/prisma';
import { sendEmail } from '../../config/email';
import { formatUserName } from '../../utils/name.utils';
import { decimalToNumber } from '../../utils/decimal.utils';
import {
  resolveSubmissionGeneratedPdfId,
  syncPartnerPortalOnSecureSubmission,
} from '../partner/partner-submission.service';
import { persistApplicationQuarterYear } from '../applications/application-quarter.utils';
/**
 * Government Contact Ingestion & Caching Strategy
 * Supports scalable dynamic routing for email composition.
 */
export interface GovContact {
  agency: string;
  department: string;
  email: string;
  state: string;
  category: string;
  source_url: string;
}

export class AutomationService {
  // In-memory cache to prevent constant DB hits if schema is expanded later
  private contactCache: Map<string, GovContact[]> = new Map();

  /**
   * TASK 7: Ingests scraped contacts from external websites safely.
   */
  async ingestContacts(contacts: GovContact[]) {
    console.log(`[Automation] Ingesting ${contacts.length} government contacts...`);
    
    for (const contact of contacts) {
      // Validate email format
      if (!/^\S+@\S+\.\S+$/.test(contact.email)) {
        continue;
      }
      
      const key = `${contact.state}-${contact.agency}`;
      const existing = this.contactCache.get(key) || [];
      
      // Prevent duplicates
      if (!existing.find(c => c.email === contact.email)) {
        existing.push(contact);
        this.contactCache.set(key, existing);
      }
    }
  }

  /**
   * TASK 6: Prepares a composed email draft for a specific application.
   * Finds the correct contact, generates a templated body using AI, and prepares document attachments.
   */
  async composeApplicationEmail(applicationId: string, userId: string, attachPdf: boolean = true, documentIds?: string[]) {
    const application = await prisma.application.findUnique({
      where: { id: applicationId },
      include: {
        program: true,
        user: { include: { family_profile: true } },
        documents: true
      }
    });

    if (!application) {
      throw new Error('Application not found');
    }

    if (!application.program_id || !application.program) {
      throw new Error('Application does not have a valid benefit program');
    }

    const programId = application.program_id;
    const program = application.program;
    const familyProfile = application.user.family_profile;

    // 1. Verify Eligibility (allow draft for programs the user is actively pursuing)
    const eligibilityResult = await prisma.eligibilityResult.findUnique({
      where: {
        user_id_program_id: { user_id: userId, program_id: programId }
      }
    });

    const allowedStatuses = ['qualified', 'likely_qualified', 'check_required'];
    if (!eligibilityResult || !allowedStatuses.includes(eligibilityResult.status)) {
      throw new Error('User is not eligible to draft an application for this program.');
    }

    // 2. Determine target contact
    const state = application.user.state || 'National';
    const contacts = this.contactCache.get(`${state}-${program.agency}`) || [];
    const primaryContact = program.contact_email || (contacts.length > 0 ? contacts[0].email : 'support@agency.gov');

    // 3. Determine which documents to attach
    let docsToAttach = [];
    if (documentIds && Array.isArray(documentIds)) {
      docsToAttach = await prisma.document.findMany({
        where: {
          id: { in: documentIds },
          user_id: userId
        }
      });
    } else {
      docsToAttach = application.documents;
    }

    // Avoid attaching the generated package twice when attachPdf also includes it
    if (attachPdf) {
      docsToAttach = docsToAttach.filter((doc) => doc.document_type !== 'application_package');
    }

    const applicantName = formatUserName(application.user) || 'Applicant';
    const monthlyIncome = familyProfile ? decimalToNumber(familyProfile.monthly_income) : null;
    const householdSize = familyProfile?.household_size ?? 'Not specified';
    const city = familyProfile?.city ?? 'Not specified';
    const applicantState = application.user.state ?? 'Not specified';

    const templateBody = `Dear ${program.agency} Representative,\n\n` +
      `Please find the application submission for ${applicantName}.\n` +
      `Program: ${program.name}\n\n` +
      (docsToAttach.length > 0
        ? `Attached are ${docsToAttach.length} supporting documents.\n`
        : '') +
      `\nThank you,\nMomPlan Automations System`;

    // 4. Compose email via Anthropic AI when profile data is available
    const { callClaudeApi } = require('../../config/anthropic');
    const systemPrompt = `You are an automated government application assistant.
Your task is to draft a formal, professional email to a government agency representative on behalf of an applicant.
Do not include any placeholder brackets like [Name] in your final output, use the provided data.
Keep the email structured, clear, and focused on application submission.`;

    const userPrompt = `Draft an application submission email for ${applicantName} applying to ${program.name}.
Agency: ${program.agency}
Applicant Profile:
- Household Size: ${householdSize}
- Income: ${monthlyIncome != null ? `$${monthlyIncome}/month` : 'Not specified'}
- Address: ${city}, ${applicantState}
- Documents Attached: ${docsToAttach.length > 0 ? docsToAttach.map(d => d.display_name).join(', ') : 'None'}

The email should be ready to send as-is. End with "MomPlan Automations System" as the sender.`;

    let generatedBody = templateBody;
    if (familyProfile) {
      try {
        generatedBody = await callClaudeApi(systemPrompt, userPrompt);
      } catch (err) {
        console.error('Failed to generate AI email, falling back to template', err);
        generatedBody = templateBody;
      }
    }

    const subject = `Application Submission: ${program.name} - ${applicantName}`;

    const generatedPdf = attachPdf
      ? await prisma.generatedPdf.findFirst({
          where: {
            application_id: applicationId,
            user_id: userId,
          },
          orderBy: { generated_at: 'desc' },
        }) ??
        (await prisma.generatedPdf.findFirst({
          where: {
            user_id: userId,
            program_id: programId,
          },
          orderBy: { generated_at: 'desc' },
        }))
      : null;

    return {
      to: primaryContact,
      subject,
      body: generatedBody,
      attachments: [
        ...(generatedPdf ? [{
          filename: `${program.name.replace(/\s+/g, '_')}_Application.pdf`,
          url: generatedPdf.file_url,
          mimeType: 'application/pdf',
        }] : []),
        ...docsToAttach.map(doc => ({
          filename: doc.display_name,
          url: doc.file_url,
          mimeType: doc.mime_type
        }))
      ]
    };
  }

  /**
   * TASK 5: Application Workflow Hooks for future automation expansion
   */
  async onApplicationStatusChange(applicationId: string, newStatus: string) {
    console.log(`[Automation] Hook triggered for Application ${applicationId} -> ${newStatus}`);
    
    if (newStatus === 'submitted') {
      // Future: automatically generate email composition and queue it for review
      console.log(`[Automation] Queuing async review tasks for submitted application.`);
    }
  }

  /**
   * TASK 8: Process Application (Sync replacement for BullMQ)
   */
  async processApplication(
    applicationId: string,
    userId: string,
    customBody?: string,
    customSubject?: string,
    customTo?: string,
    attachPdf: boolean = true,
    documentIds?: string[]
  ) {
    console.log(`[Worker] Processing Apply Now for application: ${applicationId}`);

    try {
      const application = await prisma.application.findUnique({
        where: { id: applicationId },
        select: { program_id: true },
      });
      if (!application?.program_id) {
        throw new Error('Application does not have a valid benefit program');
      }

      const generatedPdfId = await resolveSubmissionGeneratedPdfId(
        applicationId,
        userId,
        application.program_id,
        attachPdf
      );

      // 1. Compose email (this will fetch contact, prepare payload, and use AI to generate email)
      const emailData = await this.composeApplicationEmail(applicationId, userId, attachPdf, documentIds);

      if (customBody) emailData.body = customBody;
      if (customSubject) emailData.subject = customSubject;
      if (customTo) emailData.to = customTo;

      // 2. Attach documents and send email
      await sendEmail({
        to: emailData.to,
        subject: emailData.subject,
        html: emailData.body,
        attachments: emailData.attachments.map((att: any) => ({
          filename: att.filename,
          path: att.url, // Resend accepts remote URLs using 'path'
        }))
      });

      const resolvedDocumentIds =
        documentIds ??
        (
          await prisma.document.findMany({
            where: { application_id: applicationId, user_id: userId },
            select: { id: true },
          })
        ).map((d) => d.id);

      // 3. Update application tracking status
      const submissionPdf = generatedPdfId
        ? await prisma.generatedPdf.findUnique({
            where: { id: generatedPdfId },
            select: { quarter: true, year: true },
          })
        : null;

      await prisma.application.update({
        where: { id: applicationId },
        data: { status: 'submitted', submitted_at: new Date() },
      });

      await persistApplicationQuarterYear(
        applicationId,
        submissionPdf?.quarter,
        submissionPdf?.year ?? undefined
      );

      await prisma.partnerCase.updateMany({
        where: { application_id: applicationId },
        data: { status: 'submitted' },
      });

      // 4. Sync partner portal with the exact submission package
      await syncPartnerPortalOnSecureSubmission({
        applicationId,
        userId,
        generatedPdfId,
        documentIds: resolvedDocumentIds,
      });

      // 5. Notify user
      await prisma.notification.create({
        data: {
          user_id: userId,
          type: 'status_update',
          title: 'Application Submitted',
          message: `Your application has been successfully submitted to the agency.`,
          related_application_id: applicationId,
        },
      });

      console.log(`[Worker] Successfully processed Apply Now for application: ${applicationId}`);
    } catch (error: any) {
      console.error(`[Worker] Failed to process application ${applicationId}:`, error);

      await prisma.application.update({
        where: { id: applicationId },
        data: {
          status: 'action_required',
          notes: `Secure submission failed: ${error.message}`,
        },
      });

      await prisma.partnerCase.updateMany({
        where: { application_id: applicationId },
        data: { status: 'action_required' },
      });

      await prisma.notification.create({
        data: {
          user_id: userId,
          type: 'system',
          title: 'Application Submission Failed',
          message: `We encountered an error submitting your application. Please try again or contact support. Error: ${error.message}`,
          related_application_id: applicationId,
        },
      });
    }
  }
}

export const automationService = new AutomationService();
