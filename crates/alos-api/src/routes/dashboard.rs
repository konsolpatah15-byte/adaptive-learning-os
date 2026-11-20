//! GET /api/dashboard | GET /api/dashboard/summary

use axum::{extract::State, Json};
use std::sync::Arc;
use crate::state::AppState;
use crate::auth as auth_mod;

pub async fn dashboard(
    State(state): State<Arc<AppState>>,
    headers: axum::http::HeaderMap,
) -> Result<Json<serde_json::Value>, (axum::http::StatusCode, Json<serde_json::Value>)>
{
    let claims = auth_mod::extract_bearer(&headers)
        .and_then(|t| auth_mod::verify_token(t, &state.config.jwt_secret).ok())
        .ok_or_else(|| (axum::http::StatusCode::UNAUTHORIZED, Json(serde_json::json!({"error": "unauthorized"}))))?;

    let user_id = claims.sub;
    let today = chrono::Utc::now().format("%Y-%m-%d").to_string();

    let goals = alos_db::repo::get_goals(&state.db, user_id).await.unwrap_or_default();
    let today_plan = alos_db::repo::get_today_plan(&state.db, user_id, &today).await.unwrap_or_default();
    let recent_sessions = alos_db::repo::get_recent_sessions(&state.db, user_id, 5).await.unwrap_or_default();
    let weakest = alos_db::repo::get_weakest_competencies(&state.db, user_id, 5).await.unwrap_or_default();
    let reviews = alos_db::repo::get_due_reviews(&state.db, user_id).await.unwrap_or_default();

    Ok(Json(serde_json::json!({
        "goals": goals,
        "today_plan": today_plan,
        "recent_sessions": recent_sessions,
        "weakest_competencies": weakest,
        "upcoming_reviews": reviews,
    })))
}

pub async fn summary(
    State(state): State<Arc<AppState>>,
    headers: axum::http::HeaderMap,
) -> Result<Json<serde_json::Value>, (axum::http::StatusCode, Json<serde_json::Value>)>
{
    let claims = auth_mod::extract_bearer(&headers)
        .and_then(|t| auth_mod::verify_token(t, &state.config.jwt_secret).ok())
        .ok_or_else(|| (axum::http::StatusCode::UNAUTHORIZED, Json(serde_json::json!({"error": "unauthorized"}))))?;

    let user_id = claims.sub;
    let today = chrono::Utc::now().format("%Y-%m-%d").to_string();

    let today_plan = alos_db::repo::get_today_plan(&state.db, user_id, &today).await.unwrap_or_default();
    let reviews = alos_db::repo::get_due_reviews(&state.db, user_id).await.unwrap_or_default();
    let weakest = alos_db::repo::get_weakest_competencies(&state.db, user_id, 3).await.unwrap_or_default();

    Ok(Json(serde_json::json!({
        "today_minutes_planned": today_plan.iter().map(|s| s.minutes).sum::<i64>(),
        "today_activities": today_plan.len(),
        "pending_reviews": reviews.len(),
        "top_weakness": weakest.first().map(|w| serde_json::json!({"code": w.code, "name": w.name, "mastery": w.mastery})),
    })))
}