===== PHASE 3 PROMPT — CROSSWORD PUZZLE =====

You are working in the existing Flutter codebase for “Path of Nūr”.

==================================================
PRIMARY OBJECTIVE === BUILDING CROSSWORD PUZZLE
==================================================

Expand the Crossword Puzzle system into Phase 3 by adding:
- stronger puzzle pack architecture
- category/themed puzzle browsing
- semi-dynamic puzzle assembly using seeded local content
- better puzzle metadata and filtering
- improved completion states and progression surfacing
- reusable foundations for the future “Knowledge Games Engine”

This phase must continue building on the existing crossword implementation and must keep the same app build and feel, using the global themes, shared components, shared layout systems, and existing reward/progression architecture.

This is NOT a standalone mini-game.
This must remain a fully integrated Path of Nūr feature.

==================================================
GLOBAL APP CONSISTENCY (MANDATORY)
==================================================

The implementation MUST:
- keep the same app build and feel
- use the global theme system
- use shared page shells, cards, surfaces, spacing, typography, and motion patterns
- preserve localization
- follow existing navigation and routing standards
- reuse XP, levels, streaks, Ocean Drops, and reward systems
- remain visually and behaviorally consistent with the rest of the app

DO NOT:
- create disconnected UI
- introduce a separate styling system
- create parallel persistence or reward systems
- make crossword feel like a separate product inside the app

Everything must feel native to Path of Nūr.

==================================================
TASK TYPE
==================================================

Implement Crossword Puzzle Phase 3.

==================================================
EXECUTION RULES
==================================================

1. Audit first before editing.
2. Build on the current crossword implementation from earlier phases.
3. Reuse existing content sources and shared systems.
4. Keep everything offline-first.
5. Keep this phase modular, stable, and extensible.
6. Do not implement full procedural crossword generation yet.
7. Run analyzer on changed files and summarize results.

==================================================
A. AUDIT PHASE (MANDATORY FIRST STEP)
==================================================

Audit the current crossword implementation and surrounding app architecture.

Identify:
- current crossword home flow
- current kids/adult/daily puzzle routing
- current models and seeded datasets
- current difficulty and metadata structure
- current reward and drops integration
- current streak and persistence logic
- existing content normalization work, if any
- any current limitations in puzzle reuse, browsing, or scaling

Determine:
1. what can be reused directly
2. what should be refactored for scalability
3. what should remain unchanged
4. what minimal architectural changes are needed to support themed browsing and semi-dynamic assembly
5. how to improve data structure without breaking current saved progress unnecessarily

Base all implementation decisions on this audit.

==================================================
B. PUZZLE PACK ARCHITECTURE
==================================================

Introduce a clean puzzle pack system.

Goal:
Allow crossword content to be grouped and surfaced as:
- Kids Packs
- Adult Packs
- Daily Eligible Packs
- Category Packs
- Difficulty Packs
- Seasonal / special packs later

Implement or refine a structure like:

class CrosswordPuzzlePack {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final String mode; // kids / adult / mixed / daily
  final String category; // quran / hadith / prophets / duas / worship / mixed
  final int minDifficulty;
  final int maxDifficulty;
  final List<String> puzzleIds;
  final List<String> tags;
  final bool isDailyEligible;
  final bool isFeatured;
}

Requirements:
- packs must be local/offline
- packs must be easy to extend
- packs must not duplicate puzzle data
- packs must work with the current persistence/progression system

==================================================
C. CATEGORY + THEMED BROWSING
==================================================

Add a better browsing experience for crossword content.

Implement support for browsing by:
- Kids
- Adult
- Daily
- Qur’an
- Hadith
- Prophets
- Duas
- Worship / Practice
- Character / Adab
- Mixed

UI requirements:
- use shared cards/surfaces
- keep the browsing calm and uncluttered
- show clear mode/category labels
- show completion state/progress where available
- show difficulty band in a clean consistent way
- allow the user to enter packs or themed lists, not just random isolated puzzles

Do not overbuild search unless a simple existing shared search/filter helper is already easy to reuse.

==================================================
D. SEMI-DYNAMIC PUZZLE ASSEMBLY
==================================================

Do NOT build a full auto-generating crossword engine yet.

Instead, implement a semi-dynamic assembly layer using seeded local content plus prebuilt layout templates.

Goal:
Allow the app to select or assemble a puzzle from:
- eligible content entries
- matching difficulty band
- matching mode
- matching category/theme
- matching grid template/layout rules

This should be a controlled system.

Recommended architecture:
1. content entries
2. layout templates
3. puzzle assembly rules
4. final assembled playable puzzle model

Examples:
- kids easy template
- adult medium template
- prophets themed template
- daily mixed template

Rules:
- only assemble puzzles when data fit is valid
- avoid unstable or unsolved layouts
- prioritize reliability over novelty
- if a requested assembly cannot be built safely, fall back to a seeded prebuilt puzzle

This phase is about future-readiness, not risky generation.

==================================================
E. LAYOUT TEMPLATE SYSTEM
==================================================

Introduce reusable crossword layout templates.

Possible structure:

class CrosswordLayoutTemplate {
  final String id;
  final int gridSize;
  final List<CrosswordSlot> slots;
  final String mode;
  final int difficultyScore;
  final List<String> tags;
}

class CrosswordSlot {
  final int row;
  final int col;
  final int length;
  final bool isAcross;
}

Requirements:
- templates must be reusable
- templates must support small kids layouts and larger adult layouts
- templates must be stable and deterministic
- templates must be easy to validate
- templates must support overlap rules safely

Use templates to support semi-dynamic assembly and future scaling.

==================================================
F. CONTENT NORMALIZATION IMPROVEMENTS
==================================================

Refine the content layer so crossword content can scale safely.

Each usable entry should support fields such as:
- id
- answer
- normalizedAnswer
- clue
- hint
- mode compatibility
- category
- difficulty score
- tags
- source type
- source id/reference if applicable
- optional imageKey
- optional audioKey
- allowed level band
- daily eligibility
- pack eligibility

Rules:
- normalize answers for crossword usage
- define how spaces, hyphens, apostrophes, and transliteration are handled
- be consistent across kids and adult modes
- avoid fragile answer formats that break grids

Examples:
- decide how multi-word answers are handled
- decide whether long answers are limited to adult mode
- decide whether transliteration is canonical in kids mode

Keep the system simple and deterministic.

==================================================
G. PROGRESSION SURFACING
==================================================

Improve how crossword progress is shown to the user.

Add or refine:
- pack completion percentage
- puzzle completion badges/states
- category progress
- kids/adult progress overview
- daily completion history summary if appropriate
- perfect solve indication if available
- locked / recommended next puzzle behavior if it fits the current app style

Do NOT introduce a heavy gamification overload.
Keep it clean, motivating, and aligned with Path of Nūr.

==================================================
H. REWARD + OCEAN DROPS REFINEMENT
==================================================

Continue using the existing reward architecture.

Ensure:
- rewards still trigger correctly for assembled or pack-based puzzles
- each solved word and completed puzzle uses existing hooks
- daily/pack/category views reflect earned state accurately
- no duplicate reward grants happen due to resume/reopen/reassembly issues

If needed, add safe reward-claim guards tied to puzzle instance identity and completion state.

Do not duplicate XP, drop, or streak services.

==================================================
I. UI / UX IMPROVEMENTS
==================================================

Refine the crossword experience to support packs and themed browsing.

Update or extend:
1. Crossword home
   - featured daily card
   - kids entry point
   - adult entry point
   - themed category entry points
   - continue/resume section if relevant

2. Category / pack listing screen
   - pack cards
   - progress
   - difficulty label
   - completion status
   - featured / recommended state if appropriate

3. Puzzle screen
   - clearer current clue focus
   - cleaner mode/category context
   - better completion celebration polish
   - smoother transition from pack/list to puzzle

4. Completion screen
   - next recommended puzzle
   - return to pack/category
   - progress summary
   - reward feedback

Design direction:
- calm
- polished
- premium
- readable
- consistent
- not visually noisy

==================================================
J. DATA EXPANSION
==================================================

Expand seeded crossword content carefully.

Recommended:
- more kids puzzles
- more adult puzzles
- more daily-eligible puzzles
- more category-tagged puzzles
- more template-compatible entries
- stronger metadata coverage

Keep content grounded in existing app knowledge:
- Qur’an learning
- Hadith dataset
- prophets and stories
- duas
- Arabic kids data
- learning hub content
- worship and adab content

Do not create disconnected filler content.

==================================================
K. SAFE FALLBACK LOGIC
==================================================

Because semi-dynamic assembly is being introduced, add safe fallback behavior.

If a puzzle cannot be assembled safely due to:
- incompatible slot lengths
- missing eligible entries
- invalid overlap rules
- invalid template fit
- malformed content entry

Then:
- log/debug clearly in development
- gracefully fall back to a known-good seeded puzzle
- avoid broken puzzle rendering in release behavior

User experience must remain stable even when content/template matching is imperfect.

==================================================
L. CLEANUP
==================================================

- remove or refactor duplicate logic that no longer fits the scaled architecture
- keep naming consistent
- keep models modular
- avoid giant manager classes
- keep feature ownership boundaries clear
- preserve compatibility with existing saved progress where practical

==================================================
M. VALIDATION
==================================================

Confirm:
- puzzle packs render correctly
- themed browsing works correctly
- categories and difficulty groupings are stable
- semi-dynamic assembly works for supported cases
- fallback logic works safely
- rewards still trigger once correctly
- saved progress remains stable
- UI remains fully aligned with global theme and app build
- analyzer passes on changed files

==================================================
DELIVERABLES
==================================================

After implementation, provide a concise summary of:
1. files created / updated
2. what was reused from previous phases and the wider app
3. how puzzle packs work
4. how category/themed browsing works
5. how semi-dynamic assembly works
6. how layout templates are stored and validated
7. what fallback logic exists
8. any limitations
9. recommended Phase 4 next steps

==================================================
END
==================================================
