import { Request, Response, NextFunction } from 'express';
import { PartnerAuthService } from './partner-auth.service';
import { UnauthorizedError } from '../../utils/errors';
import { env } from '../../config/env';

const partnerAuthService = new PartnerAuthService();

export const PARTNER_REFRESH_COOKIE = 'mp_org_rt';

const refreshTokenTtlMs = 30 * 24 * 60 * 60 * 1000;

const cookieSameSite = env.NODE_ENV === 'production' ? ('none' as const) : ('lax' as const);

const refreshCookieOptions = {
  httpOnly: true,
  secure: env.NODE_ENV === 'production',
  sameSite: cookieSameSite,
  maxAge: refreshTokenTtlMs,
  path: '/',
};

function setRefreshCookie(res: Response, token: string) {
  res.cookie(PARTNER_REFRESH_COOKIE, token, refreshCookieOptions);
}

function clearRefreshCookie(res: Response) {
  res.clearCookie(PARTNER_REFRESH_COOKIE, {
    httpOnly: true,
    secure: env.NODE_ENV === 'production',
    sameSite: cookieSameSite,
    path: '/',
  });
}

export class PartnerAuthController {
  async register(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await partnerAuthService.register(req.body);
      setRefreshCookie(res, result.refreshToken);
      res.status(201).json({
        success: true,
        data: {
          user:         result.user,
          accessToken:  result.accessToken,
          organization: result.organization,
        },
      });
    } catch (error) {
      next(error);
    }
  }

  async login(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await partnerAuthService.login(req.body);
      setRefreshCookie(res, result.refreshToken);
      res.status(200).json({
        success: true,
        data: {
          user:         result.user,
          accessToken:  result.accessToken,
          organization: result.organization,
        },
      });
    } catch (error) {
      next(error);
    }
  }

  async logout(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const refreshToken = req.cookies?.[PARTNER_REFRESH_COOKIE];
      await partnerAuthService.logout(refreshToken);
      clearRefreshCookie(res);
      res.status(200).json({ success: true, message: 'Logged out successfully' });
    } catch (error) {
      next(error);
    }
  }

  async refresh(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const refreshToken = req.cookies?.[PARTNER_REFRESH_COOKIE] || req.body?.refreshToken;
      if (!refreshToken) throw new UnauthorizedError('No refresh token provided');

      const result = await partnerAuthService.refresh(refreshToken);
      setRefreshCookie(res, result.refreshToken);
      res.status(200).json({
        success: true,
        data: {
          user:         result.user,
          accessToken:  result.accessToken,
          organization: result.organization,
        },
      });
    } catch (error) {
      clearRefreshCookie(res);
      next(error);
    }
  }

  async changePassword(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.orgUser) throw new UnauthorizedError('Not authenticated');
      const { current_password, new_password } = req.body;
      const result = await partnerAuthService.changePassword(
        req.orgUser.orgUserId,
        current_password,
        new_password
      );
      setRefreshCookie(res, result.refreshToken);
      res.status(200).json({
        success: true,
        data: {
          user:         result.user,
          accessToken:  result.accessToken,
          organization: result.organization,
        },
      });
    } catch (error) {
      next(error);
    }
  }
}
