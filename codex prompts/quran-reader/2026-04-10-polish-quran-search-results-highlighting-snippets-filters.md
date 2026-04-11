# Phase 6 — Polish Quran Search Results With Match Highlighting, Better Snippets, And Optional Field Filters

PRIMARY OBJECTIVE === MAKE THE EXISTING UNIFIED QURAN SEARCH FEEL CLEARER, MORE PRECISE, AND MORE USER-FRIENDLY WITHOUT CHANGING THE CORE SEARCH OWNERSHIP OR READER NAVIGATION

You are working in the existing Flutter codebase for Path of Nūr.

This is an implementation task, not an audit.
The repo already has:
- hardened exact-ayah navigation
- unified canonical Quran search ownership
- local English translation search
- local transliteration search
- local Arabic search
- unified search surfaces across Home, Qur’an hub, Read Qur’an, and /quran/search

Do not redesign the app.
Do not create a competing search engine.
Do not break routing, exact ayah opening, playback, localization, knowledge search, or existing discovery flows.

CONTEXT
The core search engine is now strong.
The next need is UX clarity:
- users should see why a result matched
- result previews/snippets should be more helpful
- /quran/search should allow lightweight field filtering without fragmenting the search system

GOAL
Polish Quran search results so they feel production-grade and easier to understand by adding:
1. match highlighting
2. better result snippets around the match
3. optional field filters on /quran/search

DESIGN RULES
- Keep one canonical Quran search owner.
- Keep one shared result model / navigation path.
- Do not split search logic by page.
- Keep /quran/search as the canonical full Quran search surface.
- Keep Home / Qur’an hub / Read Qur’an compact search sections lightweight.
- Keep /quran/knowledge-search separate.
- Do not redesign result cards unnecessarily.
- Use small, additive, production-safe UI improvements.

IMPLEMENT THE FOLLOWING

A. ADD MATCH-AWARE RESULT METADATA
- Extend the canonical Quran search result shaping so results can carry enough metadata to support:
  - which field matched
  - translation
  - transliteration
  - Arabic
  - surah name
  - matched substring/token range when practical
  - snippet generation context
- Keep this metadata lightweight and maintainable.
- Do not create a second result model if avoidable.

B. ADD BETTER SNIPPET GENERATION
- Improve snippets shown in /quran/search and compact preview surfaces so they center around the relevant match when possible.
- Snippets should work sensibly for:
  - translation matches
  - transliteration matches
  - Arabic matches
- Keep snippets readable and not overly long.
- Preserve existing card compactness where needed.
- Prefer a deterministic snippet strategy rather than a heavy NLP approach.

C. ADD MATCH HIGHLIGHTING
- Add safe result highlighting for matched text in the result preview/snippet area where practical.
- Support highlighting for:
  - translation matches
  - transliteration matches
  - Arabic matches
- Keep highlighting visually consistent with the app theme.
- Do not over-style or clutter the UI.
- If full exact-range highlighting is not practical in every case, implement the strongest deterministic version that is safe and maintainable.

D. ADD LIGHT MATCH-TYPE CLARITY
- On /quran/search, add small non-intrusive match-type hints when helpful, such as:
  - Translation
  - Transliteration
  - Arabic
  - Surah
- Keep these subtle and translation-ready.
- Avoid adding too much copy or visual noise.
- Do not add new user-facing text unless necessary.

E. ADD OPTIONAL FIELD FILTERS TO /quran/search
- Add lightweight user-selectable filters on the dedicated /quran/search surface only.
- Filters should allow narrowing to something like:
  - All
  - Translation
  - Transliteration
  - Arabic
  - Surah names
- Keep the default as All.
- Filters must reuse the same canonical search engine, not fork separate search systems.
- Home / Qur’an hub / Read Qur’an compact search does not need the full filter UI unless there is already a safe tiny reuse path.

F. KEEP CROSS-SURFACE BEHAVIOR CONSISTENT
- Home / Qur’an hub / Read Qur’an compact sections should benefit from the better snippets and match clarity where appropriate.
- /quran/search should remain the richest search surface.
- /quran/knowledge-search must remain separate and unaffected.

G. KEEP RESULT NAVIGATION UNCHANGED
- Search result taps must still use the shared navigation helper and canonical reader route.
- Do not bypass or weaken the exact-ayah landing fixes.
- Do not reintroduce any path that opens the surah at the top instead of the exact ayah.

H. KEEP THE CHANGESET TIGHT
- Do not start morphology/root search in this phase.
- Do not redesign the whole search UI.
- Do not introduce advanced semantic search here.
- Focus only on result polish and optional field narrowing.

I. TESTS + VALIDATION
Add or update focused tests for:
- result metadata correctly identifies the matched field
- snippet generation centers around the matched content
- highlighting logic behaves safely for translation/transliteration/Arabic
- /quran/search field filters narrow results correctly
- compact surfaces still show sensible snippets
- result taps still open the exact ayah correctly
- /quran/knowledge-search remains separate and unaffected

J. DO NOT BREAK
- quran_repository.dart canonical search ownership
- quran_navigation.dart
- canonical /quran/surah/:surahNumber route
- exact ayah landing fixes
- homepage/Qur’an hub/Read Qur’an compact search behavior
- /quran/search
- /quran/knowledge-search
- playback
- localization
- reader startup reliability
- existing English/transliteration/Arabic search behavior

DELIVERABLES
After implementing, provide:
1. Executive summary
2. Files changed
3. What search result metadata was added
4. How snippet generation works
5. How highlighting works
6. What field filters were added and how they reuse the canonical search stack
7. How compact surfaces benefited without becoming cluttered
8. Validation notes
9. Analyzer results
10. Test results
11. Any follow-up notes for future morphology/root-search work

At the very end, do a concise Codex audit summary so I can review the implementation cleanly.
