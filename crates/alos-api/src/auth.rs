//! JWT authentication — token creation, verification, middleware.

use axum::{
    extract::State,
    http::{Request, StatusCode, HeaderMap},
    middleware::Next,
    response::Response,
    Json,
};
use jsonwebtoken::{encode, decode, Header, Validation, EncodingKey, DecodingKey};
use serde::{Deserialize, Serialize};
use std::sync::Arc;
use crate::state::AppState;

const BEARER_PREFIX: &str = "Bearer ";

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct Claims {
    pub sub: i64,
    pub username: String,
    pub exp: usize,
}

pub fn create_token(user_id: i64, username: &str, secret: &str, ttl_hours: i64) -> Result<String, jsonwebtoken::errors::Error> {
    let now = chrono::Utc::now();
    let exp = (now + chrono::Duration::hours(ttl_hours)).timestamp() as usize;
    let claims = Claims { sub: user_id, username: username.into(), exp };
    encode(&Header::default(), &claims, &EncodingKey::from_secret(secret.as_bytes()))
}

pub fn verify_token(token: &str, secret: &str) -> Result<Claims, jsonwebtoken::errors::Error> {
    let data = decode::<Claims>(token, &DecodingKey::from_secret(secret.as_bytes()), &Validation::default())?;
    Ok(data.claims)
}

pub fn extract_bearer(headers: &HeaderMap) -> Option<&str> {
    headers.get("Authorization")
        .and_then(|v| v.to_str().ok())
        .and_then(|v| v.strip_prefix(BEARER_PREFIX))
}

/// Verify JWT and inject claims into request extensions. Returns 401 on failure.
pub async fn require_auth(
    State(state): State<Arc<AppState>>,
    mut request: Request<axum::body::Body>,
    next: Next,
) -> Result<Response, (StatusCode, Json<serde_json::Value>)>
{
    let claims = extract_bearer(request.headers())
        .and_then(|t| verify_token(t, &state.config.jwt_secret).ok());
    
    match claims {
        Some(c) => {
            request.extensions_mut().insert(c);
            Ok(next.run(request).await)
        }
        None => Err((
            StatusCode::UNAUTHORIZED,
            Json(serde_json::json!({"error": "invalid or missing token"})),
        )),
    }
}

/// Verify password against argon2 hash.
pub fn verify_password(hash: &str, password: &str) -> bool {
    use argon2::{PasswordHash, PasswordVerifier};
    let parsed = match PasswordHash::new(hash) {
        Ok(p) => p,
        Err(e) => {
            tracing::error!(error = %e, hash = %hash, "failed to parse password hash");
            return false;
        }
    };
    let result = argon2::Argon2::default().verify_password(password.as_bytes(), &parsed);
    if let Err(ref e) = result {
        tracing::warn!(error = %e, "password verification failed");
    }
    result.is_ok()
}

/// Hash a password with argon2.
pub fn hash_password(password: &str) -> Result<String, argon2::password_hash::Error> {
    use argon2::{PasswordHasher, Argon2};
    use argon2::password_hash::SaltString;
    use rand::Rng;
    let mut rng = rand::thread_rng();
    let salt = SaltString::generate(&mut rng);
    let hash = Argon2::default().hash_password(password.as_bytes(), &salt)?;
    Ok(hash.to_string())
}

#[cfg(test)]
mod tests {
    #[test]
    fn test_hash_verify() {
        use argon2::{PasswordHasher, PasswordVerifier, Argon2, PasswordHash};
        use argon2::password_hash::SaltString;
        use rand::Rng;

        let password = "test1234";
        let mut rng = rand::thread_rng();
        let salt = SaltString::generate(&mut rng);
        let hash = Argon2::default()
            .hash_password(password.as_bytes(), &salt)
            .unwrap()
            .to_string();

        eprintln!("Hash: {}", hash);

        let parsed = PasswordHash::new(&hash).unwrap();
        let valid = Argon2::default()
            .verify_password(password.as_bytes(), &parsed)
            .is_ok();

        eprintln!("Valid: {}", valid);
        assert!(valid, "roundtrip failed");
    }

    #[test]
    fn test_verify_db_hash() {
        use argon2::{PasswordVerifier, Argon2, PasswordHash};

        // This hash was stored by the bootstrap
        let hash = "$argon2id$v=19$m=19456,t=2,p=1$1QJHCzn6EWTb83ohrWjx9w$wlNMQLCz7SdaB3RQUXij+VyNTxhtWtYXZP6MUfQmmn0";
        let password = "learner123";

        let parsed = PasswordHash::new(hash);
        eprintln!("Parse result: {:?}", parsed.is_ok());
        if let Ok(p) = parsed {
            let valid = Argon2::default()
                .verify_password(password.as_bytes(), &p)
                .is_ok();
            eprintln!("Verification: {}", valid);
            assert!(valid, "DB hash verification failed");
        } else {
            panic!("Failed to parse hash: {:?}", parsed.err());
        }
    }
}