# Phase 44 Prompt — Qur’an Readiness Bridge Expansion Pack

PRIMARY OBJECTIVE === EXPANDING THE QUR’AN READINESS BRIDGE WITH A LARGER, STRUCTURED SET OF BEGINNER-FRIENDLY SNIPPETS, STRONGER PROGRESSION, AND CLEARER CONFIDENCE-BUILDING FLOW FROM ARABIC LEARNING INTO REAL QUR’AN RECOGNITION

You are working in the existing Flutter codebase for Path of Nūr.

This phase builds on top of:
- the initial Qur’an readiness bridge (Phase 40)
- shared Arabic alphabet foundation
- shared positional-form foundation
- shared Arabic audio manifest
- shared words/phrases foundation
- Kids Arabic and Adult Arabic learning systems
- shared continuity/resume layer
- shared review layer
- offline-first Arabic bundle

DO NOT rebuild the Qur’an reader. DO NOT merge this bridge into the full reader UI. DO NOT introduce strict recitation scoring. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve the existing Qur’an readiness bridge behavior
- Keep bridge separate from full Qur’an reader
- Use real Qur’anic text only
- Keep snippets short, meaningful, and beginner-safe
- Keep UX calm and confidence-building
- Reuse shared Arabic foundations where useful
- No destructive migrations
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Expand the set of beginner Qur’anic snippets beyond the initial minimal set

2. Introduce a simple progression structure within the bridge

3. Improve recognition confidence through:
   - better snippet selection
   - clearer grouping
   - more consistent highlighting/audio behavior

4. Keep the experience lightweight and distinct from the full reader

--------------------------------------------------
A. AUDIT CURRENT QUR’AN BRIDGE
--------------------------------------------------

Inspect:
- current bridge snippet set
- current highlighting behavior
- current audio playback
- entry points from Kids and Adult Arabic
- any progression or sequencing already present
- continuity/resume integration
- any overlap with short-surah or Qur’an learning pages

Audit these questions:
- How many snippets are currently available?
- Are they grouped or flat?
- Are some snippets stronger than others?
- Is there a sense of progression today?
- Is highlighting/audio consistent across all snippets?
- What is the current weakest part of the bridge experience?
- What content should be expanded versus replaced?

--------------------------------------------------
B. DEFINE AN EXPANDED BEGINNER SNIPPET SET
--------------------------------------------------

Create a curated expanded set of Qur’anic snippets.

Requirements:
- use real Qur’anic text only
- keep snippets short and readable
- choose content that:
  - reinforces learned letters/words
  - is commonly heard/recognized
  - builds confidence

Organize the set into small groups such as:
- very first recognition snippets
- slightly longer snippets
- familiar phrases/ayah fragments

Do NOT create a full curriculum explosion.

Document in the final summary:
- what snippets were added
- why they were selected
- how they support progression

--------------------------------------------------
C. ADD A SIMPLE PROGRESSION STRUCTURE
--------------------------------------------------

Introduce a clear but lightweight progression inside the bridge.

Possible structure:
- Level 1: very short recognition
- Level 2: slightly longer snippets
- Level 3: combined recognition

Requirements:
- keep progression simple
- no locking that frustrates users
- allow forward movement and optional revisit
- integrate with continuity/resume layer

--------------------------------------------------
D. IMPROVE HIGHLIGHTING CONSISTENCY
--------------------------------------------------

Refine highlighting behavior across all snippets.

Requirements:
- consistent highlighting style
- reuse safe parts of Qur’an reader highlighting if possible
- avoid bringing full reader complexity
- keep it readable and beginner-friendly

Options:
- full-snippet highlight during playback
- word-level highlight if already safe
- consistent color and animation

--------------------------------------------------
E. IMPROVE AUDIO CONSISTENCY
--------------------------------------------------

Ensure snippet audio is:
- consistent in quality
- aligned with Phase 39 improvements
- responsive and replayable

Requirements:
- tap-to-hear
- replay
- optional slow playback if already supported
- no heavy controls

--------------------------------------------------
F. CONNECT TO SHARED ARABIC LEARNING
--------------------------------------------------

Where useful, connect snippets to:
- shared words/phrases
- shared letter ids
- shared positional forms

Examples:
- highlight familiar word inside snippet
- optionally show a known phrase reference

Requirements:
- do not overbuild parsing
- keep it helpful and minimal

--------------------------------------------------
G. IMPROVE ENTRY POINTS AND DISCOVERY
--------------------------------------------------

Refine how users reach the bridge.

Requirements:
- clear entry from Kids Arabic
- clear entry from Adult Arabic
- optional entry from Qur’an learning
- avoid duplicate confusing entry points

Examples:
- “Try reading Qur’an”
- “First Qur’an reading”
- “Arabic → Qur’an”

--------------------------------------------------
H. IMPROVE CONTINUITY AND RESUME
--------------------------------------------------

Integrate the expanded bridge with the shared continuity layer.

Requirements:
- resume last snippet
- suggest next snippet
- allow gentle review
- no fragmented resume logic

--------------------------------------------------
I. HANDLE EMPTY / FIRST-TIME / COMPLETION STATES
--------------------------------------------------

Handle:
- first-time entry (explain purpose briefly)
- mid-progress users (resume clearly)
- users who complete all current snippets (suggest review or move to next Qur’an learning surface)

Keep states calm and helpful.

--------------------------------------------------
J. KEEP FULL QUR’AN READER SEPARATE
--------------------------------------------------

Ensure:
- bridge is not overloaded with full reader features
- reader remains the full-featured surface
- optional handoff may exist but is not required in this phase

--------------------------------------------------
K. DATA SAFETY
--------------------------------------------------

Preserve:
- Kids Arabic progress
- Adult Arabic progress
- Qur’an reader integrity
- shared foundations
- audio behavior
- routing

Requirements:
- no destructive migrations
- no reset of progress
- no breaking of reader/player behavior

--------------------------------------------------
L. TESTING
--------------------------------------------------

Add/update meaningful tests for:

- expanded snippet set renders correctly
- highlighting works consistently
- audio plays correctly
- progression navigation works
- continuity/resume works
- entry points route correctly
- no regressions to Arabic learning or Qur’an systems

Run analyzer/tests and report results.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed
2. Audit findings
3. Expanded snippet set summary
4. Progression structure summary
5. Highlighting/audio improvements
6. Entry/continuity summary
7. Data safety summary
8. Validation results
9. FINAL AUDIT

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- Qur’an bridge includes a larger, high-quality snippet set
- progression feels real but simple
- highlighting/audio are consistent
- users can build confidence step by step
- Kids and Adults both have clear entry paths
- no regressions introduced
- learners experience a stronger “I can recognize Qur’an” moment

--------------------------------------------------

“And We have certainly made the Qur’an easy for remembrance.” — Qur’an 54:17

