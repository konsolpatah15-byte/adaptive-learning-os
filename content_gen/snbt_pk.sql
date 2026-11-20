-- SNBT PK curriculum content
INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pk.numbers'), 'Bilangan & Operasi — Dasar yang Sering Dilupakan', 'id', 'demo', 2, 1, '## Operasi Dasar yang Harus Otomatis

**1. Urutan operasi (KABATAKU):**
Kali-Bagi dulu, baru Tambah-Kurang. Kurung selalu pertama.
24 ÷ 6 × 2 = 4 × 2 = 8 (bukan 24 ÷ 12 = 2!)
24 ÷ (6 × 2) = 24 ÷ 12 = 2

**2. Pecahan:**
- Penjumlahan/pengurangan: samakan penyebut dulu
  2/3 + 1/4 = 8/12 + 3/12 = 11/12
- Perkalian: kali lurus (pembilang × pembilang, penyebut × penyebut)
  2/3 × 3/4 = 6/12 = 1/2
- Pembagian: balik lalu kali
  2/3 ÷ 3/4 = 2/3 × 4/3 = 8/9

**3. Persentase:**
- % ke desimal: geser koma 2 kali ke kiri → 25% = 0.25
- Perubahan: (baru − lama) / lama × 100%
  Naik dari 80 ke 100 → (100−80)/80 × 100% = 25%
  Turun dari 100 ke 80 → (80−100)/100 × 100% = −20%

**4. FPB dan KPK:**
- FPB (Faktor Persekutuan terBesar): ambil faktor prima SAMA dengan pangkat TERKECIL
- KPK (Kelipatan Persekutuan terKecil): ambil SEMUA faktor prima dengan pangkat TERBESAR
FPB 24,36: 24=2³×3, 36=2²×3² → FPB=2²×3=12, KPK=2³×3²=72

**Kunci PK:** operasi bilangan adalah FONDASI untuk aljabar, geometri, statistika. Kalau ini goyah, semuanya susah. Pastikan 100% otomatis.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pk.numbers'), 'Perbandingan dan Skala — Konsep Penting untuk Soal Cerita', 'id', 'visual', 2, 2, '## Perbandingan = Hubungan Proporsional

**Jenis perbandingan:**
1. **Senilai:** a/b = c/d. Makin besar A, makin besar B (proporsional)
   Contoh: 2 kg pakan → 10 ekor. 5 kg → 25 ekor. (5/2 × 10 = 25)

2. **Berbalik nilai:** a×b = c×d. Makin besar A, makin kecil B
   Contoh: 2 orang → 12 hari. 4 orang → 6 hari. (2×12 = 4×6 = 24)

**Skala peta:**
Skala = jarak peta / jarak sebenarnya (dalam satuan sama!)
Skala 1:50.000 berarti 1 cm di peta = 50.000 cm = 500 m = 0.5 km sebenarnya

**Perbandingan tiga variabel:**
A : B = 2 : 3, B : C = 4 : 5. A : B : C?
Samakan B: A:B = 2:3 = 8:12, B:C = 4:5 = 12:15
A : B : C = 8 : 12 : 15

Kalau A+B+C = 350, maka:
A = 8/(8+12+15) × 350 = 8/35 × 350 = 80
B = 12/35 × 350 = 120
C = 15/35 × 350 = 150

**Triks:** selalu cek SATUAN. Soal PK sering menjebak dengan satuan berbeda (cm↔m, gram↔kg, menit↔jam).

Latihan: skala 1:250.000, jarak di peta 8 cm. Jarak sebenarnya = ? km.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pk.algebra'), 'Aljabar — Dari Persamaan Linear ke Persamaan Kuadrat', 'id', 'demo', 3, 1, '## Aljabar = Mencari yang Tidak Diketahui

**Persamaan linear satu variabel:**
2x + 5 = 13 → 2x = 8 → x = 4
Kunci: pisahkan variabel di satu sisi, konstanta di sisi lain.

**Dua persamaan dua variabel:**
(1) x + y = 10
(2) x − y = 4
Eliminasi: (1)+(2) → 2x = 14 → x = 7, y = 3
Atau substitusi: dari (1) y = 10−x, masukkan ke (2): x − (10−x) = 4 → 2x = 14 → x = 7

**Persamaan kuadrat: ax² + bx + c = 0**
Faktorisasi: x² − 5x + 6 = 0 → (x−2)(x−3) = 0 → x = 2 atau x = 3
Rumus: x = [−b ± √(b²−4ac)] / 2a

**Pertidaksamaan:**
2x + 3 > 7 → 2x > 4 → x > 2
HATI-HATI: kalau dikali/dibagi bilangan NEGATIF, TANDA DIBALIK!
−2x > 6 → x < −3

**Fungsi linear: y = mx + c**
m = gradien (kemiringan), c = titik potong sumbu y
Dua garis: sejajar (m₁=m₂), tegak lurus (m₁×m₂=−1)

Latihan: selesaikan 3x² − 7x + 2 = 0 dengan dua metode (faktorisasi dan rumus).');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pk.algebra'), 'Pertidaksamaan dan Sistem — Melampaui Persamaan', 'id', 'guided', 3, 2, '## Pertidaksamaan ≠ Persamaan

**Perbedaan kunci:** persamaan punya SATU solusi. Pertidaksamaan punya RENTANG solusi.

**Pertidaksamaan linear:**
3x − 5 < 10 → 3x < 15 → x < 5
Solusi: semua bilangan kurang dari 5 → x ∈ (−∞, 5)

**Pertidaksamaan kuadrat:** cari akar dulu, baru uji interval.
x² − 5x + 6 > 0 → (x−2)(x−3) > 0
Akar: x = 2, x = 3. Uji interval:
- x < 2: (negatif)×(negatif) = positif > 0 ✔
- 2 < x < 3: (positif)×(negatif) = negatif > 0 ❌
- x > 3: (positif)×(positif) = positif > 0 ✔
Solusi: x < 2 atau x > 3

**Sistem pertidaksamaan:**
x + y ≤ 10, x ≥ 2, y ≥ 3
Gambar daerah penyelesaian pada bidang Kartesius. Daerah yang memenuhi SEMUA syarat itulah solusinya. Titik optimum biasanya di titik sudut daerah ini.

**Aplikasi: soal cerita optimasi!**
"Petani punya lahan 100 m². Satu kolam lele butuh 4 m², satu kolam nila butuh 5 m². Minimal 10 kolam lele. Maksimal total 25 kolam. Berapa kombinasi yang memberikan keuntungan maksimal?"
→ Modelkan sebagai sistem pertidaksamaan linear.

Latihan: selesaikan sistem x + 2y ≤ 12, x ≥ 1, y ≥ 2 untuk mendapatkan titik potong dan daerah penyelesaian.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pk.geometry'), 'Geometri Dasar — Luas, Volume, dan Sudut', 'id', 'visual', 3, 1, '## Rumus yang Wajib Diingat

**Bangun datar:**
- Persegi: L = s², K = 4s
- Persegi panjang: L = p×l, K = 2(p+l)
- Segitiga: L = ½ × a × t, K = a + b + c
- Lingkaran: L = πr², K = 2πr
- Jajargenjang: L = a × t
- Trapesium: L = ½(a+b) × t
- Belah ketupat: L = ½ × d₁ × d₂

**Bangun ruang:**
- Kubus: V = s³, LP = 6s²
- Balok: V = p×l×t, LP = 2(pl+pt+lt)
- Tabung: V = πr²t, LP = 2πr(r+t)
- Kerucut: V = ⅓πr²t
- Bola: V = ⁴⁄₃πr³, LP = 4πr²

**Sudut:**
- Segitiga: total 180°
- Segiempat: total 360°
- Sudut berpelurus: 180°
- Sudut berpenyiku: 90°

**Teorema Pythagoras: a² + b² = c²** (c = sisi miring)
Tripel Pythagoras umum: 3-4-5, 5-12-13, 8-15-17

**Koordinat:** jarak dua titik (x₁,y₁) dan (x₂,y₂) = √[(x₂−x₁)² + (y₂−y₁)²]

Latihan: segitiga dengan sisi 6, 8, 10. Apakah siku-siku? Hitung luasnya.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pk.geometry'), 'Geometri Koordinat dan Transformasi', 'id', 'visual', 3, 2, '## Bidang Kartesius — Teman atau Musuh?

**Jarak dua titik:**
A(x₁,y₁) ke B(x₂,y₂): d = √[(x₂−x₁)² + (y₂−y₁)²]

**Titik tengah:**
M = ((x₁+x₂)/2, (y₁+y₂)/2)

**Gradien garis:**
m = (y₂−y₁)/(x₂−x₁)
Garis mendatar: m = 0. Garis vertikal: m = tak terdefinisi.

**Persamaan garis:**
- y = mx + c (bentuk gradien)
- y−y₁ = m(x−x₁) (bentuk titik-gradien)
- ax + by + c = 0 (bentuk umum)

**Hubungan dua garis:**
- Sejajar: m₁ = m₂
- Tegak lurus: m₁ × m₂ = −1

**Transformasi (sering muncul di PK):**
- Translasi (a,b): (x,y) → (x+a, y+b)
- Refleksi sumbu x: (x,y) → (x, −y)
- Refleksi sumbu y: (x,y) → (−x, y)
- Rotasi 90° berlawanan jarum jam: (x,y) → (−y, x)
- Dilatasi faktor k: (x,y) → (kx, ky)

**Soal favorit PK:** "Titik A(2,3) direfleksikan ke sumbu y, lalu ditranslasikan (3,−1). Koordinat akhir?"
A(2,3) → refleksi y → A''(−2,3) → translasi → A''''(1,2)

Latihan: garis dengan gradien 2 melalui (1,3). Tentukan persamaannya dan titik potong dengan sumbu y.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pk.data'), 'Statistika — Mean, Median, Modus, Jangkauan', 'id', 'demo', 3, 1, '## Tiga Ukuran Pemusatan Data

**Mean (rata-rata):** jumlah semua data ÷ banyak data
Data: 6, 8, 10, 12, 14 → mean = (6+8+10+12+14) ÷ 5 = 10

**Median (nilai tengah):** urutkan data, ambil yang di tengah
Data ganjil: 6, 8, 10, 12, 14 → median = 10 (data ke-3)
Data genap: 6, 8, 10, 12 → median = (8+10)÷2 = 9

**Modus:** nilai yang paling sering muncul
6, 8, 8, 10, 12 → modus = 8

**Kapan pakai yang mana?**
- Mean: data simetris, tidak ada outlier
- Median: data ada outlier (nilai ekstrem)
  Contoh: gaji karyawan (1 direktur gaji 50jt, 10 staf gaji 5jt) → mean = 9jt (menyesatkan!), median = 5jt (lebih realistis)
- Modus: data kategorikal atau mencari yang paling populer

**Jangkauan (range):** data terbesar − data terkecil
**Kuartil:** Q₁ (25%), Q₂ (median/50%), Q₃ (75%)
**Jangkauan interkuartil:** Q₃ − Q₁

**Rata-rata gabungan:**
Kelas A: 20 siswa, mean 75. Kelas B: 30 siswa, mean 80.
Mean gabungan = (20×75 + 30×80) ÷ (20+30) = (1500+2400) ÷ 50 = 78

Latihan: data 5, 7, x, 9, 11 punya mean 8. Tentukan x dan mediannya.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pk.data'), 'Peluang dan Kombinatorika — Menghitung Kemungkinan', 'id', 'demo', 3, 2, '## Peluang = Kasus yang Diinginkan ÷ Semua Kasus

**Aturan perkalian:** kalau ada m cara untuk langkah 1 dan n cara untuk langkah 2, total = m × n.
Contoh: 3 baju × 4 celana = 12 kombinasi pakaian.

**Permutasi (urutan PENTING):** P(n,r) = n!/(n−r)!
Menyusun 3 dari 5 orang untuk posisi ketua, wakil, sekretaris:
P(5,3) = 5!/(5−3)! = 5×4×3 = 60 cara

**Kombinasi (urutan TIDAK penting):** C(n,r) = n!/[r!(n−r)!]
Memilih 3 dari 5 orang untuk tim (tanpa jabatan):
C(5,3) = 5!/(3!×2!) = (5×4)/(2×1) = 10 cara

**Peluang kejadian:**
P(A) = n(A) / n(S)
Satu dadu dilempar: P(ganjil) = 3/6 = 1/2

**Peluang kejadian majemuk:**
- A DAN B (intersection): P(A∩B) = P(A) × P(B) [kalau independen]
- A ATAU B (union): P(A∪B) = P(A) + P(B) − P(A∩B)

**Frekuensi harapan = n × P(kejadian)**
Lempar koin 100 kali → harapan muncul gambar = 100 × ½ = 50 kali

**Kunci PK:** jangan bingung permutasi vs kombinasi. Tanya: "apakah urutan penting?" YA → permutasi. TIDAK → kombinasi.

Latihan: dari 10 pembudidaya, dipilih 3 untuk pelatihan. Berapa cara? Bagaimana kalau yang terpilih jadi ketua, wakil, sekretaris?');