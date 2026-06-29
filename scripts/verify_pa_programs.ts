import { PrismaClient } from '@prisma/client';
import { AuthService } from '../src/modules/auth/auth.service';
import { EligibilityService } from '../src/modules/eligibility/eligibility.service';

const prisma = new PrismaClient();
const authService = new AuthService();
const eligibilityService = new EligibilityService();

const EXPECTED_PA_PROGRAM_IDS = [
  'snap_pa',
  'wic_pa',
  'medicaid_pa',
  'tanf_work_first_pa',
  'liheap_pa',
  'childcare_subsidy_pa',
  'section8_pa',
  'child_support_pa',
];

/** Programs that should score qualified/likely for the standard low-income PA test household. */
const MUST_QUALIFY_IDS = ['snap_pa', 'wic_pa', 'tanf_work_first_pa', 'childcare_subsidy_pa'];

async function main() {
  console.log('=== Pennsylvania Program Availability & Eligibility Validation ===\n');

  let testUserId: string | null = null;
  const errors: string[] = [];

  try {
    // 1. Verify PA programs exist with rules
    console.log('1. Checking PA programs and eligibility rules in database...');
    const paPrograms = await prisma.benefitProgram.findMany({
      where: { state_code: 'PA', is_active: true },
      select: { id: true, name: true, metadata: true, eligibility_criteria: true },
      orderBy: { name: 'asc' },
    });

    if (paPrograms.length < EXPECTED_PA_PROGRAM_IDS.length) {
      errors.push(
        `Expected at least ${EXPECTED_PA_PROGRAM_IDS.length} active PA programs, found ${paPrograms.length}`
      );
    }

    for (const id of EXPECTED_PA_PROGRAM_IDS) {
      const program = paPrograms.find((p) => p.id === id);
      if (!program) {
        errors.push(`Missing PA program: ${id}`);
        continue;
      }
      const rules = program.metadata ?? program.eligibility_criteria;
      if (!rules || typeof rules !== 'object') {
        errors.push(`Missing eligibility rules for ${program.name} (${id})`);
      } else {
        console.log(`   ✅ ${program.name} — rules present`);
      }
    }

    // 2. Register PA test user
    const testEmail = `pa.verify.${Date.now()}@example.com`;
    console.log(`\n2. Registering PA test user: ${testEmail}...`);
    const session = await authService.register({
      email: testEmail,
      password: 'Password123!',
      first_name: 'Sarah',
      middle_name: 'Jane',
      last_name: 'Doe',
      phone: '2155550199',
      zip_code: '19103',
    });
    testUserId = session.user.id;
    console.log(`   ✅ Registered. User state should be PA (ZIP 19103).`);

    const user = await prisma.user.findUnique({ where: { id: testUserId } });
    if (user?.state !== 'PA') {
      errors.push(`User state mismatch: expected PA, got ${user?.state}`);
    }

    // 3. Low-income household profile (typical qualifying mother)
    console.log('\n3. Setting qualifying family profile...');
    await prisma.familyProfile.update({
      where: { user_id: testUserId },
      data: {
        household_size: 3,
        num_children: 2,
        children_ages: [2, 4],
        monthly_income: 1800,
        employment_status: 'full_time',
        needs_childcare: true,
        is_pregnant: false,
        has_disability: false,
        housing_status: 'renting',
        immigration_status: 'citizen',
        health_insurance: 'none',
      },
    });
    console.log('   ✅ Profile updated.');

    // 4. Run eligibility scan
    console.log('\n4. Running eligibility scan...');
    const scan = await eligibilityService.runScan(testUserId);
    const results = scan.results;
    console.log(`   ✅ Scan returned ${results.length} program result(s).`);

    const paResults = results.filter((r) => r.program?.state_code === 'PA');
    const gaLeak = results.filter((r) => r.program?.state_code === 'GA');

    console.log(`   PA state programs in scan: ${paResults.length}`);
    console.log(`   GA programs leaked: ${gaLeak.length}`);

    if (gaLeak.length > 0) {
      errors.push(`Georgia programs incorrectly included for PA user: ${gaLeak.map((r) => r.program?.name).join(', ')}`);
    }

    for (const id of EXPECTED_PA_PROGRAM_IDS) {
      if (!paResults.some((r) => r.program_id === id || r.program?.id === id)) {
        errors.push(`PA program missing from scan results: ${id}`);
      }
    }

    // 5. Verify scoring — no longer all default check_required / score 50
    console.log('\n5. Verifying PA program eligibility scores...');
    const allDefaultScore = paResults.every(
      (r) => r.status === 'check_required' && r.confidence_score === 50
    );
    if (allDefaultScore) {
      errors.push(
        'All PA programs still have default score 50 / check_required — eligibility rules may not be seeded'
      );
    }

    for (const r of paResults) {
      console.log(
        `   - ${r.program?.name}: ${r.status} (score ${r.confidence_score})`
      );
    }

    for (const id of MUST_QUALIFY_IDS) {
      const match = paResults.find((r) => r.program?.id === id);
      if (!match) continue;
      if (match.status !== 'qualified' && match.status !== 'likely_qualified') {
        errors.push(
          `Expected ${match.program?.name} to be qualified/likely_qualified, got ${match.status} (${match.confidence_score})`
        );
      }
    }

    // 6. Summary
    console.log('\n6. Validation summary...');
    if (errors.length === 0) {
      console.log('✅ All Pennsylvania program checks passed.');
      console.log('\n🏆 OVERALL TEST RESULT: PASS');
    } else {
      console.log('❌ Issues found:');
      errors.forEach((e) => console.log(`   - ${e}`));
      console.log('\n🏆 OVERALL TEST RESULT: FAIL');
      process.exit(1);
    }
  } catch (error) {
    console.error('\n❌ Test execution failed:', error);
    console.log('\n🏆 OVERALL TEST RESULT: FAIL');
    process.exit(1);
  } finally {
    if (testUserId) {
      console.log('\nCleaning up test user...');
      await prisma.notification.deleteMany({ where: { user_id: testUserId } });
      await prisma.eligibilityResult.deleteMany({ where: { user_id: testUserId } });
      await prisma.familyProfile.deleteMany({ where: { user_id: testUserId } });
      await prisma.refreshToken.deleteMany({ where: { user_id: testUserId } });
      await prisma.user.delete({ where: { id: testUserId } });
      console.log('Cleanup complete.');
    }
    await prisma.$disconnect();
  }
}

main();
