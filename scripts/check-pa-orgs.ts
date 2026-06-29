import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

async function run() {
  const orgs = await prisma.organization.findMany({ 
    where: { 
      OR: [
        { state: { equals: 'PA', mode: 'insensitive' } }, 
        { city: { contains: 'philadelphia', mode: 'insensitive' } }, 
        { org_name: { contains: 'pennsylvania', mode: 'insensitive' } },
        { counties_served: { hasSome: ['Philidelphia', 'philidelphia'] } }
      ] 
    } 
  });
  console.log(JSON.stringify(orgs.map(o => ({ id: o.id, name: o.org_name, counties_served: o.counties_served, state: o.state })), null, 2));
  await prisma.$disconnect();
}

run();
