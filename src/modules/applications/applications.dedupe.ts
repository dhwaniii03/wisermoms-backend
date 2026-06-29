const APPLICATION_STATUS_RANK: Record<string, number> = {
  approved: 7,
  under_review: 6,
  submitted: 5,
  action_required: 4,
  draft: 3,
  rejected: 2,
  withdrawn: 1,
};

export type DedupeableApplication = {
  id: string;
  program_id: string | null;
  status: string;
  last_updated_at: Date;
  quarter?: string | null;
  year?: number | null;
};

function periodDedupeKey(app: DedupeableApplication): string {
  if (!app.program_id) return app.id;
  const quarter = app.quarter ?? 'unknown';
  const year = app.year ?? 0;
  return `${app.program_id}:${quarter}:${year}`;
}

/**
 * Return one application per program within the same quarter/year period.
 * When duplicate rows exist for the same program and period, prefer the most
 * meaningful status without hiding a newer submission behind an older in-review row (MED-03).
 */
export function dedupeApplicationsByProgram<T extends DedupeableApplication>(
  applications: T[]
): T[] {
  const byProgramPeriod = new Map<string, T>();

  for (const app of applications) {
    if (!app.program_id) continue;

    const key = periodDedupeKey(app);
    const existing = byProgramPeriod.get(key);
    if (!existing) {
      byProgramPeriod.set(key, app);
      continue;
    }

    const appRank = APPLICATION_STATUS_RANK[app.status] ?? 0;
    const existingRank = APPLICATION_STATUS_RANK[existing.status] ?? 0;
    const appTime = app.last_updated_at.getTime();
    const existingTime = existing.last_updated_at.getTime();

    if (appRank > existingRank) {
      if (['draft', 'withdrawn', 'rejected'].includes(existing.status)) {
        byProgramPeriod.set(key, app);
      }
    } else if (appRank === existingRank && appTime > existingTime) {
      byProgramPeriod.set(key, app);
    }
  }

  const withoutProgram = applications.filter((app) => !app.program_id);
  return [...byProgramPeriod.values(), ...withoutProgram].sort(
    (a, b) => b.last_updated_at.getTime() - a.last_updated_at.getTime()
  );
}
