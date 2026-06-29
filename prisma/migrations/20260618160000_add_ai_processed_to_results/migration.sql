-- Add ai_processed flag to eligibility results so the frontend can poll
-- until background AI explanation generation is complete.
ALTER TABLE "results" ADD COLUMN "ai_processed" BOOLEAN NOT NULL DEFAULT FALSE;
