-- Add quarter/year tracking to applications (schema.prisma already defines these fields).
ALTER TABLE "applications" ADD COLUMN IF NOT EXISTS "quarter" TEXT;
ALTER TABLE "applications" ADD COLUMN IF NOT EXISTS "year" INTEGER;
