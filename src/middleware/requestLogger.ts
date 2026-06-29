import { Request, Response } from 'express';
import pinoHttp from 'pino-http';
import { randomUUID } from 'crypto';
import { logger } from '../config/logger';

function requestId(req: Request): string {
  const incoming = req.headers['x-request-id'];
  if (typeof incoming === 'string' && incoming.trim()) return incoming.trim();
  if (Array.isArray(incoming) && incoming[0]?.trim()) return incoming[0].trim();
  return randomUUID();
}

function customLogLevel(
  _req: Request,
  res: Response,
  err?: Error
): 'silent' | 'trace' | 'debug' | 'info' | 'warn' | 'error' | 'fatal' {
  if (err || res.statusCode >= 500) return 'error';
  if (res.statusCode >= 400) return 'warn';
  return 'info';
}

export const requestLogger = pinoHttp({
  logger,
  genReqId: requestId,
  customLogLevel,
  autoLogging: {
    ignore: (req) => req.url === '/health',
  },
  customSuccessMessage: (req, res) =>
    `${req.method} ${req.url} ${res.statusCode}`,
  customErrorMessage: (req, res, err) =>
    `${req.method} ${req.url} ${res.statusCode} — ${err?.message ?? 'request failed'}`,
  customAttributeKeys: {
    req: 'request',
    res: 'response',
    err: 'error',
    responseTime: 'durationMs',
  },
  customProps: (req) => {
    const props: Record<string, string> = {};
    if (req.user?.id) props.userId = req.user.id;
    if (req.orgUser?.orgUserId) props.orgUserId = req.orgUser.orgUserId;
    if (req.orgUser?.orgId) props.orgId = req.orgUser.orgId;
    return props;
  },
  serializers: {
    req: (req) => ({
      id: req.id,
      method: req.method,
      url: req.url,
      query: req.query,
      remoteAddress: req.remoteAddress,
      userAgent: req.headers['user-agent'],
    }),
    res: (res) => ({
      statusCode: res.statusCode,
    }),
  },
});
