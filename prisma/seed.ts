import { OrganizationType, PrismaClient } from '@prisma/client';
import bcrypt from 'bcrypt';

const prisma = new PrismaClient();

const programs = [
  {
    id: 'tanf',
    name: 'TANF — Temporary Assistance for Needy Families',
    agency: 'U.S. Dept. of Health & Human Services',
    program_type: 'Cash Assistance',
    federal_or_state: 'Federal And State Program',
    description: 'Monthly cash assistance for low-income families with children, plus job training and childcare support.',
    benefit: 'Up to $400–$900/mo',
    estimated_monthly_value_min: 400,
    estimated_monthly_value_max: 900,
    website: 'https://www.acf.hhs.gov/ofa/programs/tanf',
    application_url: 'https://www.acf.hhs.gov/ofa/map/about/help-families',
    contact_email: 'infocollection@acf.hhs.gov',
    tags: ['cash', 'children', 'emergency'],
    eligibility_criteria: {
      income_threshold_type: 'low',
      requires_children: true,
      requires_unemployment: false,
      priority_score: 95,
      category: 'Cash'
    },
    metadata: {
      income_threshold_type: 'low',
      requires_children: true,
      requires_unemployment: false,
      priority_score: 95,
      category: 'Cash'
    }
  },
  {
    id: 'snap',
    name: 'SNAP — Food Stamps',
    agency: 'USDA',
    program_type: 'Federal Program',
    federal_or_state: 'Federal Program',
    description: 'Monthly EBT benefits to buy groceries for you and your family.',
    benefit: 'Avg $180 per person/mo',
    estimated_monthly_value_min: 180,
    estimated_monthly_value_max: 1200,
    website: 'https://www.fns.usda.gov/snap/supplemental-nutrition-assistance-program',
    application_url: 'https://www.fns.usda.gov/snap/state-directory',
    contact_email: 'AskUSDA@usda.gov',
    tags: ['food', 'essential', 'ebt'],
    eligibility_criteria: {
      income_threshold_type: 'low',
      requires_children: false,
      priority_score: 90,
      category: 'Food'
    },
    metadata: {
      income_threshold_type: 'low',
      requires_children: false,
      priority_score: 90,
      category: 'Food'
    }
  },
  {
    id: 'wic',
    name: 'WIC — Women, Infants & Children',
    agency: 'USDA',
    program_type: 'Federal Program',
    federal_or_state: 'Federal Program',
    description: 'Nutritious food, formula, breastfeeding support, and health referrals for pregnant women and kids under 5.',
    benefit: 'Food package + formula',
    estimated_monthly_value_min: 50,
    estimated_monthly_value_max: 300,
    website: 'https://www.fns.usda.gov/wic',
    application_url: 'https://www.fns.usda.gov/wic/wic-state-agencies',
    contact_email: 'AskUSDA@usda.gov',
    tags: ['food', 'nutrition', 'pregnancy', 'children'],
    eligibility_criteria: {
      income_threshold_type: 'moderate',
      requires_pregnancy_or_child_under_5: true,
      priority_score: 98,
      category: 'Nutrition'
    },
    metadata: {
      income_threshold_type: 'moderate',
      requires_pregnancy_or_child_under_5: true,
      priority_score: 98,
      category: 'Nutrition'
    }
  },
  {
    id: 'medicaid',
    name: 'Medicaid & CHIP',
    agency: 'CMS',
    program_type: 'Federal Program',
    federal_or_state: 'Federal Program',
    description: 'Free or low-cost health coverage for you and your kids.',
    benefit: 'Comprehensive medical coverage',
    estimated_monthly_value_min: 300,
    estimated_monthly_value_max: 2000,
    website: 'https://www.medicaid.gov/',
    application_url: 'https://www.healthcare.gov/medicaid-chip/',
    contact_email: 'Medicaid.gov@cms.hhs.gov',
    tags: ['healthcare', 'health', 'children', 'pregnancy'],
    eligibility_criteria: {
      income_threshold_type: 'low',
      requires_children: false,
      supports_disability: true,
      priority_score: 92,
      category: 'Health'
    },
    metadata: {
      income_threshold_type: 'low',
      requires_children: false,
      supports_disability: true,
      priority_score: 92,
      category: 'Health'
    }
  },
  {
    id: 'ccdf',
    name: 'Child Care Subsidy (CCDF)',
    agency: 'Office of Child Care',
    program_type: 'Federal Program',
    federal_or_state: 'Federal Program',
    description: 'Help paying for daycare or after-school care so you can work or attend school.',
    benefit: 'Subsidized childcare costs',
    estimated_monthly_value_min: 200,
    estimated_monthly_value_max: 1500,
    website: 'https://www.acf.hhs.gov/occ',
    application_url: 'https://www.childcare.gov/state-resources',
    contact_email: 'OCCPolicyInfo@acf.hhs.gov',
    tags: ['childcare', 'employment', 'education'],
    eligibility_criteria: {
      income_threshold_type: 'moderate',
      requires_children: true,
      requires_employment_or_student: true,
      priority_score: 88,
      category: 'Childcare'
    },
    metadata: {
      income_threshold_type: 'moderate',
      requires_children: true,
      requires_employment_or_student: true,
      priority_score: 88,
      category: 'Childcare'
    }
  },
  {
    id: 'section8',
    name: 'Section 8 Housing Choice Voucher',
    agency: 'HUD',
    program_type: 'Federal Program',
    federal_or_state: 'Federal Program',
    description: 'Rental assistance — pay ~30% of your income, voucher covers the rest.',
    benefit: 'Rental voucher',
    estimated_monthly_value_min: 500,
    estimated_monthly_value_max: 2500,
    website: 'https://www.hud.gov/topics/housing_choice_voucher_program_section_8',
    application_url: 'https://www.hud.gov/program_offices/public_indian_housing/pha/contacts',
    contact_email: 'answers@hud.gov',
    tags: ['housing', 'rent', 'low-income'],
    eligibility_criteria: {
      income_threshold_type: 'very_low',
      requires_children: false,
      supports_disability: true,
      priority_score: 85,
      category: 'Housing'
    },
    metadata: {
      income_threshold_type: 'very_low',
      requires_children: false,
      supports_disability: true,
      priority_score: 85,
      category: 'Housing'
    }
  },
  {
    id: 'liheap',
    name: 'LIHEAP — Energy Assistance',
    agency: 'HHS',
    program_type: 'Federal Program',
    federal_or_state: 'Federal Program',
    description: 'Help paying heating, cooling, and energy bills.',
    benefit: 'Up to $1,000/yr toward bills',
    estimated_monthly_value_min: 20,
    estimated_monthly_value_max: 100,
    website: 'https://www.acf.hhs.gov/ocs/programs/liheap',
    application_url: 'https://www.acf.hhs.gov/ocs/low-income-home-energy-assistance-program-liheap',
    contact_email: 'LIHEAP@acf.hhs.gov',
    tags: ['utilities', 'energy', 'heating', 'cooling'],
    eligibility_criteria: {
      income_threshold_type: 'low',
      supports_seniors_and_disability: true,
      priority_score: 80,
      category: 'Utilities'
    },
    metadata: {
      income_threshold_type: 'low',
      supports_seniors_and_disability: true,
      priority_score: 80,
      category: 'Utilities'
    }
  },
  {
    id: 'eitc',
    name: 'Earned Income Tax Credit (EITC)',
    agency: 'IRS',
    program_type: 'Federal Program',
    federal_or_state: 'Federal Program',
    description: 'Refundable tax credit for working parents — money back even if you owe nothing.',
    benefit: 'Up to $7,830/yr',
    estimated_monthly_value_min: 50,
    estimated_monthly_value_max: 650,
    website: 'https://www.irs.gov/credits-deductions/individuals/earned-income-tax-credit-eitc',
    application_url: 'https://www.irs.gov/credits-deductions/individuals/earned-income-tax-credit-eitc',
    contact_email: 'TAS.Form.911.Request.for.Assistance@irs.gov',
    tags: ['tax', 'cash', 'employment'],
    eligibility_criteria: {
      income_threshold_type: 'moderate',
      requires_employment: true,
      priority_score: 82,
      category: 'Tax'
    },
    metadata: {
      income_threshold_type: 'moderate',
      requires_employment: true,
      priority_score: 82,
      category: 'Tax'
    }
  },
  {
    id: 'child_tax_credit',
    name: 'Child Tax Credit',
    agency: 'IRS',
    program_type: 'Federal Program',
    federal_or_state: 'Federal Program',
    description: 'Up to $2,000 per qualifying child under 17 on your federal return.',
    benefit: '$2,000 per child',
    estimated_monthly_value_min: 160,
    estimated_monthly_value_max: 160,
    website: 'https://www.irs.gov/credits-deductions/child-tax-credit',
    application_url: 'https://www.irs.gov/credits-deductions/child-tax-credit',
    contact_email: 'TAS.Form.911.Request.for.Assistance@irs.gov',
    tags: ['tax', 'children', 'cash'],
    eligibility_criteria: {
      income_threshold_type: 'high',
      requires_children: true,
      max_child_age: 17,
      priority_score: 90,
      category: 'Tax'
    },
    metadata: {
      income_threshold_type: 'high',
      requires_children: true,
      max_child_age: 17,
      priority_score: 90,
      category: 'Tax'
    }
  },
  {
    id: 'pell_grant',
    name: 'Federal Pell Grant',
    agency: 'Dept. of Education',
    program_type: 'Federal Program',
    federal_or_state: 'Federal Program',
    description: "Free college money for low-income students — doesn't need to be repaid.",
    benefit: 'Up to $7,395/yr',
    estimated_monthly_value_min: 100,
    estimated_monthly_value_max: 615,
    website: 'https://studentaid.gov/understand-aid/types/grants/pell',
    application_url: 'https://studentaid.gov/h/apply-for-aid/fafsa',
    contact_email: 'customerservice@studentaid.gov',
    tags: ['education', 'college', 'students'],
    eligibility_criteria: {
      income_threshold_type: 'moderate',
      requires_student_status: true,
      priority_score: 75,
      category: 'Education'
    },
    metadata: {
      income_threshold_type: 'moderate',
      requires_student_status: true,
      priority_score: 75,
      category: 'Education'
    }
  },
  {
    id: 'head_start',
    name: 'Head Start & Early Head Start',
    agency: 'HHS',
    program_type: 'Federal Program',
    federal_or_state: 'Federal Program',
    description: 'Free early learning, health, and family services for kids 0–5.',
    benefit: 'Free preschool program',
    estimated_monthly_value_min: 500,
    estimated_monthly_value_max: 1200,
    website: 'https://www.acf.hhs.gov/ohs',
    application_url: 'https://eclkc.ohs.acf.hhs.gov/center-locator',
    contact_email: 'HeadStart@eclkc.info',
    tags: ['education', 'children', 'preschool'],
    eligibility_criteria: {
      income_threshold_type: 'low',
      requires_children: true,
      max_child_age: 5,
      priority_score: 91,
      category: 'Education'
    },
    metadata: {
      income_threshold_type: 'low',
      requires_children: true,
      max_child_age: 5,
      priority_score: 91,
      category: 'Education'
    }
  },
  {
    id: 'lifeline',
    name: 'Lifeline Phone & Internet',
    agency: 'FCC',
    program_type: 'Federal Program',
    federal_or_state: 'Federal Program',
    description: 'Discount on monthly phone or internet for qualifying households.',
    benefit: '$9.25/mo discount',
    estimated_monthly_value_min: 9,
    estimated_monthly_value_max: 9,
    website: 'https://www.lifelinesupport.org/',
    application_url: 'https://www.lifelinesupport.org/get-started/',
    contact_email: 'LifelineSupport@usac.org',
    tags: ['utilities', 'phone', 'internet'],
    eligibility_criteria: {
      income_threshold_type: 'low',
      priority_score: 72,
      category: 'Utilities'
    },
    metadata: {
      income_threshold_type: 'low',
      priority_score: 72,
      category: 'Utilities'
    }
  },
  {
    id: 'legal_aid',
    name: 'Civil Legal Aid Services',
    agency: 'Legal Services Corporation (LSC)',
    program_type: 'Federal and State Program',
    federal_or_state: 'Federal Program',
    description: 'Free civil legal assistance for low-income individuals facing housing, family, domestic violence, or benefits issues.',
    benefit: 'Free attorney representation & consultation',
    estimated_monthly_value_min: 150,
    estimated_monthly_value_max: 800,
    website: 'https://www.lsc.gov/',
    application_url: 'https://www.lsc.gov/grants/our-grantees',
    contact_email: 'info@lsc.gov',
    tags: ['legal', 'civil-rights', 'emergency', 'family-safety'],
    eligibility_criteria: {
      income_threshold_type: 'low',
      supports_legal_aid: true,
      priority_score: 80,
      category: 'Legal'
    },
    metadata: {
      income_threshold_type: 'low',
      supports_legal_aid: true,
      priority_score: 80,
      category: 'Legal'
    }
  }
];

// ---- Partner org seed data ----

const DEMO_ORG_ID      = '00000000-0000-0000-0000-000000000001';
const DEMO_ADMIN_ID    = '00000000-0000-0000-0000-000000000002';
const DEMO_CASEWORKER1 = '00000000-0000-0000-0000-000000000003';
const DEMO_CASEWORKER2 = '00000000-0000-0000-0000-000000000004';

const DEMO_MOTHERS = [
  { id: '00000000-0000-0000-0001-000000000001', userId: '00000000-0000-0000-0001-000000000101', first: 'Keondra', last: 'Wells', program: 'snap', status: 'renewal_due', caseworker: DEMO_CASEWORKER1 },
  { id: '00000000-0000-0000-0001-000000000002', userId: '00000000-0000-0000-0001-000000000102', first: 'Desiree', last: 'Williams', program: 'snap', status: 'in_progress', caseworker: DEMO_CASEWORKER1 },
  { id: '00000000-0000-0000-0001-000000000003', userId: '00000000-0000-0000-0001-000000000103', first: 'Tiffany', last: 'Cruz', program: 'medicaid', status: 'in_progress', caseworker: DEMO_CASEWORKER2 },
  { id: '00000000-0000-0000-0001-000000000004', userId: '00000000-0000-0000-0001-000000000104', first: 'Aaliyah', last: 'Johnson', program: 'wic', status: 'approved', caseworker: DEMO_CASEWORKER2 },
  { id: '00000000-0000-0000-0001-000000000005', userId: '00000000-0000-0000-0001-000000000105', first: 'Monica', last: 'Reyes', program: 'tanf', status: 'submitted', caseworker: DEMO_CASEWORKER1 },
  { id: '00000000-0000-0000-0001-000000000006', userId: '00000000-0000-0000-0001-000000000106', first: 'Jasmine', last: 'Porter', program: 'ccdf', status: 'approved', caseworker: DEMO_CASEWORKER2 },
  { id: '00000000-0000-0000-0001-000000000007', userId: '00000000-0000-0000-0001-000000000107', first: 'Latoya', last: 'Mitchell', program: 'section8', status: 'not_started', caseworker: DEMO_CASEWORKER1 },
];

function daysFromNow(n: number): Date {
  const d = new Date();
  d.setDate(d.getDate() + n);
  d.setHours(0, 0, 0, 0);
  return d;
}

async function seedPartnerOrg() {
  console.log('Seeding demo partner organization...');

  const password_hash = await bcrypt.hash('Admin1234!', 10);

  await prisma.organization.upsert({
    where:  { id: DEMO_ORG_ID },
    update: { onboarding_completed: true },
    create: {
      id:            DEMO_ORG_ID,
      org_name:      'Blossom Community Hub',
      category:      'Non-profit (501c3)',
      org_type:      OrganizationType.nonprofit_501c3,
      website:       'https://www.blossomcommunityhub.org',
      description:   'Connecting underserved mothers and families to the benefits, resources, and community they deserve.',
      purpose:       'Connecting underserved mothers and families to the benefits, resources, and community they deserve.',
      phone:         '+1 (404) 555-0192',
      address:       '250 Peachtree St NW, Suite 400',
      city:          'Atlanta',
      state:         'GA',
      zip_code:      '30303',
      country:       'United States',
      contact_email: 'hello@blossomcommunityhub.org',
      email:         'hello@blossomcommunityhub.org',
      employees:     '11-50',
      founded:       '2018',
      tax_id:        '82-1234567',
      linkedin:      'https://linkedin.com/company/blossom-community-hub',
      onboarding_completed: true,
    },
  });

  await prisma.orgUser.upsert({
    where:  { id: DEMO_ADMIN_ID },
    update: {},
    create: {
      id: DEMO_ADMIN_ID, full_name: 'K. Marshall', email: 'admin@blossomcommunityhub.org',
      password_hash, role: 'admin', org_id: DEMO_ORG_ID, is_active: true, must_change_password: false,
    },
  });

  await prisma.orgUser.upsert({
    where:  { id: DEMO_CASEWORKER1 },
    update: {},
    create: {
      id: DEMO_CASEWORKER1, full_name: 'R. Patel', email: 'rpatel@blossomcommunityhub.org',
      password_hash, role: 'caseworker', org_id: DEMO_ORG_ID, is_active: true, caseload_capacity: 30,
      must_change_password: false,
    },
  });

  await prisma.orgUser.upsert({
    where:  { id: DEMO_CASEWORKER2 },
    update: {},
    create: {
      id: DEMO_CASEWORKER2, full_name: 'S. Nguyen', email: 'snguyen@blossomcommunityhub.org',
      password_hash, role: 'caseworker', org_id: DEMO_ORG_ID, is_active: true, caseload_capacity: 25,
      must_change_password: false,
    },
  });

  const quarter = 'Q2';
  let caseIdx = 0;

  for (const m of DEMO_MOTHERS) {
    caseIdx++;
    const caseId = `00000000-0000-0000-0002-00000000000${caseIdx}`;

    await prisma.user.upsert({
      where: { email: `${m.first.toLowerCase()}.demo@momplan.test` },
      update: { first_name: m.first, last_name: m.last },
      create: {
        id: m.userId,
        email: `${m.first.toLowerCase()}.demo@momplan.test`,
        first_name: m.first,
        last_name: m.last,
        password_hash: '',
      },
    });

    await prisma.familyProfile.upsert({
      where: { user_id: m.userId },
      update: {
        first_name: m.first,
        last_name: m.last,
        phone: '(404) 555-0193',
        email: `${m.first.toLowerCase()}.demo@momplan.test`,
        street_address: '241 Peach St',
        city: 'Atlanta',
        state: 'GA',
        zip_code: '30314',
        household_size: 3,
        num_children: 2,
        monthly_income: 1840,
        preferred_contact: 'text',
        preferred_language: 'English',
        postpartum_months_since_birth: m.first === 'Desiree' ? 7 : undefined,
        children_dobs: m.first === 'Desiree' ? ['2020-03-15', '2025-11-01'] : ['2019-06-10'],
      },
      create: {
        user_id: m.userId,
        first_name: m.first,
        last_name: m.last,
        phone: '(404) 555-0193',
        email: `${m.first.toLowerCase()}.demo@momplan.test`,
        street_address: '241 Peach St',
        city: 'Atlanta',
        state: 'GA',
        zip_code: '30314',
        household_size: 3,
        num_children: 2,
        monthly_income: 1840,
        preferred_contact: 'text',
        preferred_language: 'English',
        postpartum_months_since_birth: m.first === 'Desiree' ? 7 : null,
        children_dobs: m.first === 'Desiree' ? ['2020-03-15', '2025-11-01'] : ['2019-06-10'],
      },
    });

    await prisma.mother.upsert({
      where: { id: m.id },
      update: {},
      create: {
        id: m.id,
        user_id: m.userId,
        caseworker_id: m.caseworker,
        dob: new Date('1994-03-02'),
        phone: '(404) 555-0193',
        address: '241 Peach St, Atlanta, GA 30314',
        enrollment_status: 'enrolled',
      },
    });

    await prisma.partnerCase.upsert({
      where: { id: caseId },
      update: {
        status: m.status,
        quarter,
        secure_submitted_at: ['submitted', 'approved', 'renewal_due'].includes(m.status) ? new Date() : null,
      },
      create: {
        id: caseId,
        mother_id: m.id,
        caseworker_id: m.caseworker,
        program_id: m.program,
        status: m.status,
        urgency_level: m.status === 'renewal_due' ? 'high' : 'normal',
        quarter,
        intake_date: new Date(),
        secure_submitted_at: ['submitted', 'approved', 'renewal_due'].includes(m.status) ? new Date() : null,
        last_activity: new Date(),
      },
    });

    const deadlineDays = m.first === 'Desiree' ? 1 : m.status === 'renewal_due' ? 5 : 20 + caseIdx * 3;
    await prisma.caseDeadline.upsert({
      where: { id: `00000000-0000-0000-0003-00000000000${caseIdx}` },
      update: { due_date: daysFromNow(deadlineDays) },
      create: {
        id: `00000000-0000-0000-0003-00000000000${caseIdx}`,
        case_id: caseId,
        type: m.status === 'renewal_due' || m.first === 'Desiree' ? 'renewal' : 'document_upload',
        due_date: daysFromNow(deadlineDays),
        is_resolved: false,
      },
    });

    const docs = [
      { type: 'Proof of income', status: 'pending' as const, hasFile: false },
      { type: 'Proof of residency', status: 'pending' as const, hasFile: false },
      { type: 'Government-issued ID', status: 'approved' as const, hasFile: true },
    ];
    if (m.first === 'Desiree') {
      docs.push({ type: 'Birth certificate — Jaylen', status: 'approved' as const, hasFile: true });
      docs.push({ type: 'SNAP renewal form', status: 'pending' as const, hasFile: true });
    }

    for (let di = 0; di < docs.length; di++) {
      const doc = docs[di];
      await prisma.caseDocument.upsert({
        where: { id: `00000000-0000-0000-0004-${String(caseIdx).padStart(6, '0')}${String(di).padStart(6, '0')}` },
        update: {},
        create: {
          id: `00000000-0000-0000-0004-${String(caseIdx).padStart(6, '0')}${String(di).padStart(6, '0')}`,
          case_id: caseId,
          doc_type: doc.type,
          file_url: doc.hasFile ? `uploads/demo/${caseId}/${doc.type.replace(/\s/g, '_')}.pdf` : '',
          review_status: doc.status,
        },
      });
    }

    await prisma.communication.upsert({
      where: { id: `00000000-0000-0000-0005-00000000000${caseIdx}` },
      update: {},
      create: {
        id: `00000000-0000-0000-0005-00000000000${caseIdx}`,
        case_id: caseId,
        sent_by: m.caseworker,
        type: m.first === 'Desiree' ? 'document_request' : 'status_update',
        channel: 'email',
        message: m.first === 'Desiree' ? 'Document request sent' : 'Approval letter sent',
        sent_at: new Date(),
        delivery_status: 'sent',
      },
    });

    await prisma.statusHistory.upsert({
      where: { id: `00000000-0000-0000-0006-00000000000${caseIdx}` },
      update: {},
      create: {
        id: `00000000-0000-0000-0006-00000000000${caseIdx}`,
        case_id: caseId,
        changed_by: m.caseworker,
        old_status: 'not_started',
        new_status: m.status,
        notes: m.status === 'approved' ? 'Postpartum Medicaid approved' : undefined,
      },
    });
  }

  console.log('Demo org seeded — email: admin@blossomcommunityhub.org  password: Admin1234!');
}

async function main() {
  console.log('Seeding benefit programs with structured metadata...');

  for (const program of programs) {
    await prisma.benefitProgram.upsert({
      where: { id: program.id },
      update: {
        name: program.name,
        agency: program.agency,
        program_type: program.program_type,
        federal_or_state: program.federal_or_state,
        description: program.description,
        eligibility_criteria: program.eligibility_criteria as any,
        estimated_monthly_value_min: program.estimated_monthly_value_min,
        estimated_monthly_value_max: program.estimated_monthly_value_max,
        application_url: program.application_url,
        contact_email: (program as any).contact_email,
        tags: program.tags,
        metadata: program.metadata as any,
      },
      create: {
        id: program.id,
        name: program.name,
        agency: program.agency,
        program_type: program.program_type,
        federal_or_state: program.federal_or_state,
        description: program.description,
        eligibility_criteria: program.eligibility_criteria as any,
        estimated_monthly_value_min: program.estimated_monthly_value_min,
        estimated_monthly_value_max: program.estimated_monthly_value_max,
        application_url: program.application_url,
        contact_email: (program as any).contact_email,
        tags: program.tags,
        metadata: program.metadata as any,
      },
    });
  }

  await seedPartnerOrg();
  console.log('Seed completed successfully.');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
