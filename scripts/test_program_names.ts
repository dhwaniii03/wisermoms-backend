import assert from 'node:assert/strict';
import {
  PROGRAM_DISPLAY_NAMES,
  programBadgeKey,
  programDisplayName,
} from '../src/modules/programs/program-display';

const NAME_01: Record<string, string> = {
  tanf: 'Temporary Assistance for Needy Families',
  wic: 'Women, Infants and Children',
  ccdf: 'Child Care Assistance Program',
  medicaid: 'Medicaid & CHIP',
};

for (const [id, expected] of Object.entries(NAME_01)) {
  assert.equal(
    programDisplayName(id),
    expected,
    `programDisplayName(${id}) should match NAME-01`
  );
  assert.equal(
    PROGRAM_DISPLAY_NAMES[id],
    expected,
    `PROGRAM_DISPLAY_NAMES[${id}] should match NAME-01`
  );
}

assert.equal(programDisplayName('snap'), 'Supplemental Nutrition Assistance Program');
assert.equal(programDisplayName('unknown_program', 'Custom Benefit'), 'Custom Benefit');
assert.equal(programDisplayName('unknown_program'), 'unknown_program');

assert.equal(programBadgeKey('wic'), 'WIC');
assert.equal(programBadgeKey('ccdf'), 'CCAP');
assert.equal(programBadgeKey('medicaid'), 'Medicaid');

console.log('program-display: all NAME-01 assertions passed');
