===== PHASE 5 PROMPT — CROSSWORD PUZZLE =====

You are working in the existing Flutter codebase for “Path of Nūr”.

==================================================
PRIMARY OBJECTIVE === BUILDING CROSSWORD PUZZLE
==================================================

Expand the Crossword Puzzle system into Phase 5 by building:
- a complete daily challenge ecosystem
- deeper rotation logic and long-term engagement loops
- a scalable content authoring pipeline
- lightweight live-ready structures (still offline-first)
- stronger integration with streaks, progression, and Ocean Drops at scale

This phase prepares the crossword system for long-term usage, high engagement, and future growth across thousands of puzzles.

This must remain fully aligned with the existing app build, feel, global theme system, and shared architecture.

==================================================
GLOBAL APP CONSISTENCY (MANDATORY)
==================================================

The implementation MUST:
- keep the same app build and feel
- use the global theme system
- reuse shared surfaces, cards, layouts, spacing, and typography
- follow existing navigation patterns
- preserve localization
- reuse XP, levels, streaks, Ocean Drops, and reward systems
- match existing motion and interaction patterns

DO NOT:
- introduce new visual systems
- create disconnected flows
- create a “mini-game system” separate from the app
- duplicate reward or persistence systems

Everything must feel native to Path of Nūr.

==================================================
TASK TYPE
==================================================

Implement Crossword Puzzle Phase 5.

==================================================
EXECUTION RULES
==================================================

1. Audit first before editing.
2. Build on Phase 1–4 architecture.
3. Keep everything offline-first by default.
4. Introduce live-ready structures without requiring backend dependency.
5. Keep architecture modular and scalable.
6. Avoid over-engineering real-time systems.
7. Run analyzer on changed files and summarize results.

==================================================
A. AUDIT PHASE (MANDATORY FIRST STEP)
==================================================

Audit the current crossword implementation.

Identify:
- daily crossword logic
- current rotation system
- streak tracking implementation
- reward trigger points
- puzzle pack system
- content structure and metadata
- persistence and resume logic
- category and difficulty distribution
- current limitations for scaling content

Determine:
1. what parts already support scale
2. where rotation logic is too simple
3. where content pipeline is fragile
4. what needs to change to support long-term growth
5. how daily challenges can expand without breaking current behavior

==================================================
B. DAILY CHALLENGE ECOSYSTEM
==================================================

Expand the daily crossword into a full system.

Add support for:

1. DAILY PUZZLE (existing, refine)
- one puzzle per day
- theme-based (weekday mapping)
- consistent per day
- completion tracked

2. DAILY BONUS OBJECTIVES
Examples:
- complete without hints
- complete within time threshold
- complete perfectly (no mistakes)
- complete 2 puzzles (if applicable)

Rules:
- do not force complexity
- keep objectives simple and optional
- reuse existing reward system

3. DAILY COMPLETION STATE
Track:
- completed
- completed with bonus
- perfect completion
- time taken (if available)

4. DAILY HISTORY
- store last X days (e.g. 7, 14, or 30)
- allow user to view past completions
- show simple visual history (no heavy charts)

==================================================
C. STREAK SYSTEM EXPANSION
==================================================

Refine crossword streak behavior.

Ensure:
- daily crossword contributes to streak
- streak increments once per valid completion
- streak resets only when truly missed
- optional grace/skip integrates only if an existing system exists

Add:
- streak visibility on crossword home
- subtle streak feedback after completion

Do NOT:
- duplicate global streak systems
- create conflicting streak definitions

==================================================
D. ROTATION DEPTH + CONTENT DISTRIBUTION
==================================================

Improve daily rotation quality.

Ensure:
- puzzles do not repeat too frequently
- themes are respected (Qur’an, Hadith, Prophets, Duas, etc.)
- difficulty varies across days
- kids vs adult rotation is handled cleanly
- enough content pool exists for rotation

Introduce:
- rotation index or deterministic selection strategy
- simple content pool filtering by:
  - category
  - difficulty
  - eligibility flags
  - usage history

Keep:
- offline-first determinism
- predictable results

==================================================
E. CONTENT AUTHORING PIPELINE (CRITICAL)
==================================================

Introduce a clean, scalable way to define crossword content.

Create or refine:
- structured JSON or Dart seed format for puzzles
- structured format for crossword entries
- structured format for packs and categories
- clear metadata requirements

Define:
- required fields
- optional fields
- validation expectations

Ensure:
- content is easy to add
- content is easy to review
- content errors are easy to detect

If appropriate:
- add lightweight validation helpers for content authors
- ensure all puzzle entries pass validation rules

This is critical for scaling beyond V1.

==================================================
F. CONTENT TAGGING + ELIGIBILITY SYSTEM
==================================================

Refine content metadata to support rotation and filtering.

Each puzzle or entry should support:
- category
- difficulty
- tags
- daily eligibility
- pack eligibility
- mode compatibility (kids/adult/mixed)
- theme compatibility (weekday mapping)

Ensure:
- consistent tagging
- no ambiguous category assignments
- deterministic filtering logic

==================================================
G. OCEAN DROPS SCALING INTEGRATION
==================================================

Expand integration with the Ocean Drops system.

Ensure:
- each solved word continues to add drops
- daily puzzle completion contributes meaningfully
- bonus objectives can optionally grant additional drops (if aligned with system rules)

Add:
- optional daily contribution summary
  Example:
  “Today your crossword added X drops to the ocean”

- optional global-style messaging placeholder
  (no real backend required yet)

Do NOT:
- break existing drop logic
- duplicate drop calculation systems

==================================================
H. REWARD BALANCING
==================================================

Refine XP and reward structure.

Ensure:
- rewards feel meaningful but not excessive
- kids vs adult balance feels appropriate
- daily completion feels slightly elevated vs normal puzzles
- bonus objectives provide small additional incentive

Do NOT:
- introduce complex economies
- introduce monetization-like mechanics

Keep:
- simple
- fair
- consistent

==================================================
I. UI / UX — DAILY + ENGAGEMENT LAYER
==================================================

Enhance UI for engagement.

Update:
1. Crossword home
   - daily card (prominent)
   - streak indicator
   - progress indicators
   - recent activity

2. Daily puzzle entry
   - clear “today’s challenge” identity
   - theme indication
   - difficulty indicator

3. Completion screen
   - daily completion acknowledgment
   - streak feedback
   - bonus completion acknowledgment

4. History surface
   - simple list/grid of past days
   - completion states

Design direction:
- calm
- premium
- motivating
- not overwhelming

==================================================
J. LIGHTWEIGHT LIVE-READY PREPARATION
==================================================

Prepare for future live updates without requiring backend now.

Introduce:
- structure for remote override (future)
- versionable puzzle packs
- ability to swap or extend content later

Keep:
- everything fully functional offline
- no dependency on network

==================================================
K. PERFORMANCE + SCALE SAFETY
==================================================

Ensure system holds up as content grows.

Review:
- puzzle loading
- pack browsing
- daily resolution
- persistence size
- validation performance

Optimize only where needed.

==================================================
L. CLEANUP
==================================================

- remove fragile logic from earlier phases if replaced
- ensure naming consistency
- ensure modular architecture
- avoid monolithic files
- keep feature boundaries clean

==================================================
M. VALIDATION
==================================================

Confirm:
- daily challenge works correctly
- streak updates correctly
- rotation logic avoids repetition
- content pipeline is clean and scalable
- rewards trigger correctly
- Ocean Drops integrate correctly
- UI matches global theme
- system works offline
- analyzer passes

==================================================
DELIVERABLES
==================================================

After implementation, provide:

1. files created / updated
2. how daily ecosystem works
3. how rotation logic works
4. how content pipeline is structured
5. how streaks and rewards integrate
6. how Ocean Drops scale with crossword
7. any limitations
8. recommended Phase 6 next steps

==================================================
END
==================================================
