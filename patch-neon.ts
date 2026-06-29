import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('Adding quarter and year columns to the applications table...');
  try {
    await prisma.$executeRawUnsafe(`ALTER TABLE "results" ADD COLUMN IF NOT EXISTS "quarter" TEXT;`);
    await prisma.$executeRawUnsafe(`ALTER TABLE "results" ADD COLUMN IF NOT EXISTS "year" INTEGER;`);
    console.log('Successfully added columns to Neon database!');
  } catch (error) {
    console.error('Failed to add columns:', error);
  } finally {
    await prisma.$disconnect();
  }
}

main();
