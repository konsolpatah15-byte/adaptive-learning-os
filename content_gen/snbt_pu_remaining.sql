-- SNBT PU remaining competencies
INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pu.implication'), 'Implikasi Logika — "Kalau...Maka..." dalam Soal PU', 'id', 'analogy', 2, 1, '## Implikasi = Janji Bersyarat

Bayangkan kamu bilang ke teman: "Kalau hujan, aku bawa payung."

Kapan kamu BOHONG? HANYA ketika hujan TAPI kamu tidak bawa payung.
Kalau tidak hujan? Kamu bebas — bawa atau tidak, kamu tidak bohong.

**Tabel kebenaran implikasi p → q:**
- p BENAR, q BENAR → implikasi BENAR (hujan, bawa payung)
- p BENAR, q SALAH → implikasi SALAH (hujan, tidak bawa — BOHONG!)
- p SALAH, q BENAR → implikasi BENAR (tidak hujan, tetap bawa)
- p SALAH, q SALAH → implikasi BENAR (tidak hujan, tidak bawa)

**Kunci: implikasi hanya SALAH saat janji dilanggar.**

Contoh soal PU: "Jika panen bagus maka harga turun." Kapan pernyataan ini SALAH?
Jawab: Saat panen bagus TAPI harga TIDAK turun.

**Kontraposisi (selalu ekuivalen):** p → q ≡ ~q → ~p
"Kalau panen bagus maka harga turun" ≡ "Kalau harga tidak turun maka panen tidak bagus."

**Kesalahan klasik (jangan terkecoh!):**
- Konvers: q → p (harga turun → panen bagus) — TIDAK ekuivalen!
- Invers: ~p → ~q (panen tidak bagus → harga tidak turun) — TIDAK ekuivalen!

Latihan: "Kalau diberi pakan teratur, ikan tumbuh sehat." Coba tulis kontraposisinya.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pu.implication'), 'Implikasi dan Penarikan Kesimpulan', 'id', 'guided', 2, 2, '## Tiga Pola Penarikan Kesimpulan

**1. Modus Ponens (MP) — yang paling sering muncul**
Premis 1: p → q (kalau hujan, jalan basah)
Premis 2: p (hujan)
Kesimpulan: q (jalan basah) — PASTI benar

**2. Modus Tollens (MT)**
Premis 1: p → q
Premis 2: ~q (jalan TIDAK basah)
Kesimpulan: ~p (TIDAK hujan) — PASTI benar

**3. Silogisme**
Premis 1: p → q
Premis 2: q → r
Kesimpulan: p → r — PASTI benar

**Dua jebakan yang BUKAN kesimpulan valid:**
- p → q, q → kesimpulan p? ❌ (affirming the consequent)
- p → q, ~p → kesimpulan ~q? ❌ (denying the antecedent)

Contoh: "Semua pembudidaya yang sukses mencatat keuangan. Budi mencatat keuangan."
Apakah Budi sukses? TIDAK PASTI — ini affirming the consequent.

**Strategi mengerjakan:** tulis ulang premis sebagai simbol (p, q, r), lalu cek apakah kesimpulan mengikuti salah satu dari TIGA pola valid di atas.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pu.deduction'), 'Deduksi & Silogisme — Menarik Kesimpulan Pasti', 'id', 'demo', 2, 1, '## Silogisme Kategoris: Semua, Sebagian, Tidak Ada

**Tipe pernyataan:**
- A: Semua A adalah B (universal afirmatif)
- I: Sebagian A adalah B (partikular afirmatif)
- E: Tidak ada A yang B (universal negatif)
- O: Sebagian A bukan B (partikular negatif)

**Aturan silogisme valid:**
1. Dua premis negatif → TIDAK VALID
2. Dua premis partikular → TIDAK VALID
3. Term tengah harus minimal satu kali universal

Contoh klasik:
- Premis 1: Semua mamalia bernapas dengan paru-paru
- Premis 2: Semua paus adalah mamalia
- Kesimpulan: Semua paus bernapas dengan paru-paru ✔ (Valid!)

Cek: term tengah "mamalia" di Premis 1 = universal (semua). Aturan 3 terpenuhi.

**Silogisme hipotetik (p → q, q → r, ∴ p → r):**
"Kalau kolam penuh, air meluap. Kalau air meluap, jalan licin. Jadi kalau kolam penuh, jalan licin." ✔

**Kunci: kesimpulan PASTI = TIDAK MUNGKIN salah kalau premis benar.**
Kalau kamu bisa bayangkan satu situasi di mana premis benar tapi kesimpulan salah → kesimpulan TIDAK pasti.

Latihan: "Semua ikan lele bisa hidup di air keruh. Sebagian ikan di kolam ini adalah lele." Kesimpulan yang PASTI?');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pu.deduction'), 'Deduksi dengan Diagram — Visualisasi Himpunan', 'id', 'visual', 2, 2, '## Gambar Dulu, Simpulkan Kemudian

Untuk soal deduksi yang kompleks, gambar diagram hubungan antar himpunan.

**Soal:** "Semua A adalah B. Semua B adalah C. Sebagian D adalah A."

Gambar: Lingkaran A di dalam B, B di dalam C. Lalu D sebagian masuk ke A.

Kesimpulan yang PASTI:
- Sebagian D adalah B ✔ (karena D sebagian di A, dan A semua di B)
- Sebagian D adalah C ✔ (karena D sebagian di A → B → C)
- Semua A adalah C ✔ 

Kesimpulan yang TIDAK pasti:
- Semua D adalah A ❌ (hanya "sebagian")
- Sebagian C adalah D ✔ (ini pasti! karena D masuk ke A yang masuk ke C)

**Teknik eliminasi:** untuk setiap opsi jawaban, cek diagram. Kalau ada SATU konfigurasi yang konsisten dengan premis tapi membuat opsi itu salah → buang.

**Latihan visual:** gambar diagram untuk:
"Semua ikan nila adalah herbivora. Sebagian herbivora bisa dibudidayakan di kolam terpal. Tidak ada lele yang herbivora."
Apa yang PASTI tentang lele?');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pu.analytical'), 'Penalaran Analitis — Posisi, Urutan, dan Pengelompokan', 'id', 'demo', 3, 1, '## Soal Urutan — Bikin Tabel Posisi

**Soal:** Enam petani (A, B, C, D, E, F) duduk melingkar. A di seberang D. B di kanan C. E di antara A dan F. Siapa di kanan D?

**Langkah 1 — Gambar lingkaran dengan 6 posisi (diberi nomor 1-6).**
**Langkah 2 — Pasang A di posisi 1, maka D di posisi 4 (seberang = 3 langkah).**
**Langkah 3 — E di antara A dan F → A-E-F atau F-E-A.**
**Langkah 4 — B di kanan C → B satu langkah searah jarum jam dari C.**
**Langkah 5 — Isi posisi yang tersisa, cek semua aturan terpenuhi.**

**Kunci:** Mulai dari aturan yang paling MEMBATASI (biasanya "di seberang", "di antara", "di samping").

**Jenis soal analitis:**
1. Urutan linear (antrian, peringkat, jadwal)
2. Posisi melingkar (meja bundar)
3. Pengelompokan (tim, komite)
4. Penjadwalan (shift kerja, alokasi ruang)

Untuk pengelompokan: buat tabel dengan anggota vs kelompok, isi yang PASTI dulu, baru yang mungkin.

**Latihan:** "Lima pembudidaya P, Q, R, S, T mengikuti pelatihan di hari Senin-Jumat, satu per hari. P sebelum Q. R setelah S. T di hari Rabu. Kapan Q paling cepat?" Gunakan teknik tabel.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pu.analytical'), 'Penalaran Analitis — Strategi Eliminasi Cepat', 'id', 'guided', 3, 2, '## Tidak Perlu Selesaikan Semua — Cukup Yang Ditanya

**Strategi hemat waktu:**
1. Baca aturan, bukan narasi panjang
2. Tandai aturan yang MEMBATASI (pasti, harus, tidak boleh)
3. Untuk soal "mana yang tidak mungkin" → uji setiap opsi, cari yang melanggar aturan
4. Untuk soal "urutan yang mungkin" → eliminasi opsi yang melanggar SATU aturan saja

**Contoh soal cepat:**
Aturan: (1) X tidak boleh dengan Y, (2) Z harus di posisi 3, (3) W sebelum X.

"Mana kelompok yang TIDAK mungkin?" → cukup cek opsi satu per satu. Begitu ketemu yang melanggar (misal X dan Y satu kelompok), itu jawabannya. Selesai. Jangan teruskan cek opsi lain.

**Teknik "ujung ke ujung":**
Untuk soal posisi: kalau ada 6 posisi, tes apakah A bisa di posisi 1, lalu posisi 6. Dua ujung ini biasanya paling membatasi — kalau keduanya mungkin, yang di tengah hampir pasti mungkin.

**Kesalahan umum:** membaca ulang seluruh narasi untuk setiap soal. Lebih efisien: tulis aturan SEKALI dalam bentuk singkat, lalu pakai aturan itu untuk SEMUA soal dalam satu set.

Latihan: "P, Q, R, S, T duduk berjajar. Q tidak di ujung. R di antara P dan S. T di kanan Q." Siapa yang PASTI di posisi 1?');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pu.argument_eval'), 'Evaluasi Argumen — Membedakan Argumen Kuat dan Lemah', 'id', 'case', 3, 1, '## Argumen = Klaim + Alasan + Bukti

**Struktur argumen:**
- Klaim (claim): apa yang ingin dibuktikan
- Alasan (reason): kenapa klaim itu benar
- Bukti (evidence): data, fakta, contoh yang mendukung
- Asumsi (assumption): yang dianggap benar tanpa dibuktikan

**Ciri argumen KUAT:**
1. Alasan relevan dengan klaim
2. Bukti cukup dan spesifik
3. Mempertimbangkan sudut pandang berlawanan
4. Tidak mengandung logical fallacy

**Ciri argumen LEMAH:**
1. Alasan tidak nyambung (non sequitur)
2. Generalisasi terburu-buru (hasty generalization)
3. Menyerang orang, bukan argumen (ad hominem)
4. Argumen melingkar (begging the question)

**Contoh evaluasi:**
Klaim: "Pakan buatan lebih baik dari pakan alami."
Argumen A: "Karena saya sudah 20 tahun beternak." → LEMAH (otoritas tanpa data, appeal to tradition)
Argumen B: "Studi 3 tahun di 50 kolam menunjukkan pakan buatan meningkatkan bobot panen 15%." → KUAT (data spesifik)

**Yang sering muncul di PU:** "Manakah yang MEMPERLEMAH argumen di atas?" → cari opsi yang membuat ASUMSI argumen tidak berlaku.

Latihan: klaim "Semua pembudidaya sukses menggunakan probiotik." Argumen mana yang paling melemahkan?');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pu.argument_eval'), 'Logical Fallacies — 7 Jebakan yang Sering Muncul', 'id', 'case', 3, 2, '## Tujuh Logical Fallacy yang Wajib Dikenali

**1. Ad Hominem:** Menyerang orang, bukan argumen.
"Kamu tidak boleh ngomong soal budidaya, kamu kan bukan sarjana perikanan." → tidak relevan!

**2. Straw Man:** Memelintir argumen lawan, lalu menyerang versi pelintirannya.
"Katanya pakai probiotik bagus? Jadi kamu bilang pakan biasa beracun?" → tidak ada yang bilang begitu.

**3. False Dilemma:** Hanya memberi dua pilihan, padahal ada lebih.
"Kamu pilih kuliah atau jadi pengangguran?" → ada pilihan lain (kursus, wirausaha, dll).

**4. Slippery Slope:** A → B → C → bencana, tanpa bukti tiap langkah.
"Kalau izin tambak diperlonggar, lingkungan rusak, semua ikan mati, ekonomi hancur."

**5. Hasty Generalization:** Kesimpulan dari sampel terlalu kecil.
"Dua petani gagal pakai probiotik, jadi probiotik tidak efektif."

**6. Post Hoc:** Karena A terjadi sebelum B, maka A penyebab B.
"Setelah saya ganti pakan, panen bagus. Jadi pakan baru penyebabnya." → bisa jadi faktor lain.

**7. Circular Reasoning:** Kesimpulan = premis yang diulang.
"Probiotik itu bagus karena probiotik bermanfaat." → tidak ada bukti baru.

**Cara menjawab soal "kelemahan argumen":** identifikasi dulu JENIS fallacy-nya, baru cari opsi yang mengungkap fallacy itu.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pu.number_patterns'), 'Pola Bilangan — Deret Fibonacci, Aritmetika, Geometri', 'id', 'demo', 2, 1, '## Tiga Pola Dasar + Variasinya

**1. Deret Aritmetika:** selisih KONSTAN
2, 5, 8, 11, 14, ... → selisih = +3 → suku berikutnya: 17, 20

**2. Deret Geometri:** rasio KONSTAN
3, 6, 12, 24, 48, ... → rasio = ×2 → selanjutnya: 96, 192

**3. Deret Fibonacci:** suku = jumlah dua suku sebelumnya
2, 3, 5, 8, 13, 21, ... → 8+13=21 → selanjutnya: 34, 55

**Pola campuran (yang bikin susah):**
- Loncat: 2, 5, 4, 7, 6, 9, ... → posisi ganjil: +2, posisi genap: +2
- Operasi bergantian: 3, 6, 4, 8, 6, 12, ... → ×2, −2, ×2, −2, ×2...
- Kuadrat: 1, 4, 9, 16, 25, ... → n²
- Segitiga: 1, 3, 6, 10, 15, ... → +2, +3, +4, +5...

**Teknik menemukan pola:**
1. Hitung selisih antar suku. Konstan? → aritmetika.
2. Kalau selisihnya berubah, hitung selisih kedua (selisih dari selisih). Konstan? → kuadratik.
3. Cek rasio. Konstan? → geometri.
4. Cek penjumlahan dua suku berturut-turut.

**Contoh soal PU:** 3, 5, 9, 17, 33, ... → selisih: +2, +4, +8, +16 (×2). Selanjutnya: 33+32 = 65.

Latihan: temukan 2 suku berikutnya dari 1, 4, 2, 8, 4, 16, ... (petunjuk: operasi bergantian)');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pu.number_patterns'), 'Pola dalam Tabel dan Gambar — Melampaui Deret Linear', 'id', 'visual', 2, 2, '## Pola Bisa di Mana Saja — Bukan Cuma Deret

**Pola tabel:**
| 2 | 5 | 10 |
| 3 | 8 | 17 |
| 4 | 11 | ? |

Cek per baris: baris 1 → 2, 2+3=5, 5+5=10 (+3, +5). Baris 2 → 3, 3+5=8, 8+9=17 (+5, +9). Baris 3 → 4, 4+7=11, 11+13=24.
Atau cek per kolom: kolom 1 → 2,3,4 (+1). Kolom 2 → 5,8,11 (+3). Kolom 3 → 10,17,? (+7). Pola selisih: +7 maka ? = 17+7 = 24.

**Pola gambar/figural:**
- Rotasi: berputar 90°, 180°
- Refleksi: cermin horizontal/vertikal
- Penambahan/pengurangan elemen
- Perubahan ukuran, warna, atau pola arsiran

**Pola spiral/matriks:**
1  2  6
3  5  7
4  8  ?

Bisa dibaca zigzag: 1→2→3→4→5→6→7→8→? → 1,2,3,4,5,6,7,8,9
Atau pola lain: tiap kolom punya aturan sendiri.

**Kunci:** jangan terpaku pada satu arah baca. Coba vertikal, horizontal, diagonal, spiral. Kalau tidak ketemu, cek operasi matematika antar sel (penjumlahan, perkalian, selisih).

Latihan: temukan ? pada tabel:
| 5 | 12 | 23 |
| 7 | 16 | 31 |
| 9 | 20 | ? |');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pu.productivity'), 'Produktivitas Langsung — Hasil per Satuan Input', 'id', 'scenario', 2, 1, '## Produktivitas = Output ÷ Input

**Rumus dasar:**
- Produktivitas per pekerja = total hasil ÷ jumlah pekerja
- Produktivitas per jam = total hasil ÷ total jam
- Produktivitas per lahan = total panen ÷ luas lahan

**Contoh:** 5 pekerja memanen 300 kg lele dalam 4 jam.
- Total hasil = 300 kg
- Produktivitas per pekerja = 300 ÷ 5 = 60 kg/pekerja
- Produktivitas per jam-kerja = 300 ÷ (5×4) = 15 kg/jam-orang

**Variasi soal:** perbandingan produktivitas.
"Kolam A: 2 pekerja, 400 kg, 5 jam. Kolam B: 3 pekerja, 540 kg, 6 jam. Mana yang lebih produktif per jam-kerja?"
- Kolam A: 400 ÷ (2×5) = 40 kg/jam-orang
- Kolam B: 540 ÷ (3×6) = 30 kg/jam-orang
→ Kolam A lebih produktif.

**Hati-hati:** produktivitas BUKAN work-rate (berbalik nilai). Produktivitas = seberapa EFISIEN, work-rate = seberapa CEPAT.

**Soal PU sering menjebak dengan mencampur produktivitas dan work-rate dalam satu soal. Baca dulu: yang ditanya produktivitas (output per input) atau waktu penyelesaian (work-rate)?**

Latihan: "Mesin A: 120 bungkus pakan dalam 3 jam. Mesin B: 200 bungkus dalam 4 jam. Berapa bungkus yang dihasilkan jika kedua mesin bekerja bersama selama 5 jam?" (Hati-hati: ini produktivitas langsung, BUKAN work-rate berbalik nilai!)');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pu.productivity'), 'Perbandingan Produktivitas Multi-Variabel', 'id', 'guided', 2, 2, '## Membandingkan Produktivitas dengan Satuan Berbeda

**Trik: samakan satuan dulu.**

Soal: "Petani A: 2 ton padi dari 0.5 ha. Petani B: 3.5 ton dari 0.8 ha. Siapa lebih produktif?"

Samakan ke ton/ha:
- A: 2 ÷ 0.5 = 4 ton/ha
- B: 3.5 ÷ 0.8 = 4.375 ton/ha → B lebih produktif.

**Produktivitas dengan perubahan:**
"Bulan lalu: 500 kg, 4 pekerja. Bulan ini: pekerja sama, hasil naik 20%. Produktivitas naik berapa persen?"
- Bulan lalu: 500 ÷ 4 = 125 kg/pekerja
- Bulan ini: 500 × 1.2 = 600 kg, 600 ÷ 4 = 150 kg/pekerja
- Kenaikan: (150 − 125) ÷ 125 × 100% = 20% → SAMA dengan kenaikan output karena pekerja tetap.

**Rumus cepat:** kalau input tetap, % perubahan produktivitas = % perubahan output.

**Yang bikin susah:** output dan input dua-duanya berubah.
"Output naik 30%, jumlah pekerja turun 20%. Produktivitas naik berapa?"
- Awal: output O, pekerja P → produktivitas = O/P
- Akhir: output 1.3O, pekerja 0.8P → produktivitas = 1.3O / 0.8P = 1.625 O/P
- Kenaikan: 62.5%

**Rumus: produktivitas baru = (1 + %Δoutput) / (1 + %Δinput) × produktivitas lama.**

Latihan: "Panen naik 40%, luas lahan berkurang 30%. Produktivitas per hektar naik berapa persen?');