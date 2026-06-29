-- Backfill name parts from full_name before dropping the legacy column
UPDATE "users"
SET
  "first_name" = COALESCE(
    NULLIF(TRIM("first_name"), ''),
    (regexp_split_to_array(TRIM("full_name"), '\s+'))[1]
  ),
  "last_name" = COALESCE(
    NULLIF(TRIM("last_name"), ''),
    CASE
      WHEN array_length(regexp_split_to_array(TRIM("full_name"), '\s+'), 1) >= 2
      THEN (regexp_split_to_array(TRIM("full_name"), '\s+'))[array_length(regexp_split_to_array(TRIM("full_name"), '\s+'), 1)]
      ELSE ''
    END
  ),
  "middle_name" = COALESCE(
    NULLIF(TRIM("middle_name"), ''),
    CASE
      WHEN array_length(regexp_split_to_array(TRIM("full_name"), '\s+'), 1) > 2
      THEN array_to_string(
        (regexp_split_to_array(TRIM("full_name"), '\s+'))[2:array_length(regexp_split_to_array(TRIM("full_name"), '\s+'), 1) - 1],
        ' '
      )
      ELSE NULL
    END
  )
WHERE TRIM(COALESCE("full_name", '')) <> '';

UPDATE "users" SET "first_name" = '' WHERE "first_name" IS NULL;
UPDATE "users" SET "last_name" = '' WHERE "last_name" IS NULL;

ALTER TABLE "users" ALTER COLUMN "first_name" SET DEFAULT '';
ALTER TABLE "users" ALTER COLUMN "first_name" SET NOT NULL;
ALTER TABLE "users" ALTER COLUMN "last_name" SET DEFAULT '';
ALTER TABLE "users" ALTER COLUMN "last_name" SET NOT NULL;

ALTER TABLE "users" DROP COLUMN "full_name";
