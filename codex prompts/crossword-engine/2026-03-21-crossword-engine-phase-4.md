===== PHASE 4 PROMPT — CROSSWORD PUZZLE =====

You are working in the existing Flutter codebase for “Path of Nūr”.

==================================================
PRIMARY OBJECTIVE === BUILDING CROSSWORD PUZZLE
==================================================

Expand the Crossword Puzzle feature into Phase 4 by focusing on:
- polish
- scalability
- stronger progression UX
- accessibility and usability refinement
- puzzle quality validation
- future bridge into the broader Knowledge Games Engine

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

Implement Crossword Puzzle Phase 4.

==================================================
EXECUTION RULES
==================================================

1. Audit first before editing.
2. Build on the current crossword implementation from earlier phases.
3. Reuse existing content sources and shared systems.
4. Keep everything offline-first.
5. Keep this phase modular, stable, and extensible.
6. Do not implement risky full procedural generation yet.
7. Prioritize production-readiness, quality, and consistency.
8. Run analyzer on changed files and summarize results.

==================================================
A. AUDIT PHASE (MANDATORY FIRST STEP)
==================================================

Audit the current crossword feature and surrounding app systems.

Identify:
- current crossword home structure
- current kids/adult/daily flows
- current pack/category browsing
- current puzzle model and layout template system
- current hint, reward, streak, and persistence behavior
- current puzzle completion UX
- any visual inconsistencies against global app surfaces/themes
- any friction in navigation, input flow, or clue readability
- any weak points in puzzle validation or content integrity
- any accessibility/usability gaps

Determine:
1. what is already strong and should remain unchanged
2. what needs polish
3. what needs structural tightening for scale
4. what validation safeguards are still missing
5. what should be prepared now for the future Knowledge Games Engine

Base all implementation decisions on this audit.

==================================================
B. POLISH THE CROSSWORD UX
==================================================

Refine the user experience end to end.

Polish areas:
- crossword home clarity
- puzzle entry flow
- category/pack browsing clarity
- selected clue focus
- selected cell visibility
- across/down switching clarity
- keyboard/input flow
- hint usage clarity
- completion transitions
- resume/reopen confidence
- empty/loading/error/fallback states

Requirements:
- remove friction
- reduce ambiguity
- keep the experience calm and premium
- avoid visual clutter
- make it feel intentionally designed, not just functional

Specific polish goals:
- make the current clue obvious at all times
- make selected word highlighting cleaner
- make solved/unsolved states easier to read
- make kids mode feel more guided and forgiving
- make adult mode feel more focused and elegant
- keep daily mode feeling special but not visually noisy

==================================================
C. ACCESSIBILITY + USABILITY REFINEMENT
==================================================

Improve accessibility and usability while staying within the app’s design language.

Implement or refine:
- better touch targets for cells and controls
- improved focus states
- readable text sizing behavior
- color contrast review against global theme tokens
- screen reader-friendly labels where practical
- clue/cell relationships that are easier to understand
- reduced ambiguity for color-only states
- support for longer localized clue text without layout breakage

If the app already has accessibility helpers or shared semantics patterns:
- reuse them
- do not create isolated accessibility solutions

Kids mode:
- ensure taps are forgiving
- make action buttons obvious
- keep interaction simple

Adult mode:
- ensure precision without making the grid feel cramped

==================================================
D. PUZZLE QUALITY VALIDATION LAYER
==================================================

Introduce a stronger crossword validation layer for seeded and semi-dynamic puzzles.

Add or refine validation checks for:
- duplicate answers in the same puzzle
- invalid slot lengths
- invalid overlaps
- conflicting letters at intersections
- missing clue text
- malformed answers
- unsupported characters/normalization issues
- empty or broken template assignments
- invalid daily eligibility metadata
- puzzle pack references that point to missing puzzles

Goal:
- catch content and assembly problems before they reach the user
- make seeded content safer to expand
- make future dynamic growth easier

Recommended approach:
- add reusable validation helpers
- keep them deterministic
- use them in development/debug flows and where safe during runtime guards
- surface clear diagnostics during development

Do not make the release app noisy with debug output.

==================================================
E. CONTENT TOOLING FOR SCALE
==================================================

Improve the crossword content structure so it scales cleanly.

Refine or extend:
- content normalization
- puzzle metadata consistency
- pack metadata consistency
- category tagging consistency
- difficulty labeling consistency
- daily eligibility consistency
- kids/adult mode compatibility rules

If helpful, add lightweight internal helper utilities for:
- puzzle filtering
- puzzle validation
- recommended-next-puzzle selection
- category aggregation
- completion summaries

Goal:
Make the crossword data layer easier to extend without rewriting the feature later.

==================================================
F. PROGRESSION + RECOMMENDATION POLISH
==================================================

Refine progression surfacing and next-step guidance.

Add or improve:
- continue where you left off surface
- recommended next puzzle
- next puzzle in pack flow
- category progress summary
- kids/adult progress summary
- daily history or recent completions if it fits the current UI patterns
- clean “completed” and “perfect” state representation
- clearer locked/recommended sequencing if appropriate

Rules:
- keep it lightweight
- do not overload the user with too many stats
- reuse existing progression/reward patterns where practical
- keep it motivating and clear

==================================================
G. COMPLETION EXPERIENCE REFINEMENT
==================================================

Refine completion feedback for crossword puzzles.

Improve:
- completion animation/state
- reward summary presentation
- XP + Ocean Drops acknowledgment
- perfect completion recognition
- daily completion recognition
- return / next action choices

Requirements:
- keep the same app build and feel
- use existing celebration/reward patterns if available
- avoid overdone game-like effects
- keep it polished, calm, and satisfying

Completion screen/actions may include:
- continue to next recommended puzzle
- return to pack/category
- go back home
- view progress

==================================================
H. PERFORMANCE + STABILITY REVIEW
==================================================

Audit and improve crossword performance and stability.

Review:
- grid repaint behavior
- clue list rebuild behavior
- selection/focus responsiveness
- persistence save frequency
- large puzzle handling
- pack browsing performance
- daily puzzle resolution stability
- resume/reopen correctness

Optimize only where needed.
Do not prematurely micro-optimize.
Focus on real issues that affect smoothness, correctness, or maintainability.

==================================================
I. KNOWLEDGE GAMES ENGINE BRIDGE
==================================================

Prepare the crossword feature to act as a clean base for future game types.

Do NOT build other games yet.

Instead, refactor or shape the architecture so crossword-specific systems are separated appropriately from reusable knowledge game foundations.

Possible reusable foundations:
- content entry normalization
- category/theme metadata
- difficulty metadata
- pack architecture
- daily resolver concepts
- progress summaries
- reward claim guards
- game recommendation flow

Possible crossword-specific layers:
- grid rendering
- slot layout templates
- cell entry logic
- across/down clue handling
- crossword completion logic

Goal:
When future modes are added later, the app should not need a major rewrite.

==================================================
J. QA / DEBUG SURFACES (LIGHTWEIGHT)
==================================================

If appropriate and low-risk, add lightweight internal-only debug helpers for development such as:
- puzzle validation summary
- template integrity checks
- content metadata sanity checks
- unresolved pack references
- daily resolver preview for upcoming days

Rules:
- do not expose developer/debug UI in production release flows unless already consistent with app debug tooling
- keep any tooling lightweight and maintainable

==================================================
K. CONTENT EXPANSION (SAFE + CONTROLLED)
==================================================

Expand content only if safe and consistent with current architecture.

Recommended:
- fill obvious content gaps across categories
- strengthen kids ladder progression
- strengthen adult theme variety
- strengthen daily eligible pool
- improve clue wording consistency
- improve answer normalization rules

Continue using existing app knowledge:
- Qur’an learning
- Hadith dataset
- prophets and stories
- duas
- Arabic kids data
- learning hub content
- worship and adab content

Do not add disconnected filler content.

==================================================
L. CLEANUP
==================================================

- remove duplicate logic
- remove brittle temporary glue code if Phase 4 replaces it with a cleaner solution
- keep naming consistent
- keep files modular
- avoid giant coordinator/managers
- preserve compatibility with existing saved progress where practical
- keep feature ownership boundaries clear

==================================================
M. VALIDATION
==================================================

Confirm:
- crossword UI still matches the same global app build and feel
- kids/adult/daily flows remain stable
- clue and cell selection clarity is improved
- puzzle completion UX is more polished
- validation layer catches bad puzzle content safely
- pack/category browsing remains correct
- persistence and resume still work correctly
- rewards still trigger once correctly
- recommendations/next puzzle logic works correctly
- architecture is cleaner for future Knowledge Games Engine reuse
- analyzer passes on changed files

==================================================
DELIVERABLES
==================================================

After implementation, provide a concise summary of:
1. files created / updated
2. what was polished vs refactored
3. what validation safeguards were added
4. how accessibility/usability improved
5. how progression/recommendation flow improved
6. what was prepared for the future Knowledge Games Engine
7. any limitations
8. recommended Phase 5 next steps

==================================================
END
==================================================
