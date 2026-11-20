//! Daily/weekly scheduling engine (Section 13).

use chrono::{NaiveTime, Datelike, Weekday, Timelike};

/// Schedule parameters from learner preferences.
pub struct ScheduleParams {
    pub weekday_minutes: i32,
    pub weekday_window_start: NaiveTime,
    pub weekday_window_end: NaiveTime,
    pub weekend_minutes: i32,
    pub buffer_ratio: f64,           // leave N% unscheduled
    pub ielts_ratio: f64,            // fraction of time for IELTS vs SNBT
}

impl Default for ScheduleParams {
    fn default() -> Self {
        Self {
            weekday_minutes: 90,
            weekday_window_start: NaiveTime::from_hms_opt(16, 30, 0).unwrap(),
            weekday_window_end: NaiveTime::from_hms_opt(19, 0, 0).unwrap(),
            weekend_minutes: 210,
            buffer_ratio: 0.15,
            ielts_ratio: 0.5,
        }
    }
}

/// A single scheduled block.
#[derive(Debug, Clone)]
pub struct ScheduleBlock {
    pub date: String,
    pub start_time: String,
    pub duration_minutes: i32,
    pub track: String,
    pub activity: String,
    pub title: String,
}

/// Generate a daily plan.
pub fn plan_day(
    date: String,
    params: &ScheduleParams,
    pending_reviews: i32,
    _weak_competency_count: i32,
) -> Vec<ScheduleBlock>
{
    let parsed = chrono::NaiveDate::parse_from_str(&date, "%Y-%m-%d").unwrap_or(
        chrono::Utc::now().date_naive()
    );
    let is_weekend = matches!(parsed.weekday(), Weekday::Sat | Weekday::Sun);
    let max_minutes = if is_weekend { params.weekend_minutes } else { params.weekday_minutes };
    let effective = ((max_minutes as f64) * (1.0 - params.buffer_ratio)) as i32;

    let mut blocks = Vec::new();
    let mut remaining = effective;
    let mut current_time = params.weekday_window_start;
    let time_step = 25; // minutes per block, then 5-min break

    // 1. Reviews first (high priority)
    let review_count = pending_reviews.min(remaining / time_step);
    let review_minutes = review_count * time_step;
    if review_count > 0 {
        blocks.push(ScheduleBlock {
            date: date.clone(),
            start_time: current_time.format("%H:%M").to_string(),
            duration_minutes: review_minutes,
            track: "review".into(),
            activity: "review".into(),
            title: format!("Spaced repetition review ({} items)", review_count),
        });
        current_time = add_minutes(current_time, review_minutes + 5);
        remaining -= review_minutes;
    }

    // 2. Weak competencies — alternate IELTS and SNBT
    let ielts_minutes = ((remaining as f64) * params.ielts_ratio) as i32;
    let snbt_minutes = remaining - ielts_minutes;

    if ielts_minutes >= time_step {
        blocks.push(ScheduleBlock {
            date: date.clone(),
            start_time: current_time.format("%H:%M").to_string(),
            duration_minutes: ielts_minutes,
            track: "ielts".into(),
            activity: "explanation".into(),
            title: "IELTS Academic — competency practice".into(),
        });
        current_time = add_minutes(current_time, ielts_minutes + 5);
    }

    if snbt_minutes >= time_step {
        blocks.push(ScheduleBlock {
            date: date.clone(),
            start_time: current_time.format("%H:%M").to_string(),
            duration_minutes: snbt_minutes,
            track: "snbt".into(),
            activity: "guided_practice".into(),
            title: "SNBT PU — Penalaran Umum".into(),
        });
    }

    // 3. Buffer: leave the rest unscheduled (anti-burnout)
    blocks
}

fn add_minutes(t: NaiveTime, m: i32) -> NaiveTime {
    let total = t.num_seconds_from_midnight() as i32 + m * 60;
    let hours = (total / 3600) % 24;
    let mins = (total % 3600) / 60;
    NaiveTime::from_hms_opt(hours as u32, mins as u32, 0).unwrap_or(t)
}