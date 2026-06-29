import { PrismaClient } from '@prisma/client';
import { AuthService } from '../src/modules/auth/auth.service';
import { EligibilityService } from '../src/modules/eligibility/eligibility.service';

const prisma = new PrismaClient();
const authService = new AuthService();
const eligibilityService = new EligibilityService();

async function main() {
  console.log("=== Testing Pennsylvania Eligibility Scan (Diagnostics) ===");

  const testEmail = `pa.test.${Date.now()}@example.com`;
  const registrationPayload = {
    email: testEmail,
    password: 'Password123!',
    first_name: 'Sarah',
    middle_name: 'Jane',
    last_name: 'Doe',
    phone: '2155550199',
    zip_code: '19103', // Philadelphia, PA
  };

  let testUserId: string | null = null;

  try {
    // 1. Register User
    console.log(`\n1. Registering user in PA: ${testEmail}...`);
    const session = await authService.register(registrationPayload);
    testUserId = session.user.id;
    console.log(`✅ Registered successfully. User ID: ${testUserId}`);

    // 2. Update Profile
    console.log("\n2. Updating family profile...");
    await prisma.familyProfile.update({
      where: { user_id: testUserId },
      data: {
        household_size: 3,
        num_children: 2,
        children_ages: [2, 4],
        monthly_income: 1800,
        employment_status: 'employed',
        needs_childcare: true,
        is_pregnant: false,
        has_disability: false,
        housing_status: 'stable',
        immigration_status: 'citizen',
      }
    });
    console.log("✅ Profile updated.");

    // 3. Run Eligibility Scan
    console.log("\n3. Executing eligibility scan...");
    const scanResult = await eligibilityService.runScan(testUserId);
    console.log(`✅ Scan returned ${scanResult.results.length} results.`);

    // 4. Retrieve directly from DB
    console.log("\n4. Retrieving directly from DB before filtering...");
    const rawResults = await prisma.eligibilityResult.findMany({
      where: { user_id: testUserId },
      include: { program: true }
    });
    console.log(`Found ${rawResults.length} raw results in DB.`);
    
    for (const r of rawResults) {
      console.log(`- DB Result Program: "${r.program?.name}" | state_code: "${r.program?.state_code}" | state: "${(r.program as any)?.state}" | federal_or_state: "${r.program?.federal_or_state}"`);
    }

    // 5. Get filtered results
    console.log("\n5. Get Results via EligibilityService...");
    const results = await eligibilityService.getResults(testUserId);
    console.log(`Service returned ${results.results.length} results.`);

  } catch (error) {
    console.error("\n❌ Test failed with error:", error);
  } finally {
    if (testUserId) {
      console.log("\nCleaning up...");
      await prisma.eligibilityResult.deleteMany({ where: { user_id: testUserId } });
      await prisma.notification.deleteMany({ where: { user_id: testUserId } });
      await prisma.familyProfile.deleteMany({ where: { user_id: testUserId } });
      await prisma.refreshToken.deleteMany({ where: { user_id: testUserId } });
      await prisma.user.delete({ where: { id: testUserId } });
      console.log("Cleanup complete.");
    }
    await prisma.$disconnect();
  }
}

main();
