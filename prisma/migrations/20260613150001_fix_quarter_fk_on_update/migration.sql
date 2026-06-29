-- Realign the program_quarter_due_dates -> programs foreign key with the Prisma
-- schema. The live database had this constraint manually recreated with
-- ON UPDATE NO ACTION, while the schema (and the init migration) expect
-- ON UPDATE CASCADE. On a fresh database this drops the constraint created by
-- the init migration and re-adds an identical one, so it remains reproducible.
ALTER TABLE "program_quarter_due_dates" DROP CONSTRAINT "program_quarter_due_dates_program_id_fkey";
ALTER TABLE "program_quarter_due_dates" ADD CONSTRAINT "program_quarter_due_dates_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "programs"("id") ON DELETE CASCADE ON UPDATE CASCADE;
