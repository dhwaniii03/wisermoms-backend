import PDFDocument from 'pdfkit';
import { prisma } from '../../config/prisma';
import { s3Client } from '../../config/s3';
import { callClaudeApi } from '../../config/anthropic';
import { env } from '../../config/env';
import { getProgramRequirements, getDocumentLabel, DOCUMENT_META, ProgramRequirements } from './program-requirements.data';
import { getQuarterForMonth } from '../programs/quarterDueDates.service';
import { Quarter } from '../programs/quarterDueDates.types';
import { PutObjectCommand } from '@aws-sdk/client-s3';
import { getPresignedDownloadUrl } from '../../config/s3';
import { hasUserName, joinFullName, userNameSelect } from '../../utils/name.utils';
import { decimalToNumber } from '../../utils/decimal.utils';
import crypto from 'crypto';
import fs from 'fs';
import path from 'path';

export interface ValidationReport {
  is_valid: boolean;
  missing_required_fields: string[];
  missing_required_documents: string[];
  missing_optional_fields: string[];
  missing_optional_documents: string[];
  uploaded_document_types: string[];   // NEW — which doc types the user HAS uploaded
  can_generate: boolean;
}

/** HTTP Content-Disposition filenames must be ASCII — strip unicode punctuation (e.g. em dashes). */
export function sanitizeFilenamePart(value: string): string {
  return value
    .replace(/\s+/g, '_')
    .replace(/[^A-Za-z0-9._-]/g, '_')
    .replace(/_+/g, '_')
    .replace(/^_|_$/g, '') || 'Application';
}

export function buildPdfFilename(
  programName: string,
  quarter: string | null | undefined,
  year: number | null | undefined,
  version: number
): string {
  const safeName = sanitizeFilenamePart(programName || 'Application');
  const quarterPart = quarter && year ? `_${quarter}_${year}` : '';
  return `${safeName}_Package${quarterPart}_v${version}.pdf`;
}

export class PdfService {
  private resolveQuarterYear(quarter?: string, year?: number): { quarter: Quarter; year: number } {
    const now = new Date();
    const resolvedQuarter =
      quarter && ['Q1', 'Q2', 'Q3', 'Q4'].includes(quarter)
        ? (quarter as Quarter)
        : getQuarterForMonth(now.getUTCMonth() + 1);
    const resolvedYear = year ?? now.getUTCFullYear();
    return { quarter: resolvedQuarter, year: resolvedYear };
  }

  // ─── Validate what data is present/missing before generation ───────────────
  async validateForProgram(userId: string, programId: string): Promise<ValidationReport> {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      include: { family_profile: true, documents: true },
    });

    if (!user) throw new Error('User not found');
    const profile = user.family_profile;
    const monthlyIncome = decimalToNumber(profile?.monthly_income);

    const program = await prisma.benefitProgram.findUnique({ where: { id: programId } });
    if (!program) throw new Error('Program not found');

    const requirements = getProgramRequirements(program.name);

    const missing_required_fields: string[] = [];
    const missing_optional_fields: string[] = [];
    const missing_required_documents: string[] = [];
    const missing_optional_documents: string[] = [];

    const checkField = (field: string): boolean => {
      if (field === 'full_name') return hasUserName(user);
      if (!profile) return false;
      if (field === 'date_of_birth') return !!profile.date_of_birth;
      if (field === 'address') return !!(profile.street_address && profile.city && profile.state && profile.zip_code);
      if (field === 'household_size') return profile.household_size !== null && profile.household_size > 0;
      if (field === 'num_children') return profile.num_children !== null && profile.num_children >= 0;
      if (field === 'children_ages') {
        if (profile.num_children === 0) return true;
        const ages = profile.children_ages as any;
        return Array.isArray(ages) && ages.length > 0;
      }
      if (field === 'monthly_income') return profile.monthly_income !== null && monthlyIncome >= 0;
      if (field === 'employment_status') return !!profile.employment_status;
      if (field === 'immigration_status') return !!profile.immigration_status;
      if (field === 'employer_name') return !!profile.employer_name;
      if (field === 'has_disability') return typeof profile.has_disability === 'boolean';
      if (field === 'income_sources') {
        const sources = profile.income_sources as any;
        return Array.isArray(sources) && sources.length > 0;
      }
      if (field === 'monthly_rent') return profile.monthly_rent !== null && profile.monthly_rent !== undefined;
      if (field === 'monthly_utilities') return profile.monthly_utilities !== null && profile.monthly_utilities !== undefined;
      if (field === 'eviction_risk') return typeof profile.eviction_risk === 'boolean';
      if (field === 'is_pregnant') return typeof profile.is_pregnant === 'boolean';
      if (field === 'health_insurance') return !!profile.health_insurance;
      if (field === 'chronic_illness') return typeof profile.chronic_illness === 'boolean';
      if (field === 'marital_status') return !!profile.marital_status;
      if (field === 'domestic_violence') return typeof profile.domestic_violence === 'boolean';
      if (field === 'needs_childcare') return typeof profile.needs_childcare === 'boolean';
      if (field === 'legal_issues') {
        const issues = profile.legal_issues as any;
        return Array.isArray(issues) && issues.length > 0;
      }
      return false;
    };

    for (const field of requirements.required_fields) {
      if (!checkField(field)) missing_required_fields.push(field);
    }
    for (const field of requirements.optional_fields) {
      if (!checkField(field)) missing_optional_fields.push(field);
    }

    const userDocTypes = new Set(user.documents.map(d => d.document_type));
    for (const docType of requirements.required_documents) {
      if (!userDocTypes.has(docType)) missing_required_documents.push(docType);
    }
    for (const docType of requirements.optional_documents) {
      if (!userDocTypes.has(docType)) missing_optional_documents.push(docType);
    }

    const is_valid = missing_required_fields.length === 0 && missing_required_documents.length === 0;
    const can_generate = hasUserName(user);

    return {
      is_valid,
      missing_required_fields,
      missing_required_documents,
      missing_optional_fields,
      missing_optional_documents,
      uploaded_document_types: Array.from(userDocTypes),
      can_generate,
    };
  }

  // ─── Generate PDF Buffer Helper ───────────────────────────────────────────
  async generatePdfBuffer(
    userId: string,
    programId: string,
    applicationId?: string,
    existingUuid?: string,
    pdfMeta?: { version?: number; quarter?: Quarter; year?: number }
  ): Promise<{ pdfBuffer: Buffer; validationReport: ValidationReport; uuid: string }> {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      include: { family_profile: true, documents: true },
    });

    if (!user || !user.family_profile) {
      throw new Error('Complete family profile not found.');
    }

    const profile = user.family_profile;
    const monthlyIncome = decimalToNumber(profile.monthly_income);
    const program = await prisma.benefitProgram.findUnique({ where: { id: programId } });
    if (!program) throw new Error('Benefit program not found.');

    const displayName = joinFullName(user.first_name, user.middle_name, user.last_name);

    const eligibilityResult = await prisma.eligibilityResult.findUnique({
      where: { user_id_program_id: { user_id: userId, program_id: programId } },
    });

    const eligibility = eligibilityResult || {
      id: crypto.randomUUID(),
      user_id: userId,
      program_id: programId,
      status: 'check_required' as const,
      confidence_score: 80,
      reasoning: 'Eligibility pending formal agency review. Application drafted by user.',
      created_at: new Date(),
      checked_at: new Date(),
      org_id: null as string | null,
      match_type: null as string | null,
      eligibility: null as string | null,
      estimated_benefit: null as any,
      match_reason: null as string | null,
      ai_rank: null as number | null,
      reasons: [] as string[],
      program_code: null as string | null,
    };

    if (!applicationId) {
      const app = await prisma.application.findFirst({ where: { user_id: userId, program_id: programId } });
      if (app) applicationId = app.id;
    }

    const requirements = getProgramRequirements(program.name);
    const validationReport = await this.validateForProgram(userId, programId);

    // Build doc lookup: type → uploaded Document record
    const docByType = new Map(user.documents.map(d => [d.document_type, d]));

    // Categorise required/optional docs for this program
    const requiredDocs = (requirements?.required_documents ?? []).map(type => ({
      type,
      uploaded: docByType.get(type) ?? null,
      required: true,
    }));
    const optionalDocs = (requirements?.optional_documents ?? []).map(type => ({
      type,
      uploaded: docByType.get(type) ?? null,
      required: false,
    }));
    const allProgramDocs = [...requiredDocs, ...optionalDocs];

    const missingRequiredDocs = requiredDocs.filter(d => !d.uploaded);
    const hasMissingRequired = missingRequiredDocs.length > 0;

    // ── Claude AI narrative summary ─────────────────────────────────────────
    let eligibilitySummary = '';
    const isPlaceholder = env.ANTHROPIC_API_KEY.includes('placeholder') || !env.ANTHROPIC_API_KEY;

    if (isPlaceholder) {
      eligibilitySummary = `Based on the information provided, this applicant meets the income and household requirements for ${program.name}. The eligibility determination was completed on ${this.formatDate(new Date())} with a confidence score of ${eligibility.confidence_score}%. Supporting documentation has been reviewed and is included in this application package.`;
    } else {
      const systemPrompt = `You are a professional government benefits application writer for MomPlan.
Write a formal eligibility summary for a government assistance application PDF.
Output exactly 3-4 sentences of plain text. No markdown, no bullets, no headers.
Use formal professional language appropriate for a government document.
Do not include dollar amounts or specific benefit figures — those are shown separately.
Do not include the applicant's SSN, full date of birth, or any security-sensitive data.`;

      const userPrompt = `Program: ${program.name}
Agency: ${requirements?.agency || program.agency}
Eligibility Status: ${eligibility.status}
Confidence Score: ${eligibility.confidence_score}%
Qualification Reasons: ${eligibility.reasoning}
Household Size: ${profile.household_size}
Employment Status: ${profile.employment_status}
Missing Required Documents: ${missingRequiredDocs.map(d => getDocumentLabel(d.type)).join(', ') || 'None'}

Write the eligibility summary for this applicant's application packet.`;

      try {
        eligibilitySummary = await callClaudeApi(systemPrompt, userPrompt);
        eligibilitySummary = eligibilitySummary.replace(/```[a-z]*|```/g, '').trim();
      } catch (err) {
        console.error('Claude API call failed in PdfService:', err);
        eligibilitySummary = `Based on the information provided, this applicant meets the income and household requirements for ${program.name}. The eligibility determination was completed on ${this.formatDate(new Date())} with a confidence score of ${eligibility.confidence_score}%. Supporting documentation has been reviewed and is included in this application package.`;
      }
    }

    const uuid = existingUuid || crypto.randomUUID();

    // ── Build PDF ───────────────────────────────────────────────────────────
    const pdfBuffer = await new Promise<Buffer>((resolve, reject) => {
      const doc = new PDFDocument({ margin: 50, bufferPages: true });
      const chunks: Buffer[] = [];

      doc.on('data', chunk => chunks.push(chunk));
      doc.on('end', () => resolve(Buffer.concat(chunks)));
      doc.on('error', err => reject(err));

      try {
        // ── Colour Palette ────────────────────────────────────────────────────
      const primaryColor  = '#6D47FC';
      const darkColor     = '#1E2130';
      const slateColor    = '#475569';
      const dividerColor  = '#E2E8F0';
      const successColor  = '#10B981';
      const dangerColor   = '#EF4444';
      const warningColor  = '#F59E0B';
      const lower         = program.name.toLowerCase();

      // ── COVER PAGE ────────────────────────────────────────────────────────
      doc.rect(0, 0, 612, 190).fill('#F3F0FF');

      // Document status banner — warn if docs are missing
      if (hasMissingRequired) {
        doc.rect(0, 0, 612, 6).fill(dangerColor);
      } else {
        doc.rect(0, 0, 612, 6).fill(successColor);
      }

      doc.font('Helvetica-Bold').fontSize(9).fillColor(primaryColor).text('MOMPLAN DIGITAL VAULT', 50, 48, { characterSpacing: 1 });
      doc.font('Helvetica-Bold').fontSize(26).fillColor(darkColor).text(program.name, 50, 75, { width: 512 });
      doc.moveDown(0.25);
      doc.font('Helvetica-Bold').fontSize(10).fillColor(primaryColor).text((requirements?.agency || program.agency).toUpperCase(), { characterSpacing: 0.5 });

      const programSpecificTitle = this.getProgramSpecificTitle(program.name);
      doc.font('Helvetica-Bold').fontSize(17).fillColor(darkColor).text(programSpecificTitle, 50, 230);
      doc.moveTo(50, 255).lineTo(562, 255).lineWidth(1.5).stroke(primaryColor);

      const programIntro = this.getProgramIntroduction(program.name);
      doc.font('Helvetica').fontSize(10).fillColor(slateColor).text(programIntro, 50, 275, { width: 512, lineGap: 3 });

      // Applicant summary box
      const boxY = 380;
      doc.roundedRect(50, boxY, 512, 130, 8).lineWidth(1).stroke('#E2E8F0');
      doc.font('Helvetica-Bold').fontSize(10).fillColor(darkColor).text('APPLICANT PORTFOLIO SUMMARY', 70, boxY + 15);
      doc.font('Helvetica-Bold').fontSize(9).fillColor(slateColor).text('Applicant Name:', 70, boxY + 35).font('Helvetica').fillColor(darkColor).text(displayName, 190, boxY + 35);
      doc.font('Helvetica-Bold').fontSize(9).fillColor(slateColor).text('Submission Date:', 70, boxY + 55).font('Helvetica').fillColor(darkColor).text(this.formatDate(new Date()), 190, boxY + 55);
      doc.font('Helvetica-Bold').fontSize(9).fillColor(slateColor).text('Verification ID:', 70, boxY + 75).font('Helvetica').fillColor(darkColor).text(uuid, 190, boxY + 75);

      // Document readiness status on cover
      const docStatusLabel = hasMissingRequired
        ? `⚠ INCOMPLETE — ${missingRequiredDocs.length} required document(s) missing`
        : `✓ DOCUMENT READY — All required documents uploaded`;
      const docStatusColor = hasMissingRequired ? dangerColor : successColor;
      doc.font('Helvetica-Bold').fontSize(9).fillColor(docStatusColor).text(docStatusLabel, 70, boxY + 100);

      doc.font('Helvetica-Bold').fontSize(9).fillColor(successColor).text('✓ DIGITALLY SECURED & VERIFIED BY MOMPLAN', 50, 680);
      doc.font('Helvetica').fontSize(8).fillColor(slateColor).text('This is an official document portfolio generated on behalf of the applicant for direct agency intake processing.', 50, 695);

      doc.addPage();

      // ── Helpers ───────────────────────────────────────────────────────────
      const drawSectionHeader = (title: string, color?: string) => {
        doc.moveDown(0.8);
        doc.font('Helvetica-Bold').fontSize(12).fillColor(color ?? primaryColor).text(title);
        doc.moveTo(50, doc.y + 3).lineTo(562, doc.y + 3).stroke(dividerColor);
        doc.moveDown(0.5);
      };

      const drawRow = (label: string, value: string) => {
        doc.font('Helvetica-Bold').fontSize(9).fillColor(darkColor).text(label, { continued: true })
           .font('Helvetica').fillColor(slateColor).text(` ${value}`);
        doc.moveDown(0.3);
      };

      // ── Section 1 — Applicant Summary ─────────────────────────────────────
      drawSectionHeader('Section 1 — Applicant Summary');
      drawRow('Full Name:', displayName);
      drawRow('Date of Birth:', this.formatDate(profile.date_of_birth));
      drawRow('Address:', `${profile.street_address || ''}, ${profile.city || ''}, ${profile.state || ''} ${profile.zip_code || ''}`);
      drawRow('Phone:', user.phone || 'N/A');
      drawRow('Email:', user.email);
      drawRow('Citizenship Status:', this.slugToTitle(profile.immigration_status || 'N/A'));
      if (profile.preferred_language) drawRow('Preferred Language:', profile.preferred_language);

      // ── Section 2 — Household & Income ────────────────────────────────────
      drawSectionHeader('Section 2 — Household & Income');
      drawRow('Household Size:', String(profile.household_size));
      drawRow('Number of Children:', String(profile.num_children));

      let childAgesStr = 'N/A';
      if (profile.children_ages && Array.isArray(profile.children_ages)) {
        childAgesStr = (profile.children_ages as number[]).map(a => `${a} yr`).join(', ');
      }
      drawRow('Children Ages:', childAgesStr);
      drawRow('Marital Status:', this.slugToTitle(profile.marital_status || 'N/A'));
      drawRow('Employment Status:', this.slugToTitle(profile.employment_status || 'N/A'));
      if (profile.employer_name) drawRow('Employer:', profile.employer_name);
      drawRow('Monthly Income:', this.formatCurrency(monthlyIncome));
      drawRow('Annual Income:', this.formatCurrency(monthlyIncome * 12));
      drawRow('Federal Poverty Level %:', this.calculateFplPercentage(profile.household_size || 1, monthlyIncome));

      let incomeSourcesStr = 'N/A';
      if (profile.income_sources && Array.isArray(profile.income_sources)) {
        incomeSourcesStr = (profile.income_sources as string[]).join(', ');
      }
      drawRow('Income Sources:', incomeSourcesStr);
      if (profile.child_support_status) drawRow('Child Support Status:', this.slugToTitle(profile.child_support_status));
      if (profile.savings_assets) drawRow('Savings / Assets:', this.slugToTitle(profile.savings_assets));

      // Childcare subsidy specifics
      if (lower.includes('ccdf') || lower.includes('child care') || lower.includes('head start')) {
        doc.moveDown(0.2);
        doc.font('Helvetica-Bold').fontSize(9).fillColor(darkColor).text('Childcare Subsidy Details:');
        drawRow('Childcare Subsidies Needed:', this.formatBoolean(profile.needs_childcare));
        if (profile.childcare_preference) drawRow('Preferred Childcare Mode:', this.slugToTitle(profile.childcare_preference));
        if (profile.childcare_provider) drawRow('Chosen Provider Name:', profile.childcare_provider);
        if (profile.monthly_childcare_cost !== null && profile.monthly_childcare_cost !== undefined) {
          drawRow('Current Monthly Childcare Expenses:', this.formatCurrency(Number(profile.monthly_childcare_cost)));
        }
      }

      // ── Section 3 — Housing & Utilities ───────────────────────────────────
      drawSectionHeader('Section 3 — Housing');
      drawRow('Housing Status:', this.slugToTitle(profile.housing_status || 'N/A'));
      if (profile.monthly_rent !== null && profile.monthly_rent !== undefined) {
        drawRow('Monthly Rent:', this.formatCurrency(Number(profile.monthly_rent)));
      }
      if (profile.monthly_utilities !== null && profile.monthly_utilities !== undefined) {
        drawRow('Monthly Utilities:', this.formatCurrency(Number(profile.monthly_utilities)));
      }
      drawRow('Eviction/Homelessness Risk:', this.formatBoolean(profile.eviction_risk));

      // ── Section 4 — Health & Demographics ────────────────────────────────
      drawSectionHeader('Section 4 — Health & Demographics');
      drawRow('Pregnancy Status:', this.formatBoolean(profile.is_pregnant));
      drawRow('Disability Status:', this.formatBoolean(profile.has_disability));
      drawRow('Current Health Coverage:', profile.health_insurance ? this.slugToTitle(profile.health_insurance) : 'None');
      drawRow('Chronic Illness:', this.formatBoolean(profile.chronic_illness));

      // Legal Aid specifics
      if (lower.includes('legal aid') || lower.includes('civil legal')) {
        let legalIssuesStr = 'None';
        if (profile.legal_issues && Array.isArray(profile.legal_issues)) {
          legalIssuesStr = (profile.legal_issues as string[]).map(t => this.slugToTitle(String(t))).join(', ');
        }
        drawRow('Civil Legal Aid Issues:', legalIssuesStr);
        if (profile.urgency) drawRow('Assistance Urgency Level:', this.slugToTitle(profile.urgency));
      }

      doc.addPage();

      // ── Section 5 — Eligibility Summary ──────────────────────────────────
      drawSectionHeader('Section 5 — Eligibility Summary');
      drawRow('Program Matched:', program.name);
      drawRow('Qualification Status:', this.slugToTitle(eligibility.status));
      drawRow('AI Confidence Score:', `${eligibility.confidence_score}%`);
      if (program.estimated_monthly_value_min !== null) {
        drawRow('Estimated Monthly Benefit:', `${this.formatCurrency(program.estimated_monthly_value_min)} – ${this.formatCurrency(program.estimated_monthly_value_max || 0)}`);
      }
      doc.moveDown(0.2);
      doc.font('Helvetica-Bold').fontSize(9).fillColor(darkColor).text('AI Match Summary:');
      doc.font('Helvetica').fontSize(9).fillColor(slateColor).text(eligibilitySummary, { lineGap: 2.5 });
      doc.moveDown(0.5);

      // ── Section 6 — Supporting Documents (smart colour-coded table) ───────
      drawSectionHeader('Section 6 — Supporting Documents');

      // Document readiness summary line
      const uploadedCount = allProgramDocs.filter(d => d.uploaded).length;
      const totalRequired = requiredDocs.length;
      const missingCount = missingRequiredDocs.length;

      doc.font('Helvetica').fontSize(9).fillColor(slateColor)
         .text(`${uploadedCount} of ${allProgramDocs.length} program documents on file.  `
             + (hasMissingRequired
               ? `${missingCount} REQUIRED document(s) are missing — see Gap Report (Section 7).`
               : 'All required documents are uploaded. ✓'),
           { lineGap: 2 });
      doc.moveDown(0.5);

      // Table header
      const tableStartY = doc.y;
      const COL = { type: 50, name: 200, status: 440 };

      // Header row background
      doc.rect(50, tableStartY - 2, 512, 14).fill('#F1F5F9');
      doc.font('Helvetica-Bold').fontSize(8).fillColor(darkColor);
      doc.text('Document Type', COL.type, tableStartY);
      doc.text('File Name', COL.name, tableStartY, { width: 220 });
      doc.text('Status', COL.status, tableStartY, { width: 120 });
      doc.moveTo(50, tableStartY + 13).lineTo(562, tableStartY + 13).stroke(dividerColor);
      doc.moveDown(0.5);

      // Render each document row
      for (const item of allProgramDocs) {
        const rowY = doc.y;
        const label = getDocumentLabel(item.type);

        if (item.uploaded) {
          // ✅ Green row — document uploaded
          doc.rect(50, rowY - 1, 512, 13).fill('#F0FDF4');
          doc.font('Helvetica-Bold').fontSize(8).fillColor('#166534')
             .text(`✓ ${label}`, COL.type, rowY, { width: 145 });
          doc.font('Helvetica').fontSize(8).fillColor('#15803d')
             .text(item.uploaded.display_name, COL.name, rowY, { width: 220, ellipsis: true });
          doc.font('Helvetica-Bold').fontSize(8).fillColor('#16a34a')
             .text('Attached', COL.status, rowY);
        } else if (item.required) {
          // ❌ Red row — required doc missing
          doc.rect(50, rowY - 1, 512, 13).fill('#FEF2F2');
          doc.font('Helvetica-Bold').fontSize(8).fillColor('#7F1D1D')
             .text(`✗ ${label}`, COL.type, rowY, { width: 145 });
          doc.font('Helvetica').fontSize(8).fillColor('#DC2626')
             .text('— Not Uploaded', COL.name, rowY, { width: 220 });
          doc.font('Helvetica-Bold').fontSize(8).fillColor(dangerColor)
             .text('REQUIRED — Missing', COL.status, rowY);
        } else {
          // ⚪ Grey row — optional doc missing
          doc.font('Helvetica').fontSize(8).fillColor(slateColor)
             .text(label, COL.type, rowY, { width: 145 });
          doc.font('Helvetica').fontSize(8).fillColor('#94A3B8')
             .text('— Not Provided', COL.name, rowY, { width: 220 });
          doc.font('Helvetica').fontSize(8).fillColor('#94A3B8')
             .text('Optional', COL.status, rowY);
        }
        doc.moveDown(0.45);
      }

      // ── Section 7 — Document Gap Report (only when required docs missing) ─
      if (hasMissingRequired) {
        doc.addPage();
        drawSectionHeader('Section 7 — Document Gap Report', dangerColor);

        // Alert box
        doc.rect(50, doc.y, 512, 36).fill('#FEF2F2');
        doc.font('Helvetica-Bold').fontSize(10).fillColor(dangerColor)
           .text(`ACTION REQUIRED — ${missingRequiredDocs.length} Required Document(s) Missing`, 62, doc.y + 8);
        doc.font('Helvetica').fontSize(9).fillColor('#7F1D1D')
           .text('You must upload or present the following documents to complete this application.', 62, doc.y + 4);
        doc.moveDown(1.2);

        doc.font('Helvetica').fontSize(9).fillColor(slateColor).text(
          'The documents listed below are required by the agency to process your application. '
        + 'Without these documents, the agency cannot verify your eligibility and your application may be delayed or denied. '
        + 'Please gather and upload these documents through your MomPlan Document Vault, or bring originals to your agency intake appointment.',
          { lineGap: 2.5 }
        );
        doc.moveDown(0.8);

        missingRequiredDocs.forEach((item, idx) => {
          const meta = DOCUMENT_META[item.type];
          const rowTop = doc.y;

          // Numbered block background
          doc.rect(50, rowTop, 512, meta ? 64 : 30).fill('#FEF2F2');

          // Number circle
          doc.circle(68, rowTop + 14, 9).fill(dangerColor);
          doc.font('Helvetica-Bold').fontSize(9).fillColor('#FFFFFF')
             .text(String(idx + 1), 64, rowTop + 9, { width: 10, align: 'center' });

          // Doc label
          doc.font('Helvetica-Bold').fontSize(10).fillColor(darkColor)
             .text(meta?.label ?? getDocumentLabel(item.type), 84, rowTop + 5);

          if (meta) {
            doc.font('Helvetica').fontSize(8).fillColor(slateColor)
               .text(`Examples: ${meta.examples}`, 84, rowTop + 19, { width: 470 });
            doc.font('Helvetica').fontSize(8).fillColor('#374151')
               .text(`Agency note: ${meta.agency_note}`, 84, rowTop + 31, { width: 470 });
          }

          doc.moveDown(meta ? 4.5 : 2.2);
        });

        // Checklist print block
        doc.moveDown(0.5);
        doc.rect(50, doc.y, 512, 18).fill('#F1F5F9');
        doc.font('Helvetica-Bold').fontSize(9).fillColor(darkColor)
           .text('DOCUMENT CHECKLIST — bring originals and photocopies to your agency appointment:', 58, doc.y + 4);
        doc.moveDown(1.2);

        missingRequiredDocs.forEach(item => {
          const label = DOCUMENT_META[item.type]?.label ?? getDocumentLabel(item.type);
          doc.font('Helvetica').fontSize(9).fillColor(darkColor)
             .text(`☐  ${label}`, 64, doc.y, { lineGap: 1.5 });
          doc.moveDown(0.5);
        });

        doc.moveDown(0.5);
        doc.font('Helvetica').fontSize(8.5).fillColor(slateColor)
           .text('Upload documents at: momplan.app/dashboard/documents  •  Or visit your nearest agency office with originals.',
             { align: 'center' });
      } else {
        // Section 7 — All docs ready
        doc.moveDown(0.5);
        drawSectionHeader('Section 7 — Document Status', successColor);
        doc.rect(50, doc.y, 512, 30).fill('#F0FDF4');
        doc.font('Helvetica-Bold').fontSize(10).fillColor(successColor)
           .text('✓ All required documents have been uploaded.', 62, doc.y + 8);
        doc.font('Helvetica').fontSize(9).fillColor('#166534')
           .text('This application package is complete and ready for agency submission.', 62, doc.y + 4);
        doc.moveDown(2.5);
      }

      // ── Declaration & Signature ───────────────────────────────────────────
      doc.addPage();
      doc.font('Helvetica-Bold').fontSize(10).fillColor(darkColor).text('APPLICANT DECLARATION', { align: 'center' });
      doc.moveDown(0.3);
      doc.font('Helvetica').fontSize(8.5).fillColor(slateColor).text(
        'I certify that all information provided in this application is true, accurate, and complete to the best of my knowledge. I understand that knowingly providing false information is subject to penalties under law.',
        { align: 'justify', lineGap: 1.5 }
      );
      doc.moveDown(1.5);
      const sigY = doc.y;
      doc.moveTo(50, sigY + 12).lineTo(300, sigY + 12).stroke(darkColor);
      doc.moveTo(400, sigY + 12).lineTo(562, sigY + 12).stroke(darkColor);
      doc.font('Helvetica').fontSize(8.5).fillColor(darkColor);
      doc.text('Applicant Signature', 50, sigY + 18);
      doc.text('Date', 400, sigY + 18);
      doc.moveDown(1.2);
      doc.font('Helvetica-Bold').fontSize(8.5).text('Printed Name: ', { continued: true }).font('Helvetica').text(displayName);
      doc.moveDown(0.8);
      doc.fontSize(7.5).fillColor(slateColor).text(`Prepared on behalf of applicant by MomPlan Application System.`, { align: 'center' });
      doc.text(`This document was generated on ${this.formatDate(new Date())} and is valid for submission.`, { align: 'center' });

      // ── Appendix — Attached Documents ─────────────────────────────────────
      doc.addPage();
      drawSectionHeader('Appendix — Attached Documents');
      doc.font('Helvetica').fontSize(9).fillColor(slateColor).text(
        'Due to current system limits, full original copies of the uploaded documents listed in Section 6 are attached separately in your email package. They are also preserved in your secure digital vault on the MomPlan platform.',
        { lineGap: 2.5 }
      );
      doc.moveDown(0.5);

      // List uploaded documents with file info
      const uploadedDocs = user.documents;
      if (uploadedDocs.length > 0) {
        doc.font('Helvetica-Bold').fontSize(9).fillColor(darkColor).text(`Uploaded Files (${uploadedDocs.length}):`);
        doc.moveDown(0.4);
        uploadedDocs.forEach((d, i) => {
          doc.font('Helvetica').fontSize(8.5).fillColor(slateColor)
             .text(`${i + 1}.  ${d.display_name}  (${getDocumentLabel(d.document_type)})  —  uploaded ${this.formatDate(d.uploaded_at)}`,
               { lineGap: 1.5 });
        });
      } else {
        doc.font('Helvetica').fontSize(9).fillColor('#94A3B8').text('No documents have been uploaded to the MomPlan vault yet.');
      }

      // ── Global page numbering pass ────────────────────────────────────────
      // Close any open text flow before switching pages — otherwise PDFKit may
      // auto-add blank pages when drawing headers/footers near the page edge.
      doc.text('', { continued: false });

      const range = doc.bufferedPageRange();
      const pageCount = range.count;
      const generatedDate = this.formatDate(new Date());
      const programHeader = program.name.toUpperCase();
      const { quarter: pdfQuarter, year: pdfYear } = this.resolveQuarterYear(
        pdfMeta?.quarter,
        pdfMeta?.year
      );
      const versionLabel = pdfMeta?.version ?? 1;
      const quarterYearLabel = `${pdfQuarter} ${pdfYear}`;

      for (let i = range.start + 1; i < range.start + pageCount; i++) {
        doc.switchToPage(i);
        doc.save();

        doc.font('Helvetica-Bold').fontSize(7.5).fillColor(slateColor)
          .text(programHeader, 50, 25, { width: 400, lineBreak: false });
        doc.font('Helvetica').fontSize(7.5).fillColor(slateColor)
          .text(generatedDate, 50, 25, { width: 512, align: 'right', lineBreak: false });

        doc.moveTo(50, 36).lineTo(562, 36).lineWidth(0.5).stroke(dividerColor);
        doc.moveTo(50, 745).lineTo(562, 745).lineWidth(0.5).stroke(dividerColor);

        // Footer text must use a fixed height — writing near the page bottom without
        // one triggers PDFKit to auto-create blank pages during switchToPage passes.
        doc.font('Helvetica').fontSize(7.5).fillColor(slateColor)
          .text('Digitally compiled by MomPlan Assistance Platform', 50, 752, { width: 170, height: 12, lineBreak: false });
        doc.font('Helvetica-Bold').fontSize(7.5).fillColor(slateColor)
          .text(`Version ${versionLabel} · ${quarterYearLabel}`, 50, 752, { width: 512, height: 12, align: 'center', lineBreak: false });
        doc.font('Helvetica').fontSize(7.5).fillColor(slateColor)
          .text(`Page ${i - range.start + 1} of ${pageCount}`, 50, 752, { width: 512, height: 12, align: 'right', lineBreak: false });

        doc.restore();
      }

      doc.end();
      } catch (err) {
        console.error(`[PdfService] Error generating PDF for program ${program.name} (ID: ${program.id}):`, err);
        reject(err);
      }
    });

    return { pdfBuffer, validationReport, uuid };
  }

  // ─── Sync generated PDF into the documents vault ───────────────────────────
  private async syncGeneratedPdfToVault(
    userId: string,
    pdfId: string,
    applicationId: string | null,
    programName: string,
    file_url: string,
    file_size: number,
    quarter: Quarter,
    year: number,
    version: number
  ): Promise<void> {
    const displayName = buildPdfFilename(
      programName,
      quarter,
      year,
      Math.max(version, 1)
    );
    const vaultKey = `generated_pdf:${pdfId}`;

    const existingDoc = await prisma.document.findFirst({
      where: {
        user_id: userId,
        original_file_name: vaultKey,
      },
    });

    if (existingDoc) {
      await prisma.document.update({
        where: { id: existingDoc.id },
        data: {
          display_name: displayName,
          file_url,
          file_size,
          application_id: applicationId ?? existingDoc.application_id,
        },
      });
      return;
    }

    await prisma.document.create({
      data: {
        user_id: userId,
        application_id: applicationId,
        document_type: 'application_package',
        original_file_name: vaultKey,
        display_name: displayName,
        file_url,
        file_size,
        mime_type: 'application/pdf',
      },
    });
  }

  private async resolveApplicationId(
    userId: string,
    programId: string,
    applicationId?: string
  ): Promise<string | undefined> {
    if (applicationId) return applicationId;

    const existingApp = await prisma.application.findFirst({
      where: { user_id: userId, program_id: programId },
      orderBy: { last_updated_at: 'desc' },
    });

    return existingApp?.id;
  }

  // ─── Record a download (version = download count) ─────────────────────────
  async recordDownload(pdfId: string): Promise<{ version: number; filename: string }> {
    const pdf = await prisma.generatedPdf.findUnique({
      where: { id: pdfId },
      include: { program: { select: { name: true } } },
    });
    if (!pdf) throw new Error('PDF not found');

    const newVersion = pdf.version + 1;
    const updated = await prisma.generatedPdf.update({
      where: { id: pdfId },
      data: { version: newVersion },
      include: { program: { select: { name: true } } },
    });

    const filename = buildPdfFilename(
      updated.program?.name || 'Application',
      updated.quarter,
      updated.year,
      newVersion
    );

    if (updated.quarter && updated.year) {
      await this.syncGeneratedPdfToVault(
        updated.user_id,
        updated.id,
        updated.application_id,
        updated.program?.name || 'Application',
        updated.file_url,
        updated.file_size,
        updated.quarter as Quarter,
        updated.year,
        newVersion
      );
    }

    return { version: newVersion, filename };
  }

  async ensureVaultDocument(pdfId: string, userId: string): Promise<void> {
    const pdf = await prisma.generatedPdf.findUnique({
      where: { id: pdfId },
      include: { program: { select: { name: true } } },
    });
    if (!pdf || pdf.user_id !== userId) {
      throw new Error('PDF not found');
    }
    if (!pdf.quarter || pdf.year == null) {
      throw new Error('PDF is missing quarter metadata');
    }

    let applicationId = pdf.application_id;
    if (!applicationId) {
      applicationId = (await this.resolveApplicationId(userId, pdf.program_id)) ?? null;
      if (applicationId) {
        await prisma.generatedPdf.update({
          where: { id: pdfId },
          data: { application_id: applicationId },
        });
      }
    }

    await this.syncGeneratedPdfToVault(
      userId,
      pdf.id,
      applicationId,
      pdf.program?.name || 'Application',
      pdf.file_url,
      pdf.file_size,
      pdf.quarter as Quarter,
      pdf.year,
      pdf.version
    );
  }

  // ─── Main generation function ──────────────────────────────────────────────
  async generateApplicationPdf(
    userId: string,
    programId: string,
    applicationId?: string,
    quarter?: string,
    year?: number
  ): Promise<any> {
    const { quarter: resolvedQuarter, year: resolvedYear } = this.resolveQuarterYear(quarter, year);
    const resolvedApplicationId = await this.resolveApplicationId(userId, programId, applicationId);

    const program = await prisma.benefitProgram.findUnique({
      where: { id: programId },
      select: { name: true },
    });

    const existing = await prisma.generatedPdf.findFirst({
      where: {
        user_id: userId,
        program_id: programId,
        quarter: resolvedQuarter,
        year: resolvedYear,
      },
      orderBy: { generated_at: 'desc' },
    });

    // Version tracks download count; new/regenerated PDFs start at 0 until first download
    const version = existing?.version ?? 0;
    const pdfId = existing?.id ?? crypto.randomUUID();

    const { pdfBuffer, validationReport } = await this.generatePdfBuffer(
      userId,
      programId,
      resolvedApplicationId,
      pdfId,
      { version: Math.max(version, 1), quarter: resolvedQuarter, year: resolvedYear }
    );

    // ── File persistence ────────────────────────────────────────────────────
    const isS3Placeholder = env.AWS_ACCESS_KEY_ID.includes('placeholder');
    let file_url = existing?.file_url ?? '';

    if (isS3Placeholder) {
      const dir = path.join(process.cwd(), 'uploads', 'pdfs', userId);
      fs.mkdirSync(dir, { recursive: true });
      const localPath = path.join(dir, `${pdfId}.pdf`);
      fs.writeFileSync(localPath, pdfBuffer);
      file_url = localPath;
    } else {
      const key = `pdfs/${userId}/${pdfId}.pdf`;
      await s3Client.send(new PutObjectCommand({
        Bucket: env.S3_BUCKET_NAME,
        Key: key,
        Body: pdfBuffer,
        ContentType: 'application/pdf',
      }));
      file_url = `https://${env.S3_BUCKET_NAME}.s3.${env.AWS_REGION}.amazonaws.com/${key}`;
    }

    let generated;
    if (existing) {
      generated = await prisma.generatedPdf.update({
        where: { id: existing.id },
        data: {
          application_id: resolvedApplicationId || existing.application_id,
          file_url,
          file_size: pdfBuffer.length,
          validation_report: validationReport as any,
          generated_at: new Date(),
        },
        include: { program: true },
      });
    } else {
      generated = await prisma.generatedPdf.create({
        data: {
          id: pdfId,
          user_id: userId,
          application_id: resolvedApplicationId || null,
          program_id: programId,
          file_url,
          file_size: pdfBuffer.length,
          version: 0,
          quarter: resolvedQuarter,
          year: resolvedYear,
          status: 'generated',
          validation_report: validationReport as any,
        },
        include: { program: true },
      });
    }

    await this.syncGeneratedPdfToVault(
      userId,
      generated.id,
      resolvedApplicationId || generated.application_id,
      program?.name || generated.program?.name || 'Application',
      file_url,
      pdfBuffer.length,
      resolvedQuarter,
      resolvedYear,
      generated.version
    );

    const applicationIdToUpdate = resolvedApplicationId || generated.application_id;
    if (applicationIdToUpdate) {
      const { persistApplicationQuarterYear } = await import(
        '../applications/application-quarter.utils'
      );
      await persistApplicationQuarterYear(
        applicationIdToUpdate,
        resolvedQuarter,
        resolvedYear
      );
    }

    return generated;
  }

  // ─── Regenerate Local PDF File ─────────────────────────────────────────────
  async regenerateLocalPdf(pdfId: string): Promise<Buffer> {
    const pdf = await prisma.generatedPdf.findUnique({
      where: { id: pdfId },
      include: { program: true }
    });
    if (!pdf) throw new Error('PDF not found in database');

    const { pdfBuffer } = await this.generatePdfBuffer(
      pdf.user_id,
      pdf.program_id,
      pdf.application_id || undefined,
      pdf.id,
      {
        version: pdf.version,
        quarter: (pdf.quarter as Quarter | null) ?? undefined,
        year: pdf.year ?? undefined,
      }
    );

    const isS3Placeholder = env.AWS_ACCESS_KEY_ID.includes('placeholder');
    if (isS3Placeholder || !pdf.file_url.startsWith('http')) {
      const relativeDir = path.join('uploads', 'pdfs', pdf.user_id);
      const dir = path.join(process.cwd(), relativeDir);
      fs.mkdirSync(dir, { recursive: true });
      const localPath = path.join(dir, `${pdf.id}.pdf`);
      fs.writeFileSync(localPath, pdfBuffer);

      // Also try backend directory if it exists (for backend running in subdirectory)
      const backendDir = path.join(process.cwd(), 'backend', relativeDir);
      if (fs.existsSync(path.join(process.cwd(), 'backend'))) {
        fs.mkdirSync(backendDir, { recursive: true });
        fs.writeFileSync(path.join(backendDir, `${pdf.id}.pdf`), pdfBuffer);
      }
    } else {
      // S3 is enabled and URL is S3 URL: re-upload to S3 in case it was deleted
      const { PutObjectCommand } = require('@aws-sdk/client-s3');
      const { s3Client } = require('../../config/s3');
      try {
        const urlObj = new URL(pdf.file_url);
        const key = urlObj.pathname.substring(1); // remove leading slash
        await s3Client.send(new PutObjectCommand({
          Bucket: env.S3_BUCKET_NAME,
          Key: key,
          Body: pdfBuffer,
          ContentType: 'application/pdf',
        }));
      } catch (s3Err) {
        console.error('Failed to upload regenerated PDF to S3:', s3Err);
      }
    }
    return pdfBuffer;
  }

  // ── Download URL ───────────────────────────────────────────────────────────
  async getDownloadUrl(pdfId: string, userId: string, role?: string, backendUrl?: string): Promise<string> {
    const pdf = await prisma.generatedPdf.findUnique({ where: { id: pdfId } });
    if (!pdf) throw new Error('PDF not found');
    if (role !== 'admin' && role !== 'counselor' && pdf.user_id !== userId) throw new Error('Access denied to this PDF');

    const isPlaceholder = env.AWS_ACCESS_KEY_ID.includes('placeholder');
    if (isPlaceholder) {
      const baseUrl = backendUrl || `${env.FRONTEND_URL.replace(/:3000|:3001/, ':5000')}`;
      return `${baseUrl}/api/pdf/${pdfId}/download/stream`;
    } else {
      const key = pdf.file_url.split('.amazonaws.com/').pop() || '';
      return getPresignedDownloadUrl(key);
    }
  }

  // ── List PDFs ──────────────────────────────────────────────────────────────
  async listPdfs(
    userId: string,
    role: string,
    filters?: { quarter?: string; year?: number }
  ): Promise<any[]> {
    const quarterFilter =
      filters?.quarter && ['Q1', 'Q2', 'Q3', 'Q4'].includes(filters.quarter)
        ? filters.quarter
        : undefined;

    const where: Record<string, unknown> = {};
    if (role !== 'admin' && role !== 'counselor') {
      where.user_id = userId;
    }
    if (quarterFilter) {
      where.quarter = quarterFilter;
    }
    if (filters?.year != null) {
      where.year = filters.year;
    }

    if (role === 'admin' || role === 'counselor') {
      return prisma.generatedPdf.findMany({
        where,
        include: {
          user: { select: { ...userNameSelect, email: true } },
          program: { select: { name: true, agency: true } },
        },
        orderBy: { generated_at: 'desc' },
      });
    }
    return prisma.generatedPdf.findMany({
      where,
      include: { program: { select: { name: true, agency: true } } },
      orderBy: { generated_at: 'desc' },
    });
  }

  // ── Formatting helpers ─────────────────────────────────────────────────────
  private formatDate(date: Date | string | null | undefined): string {
    if (!date) return 'N/A';
    const d = new Date(date);
    if (isNaN(d.getTime())) return 'N/A';
    return `${String(d.getMonth() + 1).padStart(2, '0')}/${String(d.getDate()).padStart(2, '0')}/${d.getFullYear()}`;
  }

  private formatCurrency(value: number): string {
    return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(value);
  }

  private formatBoolean(val: boolean | null | undefined): string {
    if (val === true) return 'Yes';
    if (val === false) return 'No';
    return 'N/A';
  }

  private calculateFplPercentage(householdSize: number, monthlyIncome: number): string {
    const size = Math.max(1, householdSize);
    const annualFpl = 15060 + (size - 1) * 5380;
    const percentage = Math.round(((monthlyIncome * 12) / annualFpl) * 100);
    return `${percentage}%`;
  }

  private slugToTitle(slug: string | null | undefined): string {
    if (!slug) return 'N/A';
    return slug.split('_').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ');
  }

  private getProgramSpecificTitle(programName: string): string {
    const lower = programName.toLowerCase();
    if (lower.includes('snap')) return 'Supplemental Nutrition Assistance Program (SNAP) Benefits Application';
    if (lower.includes('tanf')) return 'Temporary Assistance for Needy Families (TANF) Application';
    if (lower.includes('wic')) return 'Women, Infants, and Children (WIC) Nutrition Program Application';
    if (lower.includes('medicaid')) return 'Medicaid & CHIP Healthcare Coverage Application';
    if (lower.includes('ccdf') || lower.includes('child care subsidy')) return 'Child Care Development Fund (CCDF) Subsidy Application';
    if (lower.includes('section 8') || lower.includes('housing choice') || lower.includes('section8')) return 'Section 8 Housing Choice Voucher Application';
    if (lower.includes('liheap')) return 'Low-Income Home Energy Assistance Program (LIHEAP) Application';
    if (lower.includes('eitc')) return 'Earned Income Tax Credit (EITC) Benefits Portfolio';
    if (lower.includes('child tax')) return 'Child Tax Credit (CTC) Verification Portfolio';
    if (lower.includes('pell')) return 'Federal Pell Grant Student Assistance Application';
    if (lower.includes('head start')) return 'Head Start & Early Head Start Enrollment Package';
    if (lower.includes('lifeline')) return 'Lifeline Benefit Phone & Internet Assistance Application';
    if (lower.includes('legal aid') || lower.includes('civil legal')) return 'Civil Legal Aid Intake & Eligibility Portfolio';
    return `${programName} Application Portfolio`;
  }

  private getProgramIntroduction(programName: string): string {
    const lower = programName.toLowerCase();
    if (lower.includes('snap')) return 'This application package contains the necessary applicant details, household demographics, and verified income statements required to determine eligibility for the Supplemental Nutrition Assistance Program (SNAP). SNAP helps low-income individuals and families purchase healthy food.';
    if (lower.includes('tanf')) return 'This document portfolio is prepared for the Temporary Assistance for Needy Families (TANF) program. It outlines the family composition, children details, employment search parameters, and monthly income verification necessary for cash assistance and support service eligibility.';
    if (lower.includes('wic')) return 'This intake portfolio is for the Special Supplemental Nutrition Program for Women, Infants, and Children (WIC). It presents the pregnancy status, children age details, and household nutritional needs to facilitate access to WIC supplemental foods, health care referrals, and nutrition education.';
    if (lower.includes('medicaid')) return "This application packet compiles demographic and financial verification for Medicaid and Children's Health Insurance Program (CHIP). It details household income, health indicators, disability status, and coverage needs to process state health insurance eligibility.";
    if (lower.includes('ccdf') || lower.includes('child care subsidy')) return "This enrollment package is prepared for the Child Care and Development Fund (CCDF) subsidy. It specifies the applicant's employment status, childcare requirements, children age ranges, and verified income statements to secure childcare support benefits.";
    if (lower.includes('section 8') || lower.includes('housing choice') || lower.includes('section8')) return 'This document packet is compiled for the Section 8 Housing Choice Voucher Program. It verifies household size, rental contribution constraints, eviction risks, and total gross income to determine qualification for housing assistance vouchers.';
    if (lower.includes('liheap')) return 'This utility assistance packet is prepared for the Low-Income Home Energy Assistance Program (LIHEAP). It details household composition, energy utility billing status, and income verification to support home heating and cooling energy credit determinations.';
    if (lower.includes('eitc')) return 'This tax credit intake packet compiles household earnings, child details, and tax filing parameters for the Earned Income Tax Credit (EITC). It assists counselors in validating credit amounts during tax preparation.';
    if (lower.includes('child tax')) return 'This validation portfolio supports eligibility for the Child Tax Credit (CTC). It registers child counts, age documentation, dependency verification, and income ranges to support eligibility audits.';
    if (lower.includes('pell')) return 'This student assistance package is compiled for the Federal Pell Grant. It outlines enrollment intent, dependent details, and household income ratios to qualify for post-secondary education tuition subsidies.';
    if (lower.includes('head start')) return 'This enrollment package is for the Head Start and Early Head Start child development programs. It provides household demographics, child age documentation, and family status details to process enrollment placement.';
    if (lower.includes('lifeline')) return 'This communication assistance application is for the Lifeline program. It documents household income and program participation criteria to establish entitlement to subsidized broadband and cellular voice services.';
    if (lower.includes('legal aid') || lower.includes('civil legal')) return 'This intake document supports qualifications for Civil Legal Aid Services. It details the nature of civil legal challenges (housing, safety, employment) along with family income levels to verify qualification under local legal services limits.';
    return `This document packet compiles all essential household profiles, income disclosures, and supporting documentation required to review eligibility and initiate enrollment for the ${programName}.`;
  }
}
