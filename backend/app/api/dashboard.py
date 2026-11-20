"""Dashboard aggregate endpoints — one round-trip for the overview page."""
from datetime import datetime, timedelta
from fastapi import APIRouter, Depends

from ..core.db import get_db, rows
from ..core.security import current_user
from ..core.config import load_config

router = APIRouter(prefix="/api/dashboard", tags=["dashboard"])


@router.get("")
def dashboard(user: dict = Depends(current_user)):
    uid = user["id"]
    learner = load_config("learner")
    with get_db() as db:
        goals = rows(db.execute("SELECT * FROM goals WHERE user_id=? AND status='active'", (uid,)))
        today = datetime.utcnow().strftime("%Y-%m-%d")
        plan = rows(db.execute(
            "SELECT s.*, c.code AS competency_code FROM study_schedule s"
            " LEFT JOIN competencies c ON c.id=s.competency_id"
            " WHERE s.user_id=? AND s.plan_date=? ORDER BY s.start_time", (uid, today)))
        week_ago = (datetime.utcnow() - timedelta(days=7)).strftime("%Y-%m-%dT%H:%M:%SZ")
        weekly = db.execute(
            "SELECT COALESCE(SUM(duration_minutes),0) m, COUNT(*) n FROM learning_sessions"
            " WHERE user_id=? AND started_at>=?", (uid, week_ago)).fetchone()
        recent = rows(db.execute(
            "SELECT id, track, mode, started_at, duration_minutes, summary"
            " FROM learning_sessions WHERE user_id=? ORDER BY id DESC LIMIT 5", (uid,)))
        weakest = rows(db.execute(
            "SELECT code, name, name_id, mastery, confidence, status FROM competencies"
            " WHERE evidence_count>0 ORDER BY mastery ASC LIMIT 6"))
        reviews = rows(db.execute(
            "SELECT q.id, q.due_at, c.code, c.name_id FROM review_queue q"
            " JOIN competencies c ON c.id=q.competency_id"
            " WHERE q.user_id=? AND q.status='pending' ORDER BY q.due_at LIMIT 8", (uid,)))
        avg = db.execute("SELECT AVG(mastery) a FROM competencies WHERE evidence_count>0").fetchone()["a"] or 0
        unresolved = db.execute(
            "SELECT COUNT(*) n FROM mistake_bank WHERE user_id=? AND resolved=0", (uid,)).fetchone()["n"]
    return {
        "overall_mastery": round(avg, 1),
        "goals": goals, "today_plan": plan,
        "weekly_study": {"minutes": round(weekly["m"], 1), "sessions": weekly["n"]},
        "recent_sessions": recent, "weakest_competencies": weakest,
        "upcoming_reviews": reviews, "unresolved_mistakes": unresolved,
        "recommendation": ("Mulai dari review ringan, lalu penjelasan topik terlemah — "
                           "bukan tes. Fokus SNBT aktif: PU."),
        "learner": {"display_name": user["display_name"],
                    "preferences": learner["preferences"]},
    }


@router.get("/summary")
def summary(user: dict = Depends(current_user)):
    with get_db() as db:
        n = db.execute("SELECT COUNT(*) n, AVG(mastery) a FROM competencies WHERE evidence_count>0").fetchone()
        sessions = db.execute("SELECT COUNT(*) n FROM learning_sessions WHERE user_id=?",
                              (user["id"],)).fetchone()["n"]
    return {"competencies_tracked": n["n"], "average_mastery": round(n["a"] or 0, 1),
            "total_sessions": sessions}