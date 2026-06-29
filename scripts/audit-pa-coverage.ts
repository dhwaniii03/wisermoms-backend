import { prisma } from '../src/config/prisma';
import { MotherOrgEnrollmentService } from '../src/modules/partner/mother-org-enrollment.service';
import { zipValidationService } from '../src/services/zipValidation.service';

const svc = new MotherOrgEnrollmentService();

const TEST_ZIPS = ['19103', '15213', '17101', '19003'];

async function main() {
  console.log('=== Pennsylvania Organization Coverage Audit ===\n');

  const byState = await prisma.organization.groupBy({
    by: ['state'],
    _count: true,
    orderBy: { state: 'asc' },
  });
  console.log('Organizations by state:', byState);

  const paOrgs = await prisma.organization.findMany({
    where: { state: { equals: 'PA', mode: 'insensitive' }, active: true },
    select: {
      org_name: true,
      city: true,
      county: true,
      counties_served: true,
      zip_code: true,
    },
    orderBy: { org_name: 'asc' },
  });
  console.log(`\nActive PA organizations (${paOrgs.length}):`);
  for (const org of paOrgs) {
    console.log(`  - ${org.org_name}`);
    console.log(`    counties_served: ${JSON.stringify(org.counties_served)}`);
  }

  const typoOrgs = await prisma.organization.count({
    where: { counties_served: { has: 'Philidelphia' } },
  });
  console.log(`\nOrgs with "Philidelphia" typo in counties_served: ${typoOrgs}`);

  const emptyServed = await prisma.organization.count({
    where: { state: { equals: 'PA', mode: 'insensitive' }, counties_served: { isEmpty: true } },
  });
  console.log(`PA orgs with empty counties_served: ${emptyServed}`);

  console.log('\n--- ZIP → organization lookup simulation ---');
  for (const zip of TEST_ZIPS) {
    const lookup = zipValidationService.lookupZip(zip);
    if (!lookup.state || !lookup.counties.length) {
      console.log(`\nZIP ${zip}: lookup failed — ${lookup.error ?? 'no data'}`);
      continue;
    }

    const county = lookup.counties[0];
    const result = await svc.listOrganizations({
      state: lookup.state,
      county,
      stateFallback: true,
    });

    console.log(`\nZIP ${zip} → ${lookup.city}, ${lookup.state}, county ${county}`);
    console.log(`  matchLevel: ${result.matchLevel}`);
    console.log(`  organizations (${result.organizations.length}):`);
    for (const org of result.organizations) {
      console.log(`    - ${org.name}`);
    }
  }

  await prisma.$disconnect();
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
