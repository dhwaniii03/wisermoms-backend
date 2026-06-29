import { z } from 'zod';

export const optionalUsPhoneSchema = z
  .string()
  .optional()
  .refine((val) => !val || /^\+1\d{10}$/.test(val), {
    message: 'Enter a valid US phone number',
  });
