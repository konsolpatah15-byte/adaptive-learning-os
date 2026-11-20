-- SNBT PBM curriculum content
INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pbm.spelling'), 'Ejaan & PUEBI — 10 Kesalahan Paling Umum', 'id', 'direct', 2, 1, '## Ejaan yang Sering Salah di Soal PBM

**1. "di" sebagai kata depan vs awalan:**
- Kata depan (tempat): ditulis TERPISAH → di kolam, di pasar, di sini
- Awalan (pasif): ditulis GABUNG → dimakan, dijual, dipanen
- Trik: kalau bisa diganti "ke" → kata depan (pisah)

**2. Partikel "pun":**
- Kata penghubung: ditulis GABUNG → walaupun, sekalipun, bagaimanapun
- Bermakna "juga": ditulis PISAH → saya pun, apa pun, siapa pun

**3. Gabungan kata yang dapat awalan/akhiran:**
- "tanda tangani" → BENAR (awalan di akhir)
- "tandatangani" → SALAH
- "bertanggung jawab" → BENAR (awalan di awal)
- "ber-tanggungjawab" → SALAH

**4. Huruf kapital:**
- Nama diri, gelar (diikuti nama), hari, bulan, lembaga → KAPITAL
- Nama bangsa, bahasa, suku → KAPITAL
- "Tuhan", "Yang Mahakuasa" → KAPITAL

**5. Angka dan bilangan:**
- Ditulis huruf: di awal kalimat, bilangan kecil (satu, dua), dokumen resmi
- Ditulis angka: di tengah kalimat, data statistik, jam

Latihan: perbaiki kalimat "di saat musim hujan tiba, para petani di desa sukamaju mulai mengolah sawahnya.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pbm.spelling'), 'Kata Baku vs Tidak Baku — Bedakan dengan Cepat', 'id', 'guided', 2, 2, '## Pasangan Baku-Tidak Baku yang Sering Muncul

Kesalahan paling umum di PBM adalah kata tidak baku yang "kedengaran benar" karena sering dipakai sehari-hari.

**Daftar penting:**
| Tidak Baku | Baku |
|-----------|------|
| fikir | pikir |
| faham | paham |
| nasehat | nasihat |
| himbau | imbau |
| jaman | zaman |
| ijin | izin |
| ijasah | ijazah |
| ijasah | ijazah |
| karna | karena |
| rubah | ubah |
| pasip | pasif |
| aktip | aktif |
| apotik | apotek |
| atlit | atlet |
| cidera | cedera |
| duren | durian |
| esok | besok |
| fotocopy | fotokopi |
| hisap | isap |
| nafas | napas |

**Trik cepat:** kata serapan asing biasanya pakai F, Z, K, S (aktif, zaman, izin, napas). Bukan P, J, I, F seperti lidah Indonesia.

**Kata yang sering salah di konteks formal:**
- "mempengaruhi" → SALAH, yang benar "memengaruhi" (pengaruh → meN- + pengaruh, P luluh)
- "mentaati" → SALAH, yang benar "menaati" (taat → meN- + taat, T luluh)
- "mensahkan" → SALAH, yang benar "mengesahkan" (sah → meN- + sah)

Latihan: dari 5 kata berikut, mana yang SEMUA bakunya benar? a) fikir, jaman, ijin b) pikir, zaman, izin c) pikir, jaman, ijin');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pbm.effective_sentence'), 'Kalimat Efektif — Syarat dan Ciri-cirinya', 'id', 'direct', 3, 1, '## Kalimat Efektif = Hemat, Jelas, Logis

**7 syarat kalimat efektif:**
1. **Kesejajaran (paralelisme):** imbuhan yang sama untuk fungsi yang sama
   ❌ "Kegiatannya meliputi membeli, penjualan, dan mengelola."
   ✔ "Kegiatannya meliputi pembelian, penjualan, dan pengelolaan."

2. **Kehematan:** hindari kata yang tidak perlu
   ❌ "Para petani-petani itu sedang mengadakan pertemuan."
   ✔ "Para petani itu mengadakan pertemuan." (tidak perlu "sedang" dan ulangan jamak)

3. **Kelogisan:** masuk akal
   ❌ "Waktu dan tempat kami persilakan." → yang dipersilakan ORANG, bukan waktu
   ✔ "Bapak Kepala Desa kami persilakan."

4. **Kepaduan:** hubungan antar kata jelas
   ❌ "Dia menceritakan tentang pengalamannya." → "tentang" tidak perlu
   ✔ "Dia menceritakan pengalamannya."

5. **Ketepatan diksi:** kata yang tepat
   ❌ "Panen kali ini lumayan sempurna." → "sempurna" tidak bisa "lumayan"
   ✔ "Panen kali ini cukup baik."

6. **Kecermatan:** tidak ambigu
   ❌ "Istri pembudidaya yang rajin itu ramah." → siapa yang rajin?
   ✔ "Istri pembudidaya rajin itu ramah."

7. **Subjek-predikat jelas:**
   ❌ "Dalam pertemuan itu membahas harga pakan." → tidak ada subjek
   ✔ "Pertemuan itu membahas harga pakan."

Latihan: perbaiki "Bagi para petani dihimbau untuk segera melaporkan hasil panennya.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pbm.effective_sentence'), 'Memperbaiki Kalimat Tidak Efektif', 'id', 'guided', 3, 2, '## Bedah dan Perbaiki Kalimat

Soal PBM sering minta kamu MEMPERBAIKI kalimat, bukan cuma mengenali kesalahan.

**Langkah perbaikan:**
1. Temukan SUBJEK dan PREDIKAT — kalau tidak jelas, itu masalah utama
2. Buang kata mubazir (para ... -nya, adalah, daripada, tentang, dari, untuk)
3. Perbaiki kesejajaran imbuhan
4. Cek kelogisan (apakah subjeknya bisa melakukan predikat itu?)

**Contoh perbaikan bertahap:**

Kalimat asli: "Dalam penelitian ini bertujuan untuk mengetahui pengaruh daripada probiotik terhadap pertumbuhan ikan lele."

Langkah 1: subjek? Tidak jelas. "Dalam penelitian ini" = keterangan, bukan subjek.
Langkah 2: buang "daripada" → "pengaruh probiotik"
Langkah 3: subjek = Penelitian ini
Perbaikan: "Penelitian ini bertujuan mengetahui pengaruh probiotik terhadap pertumbuhan ikan lele."

**Kata-kata yang sering membuat kalimat tidak efektif:**
- "adalah" diikuti kata kerja → BUANG
- "daripada" setelah kata benda langsung → BUANG
- "para ... -nya" (jamak ganda) → PILIH SATU
- "dalam ... ini" menggantikan subjek → PINDAHKAN subjek

Latihan: perbaiki "Untuk para petani di Desa Sukamaju adalah sangat mengharapkan bantuan bibit dari pemerintah.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pbm.text_comprehension'), 'Pemahaman Isi Bacaan — Strategi Membaca Efisien', 'id', 'guided', 2, 1, '## Baca Pertanyaan DULU, Baru Baca Teks

Untuk soal PBM dengan teks panjang, strategi "baca semua teks dulu" buang-buang waktu.

**Strategi 3 langkah:**
1. Baca pertanyaan terlebih dahulu (30 detik)
2. Tandai kata kunci dalam pertanyaan
3. Scan teks untuk menemukan kata kunci tersebut — baca hanya paragraf yang relevan

**Contoh pertanyaan dan kata kunci:**
- "Apa penyebab..." → cari "karena", "sebab", "akibat"
- "Bagaimana cara..." → cari langkah-langkah (pertama, kemudian, selanjutnya)
- "Mengapa penulis..." → cari opini di akhir paragraf

**Jenis pertanyaan PBM:**
1. Informasi tersurat (tersedia langsung di teks) — scanning
2. Informasi tersirat (membaca antara baris) — interpretasi
3. Judul/topik teks — lihat kalimat pertama & terakhir
4. Tujuan penulis — informatif, persuasif, deskriptif?

**Teknik skimming (30 detik):**
- Baca judul + kalimat pertama setiap paragraf + kalimat terakhir teks
- Dapatkan GAMBARAN BESAR — ini cukup untuk soal ide pokok

**Kunci:** kamu tidak perlu MEMAHAMI seluruh teks. Cukup temukan JAWABAN untuk pertanyaan yang diberikan.

Latihan: baca teks 3 paragraf tentang "dampak perubahan iklim terhadap budidaya tambak" dalam 30 detik dan sebutkan ide pokoknya.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pbm.text_comprehension'), 'Membedakan Fakta, Opini, dan Kesimpulan', 'id', 'case', 2, 2, '## Tiga Jenis Informasi dalam Bacaan

**Fakta:** dapat diverifikasi, ada data, objektif.
Ciri: angka, nama, tanggal, hasil penelitian, kutipan langsung.
"Itik petelur menghasilkan rata-rata 250 butir per tahun."

**Opini:** pendapat pribadi, subjektif, belum tentu benar.
Ciri: "menurut saya", "sebaiknya", "mungkin", kata sifat evaluatif.
"Pakan organik adalah pilihan terbaik untuk semua jenis unggas." → OPINI (kata "terbaik")

**Kesimpulan:** rangkuman berdasarkan bukti yang disajikan.
Ciri: ada di akhir teks, sering ditandai "jadi", "dengan demikian".
"Berdasarkan data tiga tahun terakhir, bioflok meningkatkan panen 25-40%." → KESIMPULAN (berdasarkan data)

**Yang sering menjebak:** opini yang KEDENGARAN seperti fakta karena ditulis dengan bahasa formal.
"Pemerintah seharusnya memberikan subsidi penuh untuk pakan ternak." → OPINI ("seharusnya" = penanda opini)

**Teknik: tanya "bisakah ini dibuktikan/diverifikasi?"** Kalau butuh data dan ada datanya → fakta. Kalau butuh persetujuan → opini.

Latihan: dari teks tentang "kebijakan ekspor hasil perikanan", identifikasi 2 fakta, 1 opini, dan 1 kesimpulan.');