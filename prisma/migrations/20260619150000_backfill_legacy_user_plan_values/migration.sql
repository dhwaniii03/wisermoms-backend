-- Plans belong on subscriptions (org billing), not on users.
ALTER TABLE "users" DROP COLUMN IF EXISTS "plan";
