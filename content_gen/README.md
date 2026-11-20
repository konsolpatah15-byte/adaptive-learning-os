# ALOS Content Generation

This directory contains:
- **ielts_content.sql** — Generated curriculum topics for all 24 IELTS competencies
- **snbt_content.sql** — Generated curriculum topics for all 30 SNBT competencies
- **apply_content.py** — Script to apply SQL files to the database
- **RESOURCES.md** — Comprehensive resource index with all external sources
- **METHODOLOGY.md** — Evidence-based learning methodology reference
- **README.md** — This file

## How to Apply Content

```bash
cd /data/workspace/adaptive-learning-os/content_gen
python3 apply_content.py
```

This will:
1. Load both SQL files
2. Insert all curriculum topics into the database
3. Display topic counts per competency

## Content Stats

- **Total competencies**: 54 (24 IELTS + 30 SNBT)
- **Target topics**: 2+ per competency = 120+ total
- **Languages**: Indonesian (primary), with English terminology
- **Methods used**: All 10 teaching strategies (direct, socratic, demo, analogy, scenario, visual, guided, discussion, case, practical)
- **Analogies**: Aquaculture/farming (kolam lele, pompa air, panen, pakan) — relevant to Indonesian context

## Content Sources

All content is originally generated based on:
1. Official IELTS/SNBT test specifications
2. Evidence-based teaching methods (see METHODOLOGY.md)
3. International curriculum standards (CEFR, Bloom's Taxonomy)
4. Real-world Indonesian context (aquaculture, agriculture)

Direct scrapes from:
- British Council IELTS
- Cambridge English
- Khan Academy
- Purdue OWL
- BBC Learning English
- Analitica.id (SNBT priority map)
- RuangTes.id (SNBT practice questions)