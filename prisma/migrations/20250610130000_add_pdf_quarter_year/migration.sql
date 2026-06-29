-- AlterTable
ALTER TABLE "generated_pdfs" ADD COLUMN "quarter" TEXT;
ALTER TABLE "generated_pdfs" ADD COLUMN "year" INTEGER;

-- CreateIndex
CREATE INDEX "generated_pdfs_user_id_program_id_quarter_year_idx" ON "generated_pdfs"("user_id", "program_id", "quarter", "year");
