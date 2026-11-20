"""ALOS FastAPI application — lean single-worker ASGI app.

Memory discipline: no ORM, no heavy middleware stack, stdlib+uvicorn only.
Target RSS < 100 MB with SQLite WAL.
"""
from __future__ import annotations
import os
from contextlib import asynccontextmanager

from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from .core.config import system, load_config
from .core.db import migrate, backup, log_event, get_db
from .core.security import hash_password
from .api import auth, dashboard, learning, data


def bootstrap_user() -> None:
    """Create the learner account on first run. Password from env or generated
    once and stored in database/.bootstrap_password (chmod 600, gitignored)."""
    with get_db() as db:
        if db.execute("SELECT COUNT(*) n FROM users").fetchone()["n"]:
            return
        pw = os.environ.get("ALOS_BOOTSTRAP_PASSWORD")
        generated = False
        if not pw:
            import secrets
            pw = secrets.token_urlsafe(12)
            generated = True
        learner = load_config("learner")
        cur = db.execute(
            "INSERT INTO users (username, password_hash, display_name, role)"
            " VALUES (?,?,?, 'learner')",
            ("learner", hash_password(pw), learner["learner"]["display_name"]))
        uid = cur.lastrowid
        for g in learner["goals"]:
            band = system()["tracks"]["ielts"]["target_band"] if g["track"] == "ielts" else (None, None)
            db.execute(
                "INSERT INTO goals (user_id, track, title, target_band_low, target_band_high,"
                " target_date, date_is_tentative) VALUES (?,?,?,?,?,?,?)",
                (uid, g["track"], g["title"], band[0], band[1],
                 g.get("target_date"), int(g.get("date_is_tentative", True))))
        import json
        db.execute("INSERT INTO learning_preferences (user_id, data_json) VALUES (?,?)",
                   (uid, json.dumps(learner["preferences"], ensure_ascii=False)))
        if generated:
            from .core.config import ROOT
            pfile = ROOT / "database" / ".bootstrap_password"
            pfile.write_text(pw)
            pfile.chmod(0o600)
        # baseline migration 003 attaches to user id 1 — guaranteed here since
        # this is the first user ever inserted.
        log_event("bootstrap", "user_created", f"username=learner generated_password={generated}")


@asynccontextmanager
async def lifespan(app: FastAPI):
    applied = migrate()
    bootstrap_user()
    backup()
    log_event("app", "startup", f"migrations_applied={applied}")
    yield
    backup()
    log_event("app", "shutdown", "clean exit")


app = FastAPI(title="Adaptive Learning OS API", version="2.0.0", lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=system()["server"]["cors_origins"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)
app.include_router(dashboard.router)
app.include_router(learning.router)
app.include_router(data.router)


@app.exception_handler(ValueError)
async def value_error_handler(request: Request, exc: ValueError):
    return JSONResponse(status_code=400, content={"detail": str(exc)})


@app.get("/api/health")
def health():
    return {"status": "ok", "app": "ALOS", "version": "2.0.0"}