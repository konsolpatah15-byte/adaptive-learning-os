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
    // The seed migration creates user id 1 with a PLACEHOLDER hash so baseline
    // evidence (assessment_results, mistake_bank) can reference it via FK.
    // Never delete that row — UPDATE the hash in place so all historical
    // learning data survives (spec: no silent deletion of learning history).
    let placeholder = sqlx::query_scalar::<_, i64>(
        "SELECT COUNT(*) FROM users WHERE password_hash LIKE '$argon2id%AAAAAAAAAAA%'"
    ).fetch_one(pool).await?;

    let existing = sqlx::query_scalar::<_, i64>("SELECT COUNT(*) FROM users")
        .fetch_one(pool).await?;

    if existing > 0 && placeholder == 0 {
        return Ok(()); // real user already bootstrapped
    }

    use argon2::{PasswordHasher, Argon2};
    use argon2::password_hash::SaltString;

    // Password: env override, else persisted random secret (chmod 600, gitignored),
    // else generate once. Never log the password or its hash.
    let pw_file = std::path::Path::new("database/.bootstrap_password");
    let password = match std::env::var("ALOS_ADMIN_PASSWORD") {
        Ok(p) if !p.is_empty() && p != "learner123" => p,
        _ => {
            if let Ok(p) = std::fs::read_to_string(pw_file) {
                p.trim().to_string()
            } else {
                use rand::Rng;
                let p: String = rand::thread_rng()
                    .sample_iter(&rand::distributions::Alphanumeric)
                    .take(16).map(char::from).collect();
                std::fs::write(pw_file, &p)?;
                #[cfg(unix)]
                {
                    use std::os::unix::fs::PermissionsExt;
                    std::fs::set_permissions(pw_file, std::fs::Permissions::from_mode(0o600))?;
                }
                tracing::info!("Bootstrap password generated at database/.bootstrap_password");
                p
            }
        }
    };

    let salt = SaltString::generate(&mut rand::thread_rng());
    let hash = Argon2::default()
        .hash_password(password.as_bytes(), &salt)
        .map_err(|e| anyhow::anyhow!("argon2: {}", e))?
        .to_string();

    if placeholder > 0 {
        sqlx::query("UPDATE users SET password_hash = ?1 WHERE password_hash LIKE '$argon2id%AAAAAAAAAAA%'")
            .bind(&hash)
            .execute(pool).await?;
        tracing::info!("Placeholder credentials replaced in place; baseline evidence preserved");
    } else {
        sqlx::query(
            "INSERT INTO users (username, password_hash, display_name, role) VALUES (?1, ?2, ?3, ?4)"
        )
        .bind("learner").bind(&hash).bind("Learner").bind("learner")
        .execute(pool).await?;
        tracing::info!("Default learner user created (username: learner)");
    }

    // Seed goals only if missing (idempotent across restarts)
    let goal_count = sqlx::query_scalar::<_, i64>("SELECT COUNT(*) FROM goals WHERE user_id = 1")
        .fetch_one(pool).await?;
    if goal_count == 0 {
        sqlx::query("INSERT INTO goals (user_id, track, title, target_date, date_is_tentative) VALUES (1, 'ielts', 'IELTS Academic Band 7.0-8.0', '2027-05-20', 1)").execute(pool).await?;
        sqlx::query("INSERT INTO goals (user_id, track, title, date_is_tentative) VALUES (1, 'snbt', 'SNBT 2027 — all 7 subtests, PU first', 1)").execute(pool).await?;
        tracing::info!("Default goals created");
    }

    Ok(())
}