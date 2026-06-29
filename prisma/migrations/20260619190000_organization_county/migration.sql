-- Add county field for partner organization location (mirrors mom portal family profile)
ALTER TABLE "organizations" ADD COLUMN IF NOT EXISTS "county" TEXT;
