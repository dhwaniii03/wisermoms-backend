import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

async function run() {
  const p = await prisma.benefitProgram.findMany({ select: { name: true, program_code: true } });
  const matches = p.filter(x => x.name.toLowerCase().includes('review') || x.name.toLowerCase().includes('additional'));
  console.log('Matches:', matches);
}

run().catch(console.error).finally(() => prisma.$disconnect());
