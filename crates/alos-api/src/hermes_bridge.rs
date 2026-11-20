//! Hermes Agent bridge — calls Hermes CLI as a subprocess for AI tutor responses.
//! Falls back to deterministic engine response when Hermes is unavailable.

use std::process::Command;

/// Check if the `hermes` binary is available on PATH.
pub fn hermes_available() -> bool {
    Command::new("which")
        .arg("hermes")
        .output()
        .map(|o| o.status.success())
        .unwrap_or(false)
}

/// System prompt for the ALOS tutor (Indonesian-first, anti-boredom rules).
const SYSTEM_PROMPT: &str = "\
Kamu adalah tutor pribadi ALOS (Adaptive Learning OS) untuk siswa SMK Indonesia \
(jurusan Agribisnis Perikanan Air Tawar) yang menyiapkan IELTS Academic (target band 7-8, \
ujian tentatif 20 Mei 2027) dan SNBT 2027 (fokus aktif: PU). \
ATURAN WAJIB: (1) Jelaskan dalam Bahasa Indonesia dulu; istilah Inggris diperkenalkan bertahap. \
(2) AJARKAN sebelum menguji; jangan membuat ujian panjang setelah tiap pelajaran. \
(3) Jika siswa bingung, ganti metode penjelasan — JANGAN mengulang tes remedial. \
(4) Jangan mengklaim band IELTS resmi dari latihan; semua estimasi bersifat provisional. \
(5) Latihan listening TTS bukan bukti listening IELTS autentik. \
(6) Gunakan contoh nyata yang relevan (akuakultur, bisnis, kehidupan sehari-hari). \
(7) Jawaban singkat, hangat, interaktif; akhiri dengan pertanyaan ringan atau langkah lanjut, bukan ujian.";

/// Build a compact context string with learner progress data.
pub async fn build_context(pool: &sqlx::SqlitePool, user_id: i64, mode: &str) -> String {
    let mut ctx = String::from(SYSTEM_PROMPT);
    ctx.push_str(&format!("\n\nMode belajar saat ini: {mode}.\n"));

    // Weak competencies
    if let Ok(rows) = sqlx::query_as::<_, (String, Option<String>, f64)>(
        "SELECT code, name_id, mastery FROM competencies WHERE status IN ('weak','learning','new') ORDER BY mastery ASC LIMIT 5"
    ).fetch_all(pool).await {
        if !rows.is_empty() {
            ctx.push_str("Kompetensi terlemah: ");
            for (i, (code, name_id, mastery)) in rows.iter().enumerate() {
                if i > 0 { ctx.push_str("; "); }
                ctx.push_str(&format!("{} ({:.0}/100)", name_id.as_deref().unwrap_or(code), mastery));
            }
            ctx.push('\n');
        }
    }

    // Mistake patterns
    if let Ok(rows) = sqlx::query_as::<_, (String, i64)>(
        "SELECT root_cause, COUNT(*) n FROM mistake_bank WHERE user_id=?1 AND resolved=0 GROUP BY root_cause ORDER BY n DESC LIMIT 4"
    ).bind(user_id).fetch_all(pool).await {
        if !rows.is_empty() {
            ctx.push_str("Pola kesalahan: ");
            for (i, (cause, n)) in rows.iter().enumerate() {
                if i > 0 { ctx.push_str("; "); }
                ctx.push_str(&format!("{}×{}", cause, n));
            }
            ctx.push('\n');
        }
    }

    ctx.truncate(8000);
    ctx
}

/// Call Hermes via CLI subprocess. Returns the reply or falls back to engine.
pub async fn chat(
    pool: &sqlx::SqlitePool,
    user_id: i64,
    message: &str,
    mode: &str,
) -> String
{
    // Save user message
    let _ = sqlx::query(
        "INSERT INTO tutor_messages (user_id, role, content, mode) VALUES (?1, ?2, ?3, ?4)"
    ).bind(user_id).bind("user").bind(message).bind(mode).execute(pool).await;

    let context = build_context(pool, user_id, mode).await;
    let prompt = format!("{}\n\nSiswa: {}\nTutor:", context, message);

    // Try Hermes
    if hermes_available() {
        if let Ok(output) = tokio::time::timeout(
            std::time::Duration::from_secs(180),
            tokio::task::spawn_blocking(move || {
                Command::new("hermes")
                    .args(["chat", "-q", &prompt])
                    .output()
            }),
        ).await {
            if let Ok(Ok(out)) = output {
                if out.status.success() {
                    let reply = String::from_utf8_lossy(&out.stdout).trim().to_string();
                    if !reply.is_empty() {
                        // Save assistant reply
                        let _ = sqlx::query(
                            "INSERT INTO tutor_messages (user_id, role, content, mode) VALUES (?1, ?2, ?3, ?4)"
                        ).bind(user_id).bind("assistant").bind(&reply).bind(mode).execute(pool).await;
                        return reply;
                    }
                }
            }
        }
    }

    // Fallback: deterministic engine response
    let fallback = engine_fallback(message, mode);
    let _ = sqlx::query(
        "INSERT INTO tutor_messages (user_id, role, content, mode) VALUES (?1, ?2, ?3, ?4)"
    ).bind(user_id).bind("assistant").bind(&fallback).bind(mode).execute(pool).await;

    fallback
}

/// Deterministic fallback when Hermes is unavailable.
fn engine_fallback(message: &str, _mode: &str) -> String {
    // Anti-boredom detection — same as the Rust engine
    if let Some((note, strategy)) = alos_engine::teaching::detect_learner_intent(message) {
        return format!("{}\n\nMetode: {}", note, strategy.as_str());
    }

    format!(
        "Saya siap membantu! Saat ini mode AI hemat aktif (Hermes belum tersedia).\n\n\
         Kita bisa:\n\
         1. Latihan soal Penalaran Umum (PU) — perbandingan, himpunan, logika\n\
         2. Belajar grammar IELTS — conditionals, subject-verb agreement\n\
         3. Review materi sebelumnya\n\
         4. Diskusi konsep yang sulit\n\n\
         Apa yang ingin kamu pelajari hari ini?"
    )
}