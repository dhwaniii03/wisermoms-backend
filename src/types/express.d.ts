import { UserRole } from '@prisma/client';
import type { Logger } from 'pino';

declare global {
  namespace Express {
    interface Request {
      id?: string;
      log?: Logger;
      user?: {
        id: string;
        email: string;
        role: UserRole;
      };
    }
  }
}
