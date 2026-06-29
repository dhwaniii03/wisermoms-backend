# ZIP lookup data sources

## Required (already in repo)

- `../uszips.csv` — SimpleMaps US ZIP database (primary city, state, multi-county)

## Optional — acceptable city aliases

Download once before running `npm run build:zip-master`:

```bash
curl -fsSL -o data/zip_code_database.csv \
  https://raw.githubusercontent.com/seanpianka/Zipcodes/master/scripts/data/zip_code_database.csv
```

Source: [seanpianka/Zipcodes](https://github.com/seanpianka/Zipcodes) (aggregates unitedstateszipcodes.org, CC BY 4.0).

This file adds **acceptable alternate city names** per ZIP (e.g. `19103` → `Phila`, `Mid City West`).

`zip_code_database.csv` is **not committed** (~4.5 MB). Add it locally, then rebuild.

## Optional — manual overrides

`zip-acceptable-cities.supplement.json` — hand-edited aliases merged on top of automated sources:

```json
{
  "12345": ["Alternate City Name"]
}
```

## Optional — USPS fallback ZIPs

`../us_cities_states_counties_zips.csv` — pipe-delimited fallback for PO box / military ZIPs missing from SimpleMaps.

## Rebuild

```bash
npm run build:zip-master
```

Output: `../zip-master.json`
