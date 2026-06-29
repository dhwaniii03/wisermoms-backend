-- Deduplicate programs by normalized program_name (case-insensitive, trimmed).
-- For each group of duplicates, keeps the oldest record and re-links all FKs.

BEGIN;

-- 1. Create a temp table mapping each duplicate to its keeper
CREATE TEMP TABLE program_dedup_map AS
WITH ranked AS (
  SELECT id, program_name,
         ROW_NUMBER() OVER (
           PARTITION BY LOWER(TRIM(program_name))
           ORDER BY created_at ASC, id ASC
         ) AS rn
  FROM programs
)
SELECT dups.id AS duplicate_id, keepers.id AS keeper_id
FROM ranked dups
JOIN ranked keepers
  ON LOWER(TRIM(dups.program_name)) = LOWER(TRIM(keepers.program_name))
  AND keepers.rn = 1
WHERE dups.rn > 1;

-- 2. Handle unique constraints by removing rows that would conflict
-- program_quarter_due_dates has @@unique([program_id, year, quarter])
DELETE FROM program_quarter_due_dates
WHERE id IN (
  SELECT pqdd.id
  FROM program_quarter_due_dates pqdd
  JOIN program_dedup_map m ON pqdd.program_id = m.duplicate_id
  WHERE EXISTS (
    SELECT 1 FROM program_quarter_due_dates existing
    WHERE existing.program_id = m.keeper_id
      AND existing.year = pqdd.year
      AND existing.quarter = pqdd.quarter
      AND existing.id != pqdd.id
  )
);

-- results has @@unique([user_id, program_id])
DELETE FROM results
WHERE id IN (
  SELECT r.id
  FROM results r
  JOIN program_dedup_map m ON r.program_id = m.duplicate_id
  WHERE EXISTS (
    SELECT 1 FROM results existing
    WHERE existing.user_id = r.user_id
      AND existing.program_id = m.keeper_id
      AND existing.id != r.id
  )
);

-- 3. Re-link all FKs to the keeper
UPDATE cases SET program_id = m.keeper_id FROM program_dedup_map m WHERE cases.program_id = m.duplicate_id;
UPDATE applications SET program_id = m.keeper_id FROM program_dedup_map m WHERE applications.program_id = m.duplicate_id;
UPDATE generated_pdfs SET program_id = m.keeper_id FROM program_dedup_map m WHERE generated_pdfs.program_id = m.duplicate_id;
UPDATE results SET program_id = m.keeper_id FROM program_dedup_map m WHERE results.program_id = m.duplicate_id;
UPDATE program_quarter_due_dates SET program_id = m.keeper_id FROM program_dedup_map m WHERE program_quarter_due_dates.program_id = m.duplicate_id;
UPDATE documents_required SET program_id = m.keeper_id FROM program_dedup_map m WHERE documents_required.program_id = m.duplicate_id;
UPDATE income_thresholds SET program_id = m.keeper_id FROM program_dedup_map m WHERE income_thresholds.program_id = m.duplicate_id;
UPDATE reminders SET program_id = m.keeper_id FROM program_dedup_map m WHERE reminders.program_id = m.duplicate_id;
UPDATE application_guides SET program_id = m.keeper_id FROM program_dedup_map m WHERE application_guides.program_id = m.duplicate_id;

-- 4. Delete the duplicate program rows
DELETE FROM programs WHERE id IN (SELECT duplicate_id FROM program_dedup_map);

-- 5. Verify no remaining duplicates
SELECT LOWER(TRIM(program_name)) AS name, COUNT(*) AS remaining FROM programs GROUP BY 1 HAVING COUNT(*) > 1;

-- 6. Show final count
SELECT COUNT(*) AS total_programs FROM programs;

DROP TABLE program_dedup_map;

COMMIT;
