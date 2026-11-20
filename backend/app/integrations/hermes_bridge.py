"""Hermes bridge — uses ONLY documented mechanisms:

- `hermes chat -q '<prompt>'` one-shot subprocess (documented CLI).
- Hermes Memory/Skills/Cron are managed by the agent itself, not via
  invented HTTP endpoints. This bridge passes learner context in the prompt
  and persists everything authoritative in SQLite.

Bounded memory: history capped, subprocess timeout enforced, output capped.
Falls back to the deterministic engine when Hermes is unavailable.
"""
from __future__ import annotations
import shutil
import subprocess

from ..core.config import system
from ..core.db import get_db, rows, log_event

MAX_OUTPUT_CHARS = 12000


def hermes_available() -> bool:
    return shutil.which(system()["ai"]["hermes_bin"]) is not None


SYSTEM_PREAMBLE = (
    "Kamu adalah tutor pribadi ALOS (Adaptive Learning OS) untuk siswa SMK Indonesia "
    "(jurusan Agribisnis Perikanan Air Tawar) yang menyiapkan IELTS Academic (target band 7-8, "
    "ujian tentatif 20 Mei 2027) dan SNBT 2027 (fokus aktif: PU). "
    "ATURAN WAJIB: (1) Jelaskan dalam Bahasa Indonesia dulu; istilah Inggris diperkenalkan bertahap. "
    "(2) AJARKAN sebelum menguji; jangan membuat ujian panjang setelah tiap pelajaran. "
    "(3) Jika siswa bingung, ganti metode penjelasan — JANGAN mengulang tes remedial. "
    "(4) Jangan mengklaim band IELTS resmi dari latihan; semua estimasi bersifat provisional. "
    "(5) Latihan listening TTS bukan bukti listening IELTS autentik; pelafalan tidak bisa dinilai dari transkrip. "
    "(6) Gunakan contoh nyata yang relevan (akuakultur, bisnis, kehidupan sehari-hari). "
    "(7) Jawaban ringkas, hangat, interaktif; akhiri dengan satu pertanyaan ringan atau langkah lanjut, bukan ujian."
)


def build_context(user_id: int, mode: str) -> str:
    """Compact progress-aware context (bounded size)."""
    with get_db() as db:
        weak = rows(db.execute(
            "SELECT code, name_id, mastery FROM competencies WHERE status IN ('weak','beginning')"
            " ORDER BY mastery ASC LIMIT 5"))
        strong = rows(db.execute(
            "SELECT code, name_id, mastery FROM competencies WHERE mastery>=61"
            " ORDER BY mastery DESC LIMIT 3"))
        mistakes = rows(db.execute(
            "SELECT root_cause, COUNT(*) n FROM mistake_bank WHERE user_id=? AND resolved=0"
            " GROUP BY root_cause ORDER BY n DESC LIMIT 4", (user_id,)))
        hist = rows(db.execute(
            "SELECT role, content FROM tutor_messages WHERE user_id=?"
            " ORDER BY id DESC LIMIT ?", (user_id, system()["ai"]["max_history_messages"])))
    lines = [SYSTEM_PREAMBLE, "", f"Mode belajar saat ini: {mode}."]
    if weak:
        lines.append("Kompetensi terlemah: " + "; ".join(
            f"{w['name_id'] or w['code']} ({w['mastery']:.0f}/100)" for w in weak))
    if strong:
        lines.append("Sudah cukup kuat: " + "; ".join(
            f"{s['name_id'] or s['code']}" for s in strong))
    if mistakes:
        lines.append("Pola kesalahan belum tuntas: " + "; ".join(
            f"{m['root_cause']}×{m['n']}" for m in mistakes))
    if hist:
        lines.append("\nRiwayat percakapan terakhir:")
        for m in reversed(hist):
            who = "Siswa" if m["role"] == "user" else "Tutor"
            lines.append(f"{who}: {m['content'][:500]}")
    return "\n".join(lines)[:8000]


def chat(user_id: int, message: str, mode: str = "explanation") -> dict:
    """Persist user msg → call Hermes → persist reply. Engine fallback if down."""
    with get_db() as db:
        db.execute("INSERT INTO tutor_messages (user_id, role, content, mode) VALUES (?,?,?,?)",
                   (user_id, "user", message[:4000], mode))
    prompt = build_context(user_id, mode) + f"\n\nSiswa: {message[:2000]}\nTutor:"
    reply, source = None, "hermes"
    if hermes_available():
        try:
            proc = subprocess.run(
                [system()["ai"]["hermes_bin"], "chat", "-q", prompt],
                capture_output=True, text=True,
                timeout=system()["ai"]["chat_timeout_s"],
            )
            out = (proc.stdout or "").strip()
            if proc.returncode == 0 and out:
                reply = out[-MAX_OUTPUT_CHARS:]
        except (subprocess.TimeoutExpired, OSError) as e:
            log_event("hermes_bridge", "chat_failed", str(e), level="warn")
    if reply is None:
        source = "engine_fallback"
        reply = _engine_fallback(message, mode)
    with get_db() as db:
        db.execute("INSERT INTO tutor_messages (user_id, role, content, mode) VALUES (?,?,?,?)",
                   (user_id, "assistant", reply, mode))
    return {"reply": reply, "source": source, "mode": mode}


def _engine_fallback(message: str, mode: str) -> str:
    """Deterministic, honest fallback — routes to the learning engine."""
    import importlib.util
    from pathlib import Path
    root = Path(__file__).resolve().parents[3]
    spec = importlib.util.spec_from_file_location(
        "orchestrator", root / "learning-engine" / "orchestrator.py")
    orch = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(orch)
    lesson = orch.next_lesson(1, intent_text=message)
    note = lesson.get("note_id", "")
    name = lesson.get("name_id", "topik berikutnya")
    strat = lesson.get("strategy_label_id", "penjelasan")
    body = (f"{note}\n\nTopik prioritas sekarang: **{name}** "
            f"(mastery {lesson.get('mastery', 0):.0f}/100). "
            f"Metode: {strat}. ")
    if lesson.get("lesson"):
        body += "\n\n" + lesson["lesson"]["content_md"][:3000]
    else:
        body += ("\n(Mesin AI sedang tidak tersedia — mode hemat aktif. "
                 "Materi lengkap akan dibuat saat koneksi pulih; sementara kita bisa "
                 "diskusi konsep dasarnya dulu.)")
    return body