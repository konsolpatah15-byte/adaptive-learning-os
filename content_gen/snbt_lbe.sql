-- SNBT LBE
INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.lbe.main_idea'), 'Main Idea — Finding the Topic Sentence', 'id', 'guided', 2, 1, '## Topic Sentence = Main Idea in One Sentence

In English academic texts, the main idea is almost always in the FIRST sentence of each paragraph. This is called the "topic sentence."

**The 80/20 Rule:** 80% of the time, the main idea is in the first sentence. 20% — last sentence (conclusion-style paragraphs).

**Quick method:**
1. Read the FIRST sentence
2. Read the LAST sentence
3. Ask: "What is this paragraph TRYING to prove or explain?"
4. The answer = main idea

**Example paragraph:**
"Tilapia farming has grown rapidly in Southeast Asia over the past decade. Indonesia alone produces over 1.5 million tons annually. Thailand and the Philippines have also seen double-digit growth. Experts attribute this to low production costs and high consumer demand."

Main idea: Tilapia farming has grown rapidly in Southeast Asia. (First sentence!)

**Distractor types in LBE:**
- Too specific: "Indonesia produces 1.5 million tons" — only a detail
- Too broad: "Fish farming is important globally" — not what the paragraph is about
- Off-topic: "Aquaculture creates jobs" — true but not in this paragraph

**Practice:** find the main idea of this paragraph in 10 seconds:
"Climate change poses serious risks to coastal aquaculture. Rising sea temperatures increase disease outbreaks in shrimp farms. Saltwater intrusion damages freshwater fish ponds. Farmers report losing up to 40% of their stock during extreme weather events.');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.lbe.main_idea'), 'Text Purpose — Inform, Persuade, or Entertain?', 'id', 'case', 2, 2, '## Every Text Has a Purpose

**Three main purposes:**
1. **To inform:** presents facts, explains, describes. Neutral tone. No opinion.
2. **To persuade:** argues a position, tries to convince. Uses evidence + opinion.
3. **To entertain:** tells a story, creates emotion. Narrative style.

**Identifying purpose — key signals:**

**Informative:**
- "According to research..." / "Data shows..."
- Numbers, statistics, definitions
- No personal pronouns (I, we, you — rarely)
- Example: encyclopedia entries, news reports, scientific articles

**Persuasive:**
- "We should..." / "It is essential that..."
- Emotional language, rhetorical questions
- Calls to action
- Counter-arguments addressed
- Example: opinion pieces, advertisements, policy proposals

**Entertaining:**
- Story elements: characters, plot, dialogue
- Descriptive, sensory language
- Humor, suspense, surprise
- Example: short stories, personal anecdotes, novels

**LBE common question:** "What is the author''s purpose in writing this text?"
→ Identify the dominant purpose. Most texts mix purposes, but ONE is primary.

**Practice:** "Although biofloc technology requires initial investment, the long-term savings on feed costs make it the most economical choice for small-scale fish farmers." — What is the purpose?');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.lbe.inference'), 'Inference — Reading Between the Lines', 'id', 'case', 4, 1, '## Inference = NOT Written, But SUPPORTED

Inference questions are the hardest in LBE because the answer is NOT directly in the text — but it MUST be supported by the text.

**The inference test:**
"Could I point to specific sentences in the text that SUPPORT this answer, even though they don''t say it directly?"

**Example:**
Text: "Unlike his competitors, Rahman never missed a feeding schedule. His harvest was consistently the largest in the cooperative."
Question: What can be inferred about Rahman''s competitors?
Answer: They were less disciplined in feeding. (Supported by "unlike his competitors" + Rahman''s discipline)

**Inference question signals:**
- "What can be inferred..."
- "The author implies/suggests..."
- "It can be concluded that..."
- "The text most likely..."

**Three types of answer choices:**
1. STATED directly → NOT an inference (it''s a detail question)
2. SUPPORTED but not stated → CORRECT inference
3. UNSUPPORTED / too far → WRONG (the trap!)

**Elimination strategy:** for each option, ask "Does the text give me evidence for this?" If you have to ADD assumptions from outside the text → eliminate it.

**Practice:** "The river that once supported dozens of fishing families now runs clear — too clear. The fish disappeared three years after the factory opened upstream." What can be inferred about the factory?');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.lbe.inference'), 'Tone and Writer''s Attitude', 'id', 'guided', 4, 2, '## Tone = The Writer''s Emotional Stance

Tone questions ask HOW the author feels about the subject — not WHAT they say.

**Common tones in LBE:**
- **Critical/concerned:** "This alarming trend threatens..." (negative, worried)
- **Optimistic/hopeful:** "Despite challenges, promising solutions are emerging."
- **Neutral/objective:** "The study examined 500 samples over three years."
- **Skeptical/doubtful:** "Whether this approach can scale remains to be seen."
- **Enthusiastic:** "This breakthrough could revolutionize the industry!"

**Tone signals:**
- Word choice: "catastrophic" vs "challenging" vs "interesting"
- Modals: "must" (strong), "should" (persuasive), "may" (tentative)
- Punctuation: exclamation marks = enthusiasm; questions = doubt
- Adjectives/adverbs: "remarkably effective" vs "somewhat useful"

**Distinguishing tone from mood:**
- Tone = writer''s attitude toward the SUBJECT
- Mood = emotional ATMOSPHERE created for the reader

**Example:**
"The government''s latest aquaculture policy contains ambitious targets. Whether these targets survive contact with reality remains an open question."
Tone: skeptical (the second sentence undercuts the first — "survive contact with reality" = doubt)

**Practice:** "At last, after decades of overfishing, marine protected areas are showing results. Fish populations are rebounding. Coral cover is increasing. There is reason for hope." — What is the writer''s tone?');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.lbe.vocab_context'), 'Vocabulary in Context — Don''t Panic, Use Clues', 'id', 'guided', 3, 1, '## Context Clues = Your Best Friend

You don''t need to know every English word. The text GIVES you clues.

**Types of context clues:**
1. **Definition clue:** "Aquaponics, a system combining fish farming with hydroponic plant cultivation, is gaining popularity."
→ "combining fish farming with hydroponic plant cultivation" DEFINES aquaponics

2. **Synonym clue:** "The harvest was bountiful — abundant and plentiful beyond expectations."
→ "abundant and plentiful" = synonyms of bountiful

3. **Contrast clue:** "Unlike the arid highlands, the coastal region receives ample rainfall."
→ "arid" contrasts with "ample rainfall" → arid = dry

4. **Example clue:** "Crustaceans such as shrimp, crab, and lobster are high-value exports."
→ "shrimp, crab, lobster" are examples of crustaceans

5. **Experience clue:** "The farmer''s face showed consternation when he saw his entire crop destroyed by the flood."
→ "entire crop destroyed" → consternation = shock/horror/dismay

**Strategy for LBE vocab questions:**
1. Find the word in the text
2. Read the FULL sentence + 1 sentence before and after
3. Identify the clue type (definition, synonym, contrast...)
4. Predict the meaning in your own words
5. Match your prediction to the answer choices

**NEVER:** guess based on what the word looks like or sounds like. ALWAYS use context.

**Practice:** "The efficacy of the new vaccine was demonstrated when fish mortality dropped by 80%." What does "efficacy" mean?');INSERT INTO curriculum_topics (competency_id, title, language, method, difficulty, sort_order, content_md) VALUES
((SELECT id FROM competencies WHERE code='snbt.lbe.vocab_context'), 'Common Prefixes and Roots for Guessing Meaning', 'id', 'direct', 3, 2, '## Word Parts — Your Emergency Backup

When context clues aren''t enough, break the word into parts.

**Common prefixes:**
- un-/in-/im-/dis- = not (unlikely, invisible, impossible, disagree)
- re- = again (rebuild, reconsider, reheat)
- pre- = before (preview, prehistoric, predict)
- post- = after (postpone, post-war)
- sub-/under- = below (submarine, underwater)
- super-/over- = above, excessive (supervise, overproduce)
- inter- = between (international, interact)
- trans- = across (transport, transform)

**Common roots:**
- aqua-/hydro- = water (aquaculture, hydroponics)
- bio- = life (biology, biofloc)
- agri-/agro- = farming (agriculture, agroforestry)
- pisc- = fish (pisciculture = fish farming)
- -culture = cultivation/growing (agriculture, aquaculture)

**Example:** "The aquaponic system integrates pisciculture with hydroponics."
- aqua- = water, -ponic = work → water-working system
- pisci- = fish, -culture = cultivation → fish farming
- hydro- = water, -ponic = work → water-based plant growing
So: a system combining fish farming with water-based plant growing.

**Warning:** word parts help but are not 100% reliable. ALWAYS confirm with context. "Inflammable" looks like "not flammable" but actually means "easily catches fire!"

**Practice:** guess the meaning of "bioremediation" from its parts. (bio- + re- + med- = ?)');