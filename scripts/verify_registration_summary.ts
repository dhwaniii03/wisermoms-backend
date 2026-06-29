import { PrismaClient } from '@prisma/client';
import { AuthService } from '../src/modules/auth/auth.service';
import { UserService } from '../src/modules/user/user.service';
import { z } from 'zod';

const prisma = new PrismaClient();
const authService = new AuthService();
const userService = new UserService();

// Exact replica of the frontend profileResponseSchema in useUserProfile.ts
const profileResponseSchema = z.object({
  id: z.string(),
  email: z.string().email("Invalid email format"),
  first_name: z.string().min(1, "First name is required"),
  last_name: z.string().min(1, "Last name is required"),
  phone: z.string().nullable().optional(),
  state: z.string().nullable().optional(),
  zip_code: z.string().nullable().optional(),
  org_type: z.string().nullable().optional(),
  org_id: z.string().nullable().optional(),
  organization: z
    .object({
      id: z.string(),
      name: z.string(),
      city: z.string().nullable().optional(),
      state: z.string().nullable().optional(),
    })
    .nullable()
    .optional(),
  family_profile: z
    .object({
      household_size: z.number().nullable().optional(),
      num_children: z.number().nullable().optional(),
      monthly_income: z.number().nullable().optional(),
      employment_status: z.string().nullable().optional(),
      housing_status: z.string().nullable().optional(),
      has_disability: z.boolean().nullable().optional(),
      is_pregnant: z.boolean().nullable().optional(),
      date_of_birth: z.string().nullable().optional(),
      street_address: z.string().nullable().optional(),
      city: z.string().nullable().optional(),
      state: z.string().nullable().optional(),
      zip_code: z.string().nullable().optional(),
      county: z.string().nullable().optional(),
    })
    .nullable()
    .optional(),
});

async function main() {
  console.log("=== Registration Summary Data Validation Test ===");

  const testEmail = `jane.smith.val.${Date.now()}@example.com`;
  const registrationPayload = {
    email: testEmail,
    password: 'Password123!',
    first_name: 'Jane',
    middle_name: 'Anne',
    last_name: 'Smith',
    phone: '5550100101',
    zip_code: '30030', // Decatur, GA (DeKalb County)
  };

  let testUserId: string | null = null;

  try {
    // 1. Perform Registration
    console.log(`\n1. Registering user: ${testEmail}...`);
    const session = await authService.register(registrationPayload);
    testUserId = session.user.id;
    console.log(`✅ Registered successfully. User ID: ${testUserId}`);

    // 2. Fetch Profile from UserService (the definitive source of truth from database)
    console.log("\n2. Fetching profile using UserService.getProfile...");
    const rawProfile = await userService.getProfile(testUserId);
    
    // Serialize it to simulate JSON response over Express/HTTP
    const serializedProfile = JSON.parse(JSON.stringify(rawProfile));
    console.log("✅ Profile fetched successfully. Data details:");
    console.log(`   Name: ${serializedProfile.first_name} ${serializedProfile.middle_name} ${serializedProfile.last_name}`);
    console.log(`   Email: ${serializedProfile.email}`);
    console.log(`   Phone: ${serializedProfile.phone}`);
    console.log(`   ZIP code: ${serializedProfile.zip_code}`);
    console.log(`   State: ${serializedProfile.state}`);
    console.log(`   City: ${serializedProfile.city}`);
    console.log(`   County: ${serializedProfile.county}`);

    // 3. Verify Zod Schema Validation
    console.log("\n3. Validating profile response structure using frontend's Zod Schema...");
    const validationResult = profileResponseSchema.safeParse(serializedProfile);
    if (validationResult.success) {
      console.log("✅ Zod Validation: PASS. Structure conforms perfectly to the frontend expectations.");
    } else {
      console.log("❌ Zod Validation: FAIL.");
      console.error(validationResult.error.format());
      throw new Error("Zod schema validation failed");
    }

    // 4. Assert all submitted fields match database values
    console.log("\n4. Verifying correctness of submitted information...");
    
    const errors: string[] = [];
    if (serializedProfile.first_name !== registrationPayload.first_name) {
      errors.push(`First Name mismatch: expected '${registrationPayload.first_name}', got '${serializedProfile.first_name}'`);
    }
    if (serializedProfile.middle_name !== registrationPayload.middle_name) {
      errors.push(`Middle Name mismatch: expected '${registrationPayload.middle_name}', got '${serializedProfile.middle_name}'`);
    }
    if (serializedProfile.last_name !== registrationPayload.last_name) {
      errors.push(`Last Name mismatch: expected '${registrationPayload.last_name}', got '${serializedProfile.last_name}'`);
    }
    if (serializedProfile.email !== registrationPayload.email) {
      errors.push(`Email mismatch: expected '${registrationPayload.email}', got '${serializedProfile.email}'`);
    }
    if (serializedProfile.phone !== registrationPayload.phone) {
      errors.push(`Phone mismatch: expected '${registrationPayload.phone}', got '${serializedProfile.phone}'`);
    }
    if (serializedProfile.zip_code !== registrationPayload.zip_code) {
      errors.push(`ZIP Code mismatch: expected '${registrationPayload.zip_code}', got '${serializedProfile.zip_code}'`);
    }
    if (serializedProfile.state !== 'GA') {
      errors.push(`State mismatch: expected 'GA' (derived from ZIP), got '${serializedProfile.state}'`);
    }
    if (serializedProfile.city !== 'Decatur') {
      errors.push(`City mismatch: expected 'Decatur' (derived from ZIP), got '${serializedProfile.city}'`);
    }
    if (serializedProfile.county !== 'DEKALB') {
      errors.push(`County mismatch: expected 'DEKALB' (derived from ZIP), got '${serializedProfile.county}'`);
    }

    // Validate family_profile nested fields
    const fp = serializedProfile.family_profile;
    if (!fp) {
      errors.push("Missing family_profile object in response.");
    } else {
      if (fp.city !== 'Decatur') {
        errors.push(`family_profile.city mismatch: expected 'Decatur', got '${fp.city}'`);
      }
      if (fp.state !== 'GA') {
        errors.push(`family_profile.state mismatch: expected 'GA', got '${fp.state}'`);
      }
      if (fp.zip_code !== registrationPayload.zip_code) {
        errors.push(`family_profile.zip_code mismatch: expected '${registrationPayload.zip_code}', got '${fp.zip_code}'`);
      }
      if (fp.county !== 'DEKALB') {
        errors.push(`family_profile.county mismatch: expected 'DEKALB', got '${fp.county}'`);
      }
    }

    if (errors.length === 0) {
      console.log("✅ All submitted information matches stored database data exactly.");
    } else {
      console.log("❌ Mismatches found:");
      errors.forEach(err => console.log(`   - ${err}`));
      throw new Error("Verification failed due to mismatches");
    }

    // 5. Verify no missing fields and formatting issues
    console.log("\n5. Checking for missing required fields or formatting issues...");
    if (!serializedProfile.id) errors.push("Missing User ID");
    if (!serializedProfile.email) errors.push("Missing Email");
    if (!serializedProfile.first_name) errors.push("Missing First Name");
    if (!serializedProfile.last_name) errors.push("Missing Last Name");
    if (!serializedProfile.state) errors.push("Missing State");
    if (!serializedProfile.city) errors.push("Missing City");
    if (!serializedProfile.zip_code) errors.push("Missing ZIP code");
    if (!serializedProfile.county) errors.push("Missing County");

    if (errors.length === 0) {
      console.log("✅ No missing required fields or formatting issues found.");
    } else {
      throw new Error("Formatting/Completeness check failed");
    }

    console.log("\n🏆 OVERALL TEST RESULT: PASS");
  } catch (error) {
    console.error("\n❌ Test Execution Failed:", error);
    console.log("\n🏆 OVERALL TEST RESULT: FAIL");
    process.exit(1);
  } finally {
    if (testUserId) {
      console.log("\nCleaning up: deleting test user database records...");
      await prisma.familyProfile.deleteMany({ where: { user_id: testUserId } });
      await prisma.refreshToken.deleteMany({ where: { user_id: testUserId } });
      await prisma.user.delete({ where: { id: testUserId } });
      console.log("Cleanup complete.");
    }
    await prisma.$disconnect();
  }
}

main();
