//! GET /api/snbt/progress | GET /api/snbt/subtests

use axum::{extract::State, Json};
use std::sync::Arc;
use crate::state::AppState;

pub async fn progress(
    State(state): State<Arc<AppState>>,
) -> Result<Json<serde_json::Value>, (axum::http::StatusCode, Json<serde_json::Value>)> {
    let subjects = alos_modules::snbt::subjects();
    let mut subtests = Vec::new();
    for subj in &subjects {
        let mut comps = Vec::new();
        for c in &subj.competencies {
            if let Ok(Some(db_comp)) = alos_db::repo::get_competency(&state.db, &c.code).await {
                comps.push(serde_json::json!({
                    "code": c.code, "name": c.name, "name_id": c.name_id,
                    "mastery": db_comp.mastery, "confidence": db_comp.confidence,
                    "status": db_comp.status,
                }));
            } else {
                comps.push(serde_json::json!({"code": c.code, "name": c.name, "mastery": 0.0, "status": "new"}));
            }
        }
        subtests.push(serde_json::json!({"code": subj.code, "name": subj.name, "competencies": comps}));
    }
    Ok(Json(serde_json::json!({"track": "snbt", "subtests": subtests})))
}

pub async fn subtests() -> Json<serde_json::Value> {
    Json(serde_json::json!({
        "track": "snbt",
        "subtests": alos_modules::snbt::subjects(),
    }))
}