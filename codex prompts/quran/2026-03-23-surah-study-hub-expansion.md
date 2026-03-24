# ===== PHASE QURAN ENRICHMENT PROMPT — SURAH STUDY HUB EXPANSION =====

## PRIMARY OBJECTIVE === BUILDING SURAH STUDY HUB EXPANSION

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows:
- ayah + surah enrichment
- reference quality hardening
- thematic map layer
- ayah reference detail sheet + explanation layer

Current state:
- the Qur’an reader now supports richer ayah and surah reference linking
- users can better understand why references are related
- the next highest-value step is to make **surah-level study** feel more complete and intentional

The goal is to expand surah study so a user can move from simply reading a surah to understanding:
- its major themes
- its related Hadith themes
- its character / life lessons
- its signs / worldly lessons
- its Seerah / prophetic / historical context where appropriate
- its journey/path relevance in the app

This phase is **not** a rebuild of the Qur’an reader.
It is a **surah-level study expansion phase**.

**Critical safety rule:**  
Do not go haywire deleting current reader behavior, route structure, or existing Qur’an enrichment.  
Do not overload every surah with giant walls of content.  
Build a calm, structured, premium surah study layer on top of the existing system.

> “And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

---

## TASK TYPE

Surah study UX expansion, thematic structuring, owned-content handoff refinement, and safe study-mode enhancement.

---

## PRODUCT GOAL

Give users a stronger **Surah Study Hub** experience so each surah can feel like:
- a reading destination
- a reflection destination
- a connected learning destination

This should help users answer:
- what is this surah broadly about?
- what can I learn from it?
- what other knowledge in the app connects to it?
- where should I go next if I want deeper study?

---

## EXECUTION RULES

1. **Audit first before editing.**
2. **Do not rebuild the reader or playback systems.**
3. **Do not add huge encyclopedic content dumps.**
4. **Prefer curated structure over lots of generic cards.**
5. **Reuse existing surah insight and enrichment providers where practical.**
6. **Keep the UI calm, premium, and readable.**
7. **Preserve localization readiness.**
8. **Run analyzer and relevant tests at the end.**
9. **Provide one full audit summary at the end.**

---

# IMPLEMENTATION SCOPE

## A. Audit current surah-level study support first

Inspect at minimum:
- `quran_reader_page.dart`
- `quran_surah_insights_provider.dart`
- any surah insight models
- `quran_reference_viewer.dart`
- `quran_ayah_enrichment_provider.dart`
- `quran_reference_graph_provider.dart`
- any existing surah insight browse screens/routes
- current Qur’an hub exposure of surah insights

Determine:
1. what surah-level study support already exists
2. what is currently weak or too shallow
3. where surah-level structure feels too generic
4. which surah study sections already exist and which are missing
5. whether a dedicated study-mode section/page is already partly present and should be enhanced instead of duplicated

---

## B. Strengthen surah-level study structure

Build or enhance a clear surah study structure that can include sections like:

### 1. Main themes
- broad themes of the surah
- concise, meaningful framing
- avoid vague generic wording

### 2. Why this surah matters
- spiritual, practical, or reflective significance
- short and useful, not overly long

### 3. Related learning connections
Curated links into:
- Hadith
- Character / Life / Divine Life
- Signs / World / Creation
- Seerah / Prophets / History
- Journey / Path / Lesson surfaces where semantically correct

### 4. Reflection / study prompts
- lightweight study cues
- not a huge journaling system
- just enough to deepen engagement

### 5. Next study directions
- where to go next within the app for deeper learning

Keep this structured and scannable.

---

## C. Improve surah theme quality

Refine how surah themes are represented:
- make themes more distinct
- reduce vague or repetitive labels
- improve semantic correctness
- connect themes to the owned surfaces that best represent them

Do not surface weak theme links just to fill the page.

---

## D. Strengthen surah-to-owner handoffs

For each surah study hub or study section, improve the quality of linked destinations such as:
- Hadith-related themes
- Character / Adab companion
- Seerah companion
- History archive
- World / Creation / Signs learning
- Journeys / lesson paths
- Qur’an thematic maps if already present

Important:
- use canonical route-backed destinations
- keep links semantically correct
- prefer fewer, stronger handoffs

---

## E. Improve surah study UI without clutter

If the current Surah Insights block is too compact or flat, refine it safely.

Possible directions:
- better grouping of study sections
- clearer subheadings
- premium cards for major study blocks
- stronger ordering of the most useful content first

Do not:
- push too much content above the fold
- overload the reader page
- create a noisy dashboard

---

## F. Support high-value surahs especially well

If the system supports differentiated enrichment, give special attention to high-value surahs that benefit most from structured study, such as:
- Al-Fatihah
- Al-Baqarah
- Ali ‘Imran
- Yusuf
- Al-Kahf
- Maryam
- Yasin
- Ar-Rahman
- Al-Mulk
- Juz ‘Amma surahs

You do not need to fully solve all of them in this phase, but prioritize where current support is strongest and most useful.

---

## G. Reuse current reader + insight flow safely

Keep the current reading flow intact.

If a separate or deeper study surface already exists, enhance it instead of forcing everything into the main reader page.

If the main reader page is the right place for some study sections:
- keep them concise
- keep them elegant
- avoid overwhelming the reading experience

---

## H. Add focused tests and validation

Add/update focused tests for:
- surah insight structure
- route integrity of study handoffs
- theme grouping if changed
- no regressions to reader and Qur’an hub behavior

Run:
- `flutter analyze`
- relevant focused tests

---

# VALIDATION

After implementation, validate:

1. the Qur’an reader still works correctly
2. surah study support is richer and better structured
3. themes are clearer and more meaningful
4. related owner-surface handoffs are semantically correct
5. the UI remains calm and not overloaded
6. no routing regressions were introduced
7. `flutter analyze` passes
8. relevant tests pass
9. localization remains valid

---

# DELIVERABLES

Provide a concise summary with:

1. **Audit findings before changes**
   - what surah-level support already existed
   - what was weak or missing

2. **Surah study improvements**
   - what sections were added or improved
   - how theme quality improved
   - how study structure improved

3. **Owner-surface handoff improvements**
   - what destinations were linked more clearly
   - why

4. **UI improvements**
   - how surah study became more structured without clutter

5. **Files changed**
   - updated files
   - new model/provider/page/test files

6. **Validation**
   - analyzer
   - tests
   - reader stability confirmation

7. **Final audit**
   - whether surah study now feels more complete and intentional
   - what the next highest-value follow-up phase should be

# END OF PROMPT
