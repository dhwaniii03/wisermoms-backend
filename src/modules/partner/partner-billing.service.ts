import { prisma } from '../../config/prisma';
import { NotFoundError, BadRequestError } from '../../utils/errors';
import {
  BillingService,
  getPartnerBillingUrls,
  type BillingRedirectUrls,
} from '../billing/billing.service';
import { splitFullName } from '../../utils/name.utils';

const billingService = new BillingService();
const partnerUrls = getPartnerBillingUrls();

export class PartnerBillingService {
  async resolveBillingUserId(orgId: string): Promise<string> {
    const org = await prisma.organization.findUnique({
      where: { id: orgId },
      include: {
        org_users: {
          where: { role: 'admin', is_active: true },
          orderBy: { created_at: 'asc' },
          take: 1,
        },
      },
    });

    if (!org) throw new NotFoundError('Organization not found');
    if (org.billing_user_id) return org.billing_user_id;

    const admin = org.org_users[0];
    if (!admin) {
      throw new BadRequestError('No organization admin found for billing');
    }

    let billingUser = await prisma.user.findUnique({ where: { email: admin.email } });

    if (!billingUser) {
      const nameParts = splitFullName(admin.full_name);
      billingUser = await prisma.user.create({
        data: {
          email: admin.email,
          first_name: nameParts.first_name,
          middle_name: nameParts.middle_name,
          last_name: nameParts.last_name,
          org_id: orgId,
        },
      });
    } else if (!billingUser.org_id) {
      billingUser = await prisma.user.update({
        where: { id: billingUser.id },
        data: { org_id: orgId },
      });
    }

    await prisma.organization.update({
      where: { id: orgId },
      data: { billing_user_id: billingUser.id },
    });

    return billingUser.id;
  }

  private urls(): BillingRedirectUrls {
    return partnerUrls;
  }

  async createCheckout(orgId: string, plan: string, interval?: string) {
    const userId = await this.resolveBillingUserId(orgId);
    return billingService.createCheckoutSession(userId, plan, interval, this.urls());
  }

  async activateCommunity(orgId: string) {
    const userId = await this.resolveBillingUserId(orgId);
    return billingService.activateCommunityPlan(userId);
  }

  async upgrade(orgId: string, plan: string, interval?: string) {
    const userId = await this.resolveBillingUserId(orgId);
    return billingService.upgradeSubscription(userId, plan, interval, this.urls());
  }

  async downgrade(orgId: string, plan: string, interval?: string) {
    const userId = await this.resolveBillingUserId(orgId);
    return billingService.downgradeSubscription(userId, plan, interval);
  }

  async cancel(orgId: string) {
    const userId = await this.resolveBillingUserId(orgId);
    return billingService.cancelSubscription(userId);
  }

  async reactivate(orgId: string) {
    const userId = await this.resolveBillingUserId(orgId);
    return billingService.reactivateSubscription(userId);
  }

  async portal(orgId: string) {
    const userId = await this.resolveBillingUserId(orgId);
    return billingService.createPortalSession(userId, this.urls());
  }

  async subscription(orgId: string) {
    const userId = await this.resolveBillingUserId(orgId);
    return billingService.getSubscriptionStatus(userId);
  }
}

/** Create and link a billing user when a partner organization is registered. */
export async function createPartnerBillingUser(
  orgId: string,
  admin: { email: string; full_name: string }
): Promise<string> {
  const nameParts = splitFullName(admin.full_name);
  const billingUser = await prisma.user.create({
    data: {
      email: admin.email,
      first_name: nameParts.first_name,
      middle_name: nameParts.middle_name,
      last_name: nameParts.last_name,
      org_id: orgId,
    },
  });

  await prisma.organization.update({
    where: { id: orgId },
    data: { billing_user_id: billingUser.id },
  });

  return billingUser.id;
}
