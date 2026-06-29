import { z } from 'zod';
import { optionalUsPhoneSchema } from '../../utils/phone.utils';

export const partnerRegisterSchema = z.object({
  body: z.object({
    // Organization (step 0)
    orgName:       z.string().min(2, 'Organization name is required'),
    orgType:       z.string().min(1, 'Organization type is required'),
    existingOrgId: z.string().uuid('Invalid organization id').optional(),
    website:       z.string().url('Invalid URL').or(z.literal('')).optional(),
    description:   z.string().max(1000).optional(),

    // Contact / location (step 1)
    email:   z.string().email('Invalid contact email'),
    phone:   optionalUsPhoneSchema,
    address: z.string().min(3, 'Street address is required'),
    city:    z.string().trim().min(1, 'City is required'),
    state:   z.string().trim().min(2, 'State is required').max(2),
    zip:     z.string().trim().min(1, 'ZIP code is required'),
    county:  z.string().trim().min(1, 'County is required'),
    country: z.string().optional(),

    // Admin account (step 2)
    adminFirstName:  z.string().trim().min(1, 'First name is required'),
    adminMiddleName: z.string().trim().optional().or(z.literal('')),
    adminLastName:   z.string().trim().min(1, 'Last name is required'),
    adminEmail:      z.string().email('Invalid admin email'),
    adminPassword: z.string().min(8, 'Password must be at least 8 characters'),
    employees:     z.string().optional(),
    founded:       z.string().optional(),
    taxId:         z.string().optional(),
    linkedin:      z.string().url('Invalid URL').or(z.literal('')).optional(),
  }),
});

export const partnerLoginSchema = z.object({
  body: z.object({
    email:    z.string().email('Invalid email'),
    password: z.string().min(1, 'Password is required'),
  }),
});

export const partnerRefreshSchema = z.object({
  body: z.object({
    refreshToken: z.string().optional(),
  }),
});

export const partnerChangePasswordSchema = z.object({
  body: z.object({
    current_password: z.string().min(1, 'Current password is required'),
    new_password: z.string().min(8, 'Password must be at least 8 characters'),
  }),
});
