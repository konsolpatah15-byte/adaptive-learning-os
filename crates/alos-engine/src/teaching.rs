//! Teaching strategy selector — maps root cause + learner context → best strategy.

use crate::{RootCause, TeachingStrategy};

/// Decide the best teaching strategy given the error root cause, difficulty, and learner prefs.
pub fn decide(cause: RootCause, difficulty: i64, previous_mastery: f64, _teach_before_test: bool,
              _preferred_style: &[String]) -> TeachingStrategy
{
    // If the learner is completely new to the topic, always teach first
    if previous_mastery < 20.0 {
        return TeachingStrategy::DirectTeaching;
    }

    // Anti-boredom: if we've been in direct-teach mode too long, mix it up
    match cause {
        RootCause::ConceptualMisunderstanding => {
            if difficulty <= 2 {
                TeachingStrategy::StepByStepDemonstration
            } else {
                TeachingStrategy::Analogy
            }
        }
        RootCause::CalculationError => TeachingStrategy::StepByStepDemonstration,
        RootCause::Misreading => TeachingStrategy::GuidedProblemSolving,
        RootCause::VocabularyLimitation => {
            if previous_mastery < 40.0 { TeachingStrategy::DirectTeaching }
            else { TeachingStrategy::RealWorldScenario }
        }
        RootCause::GrammarError => TeachingStrategy::StepByStepDemonstration,
        RootCause::LogicalReasoningError => TeachingStrategy::SocraticDialogue,
        RootCause::CarelessMistake => TeachingStrategy::GuidedProblemSolving,
        RootCause::TimeManagementIssue => TeachingStrategy::PracticalApplication,
        RootCause::InsufficientBackgroundKnowledge => TeachingStrategy::DirectTeaching,
        RootCause::Unknown => {
            // No error — choose something engaging
            if difficulty >= 4 { TeachingStrategy::CaseStudy }
            else { TeachingStrategy::InteractiveDiscussion }
        }
    }
}

/// Anti-boredom: detect learner intent phrases and return the override strategy.
pub fn detect_learner_intent(message: &str) -> Option<(&'static str, TeachingStrategy)> {
    let m = message.to_lowercase();
    if m.contains("too many tests") || m.contains("terlalu banyak tes") {
        return Some(("Exit testing mode — switching to discussion/visual.", TeachingStrategy::InteractiveDiscussion));
    }
    if m.contains("explain instead") || m.contains("jelaskan saja") {
        return Some(("Replacing questions with multi-angle explanation.", TeachingStrategy::DirectTeaching));
    }
    if m.contains("i'm weak here") || m.contains("saya lemah") || m.contains("aku lemah") {
        return Some(("Lowering difficulty, switching to guided step-by-step.", TeachingStrategy::StepByStepDemonstration));
    }
    if m.contains("let's move on") || m.contains("lanjut") || m.contains("pindah") {
        return Some(("Transitioning to next topic.", TeachingStrategy::PracticalApplication));
    }
    if m.contains("continue") || m.contains("lanjutkan") {
        return Some(("Continuing without quiz.", TeachingStrategy::StepByStepDemonstration));
    }
    None
}