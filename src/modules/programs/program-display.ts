/** Canonical full display names (NAME-01) keyed by benefit program id. */
export const PROGRAM_DISPLAY_NAMES: Record<string, string> = {
  tanf: 'Temporary Assistance for Needy Families',
  wic: 'Women, Infants and Children',
  ccdf: 'Child Care Assistance Program',
  medicaid: 'Medicaid & CHIP',
  snap: 'Supplemental Nutrition Assistance Program',
  section8: 'Housing Choice Voucher Program',
  liheap: 'Low Income Home Energy Assistance Program',
};

/** Short badge keys for partner UI color maps. */
export const PROGRAM_BADGE_KEYS: Record<string, string> = {
  snap: 'SNAP',
  wic: 'WIC',
  medicaid: 'Medicaid',
  tanf: 'TANF',
  ccdf: 'CCAP',
  section8: 'Housing',
  liheap: 'LIHEAP',
};

export function programDisplayName(programId: string, programName?: string | null): string {
  const canonical = PROGRAM_DISPLAY_NAMES[programId];
  if (canonical) return canonical;
  if (programName?.trim()) return programName.trim();
  return programId;
}

export function programBadgeKey(programId: string, programName?: string | null): string {
  const badge = PROGRAM_BADGE_KEYS[programId];
  if (badge) return badge;
  return programName?.split(/[—–-]/)[0]?.trim() ?? programId;
}
