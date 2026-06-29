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

type DedupeableApplicationLike = {
  id?: string;
  program_id?: string | null;
  status?: string;
  last_updated_at?: Date | string | null;
  quarter?: string | null;
  year?: number | null;
};

function normalizeApplication(
  app: DedupeableApplicationLike,
): DedupeableApplication {
  return {
    id: app.id ?? "",
    program_id: app.program_id ?? null,
    status: app.status ?? "draft",
    last_updated_at: app.last_updated_at
      ? new Date(app.last_updated_at)
      : new Date(0),
    quarter: app.quarter ?? null,
    year: app.year ?? null,
  };
}

function periodDedupeKey(app: DedupeableApplicationLike): string {
  const normalized = normalizeApplication(app);
  if (!normalized.program_id) return normalized.id;
  const quarter = normalized.quarter ?? "unknown";
  const year = normalized.year ?? 0;
  return `${normalized.program_id}:${quarter}:${year}`;
}

/**
 * Return one application per program within the same quarter/year period.
 * When duplicate rows exist for the same program and period, prefer the most
 * meaningful status without hiding a newer submission behind an older in-review row (MED-03).
 */
export function dedupeApplicationsByProgram<
  T extends DedupeableApplicationLike,
>(applications: T[]): T[] {
  const byProgramPeriod = new Map<string, T>();

  for (const app of applications) {
    const normalizedApp = normalizeApplication(app);
    if (!normalizedApp.program_id) continue;

    const key = periodDedupeKey(app);
    const existing = byProgramPeriod.get(key);
    if (!existing) {
      byProgramPeriod.set(key, app);
      continue;
    }

    const existingNormalized = normalizeApplication(existing);
    const appRank = APPLICATION_STATUS_RANK[normalizedApp.status] ?? 0;
    const existingRank =
      APPLICATION_STATUS_RANK[existingNormalized.status] ?? 0;
    const appTime = normalizedApp.last_updated_at.getTime();
    const existingTime = existingNormalized.last_updated_at.getTime();

    if (appRank > existingRank) {
      if (
        ["draft", "withdrawn", "rejected"].includes(existingNormalized.status)
      ) {
        byProgramPeriod.set(key, app);
      }
    } else if (appRank === existingRank && appTime > existingTime) {
      byProgramPeriod.set(key, app);
    }
  }

  const withoutProgram = applications.filter(
    (app) => !normalizeApplication(app).program_id,
  );
  return [...byProgramPeriod.values(), ...withoutProgram].sort((a, b) => {
    const aTime = normalizeApplication(a).last_updated_at.getTime();
    const bTime = normalizeApplication(b).last_updated_at.getTime();
    return bTime - aTime;
  });
}
