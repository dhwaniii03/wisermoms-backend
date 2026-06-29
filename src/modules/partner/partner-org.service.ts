import { prisma } from '../../config/prisma';
import { BadRequestError, NotFoundError } from '../../utils/errors';
import { toPartnerOrganization } from '../../utils/partner-organization.utils';
import { resolveLocationInput } from '../../utils/location-input.utils';
import { TeamService } from '../team/team.service';
import {
  isZipValidationEnabled,
  zipValidationService,
} from '../../services/zipValidation.service';

type LocationInput = {
  address?: string;
  city?: string;
  state?: string;
  zip?: string;
  county?: string;
  country?: string;
};

async function buildLocationPatch(
  existing: { city: string | null; state: string | null; zip_code: string | null; county: string | null },
  data: LocationInput
) {
  const patch: Record<string, string | null> = {};

  if (data.address !== undefined) patch.address = data.address || null;
  if (data.country !== undefined) patch.country = data.country || null;
  if (data.county !== undefined) patch.county = data.county?.trim() || null;

  const zipChanging = data.zip !== undefined;
  if (zipChanging) {
    const resolved = await resolveLocationInput({
      zip: data.zip,
      state: data.state ?? existing.state ?? undefined,
      city: data.city ?? existing.city ?? undefined,
      county: data.county ?? existing.county ?? undefined,
    });
    patch.zip_code = resolved.zip_code;
    patch.state = resolved.state;
    patch.city = resolved.city;
    if (resolved.county) {
      patch.county = resolved.county;
    }
  } else {
    if (data.city !== undefined) patch.city = data.city || null;
    if (data.state !== undefined) patch.state = data.state || null;
  }

  const effectiveZip = (patch.zip_code as string | undefined) ?? existing.zip_code;
  const effectiveState = (patch.state as string | undefined) ?? existing.state;
  const effectiveCity = (patch.city as string | undefined) ?? existing.city;

  const effectiveCounty = (patch.county as string | undefined) ?? existing.county;

  if (
    zipChanging &&
    isZipValidationEnabled() &&
    effectiveZip &&
    effectiveState
  ) {
    const zipResult = zipValidationService.validateZip(
      String(effectiveZip),
      String(effectiveState),
      effectiveCity ? String(effectiveCity) : undefined,
      effectiveCounty ? String(effectiveCounty) : undefined
    );
    if (!zipResult.valid) {
      throw new BadRequestError(zipResult.error || 'Invalid ZIP code.');
    }
  }

  return patch;
}

/** Partner orgs store their home county; seed data uses counties_served. Keep both in sync. */
function countiesServedPatch(
  existing: { counties_served: string[] },
  county: string | null | undefined
): { counties_served?: string[] } {
  const trimmed = county?.trim();
  if (!trimmed || existing.counties_served.length > 0) return {};
  return { counties_served: [trimmed] };
}

export class PartnerOrgService {
  async updateOrganization(
    orgId: string,
    data: {
      name?: string;
      website?: string;
      description?: string;
      phone?: string;
      email?: string;
      address?: string;
      city?: string;
      state?: string;
      zip?: string;
      county?: string;
      country?: string;
    }
  ) {
    const org = await prisma.organization.findUnique({ where: { id: orgId } });
    if (!org) throw new NotFoundError('Organization not found');

    const locationPatch = await buildLocationPatch(org, data);
    const countyPatch = countiesServedPatch(
      org,
      (locationPatch.county as string | undefined) ?? org.county
    );

    const updated = await prisma.organization.update({
      where: { id: orgId },
      data: {
        ...(data.name !== undefined && { org_name: data.name }),
        ...(data.website !== undefined && { website: data.website || null }),
        ...(data.description !== undefined && {
          description: data.description || null,
          purpose: data.description || null,
        }),
        ...(data.phone !== undefined && { phone: data.phone || null }),
        ...(data.email !== undefined && {
          contact_email: data.email || null,
          email: data.email || null,
        }),
        ...locationPatch,
        ...countyPatch,
      },
    });

    return toPartnerOrganization(updated);
  }

  async completeOnboarding(
    orgId: string,
    data: {
      // profile
      name?: string;
      tagline?: string;
      description?: string;
      website?: string;
      linkedin?: string;
      services?: string;
      // location
      address?: string;
      city?: string;
      state?: string;
      zip?: string;
      county?: string;
      country?: string;
      email?: string;
      phone?: string;
      service_area?: string;
      // preferences
      primary_language?: string;
      notification_frequency?: string;
      case_numbering_prefix?: string;
      // team invites
      caseworker_emails?: string[];
      caseworker_password?: string;
      default_caseload_capacity?: number;
    }
  ) {
    const org = await prisma.organization.findUnique({ where: { id: orgId } });
    if (!org) throw new NotFoundError('Organization not found');

    const hasLocationInput =
      data.address !== undefined ||
      data.city !== undefined ||
      data.state !== undefined ||
      data.zip !== undefined ||
      data.county !== undefined ||
      data.country !== undefined;

    const locationPatch = hasLocationInput ? await buildLocationPatch(org, data) : {};
    const countyPatch = countiesServedPatch(
      org,
      (locationPatch.county as string | undefined) ?? org.county
    );

    const updated = await prisma.organization.update({
      where: { id: orgId },
      data: {
        ...(data.name          && { org_name:      data.name }),
        ...(data.tagline       !== undefined && { tagline:       data.tagline || null }),
        ...(data.description   !== undefined && {
          description: data.description || null,
          purpose:     data.description || null,
        }),
        ...(data.website       !== undefined && { website:       data.website || null }),
        ...(data.linkedin      !== undefined && { linkedin:      data.linkedin || null }),
        ...(data.services      !== undefined && { services_offered: data.services || null }),
        ...locationPatch,
        ...countyPatch,
        ...(data.email         !== undefined && {
          contact_email: data.email || null,
          email:         data.email || null,
        }),
        ...(data.phone         !== undefined && { phone:         data.phone || null }),
        ...(data.service_area  !== undefined && { service_area:  data.service_area || null }),
        ...(data.primary_language       !== undefined && { primary_language:       data.primary_language }),
        ...(data.notification_frequency !== undefined && { notification_frequency: data.notification_frequency }),
        ...(data.case_numbering_prefix  !== undefined && { case_numbering_prefix:  data.case_numbering_prefix }),
        onboarding_completed: true,
      },
    });

    let teamInviteResult: Awaited<ReturnType<TeamService['bulkCreateMembers']>> | null = null;
    const emails = data.caseworker_emails?.map((e) => e.trim().toLowerCase()).filter(Boolean) ?? [];
    if (emails.length > 0) {
      if (!data.caseworker_password) {
        throw new BadRequestError('A password is required when inviting caseworkers during onboarding');
      }
      const teamSvc = new TeamService();
      teamInviteResult = await teamSvc.bulkCreateMembers(
        orgId,
        emails,
        data.caseworker_password,
        data.default_caseload_capacity ?? 8
      );
    }

    return {
      organization: toPartnerOrganization(updated),
      team_invites: teamInviteResult,
    };
  }

  async getOrganization(orgId: string) {
    const org = await prisma.organization.findUnique({ where: { id: orgId } });
    if (!org) throw new NotFoundError('Organization not found');
    return toPartnerOrganization(org);
  }
}
