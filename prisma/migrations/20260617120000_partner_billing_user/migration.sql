-- Link partner organizations to a billing user account (reuses existing subscription tables)
ALTER TABLE "partner_organizations" ADD COLUMN "billing_user_id" UUID;

CREATE UNIQUE INDEX "partner_organizations_billing_user_id_key" ON "partner_organizations"("billing_user_id");

ALTER TABLE "partner_organizations" ADD CONSTRAINT "partner_organizations_billing_user_id_fkey" FOREIGN KEY ("billing_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;
