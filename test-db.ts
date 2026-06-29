import { PrismaClient } from '@prisma/client';
import dotenv from 'dotenv';

// Load the environment variables from .env
dotenv.config();

async function testConnection(url: string, name: string) {
  console.log(`\nTesting ${name}...`);
  const prisma = new PrismaClient({
    datasources: {
      db: {
        url: url,
      },
    },
  });

  try {
    await prisma.$queryRaw`SELECT 1`;
    console.log(`✅ SUCCESS: Connected using ${name}!`);
    return true;
  } catch (error: any) {
    console.error(`❌ FAILED: ${name}`);
    console.error(error.message);
    return false;
  } finally {
    await prisma.$disconnect();
  }
}

async function main() {
  const defaultUrl = process.env.DATABASE_URL || '';
  
  // Try the provided pooler URL first
  const success1 = await testConnection(defaultUrl, 'Default DATABASE_URL');
  
  if (!success1) {
    // If it fails with Tenant Not Found, try the traditional direct Supabase host format
    console.log('\nSince the pooler failed, trying the traditional direct connection (IPv4/IPv6)...');
    
    // Extract password from DATABASE_URL
    const pwdMatch = defaultUrl.match(/:([^:]+)@/);
    const pwd = pwdMatch ? pwdMatch[1] : 'Beetel1234%24';
    
    // Traditional direct URL format: postgresql://postgres:PASSWORD@db.[PROJECT-REF].supabase.co:5432/postgres
    const traditionalUrl = `postgresql://postgres:${pwd}@db.rskhycwjcaxmujhqslyq.supabase.co:5432/postgres`;
    await testConnection(traditionalUrl, 'Traditional Direct URL');
  }
}

main();
