-- CreateEnum
CREATE TYPE "OrgUserRole" AS ENUM ('admin', 'caseworker');

-- Add must_change_password column
ALTER TABLE "org_users" ADD COLUMN "must_change_password" BOOLEAN NOT NULL DEFAULT true;

-- Existing admins should not be forced to change password
UPDATE "org_users" SET "must_change_password" = false WHERE "role" = 'admin';

-- Normalize legacy role strings to caseworker before enum conversion
UPDATE "org_users" SET "role" = 'caseworker' WHERE "role" NOT IN ('admin', 'caseworker');

-- Convert role column to enum
ALTER TABLE "org_users" ALTER COLUMN "role" DROP DEFAULT;
ALTER TABLE "org_users" ALTER COLUMN "role" TYPE "OrgUserRole" USING ("role"::"OrgUserRole");
ALTER TABLE "org_users" ALTER COLUMN "role" SET DEFAULT 'caseworker';
