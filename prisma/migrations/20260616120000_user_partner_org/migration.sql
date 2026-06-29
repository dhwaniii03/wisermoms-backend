-- AlterTable
ALTER TABLE "users" ADD COLUMN "partner_org_id" UUID;

-- CreateIndex
CREATE INDEX "users_partner_org_id_idx" ON "users"("partner_org_id");

-- AddForeignKey
ALTER TABLE "users" ADD CONSTRAINT "users_partner_org_id_fkey" FOREIGN KEY ("partner_org_id") REFERENCES "partner_organizations"("id") ON DELETE SET NULL ON UPDATE CASCADE;
