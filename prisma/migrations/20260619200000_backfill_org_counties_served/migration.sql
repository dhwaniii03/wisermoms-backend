-- Partner org signup stores county but not counties_served; mom portal filters by counties_served.
UPDATE "organizations"
SET "counties_served" = ARRAY["county"]
WHERE "county" IS NOT NULL
  AND TRIM("county") <> ''
  AND COALESCE(array_length("counties_served", 1), 0) = 0;
