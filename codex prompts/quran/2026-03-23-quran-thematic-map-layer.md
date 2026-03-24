# ===== PHASE QURAN ENRICHMENT PROMPT — THEMATIC MAP LAYER =====

## PRIMARY OBJECTIVE === BUILDING QURAN THEMATIC MAP LAYER

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows the Qur’an enrichment pass and the reference quality audit/relevance hardening pass.

Current state:
- ayah and surah references now connect the reader to internal content
- relevance quality has been tightened
- the next highest-value improvement is **thematic discoverability**

The goal is to help users discover the Qur’an through meaningful themes, not only through surah order or isolated ayah references.

Examples of themes:
- patience
- gratitude
- mercy
- hypocrisy
- sincerity
- family
- akhirah
- signs in creation
- prophets
- trust in Allah
- repentance
- justice
- remembrance
- prayer
- charity

This phase is **not** a giant ontology or encyclopedia project.
It is a **curated thematic layer** that should feel calm, useful, and well integrated into the app.

**Critical safety rule:**  
Do not go haywire deleting current Qur’an reader behavior, existing reference systems, or content links for no reason.  
Do not build a bloated theme engine with weak mappings.  
Prefer a smaller, high-quality thematic system over a huge noisy one.

> “And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

---

## TASK TYPE

Theme discovery architecture, curated thematic mapping, and safe UI integration for Qur’an study.

---

## PRODUCT GOAL

Add a **Thematic Map Layer** so users can:
- browse themes connected to ayahs and surahs
- understand recurring ideas across the Qur’an
- jump from theme → relevant ayahs/surahs
- connect themes to existing owned learning surfaces in the app

This should improve:
- study discoverability
- reflection depth
- cross-surah understanding
- internal learning handoffs

---

## EXECUTION RULES

1. **Audit first before editing.**
2. **Do not build a giant academic classification engine.**
3. **Prefer curated high-signal themes over too many weak ones.**
4. **Do not map ayahs to themes based on shallow keywords only.**
5. **Reuse the existing reference graph/content owners where useful.**
6. **Keep UI calm and premium.**
7. **Preserve localization readiness.**
8. **Run analyzer and relevant tests at the end.**
9. **Provide a full audit summary at the end.**

---

# IMPLEMENTATION SCOPE

## A. Audit current Qur’an study/discovery surfaces first

Inspect at minimum:
- `quran_reader_page.dart`
- `quran_reference_viewer.dart`
- `quran_ayah_enrichment_provider.dart`
- `quran_reference_graph_provider.dart`
- `quran_surah_insights_provider.dart`
- `quran_app_hub_page.dart`
- `learn_quran_hub_page.dart`
- any existing topic/theme exploration surfaces
- any current topic/tag data already in the codebase

Determine:
- what topic/theme concepts already exist
- whether `quranTopicExplorer` or similar routes already provide a partial base
- how current surah/ayah enrichment could feed a thematic layer
- where a thematic experience should live in the product

---

## B. Define a curated V1 theme set

Create a **focused, curated** starter set of themes.

Aim for a manageable set such as 10–18 strong themes, for example:
- patience
- gratitude
- mercy
- hypocrisy
- sincerity
- family
- akhirah
- signs in creation
- prophets
- trust in Allah
- repentance
- remembrance
- prayer
- charity
- justice
- humility

You may adjust the exact list based on what the content library and current Qur’an references support best.

### Rules
- themes must be meaningful and product-useful
- avoid overly overlapping themes
- avoid too many tiny niche themes
- prefer themes that connect well to existing owned surfaces

---

## C. Define the theme model cleanly

Add a lightweight structured model if needed, such as:
- theme id
- title
- subtitle/description
- representative ayahs/surahs
- supporting content categories
- linked owner surfaces
- optional icon/category styling

Keep it lightweight and maintainable.
Do not overengineer a huge graph schema.

---

## D. Build curated theme mappings

Create curated mappings from themes to:
- representative ayahs
- relevant surahs
- relevant internal learning owners where appropriate

Important:
- use meaningful mappings
- do not link dozens of weak ayahs per theme
- prefer “starter study paths” over exhaustive dumps

A good V1 result is:
- each theme has a meaningful small set of starting ayahs/surahs
- each theme has clean handoffs to one or more owned surfaces where appropriate

---

## E. Integrate with existing Qur’an study surfaces

Determine the safest and clearest place to expose the thematic layer.

Possible good owners:
- the main Qur’an hub
- the Qur’an learning hub
- an existing topic explorer route if already present and suitable

If an existing `quranTopicExplorer` or similar surface exists and is product-ready, prefer enhancing it rather than duplicating it.

If needed, create a clean owned thematic entry surface, but only if that is the safest path.

---

## F. Add ayah/surah theme visibility where helpful

Where useful and safe:
- show relevant theme chips in the reader or surah insights
- allow users to jump from ayah/surah → broader theme
- allow theme → representative ayahs/surahs

Do not overload the reader UI.
Keep this subtle.

---

## G. Strengthen handoffs to owned surfaces

For each theme, where semantically correct, connect to existing owner surfaces such as:
- Character companion
- Seerah companion
- Hadith
- History
- Divine Life / Life lessons
- World / Creation / Signs
- Journeys

Important:
- use real owner surfaces
- keep links semantically correct
- avoid generic overlinking

---

## H. Keep the UI calm and understandable

The thematic layer should feel:
- guided
- elegant
- readable
- not like a noisy taxonomy browser

Good direction:
- theme cards
- small description
- representative ayah/surah links
- related learning links

Do not build a dense admin-style browser.

---

## I. Add focused tests and validation

Add/update focused tests for:
- theme model integrity
- route stability
- representative mappings if practical
- theme → route handoff integrity
- no regressions to Qur’an study navigation

Run:
- `flutter analyze`
- relevant focused tests

---

# VALIDATION

After implementation, validate:

1. the thematic layer is clearly exposed
2. themes feel curated and meaningful
3. representative ayah/surah mappings are useful
4. links to owned surfaces are semantically correct
5. the Qur’an reader and hub still work correctly
6. no clutter or routing regressions were introduced
7. `flutter analyze` passes
8. relevant tests pass
9. localization remains valid

---

# DELIVERABLES

Provide a concise summary with:

1. **Audit findings before changes**
   - what theme/topic infrastructure already existed
   - what was missing

2. **Theme layer decisions**
   - theme set chosen
   - where the thematic layer lives
   - why

3. **Mappings added**
   - how themes map to ayahs/surahs
   - how themes map to owner surfaces

4. **UI integration**
   - where users can now discover themes
   - any ayah/surah theme chips or links added

5. **Files changed**
   - updated files
   - new model/provider/page/test files

6. **Validation**
   - analyzer
   - tests
   - study flow stability

7. **Final audit**
   - whether the Qur’an now supports stronger thematic discovery
   - what the next highest-value follow-up phase should be

# END OF PROMPT
