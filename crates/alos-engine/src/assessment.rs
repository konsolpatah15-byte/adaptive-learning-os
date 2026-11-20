//! Assessment engine — lightweight checks, not full exams (anti-boredom policy).

/// Determine whether to ask a verification question after teaching.
/// Returns (should_ask, max_questions, question_difficulty).
pub fn should_verify(
    previous_mastery: f64,
    questions_this_session: i32,
    max_before_reexplain: i32,
    _teach_before_test: bool,
    session_mode: &str,
) -> (bool, i32, i64)
{
    // Never test in pure explanation mode
    if session_mode == "explanation" {
        return (false, 0, 0);
    }

    // Respect the max-questions-before-reexplain limit
    if questions_this_session >= max_before_reexplain {
        return (false, 0, 0);
    }

    // Low mastery: teach more, test less
    if previous_mastery < 30.0 && questions_this_session >= 1 {
        return (false, 0, 0);
    }

    // High mastery: occasional verification
    if previous_mastery > 75.0 && questions_this_session >= 2 {
        return (false, 0, 0);
    }

    // Determine appropriate difficulty
    let difficulty: i64 = if previous_mastery < 30.0 { 1 }
        else if previous_mastery < 60.0 { 2 }
        else if previous_mastery < 80.0 { 3 }
        else { 4 };

    let max_q = if questions_this_session == 0 { 2 } else { 1 };

    (true, max_q, difficulty)
}

/// Score a single answer: 0.0–1.0 normalized.
pub fn score_answer(correct: bool, difficulty: i64, independent: bool) -> f64 {
    if !correct { return 0.0; }
    let base = 1.0;
    let difficulty_bonus = (difficulty as f64 - 1.0) * 0.1;
    let independence_bonus = if independent { 0.1 } else { 0.0 };
    (base + difficulty_bonus + independence_bonus).min(1.0)
}