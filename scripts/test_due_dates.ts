import assert from 'node:assert/strict';
import { formatDisplayDate } from '../src/utils/date-format.utils';
import { generateDueDatesForQuarter } from '../src/modules/programs/quarterDueDates.service';

assert.equal(formatDisplayDate('2026-06-30T00:00:00.000Z'), 'Jun 30, 2026');
assert.equal(formatDisplayDate(null), null);
assert.equal(formatDisplayDate('invalid'), null);

const q2 = generateDueDatesForQuarter(3, 'Q2', 2026);
assert.ok(q2.dueDates.length > 0, 'Q2 quarterly due dates should be generated');

console.log('due-date utilities: all assertions passed');
