===== PHASE 8 — BUILD SOURCE-BOOK / CHAPTER HADITH BROWSE =====

PRIMARY OBJECTIVE === ADD A CANONICAL HADITH BROWSE EXPERIENCE BY SOURCE COLLECTION / BOOK / CHAPTER ON TOP OF THE EXISTING VERIFIED HADITH FOUNDATION

You are working in the existing Flutter codebase for Path of Nūr.

This is an implementation task based on the completed Hadith foundation, reader, graph, relation, corpus, and search phases.
Do not redesign the app.
Do not replace the current Hadith landing/search systems.
Do not guess. Use the existing normalized source/book/chapter/reference metadata already established.

CONTEXT
Completed groundwork:
- one canonical public Hadith content owner exists
- verified-only/default public surfacing rules are enforced
- source/book/chapter/reference metadata is normalized
- source collection/book is first-class
- category/subcategory taxonomy exists
- Hadith reader/detail parity is in place
- canonical Hadith search exists and is polished
- the verified public corpus is now large enough to support meaningful browse

What is still missing is a traditional source-oriented Hadith browse experience:
- browse by source collection/book
- browse by chapter
- open Hadith in the canonical reader

GOAL
Build a canonical Hadith browse flow by source/book/chapter that complements search and thematic discovery.

IMPORTANT PRODUCT RULES
- Use only the verified public Hadith subset.
- Do not build a second ownership model.
- Keep route ownership clear.
- Do not break current Hadith landing, search, or reader behavior.
- Keep the UI consistent with the rest of the app and the sacred-reading style, but do not force Qur’an-specific surah/ayah assumptions.

IMPLEMENT THE FOLLOWING

A. ADD CANONICAL SOURCE-BOOK BROWSE OWNERSHIP
- Build repository/provider support for:
  - listing available public source collections/books
  - grouping entries by source collection/book
  - grouping entries by chapter where chapter metadata exists
- Keep ownership inside the canonical Hadith foundation domain.

B. ADD SOURCE-BOOK BROWSE UI
- Add a Hadith source browse surface under the Hadith domain.
- It may be:
  - integrated into the Hadith landing page
  - or a dedicated browse page/route reachable from the landing page
- Keep route ownership clear and minimal.

C. SUPPORT SOURCE COLLECTION / BOOK LISTING
- Show available public source collections/books using the canonical source collection metadata.
- Example:
  - Riyad as-Salihin
  - 40 Hadith an-Nawawi
  - Sahih al-Bukhari
  - Sahih Muslim
- Use counts where helpful.

D. SUPPORT CHAPTER BROWSE
- Where chapter metadata exists, let users browse chapters within a source/book.
- Keep the experience calm and readable.
- If some collections are missing strong chapter metadata, degrade gracefully without breaking the flow.

E. SUPPORT ENTRY LISTING AND READER HANDOFF
- From a source/book or chapter view, show Hadith entries in a browse-friendly list.
- Entry taps must open the canonical Hadith reader/detail route.
- Preserve trust/public-default gating and current route behavior.

F. KEEP SEARCH AND THEME DISCOVERY INTACT
- Do not remove or replace the current thematic discovery/search experience.
- This source-book/chapter browse should complement them.

G. KEEP TRUST RULES INTACT
- Only verified public Hadith entries may appear.
- Do not surface raw imports, excluded entries, or legacy lesson-only content through browse.

H. ADD TEST COVERAGE
Add or update focused tests for:
- source collection/book listing
- chapter grouping where metadata exists
- graceful handling where chapter metadata is sparse
- browse entry taps open the canonical Hadith reader route
- only verified public Hadith entries appear
- current Hadith routes remain intact

I. DO NOT BREAK
- canonical public Hadith foundation owner
- verified-only public Hadith surfacing
- current Hadith landing page
- current Hadith search route/page
- current Hadith reader/detail route
- saved Hadith persistence
- daily Hadith flow
- kids Hadith routes
- Hadith Reflection routes
- localization

J. KEEP THE CHANGESET TIGHT
- Focus only on source-book/chapter browse.
- Do not build cross-domain federated search in this phase.
- Do not redesign unrelated Learn pages.
- Do not add in-reader Hadith search yet.

DELIVERABLES
After implementing, provide:

1. Executive summary
2. Files changed
3. What browse ownership/providers were added
4. How source collection/book browse works
5. How chapter browse works
6. How entry navigation works
7. How verified-only public surfacing remains intact
8. Validation notes
9. Analyzer results
10. Test results
11. Any follow-up notes for Phase 9 excluded-entry recovery or future cross-domain “All” search

At the very end, explicitly confirm:
- Hadith can now be browsed by source collection/book
- chapter browse works where metadata exists
- entry taps still open the canonical Hadith reader/detail route
- current routes and trust rules remain intact

===== END =====
