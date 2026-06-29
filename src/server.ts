import app from './app';
import { env, allowedOrigins } from './config/env';
import { prisma } from './config/prisma';
import { logger } from './config/logger';

const startServer = async () => {
  // ─── 1. Database Connection ────────────────────────────────────────
  let dbConnected = false;
  try {
    await prisma.$connect();
    logger.info('Connected to PostgreSQL database via Prisma ORM');
    dbConnected = true;
  } catch (dbError: any) {
    if (env.NODE_ENV === 'development') {
      logger.warn(
        { err: dbError },
        'PostgreSQL connection failed — server starting WITHOUT database. Ensure PostgreSQL is running and DATABASE_URL is correct in .env'
      );
    } else {
      logger.fatal({ err: dbError }, 'PostgreSQL connection failed in production — shutting down');
      process.exit(1);
    }
  }

  // ─── 2. Background Job Scheduler (only if DB is up) ───────────────
  if (dbConnected) {
    try {
      const { startBackgroundScheduler } = await import('./jobs/scheduler');
      await startBackgroundScheduler();
      logger.info('Background task scheduler started');
    } catch (jobError: any) {
      logger.warn({ err: jobError }, 'Background tasks failed to start');
    }
  }

  // ─── 3. HTTP Server ────────────────────────────────────────────────
  const server = app.listen(env.PORT, () => {
    logger.info(
      {
        port: env.PORT,
        nodeEnv: env.NODE_ENV,
        corsOrigins: allowedOrigins,
        dbConnected,
      },
      'MomPlan Backend ready to accept requests'
    );
  });

  // ─── 4. Graceful Shutdown ──────────────────────────────────────────
  const shutdown = async (signal: string) => {
    logger.info({ signal }, 'Shutting down gracefully');
    if (typeof server.closeAllConnections === 'function') {
      server.closeAllConnections();
    }
    server.close(async () => {
      if (dbConnected) {
        await prisma.$disconnect();
      }
      logger.info('Server shutdown complete');
      process.exit(0);
    });

    // Force-kill after 10 seconds if shutdown hangs
    setTimeout(() => {
      logger.error('Shutdown timeout — forcing exit');
      process.exit(1);
    }, 10_000);
  };

  process.on('SIGINT', () => shutdown('SIGINT'));
  // tsx watch sends SIGTERM to restart; exit immediately in dev so the port is released.
  if (env.NODE_ENV === 'development') {
    process.on('SIGTERM', () => process.exit(0));
  } else {
    process.on('SIGTERM', () => shutdown('SIGTERM'));
  }
  process.on('uncaughtException', (err) => {
    logger.fatal({ err }, 'Uncaught exception');
    shutdown('uncaughtException');
  });
  process.on('unhandledRejection', (reason) => {
    logger.fatal({ reason }, 'Unhandled promise rejection');
    shutdown('unhandledRejection');
  });
};

startServer();
