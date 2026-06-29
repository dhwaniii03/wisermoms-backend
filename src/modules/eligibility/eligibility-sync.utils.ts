import { FamilyProfile, User } from '@prisma/client';

export interface EligibilitySyncStatus {
  /** True when eligibility-relevant profile fields changed since the last scan. */
  isStale: boolean;
  /** True when the user has at least one eligibility scan result. */
  hasScan: boolean;
  /** Latest profile change timestamp (user or family profile). */
  lastProfileUpdateAt: Date | null;
  /** Timestamp of the most recent eligibility scan. */
  lastEligibilityScanAt: Date | null;
}

/**
 * Stale detection is event-driven, not timestamp-based:
 *  - `last_eligibility_scan_at` is set to now() when a scan completes.
 *  - `last_eligibility_scan_at` is cleared to null when eligibility-relevant
 *    profile fields are updated.
 *
 * This avoids false positives from Prisma @updatedAt being written by the
 * scan itself, or user.updated_at being bumped by unrelated changes (login, etc).
 */
export function computeEligibilitySyncStatus(
  user: Pick<User, 'updated_at'>,
  familyProfile:
    | Pick<FamilyProfile, 'updated_at' | 'last_eligibility_scan_at'>
    | null
    | undefined,
  hasScanResults: boolean
): EligibilitySyncStatus {
  // A scan has been run if results exist OR last_eligibility_scan_at is set.
  const hasScan = hasScanResults || familyProfile?.last_eligibility_scan_at != null;

  // Stale = has results but last_eligibility_scan_at was explicitly cleared
  // because an eligibility-relevant profile field changed after the scan.
  const isStale = hasScan && familyProfile?.last_eligibility_scan_at == null;

  const lastEligibilityScanAt = familyProfile?.last_eligibility_scan_at ?? null;

  return {
    isStale,
    hasScan,
    lastProfileUpdateAt: null,
    lastEligibilityScanAt,
  };
}

export function serializeEligibilitySyncStatus(status: EligibilitySyncStatus) {
  return {
    isStale: status.isStale,
    hasScan: status.hasScan,
    lastProfileUpdateAt: status.lastProfileUpdateAt?.toISOString() ?? null,
    lastEligibilityScanAt: status.lastEligibilityScanAt?.toISOString() ?? null,
  };
}
