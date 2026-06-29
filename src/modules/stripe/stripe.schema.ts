import { z } from 'zod';

export const createCheckoutSessionSchema = z.object({
  body: z.object({
    plan: z.enum(['partner', 'network']),
    successUrl: z.string().url().optional(),
    cancelUrl: z.string().url().optional(),
  }),
});
