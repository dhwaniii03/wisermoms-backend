import { BadRequestError } from '../utils/errors';
import {
  getZipDatasetLoadError,
  lookupZipEntry,
  lookupZipsForCity,
} from '../data/zip-master.loader';
import {
  citiesMatch,
  extractZip5,
  isValidZipFormat,
  normalizeCityName,
  normalizeStateCode,
} from '../utils/zip.utils';

export {
  extractZip5,
  isValidZipFormat,
  normalizeCityName,
};

export function isZipValidationEnabled(): boolean {
  return true;
}

export type ZipValidationErrorCode =
  | 'INVALID_FORMAT'
  | 'NOT_FOUND'
  | 'STATE_MISMATCH'
  | 'CITY_MISMATCH'
  | 'COUNTY_MISMATCH'
  | 'DATASET_ERROR';

export interface ZipValidationResult {
  valid: boolean;
  city?: string;
  cities?: string[];
  state?: string;
  zip?: string;
  counties?: string[];
  county?: string;
  error?: string;
  errorCode?: ZipValidationErrorCode;
}

export interface ZipLookupResult {
  zip: string;
  city: string | null;
  cities: string[];
  state: string | null;
  stateName: string | null;
  counties: string[];
  error?: string;
  errorCode?: ZipValidationErrorCode;
}

export interface CityLookupResult {
  valid: boolean;
  city: string | null;
  state: string | null;
  zips: string[];
  error?: string;
  errorCode?: ZipValidationErrorCode;
}

const ZIP_NOT_FOUND_ERROR = 'ZIP code not found. Please enter a valid US ZIP code.';

function formatCityMismatchError(
  zip5: string,
  state: string,
  selectedCity: string,
  expectedCity: string
): string {
  return `ZIP ${zip5} is assigned to ${expectedCity}, ${state} — not ${selectedCity}.`;
}

function formatCountyMismatchError(zip5: string, selectedCounty: string, counties: string[]): string {
  const options = counties.join(' or ');
  return `ZIP ${zip5} is in ${options} — not ${selectedCounty}.`;
}

function datasetErrorResult(): { error: string; errorCode: ZipValidationErrorCode } {
  return {
    error: getZipDatasetLoadError() ?? 'ZIP lookup data is unavailable. Please contact support.',
    errorCode: 'DATASET_ERROR',
  };
}

export class ZipValidationService {
  lookupZip(zip: string): ZipLookupResult {
    if (!isZipValidationEnabled()) {
      const zip5 = extractZip5(zip);
      return { zip: zip5 ?? '', city: null, cities: [], state: null, stateName: null, counties: [] };
    }

    const zip5 = extractZip5(zip);
    if (!zip5) {
      return {
        zip: '',
        city: null,
        cities: [],
        state: null,
        stateName: null,
        counties: [],
        error: 'Please enter a valid US ZIP code.',
        errorCode: 'INVALID_FORMAT',
      };
    }

    let entry;
    try {
      entry = lookupZipEntry(zip5);
    } catch {
      const { error, errorCode } = datasetErrorResult();
      return {
        zip: zip5,
        city: null,
        cities: [],
        state: null,
        stateName: null,
        counties: [],
        error,
        errorCode,
      };
    }

    if (!entry) {
      return {
        zip: zip5,
        city: null,
        cities: [],
        state: null,
        stateName: null,
        counties: [],
        error: ZIP_NOT_FOUND_ERROR,
        errorCode: 'NOT_FOUND',
      };
    }

    return {
      zip: zip5,
      city: entry.city,
      cities: [entry.city, ...(entry.acceptableCities || [])],
      state: entry.stateCode,
      stateName: entry.state,
      counties: entry.counties,
    };
  }

  lookupCityInState(state: string, city: string): CityLookupResult {
    const normalizedState = normalizeStateCode(state);
    const trimmedCity = city?.trim();

    if (!normalizedState || normalizedState.length !== 2) {
      return {
        valid: false,
        city: null,
        state: null,
        zips: [],
        error: 'Please select a valid US state.',
        errorCode: 'INVALID_FORMAT',
      };
    }

    if (!trimmedCity) {
      return {
        valid: false,
        city: null,
        state: null,
        zips: [],
        error: 'City is required.',
        errorCode: 'INVALID_FORMAT',
      };
    }

    try {
      const zips = lookupZipsForCity(normalizedState, trimmedCity);
      if (zips.length === 0) {
        return {
          valid: false,
          city: null,
          state: normalizedState,
          zips: [],
          error: `Could not find ${trimmedCity} in ${normalizedState}.`,
          errorCode: 'NOT_FOUND',
        };
      }

      const entry = lookupZipEntry(zips[0]);
      return {
        valid: true,
        city: entry?.city ?? trimmedCity,
        state: normalizedState,
        zips,
      };
    } catch {
      const { error, errorCode } = datasetErrorResult();
      return {
        valid: false,
        city: null,
        state: normalizedState,
        zips: [],
        error,
        errorCode,
      };
    }
  }

  validateZip(
    zip: string,
    state: string,
    city?: string,
    county?: string
  ): ZipValidationResult {
    if (!isZipValidationEnabled()) {
      const zip5 = extractZip5(zip);
      return {
        valid: true,
        zip: zip5 ?? undefined,
        state: state ? normalizeStateCode(state) : undefined,
      };
    }

    const zip5 = extractZip5(zip);
    if (!zip5) {
      return {
        valid: false,
        error: 'Please enter a valid US ZIP code.',
        errorCode: 'INVALID_FORMAT',
      };
    }

    const normalizedState = normalizeStateCode(state);
    if (!normalizedState || normalizedState.length !== 2) {
      return {
        valid: false,
        error: 'Please select a valid US state.',
        errorCode: 'INVALID_FORMAT',
      };
    }

    let entry;
    try {
      entry = lookupZipEntry(zip5);
    } catch {
      const { error, errorCode } = datasetErrorResult();
      return { valid: false, zip: zip5, error, errorCode };
    }

    if (!entry) {
      return {
        valid: false,
        zip: zip5,
        error: ZIP_NOT_FOUND_ERROR,
        errorCode: 'NOT_FOUND',
      };
    }

    if (entry.stateCode !== normalizedState) {
      return {
        valid: false,
        zip: zip5,
        counties: entry.counties,
        error: 'This ZIP code does not belong to the selected state.',
        errorCode: 'STATE_MISMATCH',
      };
    }

    const trimmedCity = city?.trim();
    if (trimmedCity) {
      const match = citiesMatch(trimmedCity, entry.city) || 
        (entry.acceptableCities ?? []).some(ac => citiesMatch(trimmedCity, ac));

      if (!match) {
        return {
          valid: false,
          zip: zip5,
          counties: entry.counties,
          error: formatCityMismatchError(zip5, normalizedState, trimmedCity, entry.city),
          errorCode: 'CITY_MISMATCH',
        };
      }
    }

    const trimmedCounty = county?.trim();
    if (trimmedCounty) {
      const normalizedCounty = trimmedCounty.toUpperCase();
      const matchingCounty = entry.counties.find(
        (value) => value.toUpperCase() === normalizedCounty
      );
      if (!matchingCounty) {
        return {
          valid: false,
          zip: zip5,
          counties: entry.counties,
          error: formatCountyMismatchError(zip5, trimmedCounty, entry.counties),
          errorCode: 'COUNTY_MISMATCH',
        };
      }

      return {
        valid: true,
        city: trimmedCity ? (citiesMatch(trimmedCity, entry.city) ? entry.city : (entry.acceptableCities?.find(ac => citiesMatch(trimmedCity, ac)) ?? entry.city)) : entry.city,
        cities: [entry.city, ...(entry.acceptableCities || [])],
        state: entry.stateCode,
        zip: zip5,
        counties: entry.counties,
        county: matchingCounty,
      };
    }

    if (entry.counties.length > 1) {
      return {
        valid: false,
        zip: zip5,
        city: entry.city,
        cities: [entry.city, ...(entry.acceptableCities || [])],
        state: entry.stateCode,
        counties: entry.counties,
        error: 'Please select a county for this ZIP code.',
        errorCode: 'INVALID_FORMAT',
      };
    }

    return {
      valid: true,
      city: trimmedCity ? (citiesMatch(trimmedCity, entry.city) ? entry.city : (entry.acceptableCities?.find(ac => citiesMatch(trimmedCity, ac)) ?? entry.city)) : entry.city,
      cities: [entry.city, ...(entry.acceptableCities || [])],
      state: entry.stateCode,
      zip: zip5,
      counties: entry.counties,
      county: entry.counties[0] ?? undefined,
    };
  }

  async assertZipValid(
    zip: string,
    state: string,
    city?: string,
    county?: string
  ): Promise<ZipValidationResult> {
    const result = this.validateZip(zip, state, city, county);
    if (!result.valid) {
      throw new BadRequestError(result.error || 'Invalid ZIP code.');
    }
    return result;
  }

  resolveLocationFromZip(
    zip: string,
    county?: string
  ): {
    zip_code: string;
    state: string;
    city: string;
    county: string | null;
  } {
    const lookup = this.lookupZip(zip);
    if (!lookup.state || !lookup.city) {
      throw new BadRequestError(lookup.error || 'Invalid ZIP code.');
    }

    const validation = this.validateZip(zip, lookup.state, lookup.city, county);
    if (!validation.valid || !validation.state || !validation.city) {
      throw new BadRequestError(validation.error || 'Invalid ZIP code.');
    }

    return {
      zip_code: validation.zip ?? lookup.zip,
      state: validation.state,
      city: validation.city,
      county: validation.county ?? null,
    };
  }
}

export const zipValidationService = new ZipValidationService();
