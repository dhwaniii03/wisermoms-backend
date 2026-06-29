/**
 * Manual scraper for Healthcare.gov Grace Period page.
 * Determines renewal/payment frequency (renewal_period_months) only — no due dates.
 *
 * Usage:
 *   npm run scrape:healthcare-gov
 *   npx tsx src/scripts/scrapers/healthcare-gov-grace-period.ts
 *   npx tsx src/scripts/scrapers/healthcare-gov-grace-period.ts 2026
 *
 * Optional env:
 *   HEALTHCARE_GOV_GRACE_PERIOD_PROGRAM_ID — override program lookup
 *
 * After updating renewal_period_months, backfills program_quarter_due_dates for
 * that program only (same logic as prisma/backfill_quarter_due_dates.ts).
 */
import axios from 'axios';
import * as cheerio from 'cheerio';
import type { CheerioAPI } from 'cheerio';
import { callClaudeApi } from '../../config/anthropic';
import { prisma } from '../../config/prisma';
import { quarterDueDatesService } from '../../modules/programs/quarterDueDates.service';

const HEALTHCARE_GOV_GRACE_PERIOD_URL =
  'https://www.healthcare.gov/apply-and-enroll/health-insurance-grace-period/';

const GRACE_PERIOD_PATH = '/apply-and-enroll/health-insurance-grace-period/';

/** Default program for Healthcare.gov grace period coverage (override via env or source_url lookup). */
const DEFAULT_PROGRAM_ID = 'medicaid';

const VALID_RENEWAL_PERIODS = new Set([1, 3, 6, 12]);
const MIN_CONFIDENCE = 0.8;

export interface RenewalFrequencyClassification {
  renewalPeriodMonths: number | null;
  confidence: number;
  reasoning: string;
}

function normalizeWhitespace(text: string): string {
  return text.replace(/\s+/g, ' ').trim();
}

function selectArticleContent($: CheerioAPI) {
  const candidates = [
    $('.learn-explainer-content').first(),
    $('[class*="learn-explainer-content"]').first(),
    $('main#main .index-module--content--6c4f4').first(),
    $('main#main').first(),
  ];

  for (const candidate of candidates) {
    if (candidate.length > 0) {
      return candidate;
    }
  }

  throw new Error('Main article content section not found on Healthcare.gov page');
}

function flattenGlossaryTriggers($: CheerioAPI, root: ReturnType<CheerioAPI>) {
  root.find('.ds-c-tooltip__trigger').each((_, element) => {
    const trigger = $(element);
    const label = normalizeWhitespace(trigger.find('span').first().text() || trigger.text());
    trigger.replaceWith(label ? ` ${label} ` : ' ');
  });
}

export function extractArticleText(html: string): string {
  const $ = cheerio.load(html);
  const article = selectArticleContent($).clone();

  article
    .find(
      [
        'nav',
        'footer',
        'script',
        'style',
        'svg',
        'dialog',
        '.ds-c-tooltip',
        '.ds-c-tooltip__content',
        '.index-module--email-rss--0a5d1',
        '.index-module--mobile-email-rss--64dcb',
        '.learn-explainer-nav',
        '.ExplainerNav-module--explainer-nav--e5b31',
        '#back-to-top',
        '#q-survey',
      ].join(', ')
    )
    .remove();

  flattenGlossaryTriggers($, article);

  return normalizeWhitespace(article.text());
}

function stripJsonFences(text: string): string {
  const trimmed = text.trim();
  const fenced = trimmed.match(/^```(?:json)?\s*([\s\S]*?)\s*```$/i);
  return fenced ? fenced[1].trim() : trimmed;
}

function validateClassification(data: unknown): RenewalFrequencyClassification | null {
  if (!data || typeof data !== 'object') return null;

  const record = data as Record<string, unknown>;
  const renewalPeriodMonths = record.renewalPeriodMonths;
  const confidence = record.confidence;
  const reasoning = record.reasoning;

  if (
    renewalPeriodMonths !== null &&
    (typeof renewalPeriodMonths !== 'number' ||
      !VALID_RENEWAL_PERIODS.has(renewalPeriodMonths))
  ) {
    return null;
  }

  if (typeof confidence !== 'number' || confidence < 0 || confidence > 1) {
    return null;
  }

  if (typeof reasoning !== 'string' || !reasoning.trim()) {
    return null;
  }

  return {
    renewalPeriodMonths: renewalPeriodMonths as number | null,
    confidence,
    reasoning: reasoning.trim(),
  };
}

function frequencyLabel(months: number): string {
  switch (months) {
    case 1:
      return 'monthly';
    case 3:
      return 'quarterly';
    case 6:
      return 'semiannual';
    case 12:
      return 'annual';
    default:
      return `${months}-month`;
  }
}

async function classifyRenewalFrequencyWithClaude(
  articleText: string
): Promise<RenewalFrequencyClassification> {
  const systemPrompt =
    'You analyze government benefits pages to determine recurring payment, renewal, certification, reporting, or filing frequency. Return ONLY valid JSON with no markdown or commentary.';

  const userPrompt = `Analyze this government benefits page.

Determine whether the page clearly implies a recurring payment, renewal, certification, reporting, or filing frequency.

Return only valid JSON:

{
  "renewalPeriodMonths": number | null,
  "confidence": number,
  "reasoning": string
}

Rules:
- Monthly payment cycle = 1
- Quarterly cycle = 3
- Semiannual cycle = 6
- Annual cycle = 12
- If frequency cannot be determined, return null.
- Do not infer dates that are not stated.
- Use the strongest recurring frequency clearly described in the page.

Page text:
${articleText}`;

  const response = await callClaudeApi(systemPrompt, userPrompt);
  const jsonText = stripJsonFences(response);

  let parsed: unknown;
  try {
    parsed = JSON.parse(jsonText);
  } catch {
    throw new Error(`Claude returned invalid JSON: ${jsonText.slice(0, 200)}`);
  }

  const validated = validateClassification(parsed);
  if (!validated) {
    throw new Error('Claude JSON did not match expected renewal frequency shape');
  }

  return validated;
}

async function fetchHealthcareGovPage(): Promise<string> {
  const response = await axios.get<string>(HEALTHCARE_GOV_GRACE_PERIOD_URL, {
    headers: {
      'User-Agent': 'MomPlan Healthcare.gov Grace Period Scraper/1.0 (+manual admin sync)',
      Accept: 'text/html,application/xhtml+xml',
    },
    timeout: 30_000,
    responseType: 'text',
  });

  if (!response.data || typeof response.data !== 'string') {
    throw new Error('Healthcare.gov page response was empty');
  }

  return response.data;
}

async function resolveProgramId(): Promise<string> {
  const envId = process.env.HEALTHCARE_GOV_GRACE_PERIOD_PROGRAM_ID?.trim();
  if (envId) {
    return envId;
  }

  const linked = await prisma.benefitProgram.findFirst({
    where: {
      OR: [
        { source_url: HEALTHCARE_GOV_GRACE_PERIOD_URL },
        { guide_url: HEALTHCARE_GOV_GRACE_PERIOD_URL },
        { source_url: { contains: GRACE_PERIOD_PATH } },
        { guide_url: { contains: GRACE_PERIOD_PATH } },
      ],
    },
    select: { id: true },
  });

  if (linked) {
    return linked.id;
  }

  const marketplace = await prisma.benefitProgram.findFirst({
    where: {
      OR: [
        { id: DEFAULT_PROGRAM_ID },
        { name: { contains: 'Marketplace', mode: 'insensitive' } },
        {
          AND: [
            { application_url: { contains: 'healthcare.gov' } },
            { NOT: { application_url: { contains: 'medicaid-chip' } } },
          ],
        },
      ],
    },
    select: { id: true },
  });

  if (marketplace) {
    return marketplace.id;
  }

  return DEFAULT_PROGRAM_ID;
}

async function main() {
  const yearArg = process.argv[2];
  const calendarYear = yearArg ? Number(yearArg) : new Date().getUTCFullYear();

  if (!Number.isInteger(calendarYear) || calendarYear < 2000 || calendarYear > 2100) {
    throw new Error('Year must be an integer between 2000 and 2100');
  }

  console.log('Starting Healthcare.gov scrape...');

  const html = await fetchHealthcareGovPage();

  console.log('Extracting article text...');
  const articleText = extractArticleText(html);

  if (!articleText) {
    throw new Error('Extracted article text was empty');
  }

  console.log('Sending content to Claude...');
  const classification = await classifyRenewalFrequencyWithClaude(articleText);

  console.log('Claude response:', classification);

  if (
    classification.renewalPeriodMonths === null ||
    classification.confidence < MIN_CONFIDENCE
  ) {
    console.log('No renewal frequency detected.');
    console.log('Skipping database update.');
    return;
  }

  console.log(
    `Claude determined ${frequencyLabel(classification.renewalPeriodMonths)} frequency...`
  );

  const programId = await resolveProgramId();
  const program = await prisma.benefitProgram.findUnique({ where: { id: programId } });
  if (!program) {
    throw new Error(
      `Program not found: ${programId}. Set HEALTHCARE_GOV_GRACE_PERIOD_PROGRAM_ID or link source_url/guide_url to the grace period page.`
    );
  }

  console.log(`Updating renewal_period_months... (${program.name})`);

  if (program.renewal_period_months !== classification.renewalPeriodMonths) {
    await prisma.benefitProgram.update({
      where: { id: program.id },
      data: { renewal_period_months: classification.renewalPeriodMonths },
    });
    console.log(
      `Updated renewal_period_months: ${program.renewal_period_months ?? 'null'} -> ${classification.renewalPeriodMonths}`
    );
  } else {
    console.log(
      `renewal_period_months unchanged (${program.renewal_period_months ?? 'null'})`
    );
  }

  console.log(
    `Starting quarter due date backfill for ${program.id} (year ${calendarYear})...`
  );
  const backfillResults = await quarterDueDatesService.backfillProgramQuarters(
    program.id,
    calendarYear
  );
  console.log('Backfill complete:', JSON.stringify(backfillResults, null, 2));

  console.log('Completed successfully.');
}

main()
  .catch((error: unknown) => {
    const message = error instanceof Error ? error.message : String(error);
    console.error(`Healthcare.gov scrape failed: ${message}`);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
