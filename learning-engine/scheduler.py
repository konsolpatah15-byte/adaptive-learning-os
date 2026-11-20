"""Spaced repetition — adaptive intervals 1→3→7→14→30 days.

Success extends the interval (×~2 along the ladder); partial keeps it;
failure resets to 1 day but DOES NOT trigger a re-test — the orchestrator
routes failures to teaching with a new method first (anti-boredom).
"""
from __future__ import annotations
from datetime import datetime, timedelta, timezone

LADDER = [1.0, 3.0, 7.0, 14.0, 30.0]


def next_interval(current_days: float, result: str, streak: int) -> tuple[float, int]:
    """Return (interval_days, new_streak)."""
    if result == "remembered":
        streak += 1
        try:
            idx = LADDER.index(current_days)
            nxt = LADDER[min(idx + 1, len(LADDER) - 1)]
        except ValueError:
            nxt = min(60.0, current_days * 2)
        if streak >= 4:                        # consistently retrieved → stretch further
            nxt = min(90.0, nxt * 1.5)
        return nxt, streak
    if result == "partial":
        return max(1.0, current_days), streak
    return 1.0, 0                              # forgotten → short interval, teach first


def due_date(interval_days: float, now: datetime | None = None) -> str:
    now = now or datetime.now(timezone.utc)
    return (now + timedelta(days=interval_days)).strftime("%Y-%m-%dT%H:%M:%SZ")


def prioritize(queue: list[dict]) -> list[dict]:
    """Weakest + most overdue first; recently mastered material sinks."""
    def key(item):
        overdue = item.get("overdue_days", 0.0)
        mastery = item.get("mastery", 50.0)
        return (-overdue * (1.0 + (100.0 - mastery) / 100.0))
    return sorted(queue, key=key)