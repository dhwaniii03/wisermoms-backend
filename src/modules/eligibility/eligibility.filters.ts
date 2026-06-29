import {
  programHasMatchingQuarterData,
  QuarterDueDatesByProgramAndYear,
} from '../programs/quarterDueDates.service';
import { Quarter, QUARTERS } from '../programs/quarterDueDates.types';
import { readProgramStateCode } from '../programs/programs.cache';

export interface EligibilityResultsFilters {
  profileState?: string;
  federal?: boolean;
  stateOnly?: boolean;
  /** Explicit state code filter (federal programs are always included). */
  state?: string;
  /** When true, do not scope results to profile or a single state. */
  allStates?: boolean;
  stateSearch?: string;
  year?: number | 'all';
  quarter?: Quarter | 'all';
  page?: number;
  limit?: number;
}

export interface EligibilityResultsSummary {
  qualifiedCount: number;
  totalMonthlyValueMax: number;
  totalCount: number;
}

export interface EligibilitySyncMeta {
  isStale: boolean;
  hasScan: boolean;
  lastProfileUpdateAt: string | null;
  lastEligibilityScanAt: string | null;
}

export interface EligibilityResultsResponse {
  results: unknown[];
  summary: EligibilityResultsSummary;
  /** Total eligibility results before user-facing filters are applied. */
  scanTotalCount: number;
  availableStates: string[];
  availableYears: number[];
  profileState: string | null;
  /** True while at least one result is still awaiting AI explanation generation. */
  aiProcessing: boolean;
  /** Profile ↔ scan synchronization metadata. */
  sync: EligibilitySyncMeta;
  pagination?: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
  };
}

const US_STATES = [
  { value: 'AL', label: 'Alabama' }, { value: 'AK', label: 'Alaska' }, { value: 'AZ', label: 'Arizona' },
  { value: 'AR', label: 'Arkansas' }, { value: 'CA', label: 'California' }, { value: 'CO', label: 'Colorado' },
  { value: 'CT', label: 'Connecticut' }, { value: 'DE', label: 'Delaware' }, { value: 'FL', label: 'Florida' },
  { value: 'GA', label: 'Georgia' }, { value: 'HI', label: 'Hawaii' }, { value: 'ID', label: 'Idaho' },
  { value: 'IL', label: 'Illinois' }, { value: 'IN', label: 'Indiana' }, { value: 'IA', label: 'Iowa' },
  { value: 'KS', label: 'Kansas' }, { value: 'KY', label: 'Kentucky' }, { value: 'LA', label: 'Louisiana' },
  { value: 'ME', label: 'Maine' }, { value: 'MD', label: 'Maryland' }, { value: 'MA', label: 'Massachusetts' },
  { value: 'MI', label: 'Michigan' }, { value: 'MN', label: 'Minnesota' }, { value: 'MS', label: 'Mississippi' },
  { value: 'MO', label: 'Missouri' }, { value: 'MT', label: 'Montana' }, { value: 'NE', label: 'Nebraska' },
  { value: 'NV', label: 'Nevada' }, { value: 'NH', label: 'New Hampshire' }, { value: 'NJ', label: 'New Jersey' },
  { value: 'NM', label: 'New Mexico' }, { value: 'NY', label: 'New York' }, { value: 'NC', label: 'North Carolina' },
  { value: 'ND', label: 'North Dakota' }, { value: 'OH', label: 'Ohio' }, { value: 'OK', label: 'Oklahoma' },
  { value: 'OR', label: 'Oregon' }, { value: 'PA', label: 'Pennsylvania' }, { value: 'RI', label: 'Rhode Island' },
  { value: 'SC', label: 'South Carolina' }, { value: 'SD', label: 'South Dakota' }, { value: 'TN', label: 'Tennessee' },
  { value: 'TX', label: 'Texas' }, { value: 'UT', label: 'Utah' }, { value: 'VT', label: 'Vermont' },
  { value: 'VA', label: 'Virginia' }, { value: 'WA', label: 'Washington' }, { value: 'WV', label: 'West Virginia' },
  { value: 'WI', label: 'Wisconsin' }, { value: 'WY', label: 'Wyoming' },
];

const STATE_LABEL_BY_CODE = Object.fromEntries(US_STATES.map((state) => [state.value, state.label]));
const STATE_CODE_BY_LABEL = Object.fromEntries(
  US_STATES.map((state) => [state.label.toUpperCase(), state.value])
);

type ProgramLike = {
  federal_or_state?: string | null;
  state_code?: string | null;
  state?: string | null;
};

type ResultLike = {
  status: string;
  program: ProgramLike | null;
  program_id: string;
};

export function getProgramStateCode(program: ProgramLike | null | undefined): string {
  return readProgramStateCode(program);
}

export function normalizeStateCode(state: string | null | undefined): string | undefined {
  const trimmed = (state ?? '').trim();
  if (!trimmed) return undefined;

  const upper = trimmed.toUpperCase();
  if (STATE_LABEL_BY_CODE[upper]) return upper;
  return STATE_CODE_BY_LABEL[upper];
}

/** Nationwide programs with no state — not state implementations of federal programs. */
export function isFederalProgram(program: ProgramLike | null | undefined): boolean {
  if (getProgramStateCode(program)) return false;
  const fedOrState = (program?.federal_or_state ?? '').toLowerCase();
  return fedOrState === 'federal' || fedOrState.includes('federal');
}

export function matchesProfileStateScope(
  program: ProgramLike | null | undefined,
  profileState: string
): boolean {
  const programState = getProgramStateCode(program);
  if (programState) return programState === profileState;
  return isFederalProgram(program);
}

export function stateMatchesQuery(stateCode: string, query: string): boolean {
  const q = query.trim().toLowerCase();
  if (!q) return true;

  const code = stateCode.toLowerCase();
  if (code.includes(q)) return true;

  const label = (STATE_LABEL_BY_CODE[stateCode] ?? '').toLowerCase();
  return label.includes(q);
}

export function computeSummary(results: ResultLike[]): EligibilityResultsSummary {
  const qualified = results.filter((result) =>
    ['qualified', 'likely_qualified'].includes(result.status)
  );

  return {
    qualifiedCount: qualified.length,
    totalMonthlyValueMax: qualified.reduce(
      (acc, result) => acc + ((result.program as { estimated_monthly_value_max?: number } | null)?.estimated_monthly_value_max ?? 0),
      0
    ),
    totalCount: results.length,
  };
}

export function mergeAvailableStateCodes(...codeGroups: string[][]): string[] {
  return [...new Set(codeGroups.flat().map((code) => code.trim().toUpperCase()).filter(Boolean))].sort();
}

export function applyEligibilityFilters<T extends ResultLike>(
  results: T[],
  filters?: EligibilityResultsFilters,
  quarterDueDatesByProgramAndYear?: QuarterDueDatesByProgramAndYear
): T[] {
  if (!filters) return results;

  let filtered = results;

  if (!filters.allStates) {
    if (filters.state) {
      const targetState = filters.state.trim().toUpperCase();
      filtered = filtered.filter((result) =>
        matchesProfileStateScope(result.program, targetState)
      );
    } else if (filters.profileState) {
      filtered = filtered.filter((result) =>
        matchesProfileStateScope(result.program, filters.profileState!)
      );
    }
  }

  if (filters.federal) {
    filtered = filtered.filter((result) => isFederalProgram(result.program));
  }

  if (filters.stateOnly) {
    filtered = filtered.filter((result) => !isFederalProgram(result.program));
  }

  if (filters.stateSearch?.trim()) {
    const query = filters.stateSearch.trim();
    filtered = filtered.filter((result) =>
      stateMatchesQuery(getProgramStateCode(result.program), query)
    );
  }

  const yearFilter = filters.year ?? 'all';
  const quarterFilter = filters.quarter ?? 'all';

  if (quarterDueDatesByProgramAndYear && quarterFilter !== 'all') {
    filtered = filtered.filter((result) => {
      const yearMap = quarterDueDatesByProgramAndYear.get(result.program_id);
      if (!yearMap) return true;
      return programHasMatchingQuarterData(yearMap, yearFilter, quarterFilter);
    });
  }

  return filtered;
}

function parseYearFilter(value: unknown): number | 'all' {
  if (value === 'all' || value === undefined || value === '') return 'all';
  const parsed = typeof value === 'string' ? Number.parseInt(value, 10) : Number(value);
  return Number.isFinite(parsed) && parsed > 0 ? parsed : 'all';
}

export function parseEligibilityResultsFilters(query: Record<string, unknown>): EligibilityResultsFilters {
  const quarter = typeof query.quarter === 'string' ? query.quarter : undefined;
  const validQuarter: Quarter | 'all' =
    quarter === 'all' || quarter === undefined || quarter === ''
      ? 'all'
      : (QUARTERS as readonly string[]).includes(quarter)
        ? (quarter as Quarter)
        : 'all';

  const rawState = typeof query.state === 'string' ? query.state.trim() : '';
  const allStates = rawState.toUpperCase() === 'ALL';

  const page =
    query.page !== undefined && query.page !== ''
      ? Number.parseInt(String(query.page), 10)
      : undefined;
  const limit =
    query.limit !== undefined && query.limit !== ''
      ? Number.parseInt(String(query.limit), 10)
      : undefined;

  return {
    federal: query.federal === 'true' || query.federal === true,
    stateOnly: query.state_only === 'true' || query.state_only === true,
    allStates: allStates || undefined,
    state: rawState && !allStates ? rawState : undefined,
    stateSearch:
      typeof query.state_search === 'string' && query.state_search.trim()
        ? query.state_search.trim()
        : undefined,
    year: parseYearFilter(query.year),
    quarter: validQuarter,
    page: page && Number.isFinite(page) && page >= 1 ? page : undefined,
    limit: limit && Number.isFinite(limit) && limit >= 1 ? limit : undefined,
  };
}
