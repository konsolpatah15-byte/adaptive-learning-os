//! GET /api/analytics/progress | GET /api/analytics/weaknesses

use axum::{extract::State, Json};
use std::sync::Arc;
use crate::state::AppState;
use crate::auth as auth_mod;

fn uid(h: &axum::http::HeaderMap, s: &AppState) -> Result<i64, (axum::http::StatusCode, Json<serde_json::Value>)> {
    auth_mod::extract_bearer(h).and_then(|t| auth_mod::verify_token(t, &s.config.jwt_secret).ok())
        .map(|c| c.sub)
        .ok_or_else(|| (axum::http::StatusCode::UNAUTHORIZED, Json(serde_json::json!({"error": "unauthorized"}))))
}

pub async fn progress(
    State(state): State<Arc<AppState>>,
    headers: axum::http::HeaderMap,
) -> Result<Json<serde_json::Value>, (axum::http::StatusCode, Json<serde_json::Value>)> {
    let user_id = uid(&headers, &state)?;
    let sessions = alos_db::repo::get_recent_sessions(&state.db, user_id, 30).await.unwrap_or_default();
    let weakest = alos_db::repo::get_weakest_competencies(&state.db, user_id, 5).await.unwrap_or_default();
    let reviews = alos_db::repo::get_due_reviews(&state.db, user_id).await.unwrap_or_default();

    Ok(Json(serde_json::json!({
        "total_sessions": sessions.len(),
        "recent_session_count": sessions.len(),
        "weakest_competencies": weakest,
        "pending_reviews": reviews.len(),
    })))
}

pub async fn weaknesses(
    State(state): State<Arc<AppState>>,
    headers: axum::http::HeaderMap,
) -> Result<Json<serde_json::Value>, (axum::http::StatusCode, Json<serde_json::Value>)> {
    let user_id = uid(&headers, &state)?;
    let weakest = alos_db::repo::get_weakest_competencies(&state.db, user_id, 10).await.unwrap_or_default();
    Ok(Json(serde_json::json!({"weaknesses": weakest})))
}