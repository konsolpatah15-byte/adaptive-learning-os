"""End-to-end API tests against a throwaway DB (real HTTP via TestClient)."""
import os
import sys
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "backend"))


@pytest.fixture(scope="module")
def client(tmp_path_factory):
    # isolate DB per test module run
    tmp = tmp_path_factory.mktemp("alosdb")
    import app.core.config as cfg
    cfg.system()["database"]["path"] = str(tmp / "test.db")
    cfg.system()["database"]["backup_dir"] = str(tmp / "backups")
    os.environ["ALOS_BOOTSTRAP_PASSWORD"] = "testpass123"
    from fastapi.testclient import TestClient
    from app.main import app
    with TestClient(app) as c:
        yield c


@pytest.fixture(scope="module")
def token(client):
    r = client.post("/api/auth/login", json={"username": "learner", "password": "testpass123"})
    assert r.status_code == 200, r.text
    return r.json()["access_token"]


def auth(token):
    return {"Authorization": f"Bearer {token}"}


def test_health(client):
    assert client.get("/api/health").json()["status"] == "ok"


def test_login_bad_password(client):
    r = client.post("/api/auth/login", json={"username": "learner", "password": "wrongpw1"})
    assert r.status_code == 401


def test_unauthorized_blocked(client):
    assert client.get("/api/dashboard").status_code == 401


def test_me(client, token):
    r = client.get("/api/auth/me", headers=auth(token))
    assert r.status_code == 200 and r.json()["username"] == "learner"


def test_dashboard_shape(client, token):
    d = client.get("/api/dashboard", headers=auth(token)).json()
    for key in ("overall_mastery", "goals", "today_plan", "weekly_study",
                "weakest_competencies", "upcoming_reviews"):
        assert key in d
    assert len(d["goals"]) == 2


def test_baseline_imported_with_evidence_tags(client, token):
    p = client.get("/api/ielts/progress", headers=auth(token)).json()
    est = p["band_estimates_provisional"]
    # TTS listening must NOT be treated as authentic: confidence stays low
    comps = client.get("/api/competencies?track=ielts", headers=auth(token)).json()["competencies"]
    tts = next(c for c in comps if c["code"] == "ielts.list.detail")
    assert tts["confidence"] <= 20
    pron = next(c for c in comps if c["code"] == "ielts.speak.pronunciation")
    assert pron["mastery"] == 0 and pron["evidence_count"] == 0
    assert all(e["is_provisional"] == 1 for e in est)
    assert "PROVISIONAL" in p["disclaimer"]


def test_snbt_official_info_tentative(client, token):
    s = client.get("/api/snbt/subtests", headers=auth(token)).json()
    assert len(s["subtests"]) == 7
    assert s["official_info"]["status"] == "pending_official_2027_announcement"
    pu = next(x for x in s["subtests"] if x["code"] == "pu")
    assert pu["active"] is True


def test_observation_updates_mastery_and_mistake(client, token):
    before = client.get("/api/competencies?track=snbt", headers=auth(token)).json()["competencies"]
    comp = next(c for c in before if c["code"] == "snbt.pu.inverse_proportion")
    r = client.post("/api/learning/observe", headers=auth(token), json={
        "competency_code": "snbt.pu.inverse_proportion", "correct": False,
        "difficulty": 3, "kind": "light_check",
        "question": "6 pekerja 10 hari, 4 pekerja berapa hari?", "learner_answer": "6.7 hari",
        "correct_answer": "15 hari"})
    assert r.status_code == 200
    body = r.json()
    assert body["mastery"] < comp["mastery"]          # wrong answer lowers mastery
    assert body["root_cause"] == "conceptual"
    assert body["next_strategy"] in ("analogy", "visual", "demo", "scenario", "socratic", "direct")
    assert "retest" in body["policy"] or "teach" in body["policy"]
    mistakes = client.get("/api/mistakes?resolved=false", headers=auth(token)).json()["mistakes"]
    assert any(m["question"].startswith("6 pekerja") for m in mistakes)


def test_correct_answer_schedules_review(client, token):
    r = client.post("/api/learning/observe", headers=auth(token), json={
        "competency_code": "snbt.pu.number_patterns", "correct": True,
        "difficulty": 2, "kind": "practice"})
    assert r.status_code == 200 and "next_review" in r.json()


def test_mastery_not_from_single_answer(client, token):
    """One correct answer must not jump a weak competency to mastered."""
    comps = client.get("/api/competencies?track=snbt", headers=auth(token)).json()["competencies"]
    c = next(x for x in comps if x["code"] == "snbt.pu.min_intersection")
    r = client.post("/api/learning/observe", headers=auth(token), json={
        "competency_code": "snbt.pu.min_intersection", "correct": True,
        "difficulty": 4, "kind": "formal"}).json()
    assert r["mastery"] - c["mastery"] <= 12.0
    assert r["mastery"] < 76


def test_intent_weak_here_no_test(client, token):
    r = client.get("/api/learning/next-lesson",
                   params={"say": "aku masih bingung di sini"}, headers=auth(token)).json()
    assert r["intent"] == "weak_here"
    assert r["assessment_allowed"] is False
    assert r["action"] == "guided_learning_new_method"


def test_intent_too_many_tests(client, token):
    r = client.get("/api/learning/next-lesson",
                   params={"say": "kebanyakan tes, bosan soal terus"}, headers=auth(token)).json()
    assert r["intent"] == "too_many_tests"
    assert r["assessment_allowed"] is False


def test_next_lesson_has_content(client, token):
    r = client.get("/api/learning/next-lesson",
                   params={"competency": "snbt.pu.inverse_proportion"}, headers=auth(token)).json()
    assert r["lesson"] is not None
    assert "kolam" in r["lesson"]["content_md"].lower()


def test_session_lifecycle(client, token):
    sid = client.post("/api/learning/sessions", headers=auth(token),
                      json={"track": "snbt", "mode": "explanation",
                            "competency_code": "snbt.pu.venn"}).json()["session_id"]
    r = client.post(f"/api/learning/sessions/{sid}/end", headers=auth(token),
                    json={"summary": "Belajar diagram Venn", "feedback": "helpful"}).json()
    assert r["duration_minutes"] >= 0


def test_schedule_generation_respects_budget(client, token):
    r = client.post("/api/schedule/generate?days=7", headers=auth(token)).json()
    assert len(r["created"]) > 0
    from collections import defaultdict
    per_day = defaultdict(int)
    for item in r["created"]:
        per_day[item["plan_date"]] += item["minutes"]
    for day, minutes in per_day.items():
        assert minutes <= 210          # never exceeds weekend budget; weekdays ≤ 90


def test_manual_schedule_override(client, token):
    r = client.post("/api/schedule", headers=auth(token), json={
        "plan_date": "2026-11-21", "start_time": "16:30", "minutes": 25,
        "track": "snbt", "activity": "discussion", "title": "Diskusi Venn"})
    assert r.status_code == 200
    sid = r.json()["id"]
    assert client.patch(f"/api/schedule/{sid}", headers=auth(token),
                        json={"status": "done"}).status_code == 200


def test_settings_update_and_export(client, token):
    r = client.put("/api/settings", headers=auth(token),
                   json={"weekday_minutes": 75, "active_snbt_subtest": "pu"})
    assert r.status_code == 200
    exp = client.get("/api/settings/export", headers=auth(token)).json()
    assert "assessment_results" in exp and len(exp["assessment_results"]) >= 8
    assert "password_hash" not in str(exp)


def test_validation_rejects_bad_input(client, token):
    r = client.post("/api/learning/observe", headers=auth(token),
                    json={"competency_code": "x", "correct": "yes"})
    assert r.status_code == 422
    r = client.post("/api/tutor/chat", headers=auth(token),
                    json={"message": "hi", "mode": "exam_forever"})
    assert r.status_code == 422


def test_tutor_chat_fallback_honest(client, token, monkeypatch):
    import app.integrations.hermes_bridge as hb
    monkeypatch.setattr(hb, "hermes_available", lambda: False)
    r = client.post("/api/tutor/chat", headers=auth(token),
                    json={"message": "jelaskan perbandingan berbalik nilai", "mode": "explanation"})
    assert r.status_code == 200
    body = r.json()
    assert body["source"] == "engine_fallback"
    assert len(body["reply"]) > 50
    hist = client.get("/api/tutor/history", headers=auth(token)).json()["messages"]
    assert hist[-1]["role"] == "assistant"