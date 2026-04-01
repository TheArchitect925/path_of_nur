===== PHASE 4 PROMPT — SAFE LEARN ROUTE / ALIAS / CANONICAL OWNERSHIP CONSOLIDATION =====

PRIMARY OBJECTIVE === CONSOLIDATE LEARNING ROUTES, ALIASES, REDIRECTS, AND CANONICAL OWNERSHIP SAFELY SO PATH OF NUR HAS ONE CLEAR LEARNING ENTRY MODEL WITHOUT BREAKING EXISTING PAGES, DEEP LINKS, SEARCH, QURAN OWNERSHIP, KIDS FLOWS, OR USER ACCESS

You are working in the existing Flutter codebase for “Path of Nūr”.

This pass happens after:
- Learning Hub IA audit
- visible island consolidation
- copy / naming cleanup
- Guided Learning Paths V1

This is a route-safety and architecture pass.
It is NOT a destructive rewrite.
It is NOT permission to delete working pages just because newer UI exists.

Core safety rule:
Do not go haywire and remove/delete records, routes, pages, aliases, redirects, deep links, metadata, search mappings, analytics hooks, or navigation targets for no reason.

This pass must be production-safe, reversible in logic, and respectful of compatibility.

==================================================
PRIMARY GOAL
==================================================

The Learn experience currently has too many parallel entry systems and overlapping route families.

We want to safely move toward this ownership model:

CANONICAL OWNERSHIP MODEL
- `/learn` = primary learning front door
- `/quran/*` = canonical Qur’an owner
- kids route family = preserved audience lane
- guided paths = guided orchestration layer, not a replacement for canonical domain owners
- older / legacy / alias Learn routes = preserved as compatibility paths where needed, but no longer competing as equal primary visible entry systems

The end result should be:
- fewer competing route owners
- safer redirect logic
- preserved backward compatibility
- stable search/indexing
- stable deep links
- a documented canonical ownership model

==================================================
IMPORTANT NON-GOALS
==================================================

DO NOT:
- delete large route families casually
- remove legacy paths without safe compatibility handling
- destructively merge unrelated pages
- rebuild the entire Learn feature tree
- rewrite unrelated Qur’an internals
- break kids navigation
- break search/indexing
- change user-visible URLs/deep links without safe handling
- create new canonical duplication

==================================================
ROUTE FAMILIES / SURFACES TO AUDIT
==================================================

At minimum audit and handle these safely:
- `/learn`
- `/learn/legacy`
- `/learn/journey-home`
- `/learn/learning-journey`
- `/learn/explore`
- `/learn/games`
- `/learn/quizzes`
- `/learn/hub/*`
- `/learn/section/*`
- `/learn/browse`
- kids route family
- `/quran/*`

Also inspect:
- any home cards or navigation helpers linking into Learn
- any deep link handlers
- any shared route helpers/constants
- any route aliases or redirects already present
- any search/index metadata keyed off route/category targets
- any tests covering route behavior

==================================================
YOUR TASK
==================================================

1. AUDIT CURRENT ROUTE OWNERSHIP BEFORE EDITING
Audit:
- route definitions
- redirect rules
- aliases
- navigation helpers
- deep link handling
- landing-page destinations
- legacy compatibility mappings
- any duplicated route ownership across Learn/Qur’an/Kids/Games/Journeys

Determine for each route family:
- canonical owner
- compatibility alias
- legacy UI entry
- active visible primary entry
- internal helper path
- deprecated but still needed compatibility path
- unclear ownership or duplicated ownership

2. DEFINE A FORMAL CANONICAL OWNERSHIP MODEL
Create and implement a clear ownership matrix for the current routing system.

Expected direction:
- `/learn` = primary visible front door for learning
- `/quran/*` = canonical Qur’an learning / reading / listening / study owner
- kids route family = canonical audience-specific kids learning owner
- `/learn` Qur’an and Kids cards = curated entry points, not duplicate owners
- games/quizzes/trivia = structured beneath the simplified Learn model without losing direct compatibility routes
- old routes such as legacy/journey-home/learning-journey/hub/section/browse remain only if needed for compatibility or internal routing stability

3. CLASSIFY EVERY RELEVANT ROUTE
For each relevant learning-related route, classify it as one of:
- canonical
- compatibility alias
- redirect-only
- visible entry point
- hidden compatibility path
- legacy but retained
- candidate for future retirement
- unresolved / needs follow-up

4. CONSOLIDATE REDIRECT LOGIC SAFELY
Where duplicate routes represent the same or near-same destination, safely consolidate with redirects or compatibility handling.

Requirements:
- preserve working old paths
- preserve deep links
- preserve any route parameters
- preserve back-stack behavior where practical
- avoid redirect loops
- avoid ambiguous ownership
- prefer central redirect logic rather than scattered one-off hacks

5. KEEP `/QURAN/*` CANONICAL
Important:
- do not create or preserve a second equal-weight canonical Qur’an owner under `/learn`
- Learn may link into Qur’an
- Learn may feature curated Qur’an entry points
- but full Qur’an ownership remains under `/quran/*`

Audit and fix any visible or routing ambiguity that suggests otherwise.

6. KEEP KIDS SAFE
Important:
- kids routes remain preserved
- kids remains discoverable
- kids must not be accidentally buried or broken by route cleanup
- if kids has alternate Learn-side entry routes, preserve safe compatibility handling

7. UNIFY GAMES / QUIZZES / TRIVIA ROUTE BEHAVIOR
Audit all game-related learning paths such as:
- `/learn/games`
- `/learn/quizzes`
- `/learn/quizzes/trivia`
- any `/learn/hub/trivia`
- other game/challenge aliases

Build a safer ownership model where:
- visible ownership aligns to Games
- compatibility routes remain working
- duplicate direct front doors do not compete unnecessarily
- routing remains easy to reason about

8. PRESERVE GUIDED PATHS INTEGRATION
If Guided Learning Paths V1 exists:
- ensure any path step route targets still resolve safely
- update path mappings only if necessary
- do not break path progress because of route cleanup
- centralize target mapping if that improves safety

9. PRESERVE SEARCH / INDEXING / METADATA
Critical:
- do not regress Learn search or content indexing
- preserve stable identifiers where possible
- visible route cleanup must not orphan content metadata
- if route targets change, update metadata and compatibility carefully
- document all affected identifiers and why

10. PRESERVE LOCALIZATION
If any user-facing labels or route-facing visible copy are adjusted in this pass:
- keep localization intact
- add/update only necessary keys
- preserve existing translation structure

At the end, report:
- which localization keys were added/updated
- which keys were reused
- which locale files were touched

11. ADD TESTS OR UPDATE TESTS WHERE PRACTICAL
Where practical and low-risk, add or update tests for:
- redirects
- canonical route resolution
- alias resolution
- absence of redirect loops
- continued access to preserved legacy paths

Do not overbuild a giant test suite if it is out of scope, but add meaningful coverage where route logic changed.

12. CREATE DOCUMENTATION
Create a markdown file such as:
docs/learn_route_canonicalization_2026-03-31.md

This document must include:
- executive summary
- canonical ownership matrix
- route classification table
- redirects/aliases preserved
- routes now treated as canonical vs compatibility
- Qur’an ownership notes
- Kids ownership notes
- Games/quizzes/trivia ownership notes
- search/indexing impact
- localization impact
- testing impact
- risks and future retirement candidates

13. CREATE A FUTURE RETIREMENT / CLEANUP BACKLOG
Create a second markdown file such as:
docs/learn_route_cleanup_backlog_2026-03-31.md

Include:
- routes safe to keep indefinitely as aliases
- routes that could be retired in a later phase
- prerequisites before retiring anything
- telemetry/analytics checks needed before retirement
- user-facing migration considerations
- do-not-break notes
- follow-up cleanup opportunities

==================================================
IMPLEMENTATION DETAILS
==================================================

A. PREFER CENTRALIZED ROUTE LOGIC
If route aliasing/redirect logic is currently scattered, consolidate safely where practical into clearer routing helpers or redirect functions.
Do not introduce a complicated or magical system if a simpler improvement is safer.

B. DO NOT SILENTLY DELETE DESTINATIONS
If two routes overlap, do not assume one page can be removed.
Preserve the underlying page unless the audit clearly proves safe alias-only behavior and even then prefer restraint in this pass.

C. DOCUMENT ALL BEHAVIORAL CHANGES
Every meaningful redirect/canonicalization decision should be documented so the next pass can safely build on it.

D. PROTECT COMPATIBILITY
If older links from widgets, saved state, search, guided paths, or notes may still target older paths, preserve them.

E. MAINTAIN USER EXPERIENCE
Even though this is a plumbing pass, do not degrade UX:
- avoid jarring redirects
- keep destination behavior intuitive
- maintain clean entry flow from `/learn`

==================================================
VALIDATION
==================================================

Before finishing, confirm:

1. `/learn` remains the primary learning front door.
2. `/quran/*` remains the canonical Qur’an owner.
3. kids route family remains safe and discoverable.
4. guided paths still resolve correctly if present.
5. legacy/alias Learn routes still resolve safely.
6. duplicate ownership ambiguity is reduced.
7. redirects do not loop.
8. search/indexing/metadata was not regressed.
9. localization remains intact.
10. any changed tests pass or remaining failures are clearly explained.
11. analyzer passes on changed files or remaining issues are clearly explained.

==================================================
DELIVERABLES
==================================================

1. Implement safe route / alias / canonical ownership consolidation.
2. Create the canonicalization markdown doc.
3. Create the future cleanup backlog markdown doc.
4. Return a concise but thorough summary including:
   - audit findings before changes
   - files changed
   - canonical ownership model implemented
   - redirects/aliases preserved
   - how `/quran/*` was protected
   - how kids was protected
   - how games/quizzes/trivia routes were unified
   - guided path impact
   - search/indexing impact
   - localization keys added/reused
   - test impact
   - analyzer results
5. At the very end, audit your own implementation and provide one full summary so we can work on fixing this next.

===== END PHASE 4 PROMPT — SAFE LEARN ROUTE / ALIAS / CANONICAL OWNERSHIP CONSOLIDATION =====
