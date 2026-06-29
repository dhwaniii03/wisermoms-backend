import { z } from 'zod';
import { optionalUsPhoneSchema } from '../../utils/phone.utils';

export const createPartnerCaseSchema = z.object({
  body: z.object({
    first_name: z.string().min(1, 'First name is required'),
    last_name: z.string().min(1, 'Last name is required'),
    email: z.string().email('Invalid email').optional().or(z.literal('')),
    phone: optionalUsPhoneSchema,
    dob: z.string().optional(),
    address: z.string().optional(),
    program_id: z.string().min(1, 'Program is required'),
    caseworker_id: z.string().uuid().optional(),
    intake_date: z.string().optional(),
    quarter: z.string().optional(),
    notes: z.string().max(2000).optional(),
  }),
});
