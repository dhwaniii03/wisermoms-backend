import { prisma } from '../../config/prisma';
import {
  caseListWhere,
  OrgAccessContext,
  isOrgAdmin,
  secureSubmittedCaseWhere,
} from './partner-access';
import { formatUserName, hasUserName } from '../../utils/name.utils';
import { programDisplayName, programBadgeKey } from '../programs/program-display';
import { daysUntil, urgencyBucket } from './urgency.utils';

function initials(name: string): string {
  return name
    .trim()
    .split(/\s+/)
    .slice(0, 2)
    .map((w) => w[0]?.toUpperCase() ?? '')
    .join('');
}

function caseworkerShortName(fullName: string): string {
  const parts = fullName.trim().split(/\s+/);
  if (parts.length < 2) return fullName;
  return `${parts[0][0]}. ${parts[parts.length - 1]}`;
}

function formatMotherNumber(motherId: string): string {
  const hex = motherId.replace(/-/g, '').slice(0, 4);
  const num = parseInt(hex, 16) % 10000;
  return `M-${String(num).padStart(4, '0')}`;
}


async function resolveMotherName(mother: {
  user?: {
    first_name: string;
    middle_name?: string | null;
    last_name: string;
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

// Snoozed alerts stored in deadline notes as JSON prefix
function isSnoozed(notes: string | null): boolean {
  if (!notes) return false;
  try {
    const parsed = JSON.parse(notes);
    if (parsed.snoozed_until) {
      return new Date(parsed.snoozed_until) > new Date();
    }
  } catch {
    return false;
  }
  return false;
}

function snoozeData(notes: string | null): { snoozed_until?: string } {
  if (!notes) return {};
  try {
    return JSON.parse(notes);
  } catch {
    return {};
  }
}

export class PartnerAlertsService {
  async getSummary(ctx: OrgAccessContext, quarter?: string) {
    const alerts = await this.fetchAlerts(ctx, { quarter, showSnoozed: false });
    const counts = { critical: 0, soon: 0, upcoming: 0, on_track: 0 };
    for (const a of alerts) {
      counts[a.urgency_bucket]++;
    }
    return { ...counts, total_cases: alerts.length };
  }

  async listAlerts(
    ctx: OrgAccessContext,
    filters: {
      quarter?: string;
      search?: string;
      alertType?: string;
      program?: string;
      caseworker?: string;
      showSnoozed?: boolean;
    }
  ) {
    let alerts = await this.fetchAlerts(ctx, filters);

    if (!filters.showSnoozed) {
      alerts = alerts.filter((a) => !a.is_snoozed);
    }

    const search = filters.search?.toLowerCase().trim();
    if (search) {
      alerts = alerts.filter(
        (a) =>
          a.client_name.toLowerCase().includes(search) ||
          a.case_number.toLowerCase().includes(search)
      );
    }

    if (filters.alertType && filters.alertType !== 'all') {
      alerts = alerts.filter((a) => a.alert_type === filters.alertType);
    }

  return alerts.sort((a, b) => a.days_remaining - b.days_remaining);
  }

  private async fetchAlerts(
    ctx: OrgAccessContext,
    filters: { quarter?: string; program?: string; caseworker?: string; showSnoozed?: boolean }
  ) {
    const caseworkerFilter = isOrgAdmin(ctx) ? filters.caseworker : undefined;

    const deadlines = await prisma.caseDeadline.findMany({
      where: {
        is_resolved: false,
        case: {
          ...caseListWhere(ctx, caseworkerFilter),
          ...secureSubmittedCaseWhere(),
          ...(filters.quarter ? { quarter: filters.quarter.toUpperCase() } : {}),
          ...(filters.program && filters.program !== 'all' ? { program_id: filters.program } : {}),
        },
      },
      include: {
        case: {
          include: {
            mother: { include: { user: { include: { family_profile: true } } } },
            caseworker: true,
            program: true,
            communications: { orderBy: { sent_at: 'desc' }, take: 1 },
          },
        },
      },
      orderBy: { due_date: 'asc' },
    });

    const results = await Promise.all(
      deadlines.map(async (d) => {
        const c = d.case;
        const motherName = await resolveMotherName(c.mother);
        const days = daysUntil(d.due_date);
        const bucket = urgencyBucket(days);
        const lastComm = c.communications[0];
        const snoozed = isSnoozed(d.notes);

        const alertType = d.type === 'renewal' ? 'renewal' : 'doc_expiry';
        const program = programDisplayName(c.program.id, c.program.name);

        let description = '';
        if (d.type === 'renewal') {
          description = `${program} renewal due date ${days <= 1 ? 'tomorrow' : `in ${days} days`}`;
        } else {
          description = `${d.type.replace(/_/g, ' ')} due ${days <= 1 ? 'tomorrow' : `in ${days} days`}`;
        }

        return {
          id: d.id,
          case_id: c.id,
          client_name: motherName,
          case_number: formatMotherNumber(c.mother_id),
          days_remaining: days,
          due_date: d.due_date.toISOString(),
          description,
          alert_type: alertType,
          program,
          program_code: c.program.id,
          program_badge: programBadgeKey(c.program.id, c.program.name),
          urgency_bucket: bucket,
          is_snoozed: snoozed,
          last_activity: lastComm
            ? { description: lastComm.message, date: (lastComm.sent_at ?? new Date()).toISOString() }
            : null,
          caseworker: c.caseworker
            ? {
                id: c.caseworker.id,
                name: caseworkerShortName(c.caseworker.full_name),
                full_name: c.caseworker.full_name,
                initials: initials(c.caseworker.full_name),
              }
            : null,
        };
      })
    );

    return results;
  }

  async snoozeAlert(ctx: OrgAccessContext, deadlineId: string, days = 3) {
    const deadline = await prisma.caseDeadline.findFirst({
      where: {
        id: deadlineId,
        case: caseListWhere(ctx),
      },
    });
    if (!deadline) return null;

    const snoozedUntil = new Date();
    snoozedUntil.setDate(snoozedUntil.getDate() + days);

    const existing = snoozeData(deadline.notes);
    await prisma.caseDeadline.update({
      where: { id: deadlineId },
      data: {
        notes: JSON.stringify({ ...existing, snoozed_until: snoozedUntil.toISOString() }),
      },
    });

    return { snoozed_until: snoozedUntil.toISOString() };
  }
}
