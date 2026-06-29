-- Drop manually-added column defaults that drifted from the Prisma schema.
-- `id` is generated client-side via Prisma `@default(uuid())` and `updated_at`
-- is managed client-side via `@updatedAt`, so neither needs a database default.
-- These DROP DEFAULTs are no-ops on a fresh database (where the defaults never
-- existed) and remove the drift on the live database.
ALTER TABLE "program_quarter_due_dates" ALTER COLUMN "id" DROP DEFAULT;
ALTER TABLE "program_quarter_due_dates" ALTER COLUMN "updated_at" DROP DEFAULT;
