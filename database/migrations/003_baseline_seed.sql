-- ALOS 2.0 · migration 003 · baseline evidence import (historical, tagged — never fabricated)
-- User row is created by the app bootstrap (auth). Baselines attach to user id 1.

-- ===== ENGLISH BASELINE =====
-- Grammar & Vocabulary 7/10 (historical)
INSERT INTO assessment_results (user_id, competency_id, track, kind, evidence_type, score_raw, score_max, is_provisional, notes, taken_at)
VALUES (1,(SELECT id FROM competencies WHERE code='ielts.gram.sva'),'ielts','diagnostic_baseline','historical',7,10,1,
 'Baseline grammar+vocabulary aggregate 7/10 (historical assessment, pre-ALOS). Weaknesses: conditionals, SVA, past perfect, verb forms, articles, noun/adjective. Strengths: basic vocab, simple present, basic prepositions.','2026-11-20T00:00:00Z');

-- Reading 6/7 (historical)
INSERT INTO assessment_results (user_id, competency_id, track, kind, evidence_type, score_raw, score_max, is_provisional, notes, taken_at)
VALUES (1,(SELECT id FROM competencies WHERE code='ielts.read.inference'),'ielts','diagnostic_baseline','historical',6,7,1,
 'Baseline reading 6/7 (historical). Strengths: main idea, detail, vocab-in-context. Weakness: inference.','2026-11-20T00:00:00Z');

-- Listening 7/7 via TTS — explicitly NOT authentic IELTS evidence
INSERT INTO assessment_results (user_id, competency_id, track, kind, evidence_type, score_raw, score_max, is_provisional, notes, taken_at)
VALUES (1,(SELECT id FROM competencies WHERE code='ielts.list.detail'),'ielts','diagnostic_baseline','tts_exercise',7,7,1,
 'TTS-based exercise 7/7. NOT authentic IELTS listening evidence; must not be treated as a reliable IELTS Listening score. Reassess with authentic audio.','2026-11-20T00:00:00Z');

-- Writing rough estimate band 4.0–4.5 (provisional)
INSERT INTO assessment_results (user_id, competency_id, track, kind, evidence_type, band_estimate_low, band_estimate_high, is_provisional, notes, taken_at)
VALUES (1,(SELECT id FROM competencies WHERE code='ielts.write.task2'),'ielts','diagnostic_baseline','rough_estimate',4.0,4.5,1,
 'Provisional writing estimate ~4.0–4.5. Can express personal ideas/goals. Weak: grammar accuracy, sentence construction, verb forms, articles, SVA, vocabulary precision, complex sentences, paragraph organization, academic structure. Reassess via authentic IELTS-aligned tasks.','2026-11-20T00:00:00Z');

-- Speaking rough estimate band 3.5–4.5, transcript-only; pronunciation unassessed
INSERT INTO assessment_results (user_id, competency_id, track, kind, evidence_type, band_estimate_low, band_estimate_high, is_provisional, notes, taken_at)
VALUES (1,(SELECT id FROM competencies WHERE code='ielts.speak.part2'),'ielts','diagnostic_baseline','transcript_only',3.5,4.5,1,
 'Provisional speaking estimate ~3.5–4.5 from TRANSCRIPTION ONLY. Can communicate basic experiences/opinions. Weak: sentence construction, grammar accuracy, pauses/restarts, answer development, elaboration. Pronunciation NOT reliably assessed — no definitive CEFR level assigned.','2026-11-20T00:00:00Z');

-- ===== SNBT PU BASELINE (historical series) =====
INSERT INTO assessment_results (user_id, competency_id, track, kind, evidence_type, score_raw, score_max, excluded_items, is_provisional, notes, taken_at) VALUES
 (1,(SELECT id FROM competencies WHERE code='snbt.pu.deduction'),'snbt','remedial_historical','historical',3,5,0,1,'PU Assessment 1: 3/5 (historical).','2026-11-20T00:00:00Z'),
 (1,(SELECT id FROM competencies WHERE code='snbt.pu.deduction'),'snbt','remedial_historical','historical',3,5,0,1,'PU Assessment 2: 3/5 (historical).','2026-11-20T00:00:01Z'),
 (1,(SELECT id FROM competencies WHERE code='snbt.pu.deduction'),'snbt','remedial_historical','historical',4,5,0,1,'Remedial Assessment 1: 4/5 (historical).','2026-11-20T00:00:02Z'),
 (1,(SELECT id FROM competencies WHERE code='snbt.pu.analytical'),'snbt','remedial_historical','historical',2,4,1,1,'PU Advanced Assessment 1: 2/4 valid; one question EXCLUDED for ambiguous wording (historical).','2026-11-20T00:00:03Z'),
 (1,(SELECT id FROM competencies WHERE code='snbt.pu.inverse_proportion'),'snbt','remedial_historical','historical',2,5,0,1,'Targeted Remedial Assessment: 2/5 (historical). Learner requested FEWER exams — prioritize teaching over retesting.','2026-11-20T00:00:04Z'),
 (1,(SELECT id FROM competencies WHERE code='snbt.pu.work_rate'),'snbt','remedial_historical','historical',2,3,0,1,'Conceptual practice: 2/3 (historical).','2026-11-20T00:00:05Z');

-- ===== Baseline mastery seeds (conservative, evidence-weighted; NOT one-answer mastery) =====
-- Strengths → functional-ish seeds; weaknesses → beginning/developing seeds. All provisional until live evidence.
UPDATE competencies SET mastery=65, confidence=40, evidence_count=1, status='functional' WHERE code IN
 ('ielts.vocab.basic','ielts.gram.simple_present','ielts.gram.prepositions',
  'ielts.read.main_idea','ielts.read.detail','ielts.read.vocab_context',
  'snbt.pu.deduction','snbt.pu.implication','snbt.pu.number_patterns','snbt.pu.productivity');
UPDATE competencies SET mastery=30, confidence=25, evidence_count=1, status='weak' WHERE code IN
 ('ielts.gram.conditionals','ielts.gram.sva','ielts.gram.past_perfect','ielts.gram.verb_forms',
  'ielts.gram.articles','ielts.gram.noun_adj','ielts.read.inference',
  'ielts.write.task1','ielts.write.task2','ielts.write.paragraph','ielts.write.academic_structure',
  'ielts.write.coherence','ielts.vocab.precision','ielts.gram.complex_sentences',
  'ielts.speak.part1','ielts.speak.part2','ielts.speak.elaboration','ielts.speak.fluency_restarts',
  'snbt.pu.inverse_proportion','snbt.pu.work_rate','snbt.pu.set_theory','snbt.pu.venn',
  'snbt.pu.min_intersection','snbt.pu.word_to_model','snbt.pu.necessary_vs_possible');
-- Listening: TTS evidence is weak evidence → low confidence, developing seed only.
UPDATE competencies SET mastery=45, confidence=15, evidence_count=1, status='developing' WHERE code='ielts.list.detail';
-- Pronunciation: never assessed → stays 0/new.
UPDATE competencies SET mastery=0, confidence=0, evidence_count=0, status='new' WHERE code='ielts.speak.pronunciation';

-- ===== Initial mistake-bank entries from identified weakness patterns (root causes tagged) =====
INSERT INTO mistake_bank (user_id, competency_id, track, question, root_cause, explanation, resolved) VALUES
 (1,(SELECT id FROM competencies WHERE code='snbt.pu.inverse_proportion'),'snbt','Pattern: keliru membedakan perbandingan senilai vs berbalik nilai pada soal pekerja-waktu.','conceptual','Jika jumlah pekerja bertambah, waktu berkurang (hasil kali tetap: pekerja × hari = konstan). Akan diajarkan ulang dengan demonstrasi tabel, bukan tes ulang.',0),
 (1,(SELECT id FROM competencies WHERE code='snbt.pu.min_intersection'),'snbt','Pattern: salah menghitung persentase irisan minimum dua himpunan.','conceptual','Irisan minimum = A% + B% − 100% (jika positif). Akan diajarkan dengan diagram Venn visual dan contoh survei nyata.',0),
 (1,(SELECT id FROM competencies WHERE code='snbt.pu.necessary_vs_possible'),'snbt','Pattern: menyimpulkan sesuatu yang MUNGKIN sebagai PASTI.','logical_reasoning','Kesimpulan pasti harus benar di SEMUA skenario yang konsisten dengan premis; cukup satu skenario penyangkal untuk menjadikannya sekadar mungkin.',0),
 (1,(SELECT id FROM competencies WHERE code='ielts.gram.sva'),'ielts','Pattern: subjek tunggal dengan kata kerja jamak (dan sebaliknya) pada tulisan.','grammar','Subjek tunggal → verb +s (present); kenali subjek inti walau ada frasa penyela. Latihan terbimbing dengan contoh dari tulisan sendiri.',0),
 (1,(SELECT id FROM competencies WHERE code='ielts.read.inference'),'ielts','Pattern: jawaban inferensi memilih yang tertulis eksplisit, bukan yang tersirat.','logical_reasoning','Inferensi = kesimpulan yang DIDUKUNG teks tapi tidak ditulis langsung. Strategi: eliminasi opsi yang terlalu jauh atau sekadar parafrase.',0);

-- ===== System event: baseline import audit =====
INSERT INTO system_events (level, source, event, detail) VALUES
 ('info','bootstrap','baseline_imported','Historical English + PU baselines imported with evidence tags (historical/tts_exercise/transcript_only/rough_estimate). No data fabricated; missing assessments left unassessed.');