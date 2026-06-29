import { zipValidationService } from '../src/services/zipValidation.service';

async function runTests() {
  console.log('--- ZIP Validation Tests ---');

  const validZipRes = zipValidationService.lookupZip('19103');
  console.log('1. Lookup 19103:', {
    city: validZipRes.city,
    cities: validZipRes.cities,
    state: validZipRes.state,
    stateName: validZipRes.stateName,
    counties: validZipRes.counties,
  });

  const invalidZipRes = zipValidationService.lookupZip('00000');
  console.log('2. Invalid ZIP 00000:', {
    error: invalidZipRes.error,
    errorCode: invalidZipRes.errorCode,
  });

  const primaryValid = zipValidationService.validateZip('19103', 'PA', 'Philadelphia');
  console.log('3. Validate 19103 + Philadelphia:', {
    valid: primaryValid.valid,
    city: primaryValid.city,
  });

  const aliasValid = zipValidationService.validateZip('19103', 'PA', 'Phila');
  console.log('4. Validate 19103 + acceptable alias "Phila":', {
    valid: aliasValid.valid,
    city: aliasValid.city,
  });

  const badCity = zipValidationService.validateZip('19103', 'PA', 'New York');
  console.log('5. Reject 19103 + New York:', {
    valid: badCity.valid,
    error: badCity.error,
  });

  const multiCity = zipValidationService.lookupZip('10001');
  console.log('6. Lookup 10001 (multi-name NYC ZIP):', {
    city: multiCity.city,
    cities: multiCity.cities,
  });

  const multiCounty = zipValidationService.lookupZip('30101');
  console.log('7. Lookup 30101 (multi-county GA ZIP):', {
    counties: multiCounty.counties,
  });

  try {
    zipValidationService.resolveLocationFromZip('30101');
    console.log('8. Multi-county without county: UNEXPECTED PASS');
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    console.log('8. Multi-county without county rejected:', message);
  }

  const multiCountyResolved = zipValidationService.resolveLocationFromZip('30101', 'COBB');
  console.log('9. Multi-county with county COBB:', {
    county: multiCountyResolved.county,
    city: multiCountyResolved.city,
  });
}

runTests().catch(console.error);
