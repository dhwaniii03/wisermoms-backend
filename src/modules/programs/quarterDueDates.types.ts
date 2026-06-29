export type Quarter = 'Q1' | 'Q2' | 'Q3' | 'Q4';

export const QUARTERS: Quarter[] = ['Q1', 'Q2', 'Q3', 'Q4'];

export const QUARTER_MONTHS: Record<Quarter, [number, number, number]> = {
  Q1: [1, 2, 3],
  Q2: [4, 5, 6],
  Q3: [7, 8, 9],
  Q4: [10, 11, 12],
};

export type QuarterDueDateSource = 'GOVT' | 'CALCULATED';

export interface QuarterDueDateRecord {
  id: string;
  program_id: string;
  year: number;
  quarter: Quarter;
  due_dates_json: string[];
  source: QuarterDueDateSource | null;
  created_at: Date;
  updated_at: Date;
}

export interface GovtQuarterDueDateInput {
  program_id: string;
  year: number;
  quarter: Quarter;
  due_dates: string[];
}
