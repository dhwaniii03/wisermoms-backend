-- Track when eligibility was last scanned on the profile so stale detection
-- does not false-positive after a scan updates profile fields in the same request.
ALTER TABLE "profiles"
ADD COLUMN "last_eligibility_scan_at" TIMESTAMPTZ(6);

UPDATE "profiles" fp
SET "last_eligibility_scan_at" = sub.max_checked
FROM (
  SELECT user_id, MAX(checked_at) AS max_checked
  FROM "results"
  GROUP BY user_id
) sub
WHERE fp.user_id = sub.user_id;
