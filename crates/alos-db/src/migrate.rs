//! SQLx migrator — runs embedded migrations on startup.

use sqlx::sqlite::SqlitePool;
use sqlx::migrate::Migrator;
use std::path::Path;

static MIGRATOR: Migrator = sqlx::migrate!("./migrations");

/// Run all pending migrations, creating the db if needed.
pub async fn run(pool: &SqlitePool) -> Result<(), sqlx::migrate::MigrateError> {
    MIGRATOR.run(pool).await?;
    tracing::info!("database migrations complete");
    Ok(())
}

/// Create a backup of the current database to the given directory.
pub async fn backup(pool: &SqlitePool, backup_dir: &Path) -> Result<String, anyhow::Error> {
    let ts = chrono::Utc::now().format("%Y%m%dT%H%M%SZ");
    let name = format!("alos_backup_{}.db", ts);
    let dest = backup_dir.join(&name);

    tokio::fs::create_dir_all(backup_dir).await?;

    // Use SQLite backup API via sqlx
    sqlx::query("VACUUM INTO ?1")
        .bind(dest.to_string_lossy().to_string())
        .execute(pool)
        .await?;

    tracing::info!(path = %dest.display(), "database backup created");
    Ok(dest.to_string_lossy().to_string())
}