//! Adaptation engine (Section 9.7) — adjusts strategy, difficulty, and scheduling dynamically.

use crate::TeachingStrategy;

/// Learner behavior patterns.
#[derive(Debug, Clone)]
pub enum LearnerPattern {
    ConsistentlyStruggling,
    RapidlyImproving,
    Bored,
    Overconfident,
    Underconfident,
}

/// Adaptation decision: what to change based on recent performance.
#[derive(Debug, Clone)]
pub struct Adaptation {
    pub adjust_difficulty: i64,             // -1, 0, +1
    pub switch_strategy: Option<TeachingStrategy>,
    pub adjust_pace: f64,                   // multiplier on session time
    pub adjust_review_interval: f64,        // multiplier on SRS interval
    pub reason: String,
}

/// Detect learner patterns from recent session history.
pub fn detect_pattern(
    recent_accuracy: &[f64],
    feedback_signals: &[&str],
    confidence_gap: Option<f64>,
) -> LearnerPattern
{
    if feedback_signals.iter().any(|f| f.contains("too_many_tests") || f.contains("boring")) {
        return LearnerPattern::Bored;
    }
    if !recent_accuracy.is_empty() {
        let avg = recent_accuracy.iter().sum::<f64>() / recent_accuracy.len() as f64;
        if avg < 0.4 { return LearnerPattern::ConsistentlyStruggling; }
        if avg > 0.8 && recent_accuracy.len() >= 3 { return LearnerPattern::RapidlyImproving; }
    }
    if let Some(gap) = confidence_gap {
        if gap > 20.0 { return LearnerPattern::Overconfident; }
        if gap < -20.0 { return LearnerPattern::Underconfident; }
    }
    LearnerPattern::RapidlyImproving // default optimistic
}

/// Adapt strategy based on detected pattern.
pub fn adapt_strategy(
    current: TeachingStrategy,
    pattern: &LearnerPattern,
    same_count: i32,
) -> TeachingStrategy
{
    if same_count >= 3 {
        return match current {
            TeachingStrategy::DirectTeaching => TeachingStrategy::InteractiveDiscussion,
            TeachingStrategy::StepByStepDemonstration => TeachingStrategy::RealWorldScenario,
            TeachingStrategy::GuidedProblemSolving => TeachingStrategy::CaseStudy,
            _ => TeachingStrategy::Analogy,
        };
    }
    match pattern {
        LearnerPattern::ConsistentlyStruggling => TeachingStrategy::DirectTeaching,
        LearnerPattern::RapidlyImproving => TeachingStrategy::PracticalApplication,
        LearnerPattern::Bored => TeachingStrategy::InteractiveDiscussion,
        LearnerPattern::Overconfident => TeachingStrategy::GuidedProblemSolving,
        LearnerPattern::Underconfident => TeachingStrategy::StepByStepDemonstration,
    }
}

/// Main adaptation function — compute full adaptation from session data.
pub fn adapt(
    recent_correct: &[bool],
    recent_strategies: &[TeachingStrategy],
    current_mastery: f64,
    session_fatigue: bool,
    learner_request: Option<&str>,
) -> Adaptation
{
    if let Some(req) = learner_request {
        let r = req.to_lowercase();
        if r.contains("less") || r.contains("fewer") || r.contains("kurang") {
            return Adaptation {
                adjust_difficulty: -1,
                switch_strategy: Some(TeachingStrategy::InteractiveDiscussion),
                adjust_pace: 0.7, adjust_review_interval: 1.0,
                reason: "Learner requested reduced workload".into(),
            };
        }
        if r.contains("hard") || r.contains("challenge") {
            return Adaptation {
                adjust_difficulty: 1, switch_strategy: None,
                adjust_pace: 1.2, adjust_review_interval: 1.0,
                reason: "Learner requested more challenge".into(),
            };
        }
    }

    let total = recent_correct.len();
    let correct = recent_correct.iter().filter(|c| **c).count();
    let accuracy = if total > 0 { correct as f64 / total as f64 } else { 0.5 };

    if session_fatigue {
        return Adaptation {
            adjust_difficulty: -1,
            switch_strategy: Some(TeachingStrategy::InteractiveDiscussion),
            adjust_pace: 0.5, adjust_review_interval: 1.5,
            reason: "Fatigue detected — reducing intensity".into(),
        };
    }

    if accuracy > 0.8 && total >= 3 {
        return Adaptation {
            adjust_difficulty: 1,
            switch_strategy: if current_mastery > 60.0 { Some(TeachingStrategy::CaseStudy) } else { None },
            adjust_pace: 1.0, adjust_review_interval: 1.3,
            reason: format!("High accuracy ({:.0}%) — increasing difficulty", accuracy * 100.0),
        };
    }

    let last = recent_strategies.last().copied().unwrap_or(TeachingStrategy::DirectTeaching);
    let same_count = recent_strategies.iter().filter(|s| **s == last).count() as i32;

    if accuracy >= 0.4 && total >= 3 {
        return Adaptation {
            adjust_difficulty: 0,
            switch_strategy: if same_count >= 3 { Some(TeachingStrategy::SocraticDialogue) } else { None },
            adjust_pace: 1.0, adjust_review_interval: 1.0,
            reason: format!("Moderate accuracy ({:.0}%) — {}", accuracy * 100.0,
                if same_count >= 3 { "switching" } else { "continuing" }),
        };
    }

    if accuracy < 0.4 && total >= 2 {
        return Adaptation {
            adjust_difficulty: -1,
            switch_strategy: Some(TeachingStrategy::DirectTeaching),
            adjust_pace: 0.8, adjust_review_interval: 0.5,
            reason: format!("Low accuracy ({:.0}%) — reducing difficulty", accuracy * 100.0),
        };
    }

    Adaptation {
        adjust_difficulty: 0, switch_strategy: None,
        adjust_pace: 1.0, adjust_review_interval: 1.0,
        reason: "Stable performance — maintaining current approach".into(),
    }
}