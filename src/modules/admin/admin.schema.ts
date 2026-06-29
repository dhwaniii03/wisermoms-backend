import { z } from 'zod';

export const listUsersQuerySchema = z.object({
  query: z.object({
    page: z.string().regex(/^\d+$/).optional(),
    limit: z.string().regex(/^\d+$/).optional(),
    search: z.string().optional(),
    role: z.enum(['user', 'admin', 'counselor']).optional(),
    status: z.enum(['active', 'inactive', 'flagged']).optional(),
  }),
});

export const userIdParamSchema = z.object({
  params: z.object({
    id: z.string().min(1),
  }),
});

export const updateUserStatusSchema = z.object({
  params: z.object({
    id: z.string().min(1),
  }),
  body: z.object({
    status: z.enum(['active', 'inactive', 'flagged']),
  }),
});

export const listAdminApplicationsQuerySchema = z.object({
  query: z.object({
    status: z.string().optional(),
    program_id: z.string().optional(),
    priority: z.enum(['normal', 'high', 'urgent']).optional(),
  }),
});

export const updateAdminApplicationSchema = z.object({
  params: z.object({
    id: z.string().min(1),
  }),
  body: z.object({
    status: z
      .enum(['draft', 'submitted', 'under_review', 'action_required', 'approved', 'rejected', 'withdrawn'])
      .optional(),
    notes: z.string().nullable().optional(),
    priority: z.enum(['normal', 'high', 'urgent']).optional(),
    assigned_admin_id: z.string().nullable().optional(),
  }),
});
