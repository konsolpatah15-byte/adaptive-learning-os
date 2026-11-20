"""Competencies, IELTS/SNBT progress, analytics, mistakes, schedule, settings."""
from datetime import datetime, timedelta
from fastapi import APIRouter, Depends, HTTPException

from ..core.db import get_db, rows, log_event
from ..core.security import current_user
from ..core.config import load_config, CONFIG_DIR
from ..schemas.api import (CompetencyPatch, MistakeIn, MistakePatch,
                           ScheduleIn, SchedulePatch, PreferencesIn)
from ..services.engine_loader import orchestrator

router = APIRouter(tags=["data"])


# ---- Competencies ----
@router.get("/api/competencies")
def competencies(track: str | None = None, user: dict = Depends(current_user)):
    q = ("SELECT c.*, s.code AS subject_code, s.track FROM competencies c"
         " JOIN subjects s ON s.id=c.subject_id")
    args: tuple = ()
    if track:
        q += " WHERE s.track=?"
        args = (track,)
    q += " ORDER BY s.sort_order, c.id"
    with get_db() as db:
        return {"competencies": rows(db.execute(q, args))}


@router.get("/api/competencies/{comp_id}")
def competency(comp_id: int, user: dict = Depends(current_user)):
    with get_db() as db:
        c = db.execute("SELECT * FROM competencies WHERE id=?", (comp_id,)).fetchone()
        if c is None:
            raise HTTPException(404, "Not found")
        topics = rows(db.execute("SELECT id,title,method,difficulty FROM curriculum_topics"
                                 " WHERE competency_id=? ORDER BY sort_order", (comp_id,)))
        mistakes = rows(db.execute("SELECT id,question,root_cause,resolved FROM mistake_bank"
                                   " WHERE competency_id=? ORDER BY id DESC LIMIT 20", (comp_id,)))
    return {**dict(c), "topics": topics, "mistakes": mistakes}


@router.patch("/api/competencies/{comp_id}")
def patch_competency(comp_id: int, body: CompetencyPatch, user: dict = Depends(current_user)):
    fields = {k: v for k, v in body.model_dump().items() if v is not None}
    if not fields:
        raise HTTPException(400, "Nothing to update")
    sets = ", ".join(f"{k}=?" for k in fields)
    with get_db() as db:
        cur = db.execute(f"UPDATE competencies SET {sets}, updated_at=strftime('%Y-%m-%dT%H:%M:%fZ','now')"
                         f" WHERE id=?", (*fields.values(), comp_id))
        if cur.rowcount == 0:
            raise HTTPException(404, "Not found")
    return {"ok": True}


# ---- IELTS / SNBT progress ----
def _track_progress(track: str) -> dict:
    with get_db() as db:
        subjects = rows(db.execute("SELECT * FROM subjects WHERE track=? ORDER BY sort_order", (track,)))
        out = []
        for s in subjects:
            comps = rows(db.execute("SELECT * FROM competencies WHERE subject_id=?", (s["id"],)))
            assessed = [c for c in comps if c["evidence_count"] > 0]
            avg = round(sum(c["mastery"] for c in assessed) / len(assessed), 1) if assessed else None
            out.append({"subject": s, "competencies": comps,
                        "average_mastery": avg, "assessed_count": len(assessed)})
        estimates = rows(db.execute(
            "SELECT a.*, c.code AS competency_code FROM assessment_results a"
            " LEFT JOIN competencies c ON c.id=a.competency_id"
            " WHERE a.track=? AND (a.band_estimate_low IS NOT NULL)"
            " ORDER BY a.taken_at DESC LIMIT 10", (track,)))
    return {"subjects": out, "band_estimates_provisional": estimates,
            "disclaimer": ("Semua estimasi band bersifat PROVISIONAL dari latihan — "
                           "bukan hasil IELTS resmi. Listening TTS ≠ bukti autentik; "
                           "pelafalan belum dinilai (butuh audio).") if track == "ielts" else
                           ("Jadwal & format resmi SNBT 2027 menunggu pengumuman SNPMB "
                            "(snpmb.bppp.kemdikbud.go.id). Struktur 7 subtes mengacu format UTBK terkini.")}


@router.get("/api/ielts/progress")
def ielts_progress(user: dict = Depends(current_user)):
    return _track_progress("ielts")


@router.get("/api/ielts/skills")
def ielts_skills(user: dict = Depends(current_user)):
    p = _track_progress("ielts")
    return {"skills": [{"code": s["subject"]["code"], "name": s["subject"]["name"],
                        "average_mastery": s["average_mastery"]} for s in p["subjects"]]}


@router.get("/api/snbt/progress")
def snbt_progress(user: dict = Depends(current_user)):
    return _track_progress("snbt")


@router.get("/api/snbt/subtests")
def snbt_subtests(user: dict = Depends(current_user)):
    p = _track_progress("snbt")
    active = load_config("system")["tracks"]["snbt"]["active_subtest"]
    return {"subtests": [{"code": s["subject"]["code"], "name": s["subject"]["name"],
                          "average_mastery": s["average_mastery"],
                          "active": s["subject"]["code"] == active} for s in p["subjects"]],
            "official_info": {
                "status": "pending_official_2027_announcement",
                "source": "https://snpmb.bppp.kemdikbud.go.id/jadwal-penting",
                "note": ("Situs resmi SNPMB per Nov 2026 masih memuat jadwal 2025; jadwal 2027 belum diumumkan. "
                         "Estimasi pihak ketiga (registrasi Jan–Apr, UTBK Apr–Mei 2027) ditandai TENTATIF."),
                "format_reference": {
                    "subtests": [
                        {"code": "pu", "items": 30, "minutes": 30},
                        {"code": "ppu", "items": 20, "minutes": 15},
                        {"code": "pbm", "items": 20, "minutes": 25},
                        {"code": "pk", "items": 20, "minutes": 20},
                        {"code": "lbi", "items": 30, "minutes": 42.5},
                        {"code": "lbe", "items": 20, "minutes": 20},
                        {"code": "pm", "items": 20, "minutes": 42.5}],
                    "total_items": 160, "total_minutes": 195,
                    "scoring": "IRT (Item Response Theory)",
                    "status": "berdasarkan format UTBK terkini; verifikasi ulang saat pengumuman resmi 2027"}}}


# ---- Analytics ----
@router.get("/api/analytics/progress")
def analytics_progress(user: dict = Depends(current_user)):
    with get_db() as db:
        by_subject = rows(db.execute(
            "SELECT s.code, s.track, AVG(c.mastery) avg_mastery, COUNT(c.id) n"
            " FROM subjects s JOIN competencies c ON c.subject_id=s.id"
            " WHERE c.evidence_count>0 GROUP BY s.id ORDER BY s.track, s.sort_order"))
        sessions = rows(db.execute(
            "SELECT date(started_at) d, SUM(duration_minutes) minutes, COUNT(*) n"
            " FROM learning_sessions WHERE user_id=? GROUP BY d ORDER BY d DESC LIMIT 30",
            (user["id"],)))
        bands = rows(db.execute(
            "SELECT status, COUNT(*) n FROM competencies GROUP BY status"))
        retention = db.execute(
            "SELECT last_result, COUNT(*) n FROM review_queue WHERE user_id=? AND last_result IS NOT NULL"
            " GROUP BY last_result", (user["id"],)).fetchall()
    return {"mastery_by_subject": by_subject, "study_consistency": sessions,
            "mastery_bands": bands, "retention": [dict(r) for r in retention]}


@router.get("/api/analytics/weaknesses")
def analytics_weaknesses(user: dict = Depends(current_user)):
    with get_db() as db:
        weak = rows(db.execute(
            "SELECT code, name_id, mastery, confidence, evidence_count FROM competencies"
            " WHERE status IN ('weak','beginning','new') AND evidence_count>0"
            " ORDER BY mastery ASC LIMIT 15"))
        causes = rows(db.execute(
            "SELECT root_cause, COUNT(*) n FROM mistake_bank WHERE user_id=? AND resolved=0"
            " GROUP BY root_cause ORDER BY n DESC", (user["id"],)))
    return {"weakest": weak, "error_patterns": causes}


# ---- Mistakes ----
@router.get("/api/mistakes")
def list_mistakes(resolved: bool | None = None, user: dict = Depends(current_user)):
    q = ("SELECT m.*, c.code AS competency_code FROM mistake_bank m"
         " LEFT JOIN competencies c ON c.id=m.competency_id WHERE m.user_id=?")
    args: list = [user["id"]]
    if resolved is not None:
        q += " AND m.resolved=?"
        args.append(int(resolved))
    q += " ORDER BY m.id DESC LIMIT 100"
    with get_db() as db:
        return {"mistakes": rows(db.execute(q, tuple(args)))}


@router.post("/api/mistakes")
def add_mistake(body: MistakeIn, user: dict = Depends(current_user)):
    if body.track not in ("ielts", "snbt"):
        raise HTTPException(400, "track must be ielts|snbt")
    with get_db() as db:
        cid = None
        if body.competency_code:
            r = db.execute("SELECT id FROM competencies WHERE code=?", (body.competency_code,)).fetchone()
            cid = r["id"] if r else None
        cur = db.execute(
            "INSERT INTO mistake_bank (user_id, competency_id, track, question, learner_answer,"
            " correct_answer, root_cause, explanation) VALUES (?,?,?,?,?,?,?,?)",
            (user["id"], cid, body.track, body.question, body.learner_answer,
             body.correct_answer, body.root_cause, body.explanation))
    return {"id": cur.lastrowid}


@router.patch("/api/mistakes/{mid}")
def patch_mistake(mid: int, body: MistakePatch, user: dict = Depends(current_user)):
    fields = {k: v for k, v in body.model_dump().items() if v is not None}
    if "resolved" in fields:
        fields["resolved"] = int(fields["resolved"])
        if fields["resolved"]:
            fields["resolved_at"] = datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")
    if not fields:
        raise HTTPException(400, "Nothing to update")
    sets = ", ".join(f"{k}=?" for k in fields)
    with get_db() as db:
        cur = db.execute(f"UPDATE mistake_bank SET {sets},"
                         " updated_at=strftime('%Y-%m-%dT%H:%M:%fZ','now')"
                         " WHERE id=? AND user_id=?", (*fields.values(), mid, user["id"]))
        if cur.rowcount == 0:
            raise HTTPException(404, "Not found")
    return {"ok": True}


# ---- Schedule ----
@router.get("/api/schedule")
def get_schedule(days: int = 7, user: dict = Depends(current_user)):
    days = max(1, min(days, 30))
    start = datetime.utcnow().strftime("%Y-%m-%d")
    end = (datetime.utcnow() + timedelta(days=days)).strftime("%Y-%m-%d")
    with get_db() as db:
        items = rows(db.execute(
            "SELECT s.*, c.code AS competency_code FROM study_schedule s"
            " LEFT JOIN competencies c ON c.id=s.competency_id"
            " WHERE s.user_id=? AND s.plan_date BETWEEN ? AND ?"
            " ORDER BY s.plan_date, s.start_time", (user["id"], start, end)))
        reviews = rows(db.execute(
            "SELECT q.*, c.code, c.name_id FROM review_queue q"
            " JOIN competencies c ON c.id=q.competency_id"
            " WHERE q.user_id=? AND q.status='pending' ORDER BY q.due_at LIMIT 20", (user["id"],)))
    return {"schedule": items, "review_queue": reviews}


@router.post("/api/schedule")
def add_schedule(body: ScheduleIn, user: dict = Depends(current_user)):
    if body.track not in ("ielts", "snbt", "review", "break"):
        raise HTTPException(400, "invalid track")
    with get_db() as db:
        cid = None
        if body.competency_code:
            r = db.execute("SELECT id FROM competencies WHERE code=?", (body.competency_code,)).fetchone()
            cid = r["id"] if r else None
        cur = db.execute(
            "INSERT INTO study_schedule (user_id, plan_date, start_time, minutes, track,"
            " activity, competency_id, title, manual_override) VALUES (?,?,?,?,?,?,?,?,1)",
            (user["id"], body.plan_date, body.start_time, body.minutes, body.track,
             body.activity, cid, body.title))
    return {"id": cur.lastrowid}


@router.post("/api/schedule/generate")
def generate_schedule(days: int = 7, user: dict = Depends(current_user)):
    return {"created": orchestrator().generate_plan(user["id"], max(1, min(days, 14)))}


@router.patch("/api/schedule/{sid}")
def patch_schedule(sid: int, body: SchedulePatch, user: dict = Depends(current_user)):
    fields = {k: v for k, v in body.model_dump().items() if v is not None}
    if not fields:
        raise HTTPException(400, "Nothing to update")
    fields["manual_override"] = 1
    sets = ", ".join(f"{k}=?" for k in fields)
    with get_db() as db:
        cur = db.execute(f"UPDATE study_schedule SET {sets} WHERE id=? AND user_id=?",
                         (*fields.values(), sid, user["id"]))
        if cur.rowcount == 0:
            raise HTTPException(404, "Not found")
    return {"ok": True}


# ---- Settings / preferences / export ----
@router.get("/api/settings")
def get_settings(user: dict = Depends(current_user)):
    with get_db() as db:
        row = db.execute("SELECT data_json FROM learning_preferences WHERE user_id=?",
                         (user["id"],)).fetchone()
    import json
    stored = json.loads(row["data_json"]) if row else {}
    learner = load_config("learner")
    return {"preferences": stored or learner["preferences"],
            "availability": learner["availability"], "goals": learner["goals"]}


@router.put("/api/settings")
def put_settings(body: PreferencesIn, user: dict = Depends(current_user)):
    import json
    with get_db() as db:
        db.execute(
            "INSERT INTO learning_preferences (user_id, data_json) VALUES (?,?)"
            " ON CONFLICT(user_id) DO UPDATE SET data_json=excluded.data_json,"
            " updated_at=strftime('%Y-%m-%dT%H:%M:%fZ','now')",
            (user["id"], json.dumps(body.model_dump(), ensure_ascii=False)))
        if body.ielts_target_date:
            db.execute("UPDATE goals SET target_date=?, date_is_tentative=1,"
                       " updated_at=strftime('%Y-%m-%dT%H:%M:%fZ','now')"
                       " WHERE user_id=? AND track='ielts'", (body.ielts_target_date, user["id"]))
    log_event("settings", "preferences_updated", f"user={user['username']}")
    return {"ok": True, "note": "Perubahan subtest aktif disimpan sebagai preferensi; engine membaca config saat restart/reload."}


@router.get("/api/settings/export")
def export_history(user: dict = Depends(current_user)):
    """Full learner-owned export (no credentials, no other users)."""
    uid = user["id"]
    tables = ["goals", "learning_sessions", "assessment_results", "mistake_bank",
              "study_schedule", "review_queue", "tutor_messages", "learning_preferences"]
    out: dict = {"exported_at": datetime.utcnow().isoformat() + "Z", "user": user["username"]}
    with get_db() as db:
        for t in tables:
            out[t] = rows(db.execute(f"SELECT * FROM {t} WHERE user_id=?", (uid,)))
        out["competencies"] = rows(db.execute("SELECT * FROM competencies"))
    return out