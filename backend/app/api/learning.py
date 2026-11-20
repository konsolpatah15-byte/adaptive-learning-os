"""Tutor chat + learning sessions + observations + recommendations."""
from fastapi import APIRouter, Depends, HTTPException

from ..core.db import get_db, rows
from ..core.security import current_user, rate_limit
from ..schemas.api import (ChatIn, FeedbackIn, SessionIn, SessionEndIn, ObservationIn)
from ..integrations.hermes_bridge import chat as hermes_chat
from ..services.engine_loader import orchestrator

router = APIRouter(tags=["learning"])


@router.post("/api/tutor/chat", dependencies=[Depends(rate_limit)])
def tutor_chat(body: ChatIn, user: dict = Depends(current_user)):
    orch = orchestrator()
    intent = None
    try:
        te = __import__("sys").modules.get("alos_engine_teaching_engine")
        if te:
            intent = te.detect_intent(body.message)
    except Exception:
        pass
    result = hermes_chat(user["id"], body.message, body.mode)
    result["intent_detected"] = intent
    return result


@router.get("/api/tutor/history")
def tutor_history(limit: int = 50, user: dict = Depends(current_user)):
    limit = max(1, min(limit, 200))
    with get_db() as db:
        msgs = rows(db.execute(
            "SELECT id, role, content, mode, created_at FROM tutor_messages"
            " WHERE user_id=? ORDER BY id DESC LIMIT ?", (user["id"], limit)))
    return {"messages": list(reversed(msgs))}


@router.post("/api/tutor/feedback")
def tutor_feedback(body: FeedbackIn, user: dict = Depends(current_user)):
    with get_db() as db:
        if body.session_id:
            db.execute("UPDATE learning_sessions SET learner_feedback=? WHERE id=? AND user_id=?",
                       (body.feedback, body.session_id, user["id"]))
        from ..core.db import log_event
        log_event("tutor", "learner_feedback", body.feedback)
    return {"ok": True}


@router.get("/api/learning/sessions")
def list_sessions(limit: int = 30, user: dict = Depends(current_user)):
    limit = max(1, min(limit, 100))
    with get_db() as db:
        return {"sessions": rows(db.execute(
            "SELECT s.*, c.code AS competency_code FROM learning_sessions s"
            " LEFT JOIN competencies c ON c.id=s.competency_id"
            " WHERE s.user_id=? ORDER BY s.id DESC LIMIT ?", (user["id"], limit)))}


@router.post("/api/learning/sessions")
def create_session(body: SessionIn, user: dict = Depends(current_user)):
    sid = orchestrator().start_session(user["id"], body.track, body.mode, body.competency_code)
    return {"session_id": sid}


@router.post("/api/learning/sessions/{session_id}/end")
def finish_session(session_id: int, body: SessionEndIn, user: dict = Depends(current_user)):
    with get_db() as db:
        own = db.execute("SELECT id FROM learning_sessions WHERE id=? AND user_id=?",
                         (session_id, user["id"])).fetchone()
    if own is None:
        raise HTTPException(404, "Session not found")
    return orchestrator().end_session(session_id, body.summary, body.feedback)


@router.post("/api/learning/observe")
def observe(body: ObservationIn, user: dict = Depends(current_user)):
    try:
        return orchestrator().observe_answer(
            user["id"], body.competency_code, body.correct,
            difficulty=body.difficulty, independent=body.independent, kind=body.kind,
            confidence_self=body.confidence_self, question=body.question,
            learner_answer=body.learner_answer, correct_answer=body.correct_answer,
            diagnosis_hints=body.diagnosis_hints)
    except ValueError as e:
        raise HTTPException(404, str(e))


@router.get("/api/learning/recommendations")
def recommendations(user: dict = Depends(current_user)):
    from ..core.config import load_config
    learner = load_config("learner")
    avail = learner["availability"]
    from datetime import datetime
    weekend = datetime.utcnow().weekday() >= 5
    minutes = avail["weekend_minutes"] if weekend else avail["weekday_minutes"]
    with get_db() as db:
        comps = rows(db.execute(
            "SELECT c.*, s.track FROM competencies c JOIN subjects s ON s.id=c.subject_id"))
        due = rows(db.execute(
            "SELECT q.id, c.code, c.name_id, c.mastery FROM review_queue q"
            " JOIN competencies c ON c.id=q.competency_id"
            " WHERE q.user_id=? AND q.status='pending' AND q.due_at<=strftime('%Y-%m-%dT%H:%M:%SZ','now')"
            " LIMIT 5", (user["id"],)))
    recs_mod = orchestrator().recs
    active = load_config("system")["tracks"]["snbt"]["active_subtest"]
    ielts_date = next((g.get("target_date") for g in learner["goals"] if g["track"] == "ielts"), None)
    return recs_mod.daily_recommendations(comps, due, minutes, active, ielts_date)


@router.get("/api/learning/next-lesson")
def next_lesson(competency: str | None = None, say: str | None = None,
                user: dict = Depends(current_user)):
    return orchestrator().next_lesson(user["id"], competency, say)