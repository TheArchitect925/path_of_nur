===== PHASE 6 — BUILD THE CANONICAL HADITH SEARCH FOUNDATION =====

PRIMARY OBJECTIVE === CREATE A TRUSTWORTHY, CANONICAL HADITH SEARCH SYSTEM ON TOP OF THE VERIFIED HADITH FOUNDATION, NORMALIZED METADATA, AND NEW CROSS-DOMAIN RELATION MODEL

You are working in the existing Flutter codebase for Path of Nūr.

This is an implementation task based on the completed Hadith foundation, reader, graph-id migration, and editorial relation phases.
Do not redesign the app.
Do not build an overcomplicated “everything search” yet.
Do not guess. Use the actual canonical Hadith foundation and relation ownership already established.

CONTEXT
Completed groundwork:
- one canonical public Hadith content owner exists
- verified-only/default public surfacing rules are enforced
- source/book/chapter/reference metadata is normalized
- source collection/book is first-class
- category/subcategory taxonomy exists
- Hadith reader/detail parity is in place
- Qur’an ↔ Hadith graph now uses canonical `HadithEntry.id`
- a canonical cross-domain editorial relation model now exists

The next step is to build the core Hadith search foundation itself.

GOAL
Build a canonical Hadith search system that supports:
1. text/phrase search over trusted public Hadith entries
2. search by source/book
3. search by category/subcategory
4. search result snippets/highlighting
5. safe handoff into the canonical Hadith reader
6. future extension into cross-domain “All” search later

IMPORTANT PRODUCT RULES
- Search must only operate on the canonical public verified Hadith subset.
- Do not search the raw seed set directly.
- Do not create competing search owners.
- Build one canonical Hadith search owner/provider/route.
- Keep this phase focused on Hadith search itself, not full cross-domain federated search yet.

IMPLEMENT THE FOLLOWING

A. CREATE A CANONICAL HADITH SEARCH OWNER
- Add a dedicated Hadith search owner in the canonical Hadith domain.
- This should likely include:
  - normalized search support/helpers
  - repository/provider search path
  - result model for search hits
- Keep ownership centralized and deterministic.

B. ADD A DEDICATED HADITH SEARCH ROUTE / PAGE
- Add a canonical Hadith search route/page under the Learn/Hadith domain.
- Keep route ownership clear and aligned with existing Hadith routes.
- Do not break `/learn/hadith` or existing detail routes.
- Keep the UI calm and simple, similar in spirit to Qur’an search but appropriate for Hadith.

C. SUPPORT CORE SEARCH MODES
Build Hadith search over the canonical public verified subset for:
1. text / phrase search
   - translation text
   - Arabic text where available
   - transliteration where available
   - title/excerpt if relevant
2. source/book search
   - source collection/book title
3. category/subcategory search
4. narrator/source-reference matching where it is useful and safe

D. USE NORMALIZED FIELDS
- Reuse the normalized metadata from the Hadith foundation work:
  - source collection/book
  - reference
  - grade
  - category/subcategory
  - narrator normalization
- Add any needed normalized search helpers, but keep them canonical and centralized.

E. BUILD A SEARCH RESULT MODEL
- Create a clean result model that can support:
  - matched field/type
  - snippet text
  - highlight terms
  - destination entry id
- Keep this ready for future UI polish, but do not overbuild.

F. ADD SAFE RESULT NAVIGATION
- Search result taps must open the canonical Hadith reader/detail route.
- Preserve current public verified Hadith ownership.
- Do not bypass repository/provider trust logic.

G. SUPPORT LIGHT FILTERS
For V1, support at least:
- All
- Source
- Category
- Subcategory
- optionally Grade if it is already safe and clean
Keep filters lightweight and useful.

H. KEEP CROSS-DOMAIN RELATION MODEL COMPATIBLE
- Do not merge cross-domain editorial relations into the core Hadith search engine yet.
- However, the Hadith search foundation should be built in a way that later allows:
  - connected Qur’an results
  - connected Dua results
  - connected Learn content
in a future “All” or related-content mode.

I. KEEP TRUST RULES INTACT
- Search results must only come from the public verified Hadith subset.
- Non-public or incomplete Hadith entries must not surface in search.
- Preserve the Phase 1 public-content policy.

J. ADD TEST COVERAGE
Add or update focused tests for:
- canonical Hadith search owner/provider behavior
- text/phrase search works on public verified entries
- source/book search works
- category/subcategory filtering works
- non-public Hadith entries do not appear
- result routing opens the canonical Hadith detail path
- current Hadith routes remain intact

K. DO NOT BREAK
- canonical public Hadith foundation owner
- verified-only public Hadith surfacing
- current Hadith detail reader
- current route names
- saved Hadith persistence
- daily Hadith flow
- kids Hadith routes
- Hadith Reflection routes
- editorial override flow
- localization

L. KEEP THE CHANGESET TIGHT
- Build the canonical Hadith search foundation only.
- Do not build full cross-domain federated search in this phase.
- Do not redesign unrelated Learn pages.
- Do not add in-reader Hadith search yet unless a tiny safe hook is needed.

DELIVERABLES
After implementing, provide:

1. Executive summary
2. Files changed
3. What canonical Hadith search owner was added
4. What route/page was added
5. What fields are searchable
6. What filters are supported
7. How result navigation works
8. How verified-only public surfacing remains intact
9. Validation notes
10. Analyzer results
11. Test results
12. Any follow-up notes for Phase 7 search polish or future cross-domain “All” search

At the very end, explicitly confirm:
- a canonical Hadith search foundation now exists
- search uses only the public verified Hadith subset
- result taps open the canonical Hadith reader/detail route
- current routes and trust rules remain intact

===== END =====
