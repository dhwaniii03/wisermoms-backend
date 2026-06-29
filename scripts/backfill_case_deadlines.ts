import { prisma } from '../src/config/prisma';
import {
  syncApplicationDeadline,
  syncPartnerCaseDeadline,
} from '../src/modules/partner/case-deadline-sync';

async function main() {
  const cases = await prisma.partnerCase.findMany({
    where: { secure_submitted_at: { not: null } },
    select: {
      id: true,
      program_id: true,
      quarter: true,
      application_id: true,
      mother: { select: { user_id: true } },
    },
  });

  let synced = 0;
  for (const c of cases) {
    await syncPartnerCaseDeadline(c.id, c.program_id, c.quarter ?? undefined);
    if (c.application_id && c.mother?.user_id) {
      await syncApplicationDeadline(
        c.application_id,
        c.mother.user_id,
        c.program_id,
        c.quarter ?? undefined
      );
    }
    synced++;
  }

  console.log(`Backfilled due dates for ${synced} submitted partner case(s).`);
}

main()
  .catch((err) => {
    console.error(err);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
