# ===== PHASE QURAN ENRICHMENT PROMPT — MEMORIZATION (HIFZ) + STUDY BRIDGE =====

## PRIMARY OBJECTIVE === BUILDING MEMORIZATION (HIFZ) + STUDY BRIDGE

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows:
- ayah + surah enrichment
- thematic map layer
- reference explanation layer
- surah study hub expansion
- high-value surah coverage
- Journey ↔ Qur’an integration
- reader UX polish

Current state:
- the Qur’an reader is now rich in understanding and connections
- users can read, reflect, and explore deeply
- BUT memorization (hifz) and repetition are still not tightly integrated with understanding

This phase is about bridging:
👉 memorization (repetition, recall, retention)  
👉 with understanding (themes, references, context)

So the Qur’an becomes:
- something users read
- something they understand
- something they **retain**

This is one of the highest-value long-term features.

---

## TASK TYPE

Learning system integration, memorization UX, lightweight retention model, and safe reader extension.

---

## PRODUCT GOAL

Enable users to:
- mark ayahs/surahs for memorization
- review them easily
- connect memorization with:
  - meaning
  - themes
  - references
- build consistency without overwhelming them

This should remain:
- calm
- simple
- non-gamified (at least in V1)
- deeply useful

---

## EXECUTION RULES

1. **Audit existing memorization-related code first.**
2. **Do not build a full advanced hifz system in this phase.**
3. **Do not disrupt current reading or study flow.**
4. **Prefer simple, high-value interactions.**
5. **Reuse existing persistence where possible.**
6. **Keep UX calm and intentional.**
7. **Do not over-gamify or add noise.**
8. **Run analyzer and relevant tests at the end.**
9. **Provide a full summary at the end.**

---

# IMPLEMENTATION SCOPE

## A. Audit existing memorization support

Inspect:
- any memorization helpers already present
- `quran_reader_page.dart`
- bookmarks, notes, highlights
- any review/repetition-related code
- persistence models that can be reused

Determine:
- what already exists
- what is missing
- what can be reused safely

---

## B. Add “Mark for Memorization” (core entry)

Allow users to:
- mark an ayah or surah as “memorize”

From:
- ayah menu / action
- surah header (optional)

This should:
- store a simple reference
- not require heavy configuration

---

## C. Build a lightweight “Review / Memorization list”

Create a simple owned surface (or reuse an existing one if appropriate):

Examples:
- `/quran/review`
- or integrate into existing bookmarks/notes if cleaner

The list should:
- show saved ayahs/surahs
- allow quick jump back into reader
- support simple review flow

---

## D. Add repetition-friendly reader behavior

When entering from memorization:
- optionally:
  - focus on selected ayah(s)
  - allow quick replay (audio)
  - reduce visual clutter if possible
- allow:
  - easy repeat
  - quick navigation

Do not create a full memorization trainer yet.

---

## E. Connect memorization with understanding

This is the key part.

When reviewing a memorized ayah:
- show:
  - meaning (translation)
  - key theme (if available)
  - 1–2 high-value references (not all)

Goal:
- reinforce memory through understanding
- not just repetition

---

## F. Add lightweight progress signals (optional)

If safe and simple:
- show:
  - number of memorized ayahs
  - recently reviewed
- do not add:
  - streak pressure
  - heavy gamification
  - complex scoring

---

## G. Keep UX calm and non-overwhelming

Avoid:
- too many buttons
- too many modes
- complicated flows

Focus:
- mark
- review
- repeat
- understand

---

## H. Add focused tests

Test:
- marking/unmarking memorization
- persistence
- navigation from review list
- reader entry behavior

Run:
- `flutter analyze`
- relevant tests

---

# VALIDATION

After implementation:

1. users can mark ayahs/surahs for memorization
2. users can review them easily
3. memorization integrates with understanding
4. no reader regressions
5. no routing issues
6. UX remains calm and simple
7. `flutter analyze` passes
8. tests pass

---

# DELIVERABLES

Provide:

1. audit findings
2. memorization feature added
3. review list behavior
4. reader integration changes
5. files changed
6. validation results
7. final audit

---

# END OF PROMPT
