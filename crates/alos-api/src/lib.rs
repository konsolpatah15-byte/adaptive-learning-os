//! alos-api — Axum REST API server for Adaptive Learning OS 2.0.

mod routes;
mod auth;
pub mod state;
mod hermes_bridge;

use axum::{Router, routing::get, middleware};
use tower_http::cors::CorsLayer;
use std::sync::Arc;

pub use state::AppState;

/// Build the full router: public routes + auth-gated protected routes.
pub fn build_router(state: Arc<AppState>) -> Router {
    let cors = CorsLayer::permissive(); // For development; tighten in production via env

    // ── Public routes (no auth required) ──
    let public = Router::new()
        .route("/health", get(|| async { "ALOS 2.0 — OK" }))
        .route("/api/auth/login", axum::routing::post(routes::auth::login))
        .route("/api/auth/logout", axum::routing::post(routes::auth::logout))
        .route("/api/competencies", axum::routing::get(routes::competencies::list_all))
        .route("/api/ielts/skills", axum::routing::get(routes::ielts::skills))
        .route("/api/snbt/subtests", axum::routing::get(routes::snbt::subtests));

    // ── Protected routes (JWT required) ──
    let protected = Router::new()
        .route("/api/auth/me", axum::routing::get(routes::auth::me))
        .route("/api/dashboard", axum::routing::get(routes::dashboard::dashboard))
        .route("/api/dashboard/summary", axum::routing::get(routes::dashboard::summary))
        .route("/api/tutor/chat", axum::routing::post(routes::tutor::chat))
        .route("/api/tutor/history", axum::routing::get(routes::tutor::history))
        .route("/api/tutor/feedback", axum::routing::post(routes::tutor::feedback))
        .route("/api/learning/sessions", axum::routing::get(routes::learning::list_sessions).post(routes::learning::create_session))
        .route("/api/learning/recommendations", axum::routing::get(routes::learning::recommendations))
        .route("/api/competencies/{code}", axum::routing::get(routes::competencies::get_one).patch(routes::competencies::update))
        .route("/api/ielts/progress", axum::routing::get(routes::ielts::progress))
        .route("/api/snbt/progress", axum::routing::get(routes::snbt::progress))
        .route("/api/analytics/progress", axum::routing::get(routes::analytics::progress))
        .route("/api/analytics/weaknesses", axum::routing::get(routes::analytics::weaknesses))
        .route("/api/mistakes", axum::routing::get(routes::mistakes::list).post(routes::mistakes::create))
        .route("/api/mistakes/{id}", axum::routing::patch(routes::mistakes::resolve))
        .route("/api/schedule", axum::routing::get(routes::schedule::get).post(routes::schedule::create))
        .route("/api/schedule/{id}", axum::routing::patch(routes::schedule::update))
        .layer(middleware::from_fn_with_state(state.clone(), auth::require_auth));

    Router::new()
        .merge(public)
        .merge(protected)
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