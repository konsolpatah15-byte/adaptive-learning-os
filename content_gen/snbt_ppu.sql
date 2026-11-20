-- SNBT PPU curriculum content
INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.ppu.word_meaning'), 'Makna Kata dalam Konteks — Strategi Menebak Tanpa Kamus', 'id', 'guided', 2, 1, '## Jangan Panik Kalau Tidak Tahu Artinya

Di soal PPU, sering muncul kata yang tidak familiar. Tapi kamu TIDAK perlu tahu arti persisnya — cukup tebak dari KONTEKS.

**Langkah-langkah:**
1. Baca kalimat SEBELUM dan SESUDAH kata tersebut
2. Cari petunjuk: sinonim, antonim, contoh, penjelasan
3. Tentukan MAKNA (bukan definisi kamus)

**Contoh:**
"Para petani mulai beralih ke sistem akuaponik yang mengintegrasikan budidaya ikan dengan hidroponik tanaman."

Kata "mengintegrasikan": dari konteks "budidaya ikan DENGAN hidroponik tanaman" → menggabungkan, menyatukan.

**Sinyal konteks yang membantu:**
- "yaitu", "yakni", "adalah" → definisi langsung mengikuti
- "seperti", "misalnya" → contoh
- "tetapi", "namun", "sebaliknya" → antonim/berlawanan
- "dan", "serta", "juga" → makna mirip/sejalan

**Kunci:** jangan cari arti yang "paling bagus" — cari yang PALING SESUAI dengan konteks kalimat. Dua kata bisa bersinonim secara umum, tapi dalam konteks spesifik hanya satu yang tepat.

Latihan: "Hasil panen tahun ini sungguh impresif; belum pernah tercatat angka setinggi ini dalam sejarah desa." Arti "impresif" dalam konteks ini?');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.ppu.word_meaning'), 'Makna Kata Kiasan dan Peribahasa', 'id', 'case', 2, 2, '## Kata Kiasan Bukan Arti Harfiah

Soal PPU sering menguji pemahaman makna kiasan (konotatif), bukan makna sebenarnya (denotatif).

**Contoh:**
"Meski sudah jatuh bangun membangun usahanya, Pak Rahman tak pernah patah arang."
- "jatuh bangun" → berulang kali gagal dan bangkit (bukan jatuh dan bangun secara fisik)
- "patah arang" → putus asa (bukan arang yang patah)

**Peribahasa umum yang sering muncul:**
- "bagai air di daun talas" → tidak menetap, mudah berubah
- "bagai pungguk merindukan bulan" → mengharapkan yang mustahil
- "air susu dibalas air tuba" → kebaikan dibalas kejahatan
- "berat sama dipikul, ringan sama dijinjing" → gotong royong
- "tong kosong nyaring bunyinya" → orang bodoh biasanya banyak bicara

**Teknik menjawab:**
1. Kenali apakah kalimat mengandung kiasan
2. Cari hubungan antara kiasan dengan situasi yang dibahas
3. Jangan terjebak makna harfiah

**Kunci:** peribahasa/kiasan selalu punya PESAN MORAL atau PENGANDAIAN. Cari opsi yang menangkap PESAN itu, bukan deskripsi fisiknya.

Latihan: arti "seperti katak dalam tempurung" dalam konteks "Anak muda zaman sekarang tidak boleh seperti katak dalam tempurung.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.ppu.paragraph_idea'), 'Ide Pokok Paragraf — Temukan dalam 10 Detik', 'id', 'guided', 2, 1, '## Ide Pokok = Jawaban dari "Paragraf ini tentang APA?"

**Aturan 80/20:** 80% ide pokok ada di kalimat PERTAMA atau TERAKHIR paragraf.

**Langkah 10 detik:**
1. Baca kalimat pertama
2. Baca kalimat terakhir
3. Tanya: "kalimat-kalimat lain mendukung APA?"
4. Pilih opsi yang paling UMUM (mencakup seluruh isi)

**Contoh paragraf:**
"Budidaya lele dengan sistem bioflok semakin populer di kalangan petani kecil. Sistem ini memanfaatkan mikrob untuk menguraikan limbah nitrogen. Selain mengurangi biaya pakan hingga 30%, bioflok juga menghemat penggunaan air. Di beberapa daerah, sistem ini telah meningkatkan pendapatan petani hingga dua kali lipat."

Ide pokok: Popularitas dan manfaat sistem bioflok untuk budidaya lele.

**Bukan ide pokok (terlalu sempit):**
- "Bioflok mengurangi biaya pakan 30%" → hanya satu detail
- "Petani kecil mulai budidaya lele" → tidak menyebut bioflok ❌

**Teknik eliminasi:** kalau satu kalimat dalam paragraf TIDAK mendukung opsi tersebut → itu bukan ide pokok.

Latihan: temukan ide pokok paragraf tentang "sertifikasi organik untuk produk perikanan" dalam 10 detik.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.ppu.paragraph_idea'), 'Jenis Paragraf dan Posisi Ide Pokok', 'id', 'demo', 2, 2, '## Tidak Semua Ide Pokok di Awal

**1. Paragraf DEDUKTIF:** ide pokok di AWAL, lalu diikuti penjelasan.
Paling umum di teks akademik Indonesia.

**2. Paragraf INDUKTIF:** penjelasan dulu, ide pokok di AKHIR sebagai simpulan.
Sering ditandai "jadi", "dengan demikian", "oleh karena itu".

**3. Paragraf CAMPURAN:** ide pokok di awal, diulang/dipertegas di akhir.

**Cara mengenali:**
- Deduktif: kalimat pertama = pernyataan umum, sisanya rincian/contoh
- Induktif: kalimat-kalimat awal = data/fakta/kasus, akhir = generalisasi
- Campuran: ada "jembatan" antara awal dan akhir

**Contoh induktif:**
"Di Desa A, panen naik 40%. Di Desa B, pendapatan petani naik 60%. Di Desa C, 80% petani kini pakai bioflok. Jadi, teknologi bioflok terbukti meningkatkan kesejahteraan petani."
→ Ide pokok di AKHIR.

**Strategi:** baca kalimat pertama dan terakhir DULU sebelum membaca seluruh paragraf. Ini hemat waktu untuk soal PPU yang teksnya panjang.

Latihan: tentukan jenis paragraf dari teks tentang "revitalisasi tambak tradisional" dan temukan ide pokoknya.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.ppu.general_knowledge'), 'Wawasan Sosial-Budaya — Membaca yang Tersirat', 'id', 'discussion', 3, 1, '## Pengetahuan Umum Bukan Hafalan — Tapi Pemahaman Konteks

Soal PPU tentang wawasan sosial-budaya menguji kemampuan memahami konteks Indonesia — bukan hafalan tanggal atau nama.

**Topik yang sering muncul:**
- Kearifan lokal (sistem subak di Bali, sasi di Maluku, lubuk larangan)
- Keberagaman budaya dan toleransi
- Isu lingkungan dan pembangunan berkelanjutan
- Ekonomi kerakyatan dan koperasi
- Pendidikan dan kesenjangan sosial

**Contoh soal:**
"Masyarakat adat di berbagai daerah memiliki sistem pengelolaan sumber daya alam yang telah teruji selama ratusan tahun. Namun, sistem ini sering terpinggirkan oleh kebijakan yang seragam."

Yang tersirat: ada ketegangan antara kearifan lokal dan kebijakan nasional yang top-down.

**Kunci:** jawaban selalu ADA di teks — kamu tidak perlu pengetahuan dari luar. Tapi kamu perlu MEMAHAMI konteks Indonesia untuk menangkap nuansanya.

**Teknik:** anggap teks seperti percakapan — penulis ingin menyampaikan sesuatu TANPA mengatakannya langsung. Apa yang "terselip" di antara baris-baris?

Latihan: baca teks tentang "tradisi gotong royong di era digital" — apa kekhawatiran tersirat penulis?');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.ppu.general_knowledge'), 'Wawasan Kebangsaan dalam Teks — NKRI, Pancasila, Bhinneka', 'id', 'scenario', 3, 2, '## Konteks Kebangsaan dalam Soal PPU

Soal wawasan kebangsaan tidak menguji hafalan pasal UUD, tapi bagaimana nilai-nilai kebangsaan TERCERMIN dalam teks.

**Nilai yang sering muncul:**
- Persatuan dalam keberagaman (Bhinneka Tunggal Ika)
- Gotong royong dan solidaritas sosial
- Keadilan sosial (Pancasila sila ke-5)
- Musyawarah untuk mufakat
- Cinta tanah air dan pelestarian budaya

**Contoh:**
"Meski berasal dari berbagai suku dan agama, warga Desa Sukamaju tetap menggelar kerja bakti membersihkan saluran irigasi setiap bulan."

Nilai yang tercermin: persatuan (Bhinneka) dan gotong royong.

**Teknik menjawab:**
1. Identifikasi tindakan/sikap tokoh dalam teks
2. Cocokkan dengan nilai-nilai Pancasila/Bhinneka
3. Pilih yang PALING SESUAI (bukan yang "mirip")

**Hindari:** jawaban yang terlalu ekstrem ("sangat nasionalis", "paling Pancasila") biasanya SALAH. Soal PPU mencari jawaban yang MODERAT dan KONTEKSTUAL.

Latihan: teks tentang "festival budaya nusantara di kota metropolitan" — nilai kebangsaan apa yang paling menonjol?');