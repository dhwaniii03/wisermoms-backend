export function normalizeCityName(city: string): string {
  return city.trim().toLowerCase().replace(/\s+/g, ' ');
}

export function normalizeStateCode(state: string): string {
  return state.trim().toUpperCase();
}

export function citiesMatch(a: string, b: string): boolean {
  return normalizeCityName(a) === normalizeCityName(b);
}

export function extractZip5(zip: string): string | null {
  const match = zip.trim().match(/^(\d{5})(?:-\d{4})?$/);
  return match ? match[1] : null;
}

export function isValidZipFormat(zip: string): boolean {
  return extractZip5(zip) !== null;
}
