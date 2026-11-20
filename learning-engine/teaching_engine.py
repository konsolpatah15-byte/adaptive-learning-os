"""Teaching engine — lesson assembly + anti-boredom intent handling.

Builds a TEACH payload from curriculum topics using the strategy chosen by
the adaptation engine. Language: Indonesian first, English terms introduced
gradually for IELTS. Verification is a LIGHT check (max 1-2 items), never a
full exam after each lesson.
"""
from __future__ import annotations
import re

INTENT_PATTERNS = {
    "too_many_tests": [r"too many tests", r"kebanyakan (tes|soal|ujian)", r"terlalu banyak (tes|ujian)", r"bosan (soal|tes)"],
    "explain_instead": [r"explain instead", r"jelaskan (saja|dulu)", r"jelasanin", r"\bcontinue\b", r"\blanjut(kan)?\b"],
    "weak_here": [r"(i'?m|aku|saya|gue) (weak|lemah|bingung)", r"masih bingung", r"belum paham", r"nggak ngerti", r"ga ngerti"],
    "move_on": [r"let'?s move on", r"ganti topik", r"lanjut topik lain", r"skip (ini|dulu)"],
}


def detect_intent(text: str) -> str | None:
    t = text.lower().strip()
    # priority: explicit test-fatigue > weakness > move-on > generic continue
    for intent in ("too_many_tests", "weak_here", "move_on", "explain_instead"):
        for pat in INTENT_PATTERNS[intent]:
            if re.search(pat, t):
                return intent
    return None


INTENT_ACTION = {
    "too_many_tests": {"action": "switch_to_teaching", "assessment_allowed": False,
                       "note_id": "Oke, tidak ada tes dulu. Kita belajar dengan cara lain — aku jelaskan pakai contoh nyata."},
    "weak_here": {"action": "guided_learning_new_method", "assessment_allowed": False,
                  "note_id": "Tidak apa-apa belum paham — itu bukan kurang usaha. Aku coba penjelasan dengan metode berbeda, pelan-pelan."},
    "explain_instead": {"action": "alternative_explanation", "assessment_allowed": False,
                        "note_id": "Siap, lanjut penjelasan. Aku pakai sudut pandang lain supaya lebih jelas."},
    "move_on": {"action": "offer_topic_switch", "assessment_allowed": False,
                "note_id": "Boleh ganti topik. Topik ini tetap tersimpan dan akan diulang ringan nanti lewat review, bukan tes."},
}


def build_lesson(topic: dict, strategy: str, language: str = "id",
                 include_check: bool = True) -> dict:
    """Assemble lesson: explanation → example → (optional) ONE light check."""
    lesson = {
        "topic_id": topic.get("id"),
        "title": topic["title"],
        "strategy": strategy,
        "language": language,
        "content_md": topic["content_md"],
        "phases": ["explain", "example", "discuss"],
    }
    if include_check:
        lesson["phases"].append("light_check")
        lesson["check_policy"] = "max 2 items; skip freely; failure → new explanation, NOT retest"
    return lesson


METHOD_LABELS_ID = {
    "direct": "penjelasan langsung", "socratic": "tanya-jawab terpandu",
    "demo": "demonstrasi langkah demi langkah", "scenario": "skenario dunia nyata",
    "analogy": "analogi", "visual": "penjelasan visual/diagram",
    "guided": "pemecahan masalah terbimbing", "discussion": "diskusi interaktif",
    "case": "studi kasus", "practical": "aplikasi praktis",
}