//! alos-api — Axum REST API server for Adaptive Learning OS 2.0.
//!
//! All 10 API groups (25 endpoints) per Section 17 of the ALOS prompt.

mod routes;
mod auth;
pub mod state;
mod hermes_bridge;

use axum::{Router, routing::get};
use tower_http::cors::{CorsLayer, Any};
use std::sync::Arc;

pub use state::AppState;

/// Build the full router with all routes and middleware.
pub fn build_router(state: Arc<AppState>) -> Router {
    let cors = CorsLayer::new()
        .allow_origin(Any)
        .allow_methods(Any)
        .allow_headers(Any);

    Router::new()
        // ── Auth ──
        .route("/api/auth/login", axum::routing::post(routes::auth::login))
        .route("/api/auth/logout", axum::routing::post(routes::auth::logout))
        .route("/api/auth/me", axum::routing::get(routes::auth::me))
        // ── Dashboard ──
        .route("/api/dashboard", axum::routing::get(routes::dashboard::dashboard))
        .route("/api/dashboard/summary", axum::routing::get(routes::dashboard::summary))
        // ── Tutor ──
        .route("/api/tutor/chat", axum::routing::post(routes::tutor::chat))
        .route("/api/tutor/history", axum::routing::get(routes::tutor::history))
        .route("/api/tutor/feedback", axum::routing::post(routes::tutor::feedback))
        // ── Learning ──
        .route("/api/learning/sessions", axum::routing::get(routes::learning::list_sessions))
        .route("/api/learning/sessions", axum::routing::post(routes::learning::create_session))
        .route("/api/learning/recommendations", axum::routing::get(routes::learning::recommendations))
        // ── Competencies ──
        .route("/api/competencies", axum::routing::get(routes::competencies::list_all))
        .route("/api/competencies/{code}", axum::routing::get(routes::competencies::get_one))
        .route("/api/competencies/{code}", axum::routing::patch(routes::competencies::update))
        // ── IELTS ──
        .route("/api/ielts/progress", axum::routing::get(routes::ielts::progress))
        .route("/api/ielts/skills", axum::routing::get(routes::ielts::skills))
        // ── SNBT ──
        .route("/api/snbt/progress", axum::routing::get(routes::snbt::progress))
        .route("/api/snbt/subtests", axum::routing::get(routes::snbt::subtests))
        // ── Analytics ──
        .route("/api/analytics/progress", axum::routing::get(routes::analytics::progress))
        .route("/api/analytics/weaknesses", axum::routing::get(routes::analytics::weaknesses))
        // ── Mistakes ──
        .route("/api/mistakes", axum::routing::get(routes::mistakes::list))
        .route("/api/mistakes", axum::routing::post(routes::mistakes::create))
        .route("/api/mistakes/{id}", axum::routing::patch(routes::mistakes::resolve))
        // ── Schedule ──
        .route("/api/schedule", axum::routing::get(routes::schedule::get))
        .route("/api/schedule", axum::routing::post(routes::schedule::create))
        .route("/api/schedule/{id}", axum::routing::patch(routes::schedule::update))
        // ── Health ──
        .route("/health", get(|| async { "ALOS 2.0 — OK" }))
        .layer(cors)
        .with_state(state)
}

/// Start the server.
pub async fn serve(state: Arc<AppState>, host: &str, port: u16) -> Result<(), anyhow::Error> {
    let app = build_router(state);
    let addr = format!("{}:{}", host, port);
    tracing::info!("ALOS API listening on {}", addr);
    let listener = tokio::net::TcpListener::bind(&addr).await?;
    axum::serve(listener, app).await?;
    Ok(())
}