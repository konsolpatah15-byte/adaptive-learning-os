//! GET/POST /api/mistakes | PATCH /api/mistakes/{id}

use axum::{extract::{State, Path}, Json};
use serde::Deserialize;
use std::sync::Arc;
use crate::state::AppState;
use crate::auth as auth_mod;

fn uid(h: &axum::http::HeaderMap, s: &AppState) -> Result<i64, (axum::http::StatusCode, Json<serde_json::Value>)> {
    auth_mod::extract_bearer(h).and_then(|t| auth_mod::verify_token(t, &s.config.jwt_secret).ok())
        .map(|c| c.sub)
        .ok_or_else(|| (axum::http::StatusCode::UNAUTHORIZED, Json(serde_json::json!({"error": "unauthorized"}))))
}

pub async fn list(
    State(state): State<Arc<AppState>>,
    headers: axum::http::HeaderMap,
) -> Result<Json<serde_json::Value>, (axum::http::StatusCode, Json<serde_json::Value>)> {
    let user_id = uid(&headers, &state)?;
    let mistakes = alos_db::repo::get_unresolved_mistakes(&state.db, user_id).await.unwrap_or_default();
    Ok(Json(serde_json::json!({"mistakes": mistakes})))
}

#[derive(Deserialize)]
pub struct CreateMistakeRequest {
    pub competency_code: String,
    pub track: String,
    pub question: String,
    pub learner_answer: String,
    pub correct_answer: String,
    pub root_cause: String,
}

pub async fn create(
    State(state): State<Arc<AppState>>,
    headers: axum::http::HeaderMap,
    Json(req): Json<CreateMistakeRequest>,
) -> Result<Json<serde_json::Value>, (axum::http::StatusCode, Json<serde_json::Value>)> {
    let user_id = uid(&headers, &state)?;
    let comp_id = alos_db::repo::get_competency(&state.db, &req.competency_code).await.ok().flatten().map(|c| c.id);
    let entry = alos_db::models::MistakeEntry {
        id: 0, user_id, competency_id: comp_id, track: req.track,
        question: req.question, learner_answer: Some(req.learner_answer),
        correct_answer: Some(req.correct_answer), root_cause: req.root_cause,
        explanation: None, resolved: false, resolved_at: None, occurrences: 1,
        created_at: String::new(), updated_at: String::new(),
    };
    let result = alos_db::repo::record_mistake(&state.db, &entry).await
        .map_err(|e| (axum::http::StatusCode::INTERNAL_SERVER_ERROR, Json(serde_json::json!({"error": e.to_string()}))))?;
    Ok(Json(serde_json::json!({"mistake": result})))
}

pub async fn resolve(
    State(state): State<Arc<AppState>>,
    headers: axum::http::HeaderMap,
    Path(id): Path<i64>,
) -> Result<Json<serde_json::Value>, (axum::http::StatusCode, Json<serde_json::Value>)> {
    uid(&headers, &state)?;
    sqlx::query("UPDATE mistake_bank SET resolved = 1, resolved_at = strftime('%Y-%m-%dT%H:%M:%fZ','now') WHERE id = ?1")
        .bind(id).execute(&state.db).await
        .map_err(|e| (axum::http::StatusCode::INTERNAL_SERVER_ERROR, Json(serde_json::json!({"error": e.to_string()}))))?;
    Ok(Json(serde_json::json!({"ok": true})))
}