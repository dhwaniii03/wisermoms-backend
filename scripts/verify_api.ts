import { PrismaClient, UserRole } from '@prisma/client';
import { ApplicationsService } from '../src/modules/applications/applications.service';

const prisma = new PrismaClient();

async function run() {
  const service = new ApplicationsService();
  
  // Find a user who has a Medicaid application
  const app = await prisma.application.findFirst({
    where: { program_id: 'medicaid' },
  });

  if (!app) {
    console.log("No Medicaid applications found.");
    return;
  }

  console.log(`Testing user: ${app.user_id}`);
  
  // 1. Get current applications list
  const applications = await service.listApplications(app.user_id, UserRole.user, {});
  
  console.log("\n--- Applications returned by listApplications API ---");
  for (const a of applications) {
    console.log(`Program: ${a.program_id} | Status: ${a.status} | Last Updated: ${a.last_updated_at}`);
  }

  // Check if Medicaid is there
  const medicaidApp = applications.find(a => a.program_id === 'medicaid');
  if (medicaidApp) {
    console.log(`\n✅ Medicaid application IS visible in the list (status: ${medicaidApp.status})`);
  } else {
    console.log('\n❌ Medicaid application is NOT visible in the list.');
  }

}

run().catch(console.error).finally(() => prisma.$disconnect());
