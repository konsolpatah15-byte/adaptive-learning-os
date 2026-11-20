-- ALOS 2.0 · practice questions bank · IELTS + SNBT · 51 questions across 13 subjects
PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS practice_questions (
  id INTEGER PRIMARY KEY,
  competency_id INTEGER NOT NULL REFERENCES competencies(id),
  question TEXT NOT NULL,
  option_a TEXT NOT NULL,
  option_b TEXT NOT NULL,
  option_c TEXT NOT NULL,
  option_d TEXT NOT NULL,
  option_e TEXT NOT NULL,
  correct_answer TEXT NOT NULL CHECK(correct_answer IN ('A','B','C','D','E')),
  explanation TEXT,
  difficulty INTEGER NOT NULL DEFAULT 2,
  created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);

-- =========================================================================
-- IELTS: Listening (5 questions)
-- =========================================================================

-- Q1: Main idea recognition
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='ielts.list.main_idea'),
 'What is the main topic of the conversation?',
 'The history of marine biology research in Southeast Asia',
 'A university lecture about climate change policies',
 'A student discussing her research proposal on coral reef restoration',
 'The economic impact of tourism on coastal communities',
 'An interview with a marine park director about funding cuts',
 'C',
 'The conversation centers on a student presenting her research proposal about coral reef restoration techniques. Option A is too broad (history of marine biology), B introduces climate policies not mentioned, D shifts to tourism economics, and E focuses on funding cuts — all outside the core topic of a student''s research proposal.',
 2);

-- Q2: Detail & distractor recognition
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='ielts.list.detail'),
 'According to the speaker, how many volunteers will be needed for the beach cleanup on Saturday?',
 '15 volunteers',
 '25 volunteers',
 '30 volunteers',
 '50 volunteers',
 '100 volunteers',
 'D',
 'The speaker clearly states that 50 volunteers are needed for Saturday''s beach cleanup. Distractor: the speaker mentions 25 volunteers participated last month (option B), and 30 signed up for Sunday''s tree-planting (option C). Option A (15) and E (100) are not mentioned. The key is distinguishing the Saturday cleanup number from the other figures.',
 3);

-- Q3: Distractor-focused listening
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='ielts.list.detail'),
 'The tour guide mentions three departure times. What time does the LAST bus leave?',
 '8:30 AM',
 '9:45 AM',
 '10:15 AM',
 '10:45 AM',
 '11:00 AM',
 'D',
 'The guide says buses depart at 8:30, 9:45, and 10:45. The speaker then corrects: "Actually, the middle one is now 10:15, not 9:45." The LAST bus remains 10:45. Distractors: 9:45 (original middle time before correction), 10:15 (corrected middle time), 8:30 (first bus, not last).',
 3);

-- Q4: Map & diagram labelling
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='ielts.list.map_diagram'),
 'On the campus map, where is the new library extension located relative to the main cafeteria?',
 'Directly north of the cafeteria',
 'To the east, across the pedestrian bridge',
 'Southwest, beside the sports complex',
 'To the west, behind the administration building',
 'Northeast, adjacent to the lecture hall',
 'B',
 'The speaker describes the library extension as "on the east side of campus, just across the pedestrian bridge from the main cafeteria." Option A (north) and C (southwest) contradict the east location. Option D (west) is the opposite direction. Option E (northeast, adjacent to lecture hall) describes the old library, not the new extension.',
 3);

-- Q5: Numbers & spelling accuracy
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='ielts.list.numbers_spelling'),
 'The customer''s reference number is:',
 'AX-447921',
 'AX-447912',
 'AX-449721',
 'AK-447921',
 'AX-477921',
 'A',
 'The speaker spells out "A-X" then says the digits "4-4-7-9-2-1." Option B transposes the last two digits (912 instead of 921). Option C has 449 instead of 447. Option D uses K instead of X. Option E has 477 instead of 447. Careful listening for digit sequences is essential.',
 2);

-- =========================================================================
-- IELTS: Reading (5 questions)
-- =========================================================================

-- Q6: Skimming & scanning
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='ielts.read.skim_scan'),
 'A passage about urban biodiversity has four paragraphs. Which paragraph most likely contains statistics on bird species decline?',
 'Paragraph A, which introduces the concept of urban ecosystems',
 'Paragraph B, which presents data from a 10-year metropolitan wildlife survey',
 'Paragraph C, which discusses community gardening initiatives',
 'Paragraph D, which concludes with policy recommendations',
 'The statistics are scattered across all paragraphs',
 'B',
 'Paragraph B explicitly mentions "data from a 10-year survey" — the word "data" signals quantitative information. Paragraph A introduces the concept (no data), Paragraph C discusses initiatives (qualitative), and Paragraph D offers recommendations (conclusion). Skimming for signal words like "survey," "percent," and "study" leads to B.',
 2);

-- Q7: Inference
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='ielts.read.inference'),
 'The text states: "Despite the factory''s claims of environmental compliance, independent water tests consistently showed elevated mercury levels downstream." What can be inferred?',
 'The factory is definitely violating environmental regulations',
 'The independent water tests may be unreliable',
 'The factory''s claims about compliance may not be accurate',
 'The mercury comes from a different source upstream',
 'The government has failed to enforce environmental laws',
 'C',
 'The word "despite" signals a contrast between claims and evidence. The inference is that compliance claims may be inaccurate, given the contradictory test results. Option A overstates — elevated levels suggest but don''t prove violation. Option B undermines the independent tests without evidence. Option D invents an alternative source. Option E goes beyond the text (no mention of enforcement).',
 4);

-- Q8: True/False/Not Given
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='ielts.read.tfng'),
 'Text: "The company launched its recycling program in 2018. By 2020, participation had reached 65% of employees." Statement: The recycling program was started before 2020.',
 'True',
 'False',
 'Not Given',
 '',
 '',
 'A',
 'The text explicitly states the program launched in 2018, which is before 2020. This is a straightforward True — the information is directly stated in the passage. False would require the text to contradict the statement. Not Given would apply only if the launch date were not mentioned.',
 4);

-- Q9: Vocabulary in context
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='ielts.read.vocab_context'),
 'In the sentence "The researcher''s findings were met with skepticism by her peers, who questioned her methodology," the word "skepticism" most nearly means:',
 'Enthusiasm',
 'Doubt',
 'Hostility',
 'Indifference',
 'Admiration',
 'B',
 'The context clue "questioned her methodology" indicates that peers expressed doubt, which matches "skepticism." Option A (enthusiasm) and E (admiration) are positive, contradicting the questioning. Option C (hostility) is too strong — questioning methodology is not hostile. Option D (indifference) suggests no reaction, which contradicts active questioning.',
 3);

-- Q10: Main idea & headings
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='ielts.read.main_idea'),
 'A paragraph describes how microplastics enter the food chain through plankton consumption, accumulate in small fish, and concentrate in larger predators including tuna consumed by humans. The best heading for this paragraph is:',
 'The Chemistry of Plastic Production',
 'How Microplastics Travel Through the Food Web',
 'Government Regulations on Plastic Waste',
 'The Economic Cost of Ocean Pollution',
 'Alternatives to Single-Use Plastics',
 'B',
 'The paragraph traces the journey of microplastics from plankton → small fish → large predators → humans, which is exactly what "How Microplastics Travel Through the Food Web" describes. Option A focuses on production chemistry (not discussed). C and D introduce regulation and economics (absent). E discusses alternatives (not mentioned).',
 2);

-- =========================================================================
-- IELTS: Writing (3 questions)
-- =========================================================================

-- Q11: Task 1 structure
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='ielts.write.task1'),
 'In IELTS Writing Task 1 (Academic), what should the overview paragraph contain?',
 'A detailed description of every data point in the chart',
 'Your personal opinion about the trends shown',
 'The main trends or key features without specific data',
 'A prediction about future trends based on the data',
 'A comparison with data from other countries not shown',
 'C',
 'The overview should summarize main trends and key features (e.g., "overall upward trend," "X was consistently higher than Y") without citing specific figures. Option A belongs in the detail paragraphs. Option B introduces personal opinion (not allowed). Option D adds predictions (beyond the data). Option E introduces external data (irrelevant).',
 4);

-- Q12: Task 2 essay type
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='ielts.write.task2'),
 'An essay prompt asks: "Some people believe that university education should be free for everyone. To what extent do you agree or disagree?" Which essay structure is most appropriate?',
 'Only present arguments supporting free education',
 'Present both sides equally without stating your own view',
 'State your position clearly and support it with reasons, while also addressing counterarguments',
 'Describe the history of university tuition fees without taking a position',
 'List statistics about education costs in different countries',
 'C',
 'An "agree/disagree" prompt requires a clear position with supporting arguments. Strong essays also acknowledge counterarguments before rebutting them. Option A is one-sided (ignores complexity). Option B fits "discuss both views" prompts, not agree/disagree. Option D is purely descriptive (no position). Option E lists data without argumentation.',
 4);

-- Q13: Coherence & cohesion
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='ielts.write.coherence'),
 'Which sentence best maintains coherence when added after: "Air pollution in urban areas has reached critical levels."?',
 'My grandmother lives in a rural village with clean air.',
 'Vehicular emissions are the primary contributor, accounting for 60% of urban air pollutants.',
 'Many people enjoy hiking in the mountains on weekends.',
 'The history of air quality monitoring began in the 1950s.',
 'Some cities have beautiful parks with many trees.',
 'B',
 'Option B directly develops the topic by explaining a cause of the pollution levels mentioned. Options A, C, and E introduce unrelated topics (grandmother, hiking, parks) that break coherence. Option D shifts to history instead of developing the current situation. Coherence requires logical progression from one sentence to the next.',
 3);

-- =========================================================================
-- IELTS: Speaking (3 questions)
-- =========================================================================

-- Q14: Part 1 fluency
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='ielts.speak.part1'),
 'In IELTS Speaking Part 1, when asked "Do you enjoy cooking?", which response demonstrates the best fluency strategy?',
 'Yes.',
 'Yes, I do. I find cooking very relaxing, especially on weekends when I have time to try new recipes. Last week I made Indonesian rendang for the first time.',
 'Cooking is a very important life skill that everyone should learn from a young age because it promotes healthier eating habits.',
 'I don''t know. Maybe. Sometimes I cook but not very often because I am usually busy with my studies.',
 'No, I prefer eating out because restaurants offer more variety and I don''t have to clean up afterwards.',
 'B',
 'Option B gives a direct answer with brief elaboration and a specific example — the ideal Part 1 strategy: answer + reason + example, in 2-3 sentences. Option A is too short. Option C sounds rehearsed and like a Part 3 response. Option D shows hesitation and lack of confidence. Option E is acceptable but lacks the positive elaboration expected for fluency demonstration.',
 2);

-- Q15: Part 2 long-turn
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='ielts.speak.part2'),
 'For the Part 2 cue card "Describe a memorable trip you took," which approach best uses the 1-minute preparation time?',
 'Write out the full 2-minute speech word for word',
 'Memorize a prepared script about a famous destination',
 'Jot down key points following the bullet points on the card: where, when, who with, what happened, why memorable',
 'Focus only on vocabulary — list all the advanced words you plan to use',
 'Skip preparation and improvise to sound more natural',
 'C',
 'The bullet points on the cue card provide a natural structure. Jotting keywords for each point ensures coverage and fluency without sounding scripted. Option A is impossible in 1 minute and produces unnatural speech. Option B risks sounding memorized (penalized). Option D neglects structure and content. Option E often leads to rambling or running out of things to say.',
 3);

-- Q16: Part 3 abstract discussion
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='ielts.speak.part3'),
 'In Part 3, the examiner asks: "How has technology changed the way people travel?" Which response structure is most effective?',
 'List five different technologies without explaining any of them',
 'Give a one-sentence answer and wait for the next question',
 'State your main point, explain with an example, then discuss a broader implication or contrasting view',
 'Talk about your personal travel experiences in detail',
 'Avoid answering directly and ask the examiner for clarification',
 'C',
 'Part 3 requires extended, analytical responses. The structure "point → explanation → example → broader implication" demonstrates abstract thinking. Option A is shallow (listing without depth). Option B is too brief (Part 3 expects development). Option D is too personal (Part 3 asks for general/abstract, not personal). Option E wastes time and shows inability to engage.',
 4);

-- =========================================================================
-- IELTS: Grammar (5 questions)
-- =========================================================================

-- Q17: Conditionals
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='ielts.gram.conditionals'),
 'Choose the correct sentence:',
 'If I will see her, I will tell her the news.',
 'If I see her, I will tell her the news.',
 'If I saw her, I will tell her the news.',
 'If I would see her, I will tell her the news.',
 'If I see her, I would tell her the news.',
 'B',
 'First conditional (real future): If + simple present, will + base verb. Option B correctly uses "see" (present) and "will tell." Option A incorrectly uses "will" after "if." Option C mixes past (saw) with future (will). Option D uses "would" after "if" (wrong for Type 1). Option E mixes present (see) with "would" (wrong pairing — Type 2 uses would with past).',
 3);

-- Q18: Subject-verb agreement
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='ielts.gram.sva'),
 'The quality of the products _____ improved significantly since last year.',
 'have',
 'are',
 'has',
 'were',
 'have been',
 'C',
 'The core subject is "quality" (singular), not "products." The prepositional phrase "of the products" is a distractor. Singular subject requires singular verb: "has improved." Option A (have) and E (have been) are plural. Option B (are) is present tense and plural. Option D (were) is past tense and plural. Strip the prepositional phrase to find the true subject.',
 2);

-- Q19: Verb forms & tenses
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='ielts.gram.verb_forms'),
 'By the time the conference _____, we _____ all the arrangements.',
 'starts / will finalize',
 'will start / finalize',
 'started / will have finalized',
 'starts / will have finalized',
 'will have started / finalize',
 'D',
 '"By the time" + present tense clause indicates a future point. The main clause needs future perfect (will have + past participle) to show completion before that point: "starts ... will have finalized." Option A (will finalize) suggests the arrangements finish at the same time, not before. Option B has "will start" after "by the time" (incorrect). Option C mixes past (started) with future. Option E reverses the tense structure.',
 3);

-- Q20: Articles
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='ielts.gram.articles'),
 'She was appointed _____ head of the department last month.',
 'a',
 'an',
 'the',
 'no article needed',
 'one',
 'D',
 'No article is needed before titles/roles when they refer to a unique position held by one person at a time (head, president, captain, CEO). Option A and C are commonly overused here. "The head" would imply there are multiple heads and she is one specific one. "A head" would imply she is one of several heads. Since "head of the department" is a unique role, no article is correct.',
 2);

-- Q21: Prepositions
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='ielts.gram.prepositions'),
 'The research team is focusing _____ the long-term effects of microplastics.',
 'at',
 'in',
 'on',
 'with',
 'for',
 'C',
 '"Focus on" is a fixed collocation. The verb "focus" always pairs with "on" when meaning "to concentrate attention on something." Options A (at), B (in), D (with), and E (for) do not form correct collocations with "focus" in this meaning.',
 1);

-- =========================================================================
-- IELTS: Vocabulary (3 questions)
-- =========================================================================

-- Q22: Academic word list
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='ielts.vocab.academic'),
 'The study _____ a significant correlation between sleep duration and academic performance.',
 'made',
 'did',
 'established',
 'put',
 'got',
 'C',
 '"Established" is an academic word meaning "demonstrated or proved the existence of." It collocates naturally with "correlation" in research writing. "Made a correlation" (A) is unidiomatic. "Did" (B) and "got" (E) are too informal for academic writing. "Put" (D) does not collocate with "correlation."',
 3);

-- Q23: Collocations
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='ielts.vocab.precision'),
 'The government needs to _____ action to address rising unemployment.',
 'do',
 'make',
 'take',
 'give',
 'have',
 'C',
 '"Take action" is the correct collocation. While "do" pairs with general activities, specific nouns like "action," "measures," "steps," and "precautions" use "take." Option A (do action), B (make action), D (give action), and E (have action) are all unidiomatic.',
 3);

-- Q24: Topic vocabulary
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='ielts.vocab.basic'),
 'Which word best completes the sentence: "Renewable energy sources such as solar and wind power are becoming increasingly _____ as technology improves."?',
 'expensive',
 'viable',
 'ancient',
 'scarce',
 'complicated',
 'B',
 '"Viable" means workable, practical, or capable of succeeding — fitting the context of technology making renewable energy more practical. Option A (expensive) contradicts the positive trend implied. Option C (ancient) is factually wrong. Option D (scarce) means rare/limited, opposite of the intended meaning. Option E (complicated) doesn''t fit — technology improvements typically make things simpler, not more complicated.',
 1);

-- =========================================================================
-- SNBT: Penalaran Umum (PU) — 5 questions
-- =========================================================================

-- Q25: Inverse proportion
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.pu.inverse_proportion'),
 'Sebuah proyek perbaikan jalan direncanakan selesai dalam 30 hari oleh 15 pekerja. Setelah 10 hari bekerja, proyek terhenti selama 5 hari karena hujan. Berapa tambahan pekerja yang diperlukan agar proyek selesai tepat waktu?',
 '3 pekerja',
 '5 pekerja',
 '8 pekerja',
 '10 pekerja',
 '15 pekerja',
 'B',
 'Sisa pekerjaan = 20 hari × 15 pekerja = 300 satuan kerja. Waktu tersisa = 30 − 10 − 5 = 15 hari. Pekerja yang dibutuhkan = 300 ÷ 15 = 20 pekerja. Tambahan = 20 − 15 = 5 pekerja. Hati-hati: jangan langsung membandingkan 30:15 = 2:1 karena proyek sudah berjalan 10 hari.',
 3);

-- Q26: Work-rate
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.pu.work_rate'),
 'Mesin A dapat memproduksi 100 unit dalam 4 jam. Mesin B dapat memproduksi 100 unit dalam 5 jam. Jika kedua mesin bekerja bersama, berapa jam yang diperlukan untuk memproduksi 450 unit?',
 '8 jam',
 '9 jam',
 '10 jam',
 '11 jam',
 '12 jam',
 'C',
 'Laju A = 100/4 = 25 unit/jam. Laju B = 100/5 = 20 unit/jam. Laju gabungan = 45 unit/jam. Waktu untuk 450 unit = 450 ÷ 45 = 10 jam. Jangan menjumlahkan waktu (4+5=9) karena itu salah — yang dijumlahkan adalah laju, bukan waktu.',
 3);

-- Q27: Set theory
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.pu.set_theory'),
 'Dari 80 siswa, 50 siswa menyukai matematika, 45 siswa menyukai fisika, dan x siswa menyukai keduanya. Jika setiap siswa menyukai minimal satu pelajaran, berapa nilai x?',
 '5',
 '10',
 '15',
 '20',
 '25',
 'C',
 'Gunakan rumus: |M ∪ F| = |M| + |F| − |M ∩ F|. 80 = 50 + 45 − x → 80 = 95 − x → x = 15. Cek: yang hanya suka matematika = 50−15 = 35, hanya fisika = 45−15 = 30, keduanya = 15, total = 35+30+15 = 80. ✔',
 3);

-- Q28: Deduction & syllogisms
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.pu.deduction'),
 'Semua ikan lele adalah ikan air tawar. Semua ikan air tawar hidup di perairan non-asin. Sebagian ikan yang hidup di perairan non-asin dibudidayakan di kolam. Kesimpulan yang PASTI benar:',
 'Semua ikan lele dibudidayakan di kolam',
 'Sebagian ikan lele hidup di perairan non-asin',
 'Semua yang dibudidayakan di kolam adalah ikan lele',
 'Semua ikan lele hidup di perairan non-asin',
 'Sebagian ikan air tawar adalah ikan lele',
 'D',
 'Dari premis: lele → air tawar → perairan non-asin. Jadi semua lele pasti hidup di perairan non-asin. A tidak pasti (hanya "sebagian" yang dibudidayakan). B salah (semua, bukan sebagian). C membalik arah (tidak semua yang dibudidayakan adalah lele). E benar tapi itu bukan kesimpulan dari rangkaian — premis 1 sudah menyatakan "semua ikan lele adalah ikan air tawar," dan "sebagian" lebih lemah dari "semua." Yang ditanya adalah kesimpulan dari seluruh rangkaian.',
 2);

-- Q29: Number patterns
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.pu.number_patterns'),
 'Lanjutkan deret: 3, 6, 11, 18, 27, ...',
 '36',
 '38',
 '40',
 '43',
 '45',
 'B',
 'Pola selisih: +3, +5, +7, +9, +11. Selanjutnya: 27 + 11 = 38. Atau rumus suku ke-n: Un = n² + 2. U6 = 36 + 2 = 38. Periksa: U1=1²+2=3, U2=4+2=6, U3=9+2=11, U4=16+2=18, U5=25+2=27, U6=36+2=38. ✔',
 2);

-- =========================================================================
-- SNBT: PPU — 3 questions
-- =========================================================================

-- Q30: Word & phrase meaning
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.ppu.word_meaning'),
 'Kata "kontribusi" dalam kalimat "Kontribusi UMKM terhadap PDB nasional mencapai 60%" paling tepat bermakna:',
 'Sumbangan atau andil',
 'Persaingan atau rivalitas',
 'Ketergantungan atau relasi',
 'Pengaruh atau dampak negatif',
 'Keuntungan atau laba bersih',
 'A',
 'Dalam konteks ekonomi, "kontribusi" berarti sumbangan, andil, atau peran serta terhadap sesuatu. UMKM menyumbang 60% terhadap PDB. Opsi B (persaingan), C (ketergantungan), D (pengaruh negatif) tidak sesuai konteks positif kalimat. Opsi E (keuntungan) salah — kontribusi terhadap PDB bukan laba, melainkan nilai tambah.',
 2);

-- Q31: Paragraph main idea
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.ppu.paragraph_idea'),
 'Bacalah: "Fenomena brain drain atau migrasi tenaga terampil Indonesia ke luar negeri terus meningkat. Data Bank Dunia menunjukkan sekitar 8% lulusan perguruan tinggi Indonesia memilih bekerja di luar negeri. Rendahnya insentif riset dan terbatasnya lapangan kerja berkualitas di dalam negeri menjadi faktor pendorong utama." Ide pokok paragraf tersebut adalah:',
 'Data Bank Dunia tentang lulusan Indonesia',
 'Rendahnya insentif riset di Indonesia',
 'Penyebab utama brain drain adalah kurangnya lapangan kerja berkualitas',
 'Meningkatnya migrasi tenaga terampil Indonesia ke luar negeri',
 'Perbandingan gaji tenaga kerja dalam dan luar negeri',
 'D',
 'Ide pokok terdapat di kalimat pertama: meningkatnya brain drain (migrasi tenaga terampil). Kalimat berikutnya adalah data pendukung dan penyebab. Opsi A dan B adalah detail, bukan ide pokok. Opsi C adalah penyebab (kalimat penjelas). Opsi E tidak disebutkan dalam paragraf.',
 2);

-- Q32: General knowledge
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.ppu.general_knowledge'),
 'Indonesia memiliki keragaman suku bangsa yang sangat tinggi. Suku dengan populasi terbesar di Indonesia adalah:',
 'Suku Sunda',
 'Suku Batak',
 'Suku Jawa',
 'Suku Minangkabau',
 'Suku Bugis',
 'C',
 'Berdasarkan data BPS, Suku Jawa merupakan suku dengan populasi terbesar di Indonesia (sekitar 40% dari total penduduk). Suku Sunda adalah terbesar kedua (sekitar 15%). Suku Batak, Minangkabau, dan Bugis memiliki populasi yang lebih kecil.',
 3);

-- =========================================================================
-- SNBT: PBM — 3 questions
-- =========================================================================

-- Q33: Spelling (Ejaan & PUEBI)
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.pbm.spelling'),
 'Penulisan kata serapan yang BENAR sesuai PUEBI adalah:',
 'Hakekat, khawatir, komplek',
 'Hakikat, khawatir, kompleks',
 'Hakekat, kawatir, kompleks',
 'Hakikat, khawatir, komplek',
 'Hakikat, kawatir, kompleks',
 'B',
 'Menurut PUEBI: "hakikat" (bukan hakekat — dari Arab haqīqah), "khawatir" (bukan kawatir — dari Arab khawf), "kompleks" (bukan komplek — dari Inggris complex). Opsi A: "hakekat" dan "komplek" salah. Opsi C: "hakekat" dan "kawatir" salah. Opsi D: "komplek" salah. Opsi E: "kawatir" salah.',
 2);

-- Q34: Effective sentence (Kalimat efektif)
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.pbm.effective_sentence'),
 'Manakah kalimat yang PALING EFEKTIF?',
 'Bagi para mahasiswa-mahasiswa diharapkan mengumpulkan tugas tepat pada waktunya.',
 'Para mahasiswa diharapkan mengumpulkan tugas tepat waktu.',
 'Mahasiswa-mahasiswa diharapkan untuk dapat mengumpulkan tugas pada tepat waktunya.',
 'Kepada para mahasiswa diharap untuk mengumpulkan tugasnya tepat waktu.',
 'Mahasiswa diharapkan mengumpulkan tugas-tugasnya dengan tepat pada waktunya.',
 'B',
 'Kalimat efektif harus hemat kata, tidak boros, dan lugas. Opsi B paling ringkas tanpa pengulangan. Opsi A boros: "bagi para mahasiswa-mahasiswa" (para + pengulangan). Opsi C boros: "untuk dapat." Opsi D tidak baku: "diharap" dan "kepada" tidak diperlukan. Opsi E boros: "tugas-tugasnya" dan "dengan."',
 3);

-- Q35: Text comprehension
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.pbm.text_comprehension'),
 '"Meskipun pemerintah telah meluncurkan berbagai program pengentasan kemiskinan, angka kemiskinan hanya turun 0,5% dalam lima tahun terakhir. Hal ini menunjukkan bahwa kebijakan yang ada belum menyentuh akar masalah." Pernyataan yang sesuai dengan teks:',
 'Program pemerintah berhasil menurunkan kemiskinan secara signifikan',
 'Angka kemiskinan tidak mengalami perubahan sama sekali',
 'Kebijakan yang ada dinilai belum mengatasi penyebab utama kemiskinan',
 'Pemerintah tidak memiliki program pengentasan kemiskinan',
 'Penurunan 0,5% menunjukkan program pemerintah gagal total',
 'C',
 'Kalimat kedua teks menyatakan kebijakan "belum menyentuh akar masalah" — sesuai opsi C. Opsi A bertentangan (turun hanya 0,5% tidak signifikan). Opsi B salah (ada penurunan 0,5%). Opsi D bertentangan (pemerintah telah meluncurkan program). Opsi E terlalu ekstrem — turun 0,5% bukan berarti gagal total, teks hanya menyatakan belum menyentuh akar masalah.',
 2);

-- =========================================================================
-- SNBT: PK — 5 questions
-- =========================================================================

-- Q36: Arithmetic (Bilangan & operasi)
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.pk.numbers'),
 'Hasil dari 2⅓ × 1½ ÷ ⅚ adalah:',
 '3⅕',
 '3⅔',
 '4⅕',
 '4⅓',
 '5',
 'C',
 'Ubah ke pecahan: 2⅓ = 7/3, 1½ = 3/2, ⅚ = 5/6. Hitung: (7/3 × 3/2) ÷ 5/6 = (7/2) ÷ (5/6) = 7/2 × 6/5 = 42/10 = 21/5 = 4⅕. Alternatif: 7/2 × 6/5 = 42/10 = 4,2 = 4⅕.',
 2);

-- Q37: Algebra
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.pk.algebra'),
 'Jika 3x − 2y = 11 dan x + y = 7, maka nilai 2x + y adalah:',
 '9',
 '11',
 '12',
 '13',
 '15',
 'C',
  'Dari x + y = 7 → y = 7 − x. Substitusi ke 3x − 2(7−x) = 11 → 3x − 14 + 2x = 11 → 5x = 25 → x = 5. Maka y = 7 − 5 = 2. Jadi 2x + y = 2(5) + 2 = 10 + 2 = 12. Jawaban: C.',
  3);

-- Q38: Geometry
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.pk.geometry'),
 'Sebuah segitiga siku-siku memiliki panjang sisi miring 13 cm dan salah satu sisi tegaknya 5 cm. Luas segitiga tersebut adalah:',
 '30 cm²',
 '32,5 cm²',
 '60 cm²',
 '65 cm²',
 '78 cm²',
 'A',
 'Cari sisi tegak lainnya dengan Pythagoras: b² = 13² − 5² = 169 − 25 = 144, maka b = 12 cm. Luas = ½ × alas × tinggi = ½ × 5 × 12 = 30 cm². Jangan terkecoh menghitung keliling atau langsung mengalikan 13 × 5.',
 3);

-- Q39: Statistics
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.pk.data'),
 'Nilai ulangan 10 siswa: 65, 70, 75, 75, 80, 80, 85, 85, 90, 95. Median dari data tersebut adalah:',
 '75',
 '80',
 '82,5',
 '85',
 '87,5',
 'B',
 'Data sudah terurut. Jumlah data genap (10), median = rata-rata data ke-5 dan ke-6. Data ke-5 = 80, data ke-6 = 80. Median = (80+80)/2 = 80. Hati-hati: median bukan rata-rata seluruh data (mean = 80, tapi median juga 80 untuk kasus ini).',
 3);

-- Q40: Additional arithmetic
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.pk.numbers'),
 'FPB dari 72, 96, dan 120 adalah:',
 '6',
 '8',
 '12',
 '24',
 '36',
 'D',
 'Faktorisasi: 72 = 2³ × 3², 96 = 2⁵ × 3, 120 = 2³ × 3 × 5. FPB = 2³ × 3 = 8 × 3 = 24. Ambil pangkat terkecil untuk setiap faktor prima yang sama.',
 2);

-- =========================================================================
-- SNBT: LBI — 3 questions
-- =========================================================================

-- Q41: Info extraction
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.lbi.info_extraction'),
 'Teks: "Kementerian Pendidikan melaporkan bahwa angka partisipasi sekolah tingkat SMP mencapai 95,4% pada tahun 2024, naik dari 93,1% pada tahun 2020. Namun, kesenjangan antara daerah perkotaan dan perdesaan masih cukup lebar, mencapai 8,3 poin persentase." Berdasarkan teks, kenaikan angka partisipasi sekolah SMP dari 2020 ke 2024 adalah:',
 '0,5%',
 '2,3%',
 '5,4%',
 '8,3%',
 '95,4%',
 'B',
 'Kenaikan = 95,4% − 93,1% = 2,3 poin persentase. Opsi D (8,3%) adalah kesenjangan perkotaan-perdesaan, bukan kenaikan. Opsi C (5,4%) tidak ada dalam teks. Opsi E (95,4%) adalah angka tahun 2024, bukan kenaikan.',
 2);

-- Q42: Interpretation
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.lbi.interpretation'),
 'Teks yang sama (Q41). Apa implikasi dari kesenjangan 8,3 poin persentase antara perkotaan dan perdesaan?',
 'Seluruh anak di perkotaan sudah bersekolah semua',
 'Program pemerataan akses pendidikan di perdesaan masih perlu ditingkatkan',
 'Angka partisipasi di perdesaan lebih tinggi daripada di perkotaan',
 'Kesenjangan tersebut tidak signifikan secara statistik',
 'Pemerintah tidak perlu melakukan intervensi tambahan',
 'B',
 'Kesenjangan 8,3 poin menunjukkan adanya ketimpangan akses pendidikan antara kota dan desa. Implikasi logisnya adalah perlunya program pemerataan, terutama di perdesaan. Opsi A terlalu absolut. Opsi C terbalik (kota biasanya lebih tinggi). Opsi D bertentangan dengan konteks (8,3 poin adalah kesenjangan signifikan). Opsi E bertentangan dengan kebutuhan intervensi.',
 3);

-- Q43: Evaluation
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.lbi.evaluation'),
 'Manakah pernyataan yang paling TEPAT mengevaluasi kelemahan argumen berikut: "Program vaksinasi nasional berhasil karena jumlah kasus menurun 40% dalam 6 bulan terakhir."',
 'Penurunan 40% adalah angka yang terlalu kecil untuk disebut keberhasilan',
 'Penurunan kasus bisa disebabkan faktor lain seperti peningkatan imunitas alami atau pembatasan sosial, bukan semata-mata vaksinasi',
 'Vaksinasi nasional belum tentu menjangkau seluruh wilayah Indonesia',
 'Data penurunan 40% mungkin tidak akurat karena pelaporan yang buruk',
 'Program vaksinasi justru dapat menyebabkan peningkatan kasus',
 'B',
 'Kelemahan utama adalah korelasi tidak membuktikan kausalitas — penurunan kasus bisa disebabkan oleh banyak faktor (confounding variables), bukan hanya vaksinasi. Evaluasi yang baik mengidentifikasi kelemahan logis argumen. Opsi A, C, D membahas detail angka atau cakupan, bukan struktur logika. Opsi E salah secara faktual.',
 4);

-- =========================================================================
-- SNBT: LBE — 3 questions
-- =========================================================================

-- Q44: Main idea & purpose
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.lbe.main_idea'),
 'Text: "Remote work has transformed the global workforce. Companies report increased productivity and lower operational costs. However, challenges remain, including communication barriers and employee isolation. Experts suggest a hybrid model may offer the best balance." The main idea of the text is:',
 'Remote work eliminates all workplace problems',
 'Communication barriers make remote work impossible',
 'Remote work offers benefits but also presents challenges, making hybrid models a potential solution',
 'Companies should abandon remote work entirely',
 'Productivity always increases with remote work',
 'C',
 'The text presents both benefits (productivity, lower costs) and challenges (communication, isolation), concluding with the hybrid model as a balanced solution. Option A and E overstate. Option B and D go against the text (challenges exist but work isn''t impossible; no call to abandon it).',
 2);

-- Q45: Inference & tone
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.lbe.inference'),
 'Text: "The city council voted unanimously to reject the proposed shopping mall development, citing concerns over traffic congestion and the potential loss of green space. Local residents had campaigned against the project for over a year." What can be inferred about the author''s tone?',
 'Strongly supportive of the shopping mall',
 'Neutral and objective, reporting facts without bias',
 'Skeptical about the residents'' campaign',
 'Critical of the city council''s decision',
 'Enthusiastic about commercial development',
 'B',
 'The text presents facts without evaluative language: it reports the vote, the reasons, and the residents'' campaign — all neutrally. There are no adjectives indicating support or criticism. Option A and E are unsupported. Option C and D would require judgmental language not present in the text.',
 4);

-- Q46: Vocabulary in context (LBE)
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.lbe.vocab_context'),
 'In the sentence "The committee decided to postpone the implementation of the new policy until further data could be collected," the word "postpone" most nearly means:',
 'Cancel permanently',
 'Speed up',
 'Put off until a later time',
 'Announce publicly',
 'Modify substantially',
 'C',
 'The phrase "until further data could be collected" indicates the action is delayed, not cancelled — matching "put off until a later time." Option A (cancel permanently) contradicts the temporary nature implied. Option B (speed up) is the opposite. Option D (announce) doesn''t fit the context. Option E (modify) changes the meaning entirely.',
 3);

-- =========================================================================
-- SNBT: PM — 5 questions
-- =========================================================================

-- Q47: Formulating models
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.pm.formulate'),
 'Seorang peternak memiliki 20 ekor sapi. Setiap hari, satu ekor sapi membutuhkan 15 kg pakan. Pakan tersedia dalam karung berisi 50 kg. Model matematika untuk menghitung banyak karung pakan (K) yang dibutuhkan untuk memberi makan seluruh sapi selama h hari adalah:',
 'K = (20 × h) ÷ (15 × 50)',
 'K = (20 × 15 × h) ÷ 50',
 'K = (20 × 15) ÷ (h × 50)',
 'K = (15 × h) ÷ (20 × 50)',
 'K = (50 × h) ÷ (20 × 15)',
 'B',
 'Total pakan = jumlah sapi × pakan per ekor × hari = 20 × 15 × h kg. Jumlah karung = total pakan ÷ kapasitas per karung = (20 × 15 × h) ÷ 50. Opsi A mengalikan h dengan 50 secara salah. Opsi C membagi dengan h (seharusnya mengalikan). Opsi D dan E membalik pembilang dan penyebut.',
 3);

-- Q48: Employing procedures 1
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.pm.employ'),
 'Sebuah kolam renang berbentuk balok dengan panjang 25 m, lebar 10 m, dan kedalaman 1,5 m akan diisi air hingga penuh. Jika debit air dari pompa adalah 500 liter per menit, berapa jam waktu yang diperlukan untuk mengisi kolam?',
 '10,5 jam',
 '12,5 jam',
 '15 jam',
 '18 jam',
 '25 jam',
 'B',
 'Volume kolam = 25 × 10 × 1,5 = 375 m³ = 375.000 liter. Waktu = volume ÷ debit = 375.000 ÷ 500 = 750 menit = 750 ÷ 60 = 12,5 jam. Perhatikan konversi satuan: m³ ke liter (×1.000) dan menit ke jam (÷60).',
 3);

-- Q49: Employing procedures 2
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.pm.employ'),
 'Harga sebuah barang setelah diskon 15% adalah Rp340.000,00. Harga barang tersebut sebelum diskon adalah:',
 'Rp391.000,00',
 'Rp400.000,00',
 'Rp425.000,00',
 'Rp450.000,00',
 'Rp510.000,00',
 'B',
 'Misal harga awal = x. Setelah diskon 15%: x − 0,15x = 0,85x = 340.000. Maka x = 340.000 ÷ 0,85 = 400.000. Cek: 15% × 400.000 = 60.000, 400.000 − 60.000 = 340.000. ✔ Jangan langsung 340.000 × 1,15 = 391.000 karena itu menghitung 15% dari 340.000, bukan dari harga awal.',
 3);

-- Q50: Interpreting & evaluating
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.pm.interpret'),
 'Grafik menunjukkan suhu harian kota A selama seminggu: Sen(28°), Sel(30°), Rab(32°), Kam(29°), Jum(27°), Sab(31°), Min(33°). Kesimpulan yang BENAR berdasarkan data:',
 'Suhu selalu naik setiap hari',
 'Suhu tertinggi terjadi pada hari Rabu',
 'Rata-rata suhu selama seminggu adalah 30°',
 'Selisih suhu tertinggi dan terendah adalah 5°',
 'Suhu mengalami penurunan pada hari Kamis dan Jumat',
 'C',
 'Rata-rata = (28+30+32+29+27+31+33) ÷ 7 = 210 ÷ 7 = 30°. Opsi A salah (naik-turun). Opsi B salah (tertinggi Minggu 33°, bukan Rabu 32°). Opsi D salah (33−27=6°, bukan 5°). Opsi E sebagian benar (turun Kamis-Jumat) tapi tidak lengkap — rata-rata adalah kesimpulan yang mencakup keseluruhan data.',
 4);

-- Q51: Formulating models 2
INSERT INTO practice_questions (competency_id, question, option_a, option_b, option_c, option_d, option_e, correct_answer, explanation, difficulty) VALUES
((SELECT id FROM competencies WHERE code='snbt.pm.formulate'),
 'Sebuah perusahaan taksi menetapkan tarif: biaya buka pintu Rp7.000,00 dan tarif per kilometer Rp4.500,00. Model matematika untuk total biaya (B) sebagai fungsi jarak tempuh (x km) adalah:',
 'B = 4.500 + 7.000x',
 'B = 7.000 + 4.500x',
 'B = 7.000x + 4.500x',
 'B = 11.500x',
 'B = 7.000 − 4.500x',
 'B',
 'Biaya total = biaya tetap (buka pintu) + biaya variabel (per km × jarak). B = 7.000 + 4.500x. Opsi A membalik koefisien. Opsi C dan D menjumlahkan koefisien secara salah. Opsi E menggunakan pengurangan yang tidak sesuai.',
 3);