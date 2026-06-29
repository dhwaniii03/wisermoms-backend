import type { ZipMasterDataset } from '../data/zip-master.types';

const COUNTY_SUFFIXES = [
  'CITY AND BOROUGH',
  'CENSUS AREA',
  'BOROUGH',
  'PARISH',
  'COUNTY',
] as const;

const ABBREVIATION_REPLACEMENTS: Array<[RegExp, string]> = [
  [/\bSAINT\b/g, 'ST'],
  [/\bMOUNT\b/g, 'MT'],
  [/\bFORT\b/g, 'FT'],
];

export type CountyMatchMethod =
  | 'exact'
  | 'case_insensitive'
  | 'whitespace_insensitive'
  | 'punctuation_insensitive'
  | 'fuzzy'
  | 'alias';

export interface CountyMatchResult {
  match: string;
  confidence: number;
  method: CountyMatchMethod;
}

export interface CountyLabelAliasResult {
  match: string;
  confidence: number;
  method: 'alias';
}

/** Non-canonical seed labels mapped to ZIP dataset / app conventions. */
const COUNTY_LABEL_ALIASES: Record<string, string> = {
  'north fulton': 'FULTON',
  'all counties': 'statewide',
};

export function resolveCountyLabelAlias(value: string): CountyLabelAliasResult | null {
  const match = COUNTY_LABEL_ALIASES[value.trim().toLowerCase()];
  if (!match) return null;
  return { match, confidence: 1, method: 'alias' };
}

export function applyCountyLabelAlias(value: string): string {
  return resolveCountyLabelAlias(value)?.match ?? value;
}

export function isStatewideCountyLabel(value: string): boolean {
  return value.trim().toLowerCase() === 'statewide';
}

export interface CanonicalCountyIndex {
  allCounties: string[];
  countiesByState: Map<string, string[]>;
}

export function normalizeCounty(county: string): string {
  let normalized = county.trim().toUpperCase();
  normalized = normalized.replace(/\./g, '');
  normalized = normalized.replace(/'/g, '');
  normalized = normalized.replace(/\s+/g, ' ').trim();

  for (const suffix of COUNTY_SUFFIXES) {
    const suffixPattern = new RegExp(`\\s+${suffix.replace(/\s+/g, '\\s+')}$`);
    normalized = normalized.replace(suffixPattern, '').trim();
  }

  for (const [pattern, replacement] of ABBREVIATION_REPLACEMENTS) {
    normalized = normalized.replace(pattern, replacement);
  }

  return normalized.replace(/\s+/g, ' ').trim();
}

function stripWhitespace(value: string): string {
  return value.replace(/\s+/g, '');
}

function stripPunctuation(value: string): string {
  return value
    .replace(/[^A-Z0-9\s]/gi, '')
    .replace(/\s+/g, ' ')
    .trim();
}

export function levenshteinDistance(a: string, b: string): number {
  if (a === b) return 0;
  if (a.length === 0) return b.length;
  if (b.length === 0) return a.length;

  const matrix: number[][] = Array.from({ length: a.length + 1 }, () =>
    Array(b.length + 1).fill(0)
  );

  for (let i = 0; i <= a.length; i++) matrix[i][0] = i;
  for (let j = 0; j <= b.length; j++) matrix[0][j] = j;

  for (let i = 1; i <= a.length; i++) {
    for (let j = 1; j <= b.length; j++) {
      const cost = a[i - 1] === b[j - 1] ? 0 : 1;
      matrix[i][j] = Math.min(
        matrix[i - 1][j] + 1,
        matrix[i][j - 1] + 1,
        matrix[i - 1][j - 1] + cost
      );
    }
  }

  return matrix[a.length][b.length];
}

export function computeFuzzyConfidence(a: string, b: string): number {
  const maxLen = Math.max(a.length, b.length);
  if (maxLen === 0) return 1;
  return 1 - levenshteinDistance(a, b) / maxLen;
}

export function buildCanonicalCountyIndex(dataset: ZipMasterDataset): CanonicalCountyIndex {
  const all = new Set<string>();
  const byState = new Map<string, Set<string>>();

  for (const entry of Object.values(dataset)) {
    for (const county of entry.counties) {
      all.add(county);
      const stateCounties = byState.get(entry.stateCode) ?? new Set<string>();
      stateCounties.add(county);
      byState.set(entry.stateCode, stateCounties);
    }
  }

  return {
    allCounties: Array.from(all).sort(),
    countiesByState: new Map(
      Array.from(byState.entries()).map(([state, counties]) => [
        state,
        Array.from(counties).sort(),
      ])
    ),
  };
}

export function getCandidateCounties(
  index: CanonicalCountyIndex,
  stateCode?: string | null
): string[] {
  if (stateCode) {
    const normalizedState = stateCode.trim().toUpperCase();
    const stateCounties = index.countiesByState.get(normalizedState);
    if (stateCounties?.length) {
      return stateCounties;
    }
  }

  return index.allCounties;
}

export function matchCountyDeterministic(
  orgCounty: string,
  candidates: string[]
): CountyMatchResult | null {
  const trimmed = orgCounty.trim();
  if (!trimmed) return null;

  for (const candidate of candidates) {
    if (trimmed === candidate) {
      return { match: candidate, confidence: 1, method: 'exact' };
    }
  }

  const normalized = normalizeCounty(trimmed);

  for (const candidate of candidates) {
    if (normalized === normalizeCounty(candidate)) {
      return { match: candidate, confidence: 1, method: 'exact' };
    }
  }

  for (const candidate of candidates) {
    if (normalized === candidate.toUpperCase()) {
      return { match: candidate, confidence: 1, method: 'case_insensitive' };
    }
  }

  const whitespaceNormalized = stripWhitespace(normalized);
  for (const candidate of candidates) {
    if (whitespaceNormalized === stripWhitespace(normalizeCounty(candidate))) {
      return { match: candidate, confidence: 1, method: 'whitespace_insensitive' };
    }
  }

  const punctuationNormalized = stripWhitespace(stripPunctuation(normalized));
  for (const candidate of candidates) {
    const candidateKey = stripWhitespace(stripPunctuation(normalizeCounty(candidate)));
    if (punctuationNormalized === candidateKey) {
      return { match: candidate, confidence: 1, method: 'punctuation_insensitive' };
    }
  }

  let best: CountyMatchResult | null = null;
  for (const candidate of candidates) {
    const confidence = computeFuzzyConfidence(
      stripWhitespace(normalized),
      stripWhitespace(normalizeCounty(candidate))
    );
    if (!best || confidence > best.confidence) {
      best = { match: candidate, confidence, method: 'fuzzy' };
    }
  }

  return best;
}

export const COUNTY_MATCH_CONFIDENCE_THRESHOLD = 0.9;
