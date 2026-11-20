//! GET/POST /api/schedule | PATCH /api/schedule/{id}

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

pub async fn get(
    State(state): State<Arc<AppState>>,
    headers: axum::http::HeaderMap,
) -> Result<Json<serde_json::Value>, (axum::http::StatusCode, Json<serde_json::Value>)> {
    let user_id = uid(&headers, &state)?;
    let today = chrono::Utc::now().format("%Y-%m-%d").to_string();
    let plan = alos_db::repo::get_today_plan(&state.db, user_id, &today).await.unwrap_or_default();
    let reviews = alos_db::repo::get_due_reviews(&state.db, user_id).await.unwrap_or_default();
    Ok(Json(serde_json::json!({"date": today, "plan": plan, "pending_reviews": reviews})))
}

#[derive(Deserialize)]
pub struct CreateScheduleRequest {
    pub plan_date: String,
    pub start_time: String,
    pub minutes: i32,
    pub track: String,
    pub activity: String,
    pub title: String,
    pub competency_code: Option<String>,
}

pub async fn create(
    State(state): State<Arc<AppState>>,
    headers: axum::http::HeaderMap,
    Json(req): Json<CreateScheduleRequest>,
) -> Result<Json<serde_json::Value>, (axum::http::StatusCode, Json<serde_json::Value>)> {
    let user_id = uid(&headers, &state)?;
    let comp_id = if let Some(ref code) = req.competency_code {
        alos_db::repo::get_competency(&state.db, code).await.ok().flatten().map(|c| c.id)
    } else { None };
    let row = sqlx::query_as::<_, alos_db::models::StudySchedule>(
        "INSERT INTO study_schedule (user_id, plan_date, start_time, minutes, track, activity, title, competency_id)
         VALUES (?1,?2,?3,?4,?5,?6,?7,?8) RETURNING *"
    )
    .bind(user_id).bind(&req.plan_date).bind(&req.start_time).bind(req.minutes)
    .bind(&req.track).bind(&req.activity).bind(&req.title).bind(comp_id)
    .fetch_one(&state.db).await
    .map_err(|e| (axum::http::StatusCode::INTERNAL_SERVER_ERROR, Json(serde_json::json!({"error": e.to_string()}))))?;
    Ok(Json(serde_json::json!({"schedule": row})))
}

#[derive(Deserialize)]
pub struct UpdateScheduleRequest {
    pub status: Option<String>,
    pub manual_override: Option<bool>,
}

pub async fn update(
    State(state): State<Arc<AppState>>,
    headers: axum::http::HeaderMap,
    Path(id): Path<i64>,
    Json(req): Json<UpdateScheduleRequest>,
) -> Result<Json<serde_json::Value>, (axum::http::StatusCode, Json<serde_json::Value>)> {
    uid(&headers, &state)?;
    if let Some(status) = &req.status {
        sqlx::query("UPDATE study_schedule SET status = ?1 WHERE id = ?2")
            .bind(status).bind(id).execute(&state.db).await
            .map_err(|e| (axum::http::StatusCode::INTERNAL_SERVER_ERROR, Json(serde_json::json!({"error": e.to_string()}))))?;
    }
    if let Some(ov) = req.manual_override {
        sqlx::query("UPDATE study_schedule SET manual_override = ?1 WHERE id = ?2")
            .bind(ov).bind(id).execute(&state.db).await
            .map_err(|e| (axum::http::StatusCode::INTERNAL_SERVER_ERROR, Json(serde_json::json!({"error": e.to_string()}))))?;
    }
    Ok(Json(serde_json::json!({"ok": true})))
}