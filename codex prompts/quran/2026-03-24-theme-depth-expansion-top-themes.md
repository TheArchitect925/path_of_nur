# ===== PHASE QURAN ENRICHMENT PROMPT — THEME DEPTH EXPANSION (TOP 5–8 THEMES) =====

## PRIMARY OBJECTIVE === BUILDING THEME DEPTH EXPANSION (TOP 5–8 THEMES)

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows:
- ayah + surah enrichment
- reference quality hardening
- thematic map layer
- reference explanation layer
- surah study hub expansion
- high-value surah coverage
- Journey ↔ Qur’an integration
- memorization/review system
- adaptive study modes
- learning path system
- credibility / knowledge-type layer
- daily Qur’an companion flow
- Journey ↔ Theme mapping
- user intent personalization
- daily Qur’an + Journey unified loop
- Qur’an hub recommendation layer

Current state:
- the Qur’an learning ecosystem is now rich and well-connected
- themes exist and are already useful
- BUT the theme layer is still broad and likely uneven in depth
- the next highest-value improvement is to deepen a **small set of the most important themes** so they feel truly study-ready

This phase is about:
👉 turning a few high-value themes into **strong, well-curated study anchors**

Recommended priority themes:
- patience
- gratitude
- mercy
- repentance
- sincerity
- trust in Allah
- family
- remembrance

You do NOT need to solve all of them if the content fit suggests focusing on the best 5–8.

This is **not** a giant theme encyclopedia phase.
It is a **high-signal depth pass**.

**Critical safety rule:**  
Do not go haywire trying to deepen every theme in the system.  
Do not add weak filler ayah links or generic handoffs.  
Prefer fewer themes with strong study value over broad shallow coverage.

> “And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

---

## TASK TYPE

Curated theme-depth expansion, stronger ayah/surah clustering, improved owner-surface handoffs, and study-quality enhancement for the thematic layer.

---

## PRODUCT GOAL

Take the strongest themes in the app and make them feel more complete by improving:
- representative ayah clusters
- relevant surah anchors
- study framing
- related owner-surface handoffs
- practical learning usefulness
- journey/path relevance

The goal is that when a user opens one of these major themes, it should feel:
- meaningful
- coherent
- educational
- calm
- trustworthy
- worth revisiting

---

## EXECUTION RULES

1. **Audit first before editing.**
2. **Do not deepen too many themes in one pass.**
3. **Prefer quality over quantity.**
4. **Do not use weak keyword-only ayah clustering.**
5. **Reuse current theme models, ayah/surah insight systems, and owner-surface links wherever possible.**
6. **Keep the UI calm and premium.**
7. **Preserve localization readiness.**
8. **Run analyzer and relevant tests at the end.**
9. **Provide one full audit summary at the end.**

---

# IMPLEMENTATION SCOPE

## A. Audit the current theme layer first

Inspect at minimum:
- the thematic map layer
- current theme models and mappings
- representative ayah/surah clusters
- related owner-surface handoffs
- theme entry points in the Qur’an hub, reader, and study flows
- any tests already covering theme behavior

Determine:
1. which themes already feel strongest
2. which high-value themes are currently shallow
3. where ayah clusters are too small, too broad, or too generic
4. where owner-surface handoffs are weak or repetitive
5. where theme study value can be meaningfully strengthened

---

## B. Choose a realistic theme set for this phase

Select the strongest 5–8 themes for a meaningful depth pass.

Likely candidates:
- patience
- gratitude
- mercy
- repentance
- sincerity
- trust in Allah
- family
- remembrance

You may refine the set based on current data quality and coverage.

Explain why the selected set makes sense.

---

## C. Deepen theme structure for the chosen set

For each selected theme, strengthen:

### 1. Theme framing
- clearer title/subtitle/description
- why this theme matters
- what the user is studying

### 2. Representative ayah clusters
- a stronger, curated set of ayahs
- not too many
- enough to show breadth and meaning

### 3. Surah anchors
- identify key surahs strongly connected to the theme
- help users move from theme → surah study

### 4. Reflection/study value
- what the user should notice
- what the theme teaches
- where to go deeper next

Do not make the theme pages dense or academic.

---

## D. Improve owner-surface handoffs for the chosen themes

Strengthen theme → owner-surface relevance using real owned destinations such as:
- Character companion
- Seerah companion
- Hadith
- History
- Divine Life / Life lessons
- World / Creation / Signs
- Journeys
- learning paths
- daily flow where relevant

Examples:
- patience → Character, Journey, relevant surah study
- mercy → Daily Wisdom, Character, Hadith, signs of mercy
- gratitude → Daily flow, signs/world themes, Character
- family → Character, Journey, selected surahs
- remembrance → Daily flow, memorization/review, reflection path

Important:
- keep links semantically correct
- avoid generic overlinking
- prefer fewer, stronger handoffs

---

## E. Strengthen theme-to-study-mode usefulness

Where useful, connect the chosen themes more clearly to:
- reflection mode
- study mode
- theme mode
- memorization support where appropriate
- guided paths

The aim is that a strong theme can become a better starting point for the rest of the Qur’an system.

---

## F. Improve UX for deeper themes without clutter

If the theme surface or theme cards need refinement:
- improve grouping
- improve ordering
- improve study cues
- improve clarity of what the user can do next

Do not redesign the whole theme layer.
Do not add huge walls of text.

---

## G. Keep theme quality trustworthy

This is important.

For each selected theme:
- use semantically strong ayahs
- use carefully chosen surah anchors
- use honest owner-surface links
- avoid stretching a theme too far just to make it look deep

Trust matters more than volume.

---

## H. Add focused tests and validation

Add/update focused tests for:
- chosen theme integrity
- ayah/surah cluster stability
- owner-surface route integrity
- no regressions to existing thematic map behavior

Run:
- `flutter analyze`
- relevant focused tests

---

# VALIDATION

After implementation, validate:

1. the chosen themes now feel meaningfully deeper
2. ayah clusters are stronger and more coherent
3. surah anchors are useful and semantically correct
4. owner-surface handoffs are more helpful
5. the thematic layer remains calm and readable
6. no routing regressions were introduced
7. `flutter analyze` passes
8. relevant tests pass
9. localization remains valid

---

# DELIVERABLES

Provide:

1. **Audit findings before changes**
   - which themes were strongest/weakest
   - what was prioritized

2. **Theme depth expansion completed**
   - which themes were deepened
   - how framing, ayah clusters, and surah anchors improved

3. **Owner-surface improvements**
   - what destinations were better connected
   - why

4. **Study-mode / path usefulness improvements**
   - how the chosen themes became more useful across the broader system

5. **Files changed**
   - updated files
   - new model/provider/test files if any

6. **Validation**
   - analyzer
   - tests
   - study flow stability confirmation

7. **Final audit**
   - whether the chosen themes now feel substantially stronger
   - what the next highest-value follow-up phase should be

# END OF PROMPT
