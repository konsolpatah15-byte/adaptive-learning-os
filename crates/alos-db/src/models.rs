//! Database models matching all 13 SQL tables.

use serde::{Deserialize, Serialize};
use sqlx::FromRow;

// ── Users ──────────────────────────────────────────────────────────
#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct User {
    pub id: i64,
    pub username: String,
    #[serde(skip_serializing)]
    pub password_hash: String,
    pub display_name: String,
    pub role: String,
    pub created_at: String,
    pub updated_at: String,
}

// ── Goals ──────────────────────────────────────────────────────────
#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct Goal {
    pub id: i64,
    pub user_id: i64,
    pub track: String,
    pub title: String,
    pub target_band_low: Option<f64>,
    pub target_band_high: Option<f64>,
    pub target_date: Option<String>,
    pub date_is_tentative: bool,
    pub status: String,
    pub created_at: String,
    pub updated_at: String,
}

// ── Subjects ───────────────────────────────────────────────────────
#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct Subject {
    pub id: i64,
    pub track: String,
    pub code: String,
    pub name: String,
    pub name_id: Option<String>,
    pub description: Option<String>,
    pub sort_order: i64,
}

// ── Competencies ───────────────────────────────────────────────────
#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct Competency {
    pub id: i64,
    pub subject_id: i64,
    pub code: String,
    pub name: String,
    pub name_id: Option<String>,
    pub description: Option<String>,
    pub difficulty: i64,
    pub prerequisites: String,   // JSON array of competency codes
    pub mastery: f64,
    pub confidence: f64,
    pub evidence_count: i64,
    pub last_practiced_at: Option<String>,
    pub next_review_at: Option<String>,
    pub review_interval_days: f64,
    pub retrieval_streak: i64,
    pub status: String,
    pub created_at: String,
    pub updated_at: String,
}

// ── Curriculum Topics ──────────────────────────────────────────────
#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct CurriculumTopic {
    pub id: i64,
    pub competency_id: i64,
    pub title: String,
    pub language: String,
    pub content_md: String,
    pub method: String,
    pub difficulty: i64,
    pub sort_order: i64,
    pub created_at: String,
}

// ── Learning Sessions ──────────────────────────────────────────────
#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct LearningSession {
    pub id: i64,
    pub user_id: i64,
    pub track: String,
    pub mode: String,
    pub competency_id: Option<i64>,
    pub started_at: String,
    pub ended_at: Option<String>,
    pub duration_minutes: f64,
    pub summary: Option<String>,
    pub learner_feedback: Option<String>,
    pub created_at: String,
}

// ── Assessment Results ─────────────────────────────────────────────
#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct AssessmentResult {
    pub id: i64,
    pub session_id: Option<i64>,
    pub user_id: i64,
    pub competency_id: Option<i64>,
    pub track: String,
    pub kind: String,
    pub evidence_type: String,
    pub score_raw: Option<f64>,
    pub score_max: Option<f64>,
    pub band_estimate_low: Option<f64>,
    pub band_estimate_high: Option<f64>,
    pub is_provisional: bool,
    pub excluded_items: i64,
    pub notes: Option<String>,
    pub taken_at: String,
}

// ── Mistake Bank ───────────────────────────────────────────────────
#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct MistakeEntry {
    pub id: i64,
    pub user_id: i64,
    pub competency_id: Option<i64>,
    pub track: String,
    pub question: String,
    pub learner_answer: Option<String>,
    pub correct_answer: Option<String>,
    pub root_cause: String,
    pub explanation: Option<String>,
    pub resolved: bool,
    pub resolved_at: Option<String>,
    pub occurrences: i64,
    pub created_at: String,
    pub updated_at: String,
}

// ── Study Schedule ─────────────────────────────────────────────────
#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct StudySchedule {
    pub id: i64,
    pub user_id: i64,
    pub plan_date: String,
    pub start_time: String,
    pub minutes: i64,
    pub track: String,
    pub activity: String,
    pub competency_id: Option<i64>,
    pub title: String,
    pub status: String,
    pub manual_override: bool,
    pub created_at: String,
}

// ── Review Queue ───────────────────────────────────────────────────
#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct ReviewQueue {
    pub id: i64,
    pub user_id: i64,
    pub competency_id: i64,
    pub due_at: String,
    pub interval_days: f64,
    pub repetitions: i64,
    pub last_result: Option<String>,
    pub status: String,
    pub created_at: String,
}

// ── Learning Preferences ───────────────────────────────────────────
#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct LearningPreferences {
    pub user_id: i64,
    pub data_json: String,
    pub updated_at: String,
}

// ── Tutor Messages ─────────────────────────────────────────────────
#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct TutorMessage {
    pub id: i64,
    pub user_id: i64,
    pub session_id: Option<i64>,
    pub role: String,
    pub content: String,
    pub mode: Option<String>,
    pub created_at: String,
}

// ── System Events ──────────────────────────���───────────────────────
#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct SystemEvent {
    pub id: i64,
    pub level: String,
    pub source: String,
    pub event: String,
    pub detail: Option<String>,
    pub created_at: String,
}

// ── Deployment History ─────────────────────────────────────────────
#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct DeploymentHistory {
    pub id: i64,
    pub target: String,
    pub ref_: Option<String>,
    pub status: String,
    pub detail: Option<String>,
    pub created_at: String,
}

// ── DTOs / Request-Response types ───────────────��──────────────────

/// Lean competency summary for dashboard / list views.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CompetencySummary {
    pub code: String,
    pub name: String,
    pub name_id: Option<String>,
    pub mastery: f64,
    pub confidence: f64,
    pub status: String,
}

/// Dashboard aggregate returned to the frontend.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct DashboardResponse {
    pub active_goals: Vec<Goal>,
    pub today_plan: Vec<StudySchedule>,
    pub recent_sessions: Vec<LearningSession>,
    pub weakest_competencies: Vec<CompetencySummary>,
    pub upcoming_reviews: Vec<ReviewQueue>,
}

/// Learning preferences as a typed struct (serialized as JSON in the DB).
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LearnerPrefs {
    pub explanation_language: String,
    pub weekday_minutes: i32,
    pub weekday_window_start: String,
    pub weekday_window_end: String,
    pub weekend_minutes: i32,
    pub teach_before_test: bool,
    pub max_questions_before_reexplain: i32,
    pub autonomy_level: String,
}