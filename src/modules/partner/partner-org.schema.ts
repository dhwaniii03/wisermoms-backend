import { z } from 'zod';
import { optionalUsPhoneSchema } from '../../utils/phone.utils';

export const partnerUpdateOrganizationSchema = z.object({
  body: z.object({
    name: z.string().min(2).optional(),
    website: z.string().url().or(z.literal('')).optional(),
    description: z.string().max(1000).optional(),
    phone: optionalUsPhoneSchema,
    email: z.string().email().or(z.literal('')).optional(),
    address: z.string().optional(),
    city: z.string().trim().min(1).optional(),
    state: z.string().trim().min(2).max(2).optional(),
    zip: z.string().trim().min(1).optional(),
    county: z.string().trim().min(1).optional(),
    country: z.string().optional(),
  }),
});

export const partnerCompleteOnboardingSchema = z.object({
  body: z.object({
    name: z.string().min(2).optional(),
    tagline: z.string().max(120).optional(),
    description: z.string().max(1000).optional(),
    website: z.string().url().or(z.literal('')).optional(),
    linkedin: z.string().url().or(z.literal('')).optional(),
    services: z.string().optional(),
    address: z.string().optional(),
    city: z.string().trim().min(1).optional(),
    state: z.string().trim().min(2).max(2).optional(),
    zip: z.string().trim().min(1).optional(),
    county: z.string().trim().min(1).optional(),
    country: z.string().optional(),
    email: z.string().email().or(z.literal('')).optional(),
    phone: optionalUsPhoneSchema,
    service_area: z.string().optional(),
    primary_language: z.string().optional(),
    notification_frequency: z.string().optional(),
    case_numbering_prefix: z.string().max(8).optional(),
    caseworker_emails: z.array(z.string().email()).optional(),
    caseworker_password: z.string().min(8).optional(),
    default_caseload_capacity: z.number().int().min(1).max(500).optional(),
  }),
});
