//! GET /api/competencies | GET/PATCH /api/competencies/{code}

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

pub async fn list_all(
    axum::extract::Query(params): axum::extract::Query<std::collections::HashMap<String, String>>,
) -> Json<serde_json::Value> {
    let track = params.get("track").map(|s| s.as_str()).unwrap_or("ielts");
    let subjects = alos_modules::subjects_for_track(track);
    Json(serde_json::json!({"track": track, "subjects": subjects}))
}

pub async fn get_one(
    State(state): State<Arc<AppState>>,
    headers: axum::http::HeaderMap,
    Path(code): Path<String>,
) -> Result<Json<serde_json::Value>, (axum::http::StatusCode, Json<serde_json::Value>)> {
    uid(&headers, &state)?;
    let comp = alos_db::repo::get_competency(&state.db, &code).await
        .map_err(|e| (axum::http::StatusCode::INTERNAL_SERVER_ERROR, Json(serde_json::json!({"error": e.to_string()}))))?
        .ok_or_else(|| (axum::http::StatusCode::NOT_FOUND, Json(serde_json::json!({"error": "competency not found"}))))?;
    Ok(Json(serde_json::json!({"competency": comp})))
}

#[derive(Deserialize)]
pub struct UpdateCompetencyRequest {
    pub mastery: Option<f64>,
    pub confidence: Option<f64>,
    pub status: Option<String>,
}

pub async fn update(
    State(state): State<Arc<AppState>>,
    headers: axum::http::HeaderMap,
    Path(code): Path<String>,
    Json(req): Json<UpdateCompetencyRequest>,
) -> Result<Json<serde_json::Value>, (axum::http::StatusCode, Json<serde_json::Value>)> {
    uid(&headers, &state)?;
    let mastery = req.mastery.unwrap_or(0.0);
    let confidence = req.confidence.unwrap_or(0.0);
    let status = req.status.as_deref().unwrap_or("learning");
    alos_db::repo::update_competency_mastery(&state.db, &code, mastery, confidence, status).await
        .map_err(|e| (axum::http::StatusCode::INTERNAL_SERVER_ERROR, Json(serde_json::json!({"error": e.to_string()}))))?;
    Ok(Json(serde_json::json!({"ok": true})))
}