import dotenv from 'dotenv';
import { z } from 'zod';

dotenv.config({ override: true });

const envSchema = z.object({
  // ─── Core ──────────────────────────────────────────────────────────
  PORT: z.string().default('5000'),
  NODE_ENV: z.enum(['development', 'test', 'production']).default('development'),
  /** Log level: trace | debug | info | warn | error | fatal | silent */
  LOG_LEVEL: z
    .enum(['trace', 'debug', 'info', 'warn', 'error', 'fatal', 'silent'])
    .optional(),
  FRONTEND_URL: z.string().default('http://localhost:3000'),
  PARTNER_PORTAL_URL: z.string().default('http://localhost:3002'),
  ADMIN_FRONTEND_URL: z.string().default('http://localhost:3001'),
  /** Comma-separated list of additional allowed CORS origins */
  CORS_ORIGINS: z.string().default(''),

  // ─── Database ──────────────────────────────────────────────────────────
  // Supabase: DATABASE_URL = pooled connection via Supavisor (runtime queries, port 6543)
  //           DIRECT_URL   = direct connection (Prisma migrations only, port 5432)
  DATABASE_URL: z.string().url('DATABASE_URL must be a valid postgresql:// URL'),
  DIRECT_URL: z.string().default(''),

  // ─── Redis ─────────────────────────────────────────────────────────
  REDIS_URL: z.string().default('redis://localhost:6379'),

  // ─── Auth ──────────────────────────────────────────────────────────
  JWT_SECRET: z.string().min(16, 'JWT_SECRET must be at least 16 characters'),
  JWT_REFRESH_SECRET: z.string().min(16, 'JWT_REFRESH_SECRET must be at least 16 characters'),
  /** Passed to jsonwebtoken `expiresIn` (e.g. 15m, 1h, 7d) */
  JWT_ACCESS_TOKEN_EXPIRES_IN: z.string().default('15m'),
  JWT_REFRESH_TOKEN_EXPIRES_DAYS: z.coerce.number().int().positive().default(30),
  SUPABASE_URL: z.string().url('SUPABASE_URL must be a valid URL').optional(),
  SUPABASE_ANON_KEY: z.string().optional(),

  // ─── External APIs (optional in dev — services will mock gracefully) ─
  ANTHROPIC_API_KEY: z.string().default(''),
  STRIPE_SECRET_KEY: z.string().default(''),
  STRIPE_WEBHOOK_SECRET: z.string().default(''),
  STRIPE_PRICE_PARTNER_MONTHLY: z.string().default(''),
  STRIPE_PRICE_PARTNER_ANNUAL: z.string().default(''),
  STRIPE_PRICE_NETWORK_MONTHLY: z.string().default(''),
  STRIPE_PRICE_NETWORK_ANNUAL: z.string().default(''),
  /** When true, simulates successful Stripe payments without charging cards */
  MOCK_STRIPE_PAYMENTS: z
    .string()
    .default('false')
    .transform((v) => v === 'true' || v === '1'),
  AWS_ACCESS_KEY_ID: z.string().default(''),
  AWS_SECRET_ACCESS_KEY: z.string().default(''),
  S3_BUCKET_NAME: z.string().default('momplan-documents-dev'),
  AWS_REGION: z.string().default('us-east-1'),
  RESEND_API_KEY: z.string().default(''),
  RESEND_FROM_EMAIL: z.string().default('MomPlan Notifications <notifications@momplan.gov-assist.com>'),
});

const _env = envSchema.safeParse(process.env);

if (!_env.success) {
  console.error('❌ Invalid environment variables:');
  const formatted = _env.error.format();
  Object.entries(formatted).forEach(([key, val]) => {
    if (key !== '_errors' && typeof val === 'object' && '_errors' in val) {
      console.error(`  ✗ ${key}: ${(val as any)._errors.join(', ')}`);
    }
  });
  console.error('\nFix the above variables in your .env file and restart.');
  process.exit(1);
}

export const env = _env.data;

export const refreshTokenTtlMs =
  env.JWT_REFRESH_TOKEN_EXPIRES_DAYS * 24 * 60 * 60 * 1000;

function normalizeOrigin(url: string): string {
  return url.trim().replace(/\/$/, '');
}

/** Parse comma-separated origin strings into a deduplicated list. */
export function parseCorsOrigins(...sources: string[]): string[] {
  const origins = sources
    .flatMap((source) => source.split(','))
    .map(normalizeOrigin)
    .filter(Boolean);
  return [...new Set(origins)];
}

export const allowedOrigins = parseCorsOrigins(
  env.FRONTEND_URL,
  env.PARTNER_PORTAL_URL,
  env.ADMIN_FRONTEND_URL,
  env.CORS_ORIGINS,
);

// Warn about missing optional service keys in development
if (env.NODE_ENV === 'development') {
  const optionalKeys: (keyof typeof env)[] = [
    'ANTHROPIC_API_KEY',
    'STRIPE_SECRET_KEY',
    'STRIPE_WEBHOOK_SECRET',
    'AWS_ACCESS_KEY_ID',
    'AWS_SECRET_ACCESS_KEY',
    'RESEND_API_KEY',
  ];

  const missing = optionalKeys.filter((k) => !env[k]);
  if (missing.length > 0) {
    console.warn(
      `⚠️  Dev mode: Missing optional service keys — these features will be mocked:\n   ${missing.join(', ')}\n`
    );
  }
}
