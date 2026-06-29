import { prisma } from '../../config/prisma';
import { parseIsoDateOnly } from '../../utils/date-format.utils';
import {
  generateDueDatesForQuarter,
  getPrimaryDueDateForProgram,
} from '../programs/quarterDueDates.service';
import type { Quarter } from '../programs/quarterDueDates.types';

function currentQuarter(): Quarter {
  const m = new Date().getMonth();
  if (m < 3) return 'Q1';
  if (m < 6) return 'Q2';
  if (m < 9) return 'Q3';
  return 'Q4';
}

/** Resolve the next relevant due date for a benefit program (DATE-01). */
export async function resolveProgramDueDateIso(
  programId: string,
  quarter?: string,
  year?: number,
  referenceDate: Date = new Date()
): Promise<string | null> {
  const q = (quarter ?? currentQuarter()).toUpperCase() as Quarter;
  const y = year ?? referenceDate.getFullYear();

  const quarterRecords = await prisma.programQuarterDueDate.findMany({
    where: { program_id: programId },
    select: { year: true, quarter: true, due_dates_json: true },
  });

  const records = quarterRecords.map((r) => ({
    year: r.year,
    quarter: r.quarter as Quarter,
    due_dates_json: r.due_dates_json,
  }));

  const fromQuarter = getPrimaryDueDateForProgram(records, y, q, referenceDate);
  if (fromQuarter) return fromQuarter;

  const fromAny = getPrimaryDueDateForProgram(records, 'all', 'all', referenceDate);
  if (fromAny) return fromAny;

  const program = await prisma.benefitProgram.findUnique({
    where: { id: programId },
    select: { program_due_date: true, renewal_period_months: true },
  });

  if (program?.program_due_date) {
    return program.program_due_date.toISOString().slice(0, 10);
  }

  const generated = generateDueDatesForQuarter(program?.renewal_period_months, q, y);
  if (generated.dueDates.length > 0) {
    return getPrimaryDueDateForProgram(
      [{ year: y, quarter: q, due_dates_json: generated.dueDates }],
      y,
      q,
      referenceDate
    );
  }

  return null;
}

/** Upsert an unresolved renewal due date on a partner case. */
export async function syncPartnerCaseDeadline(
  caseId: string,
  programId: string,
  quarter?: string,
  year?: number
): Promise<void> {
  const dueDateIso = await resolveProgramDueDateIso(programId, quarter, year);
  if (!dueDateIso) return;

  const dueDate = parseIsoDateOnly(dueDateIso);

  const existing = await prisma.caseDeadline.findFirst({
    where: { case_id: caseId, type: 'renewal', is_resolved: false },
  });

  if (existing) {
    await prisma.caseDeadline.update({
      where: { id: existing.id },
      data: { due_date: dueDate },
    });
    return;
  }

  await prisma.caseDeadline.create({
    data: {
      case_id: caseId,
      type: 'renewal',
      due_date: dueDate,
      is_resolved: false,
    },
  });
}

/** Upsert a mother-portal application due date after secure submission. */
export async function syncApplicationDeadline(
  applicationId: string,
  userId: string,
  programId: string,
  quarter?: string,
  year?: number
): Promise<void> {
  const dueDateIso = await resolveProgramDueDateIso(programId, quarter, year);
  if (!dueDateIso) return;

  const dueDate = parseIsoDateOnly(dueDateIso);

  const existing = await prisma.deadline.findFirst({
    where: {
      application_id: applicationId,
      deadline_type: 'renewal',
      is_completed: false,
    },
  });

  if (existing) {
    await prisma.deadline.update({
      where: { id: existing.id },
      data: { due_date: dueDate },
    });
    return;
  }

  await prisma.deadline.create({
    data: {
      user_id: userId,
      application_id: applicationId,
      deadline_type: 'renewal',
      due_date: dueDate,
      is_completed: false,
    },
  });
}
