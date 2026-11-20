//! GET/POST /api/learning/sessions | GET /api/learning/recommendations

use axum::{extract::State, Json};
use serde::Deserialize;
use std::sync::Arc;
use crate::state::AppState;
use crate::auth as auth_mod;

#[derive(Deserialize)]
pub struct CreateSessionRequest {
    pub track: String,
    pub mode: String,
    pub competency_code: Option<String>,
}

fn uid(headers: &axum::http::HeaderMap, state: &AppState) -> Result<i64, (axum::http::StatusCode, Json<serde_json::Value>)> {
    auth_mod::extract_bearer(headers)
        .and_then(|t| auth_mod::verify_token(t, &state.config.jwt_secret).ok())
        .map(|c| c.sub)
        .ok_or_else(|| (axum::http::StatusCode::UNAUTHORIZED, Json(serde_json::json!({"error": "unauthorized"}))))
}

pub async fn list_sessions(
    State(state): State<Arc<AppState>>,
    headers: axum::http::HeaderMap,
) -> Result<Json<serde_json::Value>, (axum::http::StatusCode, Json<serde_json::Value>)> {
    let user_id = uid(&headers, &state)?;
    let sessions = alos_db::repo::get_recent_sessions(&state.db, user_id, 20).await.unwrap_or_default();
    Ok(Json(serde_json::json!({"sessions": sessions})))
}

pub async fn create_session(
    State(state): State<Arc<AppState>>,
    headers: axum::http::HeaderMap,
    Json(req): Json<CreateSessionRequest>,
) -> Result<Json<serde_json::Value>, (axum::http::StatusCode, Json<serde_json::Value>)> {
    let user_id = uid(&headers, &state)?;
    let comp_id = if let Some(ref code) = req.competency_code {
        alos_db::repo::get_competency(&state.db, code).await.ok().flatten().map(|c| c.id)
    } else { None };
    let session = alos_db::repo::create_session(&state.db, user_id, &req.track, &req.mode, comp_id).await
        .map_err(|e| (axum::http::StatusCode::INTERNAL_SERVER_ERROR, Json(serde_json::json!({"error": e.to_string()}))))?;
    Ok(Json(serde_json::json!({"session": session})))
}

pub async fn recommendations(
    State(state): State<Arc<AppState>>,
    headers: axum::http::HeaderMap,
) -> Result<Json<serde_json::Value>, (axum::http::StatusCode, Json<serde_json::Value>)> {
    let user_id = uid(&headers, &state)?;
    let weakest = alos_db::repo::get_weakest_competencies(&state.db, user_id, 5).await.unwrap_or_default();
    let recs: Vec<_> = weakest.iter().map(|w| serde_json::json!({
        "code": w.code, "name": w.name, "mastery": w.mastery, "status": w.status,
    })).collect();
    Ok(Json(serde_json::json!({"recommendations": recs})))
}