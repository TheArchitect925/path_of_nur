# ===== PHASE V14 PROMPT — COMPANION SURFACES LOCALIZATION + COPY QUALITY HARDENING =====

## PRIMARY OBJECTIVE === BUILDING COMPANION SURFACES LOCALIZATION + COPY QUALITY HARDENING

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows:
- V10: Companion surfaces buildout
- V11: Content depth refinement
- V12: Interaction + personalization
- V13: Content expansion
- Content audit and depth passes for Seerah, Character, and Daily Wisdom

Current state:
- `/learn/seerah`, `/learn/character`, `/learn/daily-wisdom` are live and used
- content depth has improved
- routing and ownership are stable
- **localization quality and copy consistency are now the biggest user-facing gaps**

The audit identified:
- non-English ARBs still contain English fallback text
- some strings are repetitive or too generic
- tone is sometimes inconsistent across surfaces
- copy is functional but not yet polished

This phase is about **polishing what the user reads**.

**Critical safety rule:**  
Do not go haywire deleting keys, breaking gen-l10n, or removing strings for no reason.  
Do not change routing or surface ownership.  
Improve clarity, consistency, and translation readiness safely.

> “And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

---

## TASK TYPE

Localization hardening, copy refinement, and content tone consistency across companion surfaces.

---

## PRODUCT GOAL

Make the companion surfaces:
- clearer
- more consistent
- more readable
- more intentional in tone
- ready for proper translation

Focus on:
- `/learn/seerah`
- `/learn/character`
- `/learn/daily-wisdom`

---

## EXECUTION RULES

1. **Audit localization and copy first before editing.**
2. **Do not remove keys unless they are clearly unused and safe.**
3. **Do not break gen-l10n or localization structure.**
4. **Keep tone calm, premium, and consistent.**
5. **Avoid over-stylized or overly verbose copy.**
6. **Avoid duplicate phrasing across cards and sections.**
7. **Preserve semantic meaning — do not rewrite content incorrectly.**
8. **Keep all new strings localization-ready.**
9. **Run gen-l10n, analyzer, and tests at the end.**
10. **Provide a full audit summary.**

---

# IMPLEMENTATION SCOPE

## A. Audit localization state

Audit:
- `lib/l10n/app_en.arb`
- all other locale ARBs
- generated localization files

Identify:
- keys used by companion surfaces
- English fallback text in non-English locales
- inconsistent naming patterns
- duplicated keys
- unused or legacy keys (only if clearly safe)

---

## B. Audit copy quality across surfaces

Review actual UI copy in:
- Seerah companion page
- Character companion page
- Daily Wisdom page

Evaluate:
- clarity
- repetition
- tone consistency
- usefulness
- whether subtitles actually help users
- whether sections feel too generic

---

## C. Improve copy quality

Refine:
- section titles
- subtitles
- card descriptions
- “why this matters” text
- “next step” text
- “practice today” text

Goals:
- reduce repetition
- improve clarity
- improve usefulness
- maintain calm tone
- keep text concise

---

## D. Improve tone consistency

Ensure:
- Seerah = narrative, guided, reflective
- Character = practical, behavioral, grounded
- Daily Wisdom = calm, concise, reflective

Remove:
- inconsistent tone shifts
- overly similar phrasing across different surfaces

---

## E. Clean localization structure

Where safe:
- group related keys logically
- standardize naming patterns
- remove clearly unused keys (only if verified safe)
- avoid duplication

---

## F. Handle non-English locales safely

For non-English ARBs:
- keep structure intact
- ensure all keys exist
- keep English fallback if translation is not available yet
- clearly document translation gaps

Do NOT:
- attempt full translation in this phase
- remove keys because they are untranslated

---

## G. Improve key naming consistency

Ensure:
- keys are descriptive and grouped
- companion surface keys follow a consistent naming pattern
- no confusing or inconsistent prefixes

---

## H. Run localization generation

Run:
- `flutter gen-l10n`

Fix:
- any errors
- missing keys
- generation issues

---

## I. Tests and validation

Run:
- `flutter analyze`
- existing tests

Add tests only if:
- localization structure changes affect logic

---

# VALIDATION

After implementation:

1. All companion surface text is clearer and less repetitive
2. Tone is consistent across Seerah, Character, and Daily Wisdom
3. No localization keys are broken
4. `flutter gen-l10n` succeeds
5. `flutter analyze` passes
6. tests pass
7. non-English locales still load correctly

---

# DELIVERABLES

Provide a concise summary with:

1. **Localization audit findings**
   - fallback issues
   - structure issues
   - duplication issues

2. **Copy improvements**
   - what was changed
   - where repetition was reduced
   - where clarity improved

3. **Tone consistency improvements**
   - what was aligned
   - how surfaces now differ correctly

4. **Localization structure cleanup**
   - keys reorganized or removed
   - naming improvements

5. **Files changed**
   - ARB files
   - any UI files
   - any helpers

6. **Validation**
   - gen-l10n result
   - analyzer result
   - test results

7. **Final audit**
   - whether content now feels cleaner and more production-ready
   - remaining translation debt

---

# IMPORTANT SAFETY RULE

This is a **polish phase**.

Do not:
- break localization
- remove keys aggressively
- rewrite content meaning
- change routing or structure

Do:
- improve clarity
- improve consistency
- improve tone
- prepare the app for real translation later

# END OF PROMPT
