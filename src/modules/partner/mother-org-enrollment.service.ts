import type { Prisma } from '@prisma/client';
import { prisma } from '../../config/prisma';
import { NotFoundError } from '../../utils/errors';
import {
  organizationPublicSelect,
  OrganizationListMatchLevel,
  OrganizationLocationFilters,
  buildOrganizationCountyWhere,
  buildOrganizationStateWhere,
  toPublicOrganization,
} from '../../utils/organization.utils';
import { activeCasesForMotherWhere } from './partner-access';

type TransactionClient = Prisma.TransactionClient;

function buildAddress(fp: {
  street_address?: string | null;
  city?: string | null;
  state?: string | null;
  zip_code?: string | null;
} | null | undefined): string | null {
  if (!fp) return null;
  const line = [fp.street_address, fp.city, fp.state, fp.zip_code].filter(Boolean).join(', ');
  return line || null;
}

async function cascadeCaseworkerToActiveCases(
  tx: TransactionClient,
  motherId: string,
  caseworkerId: string | null
) {
  await tx.partnerCase.updateMany({
    where: activeCasesForMotherWhere(motherId),
    data: { caseworker_id: caseworkerId },
  });
}

async function upsertMotherCaseworkerForOrg(
  tx: TransactionClient,
  params: {
    userId: string;
    caseworkerId: string | null;
    dob: Date | null;
    phone: string | null;
    address: string | null;
  }
) {
  const { userId, caseworkerId, dob, phone, address } = params;
  const mother = await tx.mother.findUnique({ where: { user_id: userId } });

  if (!mother) {
    return tx.mother.create({
      data: {
        user_id: userId,
        caseworker_id: caseworkerId,
        dob,
        phone,
        address,
        enrollment_status: 'pending',
      },
    });
  }

  const updated = await tx.mother.update({
    where: { id: mother.id },
    data: { caseworker_id: caseworkerId },
  });
  await cascadeCaseworkerToActiveCases(tx, mother.id, caseworkerId);
  return updated;
}

export async function pickCaseworker(orgId: string): Promise<string | null> {
  const caseworkers = await prisma.orgUser.findMany({
    where: {
      org_id: orgId,
      is_active: true,
      role: { in: ['caseworker', 'admin'] },
    },
    include: { _count: { select: { cases: true } } },
    orderBy: { full_name: 'asc' },
  });

  if (caseworkers.length === 0) {
    const fallback = await prisma.orgUser.findFirst({
      where: { org_id: orgId, is_active: true },
      orderBy: { created_at: 'asc' },
    });
    return fallback?.id ?? null;
  }

  caseworkers.sort((a, b) => a._count.cases - b._count.cases);
  return caseworkers[0]!.id;
}

export class MotherOrgEnrollmentService {
  async listOrganizations(filters?: OrganizationLocationFilters): Promise<{
    organizations: ReturnType<typeof toPublicOrganization>[];
    matchLevel: OrganizationListMatchLevel;
  }> {
    const state = filters?.state?.trim();
    const county = filters?.county?.trim();

    if (!county) {
      const orgs = await prisma.organization.findMany({
        where: buildOrganizationStateWhere(state),
        select: organizationPublicSelect,
        orderBy: { org_name: 'asc' },
      });
      return {
        organizations: orgs.map(toPublicOrganization),
        matchLevel: null,
      };
    }

    const countyMatches = await prisma.organization.findMany({
      where: buildOrganizationCountyWhere(county, state),
      select: organizationPublicSelect,
      orderBy: { org_name: 'asc' },
    });

    if (countyMatches.length > 0) {
      return {
        organizations: countyMatches.map(toPublicOrganization),
        matchLevel: 'county',
      };
    }

    if (filters?.stateFallback && state) {
      const stateOrgs = await prisma.organization.findMany({
        where: buildOrganizationStateWhere(state),
        select: organizationPublicSelect,
        orderBy: { org_name: 'asc' },
      });
      return {
        organizations: stateOrgs.map(toPublicOrganization),
        matchLevel: 'state',
      };
    }

    return {
      organizations: [],
      matchLevel: null,
    };
  }

  /**
   * Assign or refresh caseworker + active cases for a user already linked to orgId.
   * Caller must update User.org_id in the same transaction when appropriate.
   */
  async applyPartnerOrgEnrollment(tx: TransactionClient, userId: string, orgId: string) {
    const org = await tx.organization.findUnique({ where: { id: orgId } });
    if (!org) throw new NotFoundError('Partner organization not found');

    const user = await tx.user.findUnique({
      where: { id: userId },
      include: { family_profile: true },
    });
    if (!user) throw new NotFoundError('User not found');

    const caseworkerId = await pickCaseworker(orgId);
    if (!caseworkerId) {
      console.warn(
        `[MotherOrgEnrollment] No caseworker available for org ${orgId}; clearing caseworker assignment for user ${userId}`
      );
    }

    const fp = user.family_profile;
    return upsertMotherCaseworkerForOrg(tx, {
      userId,
      caseworkerId,
      dob: fp?.date_of_birth ?? null,
      phone: fp?.phone ?? user.phone ?? null,
      address: buildAddress(fp),
    });
  }

  /** Clear mother and active case caseworker assignments when org enrollment is removed. */
  async clearPartnerOrgCaseworkerAssignments(tx: TransactionClient, userId: string) {
    const mother = await tx.mother.findUnique({ where: { user_id: userId } });
    if (!mother) return;

    await tx.mother.update({
      where: { id: mother.id },
      data: { caseworker_id: null },
    });
    await cascadeCaseworkerToActiveCases(tx, mother.id, null);
  }

  async enrollUserInPartnerOrg(userId: string, orgId: string) {
    const org = await prisma.organization.findUnique({ where: { id: orgId } });
    if (!org) throw new NotFoundError('Partner organization not found');

    await prisma.$transaction(async (tx) => {
      await tx.user.update({
        where: { id: userId },
        data: {
          org_id: orgId,
          org_type: org.category || org.org_type || null,
        },
      });
      await this.applyPartnerOrgEnrollment(tx, userId, orgId);
    });

    return { org_id: org.id };
  }

  /** Ensure a Mother row exists and caseworker matches the user's current partner org. */
  async ensureMotherForOrg(userId: string, orgId: string) {
    const org = await prisma.organization.findUnique({ where: { id: orgId } });
    if (!org) return null;

    return prisma.$transaction((tx) => this.applyPartnerOrgEnrollment(tx, userId, orgId));
  }
}
