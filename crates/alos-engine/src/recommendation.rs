//! Recommendation engine — suggests next learning actions.

use crate::{RootCause, TeachingStrategy};

/// A learning recommendation.
#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub struct Recommendation {
    pub competency_code: String,
    pub priority: i32,                   // 1 = highest
    pub strategy: String,
    pub reason: String,
    pub suggested_minutes: i32,
}

/// Generate recommendations ordered by priority.
pub fn recommend(
    weakest: &[(String, f64)],                    // (code, mastery)
    pending_reviews: &[(String, String, f64)],    // (code, due_at, interval_days)
    last_activity: &str,                          // last session mode
) -> Vec<Recommendation>
{
    let mut recs = Vec::new();

    // 1. Overdue reviews are highest priority
    for (code, due_at, interval) in pending_reviews {
        let overdue = chrono::Utc::now().format("%Y-%m-%dT%H:%M:%SZ").to_string() > *due_at;
        let priority = if overdue { 1 } else { 3 };
        recs.push(Recommendation {
            competency_code: code.clone(),
            priority,
            strategy: "review".into(),
            reason: if overdue {
                format!("Overdue review (was due {})", due_at)
            } else {
                format!("Review due in {} days", interval)
            },
            suggested_minutes: 15,
        });
    }

    // 2. Weak competencies — prioritize by severity
    for (_i, (code, mastery)) in weakest.iter().enumerate() {
        let priority = if *mastery < 20.0 { 2 }
            else if *mastery < 40.0 { 4 }
            else { 5 };

        let strategy = if *mastery < 30.0 { "explanation" }
            else { "guided_practice" };

        recs.push(Recommendation {
            competency_code: code.clone(),
            priority,
            strategy: strategy.into(),
            reason: format!("Weak competency (mastery {:.0}%)", mastery),
            suggested_minutes: 25,
        });
    }

    // 3. Anti-boredom: if last activity was assessment, recommend discussion
    if last_activity == "assessment" && !weakest.is_empty() {
        recs.push(Recommendation {
            competency_code: weakest[0].0.clone(),
            priority: 3,
            strategy: "discussion".into(),
            reason: "Mix it up after assessment — interactive discussion recommended".into(),
            suggested_minutes: 20,
        });
    }

    // Sort by priority
    recs.sort_by_key(|r| r.priority);
    recs
}