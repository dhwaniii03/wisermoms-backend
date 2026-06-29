import { FamilyProfile, User } from '@prisma/client';
import { normalizeStateCode } from '../eligibility/eligibility.filters';

export type ProfileWithFamily = User & {
  family_profile: FamilyProfile | null;
  organization?: {
    id: string;
    name: string;
    city: string | null;
    state: string | null;
  } | null;
};

function valuesDiffer(a: unknown, b: unknown): boolean {
  if (Array.isArray(a) || Array.isArray(b)) {
    return JSON.stringify(a ?? []) !== JSON.stringify(b ?? []);
  }
  if (a === b) return false;
  if (a == null && b == null) return false;
  return String(a) !== String(b);
}

function fieldChanged(
  existing: ProfileWithFamily,
  updates: Record<string, unknown>,
  key: string,
  readExisting: (profile: ProfileWithFamily) => unknown = (profile) =>
    (profile.family_profile as Record<string, unknown> | null)?.[key]
): boolean {
  if (!(key in updates) || updates[key] === undefined) return false;
  return valuesDiffer(readExisting(existing), updates[key]);
}

const USER_SCALAR_FIELDS = [
  'first_name',
  'middle_name',
  'last_name',
  'phone',
  'email',
  'state',
  'zip_code',
  'profile_picture',
] as const;

const FAMILY_FIELDS = [
  'household_size',
  'num_children',
  'children_ages',
  'monthly_income',
  'employment_status',
  'housing_status',
  'has_disability',
  'is_pregnant',
  'needs_childcare',
  'monthly_rent',
  'monthly_utilities',
  'eviction_risk',
  'domestic_violence',
  'chronic_illness',
  'immigration_status',
  'date_of_birth',
  'ssn_last_four',
  'preferred_language',
  'marital_status',
  'other_adults',
  'other_household_income',
  'income_sources',
  'work_situation',
  'employer_name',
  'health_insurance',
  'savings_assets',
  'child_support_status',
  'monthly_childcare_cost',
  'childcare_preference',
  'childcare_provider',
  'legal_issues',
  'urgency',
  'children_dobs',
  'street_address',
  'city',
  'county',
  'first_name',
  'last_name',
] as const;

/** Returns true when profile updates can change eligibility scan results. */
export function profileUpdateAffectsEligibility(
  existing: ProfileWithFamily,
  updates: Record<string, unknown>
): boolean {
  if (
    fieldChanged(existing, updates, 'state', (profile) => profile.state) &&
    normalizeStateCode(String(updates.state)) !== normalizeStateCode(existing.state)
  ) {
    return true;
  }

  if (
    fieldChanged(existing, updates, 'zip_code', (profile) => profile.zip_code) &&
    String(updates.zip_code ?? '') !== String(existing.zip_code ?? '')
  ) {
    return true;
  }

  const eligibilityFields = [
    'household_size',
    'num_children',
    'children_ages',
    'monthly_income',
    'employment_status',
    'housing_status',
    'has_disability',
    'is_pregnant',
    'needs_childcare',
    'monthly_rent',
    'monthly_utilities',
    'eviction_risk',
    'domestic_violence',
    'chronic_illness',
    'immigration_status',
    'preferred_language',
    'marital_status',
    'other_adults',
    'other_household_income',
    'income_sources',
    'work_situation',
    'employer_name',
    'health_insurance',
    'savings_assets',
    'child_support_status',
    'monthly_childcare_cost',
    'childcare_preference',
    'childcare_provider',
    'legal_issues',
    'urgency',
    'children_dobs',
    'date_of_birth',
    'ssn_last_four',
    'street_address',
  ] as const;

  return eligibilityFields.some((key) => fieldChanged(existing, updates, key));
}

export function buildUserProfilePatch(
  existing: User,
  data: Record<string, unknown>
): Record<string, unknown> {
  const patch: Record<string, unknown> = {};

  for (const key of USER_SCALAR_FIELDS) {
    if (!(key in data) || data[key] === undefined) continue;
    let next = data[key];
    if (typeof next === 'string' && key !== 'email') {
      next = key === 'middle_name' ? next.trim() || null : next.trim();
    }
    if (valuesDiffer((existing as Record<string, unknown>)[key], next)) {
      patch[key] = next;
    }
  }

  if ('org_type' in data && data.org_type !== undefined) {
    const next = data.org_type || null;
    if (valuesDiffer(existing.org_type, next)) {
      patch.org_type = next;
    }
  }

  return patch;
}

export function buildFamilyProfilePatch(
  existing: FamilyProfile | null,
  data: Record<string, unknown>
): Record<string, unknown> | null {
  const patch: Record<string, unknown> = {};

  for (const key of FAMILY_FIELDS) {
    if (!(key in data) || data[key] === undefined) continue;
    const current = existing ? (existing as Record<string, unknown>)[key] : undefined;
    if (!existing || valuesDiffer(current, data[key])) {
      patch[key] = data[key];
    }
  }

  if ('state' in data && data.state !== undefined && valuesDiffer(existing?.state, data.state)) {
    patch.state = data.state;
  }
  if ('zip_code' in data && data.zip_code !== undefined && valuesDiffer(existing?.zip_code, data.zip_code)) {
    patch.zip_code = data.zip_code;
  }

  return Object.keys(patch).length > 0 ? patch : null;
}

export function mergeProfileResponse(
  existing: ProfileWithFamily,
  userPatch: Record<string, unknown>,
  familyPatch: Record<string, unknown> | null,
  organization?: ProfileWithFamily['organization']
): ProfileWithFamily {
  const family_profile = existing.family_profile
    ? ({ ...existing.family_profile, ...(familyPatch ?? {}) } as FamilyProfile)
    : familyPatch
      ? ({ user_id: existing.id, ...familyPatch } as FamilyProfile)
      : null;

  return {
    ...existing,
    ...userPatch,
    family_profile,
    organization:
      organization !== undefined ? organization : existing.organization,
  };
}
