/**
 * Builds backend/zip-master.json from:
 *   1. uszips.csv (SimpleMaps) — primary city, state, multi-county
 *   2. data/zip_code_database.csv (optional) — USPS-style acceptable city aliases
 *   3. us_cities_states_counties_zips.csv (optional) — fallback ZIPs + extra city rows
 *   4. data/zip-acceptable-cities.supplement.json (optional) — manual overrides
 *
 * Download optional alias source (CC BY 4.0, unitedstateszipcodes.org via Zipcodes repo):
 *   curl -fsSL -o data/zip_code_database.csv \
 *     https://raw.githubusercontent.com/seanpianka/Zipcodes/master/scripts/data/zip_code_database.csv
 *
 * Usage: npx tsx scripts/build-zip-master.ts
 */

import fs from 'fs';
import path from 'path';

const BACKEND_ROOT = path.resolve(__dirname, '..');
const SOURCE_CSV = path.join(BACKEND_ROOT, 'uszips.csv');
const ALIAS_CSV = path.join(BACKEND_ROOT, 'data', 'zip_code_database.csv');
const FALLBACK_CSV = path.join(BACKEND_ROOT, 'us_cities_states_counties_zips.csv');
const SUPPLEMENT_JSON = path.join(BACKEND_ROOT, 'data', 'zip-acceptable-cities.supplement.json');
const OUTPUT_JSONL = path.join(BACKEND_ROOT, 'zip-master.jsonl');
const OUTPUT_ZIP_IDX = path.join(BACKEND_ROOT, 'zip-master.idx.json');
const OUTPUT_CITY_IDX = path.join(BACKEND_ROOT, 'zip-city.idx.json');

export interface ZipMasterBuildEntry {
  city: string;
  acceptableCities?: string[];
  state: string;
  stateCode: string;
  counties: string[];
}

type ZipMasterBuildDataset = Record<string, ZipMasterBuildEntry>;

function parseCsvLine(line: string): string[] {
  const fields: string[] = [];
  let current = '';
  let inQuotes = false;

  for (let i = 0; i < line.length; i++) {
    const char = line[i];

    if (inQuotes) {
      if (char === '"') {
        if (line[i + 1] === '"') {
          current += '"';
          i++;
        } else {
          inQuotes = false;
        }
      } else {
        current += char;
      }
    } else if (char === '"') {
      inQuotes = true;
    } else if (char === ',') {
      fields.push(current);
      current = '';
    } else {
      current += char;
    }
  }

  fields.push(current);
  return fields;
}

function normalizeCityKey(city: string): string {
  return city.trim().toLowerCase().replace(/\s+/g, ' ');
}

function parseCityList(raw: string | undefined): string[] {
  if (!raw?.trim()) return [];
  return raw
    .split(',')
    .map((part) => part.trim())
    .filter(Boolean);
}

function mergeAcceptableCities(
  entry: ZipMasterBuildEntry,
  candidates: string[]
): void {
  if (candidates.length === 0) return;

  const primaryKey = normalizeCityKey(entry.city);
  const existing = new Set(
    [entry.city, ...(entry.acceptableCities ?? [])].map(normalizeCityKey)
  );

  for (const city of candidates) {
    const key = normalizeCityKey(city);
    if (!key || key === primaryKey || existing.has(key)) continue;
    existing.add(key);
    if (!entry.acceptableCities) entry.acceptableCities = [];
    entry.acceptableCities.push(city);
  }

  if (entry.acceptableCities?.length) {
    entry.acceptableCities.sort((a, b) => a.localeCompare(b));
  } else {
    delete entry.acceptableCities;
  }
}

function loadSimpleMaps(output: ZipMasterBuildDataset): number {
  const raw = fs.readFileSync(SOURCE_CSV, 'utf8');
  const lines = raw.split(/\r?\n/).filter(Boolean);

  const header = parseCsvLine(lines[0]);
  const col = (name: string) => {
    const idx = header.indexOf(name);
    if (idx === -1) throw new Error(`Missing expected column "${name}" in ${SOURCE_CSV}`);
    return idx;
  };

  const zipIdx = col('zip');
  const cityIdx = col('city');
  const stateNameIdx = col('state_name');
  const stateIdIdx = col('state_id');
  const countyNameIdx = col('county_name');
  const countyNamesAllIdx = col('county_names_all');

  let multiCountyCount = 0;

  for (let i = 1; i < lines.length; i++) {
    const fields = parseCsvLine(lines[i]);
    const zip = fields[zipIdx]?.trim();
    if (!zip) continue;

    const countiesRaw =
      fields[countyNamesAllIdx]?.trim() || fields[countyNameIdx]?.trim() || '';

    const counties = Array.from(
      new Set(
        countiesRaw
          .split('|')
          .map((c) => c.trim().toUpperCase())
          .filter(Boolean)
      )
    ).sort();

    if (counties.length > 1) multiCountyCount++;

    output[zip] = {
      city: fields[cityIdx]?.trim() || '',
      state: fields[stateNameIdx]?.trim() || '',
      stateCode: fields[stateIdIdx]?.trim() || '',
      counties,
    };
  }

  console.log(`  SimpleMaps: ${Object.keys(output).length} ZIP codes (${multiCountyCount} multi-county)`);
  return multiCountyCount;
}

function mergeAliasCsv(output: ZipMasterBuildDataset): number {
  if (!fs.existsSync(ALIAS_CSV)) {
    console.log('  Alias CSV: skipped (data/zip_code_database.csv not found — see script header for download URL)');
    return 0;
  }

  const raw = fs.readFileSync(ALIAS_CSV, 'utf8');
  const lines = raw.split(/\r?\n/).filter(Boolean);
  const header = parseCsvLine(lines[0]);

  const zipIdx = header.indexOf('zip');
  const primaryCityIdx = header.indexOf('primary_city');
  const acceptableIdx = header.indexOf('acceptable_cities');
  const stateIdx = header.indexOf('state');

  if (zipIdx === -1 || acceptableIdx === -1 || stateIdx === -1) {
    throw new Error('zip_code_database.csv is missing required columns (zip, acceptable_cities, state)');
  }

  let enriched = 0;

  for (let i = 1; i < lines.length; i++) {
    const fields = parseCsvLine(lines[i]);
    const zip = fields[zipIdx]?.trim();
    if (!/^\d{5}$/.test(zip ?? '')) continue;

    const acceptable = parseCityList(fields[acceptableIdx]);
    if (acceptable.length === 0) continue;

    const entry = output[zip];
    if (!entry) continue;

    const csvState = fields[stateIdx]?.trim().toUpperCase();
    if (csvState && entry.stateCode.toUpperCase() !== csvState) continue;

    const before = entry.acceptableCities?.length ?? 0;
    mergeAcceptableCities(entry, acceptable);

    // Some rows list a different primary in the alias file — keep SimpleMaps primary, only merge aliases.
    void fields[primaryCityIdx];
    if ((entry.acceptableCities?.length ?? 0) > before) enriched++;
  }

  console.log(`  Alias CSV: ${enriched} ZIP codes gained acceptable city names`);
  return enriched;
}

function mergeFallbackCsv(output: ZipMasterBuildDataset): number {
  if (!fs.existsSync(FALLBACK_CSV)) {
    console.log('  USPS fallback CSV: skipped (us_cities_states_counties_zips.csv not found)');
    return 0;
  }

  const fallbackLines = fs.readFileSync(FALLBACK_CSV, 'utf8').split(/\r?\n/).filter(Boolean);
  const citiesByZip = new Map<string, Map<string, { city: string; state: string; stateCode: string; counties: Set<string> }>>();

  for (let i = 1; i < fallbackLines.length; i++) {
    const [city, stateCode, state, county, , zipString] = fallbackLines[i].split('|');
    if (!zipString?.trim() || !city?.trim()) continue;

    for (const zip of zipString.trim().split(/\s+/)) {
      if (!/^\d{5}$/.test(zip)) continue;

      if (!citiesByZip.has(zip)) citiesByZip.set(zip, new Map());
      const byCity = citiesByZip.get(zip)!;
      const cityKey = normalizeCityKey(city);

      if (!byCity.has(cityKey)) {
        byCity.set(cityKey, {
          city: city.trim(),
          state: state?.trim() || '',
          stateCode: stateCode?.trim().toUpperCase() || '',
          counties: new Set(),
        });
      }

      if (county) byCity.get(cityKey)!.counties.add(county.trim().toUpperCase());
    }
  }

  let fallbackAdded = 0;
  let alternatesMerged = 0;

  for (const [zip, byCity] of citiesByZip) {
    const cityRows = [...byCity.values()];
    if (cityRows.length === 0) continue;

    const existing = output[zip];

    if (existing) {
      const alternates = cityRows.map((row) => row.city).filter((c) => normalizeCityKey(c) !== normalizeCityKey(existing.city));
      const before = existing.acceptableCities?.length ?? 0;
      mergeAcceptableCities(existing, alternates);
      if ((existing.acceptableCities?.length ?? 0) > before) alternatesMerged++;
      continue;
    }

    const primary = cityRows[0];
    output[zip] = {
      city: primary.city,
      state: primary.state,
      stateCode: primary.stateCode,
      counties: Array.from(primary.counties).sort(),
    };

    if (cityRows.length > 1) {
      mergeAcceptableCities(
        output[zip],
        cityRows.slice(1).map((row) => row.city)
      );
    }

    fallbackAdded++;
  }

  console.log(`  USPS fallback: ${fallbackAdded} ZIP-only entries added, ${alternatesMerged} existing ZIPs gained alternates`);
  return fallbackAdded;
}

function mergeSupplement(output: ZipMasterBuildDataset): number {
  if (!fs.existsSync(SUPPLEMENT_JSON)) {
    console.log('  Supplement JSON: skipped (no manual overrides file)');
    return 0;
  }

  const supplement = JSON.parse(fs.readFileSync(SUPPLEMENT_JSON, 'utf8')) as Record<string, string[]>;
  let merged = 0;

  for (const [zip, cities] of Object.entries(supplement)) {
    const entry = output[zip];
    if (!entry || !Array.isArray(cities)) continue;
    const before = entry.acceptableCities?.length ?? 0;
    mergeAcceptableCities(entry, cities);
    if ((entry.acceptableCities?.length ?? 0) > before) merged++;
  }

  console.log(`  Supplement JSON: ${merged} ZIP codes updated`);
  return merged;
}

function main(): void {
  console.log('Building zip-master.json...\n');

  if (!fs.existsSync(SOURCE_CSV)) {
    throw new Error(`Missing ${SOURCE_CSV}. SimpleMaps uszips.csv is required.`);
  }

  const output: ZipMasterBuildDataset = {};
  loadSimpleMaps(output);
  mergeAliasCsv(output);
  mergeFallbackCsv(output);
  mergeSupplement(output);

  const withAlternates = Object.values(output).filter((e) => (e.acceptableCities?.length ?? 0) > 0).length;

  const fd = fs.openSync(OUTPUT_JSONL, 'w');
  const zipIdx: Record<string, [number, number]> = {};
  const cityIdx: Record<string, string[]> = {};
  let offset = 0;

  for (const [zip, entry] of Object.entries(output)) {
    const line = JSON.stringify({ zip, ...entry }) + '\n';
    const buffer = Buffer.from(line, 'utf8');
    fs.writeSync(fd, buffer);
    zipIdx[zip] = [offset, buffer.length];
    offset += buffer.length;

    const cityKey = `${entry.stateCode.toUpperCase()}|${normalizeCityKey(entry.city)}`;
    if (!cityIdx[cityKey]) {
      cityIdx[cityKey] = [];
    }
    cityIdx[cityKey].push(zip);
  }
  
  for (const zips of Object.values(cityIdx)) {
    zips.sort();
  }

  fs.closeSync(fd);
  fs.writeFileSync(OUTPUT_ZIP_IDX, JSON.stringify(zipIdx));
  fs.writeFileSync(OUTPUT_CITY_IDX, JSON.stringify(cityIdx));

  console.log('\nDone.');
  console.log(`  Total ZIP codes: ${Object.keys(output).length}`);
  console.log(`  With acceptable alternate cities: ${withAlternates}`);
  console.log(`  Output: ${OUTPUT_JSONL}, ${OUTPUT_ZIP_IDX}, ${OUTPUT_CITY_IDX}`);
}

main();
