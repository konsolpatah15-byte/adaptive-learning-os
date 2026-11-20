//! Repository functions — typed queries for the 13 tables.

use sqlx::SqlitePool;
use crate::models::*;

// ── Users ──────────────────────────────────────────────────────────
pub async fn create_user(pool: &SqlitePool, username: &str, password_hash: &str) -> Result<User, sqlx::Error> {
    sqlx::query_as::<_, User>(
        "INSERT INTO users (username, password_hash) VALUES (?1, ?2) RETURNING *"
    )
    .bind(username).bind(password_hash)
    .fetch_one(pool).await
}

pub async fn get_user_by_username(pool: &SqlitePool, username: &str) -> Result<Option<User>, sqlx::Error> {
    sqlx::query_as::<_, User>("SELECT * FROM users WHERE username = ?1")
        .bind(username)
        .fetch_optional(pool).await
}

pub async fn get_user(pool: &SqlitePool, user_id: i64) -> Result<Option<User>, sqlx::Error> {
    sqlx::query_as::<_, User>("SELECT * FROM users WHERE id = ?1")
        .bind(user_id)
        .fetch_optional(pool).await
}

// ── Goals ──────────────────────────────────────────────────────────
pub async fn get_goals(pool: &SqlitePool, user_id: i64) -> Result<Vec<Goal>, sqlx::Error> {
    sqlx::query_as::<_, Goal>(
        "SELECT * FROM goals WHERE user_id = ?1 AND status = 'active' ORDER BY created_at"
    )
    .bind(user_id)
    .fetch_all(pool).await
}

// ── Subjects ───────────────────────────────────────────────────────
pub async fn get_subjects(pool: &SqlitePool, track: &str) -> Result<Vec<Subject>, sqlx::Error> {
    sqlx::query_as::<_, Subject>(
        "SELECT * FROM subjects WHERE track = ?1 ORDER BY sort_order"
    )
    .bind(track)
    .fetch_all(pool).await
}

// ── Competencies ───────────────────────────────────────────────────
pub async fn get_competency(pool: &SqlitePool, code: &str) -> Result<Option<Competency>, sqlx::Error> {
    sqlx::query_as::<_, Competency>("SELECT * FROM competencies WHERE code = ?1")
        .bind(code)
        .fetch_optional(pool).await
}

pub async fn get_competencies_by_subject(pool: &SqlitePool, subject_id: i64) -> Result<Vec<Competency>, sqlx::Error> {
    sqlx::query_as::<_, Competency>(
        "SELECT * FROM competencies WHERE subject_id = ?1 ORDER BY difficulty, code"
    )
    .bind(subject_id)
    .fetch_all(pool).await
}

pub async fn get_weakest_competencies(pool: &SqlitePool, _user_id: i64, limit: i64) -> Result<Vec<CompetencySummary>, sqlx::Error> {
    #[derive(sqlx::FromRow)]
    struct Row { code: String, name: String, name_id: Option<String>, mastery: f64, confidence: f64, status: String }
    let rows: Vec<Row> = sqlx::query_as::<_, Row>(
        "SELECT code, name, name_id, mastery, confidence, status FROM competencies
         WHERE status IN ('new','learning','weak','developing') AND evidence_count > 0
         ORDER BY mastery ASC, confidence ASC LIMIT ?1"
    )
    .bind(limit)
    .fetch_all(pool).await?;
    Ok(rows.into_iter().map(|r| CompetencySummary {
        code: r.code, name: r.name, name_id: r.name_id,
        mastery: r.mastery, confidence: r.confidence, status: r.status,
    }).collect())
}

pub async fn update_competency_mastery(pool: &SqlitePool, code: &str, mastery: f64, confidence: f64, status: &str) -> Result<(), sqlx::Error> {
    sqlx::query(
        "UPDATE competencies SET mastery = ?1, confidence = ?2, status = ?3,
         evidence_count = evidence_count + 1, last_practiced_at = strftime('%Y-%m-%dT%H:%M:%fZ','now'),
         updated_at = strftime('%Y-%m-%dT%H:%M:%fZ','now') WHERE code = ?4"
    )
    .bind(mastery).bind(confidence).bind(status).bind(code)
    .execute(pool).await?;
    Ok(())
}

// ── Learning Sessions ──────────────────────────────────────────────
pub async fn create_session(pool: &SqlitePool, user_id: i64, track: &str, mode: &str, competency_id: Option<i64>) -> Result<LearningSession, sqlx::Error> {
    sqlx::query_as::<_, LearningSession>(
        "INSERT INTO learning_sessions (user_id, track, mode, competency_id) VALUES (?1, ?2, ?3, ?4) RETURNING *"
    )
    .bind(user_id).bind(track).bind(mode).bind(competency_id)
    .fetch_one(pool).await
}

pub async fn get_recent_sessions(pool: &SqlitePool, user_id: i64, limit: i64) -> Result<Vec<LearningSession>, sqlx::Error> {
    sqlx::query_as::<_, LearningSession>(
        "SELECT * FROM learning_sessions WHERE user_id = ?1 ORDER BY started_at DESC LIMIT ?2"
    )
    .bind(user_id).bind(limit)
    .fetch_all(pool).await
}

pub async fn end_session(pool: &SqlitePool, session_id: i64, summary: &str, feedback: Option<&str>, duration_minutes: f64) -> Result<(), sqlx::Error> {
    sqlx::query(
        "UPDATE learning_sessions SET ended_at = strftime('%Y-%m-%dT%H:%M:%fZ','now'),
         duration_minutes = ?1, summary = ?2, learner_feedback = ?3 WHERE id = ?4"
    )
    .bind(duration_minutes).bind(summary).bind(feedback).bind(session_id)
    .execute(pool).await?;
    Ok(())
}

// ── Assessment Results ─────────────────────────────────────────────
pub async fn record_assessment(pool: &SqlitePool, r: &AssessmentResult) -> Result<AssessmentResult, sqlx::Error> {
    sqlx::query_as::<_, AssessmentResult>(
        "INSERT INTO assessment_results (session_id, user_id, competency_id, track, kind, evidence_type,
         score_raw, score_max, band_estimate_low, band_estimate_high, is_provisional, excluded_items, notes)
         VALUES (?1,?2,?3,?4,?5,?6,?7,?8,?9,?10,?11,?12,?13) RETURNING *"
    )
    .bind(r.session_id).bind(r.user_id).bind(r.competency_id).bind(&r.track)
    .bind(&r.kind).bind(&r.evidence_type)
    .bind(r.score_raw).bind(r.score_max)
    .bind(r.band_estimate_low).bind(r.band_estimate_high)
    .bind(r.is_provisional).bind(r.excluded_items).bind(&r.notes)
    .fetch_one(pool).await
}

// ── Mistake Bank ───────────────────────────────────────────────────
pub async fn record_mistake(pool: &SqlitePool, m: &MistakeEntry) -> Result<MistakeEntry, sqlx::Error> {
    sqlx::query_as::<_, MistakeEntry>(
        "INSERT INTO mistake_bank (user_id, competency_id, track, question, learner_answer, correct_answer, root_cause, explanation)
         VALUES (?1,?2,?3,?4,?5,?6,?7,?8) RETURNING *"
    )
    .bind(m.user_id).bind(m.competency_id).bind(&m.track)
    .bind(&m.question).bind(&m.learner_answer).bind(&m.correct_answer)
    .bind(&m.root_cause).bind(&m.explanation)
    .fetch_one(pool).await
}

pub async fn get_unresolved_mistakes(pool: &SqlitePool, user_id: i64) -> Result<Vec<MistakeEntry>, sqlx::Error> {
    sqlx::query_as::<_, MistakeEntry>(
        "SELECT * FROM mistake_bank WHERE user_id = ?1 AND resolved = 0 ORDER BY created_at DESC"
    )
    .bind(user_id)
    .fetch_all(pool).await
}

// ── Study Schedule ─────────────────────────────────────────────────
pub async fn get_today_plan(pool: &SqlitePool, user_id: i64, date: &str) -> Result<Vec<StudySchedule>, sqlx::Error> {
    sqlx::query_as::<_, StudySchedule>(
        "SELECT * FROM study_schedule WHERE user_id = ?1 AND plan_date = ?2 ORDER BY start_time"
    )
    .bind(user_id).bind(date)
    .fetch_all(pool).await
}

// ── Review Queue ───────────────────────────────────────────────────
pub async fn get_due_reviews(pool: &SqlitePool, user_id: i64) -> Result<Vec<ReviewQueue>, sqlx::Error> {
    sqlx::query_as::<_, ReviewQueue>(
        "SELECT * FROM review_queue WHERE user_id = ?1 AND status = 'pending' AND due_at <= strftime('%Y-%m-%dT%H:%M:%fZ','now') ORDER BY due_at"
    )
    .bind(user_id)
    .fetch_all(pool).await
}

// ── Tutor Messages ───────────────��───────────────────────────────��─
pub async fn save_tutor_message(pool: &SqlitePool, user_id: i64, session_id: Option<i64>, role: &str, content: &str, mode: Option<&str>) -> Result<TutorMessage, sqlx::Error> {
    sqlx::query_as::<_, TutorMessage>(
        "INSERT INTO tutor_messages (user_id, session_id, role, content, mode) VALUES (?1,?2,?3,?4,?5) RETURNING *"
    )
    .bind(user_id).bind(session_id).bind(role).bind(content).bind(mode)
    .fetch_one(pool).await
}

pub async fn get_session_messages(pool: &SqlitePool, session_id: i64, limit: i64) -> Result<Vec<TutorMessage>, sqlx::Error> {
    sqlx::query_as::<_, TutorMessage>(
        "SELECT * FROM tutor_messages WHERE session_id = ?1 ORDER BY id ASC LIMIT ?2"
    )
    .bind(session_id).bind(limit)
    .fetch_all(pool).await
}

// ── System Events ───────────────────────────────────────────────��──
pub async fn log_event(pool: &SqlitePool, level: &str, source: &str, event: &str, detail: Option<&str>) -> Result<(), sqlx::Error> {
    sqlx::query("INSERT INTO system_events (level, source, event, detail) VALUES (?1,?2,?3,?4)")
        .bind(level).bind(source).bind(event).bind(detail)
        .execute(pool).await?;
    Ok(())
}

// ── Deployment History ─────────────────────────────────────────────
pub async fn record_deploy(pool: &SqlitePool, target: &str, ref_: Option<&str>, status: &str, detail: Option<&str>) -> Result<(), sqlx::Error> {
    sqlx::query("INSERT INTO deployment_history (target, ref, status, detail) VALUES (?1,?2,?3,?4)")
        .bind(target).bind(ref_).bind(status).bind(detail)
        .execute(pool).await?;
    Ok(())
}