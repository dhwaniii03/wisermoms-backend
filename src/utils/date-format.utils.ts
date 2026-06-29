/** Standard display format for due dates across portals (DATE-02). */
const DISPLAY_DATE_FORMAT: Intl.DateTimeFormatOptions = {
  month: 'short',
  day: 'numeric',
  year: 'numeric',
};

export function formatDisplayDate(date: Date | string | null | undefined): string | null {
  if (date == null) return null;
  const d = typeof date === 'string' ? new Date(date) : date;
  if (Number.isNaN(d.getTime())) return null;
  return new Intl.DateTimeFormat('en-US', DISPLAY_DATE_FORMAT).format(d);
}

export function parseIsoDateOnly(iso: string): Date {
  return new Date(`${iso}T00:00:00.000Z`);
}
