/**
 * Follow-up pass for non-canonical county labels that need explicit aliases.
 *
 *   North Fulton  -> FULTON
 *   All Counties  -> statewide
 *
 * Usage:
 *   npm run counties:normalize-aliases:dry-run
 *   npm run counties:normalize-aliases
 */
import fs from 'fs';
import path from 'path';
import { prisma } from '../src/config/prisma';
import {
  applyCountyLabelAlias,
  isStatewideCountyLabel,
  resolveCountyLabelAlias,
} from '../src/utils/county.utils';

const REPORT_FILENAME = 'county-alias-normalization-report.json';
const isLiveMode = process.argv.includes('--live');

const ALIAS_SOURCE_LABELS = ['North Fulton', 'All Counties'] as const;

interface AliasUpdateRecord {
  organizationId: string;
  orgName: string;
  state: string | null;
  beforeCounty: string | null;
  afterCounty: string | null;
  beforeCountiesServed: string[];
  afterCountiesServed: string[];
}

interface AliasReport {
  updated: AliasUpdateRecord[];
  skipped: Array<{ organizationId: string; orgName: string; reason: string }>;
}

function resolveReportPath(): string {
  return path.resolve(process.cwd(), REPORT_FILENAME);
}

function orgNeedsAliasPass(org: {
  county: string | null;
  counties_served: string[];
}): boolean {
  if (org.county && resolveCountyLabelAlias(org.county)) return true;
  return org.counties_served.some((entry) => resolveCountyLabelAlias(entry));
}

function applyAliasPass(org: {
  county: string | null;
  counties_served: string[];
}): { county: string | null; counties_served: string[] } {
  const counties_served = org.counties_served.map((entry) => applyCountyLabelAlias(entry));

  let county = org.county;
  if (county?.trim()) {
    const aliasedCounty = applyCountyLabelAlias(county.trim());
    county = isStatewideCountyLabel(aliasedCounty) ? null : aliasedCounty;
  } else {
    const nonStatewide = counties_served.filter((entry) => !isStatewideCountyLabel(entry));
    county = nonStatewide.length === 1 ? nonStatewide[0] : null;
  }

  return { county, counties_served };
}

async function main() {
  console.log(`County alias normalization starting (${isLiveMode ? 'LIVE' : 'DRY-RUN'})...`);

  const organizations = await prisma.organization.findMany({
    select: {
      id: true,
      org_name: true,
      state: true,
      county: true,
      counties_served: true,
    },
    orderBy: { org_name: 'asc' },
  });

  const report: AliasReport = { updated: [], skipped: [] };

  for (const org of organizations) {
    if (!orgNeedsAliasPass(org)) continue;

    const next = applyAliasPass(org);
    const changed =
      (org.county ?? null) !== (next.county ?? null) ||
      org.counties_served.join('\u0000') !== next.counties_served.join('\u0000');

    if (!changed) {
      report.skipped.push({
        organizationId: org.id,
        orgName: org.org_name,
        reason: 'Alias labels present but no effective change',
      });
      continue;
    }

    const record: AliasUpdateRecord = {
      organizationId: org.id,
      orgName: org.org_name,
      state: org.state,
      beforeCounty: org.county,
      afterCounty: next.county,
      beforeCountiesServed: org.counties_served,
      afterCountiesServed: next.counties_served,
    };

    report.updated.push(record);

    if (isLiveMode) {
      await prisma.organization.update({
        where: { id: org.id },
        data: {
          county: next.county,
          counties_served: next.counties_served,
        },
      });
    }

    console.log(
      `${isLiveMode ? 'Updated' : 'Would update'} ${org.org_name}: county=${next.county ?? 'null'}, counties_served=[${next.counties_served.join(', ')}]`
    );
  }

  const reportPath = resolveReportPath();
  fs.writeFileSync(reportPath, JSON.stringify(report, null, 2));

  console.log('\n=== County Alias Normalization Summary ===');
  console.log(`Mode: ${isLiveMode ? 'LIVE' : 'DRY-RUN'}`);
  console.log(`Alias source labels: ${ALIAS_SOURCE_LABELS.join(', ')}`);
  console.log(`Organizations ${isLiveMode ? 'updated' : 'to update'}: ${report.updated.length}`);
  console.log(`Skipped: ${report.skipped.length}`);
  console.log(`Report written to: ${reportPath}`);
}

main()
  .catch((error) => {
    console.error('County alias normalization failed:', error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
