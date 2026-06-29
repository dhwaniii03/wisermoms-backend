import { z } from 'zod';

export const listDocumentsChecklistQuerySchema = z.object({
  query: z.object({
    state: z.string().optional(),
    level: z.enum(['All levels', 'Federal', 'State']).optional(),
    search: z.string().optional(),
    page: z.coerce.number().int().min(1).optional(),
    limit: z.coerce.number().int().min(1).max(100).optional(),
  }),
});

export const listProgramsQuerySchema = z.object({
  query: z.object({
    state: z.string().optional(),
    type: z.string().optional(),
    search: z.string().optional(),
    level: z.enum(['All levels', 'Federal', 'State']).optional(),
    page: z.coerce.number().int().min(1).optional(),
    limit: z.coerce.number().int().min(1).max(100).optional(),
  }),
});

export const programIdParamSchema = z.object({
  params: z.object({
    id: z.string().min(1),
  }),
});

export const quarterDueDatesQuerySchema = z.object({
  params: z.object({
    id: z.string().min(1),
  }),
  query: z.object({
    year: z.coerce.number().int().min(2000).max(2100).optional(),
  }),
});

export const backfillQuarterDueDatesSchema = z.object({
  body: z
    .object({
      year: z.number().int().min(2000).max(2100).optional(),
    })
    .optional()
    .default({}),
});

export const createProgramSchema = z.object({
  body: z.object({
    name: z.string().min(1),
    agency: z.string().min(1),
    program_type: z.string().min(1),
    federal_or_state: z.string().min(1),
    state_code: z.string().nullable().optional(),
    description: z.string().min(1),
    eligibility_criteria: z.record(z.any()),
    estimated_monthly_value_min: z.number().min(0),
    estimated_monthly_value_max: z.number().min(0),
    application_url: z.string().url().or(z.literal("")).nullable().optional(),
    contact_email: z.string().email().or(z.literal("")).nullable().optional(),
    is_active: z.boolean().default(true),
    program_due_date: z.string().datetime().or(z.string()).nullable().optional(),
    renewal_period_months: z.number().int().min(1).max(12).nullable().optional(),
  }),
});

export const updateProgramSchema = z.object({
  params: z.object({
    id: z.string().min(1),
  }),
  body: z.object({
    name: z.string().min(1).optional(),
    agency: z.string().min(1).optional(),
    program_type: z.string().min(1).optional(),
    federal_or_state: z.string().min(1).optional(),
    state_code: z.string().nullable().optional(),
    description: z.string().min(1).optional(),
    eligibility_criteria: z.record(z.any()).optional(),
    estimated_monthly_value_min: z.number().min(0).optional(),
    estimated_monthly_value_max: z.number().min(0).optional(),
    application_url: z.string().url().or(z.literal("")).nullable().optional(),
    contact_email: z.string().email().or(z.literal("")).nullable().optional(),
    is_active: z.boolean().optional(),
    program_due_date: z.string().datetime().or(z.string()).nullable().optional(),
    renewal_period_months: z.number().int().min(1).max(12).nullable().optional(),
  }),
});
