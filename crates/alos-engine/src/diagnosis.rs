//! Diagnosis engine — classify errors into 9 root-cause categories.

use crate::RootCause;

/// Diagnose the most likely root cause from observation data.
/// Uses simple heuristics; the real system would analyze patterns across multiple answers.
pub fn diagnose(correct: bool, question: &str, learner_answer: &str, correct_answer: &str,
                difficulty: i64, _independent: bool, previous_mastery: f64) -> RootCause
{
    if correct {
        // No error to diagnose — but if past mastery was low, this is progress
        return if previous_mastery < 30.0 { RootCause::ConceptualMisunderstanding }
               else { RootCause::Unknown };
    }

    let la = learner_answer.trim().to_lowercase();
    let ca = correct_answer.trim().to_lowercase();
    let q = question.to_lowercase();

    // Careless mistake: answer is close but off by small detail (sign, unit, spelling)
    if edit_distance_ratio(&la, &ca) < 0.25 && la.len() > 1 {
        return RootCause::CarelessMistake;
    }

    // Calculation error: numeric question, answers differ numerically
    if is_numeric(&q) && la.chars().any(|c| c.is_numeric()) {
        return RootCause::CalculationError;
    }

    // Misreading: answer addresses a different aspect than the question
    if keyword_overlap(&la, &q) < 0.3 && keyword_overlap(&la, &ca) < 0.3 {
        return RootCause::Misreading;
    }

    // Vocabulary: learner answer is short and uses imprecise terms
    if la.split_whitespace().count() < 3 && !is_numeric(&q) {
        return RootCause::VocabularyLimitation;
    }

    // Grammar: English questions with clear grammar issues
    if q.contains("tense") || q.contains("verb") || q.contains("article") || q.contains("subject") {
        return RootCause::GrammarError;
    }

    // Logical: reasoning/math/logic questions
    if q.contains("reason") || q.contains("logic") || q.contains("infer") || q.contains("therefore")
        || q.contains("conclusion") || q.contains("pattern") {
        return RootCause::LogicalReasoningError;
    }

    // Background knowledge: difficult question, learner has low prior mastery
    if difficulty >= 4 && previous_mastery < 40.0 {
        return RootCause::InsufficientBackgroundKnowledge;
    }

    // Default: conceptual gap
    RootCause::ConceptualMisunderstanding
}

fn edit_distance_ratio(a: &str, b: &str) -> f64 {
    if a.is_empty() && b.is_empty() { return 0.0; }
    let max_len = a.len().max(b.len()) as f64;
    if max_len == 0.0 { return 0.0; }
    let dist = edit_distance(a, b) as f64;
    dist / max_len
}

fn edit_distance(a: &str, b: &str) -> usize {
    let a_chars: Vec<char> = a.chars().collect();
    let b_chars: Vec<char> = b.chars().collect();
    let mut prev = (0..=b_chars.len()).collect::<Vec<_>>();
    let mut curr = vec![0; b_chars.len() + 1];
    for (i, ca) in a_chars.iter().enumerate() {
        curr[0] = i + 1;
        for (j, cb) in b_chars.iter().enumerate() {
            let cost = if ca == cb { 0 } else { 1 };
            curr[j + 1] = (prev[j + 1] + 1).min(curr[j] + 1).min(prev[j] + cost);
        }
        std::mem::swap(&mut prev, &mut curr);
    }
    prev[b_chars.len()]
}

fn is_numeric(s: &str) -> bool {
    s.contains(|c: char| c.is_ascii_digit())
}

fn keyword_overlap(a: &str, b: &str) -> f64 {
    let wa: std::collections::HashSet<_> = a.split_whitespace().collect();
    let wb: std::collections::HashSet<_> = b.split_whitespace().collect();
    if wa.is_empty() || wb.is_empty() { return 0.0; }
    let intersection = wa.intersection(&wb).count() as f64;
    intersection / wa.len().min(wb.len()) as f64
}