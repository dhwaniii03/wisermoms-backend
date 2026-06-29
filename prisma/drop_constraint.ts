import { PrismaClient } from '@prisma/client';
import dotenv from 'dotenv';

dotenv.config();

const SUPABASE_URL = process.env.DATABASE_URL || "";

async function main() {
  console.log('Connecting to Supabase to drop foreign key constraint...');
  const prisma = new PrismaClient({
    datasources: {
      db: { url: SUPABASE_URL },
    },
  });

  try {
    await prisma.$executeRawUnsafe(`
      ALTER TABLE public.users DROP CONSTRAINT IF EXISTS users_id_fkey CASCADE;
    `);
    console.log('Successfully dropped users_id_fkey constraint from Supabase.');

    console.log('Updating existing NULL values to defaults for Prisma compatibility...');
    
    // Ensure columns exist first before attempting to update them
    await prisma.$executeRawUnsafe(`
      ALTER TABLE public.users ADD COLUMN IF NOT EXISTS password_hash text;
    `);
    await prisma.$executeRawUnsafe(`
      ALTER TABLE public.users ADD COLUMN IF NOT EXISTS full_name text;
    `);
    await prisma.$executeRawUnsafe(`
      ALTER TABLE public.results ADD COLUMN IF NOT EXISTS confidence_score double precision;
    `);
    await prisma.$executeRawUnsafe(`
      ALTER TABLE public.results ADD COLUMN IF NOT EXISTS reasoning text;
    `);
    await prisma.$executeRawUnsafe(`
      ALTER TABLE public.results ADD COLUMN IF NOT EXISTS status text;
    `);

    // Perform updates
    await prisma.$executeRawUnsafe(`
      UPDATE public.users SET password_hash = '' WHERE password_hash IS NULL;
    `);
    await prisma.$executeRawUnsafe(`
      UPDATE public.users SET full_name = '' WHERE full_name IS NULL;
    `);
    await prisma.$executeRawUnsafe(`
      UPDATE public.results SET confidence_score = 0 WHERE confidence_score IS NULL;
    `);
    await prisma.$executeRawUnsafe(`
      UPDATE public.results SET reasoning = '' WHERE reasoning IS NULL;
    `);
    await prisma.$executeRawUnsafe(`
      UPDATE public.results SET status = 'check_required' WHERE status IS NULL;
    `);
    console.log('Successfully updated NULL values in users and results tables.');
  } catch (error) {
    console.error('Failed to drop constraint:', error);
  } finally {
    await prisma.$disconnect();
  }
}

main();
