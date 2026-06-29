export interface ProgramRequirements {
  program_key: string;          // matches BenefitProgram.name keywords for fuzzy matching
  agency: string;
  required_fields: string[];    // keys from FamilyProfile / User / EligibilityResult
  optional_fields: string[];
  required_documents: string[]; // values from Document.document_type
  optional_documents: string[];
}

// Human-readable metadata for every document_type key used across programs.
// Used by the PDF gap report and the frontend readiness modal.
export interface DocumentMeta {
  label: string;           // Display name, e.g. "Government-Issued Photo ID"
  examples: string;        // Comma-separated examples
  agency_note: string;     // What to bring / look up
  urgent: boolean;         // True = blocking without this doc
}

export const DOCUMENT_META: Record<string, DocumentMeta> = {
  government_id: {
    label: 'Government-Issued Photo ID',
    examples: "Driver's license, State ID, Passport, Military ID",
    agency_note: 'Must be current and not expired. All adult household members may need to provide ID.',
    urgent: true,
  },
  proof_of_income: {
    label: 'Proof of Income',
    examples: 'Last 2 pay stubs, most recent W-2, Social Security award letter, unemployment benefit letter',
    agency_note: 'Must cover the last 30 days. Self-employed applicants may use a profit/loss statement or tax return.',
    urgent: true,
  },
  birth_certificate: {
    label: "Child's Birth Certificate",
    examples: 'Official state-issued birth certificate for each child in the household',
    agency_note: 'Required for children claimed as dependents. Hospital certificates are not accepted.',
    urgent: true,
  },
  lease_agreement: {
    label: 'Lease / Rental Agreement',
    examples: 'Current signed lease, month-to-month rental contract, letter from landlord',
    agency_note: 'Must show your name, address, and landlord contact. If staying with family, a letter from the homeowner works.',
    urgent: true,
  },
  utility_bill: {
    label: 'Utility Bill',
    examples: 'Electric, gas, water, or heating oil bill from the past 60 days',
    agency_note: 'Used to verify address and calculate utility deductions. Must show your name and service address.',
    urgent: false,
  },
  bank_statement: {
    label: 'Bank / Financial Account Statement',
    examples: 'Last 1–3 months of checking or savings account statements',
    agency_note: 'Required when the program has a resource/asset limit (e.g., SNAP). Must show account holder name.',
    urgent: false,
  },
  medical_record: {
    label: 'Medical Documentation',
    examples: 'Doctor letter, disability certification, prescription history, hospital discharge summary',
    agency_note: 'Required when claiming a disability or chronic illness. Must be on official letterhead.',
    urgent: false,
  },
  childcare_record: {
    label: 'Childcare Provider Record',
    examples: 'Signed childcare provider agreement, enrollment letter, CCDF provider registration',
    agency_note: "Provider must be licensed or certified. Include the provider's tax ID or license number.",
    urgent: false,
  },
  social_security_card: {
    label: 'Social Security Card',
    examples: 'Original or certified copy of Social Security card for each household member',
    agency_note: 'Required for all members claiming benefits. Must match the name on the application.',
    urgent: true,
  },
  immigration_document: {
    label: 'Immigration / Status Document',
    examples: 'Permanent Resident Card (Green Card), Employment Authorization Document (EAD), Passport with visa',
    agency_note: 'Required for non-citizen applicants. Programs vary in residency requirements.',
    urgent: true,
  },
  school_enrollment: {
    label: 'School / Training Enrollment Proof',
    examples: 'Enrollment letter, student ID, class schedule from an accredited institution',
    agency_note: 'Required to satisfy work/training participation requirements for TANF and CCDF.',
    urgent: false,
  },
  tax_return: {
    label: 'Prior Year Tax Return',
    examples: 'IRS Form 1040 (most recent filed year), all schedules included',
    agency_note: 'May be used in place of pay stubs for self-employed or irregular income. Include all pages.',
    urgent: false,
  },
  proof_of_pregnancy: {
    label: 'Proof of Pregnancy',
    examples: "Physician's letter confirming pregnancy with expected due date",
    agency_note: 'Required for Medicaid, WIC, and TANF pregnancy-based eligibility. Must be on clinic letterhead.',
    urgent: false,
  },
  custody_order: {
    label: 'Child Custody Order',
    examples: 'Court-issued custody decree, parenting plan, guardianship paperwork',
    agency_note: 'Required when custody is shared or disputed. Must be the most recent court order.',
    urgent: false,
  },
};

export const PROGRAM_REQUIREMENTS: Record<string, ProgramRequirements> = {
  SNAP: {
    program_key: 'snap',
    agency: 'USDA Food and Nutrition Service',
    required_fields: ['full_name', 'date_of_birth', 'address', 'household_size', 'monthly_income', 'immigration_status'],
    optional_fields: ['employer_name', 'has_disability', 'income_sources'],
    required_documents: ['government_id', 'proof_of_income'],
    optional_documents: ['utility_bill', 'bank_statement'],
  },
  TANF: {
    program_key: 'tanf',
    agency: 'HHS Administration for Children and Families',
    required_fields: ['full_name', 'date_of_birth', 'address', 'household_size', 'num_children', 'children_ages', 'monthly_income', 'employment_status'],
    optional_fields: ['marital_status', 'domestic_violence', 'employer_name'],
    required_documents: ['government_id', 'proof_of_income', 'birth_certificate'],
    optional_documents: ['bank_statement', 'lease_agreement'],
  },
  SECTION_8: {
    program_key: 'section 8',
    agency: 'HUD / Local Housing Authority',
    required_fields: ['full_name', 'date_of_birth', 'address', 'household_size', 'monthly_income', 'monthly_rent', 'immigration_status'],
    optional_fields: ['eviction_risk', 'has_disability'],
    required_documents: ['government_id', 'proof_of_income', 'lease_agreement'],
    optional_documents: ['utility_bill', 'bank_statement'],
  },
  MEDICAID: {
    program_key: 'medicaid',
    agency: 'CMS / State Medicaid Office',
    required_fields: ['full_name', 'date_of_birth', 'address', 'household_size', 'monthly_income', 'immigration_status'],
    optional_fields: ['has_disability', 'is_pregnant', 'health_insurance'],
    required_documents: ['government_id'],
    optional_documents: ['proof_of_income', 'medical_record'],
  },
  WIC: {
    program_key: 'wic',
    agency: 'USDA Food and Nutrition Service',
    required_fields: ['full_name', 'date_of_birth', 'address', 'monthly_income', 'is_pregnant', 'num_children', 'children_ages'],
    optional_fields: ['has_disability'],
    required_documents: ['government_id', 'proof_of_income'],
    optional_documents: ['birth_certificate'],
  },
  LIHEAP: {
    program_key: 'liheap',
    agency: 'HHS Office of Community Services',
    required_fields: ['full_name', 'address', 'household_size', 'monthly_income'],
    optional_fields: ['has_disability', 'monthly_utilities'],
    required_documents: ['government_id', 'proof_of_income', 'utility_bill'],
    optional_documents: [],
  },
  HEAD_START: {
    program_key: 'head start',
    agency: 'HHS Administration for Children and Families',
    required_fields: ['full_name', 'address', 'household_size', 'monthly_income', 'num_children', 'children_ages'],
    optional_fields: ['employment_status', 'has_disability'],
    required_documents: ['government_id', 'proof_of_income', 'birth_certificate'],
    optional_documents: ['childcare_record'],
  },
  CHIP: {
    program_key: 'chip',
    agency: 'CMS / State CHIP Office',
    required_fields: ['full_name', 'date_of_birth', 'address', 'household_size', 'num_children', 'children_ages'],
    optional_fields: ['health_insurance'],
    required_documents: ['government_id', 'proof_of_income'],
    optional_documents: ['birth_certificate'],
  },
  CCDF: {
    program_key: 'ccdf',
    agency: 'Office of Child Care',
    required_fields: ['full_name', 'date_of_birth', 'address', 'household_size', 'num_children', 'children_ages', 'needs_childcare'],
    optional_fields: ['monthly_childcare_cost', 'marital_status', 'employment_status'],
    required_documents: ['government_id', 'proof_of_income'],
    optional_documents: ['birth_certificate'],
  },
  EITC: {
    program_key: 'eitc',
    agency: 'Internal Revenue Service',
    required_fields: ['full_name', 'date_of_birth', 'household_size', 'num_children', 'monthly_income'],
    optional_fields: ['children_ages', 'marital_status', 'employment_status'],
    required_documents: ['government_id', 'proof_of_income'],
    optional_documents: [],
  },
  CHILD_TAX_CREDIT: {
    program_key: 'child tax credit',
    agency: 'Internal Revenue Service',
    required_fields: ['full_name', 'date_of_birth', 'num_children', 'children_ages', 'monthly_income'],
    optional_fields: ['household_size', 'marital_status'],
    required_documents: ['government_id', 'birth_certificate'],
    optional_documents: ['proof_of_income'],
  },
  PELL_GRANT: {
    program_key: 'pell grant',
    agency: 'U.S. Department of Education',
    required_fields: ['full_name', 'date_of_birth', 'address', 'monthly_income'],
    optional_fields: ['household_size', 'employment_status'],
    required_documents: ['government_id', 'proof_of_income'],
    optional_documents: [],
  },
  LIFELINE: {
    program_key: 'lifeline',
    agency: 'Federal Communications Commission',
    required_fields: ['full_name', 'date_of_birth', 'address', 'monthly_income'],
    optional_fields: ['household_size'],
    required_documents: ['government_id', 'proof_of_income'],
    optional_documents: [],
  },
  LEGAL_AID: {
    program_key: 'legal aid',
    agency: 'Legal Services Corporation',
    required_fields: ['full_name', 'date_of_birth', 'address', 'monthly_income', 'legal_issues'],
    optional_fields: ['household_size', 'urgency'],
    required_documents: ['government_id'],
    optional_documents: ['proof_of_income'],
  },
};

/** Fallback when no program-specific requirements match (Additional Review / unmapped programs). */
export const DEFAULT_PROGRAM_REQUIREMENTS: ProgramRequirements = {
  program_key: '__default__',
  agency: 'Partner Agency',
  required_fields: ['full_name', 'address'],
  optional_fields: ['monthly_income', 'household_size', 'date_of_birth'],
  required_documents: ['government_id'],
  optional_documents: ['proof_of_income'],
};

// Fuzzy match program name → schema; falls back to DEFAULT for Additional Review / unmapped programs
export function getProgramRequirements(programName: string): ProgramRequirements {
  const lower = programName.toLowerCase();
  for (const [, req] of Object.entries(PROGRAM_REQUIREMENTS)) {
    if (lower.includes(req.program_key)) return req;
  }
  return DEFAULT_PROGRAM_REQUIREMENTS;
}

// Get human-readable label for a document type key
export function getDocumentLabel(docType: string): string {
  return DOCUMENT_META[docType]?.label ?? docType.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase());
}
