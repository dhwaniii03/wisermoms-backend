import fs from 'fs';
import path from 'path';
import type { ZipMasterDataset, ZipMasterEntry } from './zip-master.types';
import { normalizeCityName } from '../utils/zip.utils';

const ZIP_MASTER_JSONL = 'zip-master.jsonl';
const ZIP_MASTER_JSON = 'zip-master.json';
const ZIP_MASTER_IDX = 'zip-master.idx.json';
const ZIP_CITY_IDX = 'zip-city.idx.json';

let zipIndex: Record<string, [number, number]> | null = null;
let cityIndex: Record<string, string[]> | null = null;
let jsonlFd: number | null = null;
let legacyDataset: ZipMasterDataset | null = null;
let legacyCityIndex: Record<string, string[]> | null = null;
let loadError: string | null = null;

function resolvePath(filename: string): string {
  const candidates = [
    path.resolve(process.cwd(), filename),
    path.resolve(process.cwd(), 'backend', filename),
    path.resolve(__dirname, '..', '..', filename),
    path.resolve(__dirname, '..', '..', '..', filename),
  ];

  for (const candidate of candidates) {
    if (fs.existsSync(candidate)) {
      return candidate;
    }
  }

  return candidates[0];
}

function indexedLoaderAvailable(): boolean {
  return (
    fs.existsSync(resolvePath(ZIP_MASTER_JSONL)) &&
    fs.existsSync(resolvePath(ZIP_MASTER_IDX)) &&
    fs.existsSync(resolvePath(ZIP_CITY_IDX))
  );
}

function buildLegacyCityIndex(dataset: ZipMasterDataset): Record<string, string[]> {
  const idx: Record<string, string[]> = {};

  for (const [zip, entry] of Object.entries(dataset)) {
    const key = `${entry.stateCode.toUpperCase()}|${normalizeCityName(entry.city)}`;
    if (!idx[key]) {
      idx[key] = [];
    }
    idx[key].push(zip);
  }

  for (const zips of Object.values(idx)) {
    zips.sort();
  }

  return idx;
}

function loadLegacyDataset(): ZipMasterDataset {
  if (legacyDataset) {
    return legacyDataset;
  }

  const jsonPath = resolvePath(ZIP_MASTER_JSON);
  if (!fs.existsSync(jsonPath)) {
    loadError = 'ZIP lookup indexes are unavailable. Please build zip master first.';
    throw new Error(loadError);
  }

  legacyDataset = JSON.parse(fs.readFileSync(jsonPath, 'utf8')) as ZipMasterDataset;
  legacyCityIndex = buildLegacyCityIndex(legacyDataset);
  loadError = null;
  return legacyDataset;
}

export function getZipDatasetLoadError(): string | null {
  return loadError;
}

export function initZipMasterIndexes(): void {
  if (zipIndex && cityIndex && jsonlFd !== null) {
    return;
  }

  if (legacyDataset && legacyCityIndex) {
    return;
  }

  if (!indexedLoaderAvailable()) {
    loadLegacyDataset();
    return;
  }

  const jsonlPath = resolvePath(ZIP_MASTER_JSONL);
  const idxPath = resolvePath(ZIP_MASTER_IDX);
  const cityIdxPath = resolvePath(ZIP_CITY_IDX);

  try {
    zipIndex = JSON.parse(fs.readFileSync(idxPath, 'utf8'));
    cityIndex = JSON.parse(fs.readFileSync(cityIdxPath, 'utf8'));
    jsonlFd = fs.openSync(jsonlPath, 'r');
    loadError = null;
  } catch (error) {
    zipIndex = null;
    cityIndex = null;
    if (jsonlFd !== null) {
      fs.closeSync(jsonlFd);
      jsonlFd = null;
    }

    try {
      loadLegacyDataset();
    } catch {
      if (!loadError) {
        loadError = 'ZIP lookup data could not be loaded. Please contact support.';
      }
      throw error;
    }
  }
}

export function lookupZipEntry(zip5: string): ZipMasterEntry | null {
  try {
    initZipMasterIndexes();

    if (legacyDataset) {
      return legacyDataset[zip5] ?? null;
    }

    if (!zipIndex || jsonlFd === null) {
      return null;
    }

    const loc = zipIndex[zip5];
    if (!loc) return null;

    const [offset, length] = loc;
    const buffer = Buffer.alloc(length);
    fs.readSync(jsonlFd, buffer, 0, length, offset);

    const raw = buffer.toString('utf8');
    const parsed = JSON.parse(raw);

    delete parsed.zip;
    return parsed as ZipMasterEntry;
  } catch {
    return null;
  }
}

export function lookupZipsForCity(stateCode: string, city: string): string[] {
  try {
    initZipMasterIndexes();

    if (legacyCityIndex) {
      const key = `${stateCode.toUpperCase()}|${normalizeCityName(city)}`;
      return legacyCityIndex[key] ?? [];
    }

    if (!cityIndex) return [];

    const key = `${stateCode.toUpperCase()}|${normalizeCityName(city)}`;
    return cityIndex[key] ?? [];
  } catch {
    return [];
  }
}
