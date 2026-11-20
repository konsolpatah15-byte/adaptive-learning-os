//! Mastery engine — multi-factor competency scoring (Section 11).

use crate::MasteryTier;

/// 8-factor mastery update from a single observation.
/// Returns (new_mastery, new_confidence, tier_label).
pub fn update(
    current_mastery: f64,
    current_confidence: f64,
    correct: bool,
    difficulty: i64,
    independent: bool,
    confidence_self: Option<f64>,
) -> (f64, f64, String)
{
    // Factor weights (sum to ~1.0)
    let w_accuracy = 0.30;
    let w_difficulty = 0.10;
    let w_recency = 0.15;      // recent = higher weight (implicit: this IS recent)
    let w_repetition = 0.10;
    let w_retention = 0.10;
    let w_independence = 0.10;
    let w_confidence = 0.10;
    let w_context = 0.05;

    // Accuracy factor
    let acc_factor = if correct { 1.0 } else { -0.3 };

    // Difficulty factor: harder correct = bigger gain; harder wrong = smaller penalty
    let diff_factor = if correct {
        (difficulty as f64 / 5.0) * 0.05  // +0.01–0.05
    } else {
        -(difficulty as f64 / 5.0) * 0.02 // -0.004–-0.02
    };

    // Independence factor
    let ind_factor = if independent { 0.05 } else { 0.0 };

    // Confidence factor (learner's self-assessment accuracy)
    let conf_factor = match confidence_self {
        Some(cs) => {
            // Learner was accurate about their performance
            if (correct && cs > 50.0) || (!correct && cs < 50.0) { 0.03 }
            else { -0.02 }
        }
        None => 0.0,
    };

    // Retention factor: assume full retention on recent correct answer
    let ret_factor = if correct { 0.03 } else { 0.0 };

    // Repetition factor: implicit from evidence_count in DB; here we use a small constant
    let rep_factor = 0.02; // small positive for each observation

    // Context factor: small constant
    let ctx_factor = 0.01;

    // Weighted delta
    let delta = w_accuracy * acc_factor
              + w_difficulty * diff_factor
              + w_recency * (if correct { 0.04 } else { -0.02 })
              + w_repetition * rep_factor
              + w_retention * ret_factor
              + w_independence * ind_factor
              + w_confidence * conf_factor
              + w_context * ctx_factor;

    let new_mastery = (current_mastery + delta * 100.0).clamp(0.0, 100.0);

    // Confidence: tracks separately from mastery
    let confidence_delta = if correct { 3.0 } else { -5.0 };
    let new_confidence = (current_confidence + confidence_delta).clamp(0.0, 100.0);

    let tier = MasteryTier::from_score(new_mastery);

    (new_mastery, new_confidence, tier.to_status().to_string())
}