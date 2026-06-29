import { prisma } from '../../config/prisma';
import { getQuarterForMonth } from '../programs/quarterDueDates.service';
import { Quarter } from '../programs/quarterDueDates.types';

export function currentQuarterYear(): { quarter: Quarter; year: number } {
  const now = new Date();
  return {
    quarter: getQuarterForMonth(now.getUTCMonth() + 1),
    year: now.getUTCFullYear(),
  };
}

export function enrichApplicationQuarterYear(app: {
  quarter?: string | null;
  year?: number | null;
  created_at?: Date | string | null;
  partner_cases?: Array<{ quarter?: string | null }>;
  generated_pdfs?: Array<{ quarter?: string | null; year?: number | null }>;
}): { quarter: string | null; year: number } {
  const quarter =
    app.quarter ||
    app.partner_cases?.[0]?.quarter ||
    app.generated_pdfs?.[0]?.quarter ||
    null;

  const year =
    app.year ??
    app.generated_pdfs?.[0]?.year ??
    new Date(app.created_at || Date.now()).getFullYear();

  return { quarter, year };
}

export async function resolveApplicationQuarterYear(
  applicationId: string,
  explicitQuarter?: string | null,
  explicitYear?: number | null
): Promise<{ quarter: Quarter; year: number }> {
  if (
    explicitQuarter &&
    ['Q1', 'Q2', 'Q3', 'Q4'].includes(explicitQuarter) &&
    explicitYear != null
  ) {
    return { quarter: explicitQuarter as Quarter, year: explicitYear };
  }

  const pdf = await prisma.generatedPdf.findFirst({
    where: { application_id: applicationId },
    orderBy: { generated_at: 'desc' },
    select: { quarter: true, year: true },
  });

  if (pdf?.quarter && ['Q1', 'Q2', 'Q3', 'Q4'].includes(pdf.quarter) && pdf.year != null) {
    return { quarter: pdf.quarter as Quarter, year: pdf.year };
  }

  const application = await prisma.application.findUnique({
    where: { id: applicationId },
    select: { quarter: true, year: true },
  });

  if (
    application?.quarter &&
    ['Q1', 'Q2', 'Q3', 'Q4'].includes(application.quarter) &&
    application.year != null
  ) {
    return { quarter: application.quarter as Quarter, year: application.year };
  }

  return currentQuarterYear();
}

export async function persistApplicationQuarterYear(
  applicationId: string,
  explicitQuarter?: string | null,
  explicitYear?: number | null
): Promise<{ quarter: Quarter; year: number }> {
  const { quarter, year } = await resolveApplicationQuarterYear(
    applicationId,
    explicitQuarter,
    explicitYear
  );

  try {
    await prisma.application.update({
      where: { id: applicationId },
      data: { quarter, year },
    });
  } catch (err) {
    console.warn(`[Applications] Could not persist quarter/year for ${applicationId}:`, err);
  }

  return { quarter, year };
}

const VALID_QUARTERS = new Set(['Q1', 'Q2', 'Q3', 'Q4']);

export function filterApplicationsByPeriod<T extends { quarter?: string | null; year?: number | null }>(
  applications: T[],
  filters?: { quarter?: string; year?: number }
): T[] {
  let result = applications;

  if (filters?.quarter && VALID_QUARTERS.has(filters.quarter)) {
    result = result.filter((app) => app.quarter === filters.quarter);
  }

  if (filters?.year != null && Number.isFinite(filters.year)) {
    result = result.filter((app) => app.year === filters.year);
  }

  return result;
}
