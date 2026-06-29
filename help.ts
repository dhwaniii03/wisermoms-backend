/**
 * @deprecated Use `npm run build:zip-master` (scripts/build-zip-master.ts) instead.
 * This legacy script only merges SimpleMaps + USPS fallback — no acceptable city aliases.
 */
const fs = require("fs");

// Source: simplemaps US Zip Codes Database (Basic, free / CC-BY 4.0).
// https://simplemaps.com/data/us-zips
// Unlike the USPS city/county file, this lists EVERY county a ZIP overlaps
// via the `county_names_all` / `county_fips_all` columns, so a single ZIP
// can map to multiple counties (e.g. 30004 -> Fulton, Forsyth, Cherokee).

const SOURCE_CSV = "uszips.csv";
// USPS city/state/county file. Only has the primary county per ZIP, but it
// covers ~8k extra zips (PO box / unique / military) missing from simplemaps.
// Used purely as a fallback for ZIPs absent from the simplemaps dataset.
const FALLBACK_CSV = "us_cities_states_counties_zips.csv";
const OUTPUT_JSON = "zip-master.json";

// Minimal RFC-4180 CSV parser. Required because the `county_weights` column
// holds a JSON object whose commas live inside quoted fields.
function parseCsvLine(line: string): string[] {
  const fields: string[] = [];
  let current = "";
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
    } else if (char === ",") {
      fields.push(current);
      current = "";
    } else {
      current += char;
    }
  }

  fields.push(current);
  return fields;
}

const raw = fs.readFileSync(SOURCE_CSV, "utf8");
const lines = raw.split(/\r?\n/).filter(Boolean);

const header = parseCsvLine(lines[0]);
const col = (name: string) => {
  const idx = header.indexOf(name);
  if (idx === -1) throw new Error(`Missing expected column "${name}" in ${SOURCE_CSV}`);
  return idx;
};

const zipIdx = col("zip");
const cityIdx = col("city");
const stateNameIdx = col("state_name");
const stateIdIdx = col("state_id");
const countyNameIdx = col("county_name");
const countyNamesAllIdx = col("county_names_all");

const output: Record<
  string,
  { city: string; state: string; stateCode: string; counties: string[] }
> = {};

let multiCountyCount = 0;

for (let i = 1; i < lines.length; i++) {
  const fields = parseCsvLine(lines[i]);

  const zip = fields[zipIdx]?.trim();
  if (!zip) continue;

  // Prefer the full multi-county list; fall back to the primary county.
  const countiesRaw = fields[countyNamesAllIdx]?.trim() || fields[countyNameIdx]?.trim() || "";

  const counties = Array.from(
    new Set(
      countiesRaw
        .split("|")
        .map((c) => c.trim().toUpperCase())
        .filter(Boolean)
    )
  ).sort();

  if (counties.length > 1) multiCountyCount++;

  output[zip] = {
    city: fields[cityIdx]?.trim() || "",
    state: fields[stateNameIdx]?.trim() || "",
    stateCode: fields[stateIdIdx]?.trim() || "",
    counties,
  };
}

// Fallback: add ZIPs that exist only in the USPS file (PO box / unique /
// military zips). This file is pipe-delimited and lists one county per row,
// but a ZIP can appear across several rows, so we aggregate those counties.
let fallbackAdded = 0;
if (fs.existsSync(FALLBACK_CSV)) {
  const fallbackLines = fs.readFileSync(FALLBACK_CSV, "utf8").split(/\r?\n/).filter(Boolean);
  const pending: Record<
    string,
    { city: string; state: string; stateCode: string; counties: Set<string> }
  > = {};

  for (let i = 1; i < fallbackLines.length; i++) {
    const [city, stateCode, state, county, , zipString] = fallbackLines[i].split("|");
    if (!zipString) continue;

    for (const zip of zipString.trim().split(/\s+/)) {
      if (output[zip]) continue; // simplemaps wins
      if (!pending[zip]) {
        pending[zip] = { city, state, stateCode, counties: new Set() };
      }
      if (county) pending[zip].counties.add(county.trim().toUpperCase());
    }
  }

  for (const zip in pending) {
    const entry = pending[zip];
    output[zip] = {
      city: entry.city,
      state: entry.state,
      stateCode: entry.stateCode,
      counties: Array.from(entry.counties).sort(),
    };
    fallbackAdded++;
    if (entry.counties.size > 1) multiCountyCount++;
  }
}

fs.writeFileSync(OUTPUT_JSON, JSON.stringify(output, null, 2));

console.log(`Generated ${Object.keys(output).length} ZIP codes`);
console.log(`  ${multiCountyCount} ZIP codes map to more than one county`);
console.log(`  ${fallbackAdded} ZIP codes added from USPS fallback file`);
