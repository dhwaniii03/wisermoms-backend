-- Rename community directory orgs to the canonical organizations table
ALTER TABLE "community_organizations" RENAME TO "organizations";

ALTER TABLE "organizations" RENAME CONSTRAINT "community_organizations_pkey" TO "organizations_pkey";
ALTER INDEX IF EXISTS "idx_community_organizations_dv_safety_mode" RENAME TO "idx_organizations_dv_safety_mode";
ALTER INDEX IF EXISTS "idx_community_organizations_state" RENAME TO "idx_organizations_state";
ALTER INDEX IF EXISTS "idx_community_organizations_org_type" RENAME TO "idx_organizations_org_type";
