import { PrismaClient } from '@prisma/client';
import { PdfService } from '../src/modules/pdf/pdf.service';
import { getProgramRequirements, DEFAULT_PROGRAM_REQUIREMENTS } from '../src/modules/pdf/program-requirements.data';

const prisma = new PrismaClient();
const pdfService = new PdfService();

async function main() {
  console.log('=== Additional Review PDF Generation Validation ===\n');
  const errors: string[] = [];

  const user = await prisma.user.findFirst({
    where: { family_profile: { isNot: null } },
    include: { family_profile: true },
  });

  if (!user?.family_profile) {
    console.error('❌ No user with family profile found.');
    process.exit(1);
  }

  console.log(`1. Using test user: ${user.email}`);

  // 2. Default requirements fallback for unmapped programs
  console.log('\n2. Verifying default requirements fallback...');
  const unmappedReqs = getProgramRequirements('Virginia Custom Assistance Program XYZ');
  if (unmappedReqs.program_key !== DEFAULT_PROGRAM_REQUIREMENTS.program_key) {
    errors.push('Unmapped program did not receive DEFAULT_PROGRAM_REQUIREMENTS');
  } else {
    console.log('   ✅ Unmapped programs resolve to default Additional Review requirements');
  }

  // 3. Find a check_required eligibility result or create one on a test program
  let testProgramId: string | null = null;
  let createdProgram = false;

  const checkRequiredResult = await prisma.eligibilityResult.findFirst({
    where: { user_id: user.id, status: 'check_required' },
    include: { program: true },
  });

  if (checkRequiredResult?.program) {
    testProgramId = checkRequiredResult.program_id;
    console.log(`\n3. Using existing Additional Review program: ${checkRequiredResult.program.name}`);
  } else {
    const dummy = await prisma.benefitProgram.create({
      data: {
        name: 'Additional Review Validation Program',
        agency: 'Test Agency',
        program_type: 'Test',
        state_code: 'PA',
        is_active: false,
      },
    });
    testProgramId = dummy.id;
    createdProgram = true;

    await prisma.eligibilityResult.create({
      data: {
        user_id: user.id,
        program_id: dummy.id,
        status: 'check_required',
        confidence_score: 50,
        reasoning: 'Eligibility pending formal agency review.',
      },
    });
    console.log(`\n3. Created temporary Additional Review test program: ${dummy.name}`);
  }

  // 4. Generate PDF for Additional Review program
  console.log('\n4. Generating PDF for Additional Review (check_required) program...');
  try {
    const { pdfBuffer, validationReport, uuid } = await pdfService.generatePdfBuffer(
      user.id,
      testProgramId
    );

    if (!pdfBuffer || pdfBuffer.length < 500) {
      errors.push(`PDF buffer too small (${pdfBuffer?.length ?? 0} bytes)`);
    } else {
      console.log(`   ✅ PDF generated (${pdfBuffer.length} bytes), uuid: ${uuid}`);
    }

    if (!validationReport.can_generate) {
      errors.push('validationReport.can_generate is false');
    } else {
      console.log('   ✅ Validation report allows generation');
    }
  } catch (err) {
    errors.push(`PDF generation threw: ${err instanceof Error ? err.message : String(err)}`);
  }

  // 5. Generate PDF for a mapped program (SNAP) as control
  console.log('\n5. Control: generating PDF for mapped SNAP program...');
  const snapProgram = await prisma.benefitProgram.findFirst({
    where: { name: { contains: 'SNAP', mode: 'insensitive' }, is_active: true },
  });

  if (snapProgram) {
    try {
      const { pdfBuffer } = await pdfService.generatePdfBuffer(user.id, snapProgram.id);
      if (!pdfBuffer || pdfBuffer.length < 500) {
        errors.push('SNAP control PDF generation produced invalid buffer');
      } else {
        console.log(`   ✅ SNAP control PDF generated (${pdfBuffer.length} bytes)`);
      }
    } catch (err) {
      errors.push(`SNAP control PDF failed: ${err instanceof Error ? err.message : String(err)}`);
    }
  } else {
    console.log('   ⚠️  No SNAP program found for control test (skipped)');
  }

  // Cleanup
  if (createdProgram && testProgramId) {
    await prisma.eligibilityResult.deleteMany({ where: { program_id: testProgramId } });
    await prisma.benefitProgram.delete({ where: { id: testProgramId } });
    console.log('\nCleaned up temporary test program.');
  }

  console.log('\n6. Summary...');
  if (errors.length === 0) {
    console.log('✅ Additional Review PDF generation validation passed.');
    console.log('\n🏆 OVERALL TEST RESULT: PASS');
  } else {
    console.log('❌ Issues found:');
    errors.forEach((e) => console.log(`   - ${e}`));
    console.log('\n🏆 OVERALL TEST RESULT: FAIL');
    process.exit(1);
  }
}

main()
  .catch((err) => {
    console.error(err);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
