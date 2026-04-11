===== PHASE 7 — HADITH SEARCH POLISH (RECENTS, SUGGESTIONS, GROUPING, EMPTY STATES, SNIPPET/HIGHLIGHT TUNING) =====

PRIMARY OBJECTIVE === POLISH THE EXISTING CANONICAL HADITH SEARCH SO IT FEELS COMPLETE, TRUSTWORTHY, AND EASY TO USE WITHOUT CHANGING ITS CORE OWNERSHIP OR TRUST RULES

You are working in the existing Flutter codebase for Path of Nūr.

This is a focused search-polish implementation task.
Do not redesign the app.
Do not build a second Hadith search system.
Do not guess. Use the existing canonical Hadith search owner, route, page, verified public subset, and reader/detail route that already exist.

CONTEXT
The canonical Hadith search foundation is already in place:
- canonical owner/provider/repository exists
- canonical route/page exists
- search uses only the verified public Hadith subset
- result taps already open the canonical Hadith detail route
- the corpus has expanded significantly and now includes 40 Nawawi and Riyad as-Salihin

The next step is not more search architecture.
The next step is polish:
- recent searches
- suggestions
- grouped result presentation
- better empty states
- stronger snippet/highlight clarity

GOAL
Improve the usability and clarity of Hadith search without changing:
- search ownership
- trust rules
- route ownership
- canonical result handoff

IMPORTANT PRODUCT RULES
- Keep one canonical Hadith search owner.
- Keep search limited to the verified public Hadith subset.
- Do not merge cross-domain “All” search into this phase.
- Keep the UI calm and readable.
- Make the search feel like a mature sibling to Qur’an search, but still Hadith-specific.

IMPLEMENT THE FOLLOWING

A. ADD HADITH SEARCH MEMORY
- Add recent searches for Hadith search.
- Keep them local only.
- Deduplicate by normalized query.
- Show recents on the Hadith search page when the query is empty.
- Add a clear action to remove/clear recents.
- Keep this scoped to Hadith search; do not build cross-domain memory behavior in this phase.

B. ADD HADITH SEARCH SUGGESTIONS
- Add a small curated set of suggestion queries relevant to the current Hadith corpus, such as:
  - intentions
  - sincerity
  - mercy
  - repentance
  - dua
  - character
  - justice
  - gratitude
- Suggestions should be local, deterministic, and safe.
- Show them when the query is empty.
- Tapping a suggestion should run the canonical Hadith search path.

C. IMPROVE RESULT GROUPING
- Keep the canonical search owner as-is, but improve presentation so results are easier to scan.
- Group or label matches where practical, for example by:
  - main text hits
  - source/book matches
  - category/subcategory matches
- Keep grouping light and readable.
- Do not overcomplicate the page.

D. IMPROVE EMPTY STATES
- When no results are found, provide useful guidance such as:
  - try a broader phrase
  - try searching by source/book
  - try category/subcategory terms
- If safe and grounded, show a few helpful suggestion chips or quick links.
- Keep copy minimal and trust-safe.

E. POLISH SNIPPETS AND HIGHLIGHTING
- Improve snippet clarity and highlighting where needed.
- Ensure snippets clearly show why the result matched:
  - text
  - source
  - category
  - subcategory
  - narrator
- Keep highlighting deterministic and not fuzzy.
- Do not over-highlight unrelated terms.

F. KEEP FILTERS LIGHT AND USEFUL
- Preserve the current existing filter behavior:
  - All
  - Source
  - Category
  - Subcategory
  - Grade
- Polish presentation only if needed.
- Do not redesign the filter architecture.

G. KEEP RESULT NAVIGATION SAFE
- Result taps must still open the canonical Hadith detail route.
- Do not bypass repository/provider trust logic.
- Do not break reader/detail behavior.

H. KEEP TRUST RULES INTACT
- Search results must still come only from the verified public Hadith subset.
- Non-public or incomplete entries must not appear.
- Preserve the public-content policy.

I. ADD TEST COVERAGE
Add or update focused tests for:
- recent search storage and deduplication
- recent search rerun behavior
- suggestion taps triggering canonical search
- grouped result presentation behavior if grouping logic is added
- empty-state behavior
- snippet/highlight correctness
- result taps still opening the canonical Hadith detail route
- non-public Hadith entries still excluded

J. DO NOT BREAK
- canonical public Hadith foundation owner
- verified-only public Hadith surfacing
- existing Hadith search owner/repository/provider
- `/learn/hadith/search`
- current Hadith detail reader
- current route names
- saved Hadith persistence
- daily Hadith flow
- kids Hadith routes
- Hadith Reflection routes
- editorial override flow
- localization

K. KEEP THE CHANGESET TIGHT
- Focus only on Hadith search polish.
- Do not build source-book/chapter browse in this phase.
- Do not build cross-domain federated search in this phase.
- Do not redesign unrelated Learn pages.

DELIVERABLES
After implementing, provide:

1. Executive summary
2. Files changed
3. What search-memory behavior was added
4. What suggestions were added
5. How result grouping was improved
6. How empty states were improved
7. How snippet/highlight behavior was improved
8. How result navigation remains safe
9. How verified-only public surfacing remains intact
10. Validation notes
11. Analyzer results
12. Test results
13. Any follow-up notes for Phase 8 source-book/chapter browse or future cross-domain “All” search

At the very end, explicitly confirm:
- Hadith search still uses the canonical public verified subset
- recent searches and suggestions now work
- result taps still open the canonical Hadith reader/detail route
- current routes and trust rules remain intact

===== END =====
