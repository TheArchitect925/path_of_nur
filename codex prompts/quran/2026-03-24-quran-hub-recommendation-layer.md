# ===== PHASE QURAN ENRICHMENT PROMPT — QUR’AN HUB RECOMMENDATION LAYER =====

## PRIMARY OBJECTIVE === BUILDING QUR’AN HUB RECOMMENDATION LAYER

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows:
- full Qur’an enrichment system
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
- Journey ↔ Theme mapping system
- user intent personalization layer
- daily Qur’an + Journey unified loop

Current state:
- the Qur’an ecosystem is rich and connected
- users can read, study, reflect, memorize, review, and follow paths
- a unified daily loop exists
- BUT the Qur’an hub itself can still feel like a set of tools rather than an intelligently guided front door

This phase introduces:
👉 a **Qur’an Hub Recommendation Layer**

So the Qur’an hub can gently surface:
- what the user should continue
- what best fits their intent
- what connects to their active journey/theme
- what is worth revisiting next

This should feel:
- calm
- useful
- personal
- not noisy
- not algorithmically creepy

This is **not** a heavy recommendation engine.
It is a **lightweight, explainable recommendation layer** built on top of the systems already in place.

**Critical safety rule:**  
Do not go haywire deleting existing Qur’an hub sections, routes, or features for no reason.  
Do not flood the hub with too many recommendations.  
Do not build opaque recommendation logic.  
Keep it lightweight, explainable, and production-safe.

---

## TASK TYPE

Lightweight recommendation design, hub orchestration, guided entry refinement, and personalized-but-calm discoverability.

---

## PRODUCT GOAL

When a user opens the Qur’an hub, it should more clearly suggest what matters most right now, such as:
- continue your current study path
- revisit a memorization/review item
- today’s ayah and reflection
- continue a theme linked to your active journey
- reopen a surah you were studying
- explore a theme relevant to your chosen intent

The result should be:
- less friction
- better continuity
- more intelligent feel
- stronger daily usefulness

---

## EXECUTION RULES

1. **Audit first before editing.**
2. **Do not build a heavy recommendation engine.**
3. **Keep recommendation logic simple, deterministic, and explainable.**
4. **Prefer a few strong recommendations over many weak ones.**
5. **Do not remove access to existing tools.**
6. **Reuse current systems: daily flow, intent, paths, journeys, review, recent activity.**
7. **Keep the UI calm and uncluttered.**
8. **Preserve localization readiness.**
9. **Run analyzer and relevant tests at the end.**
10. **Provide a full audit summary at the end.**

---

# IMPLEMENTATION SCOPE

## A. Audit current Qur’an hub first

Inspect at minimum:
- `quran_app_hub_page.dart`
- `learn_quran_hub_page.dart`
- any supporting hub models/providers
- daily Qur’an flow entry
- memorization/review entry
- learning path entry
- thematic map entry
- recent/continue behavior if already present
- user intent model
- Journey ↔ Theme mapping
- any existing recent activity or last-opened Qur’an state

Determine:
1. what the hub already surfaces strongly
2. what continuity data already exists
3. what currently feels generic
4. what “recommended next” signals already exist implicitly
5. what can be elevated safely without clutter

## B. Define a lightweight recommendation model

Create a simple recommendation model if needed, such as:
- id
- title
- subtitle
- reason/explanation
- route target
- recommendation type
- priority
- source context (intent / journey / review / daily / recent / path)

Possible recommendation types:
- continue_path
- daily_reflection
- review_memorization
- continue_surah
- explore_theme
- journey_linked_study
- revisit_recent

Keep it lightweight and maintainable.

## C. Build a small explainable recommendation set

Generate a limited set of high-value recommendations, for example:
- up to 3 primary recommendations
- optionally a small secondary strip

Good recommendation inputs:
1. active learning path
2. active journey + mapped theme
3. daily Qur’an flow
4. pending memorization review
5. most recent surah/theme study
6. user intent

Each recommendation should have a simple, human-readable reason.

## D. Integrate recommendations into the Qur’an hub

Add a clean, calm recommendation section to the Qur’an hub near the top without overpowering core functions.

## E. Use existing systems intelligently

Drive recommendations from:
- active user intent
- daily unified loop
- memorization/review rhythm
- learning path continuity
- Journey ↔ Theme mapping
- recent Qur’an activity

## F. Preserve calmness and user control

Recommendations should remain optional and non-blocking.

## G. Improve recommendation clarity

Each recommendation should make clear:
- what it is
- why it is recommended
- what happens if tapped

## H. Keep fallback behavior clean

If meaningful signals are absent:
- show a small curated default recommendation set
- keep it high quality and stable

## I. Add focused tests and validation

Add/update focused tests for:
- recommendation model generation
- deterministic recommendation ordering
- route integrity
- graceful fallback behavior
- no regressions to Qur’an hub routing

Run:
- `flutter analyze`
- relevant focused tests

---

# VALIDATION

After implementation, validate:

1. the Qur’an hub still works correctly
2. recommendations are visible but not overwhelming
3. recommendations feel relevant and explainable
4. personalized signals work when present
5. fallback recommendations work when signals are absent
6. no routing regressions were introduced
7. `flutter analyze` passes
8. relevant tests pass
9. localization remains valid

---

# DELIVERABLES

Provide:

1. **Audit findings before changes**
2. **Recommendation layer added**
3. **Recommendation logic**
4. **UI improvements**
5. **Files changed**
6. **Validation**
7. **Final audit**

# END OF PROMPT
