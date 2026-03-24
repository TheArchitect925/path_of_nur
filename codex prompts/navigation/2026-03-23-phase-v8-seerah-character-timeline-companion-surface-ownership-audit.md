# ===== PHASE V8 PROMPT — SEERAH / CHARACTER / TIMELINE COMPANION SURFACE OWNERSHIP AUDIT =====

## PRIMARY OBJECTIVE === BUILDING COMPANION SURFACE OWNERSHIP AUDIT

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows:
- V4: Navigation stabilization
- V5: Alias integrity + learnLegacy clarification
- V6: Hidden metadata ownership cleanup
- V7: Visible fallback cleanup (safe replacements only)

Current state:
- Core navigation is stable
- Canonical routing is clean
- Hidden metadata is mostly normalized
- Some visible fallback links were safely replaced
- Remaining fallback links are **not routing problems anymore**
- They are now **product ownership / surface ownership problems**

This phase is about deciding:
👉 **What should actually own these experiences in the product**

**Critical safety rule:**
Do NOT remove routes, tools, or links unless you are replacing them with a clearly better, correct, and owned destination.
Do NOT force a replacement just to eliminate `learnLegacy`.

> “And Allah is Gentle and loves gentleness in all matters.” — Sahih Muslim

---

## TASK TYPE

Product-aware audit of unresolved visible fallback links, and mapping them to:
- a proper canonical owner
- a new dedicated surface (if needed)
- or intentional fallback retention

---

## PRODUCT GOAL

After V7, the remaining fallback links are:

### Seerah-related
- `seerah-journey`
- `seerah-hijrah`
- `seerah-madinah-society`

### Character / Adab
- `beautiful-character`

### Timeline / History expansion
- `timeline-khulafa`
- `timeline-expansion`

### Qur’an contextual
- `short-surahs-meaning`

### Reflection / daily content
- `wisdom-daily-quote`

These are no longer technical issues.

They represent **missing or unclear product surfaces**.

---

## EXECUTION RULES

1. **Audit first — do not change immediately**
2. **Do not replace blindly**
3. **Do not delete fallback behavior unless a better owner exists**
4. **Prefer real product ownership over routing cleanliness**
5. **Preserve current behavior if ownership is unclear**
6. **Do not redesign the entire IA**
7. **Do not move unrelated code**
8. **Keep everything production-safe**
9. **Document decisions clearly**

---

# IMPLEMENTATION SCOPE

## A. Audit each unresolved fallback item

For EACH of the following:

- `seerah-journey`
- `seerah-hijrah`
- `seerah-madinah-society`
- `beautiful-character`
- `timeline-khulafa`
- `timeline-expansion`
- `short-surahs-meaning`
- `wisdom-daily-quote`

Determine:

1. Where it appears (UI surface)
2. What the user expects when tapping it
3. Whether a **true canonical owner already exists**
4. Whether current fallback (`learnLegacy`) is:
   - acceptable
   - misleading
   - too generic
5. Whether replacing it would:
   - improve clarity
   - or break intended exploration behavior

---

## B. Classify each item

Each item MUST be classified into one of:

### 1. SAFE TO MAP TO EXISTING OWNER
Example:
- There is already a correct page that fully represents this concept

### 2. NEEDS NEW DEDICATED SURFACE
Example:
- concept is important but no proper home exists yet

### 3. KEEP AS INTENTIONAL FALLBACK
Example:
- broad exploration is the intended behavior

### 4. DEFER (AMBIGUOUS)
Example:
- unclear product direction
- multiple possible owners

---

## C. Apply only safe improvements

### If classification = SAFE TO MAP:
- replace fallback with canonical route
- ensure:
  - semantic correctness
  - query/path integrity
  - UI consistency

### If classification = KEEP:
- leave as-is
- add concise comment explaining why

### If classification = DEFER:
- leave untouched
- document clearly

### If classification = NEEDS NEW SURFACE:
- DO NOT build full feature
- define:
  - placeholder route (if needed)
  - or backlog item
- do not overbuild

---

## D. Do NOT over-normalize

Avoid:
- sending everything to `/learn/explore`
- forcing Qur’an routes for non-Qur’an content
- collapsing different concepts into one page
- replacing meaningful exploration with rigid routing

---

## E. Improve ownership clarity

Where helpful:
- add small comments near fallback definitions
- clarify:
  - why fallback exists
  - what future owner might be

Keep comments concise.

---

## F. Optional lightweight improvements

If trivial and safe:
- align route naming
- improve label clarity
- slightly refine navigation intent

DO NOT:
- redesign UI
- restructure journeys
- refactor large systems

---

## G. Add targeted tests (only if behavior changes)

If any visible fallback is replaced:

Add test coverage for:
- correct route resolution
- no regression in journey/lesson screens

Do NOT add unnecessary tests.

---

# VALIDATION

After implementation:

## Behavior
1. Journey detail screens still work
2. Lesson pages still work
3. Replaced links navigate correctly
4. Preserved fallbacks still work
5. No regression in exploration behavior

## Routing
6. Canonical routes resolve correctly
7. No broken navigation
8. No redirect loops

## Code
9. `flutter analyze` passes
10. tests pass
11. no localization regressions

---

# DELIVERABLES

Provide a concise summary:

## 1. Audit findings
- each item
- classification (SAFE / NEW / KEEP / DEFER)
- reasoning

## 2. Changes made
- which items were updated
- what routes replaced them
- why safe

## 3. Items preserved
- list of fallbacks kept
- explanation

## 4. Deferred items
- list and reason

## 5. New surface candidates (if any)
- simple description only
- no full implementation

## 6. Validation
- analyzer
- tests
- behavior confirmation

## 7. Final audit
- is ownership clearer now?
- what is the next highest-value phase?

---

# IMPORTANT SAFETY RULE

This is a **product ownership audit**, not a cleanup sprint.

Do not:
- force replacements
- remove fallback behavior aggressively
- over-engineer solutions

Only act when:
👉 the correct owner is obvious  
👉 the replacement improves user experience  
👉 behavior remains safe  

Otherwise:
👉 preserve and document

# END OF PROMPT
