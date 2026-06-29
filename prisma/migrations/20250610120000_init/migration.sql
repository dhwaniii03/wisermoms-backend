-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('user', 'admin', 'counselor');

-- CreateEnum
CREATE TYPE "UserPlan" AS ENUM ('free', 'family', 'navigator');

-- CreateEnum
CREATE TYPE "UserStatus" AS ENUM ('active', 'inactive', 'flagged');

-- CreateEnum
CREATE TYPE "EligibilityStatus" AS ENUM ('qualified', 'likely_qualified', 'check_required', 'not_qualified');

-- CreateEnum
CREATE TYPE "ApplicationStatus" AS ENUM ('draft', 'submitted', 'under_review', 'action_required', 'approved', 'rejected', 'withdrawn', 'not_started');

-- CreateEnum
CREATE TYPE "ApplicationPriority" AS ENUM ('normal', 'high', 'urgent');

-- CreateEnum
CREATE TYPE "QuarterDueDateSource" AS ENUM ('GOVT', 'CALCULATED');

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL,
    "email" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL DEFAULT '',
    "full_name" TEXT NOT NULL DEFAULT '',
    "phone" TEXT,
    "role" "UserRole" NOT NULL DEFAULT 'user',
    "plan" "UserPlan" NOT NULL DEFAULT 'free',
    "stripe_customer_id" TEXT,
    "stripe_subscription_id" TEXT,
    "state" TEXT,
    "zip_code" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,
    "last_active_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" "UserStatus" NOT NULL DEFAULT 'active',
    "profile_picture" TEXT,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "refresh_tokens" (
    "id" UUID NOT NULL,
    "token" TEXT NOT NULL,
    "user_id" UUID NOT NULL,
    "expires_at" TIMESTAMPTZ NOT NULL,
    "revoked" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "refresh_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "profiles" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "household_size" INTEGER,
    "num_children_under18" INTEGER,
    "children_ages" JSONB,
    "gross_monthly_income" DOUBLE PRECISION,
    "employment_status" TEXT,
    "housing_situation" TEXT,
    "has_disability" BOOLEAN DEFAULT false,
    "pregnant" BOOLEAN DEFAULT false,
    "first_name" TEXT,
    "last_name" TEXT,
    "date_of_birth" DATE,
    "phone" TEXT,
    "email" TEXT,
    "language_preference" TEXT DEFAULT 'en',
    "street_address" TEXT,
    "apartment_suite" TEXT,
    "city" TEXT,
    "state" TEXT DEFAULT 'GA',
    "zip_code" TEXT,
    "monthly_rent" DECIMAL,
    "monthly_utilities" DECIMAL,
    "landlord_name" TEXT,
    "eviction_notice" BOOLEAN DEFAULT false,
    "income_sources" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "other_household_income" BOOLEAN DEFAULT false,
    "children_dobs" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "child_disability" BOOLEAN DEFAULT false,
    "marital_status" TEXT,
    "other_adults" BOOLEAN DEFAULT false,
    "needs_childcare" BOOLEAN DEFAULT false,
    "has_health_insurance" BOOLEAN DEFAULT false,
    "immigration_status" TEXT,
    "legal_issues" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "urgency_level" TEXT,
    "has_savings" BOOLEAN DEFAULT false,
    "domestic_violence" BOOLEAN DEFAULT false,
    "chronic_illness" BOOLEAN DEFAULT false,
    "health_insurance" TEXT,
    "savings_assets" TEXT,
    "monthly_childcare_cost" DECIMAL,
    "employer_name" TEXT,
    "child_support_status" TEXT,
    "childcare_preference" TEXT,
    "childcare_provider" TEXT,
    "ssn_last_four" TEXT,
    "work_situation" TEXT,
    "county" TEXT,
    "postpartum_months_since_birth" INTEGER,
    "breastfeeding" BOOLEAN NOT NULL DEFAULT false,
    "children_under_5_count" INTEGER NOT NULL DEFAULT 0,
    "has_medicaid" BOOLEAN NOT NULL DEFAULT false,
    "has_snap" BOOLEAN NOT NULL DEFAULT false,
    "has_tanf_work_first" BOOLEAN NOT NULL DEFAULT false,
    "has_ssi" BOOLEAN NOT NULL DEFAULT false,
    "has_non_custodial_parent" BOOLEAN NOT NULL DEFAULT false,
    "us_citizen" BOOLEAN NOT NULL DEFAULT true,
    "qualified_immigrant" BOOLEAN NOT NULL DEFAULT false,
    "work_activity_hrs_per_month" INTEGER NOT NULL DEFAULT 0,
    "in_qualifying_activity" BOOLEAN NOT NULL DEFAULT false,
    "previously_denied_medicaid" BOOLEAN NOT NULL DEFAULT false,
    "intake_snapshot" JSONB,
    "preferred_contact" TEXT NOT NULL DEFAULT 'email',
    "consent_data_use" BOOLEAN NOT NULL DEFAULT false,
    "intake_completed_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "profiles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "programs" (
    "id" TEXT NOT NULL,
    "program_name" TEXT NOT NULL,
    "administering_agency" TEXT NOT NULL,
    "program_type" TEXT NOT NULL,
    "federal_or_state" TEXT,
    "state" TEXT,
    "description" TEXT,
    "eligibility_criteria" JSONB,
    "estimated_monthly_value_min" DOUBLE PRECISION,
    "estimated_monthly_value_max" DOUBLE PRECISION,
    "apply_url" TEXT,
    "contact_email" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "tags" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "metadata" JSONB,
    "also_known_as" TEXT,
    "agency_phone" TEXT,
    "agency_website" TEXT,
    "eligibility_summary" TEXT,
    "income_limit_pct_fpl" DECIMAL,
    "income_limit_pct_smi" DECIMAL,
    "asset_limit" DECIMAL,
    "lifetime_limit_months" INTEGER,
    "work_requirement_hrs" INTEGER,
    "renewal_period" TEXT,
    "counties_served" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "languages_available" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "waitlist_status" TEXT DEFAULT 'open',
    "waitlist_notes" TEXT,
    "last_verified_date" DATE,
    "source_url" TEXT,
    "guide_url" TEXT,
    "renewal_period_months" INTEGER,
    "program_code" TEXT,
    "program_due_date" DATE,
    "notes" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "programs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "program_quarter_due_dates" (
    "id" UUID NOT NULL,
    "program_id" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "quarter" TEXT NOT NULL,
    "due_dates_json" JSONB NOT NULL DEFAULT '[]',
    "source" "QuarterDueDateSource",
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "program_quarter_due_dates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "results" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "program_id" TEXT NOT NULL,
    "status" "EligibilityStatus" NOT NULL DEFAULT 'check_required',
    "confidence_score" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "reasoning" TEXT NOT NULL DEFAULT '',
    "checked_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "org_id" UUID,
    "match_type" TEXT,
    "eligibility" TEXT,
    "estimated_benefit" DECIMAL,
    "match_reason" TEXT,
    "ai_rank" INTEGER,
    "reasons" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "program_code" TEXT,
    "created_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "results_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "applications" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "program_id" TEXT,
    "status" TEXT NOT NULL DEFAULT 'draft',
    "submitted_at" TIMESTAMP(3),
    "last_updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "notes" TEXT,
    "assigned_admin_id" UUID,
    "priority" TEXT NOT NULL DEFAULT 'normal',
    "pdf_generated" BOOLEAN DEFAULT false,
    "created_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "applications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "documents" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "application_id" UUID,
    "document_type" TEXT NOT NULL,
    "file_name" TEXT NOT NULL DEFAULT 'unnamed_file',
    "display_name" TEXT NOT NULL DEFAULT 'Unnamed Document',
    "storage_path" TEXT NOT NULL,
    "file_size" INTEGER,
    "mime_type" TEXT,
    "uploaded_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "documents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notifications" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "type" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "is_read" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "related_application_id" UUID,
    "action_url" TEXT,

    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "deadlines" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "application_id" UUID NOT NULL,
    "deadline_type" TEXT NOT NULL,
    "due_date" TIMESTAMP(3) NOT NULL,
    "reminder_sent_at" TIMESTAMP(3),
    "is_completed" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "deadlines_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "counselor_sessions" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "counselor_id" UUID NOT NULL,
    "scheduled_at" TIMESTAMP(3) NOT NULL,
    "duration_minutes" INTEGER NOT NULL DEFAULT 30,
    "status" TEXT NOT NULL,
    "notes" TEXT,
    "meeting_url" TEXT,

    CONSTRAINT "counselor_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_logs" (
    "id" UUID NOT NULL,
    "admin_id" UUID NOT NULL,
    "action" TEXT NOT NULL,
    "target_type" TEXT NOT NULL,
    "target_id" TEXT NOT NULL,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "generated_pdfs" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "application_id" UUID,
    "program_id" TEXT NOT NULL,
    "file_url" TEXT NOT NULL,
    "file_size" INTEGER NOT NULL,
    "version" INTEGER NOT NULL DEFAULT 1,
    "status" TEXT NOT NULL DEFAULT 'generated',
    "validation_report" JSONB,
    "generated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "generated_pdfs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "account_deletion_requests" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "requested_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completed_at" TIMESTAMPTZ,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "error_message" TEXT,

    CONSTRAINT "account_deletion_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "application_guides" (
    "id" UUID NOT NULL,
    "program_id" TEXT,
    "guide_name" TEXT NOT NULL,
    "overview" TEXT,
    "apply_url" TEXT,
    "phone" TEXT,
    "last_verified" DATE,
    "source_url" TEXT,
    "created_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "state" TEXT NOT NULL DEFAULT 'GA',

    CONSTRAINT "application_guides_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "guide_steps" (
    "id" UUID NOT NULL,
    "guide_id" UUID NOT NULL,
    "step_number" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "plain_english" TEXT,
    "tip" TEXT,
    "url" TEXT,
    "created_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "guide_steps_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "appointments" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "org_id" UUID,
    "agency_name" TEXT,
    "appointment_date" TIMESTAMPTZ,
    "notes" TEXT,
    "created_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "appointments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "documents_required" (
    "id" UUID NOT NULL,
    "program_id" TEXT NOT NULL,
    "document_name" TEXT NOT NULL,
    "description" TEXT,
    "required" BOOLEAN NOT NULL DEFAULT true,
    "conditional_on" TEXT,
    "created_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "documents_required_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "income_thresholds" (
    "id" UUID NOT NULL,
    "program_id" TEXT NOT NULL,
    "household_size" INTEGER NOT NULL,
    "income_limit" DECIMAL,
    "income_limit_yr" DECIMAL,
    "benefit_amount" DECIMAL,
    "co_pay" DECIMAL,
    "notes" TEXT,
    "created_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "income_thresholds_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "organizations" (
    "id" UUID NOT NULL,
    "org_name" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "purpose" TEXT,
    "phone" TEXT,
    "crisis_line" TEXT,
    "email" TEXT,
    "website" TEXT,
    "address" TEXT,
    "city" TEXT DEFAULT 'Atlanta',
    "state" TEXT DEFAULT 'GA',
    "zip_code" TEXT,
    "counties_served" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "populations_served" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "languages_served" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "intake_process" TEXT,
    "hours_of_operation" TEXT,
    "flag_dv" BOOLEAN NOT NULL DEFAULT false,
    "flag_eviction" BOOLEAN NOT NULL DEFAULT false,
    "flag_children_u5" BOOLEAN NOT NULL DEFAULT false,
    "flag_pregnant" BOOLEAN NOT NULL DEFAULT false,
    "flag_student" BOOLEAN NOT NULL DEFAULT false,
    "flag_immigrant" BOOLEAN NOT NULL DEFAULT false,
    "flag_no_childcare" BOOLEAN NOT NULL DEFAULT false,
    "dv_safety_mode" BOOLEAN NOT NULL DEFAULT false,
    "partner_tier" TEXT,
    "last_verified_date" DATE,
    "source_url" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "service_tags" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "referral_notes" TEXT,

    CONSTRAINT "organizations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "org_services" (
    "id" UUID NOT NULL,
    "org_id" UUID NOT NULL,
    "service_type" TEXT NOT NULL,
    "notes" TEXT,
    "created_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "org_services_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pdf_generations" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "program_code" TEXT NOT NULL,
    "program_name" TEXT,
    "state" TEXT NOT NULL,
    "language" TEXT NOT NULL DEFAULT 'en',
    "template_used" TEXT,
    "storage_path" TEXT,
    "generated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "pdf_generations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "reminders" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "program_id" TEXT,
    "program_name" TEXT,
    "renewal_date" DATE NOT NULL,
    "reminder_date" DATE,
    "dismissed" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "reminders_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "refresh_tokens_token_key" ON "refresh_tokens"("token");

-- CreateIndex
CREATE INDEX "refresh_tokens_user_id_idx" ON "refresh_tokens"("user_id");

-- CreateIndex
CREATE INDEX "refresh_tokens_token_idx" ON "refresh_tokens"("token");

-- CreateIndex
CREATE UNIQUE INDEX "profiles_user_id_key" ON "profiles"("user_id");

-- CreateIndex
CREATE INDEX "program_quarter_due_dates_program_id_idx" ON "program_quarter_due_dates"("program_id");

-- CreateIndex
CREATE INDEX "program_quarter_due_dates_year_idx" ON "program_quarter_due_dates"("year");

-- CreateIndex
CREATE UNIQUE INDEX "program_quarter_due_dates_program_id_year_quarter_key" ON "program_quarter_due_dates"("program_id", "year", "quarter");

-- CreateIndex
CREATE INDEX "results_user_id_idx" ON "results"("user_id");

-- CreateIndex
CREATE INDEX "results_program_id_idx" ON "results"("program_id");

-- CreateIndex
CREATE UNIQUE INDEX "results_user_id_program_id_key" ON "results"("user_id", "program_id");

-- CreateIndex
CREATE INDEX "applications_user_id_idx" ON "applications"("user_id");

-- CreateIndex
CREATE INDEX "applications_program_id_idx" ON "applications"("program_id");

-- CreateIndex
CREATE INDEX "generated_pdfs_user_id_idx" ON "generated_pdfs"("user_id");

-- CreateIndex
CREATE INDEX "generated_pdfs_program_id_idx" ON "generated_pdfs"("program_id");

-- AddForeignKey
ALTER TABLE "refresh_tokens" ADD CONSTRAINT "refresh_tokens_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "profiles" ADD CONSTRAINT "profiles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "program_quarter_due_dates" ADD CONSTRAINT "program_quarter_due_dates_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "programs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "results" ADD CONSTRAINT "results_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "results" ADD CONSTRAINT "results_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "programs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "results" ADD CONSTRAINT "results_org_id_fkey" FOREIGN KEY ("org_id") REFERENCES "organizations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "applications" ADD CONSTRAINT "applications_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "applications" ADD CONSTRAINT "applications_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "programs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "applications" ADD CONSTRAINT "applications_assigned_admin_id_fkey" FOREIGN KEY ("assigned_admin_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documents" ADD CONSTRAINT "documents_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documents" ADD CONSTRAINT "documents_application_id_fkey" FOREIGN KEY ("application_id") REFERENCES "applications"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_related_application_id_fkey" FOREIGN KEY ("related_application_id") REFERENCES "applications"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "deadlines" ADD CONSTRAINT "deadlines_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "deadlines" ADD CONSTRAINT "deadlines_application_id_fkey" FOREIGN KEY ("application_id") REFERENCES "applications"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "counselor_sessions" ADD CONSTRAINT "counselor_sessions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "counselor_sessions" ADD CONSTRAINT "counselor_sessions_counselor_id_fkey" FOREIGN KEY ("counselor_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_admin_id_fkey" FOREIGN KEY ("admin_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "generated_pdfs" ADD CONSTRAINT "generated_pdfs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "generated_pdfs" ADD CONSTRAINT "generated_pdfs_application_id_fkey" FOREIGN KEY ("application_id") REFERENCES "applications"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "generated_pdfs" ADD CONSTRAINT "generated_pdfs_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "programs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "application_guides" ADD CONSTRAINT "application_guides_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "programs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "guide_steps" ADD CONSTRAINT "guide_steps_guide_id_fkey" FOREIGN KEY ("guide_id") REFERENCES "application_guides"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "appointments" ADD CONSTRAINT "appointments_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "appointments" ADD CONSTRAINT "appointments_org_id_fkey" FOREIGN KEY ("org_id") REFERENCES "organizations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documents_required" ADD CONSTRAINT "documents_required_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "programs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "income_thresholds" ADD CONSTRAINT "income_thresholds_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "programs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "org_services" ADD CONSTRAINT "org_services_org_id_fkey" FOREIGN KEY ("org_id") REFERENCES "organizations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pdf_generations" ADD CONSTRAINT "pdf_generations_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reminders" ADD CONSTRAINT "reminders_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reminders" ADD CONSTRAINT "reminders_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "programs"("id") ON DELETE CASCADE ON UPDATE CASCADE;
