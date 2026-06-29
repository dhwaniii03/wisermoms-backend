import { z } from 'zod';

export const validateZipSchema = z.object({
  body: z.object({
    zip: z.string().min(1, 'ZIP code is required'),
    state: z.string().length(2, 'State must be a 2-letter abbreviation'),
    city: z.string().trim().min(1).optional(),
    county: z.string().trim().min(1).optional(),
  }),
});

export const lookupZipSchema = z.object({
  body: z.object({
    zip: z.string().min(1, 'ZIP code is required'),
  }),
});

export const lookupCitySchema = z.object({
  query: z.object({
    state: z.string().length(2, 'State must be a 2-letter abbreviation'),
    city: z.string().trim().min(1, 'City is required'),
  }),
});
