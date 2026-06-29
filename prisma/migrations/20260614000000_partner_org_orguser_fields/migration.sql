-- Add expanded fields to partner_organizations
ALTER TABLE "partner_organizations"
  ADD COLUMN IF NOT EXISTS "website"     TEXT,
  ADD COLUMN IF NOT EXISTS "description" TEXT,
  ADD COLUMN IF NOT EXISTS "phone"       TEXT,
  ADD COLUMN IF NOT EXISTS "city"        TEXT,
  ADD COLUMN IF NOT EXISTS "state"       TEXT,
  ADD COLUMN IF NOT EXISTS "zip"         TEXT,
  ADD COLUMN IF NOT EXISTS "country"     TEXT,
  ADD COLUMN IF NOT EXISTS "employees"   TEXT,
  ADD COLUMN IF NOT EXISTS "founded"     TEXT,
  ADD COLUMN IF NOT EXISTS "tax_id"      TEXT,
  ADD COLUMN IF NOT EXISTS "linkedin"    TEXT;

-- Add password_hash and make role non-nullable with default to org_users
ALTER TABLE "org_users"
  ADD COLUMN IF NOT EXISTS "password_hash" TEXT NOT NULL DEFAULT '',
  ALTER COLUMN "role" SET NOT NULL,
  ALTER COLUMN "role" SET DEFAULT 'admin';

-- Remove the temporary default on password_hash (data migration done; enforce real value going forward)
ALTER TABLE "org_users"
  ALTER COLUMN "password_hash" DROP DEFAULT;

-- Create org_refresh_tokens table for partner portal session management
CREATE TABLE IF NOT EXISTS "org_refresh_tokens" (
  "id"          UUID         NOT NULL DEFAULT gen_random_uuid(),
  "token"       TEXT         NOT NULL,
  "org_user_id" UUID         NOT NULL,
  "revoked"     BOOLEAN      NOT NULL DEFAULT false,
  "expires_at"  TIMESTAMPTZ  NOT NULL,
  "created_at"  TIMESTAMPTZ  NOT NULL DEFAULT now(),

  CONSTRAINT "org_refresh_tokens_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "org_refresh_tokens_token_key" UNIQUE ("token"),
  CONSTRAINT "org_refresh_tokens_org_user_id_fkey"
    FOREIGN KEY ("org_user_id") REFERENCES "org_users"("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "org_refresh_tokens_org_user_id_idx"
  ON "org_refresh_tokens"("org_user_id");
