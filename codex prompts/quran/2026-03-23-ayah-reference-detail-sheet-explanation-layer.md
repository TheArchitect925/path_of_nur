# ===== PHASE QURAN ENRICHMENT PROMPT — AYAH REFERENCE DETAIL SHEET + EXPLANATION LAYER =====

## PRIMARY OBJECTIVE === BUILDING AYAH REFERENCE DETAIL SHEET + EXPLANATION LAYER

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows:
- ayah + surah enrichment
- reference quality hardening
- thematic map layer

Current state:
- ayah and surah references now exist
- thematic discovery is improving
- users can see related chips/links
- but the next usability gap is:
  - **users can tap a related reference, but the system still needs a better “why is this related?” explanation layer**

The goal of this phase is to build a **reference detail sheet / explanation layer** so related references feel:
- trustworthy
- understandable
- educational
- calm
- better connected to the user’s current ayah/surah

This phase is **not** a rebuild of the reader.
It is a **meaning/explanation UX phase**.

**Critical safety rule:**  
Do not go haywire deleting current Qur’an reader behavior, enrichment chips, routes, or learning links for no reason.  
Do not overload the user with long essays or cluttered modals.  
Build a lightweight, elegant explanation layer on top of the current reference system.

> “And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

---

## TASK TYPE

UX enrichment, reference explanation layer, and safe route-backed detail handoff refinement.

---

## PRODUCT GOAL

When the user taps a related reference chip from an ayah or surah insight, they should get a clearer understanding of:
- what this related item is
- why it connects to the current ayah/surah
- what kind of source it belongs to
- where they can go next if they want to study further

This should improve:
- trust
- learning value
- semantic clarity
- internal content handoff quality

---

## EXECUTION RULES

1. **Audit first before editing.**
2. **Do not rebuild the existing enrichment graph unless clearly necessary.**
3. **Do not turn the detail layer into a giant content dump.**
4. **Prefer concise, high-signal explanation over long text.**
5. **Keep UI calm, premium, and readable.**
6. **Preserve playback, notes, bookmarks, and existing reader flow.**
7. **Preserve localization readiness.**
8. **Run analyzer and relevant tests at the end.**
9. **Provide a full audit summary at the end.**

---

# IMPLEMENTATION SCOPE

## A. Audit current reference interaction first

Inspect at minimum:
- `quran_reader_page.dart`
- `quran_reference_viewer.dart`
- `quran_ayah_enrichment_provider.dart`
- `quran_reference_graph_provider.dart`
- any related models for:
  - ayah references
  - surah insights
  - reference chips/cards
  - owner-surface links
- current tap behavior on related chips

Determine:
- what happens today when a user taps a reference
- where the experience feels too abrupt or too opaque
- whether the user currently understands:
  - why a link is related
  - what category it belongs to
  - what they will see next

---

## B. Design a lightweight reference detail sheet

Build a clean detail surface, likely as a bottom sheet or lightweight modal, that appears when the user taps a related reference.

It should include, where available:
1. **Reference title**
2. **Reference category**
   - Hadith
   - Signs / World
   - Character
   - Seerah
   - Journey
   - Theme
   - etc.
3. **Short explanation**
   - why this item is connected to the current ayah/surah
4. **Owner/source indication**
   - where this content lives in the app
5. **Clear next action**
   - open full destination
6. Optional:
   - current ayah/surah anchor label
   - representative tag/theme chip

Keep this compact and useful.

---

## C. Add “why this is related” support

If the current data model does not support explanation text cleanly, add a lightweight explanation layer.

Possible safe approaches:
- concise explanation field in the enrichment descriptor
- category-aware explanation templates
- curated explanation text for stronger references
- small helper utilities to generate short reason text

Important:
- do not fabricate weak explanations
- if the reason is too vague, keep it short and generic rather than misleading
- prefer semantic correctness over verbosity

---

## D. Improve category clarity

Make it more obvious what kind of reference the user is seeing.

Examples:
- Hadith reference
- World / Signs lesson
- Character lesson
- Seerah companion
- Journey lesson
- Surah theme

This should appear in the detail sheet and optionally improve chip semantics if useful.

---

## E. Improve route handoff confidence

From the detail sheet, the user should be able to open the owned surface confidently.

The destination action should feel like:
- “Open Hadith lesson”
- “Open Seerah companion”
- “Open Character lesson”
- “Explore this theme”
- etc.

Do not use vague CTA wording if more specific phrasing is available.

---

## F. Optionally improve chip tap behavior in the reader

If today chips jump immediately to the destination and that feels too abrupt:
- route chip taps into the new detail sheet first
- then allow users to continue into the full owner surface

If some references still benefit from direct navigation, keep that only if clearly justified.
Default should favor understanding first.

---

## G. Keep ayah and surah contexts coherent

Ensure the detail layer works for:
- ayah-level related references
- surah-level insight references
- theme-related references if already surfaced

Do not create inconsistent UX between ayah and surah flows unless clearly necessary.

---

## H. Keep the UI elegant and calm

The detail layer should feel:
- lightweight
- premium
- educational
- not cluttered
- not like a debug inspector

Avoid:
- huge paragraphs
- too many chips
- too many actions
- overly technical labels

---

## I. Add focused tests and validation

Add/update focused tests for:
- reference detail sheet opening behavior
- category labeling
- explanation text presence where expected
- route integrity of detail-sheet CTA
- no regressions to reader behavior

Run:
- `flutter analyze`
- relevant focused tests

---

# VALIDATION

After implementation, validate:

1. the Qur’an reader still works correctly
2. tapping related references feels more understandable
3. users can see why a reference is related
4. category/source ownership is clearer
5. destination handoff remains correct
6. the UI remains calm and not overloaded
7. `flutter analyze` passes
8. relevant tests pass
9. localization remains valid

---

# DELIVERABLES

Provide a concise summary with:

1. **Audit findings before changes**
   - what current tap behavior was
   - what felt weak or unclear

2. **Reference detail layer added**
   - what UI was built
   - what information it shows
   - how clutter was controlled

3. **Explanation improvements**
   - how “why this is related” was handled
   - whether data model or templates were added/refined

4. **Route handoff improvements**
   - how users now move from chip → detail → owner surface

5. **Files changed**
   - updated files
   - new model/helper/provider/test files

6. **Validation**
   - analyzer
   - tests
   - reader stability confirmation

7. **Final audit**
   - whether the Qur’an enrichment now feels more trustworthy and explainable
   - what the next highest-value follow-up phase should be

# END OF PROMPT
