/**
 * Manual scraper for IRS Employment Tax Due Dates.
 *
 * Usage:
 *   npm run scrape:irs
 *   npx tsx src/scripts/scrapers/irs-due-dates.ts
 *   npx tsx src/scripts/scrapers/irs-due-dates.ts 2026
 *
 * Optional env:
 *   IRS_EMPLOYMENT_TAX_PROGRAM_ID — override default program id (eitc)
 */
import axios from 'axios';
import * as cheerio from 'cheerio';
import type { CheerioAPI } from 'cheerio';
import { callClaudeApi } from '../../config/anthropic';
import { prisma } from '../../config/prisma';
import { quarterDueDatesService } from '../../modules/programs/quarterDueDates.service';
import { Quarter, QUARTERS } from '../../modules/programs/quarterDueDates.types';

const IRS_EMPLOYMENT_TAX_URL =
  'https://www.irs.gov/businesses/small-businesses-self-employed/employment-tax-due-dates';

const DEFAULT_PROGRAM_ID = 'eitc';

const MONTH_NAME_TO_NUMBER: Record<string, number> = {
  jan: 1,
  january: 1,
  feb: 2,
  february: 2,
  mar: 3,
  march: 3,
  apr: 4,
  april: 4,
  may: 5,
  jun: 6,
  june: 6,
  jul: 7,
  july: 7,
  aug: 8,
  august: 8,
  sep: 9,
  sept: 9,
  september: 9,
  oct: 10,
  october: 10,
  nov: 11,
  november: 11,
  dec: 12,
  december: 12,
};

const MONTH_NUMBER_TO_NAME: Record<number, string> = {
  1: 'January',
  2: 'February',
  3: 'March',
  4: 'April',
  5: 'May',
  6: 'June',
  7: 'July',
  8: 'August',
  9: 'September',
  10: 'October',
  11: 'November',
  12: 'December',
};

export interface ScrapedQuarterDueDates {
  renewalPeriodMonths: number;
  quarterDueDates: Record<Quarter, string>;
}

interface ParsedMonthDay {
  month: number;
  day: number;
}

function normalizeWhitespace(text: string): string {
  return text.replace(/\s+/g, ' ').trim();
}

function parseMonthDayToken(token: string): ParsedMonthDay | null {
  const match = token.trim().match(/^([A-Za-z]+)\.?\s+(\d{1,2})$/);
  if (!match) return null;

  const month = MONTH_NAME_TO_NUMBER[match[1].toLowerCase()];
  const day = Number(match[2]);

  if (!month || day < 1 || day > 31) return null;
  return { month, day };
}

function formatMonthDay({ month, day }: ParsedMonthDay): string {
  return `${MONTH_NUMBER_TO_NAME[month]} ${day}`;
}

function selectMainBodyContent($: CheerioAPI) {
  const candidates = [
    $('article.pup-article .field--name-body').first(),
    $('.region-content .field--name-body').first(),
    $('[role="main"] .field--name-body').first(),
    $('#main-content .field--name-body').first(),
    $('article.pup-article').first(),
    $('.region-content').first(),
  ];

  for (const candidate of candidates) {
    if (candidate.length > 0) {
      return candidate;
    }
  }

  throw new Error('Main page body content section not found on IRS page');
}

export function extractMainContentHtml(html: string): CheerioAPI {
  const $ = cheerio.load(html);
  const bodyContent = selectMainBodyContent($);

  bodyContent.find('nav, footer, .related-links, .breadcrumb, script, style').remove();
  return cheerio.load(bodyContent.html() ?? '');
}

export function extractQuarterlySectionText(html: string): string | null {
  const $ = extractMainContentHtml(html);
  const heading = $('h1, h2, h3, h4, h5, h6')
    .filter((_, element) => normalizeWhitespace($(element).text()).includes('Forms filed quarterly'))
    .first();

  if (heading.length === 0) {
    return null;
  }

  const parts: string[] = [normalizeWhitespace(heading.text())];
  let sibling = heading.next();

  while (sibling.length > 0) {
    if (sibling.is('h1, h2, h3, h4, h5, h6')) break;
    const text = normalizeWhitespace(sibling.text());
    if (text) parts.push(text);
    sibling = sibling.next();
  }

  return parts.join('\n');
}

export function parseQuarterDueDatesDeterministic(sectionText: string): ScrapedQuarterDueDates | null {
  const quarterlyMatch = sectionText.match(
    /Forms filed quarterly with due dates of\s+(.+?)(?:\s*\(|$)/i
  );

  if (!quarterlyMatch) {
    return null;
  }

  const dateSegment = quarterlyMatch[1];
  const tokens = dateSegment
    .split(/\s*,\s*|\s+and\s+/i)
    .map((token) => token.trim())
    .filter(Boolean);

  if (tokens.length !== 4) {
    return null;
  }

  const parsedDates = tokens.map(parseMonthDayToken);
  if (parsedDates.some((date) => date == null)) {
    return null;
  }

  const quarterDueDates = {
    Q1: formatMonthDay(parsedDates[0]!),
    Q2: formatMonthDay(parsedDates[1]!),
    Q3: formatMonthDay(parsedDates[2]!),
    Q4: formatMonthDay(parsedDates[3]!),
  };

  return {
    renewalPeriodMonths: 3,
    quarterDueDates,
  };
}

function stripJsonFences(text: string): string {
  const trimmed = text.trim();
  const fenced = trimmed.match(/^```(?:json)?\s*([\s\S]*?)\s*```$/i);
  return fenced ? fenced[1].trim() : trimmed;
}

function validateScrapedData(data: unknown): ScrapedQuarterDueDates | null {
  if (!data || typeof data !== 'object') return null;

  const record = data as Record<string, unknown>;
  if (record.renewalPeriodMonths !== 3) return null;
  if (!record.quarterDueDates || typeof record.quarterDueDates !== 'object') return null;

  const quarterDueDates = record.quarterDueDates as Record<string, unknown>;
  const result = {} as Record<Quarter, string>;

  for (const quarter of QUARTERS) {
    const value = quarterDueDates[quarter.toLowerCase()] ?? quarterDueDates[quarter];
    if (typeof value !== 'string' || !value.trim()) return null;

    const parsed = parseMonthDayToken(value.trim());
    if (!parsed) return null;
    result[quarter] = formatMonthDay(parsed);
  }

  return {
    renewalPeriodMonths: 3,
    quarterDueDates: result,
  };
}

async function parseQuarterDueDatesWithClaude(sectionText: string): Promise<ScrapedQuarterDueDates> {
  const systemPrompt =
    'You extract IRS employment tax quarterly due dates from government web page text. Return ONLY valid JSON with no markdown or commentary.';

  const userPrompt = `Extract renewal frequency and quarter due dates from this IRS page section.

Return exactly this JSON shape:
{
  "renewalPeriodMonths": 3,
  "quarterDueDates": {
    "q1": "April 30",
    "q2": "July 31",
    "q3": "October 31",
    "q4": "January 31"
  }
}

Section text:
${sectionText}`;

  const response = await callClaudeApi(systemPrompt, userPrompt);
  const jsonText = stripJsonFences(response);

  let parsed: unknown;
  try {
    parsed = JSON.parse(jsonText);
  } catch {
    throw new Error(`Claude fallback returned invalid JSON: ${jsonText.slice(0, 200)}`);
  }

  const validated = validateScrapedData(parsed);
  if (!validated) {
    throw new Error('Claude fallback JSON did not match expected quarter due date shape');
  }

  return validated;
}

export function monthDayLabelToIso(
  label: string,
  quarter: Quarter,
  calendarYear: number
): string {
  const parsed = parseMonthDayToken(label);
  if (!parsed) {
    throw new Error(`Unable to convert "${label}" to ISO date`);
  }

  const dueYear = quarter === 'Q4' && parsed.month === 1 ? calendarYear + 1 : calendarYear;
  const month = String(parsed.month).padStart(2, '0');
  const day = String(parsed.day).padStart(2, '0');
  return `${dueYear}-${month}-${day}`;
}

function buildDeterministicIsoDates(
  labels: Record<Quarter, string>,
  calendarYear: number
): Record<Quarter, string> {
  return {
    Q1: monthDayLabelToIso(labels.Q1, 'Q1', calendarYear),
    Q2: monthDayLabelToIso(labels.Q2, 'Q2', calendarYear),
    Q3: monthDayLabelToIso(labels.Q3, 'Q3', calendarYear),
    Q4: monthDayLabelToIso(labels.Q4, 'Q4', calendarYear),
  };
}

function isValidIsoDate(value: string): boolean {
  return /^\d{4}-\d{2}-\d{2}$/.test(value) && !Number.isNaN(Date.parse(`${value}T00:00:00.000Z`));
}

function validateResolvedIsoDates(
  data: unknown,
  labels: Record<Quarter, string>,
  calendarYear: number
): Record<Quarter, string> | null {
  if (!data || typeof data !== 'object') return null;

  const record = data as Record<string, unknown>;
  const quarterIsoDates = record.quarterIsoDates;
  if (!quarterIsoDates || typeof quarterIsoDates !== 'object') return null;

  const raw = quarterIsoDates as Record<string, unknown>;
  const result = {} as Record<Quarter, string>;

  for (const quarter of QUARTERS) {
    const value = raw[quarter.toLowerCase()] ?? raw[quarter];
    if (typeof value !== 'string' || !isValidIsoDate(value)) return null;
    result[quarter] = value;
  }

  const q4Year = Number(result.Q4.slice(0, 4));
  if (q4Year !== calendarYear + 1) return null;

  for (const quarter of QUARTERS) {
    if (quarter === 'Q4') continue;
    if (!result[quarter].startsWith(`${calendarYear}-`)) return null;

    const label = labels[quarter];
    const expected = monthDayLabelToIso(label, quarter, calendarYear);
    if (result[quarter] !== expected) return null;
  }

  const q4Expected = monthDayLabelToIso(labels.Q4, 'Q4', calendarYear);
  if (result.Q4 !== q4Expected) return null;

  return result;
}

async function resolveQuarterIsoDatesWithClaude(
  sectionText: string,
  labels: Record<Quarter, string>,
  calendarYear: number
): Promise<Record<Quarter, string>> {
  const systemPrompt =
    'You assign calendar years to IRS quarterly employment tax due dates. Return ONLY valid JSON with no markdown or commentary.';

  const userPrompt = `Convert these quarterly due date labels into ISO dates (YYYY-MM-DD) for calendar year ${calendarYear}.

Rules:
- Q1, Q2, and Q3 due dates fall in ${calendarYear}.
- Q4 is January 31 for the fourth quarter of the previous calendar year, so it falls in ${calendarYear + 1}.

Labels:
Q1: ${labels.Q1}
Q2: ${labels.Q2}
Q3: ${labels.Q3}
Q4: ${labels.Q4}

IRS section context:
${sectionText}

Return exactly:
{
  "quarterIsoDates": {
    "q1": "${calendarYear}-04-30",
    "q2": "${calendarYear}-07-31",
    "q3": "${calendarYear}-10-31",
    "q4": "${calendarYear + 1}-01-31"
  }
}`;

  const response = await callClaudeApi(systemPrompt, userPrompt);
  const jsonText = stripJsonFences(response);

  let parsed: unknown;
  try {
    parsed = JSON.parse(jsonText);
  } catch {
    throw new Error(`Claude ISO resolution returned invalid JSON: ${jsonText.slice(0, 200)}`);
  }

  const validated = validateResolvedIsoDates(parsed, labels, calendarYear);
  if (!validated) {
    throw new Error('Claude ISO resolution JSON did not match expected quarter date shape');
  }

  return validated;
}

async function resolveQuarterIsoDates(
  sectionText: string,
  labels: Record<Quarter, string>,
  calendarYear: number
): Promise<Record<Quarter, string>> {
  try {
    console.log('Resolving quarter ISO dates with Anthropic...');
    const resolved = await resolveQuarterIsoDatesWithClaude(sectionText, labels, calendarYear);
    console.log('Resolved ISO due dates:', resolved);
    return resolved;
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    console.log(`Anthropic ISO resolution failed (${message}); using deterministic fallback.`);
    const fallback = buildDeterministicIsoDates(labels, calendarYear);
    console.log('Resolved ISO due dates:', fallback);
    return fallback;
  }
}

async function fetchIrsPage(): Promise<string> {
  const response = await axios.get<string>(IRS_EMPLOYMENT_TAX_URL, {
    headers: {
      'User-Agent': 'MomPlan IRS Due Dates Scraper/1.0 (+manual admin sync)',
      Accept: 'text/html,application/xhtml+xml',
    },
    timeout: 30_000,
    responseType: 'text',
  });

  if (!response.data || typeof response.data !== 'string') {
    throw new Error('IRS page response was empty');
  }

  return response.data;
}

async function scrapeQuarterDueDates(
  html: string
): Promise<{ scraped: ScrapedQuarterDueDates; sectionText: string }> {
  const sectionText = extractQuarterlySectionText(html);
  if (!sectionText) {
    throw new Error(
      'Deterministic extraction failed: quarterly section containing "Forms filed quarterly" was not found in main content'
    );
  }

  const deterministic = parseQuarterDueDatesDeterministic(sectionText);
  if (deterministic) {
    return { scraped: deterministic, sectionText };
  }

  console.log('Deterministic parsing failed; attempting Anthropic fallback...');
  return { scraped: await parseQuarterDueDatesWithClaude(sectionText), sectionText };
}

async function main() {
  const yearArg = process.argv[2];
  const calendarYear = yearArg ? Number(yearArg) : new Date().getUTCFullYear();

  if (!Number.isInteger(calendarYear) || calendarYear < 2000 || calendarYear > 2100) {
    throw new Error('Year must be an integer between 2000 and 2100');
  }

  console.log('Starting IRS scrape...');

  const html = await fetchIrsPage();
  const { scraped, sectionText } = await scrapeQuarterDueDates(html);

  console.log('Found quarterly due dates...', scraped.quarterDueDates);

  const programId = process.env.IRS_EMPLOYMENT_TAX_PROGRAM_ID?.trim() || DEFAULT_PROGRAM_ID;
  const program = await prisma.benefitProgram.findUnique({ where: { id: programId } });
  if (!program) {
    throw new Error(`Program not found: ${programId}`);
  }

  console.log(`Updating program... (${program.name})`);

  if (program.renewal_period_months !== scraped.renewalPeriodMonths) {
    await prisma.benefitProgram.update({
      where: { id: program.id },
      data: { renewal_period_months: scraped.renewalPeriodMonths },
    });
    console.log(`Updated renewal_period_months: ${scraped.renewalPeriodMonths}`);
  } else {
    console.log(`renewal_period_months unchanged (${program.renewal_period_months ?? 'null'})`);
  }

  const isoDates = await resolveQuarterIsoDates(sectionText, scraped.quarterDueDates, calendarYear);

  console.log('Updating quarter due dates...');

  for (const quarter of QUARTERS) {
    const label = scraped.quarterDueDates[quarter];
    const isoDate = isoDates[quarter];

    const existing = await prisma.programQuarterDueDate.findUnique({
      where: {
        program_id_year_quarter: {
          program_id: program.id,
          year: calendarYear,
          quarter,
        },
      },
    });

    await quarterDueDatesService.upsertGovtQuarterData({
      program_id: program.id,
      year: calendarYear,
      quarter,
      due_dates: [isoDate],
    });

    const action = existing ? 'updated' : 'inserted';
    console.log(`  ${action} ${quarter}: ${label} -> ${isoDate}`);
  }

  console.log('Completed successfully.');
}

main()
  .catch((error: unknown) => {
    const message = error instanceof Error ? error.message : String(error);
    console.error(`IRS scrape failed: ${message}`);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
