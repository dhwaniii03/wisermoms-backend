-- Reconciliation migration.
--
-- The live database drifted from schema.prisma because several earlier
-- migrations were recorded as applied in _prisma_migrations without their DDL
-- actually executing (baseline/restore mismatch). This migration is fully
-- idempotent so it brings any database (drifted or fresh) to the intended
-- schema state and is safe to replay.

-- 1) ApplicationSubmission profile snapshot columns (previously applied out-of-band).
ALTER TABLE "application_submissions"
  ADD COLUMN IF NOT EXISTS "profile_snapshot" JSONB,
  ADD COLUMN IF NOT EXISTS "profile_snapshot_at" TIMESTAMPTZ(6);

-- 2) users.full_name -> split into first/middle/last, then drop the legacy column.
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'users' AND column_name = 'full_name'
  ) THEN
    UPDATE "users"
    SET
      "first_name" = COALESCE(
        NULLIF(TRIM("first_name"), ''),
        (regexp_split_to_array(TRIM("full_name"), '\s+'))[1],
        ''
      ),
      "last_name" = COALESCE(
        NULLIF(TRIM("last_name"), ''),
        CASE
          WHEN array_length(regexp_split_to_array(TRIM("full_name"), '\s+'), 1) >= 2
          THEN (regexp_split_to_array(TRIM("full_name"), '\s+'))[array_length(regexp_split_to_array(TRIM("full_name"), '\s+'), 1)]
          ELSE ''
        END,
        ''
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

    ALTER TABLE "users" ALTER COLUMN "first_name" SET DEFAULT '';
    ALTER TABLE "users" ALTER COLUMN "first_name" SET NOT NULL;
    ALTER TABLE "users" ALTER COLUMN "last_name" SET DEFAULT '';
    ALTER TABLE "users" ALTER COLUMN "last_name" SET NOT NULL;

    ALTER TABLE "users" DROP COLUMN "full_name";
  END IF;
END $$;

-- 3) Plans live on subscriptions; refresh tokens live in refresh_tokens table.
ALTER TABLE "users" DROP COLUMN IF EXISTS "plan";
ALTER TABLE "users" DROP COLUMN IF EXISTS "refresh_token";

-- 4) Remove legacy UserPlan enum values (free/family/navigator). Only subscriptions.plan
--    still references the type at this point, and it uses none of the legacy values.
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_enum e JOIN pg_type t ON t.oid = e.enumtypid
    WHERE t.typname = 'UserPlan' AND e.enumlabel IN ('free', 'family', 'navigator')
  ) THEN
    ALTER TABLE "subscriptions" ALTER COLUMN "plan" DROP DEFAULT;
    ALTER TYPE "UserPlan" RENAME TO "UserPlan_old";
    CREATE TYPE "UserPlan" AS ENUM ('community', 'partner', 'network');
    ALTER TABLE "subscriptions"
      ALTER COLUMN "plan" TYPE "UserPlan" USING ("plan"::text::"UserPlan");
    DROP TYPE "UserPlan_old";
  END IF;
END $$;

-- 5) OrganizationType enum: add the values defined in schema.prisma (additive, idempotent).
ALTER TYPE "OrganizationType" ADD VALUE IF NOT EXISTS '211 Network';
ALTER TYPE "OrganizationType" ADD VALUE IF NOT EXISTS 'Childcare Provider';
ALTER TYPE "OrganizationType" ADD VALUE IF NOT EXISTS 'DV Coalition';
ALTER TYPE "OrganizationType" ADD VALUE IF NOT EXISTS 'Education Nonprofit';
ALTER TYPE "OrganizationType" ADD VALUE IF NOT EXISTS 'Emergency Shelter';
ALTER TYPE "OrganizationType" ADD VALUE IF NOT EXISTS 'Faith-Based';
ALTER TYPE "OrganizationType" ADD VALUE IF NOT EXISTS 'Food Bank';
ALTER TYPE "OrganizationType" ADD VALUE IF NOT EXISTS 'Health Clinic';
ALTER TYPE "OrganizationType" ADD VALUE IF NOT EXISTS 'Housing Nonprofit';
ALTER TYPE "OrganizationType" ADD VALUE IF NOT EXISTS 'Immigration Nonprofit';
ALTER TYPE "OrganizationType" ADD VALUE IF NOT EXISTS 'Legal Aid';
ALTER TYPE "OrganizationType" ADD VALUE IF NOT EXISTS 'Workforce Development';
ALTER TYPE "OrganizationType" ADD VALUE IF NOT EXISTS 'Wraparound Nonprofit';

-- 6) Restore the users.org_id -> organizations.id foreign key.
--    First null out orphaned references (org_id pointing at a deleted organization),
--    which is consistent with the relation's ON DELETE SET NULL behaviour.
UPDATE "users" u
SET "org_id" = NULL
WHERE u."org_id" IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM "organizations" o WHERE o."id" = u."org_id");

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'users_org_id_fkey') THEN
    ALTER TABLE "users"
      ADD CONSTRAINT "users_org_id_fkey"
      FOREIGN KEY ("org_id") REFERENCES "organizations"("id")
      ON DELETE SET NULL ON UPDATE CASCADE;
  END IF;
END $$;
