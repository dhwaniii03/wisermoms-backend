-- DropOrganizationTypeColumn
ALTER TABLE "organizations" DROP COLUMN IF EXISTS "type";

-- AddOrganizationOrgType
ALTER TABLE "organizations" ADD COLUMN IF NOT EXISTS "org_type" TEXT;

CREATE INDEX IF NOT EXISTS "idx_organizations_org_type" ON "organizations"("org_type");
