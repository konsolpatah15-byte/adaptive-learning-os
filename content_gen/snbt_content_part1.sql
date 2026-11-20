-- ALOS 2.0 · SNBT 2027 curriculum content generation
-- Generated for Adaptive Learning OS
-- Covers: PU, PPU, PBM, PK, LBI, LBE, PM
-- Indonesian-first, aquaculture/farming analogies, multiple methods

INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pu.work_rate'),
 'Work-rate dengan tiga pelaku — latihan soal bertingkat', 'id', 'guided', 3, 2,
 '## Work-rate dengan tiga pelaku atau lebih

Setelah kamu paham dua pompa/pipa mengisi kolam, saatnya tantangan dengan TIGA pelaku. Polanya sama: jumlahkan LAJU, bukan waktu.

### Soal bertingkat 1 — Tiga pipa mengisi

Pipa A mengisi kolam dalam 4 jam. Pipa B dalam 6 jam. Pipa C dalam 12 jam. Bersama-sama?

**Laju per jam masing-masing:**
- A: 1/4 kolam/jam
- B: 1/6 kolam/jam
- C: 1/12 kolam/jam

**Samakan penyebut (KPK 12):**
- A = 3/12, B = 2/12, C = 1/12
- Total laju = 3/12 + 2/12 + 1/12 = 6/12 = **1/2 kolam/jam**

Waktu = 1 ÷ (1/2) = **2 jam**.

### Soal bertingkat 2 — Dua mengisi, satu menguras

Pipa A mengisi 1/5 kolam/jam. Pipa B mengisi 1/10 kolam/jam. Pipa C MENGURAS 1/15 kolam/jam. Bersama?

Laju netto = 1/5 + 1/10 − 1/15

Samakan ke per 30: 6/30 + 3/30 − 2/30 = **7/30 kolam/jam**

Waktu = 1 ÷ (7/30) = 30/7 ≈ **4,29 jam** (atau 4 jam 17 menit).

### Soal bertingkat 3 — Pekerja masuk-keluar

6 pekerja bisa selesai 12 hari. Setelah 4 hari bekerja, 2 pekerja keluar. Sisanya?

- Usaha total = 6 × 12 = 72 satuan
- Setelah 4 hari: sisa = 72 − (6 × 4) = 72 − 24 = 48 satuan
- Pekerja tersisa = 4 orang
- Waktu sisa = 48 ÷ 4 = **12 hari**

Total waktu = 4 + 12 = **16 hari** (bukan 12 hari seperti rencana awal, karena tenaga berkurang).

### Latihan mandiri

1. Tiga tukang: A butuh 8 hari, B butuh 12 hari, C butuh 24 hari. Bersama berapa hari?
   *(Petunjuk: KPK penyebut = 24. A=3/24, B=2/24, C=1/24 → total 6/24=1/4 → 4 hari)*

2. Pompa isi 1/3 kolam/jam, kebocoran kuras 1/9 kolam/jam, kebocoran kedua kuras 1/18 kolam/jam. Penuh?
   *(Netto: 1/3 − 1/9 − 1/18 = 6/18 − 2/18 − 1/18 = 3/18 = 1/6 → 6 jam)*

3. 8 pekerja, target 20 hari. Setelah 5 hari hujan 3 hari berhenti total. Berapa pekerja tambahan agar selesai tepat 20 hari?
   *(Total usaha=160, setelah 5 hari sisa 120 satuan, waktu tersisa 12 hari (karena 20−5−3), butuh 10 pekerja → tambah 2)*')