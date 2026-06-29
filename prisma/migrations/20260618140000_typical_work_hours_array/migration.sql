-- Store multi-select work hours as a native text array (like income_sources / legal_issues)
ALTER TABLE "profiles" ADD COLUMN "typical_work_hours" TEXT[] DEFAULT ARRAY[]::TEXT[];

-- Backfill from legacy work_situation comma-separated values when they are valid work-hour ids
UPDATE "profiles"
SET "typical_work_hours" = sub.hours
FROM (
  SELECT
    p.id,
    COALESCE(
      array_agg(trim(elem) ORDER BY ord) FILTER (
        WHERE trim(elem) IN ('weekdays', 'evenings', 'weekends', 'rotating', 'varies', 'not_working')
      ),
      ARRAY[]::TEXT[]
    ) AS hours
  FROM "profiles" p
  CROSS JOIN LATERAL unnest(string_to_array(COALESCE(p.work_situation, ''), ',')) WITH ORDINALITY AS t(elem, ord)
  WHERE p.work_situation IS NOT NULL AND trim(p.work_situation) <> ''
  GROUP BY p.id
) AS sub
WHERE "profiles".id = sub.id
  AND cardinality(sub.hours) > 0;
