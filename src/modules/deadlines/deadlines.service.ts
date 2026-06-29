import { prisma } from '../../config/prisma';
import { userNameSelect } from '../../utils/name.utils';
import { NotFoundError, ForbiddenError } from '../../utils/errors';
import { UserRole } from '@prisma/client';
import {
  isFederalProgram,
  matchesProfileStateScope,
  normalizeStateCode,
} from '../eligibility/eligibility.filters';
import {
  buildQuarterDueDatesByProgramAndYear,
  getAvailableYearsFromProgramYearMap,
  getPrimaryDueDateForProgram,
  getQuarterForMonth,
  programHasMatchingQuarterData,
} from '../programs/quarterDueDates.service';
import { Quarter } from '../programs/quarterDueDates.types';

export type DeadlineDashboardStatus = 'overdue' | 'due_soon' | 'upcoming';

export interface DeadlineDashboardFilters {
  type: 'all' | 'federal' | 'state';
  year: number | 'all';
  quarter: Quarter;
}

export interface DeadlineDashboardResponse {
  items: DeadlineDashboardItem[];
  availableYears: number[];
}

export interface DeadlineDashboardItem {
  programId: string;
  programName: string;
  federalOrState: string;
  nextDueDate: string;
  daysRemaining: number;
  status: DeadlineDashboardStatus;
}

const STATUS_SORT_ORDER: Record<DeadlineDashboardStatus, number> = {
  overdue: 0,
  due_soon: 1,
  upcoming: 2,
};

function computeDaysRemaining(dueDate: string, referenceDate: Date): number {
  const dueUtc = new Date(`${dueDate}T00:00:00.000Z`).getTime();
  const todayUtc = Date.UTC(
    referenceDate.getUTCFullYear(),
    referenceDate.getUTCMonth(),
    referenceDate.getUTCDate()
  );
  return Math.ceil((dueUtc - todayUtc) / (1000 * 60 * 60 * 24));
}

function computeDeadlineStatus(daysRemaining: number): DeadlineDashboardStatus {
  if (daysRemaining < 0) return 'overdue';
  if (daysRemaining <= 30) return 'due_soon';
  return 'upcoming';
}

function sortDashboardItems(items: DeadlineDashboardItem[]): DeadlineDashboardItem[] {
  return [...items].sort((a, b) => {
    const statusDiff = STATUS_SORT_ORDER[a.status] - STATUS_SORT_ORDER[b.status];
    if (statusDiff !== 0) return statusDiff;

    if (a.status === 'overdue') {
      return b.daysRemaining - a.daysRemaining;
    }

    return a.daysRemaining - b.daysRemaining;
  });
}

type DashboardProgram = {
  id: string;
  name: string;
  federal_or_state: string | null;
};

const VALID_QUARTERS: Quarter[] = ['Q1', 'Q2', 'Q3', 'Q4'];

function isValidQuarter(value: string | null | undefined): value is Quarter {
  return typeof value === 'string' && VALID_QUARTERS.includes(value as Quarter);
}

type ApplicationQuarterContext = {
  submitted_at: Date | null;
  submissions: Array<{
    generated_pdf: { quarter: string | null; year: number | null } | null;
  }>;
  generated_pdfs: Array<{ quarter: string | null; year: number | null }>;
};

function resolveApplicationQuarterYear(
  application: ApplicationQuarterContext
): { quarter: Quarter; year: number } | null {
  for (const submission of application.submissions) {
    const pdf = submission.generated_pdf;
    if (pdf?.quarter && pdf.year && isValidQuarter(pdf.quarter)) {
      return { quarter: pdf.quarter, year: pdf.year };
    }
  }

  for (const pdf of application.generated_pdfs) {
    if (pdf.quarter && pdf.year && isValidQuarter(pdf.quarter)) {
      return { quarter: pdf.quarter, year: pdf.year };
    }
  }

  if (application.submitted_at) {
    return {
      quarter: getQuarterForMonth(application.submitted_at.getUTCMonth() + 1),
      year: application.submitted_at.getUTCFullYear(),
    };
  }

  return null;
}

function applicationMatchesDashboardFilters(
  application: ApplicationQuarterContext,
  filters: DeadlineDashboardFilters
): boolean {
  const resolved = resolveApplicationQuarterYear(application);
  if (!resolved) return false;
  if (resolved.quarter !== filters.quarter) return false;
  if (filters.year !== 'all' && resolved.year !== filters.year) return false;
  return true;
}

function buildQuarterRecordsWhere(
  programIds: string[],
  filters: DeadlineDashboardFilters
) {
  return {
    program_id: { in: programIds },
    quarter: filters.quarter,
    ...(filters.year !== 'all' ? { year: filters.year } : {}),
  };
}

function buildDashboardResponseForPrograms(
  programs: DashboardProgram[],
  filters: DeadlineDashboardFilters,
  quarterRecords: Array<{
    program_id: string;
    year: number;
    quarter: string;
    due_dates_json: unknown;
  }>
): DeadlineDashboardResponse {
  const recordsByProgramAndYear = buildQuarterDueDatesByProgramAndYear(quarterRecords);
  const availableYears = getAvailableYearsFromProgramYearMap(recordsByProgramAndYear);

  const recordsByProgram = new Map<string, typeof quarterRecords>();
  for (const record of quarterRecords) {
    const existing = recordsByProgram.get(record.program_id) ?? [];
    existing.push(record);
    recordsByProgram.set(record.program_id, existing);
  }

  const referenceDate = new Date();
  const items: DeadlineDashboardItem[] = [];

  for (const program of programs) {
    const records = recordsByProgram.get(program.id) ?? [];
    const nextDueDate = getPrimaryDueDateForProgram(
      records.map((record) => ({
        year: record.year,
        quarter: record.quarter as Quarter,
        due_dates_json: record.due_dates_json,
      })),
      filters.year,
      filters.quarter,
      referenceDate
    );

    if (!nextDueDate) continue;

    const daysRemaining = computeDaysRemaining(nextDueDate, referenceDate);
    const status = computeDeadlineStatus(daysRemaining);
    const federalOrState = (program.federal_or_state ?? 'unknown').toLowerCase();

    items.push({
      programId: program.id,
      programName: program.name,
      federalOrState,
      nextDueDate,
      daysRemaining,
      status,
    });
  }

  const uniqueByProgram = new Map<string, DeadlineDashboardItem>();
  for (const item of items) {
    const existing = uniqueByProgram.get(item.programId);
    if (!existing) {
      uniqueByProgram.set(item.programId, item);
      continue;
    }

    if (item.daysRemaining < existing.daysRemaining) {
      uniqueByProgram.set(item.programId, item);
    }
  }

  return {
    items: sortDashboardItems([...uniqueByProgram.values()]),
    availableYears,
  };
}

export class DeadlinesService {
  async getDashboard(
    userId: string,
    filters: DeadlineDashboardFilters
  ): Promise<DeadlineDashboardResponse> {
    const [results, user] = await Promise.all([
      prisma.eligibilityResult.findMany({
        where: {
          user_id: userId,
          status: { in: ['qualified', 'likely_qualified'] },
        },
        include: {
          program: {
            select: {
              id: true,
              name: true,
              federal_or_state: true,
              state_code: true,
            },
          },
        },
      }),
      prisma.user.findUnique({
        where: { id: userId },
        include: { family_profile: true },
      }),
    ]);

    const profileState =
      normalizeStateCode(user?.state) ?? normalizeStateCode(user?.family_profile?.state);

    let scopedResults = profileState
      ? results.filter((result) => matchesProfileStateScope(result.program, profileState))
      : results;

    if (filters.type === 'federal') {
      scopedResults = scopedResults.filter((result) => isFederalProgram(result.program));
    } else if (filters.type === 'state') {
      scopedResults = scopedResults.filter((result) => !isFederalProgram(result.program));
    }

    const programIds = [
      ...new Set(
        scopedResults
          .map((result) => result.program?.id)
          .filter((id): id is string => typeof id === 'string' && id.length > 0)
      ),
    ];

    if (programIds.length === 0) {
      return { items: [], availableYears: [] };
    }

    const quarterRecords = await prisma.programQuarterDueDate.findMany({
      where: buildQuarterRecordsWhere(programIds, filters),
    });

    const recordsByProgramAndYear = buildQuarterDueDatesByProgramAndYear(quarterRecords);

    const programs = scopedResults
      .map((result) => result.program)
      .filter((program): program is NonNullable<typeof program> => {
        if (!program) return false;
        return programHasMatchingQuarterData(
          recordsByProgramAndYear.get(program.id),
          filters.year,
          filters.quarter
        );
      });

    return buildDashboardResponseForPrograms(programs, filters, quarterRecords);
  }

  async getSubmittedApplicationsDashboard(
    userId: string,
    filters: DeadlineDashboardFilters
  ): Promise<DeadlineDashboardResponse> {
    const applications = await prisma.application.findMany({
      where: {
        user_id: userId,
        program_id: { not: null },
        OR: [
          { submissions: { some: {} } },
          {
            status: 'submitted',
            notes: { contains: 'Secure application' },
          },
        ],
      },
      include: {
        program: {
          select: {
            id: true,
            name: true,
            federal_or_state: true,
          },
        },
        submissions: {
          orderBy: { submitted_at: 'desc' },
          include: {
            generated_pdf: {
              select: { quarter: true, year: true },
            },
          },
        },
        generated_pdfs: {
          where: { quarter: { not: null }, year: { not: null } },
          orderBy: { generated_at: 'desc' },
          select: { quarter: true, year: true },
        },
      },
      orderBy: { submitted_at: 'desc' },
    });

    const matchingApplications = applications.filter((application) =>
      applicationMatchesDashboardFilters(application, filters)
    );

    const programsById = new Map<string, DashboardProgram>();
    for (const application of matchingApplications) {
      const program = application.program;
      if (!program) continue;
      if (!programsById.has(program.id)) {
        programsById.set(program.id, program);
      }
    }

    let programs = [...programsById.values()];

    if (filters.type === 'federal') {
      programs = programs.filter((program) => isFederalProgram(program));
    } else if (filters.type === 'state') {
      programs = programs.filter((program) => !isFederalProgram(program));
    }

    if (programs.length === 0) {
      return { items: [], availableYears: [] };
    }

    const programIds = programs.map((program) => program.id);
    const quarterRecords = await prisma.programQuarterDueDate.findMany({
      where: buildQuarterRecordsWhere(programIds, filters),
    });

    return buildDashboardResponseForPrograms(programs, filters, quarterRecords);
  }

  async listDeadlines(userId: string, role: UserRole) {
    if (role === 'admin' || role === 'counselor') {
      return prisma.deadline.findMany({
        include: {
          application: { include: { program: { select: { name: true } } } },
          user: { select: { ...userNameSelect, email: true } },
        },
        orderBy: { due_date: 'asc' },
      });
    }

    return prisma.deadline.findMany({
      where: { user_id: userId },
      include: {
        application: { include: { program: { select: { name: true } } } },
      },
      orderBy: { due_date: 'asc' },
    });
  }

  async createDeadline(
    creatorId: string,
    role: UserRole,
    data: { application_id: string; deadline_type: string; due_date: string }
  ) {
    const application = await prisma.application.findUnique({
      where: { id: data.application_id },
    });

    if (!application) {
      throw new NotFoundError('Application not found');
    }

    // Normal users can only create deadlines for their own application
    if (role === 'user' && application.user_id !== creatorId) {
      throw new ForbiddenError('Access denied');
    }

    return prisma.deadline.create({
      data: {
        user_id: application.user_id,
        application_id: data.application_id,
        deadline_type: data.deadline_type,
        due_date: new Date(data.due_date),
        is_completed: false,
      },
      include: {
        application: { include: { program: { select: { name: true } } } },
      },
    });
  }

  async completeDeadline(id: string, userId: string, role: UserRole) {
    const deadline = await prisma.deadline.findUnique({
      where: { id },
    });

    if (!deadline) {
      throw new NotFoundError('Due date not found');
    }

    if (role === 'user' && deadline.user_id !== userId) {
      throw new ForbiddenError('Access denied');
    }

    return prisma.deadline.update({
      where: { id },
      data: { is_completed: true },
      include: {
        application: { include: { program: { select: { name: true } } } },
      },
    });
  }

  async deleteDeadline(id: string, userId: string, role: UserRole) {
    const deadline = await prisma.deadline.findUnique({ where: { id } });
    if (!deadline) throw new NotFoundError('Due date not found');
    if (role === 'user' && deadline.user_id !== userId) throw new ForbiddenError('Access denied');
    await prisma.deadline.delete({ where: { id } });
  }
}
