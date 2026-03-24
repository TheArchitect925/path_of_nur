# ===== PHASE QURAN ENRICHMENT PROMPT — JOURNEY ↔ THEME MAPPING SYSTEM =====

## PRIMARY OBJECTIVE === BUILDING JOURNEY ↔ THEME MAPPING SYSTEM

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows:
- ayah + surah enrichment
- thematic map layer
- reference explanation layer
- surah study hub expansion
- high-value surah coverage
- Journey ↔ Qur’an integration
- memorization + review system
- adaptive study modes
- learning path system
- credibility / knowledge-type layer
- daily Qur’an companion flow

Current state:
- the Qur’an system is now rich and usable
- the daily flow exists
- learning paths exist
- journeys exist
- themes exist
- BUT the app still lacks a strong **systematic bridge** between:
  - Journey topics
  - Qur’anic themes
  - ayahs/surahs
  - study modes
  - owned learning surfaces

This phase introduces:
👉 a **Journey ↔ Theme Mapping System**

So the app becomes a more unified learning ecosystem, where journeys can naturally guide the user into the Qur’an through meaningful themes.

This is **not** a broad IA rewrite.
It is a **mapping and integration phase**.

**Critical safety rule:**  
Do not go haywire deleting routes, journeys, themes, lessons, or Qur’an systems for no reason.  
Do not force weak connections.  
Only create mappings that are semantically strong and clearly useful.

---

## TASK TYPE

Cross-system mapping, semantic integration, and guided-learning connective layer between Journey and Qur’an.

---

## PRODUCT GOAL

Allow the app to connect:

### Journey topics
Examples:
- patience
- gratitude
- sincerity
- mercy
- trust
- repentance
- family
- character
- Seerah moments
- consistency

### To Qur’anic themes
Examples:
- sabr
- shukr
- tawakkul
- rahmah
- tazkiyah
- akhirah
- signs
- justice
- remembrance
- guidance

### Then to:
- representative ayahs
- relevant surahs
- appropriate reader study modes
- owned companion surfaces
- learning paths

This should improve:
- cohesion across the app
- Journey relevance
- Qur’an discoverability
- study depth
- product intelligence

---

## EXECUTION RULES

1. **Audit first before editing.**
2. **Do not create weak or vague mappings.**
3. **Prefer fewer, stronger mappings over broad shallow coverage.**
4. **Reuse current journey registries, theme models, and Qur’an study systems where possible.**
5. **Do not redesign Journey IA or Qur’an IA.**
6. **Keep routing stable.**
7. **Preserve localization readiness.**
8. **Run analyzer and relevant tests at the end.**
9. **Provide one full audit summary at the end.**

---

# IMPLEMENTATION SCOPE

## A. Audit existing systems first

Inspect at minimum:
- `learning_journey_registry.dart`
- `learning_journey_lesson_content.dart`
- any journey metadata / category models
- current Qur’an thematic map layer
- `quran_ayah_enrichment_provider.dart`
- `quran_surah_insights_provider.dart`
- any learning path models/pages
- any adaptive study mode models
- any route helpers for contextual entry

Determine:
1. which journey themes already exist clearly
2. which Qur’an themes already exist clearly
3. where there is already overlap
4. where there are missing mappings
5. what can be linked safely now

---

## B. Define a lightweight mapping model

Create a simple model if needed, for example:
- journey id
- journey theme id(s)
- quran theme id(s)
- representative ayah ids
- representative surah ids
- suggested reader mode
- suggested companion surface / learning path
- mapping strength / confidence if useful

Keep it lightweight.
Do not build a huge ontology engine.

---

## C. Build a curated V1 mapping set

Start with a strong curated subset of high-value journeys and themes.

Good candidates:
- patience
- gratitude
- sincerity
- trust in Allah
- mercy
- repentance
- family conduct
- consistency
- remembrance
- Seerah-linked themes like Hijrah

For each chosen journey area, map to:
- 1–3 strong Qur’anic themes
- a small set of high-value ayahs/surahs
- an appropriate study mode where useful
- the best owned handoff(s)

Do NOT:
- map everything to everything
- use shallow keyword links
- create noisy low-signal connections

---

## D. Improve Journey → Qur’an entry quality

Use the mapping system to improve entry quality from Journey into Qur’an.

Examples:
- patience journey → open Qur’an in theme/study mode with patience-focused ayahs
- gratitude journey → open relevant surah/ayah set with gratitude references
- Hijrah-related journey → open Seerah-aware Qur’an study context
- sincerity journey → open character-linked Qur’anic theme study

These transitions should feel intentional and educational.

---

## E. Improve Qur’an → Journey handoffs

Where strong mappings exist, allow the Qur’an system to hand back into the relevant Journey.

Examples:
- a theme in Qur’an study can suggest:
  - “Continue this through your Journey”
  - or a related learning path/journey lesson

Only do this when:
- the mapping is genuinely strong
- the target journey exists and is meaningful

---

## F. Optionally integrate with learning paths

If the existing Qur’an learning path system supports it safely:
- connect mapped journeys to relevant Qur’an paths
- or allow theme mappings to suggest a path entry

Do not overcomplicate this if it is not yet clean.

---

## G. Keep the UX calm and subtle

Do not:
- add many new chips everywhere
- clutter lesson pages
- clutter the reader

Good places for these mappings:
- Journey lesson related tools
- path entry suggestions
- theme detail areas
- subtle contextual cards/sheets

Keep it elegant and high-signal.

---

## H. Add focused tests and validation

Add/update focused tests for:
- mapping model integrity
- route/context entry behavior
- no regressions to Journey or Qur’an routing
- selected high-value mapping cases

Run:
- `flutter analyze`
- relevant focused tests

---

# VALIDATION

After implementation, validate:

1. selected journeys now map meaningfully to Qur’anic themes
2. Journey → Qur’an transitions feel more intelligent
3. Qur’an → Journey handoffs remain high-signal
4. no weak noisy mappings were introduced
5. routes remain stable
6. `flutter analyze` passes
7. relevant tests pass
8. localization remains valid

---

# DELIVERABLES

Provide:

1. **Audit findings before changes**
   - what journey/theme infrastructure already existed
   - what was missing

2. **Mapping system added**
   - model used
   - journeys/themes chosen for V1
   - why

3. **Journey → Qur’an improvements**
   - what transitions became smarter
   - what study modes/ayahs/surahs were used

4. **Qur’an → Journey improvements**
   - what handoffs were added or strengthened
   - why

5. **Files changed**
   - updated files
   - new model/provider/test files

6. **Validation**
   - analyzer
   - tests
   - flow stability confirmation

7. **Final audit**
   - whether the app now feels more like one connected learning ecosystem
   - what the next highest-value follow-up phase should be

# END OF PROMPT
