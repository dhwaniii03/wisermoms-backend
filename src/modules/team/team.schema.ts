import { z } from 'zod';

export const bulkCreateMembersSchema = z.object({
  body: z.object({
    emails: z.array(z.string().email()).min(1, 'At least one email is required'),
    password: z.string().min(8, 'Password must be at least 8 characters'),
    caseload_capacity: z.number().int().min(1).max(500).optional(),
  }),
});

export const memberIdParamsSchema = z.object({
  params: z.object({
    id: z.string().uuid(),
  }),
});

export const updateMemberStatusSchema = z.object({
  params: z.object({
    id: z.string().uuid(),
  }),
  body: z.object({
    is_active: z.boolean(),
  }),
});

export const updateMemberCapacitySchema = z.object({
  params: z.object({
    id: z.string().uuid(),
  }),
  body: z.object({
    caseload_capacity: z.number().int().min(1).max(500),
  }),
});
