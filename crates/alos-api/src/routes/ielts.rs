//! GET /api/ielts/progress | GET /api/ielts/skills

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
    uid(&headers, &state)?;
    // Return all IELTS competency progress
    let subjects = alos_modules::ielts::subjects();
    let mut skills = Vec::new();
    for subj in &subjects {
        let mut comps = Vec::new();
        for c in &subj.competencies {
            if let Ok(Some(db_comp)) = alos_db::repo::get_competency(&state.db, &c.code).await {
                comps.push(serde_json::json!({
                    "code": c.code, "name": c.name, "name_id": c.name_id,
                    "mastery": db_comp.mastery, "confidence": db_comp.confidence,
                    "status": db_comp.status, "last_practiced_at": db_comp.last_practiced_at,
                }));
            } else {
                comps.push(serde_json::json!({"code": c.code, "name": c.name, "mastery": 0.0, "status": "new"}));
            }
        }
        skills.push(serde_json::json!({"subject": subj.code, "name": subj.name, "competencies": comps}));
    }
    Ok(Json(serde_json::json!({"track": "ielts", "skills": skills})))
}

pub async fn skills(
    headers: axum::http::HeaderMap,
) -> Result<Json<serde_json::Value>, (axum::http::StatusCode, Json<serde_json::Value>)> {
    // This endpoint doesn't require auth — it returns the curriculum definitions
    Ok(Json(serde_json::json!({
        "track": "ielts",
        "subjects": alos_modules::ielts::subjects(),
    })))
}