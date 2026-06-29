import pino from 'pino';
import { env } from './env';

const isDevelopment = env.NODE_ENV === 'development';
const isTest = env.NODE_ENV === 'test';

const defaultLevel = isTest ? 'silent' : isDevelopment ? 'debug' : 'info';

export const logger = pino({
  level: env.LOG_LEVEL ?? defaultLevel,
  ...(isDevelopment
    ? {
        transport: {
          target: 'pino-pretty',
          options: {
            colorize: true,
            translateTime: 'SYS:standard',
            ignore: 'pid,hostname',
            singleLine: false,
          },
        },
      }
    : {
        formatters: {
          level: (label) => ({ level: label }),
        },
        timestamp: pino.stdTimeFunctions.isoTime,
      }),
  base: {
    env: env.NODE_ENV,
    service: 'momplan-api',
  },
  redact: {
    paths: [
      'req.headers.authorization',
      'req.headers.cookie',
      'password',
      'password_hash',
      'ssn',
      'ssn_last_four',
      'token',
      'refreshToken',
    ],
    censor: '[REDACTED]',
  },
});
