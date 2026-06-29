import crypto from 'crypto';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { prisma } from '../../config/prisma';
import { env, refreshTokenTtlMs } from '../../config/env';
import { BadRequestError, UnauthorizedError, NotFoundError } from '../../utils/errors';
import { sendEmail } from '../../config/email';
import { UserRole } from '@prisma/client';
import { MotherOrgEnrollmentService } from '../partner/mother-org-enrollment.service';
import { joinFullName } from '../../utils/name.utils';
import {
  isZipValidationEnabled,
  zipValidationService,
} from '../../services/zipValidation.service';

const motherOrgEnrollment = new MotherOrgEnrollmentService();

const authUserSelect = {
  id: true,
  email: true,
  first_name: true,
  middle_name: true,
  last_name: true,
  role: true,
  password_hash: true,
  status: true,
} as const;

const resetTokensCache = new Map<string, string>();

interface AccessTokenPayload {
  userId: string;
  email: string;
  role: UserRole;
}

interface AuthUserSummary {
  id: string;
  email: string;
  first_name: string;
  middle_name: string | null;
  last_name: string;
  role: UserRole;
}

function hashToken(token: string): string {
  return crypto.createHash('sha256').update(token).digest('hex');
}

function generateOpaqueRefreshToken(): string {
  return crypto.randomBytes(64).toString('base64url');
}

function toAuthUser(user: {
  id: string;
  email: string;
  first_name: string;
  middle_name: string | null;
  last_name: string;
  role: UserRole;
}): AuthUserSummary {
  return {
    id: user.id,
    email: user.email,
    first_name: user.first_name,
    middle_name: user.middle_name,
    last_name: user.last_name,
    role: user.role,
  };
}

export class AuthService {
  private generateAccessToken(user: AccessTokenPayload): string {
    return jwt.sign(
      {
        userId: user.userId,
        email: user.email,
        role: user.role,
      },
      env.JWT_SECRET,
      { expiresIn: env.JWT_ACCESS_TOKEN_EXPIRES_IN as jwt.SignOptions['expiresIn'] }
    );
  }

  private async createRefreshToken(userId: string): Promise<string> {
    const rawToken = generateOpaqueRefreshToken();
    const tokenHash = hashToken(rawToken);
    const expiresAt = new Date(Date.now() + refreshTokenTtlMs);

    await prisma.refreshToken.create({
      data: {
        token: tokenHash,
        user_id: userId,
        expires_at: expiresAt,
      },
    });

    return rawToken;
  }

  private async revokeAllRefreshTokens(userId: string): Promise<void> {
    await prisma.refreshToken.updateMany({
      where: { user_id: userId, revoked: false },
      data: { revoked: true },
    });
  }

  private async issueSession(user: {
    id: string;
    email: string;
    first_name: string;
    middle_name: string | null;
    last_name: string;
    role: UserRole;
  }) {
    const accessToken = this.generateAccessToken({
      userId: user.id,
      email: user.email,
      role: user.role,
    });
    const refreshToken = await this.createRefreshToken(user.id);

    return {
      user: toAuthUser(user),
      accessToken,
      refreshToken,
    };
  }

  async register(data: {
    email: string;
    password: string;
    first_name: string;
    middle_name?: string;
    last_name: string;
    phone?: string;
    org_id?: string;
    org_type?: string;
    state?: string;
    city?: string;
    county?: string;
    zip_code?: string;
  }) {
    const existingUser = await prisma.user.findUnique({
      where: { email: data.email },
    });

    if (existingUser) {
      throw new BadRequestError('Email is already registered');
    }

    const state = data.state?.trim();
    const city = data.city?.trim();
    const county = data.county?.trim();
    const zip_code = data.zip_code?.trim();

    if (!zip_code) {
      throw new BadRequestError('ZIP code is required.');
    }

    let resolvedLocation: { zip_code: string; state: string; city: string; county: string | null };
    if (isZipValidationEnabled()) {
      resolvedLocation = zipValidationService.resolveLocationFromZip(zip_code, county);
    } else {
      if (!state || !city) {
        throw new BadRequestError('State and city are required.');
      }
      resolvedLocation = { zip_code, state, city, county: county || null };
    }

    const password_hash = await bcrypt.hash(data.password, 10);
    const first_name = data.first_name.trim();
    const middle_name = data.middle_name?.trim() || null;
    const last_name = data.last_name.trim();

    const user = await prisma.user.create({
      data: {
        email: data.email,
        password_hash,
        first_name,
        middle_name,
        last_name,
        phone: data.phone,
        org_type: data.org_type || null,
        state: resolvedLocation.state,
        zip_code: resolvedLocation.zip_code,
      },
    });

    await prisma.familyProfile.create({
      data: {
        user_id: user.id,
        first_name,
        last_name,
        city: resolvedLocation.city,
        county: resolvedLocation.county,
        state: resolvedLocation.state,
        zip_code: resolvedLocation.zip_code,
      },
    });

    if (data.org_id) {
      await motherOrgEnrollment.enrollUserInPartnerOrg(user.id, data.org_id);
    }

    await sendEmail({
      to: user.email,
      subject: 'Welcome to MomPlan!',
      html: `<h1>Welcome to MomPlan, ${joinFullName(user.first_name, user.middle_name, user.last_name)}!</h1><p>We are thrilled to help you discover and apply for the benefits your family deserves.</p>`,
    });

    return this.issueSession(user);
  }

  async login(data: { email: string; password: string }) {
    const user = await prisma.user.findUnique({
      where: { email: data.email },
      select: authUserSelect,
    });

    if (!user || user.status === 'inactive') {
      throw new UnauthorizedError('Invalid credentials or inactive account');
    }

    const isPasswordValid = await bcrypt.compare(data.password, user.password_hash);
    if (!isPasswordValid) {
      throw new UnauthorizedError('Invalid credentials');
    }

    await prisma.user.update({
      where: { id: user.id },
      data: { last_active_at: new Date() },
    });

    return this.issueSession(user);
  }

  async logout(refreshToken?: string, userId?: string): Promise<void> {
    if (refreshToken) {
      const tokenHash = hashToken(refreshToken);
      await prisma.refreshToken.updateMany({
        where: { token: tokenHash, revoked: false },
        data: { revoked: true },
      });
    }

    if (userId) {
      await this.revokeAllRefreshTokens(userId);
    }
  }

  async refresh(refreshToken: string) {
    const tokenHash = hashToken(refreshToken);

    const storedToken = await prisma.refreshToken.findUnique({
      where: { token: tokenHash },
      include: {
        user: {
          select: {
            id: true,
            email: true,
            first_name: true,
            middle_name: true,
            last_name: true,
            role: true,
            status: true,
          },
        },
      },
    });

    if (!storedToken) {
      throw new UnauthorizedError('Invalid refresh token');
    }

    if (storedToken.revoked) {
      // Replay attack: revoke all sessions for this user
      await this.revokeAllRefreshTokens(storedToken.user_id);
      throw new UnauthorizedError('Refresh token revoked or invalid');
    }

    if (storedToken.expires_at < new Date()) {
      await prisma.refreshToken.update({
        where: { id: storedToken.id },
        data: { revoked: true },
      });
      throw new UnauthorizedError('Refresh token expired');
    }

    const user = storedToken.user;
    if (!user || user.status === 'inactive') {
      throw new UnauthorizedError('User account not found or inactive');
    }

    // Rotate: revoke the current token before issuing a new one
    await prisma.refreshToken.update({
      where: { id: storedToken.id },
      data: { revoked: true },
    });

    const accessToken = this.generateAccessToken({
      userId: user.id,
      email: user.email,
      role: user.role,
    });
    const newRefreshToken = await this.createRefreshToken(user.id);

    return {
      user: toAuthUser(user),
      accessToken,
      refreshToken: newRefreshToken,
    };
  }

  async forgotPassword(email: string) {
    const user = await prisma.user.findUnique({
      where: { email },
    });

    if (!user) {
      return;
    }

    const resetToken = jwt.sign({ userId: user.id }, env.JWT_SECRET, { expiresIn: '1h' });
    resetTokensCache.set(resetToken, user.id);

    const resetUrl = `${env.FRONTEND_URL}/reset-password?token=${resetToken}`;

    await sendEmail({
      to: user.email,
      subject: 'Password Reset Request - MomPlan',
      html: `<p>You requested a password reset. Click the link below to set a new password:</p><a href="${resetUrl}">Reset Password</a><p>This link is valid for 1 hour.</p>`,
    });
  }

  async resetPassword(token: string, newPassword: string) {
    const userId = resetTokensCache.get(token);
    if (!userId) {
      throw new BadRequestError('Invalid or expired password reset token');
    }

    const password_hash = await bcrypt.hash(newPassword, 10);

    await prisma.user.update({
      where: { id: userId },
      data: { password_hash },
    });

    resetTokensCache.delete(token);
    await this.revokeAllRefreshTokens(userId);
  }

  async changePassword(userId: string, currentPassword: string, newPassword: string) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      throw new NotFoundError('User not found');
    }

    const isPasswordValid = await bcrypt.compare(currentPassword, user.password_hash);
    if (!isPasswordValid) {
      throw new UnauthorizedError('Invalid current password');
    }

    const password_hash = await bcrypt.hash(newPassword, 10);

    await prisma.user.update({
      where: { id: userId },
      data: { password_hash },
    });
  }
}
