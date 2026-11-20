"""Recommendation engine — daily priorities from weakness impact + reviews.

Impact = (100 − mastery) × track weight × exam proximity. PU stays the
active SNBT subtest unless the learner/plan explicitly switches (spec §14).
"""
from __future__ import annotations
from datetime import date


def exam_proximity_weight(target_date: str | None, today: date | None = None) -> float:
    if not target_date:
        return 1.0
    today = today or date.today()
    try:
        d = (date.fromisoformat(target_date) - today).days
    except ValueError:
        return 1.0
    if d <= 0:
        return 2.0
    return round(1.0 + max(0.0, (365 - min(d, 365)) / 365), 2)   # 1..2


def rank_competencies(comps: list[dict], active_snbt_subtest: str = "pu",
                      ielts_date: str | None = None, snbt_date: str | None = None) -> list[dict]:
    out = []
    for c in comps:
        code = c["code"]
        track = "ielts" if code.startswith("ielts.") else "snbt"
        if track == "snbt" and not code.startswith(f"snbt.{active_snbt_subtest}."):
            continue                                   # don't push inactive subtests
        w = exam_proximity_weight(ielts_date if track == "ielts" else snbt_date)
        gap = 100.0 - c.get("mastery", 0.0)
        prereq_penalty = 0.5 if c.get("unmet_prereqs") else 1.0
        impact = round(gap * w * prereq_penalty, 1)
        out.append({**c, "track": track, "impact": impact})
    return sorted(out, key=lambda x: -x["impact"])


def daily_recommendations(comps: list[dict], due_reviews: list[dict],
                          minutes_available: int, active_snbt_subtest: str = "pu",
                          ielts_date: str | None = None) -> dict:
    ranked = rank_competencies(comps, active_snbt_subtest, ielts_date)
    blocks = max(1, minutes_available // 30)
    plan: list[dict] = []
    if due_reviews:
        plan.append({"activity": "review", "items": due_reviews[:3],
                     "minutes": min(15, minutes_available // 3)})
    used = sum(p["minutes"] for p in plan)
    per_track_budget = (minutes_available - used) / 2
    for track in ("snbt", "ielts"):
        picks = [c for c in ranked if c["track"] == track][:2]
        for c in picks:
            m = min(25, int(per_track_budget / max(1, len(picks))))
            if m < 10:
                continue
            weak = c.get("mastery", 0) < 41
            plan.append({
                "activity": "explanation" if weak else "guided_practice",
                "competency": c["code"], "title": c.get("name_id") or c["name"],
                "minutes": m, "impact": c["impact"],
                "reason": ("Kelemahan berdampak tinggi — mulai dari penjelasan, bukan tes."
                           if weak else "Latihan terbimbing untuk memperkuat pemahaman."),
            })
    return {"minutes_available": minutes_available, "plan": plan,
            "policy": "teach_before_test; no forced remedial loops"}