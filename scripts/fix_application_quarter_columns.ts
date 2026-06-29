import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  await prisma.$executeRawUnsafe(
    'ALTER TABLE "applications" ADD COLUMN IF NOT EXISTS "quarter" TEXT'
  );
  await prisma.$executeRawUnsafe(
    'ALTER TABLE "applications" ADD COLUMN IF NOT EXISTS "year" INTEGER'
  );
  console.log('Added applications.quarter and applications.year if missing');
}

main()
  .catch(console.error)
  .finally(() => prisma.$disconnect());
