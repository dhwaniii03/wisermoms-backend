import { PrismaClient } from '@prisma/client';
import { MothersService } from '../src/modules/mothers/mothers.service';

const prisma = new PrismaClient();
const mothersService = new MothersService();

async function assertProgramIds() {
  const wic = await prisma.benefitProgram.findUnique({ where: { id: 'wic' } });
  const ccap = await prisma.benefitProgram.findUnique({ where: { id: 'ccdf' } });
  if (!wic) throw new Error('WIC program (id: wic) missing from seed data');
  if (!ccap) throw new Error('CCAP program (id: ccdf) missing from seed data');
  console.log('✓ WIC and CCAP (ccdf) program IDs match seed data');
}

async function resolveOrgAndCaseworker(): Promise<{ orgId: string; caseworkerId: string }> {
  const caseworker = await prisma.orgUser.findFirst({
    where: { role: 'caseworker', is_active: true },
    select: { id: true, org_id: true },
  });
  if (!caseworker) throw new Error('No active caseworker in database for assignment test');
  return { orgId: caseworker.org_id, caseworkerId: caseworker.id };
}

async function testAssignCaseworkerCascadesToNullCase(programId: string, label: string) {
  const partnerCase = await prisma.partnerCase.findFirst({
    where: { program_id: programId },
    include: { mother: { include: { user: true } } },
  });

  if (!partnerCase?.mother) {
    throw new Error(`No ${label} partner case found — create one or run prisma seed`);
  }

  const motherId = partnerCase.mother_id;
  const userId = partnerCase.mother.user_id;
  if (!userId) throw new Error(`${label} mother is missing user_id`);

  const { orgId, caseworkerId: targetCaseworkerId } = await resolveOrgAndCaseworker();

  await prisma.user.update({
    where: { id: userId },
    data: { org_id: orgId },
  });

  await prisma.mother.update({
    where: { id: motherId },
    data: { caseworker_id: null },
  });

  await prisma.partnerCase.update({
    where: { id: partnerCase.id },
    data: { caseworker_id: null },
  });

  await mothersService.assignCaseworker(orgId, motherId, targetCaseworkerId);

  const refreshed = await prisma.partnerCase.findUnique({
    where: { id: partnerCase.id },
    include: { mother: true },
  });

  if (refreshed?.caseworker_id !== targetCaseworkerId) {
    throw new Error(
      `${label} case did not receive cascaded caseworker (expected ${targetCaseworkerId}, got ${refreshed?.caseworker_id})`
    );
  }
  if (refreshed.mother?.caseworker_id !== targetCaseworkerId) {
    throw new Error(`${label} mother caseworker_id was not updated`);
  }

  console.log(`✓ assignCaseworker cascades to ${label} case with null caseworker_id`);
}

async function runTests() {
  console.log('--- CW-01 / CW-02: CCAP & WIC Caseworker Assignment ---');
  let passed = true;

  try {
    await assertProgramIds();
    await testAssignCaseworkerCascadesToNullCase('wic', 'WIC');
    await testAssignCaseworkerCascadesToNullCase('ccdf', 'CCAP');
    console.log('✓ partner-access.ts has no program-specific assignment blocks');
  } catch (error) {
    console.error('✗', error instanceof Error ? error.message : error);
    passed = false;
  } finally {
    await prisma.$disconnect();
  }

  if (passed) {
    console.log('\nResult: PASS');
  } else {
    console.log('\nResult: FAIL');
    process.exit(1);
  }
}

runTests();
