import { prisma } from '../../config/prisma';
import {
  motherListWhere,
  motherOrgWhere,
  assertMotherAccess,
  OrgAccessContext,
  orgCaseloadCaseWhere,
  activeCasesForMotherWhere,
} from '../partner/partner-access';
import { BadRequestError, ForbiddenError, NotFoundError } from '../../utils/errors';
import { formatUserName, hasUserName } from '../../utils/name.utils';
import { programDisplayName } from '../programs/program-display';

async function resolveMotherName(mother: {
  user?: {
    first_name: string;
    middle_name?: string | null;
    last_name: string;
    email: string;
    family_profile?: { first_name: string | null; last_name: string | null } | null;
  } | null;
}): Promise<string> {
  const fp = mother.user?.family_profile;
  if (fp?.first_name || fp?.last_name) {
    return [fp.first_name, fp.last_name].filter(Boolean).join(' ');
  }
  if (hasUserName(mother.user)) return formatUserName(mother.user);
  return 'Unknown Mother';
}

function mapMotherRow(
  mother: {
    id: string;
    enrollment_status: string;
    created_at: Date;
    caseworker_id: string | null;
    caseworker: { id: string; full_name: string } | null;
    user: {
      email: string;
      first_name: string;
      middle_name?: string | null;
      last_name: string;
      family_profile?: { first_name: string | null; last_name: string | null; email: string | null } | null;
    } | null;
  },
  name: string
) {
  return {
    id: mother.id,
    name,
    email: mother.user?.family_profile?.email ?? mother.user?.email ?? null,
    status: mother.enrollment_status,
    caseworker: mother.caseworker
      ? { id: mother.caseworker.id, full_name: mother.caseworker.full_name }
      : null,
    created_at: mother.created_at.toISOString(),
  };
}

const motherInclude = {
  user: { include: { family_profile: true } },
  caseworker: { select: { id: true, full_name: true } },
} as const;

export class MothersService {
  async listMothers(ctx: OrgAccessContext, filters: { caseworker?: string; search?: string }) {
    const mothers = await prisma.mother.findMany({
      where: motherListWhere(ctx, filters.caseworker),
      include: motherInclude,
      orderBy: { created_at: 'desc' },
    });

    const rows = await Promise.all(
      mothers.map(async (m) => mapMotherRow(m, await resolveMotherName(m)))
    );

    const search = filters.search?.toLowerCase().trim();
    if (!search) return rows;

    return rows.filter(
      (r) =>
        r.name.toLowerCase().includes(search) ||
        (r.email?.toLowerCase().includes(search) ?? false)
    );
  }

  async getMother(ctx: OrgAccessContext, motherId: string) {
    const mother = await prisma.mother.findFirst({
      where: { id: motherId, ...motherListWhere(ctx) },
      include: {
        ...motherInclude,
        cases: {
          where: {
            secure_submitted_at: { not: null },
            ...(ctx.role === 'admin'
              ? orgCaseloadCaseWhere(ctx.orgId)
              : { mother: { caseworker_id: ctx.orgUserId } }),
          },
          include: {
            program: true,
            caseworker: { select: { id: true, full_name: true } },
          },
          orderBy: [{ secure_submitted_at: 'desc' }, { created_at: 'desc' }],
        },
      },
    });

    if (!mother) {
      const inOrg = await prisma.mother.findFirst({
        where: { id: motherId, ...motherOrgWhere(ctx.orgId) },
        select: { id: true },
      });
      if (inOrg) throw new ForbiddenError('You do not have access to this mother');
      throw new NotFoundError('Mother not found');
    }

    const name = await resolveMotherName(mother);
    return {
      ...mapMotherRow(mother, name),
      cases: mother.cases.map((c) => ({
        id: c.id,
        program: programDisplayName(c.program.id, c.program.name),
        status: c.status,
        quarter: c.quarter,
        created_at: c.created_at.toISOString(),
      })),
    };
  }

  async assignCaseworker(orgId: string, motherId: string, caseworkerId: string) {
    const mother = await prisma.mother.findFirst({
      where: { id: motherId, ...motherOrgWhere(orgId) },
    });
    if (!mother) throw new NotFoundError('Mother not found');

    const assignee = await prisma.orgUser.findFirst({
      where: {
        id: caseworkerId,
        org_id: orgId,
        is_active: true,
        role: { in: ['caseworker', 'admin'] },
      },
    });
    if (!assignee) throw new BadRequestError('Invalid caseworker');

    await prisma.$transaction([
      prisma.mother.update({
        where: { id: motherId },
        data: { caseworker_id: caseworkerId },
      }),
      prisma.partnerCase.updateMany({
        where: activeCasesForMotherWhere(motherId),
        data: { caseworker_id: caseworkerId },
      }),
    ]);

    return { success: true };
  }

  async unassignCaseworker(orgId: string, motherId: string) {
    const mother = await prisma.mother.findFirst({
      where: { id: motherId, ...motherOrgWhere(orgId) },
    });
    if (!mother) throw new NotFoundError('Mother not found');

    await prisma.$transaction([
      prisma.mother.update({
        where: { id: motherId },
        data: { caseworker_id: null },
      }),
      prisma.partnerCase.updateMany({
        where: activeCasesForMotherWhere(motherId),
        data: { caseworker_id: null },
      }),
    ]);

    return { success: true };
  }

  async listAssignableCaseworkers(orgId: string) {
    const staff = await prisma.orgUser.findMany({
      where: { org_id: orgId, is_active: true, role: { in: ['caseworker', 'admin'] } },
      select: { id: true, full_name: true, role: true },
      orderBy: [{ role: 'asc' }, { full_name: 'asc' }],
    });
    return staff.map((member) => ({
      id: member.id,
      full_name:
        member.role === 'admin' ? `${member.full_name} (Admin)` : member.full_name,
    }));
  }

  async assertMotherAccessById(ctx: OrgAccessContext, motherId: string) {
    const mother = await prisma.mother.findFirst({
      where: { id: motherId, ...motherOrgWhere(ctx.orgId) },
      select: { id: true, caseworker_id: true },
    });
    if (!mother) throw new NotFoundError('Mother not found');
    assertMotherAccess(ctx, mother);
    return mother;
  }
}
