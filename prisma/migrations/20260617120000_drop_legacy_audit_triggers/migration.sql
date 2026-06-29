-- Legacy Supabase trigger `log_sensitive_changes()` writes to audit_logs with
-- admin_id = NULL on every users/profiles/applications/cases/payments change.
-- audit_logs.admin_id is NOT NULL, so any prisma.user.update() (e.g. login
-- last_active_at) fails with a null constraint violation.

DROP TRIGGER IF EXISTS trg_audit_users ON public.users;
DROP TRIGGER IF EXISTS trg_audit_profiles ON public.profiles;
DROP TRIGGER IF EXISTS trg_audit_applications ON public.applications;
DROP TRIGGER IF EXISTS trg_audit_cases ON public.cases;
DROP TRIGGER IF EXISTS trg_audit_payments ON public.payments;
DROP TRIGGER IF EXISTS trg_audit_logs_updated_at ON public.audit_logs;

DROP FUNCTION IF EXISTS public.log_sensitive_changes();
