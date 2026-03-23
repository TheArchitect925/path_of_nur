===== PHASE 21 PROMPT — FULL ARABIC ALPHABET TRACING ROLLOUT (VECTOR + FALLBACK SYSTEM) =====

PRIMARY OBJECTIVE === BUILDING FULL ARABIC ALPHABET SUPPORT FOR KIDS TRACING WITH SAFE VECTOR EXPANSION AND STABLE FALLBACK COVERAGE

You are working in the existing Flutter codebase for Path of Nūr.

This phase expands the Kids Arabic tracing system to support the full alphabet. DO NOT rebuild the tracing engine. DO NOT remove existing vector letters. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve existing tracing engine and behavior
- Preserve all implemented vector letters
- Maintain fallback system for unsupported letters
- Do not introduce strict scoring or stroke-order enforcement
- Keep UX child-friendly and consistent
- Avoid duplicating logic across files
- No destructive changes

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Ensure ALL Arabic letters are supported in the Kids Arabic system
2. Expand vector tracing coverage where safe and efficient
3. Keep fallback tracing for remaining letters
4. Centralize vector vs fallback decision
5. Maintain clean lesson flow across the full alphabet

--------------------------------------------------
A. AUDIT CURRENT LETTER COVERAGE
--------------------------------------------------

Audit:
- kids_arabic_vector_tracing.dart
- current supported vector letters
- fallback letters
- lesson sequencing

Identify:
- which letters are vector-supported
- which letters are fallback
- which letters can be safely upgraded now

--------------------------------------------------
B. COMPLETE ALPHABET COVERAGE
--------------------------------------------------

Ensure every Arabic letter:
- exists in the system
- has a valid lesson
- is reachable in sequence

Requirements:
- no missing letters
- no dead routes
- no broken UI

--------------------------------------------------
C. EXPAND VECTOR TRACING (TIER 2 LETTERS)
--------------------------------------------------

Add vector tracing for next batch of letters:

Examples:
- ta
- tha
- jeem
- hha
- kha
- dal
- dhal
- ra
- zay

Requirements:
- reuse existing path patterns where possible
- maintain consistent style
- ensure visible path = evaluation path
- avoid overly complex shapes in this phase

--------------------------------------------------
D. MAINTAIN FALLBACK SYSTEM
--------------------------------------------------

For remaining letters:
- keep fallback tracing active

Requirements:
- fallback must not feel broken
- UI must remain consistent
- user should not feel a “quality drop”

--------------------------------------------------
E. CENTRALIZE SUPPORT LOGIC
--------------------------------------------------

Implement:

supportsVectorTracing(letterId)

Requirements:
- single source of truth
- used across:
  - tracing pad
  - lesson page
  - progress provider

No scattered conditionals.

--------------------------------------------------
F. LESSON FLOW ACROSS FULL ALPHABET
--------------------------------------------------

Ensure:
- next letter navigation works across full alphabet
- no dead ends
- smooth transitions

Requirements:
- consistent ordering
- progression intact
- no duplicate entries

--------------------------------------------------
G. VISUAL CONSISTENCY
--------------------------------------------------

Ensure:
- all letters (vector + fallback) feel consistent
- same layout
- same interaction pattern

--------------------------------------------------
H. DATA SAFETY
--------------------------------------------------

Preserve:
- all progress
- XP system
- lesson state
- vector letters already implemented

--------------------------------------------------
I. TESTING
--------------------------------------------------

Test:

- full alphabet is reachable
- vector letters render correctly
- fallback letters still work
- next letter flow works
- no broken routes
- no regressions in tracing

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed
2. Coverage summary (vector vs fallback)
3. Vector expansion summary
4. Lesson flow summary
5. Data safety summary
6. Validation results
7. FINAL AUDIT

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- full Arabic alphabet is supported
- vector tracing expanded safely
- fallback remains stable
- lesson flow works across all letters
- no regressions introduced
- system is ready for full kids learning experience

--------------------------------------------------

“And We have certainly made the Qur’an easy for remembrance.” — Qur’an 54:17

===== END PHASE 21 PROMPT =====
