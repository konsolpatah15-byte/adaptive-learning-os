"""One-time repair: restore baseline evidence rows deleted by the old bootstrap.

Safety: takes a fresh backup first (done separately), only INSERTs into empty
tables, never deletes or updates existing learner data. Idempotent: skips if
assessment_results already has rows.
"""
import re
import sqlite3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
db = sqlite3.connect(ROOT / "database" / "alos.db")
db.execute("PRAGMA foreign_keys=ON")

n = db.execute("SELECT COUNT(*) FROM assessment_results").fetchone()[0]
if n > 0:
    print(f"assessment_results already has {n} rows — nothing to do")
    raise SystemExit(0)

sql = (ROOT / "crates" / "alos-db" / "migrations" / "20261120000003_baseline_seed.sql").read_text()
# user row already exists with a real hash — skip the placeholder insert
sql = re.sub(r"INSERT OR IGNORE INTO users[^;]+;", "", sql, flags=re.S)
db.executescript(sql)
db.commit()

print("assessments:", db.execute("SELECT COUNT(*) FROM assessment_results").fetchone()[0])
print("mistakes:", db.execute("SELECT COUNT(*) FROM mistake_bank").fetchone()[0])
print("weak comps:", db.execute("SELECT COUNT(*) FROM competencies WHERE status='weak'").fetchone()[0])
print("tts confidence:", db.execute("SELECT confidence FROM competencies WHERE code='ielts.list.detail'").fetchone()[0])
print("pronunciation (must be 0,0):", db.execute("SELECT mastery, evidence_count FROM competencies WHERE code='ielts.speak.pronunciation'").fetchone())
db.close()