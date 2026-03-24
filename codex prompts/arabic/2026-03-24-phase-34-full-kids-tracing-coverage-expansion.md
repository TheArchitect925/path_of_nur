===== PHASE 34 PROMPT — FULL KIDS TRACING COVERAGE EXPANSION (COMPLETE ALPHABET) =====

PRIMARY OBJECTIVE === EXPANDING THE KIDS ARABIC VECTOR TRACING SYSTEM TO COVER THE FULL 28-LETTER ALPHABET WHILE PRESERVING ENGINE STABILITY, UX QUALITY, AND FALLBACK SAFETY

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready expansion phase built on top of the existing Kids Arabic tracing engine and the unified Arabic alphabet foundation. DO NOT rebuild the tracing engine. DO NOT break existing tracing behavior, progress, routing, or reward systems. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve the existing vector tracing engine and behavior
- Preserve all currently supported vector letters
- Preserve fallback tracing system
- Maintain the shared alphabet and positional-form foundations
- Keep UX child-friendly and forgiving
- Do not introduce strict scoring or stroke-order enforcement
- No destructive migrations
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Expand vector tracing coverage from partial (currently ~8 letters) toward full 28-letter coverage

2. Replace fallback tracing with vector tracing for as many remaining letters as safely possible

3. Maintain clean vector path definitions and consistent evaluation behavior

4. Keep tracing smooth, forgiving, and consistent across all letters

5. Preserve fallback system for any letters not yet upgraded

--------------------------------------------------
A. AUDIT CURRENT TRACING COVERAGE
--------------------------------------------------

Audit:
- kids_arabic_vector_tracing.dart
- current vector-supported letters
- fallback-supported letters
- shared alphabet catalog
- lesson flow and ordering

Identify:
- which letters already have vector support
- which letters are still fallback-only
- which letters can be upgraded safely in this phase
- any shape categories that need special handling (loops, multiple strokes, disjoint dots)

--------------------------------------------------
B. DEFINE LETTER EXPANSION STRATEGY
--------------------------------------------------

Group remaining letters by shape type:

Examples:
- dot variants (ta, tha, nun variants)
- curve-heavy letters (sad, dad)
- loop letters (ain, ghain)
- multi-segment letters
- non-connecting forms

Requirements:
- reuse existing patterns where possible
- avoid duplicating path logic unnecessarily
- maintain consistent drawing style and proportions

--------------------------------------------------
C. ADD VECTOR TEMPLATES FOR REMAINING LETTERS
--------------------------------------------------

For each remaining letter:

Add:
- outline path
- ordered stroke paths
- thresholds for completion

Requirements:
- visible guide = evaluation path (same source of truth)
- smooth tracing
- child-friendly shape clarity
- consistent scale and padding
- avoid overly complex or fragile paths

--------------------------------------------------
D. PER-LETTER COMPLETION TUNING
--------------------------------------------------

Tune thresholds per letter:

Requirements:
- forgiving completion logic
- no strict scoring
- allow imperfect tracing
- prevent accidental completion from minimal scribbles

Adjust:
- effort threshold
- path coverage threshold
- alignment tolerance

--------------------------------------------------
E. PRESERVE FALLBACK SYSTEM
--------------------------------------------------

For any letters not safely upgraded:

- keep fallback tracing active

Requirements:
- no broken letters
- no empty screens
- consistent UX between vector and fallback

Do NOT remove fallback in this phase.

--------------------------------------------------
F. CENTRALIZE VECTOR SUPPORT CHECK
--------------------------------------------------

Ensure:

supportsVectorTracing(letterId)

is the single source of truth.

Requirements:
- no scattered conditional logic
- used across:
  - tracing pad
  - lesson page
  - progress provider

--------------------------------------------------
G. ENSURE FULL LESSON FLOW COVERAGE
--------------------------------------------------

Verify:
- all 28 letters are reachable
- no dead ends
- next-letter navigation works
- lesson sequence is consistent

Requirements:
- no missing entries
- no duplicate entries
- no broken routing

--------------------------------------------------
H. MAINTAIN UX CONSISTENCY
--------------------------------------------------

Ensure:
- same interaction model across all letters
- same color picker behavior
- same reset behavior
- same completion feedback

No visible “quality drop” between letters.

--------------------------------------------------
I. LIGHTWEIGHT PERFORMANCE CHECK
--------------------------------------------------

As letter count increases:

Check:
- rendering performance
- gesture responsiveness
- memory usage
- repaint efficiency

Optimize only where needed.

--------------------------------------------------
J. DATA SAFETY
--------------------------------------------------

Preserve:
- tracing progress
- XP/reward system
- lesson progression
- shared alphabet foundation
- routing and navigation

Requirements:
- no reset of progress
- no breaking changes
- no duplicate rewards

--------------------------------------------------
K. TESTING
--------------------------------------------------

Add/update tests:

- all 28 letters exist
- vector-supported letters render correctly
- fallback letters still work
- tracing works across all new letters
- next-letter navigation works
- no regressions in tracing engine

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed
2. Coverage summary (vector vs fallback)
3. Vector template summary
4. Threshold tuning summary
5. Lesson flow summary
6. Data safety summary
7. Validation results
8. FINAL AUDIT

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- full alphabet is supported in Kids Arabic
- majority of letters use vector tracing
- fallback covers any remaining safely
- tracing remains smooth and forgiving
- lesson flow works end-to-end
- no regressions introduced

--------------------------------------------------

“And We have certainly made the Qur’an easy for remembrance.” — Qur’an 54:17

===== END PHASE 34 PROMPT =====
