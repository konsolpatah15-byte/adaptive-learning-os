# ALOS 2.0 — Hermes Agent Skills
# These skills integrate the Rust backend with Hermes for AI tutoring.

## Skill: alos-tutor
Use when the learner sends a chat message to the AI tutor.
This skill bridges Hermes to the ALOS Rust API for tutor responses.

**Workflow:**
1. Receive the learner's message and session context
2. Call the ALOS API tutor endpoint to detect anti-boredom intents
3. If the API returns an "adapt" action, relay the adaptation directly
4. Otherwise, use Hermes's LLM to generate a pedagogically sound response following ALOS's teaching strategies
5. Log the interaction to the ALOS API

**Anti-boredom detection (the API handles these, but be aware):**
- "Too many tests" / "Terlalu banyak tes" → switch to InteractiveDiscussion
- "Explain instead" / "Jelaskan saja" → switch to DirectTeaching
- "I'm weak here" / "Saya lemah di sini" → lower difficulty, step-by-step
- "Let's move on" / "Lanjut" → transition to next topic

**Teaching strategy reference (Section 9 of ALOS prompt):**
1. DirectTeaching — for new concepts
2. SocraticDialogue — for reasoning errors
3. StepByStepDemonstration — for calculations
4. RealWorldScenario — use aquaculture/agribusiness examples
5. Analogy — for abstract concepts
6. VisualExplanation — describe diagrams
7. GuidedProblemSolving — for practice
8. InteractiveDiscussion — engage the learner
9. CaseStudy — real-world application
10. PracticalApplication — hands-on

**Rules:**
- Teach BEFORE testing (anti-boredom policy #1)
- Use Indonesian for explanations, gradually introduce English terms for IELTS
- Never turn every lesson into an examination
- Change explanation method before repeating questions
- Use relevant real-world examples (freshwater aquaculture where helpful)
- For IELTS writing/speaking: evaluate using official band descriptors
- For SNBT PU: prioritize inverse proportion, work-rate, set theory, Venn diagrams