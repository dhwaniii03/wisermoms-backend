-- Track secure email application submissions and link them to partner cases

CREATE TABLE "application_submissions" (
    "id" UUID NOT NULL,
    "application_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "generated_pdf_id" UUID,
    "document_ids" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "submitted_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "application_submissions_pkey" PRIMARY KEY ("id")
);

ALTER TABLE "cases"
ADD COLUMN "application_id" UUID,
ADD COLUMN "secure_submitted_at" TIMESTAMPTZ(6);

CREATE INDEX "application_submissions_application_id_idx" ON "application_submissions"("application_id");
CREATE INDEX "application_submissions_user_id_idx" ON "application_submissions"("user_id");
CREATE INDEX "cases_application_id_idx" ON "cases"("application_id");
CREATE INDEX "cases_secure_submitted_at_idx" ON "cases"("secure_submitted_at");

ALTER TABLE "application_submissions"
ADD CONSTRAINT "application_submissions_application_id_fkey"
FOREIGN KEY ("application_id") REFERENCES "applications"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "application_submissions"
ADD CONSTRAINT "application_submissions_user_id_fkey"
FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "application_submissions"
ADD CONSTRAINT "application_submissions_generated_pdf_id_fkey"
FOREIGN KEY ("generated_pdf_id") REFERENCES "generated_pdfs"("id") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "cases"
ADD CONSTRAINT "cases_application_id_fkey"
FOREIGN KEY ("application_id") REFERENCES "applications"("id") ON DELETE SET NULL ON UPDATE CASCADE;
