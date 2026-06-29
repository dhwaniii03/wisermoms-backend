import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

async function run() {
  console.log('Auditing and patching PA organizations...');
  const paOrgs = await prisma.organization.findMany({ where: { state: 'PA' } });
  
  let patchedCount = 0;

  for (const org of paOrgs) {
    let changed = false;
    let newCounties = [...org.counties_served];

    // Fix known typos
    if (newCounties.includes('Philidelphia')) {
      newCounties = newCounties.map(c => c === 'Philidelphia' ? 'Philadelphia' : c);
      changed = true;
    }

    // Standardize empty arrays to 'statewide' for clarity
    if (newCounties.length === 0) {
      newCounties = ['statewide'];
      changed = true;
    }

    if (changed) {
      console.log(`Patching org ${org.id} (${org.org_name})`);
      console.log(`  Counties: ${JSON.stringify(org.counties_served)} -> ${JSON.stringify(newCounties)}`);
      await prisma.organization.update({
        where: { id: org.id },
        data: { counties_served: newCounties }
      });
      patchedCount++;
    }
  }

  console.log(`Done. Patched ${patchedCount} organizations.`);
  await prisma.$disconnect();
}

run().catch(e => {
  console.error(e);
  process.exit(1);
});
