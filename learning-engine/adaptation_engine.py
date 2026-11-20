"""Adaptation engine — error diagnosis + teaching-strategy selection.

DIAGNOSE: classify root cause (never label everything 'conceptual').
DECIDE: pick a teaching method, rotating away from methods that already
failed for this competency (anti-boredom policy §9).
"""
from __future__ import annotations

ROOT_CAUSES = (
    "conceptual", "calculation", "misreading", "vocabulary", "grammar",
    "logical_reasoning", "careless", "time_management", "background_knowledge",
)

STRATEGIES = (
    "direct", "socratic", "demo", "scenario", "analogy", "visual",
    "guided", "discussion", "case", "practical",
)

# root cause → preferred strategy order (first not-yet-tried wins)
CAUSE_STRATEGIES: dict[str, tuple[str, ...]] = {
    "conceptual":           ("analogy", "visual", "demo", "scenario", "socratic", "direct"),
    "calculation":          ("demo", "guided", "practical", "visual"),
    "misreading":           ("guided", "demo", "discussion"),
    "vocabulary":           ("scenario", "practical", "discussion", "analogy"),
    "grammar":              ("demo", "guided", "practical", "direct"),
    "logical_reasoning":    ("socratic", "case", "visual", "discussion"),
    "careless":             ("guided", "practical", "discussion"),
    "time_management":      ("practical", "demo", "guided"),
    "background_knowledge": ("direct", "scenario", "case", "discussion"),
    "unknown":              ("discussion", "socratic", "demo", "analogy"),
}

# heuristics for auto-diagnosis from answer metadata
def diagnose(track: str, competency_code: str, *, hint_used: bool = False,
             wrong_operation: bool = False, misread_question: bool = False,
             ran_out_of_time: bool = False, unknown_word: bool = False,
             self_report: str | None = None) -> str:
    if self_report in ROOT_CAUSES:
        return self_report
    if ran_out_of_time:
        return "time_management"
    if misread_question:
        return "misreading"
    if unknown_word:
        return "vocabulary"
    if wrong_operation:
        return "calculation"
    if track == "ielts" and (".gram." in competency_code or ".write." in competency_code):
        return "grammar"
    if track == "snbt" and any(k in competency_code for k in
                               ("deduction", "implication", "necessary", "argument", "analytical")):
        return "logical_reasoning"
    if track == "snbt" and any(k in competency_code for k in
                               ("proportion", "work_rate", "venn", "set_theory", "intersection", "word_to_model")):
        return "conceptual"
    return "unknown"


def choose_strategy(root_cause: str, tried_methods: list[str],
                    last_activity: str | None = None) -> str:
    """First effective-for-cause method not yet tried; rotate if all tried.
    Also avoids repeating the immediately previous activity type."""
    prefs = CAUSE_STRATEGIES.get(root_cause, CAUSE_STRATEGIES["unknown"])
    for m in prefs:
        if m not in tried_methods and m != last_activity:
            return m
    for m in STRATEGIES:                      # exhausted cause-prefs → any fresh method
        if m not in tried_methods and m != last_activity:
            return m
    return prefs[len(tried_methods) % len(prefs)]   # full rotation restart


def next_difficulty(current: int, recent_accuracy: float) -> int:
    """Step difficulty by demonstrated accuracy, never by a single answer."""
    if recent_accuracy >= 0.8:
        return min(5, current + 1)
    if recent_accuracy <= 0.4:
        return max(1, current - 1)
    return current