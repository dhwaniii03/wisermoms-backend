-- Eligibility directory orgs move to community_organizations (frees "organizations" name)
ALTER TABLE "organizations" RENAME TO "community_organizations";

ALTER TABLE "community_organizations" RENAME CONSTRAINT "organizations_pkey" TO "community_organizations_pkey";
ALTER INDEX IF EXISTS "idx_organizations_dv_safety_mode" RENAME TO "idx_community_organizations_dv_safety_mode";
ALTER INDEX IF EXISTS "idx_organizations_state" RENAME TO "idx_community_organizations_state";
ALTER INDEX IF EXISTS "idx_organizations_org_type" RENAME TO "idx_community_organizations_org_type";

-- Partner portal orgs become the canonical organizations table
ALTER TABLE "partner_organizations" RENAME TO "organizations";

ALTER TABLE "organizations" RENAME CONSTRAINT "partner_organizations_pkey" TO "organizations_pkey";
ALTER INDEX IF EXISTS "partner_organizations_billing_user_id_key" RENAME TO "organizations_billing_user_id_key";

-- users.org_id now references organizations
ALTER TABLE "users" RENAME COLUMN "partner_org_id" TO "org_id";
ALTER INDEX "users_partner_org_id_idx" RENAME TO "users_org_id_idx";
ALTER TABLE "users" RENAME CONSTRAINT "users_partner_org_id_fkey" TO "users_org_id_fkey";
