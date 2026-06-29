import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

async function run() {
  const p = await prisma.benefitProgram.findMany({
    where: { agency: null },
    select: { id: true, name: true, state_code: true }
  });
  console.log(JSON.stringify(p, null, 2));
}

run().catch(console.error).finally(() => prisma.$disconnect());
