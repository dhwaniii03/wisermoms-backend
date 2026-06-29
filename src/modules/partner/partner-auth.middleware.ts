import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { env } from '../../config/env';
import { ForbiddenError, UnauthorizedError } from '../../utils/errors';
import { OrgUserTokenPayload } from './partner-auth.service';

declare global {
  namespace Express {
    interface Request {
      orgUser?: OrgUserTokenPayload;
    }
  }
}

export function authenticateOrgUser(req: Request, _res: Response, next: NextFunction): void {
  const authHeader = req.headers.authorization;
  if (!authHeader?.startsWith('Bearer ')) {
    return next(new UnauthorizedError('No partner token provided'));
  }

  const token = authHeader.slice(7);
  try {
    const payload = jwt.verify(token, env.JWT_SECRET) as OrgUserTokenPayload;
    if (!payload.orgUserId) {
      return next(new UnauthorizedError('Invalid partner token'));
    }
    req.orgUser = payload;
    next();
  } catch {
    next(new UnauthorizedError('Invalid or expired partner token'));
  }
}

export function requireOrgRole(...roles: string[]) {
  return (req: Request, _res: Response, next: NextFunction): void => {
    if (!req.orgUser) return next(new UnauthorizedError('Not authenticated'));
    if (!roles.includes(req.orgUser.role)) {
      return next(new ForbiddenError('Insufficient permissions'));
    }
    next();
  };
}
