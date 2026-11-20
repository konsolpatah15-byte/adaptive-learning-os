//! alos-engine — Autonomous Adaptive Learning Intelligence.
//!
//! Implements the 8-step pedagogical cycle:
//! OBSERVE → DIAGNOSE → DECIDE → TEACH → VERIFY → REMEMBER → ADAPT → REPEAT

pub mod orchestrator;
pub mod diagnosis;
pub mod teaching;
pub mod assessment;
pub mod mastery;
pub mod srs;
pub mod scheduler;
pub mod recommendation;
pub mod adaptation;

/// The 9 root-cause error categories (Section 9.2).
#[derive(Debug, Clone, Copy, PartialEq, Eq, serde::Serialize, serde::Deserialize)]
pub enum RootCause {
    ConceptualMisunderstanding,
    CalculationError,
    Misreading,
    VocabularyLimitation,
    GrammarError,
    LogicalReasoningError,
    CarelessMistake,
    TimeManagementIssue,
    InsufficientBackgroundKnowledge,
    Unknown,
}

impl RootCause {
    pub fn as_str(&self) -> &'static str {
        match self {
            Self::ConceptualMisunderstanding => "conceptual",
            Self::CalculationError => "calculation",
            Self::Misreading => "misreading",
            Self::VocabularyLimitation => "vocabulary",
            Self::GrammarError => "grammar",
            Self::LogicalReasoningError => "logical_reasoning",
            Self::CarelessMistake => "careless",
            Self::TimeManagementIssue => "time_management",
            Self::InsufficientBackgroundKnowledge => "background_knowledge",
            Self::Unknown => "unknown",
        }
    }
}

/// The 10 teaching strategies (Section 9.3).
#[derive(Debug, Clone, Copy, PartialEq, Eq, serde::Serialize, serde::Deserialize)]
pub enum TeachingStrategy {
    DirectTeaching,
    SocraticDialogue,
    StepByStepDemonstration,
    RealWorldScenario,
    Analogy,
    VisualExplanation,
    GuidedProblemSolving,
    InteractiveDiscussion,
    CaseStudy,
    PracticalApplication,
}

impl TeachingStrategy {
    pub fn as_str(&self) -> &'static str {
        match self {
            Self::DirectTeaching => "direct",
            Self::SocraticDialogue => "socratic",
            Self::StepByStepDemonstration => "demo",
            Self::RealWorldScenario => "scenario",
            Self::Analogy => "analogy",
            Self::VisualExplanation => "visual",
            Self::GuidedProblemSolving => "guided",
            Self::InteractiveDiscussion => "discussion",
            Self::CaseStudy => "case",
            Self::PracticalApplication => "practical",
        }
    }
}

/// Mastery tier (Section 11).
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, serde::Serialize, serde::Deserialize)]
pub enum MasteryTier {
    NotUnderstood = 0,
    Beginning = 1,
    Developing = 2,
    Functional = 3,
    Strong = 4,
    Mastered = 5,
}

impl MasteryTier {
    pub fn from_score(score: f64) -> Self {
        match score {
            s if s < 20.0 => Self::NotUnderstood,
            s if s < 40.0 => Self::Beginning,
            s if s < 60.0 => Self::Developing,
            s if s < 75.0 => Self::Functional,
            s if s < 90.0 => Self::Strong,
            _ => Self::Mastered,
        }
    }

    pub fn to_status(&self) -> &'static str {
        match self {
            Self::NotUnderstood => "new",
            Self::Beginning => "learning",
            Self::Developing => "weak",
            Self::Functional => "developing",
            Self::Strong => "functional",
            Self::Mastered => "mastered",
        }
    }
}

/// Observation: a single learner answer event.
#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub struct Observation {
    pub user_id: i64,
    pub competency_code: String,
    pub correct: bool,
    pub difficulty: i64,
    pub independent: bool,
    pub confidence_self: Option<f64>,
    pub question: String,
    pub learner_answer: String,
    pub correct_answer: String,
}

/// Result of one full cycle iteration.
#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub struct CycleResult {
    pub root_cause: RootCause,
    pub strategy: TeachingStrategy,
    pub new_mastery: f64,
    pub new_confidence: f64,
    pub tier: String,
    pub recommendation: String,
}