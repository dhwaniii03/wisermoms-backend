import { UserPlan } from '@prisma/client';
import { env } from '../../config/env';

export const ORG_PLANS = ['community', 'partner', 'network'] as const;
export type OrgPlanId = (typeof ORG_PLANS)[number];

export const BILLABLE_PLANS: OrgPlanId[] = ['partner', 'network'];

export const BILLING_INTERVALS = ['monthly', 'yearly'] as const;
export type BillingInterval = (typeof BILLING_INTERVALS)[number];

export const PLAN_HIERARCHY: Record<OrgPlanId, number> = {
  community: 0,
  partner: 1,
  network: 2,
};

export interface PlanConfig {
  id: OrgPlanId;
  displayName: string;
  /** Monthly amount in cents — validated on backend only */
  monthlyAmountCents: number;
  /** Annual amount in cents — validated on backend only */
  annualAmountCents: number;
  stripePriceIdMonthly: string | null;
  stripePriceIdAnnual: string | null;
}

export function isMockStripeMode(): boolean {
  return env.MOCK_STRIPE_PAYMENTS || env.STRIPE_SECRET_KEY.includes('placeholder');
}

export function getPlanConfig(plan: string): PlanConfig | null {
  const configs = getAllPlanConfigs();
  return configs[plan as OrgPlanId] ?? null;
}

export function getAllPlanConfigs(): Record<OrgPlanId, PlanConfig> {
  return {
    community: {
      id: 'community',
      displayName: 'Community',
      monthlyAmountCents: 0,
      annualAmountCents: 0,
      stripePriceIdMonthly: null,
      stripePriceIdAnnual: null,
    },
    partner: {
      id: 'partner',
      displayName: 'Partner Org',
      monthlyAmountCents: 34_900, // $349/mo
      annualAmountCents: 358_800, // $3,588/yr ($299/mo)
      stripePriceIdMonthly: env.STRIPE_PRICE_PARTNER_MONTHLY || 'price_momplan_partner_monthly',
      stripePriceIdAnnual: env.STRIPE_PRICE_PARTNER_ANNUAL || 'price_momplan_partner_annual',
    },
    network: {
      id: 'network',
      displayName: 'Network',
      monthlyAmountCents: 89_900, // $899/mo
      annualAmountCents: 898_800, // $8,988/yr ($749/mo)
      stripePriceIdMonthly: env.STRIPE_PRICE_NETWORK_MONTHLY || 'price_momplan_network_monthly',
      stripePriceIdAnnual: env.STRIPE_PRICE_NETWORK_ANNUAL || 'price_momplan_network_annual',
    },
  };
}

export function getAmountCents(plan: OrgPlanId, interval: BillingInterval): number {
  const config = getPlanConfig(plan);
  if (!config) return 0;
  return interval === 'monthly' ? config.monthlyAmountCents : config.annualAmountCents;
}

export function getStripePriceId(plan: OrgPlanId, interval: BillingInterval): string | null {
  const config = getPlanConfig(plan);
  if (!config) return null;
  return interval === 'monthly' ? config.stripePriceIdMonthly : config.stripePriceIdAnnual;
}

export function addBillingPeriod(from: Date, interval: BillingInterval): Date {
  const end = new Date(from);
  if (interval === 'monthly') {
    end.setMonth(end.getMonth() + 1);
  } else {
    end.setFullYear(end.getFullYear() + 1);
  }
  return end;
}

export function assertBillablePlan(plan: string): PlanConfig {
  const config = getPlanConfig(plan);
  if (!config || config.id === 'community') {
    throw new Error('Invalid billable plan');
  }
  return config;
}

export function toUserPlan(plan: string): UserPlan {
  if (!ORG_PLANS.includes(plan as OrgPlanId)) {
    throw new Error(`Invalid plan: ${plan}`);
  }
  return plan as UserPlan;
}

export function isUpgrade(fromPlan: UserPlan, toPlan: UserPlan): boolean {
  return PLAN_HIERARCHY[fromPlan as OrgPlanId] < PLAN_HIERARCHY[toPlan as OrgPlanId];
}

export function isDowngrade(fromPlan: UserPlan, toPlan: UserPlan): boolean {
  return PLAN_HIERARCHY[fromPlan as OrgPlanId] > PLAN_HIERARCHY[toPlan as OrgPlanId];
}

export function parseBillingInterval(value: string | undefined): BillingInterval {
  return value === 'monthly' ? 'monthly' : 'yearly';
}
