import { z } from 'zod';

export const sessionIdParamSchema = z.object({
  params: z.object({
    id: z.string().min(1),
  }),
});

export const bookSessionSchema = z.object({
  body: z.object({
    counselor_id: z.string().min(1),
    scheduled_at: z.string().datetime().or(z.string()),
    duration_minutes: z.number().int().min(15).default(30),
    notes: z.string().optional(),
  }),
});

export const updateSessionSchema = z.object({
  params: z.object({
    id: z.string().min(1),
  }),
  body: z.object({
    status: z.enum(['scheduled', 'completed', 'cancelled']).optional(),
    notes: z.string().nullable().optional(),
    meeting_url: z.string().url().nullable().optional(),
    scheduled_at: z.string().datetime().or(z.string()).optional(),
  }),
});
