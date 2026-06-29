import { z } from 'zod';
import { orgTypeSchema } from '../../constants/org-types';

export const registerSchema = z.object({
  body: z.object({
    email: z.string().email(),
    password: z.string().min(8),
    first_name: z.string().trim().min(1, 'First name is required'),
    middle_name: z.string().trim().optional().or(z.literal('')),
    last_name: z.string().trim().min(1, 'Last name is required'),
    phone: z
      .string()
      .optional()
      .refine((val) => !val || /^\+1\d{10}$/.test(val), {
        message: 'Enter a valid US phone number',
      }),
    org_id: z.string().uuid('Please select a valid organization').optional(),
    org_type: orgTypeSchema.nullable().or(z.literal('')).optional(),
    state: z.string().trim().min(2, 'State is required').max(2),
    city: z.string().trim().min(1, 'City is required'),
    county: z.string().trim().min(1, 'County is required').optional(),
    zip_code: z.string().trim().min(1, 'ZIP code is required'),
  }),
});

export const loginSchema = z.object({
  body: z.object({
    email: z.string().email(),
    password: z.string(),
  }),
});

export const changePasswordSchema = z.object({
  body: z.object({
    current_password: z.string().min(1),
    new_password: z.string().min(8),
  }),
});

export const refreshSchema = z.object({
  body: z.object({
    refreshToken: z.string().optional(),
  }),
});

export const forgotPasswordSchema = z.object({
  body: z.object({
    email: z.string().email(),
  }),
});

export const resetPasswordSchema = z.object({
  body: z.object({
    token: z.string().min(1),
    newPassword: z.string().min(8),
  }),
});
