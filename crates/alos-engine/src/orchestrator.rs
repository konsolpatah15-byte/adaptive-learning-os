//! Main Orchestrator — OBSERVE → DIAGNOSE → DECIDE → TEACH → VERIFY → REMEMBER → ADAPT → REPEAT.

use crate::*;
use crate::{diagnosis, teaching, assessment, mastery, srs, adaptation, recommendation};

/// Run one full adaptive cycle from a learner answer observation.
/// This is the core learning intelligence.
pub async fn run_cycle(
    pool: &sqlx::SqlitePool,
    obs: &Observation,
    previous_mastery: f64,
    previous_confidence: f64,
    questions_this_session: i32,
    session_mode: &str,
) -> Result<CycleResult, anyhow::Error>
{
    // ── 1. OBSERVE (already done — obs is the observation) ──
    tracing::debug!(user = obs.user_id, comp = %obs.competency_code, correct = obs.correct, "observe");

    // ── 2. DIAGNOSE ──
    let root_cause = diagnosis::diagnose(
        obs.correct,
        &obs.question,
        &obs.learner_answer,
        &obs.correct_answer,
        obs.difficulty,
        obs.independent,
        previous_mastery,
    );
    tracing::debug!(cause = %root_cause.as_str(), "diagnose");

    // ── 3. DECIDE — choose teaching strategy ──
    let strategy = teaching::decide(
        root_cause,
        obs.difficulty,
        previous_mastery,
        true, // teach_before_test
        &[],
    );
    tracing::debug!(strategy = %strategy.as_str(), "decide");

    // ── 4. TEACH — (done by AI via Hermes bridge; we just record the decision) ──

    // ── 5. VERIFY — should we ask a verification question? ──
    let max_before_reexplain = 3; // from learner prefs
    let (_should_verify, _, _) = assessment::should_verify(
        previous_mastery,
        questions_this_session,
        max_before_reexplain,
        true,
        session_mode,
    );

    // Score this answer
    let _answer_score = assessment::score_answer(obs.correct, obs.difficulty, obs.independent);

    // ── 6. REMEMBER — update mastery ──
    let (new_mastery, new_confidence, tier) = mastery::update(
        previous_mastery,
        previous_confidence,
        obs.correct,
        obs.difficulty,
        obs.independent,
        obs.confidence_self,
    );

    // Persist to DB
    alos_db::repo::update_competency_mastery(pool, &obs.competency_code, new_mastery, new_confidence, &tier).await?;

    // Record mistake if incorrect
    if !obs.correct {
        let mistake = alos_db::models::MistakeEntry {
            id: 0, user_id: obs.user_id, competency_id: None, track: "ielts".into(),
            question: obs.question.clone(),
            learner_answer: Some(obs.learner_answer.clone()),
            correct_answer: Some(obs.correct_answer.clone()),
            root_cause: root_cause.as_str().into(),
            explanation: None, resolved: false, resolved_at: None,
            occurrences: 1,
            created_at: String::new(), updated_at: String::new(),
        };
        alos_db::repo::record_mistake(pool, &mistake).await?;
    }

    // ── 7. ADAPT ──
    let ad = adaptation::adapt(
        &[obs.correct],
        &[strategy],
        new_mastery,
        false,
        None,
    );
    tracing::debug!(reason = %ad.reason, "adapt");

    // Update SRS review queue
    let _next_review = srs::next_review_date(ad.adjust_review_interval * 7.0);

    // ── 8. RECOMMEND ──
    let recs = recommendation::recommend(
        &[(obs.competency_code.clone(), new_mastery)],
        &[],
        session_mode,
    );
    let rec_text = if let Some(r) = recs.first() {
        format!("Next: {} ({})", r.competency_code, r.reason)
    } else {
        "Continue practicing".to_string()
    };

    Ok(CycleResult {
        root_cause,
        strategy,
        new_mastery,
        new_confidence,
        tier,
        recommendation: rec_text,
    })
}