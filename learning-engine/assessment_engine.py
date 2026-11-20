"""Assessment engine — evidence typing + provisional band estimation.

Hard rules:
- TTS exercises ≠ authentic IELTS listening evidence.
- Transcript-only speaking ≠ pronunciation assessment.
- Practice bands are ALWAYS provisional; official results only from official reports.
- Formal assessments are periodic (≥7 days apart), never automatic remedial loops.
"""
from __future__ import annotations
from datetime import datetime, timezone

# rough practice-accuracy → provisional band mapping (transparent heuristic,
# explicitly NOT an official IELTS conversion)
def provisional_band(accuracy: float, skill: str) -> tuple[float, float]:
    base = 3.0 + accuracy * 5.0            # 0%→3.0, 100%→8.0
    if skill in ("writing", "speaking"):
        base -= 0.5                        # productive skills lag receptive in practice
    low = max(1.0, round((base - 0.5) * 2) / 2)
    high = min(9.0, round((base + 0.5) * 2) / 2)
    return low, high


def classify_evidence(kind: str, medium: str) -> str:
    if kind == "official":
        return "official"
    if medium == "tts":
        return "tts_exercise"
    if medium == "transcript":
        return "transcript_only"
    if kind == "estimate":
        return "rough_estimate"
    return "authentic_task"


def formal_assessment_allowed(last_formal_iso: str | None, min_days: int = 7) -> bool:
    if not last_formal_iso:
        return True
    try:
        last = datetime.fromisoformat(last_formal_iso.replace("Z", "+00:00"))
    except ValueError:
        return True
    return (datetime.now(timezone.utc) - last).days >= min_days


LIGHT_CHECK_MAX_ITEMS = 2