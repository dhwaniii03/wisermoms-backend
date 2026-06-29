import { z } from 'zod';

export const dashboardQuerySchema = z.object({
  query: z.object({
    type: z.enum(['all', 'federal', 'state']).optional().default('all'),
    year: z.union([z.literal('all'), z.coerce.number().int().positive()]).optional().default('all'),
    quarter: z.enum(['Q1', 'Q2', 'Q3', 'Q4']).optional(),
  }),
});

export const deadlineIdParamSchema = z.object({
  params: z.object({
    id: z.string().min(1),
  }),
});

export const createDeadlineSchema = z.object({
  body: z.object({
    application_id: z.string().min(1),
    deadline_type: z.string().min(1),
    due_date: z.string().datetime().or(z.string()),
  }),
});
