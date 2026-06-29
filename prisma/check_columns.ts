import { PrismaClient } from '@prisma/client';
import dotenv from 'dotenv';

dotenv.config();

const NEON_URL = process.env.NEON_DATABASE_URL || "";
const SUPABASE_URL = process.env.DATABASE_URL || "";

async function checkDb(name: string, url: string) {
  console.log(`Checking columns for ${name}...`);
  const prisma = new PrismaClient({
    datasources: {
      db: { url },
    },
  });

  try {
    const columns = await prisma.$queryRawUnsafe<{ column_name: string; data_type: string }[]>(`
      SELECT column_name, data_type 
      FROM information_schema.columns 
      WHERE table_schema = 'public' AND table_name = 'users';
    `);
    console.log(`${name} users table columns:`, columns.map(c => `${c.column_name} (${c.data_type})`).join(', '));
  } catch (error) {
    console.error(`Failed to check ${name}:`, error);
  } finally {
    await prisma.$disconnect();
  }
}

async function main() {
  await checkDb('Neon', NEON_URL);
  await checkDb('Supabase', SUPABASE_URL);
}

main();
