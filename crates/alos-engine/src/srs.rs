//! Spaced Repetition engine (Section 12).

/// SRS card state.
#[derive(Debug, Clone)]
pub struct SrsCard {
    pub interval_days: f64,
    pub repetitions: i64,
    pub streak: i64,
    pub ease_factor: f64,
}

impl Default for SrsCard {
    fn default() -> Self {
        Self { interval_days: 1.0, repetitions: 0, streak: 0, ease_factor: 2.5 }
    }
}

/// Process a review result and return updated interval info.
/// Returns (new_interval_days, new_streak).
pub fn process_review(card: &SrsCard, remembered: bool) -> (f64, i64) {
    if remembered {
        let new_streak = card.streak + 1;
        let interval = if card.repetitions == 0 {
            3.0  // 1 → 3 days
        } else {
            (card.interval_days * card.ease_factor).min(365.0)
        };
        (interval, new_streak)
    } else {
        // Forgotten: reset to 1 day, halve ease factor
        (1.0, 0)
    }
}

/// Standard intervals for the review queue.
pub const DEFAULT_INTERVALS: &[f64] = &[1.0, 3.0, 7.0, 14.0, 30.0];

/// Compute the next review date from an interval in days.
pub fn next_review_date(interval_days: f64) -> String {
    let now = chrono::Utc::now();
    let next = now + chrono::Duration::days(interval_days as i64);
    next.format("%Y-%m-%dT%H:%M:%SZ").to_string()
}