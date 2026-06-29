-- Step 1: Drop foreign keys referencing the partner portal organizations table
ALTER TABLE "users" DROP CONSTRAINT IF EXISTS "users_org_id_fkey";
ALTER TABLE "org_users" DROP CONSTRAINT IF EXISTS "org_users_org_id_fkey";
ALTER TABLE "caseworker_metrics" DROP CONSTRAINT IF EXISTS "caseworker_metrics_org_id_fkey";
ALTER TABLE "org_metrics_snapshots" DROP CONSTRAINT IF EXISTS "org_metrics_snapshots_org_id_fkey";
ALTER TABLE "referrals" DROP CONSTRAINT IF EXISTS "referrals_from_org_id_fkey";
ALTER TABLE "referrals" DROP CONSTRAINT IF EXISTS "referrals_to_org_id_fkey";
ALTER TABLE "organizations" DROP CONSTRAINT IF EXISTS "organizations_billing_user_id_fkey";

-- Step 2: Drop the partner portal organizations table
DROP TABLE "organizations";
