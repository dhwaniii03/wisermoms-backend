export enum OrganizationType {
  nonprofit_501c3 = 'nonprofit_501c3',
  government_agency = 'government_agency',
  cooperative = 'cooperative',
  other = 'other',
  network_211 = 'network_211',
  childcare_provider = 'childcare_provider',
  dv_coalition = 'dv_coalition',
  education_nonprofit = 'education_nonprofit',
  emergency_shelter = 'emergency_shelter',
  faith_based = 'faith_based',
  food_bank = 'food_bank',
  health_clinic = 'health_clinic',
  housing_nonprofit = 'housing_nonprofit',
  immigration_nonprofit = 'immigration_nonprofit',
  legal_aid = 'legal_aid',
  workforce_development = 'workforce_development',
  wraparound_nonprofit = 'wraparound_nonprofit',
}
import { z } from 'zod';

export const ORG_TYPE_LABELS = {
  [OrganizationType.network_211]: '211 Network',
  [OrganizationType.childcare_provider]: 'Childcare Provider',
  [OrganizationType.cooperative]: 'Cooperative',
  [OrganizationType.dv_coalition]: 'DV Coalition',
  [OrganizationType.education_nonprofit]: 'Education Nonprofit',
  [OrganizationType.emergency_shelter]: 'Emergency Shelter',
  [OrganizationType.faith_based]: 'Faith-Based',
  [OrganizationType.food_bank]: 'Food Bank',
  [OrganizationType.government_agency]: 'Government Agency',
  [OrganizationType.health_clinic]: 'Health Clinic',
  [OrganizationType.housing_nonprofit]: 'Housing Nonprofit',
  [OrganizationType.immigration_nonprofit]: 'Immigration Nonprofit',
  [OrganizationType.legal_aid]: 'Legal Aid',
  [OrganizationType.nonprofit_501c3]: 'Non-profit (501c3)',
  [OrganizationType.other]: 'Other',
  [OrganizationType.workforce_development]: 'Workforce Development',
  [OrganizationType.wraparound_nonprofit]: 'Wraparound Nonprofit',
} as const satisfies Record<OrganizationType, string>;

/** Stored on organizations.org_type (snake_case slug). */
export const ORG_TYPE_SLUGS = {
  [OrganizationType.network_211]: '211_network',
  [OrganizationType.childcare_provider]: 'childcare_provider',
  [OrganizationType.cooperative]: 'cooperative',
  [OrganizationType.dv_coalition]: 'dv_coalition',
  [OrganizationType.education_nonprofit]: 'education_nonprofit',
  [OrganizationType.emergency_shelter]: 'emergency_shelter',
  [OrganizationType.faith_based]: 'faith_based',
  [OrganizationType.food_bank]: 'food_bank',
  [OrganizationType.government_agency]: 'government_agency',
  [OrganizationType.health_clinic]: 'health_clinic',
  [OrganizationType.housing_nonprofit]: 'housing_nonprofit',
  [OrganizationType.immigration_nonprofit]: 'immigration_nonprofit',
  [OrganizationType.legal_aid]: 'legal_aid',
  [OrganizationType.nonprofit_501c3]: 'nonprofit_501c3',
  [OrganizationType.other]: 'other',
  [OrganizationType.workforce_development]: 'workforce_development',
  [OrganizationType.wraparound_nonprofit]: 'wraparound_nonprofit',
} as const satisfies Record<OrganizationType, string>;

export const ORG_TYPES = Object.values(ORG_TYPE_LABELS);

export type OrgTypeLabel = (typeof ORG_TYPES)[number];

const labelToOrgType = Object.fromEntries(
  Object.entries(ORG_TYPE_LABELS).map(([enumVal, label]) => [label, enumVal])
) as Record<OrgTypeLabel, OrganizationType>;

const slugToOrgType = Object.fromEntries(
  Object.entries(ORG_TYPE_SLUGS).map(([enumVal, slug]) => [slug, enumVal])
) as Record<string, OrganizationType>;

export function parseOrgType(value: string): OrganizationType | undefined {
  if ((Object.values(OrganizationType) as string[]).includes(value)) {
    return value as OrganizationType;
  }
  if (slugToOrgType[value]) {
    return slugToOrgType[value];
  }
  return labelToOrgType[value as OrgTypeLabel];
}

export function orgTypeSlug(orgType: OrganizationType): string {
  return ORG_TYPE_SLUGS[orgType];
}

/** Mother-facing org_type is a free-form string (often copied from the selected organization). */
export const orgTypeSchema = z.string().trim().max(200);
