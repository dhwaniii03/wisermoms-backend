import { PrismaClient } from '@prisma/client';
import { MotherOrgEnrollmentService } from '../src/modules/partner/mother-org-enrollment.service';

const prisma = new PrismaClient();
const svc = new MotherOrgEnrollmentService();

async function runTests() {
  console.log('--- Organization Search UAT Tests ---\n');

  // Test 1: Supported PA location
  const paRes = await svc.listOrganizations({ state: 'PA', county: 'Philadelphia', stateFallback: true });
  console.log('Test 1: PA Location (Philadelphia, PA)');
  console.log(`Match Level: ${paRes.matchLevel}`);
  console.log(`Count: ${paRes.organizations.length}`);
  paRes.organizations.forEach(o => console.log(` - ${o.name} [${o.service_area}]`));
  console.log();

  // Test 2: Existing GA location
  const gaRes = await svc.listOrganizations({ state: 'GA', county: 'Fulton', stateFallback: true });
  console.log('Test 2: GA Location (Fulton, GA)');
  console.log(`Match Level: ${gaRes.matchLevel}`);
  console.log(`Count: ${gaRes.organizations.length}`);
  gaRes.organizations.slice(0, 3).forEach(o => console.log(` - ${o.name} [${o.service_area}]`));
  if (gaRes.organizations.length > 3) console.log(` - ... and ${gaRes.organizations.length - 3} more`);
  console.log();

  // Test 3: Unsupported location
  const nyRes = await svc.listOrganizations({ state: 'NY', county: 'Queens', stateFallback: true });
  console.log('Test 3: Unsupported Location (Queens, NY)');
  console.log(`Match Level: ${nyRes.matchLevel}`);
  console.log(`Count: ${nyRes.organizations.length}`);
  console.log();

  // Test 4: Check for duplicates
  const allIds = new Set();
  let hasDuplicates = false;
  for (const org of gaRes.organizations) {
    if (allIds.has(org.id)) hasDuplicates = true;
    allIds.add(org.id);
  }
  console.log('Test 4: Duplicates in GA results?', hasDuplicates ? 'Yes' : 'No');

  await prisma.$disconnect();
}

runTests().catch(console.error);
