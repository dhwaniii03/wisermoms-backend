/**
 * Converts a Prisma Decimal (or plain number/string) to a JS number.
 * Returns `fallback` when the value is null/undefined or cannot be parsed.
 */
export function decimalToNumber(value: unknown, fallback = 0): number {
  if (value === null || value === undefined) return fallback;
  const num = Number(value);
  return Number.isNaN(num) ? fallback : num;
}

/**
 * Like decimalToNumber but preserves null for absent values.
 */
export function decimalToNumberOrNull(value: unknown): number | null {
  if (value === null || value === undefined) return null;
  const num = Number(value);
  return Number.isNaN(num) ? null : num;
}
