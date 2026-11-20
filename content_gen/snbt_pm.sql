-- SNBT PM
INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pm.formulate'), 'Merumuskan Model Matematika — Dari Soal Cerita ke Persamaan', 'id', 'guided', 3, 1, '## Empat Langkah Menerjemahkan Soal Cerita

Soal PM nomor 1 selalu minta kamu mengubah narasi jadi model matematika. Ini adalah skill PALING PENTING di PM.

**Langkah 1: Baca dan tandai informasi kunci.**
"Ayah membeli 3 kg lele dan 2 kg nila seharga Rp85.000. Di tempat yang sama, 2 kg lele dan 3 kg nila seharga Rp75.000."

**Langkah 2: Definisikan variabel.**
Misal: x = harga 1 kg lele, y = harga 1 kg nila.

**Langkah 3: Tulis persamaan dari setiap kalimat.**
Kalimat 1: 3x + 2y = 85.000
Kalimat 2: 2x + 3y = 75.000

**Langkah 4: Selesaikan model.**
Eliminasi: (1)×3 → 9x + 6y = 255.000 | (2)×2 → 4x + 6y = 150.000
Kurangkan: 5x = 105.000 → x = 21.000, lalu y = 11.000

**Kamus terjemahan:**
- "lebih banyak p% dari" → ×(1 + p/100)
- "lebih sedikit p% dari" → ×(1 − p/100)
- "dua kali lipat" → ×2
- "setengah dari" → ×½
- "selisih" → |a − b| atau a − b (tergantung konteks)
- "jumlah" → a + b
- "hasil kali" → a × b

**Kunci:** jangan langsung menghitung. Pastikan MODELNYA BENAR dulu. Cek: apakah setiap kalimat dalam soal sudah jadi persamaan?

Latihan: "Panen bulan ini 25% lebih banyak dari bulan lalu. Total dua bulan 1.800 kg. Berapa panen bulan lalu?" → Tulis modelnya dulu.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pm.formulate'), 'Fungsi sebagai Model — Variabel yang Saling Mempengaruhi', 'id', 'scenario', 3, 2, '## Fungsi = Hubungan Ketergantungan

Dalam PM, fungsi digunakan untuk MEMODELKAN hubungan sebab-akibat.

**Contoh:** "Harga jual lele per kg turun Rp500 untuk setiap penambahan pasokan 1 ton. Harga dasar Rp25.000 saat pasokan 0."

Model: Harga(x) = 25.000 − 500x, dengan x = pasokan (ton).
→ Fungsi linear dengan gradien negatif.

**Jenis fungsi di PM:**
1. Linear: y = mx + c (perubahan konstan)
2. Kuadrat: y = ax² + bx + c (perubahan bertambah/berkurang)
3. Eksponensial: y = a·bˣ (pertumbuhan/peluruhan)

**Contoh fungsi kuadrat:**
"Keuntungan K (dalam ribuan) bergantung pada jumlah bibit x: K(x) = −2x² + 40x − 150."
Titik maksimum: x = −b/(2a) = −40/(−4) = 10 → keuntungan maksimum saat 10 bibit.

**Kapan pakai fungsi apa?**
- Linear: "setiap penambahan X, Y bertambah/berkurang SEJUMLAH TETAP"
- Kuadrat: "Y mencapai MAKSIMUM/MINIMUM pada nilai X tertentu"
- Eksponensial: "Y bertambah/berkurang dengan PERSENTASE tetap"

**Kunci:** cari kata "setiap", "per", "bergantung pada", "sebagai fungsi dari" — itu sinyal model fungsi.

Latihan: "Populasi ikan di kolam bertambah 15% per bulan. Awalnya 1.000 ekor. Tulis fungsi populasinya setelah t bulan.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pm.employ'), 'Menerapkan Prosedur — Strategi Sistematis', 'id', 'demo', 3, 1, '## Prosedur = Algoritma Pemecahan Masalah

Soal PM yang meminta "menerapkan prosedur" menguji kemampuan menjalankan LANGKAH-LANGKAH matematis dengan benar.

**Prosedur umum:**
1. Substitusi nilai ke rumus
2. Operasi aljabar (ekspansi, faktorisasi)
3. Turunan/integral sederhana
4. Operasi matriks atau vektor

**Contoh prosedural:**
"f(x) = 3x² − 2x + 5. Tentukan f(4) dan f''(2)."
Langkah 1: f(4) = 3(16) − 2(4) + 5 = 48 − 8 + 5 = 45
Langkah 2: f''(x) = 6x − 2
Langkah 3: f''(2) = 6(2) − 2 = 10

**Yang dinilai di PM:**
- Apakah langkah-langkahnya BENAR?
- Apakah urutannya LOGIS?
- Apakah hasil akhirnya AKURAT?

**Kesalahan paling umum:**
- Lupa tanda negatif
- Salah substitusi (x diganti angka yang salah)
- Operasi tidak lengkap (baru setengah jalan)
- Salah pakai rumus

**Teknik menghindari kesalahan:**
1. Tulis rumus dulu, baru substitusi
2. Cek satuan (apakah konsisten?)
3. Cek balik: masukkan hasil ke persamaan awal → apakah benar?
4. Tanya: "apakah hasil ini masuk akal?"

Latihan: selesaikan sistem 2x + 3y = 13, 5x − y = 7 dengan prosedur eliminasi-substitusi. Cek hasilnya.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pm.employ'), 'Prosedur Multi-Langkah — Komposisi Operasi', 'id', 'demo', 3, 2, '## Rangkai Prosedur Tanpa Kehilangan Arah

Soal PM sering meminta beberapa prosedur digabung. Output langkah 1 jadi input langkah 2.

**Contoh rantai prosedur:**
"Soal: Hitung rata-rata dari f(1), f(2), f(3) jika f(x) = x² + 1."
Langkah 1: Hitung f(1) = 2
Langkah 2: Hitung f(2) = 5
Langkah 3: Hitung f(3) = 10
Langkah 4: Rata-rata = (2+5+10)/3 = 17/3 ≈ 5.67

**Contoh soal kontekstual PM:**
"Kolam berbentuk persegi panjang dengan panjang (2x+5) m dan lebar (x+3) m. Jika x = 4, hitung: (a) luas kolam, (b) volume air jika kedalaman 1.5 m."

Langkah 1: Substitusi x = 4
- p = 2(4)+5 = 13 m, l = 4+3 = 7 m
Langkah 2: Luas = p × l = 13 × 7 = 91 m²
Langkah 3: Volume = luas × kedalaman = 91 × 1.5 = 136.5 m³

**Prinsip penting:**
- Tulis hasil setiap langkah dengan JELAS — jangan di kepala
- Label setiap hasil (L₁ = ..., V = ...) agar tidak tertukar
- Cek satuan di akhir (m² untuk luas, m³ untuk volume)

**Anti-error:** setelah selesai, telusuri ulang setiap langkah dari bawah ke atas. Kalau ada yang janggal, periksa langkah itu.

Latihan: f(x) = 2x² − 3x + 1, g(x) = x + 2. Hitung f(g(3)) langkah demi langkah.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pm.interpret'), 'Menafsirkan Hasil — Kembali ke Konteks', 'id', 'case', 4, 1, '## Interpretasi = Menjawab "Jadi Apa?"

Ini langkah terakhir dan TERPENTING di PM. Kamu sudah menghitung — sekarang jelaskan ARTINYA dalam konteks soal.

**Contoh:**
Soal: "Keuntungan K(x) = −2x² + 40x − 150, x = jumlah bibit (dalam ribuan)."
Hasil hitung: Maximum di x = 10, K(10) = 50.

Interpretasi yang BENAR: "Keuntungan maksimum sebesar Rp50.000 dicapai saat menggunakan 10.000 bibit."
Interpretasi yang KURANG: "x = 10, K = 50." (hanya mengulang angka, tidak menjelaskan artinya)

**Tiga level interpretasi:**
1. **Numerik:** "Nilai x = 10, K = 50."
2. **Konteks:** "Dengan 10.000 bibit, keuntungan Rp50.000."
3. **Implikasi:** "Menambah bibit di atas 10.000 justru menurunkan keuntungan. Petani sebaiknya tidak melebihi jumlah ini." ← PM suka yang ini!

**Pertanyaan interpretasi di PM:**
- "Apa makna nilai tersebut dalam konteks?"
- "Apakah solusi ini realistis?"
- "Apa rekomendasi berdasarkan hasil?"

**Teknik:** bayangkan kamu menjelaskan hasilnya ke orang yang TIDAK melihat perhitunganmu. Kalau mereka bisa paham konteksnya, interpretasimu bagus.

**Kesalahan umum:** memberikan interpretasi yang tidak didukung hasil hitungan. Hasil = 50, lalu klaim "keuntungan besar" tanpa mendefinisikan "besar" itu apa.

Latihan: Hasil hitungan menunjukkan titik impas di x = 5 bulan. Interpretasikan dalam konteks usaha pembesaran lele.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pm.interpret'), 'Mengevaluasi Hasil — Apakah Masuk Akal?', 'id', 'discussion', 4, 2, '## Tidak Semua Hasil Matematis Masuk Akal

PM menguji kemampuan mengevaluasi: apakah hasil perhitungan LOGIS dalam konteks dunia nyata?

**Cek kelayakan:**
1. Apakah nilainya masuk akal? (Tidak mungkin ada −3 petani atau 500% probabilitas)
2. Apakah ada batasan yang terlewat? (x ≥ 0, x harus bilangan bulat)
3. Apakah solusinya bisa diterapkan? (Teorinya benar, praktiknya?)

**Contoh evaluasi:**
Soal: "Biaya produksi C(x) = 50.000 + 2.000x. Harga jual = 3.000 per unit. Berapa unit agar untung?"

Hasil: x > 50 (baru untung di atas 50 unit).

Evaluasi: "Secara matematis benar. Namun, kapasitas produksi maksimum 40 unit per bulan. Dalam kondisi saat ini, usaha BELUM bisa untung. Perlu meningkatkan kapasitas atau menaikkan harga jual."

**Yang dinilai:**
- Apakah kamu sadar ada BATASAN di luar model matematika?
- Apakah kamu bisa memberi SARAN berdasarkan analisis?

**Sinyal soal evaluasi:**
- "Berdasarkan hasil, apakah..."
- "Menurutmu, apakah solusi ini..."
- "Berikan evaluasi terhadap..."

**Kunci:** model matematika adalah PENYEDERHANAAN realitas. Selalu ada faktor di luar model. Sebutkan faktor-faktor itu dalam evaluasimu.

Latihan: Model menunjukkan panen optimal di kepadatan 100 ekor/m². Tapi literatur budidaya merekomendasikan maksimal 75 ekor/m². Evaluasi hasil model ini.');