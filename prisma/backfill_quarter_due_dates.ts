/**
 * Idempotent backfill for program_quarter_due_dates.
 * Programs with no renewal_period_months are treated as monthly renewals.
 *
 * Usage:
 *   npx tsx prisma/backfill_quarter_due_dates.ts
 *   npx tsx prisma/backfill_quarter_due_dates.ts 2026
 */
import { quarterDueDatesService } from '../src/modules/programs/quarterDueDates.service';
import { prisma } from '../src/config/prisma';

async function main() {
  const yearArg = process.argv[2];
  const year = yearArg ? Number(yearArg) : new Date().getUTCFullYear();

  if (!Number.isInteger(year) || year < 2000 || year > 2100) {
    throw new Error('Year must be an integer between 2000 and 2100');
  }

  console.log(`Starting quarter due date backfill for year ${year}...`);
  const summary = await quarterDueDatesService.backfillAllPrograms(year);
  console.log('Backfill complete:', JSON.stringify(summary, null, 2));
}

main()
  .catch((error) => {
    console.error('Backfill failed:', error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
