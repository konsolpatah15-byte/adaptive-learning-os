//! AppState — shared application state injected into all route handlers.

use sqlx::SqlitePool;
use std::sync::Arc;

/// Central application state.
pub struct AppState {
    pub db: SqlitePool,
    pub config: Arc<AppConfig>,
}

/// Non-secret configuration loaded at startup.
#[derive(Debug, Clone)]
pub struct AppConfig {
    pub timezone: String,
    pub language_default: String,
    pub jwt_secret: String,
    pub db_path: String,
    pub backup_dir: String,
}

impl AppState {
    pub fn new(db: SqlitePool, config: AppConfig) -> Self {
        Self { db, config: Arc::new(config) }
    }
}