import { z } from 'zod';

export const generatePdfSchema = z.object({
  body: z.object({
    program_id: z.string().min(1, 'Program ID is required'),
    application_id: z.string().uuid('Application ID must be a valid UUID').optional(),
    quarter: z.enum(['Q1', 'Q2', 'Q3', 'Q4']).optional(),
    year: z.coerce.number().int().min(2000).max(2100).optional(),
  }),
});

export const listPdfsQuerySchema = z.object({
  query: z.object({
    quarter: z.enum(['Q1', 'Q2', 'Q3', 'Q4']).optional(),
    year: z.coerce.number().int().min(2000).max(2100).optional(),
  }),
});

export const validatePdfSchema = z.object({
  body: z.object({
    program_id: z.string().min(1, 'Program ID is required'),
  }),
});

export const pdfIdParamSchema = z.object({
  params: z.object({
    id: z.string().uuid('PDF ID must be a valid UUID'),
  }),
});

export const pdfStreamQuerySchema = z.object({
  params: z.object({
    id: z.string().uuid('PDF ID must be a valid UUID'),
  }),
  query: z.object({
    record_download: z.enum(['true', 'false']).optional(),
  }),
});
