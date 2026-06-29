-- CreateEnum
CREATE TYPE "EnrollmentStatus" AS ENUM ('enrolled', 'pending', 'waitlisted', 'inactive');

-- CreateEnum
CREATE TYPE "CaseOutcomeResult" AS ENUM ('approved', 'denied');

-- CreateEnum
CREATE TYPE "DocumentReviewStatus" AS ENUM ('pending', 'approved', 'rejected');

-- CreateEnum
CREATE TYPE "FlagStatus" AS ENUM ('open', 'resolved', 'dismissed');

-- CreateEnum
CREATE TYPE "CommunicationChannel" AS ENUM ('email', 'sms', 'portal');

-- CreateEnum
CREATE TYPE "CommunicationDeliveryStatus" AS ENUM ('pending', 'sent', 'delivered', 'failed');

-- CreateEnum
CREATE TYPE "ReferralStatus" AS ENUM ('pending', 'accepted', 'declined');

-- CreateEnum
CREATE TYPE "ReferralOutcome" AS ENUM ('success', 'fail');

-- CreateTable
CREATE TABLE "partner_organizations" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "type" TEXT,
    "address" TEXT,
    "contact_email" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "partner_organizations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "org_users" (
    "id" UUID NOT NULL,
    "full_name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "role" TEXT,
    "org_id" UUID NOT NULL,
    "caseload_capacity" INTEGER,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "last_login" TIMESTAMPTZ,

    CONSTRAINT "org_users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mothers" (
    "id" UUID NOT NULL,
    "user_id" UUID,
    "caseworker_id" UUID,
    "dob" DATE,
    "phone" TEXT,
    "address" TEXT,
    "enrollment_status" "EnrollmentStatus" NOT NULL DEFAULT 'pending',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "mothers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cases" (
    "id" UUID NOT NULL,
    "mother_id" UUID NOT NULL,
    "caseworker_id" UUID,
    "program_id" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "urgency_level" TEXT,
    "quarter" TEXT,
    "intake_date" DATE,
    "last_activity" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "cases_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "case_outcomes" (
    "id" UUID NOT NULL,
    "case_id" UUID NOT NULL,
    "result" "CaseOutcomeResult" NOT NULL,
    "denial_reason" TEXT,
    "benefit_amount_usd" DECIMAL(12,2),
    "first_benefit_date" DATE,
    "decided_at" TIMESTAMPTZ,
    "recorded_by" UUID,
    "notes" TEXT,

    CONSTRAINT "case_outcomes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "caseworker_metrics" (
    "id" UUID NOT NULL,
    "caseworker_id" UUID NOT NULL,
    "org_id" UUID NOT NULL,
    "period" TEXT NOT NULL,
    "active_case_count" INTEGER NOT NULL DEFAULT 0,
    "completion_rate" DECIMAL(5,2),
    "avg_response_hours" DECIMAL(8,2),
    "caseload_utilization" DECIMAL(5,2),
    "computed_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "caseworker_metrics_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "org_metrics_snapshots" (
    "id" UUID NOT NULL,
    "org_id" UUID NOT NULL,
    "period" TEXT NOT NULL,
    "mothers_served" INTEGER NOT NULL DEFAULT 0,
    "benefits_unlocked_usd" DECIMAL(14,2),
    "submission_rate" DECIMAL(5,2),
    "approval_rate" DECIMAL(5,2),
    "renewal_compliance_rate" DECIMAL(5,2),
    "avg_intake_to_benefit_days" DECIMAL(8,2),
    "computed_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "org_metrics_snapshots_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "case_deadlines" (
    "id" UUID NOT NULL,
    "case_id" UUID NOT NULL,
    "type" TEXT NOT NULL,
    "due_date" DATE NOT NULL,
    "is_resolved" BOOLEAN NOT NULL DEFAULT false,
    "alert_sent_at" TIMESTAMPTZ,
    "notes" TEXT,

    CONSTRAINT "case_deadlines_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "case_documents" (
    "id" UUID NOT NULL,
    "case_id" UUID NOT NULL,
    "doc_type" TEXT NOT NULL,
    "file_url" TEXT NOT NULL,
    "uploaded_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiry_date" DATE,
    "review_status" "DocumentReviewStatus" NOT NULL DEFAULT 'pending',
    "reviewed_by" UUID,

    CONSTRAINT "case_documents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "flags" (
    "id" UUID NOT NULL,
    "case_id" UUID NOT NULL,
    "flagged_by" UUID,
    "reason" TEXT NOT NULL,
    "status" "FlagStatus" NOT NULL DEFAULT 'open',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "resolved_at" TIMESTAMPTZ,

    CONSTRAINT "flags_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "communications" (
    "id" UUID NOT NULL,
    "case_id" UUID NOT NULL,
    "sent_by" UUID,
    "type" TEXT NOT NULL,
    "channel" "CommunicationChannel" NOT NULL,
    "message" TEXT NOT NULL,
    "sent_at" TIMESTAMPTZ,
    "responded_at" TIMESTAMPTZ,
    "delivery_status" "CommunicationDeliveryStatus" NOT NULL DEFAULT 'pending',

    CONSTRAINT "communications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "referrals" (
    "id" UUID NOT NULL,
    "case_id" UUID NOT NULL,
    "from_org_id" UUID NOT NULL,
    "to_org_id" UUID NOT NULL,
    "referred_by" UUID,
    "status" "ReferralStatus" NOT NULL DEFAULT 'pending',
    "outcome" "ReferralOutcome",
    "responded_at" TIMESTAMPTZ,
    "notes" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "referrals_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "status_history" (
    "id" UUID NOT NULL,
    "case_id" UUID NOT NULL,
    "changed_by" UUID,
    "old_status" TEXT,
    "new_status" TEXT NOT NULL,
    "changed_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "notes" TEXT,

    CONSTRAINT "status_history_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "org_users_email_key" ON "org_users"("email");

-- CreateIndex
CREATE INDEX "org_users_org_id_idx" ON "org_users"("org_id");

-- CreateIndex
CREATE INDEX "mothers_caseworker_id_idx" ON "mothers"("caseworker_id");

-- CreateIndex
CREATE INDEX "cases_mother_id_idx" ON "cases"("mother_id");

-- CreateIndex
CREATE INDEX "cases_caseworker_id_idx" ON "cases"("caseworker_id");

-- CreateIndex
CREATE INDEX "cases_program_id_idx" ON "cases"("program_id");

-- CreateIndex
CREATE INDEX "case_outcomes_case_id_idx" ON "case_outcomes"("case_id");

-- CreateIndex
CREATE INDEX "case_outcomes_recorded_by_idx" ON "case_outcomes"("recorded_by");

-- CreateIndex
CREATE INDEX "caseworker_metrics_caseworker_id_idx" ON "caseworker_metrics"("caseworker_id");

-- CreateIndex
CREATE INDEX "caseworker_metrics_org_id_idx" ON "caseworker_metrics"("org_id");

-- CreateIndex
CREATE INDEX "org_metrics_snapshots_org_id_idx" ON "org_metrics_snapshots"("org_id");

-- CreateIndex
CREATE INDEX "case_deadlines_case_id_idx" ON "case_deadlines"("case_id");

-- CreateIndex
CREATE INDEX "case_documents_case_id_idx" ON "case_documents"("case_id");

-- CreateIndex
CREATE INDEX "case_documents_reviewed_by_idx" ON "case_documents"("reviewed_by");

-- CreateIndex
CREATE INDEX "flags_case_id_idx" ON "flags"("case_id");

-- CreateIndex
CREATE INDEX "flags_flagged_by_idx" ON "flags"("flagged_by");

-- CreateIndex
CREATE INDEX "communications_case_id_idx" ON "communications"("case_id");

-- CreateIndex
CREATE INDEX "communications_sent_by_idx" ON "communications"("sent_by");

-- CreateIndex
CREATE INDEX "referrals_case_id_idx" ON "referrals"("case_id");

-- CreateIndex
CREATE INDEX "referrals_from_org_id_idx" ON "referrals"("from_org_id");

-- CreateIndex
CREATE INDEX "referrals_to_org_id_idx" ON "referrals"("to_org_id");

-- CreateIndex
CREATE INDEX "referrals_referred_by_idx" ON "referrals"("referred_by");

-- CreateIndex
CREATE INDEX "status_history_case_id_idx" ON "status_history"("case_id");

-- CreateIndex
CREATE INDEX "status_history_changed_by_idx" ON "status_history"("changed_by");

-- AddForeignKey
ALTER TABLE "org_users" ADD CONSTRAINT "org_users_org_id_fkey" FOREIGN KEY ("org_id") REFERENCES "partner_organizations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mothers" ADD CONSTRAINT "mothers_caseworker_id_fkey" FOREIGN KEY ("caseworker_id") REFERENCES "org_users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cases" ADD CONSTRAINT "cases_mother_id_fkey" FOREIGN KEY ("mother_id") REFERENCES "mothers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cases" ADD CONSTRAINT "cases_caseworker_id_fkey" FOREIGN KEY ("caseworker_id") REFERENCES "org_users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cases" ADD CONSTRAINT "cases_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "programs"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "case_outcomes" ADD CONSTRAINT "case_outcomes_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "cases"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "case_outcomes" ADD CONSTRAINT "case_outcomes_recorded_by_fkey" FOREIGN KEY ("recorded_by") REFERENCES "org_users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "caseworker_metrics" ADD CONSTRAINT "caseworker_metrics_caseworker_id_fkey" FOREIGN KEY ("caseworker_id") REFERENCES "org_users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "caseworker_metrics" ADD CONSTRAINT "caseworker_metrics_org_id_fkey" FOREIGN KEY ("org_id") REFERENCES "partner_organizations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "org_metrics_snapshots" ADD CONSTRAINT "org_metrics_snapshots_org_id_fkey" FOREIGN KEY ("org_id") REFERENCES "partner_organizations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "case_deadlines" ADD CONSTRAINT "case_deadlines_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "cases"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "case_documents" ADD CONSTRAINT "case_documents_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "cases"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "case_documents" ADD CONSTRAINT "case_documents_reviewed_by_fkey" FOREIGN KEY ("reviewed_by") REFERENCES "org_users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "flags" ADD CONSTRAINT "flags_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "cases"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "flags" ADD CONSTRAINT "flags_flagged_by_fkey" FOREIGN KEY ("flagged_by") REFERENCES "org_users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "communications" ADD CONSTRAINT "communications_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "cases"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "communications" ADD CONSTRAINT "communications_sent_by_fkey" FOREIGN KEY ("sent_by") REFERENCES "org_users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "referrals" ADD CONSTRAINT "referrals_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "cases"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "referrals" ADD CONSTRAINT "referrals_from_org_id_fkey" FOREIGN KEY ("from_org_id") REFERENCES "partner_organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "referrals" ADD CONSTRAINT "referrals_to_org_id_fkey" FOREIGN KEY ("to_org_id") REFERENCES "partner_organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "referrals" ADD CONSTRAINT "referrals_referred_by_fkey" FOREIGN KEY ("referred_by") REFERENCES "org_users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "status_history" ADD CONSTRAINT "status_history_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "cases"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "status_history" ADD CONSTRAINT "status_history_changed_by_fkey" FOREIGN KEY ("changed_by") REFERENCES "org_users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

