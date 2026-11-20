"""SQLite access layer — WAL, foreign keys, safe transactions, migrations, backups.

Memory discipline: one connection per request via context manager, row factory
only where needed, no ORM (raw SQL keeps RSS ~tens of MB, Rust-like footprint).
"""
from __future__ import annotations
import sqlite3
import shutil
import threading
import time
from contextlib import contextmanager
from datetime import datetime, timezone
from pathlib import Path

from .config import db_path, system, ROOT

MIGRATIONS_DIR = ROOT / "database" / "migrations"
_local = threading.local()


def _connect() -> sqlite3.Connection:
    cfg = system()["database"]
    conn = sqlite3.connect(db_path(), timeout=cfg["busy_timeout_ms"] / 1000)
    conn.execute("PRAGMA foreign_keys = ON")
    conn.execute(f"PRAGMA busy_timeout = {cfg['busy_timeout_ms']}")
    if cfg.get("wal", True):
        conn.execute("PRAGMA journal_mode = WAL")
    conn.execute("PRAGMA synchronous = NORMAL")
    conn.row_factory = sqlite3.Row
    return conn


@contextmanager
def get_db(reentrant: bool = True):
    """Transactional scope. Reentrant: nested calls on the same thread share
    one connection/transaction (avoids SQLite self-deadlock)."""
    existing = getattr(_local, "conn", None)
    if reentrant and existing is not None:
        yield existing
        return
    conn = _connect()
    if reentrant:
        _local.conn = conn
    try:
        yield conn
        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        if reentrant:
            _local.conn = None
        conn.close()


def rows(cursor) -> list[dict]:
    return [dict(r) for r in cursor.fetchall()]


def migrate() -> list[int]:
    """Apply pending numbered .sql migrations exactly once each.

    Data-seed migrations (version >= 3) reference user id 1, so the bootstrap
    user is created after schema migrations (001–002) and before seeds.
    """
    from pathlib import Path as _P
    applied: list[int] = []
    files = sorted(MIGRATIONS_DIR.glob("*.sql"))
    schema_files = [p for p in files if int(p.name.split("_", 1)[0]) < 3]
    seed_files = [p for p in files if int(p.name.split("_", 1)[0]) >= 3]

    def _apply(db, path):
        version = int(path.name.split("_", 1)[0])
        done = {r["version"] for r in db.execute("SELECT version FROM schema_migrations")}
        if version in done:
            return False
        # executescript() implicitly COMMITs first, so run it outside any txn,
        # then record the version atomically right after.
        db.commit()
        db.executescript(path.read_text(encoding="utf-8"))
        db.execute("INSERT INTO schema_migrations (version, name) VALUES (?, ?)",
                   (version, path.name))
        db.commit()
        return True

    with get_db() as db:
        db.execute(
            "CREATE TABLE IF NOT EXISTS schema_migrations ("
            "version INTEGER PRIMARY KEY, name TEXT NOT NULL, "
            "applied_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')))"
        )
        for path in schema_files:
            if _apply(db, path):
                applied.append(int(path.name.split("_", 1)[0]))

    # ensure learner exists before FK-dependent seeds
    from app.main import bootstrap_user  # local import avoids cycle at module load
    bootstrap_user()

    with get_db() as db:
        for path in seed_files:
            if _apply(db, path):
                applied.append(int(path.name.split("_", 1)[0]))
    return applied


def backup() -> Path | None:
    """Consistent snapshot via SQLite backup API; rolling retention."""
    cfg = system()["database"]
    bdir = ROOT / cfg["backup_dir"]
    bdir.mkdir(parents=True, exist_ok=True)
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    dest = bdir / f"alos-{stamp}.db"
    src = _connect()
    try:
        dst = sqlite3.connect(dest)
        try:
            src.backup(dst)
        finally:
            dst.close()
    finally:
        src.close()
    keep = int(cfg.get("backup_keep", 14))
    old = sorted(bdir.glob("alos-*.db"))
    for p in old[:-keep]:
        p.unlink(missing_ok=True)
    return dest


def log_event(source: str, event: str, detail: str = "", level: str = "info") -> None:
    with get_db() as db:
        db.execute(
            "INSERT INTO system_events (level, source, event, detail) VALUES (?,?,?,?)",
            (level, source, event, detail[:2000]),
        )