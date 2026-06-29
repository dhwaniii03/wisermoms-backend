export function daysUntil(date: Date): number {
  const now = new Date();
  now.setHours(0, 0, 0, 0);
  const d = new Date(date);
  d.setHours(0, 0, 0, 0);
  return Math.ceil((d.getTime() - now.getTime()) / (1000 * 60 * 60 * 24));
}

export function urgencyFromDays(days: number | null): 'high' | 'moderate' | 'normal' {
  if (days == null) return 'normal';
  if (days <= 7) return 'high';
  if (days <= 14) return 'moderate';
  return 'normal';
}

export type UrgencyBucket = 'critical' | 'soon' | 'upcoming' | 'on_track';

export function urgencyBucket(days: number): UrgencyBucket {
  if (days <= 7) return 'critical';
  if (days <= 14) return 'soon';
  if (days <= 30) return 'upcoming';
  return 'on_track';
}
