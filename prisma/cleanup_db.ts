import { PrismaClient } from '@prisma/client';
import dotenv from 'dotenv';

dotenv.config();

const SUPABASE_URL = process.env.DATABASE_URL || "";

async function main() {
  console.log('Connecting to Supabase to perform database cleanup...');
  const prisma = new PrismaClient({
    datasources: {
      db: { url: SUPABASE_URL },
    },
  });

  try {
    // 1. Clean up duplicate results (EligibilityResult)
    console.log('\n--- 1. Deduplicating results (EligibilityResult) table ---');
    const duplicateResults = await prisma.$queryRawUnsafe<any[]>(`
      SELECT user_id, program_id, COUNT(*) as cnt
      FROM public.results
      GROUP BY user_id, program_id
      HAVING COUNT(*) > 1;
    `);

    console.log(`Found ${duplicateResults.length} duplicate (user_id, program_id) groups in results table.`);
    
    for (const dup of duplicateResults) {
      const userId = dup.user_id;
      const programId = dup.program_id;
      
      // Fetch all rows for this pair, ordered by created_at or checked_at descending
      const rows = await prisma.$queryRawUnsafe<any[]>(`
        SELECT id, COALESCE(created_at, checked_at) as time 
        FROM public.results
        WHERE user_id = $1::uuid AND program_id = $2::uuid
        ORDER BY COALESCE(created_at, checked_at) DESC, id DESC;
      `, userId, programId);

      console.log(`Group (user_id: ${userId}, program_id: ${programId}) has ${rows.length} rows. Keeping row: ${rows[0].id}`);

      // Delete all except the first row
      const idsToDelete = rows.slice(1).map(r => r.id);
      for (const id of idsToDelete) {
        await prisma.$executeRawUnsafe(`
          DELETE FROM public.results WHERE id = $1::uuid;
        `, id);
      }
      console.log(`Deleted ${idsToDelete.length} duplicate rows.`);
    }

    // 2. Clean up duplicate profiles (FamilyProfile)
    console.log('\n--- 2. Deduplicating profiles (FamilyProfile) table ---');
    const duplicateProfiles = await prisma.$queryRawUnsafe<any[]>(`
      SELECT user_id, COUNT(*) as cnt
      FROM public.profiles
      GROUP BY user_id
      HAVING COUNT(*) > 1;
    `);

    console.log(`Found ${duplicateProfiles.length} duplicate user_id groups in profiles table.`);
    for (const dup of duplicateProfiles) {
      const userId = dup.user_id;
      const rows = await prisma.$queryRawUnsafe<any[]>(`
        SELECT id, updated_at 
        FROM public.profiles
        WHERE user_id = $1::uuid
        ORDER BY updated_at DESC, id DESC;
      `, userId);

      console.log(`Group (user_id: ${userId}) has ${rows.length} rows. Keeping row: ${rows[0].id}`);
      const idsToDelete = rows.slice(1).map(r => r.id);
      for (const id of idsToDelete) {
        await prisma.$executeRawUnsafe(`
          DELETE FROM public.profiles WHERE id = $1::uuid;
        `, id);
      }
      console.log(`Deleted ${idsToDelete.length} duplicate rows.`);
    }

    // 3. Clean up duplicate users (User)
    console.log('\n--- 3. Deduplicating users (User) table ---');
    const duplicateUsers = await prisma.$queryRawUnsafe<any[]>(`
      SELECT email, COUNT(*) as cnt
      FROM public.users
      GROUP BY email
      HAVING COUNT(*) > 1;
    `);

    console.log(`Found ${duplicateUsers.length} duplicate email groups in users table.`);
    for (const dup of duplicateUsers) {
      const email = dup.email;
      const rows = await prisma.$queryRawUnsafe<any[]>(`
        SELECT id, updated_at 
        FROM public.users
        WHERE email = $1
        ORDER BY updated_at DESC, id DESC;
      `, email);

      console.log(`Group (email: ${email}) has ${rows.length} rows. Keeping row: ${rows[0].id}`);
      const idsToDelete = rows.slice(1).map(r => r.id);
      for (const id of idsToDelete) {
        // Cascade delete manually just in case
        await prisma.$executeRawUnsafe(`DELETE FROM public.results WHERE user_id = $1::uuid;`, id);
        await prisma.$executeRawUnsafe(`DELETE FROM public.profiles WHERE user_id = $1::uuid;`, id);
        await prisma.$executeRawUnsafe(`DELETE FROM public.users WHERE id = $1::uuid;`, id);
      }
      console.log(`Deleted ${idsToDelete.length} duplicate users.`);
    }

    console.log('\n--- Database cleanup completed successfully! ---');
  } catch (error) {
    console.error('Cleanup failed:', error);
  } finally {
    await prisma.$disconnect();
  }
}

main();
