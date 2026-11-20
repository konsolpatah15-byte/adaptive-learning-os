//! alos-modules — Domain curriculum & rubrics for IELTS Academic and SNBT 2027.

pub mod ielts;
pub mod snbt;

/// Competency definition for a subject track.
#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub struct CompetencyDef {
    pub code: String,
    pub name: String,
    pub name_id: String,
    pub description: String,
    pub difficulty: i64,
    pub prerequisites: Vec<String>,
    pub priority: i32,
}

/// Subject definition for a track.
#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub struct SubjectDef {
    pub code: String,
    pub name: String,
    pub name_id: String,
    pub description: String,
    pub competencies: Vec<CompetencyDef>,
}

/// Get all subjects for a given track.
pub fn subjects_for_track(track: &str) -> Vec<SubjectDef> {
    match track {
        "ielts" => ielts::subjects(),
        "snbt" => snbt::subjects(),
        _ => vec![],
    }
}

/// Get all competencies for a given track.
pub fn competencies_for_track(track: &str) -> Vec<CompetencyDef> {
    subjects_for_track(track).into_iter().flat_map(|s| s.competencies).collect()
}