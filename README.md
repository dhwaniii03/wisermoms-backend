# MomPlan Backend SaaS Platform

Complete production-ready backend for **MomPlan** — an AI-powered government benefits eligibility scanning and application management SaaS platform designed to seamlessly integrate with premium React/Stripe/Claude web clients.

---

## 🚀 Architecture & Tech Stack

- **Runtime**: Node.js with TypeScript (`tsx` for dev, `tsc` for production builds)
- **Framework**: Express.js with robust async lifecycle traps
- **Database**: PostgreSQL (primary persistent storage) + Redis (sessions, token caches, queue persistence)
- **ORM**: Prisma Client v5
- **Auth**: Secure JSON Web Tokens (short-lived access tokens + Redis-backed multi-device refresh token session control) + bcrypt password hashing
- **File Storage**: AWS S3 compatible multipart document capture logic with cryptographically unique bucket keys and Presigned Access interfaces
- **AI Engine**: Direct zero-overhead streaming interface to **Anthropic Claude 3.5 Sonnet Messages API** driving smart benefit eligibility assessments
- **Payments**: Complete **Stripe** Subscriptions billing lifecycle mapping (Checkout, Billing Portals, Raw buffer webhooks with signature checks)
- **Background Jobs**: **BullMQ** + Redis handling repeated daily/weekly/monthly cron queues
- **Security**: Helmet headers, explicit single-origin CORS guards, express-rate-limit application rate fences, and pure Zod input validation wrappers

---

## 📁 Repository Structure

Built adhering strictly to clean modular architecture patterns completely separating HTTP route definitions from core business logic services.

```text
backend/
├── prisma/
│   └── schema.prisma                # Exhaustive schema maps for Users, Benefits, Apps, Docs & Audit blocks
├── src/
│   ├── config/                      # Validated configs (Zod Env, Singleton Prisma, Redis, Stripe, S3, Claude API, Resend)
│   ├── middleware/                  # Universal guards (JWT Auth, Role checking, Zod Validation, Errors, Rate Limiters)
│   ├── utils/                       # Shared logic utilities and custom HTTP AppError definitions
│   ├── modules/                     # Isolated functional feature modules
│   │   ├── admin/                   # Admin user controls, state overrides, analytics matrices & logs
│   │   ├── applications/            # User applications creation, status logs & workflow hooks
│   │   ├── auth/                    # Complete registration, sign-in, token refresh, reset flows
│   │   ├── billing/                 # Stripe plans integration & real-time webhook update parsers
│   │   ├── deadlines/               # Dynamic reminder scheduling and recertification flags
│   │   ├── documents/               # 10MB buffered multipart file verification pipelines
│   │   ├── eligibility/             # Claude JSON-array parsing benefits match engine
│   │   ├── notifications/           # User dashboard alert items & read toggle handlers
│   │   ├── programs/                # Filterable program profiles & admin audit tracking
│   │   ├── sessions/                # Multi-role counselor schedule booking engines
│   │   └── user/                    # Household matrix and basic user profile management
│   ├── jobs/                        # BullMQ Queues setup
│   │   ├── workers/                 # Active workers processing pending reminders, renewals & DB syncs
│   │   └── scheduler.ts             # Bootstrapping helper triggering recurring background cron loops
│   ├── app.ts                       # Express application bootstrap assembling modular routing trees
│   └── server.ts                    # HTTP server runtime host and database listeners
├── .env.example                     # Reference config environment variables template
├── package.json                     # Runtime requirements specification
└── tsconfig.json                    # Modern ES2022 Node.js target compiler settings
```

---

## 🛠️ Local Installation & Development Setup

### 1. Prerequisites
- **Node.js** v20+ installed
- **PostgreSQL** instance running locally or hosted accessible via connection string
- **Redis** server running locally on default port `6379`

### 2. Dependency Resolution
Navigate to the root directory and install application packages:
```bash
npm install
```

### 3. Environment Variables
Copy the reference template file to establish custom keys:
```bash
cp .env.example .env
```
Ensure you update keys inside `.env` with live access endpoints or retain the provided placeholder blocks to run safe automated fallbacks and simulated demonstration traces.

### 4. Database Setup
Initialize table collections and generate custom Prisma typings:
```bash
npx prisma db push
npx prisma generate
```

### 5. Running the Application
Launch the real-time compiled development listener engine:
```bash
npm run dev
```

The platform runs active service verification on base address `http://localhost:5000/health`.

---

## 🛡️ Role-Based Access Controls (RBAC)

The REST API exposes precise security restrictions based on the signed-in user's `role` property:
- **`user`**: Permitted to update individual/family profiles, trigger personal eligibility scans, create application instances, verify assigned deadlines, upload 10MB S3 files, and schedule counselor consultations.
- **`counselor`**: Can review all system benefit profiles, query linked member records, verify uploaded document validity, and administer dedicated consultation sessions.
- **`admin`**: Total elevated root permissions. Can inspect real-time platform statistics, query continuous 30-day submission metrics, overwrite active member privileges, create/edit benefit programs, and view historical actions logged continuously to dedicated immutable `audit_logs` collections.
