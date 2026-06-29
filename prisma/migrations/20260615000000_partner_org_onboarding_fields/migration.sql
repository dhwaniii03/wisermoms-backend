ALTER TABLE "partner_organizations"
  ADD COLUMN IF NOT EXISTS "tagline"                TEXT,
  ADD COLUMN IF NOT EXISTS "services_offered"       TEXT,
  ADD COLUMN IF NOT EXISTS "service_area"           TEXT,
  ADD COLUMN IF NOT EXISTS "primary_language"       TEXT DEFAULT 'English',
  ADD COLUMN IF NOT EXISTS "notification_frequency" TEXT DEFAULT 'daily',
  ADD COLUMN IF NOT EXISTS "case_numbering_prefix"  TEXT DEFAULT 'CASE',
  ADD COLUMN IF NOT EXISTS "onboarding_completed"   BOOLEAN NOT NULL DEFAULT false;
