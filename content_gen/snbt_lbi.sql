-- SNBT LBI
INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.lbi.info_extraction'), 'Menemukan Informasi Tersurat — Scanning Cepat', 'id', 'guided', 2, 1, '## Informasi Tersurat = ADA Tertulis di Teks

Soal LBI "menemukan informasi" adalah yang PALING MUDAH karena jawabannya ada langsung di teks. Kamu hanya perlu MENCARINYA.

**Strategi scanning 3 langkah:**
1. Baca pertanyaan, temukan KATA KUNCI (nama, angka, istilah spesifik)
2. Scan teks — mata bergerak cepat mencari kata kunci itu
3. Baca 1-2 kalimat di sekitar kata kunci untuk konfirmasi

**Kata kunci umum:**
- Nama orang/tempat: Budi, Desa Sukamaju → scan huruf kapital
- Angka: 2024, 75%, 500 kg → scan digit
- Istilah khusus: bioflok, akuaponik, probiotik → scan kata unik

**Jangan baca seluruh teks!** Mata bergerak seperti scanner — lompat dari satu kata kunci ke kata kunci berikutnya.

**Jebakan:** jawaban yang KEDENGARAN benar tapi tidak ada di teks. Kalau tidak bisa menunjuk kalimatnya → SALAH.

Contoh: Teks tentang panen raya. Pertanyaan: "Berapa ton gabah yang dihasilkan?" Cari angka + "ton" + "gabah" di teks. Ketemu "2,5 ton gabah kering" → itu jawabannya.

Latihan: dalam teks tentang "revitalisasi tambak udang", temukan tahun dimulainya program revitalisasi.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.lbi.info_extraction'), 'Pertanyaan 5W1H — Kerangka Mencari Informasi', 'id', 'demo', 2, 2, '## 5W1H = What, Who, When, Where, Why, How

Setiap teks bisa "dibedah" dengan 6 pertanyaan ini:

**What (Apa):** topik/peristiwa utama
**Who (Siapa):** pelaku, tokoh, subjek
**When (Kapan):** waktu kejadian
**Where (Di mana):** lokasi
**Why (Kenapa):** alasan, penyebab, latar belakang
**How (Bagaimana):** proses, cara, mekanisme

**Contoh penerapan pada teks:**
"Pada November 2024, Dinas Perikanan Kabupaten Pati menggelar pelatihan bioflok untuk 50 pembudidaya lele di Balai Desa Sukamaju guna meningkatkan produktivitas tambak yang menurun akibat cuaca ekstrem."

- What: pelatihan bioflok
- Who: Dinas Perikanan Kabupaten Pati, 50 pembudidaya
- When: November 2024
- Where: Balai Desa Sukamaju
- Why: meningkatkan produktivitas yang menurun akibat cuaca ekstrem
- How: (perlu informasi tambahan dari teks)

**Strategi:** sebelum baca teks, tulis 5W1H. Baca teks, isi jawabannya. Kalau ada yang kosong, berarti informasi itu tidak ada di teks — soal tidak mungkin menanyakannya.

Latihan: ekstrak 5W1H dari teks tentang "program makan bergizi untuk santri.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.lbi.interpretation'), 'Interpretasi — Membaca yang Tersirat', 'id', 'case', 3, 1, '## Tersirat = ADA di Teks tapi Tidak Tertulis Langsung

Interpretasi adalah "menyimpulkan" — bukan mengarang. Kesimpulan harus DIDUKUNG teks.

**Langkah interpretasi:**
1. Kumpulkan fakta-fakta dari teks
2. Hubungkan fakta-fakta itu
3. Tarik kesimpulan yang DIDUKUNG fakta-fakta tersebut

**Contoh:**
Teks: "Harga pakan naik 40% tahun ini. Sebanyak 30% petani beralih ke pakan alternatif. Permintaan maggot sebagai pakan alternatif melonjak 200%."
Interpretasi yang DIDUKUNG: Kenaikan harga pakan mendorong petani mencari alternatif yang lebih murah.

Interpretasi yang TIDAK didukung: "Pakan alternatif lebih baik dari pakan pabrik." (teks tidak membahas kualitas!)

**Sinyal interpretasi dalam soal:**
- "Dapat disimpulkan..."
- "Pernyataan yang PALING DIDUKUNG teks adalah..."
- "Berdasarkan teks, ..."

**Kunci:** jawaban harus LULUS uji "buktikan dari teks." Kalau kamu harus menambahkan asumsi dari luar teks → jawaban itu SALAH.

Latihan: dari teks "petani muda vs petani senior dalam adopsi teknologi digital", simpulkan tantangan utama adopsi teknologi.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.lbi.interpretation'), 'Integrasi Antar-Bagian Teks', 'id', 'guided', 3, 2, '## Menghubungkan Informasi yang Terpisah

Soal LBI sering menyebar informasi terkait di beberapa paragraf berbeda. Kamu harus MENGGABUNGKANNYA.

**Contoh:**
Paragraf 1: "Program bantuan bibit lele dimulai Januari 2024 di 5 kabupaten."
Paragraf 3: "Hingga Juni 2024, program telah menjangkau 12 kabupaten."
Paragraf 5: "Target akhir program adalah 20 kabupaten pada Desember 2024."

Pertanyaan integrasi: "Berapa kabupaten tambahan yang perlu dijangkau Juli-Desember 2024?"
→ Sudah 12, target 20, perlu 8 lagi. (Gabungan dari paragraf 3 dan 5)

**Teknik integrasi:**
1. Baca pertanyaan dulu
2. Catat kata kunci dari pertanyaan
3. Scan teks untuk SEMUA kemunculan kata kunci
4. Gabungkan informasi dari setiap kemunculan
5. Hitung/simpulkan berdasarkan gabungan

**Jebakan:** jawaban yang hanya mengambil dari SATU bagian teks (parsial). Integrasi harus mencakup SEMUA informasi relevan.

**Tipe data yang sering diintegrasikan:** angka (total, selisih, persentase), waktu (durasi, urutan kronologi), lokasi (cakupan wilayah), aktor (siapa melakukan apa).

Latihan: teks 4 paragraf tentang "bantuan pompa air di 3 kecamatan" — berapa total bantuan? Di mana bantuan terbesar?');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.lbi.evaluation'), 'Evaluasi & Refleksi — Menilai Kualitas Teks', 'id', 'discussion', 4, 1, '## Evaluasi = Menilai, Bukan Menyimpulkan

Evaluasi adalah level tertinggi dalam LBI karena kamu harus MENILAI teks itu sendiri: kelebihan, kekurangan, bias, kredibilitas.

**Aspek yang dievaluasi:**
1. **Kelengkapan:** apakah informasi cukup? Ada yang hilang?
2. **Keberimbangan:** apakah kedua sisi dibahas? Atau hanya satu sudut pandang?
3. **Objektivitas:** fakta vs opini. Ada bias penulis?
4. **Relevansi data:** data yang disajikan mendukung kesimpulan?
5. **Struktur:** alur logis? Mudah diikuti?

**Contoh evaluasi:**
"Teks hanya menyajikan keunggulan bioflok tanpa membahas kendalanya. Data yang dikutip hanya dari satu sumber. Tidak ada sudut pandang petani kecil."
→ Kelemahan: tidak berimbang, sumber terbatas.

**Kata kunci soal evaluasi:**
- "Kelemahan teks..."
- "Agar lebih objektif, teks perlu menambahkan..."
- "Penulis menunjukkan keberpihakan pada..."

**Teknik:** baca sebagai KRITIKUS, bukan sebagai pembaca biasa. Tanya terus: "apa yang KURANG dari teks ini?" Bukan "apa isi teks ini?"

Latihan: evaluasi teks "manfaat vaksinasi ikan" — apa kelemahan utamanya?');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.lbi.evaluation'), 'Refleksi — Menghubungkan Teks dengan Konteks Lebih Luas', 'id', 'case', 4, 2, '## Refleksi = Teks dalam Konteks Dunia Nyata

Refleksi menguji kemampuan menghubungkan isi teks dengan situasi di luar teks — tanpa kehilangan pijakan pada teks.

**Pertanyaan reflektif:**
- "Apa implikasi...?"
- "Bagaimana penerapannya di...?"
- "Apa dampaknya bagi...?"
- "Relevansi teks dengan kondisi...?"

**Contoh:**
Teks tentang "digitalisasi pembayaran di pasar tradisional."
Refleksi: "Bagaimana nasib pedagang lansia yang tidak terbiasa dengan teknologi?"
→ Jawaban harus: (a) berakar pada teks (digitalisasi), (b) menghubungkan ke realitas (lansia & teknologi).

**Yang membedakan refleksi dari interpretasi:**
- Interpretasi: "apa yang tersirat DALAM teks"
- Refleksi: "apa artinya teks ini UNTUK dunia di luar"

**Kunci:** jangan lepas dari teks! Refleksi yang baik SELALU bisa ditelusuri kembali ke teks. "Jembatan"-nya harus jelas: "Karena teks menyebutkan X, maka dalam konteks Y terjadi Z."

**Hindari:** refleksi yang murni opini pribadi tanpa dasar dari teks.

Latihan: teks "otomatisasi pabrik pakan" → refleksikan dampaknya terhadap lapangan kerja di pedesaan.');