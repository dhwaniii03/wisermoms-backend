import { env } from '../../config/env';
import { prisma } from '../../config/prisma';
import { EligibilityService } from '../../modules/eligibility/eligibility.service';

const eligibilityService = new EligibilityService();

export const runEligibilityRefreshTask = async () => {
  try {
    console.log('🤖 Running weekly eligibility-refresh background scan job...');

    // Find active users who have configured a family profile
    const users = await prisma.user.findMany({
      where: {
        status: 'active',
        family_profile: { isNot: null },
      },
      select: { id: true },
    });

    for (const user of users) {
      try {
        await eligibilityService.runScan(user.id);
      } catch (err: any) {
        console.error(`Failed automated weekly scan for user ${user.id}:`, err.message);
      }
    }

    console.log('✅ Weekly eligibility-refresh scan job finished successfully.');
  } catch (err: any) {
    console.error('❌ Eligibility refresh job failed with error:', err.message);
  }
};
