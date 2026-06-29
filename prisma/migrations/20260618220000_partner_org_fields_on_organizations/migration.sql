-- Partner portal columns on the unified organizations table
ALTER TABLE "organizations"
  ADD COLUMN IF NOT EXISTS "billing_user_id" UUID,
  ADD COLUMN IF NOT EXISTS "onboarding_completed" BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS "tagline" TEXT,
  ADD COLUMN IF NOT EXISTS "description" TEXT,
  ADD COLUMN IF NOT EXISTS "services_offered" TEXT,
  ADD COLUMN IF NOT EXISTS "service_area" TEXT,
  ADD COLUMN IF NOT EXISTS "primary_language" TEXT DEFAULT 'English',
  ADD COLUMN IF NOT EXISTS "notification_frequency" TEXT DEFAULT 'daily',
  ADD COLUMN IF NOT EXISTS "case_numbering_prefix" TEXT DEFAULT 'CASE',
  ADD COLUMN IF NOT EXISTS "country" TEXT,
  ADD COLUMN IF NOT EXISTS "employees" TEXT,
  ADD COLUMN IF NOT EXISTS "founded" TEXT,
  ADD COLUMN IF NOT EXISTS "tax_id" TEXT,
  ADD COLUMN IF NOT EXISTS "linkedin" TEXT,
  ADD COLUMN IF NOT EXISTS "contact_email" TEXT;

CREATE UNIQUE INDEX IF NOT EXISTS "organizations_billing_user_id_key" ON "organizations"("billing_user_id");

ALTER TABLE "organizations" DROP CONSTRAINT IF EXISTS "organizations_billing_user_id_fkey";
ALTER TABLE "organizations" ADD CONSTRAINT "organizations_billing_user_id_fkey"
  FOREIGN KEY ("billing_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- Remove portal users whose org was dropped during the organizations table consolidation
DELETE FROM "org_users"
WHERE "org_id" NOT IN (SELECT "id" FROM "organizations");

ALTER TABLE "org_users" DROP CONSTRAINT IF EXISTS "org_users_org_id_fkey";
ALTER TABLE "org_users" ADD CONSTRAINT "org_users_org_id_fkey"
  FOREIGN KEY ("org_id") REFERENCES "organizations"("id") ON DELETE CASCADE ON UPDATE CASCADE;
