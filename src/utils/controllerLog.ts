import { Request, Response, NextFunction } from 'express';
import type { Logger } from 'pino';
import { logger } from '../config/logger';

export function getRequestLog(req: Request): Logger {
  return req.log ?? logger;
}

export function requestContext(req: Request): Record<string, unknown> {
  const ctx: Record<string, unknown> = {
    requestId: req.id,
    method: req.method,
    path: req.path,
    url: req.originalUrl,
  };

  if (req.route?.path) ctx.route = req.route.path;
  if (req.user?.id) ctx.userId = req.user.id;
  if (req.user?.role) ctx.userRole = req.user.role;
  if (req.orgUser?.orgUserId) ctx.orgUserId = req.orgUser.orgUserId;
  if (req.orgUser?.orgId) ctx.orgId = req.orgUser.orgId;
  if (Object.keys(req.params).length > 0) ctx.params = req.params;

  return ctx;
}

type ControllerHandler = (req: Request, res: Response, next: NextFunction) => Promise<void> | void;

function wrapHandler(moduleName: string, methodName: string, handler: ControllerHandler): ControllerHandler {
  const action = `${moduleName}.${methodName}`;

  return async (req: Request, res: Response, next: NextFunction) => {
    const log = getRequestLog(req);
    const ctx = { ...requestContext(req), action };
    const start = Date.now();

    log.debug(ctx, `${action} invoked`);

    const onFinish = () => {
      const durationMs = Date.now() - start;
      const payload = { ...ctx, durationMs, statusCode: res.statusCode };

      if (res.statusCode >= 500) {
        log.error(payload, `${action} completed with server error`);
      } else if (res.statusCode >= 400) {
        log.warn(payload, `${action} completed with client error`);
      } else {
        log.info(payload, `${action} completed`);
      }

      res.removeListener('finish', onFinish);
    };

    res.on('finish', onFinish);

    try {
      await handler(req, res, next);
    } catch (error) {
      log.error({ ...ctx, durationMs: Date.now() - start, err: error }, `${action} threw`);
      next(error);
    }
  };
}

/**
 * Wraps every method on a controller instance with structured entry/exit logging.
 * Use in route files: `const ctrl = withControllerLog(new FooController(), 'foo');`
 */
export function withControllerLog<T extends object>(controller: T, moduleName: string): T {
  return new Proxy(controller, {
    get(target, prop, receiver) {
      const value = Reflect.get(target, prop, receiver);
      if (typeof prop === 'string' && typeof value === 'function') {
        return wrapHandler(moduleName, prop, value.bind(target));
      }
      return value;
    },
  });
}

/** Wraps a one-off inline route handler with the same logging as controllers. */
export function logHandler(
  moduleName: string,
  handlerName: string,
  handler: ControllerHandler
): ControllerHandler {
  return wrapHandler(moduleName, handlerName, handler);
}
