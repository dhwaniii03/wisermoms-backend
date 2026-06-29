/**
 * Seeds eligibility rules (metadata + eligibility_criteria) for Pennsylvania state programs.
 * Run: npx tsx scripts/seed-pa-program-rules.ts
 *
 * Rules mirror federal program logic, aligned to PA program names/IDs in benefit_programs.
 */
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

type ProgramRules = {
  income_threshold_type?: 'very_low' | 'low' | 'moderate' | 'high';
  requires_children?: boolean;
  max_child_age?: number;
  requires_pregnancy_or_child_under_5?: boolean;
  requires_employment?: boolean;
  requires_employment_or_student?: boolean;
  requires_childcare_need?: boolean;
  supports_disability?: boolean;
  supports_seniors_and_disability?: boolean;
  supports_eviction_risk?: boolean;
  requires_healthcare_gap?: boolean;
  priority_score?: number;
  category?: string;
  specific_states?: string[];
};

const PA_PROGRAM_RULES: Record<string, ProgramRules> = {
  snap_pa: {
    income_threshold_type: 'low',
    requires_children: false,
    priority_score: 90,
    category: 'Food',
    specific_states: ['PA'],
  },
  wic_pa: {
    income_threshold_type: 'moderate',
    requires_pregnancy_or_child_under_5: true,
    priority_score: 98,
    category: 'Nutrition',
    specific_states: ['PA'],
  },
  medicaid_pa: {
    income_threshold_type: 'low',
    requires_children: false,
    supports_disability: true,
    requires_healthcare_gap: true,
    priority_score: 92,
    category: 'Health',
    specific_states: ['PA'],
  },
  tanf_work_first_pa: {
    income_threshold_type: 'low',
    requires_children: true,
    priority_score: 95,
    category: 'Cash',
    specific_states: ['PA'],
  },
  liheap_pa: {
    income_threshold_type: 'low',
    supports_seniors_and_disability: true,
    priority_score: 80,
    category: 'Utilities',
    specific_states: ['PA'],
  },
  childcare_subsidy_pa: {
    income_threshold_type: 'moderate',
    requires_children: true,
    requires_childcare_need: true,
    requires_employment_or_student: true,
    priority_score: 88,
    category: 'Childcare',
    specific_states: ['PA'],
  },
  section8_pa: {
    income_threshold_type: 'very_low',
    requires_children: false,
    supports_disability: true,
    supports_eviction_risk: true,
    priority_score: 85,
    category: 'Housing',
    specific_states: ['PA'],
  },
  child_support_pa: {
    income_threshold_type: 'moderate',
    requires_children: true,
    max_child_age: 18,
    priority_score: 75,
    category: 'Child Support',
    specific_states: ['PA'],
  },
};

async function main() {
  console.log('=== Seeding Pennsylvania Program Eligibility Rules ===\n');

  let updated = 0;
  let missing = 0;

  for (const [programId, rules] of Object.entries(PA_PROGRAM_RULES)) {
    const program = await prisma.benefitProgram.findUnique({
      where: { id: programId },
      select: { id: true, name: true, state_code: true },
    });

    if (!program) {
      console.log(`⚠️  Program not found: ${programId}`);
      missing++;
      continue;
    }

    if (program.state_code !== 'PA') {
      console.log(`⚠️  Skipping ${programId} — state_code is ${program.state_code}, expected PA`);
      missing++;
      continue;
    }

    await prisma.benefitProgram.update({
      where: { id: programId },
      data: {
        metadata: rules,
        eligibility_criteria: rules,
        last_verified_date: new Date(),
      },
    });

    console.log(`✅ ${program.name} (${programId})`);
    updated++;
  }

  console.log(`\nDone. Updated ${updated} program(s). Missing/skipped: ${missing}.`);
  if (updated === 0) {
    process.exit(1);
  }
}

main()
  .catch((err) => {
    console.error(err);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
