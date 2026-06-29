import { PrismaClient } from '@prisma/client';
import dotenv from 'dotenv';

dotenv.config();

const SUPABASE_URL = process.env.DATABASE_URL || "";

async function main() {
  console.log('Connecting to Supabase to check for duplicate results...');
  const prisma = new PrismaClient({
    datasources: {
      db: { url: SUPABASE_URL },
    },
  });

  try {
    // Check if results table exists and query its columns
    const columns = await prisma.$queryRawUnsafe<any[]>(`
      SELECT column_name 
      FROM information_schema.columns 
      WHERE table_schema = 'public' AND table_name = 'results';
    `);
    console.log('Columns in results table:', columns.map(c => c.column_name));

    // Query for duplicate (user_id, program_id) pairs
    const duplicates = await prisma.$queryRawUnsafe<any[]>(`
      SELECT user_id, program_id, COUNT(*) as cnt
      FROM public.results
      GROUP BY user_id, program_id
      HAVING COUNT(*) > 1;
    `);

    console.log(`Found ${duplicates.length} duplicate (user_id, program_id) groups:`);
    console.log(duplicates);

    if (duplicates.length > 0) {
      console.log('Cleaning up duplicates...');
      for (const dup of duplicates) {
        const userId = dup.user_id;
        const programId = dup.program_id;
        console.log(`Cleaning up user_id: ${userId}, program_id: ${programId}`);

        // Fetch all rows for this pair
        const rows = await prisma.$queryRawUnsafe<any[]>(`
          SELECT id, created_at, checked_at 
          FROM public.results
          WHERE user_id = $1::uuid AND program_id = $2::uuid
          ORDER BY COALESCE(created_at, checked_at) DESC;
        `, userId, programId);

        console.log(`Found ${rows.length} rows. Keeping the first one:`, rows[0]);

        // Keep the first row, delete the rest
        const idsToDelete = rows.slice(1).map(r => r.id);
        for (const id of idsToDelete) {
          await prisma.$executeRawUnsafe(`
            DELETE FROM public.results WHERE id = $1::uuid;
          `, id);
          console.log(`Deleted row ID: ${id}`);
        }
      }
      console.log('Deduplication complete.');
    } else {
      console.log('No duplicate (user_id, program_id) records found.');
    }
  } catch (error) {
    console.error('An error occurred:', error);
  } finally {
    await prisma.$disconnect();
  }
}

main();
