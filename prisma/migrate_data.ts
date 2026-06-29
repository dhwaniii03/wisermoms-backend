import { PrismaClient } from '@prisma/client';
import dotenv from 'dotenv';

dotenv.config();

const NEON_URL = process.env.NEON_DATABASE_URL || "";
const SUPABASE_URL = process.env.DATABASE_URL || "";

async function main() {
  console.log('Initializing Prisma clients...');
  const neon = new PrismaClient({
    datasources: {
      db: { url: NEON_URL },
    },
  });

  const supabase = new PrismaClient({
    datasources: {
      db: { url: SUPABASE_URL },
    },
  });

  try {
    console.log('Ensuring essential database columns exist on Supabase...');
    await supabase.$executeRawUnsafe(`
      ALTER TABLE public.users ADD COLUMN IF NOT EXISTS password_hash text;
    `);
    await supabase.$executeRawUnsafe(`
      ALTER TABLE public.users ADD COLUMN IF NOT EXISTS updated_at timestamp with time zone DEFAULT now();
    `);
    await supabase.$executeRawUnsafe(`
      ALTER TABLE public.users ADD COLUMN IF NOT EXISTS last_active_at timestamp with time zone DEFAULT now();
    `);
    await supabase.$executeRawUnsafe(`
      ALTER TABLE public.documents ADD COLUMN IF NOT EXISTS storage_path text;
    `);

    // 1. Migrate Users
    console.log('Fetching users from Neon...');
    const users = await neon.user.findMany();
    console.log(`Found ${users.length} users in Neon. Migrating to Supabase...`);
    for (const user of users) {
      const cleanUser = {
        id: user.id,
        email: user.email,
        password_hash: user.password_hash ?? '',
        first_name: user.first_name ?? '',
        middle_name: user.middle_name,
        last_name: user.last_name ?? '',
        phone: user.phone,
        role: user.role,
        stripe_customer_id: user.stripe_customer_id,
        stripe_subscription_id: user.stripe_subscription_id,
        state: user.state,
        zip_code: user.zip_code,
        status: user.status,
        profile_picture: user.profile_picture,
        last_active_at: user.last_active_at,
        created_at: user.created_at,
        updated_at: user.updated_at,
      };
      await supabase.user.upsert({
        where: { id: user.id },
        update: cleanUser,
        create: cleanUser,
      });
    }
    console.log('Users migrated successfully.');

    // 2. Migrate Benefit Programs
    console.log('Fetching programs from Neon...');
    const programs = await neon.benefitProgram.findMany();
    console.log(`Found ${programs.length} programs in Neon. Migrating...`);
    for (const prog of programs) {
      await supabase.benefitProgram.upsert({
        where: { id: prog.id },
        update: prog,
        create: prog,
      });
    }
    console.log('Programs migrated successfully.');

    // 3. Migrate Family Profiles
    console.log('Fetching family profiles from Neon...');
    const profiles = await neon.familyProfile.findMany();
    console.log(`Found ${profiles.length} profiles in Neon. Migrating...`);
    for (const profile of profiles) {
      await supabase.familyProfile.upsert({
        where: { id: profile.id },
        update: profile,
        create: profile,
      });
    }
    console.log('Family profiles migrated successfully.');

    // 4. Migrate Applications
    console.log('Fetching applications from Neon...');
    const apps = await neon.application.findMany();
    console.log(`Found ${apps.length} applications in Neon. Migrating...`);
    for (const app of apps) {
      await supabase.application.upsert({
        where: { id: app.id },
        update: app,
        create: app,
      });
    }
    console.log('Applications migrated successfully.');

    // 5. Migrate Documents
    console.log('Fetching documents from Neon...');
    const docs = await neon.document.findMany();
    console.log(`Found ${docs.length} documents in Neon. Migrating...`);
    for (const doc of docs) {
      await supabase.document.upsert({
        where: { id: doc.id },
        update: doc,
        create: doc,
      });
    }
    console.log('Documents migrated successfully.');

    // 6. Migrate Eligibility Results
    console.log('Fetching eligibility results from Neon...');
    const results = await neon.eligibilityResult.findMany();
    console.log(`Found ${results.length} results in Neon. Migrating...`);
    for (const res of results) {
      await supabase.eligibilityResult.upsert({
        where: {
          user_id_program_id: {
            user_id: res.user_id,
            program_id: res.program_id,
          },
        },
        update: res,
        create: res,
      });
    }
    console.log('Eligibility results migrated successfully.');

    // 7. Migrate Generated PDFs
    console.log('Fetching generated PDFs from Neon...');
    const pdfs = await neon.generatedPdf.findMany();
    console.log(`Found ${pdfs.length} PDFs in Neon. Migrating...`);
    for (const pdf of pdfs) {
      await supabase.generatedPdf.upsert({
        where: { id: pdf.id },
        update: pdf,
        create: pdf,
      });
    }
    console.log('Generated PDFs migrated successfully.');

    console.log('--- Migration completed successfully! ---');
  } catch (error) {
    console.error('Migration failed:', error);
  } finally {
    await neon.$disconnect();
    await supabase.$disconnect();
  }
}

main();
