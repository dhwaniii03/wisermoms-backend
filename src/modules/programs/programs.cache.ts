import { BenefitProgram } from '@prisma/client';
import { prisma } from '../../config/prisma';

const CACHE_TTL_MS = 10 * 60 * 1000;

let cachedActivePrograms: BenefitProgram[] | null = null;
let cacheTimestamp = 0;
let inflightFetch: Promise<BenefitProgram[]> | null = null;

async function fetchActivePrograms(): Promise<BenefitProgram[]> {
  return prisma.benefitProgram.findMany({
    where: { is_active: true },
    orderBy: { name: 'asc' },
  });
}

/** Shared in-memory cache for active programs — one DB round-trip serves program browse. */
export async function getActivePrograms(): Promise<BenefitProgram[]> {
  const now = Date.now();
  if (cachedActivePrograms && now - cacheTimestamp <= CACHE_TTL_MS) {
    return cachedActivePrograms;
  }

  if (!inflightFetch) {
    inflightFetch = fetchActivePrograms()
      .then((programs) => {
        cachedActivePrograms = programs;
        cacheTimestamp = Date.now();
        return programs;
      })
      .finally(() => {
        inflightFetch = null;
      });
  }

  return inflightFetch;
}

export function clearActiveProgramsCache() {
  cachedActivePrograms = null;
  cacheTimestamp = 0;
}

type ProgramStateSource = {
  state_code?: string | null;
  state?: string | null;
};

export function readProgramStateCode(program: ProgramStateSource | null | undefined): string {
  const raw = program?.state_code ?? program?.state;
  return (raw ?? '').trim().toUpperCase();
}

/** Distinct state codes from active programs — reads DB column `state` via Prisma `state_code`. */
export async function getDistinctActiveProgramStateCodes(): Promise<string[]> {
  const rows = await prisma.benefitProgram.findMany({
    where: {
      is_active: true,
      NOT: { state_code: null },
    },
    select: { state_code: true },
    distinct: ['state_code'],
    orderBy: { state_code: 'asc' },
  });

  return rows.map((row) => readProgramStateCode(row)).filter(Boolean);
}

/** Distinct state codes from an in-memory program list. */
export function getAvailableStateCodesFromPrograms(programs: ProgramStateSource[]): string[] {
  return [...new Set(programs.map((program) => readProgramStateCode(program)).filter(Boolean))].sort();
}
