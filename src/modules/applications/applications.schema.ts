import { z } from 'zod';

export const listApplicationsQuerySchema = z.object({
  query: z.object({
    quarter: z.enum(['Q1', 'Q2', 'Q3', 'Q4']).optional(),
    year: z.coerce.number().int().min(2000).max(2100).optional(),
    filter_pdfs_by_quarter: z
      .enum(['true', 'false'])
      .optional()
      .transform((v) => v === 'true'),
  }),
});

export const applicationIdParamSchema = z.object({
  params: z.object({
    id: z.string().min(1),
  }),
});

export const createApplicationSchema = z.object({
  body: z.object({
    program_id: z.string().min(1),
    notes: z.string().optional(),
    priority: z.enum(['normal', 'high', 'urgent']).default('normal'),
  }),
});

export const updateApplicationSchema = z.object({
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

export const applyApplicationSchema = z.object({
  params: z.object({
    id: z.string().min(1),
  }),
  body: z.object({
    subject: z.string().optional(),
    body: z.string().optional(),
    to: z.string().email().optional(),
    attach_pdf: z.boolean().optional(),
    document_ids: z.array(z.string()).optional(),
  }),
});

