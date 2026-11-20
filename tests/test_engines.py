"""Unit tests for the deterministic learning engines (no DB, no network)."""
import importlib.util
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def load(name):
    key = f"engine_{name}"
    if key in sys.modules:
        return sys.modules[key]
    spec = importlib.util.spec_from_file_location(key, ROOT / "learning-engine" / f"{name}.py")
    mod = importlib.util.module_from_spec(spec)
    sys.modules[key] = mod
    spec.loader.exec_module(mod)
    return mod


mastery = load("mastery_engine")
adapt = load("adaptation_engine")
sr = load("scheduler")
teach = load("teaching_engine")
assess = load("assessment_engine")
recs = load("recommendation_engine")


# ---- mastery ----
def test_single_answer_cannot_master():
    m, n = mastery.update_mastery(30.0, 1, mastery.Evidence(True, 5, True, "formal"))
    assert m - 30.0 <= 12.0 and m < 76


def test_repeated_success_converges_high():
    m, n = 30.0, 0
    for _ in range(15):
        m, n = mastery.update_mastery(m, n, mastery.Evidence(True, 3, True, "practice"))
    assert m > 75


def test_hinted_answers_earn_less():
    a, _ = mastery.update_mastery(50, 5, mastery.Evidence(True, 3, True, "practice"))
    b, _ = mastery.update_mastery(50, 5, mastery.Evidence(True, 3, False, "practice"))
    assert a > b


def test_bands():
    assert mastery.band(10) == "not_understood"
    assert mastery.band(70) == "functional"
    assert mastery.band(95) == "mastered"


# ---- adaptation ----
def test_diagnose_not_all_conceptual():
    assert adapt.diagnose("snbt", "snbt.pu.work_rate", wrong_operation=True) == "calculation"
    assert adapt.diagnose("ielts", "ielts.read.inference", ran_out_of_time=True) == "time_management"
    assert adapt.diagnose("ielts", "ielts.gram.sva") == "grammar"
    assert adapt.diagnose("snbt", "snbt.pu.deduction") == "logical_reasoning"


def test_strategy_rotates_away_from_tried():
    s1 = adapt.choose_strategy("conceptual", [])
    s2 = adapt.choose_strategy("conceptual", [s1])
    assert s1 != s2


def test_difficulty_adapts():
    assert adapt.next_difficulty(2, 0.9) == 3
    assert adapt.next_difficulty(2, 0.3) == 1
    assert adapt.next_difficulty(2, 0.6) == 2


# ---- spaced repetition ----
def test_ladder_progression():
    i, s = sr.next_interval(1.0, "remembered", 0)
    assert i == 3.0 and s == 1
    i, s = sr.next_interval(3.0, "remembered", 1)
    assert i == 7.0
    i, s = sr.next_interval(30.0, "remembered", 3)
    assert i >= 30.0


def test_forgotten_resets_but_short():
    i, s = sr.next_interval(14.0, "forgotten", 3)
    assert i == 1.0 and s == 0


# ---- intents (anti-boredom) ----
def test_intent_detection_id_en():
    assert teach.detect_intent("kebanyakan tes terus") == "too_many_tests"
    assert teach.detect_intent("aku masih bingung di sini") == "weak_here"
    assert teach.detect_intent("I'm weak here, continue") == "weak_here"
    assert teach.detect_intent("jelaskan saja dulu") == "explain_instead"
    assert teach.detect_intent("ganti topik yuk") == "move_on"
    assert teach.detect_intent("what is a syllogism?") is None


def test_weak_intent_blocks_assessment():
    for intent in ("too_many_tests", "weak_here", "explain_instead"):
        assert teach.INTENT_ACTION[intent]["assessment_allowed"] is False


# ---- assessment honesty ----
def test_tts_is_not_authentic():
    assert assess.classify_evidence("practice", "tts") == "tts_exercise"
    assert assess.classify_evidence("practice", "transcript") == "transcript_only"
    assert assess.classify_evidence("official", "audio") == "official"


def test_formal_cadence():
    from datetime import datetime, timezone, timedelta
    recent = (datetime.now(timezone.utc) - timedelta(days=2)).isoformat()
    old = (datetime.now(timezone.utc) - timedelta(days=9)).isoformat()
    assert assess.formal_assessment_allowed(recent) is False
    assert assess.formal_assessment_allowed(old) is True
    assert assess.formal_assessment_allowed(None) is True


def test_provisional_band_bounds():
    lo, hi = assess.provisional_band(0.7, "writing")
    assert 1.0 <= lo < hi <= 9.0


# ---- recommendations ----
def test_inactive_subtests_not_pushed():
    comps = [
        {"code": "snbt.pu.venn", "name": "Venn", "mastery": 30},
        {"code": "snbt.pk.algebra", "name": "Aljabar", "mastery": 10},
        {"code": "ielts.gram.sva", "name": "SVA", "mastery": 30},
    ]
    ranked = recs.rank_competencies(comps, active_snbt_subtest="pu")
    codes = [c["code"] for c in ranked]
    assert "snbt.pk.algebra" not in codes
    assert codes[0].startswith(("snbt.pu", "ielts"))


def test_daily_plan_has_no_exam_by_default():
    comps = [{"code": "snbt.pu.venn", "name": "Venn", "mastery": 30},
             {"code": "ielts.gram.sva", "name": "SVA", "mastery": 30}]
    plan = recs.daily_recommendations(comps, [], 90)
    acts = [p["activity"] for p in plan["plan"]]
    assert "assessment" not in acts
    assert sum(p["minutes"] for p in plan["plan"]) <= 90