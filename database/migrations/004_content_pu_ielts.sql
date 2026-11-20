-- ALOS 2.0 · migration 004 · PU teaching content (Indonesian-first, aquaculture examples)
-- Multiple methods per competency so the adaptation engine can rotate explanations.

INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.pu.inverse_proportion'),
 'Perbandingan Berbalik Nilai — konsep dasar dengan analogi kolam ikan', 'id', 'analogy', 2, 1,
 '## Perbandingan Berbalik Nilai

Bayangkan kamu punya **kolam lele** yang harus dikuras sebelum panen.

- 2 orang pekerja → selesai 12 hari
- 4 orang pekerja → selesai ... ?

**Kunci:** total "usaha" tetap. Usaha = pekerja × hari.
2 × 12 = 24 satuan usaha. Maka 4 orang → 24 ÷ 4 = **6 hari**.

> Kalau satu besaran NAIK, yang lain TURUN dengan hasil kali KONSTAN.
> Itu sebabnya disebut *berbalik nilai* — bukan sekadar "kebalikan".

**Bandingkan dengan perbandingan senilai:** makin banyak pakan yang dibeli, makin besar biayanya (hasil BAGI yang konstan: biaya/kg). Berbalik nilai: hasil KALI konstan.

**Cara cepat mengenali:** tanya ke diri sendiri — "kalau X ditambah, Y bertambah atau berkurang?"
- Bertambah bersama → senilai (a/b = c/d)
- Satu naik satu turun, total kerja tetap → berbalik (a×b = c×d)

**Contoh nyata akuakultur:** pompa air mengisi kolam. 3 pompa → 8 jam. 4 pompa → 3×8÷4 = 6 jam.

Diskusi: menurutmu, apakah "makin banyak ikan di kolam, makin cepat habis oksigen" termasuk berbalik nilai? Kenapa? (Petunjuk: apakah hasil kalinya konstan?)'),

((SELECT id FROM competencies WHERE code='snbt.pu.inverse_proportion'),
 'Demonstrasi tabel: pekerja × hari = konstan', 'id', 'demo', 2, 2,
 '## Langkah demi langkah

Soal: *6 pekerja menyelesaikan perbaikan tanggul kolam dalam 10 hari. Berapa hari jika 4 pekerja?*

**Langkah 1 — Tulis pasangan yang diketahui.**
| Pekerja | Hari |
|---|---|
| 6 | 10 |
| 4 | ? |

**Langkah 2 — Uji arah hubungan.** Pekerja berkurang → hari pasti bertambah. Berbalik nilai. ✔

**Langkah 3 — Hitung konstanta.** 6 × 10 = 60.

**Langkah 4 — Bagi.** 60 ÷ 4 = **15 hari**.

**Langkah 5 — Cek akal sehat.** Lebih sedikit orang → lebih lama (15 > 10). ✔ Masuk akal.

Kesalahan umum: memakai rumus senilai (6/10 = 4/x → x ≈ 6,7 hari). Itu SALAH karena lebih sedikit pekerja tidak mungkin lebih cepat. Langkah 2 dan 5 adalah pengamanmu.'),

((SELECT id FROM competencies WHERE code='snbt.pu.work_rate'),
 'Laju pekerjaan — analogi pompa air', 'id', 'analogy', 3, 1,
 '## Work-rate: jumlahkan LAJU, bukan waktu

Pompa A mengisi kolam dalam 6 jam. Pompa B dalam 3 jam. Bersama-sama?

**Jangan jumlahkan waktunya** (6+3=9 itu salah). Jumlahkan **laju per jam**:
- Pompa A: 1/6 kolam per jam
- Pompa B: 1/3 kolam per jam
- Bersama: 1/6 + 1/3 = 1/6 + 2/6 = 3/6 = **1/2 kolam per jam**

Waktu = 1 ÷ (1/2) = **2 jam**.

**Rumus inti:** kalau A butuh a jam dan B butuh b jam, bersama = (a×b)/(a+b).
Cek: (6×3)/(6+3) = 18/9 = 2 ✔

**Kalau ada yang MENGURAS (bekerja melawan):** lajunya DIKURANGI.
Contoh: pompa mengisi 1/4 kolam/jam, kebocoran menguras 1/12 kolam/jam → netto 1/4 − 1/12 = 3/12 − 1/12 = 2/12 = 1/6 → penuh dalam 6 jam.

Ini persis soal "pekerja A membangun, pekerja B merusak" di PU — polanya sama.'),

((SELECT id FROM competencies WHERE code='snbt.pu.set_theory'),
 'Himpunan lewat data kolam budidaya', 'id', 'scenario', 2, 1,
 '## Himpunan = kelompok dengan aturan jelas

Di kelasmu ada 30 siswa pembudidaya:
- Himpunan A = yang memelihara **lele** (18 orang)
- Himpunan B = yang memelihara **nila** (15 orang)

**Gabungan (A ∪ B):** semua yang memelihara minimal satu jenis.
**Irisan (A ∩ B):** yang memelihara KEDUANYA.

Rumus kunci: **|A ∪ B| = |A| + |B| − |A ∩ B|**
Kenapa dikurangi? Karena yang ada di kedua kelompok terhitung DUA KALI saat menjumlah 18+15.

Jika semua 30 siswa memelihara minimal satu: 30 = 18 + 15 − irisan → irisan = **3 orang**.

**Komplemen:** yang TIDAK di A = total − |A|.

Latihan diskusi (bukan tes): kalau ada 5 siswa yang tidak memelihara keduanya, berapa irisan sekarang? Coba jelaskan alur berpikirmu.'),

((SELECT id FROM competencies WHERE code='snbt.pu.venn'),
 'Diagram Venn — menggambar dulu, menghitung kemudian', 'id', 'visual', 3, 1,
 '## Selalu gambar dua lingkaran

```
        Total = 40
   ┌─────────────────────┐
   │   ╭─────╮ ╭─────╮   │
   │   │  A  │∩│  B  │   │
   │   │ 12  │8│  10 │   │
   │   ╰─────╯ ╰─────╯   │
   │  di luar keduanya:10│
   └─────────────────────┘
```

**Aturan emas: isi IRISAN dulu, baru sisanya.**

Contoh: 40 petani; 20 pakai pakan apung (A), 18 pakai pakan tenggelam (B), 8 pakai keduanya.
1. Irisan = 8 (tulis di tengah).
2. A saja = 20 − 8 = 12. B saja = 18 − 8 = 10.
3. Luar keduanya = 40 − (12+8+10) = 10.

Kesalahan paling umum: menaruh 20 di bagian "A saja" — padahal 20 itu TOTAL A termasuk irisan. Menggambar mencegah kesalahan ini.

Untuk 3 himpunan, prinsipnya sama: mulai dari irisan PALAM DALAM (A∩B∩C), lalu keluar selapis demi selapis.'),

((SELECT id FROM competencies WHERE code='snbt.pu.min_intersection'),
 'Irisan minimum — logika "paling sial"', 'id', 'socratic', 4, 1,
 '## Berapa persen MINIMAL yang suka keduanya?

Survei: 70% petani suka lele, 60% suka nila. Berapa % minimal yang suka keduanya?

Mari berpikir bersama:
1. Kalau kita ingin irisan SEKECIL mungkin, kita harus membuat gabungan SEBESAR mungkin. Benar?
2. Gabungan maksimal = 100% (tidak mungkin lebih dari seluruh responden).
3. Dari rumus: gabungan = 70 + 60 − irisan → 100 = 130 − irisan → irisan = **30%**.

**Rumus cepat: irisan minimum = A% + B% − 100%** (kalau hasilnya negatif, minimumnya 0).

Cek kasus lain: 40% + 50% = 90% ≤ 100% → bisa saja TIDAK ADA yang suka keduanya (minimum 0%). Masuk akal?

**Analogi kursi:** ada 100 kursi. 70 orang berbaju merah duduk, lalu 60 orang berbaju biru masuk. Kursi tinggal 30 kosong, jadi minimal 30 orang biru HARUS duduk di kursi yang sudah diduduki orang merah — kursi ganda itulah irisan.

Untuk 3 himpunan: minimum = A+B+C − 200% (pola yang sama, "lapisan" bertambah).'),

((SELECT id FROM competencies WHERE code='snbt.pu.necessary_vs_possible'),
 'Pasti vs Mungkin — uji semua skenario', 'id', 'case', 4, 1,
 '## Kesimpulan PASTI = benar di SEMUA skenario

Premis: "Semua peternak yang sukses mencatat keuangan. Budi mencatat keuangan."
Apakah PASTI Budi sukses?

**TIDAK.** Premis hanya bilang sukses → mencatat. Tidak bilang mencatat → sukses. Budi bisa saja mencatat tapi gagal. Ini jebakan klasik *affirming the consequent*.

**Teknik uji:** gambar 2 skenario berbeda yang sama-sama konsisten dengan premis:
- Skenario 1: Budi mencatat DAN sukses. ✔ konsisten
- Skenario 2: Budi mencatat TAPI gagal. ✔ juga konsisten!

Karena ada skenario konsisten di mana kesimpulannya salah → kesimpulan itu hanya MUNGKIN, bukan PASTI.

**Yang PASTI dari premis di atas:** "Ada orang yang mencatat keuangan" (Budi buktinya). Dan kontraposisinya: "yang tidak mencatat keuangan pasti tidak sukses."

Di soal PU, kata kunci jawaban pasti: "harus", "pasti", "dapat disimpulkan". Cari SATU skenario penyangkal untuk mengeliminasi opsi.'),

((SELECT id FROM competencies WHERE code='snbt.pu.word_to_model'),
 'Menerjemahkan soal cerita menjadi model matematika', 'id', 'guided', 4, 1,
 '## Empat langkah menerjemahkan

Soal: *"Panen lele bulan ini 20% lebih banyak dari bulan lalu. Total dua bulan 660 kg. Berapa panen bulan lalu?"*

**1. Beri nama yang dicari.** Misal x = panen bulan lalu (kg).
**2. Terjemahkan tiap kalimat jadi ekspresi.**
- "20% lebih banyak" → bulan ini = x + 0,2x = 1,2x
- "total dua bulan 660" → x + 1,2x = 660
**3. Selesaikan.** 2,2x = 660 → x = 300 kg.
**4. Kembali ke konteks.** Bulan lalu 300, bulan ini 360; 300+360=660 ✔ dan 360 memang 20% di atas 300 ✔

**Kamus terjemahan penting:**
- "lebih banyak p% dari" → ×(1 + p/100)
- "berkurang p%" → ×(1 − p/100)
- "setiap ... bertambah ..." → pola linear/deret
- "sebanding / berbanding lurus" → y = kx
- "berbalik" → xy = k

Latihan terbimbing: coba terjemahkan "harga pakan naik 10%, anggaran tetap, berapa % pakan yang bisa dibeli berkurang?" — tulis modelnya dulu, belum perlu dihitung.'),

((SELECT id FROM competencies WHERE code='ielts.gram.conditionals'),
 'Conditional sentences — tiga tipe dengan contoh beasiswa', 'id', 'demo', 3, 1,
 '## Kalimat pengandaian (Conditional Sentences)

**Type 1 — mungkin terjadi (real future):**
*If I get band 7, I will apply for the scholarship.*
Pola: If + simple present, will + verb1.
❌ If I will get... (JANGAN pakai will setelah if!)

**Type 2 — khayalan saat ini (unreal present):**
*If I had band 8 now, I would apply tomorrow.*
Pola: If + past simple, would + verb1.
Catatan: "had" di sini BUKAN masa lalu — ini penanda khayalan.

**Type 3 — penyesalan masa lalu (unreal past):**
*If I had studied earlier, I would have passed.*
Pola: If + past perfect, would have + verb3.

**Jembatan ke ingatan:**
- Type 1: pintu TERBUKA (masih mungkin)
- Type 2: pintu TERTUTUP sekarang (khayalan)
- Type 3: pintu SUDAH TERLEWATI (penyesalan)

Contoh dari duniamu: *If the water temperature drops, the tilapia eat less.* (fakta/kebiasaan — ini bahkan zero conditional: If + present, present.)

Coba buat satu kalimat Type 1 tentang rencana kuliahmu — bebas, tidak dinilai, hanya latihan jari.'),

((SELECT id FROM competencies WHERE code='ielts.gram.sva'),
 'Subject-verb agreement — temukan subjek INTI', 'id', 'guided', 2, 1,
 '## Subjek tunggal → verb + s

*The list of universities **is** long.* (subjek inti = list, bukan universities!)

**Strategi 3 langkah:**
1. Coret frasa penyela: ~~of universities~~, ~~in the pond~~, ~~with my friends~~.
2. Temukan subjek inti: The list.
3. Tunggal? → is/was/has/verb+s. Jamak? → are/were/have/verb polos.

**Jebakan favorit penguji:**
- *Each of the students **has** a book.* (each selalu tunggal)
- *The number of applicants **is** rising* TAPI *A number of applicants **are** waiting.* (the number = angka itu sendiri → tunggal; a number = sejumlah orang → jamak)
- *Neither the teacher nor the students **are** ready.* (nor/or → lihat yang TERDEKAT dengan verb)

Dari tulisanmu sendiri sebelumnya, pola kesalahan: subjek tunggal dipakai verb jamak. Mulai sekarang, setiap menulis kalimat panjang, coret penyelanya dulu di kepala.

Diskusi ringan: kenapa "My family is supportive" tapi "My family are arguing"? (Petunjuk: keluarga sebagai satu unit vs anggota-anggotanya.)'),

((SELECT id FROM competencies WHERE code='ielts.read.inference'),
 'Inference — membaca yang TIDAK tertulis', 'id', 'case', 4, 1,
 '## Inferensi = kesimpulan yang didukung teks, bukan yang tertulis

Teks: *"Unlike his brother, Andi never missed a feeding schedule, and his harvest was consistently the largest in the village."*

Pertanyaan inferensi: What can be inferred about Andi''s brother?
Jawaban yang didukung: *He was less disciplined in feeding.* — TIDAK tertulis langsung, tapi "unlike his brother" + kedisiplinan Andi mendukungnya.

**Bedakan tiga jenis opsi jawaban:**
1. **Tertulis eksplisit** → itu detail question, BUKAN inferensi.
2. **Didukung tapi tersirat** → inilah jawabannya. ✔
3. **Terlalu jauh / tidak ada dasar** → jebakan. ❌

**Uji eliminasi:** untuk tiap opsi tanya "Adakah kalimat yang MENDUKUNG ini, walau tidak mengatakannya?" Kalau harus mengarang cerita tambahan → buang.

Kata sinyal inferensi di soal: *imply, suggest, infer, most likely, probably.*

Strategi waktu: baca pertanyaannya DULU, tandai paragraf relevan, baru baca dalam. Jangan baca seluruh teks untuk satu soal inferensi.');