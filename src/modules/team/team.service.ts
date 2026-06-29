import crypto from 'crypto';
import bcrypt from 'bcrypt';
import { OrgUserRole } from '@prisma/client';
import { prisma } from '../../config/prisma';
import { BadRequestError, NotFoundError } from '../../utils/errors';

function deriveFullName(email: string): string {
  const local = email.split('@')[0] ?? email;
  return local
    .split(/[._-]+/)
    .filter(Boolean)
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1).toLowerCase())
    .join(' ');
}

export function generateSecurePassword(length = 16): string {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789!@#$%&*';
  const bytes = crypto.randomBytes(length);
  return Array.from(bytes, (b) => chars[b % chars.length]).join('');
}

const DEFAULT_CASELOAD_CAPACITY = 8;

function sanitizeMember(user: {
  id: string;
  full_name: string;
  email: string;
  role: OrgUserRole;
  is_active: boolean;
  caseload_capacity: number | null;
  created_at: Date;
}) {
  return {
    id: user.id,
    full_name: user.full_name,
    email: user.email,
    role: user.role,
    is_active: user.is_active,
    caseload_capacity: user.caseload_capacity,
    created_at: user.created_at,
  };
}

export class TeamService {
  async listMembers(orgId: string) {
    const members = await prisma.orgUser.findMany({
      where: { org_id: orgId },
      select: {
        id: true,
        full_name: true,
        email: true,
        role: true,
        is_active: true,
        caseload_capacity: true,
        created_at: true,
      },
      orderBy: [{ role: 'asc' }, { full_name: 'asc' }],
    });

    return members.map(sanitizeMember);
  }

  async bulkCreateMembers(
    orgId: string,
    emails: string[],
    password: string,
    caseloadCapacity = DEFAULT_CASELOAD_CAPACITY
  ) {
    const normalized = [...new Set(emails.map((e) => e.trim().toLowerCase()).filter(Boolean))];
    const password_hash = await bcrypt.hash(password, 10);

    const created: Array<ReturnType<typeof sanitizeMember>> = [];
    const failed: Array<{ email: string; reason: string }> = [];

    const existing = await prisma.orgUser.findMany({
      where: { email: { in: normalized } },
      select: { email: true },
    });
    const existingSet = new Set(existing.map((e) => e.email));

    const toCreate = normalized.filter((email) => {
      if (existingSet.has(email)) {
        failed.push({ email, reason: 'An account with this email already exists' });
        return false;
      }
      return true;
    });

    if (toCreate.length === 0) {
      return { created, failed };
    }

    try {
      const newMembers = await prisma.$transaction(
        toCreate.map((email) =>
          prisma.orgUser.create({
            data: {
              full_name: deriveFullName(email),
              email,
              password_hash,
              role: OrgUserRole.caseworker,
              must_change_password: true,
              is_active: true,
              org_id: orgId,
              caseload_capacity: caseloadCapacity,
            },
            select: {
              id: true,
              full_name: true,
              email: true,
              role: true,
              is_active: true,
              caseload_capacity: true,
              created_at: true,
            },
          })
        )
      );
      created.push(...newMembers.map(sanitizeMember));
    } catch {
      for (const email of toCreate) {
        failed.push({ email, reason: 'Failed to create account' });
      }
    }

    return { created, failed };
  }

  private async getMemberInOrg(orgId: string, memberId: string) {
    const member = await prisma.orgUser.findFirst({
      where: { id: memberId, org_id: orgId },
    });
    if (!member) throw new NotFoundError('Team member not found');
    return member;
  }

  private async assertNotLastAdmin(orgId: string, memberId: string) {
    const member = await this.getMemberInOrg(orgId, memberId);
    if (member.role !== OrgUserRole.admin) return member;

    const adminCount = await prisma.orgUser.count({
      where: { org_id: orgId, role: OrgUserRole.admin, is_active: true },
    });

    if (adminCount <= 1) {
      throw new BadRequestError('Cannot remove or deactivate the last remaining admin');
    }

    return member;
  }

  async deleteMember(orgId: string, memberId: string, requesterId: string) {
    if (memberId === requesterId) {
      throw new BadRequestError('You cannot delete your own account');
    }

    await this.assertNotLastAdmin(orgId, memberId);

    await prisma.orgUser.delete({ where: { id: memberId } });
  }

  async resetPassword(orgId: string, memberId: string) {
    await this.getMemberInOrg(orgId, memberId);

    const tempPassword = generateSecurePassword();
    const password_hash = await bcrypt.hash(tempPassword, 10);

    await prisma.orgUser.update({
      where: { id: memberId },
      data: { password_hash, must_change_password: true },
    });

    // Revoke all refresh tokens so user must re-login with new password
    await prisma.orgRefreshToken.updateMany({
      where: { org_user_id: memberId, revoked: false },
      data: { revoked: true },
    });

    return { temporary_password: tempPassword };
  }

  async updateMemberStatus(orgId: string, memberId: string, is_active: boolean, requesterId: string) {
    if (!is_active) {
      if (memberId === requesterId) {
        throw new BadRequestError('You cannot deactivate your own account');
      }
      await this.assertNotLastAdmin(orgId, memberId);
    } else {
      await this.getMemberInOrg(orgId, memberId);
    }

    const member = await prisma.orgUser.update({
      where: { id: memberId },
      data: { is_active },
      select: {
        id: true,
        full_name: true,
        email: true,
        role: true,
        is_active: true,
        caseload_capacity: true,
        created_at: true,
      },
    });

    return sanitizeMember(member);
  }

  async updateMemberCapacity(orgId: string, memberId: string, caseloadCapacity: number) {
    const member = await this.getMemberInOrg(orgId, memberId);
    if (member.role !== OrgUserRole.caseworker && member.role !== OrgUserRole.admin) {
      throw new BadRequestError('Caseload capacity applies to caseworkers and admins only');
    }

    const updated = await prisma.orgUser.update({
      where: { id: memberId },
      data: { caseload_capacity: caseloadCapacity },
      select: {
        id: true,
        full_name: true,
        email: true,
        role: true,
        is_active: true,
        caseload_capacity: true,
        created_at: true,
      },
    });

    return sanitizeMember(updated);
  }
}
