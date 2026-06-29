import { z } from 'zod';

export const assignCaseworkerSchema = z.object({
  params: z.object({
    id: z.string().uuid('Invalid mother ID'),
  }),
  body: z.object({
    caseworkerId: z.string().uuid('Invalid caseworker ID'),
  }),
});
