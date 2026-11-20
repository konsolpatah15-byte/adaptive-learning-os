#[cfg(test)]
mod tests {
    #[test]
    fn test_hash_verify_roundtrip() {
        use argon2::{PasswordHasher, PasswordVerifier, Argon2, PasswordHash};
        use argon2::password_hash::SaltString;
        use rand::Rng;

        let password = "learner123";
        let mut rng = rand::thread_rng();
        let salt = SaltString::generate(&mut rng);
        let hash = Argon2::default()
            .hash_password(password.as_bytes(), &salt)
            .unwrap()
            .to_string();

        println!("Hash: {}", hash);

        let parsed = PasswordHash::new(&hash).unwrap();
        let valid = Argon2::default()
            .verify_password(password.as_bytes(), &parsed)
            .is_ok();

        assert!(valid, "Password verification failed!");
        println!("Verification: OK");
    }
}