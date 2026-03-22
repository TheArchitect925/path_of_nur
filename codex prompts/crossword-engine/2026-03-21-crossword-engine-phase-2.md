# Crossword Puzzle Phase 2 Prompt

Date: 2026-03-21
Feature Area: crossword-engine

## User Prompt

===== PHASE 2 PROMPT — CROSSWORD PUZZLE =====

You are working in the existing Flutter codebase for “Path of Nūr”.

==================================================
PRIMARY OBJECTIVE === BUILDING CROSSWORD PUZZLE
==================================================

Expand the existing Crossword Puzzle system into Phase 2 by adding:
- hint system
- daily rotation logic
- puzzle progression improvements
- difficulty balancing rules
- future-ready semi-dynamic puzzle preparation
- stronger persistence for crossword progress

This phase must build on the existing crossword implementation and keep the same app build, feel, structure, and shared systems.

This is NOT a standalone feature.
This must remain fully integrated into Path of Nūr.

==================================================
GLOBAL APP CONSISTENCY (MANDATORY)
==================================================

The implementation MUST:
- keep the same app build and feel
- use the global theme system
- use shared layout shells, cards, surfaces, spacing, and typography
- follow existing navigation patterns
- preserve localization
- reuse XP, levels, streaks, Ocean Drops, and reward hooks
- match the app’s existing motion and interaction style

DO NOT:
- create disconnected UI
- introduce a new styling language
- bypass shared helpers or parallel systems
- create a “mini app inside the app”

Everything must feel native to Path of Nūr.

==================================================
TASK TYPE
==================================================

Implement Crossword Puzzle Phase 2.

==================================================
EXECUTION RULES
==================================================

1. Audit first before editing.
2. Reuse existing crossword Phase 1 architecture.
3. Extend existing reward, streak, persistence, and theme systems.
4. Keep everything offline-first.
5. Keep V2 stable, clean, and extensible.
6. Avoid over-engineering full procedural generation in this phase.
7. Run analyzer on changed files and summarize results.

==================================================
A. AUDIT PHASE (MANDATORY FIRST STEP)
==================================================

Audit the current repo and the newly built crossword feature.

Identify:
- existing crossword models
- existing puzzle data sources
- current reward hooks
- existing streak logic
- current persistence approach
- daily challenge infrastructure if already present
- current kids/adult crossword routing
- UI consistency with global shared surfaces
- any existing hint-like systems in quizzes or learning flows

Determine:
1. what can be reused directly
2. what should be extended
3. what should not be duplicated
4. whether daily puzzle logic should plug into an existing daily system
5. whether persistence should live alongside existing game/learning progress storage

Base all implementation decisions on this audit.

==================================================
B. HINT SYSTEM
==================================================

Add a clean, scalable hint system for crossword puzzles.

Implement support for:
1. Reveal Letter
2. Reveal Word
3. Optional clue clarification / extra hint text if data exists

Rules:
- hints should be reusable across kids, adult, and daily modes where appropriate
- kids mode can be more forgiving
- adult mode should feel more deliberate
- hint behavior must be clear and predictable

Recommended V2 behavior:
- Reveal Letter:
  - reveals one correct letter in the currently selected word/cell
- Reveal Word:
  - reveals the full current word
- Extra Hint:
  - shows optional hint text if seeded in the puzzle entry

Hint economy:
- reuse existing XP/currency/reward systems if a suitable mechanic already exists
- if no appropriate cost mechanic exists, implement a simple usage limit per puzzle/day rather than inventing a heavy new economy
- do not overbuild monetization-like mechanics

Kids mode guidance:
- hints should feel assistive, not punishing
- voice hint button can remain future-ready if audio content is incomplete

Adult mode guidance:
- reveal tools should help progress without trivializing the puzzle too quickly

UI requirements:
- hint controls must match shared app button styles
- clearly show what each hint does
- reflect used/remaining hint state if limits exist

==================================================
C. DAILY CROSSWORD ROTATION LOGIC
==================================================

Implement a daily crossword system that rotates content by day and theme.

Daily theme mapping:
- Monday → Qur’an
- Tuesday → Hadith
- Wednesday → Prophets
- Thursday → Duas
- Friday → Jummah Special
- Saturday → Mixed
- Sunday → Mixed

Requirements:
- choose one puzzle per day using seeded local content
- keep the daily system offline-first
- ensure the same day always resolves to the same puzzle locally
- prevent the daily puzzle from changing randomly during the same day
- use user local date/time handling consistently with the rest of the app

If there is an existing daily challenge system:
- integrate with it instead of duplicating logic

If there is no existing daily challenge system:
- create a lightweight reusable resolver for daily crossword selection

Daily puzzle requirements:
- store completion state by date
- allow reopening the same day’s puzzle
- award daily completion rewards only once per eligible cycle
- connect to streak logic

==================================================
D. STREAK + PROGRESSION ENHANCEMENTS
==================================================

Extend progression for crossword puzzles using existing systems.

Implement:
- daily crossword streak tracking
- completion timestamps
- optional missed-day grace / skip token hook only if an existing skip system already exists
- kids and adult progression continuity
- per-puzzle completion state
- partial progress save/resume

Rules:
- do not duplicate the global streak system if one already exists
- if no dedicated crossword streak exists, add one in a way that aligns with app-wide habit/progress architecture
- save enough progress so a user can leave and return without losing their puzzle state

Track at minimum:
- puzzle started
- puzzle completed
- letters entered
- hints used
- completion accuracy / perfect completion eligibility
- completion date for daily puzzles

==================================================
E. DIFFICULTY BALANCING IMPROVEMENTS
==================================================

Improve the difficulty system introduced in Phase 1.

Ensure puzzle balancing reflects:
- grid size
- clue directness
- answer familiarity
- overlap complexity
- number of words
- hint expectation
- kids vs adult solving friction

Maintain the overall progression shape:
- Level 1–10 → 3x3 direct
- Level 10–25 → 5x5 mixed
- Level 25–50 → 7x7 contextual
- Level 50–75 → 9x9 indirect
- Level 75–100 → 11x11 conceptual

For Phase 2:
- do not build 100 handcrafted levels yet unless already easy to seed
- instead, build a reliable difficulty classification and grouping approach so content can scale cleanly later

Create or refine puzzle metadata as needed:
- level band
- audience type
- category
- theme
- difficulty score
- direct/contextual/conceptual clue type

==================================================
F. SEMI-DYNAMIC PUZZLE PREPARATION
==================================================

Do NOT build full procedural crossword generation yet.

Instead, prepare the architecture for future dynamic generation by introducing a clean separation between:
- puzzle content entries
- puzzle pack definitions
- puzzle layout definitions
- difficulty metadata
- daily resolver rules

If safe and low-risk, add a small helper that can:
- select from eligible puzzle pools by mode/theme/difficulty
- map seeded entries into prebuilt puzzle templates

The goal is to prepare for future dynamic generation without destabilizing the current seeded implementation.

==================================================
G. PERSISTENCE + RESUME
==================================================

Strengthen crossword persistence.

Support:
- resume incomplete puzzle
- remember filled cells
- remember solved words
- remember used hints
- remember daily completion state
- remember whether rewards were already granted

Rules:
- use the same persistence style already used in the app where practical
- do not create a one-off storage pattern without good reason
- keep serialization maintainable

==================================================
H. REWARD + OCEAN DROPS INTEGRATION
==================================================

Continue using existing reward systems.

Ensure:
- each word solved can still award the correct Ocean Drop behavior
- full completion awards XP
- perfect completion bonus still works if already implemented
- daily completion bonus can be added if aligned with existing reward patterns
- rewards are granted once, not repeatedly through reopen/resume exploits

Do not duplicate XP or drops logic.
Reuse existing hooks and services.

==================================================
I. UI / UX IMPROVEMENTS
==================================================

Refine the crossword experience while keeping the same app build and feel.

Update or extend:
1. Crossword home
   - daily card with current theme
   - progress indicators
   - streak visibility if appropriate
2. Puzzle screen
   - hint controls
   - daily badge if relevant
   - better current clue focus state
   - save/resume confidence
3. Completion state
   - daily completion acknowledgment
   - streak feedback
   - reward summary

Design direction:
- calm
- polished
- readable
- not cluttered
- premium but gentle
- aligned with the Path of Nūr visual language

==================================================
J. CONTENT EXPANSION FOR PHASE 2
==================================================

Expand seeded puzzle content modestly and safely.

Recommended:
- add more kids puzzles
- add more adult puzzles
- add dedicated daily-eligible puzzle tags
- add metadata for weekday theme routing

Do not create disconnected content.
Continue reusing:
- Qur’an learning
- Hadith
- Prophets
- Duas
- Arabic kids data
- Learning Hub content

==================================================
K. CLEANUP
==================================================

- remove dead or duplicate logic introduced during Phase 1 if now superseded
- keep naming consistent
- keep files modular
- keep ownership boundaries clear
- avoid giant all-in-one classes

==================================================
L. VALIDATION
==================================================

Confirm:
- hint system works correctly
- reveal letter works correctly
- reveal word works correctly
- daily rotation is stable and date-based
- same day returns same puzzle
- completion only rewards once
- streak updates correctly
- partial progress resumes correctly
- persistence survives app restart
- UI remains consistent with global theme and app build
- analyzer passes on changed files

==================================================
DELIVERABLES
==================================================

After implementation, provide a concise summary of:
1. files created / updated
2. what was reused from Phase 1 and the wider app
3. how hints work
4. how daily puzzle resolution works
5. how persistence/resume works
6. how streaks/rewards were integrated
7. any limitations
8. recommended Phase 3 next steps

==================================================
END
==================================================
