import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log("=== Checking Pennsylvania Programs in Database ===");
  const allPrograms = await prisma.benefitProgram.findMany({
    select: {
      id: true,
      name: true,
      state_code: true,
      is_active: true,
      federal_or_state: true,
      metadata: true,
    }
  });

  console.log(`Total programs: ${allPrograms.length}`);
  
  const paPrograms = allPrograms.filter(p => p.state_code === 'PA');
  console.log(`\nPA Programs found (${paPrograms.length}):`);
  for (const p of paPrograms) {
    console.log(`- Name: ${p.name} | Active: ${p.is_active} | Fed/State: ${p.federal_or_state} | Metadata: ${JSON.stringify(p.metadata)}`);
  }

  const gaPrograms = allPrograms.filter(p => p.state_code === 'GA');
  console.log(`\nGA Programs found (${gaPrograms.length}):`);
  for (const p of gaPrograms) {
    console.log(`- Name: ${p.name} | Active: ${p.is_active} | Fed/State: ${p.federal_or_state}`);
  }

  const fedPrograms = allPrograms.filter(p => !p.state_code);
  console.log(`\nFederal Programs found (${fedPrograms.length}):`);
  for (const p of fedPrograms) {
    console.log(`- Name: ${p.name} | Active: ${p.is_active} | Fed/State: ${p.federal_or_state}`);
  }
}

main().catch(console.error).finally(() => prisma.$disconnect());
