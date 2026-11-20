//! ALOS 2.0 API server entry point — with user bootstrapping.

use alos_api::{AppState, state::AppConfig};
use std::sync::Arc;

#[tokio::main]
async fn main() -> Result<(), anyhow::Error> {
    tracing_subscriber::fmt()
        .with_env_filter(tracing_subscriber::EnvFilter::from_default_env())
        .init();

    tracing::info!("ALOS 2.0 starting...");

    let db_path = std::env::var("ALOS_DB_PATH").unwrap_or_else(|_| "database/alos.db".into());
    let db = alos_db::open(&std::path::PathBuf::from(&db_path)).await?;

    // Bootstrap default user if none exists
    bootstrap_user(&db).await?;

    let config = AppConfig {
        timezone: "Asia/Jakarta".into(),
        language_default: "id".into(),
        jwt_secret: std::env::var("ALOS_SECRET_KEY").unwrap_or_else(|_| "dev-secret-change-me".into()),
        db_path,
        backup_dir: "database/backups".into(),
    };

    let state = Arc::new(AppState::new(db, config));

    let host = std::env::var("ALOS_HOST").unwrap_or_else(|_| "127.0.0.1".into());
    let port: u16 = std::env::var("ALOS_PORT").unwrap_or_else(|_| "8000".into()).parse()?;

    alos_api::serve(state, &host, port).await?;

    Ok(())
}

async fn bootstrap_user(pool: &sqlx::SqlitePool) -> Result<(), anyhow::Error> {
    // Check if a real user exists (not the placeholder from seed migration)
    let placeholder = sqlx::query_scalar::<_, i64>(
        "SELECT COUNT(*) FROM users WHERE password_hash LIKE '$argon2id%AAAAAAAAAAA%'"
    ).fetch_one(pool).await?;

    if placeholder > 0 {
        // Delete placeholder user so we can create a real one
        // (FK constraints: goals/mistakes reference user 1, but we recreate immediately)
        sqlx::query("DELETE FROM assessment_results WHERE user_id IN (SELECT id FROM users WHERE password_hash LIKE '$argon2id%AAAAAAAAAAA%')").execute(pool).await?;
        sqlx::query("DELETE FROM goals WHERE user_id IN (SELECT id FROM users WHERE password_hash LIKE '$argon2id%AAAAAAAAAAA%')").execute(pool).await?;
        sqlx::query("DELETE FROM mistake_bank WHERE user_id IN (SELECT id FROM users WHERE password_hash LIKE '$argon2id%AAAAAAAAAAA%')").execute(pool).await?;
        sqlx::query("DELETE FROM users WHERE password_hash LIKE '$argon2id%AAAAAAAAAAA%'").execute(pool).await?;
        tracing::info!("Placeholder user removed, creating real user...");
    }

    let existing = sqlx::query_scalar::<_, i64>("SELECT COUNT(*) FROM users")
        .fetch_one(pool).await?;
    if existing > 0 {
        return Ok(());
    }

    use argon2::{PasswordHasher, Argon2};
    use argon2::password_hash::SaltString;
    use rand::Rng;

    let password = std::env::var("ALOS_ADMIN_PASSWORD").unwrap_or_else(|_| "learner123".into());
    let mut rng = rand::thread_rng();
    let salt = SaltString::generate(&mut rng);
    let hash = Argon2::default()
        .hash_password(password.as_bytes(), &salt)
        .map_err(|e| anyhow::anyhow!("argon2: {}", e))?
        .to_string();

    tracing::info!(hash_len = hash.len(), hash = %hash, "created password hash");

    sqlx::query(
        "INSERT INTO users (username, password_hash, display_name, role) VALUES (?1, ?2, ?3, ?4)"
    )
    .bind("learner")
    .bind(&hash)
    .bind("Learner")
    .bind("learner")
    .execute(pool).await?;

    tracing::info!("Default learner user created (username: learner)");

    // Seed goals
    sqlx::query("INSERT INTO goals (user_id, track, title, target_date, date_is_tentative) VALUES (1, 'ielts', 'IELTS Academic Band 7.0-8.0', '2027-05-20', 1)").execute(pool).await?;
    sqlx::query("INSERT INTO goals (user_id, track, title, date_is_tentative) VALUES (1, 'snbt', 'SNBT 2027 — all 7 subtests, PU first', 1)").execute(pool).await?;
    tracing::info!("Default goals created");

    Ok(())
}