//! IELTS Academic module — 10 competencies across 6 skill areas.

use crate::SubjectDef;

pub fn subjects() -> Vec<SubjectDef> {
    vec![
        SubjectDef {
            code: "listening".into(),
            name: "Listening".into(),
            name_id: "Mendengarkan".into(),
            description: "IELTS Academic Listening — main ideas, details, distractors, maps, accents".into(),
            competencies: vec![
                comp("ielts-list-01", "Main Idea Recognition", "Mengenali Ide Utama",
                     "Identify the main idea in short and extended monologues/dialogues", 1, &[]),
                comp("ielts-list-02", "Detail Recognition", "Mengenali Detail",
                     "Recognize specific details, numbers, names, dates in audio", 1, &[]),
                comp("ielts-list-03", "Distractor Identification", "Identifikasi Pengecoh",
                     "Identify distractors and paraphrased information", 2, &["ielts-list-01"]),
                comp("ielts-list-04", "Map & Diagram Questions", "Pertanyaan Peta & Diagram",
                     "Follow directions and label maps/diagrams from audio descriptions", 3, &["ielts-list-02"]),
                comp("ielts-list-05", "Accent Comprehension", "Pemahaman Aksen",
                     "Understand different English accents (British, American, Australian)", 3, &["ielts-list-01", "ielts-list-03"]),
            ],
        },
        SubjectDef {
            code: "reading".into(),
            name: "Reading".into(),
            name_id: "Membaca".into(),
            description: "IELTS Academic Reading — skimming, scanning, inference, T/F/NG".into(),
            competencies: vec![
                comp("ielts-read-01", "Skimming", "Skimming",
                     "Quickly identify main ideas and paragraph purposes", 1, &[]),
                comp("ielts-read-02", "Scanning", "Scanning",
                     "Locate specific information efficiently within passages", 1, &[]),
                comp("ielts-read-03", "Inference", "Inferensi",
                     "Draw logical inferences from text (priority weakness)", 3, &["ielts-read-01", "ielts-read-02"]),
                comp("ielts-read-04", "True/False/Not Given", "Benar/Salah/Tidak Diberikan",
                     "Distinguish between confirmed, contradicted, and unstated claims", 3, &["ielts-read-03"]),
                comp("ielts-read-05", "Matching Headings", "Mencocokkan Judul",
                     "Match paragraph headings to sections based on main ideas", 2, &["ielts-read-01"]),
            ],
        },
        SubjectDef {
            code: "writing".into(),
            name: "Writing".into(),
            name_id: "Menulis".into(),
            description: "IELTS Academic Writing — Task 1 reports, Task 2 essays".into(),
            competencies: vec![
                comp("ielts-write-01", "Task 1 Report Writing", "Menulis Laporan Task 1",
                     "Describe charts, graphs, tables, and processes in 150+ words", 2, &[]),
                comp("ielts-write-02", "Task 2 Essay Writing", "Menulis Esai Task 2",
                     "Write argumentative/discursive essays in 250+ words", 3, &["ielts-write-01"]),
                comp("ielts-write-03", "Coherence & Cohesion", "Koherensi & Kohesi",
                     "Organize paragraphs logically with proper linking devices", 3, &["ielts-write-01"]),
                comp("ielts-write-04", "Lexical Resource", "Sumber Leksikal",
                     "Use varied, precise vocabulary with appropriate collocations", 3, &[]),
            ],
        },
        SubjectDef {
            code: "speaking".into(),
            name: "Speaking".into(),
            name_id: "Berbicara".into(),
            description: "IELTS Speaking — Parts 1-3, fluency, coherence, pronunciation".into(),
            competencies: vec![
                comp("ielts-speak-01", "Part 1 Fluency", "Kelancaran Part 1",
                     "Answer familiar topic questions fluently with developed responses", 1, &[]),
                comp("ielts-speak-02", "Part 2 Long Turn", "Pembicaraan Panjang Part 2",
                     "Speak for 1-2 minutes on a given topic with structure", 2, &["ielts-speak-01"]),
                comp("ielts-speak-03", "Part 3 Discussion", "Diskusi Part 3",
                     "Discuss abstract topics with reasoning and examples", 4, &["ielts-speak-02"]),
            ],
        },
        SubjectDef {
            code: "grammar".into(),
            name: "Grammar".into(),
            name_id: "Tata Bahasa".into(),
            description: "Grammar accuracy — conditionals, subject-verb agreement, tenses, articles".into(),
            competencies: vec![
                comp("ielts-gram-01", "Conditional Sentences", "Kalimat Pengandaian",
                     "Use zero, first, second, and third conditionals correctly", 3, &[]),
                comp("ielts-gram-02", "Subject-Verb Agreement", "Kesesuaian Subjek-Kata Kerja",
                     "Match subjects with correct verb forms in all tenses", 2, &[]),
                comp("ielts-gram-03", "Past Perfect & Verb Forms", "Past Perfect & Bentuk Kata Kerja",
                     "Use past perfect and irregular verb forms accurately", 3, &[]),
                comp("ielts-gram-04", "Articles & Determiners", "Artikel & Penentu",
                     "Use a/an/the and other determiners correctly", 2, &[]),
            ],
        },
        SubjectDef {
            code: "vocabulary".into(),
            name: "Vocabulary".into(),
            name_id: "Kosakata".into(),
            description: "Academic vocabulary, collocations, word families, topic-specific lexis".into(),
            competencies: vec![
                comp("ielts-vocab-01", "Academic Word List", "Daftar Kosakata Akademik",
                     "Recognize and use high-frequency academic vocabulary", 1, &[]),
                comp("ielts-vocab-02", "Collocations", "Kolokasi",
                     "Use natural word partnerships and fixed expressions", 2, &["ielts-vocab-01"]),
                comp("ielts-vocab-03", "Topic-Specific Vocabulary", "Kosakata Tematik",
                     "Use domain-specific vocabulary for common IELTS topics", 2, &["ielts-vocab-01"]),
            ],
        },
    ]
}

fn comp(code: &str, name: &str, name_id: &str, desc: &str, difficulty: i64, prereqs: &[&str]) -> crate::CompetencyDef {
    crate::CompetencyDef {
        code: code.into(),
        name: name.into(),
        name_id: name_id.into(),
        description: desc.into(),
        difficulty,
        prerequisites: prereqs.iter().map(|s| s.to_string()).collect(),
        priority: difficulty as i32,
    }
}