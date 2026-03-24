# ===== PHASE QURAN ENRICHMENT PROMPT — QUR’AN READER UX POLISH + LEARN MORE CLARITY =====

## PRIMARY OBJECTIVE === BUILDING QUR’AN READER UX POLISH + LEARN MORE CLARITY

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows:
- ayah + surah enrichment
- reference quality hardening
- thematic map layer
- ayah reference detail sheet
- surah study hub expansion
- high-value surah coverage expansion
- Journey ↔ Qur’an study integration

Current state:
- the Qur’an reader is now significantly richer
- references, themes, study handoffs, and journey entry points exist
- the next likely gap is no longer ownership or core functionality
- the next likely gap is **UX clarity, density control, and section polish**, especially around:
  - “Learn more”
  - chips
  - section ordering
  - visual hierarchy
  - density of study/enrichment modules
  - contextual cues when entering from Journey

This phase is a **reader UX polish phase**, not a rebuild.

**Critical safety rule:**  
Do not go haywire deleting existing enrichment, routes, playback behavior, notes, bookmarks, or study features for no reason.  
Do not flatten the reader back into a simplistic page.  
Refine the experience so it feels clearer, calmer, and more premium.

> “And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

---

## TASK TYPE

UX refinement, information hierarchy polish, density control, and calm study-flow optimization for the Qur’an reader.

---

## PRODUCT GOAL

Make the Qur’an reader feel:
- easier to scan
- clearer to understand
- richer without feeling crowded
- more intentional in how study references appear
- calmer when entering from different contexts

The main goal is to improve:
- chip grouping
- “Learn more” clarity
- ayah vs surah study distinction
- section ordering
- density and spacing
- contextual awareness

---

## EXECUTION RULES

1. **Audit first before editing.**
2. **Do not rebuild reader architecture.**
3. **Do not remove strong study capabilities just to simplify visually.**
4. **Prefer hierarchy and curation over adding more content.**
5. **Keep reading first, study second.**
6. **Reuse existing page/card/chip design patterns where sensible.**
7. **Preserve localization readiness.**
8. **Run analyzer and relevant tests at the end.**
9. **Provide one full audit summary at the end.**

---

# IMPLEMENTATION SCOPE

## A. Audit the current reader UX first

Inspect at minimum:
- `quran_reader_page.dart`
- `quran_reference_viewer.dart`
- any chip widgets / study card widgets / section headers
- ayah enrichment and surah insight presentation
- contextual Journey entry behavior if present
- reader settings panel if it affects content visibility

Determine:
1. what feels visually strong already
2. where the reader feels too dense
3. where chips are too many, too flat, or poorly grouped
4. where “Learn more” is useful but not clearly prioritized
5. whether ayah-level and surah-level study cues feel distinct enough
6. whether contextual entry cues are visible but not intrusive

---

## B. Improve “Learn more” structure

Refine the ayah-level “Learn more” area so it feels:
- clearer
- calmer
- better grouped
- easier to scan

Possible safe improvements:
- stronger section title/subtitle
- grouping by category:
  - Hadith
  - Signs
  - Character
  - Seerah
  - Journey
  - Theme
- better ordering of strongest references first
- tighter visible cap behavior
- improved spacing between chips/groups

Do not:
- expand content volume
- make the section visually heavy
- introduce long text blocks directly into the reader

---

## C. Improve chip density and category clarity

Audit all visible study/reference chips.

Improve:
- label clarity
- category distinction
- visual grouping
- spacing
- interaction clarity

Where useful:
- make high-value chips more visually obvious
- de-emphasize secondary chips
- reduce generic labels
- ensure tap targets remain comfortable

Do not create a rainbow taxonomy or noisy badge system.

---

## D. Improve ayah vs surah study hierarchy

Make it clearer what belongs to:
- the current ayah
- the current surah
- broader study/theme context

This may include:
- clearer section headings
- better ordering
- separate visual treatment
- less blending of ayah-local and surah-wide references

Goal:
the user should not feel unsure whether a linked idea belongs to:
- this exact verse
- this surah overall
- or the broader Qur’anic theme layer

---

## E. Improve contextual entry cues from Journey

If the reader opens from a Journey or focused entry:
- make the cue visible but subtle
- keep it calm
- show enough context to be useful
- avoid making the reader feel like a different mode entirely

Examples:
- “From your Journey: Patience”
- “Study focus: Hijrah”
- “Theme: Gratitude”

If current contextual cues are weak, strengthen them safely.
If they are already good, refine spacing and placement only if helpful.

---

## F. Improve study section ordering

Refine which study modules appear first.

Possible general priority:
1. current ayah reading content
2. immediate ayah-level related study
3. surah-level insight
4. broader thematic links
5. deeper owner-surface handoffs

Adjust only if the existing order is weaker.
Do not make this rigid if certain contexts should differ.

---

## G. Improve visual hierarchy and spacing

Refine:
- section spacing
- subtitle usefulness
- card padding
- chip wrap behavior
- density around the reader body
- visual distinction between reading content and study content

Ensure the page still feels:
- readable
- premium
- not cluttered
- not overly segmented

---

## H. Optional small settings/control improvement

If current study density would benefit from one lightweight control, you may add a small safe UX option such as:
- compact vs expanded study section
- show fewer related references by default
- or another clearly useful control

Only do this if:
- it fits the current settings model
- it is low-risk
- it improves calmness

Do not add a large settings framework.

---

## I. Add focused tests and validation

Add/update focused tests for:
- section visibility/order if changed
- chip grouping behavior if practical
- route stability
- contextual entry cue behavior
- no regressions to reader features

Run:
- `flutter analyze`
- relevant focused tests

---

# VALIDATION

After implementation, validate:

1. the Qur’an reader still works correctly
2. reading remains the primary experience
3. “Learn more” is clearer and easier to scan
4. chip density feels calmer and better grouped
5. ayah vs surah study distinctions are clearer
6. contextual Journey entry cues are useful and not intrusive
7. no routing or playback regressions were introduced
8. `flutter analyze` passes
9. relevant tests pass
10. localization remains valid

---

# DELIVERABLES

Provide a concise summary with:

1. **Audit findings before changes**
   - what felt dense or unclear
   - what was already strong

2. **Learn more improvements**
   - how grouping/order/clarity improved

3. **Chip and hierarchy improvements**
   - what changed
   - how clutter was controlled

4. **Contextual entry improvements**
   - what changed for Journey/theme entry cues

5. **Files changed**
   - updated files
   - new helper/widget/test files if any

6. **Validation**
   - analyzer
   - tests
   - reader stability confirmation

7. **Final audit**
   - whether the reader now feels clearer and more premium
   - what the next highest-value follow-up phase should be

# END OF PROMPT
