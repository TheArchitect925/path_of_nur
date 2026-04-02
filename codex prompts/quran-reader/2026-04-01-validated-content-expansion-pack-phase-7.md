===== PHASE X PROMPT phase 7 — VALIDATED CONTENT EXPANSION PACK (FOUNDATIONS + COMMON SURAHS + KIDS STARTER) =====

PRIMARY OBJECTIVE === BUILDING VALIDATED QURAN EXPLANATION CONTENT EXPANSION PACK

You are working in the existing Flutter codebase for Path of Nūr.

Always ensure the system is not going haywire and removing deleting records for no reason.

Instead of only doing a v1 or placeholder let’s always build out everything into a production ready product.

===== QURAN EXPLANATION SOURCE & VALIDATION RULE =====

All Qur’an explanation content MUST follow authentic tafsir methodology.

When generating explanation content:

1. Determine the meaning using:
   - Qur’an (cross-referenced ayahs)
   - authentic tafsir grounding (e.g., Ibn Kathir-level understanding)
   - widely accepted interpretations from mainstream Sunni scholarship

2. Then simplify into Path of Nūr language:
   - simple
   - standard
   - kids

3. STRICT RULES:
   - Do NOT copy tafsir text directly
   - Do NOT invent interpretations
   - Do NOT introduce speculative or modern reinterpretations without grounding
   - Do NOT introduce sectarian, fringe, polemical, or weakly grounded claims
   - If meaning is unclear or disputed, keep explanation general and safe

4. PRIORITY:
   - accuracy over creativity
   - clarity over depth
   - simplicity without distortion

5. If uncertain:
   - fallback to a safe, widely accepted general meaning
   - never guess or over-interpret

===== END =====

At the very end, audit everything and provide one full summary.

TASK TYPE
Controlled, high-quality expansion of ayah explanation content using the established editorial pipeline.

GOAL
Add a new curated explanation dataset that:
- expands beyond the initial seeded pack
- focuses on foundational, high-impact ayahs
- maintains strict tafsir-grounded accuracy
- maintains consistent Path of Nūr tone
- supports simple, standard, and kids explanation levels
- integrates cleanly into the existing explanation system
- respects coverage governance and validation rules

IMPORTANT PRODUCT DIRECTION
This is NOT a bulk “fill everything” phase.

This is:
- curated
- high-quality
- foundational-first
- safe expansion

Better:
✔️ 30–80 high-quality ayahs  
Than:
❌ 300 weak or inconsistent ones

EXECUTION RULES
1. Audit existing coverage first using the coverage manifest from Phase 6.
2. Do not overwrite existing entries unless clearly improving them.
3. Add only new ayahs or fill missing detail levels where safe.
4. Use the editorial template for every entry.
5. Respect rollout packs and grouping structure.
6. Keep tone consistent across all new entries.
7. Run validation helpers after adding content.
8. Run analyzer and summarize results.
9. Provide a final audit summary.

AUDIT REQUIREMENTS

A. Identify current coverage
Using the coverage manifest:
- list ayahs already covered
- identify gaps in:
  - simple
  - standard
  - kids
  - deep (optional)
- identify which packs are incomplete

B. Select next expansion packs
Build at least these packs:

1. Foundations Pack
Core belief and guidance ayahs, for example:
- Surah Al-Ikhlas (112)
- Surah Al-Asr (103)
- Surah Al-Kawthar (108)
- Surah Al-Falaq (113)
- Surah An-Nas (114) if not already covered
- Additional foundational ayahs if not already seeded

2. Common Salah Surahs Pack
Surahs commonly recited in daily prayer:
- Surah Al-Ma’un (107)
- Surah Quraysh (106)
- Surah Al-Fil (105)
- Surah Al-Takathur (102)
- Surah Al-Qari’ah (101)

3. Kids Starter Pack
Ayahs ideal for children:
- short, clear, moral-driven ayahs
- high clarity and simple meaning
- easy to explain and remember

4. Reflection Pack (selected ayahs)
A small set of ayahs that:
- encourage thinking
- connect to daily life
- are suitable for reflection mode

Do NOT over-expand beyond these packs in this phase.

IMPLEMENTATION REQUIREMENTS

C. Add explanation entries using the canonical template
For each ayah:

Include:
- surahNumber
- ayahNumber
- simpleSummary
- standardExplanation
- kidsExplanation

Optional (include when meaningful):
- deepExplanation
- keyLessons (short, clean)
- reflectionPrompt (gentle, non-heavy)
- sourceRefs (internal structured metadata)
- reviewStatus (e.g., draft/reviewed)

D. Content writing rules

Simple:
- 1–2 sentences
- clear and beginner-friendly

Standard:
- short explanation
- meaning + key takeaway

Kids:
- very simple
- one clear teaching
- warm tone
- no abstract language

Deep (if included):
- slightly more context
- still readable
- not academic

Key lessons:
- short phrases or 1–2 bullets max

Reflection prompt:
- one gentle reflective question or action

E. Tone consistency (CRITICAL)

All content must follow Path of Nūr tone:
- calm
- clear
- spiritually grounded
- non-preachy
- non-judgmental
- non-academic
- consistent across all entries

Avoid:
- overly complex explanations
- emotional exaggeration
- long paragraphs
- mixing too many ideas into one ayah

F. Fallback safety

Ensure every new entry:
- has at least simple + standard
- has kids explanation where possible

If deep is missing:
- fallback must still work correctly

If kids is missing:
- fallback to simple safely

Never leave an ayah with empty or unusable content.

G. Assign rollout pack metadata

Each new entry must belong to a rollout pack:
- foundations
- salah_common
- kids_starter
- reflection_pack

Ensure this aligns with Phase 6 governance structure.

H. Validation pass

After adding all entries:
- run validation helpers
- confirm:
  - no duplicates
  - no missing required fields
  - no empty strings
  - valid metadata
  - fallback compatibility

I. Do not modify reader UI logic
This phase is data-only (plus minor model updates if required).
Do NOT:
- change UI behavior
- change reader rendering
- change settings logic

J. Maintain performance
Ensure data additions:
- do not degrade performance
- are structured efficiently
- do not cause heavy runtime parsing

K. Localization readiness
Do not fully localize explanation content in this phase unless trivial.
But ensure structure supports future multilingual content cleanly.

VALIDATION
1. Confirm new ayahs appear correctly in the reader.
2. Confirm explanation detail switching works with new content.
3. Confirm fallback behavior works.
4. Confirm kids reader uses kids explanations correctly.
5. Confirm no duplicate entries.
6. Confirm coverage manifest updates correctly.
7. Confirm analyzer passes.

DELIVERABLES
After implementation, provide:
- audit summary
- list of new ayahs added (grouped by pack)
- number of entries per pack
- confirmation of detail level coverage
- validation results
- any improvements made to existing entries
- analyzer results
- recommended next packs for future phases

===== END =====
