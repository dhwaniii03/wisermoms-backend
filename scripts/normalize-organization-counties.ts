/**
 * Normalize organization county values to canonical names from zip-master.json.
 *
 * Processes all organizations, including counties stored in `counties_served`
 * (where most seeded org data lives). Updates `county` and `counties_served`.
 *
 * Usage:
 *   npm run counties:normalize:dry-run
 *   npm run counties:normalize
 */
import fs from 'fs';
import path from 'path';
import { callClaudeApi } from '../src/config/anthropic';
import { lookupZipEntry } from '../src/data/zip-master.loader';
import { loadZipMasterDataset } from '../src/data/zip-master.loader';
import { prisma } from '../src/config/prisma';
import { extractZip5 } from '../src/services/zipValidation.service';
import {
  buildCanonicalCountyIndex,
  COUNTY_MATCH_CONFIDENCE_THRESHOLD,
  getCandidateCounties,
  matchCountyDeterministic,
  resolveCountyLabelAlias,
  normalizeCounty,
} from '../src/utils/county.utils';

const REPORT_FILENAME = 'county-normalization-report.json';
const isLiveMode = process.argv.includes('--live');

interface ReportRecord {
  organizationId: string;
  orgName: string;
  state: string | null;
  source: 'county' | 'counties_served' | 'zip';
  originalCounty: string;
  matchedCounty: string;
  confidence: number;
  method: string;
  willUpdate: boolean;
}

interface NormalizationReport {
  matched: ReportRecord[];
  fuzzyMatched: ReportRecord[];
  claudeMatched: ReportRecord[];
  unmatched: ReportRecord[];
  skipped: Array<{
    organizationId: string;
    orgName: string;
    state: string | null;
    reason: string;
  }>;
  errors: Array<{
    organizationId: string;
    orgName: string;
    originalCounty: string | null;
    error: string;
  }>;
}

interface ResolvedCountyMatch {
  match: string;
  confidence: number;
  method: string;
}

interface OrgUpdate {
  id: string;
  orgName: string;
  county: string | null;
  counties_served: string[];
}

function resolveReportPath(): string {
  return path.resolve(process.cwd(), REPORT_FILENAME);
}

function extractJsonObject(text: string): string {
  const fenced = text.match(/```(?:json)?\s*([\s\S]*?)```/);
  if (fenced?.[1]) {
    return fenced[1].trim();
  }

  const start = text.indexOf('{');
  const end = text.lastIndexOf('}');
  if (start >= 0 && end > start) {
    return text.slice(start, end + 1);
  }

  return text.trim();
}

function isStatewideLabel(value: string): boolean {
  return value.trim().toLowerCase() === 'statewide';
}

function resolveAliasedCounty(value: string): string {
  return resolveCountyLabelAlias(value)?.match ?? value;
}

function resolveCountyFieldAfterAliases(
  county: string | null,
  countiesServed: string[]
): string | null {
  if (county?.trim()) {
    const aliased = resolveAliasedCounty(county.trim());
    if (isStatewideLabel(aliased)) return null;
    return aliased;
  }

  const normalizedServed = countiesServed.filter((entry) => !isStatewideLabel(entry));
  if (normalizedServed.length === 1) {
    return normalizedServed[0];
  }

  return null;
}

interface CountySource {
  value: string;
  source: ReportRecord['source'];
}

function collectCountySources(org: {
  county: string | null;
  counties_served: string[];
  zip_code: string | null;
  state: string | null;
}): CountySource[] {
  const sources: CountySource[] = [];
  const seen = new Set<string>();

  const addSource = (value: string, source: CountySource['source']) => {
    const trimmed = value.trim();
    if (!trimmed || isStatewideLabel(trimmed)) return;
    const key = trimmed.toLowerCase();
    if (seen.has(key)) return;
    seen.add(key);
    sources.push({ value: trimmed, source });
  };

  if (org.county?.trim()) {
    addSource(org.county, 'county');
  }

  for (const served of org.counties_served) {
    addSource(served, 'counties_served');
  }

  if (sources.length === 0 && org.zip_code) {
    const zip5 = extractZip5(org.zip_code);
    if (zip5 && zip5 !== '00000') {
      const entry = lookupZipEntry(zip5);
      if (entry?.counties.length === 1) {
        addSource(entry.counties[0], 'zip');
      }
    }
  }

  return sources;
}

async function matchCountyWithClaude(
  orgCounty: string,
  candidates: string[]
): Promise<{ match: string; confidence: number } | null> {
  const systemPrompt = 'You are matching US county names.\n\nReturn ONLY valid JSON.';
  const userPrompt = `You are matching US county names.

Return ONLY valid JSON.

Organization county:
"${orgCounty}"

Available counties:
${JSON.stringify(candidates, null, 2)}

Choose the best matching county.

Return:

{
  "match": "PRINCE GEORGES",
  "confidence": 0.99
}`;

  const response = await callClaudeApi(systemPrompt, userPrompt);
  let parsed: { match?: string | null; confidence?: number };
  try {
    parsed = JSON.parse(extractJsonObject(response)) as {
      match?: string | null;
      confidence?: number;
    };
  } catch {
    return null;
  }

  if (
    typeof parsed.match !== 'string' ||
    typeof parsed.confidence !== 'number' ||
    parsed.confidence < 0 ||
    parsed.confidence > 1 ||
    !candidates.includes(parsed.match)
  ) {
    return null;
  }

  return { match: parsed.match, confidence: parsed.confidence };
}

async function resolveCountyMatch(
  originalCounty: string,
  candidates: string[],
  cache: Map<string, ResolvedCountyMatch | null>
): Promise<ResolvedCountyMatch | null> {
  const cacheKey = `${candidates.length}:${originalCounty.toLowerCase()}`;
  if (cache.has(cacheKey)) {
    return cache.get(cacheKey) ?? null;
  }

  const alias = resolveCountyLabelAlias(originalCounty);
  if (alias) {
    cache.set(cacheKey, alias);
    return alias;
  }

  const deterministic = matchCountyDeterministic(originalCounty, candidates);
  let result: ResolvedCountyMatch | null = null;

  if (
    deterministic &&
    deterministic.method !== 'fuzzy' &&
    deterministic.confidence >= COUNTY_MATCH_CONFIDENCE_THRESHOLD
  ) {
    result = {
      match: deterministic.match,
      confidence: deterministic.confidence,
      method: deterministic.method,
    };
  } else if (
    deterministic?.method === 'fuzzy' &&
    deterministic.confidence >= COUNTY_MATCH_CONFIDENCE_THRESHOLD
  ) {
    result = {
      match: deterministic.match,
      confidence: deterministic.confidence,
      method: 'fuzzy',
    };
  } else {
    const claudeResult = await matchCountyWithClaude(originalCounty, candidates);
    if (claudeResult && claudeResult.confidence >= COUNTY_MATCH_CONFIDENCE_THRESHOLD) {
      result = {
        match: claudeResult.match,
        confidence: claudeResult.confidence,
        method: 'claude',
      };
    }
  }

  cache.set(cacheKey, result);
  return result;
}

function createEmptyReport(): NormalizationReport {
  return {
    matched: [],
    fuzzyMatched: [],
    claudeMatched: [],
    unmatched: [],
    skipped: [],
    errors: [],
  };
}

function summarizeUnmatched(report: NormalizationReport): Array<{ county: string; count: number }> {
  const counts = new Map<string, number>();
  for (const record of report.unmatched) {
    counts.set(record.originalCounty, (counts.get(record.originalCounty) ?? 0) + 1);
  }

  return Array.from(counts.entries())
    .map(([county, count]) => ({ county, count }))
    .sort((a, b) => b.count - a.count || a.county.localeCompare(b.county));
}

function pushReportRecord(
  report: NormalizationReport,
  record: ReportRecord,
  method: string
): void {
  if (method === 'fuzzy') {
    report.fuzzyMatched.push(record);
  } else if (method === 'claude') {
    report.claudeMatched.push(record);
  } else {
    report.matched.push(record);
  }
}

function applyReplacementsToCountiesServed(
  countiesServed: string[],
  replacements: Map<string, string>
): string[] {
  return countiesServed.map((entry) => {
    if (isStatewideLabel(entry)) return entry;
    const trimmed = entry.trim();
    return replacements.get(trimmed) ?? resolveAliasedCounty(trimmed);
  });
}

function arraysEqual(a: string[], b: string[]): boolean {
  if (a.length !== b.length) return false;
  return a.every((value, index) => value === b[index]);
}

async function main() {
  console.log(`County normalization starting (${isLiveMode ? 'LIVE' : 'DRY-RUN'})...`);

  const dataset = loadZipMasterDataset();
  const countyIndex = buildCanonicalCountyIndex(dataset);
  const matchCache = new Map<string, ResolvedCountyMatch | null>();

  const organizations = await prisma.organization.findMany({
    select: {
      id: true,
      org_name: true,
      state: true,
      county: true,
      counties_served: true,
      zip_code: true,
    },
    orderBy: { org_name: 'asc' },
  });

  const report = createEmptyReport();
  const orgUpdates: OrgUpdate[] = [];
  let countyValuesProcessed = 0;

  for (const org of organizations) {
    const sources = collectCountySources(org);

    if (sources.length === 0) {
      report.skipped.push({
        organizationId: org.id,
        orgName: org.org_name,
        state: org.state,
        reason: 'No county, counties_served, or single-county ZIP to normalize',
      });
      continue;
    }

    const candidates = getCandidateCounties(countyIndex, org.state);
    const replacements = new Map<string, string>();

    try {
      for (const source of sources) {
        countyValuesProcessed++;
        const resolved = await resolveCountyMatch(source.value, candidates, matchCache);
        const willUpdate = Boolean(resolved && resolved.match !== source.value);
        const record: ReportRecord = {
          organizationId: org.id,
          orgName: org.org_name,
          state: org.state,
          source: source.source,
          originalCounty: source.value,
          matchedCounty: resolved?.match ?? source.value,
          confidence: resolved?.confidence ?? 0,
          method: resolved?.method ?? 'unmatched',
          willUpdate,
        };

        if (!resolved || resolved.confidence < COUNTY_MATCH_CONFIDENCE_THRESHOLD) {
          report.unmatched.push(record);
          continue;
        }

        replacements.set(source.value, resolved.match);
        pushReportRecord(report, record, resolved.method);
      }

      const nextCountiesServed = applyReplacementsToCountiesServed(
        org.counties_served,
        replacements
      );

      const nextCounty = resolveCountyFieldAfterAliases(org.county, nextCountiesServed);

      const countyChanged = (org.county ?? null) !== (nextCounty ?? null);
      const servedChanged = !arraysEqual(org.counties_served, nextCountiesServed);

      if (countyChanged || servedChanged) {
        orgUpdates.push({
          id: org.id,
          orgName: org.org_name,
          county: nextCounty,
          counties_served: nextCountiesServed,
        });
      }
    } catch (error) {
      report.errors.push({
        organizationId: org.id,
        orgName: org.org_name,
        originalCounty: org.county,
        error: error instanceof Error ? error.message : String(error),
      });
    }
  }

  const reportPath = resolveReportPath();
  fs.writeFileSync(reportPath, JSON.stringify(report, null, 2));

  if (isLiveMode) {
    for (const update of orgUpdates) {
      await prisma.organization.update({
        where: { id: update.id },
        data: {
          county: update.county,
          counties_served: update.counties_served,
        },
      });
      console.log(
        `Updated ${update.orgName}: county=${update.county ?? 'null'}, counties_served=[${update.counties_served.join(', ')}]`
      );
    }
  }

  const topUnmatched = summarizeUnmatched(report).slice(0, 10);
  const proposedChanges = orgUpdates;

  console.log('\n=== County Normalization Summary ===');
  console.log(`Mode: ${isLiveMode ? 'LIVE' : 'DRY-RUN'}`);
  console.log(`Total organizations: ${organizations.length}`);
  console.log(`Organizations skipped (no county data): ${report.skipped.length}`);
  console.log(`County values processed: ${countyValuesProcessed}`);
  console.log(`Exact/deterministic matches: ${report.matched.length}`);
  console.log(`Fuzzy matches: ${report.fuzzyMatched.length}`);
  console.log(`Claude matches: ${report.claudeMatched.length}`);
  console.log(`Unmatched county values: ${report.unmatched.length}`);
  console.log(`Errors: ${report.errors.length}`);
  console.log(`Organizations ${isLiveMode ? 'updated' : 'to update'}: ${orgUpdates.length}`);
  console.log(`Report written to: ${reportPath}`);

  if (topUnmatched.length > 0) {
    console.log('\nTop unmatched counties:');
    for (const item of topUnmatched) {
      console.log(`  - ${item.county} (${item.count})`);
    }
  }

  if (report.claudeMatched.length > 0) {
    console.log('\nClaude decisions:');
    for (const record of report.claudeMatched.slice(0, 20)) {
      console.log(
        `  - ${record.originalCounty} -> ${record.matchedCounty} (${record.confidence.toFixed(2)})`
      );
    }
    if (report.claudeMatched.length > 20) {
      console.log(`  ... and ${report.claudeMatched.length - 20} more (see report)`);
    }
  }

  if (proposedChanges.length > 0) {
    console.log(`\nOrganizations ${isLiveMode ? 'modified' : 'proposed for update'}:`);
    for (const update of proposedChanges.slice(0, 25)) {
      console.log(
        `  - ${update.orgName}: county=${update.county ?? 'null'}, counties_served=[${update.counties_served.join(', ')}]`
      );
    }
    if (proposedChanges.length > 25) {
      console.log(`  ... and ${proposedChanges.length - 25} more (see report)`);
    }
  }

  console.log('\nNormalization examples:');
  for (const example of [
    'Los Angeles County',
    'St. Louis County',
    "Prince George's County",
    'Jefferson Parish',
    'Anchorage Borough',
  ]) {
    console.log(`  ${example} -> ${normalizeCounty(example)}`);
  }
}

main()
  .catch((error) => {
    console.error('County normalization failed:', error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
