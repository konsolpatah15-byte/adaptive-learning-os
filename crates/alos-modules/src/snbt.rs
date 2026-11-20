//! SNBT 2027 module — 7 official subtests, PU priority first.

use crate::SubjectDef;

pub fn subjects() -> Vec<SubjectDef> {
    vec![
        // PU — Penalaran Umum (active priority)
        SubjectDef {
            code: "pu".into(),
            name: "Penalaran Umum (PU)".into(),
            name_id: "Penalaran Umum".into(),
            description: "General Reasoning: inductive, deductive, and quantitative reasoning".into(),
            competencies: vec![
                comp("snbt-pu-01", "Inverse Proportion", "Perbandingan Berbalik Nilai",
                     "Solve inverse proportion and work-rate problems", 3, &[], 1),
                comp("snbt-pu-02", "Work-Rate Calculations", "Perhitungan Kecepatan Kerja",
                     "Calculate combined work rates and time-to-completion", 3, &["snbt-pu-01"], 2),
                comp("snbt-pu-03", "Set Theory", "Teori Himpunan",
                     "Apply set operations: union, intersection, complement", 3, &[], 3),
                comp("snbt-pu-04", "Venn Diagrams", "Diagram Venn",
                     "Interpret and solve problems using Venn diagrams", 3, &["snbt-pu-03"], 4),
                comp("snbt-pu-05", "Minimum Intersection %", "Persentase Irisan Minimal",
                     "Calculate minimum intersection percentages in overlapping sets", 4, &["snbt-pu-04"], 5),
                comp("snbt-pu-06", "Logical Implication", "Implikasi Logis",
                     "Evaluate conditional statements and logical equivalence", 2, &[], 6),
                comp("snbt-pu-07", "Deduction", "Deduksi",
                     "Draw necessary conclusions from premises using syllogisms", 2, &["snbt-pu-06"], 7),
                comp("snbt-pu-08", "Analytical Reasoning", "Penalaran Analitis",
                     "Analyze ordering, grouping, and assignment problems", 3, &["snbt-pu-07"], 8),
                comp("snbt-pu-09", "Argument Evaluation", "Evaluasi Argumen",
                     "Distinguish strong/weak arguments, identify assumptions", 3, &[], 9),
                comp("snbt-pu-10", "Numerical Patterns", "Pola Bilangan",
                     "Identify and extend numerical and figural sequences", 2, &[], 10),
            ],
        },
        // PPU — Pengetahuan dan Pemahaman Umum
        SubjectDef {
            code: "ppu".into(),
            name: "Pengetahuan dan Pemahaman Umum (PPU)".into(),
            name_id: "Pengetahuan dan Pemahaman Umum".into(),
            description: "General knowledge and reading comprehension in Indonesian".into(),
            competencies: vec![
                comp("snbt-ppu-01", "Text Comprehension", "Pemahaman Teks",
                     "Understand main ideas and details in Indonesian passages", 1, &[], 1),
                comp("snbt-ppu-02", "Vocabulary in Context", "Kosakata dalam Konteks",
                     "Determine word meanings from context in Indonesian", 2, &[], 2),
                comp("snbt-ppu-03", "Author's Purpose", "Tujuan Penulis",
                     "Identify author's intent, tone, and perspective", 2, &["snbt-ppu-01"], 3),
                comp("snbt-ppu-04", "General Knowledge", "Pengetahuan Umum",
                     "Apply general knowledge to contextual questions", 1, &[], 4),
            ],
        },
        // PBM — Pemahaman Bacaan dan Menulis
        SubjectDef {
            code: "pbm".into(),
            name: "Pemahaman Bacaan dan Menulis (PBM)".into(),
            name_id: "Pemahaman Bacaan dan Menulis".into(),
            description: "Reading comprehension and writing in Indonesian".into(),
            competencies: vec![
                comp("snbt-pbm-01", "Indonesian Reading", "Membaca Bahasa Indonesia",
                     "Comprehend complex Indonesian texts with inference", 2, &[], 1),
                comp("snbt-pbm-02", "Indonesian Writing", "Menulis Bahasa Indonesia",
                     "Apply proper Indonesian grammar, spelling (EYD), and paragraph structure", 2, &[], 2),
                comp("snbt-pbm-03", "Text Coherence", "Koherensi Teks",
                     "Identify logical flow and cohesion in paragraphs", 3, &["snbt-pbm-01", "snbt-pbm-02"], 3),
            ],
        },
        // PK — Pengetahuan Kuantitatif
        SubjectDef {
            code: "pk".into(),
            name: "Pengetahuan Kuantitatif (PK)".into(),
            name_id: "Pengetahuan Kuantitatif".into(),
            description: "Quantitative knowledge: arithmetic, algebra, geometry, statistics".into(),
            competencies: vec![
                comp("snbt-pk-01", "Arithmetic", "Aritmetika",
                     "Perform arithmetic operations with integers, fractions, percentages", 1, &[], 1),
                comp("snbt-pk-02", "Algebra", "Aljabar",
                     "Solve linear equations, inequalities, and algebraic expressions", 2, &["snbt-pk-01"], 2),
                comp("snbt-pk-03", "Geometry", "Geometri",
                     "Apply geometry concepts: area, volume, angles, coordinate geometry", 3, &[], 3),
                comp("snbt-pk-04", "Statistics & Probability", "Statistika & Peluang",
                     "Calculate mean, median, mode, and basic probability", 2, &["snbt-pk-01"], 4),
            ],
        },
        // LBI — Literasi Bahasa Indonesia
        SubjectDef {
            code: "lbi".into(),
            name: "Literasi Bahasa Indonesia (LBI)".into(),
            name_id: "Literasi Bahasa Indonesia".into(),
            description: "Indonesian literacy: advanced reading, critical analysis, argumentation".into(),
            competencies: vec![
                comp("snbt-lbi-01", "Critical Reading ID", "Membaca Kritis",
                     "Analyze Indonesian argumentative and expository texts", 3, &[], 1),
                comp("snbt-lbi-02", "Indonesian Argumentation", "Argumentasi",
                     "Evaluate logical structure of Indonesian arguments", 3, &["snbt-lbi-01"], 2),
            ],
        },
        // LBE — Literasi Bahasa Inggris
        SubjectDef {
            code: "lbe".into(),
            name: "Literasi Bahasa Inggris (LBE)".into(),
            name_id: "Literasi Bahasa Inggris".into(),
            description: "English literacy: reading comprehension and text analysis".into(),
            competencies: vec![
                comp("snbt-lbe-01", "English Reading", "Membaca Bahasa Inggris",
                     "Comprehend English texts with main idea and detail questions", 2, &[], 1),
                comp("snbt-lbe-02", "English Vocabulary", "Kosakata Bahasa Inggris",
                     "Determine English word meanings from context clues", 2, &[], 2),
            ],
        },
        // PM — Penalaran Matematika
        SubjectDef {
            code: "pm".into(),
            name: "Penalaran Matematika (PM)".into(),
            name_id: "Penalaran Matematika".into(),
            description: "Mathematical reasoning: problem-solving, modeling, interpretation".into(),
            competencies: vec![
                comp("snbt-pm-01", "Math Problem Solving", "Pemecahan Masalah",
                     "Translate word problems into mathematical models", 3, &[], 1),
                comp("snbt-pm-02", "Data Interpretation", "Interpretasi Data",
                     "Read tables, charts, and graphs to answer quantitative questions", 2, &[], 2),
                comp("snbt-pm-03", "Mathematical Modeling", "Pemodelan Matematika",
                     "Build and apply mathematical models to real-world scenarios", 4, &["snbt-pm-01"], 3),
            ],
        },
    ]
}

fn comp(code: &str, name: &str, name_id: &str, desc: &str, difficulty: i64, prereqs: &[&str], priority: i32) -> crate::CompetencyDef {
    crate::CompetencyDef {
        code: code.into(),
        name: name.into(),
        name_id: name_id.into(),
        description: desc.into(),
        difficulty,
        prerequisites: prereqs.iter().map(|s| s.to_string()).collect(),
        priority,
    }
}