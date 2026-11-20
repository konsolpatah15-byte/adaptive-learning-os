-- ALOS 2.0 · migration 001 · core schema (SQLite, WAL, foreign keys ON)
PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS schema_migrations (
  version     INTEGER PRIMARY KEY,
  name        TEXT NOT NULL,
  applied_at  TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);

CREATE TABLE IF NOT EXISTS users (
  id            INTEGER PRIMARY KEY,
  username      TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  display_name  TEXT NOT NULL DEFAULT 'Learner',
  role          TEXT NOT NULL DEFAULT 'learner' CHECK (role IN ('learner','admin')),
  created_at    TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  updated_at    TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);

CREATE TABLE IF NOT EXISTS goals (
  id           INTEGER PRIMARY KEY,
  user_id      INTEGER NOT NULL REFERENCES users(id),
  track        TEXT NOT NULL CHECK (track IN ('ielts','snbt')),
  title        TEXT NOT NULL,
  target_band_low  REAL,
  target_band_high REAL,
  target_date  TEXT,
  date_is_tentative INTEGER NOT NULL DEFAULT 1,
  status       TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active','paused','achieved','archived')),
  created_at   TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  updated_at   TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);

CREATE TABLE IF NOT EXISTS subjects (
  id     INTEGER PRIMARY KEY,
  track  TEXT NOT NULL CHECK (track IN ('ielts','snbt')),
  code   TEXT NOT NULL UNIQUE,          -- listening/reading/... or pu/ppu/pbm/pk/lbi/lbe/pm
  name   TEXT NOT NULL,
  name_id TEXT,                          -- Indonesian display name
  description TEXT,
  sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS competencies (
  id          INTEGER PRIMARY KEY,
  subject_id  INTEGER NOT NULL REFERENCES subjects(id),
  code        TEXT NOT NULL UNIQUE,
  name        TEXT NOT NULL,
  name_id     TEXT,
  description TEXT,
  difficulty  INTEGER NOT NULL DEFAULT 2 CHECK (difficulty BETWEEN 1 AND 5),
  prerequisites TEXT NOT NULL DEFAULT '[]',   -- JSON array of competency codes
  mastery     REAL NOT NULL DEFAULT 0 CHECK (mastery BETWEEN 0 AND 100),
  confidence  REAL NOT NULL DEFAULT 0 CHECK (confidence BETWEEN 0 AND 100), -- tracked separately
  evidence_count INTEGER NOT NULL DEFAULT 0,
  last_practiced_at TEXT,
  next_review_at    TEXT,
  review_interval_days REAL NOT NULL DEFAULT 1,
  retrieval_streak INTEGER NOT NULL DEFAULT 0,
  status      TEXT NOT NULL DEFAULT 'new' CHECK (status IN ('new','learning','weak','developing','functional','strong','mastered')),
  created_at  TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  updated_at  TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE INDEX IF NOT EXISTS idx_comp_subject ON competencies(subject_id);
CREATE INDEX IF NOT EXISTS idx_comp_review ON competencies(next_review_at);

CREATE TABLE IF NOT EXISTS curriculum_topics (
  id            INTEGER PRIMARY KEY,
  competency_id INTEGER NOT NULL REFERENCES competencies(id),
  title         TEXT NOT NULL,
  language      TEXT NOT NULL DEFAULT 'id',
  content_md    TEXT NOT NULL,             -- teaching material (explanations first!)
  method        TEXT NOT NULL DEFAULT 'direct', -- direct|socratic|demo|analogy|scenario|visual|guided|discussion|case|practical
  difficulty    INTEGER NOT NULL DEFAULT 2,
  sort_order    INTEGER NOT NULL DEFAULT 0,
  created_at    TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE INDEX IF NOT EXISTS idx_topic_comp ON curriculum_topics(competency_id);

CREATE TABLE IF NOT EXISTS learning_sessions (
  id          INTEGER PRIMARY KEY,
  user_id     INTEGER NOT NULL REFERENCES users(id),
  track       TEXT NOT NULL CHECK (track IN ('ielts','snbt','mixed')),
  mode        TEXT NOT NULL DEFAULT 'explanation' CHECK (mode IN ('explanation','guided_practice','discussion','simulation','assessment','review')),
  competency_id INTEGER REFERENCES competencies(id),
  started_at  TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  ended_at    TEXT,
  duration_minutes REAL NOT NULL DEFAULT 0,
  summary     TEXT,
  learner_feedback TEXT,               -- e.g. too_many_tests / helpful / confusing
  created_at  TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE INDEX IF NOT EXISTS idx_sess_user_time ON learning_sessions(user_id, started_at);

CREATE TABLE IF NOT EXISTS assessment_results (
  id           INTEGER PRIMARY KEY,
  session_id   INTEGER REFERENCES learning_sessions(id),
  user_id      INTEGER NOT NULL REFERENCES users(id),
  competency_id INTEGER REFERENCES competencies(id),
  track        TEXT NOT NULL CHECK (track IN ('ielts','snbt')),
  kind         TEXT NOT NULL CHECK (kind IN ('light_check','practice','formal','diagnostic_baseline','remedial_historical')),
  evidence_type TEXT NOT NULL DEFAULT 'authentic_task' CHECK (evidence_type IN ('authentic_task','tts_exercise','transcript_only','rough_estimate','historical','official')),
  score_raw    REAL,                   -- e.g. 3 (out of score_max)
  score_max    REAL,                   -- e.g. 5
  band_estimate_low  REAL,             -- provisional IELTS estimates only
  band_estimate_high REAL,
  is_provisional INTEGER NOT NULL DEFAULT 1,
  excluded_items INTEGER NOT NULL DEFAULT 0,  -- e.g. ambiguous question excluded
  notes        TEXT,
  taken_at     TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE INDEX IF NOT EXISTS idx_assess_user ON assessment_results(user_id, taken_at);

CREATE TABLE IF NOT EXISTS mistake_bank (
  id           INTEGER PRIMARY KEY,
  user_id      INTEGER NOT NULL REFERENCES users(id),
  competency_id INTEGER REFERENCES competencies(id),
  track        TEXT NOT NULL CHECK (track IN ('ielts','snbt')),
  question     TEXT NOT NULL,
  learner_answer TEXT,
  correct_answer TEXT,
  root_cause   TEXT NOT NULL DEFAULT 'unknown' CHECK (root_cause IN
    ('conceptual','calculation','misreading','vocabulary','grammar','logical_reasoning','careless','time_management','background_knowledge','unknown')),
  explanation  TEXT,                   -- corrected explanation in preferred language
  resolved     INTEGER NOT NULL DEFAULT 0,
  resolved_at  TEXT,
  occurrences  INTEGER NOT NULL DEFAULT 1,
  created_at   TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  updated_at   TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE INDEX IF NOT EXISTS idx_mistake_user ON mistake_bank(user_id, resolved);

CREATE TABLE IF NOT EXISTS study_schedule (
  id          INTEGER PRIMARY KEY,
  user_id     INTEGER NOT NULL REFERENCES users(id),
  plan_date   TEXT NOT NULL,           -- YYYY-MM-DD (Asia/Jakarta)
  start_time  TEXT NOT NULL,           -- HH:MM local
  minutes     INTEGER NOT NULL,
  track       TEXT NOT NULL CHECK (track IN ('ielts','snbt','review','break')),
  activity    TEXT NOT NULL,           -- explanation|discussion|demonstration|guided_practice|simulation|assessment|review
  competency_id INTEGER REFERENCES competencies(id),
  title       TEXT NOT NULL,
  status      TEXT NOT NULL DEFAULT 'planned' CHECK (status IN ('planned','done','skipped','moved')),
  manual_override INTEGER NOT NULL DEFAULT 0,
  created_at  TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE INDEX IF NOT EXISTS idx_sched_user_date ON study_schedule(user_id, plan_date);

CREATE TABLE IF NOT EXISTS review_queue (
  id           INTEGER PRIMARY KEY,
  user_id      INTEGER NOT NULL REFERENCES users(id),
  competency_id INTEGER NOT NULL REFERENCES competencies(id),
  due_at       TEXT NOT NULL,
  interval_days REAL NOT NULL DEFAULT 1,
  repetitions  INTEGER NOT NULL DEFAULT 0,
  last_result  TEXT CHECK (last_result IN ('remembered','partial','forgotten')),
  status       TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','done','skipped')),
  created_at   TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE INDEX IF NOT EXISTS idx_review_due ON review_queue(user_id, status, due_at);

CREATE TABLE IF NOT EXISTS learning_preferences (
  user_id     INTEGER PRIMARY KEY REFERENCES users(id),
  data_json   TEXT NOT NULL,           -- validated by Pydantic before write
  updated_at  TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);

CREATE TABLE IF NOT EXISTS tutor_messages (
  id          INTEGER PRIMARY KEY,
  user_id     INTEGER NOT NULL REFERENCES users(id),
  session_id  INTEGER REFERENCES learning_sessions(id),
  role        TEXT NOT NULL CHECK (role IN ('user','assistant','system')),
  content     TEXT NOT NULL,
  mode        TEXT,
  created_at  TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE INDEX IF NOT EXISTS idx_msg_user ON tutor_messages(user_id, id);

CREATE TABLE IF NOT EXISTS system_events (
  id         INTEGER PRIMARY KEY,
  level      TEXT NOT NULL DEFAULT 'info' CHECK (level IN ('debug','info','warn','error')),
  source     TEXT NOT NULL,
  event      TEXT NOT NULL,
  detail     TEXT,
  created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);

CREATE TABLE IF NOT EXISTS deployment_history (
  id         INTEGER PRIMARY KEY,
  target     TEXT NOT NULL,            -- github | vercel | vps
  ref        TEXT,                     -- commit sha / deployment url
  status     TEXT NOT NULL,
  detail     TEXT,
  created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);