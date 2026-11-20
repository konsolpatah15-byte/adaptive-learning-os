//! POST /api/tutor/chat | GET /api/tutor/history | POST /api/tutor/feedback

use axum::{extract::State, Json};
use serde::Deserialize;
use std::sync::Arc;
use crate::state::AppState;
use crate::auth as auth_mod;

#[derive(Deserialize)]
pub struct ChatRequest {
    pub message: String,
    pub session_id: Option<i64>,
    pub track: Option<String>,
}

pub async fn chat(
    State(state): State<Arc<AppState>>,
    headers: axum::http::HeaderMap,
    Json(req): Json<ChatRequest>,
) -> Result<Json<serde_json::Value>, (axum::http::StatusCode, Json<serde_json::Value>)>
{
    let claims = auth_mod::extract_bearer(&headers)
        .and_then(|t| auth_mod::verify_token(t, &state.config.jwt_secret).ok())
        .ok_or_else(|| (axum::http::StatusCode::UNAUTHORIZED, Json(serde_json::json!({"error": "unauthorized"}))))?;

    let user_id = claims.sub;

    // Detect anti-boredom intents first (fast path, deterministic)
    if let Some((note, strategy)) = alos_engine::teaching::detect_learner_intent(&req.message) {
        alos_db::repo::save_tutor_message(&state.db, user_id, req.session_id, "user", &req.message, Some("chat")).await.ok();
        return Ok(Json(serde_json::json!({
            "response": note,
            "strategy": strategy.as_str(),
            "action": "adapt",
        })));
    }

    // Call Hermes bridge (or engine fallback)
    let mode = req.track.as_deref().unwrap_or("explanation");
    let response = crate::hermes_bridge::chat(&state.db, user_id, &req.message, mode).await;

    Ok(Json(serde_json::json!({
        "response": response,
        "strategy": "direct",
    })))
}

pub async fn history(
    State(state): State<Arc<AppState>>,
    headers: axum::http::HeaderMap,
    axum::extract::Query(params): axum::extract::Query<std::collections::HashMap<String, String>>,
) -> Result<Json<serde_json::Value>, (axum::http::StatusCode, Json<serde_json::Value>)>
{
    let claims = auth_mod::extract_bearer(&headers)
        .and_then(|t| auth_mod::verify_token(t, &state.config.jwt_secret).ok())
        .ok_or_else(|| (axum::http::StatusCode::UNAUTHORIZED, Json(serde_json::json!({"error": "unauthorized"}))))?;

    let session_id: i64 = params.get("session_id").and_then(|s| s.parse().ok()).unwrap_or(0);
    let messages = alos_db::repo::get_session_messages(&state.db, session_id, 50).await.unwrap_or_default();

    Ok(Json(serde_json::json!({ "messages": messages })))
}

#[derive(Deserialize)]
pub struct FeedbackRequest {
    pub session_id: i64,
    pub feedback: String,
}

pub async fn feedback(
    State(state): State<Arc<AppState>>,
    headers: axum::http::HeaderMap,
    Json(req): Json<FeedbackRequest>,
) -> Result<Json<serde_json::Value>, (axum::http::StatusCode, Json<serde_json::Value>)>
{
    let claims = auth_mod::extract_bearer(&headers)
        .and_then(|t| auth_mod::verify_token(t, &state.config.jwt_secret).ok())
        .ok_or_else(|| (axum::http::StatusCode::UNAUTHORIZED, Json(serde_json::json!({"error": "unauthorized"}))))?;

    alos_db::repo::end_session(&state.db, req.session_id, "Feedback recorded", Some(&req.feedback), 0.0).await
        .map_err(|e| (axum::http::StatusCode::INTERNAL_SERVER_ERROR, Json(serde_json::json!({"error": e.to_string()}))))?;

    Ok(Json(serde_json::json!({"ok": true})))
}