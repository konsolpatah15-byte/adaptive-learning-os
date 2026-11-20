//! POST /api/auth/login | POST /api/auth/logout | GET /api/auth/me

use axum::{extract::State, Json};
use serde::{Deserialize, Serialize};
use std::sync::Arc;
use crate::state::AppState;
use crate::auth as auth_mod;

#[derive(Deserialize)]
pub struct LoginRequest {
    pub username: String,
    pub password: String,
}

#[derive(Serialize)]
pub struct LoginResponse {
    pub token: String,
    pub user_id: i64,
    pub display_name: String,
}

pub async fn login(
    State(state): State<Arc<AppState>>,
    Json(req): Json<LoginRequest>,
) -> Result<Json<LoginResponse>, (axum::http::StatusCode, Json<serde_json::Value>)>
{
    let user = alos_db::repo::get_user_by_username(&state.db, &req.username)
        .await
        .map_err(|e| {
            tracing::error!(error = %e, "db error looking up user");
            (axum::http::StatusCode::INTERNAL_SERVER_ERROR, Json(serde_json::json!({"error": e.to_string()})))
        })?
        .ok_or_else(|| {
            tracing::warn!(username = %req.username, "user not found");
            (axum::http::StatusCode::UNAUTHORIZED, Json(serde_json::json!({"error": "invalid credentials"})))
        })?;

    // Verify password
    let valid = auth_mod::verify_password(&user.password_hash, &req.password);
    tracing::info!(user_id = user.id, hash_len = user.password_hash.len(), valid = valid, "password check");
    if !valid {
        return Err((axum::http::StatusCode::UNAUTHORIZED, Json(serde_json::json!({"error": "invalid credentials"}))));
    }

    let token = auth_mod::create_token(user.id, &user.username, &state.config.jwt_secret, 168)
        .map_err(|e| (axum::http::StatusCode::INTERNAL_SERVER_ERROR, Json(serde_json::json!({"error": e.to_string()}))))?;

    Ok(Json(LoginResponse { token, user_id: user.id, display_name: user.display_name }))
}

pub async fn logout() -> Json<serde_json::Value> {
    Json(serde_json::json!({"ok": true}))
}

pub async fn me(
    State(state): State<Arc<AppState>>,
    headers: axum::http::HeaderMap,
) -> Result<Json<serde_json::Value>, (axum::http::StatusCode, Json<serde_json::Value>)>
{
    let claims = auth_mod::extract_bearer(&headers)
        .and_then(|t| auth_mod::verify_token(t, &state.config.jwt_secret).ok())
        .ok_or_else(|| (axum::http::StatusCode::UNAUTHORIZED, Json(serde_json::json!({"error": "unauthorized"}))))?;

    let user = alos_db::repo::get_user(&state.db, claims.sub)
        .await.map_err(|e| (axum::http::StatusCode::INTERNAL_SERVER_ERROR, Json(serde_json::json!({"error": e.to_string()}))))?
        .ok_or_else(|| (axum::http::StatusCode::NOT_FOUND, Json(serde_json::json!({"error": "user not found"}))))?;

    Ok(Json(serde_json::json!({
        "id": user.id,
        "username": user.username,
        "display_name": user.display_name,
        "role": user.role,
    })))
}