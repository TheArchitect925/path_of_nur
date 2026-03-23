# Phase 25F Prompt — Writing-System Unification + Journal Detail Flow

PRIMARY OBJECTIVE === BUILDING A MORE COHERENT WRITING / RETENTION SYSTEM FOR PATH OF NŪR WITHOUT BREAKING EXISTING CONTENT

You are working in the existing Path of Nūr codebase.

This is a CONTROLLED PRODUCT-COHESION phase.
This is NOT a broad rebuild.
This is NOT a feature expansion phase.
This is NOT a generic cleanup sweep.

Previous phases already improved:
- route integrity
- regression trust
- live localization
- Qur’an ownership clarity

This phase must now improve the coherence of the writing / retention system across:
- Learn Notes
- Qur’an Reflections
- Journal

========================================================
CORE GOAL
========================================================

Make the app’s note/reflection/journal experience feel like one understandable system rather than three disconnected writing surfaces, while preserving existing data, routes, and feature intent.

========================================================
CURRENT PROBLEM TO SOLVE
========================================================

The writing/retention system is still fragmented:

- Learn Notes acts like an aggregator / note entry system
- Qur’an Reflections acts like a dedicated saved-reflections surface
- Journal remains separate
- Journal item drill-in is incomplete or weak
- product ownership across these surfaces is not yet clear enough to users

This phase should improve cohesion without flattening all distinct purposes into one blob.

========================================================
APPROVED DIRECTION
========================================================

Unless code evidence proves otherwise, treat this as the intended direction:

1. Learn Notes remains useful as a broader notes/discovery surface.
2. Qur’an Reflections remains a distinct Qur’an-focused reflection surface.
3. Journal remains a timeline/personal-writing surface.
4. These three should feel connected and intentionally separated by purpose.
5. Journal entries must support real item-level drill-in/open behavior.
6. Existing user data/content must be preserved.

========================================================
STRICT DO-NOT-DO RULES
========================================================

Do NOT:
- delete user notes, reflections, or journal entries
- merge everything into one flat page
- break existing routes for notes/reflections/journal
- redesign the entire Learn IA
- redesign Qur’an IA again
- remove data models for no reason
- broaden scope into unrelated polish
- go haywire and remove/delete records or content for no reason

========================================================
PHASE SCOPE
========================================================

This phase should focus on:

1. Learn Notes landing / note discovery
2. Qur’an Reflections surface
3. Journal timeline
4. Journal entry open/detail/edit flow
5. navigation and product framing between these writing surfaces
6. clarifying purpose without deleting existing usefulness

========================================================
MANDATORY AUDIT-FIRST TASKS
========================================================

Before editing, verify and document:

1. what data models back Learn Notes, Qur’an Reflections, and Journal
2. whether they are already partially shared or fully separate
3. how Journal items are currently rendered and why drill-in is incomplete
4. all current routes/entry points to these surfaces
5. whether any strong existing flows would be harmed by forced unification
6. what current labels or descriptions make the system feel fragmented or unclear

Do not guess.

========================================================
IMPLEMENTATION RULES
========================================================

1. Preserve all existing user data behavior.
2. Improve cohesion through framing, navigation, and item-level completion.
3. Keep distinct purposes where they make sense:
   - notes = broader capture/discovery
   - reflections = Qur’an-specific reflection
   - journal = personal timeline/journal writing
4. Add real journal item open/detail behavior.
5. If editing is already supported in the model, expose it properly.
6. If a full edit flow is too risky, at minimum provide a meaningful read/detail view and safe onward actions.
7. Improve navigation links between surfaces only where they help clarify the system.
8. Do not over-engineer a universal writing architecture if the current models are still intentionally different.

========================================================
COMPATIBILITY RULES
========================================================

- preserve existing routes
- preserve existing saved content behavior
- do not remove compatibility paths unless explicitly safe and clearly unnecessary
- if adding a journal detail route/view, do it in a way that preserves current timeline behavior

========================================================
TESTING REQUIREMENTS
========================================================

Run:
- flutter analyze
- relevant notes/reflections/journal tests
- any route/widget tests touched by this phase
- add coverage for journal entry drill-in behavior

Do not weaken tests just to pass.
If expectations change, explain why.
