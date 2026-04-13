===== PHASE 4 PROMPT — CANONICAL HADITH BROWSE SURFACE =====

PRIMARY OBJECTIVE === BUILD A CANONICAL HADITH BROWSE SURFACE THAT SCALES ACROSS LARGE LIBRARIES WHILE PRESERVING EXISTING ENTRY SURFACES

You are working in the existing Flutter codebase for “Path of Nūr”.

Task type:
Production-ready canonical browse surface for the Hadith domain.

Background:
The Hadith domain has already been improved in prior phases:
- Phase 1: large-library access hardening on theme and collection surfaces
- Phase 2: reader continuity controls with typed lane context
- Phase 3: route ownership cleanup with collection ownership as canonical for collection detail

Now the domain needs one canonical large-library browse surface that can scale better than parallel flat browse behaviors.

Important constraints:
1. Audit the live implementation first before editing.
2. Do not redesign the global UI.
3. Do not break existing routes, reader continuity, saved/review state, daily hadith, learning paths, source browse, search, or current collection/theme entry surfaces.
4. Do not remove existing entry surfaces.
5. Do not delete any stored data, progress, or user state.
6. Build a production-ready feature, not a placeholder.
7. Prefer reuse of existing data providers and page primitives where practical.
8. Keep route ownership and naming clean.
9. Run analyzer on changed files and summarize results.

Primary product goal:
Create one canonical Hadith Browse page that gives users a scalable, calm, filterable way to explore large corpora without relying on endless flat theme/collection scrolling.

Implement the following:

A. Add one canonical browse route and page
- Introduce a canonical Hadith Browse route/page under the Hadith domain.
- Keep naming clear and aligned with the now-clean ownership model.
- Do not replace existing theme, collection, source, or search surfaces; this is an additional primary browse surface.

B. Build a scalable browse model
The canonical browse page should support shared browsing across the corpus with calm narrowing controls such as:
- source
- collection
- grade
- subcategory/taxonomy only if current data ownership supports it cleanly
- optional “shorter entries” or similarly simple reader-friendly narrowing only if already easy to derive safely

Keep the filtering model simple, predictable, and maintainable.
Do not build an overengineered enterprise faceted search engine.

C. Use lazy rendering
- The main result list must be lazy-rendered.
- Do not eagerly construct long lists.
- Keep it performant for large corpora.

D. Preserve a summary-first feel
- The page should not feel like a raw database dump.
- Add a calm top section that helps users understand the space before diving into the long list.
- This can include counts, selected filter chips, and a short orientation layer.
- Keep it restrained and aligned with the app.

E. Keep deterministic ordering
- Results should use stable ordering.
- Reuse existing recommended/default ordering where practical.
- Avoid random ordering.

F. Integrate with reader continuity
- Opening a hadith from the canonical browse surface should pass a stable lane context into the reader.
- Previous/next should work within the current browse result set when the result lane is deterministic and supported.
- Keep this consistent with Phase 2 continuity behavior.

G. Reuse existing surfaces, do not fight them
- Themes remain overview/discovery surfaces.
- Collections remain curated collection lanes.
- Source browse remains chapter/source-structured browsing.
- Search remains query-first lookup.
- The canonical browse surface should complement these, not duplicate them awkwardly.

H. Keep the scope disciplined
DO implement:
- canonical browse page
- route wiring
- shared filter chips / narrowing controls
- lazy results
- stable reader continuity handoff from this surface

DO NOT implement yet:
- full search architecture rewrite
- deep taxonomy rebuild
- major reader redesign
- massive provider rewrites unless clearly necessary
- unnecessary duplication of theme/source/search logic

I. Validation
Confirm:
1. the new browse surface scales better than flat theme/collection lists
2. results are lazy-rendered
3. filter behavior is stable and understandable
4. opening a result preserves continuity into the reader
5. existing hadith surfaces still work
6. analyzer passes

Deliverables:
Provide a concise summary with:
- files changed
- new route/page added
- filters supported
- how lazy rendering was implemented
- how reader continuity is passed from browse results
- what existing surfaces were intentionally left unchanged
- analyzer results

At the very end, include a short audit note on the best next phase after this:
1. stronger search-to-reader continuity
2. taxonomy expansion
3. browse analytics / usage instrumentation

===== END =====
