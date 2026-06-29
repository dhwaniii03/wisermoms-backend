-- CreateEnum
CREATE TYPE "OrganizationType" AS ENUM ('Non-profit (501c3)', 'Government Agency', 'Cooperative', 'Other');

-- AlterTable
ALTER TABLE "partner_organizations" ALTER COLUMN "type" TYPE "OrganizationType" USING ("type"::"OrganizationType");

-- AlterTable
ALTER TABLE "organizations" ADD COLUMN "type" "OrganizationType";
