"""Main Learning Orchestrator — owns the full adaptive cycle and all DB writes.

OBSERVE → DIAGNOSE → DECIDE → TEACH → VERIFY → REMEMBER → ADAPT → REPEAT.
Called by the API layer; delegates language generation to the Hermes bridge
but keeps every learning decision deterministic and auditable here.
"""
from __future__ import annotations
import json
import sys
from datetime import datetime, timezone, timedelta
from pathlib import Path
from zoneinfo import ZoneInfo

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "backend"))
sys.path.insert(0, str(ROOT))

from app.core.db import get_db, rows, log_event                      # noqa: E402
from app.core.config import load_config                              # noqa: E402
import importlib.util                                                # noqa: E402


def _load(name: str):
    key = f"alos_engine_{name}"
    if key in sys.modules:
        return sys.modules[key]
    spec = importlib.util.spec_from_file_location(key, ROOT / "learning-engine" / f"{name}.py")
    mod = importlib.util.module_from_spec(spec)
    sys.modules[key] = mod          # register BEFORE exec (dataclasses needs it)
    spec.loader.exec_module(mod)
    return mod


mastery = _load("mastery_engine")
adaptation = _load("adaptation_engine")
teaching = _load("teaching_engine")
assessment = _load("assessment_engine")
sr = _load("scheduler")
recs = _load("recommendation_engine")

TZ = ZoneInfo(load_config("system")["app"]["timezone"])


# ---------- OBSERVE ----------
def observe_answer(user_id: int, competency_code: str, correct: bool, *,
                   difficulty: int = 2, independent: bool = True,
                   kind: str = "light_check", confidence_self: float | None = None,
                   question: str = "", learner_answer: str = "", correct_answer: str = "",
                   diagnosis_hints: dict | None = None) -> dict:
    """Record one observation; run DIAGNOSE→ADAPT immediately."""
    with get_db() as db:
        comp = db.execute("SELECT * FROM competencies WHERE code=?", (competency_code,)).fetchone()
        if comp is None:
            raise ValueError(f"unknown competency {competency_code}")
        comp = dict(comp)
        track = "ielts" if competency_code.startswith("ielts.") else "snbt"
        ev = mastery.Evidence(correct=correct, difficulty=difficulty,
                              independent=independent, kind=kind)
        new_m, n = mastery.update_mastery(comp["mastery"], comp["evidence_count"], ev)
        new_c = mastery.update_confidence(comp["confidence"], confidence_self, ev)
        status = mastery.status_for(new_m, n)
        now = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
        db.execute(
            "UPDATE competencies SET mastery=?, confidence=?, evidence_count=?, status=?,"
            " last_practiced_at=?, updated_at=? WHERE id=?",
            (new_m, new_c, n, status, now, now, comp["id"]))

        result = {"competency": competency_code, "mastery": new_m,
                  "confidence": new_c, "band": mastery.band(new_m), "status": status}

        if not correct:
            hints = diagnosis_hints or {}
            cause = adaptation.diagnose(track, competency_code, **hints)
            db.execute(
                "INSERT INTO mistake_bank (user_id, competency_id, track, question,"
                " learner_answer, correct_answer, root_cause) VALUES (?,?,?,?,?,?,?)",
                (user_id, comp["id"], track, question or "(observasi latihan)",
                 learner_answer, correct_answer, cause))
            tried = _tried_methods(db, comp["id"])
            strategy = adaptation.choose_strategy(cause, tried)
            result.update({"root_cause": cause, "next_strategy": strategy,
                           "policy": "teach_with_new_method_before_any_retest"})
            log_event("orchestrator", "mistake_recorded",
                      f"{competency_code} cause={cause} next={strategy}")
        else:
            # successful retrieval feeds spaced repetition
            interval, streak = sr.next_interval(comp["review_interval_days"],
                                                "remembered", comp["retrieval_streak"])
            due = sr.due_date(interval)
            db.execute(
                "UPDATE competencies SET review_interval_days=?, retrieval_streak=?,"
                " next_review_at=? WHERE id=?", (interval, streak, due, comp["id"]))
            db.execute(
                "INSERT INTO review_queue (user_id, competency_id, due_at, interval_days,"
                " repetitions, last_result, status) VALUES (?,?,?,?,?, 'remembered','pending')",
                (user_id, comp["id"], due, interval, streak))
            result["next_review"] = due
        return result


def _tried_methods(db, competency_id: int) -> list[str]:
    r = db.execute(
        "SELECT DISTINCT method FROM curriculum_topics WHERE competency_id=?",
        (competency_id,)).fetchall()
    return [x["method"] for x in r]


# ---------- DECIDE + TEACH ----------
def next_lesson(user_id: int, competency_code: str | None = None,
                intent_text: str | None = None) -> dict:
    """Pick competency (or honour learner intent), choose method, build lesson."""
    intent = teaching.detect_intent(intent_text) if intent_text else None
    with get_db() as db:
        if competency_code is None:
            comps = rows(db.execute(
                "SELECT c.*, s.track FROM competencies c JOIN subjects s ON s.id=c.subject_id"))
            learner = load_config("learner")
            ielts_date = next((g.get("target_date") for g in learner["goals"]
                               if g["track"] == "ielts"), None)
            active = load_config("system")["tracks"]["snbt"]["active_subtest"]
            ranked = recs.rank_competencies(comps, active, ielts_date)
            comp = ranked[0] if ranked else None
            if comp is None:
                return {"error": "no competencies"}
            competency_code = comp["code"]
        comp = dict(db.execute("SELECT * FROM competencies WHERE code=?",
                               (competency_code,)).fetchone())
        track = "ielts" if competency_code.startswith("ielts.") else "snbt"
        cause = "conceptual" if comp["mastery"] < 41 else "unknown"
        tried = _tried_methods(db, comp["id"])
        strategy = adaptation.choose_strategy(cause, tried)
        topic = db.execute(
            "SELECT * FROM curriculum_topics WHERE competency_id=? AND method=?"
            " ORDER BY sort_order LIMIT 1", (comp["id"], strategy)).fetchone()
        if topic is None:
            topic = db.execute(
                "SELECT * FROM curriculum_topics WHERE competency_id=?"
                " ORDER BY sort_order LIMIT 1", (comp["id"],)).fetchone()
        payload = {
            "competency": competency_code,
            "name_id": comp["name_id"] or comp["name"],
            "mastery": comp["mastery"], "status": comp["status"],
            "strategy": strategy,
            "strategy_label_id": teaching.METHOD_LABELS_ID.get(strategy, strategy),
            "assessment_allowed": True,
        }
        if intent:
            ia = teaching.INTENT_ACTION[intent]
            payload.update({"intent": intent, "action": ia["action"],
                            "assessment_allowed": ia["assessment_allowed"],
                            "note_id": ia["note_id"]})
            if intent == "too_many_tests":
                payload["strategy"] = adaptation.choose_strategy("conceptual", tried + [strategy])
        if topic:
            payload["lesson"] = teaching.build_lesson(dict(topic), payload["strategy"],
                                                      include_check=payload["assessment_allowed"])
        else:
            payload["lesson"] = None
            payload["needs_content"] = True   # Hermes/content pipeline should generate material
        return payload


# ---------- REMEMBER (session lifecycle) ----------
def start_session(user_id: int, track: str, mode: str, competency_code: str | None = None) -> int:
    with get_db() as db:
        cid = None
        if competency_code:
            r = db.execute("SELECT id FROM competencies WHERE code=?", (competency_code,)).fetchone()
            cid = r["id"] if r else None
        cur = db.execute(
            "INSERT INTO learning_sessions (user_id, track, mode, competency_id)"
            " VALUES (?,?,?,?)", (user_id, track, mode, cid))
        return cur.lastrowid


def end_session(session_id: int, summary: str = "", feedback: str | None = None) -> dict:
    with get_db() as db:
        s = db.execute("SELECT * FROM learning_sessions WHERE id=?", (session_id,)).fetchone()
        if s is None:
            raise ValueError("session not found")
        started = datetime.fromisoformat(s["started_at"].replace("Z", "+00:00"))
        minutes = round((datetime.now(timezone.utc) - started).total_seconds() / 60, 1)
        now = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
        db.execute("UPDATE learning_sessions SET ended_at=?, duration_minutes=?, summary=?,"
                   " learner_feedback=? WHERE id=?", (now, minutes, summary, feedback, session_id))
        return {"session_id": session_id, "duration_minutes": minutes}


# ---------- ADAPT (plan generation) ----------
def generate_plan(user_id: int, days: int = 7) -> list[dict]:
    """Daily plans respecting availability, variety rotation, review-first,
    buffer time, and manual overrides. Never fills every available minute."""
    learner = load_config("learner")
    sched_cfg = load_config("schedule")["scheduler"]
    avail = learner["availability"]
    active = load_config("system")["tracks"]["snbt"]["active_subtest"]
    ielts_date = next((g.get("target_date") for g in learner["goals"] if g["track"] == "ielts"), None)
    created: list[dict] = []
    with get_db() as db:
        comps = rows(db.execute(
            "SELECT c.*, s.track FROM competencies c JOIN subjects s ON s.id=c.subject_id"))
        today = datetime.now(TZ).date()
        for d in range(days):
            day = today + timedelta(days=d)
            iso = day.isoformat()
            weekend = day.weekday() >= 5
            minutes = avail["weekend_minutes"] if weekend else avail["weekday_minutes"]
            budget = int(minutes * (1 - avail["buffer_ratio"]))
            existing = db.execute(
                "SELECT COUNT(*) n FROM study_schedule WHERE user_id=? AND plan_date=?"
                " AND status='planned'", (user_id, iso)).fetchone()["n"]
            if existing:
                continue                                   # don't overwrite existing plans
            due = rows(db.execute(
                "SELECT q.*, c.code, c.name_id, c.mastery FROM review_queue q"
                " JOIN competencies c ON c.id=q.competency_id"
                " WHERE q.user_id=? AND q.status='pending' AND date(q.due_at)<=date(?)"
                " ORDER BY q.due_at LIMIT 3", (user_id, iso)))
            plan = recs.daily_recommendations(comps, due, budget, active, ielts_date)
            start_h, start_m = map(int, avail["weekday_window"][0].split(":"))
            t = start_h * 60 + start_m
            rotation = sched_cfg["variety_rotation"]
            idx = d % len(rotation)
            for item in plan["plan"]:
                act = item["activity"]
                if act not in ("review", "assessment"):
                    act = rotation[idx % len(rotation)]
                    idx += 1
                cid = None
                if item.get("competency"):
                    r = db.execute("SELECT id FROM competencies WHERE code=?",
                                   (item["competency"],)).fetchone()
                    cid = r["id"] if r else None
                track = item.get("track") or ("review" if act == "review" else
                                              ("snbt" if str(item.get("competency", "")).startswith("snbt") else "ielts"))
                title = item.get("title") or "Review ringan (bukan tes)"
                hh, mm = divmod(t, 60)
                row = {"plan_date": iso, "start_time": f"{hh:02d}:{mm:02d}",
                       "minutes": item["minutes"], "track": track, "activity": act,
                       "competency_id": cid, "title": title}
                db.execute(
                    "INSERT INTO study_schedule (user_id, plan_date, start_time, minutes,"
                    " track, activity, competency_id, title) VALUES (?,?,?,?,?,?,?,?)",
                    (user_id, iso, row["start_time"], row["minutes"], track, act, cid, title))
                created.append(row)
                t += item["minutes"] + sched_cfg["break_between_blocks_minutes"]
    log_event("orchestrator", "plan_generated", f"{len(created)} blocks over {days} days")
    return created