# Adaptive Learning OS (ALOS) 2.0

Autonomous adaptive learning platform — Rust backend, Next.js frontend, Hermes AI integration.

**Dual-track:** IELTS Academic (Band 7.0–8.0) + SNBT 2027 (7 subtests, PU priority).

## Architecture

```
apps/web/              Next.js 14 frontend (10 pages, Tailwind CSS)
crates/
  alos-api/            Axum REST API (25 endpoints, JWT auth)
  alos-engine/         Adaptive learning core (8-step cycle)
  alos-modules/        Curriculum: 24 IELTS + 30 SNBT competencies
  alos-db/             SQLite (13 tables, SQLx migrations)
skills/                Hermes Agent skill definitions
scripts/               Deploy, rebuild, backup scripts
database/              Schema, migrations, backups
```

## Quick Start

```bash
# 1. Build Rust backend
cargo build --release

# 2. Start server
ALOS_SECRET_KEY="your-secret" ./target/release/alos-api

# 3. Build frontend
cd apps/web && npm install && npm run build && npm start

# 4. Open http://localhost:3000
```

Default login: `learner` / `learner123` (configurable via `ALOS_ADMIN_PASSWORD` env).

## API Endpoints

| Group | Endpoints |
|-------|-----------|
| Auth | POST /api/auth/login, POST /api/auth/logout, GET /api/auth/me |
| Dashboard | GET /api/dashboard, GET /api/dashboard/summary |
| Tutor | POST /api/tutor/chat, GET /api/tutor/history, POST /api/tutor/feedback |
| Learning | GET/POST /api/learning/sessions, GET /api/learning/recommendations |
| Competencies | GET /api/competencies, GET/PATCH /api/competencies/{code} |
| IELTS | GET /api/ielts/progress, GET /api/ielts/skills |
| SNBT | GET /api/snbt/progress, GET /api/snbt/subtests |
| Analytics | GET /api/analytics/progress, GET /api/analytics/weaknesses |
| Mistakes | GET/POST /api/mistakes, PATCH /api/mistakes/{id} |
| Schedule | GET/POST /api/schedule, PATCH /api/schedule/{id} |

## Systemd Deployment

```bash
sudo cp scripts/alos-api.service /etc/systemd/system/
sudo systemctl enable --now alos-api
```

## Database

SQLite with WAL mode. Automated daily backups (14-day retention):
```bash
./scripts/backup.sh
```

## License

MIT