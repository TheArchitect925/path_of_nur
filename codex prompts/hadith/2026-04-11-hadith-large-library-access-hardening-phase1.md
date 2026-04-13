# User Prompt

===== PHASE 1 PROMPT — HADITH LARGE-LIBRARY ACCESS HARDENING =====

PRIMARY OBJECTIVE === IMPROVE HADITH THEME AND COLLECTION ACCESS FOR LARGE LIBRARIES WITHOUT REDESIGNING THE READER

You are working in the existing Flutter codebase for “Path of Nūr”.

Task type:
Production-ready access and performance improvement for Hadith browse/detail surfaces.

Background:
An audit has already identified the main weaknesses:
- theme and collection detail pages eagerly render large flat lists
- there is no good narrowing step before long scrolling
- the reader itself is strong for one hadith, but browse-to-reader continuity is weaker
- source/chapter browse scales better than flat theme scrolling
- the current subcategory route naming/ownership may need cleanup later, but not in this phase

This phase is NOT the giant browse-system rewrite.
This phase is the safest first production pass.

Execution rules:
1. Audit the current live implementation first before editing.
2. Do not redesign the global UI.
3. Do not break routing, localization, theming, search, saved state, daily hadith, review, or paths.
4. Do not remove existing access paths.
5. Do not delete or rename route ownership yet unless absolutely necessary.
6. Keep the reader page visually and functionally intact in this phase.
7. Build this as a production-ready improvement, not a placeholder.
8. Run analyzer on changed files and summarize results.

Implement the following:

A. Convert large flat lists to lazy rendering
- Replace eager flat list rendering on:
  - hadith_theme_page.dart
  - hadith_subcategory_page.dart
- Use lazy rendering such as ListView.builder / CustomScrollView + SliverList / equivalent, depending on the page structure.
- Preserve current card content and behavior.

B. Add summary-first page structure
For theme and collection pages:
- keep the overview/header content at the top
- do not immediately dump the entire full list under it
- introduce a calmer narrowing flow so users can understand the page before entering long content

C. Add lightweight narrowing controls
Add a small, production-safe control layer for large sets, such as:
- sort
- source filter
- grade filter
- subcategory filter where relevant
Keep it simple and visually aligned with the current app.
Do not overbuild an advanced faceted search engine in this phase.

D. Add featured / initial subset behavior
For large result sets:
- show a curated initial subset or top section first
- then show the filtered/browsable full list below
- keep this deterministic and maintainable
- do not hide content in a confusing way

E. Preserve current navigation
- opening a hadith from theme/collection pages should still go to the same reader
- preserve existing routing and incoming context behavior
- do not add reader continuity controls yet in this phase unless a tiny, safe context hook is trivial

F. Keep this phase scoped
DO implement:
- lazy rendering
- narrowing controls
- summary-first browse behavior
- production-safe list scaling improvements

DO NOT implement yet:
- major reader redesign
- full canonical hadith browse page
- deep taxonomy rewrite
- route renaming cleanup unless absolutely required
- complex recommendation logic

G. Validation
Confirm:
1. theme and collection pages no longer eagerly build long flat lists
2. large sets are easier to narrow before deep scrolling
3. current navigation into the reader still works
4. visuals remain aligned with the app
5. analyzer passes on changed files

Deliverables:
Provide a concise summary with:
- files changed
- how lazy rendering was implemented
- what sort/filter controls were added
- how summary-first behavior works
- what was intentionally deferred
- analyzer results

At the very end, include a short audit note stating the best next phase after this:
1. reader continuity controls
2. route ownership cleanup
3. canonical hadith browse surface

===== END =====
