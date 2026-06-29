import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  const apps = await prisma.application.findMany({
    where: { program_id: null },
    include: { program: true },
  });
  console.log('Total null program_id apps:', apps.length);
  for (const app of apps) {
    console.log(app.id, app.program_id, app.status, app.last_updated_at);
  }
}

main().finally(() => prisma.$disconnect());
