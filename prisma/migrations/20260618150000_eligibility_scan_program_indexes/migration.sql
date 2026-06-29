-- Indexes to support state-scoped eligibility scan queries
CREATE INDEX IF NOT EXISTS "programs_is_active_idx" ON "programs"("is_active");
CREATE INDEX IF NOT EXISTS "programs_state_code_idx" ON "programs"("state");
CREATE INDEX IF NOT EXISTS "programs_federal_or_state_idx" ON "programs"("federal_or_state");
