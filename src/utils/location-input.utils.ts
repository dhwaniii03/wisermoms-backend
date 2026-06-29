import { BadRequestError } from './errors';
import {
  isZipValidationEnabled,
  zipValidationService,
} from '../services/zipValidation.service';

export async function resolveLocationInput(data: {
  zip?: string;
  zip_code?: string;
  state?: string;
  city?: string;
  county?: string;
}): Promise<{ zip_code: string; state: string; city: string; county: string | null }> {
  const zip_code = (data.zip_code ?? data.zip)?.trim();
  if (!zip_code) {
    throw new BadRequestError('ZIP code is required.');
  }

  if (isZipValidationEnabled()) {
    return zipValidationService.resolveLocationFromZip(
      zip_code,
      data.county?.trim() || undefined
    );
  }

  const state = data.state?.trim();
  const city = data.city?.trim();
  if (!state || !city) {
    throw new BadRequestError('State and city are required.');
  }

  return { zip_code, state, city, county: data.county?.trim() || null };
}
