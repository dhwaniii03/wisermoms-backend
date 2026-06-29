import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

async function run() {
  const p = await prisma.benefitProgram.findMany({
    where: {
      OR: [
        { name: { contains: 'review', mode: 'insensitive' } },
        { id: { contains: 'review', mode: 'insensitive' } }
      ]
    }
  });
  console.log(JSON.stringify(p, null, 2));
}

run().catch(console.error).finally(() => prisma.$disconnect());
