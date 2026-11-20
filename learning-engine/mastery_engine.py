"""Mastery engine — evidence-weighted competency scoring (0–100).

Rules (from spec §10):
- Never assign mastery from one answer.
- Blend accuracy, difficulty, recency, repetition, retention, independence.
- Confidence tracked separately from mastery.
Bands: 0-20 not understood · 21-40 beginning · 41-60 developing ·
61-75 functional · 76-90 strong · 91-100 consistent mastery.
"""
from __future__ import annotations
from dataclasses import dataclass

BANDS = [
    (20, "not_understood"), (40, "beginning"), (60, "developing"),
    (75, "functional"), (90, "strong"), (100, "mastered"),
]


def band(mastery: float) -> str:
    for ceiling, name in BANDS:
        if mastery <= ceiling:
            return name
    return "mastered"


@dataclass
class Evidence:
    correct: bool
    difficulty: int = 2          # 1..5
    independent: bool = True     # solved without hints?
    kind: str = "practice"       # light_check | practice | formal | review
    days_ago: float = 0.0


def update_mastery(current: float, evidence_count: int, ev: Evidence) -> tuple[float, int]:
    """EMA-style update with diminishing single-answer impact.

    First few observations move the score gently (max ~12 pts), later
    observations weigh more as evidence accumulates. Harder correct answers
    earn more; hinted answers earn less; formal > practice > light check.
    """
    kind_w = {"formal": 1.0, "practice": 0.8, "review": 0.7, "light_check": 0.5}.get(ev.kind, 0.6)
    diff_w = 0.6 + 0.2 * ev.difficulty                  # 0.8 .. 1.6
    indep_w = 1.0 if ev.independent else 0.55
    nudge_cap = min(12.0, 4.0 + 2.0 * evidence_count)   # never one-answer leaps
    if ev.correct:
        target = min(100.0, current + nudge_cap * kind_w * diff_w * indep_w)
    else:
        drop = nudge_cap * kind_w * (1.4 - 0.12 * ev.difficulty)  # easy mistakes hurt more
        target = max(0.0, current - drop)
    alpha = min(0.5, 0.2 + 0.05 * evidence_count)       # trust grows with evidence
    new = current + alpha * (target - current)
    return round(max(0.0, min(100.0, new)), 1), evidence_count + 1


def update_confidence(current: float, self_reported: float | None, ev: Evidence) -> float:
    """Confidence = learner self-report blended with demonstrated consistency."""
    demonstrated = 70.0 if (ev.correct and ev.independent) else (45.0 if ev.correct else 20.0)
    base = self_reported if self_reported is not None else demonstrated
    return round(max(0.0, min(100.0, 0.6 * current + 0.4 * base)), 1)


def status_for(mastery: float, evidence_count: int) -> str:
    if evidence_count == 0:
        return "new"
    b = band(mastery)
    if b in ("not_understood", "beginning"):
        return "weak"
    return {"developing": "developing", "functional": "functional",
            "strong": "strong", "mastered": "mastered"}[b]