import { PrismaClient } from '@prisma/client';

declare global {
  // eslint-disable-next-line no-var
  var prisma: PrismaClient | undefined;
}

function withPoolParams(url: string): string {
  if (!url) return url;

  let result = url;
  const joiner = () => (result.includes('?') ? '&' : '?');

  if (process.env.NODE_ENV !== 'production') {
    result = /connection_limit=\d+/.test(result)
      ? result.replace(/connection_limit=\d+/, 'connection_limit=5')
      : `${result}${joiner()}connection_limit=5`;
  } else if (!/connection_limit=\d+/.test(result)) {
    result += `${joiner()}connection_limit=10`;
  }
  if (!/pool_timeout=\d+/.test(result)) {
    result += `${joiner()}pool_timeout=30`;
  }

  return result;
}

function createPrismaClient() {
  const url = withPoolParams(process.env.DATABASE_URL ?? '');

  return new PrismaClient({
    log: ['error', 'warn'],
    ...(url ? { datasources: { db: { url } } } : {}),
  });
}

// Reuse a single PrismaClient instance in development to avoid connection pool exhaustion
export const prisma: PrismaClient =
  (global as any).prisma ?? createPrismaClient();

if (process.env.NODE_ENV !== 'production') {
  (global as any).prisma = prisma;
}
