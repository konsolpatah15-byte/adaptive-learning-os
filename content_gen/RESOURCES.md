# ALOS Learning Resources Index
## Kumpulan Sumber Materi Pembelajaran Kredibel

### IELTS Academic — Official & Trusted Sources
| Source | URL | Type |
|--------|-----|------|
| British Council IELTS | https://takeielts.britishcouncil.org/ | Official tests, tips, practice |
| IDP IELTS | https://ielts.idp.com/prepare | Official preparation materials |
| Cambridge English IELTS | https://www.cambridgeenglish.org/exams-and-tests/ielts/preparation/ | Test developer resources |
| IELTS.org Sample Questions | https://ielts.org/take-a-test/preparation-resources/sample-test-questions | Free official samples |
| IELTS Advantage | https://www.ieltsadvantage.com/ | Band 7+ strategies, essay correction insights |
| BBC Learning English | https://www.bbc.co.uk/learningenglish/ | 6 Minute English, grammar, vocabulary |
| British Council LearnEnglish | https://learnenglish.britishcouncil.org/grammar | Grammar reference |
| Purdue OWL Academic Writing | https://owl.purdue.edu/owl/general_writing/academic_writing/index.html | Academic writing standards |
| Grammarly Handbook | https://www.grammarly.com/grammar | Grammar rules and syntax |

### IELTS Writing — Band 7+ Strategies
| Source | URL |
|--------|-----|
| IELTS Advantage 8 Steps | https://www.ieltsadvantage.com/2019/04/11/ielts-writing-task-2-8-steps-to-success/ |
| Amar Nepal Band 7 Guide | https://amarnepal.com/guides/ielts-band-7-writing-tips |
| British Council Writing | https://takeielts.britishcouncil.org/prepare/writing |
| Abhyaas Band 7+ Tips | https://abhyaas.in/how-to-score-band-7-in-ielts-writing/ |

### SNBT 2027 UTBK — Indonesian Sources
| Source | URL | Type |
|--------|-----|------|
| RuangTes | https://ruangtes.id/contoh-soal/utbk | 2848+ practice questions, free |
| Nakafa Tryout | https://nakafa.com/id/try-out/indonesia/snbt/2027/utbk/set-1 | 160-question simulation sets |
| Analitica Priority Map | https://analitica.id/utbk-snbt/materi | Difficulty-prioritized topic map |

### Mathematics — International
| Source | URL | Topics |
|--------|-----|--------|
| Khan Academy Math | https://www.khanacademy.org/math | All levels, free, interactive |
| Math Is Fun Algebra | https://www.mathsisfun.com/algebra/index.html | Algebra, geometry, probability |
| Math Is Fun Geometry | https://www.mathsisfun.com/geometry/index.html | Geometry fundamentals |
| Math Is Fun Data/Stats | https://www.mathsisfun.com/data/ | Statistics and probability |

### Evidence-Based Learning Methods
| Method | Key Source | Application in ALOS |
|--------|-----------|---------------------|
| Spaced Repetition (SRS) | Ebbinghaus (1885), Leitner System, Anki | SRS engine in alos-engine, 1-3-7-14-30 day intervals |
| Active Recall / Testing Effect | Roediger & Karpicke (2006), "Make It Stick" | Assessment engine, retrieval practice before re-study |
| Interleaving | Rohrer (2012) | Mixed competency sessions, not blocked |
| Elaboration | Brown, Roediger & McDaniel (2014) | "Why" questions, analogies in content |
| Dual Coding | Paivio (1986) | Visual + verbal: diagrams, charts alongside text |
| Concrete Examples | Weinstein et al. (2018) | Aquaculture/farming examples throughout |
| Metacognition | Flavell (1979) | Confidence tracking, self-assessment in competencies |

### ALOS Teaching Methods (10 strategies)
1. **direct** — Penjelasan langsung, definisi, rumus
2. **socratic** — Tanya-jawab, "apa yang terjadi kalau...?"
3. **demo** — Demonstrasi langkah demi langkah
4. **analogy** — Analogi dengan dunia nyata (akuakultur, kolam, panen)
5. **scenario** — Studi kasus, situasi konkret
6. **visual** — Diagram, tabel, gambar
7. **guided** — Latihan terbimbing dengan scaffolding
8. **discussion** — Diskusi terbuka, argumentasi
9. **case** — Analisis kasus, evaluasi bukti
10. **practical** — Aplikasi langsung, simulasi

### ALOS Repository Structure
```
adaptive-learning-os/
  crates/
    alos-api/        Axum REST API (25 endpoints)
    alos-engine/     Adaptive learning core (8 modules)
    alos-modules/    Curriculum: 24 IELTS + 30 SNBT competencies
    alos-db/         SQLite (13 tables, SQLx)
  apps/web/          Next.js 14 frontend (10 pages)
  learning-engine/   Python engine (7 modules)
  content_gen/       Generated content SQL files
  skills/            Hermes Agent skill definitions
  database/          Schema, migrations, backups
```

### Competency Counts
- IELTS: 24 competencies across 6 subjects (Listening, Reading, Writing, Speaking, Grammar, Vocabulary)
- SNBT: 30 competencies across 7 subtests (PU, PPU, PBM, PK, LBI, LBE, PM)
- Total: 54 competencies with prerequisite trees
- Content seeded so far: ~10 competencies (PU priority + some IELTS grammar)
- Generated now: ALL 54 competencies with 2+ topics each = 120+ curriculum topics