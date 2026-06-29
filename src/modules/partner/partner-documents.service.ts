import { prisma } from '../../config/prisma';
import { caseListWhere, OrgAccessContext, secureSubmittedCaseWhere } from './partner-access';

const DOC_TYPE_LABELS: Record<string, string> = {
  application_package: 'Application Package',
  government_id: 'Government ID',
  proof_of_income: 'Proof of Income',
  lease_agreement: 'Lease Agreement',
  utility_bill: 'Utility Bill',
  bank_statement: 'Bank Statement',
  medical_record: 'Medical Record',
  birth_certificate: 'Birth Certificate',
  childcare_record: 'Childcare Record',
  social_security_card: 'Social Security Card',
  immigration_document: 'Immigration Document',
  school_enrollment: 'School Enrollment',
  tax_return: 'Tax Return',
  proof_of_pregnancy: 'Proof of Pregnancy',
  custody_order: 'Custody Order',
  other: 'Other',
};

function mapDocType(type: string): string {
  return DOC_TYPE_LABELS[type] ?? type.replace(/_/g, ' ');
}

function mapPartnerDocType(docType: string): string {
  if (docType === 'application_package') return 'report';
  if (docType.includes('consent')) return 'consent';
  if (docType.includes('referral')) return 'referral_letter';
  if (docType.includes('intake')) return 'intake_form';
  if (docType.includes('assessment')) return 'assessment';
  return 'other';
}

export class PartnerDocumentsService {
  async listSubmissionDocuments(
    ctx: OrgAccessContext,
    filters?: { type?: string; limit?: number }
  ) {
    const caseDocuments = await prisma.caseDocument.findMany({
      where: {
        case: {
          ...caseListWhere(ctx),
          ...secureSubmittedCaseWhere(),
        },
      },
      include: {
        case: {
          include: {
            mother: {
              include: {
                user: { include: { family_profile: true } },
              },
            },
            program: true,
          },
        },
      },
      orderBy: { uploaded_at: 'desc' },
      take: filters?.limit ?? 50,
    });

    const rows = caseDocuments.map((doc) => {
      const fp = doc.case.mother.user?.family_profile;
      const motherName =
        [fp?.first_name, fp?.last_name].filter(Boolean).join(' ') || 'Unknown Mother';
      const mappedType = mapPartnerDocType(doc.doc_type);

      return {
        id: doc.id,
        name: `${mapDocType(doc.doc_type)} — ${motherName}`,
        type: mappedType,
        file_url: doc.file_url,
        file_size: null as number | null,
        uploaded_at: doc.uploaded_at.toISOString(),
        mother_name: motherName,
        program: doc.case.program.name,
        case_id: doc.case_id,
      };
    });

    if (filters?.type && filters.type !== 'all') {
      return rows.filter((r) => r.type === filters.type);
    }

    return rows;
  }
}
