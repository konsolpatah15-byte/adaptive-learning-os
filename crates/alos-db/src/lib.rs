//! alos-db — SQLite models, migrations, and repository layer.
//!
//! All 13 tables per the ALOS 2.0 schema. Uses sqlx with compile-time query checking.

pub mod models;
pub mod repo;
pub mod migrate;

use sqlx::sqlite::{SqliteConnectOptions, SqlitePoolOptions};
use sqlx::SqlitePool;
use std::path::Path;
use std::str::FromStr;

/// Open (or create) the SQLite database with WAL mode and foreign keys enabled.
pub async fn open(path: &Path) -> Result<SqlitePool, sqlx::Error> {
    if let Some(parent) = path.parent() {
        tokio::fs::create_dir_all(parent).await.ok();
    }
    let opts = SqliteConnectOptions::from_str(&format!("sqlite:{}", path.display()))?
        .create_if_missing(true)
        .foreign_keys(true)
        .journal_mode(sqlx::sqlite::SqliteJournalMode::Wal)
        .busy_timeout(std::time::Duration::from_secs(5));

    let pool = SqlitePoolOptions::new()
        .max_connections(5)
        .connect_with(opts)
        .await?;

    // Run migrations
    migrate::run(&pool).await?;

    Ok(pool)
}