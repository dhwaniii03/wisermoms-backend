import { prisma } from '../src/config/prisma';
import { toPublicOrganization, organizationPublicSelect } from '../src/utils/organization.utils';

async function main() {
  const pa = await prisma.organization.findMany({
    where: { state: { equals: 'PA', mode: 'insensitive' } },
    select: organizationPublicSelect,
  });
  for (const org of pa) {
    const pub = toPublicOrganization(org);
    console.log({ name: org.org_name, category: org.category, org_type: org.org_type, apiType: pub.type });
  }
  await prisma.$disconnect();
}

main();
