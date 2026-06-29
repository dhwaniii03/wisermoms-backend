import assert from 'node:assert/strict';
import { dedupeApplicationsByProgram } from '../src/modules/applications/applications.dedupe';

type Row = {
  id: string;
  program_id: string | null;
  status: string;
  last_updated_at: Date;
};

function row(
  id: string,
  program_id: string,
  status: string,
  last_updated_at: Date
): Row {
  return { id, program_id, status, last_updated_at };
}

function medicaid(status: string, daysAgo: number, id = crypto.randomUUID()): Row {
  const d = new Date();
  d.setDate(d.getDate() - daysAgo);
  return row(id, 'medicaid', status, d);
}

function assertMedicaidStatus(result: Row[], expected: string, label: string) {
  const med = result.find((a) => a.program_id === 'medicaid');
  assert.ok(med, `${label}: Medicaid row missing`);
  assert.equal(med.status, expected, `${label}: expected status ${expected}, got ${med.status}`);
}

// Newer submitted must win over older under_review (MED-03 regression).
{
  const input = [
    medicaid('submitted', 0, 'new-submitted'),
    medicaid('under_review', 30, 'old-review'),
  ];
  const result = dedupeApplicationsByProgram(input);
  assertMedicaidStatus(result, 'submitted', 'submitted vs under_review');
}

// Submitted replaces draft for the same program.
{
  const result = dedupeApplicationsByProgram([
    medicaid('submitted', 0),
    medicaid('draft', 1),
  ]);
  assertMedicaidStatus(result, 'submitted', 'submitted vs draft');
}

// Apps without program_id are preserved.
{
  const noProgram = row('orphan', null, 'draft', new Date());
  const result = dedupeApplicationsByProgram([noProgram, medicaid('draft', 0)]);
  assert.equal(result.length, 2);
  assert.ok(result.some((a) => a.id === 'orphan'));
}

// Distinct programs are all returned.
{
  const result = dedupeApplicationsByProgram([
    row('a', 'snap', 'draft', new Date()),
    row('b', 'medicaid', 'submitted', new Date()),
    row('c', 'wic', 'draft', new Date()),
  ]);
  assert.equal(result.length, 3);
}

// Same program in different quarters are both returned (quarter reporting).
{
  const q1 = { ...medicaid('submitted', 30), quarter: 'Q1', year: 2025 };
  const q2 = { ...medicaid('draft', 0), quarter: 'Q2', year: 2026 };
  const result = dedupeApplicationsByProgram([q1, q2]);
  assert.equal(result.length, 2);
}

console.log('✅ applications.dedupe unit tests passed');
