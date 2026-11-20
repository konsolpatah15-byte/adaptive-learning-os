# ALOS Learning Methodology — Evidence-Based, Internationally Proven

## Core Principles (Backed by Research)

### 1. Spaced Repetition (Ebbinghaus, 1885 → Anki, SuperMemo)
**Apa:** Mengulang materi dengan interval yang semakin panjang (1→3→7→14→30 hari).
**Kenapa:** Melawan forgetting curve. Tanpa pengulangan, 80% informasi hilang dalam 30 hari.
**Di ALOS:** `alos-engine/src/srs.rs` — SM-2 algorithm, ease factor 2.5, reset ke 1 hari jika lupa.
**Kata kunci:** jangan CRAM (belajar maraton 8 jam), lebih baik 30 menit/hari × 6 hari.

### 2. Active Recall / Testing Effect (Roediger & Karpicke, 2006)
**Apa:** Mengambil informasi dari memori (recall), BUKAN membaca ulang.
**Kenapa:** Studi menunjukkan recall 50% lebih efektif untuk retensi jangka panjang dibanding re-reading.
**Di ALOS:** Setiap topik diikuti light check / practice question. Assessment sebelum re-study.
**Cara:** Tutup buku, tulis apa yang kamu ingat. LALU buka dan cek yang terlewat.

### 3. Interleaving (Rohrer, 2012)
**Apa:** Mencampur berbagai topik dalam satu sesi, bukan belajar satu topik sampai tuntas (blocking).
**Kenapa:** Blocking terasa lebih mudah tapi hasilnya lebih rendah. Interleaving melatih otak membedakan tipe soal.
**Di ALOS:** Mixed-track sessions (IELTS reading + grammar + vocabulary dalam 1 sesi).

### 4. Elaboration (Brown, Roediger & McDaniel, "Make It Stick")
**Apa:** Menjelaskan KENAPA sesuatu benar, menghubungkan dengan yang sudah diketahui.
**Kenapa:** Membangun jaringan pengetahuan, bukan fakta terisolasi.
**Di ALOS:** Metode socratic + discussion + analogy. Setiap topik punya "diskusi" dan "kenapa".

### 5. Dual Coding (Paivio, 1986)
**Apa:** Informasi verbal + visual bersamaan.
**Kenapa:** Otak punya dua channel pemrosesan. Gabungan lebih kuat dari masing-masing sendiri.
**Di ALOS:** Diagram Venn, tabel, grafik dalam konten. Metode visual + demo.

### 6. Metacognition (Flavell, 1979)
**Apa:** Sadar tentang apa yang kamu TAHU dan TIDAK tahu.
**Kenapa:** Siswa yang overconfident tidak belajar yang perlu dipelajari.
**Di ALOS:** Confidence tracking terpisah dari mastery. "Seberapa yakin kamu?" sebelum lihat jawaban.

## The 8-Step Adaptive Learning Cycle (alos-engine)

```
DIAGNOSIS → TEACHING → ASSESSMENT → FEEDBACK →
RECOMMENDATION → SCHEDULING → SRS → ADAPTATION → (loop)
```

1. **Diagnosis** — Root cause analysis: conceptual? calculation? misreading? vocabulary?
2. **Teaching** — Pilih strategi terbaik: analogy → socratic → demo → guided → case (berdasarkan root cause)
3. **Assessment** — Light check (3-5 soal), practice (10-15 soal), formal simulation
4. **Feedback** — Corrected explanation with root_cause tagged
5. **Recommendation** — Topik berikutnya berdasarkan prerequisite tree + weakness
6. **Scheduling** — Kapan review berikutnya (SRS interval)
7. **SRS** — Spaced retrieval practice
8. **Adaptation** — Update mastery, confidence, adjust teaching strategy

## Anti-Boredom Engine
- Deteksi kalimat learner: "terlalu banyak tes" → switch ke discussion/visual
- "lemah di sini" → turunkan difficulty, step-by-step demo
- "lanjut" → skip quiz, next topic

## Session Modes
1. **explanation** — Teaching dulu, baru light check
2. **guided_practice** — Scaffolding: hint → partial solution → full solution
3. **discussion** — Socratic dialogue, argumentasi
4. **simulation** — Tryout timed, real exam conditions
5. **assessment** — Diagnostic baseline
6. **review** — SRS retrieval practice

## Weekly Schedule Template (evidence-based)
```
Senin: IELTS Listening (explanation) + Grammar (guided_practice)
Selasa: SNBT PU (discussion) + PK (demo)
Rabu:  IELTS Reading (explanation) + Vocabulary (socratic)
Kamis: SNBT PBM + LBI (guided_practice)
Jumat: IELTS Writing (simulation Task 1) + SNBT PM (explanation)
Sabtu: Mixed review (SRS retrieval) + Mistake bank review
Minggu: Free — light SRS + relaxation (tidur cukup = konsolidasi memori!)
```

## Key Principles dari Penelitian Internasional

### "Make It Stick" (Brown, Roediger, McDaniel — Harvard University Press)
- **Learning is deeper when it's effortful.** Kalau terasa mudah, mungkin tidak efektif.
- **Rereading is a waste of time.** Jangan baca ulang catatan — latihan recall.
- **Testing is a learning tool,** bukan cuma assessment.

### "Learning How to Learn" (Barbara Oakley — Coursera)
- **Focused mode + Diffuse mode.** Belajar intensif 25 menit, lalu istirahat 5 menit (Pomodoro).
- **Sleep consolidates memory.** Tidur cukup = review otomatis oleh otak.
- **Procrastination hack:** mulai dari yang termudah, bangun momentum.

### Pimsleur Language Learning (Graduated Interval Recall)
- Interval: 5 detik → 25 detik → 2 menit → 10 menit → 1 jam → 5 jam → 1 hari → 5 hari → 25 hari → 4 bulan → 2 tahun
- Diadaptasi di ALOS: 1 hari → 3 hari → 7 hari → 14 hari → 30 hari (untuk konten akademik)

### Leitner System (Flashcard fisik)
- 5 kotak. Jawab benar → maju kotak (interval lebih panjang). Salah → kembali ke kotak 1.
- Di ALOS: digital equivalent via review_queue table.

## International Standards Referenced
- **CEFR** (Common European Framework): IELTS Band 7 = C1 (Advanced)
- **IELTS Band Descriptors**: Task Achievement, Coherence & Cohesion, Lexical Resource, Grammatical Range & Accuracy
- **SNPMB Framework**: 7 subtes UTBK-SNBT, total 160 soal / 195 menit
- **Bloom's Taxonomy**: Remember → Understand → Apply → Analyze → Evaluate → Create
- **Cognitive Load Theory** (Sweller): Kurangi extraneous load, optimalkan germane load

## Error Root Cause Categories (in ALOS)
1. **conceptual** — Salah paham konsep dasar
2. **calculation** — Konsep benar, hitungan salah
3. **misreading** — Salah baca soal / instruksi
4. **vocabulary** — Tidak tahu makna kata kunci
5. **grammar** — Tata bahasa salah
6. **logical_reasoning** — Penalaran tidak runtut
7. **careless** — Ceroboh / kurang teliti
8. **time_management** — Kehabisan waktu
9. **background_knowledge** — Kurang pengetahuan latar

## Evidence Types (Authenticity Levels)
1. **official** — Hasil tes resmi IELTS/UTBK
2. **formal** — Simulasi timed penuh
3. **authentic_task** — Latihan dengan output nyata (essay written, spoken recorded)
4. **tts_exercise** — Latihan speaking/listening
5. **rough_estimate** — Self-assessment
6. **historical** — Data dari platform lain
7. **transcript_only** — Bukti tertulis tanpa recording