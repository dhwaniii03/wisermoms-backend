import crypto from 'crypto';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { Prisma } from '@prisma/client';
import { prisma } from '../../config/prisma';
import { env } from '../../config/env';
import { BadRequestError, UnauthorizedError } from '../../utils/errors';
import { joinFullName } from '../../utils/name.utils';
import { ORG_TYPE_LABELS, orgTypeSlug, parseOrgType } from '../../constants/org-types';
import {
  PartnerOrganization,
  toPartnerOrganization,
} from '../../utils/partner-organization.utils';
import { resolveLocationInput } from '../../utils/location-input.utils';
import {
  organizationPublicSelect,
  organizationServesLocation,
} from '../../utils/organization.utils';

// ---- Token helpers ----

const PARTNER_REFRESH_TTL_MS = 30 * 24 * 60 * 60 * 1000; // 30 days

export interface OrgUserTokenPayload {
  orgUserId: string;
  email: string;
  role: string;
  orgId: string;
}

function hashToken(token: string): string {
  return crypto.createHash('sha256').update(token).digest('hex');
}

function generateOpaqueToken(): string {
  return crypto.randomBytes(64).toString('base64url');
}

function generateAccessToken(payload: OrgUserTokenPayload): string {
  return jwt.sign(
    { orgUserId: payload.orgUserId, email: payload.email, role: payload.role, orgId: payload.orgId },
    env.JWT_SECRET,
    { expiresIn: env.JWT_ACCESS_TOKEN_EXPIRES_IN as jwt.SignOptions['expiresIn'] }
  );
}

async function createRefreshToken(orgUserId: string, tx: Prisma.TransactionClient = prisma): Promise<string> {
  const raw = generateOpaqueToken();
  const hash = hashToken(raw);
  const expiresAt = new Date(Date.now() + PARTNER_REFRESH_TTL_MS);

  await tx.orgRefreshToken.create({
    data: { token: hash, org_user_id: orgUserId, expires_at: expiresAt },
  });

  return raw;
}

async function issueSession(orgUser: {
  id: string;
  email: string;
  full_name: string;
  role: string;
  org_id: string;
  must_change_password: boolean;
  organization: PartnerOrganization;
}, tx: Prisma.TransactionClient = prisma) {
  const accessToken = generateAccessToken({
    orgUserId: orgUser.id,
    email: orgUser.email,
    role: orgUser.role,
    orgId: orgUser.org_id,
  });
  const refreshToken = await createRefreshToken(orgUser.id, tx);

  return {
    user: {
      id: orgUser.id,
      email: orgUser.email,
      full_name: orgUser.full_name,
      role: orgUser.role,
      org_id: orgUser.org_id,
      must_change_password: orgUser.must_change_password,
    },
    accessToken,
    refreshToken,
    organization: orgUser.organization,
  };
}

// ---- Service ----

export class PartnerAuthService {
  async register(data: {
    orgName: string;
    orgType: string;
    existingOrgId?: string;
    website?: string;
    description?: string;
    email: string;
    phone?: string;
    address: string;
    city: string;
    state?: string;
    zip?: string;
    county?: string;
    country?: string;
    adminFirstName: string;
    adminMiddleName?: string;
    adminLastName: string;
    adminEmail: string;
    adminPassword: string;
    employees?: string;
    founded?: string;
    taxId?: string;
    linkedin?: string;
  }) {
    // Guard: admin email must be unique across org users
    const existing = await prisma.orgUser.findUnique({ where: { email: data.adminEmail } });
    if (existing) {
      throw new BadRequestError('An account with this email already exists');
    }

    const password_hash = await bcrypt.hash(data.adminPassword, 10);
    const orgType = parseOrgType(data.orgType);
    if (!orgType) {
      throw new BadRequestError('Invalid organization type');
    }

    const county = data.county?.trim();
    if (!county) {
      throw new BadRequestError('County is required.');
    }

    const resolvedLocation = await resolveLocationInput({
      zip: data.zip,
      state: data.state,
      city: data.city,
      county,
    });

    const resolvedCounty = resolvedLocation.county ?? county;

    const locationFilters = {
      state: resolvedLocation.state,
      city: resolvedLocation.city,
      county: resolvedCounty,
    };

    // Create org + admin in a transaction
    const sessionResult = await prisma.$transaction(async (tx) => {
      let org;

      if (data.existingOrgId) {
        const existingOrg = await tx.organization.findUnique({
          where: { id: data.existingOrgId },
          select: { ...organizationPublicSelect, active: true },
        });

        if (!existingOrg?.active) {
          throw new BadRequestError('Selected organization was not found.');
        }

        if (!organizationServesLocation(existingOrg, locationFilters)) {
          throw new BadRequestError(
            'Selected organization does not serve your county.'
          );
        }

        org = await tx.organization.update({
          where: { id: existingOrg.id },
          data: {
            org_name: data.orgName,
            category: ORG_TYPE_LABELS[orgType],
            org_type: orgTypeSlug(orgType),
            phone: data.phone || undefined,
            address: data.address,
            city: resolvedLocation.city,
            state: resolvedLocation.state,
            zip_code: resolvedLocation.zip_code,
            county: resolvedCounty,
            country: data.country || undefined,
            contact_email: data.email,
            email: data.email,
            website: data.website || undefined,
            description: data.description || undefined,
            purpose: data.description || undefined,
            employees: data.employees || undefined,
            founded: data.founded || undefined,
            tax_id: data.taxId || undefined,
            linkedin: data.linkedin || undefined,
          },
        });
      } else {
        org = await tx.organization.create({
          data: {
            org_name:      data.orgName,
            category:      ORG_TYPE_LABELS[orgType],
            org_type:      orgTypeSlug(orgType),
            website:       data.website || null,
            description:   data.description || null,
            purpose:       data.description || null,
            phone:         data.phone || null,
            address:       data.address,
            city:          resolvedLocation.city,
            state:         resolvedLocation.state,
            zip_code:      resolvedLocation.zip_code,
            county:        resolvedCounty,
            counties_served: [resolvedCounty],
            country:       data.country || null,
            contact_email: data.email,
            email:         data.email,
            employees:     data.employees || null,
            founded:       data.founded || null,
            tax_id:        data.taxId || null,
            linkedin:      data.linkedin || null,
          },
        });
      }

      const firstName = data.adminFirstName.trim();
      const middleName = data.adminMiddleName?.trim() || null;
      const lastName = data.adminLastName.trim();
      const fullName = joinFullName(firstName, middleName, lastName);

      const adminUser = await tx.orgUser.create({
        data: {
          full_name:     fullName,
          email:         data.adminEmail,
          password_hash,
          role:          'admin',
          org_id:        org.id,
          is_active:     true,
          must_change_password: false,
        },
      });

      if (!org.billing_user_id) {
        const billingUser = await tx.user.create({
          data: {
            email: adminUser.email,
            first_name: firstName,
            middle_name: middleName,
            last_name: lastName,
            org_id: org.id,
          },
        });

        org = await tx.organization.update({
          where: { id: org.id },
          data: { billing_user_id: billingUser.id },
        });
      }

      return issueSession({
        ...adminUser,
        organization: toPartnerOrganization(org),
      }, tx);
    });

    return sessionResult;
  }

  async login(data: { email: string; password: string }) {
    const orgUser = await prisma.orgUser.findUnique({
      where: { email: data.email },
      include: { organization: true },
    });

    if (!orgUser || !orgUser.is_active) {
      throw new UnauthorizedError('Invalid credentials or inactive account');
    }

    const valid = await bcrypt.compare(data.password, orgUser.password_hash);
    if (!valid) {
      throw new UnauthorizedError('Invalid credentials');
    }

    await prisma.orgUser.update({
      where: { id: orgUser.id },
      data: { last_login: new Date() },
    });

    return issueSession({
      ...orgUser,
      organization: toPartnerOrganization(orgUser.organization),
    });
  }

  async logout(rawRefreshToken?: string): Promise<void> {
    if (!rawRefreshToken) return;
    const hash = hashToken(rawRefreshToken);
    await prisma.orgRefreshToken.updateMany({
      where: { token: hash, revoked: false },
      data: { revoked: true },
    });
  }

  async refresh(rawRefreshToken: string) {
    const hash = hashToken(rawRefreshToken);

    const stored = await prisma.orgRefreshToken.findUnique({
      where: { token: hash },
      include: { orgUser: { include: { organization: true } } },
    });

    if (!stored) throw new UnauthorizedError('Invalid refresh token');
    if (stored.revoked) {
      // Replay attack — revoke all sessions for this user
      await prisma.orgRefreshToken.updateMany({
        where: { org_user_id: stored.org_user_id, revoked: false },
        data: { revoked: true },
      });
      throw new UnauthorizedError('Refresh token revoked');
    }
    if (stored.expires_at < new Date()) {
      await prisma.orgRefreshToken.update({ where: { id: stored.id }, data: { revoked: true } });
      throw new UnauthorizedError('Refresh token expired');
    }

    const orgUser = stored.orgUser;
    if (!orgUser || !orgUser.is_active) throw new UnauthorizedError('Account not found or inactive');

    // Rotate
    await prisma.orgRefreshToken.update({ where: { id: stored.id }, data: { revoked: true } });

    return issueSession({
      ...orgUser,
      organization: toPartnerOrganization(orgUser.organization),
    });
  }

  async changePassword(orgUserId: string, currentPassword: string, newPassword: string) {
    const orgUser = await prisma.orgUser.findUnique({
      where: { id: orgUserId },
      include: { organization: true },
    });

    if (!orgUser || !orgUser.is_active) {
      throw new UnauthorizedError('Account not found or inactive');
    }

    const valid = await bcrypt.compare(currentPassword, orgUser.password_hash);
    if (!valid) {
      throw new BadRequestError('Current password is incorrect');
    }

    const password_hash = await bcrypt.hash(newPassword, 10);

    const updated = await prisma.orgUser.update({
      where: { id: orgUserId },
      data: { password_hash, must_change_password: false },
      include: { organization: true },
    });

    return issueSession({
      ...updated,
      organization: toPartnerOrganization(updated.organization),
    });
  }
}
