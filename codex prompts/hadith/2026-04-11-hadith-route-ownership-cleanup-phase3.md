===== PHASE 3 PROMPT — HADITH ROUTE OWNERSHIP CLEANUP =====

PRIMARY OBJECTIVE === CLEAN UP HADITH ROUTE OWNERSHIP AND NAMING SO THE DOMAIN SCALES CLEANLY WITHOUT BREAKING EXISTING USER FLOWS

You are working in the existing Flutter codebase for “Path of Nūr”.

Task type:
Production-safe route ownership and navigation cleanup for the Hadith domain.

Background:
Phase 1 improved large-library access on theme and collection surfaces.
Phase 2 added reader continuity using typed lane context.

The next issue is architectural clarity:
- some route names imply taxonomy ownership
- but the backing page behavior is collection-owned
- this mismatch will make future browse/search/navigation harder to reason about

Important constraints:
1. Audit first before editing.
2. Do not redesign the UI.
3. Do not break existing user-facing hadith flows.
4. Preserve routing compatibility for existing links and in-app navigation.
5. Do not remove features.
6. Do not delete stored state, saved items, review state, or progress.
7. Prefer canonical ownership with compatibility redirects/adapters where needed.
8. Keep this production-ready and maintainable.
9. Run analyzer on changed files and summarize results.

Objectives:

A. Audit current route ownership
- Inspect the Hadith routes and identify:
  - canonical route owners
  - alias/legacy-like routes if any
  - route names whose semantics do not match the actual page/data ownership
- Pay special attention to:
  - hadithSubcategoryDetail
  - collection-scoped pages
  - source browse pages
  - theme pages
  - reader route ownership

B. Resolve taxonomy-vs-collection mismatch
- Decide whether the current “subcategory detail” route should:
  1. become a true taxonomy-owned page
  OR
  2. be renamed/reframed clearly as collection-owned
- Choose the safest path based on the current repo and current product state.
- Prefer the smallest clean long-term direction.

C. Preserve compatibility
- If route names or ownership are cleaned up, preserve existing navigation behavior through:
  - redirects
  - aliases
  - compatibility wrappers
  - stable parameter handling
- Do not strand older internal links.

D. Clarify lane semantics
- Ensure the route/page naming aligns with the lane model already introduced for reader continuity.
- Theme lanes, collection lanes, source/chapter lanes, and path lanes should be conceptually clear and predictable.

E. Keep this phase scoped
DO implement:
- route ownership cleanup
- canonical naming/ownership clarification
- compatibility preservation
- small internal page/route naming cleanup where needed

DO NOT implement yet:
- giant browse unification
- deep taxonomy rebuild
- new search architecture
- reader redesign
- unnecessary sweeping refactors

F. Validation
Confirm:
1. route ownership is clearer after the change
2. existing user flows still work
3. continuity context still works
4. no hadith entry surface is broken
5. analyzer passes

Deliverables:
Provide a concise summary with:
- files changed
- what ownership mismatch was found
- what canonical ownership model was chosen
- what compatibility measures were added
- whether any route names changed
- analyzer results

At the very end, include a short audit note on the best next phase after this:
1. canonical hadith browse surface
2. stronger search-to-reader continuity
3. taxonomy expansion

===== END =====
