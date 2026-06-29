import { z } from 'zod';
import { updateProfileSchema } from '../user/user.schema';

export const getResultParamSchema = z.object({
  params: z.object({
    programId: z.string().min(1),
  }),
});

export const getResultsQuerySchema = z.object({
  query: z.object({
    federal: z.enum(['true', 'false']).optional(),
    state_only: z.enum(['true', 'false']).optional(),
    state: z.union([z.literal('All'), z.string().length(2)]).optional(),
    state_search: z.string().max(100).optional(),
    year: z.union([z.literal('all'), z.coerce.number().int().positive()]).optional(),
    quarter: z.enum(['Q1', 'Q2', 'Q3', 'Q4']).optional(),
    page: z.coerce.number().int().min(1).optional(),
    limit: z.coerce.number().int().min(1).max(100).optional(),
  }),
});

/** Optional profile payload merged into the user profile before scanning. */
export const runScanSchema = z.object({
  body: z
    .object({
      profile: updateProfileSchema.shape.body.optional(),
    })
    .optional()
    .default({}),
});
