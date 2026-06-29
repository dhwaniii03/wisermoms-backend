import { z } from 'zod';
import { orgTypeSchema } from '../../constants/org-types';

function getAdultDobBounds(referenceDate = new Date()) {
  const currentYear = referenceDate.getFullYear();
  const maxDate = new Date(
    currentYear - 16,
    referenceDate.getMonth(),
    referenceDate.getDate(),
  );
  const minDate = new Date(currentYear - 100, 0, 1);
  return { minDate, maxDate };
}

function parseIsoDateLocal(iso: string): Date | null {
  const match = iso.match(/^(\d{4})-(\d{2})-(\d{2})$/);
  if (!match) return null;
  const year = Number(match[1]);
  const month = Number(match[2]);
  const day = Number(match[3]);
  const date = new Date(year, month - 1, day);
  if (
    date.getFullYear() !== year ||
    date.getMonth() !== month - 1 ||
    date.getDate() !== day
  ) {
    return null;
  }
  return date;
}

const dateOfBirthSchema = z
  .string()
  .nullable()
  .or(z.literal(''))
  .optional()
  .superRefine((value, ctx) => {
    if (!value) return;
    const parsed = parseIsoDateLocal(value);
    if (!parsed) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        message: 'Date of birth must be a valid date (YYYY-MM-DD).',
      });
      return;
    }
    const { minDate, maxDate } = getAdultDobBounds();
    if (parsed < minDate) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        message: 'Date of birth cannot be more than 100 years ago.',
      });
    }
    if (parsed > maxDate) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        message: 'You must be at least 16 years old.',
      });
    }
  });

export const updateProfileSchema = z.object({
  body: z.object({
    first_name: z.string().trim().min(1).optional(),
    middle_name: z.string().trim().nullable().or(z.literal('')).optional(),
    last_name: z.string().trim().min(1).optional(),
    phone: z.string().nullable().or(z.literal('')).optional(),
    email: z.string().email().or(z.literal('')).nullable().optional(),
    state: z.string().nullable().or(z.literal('')).optional(),
    zip_code: z.string().nullable().or(z.literal('')).optional(),
    profile_picture: z.string().nullable().or(z.literal('')).optional(),
    org_id: z.string().uuid().nullable().or(z.literal('')).optional(),
    org_type: orgTypeSchema.nullable().or(z.literal('')).optional(),
    // Family Profile fields allowed in main profile update for convenience
    household_size: z.number().int().min(1).optional(),
    num_children: z.number().int().min(0).optional(),
    children_ages: z.array(z.number()).optional(),
    monthly_income: z.number().min(0).optional(),
    employment_status: z.string().nullable().or(z.literal('')).optional(),
    housing_status: z.string().nullable().or(z.literal('')).optional(),
    has_disability: z.boolean().optional(),
    is_pregnant: z.boolean().optional(),
    citizenship_status: z.boolean().optional(),
    
    // New Wiser Moms fields
    needs_childcare: z.boolean().optional(),
    monthly_rent: z.number().min(0).optional(),
    monthly_utilities: z.number().min(0).optional(),
    eviction_risk: z.boolean().optional(),
    domestic_violence: z.boolean().optional(),
    chronic_illness: z.boolean().optional(),
    immigration_status: z.string().nullable().or(z.literal('')).optional(),
    date_of_birth: dateOfBirthSchema,
    ssn_last_four: z.string().max(4).nullable().or(z.literal('')).optional(),
    children_dobs: z.array(z.string()).optional(),
    preferred_language: z.string().nullable().or(z.literal('')).optional(),
    marital_status: z.string().nullable().or(z.literal('')).optional(),
    other_adults: z.boolean().optional(),
    other_household_income: z.boolean().optional(),
    income_sources: z.array(z.string()).optional(),
    work_situation: z.string().nullable().or(z.literal('')).optional(),
    employer_name: z.string().nullable().or(z.literal('')).optional(),
    health_insurance: z.string().nullable().or(z.literal('')).optional(),
    savings_assets: z.string().nullable().or(z.literal('')).optional(),
    child_support_status: z.string().nullable().or(z.literal('')).optional(),
    monthly_childcare_cost: z.number().nullable().optional(),
    childcare_preference: z.string().nullable().or(z.literal('')).optional(),
    childcare_provider: z.string().nullable().or(z.literal('')).optional(),
    legal_issues: z.array(z.string()).optional(),
    urgency: z.string().nullable().or(z.literal('')).optional(),
    // Address fields
    street_address: z.string().nullable().or(z.literal('')).optional(),
    city: z.string().nullable().or(z.literal('')).optional(),
    county: z.string().nullable().or(z.literal('')).optional(),
  }),
});

export const updateFamilyProfileSchema = z.object({
  body: z.object({
    household_size: z.number().int().min(1),
    num_children: z.number().int().min(0),
    children_ages: z.array(z.number()),
    monthly_income: z.number().min(0),
    employment_status: z.string().min(1),
    housing_status: z.string().min(1),
    has_disability: z.boolean().default(false),
    is_pregnant: z.boolean().default(false),
  }),
});
