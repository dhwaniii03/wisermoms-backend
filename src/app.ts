import express, { Application } from "express";
import cors from "cors";
import helmet from "helmet";
import cookieParser from "cookie-parser";
import { allowedOrigins } from "./config/env";
import { errorHandler } from "./middleware/errorHandler";
import { apiLimiter } from "./middleware/rateLimiter";
import { responseSanitizer } from "./middleware/sanitize";
import { requestLogger } from "./middleware/requestLogger";

// Import Feature Routers
import authRoutes from "./modules/auth/auth.routes";
import userRoutes from "./modules/user/user.routes";
import eligibilityRoutes from "./modules/eligibility/eligibility.routes";
import programsRoutes from "./modules/programs/programs.routes";
import applicationsRoutes from "./modules/applications/applications.routes";
import documentsRoutes from "./modules/documents/documents.routes";
import notificationsRoutes from "./modules/notifications/notifications.routes";
import deadlinesRoutes from "./modules/deadlines/deadlines.routes";
import sessionsRoutes from "./modules/sessions/sessions.routes";
import billingRoutes from "./modules/billing/billing.routes";
import billingWebhookRoutes from "./modules/billing/billing.webhook.routes";
import adminRoutes from "./modules/admin/admin.routes";
import pdfRoutes from "./modules/pdf/pdf.routes";
import partnerAuthRoutes from "./modules/partner/partner-auth.routes";
import partnerOrgRoutes from "./modules/partner/partner-org.routes";
import partnerCasesRoutes from "./modules/partner/partner-cases.routes";
import partnerDashboardRoutes from "./modules/partner/partner-dashboard.routes";
import partnerDocumentsRoutes from "./modules/partner/partner-documents.routes";
import partnerAlertsRoutes from "./modules/partner/partner-alerts.routes";
import partnerAnalyticsRoutes from "./modules/partner/partner-analytics.routes";
import organizationsRoutes from "./modules/partner/organizations.routes";
import partnerBillingRoutes from "./modules/partner/partner-billing.routes";
import teamRoutes from "./modules/team/team.routes";
import mothersRoutes from "./modules/mothers/mothers.routes";
import locationRoutes from "./modules/location/location.routes";

const app: Application = express();

// Trust proxy for secure, accurate client IP rate-limiting behind Render/Vercel/reverse proxies
app.set("trust proxy", 1);

// HTTP request/response logging (pretty in dev, JSON in production)
app.use(requestLogger);

// Security Middleware
app.use(helmet());

// CORS: FRONTEND_URL, ADMIN_FRONTEND_URL, and optional CORS_ORIGINS (comma-separated)
app.use(
  cors({
    origin: allowedOrigins,
    credentials: true, // Required so browsers send/receive httpOnly cookies
    exposedHeaders: ["Content-Disposition", "X-Pdf-Version"],
  }),
);

// Parse httpOnly cookies (used for secure auth token storage)
app.use(cookieParser());

// Stripe webhook must receive the raw body for signature verification
app.use("/api/billing", billingWebhookRoutes);

// Body Parsers
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Billing API routes (checkout, subscription, etc.) need parsed JSON bodies
app.use("/api/billing", billingRoutes);

// Apply General Rate Limiting to all general API surface endpoints
app.use("/api", apiLimiter);

// Response sanitizer: strips sensitive PII fields (ssn_last_four, password_hash, etc.)
// from ALL outbound JSON responses before they reach the client
app.use(responseSanitizer);

// Mount Routers
app.use("/api/auth", authRoutes);
app.use("/api/user", userRoutes);
app.use("/api/eligibility", eligibilityRoutes);
app.use("/api/programs", programsRoutes);
app.use("/api/applications", applicationsRoutes);
app.use("/api/documents", documentsRoutes);
app.use("/api/notifications", notificationsRoutes);
app.use("/api/deadlines", deadlinesRoutes);
app.use("/api/sessions", sessionsRoutes);
app.use("/api/admin", adminRoutes);
app.use("/api/pdf", pdfRoutes);
app.use("/api/partner/auth", partnerAuthRoutes);
app.use("/api/partner/organization", partnerOrgRoutes);
app.use("/api/partner/cases", partnerCasesRoutes);
app.use("/api/partner/dashboard", partnerDashboardRoutes);
app.use("/api/partner/documents", partnerDocumentsRoutes);
app.use("/api/partner/alerts", partnerAlertsRoutes);
app.use("/api/partner/analytics", partnerAnalyticsRoutes);
app.use("/api/organizations", organizationsRoutes);
app.use("/api/partner/billing", partnerBillingRoutes);
app.use("/api/team/members", teamRoutes);
app.use("/api/mothers", mothersRoutes);
app.use("/api/location", locationRoutes);

// Health check endpoint
app.get("/health", (req, res) => {
  res.status(200).json({ status: "OK", timestamp: new Date() });
});

// Global Centralized Error Handling Middleware
app.use(errorHandler);

export default app;
