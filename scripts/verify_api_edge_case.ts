import { PrismaClient, UserRole } from '@prisma/client';
import { ApplicationsService } from '../src/modules/applications/applications.service';

const prisma = new PrismaClient();

async function run() {
  const service = new ApplicationsService();
  
  const user = await prisma.user.findFirst();

  if (!user) {
    console.log("No demo user found.");
    return;
  }

  // Delete all medicaid applications for this user
  await prisma.application.deleteMany({
    where: { user_id: user.id, program_id: 'medicaid' }
  });

  // Create an OLD under_review application
  const oldDate = new Date();
  oldDate.setDate(oldDate.getDate() - 30);
  
  await prisma.application.create({
    data: {
      user_id: user.id,
      program_id: 'medicaid',
      status: 'under_review',
      priority: 'normal',
      last_updated_at: oldDate,
      submitted_at: oldDate
    }
  });

  // Create a NEW submitted application
  const newDate = new Date();
  await prisma.application.create({
    data: {
      user_id: user.id,
      program_id: 'medicaid',
      status: 'submitted',
      priority: 'normal',
      last_updated_at: newDate,
      submitted_at: newDate
    }
  });

  console.log(`Testing user: ${user.id}`);
  
  // 1. Get current applications list
  const applications = await service.listApplications(user.id, UserRole.user, {});
  
  console.log("\n--- Applications returned by listApplications API ---");
  for (const a of applications) {
    if (a.program_id === 'medicaid') {
      console.log(`Program: ${a.program_id} | Status: ${a.status} | Last Updated: ${a.last_updated_at}`);
    }
  }

  // Check if Medicaid is there and its status is 'submitted'
  const medicaidApp = applications.find(a => a.program_id === 'medicaid');
  if (medicaidApp && medicaidApp.status === 'submitted') {
    console.log(`\n✅ Medicaid application IS visible in the list and correctly shows the NEW submitted status!`);
  } else {
    console.log(`\n❌ Medicaid application failed test. It is either hidden or shows the wrong status: ${medicaidApp?.status}`);
  }

}

run().catch(console.error).finally(() => prisma.$disconnect());
