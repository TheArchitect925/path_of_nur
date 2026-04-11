# Phase 10 — Add Quran Search Memory, Recents, and Suggestions

PRIMARY OBJECTIVE === MAKE QURAN SEARCH FEEL COMPLETE AND STICKY BY ADDING RECENT SEARCHES, SUGGESTED SEARCHES, AND LIGHTWEIGHT SEARCH MEMORY ACROSS ALL SEARCH SURFACES

You are working in the existing Flutter codebase for Path of Nūr.

This is an implementation task, not an audit.
The repo already has:
- hardened exact-ayah navigation
- unified canonical Quran search ownership
- English/transliteration/Arabic search
- polished result snippets/highlighting/filters on /quran/search
- in-reader search highlighting + search pill
- current-surah + whole-Qur’an reader search modes
- stable reader search sheet lifecycle and layout

Do not redesign the app.
Do not create a competing search engine.
Do not break routing, exact ayah opening, playback, localization, knowledge search, or the current unified search stack.

CONTEXT
Search is now technically strong. The next step is to make it feel:
- faster to use
- easier to repeat
- more discoverable

Users should not need to type everything from scratch every time.

GOAL
Add a lightweight, local, privacy-safe search memory layer that supports:
1. recent searches
2. suggested searches
3. optional saved searches (lightweight V1)

across:

- /quran/search
- homepage search
- Qur’an hub search
- in-reader search sheet

DESIGN RULES
- Keep everything local (no server dependency).
- Keep it lightweight and fast.
- Keep it privacy-safe (no hidden tracking).
- Keep one canonical search engine.
- Do not mix this with knowledge-search logic.
- Do not clutter compact search surfaces.

IMPLEMENT THE FOLLOWING

A. ADD RECENT SEARCH STORAGE
- Create a local storage-backed recent search system (using existing LocalStore or equivalent).
- Store:
- query string
- optional field (translation/transliteration/arabic) if available
- timestamp
- Keep a capped list (e.g. last 10–15 searches).
- Deduplicate by normalized query (move existing query to top instead of duplicating).
- Keep it fast and synchronous where possible.

B. SHOW RECENT SEARCHES IN SEARCH SURFACES
1. /quran/search
- show recent searches when the query is empty
- allow tap-to-run
- allow clear all
2. Reader search sheet
- show recent searches in the sheet when no query is active
- allow tap-to-run
3. Homepage / Qur’an hub / Read Qur’an
- show a small, non-intrusive recent search section only if it fits cleanly
- do not clutter compact surfaces

C. ADD SUGGESTED SEARCHES
- Add a small curated list of suggested Qur’an searches, for example:
- mercy
- guidance
- patience
- sabr
- rahman
- repentance
- Keep suggestions static for V1 (no ML, no personalization yet).
- Show suggestions:
- when query is empty
- below or alongside recent searches
- Allow tap-to-run.

D. OPTIONAL LIGHTWEIGHT SAVED SEARCHES (V1 SIMPLE)
- Allow users to “save” a search from /quran/search.
- Saved searches:
- appear in a small section
- can be tapped to rerun
- can be removed
- Keep this simple and local only.
- Do not overbuild cloud sync or complex management.

E. KEEP SEARCH SURFACES CLEAN
- /quran/search can show:
- recent searches
- suggestions
- saved searches (if implemented)
- Reader search sheet:
- show recents + suggestions only
- keep compact and bounded
- Homepage / Qur’an hub:
- keep minimal and unobtrusive

F. PRESERVE CANONICAL SEARCH BEHAVIOR
- Running a recent/suggested/saved search must:
- use the same canonical search provider/repository
- preserve normalization and ranking
- preserve matched-field context where applicable
- open exact ayah correctly

G. KEEP PERFORMANCE FAST
- Do not introduce delays in search startup.
- Load recents/suggestions instantly.
- Avoid async blocking in the search UI.

H. ADD PRIVACY-SAFE CONTROLS
- Add a “clear recent searches” action.
- Optionally support a simple toggle (if already aligned with settings) to disable search history.
- Keep behavior transparent.

I. TESTS + VALIDATION
Add or update tests for:
- recent searches are stored and deduplicated
- capped list behavior works
- tap-to-run works
- clear recents works
- suggestions trigger correct search results
- saved searches (if implemented) persist and rerun correctly
- reader search sheet shows recents correctly
- no regression to:
- exact ayah landing
- highlighting
- search performance
- reader search stability

J. DO NOT BREAK
- quran_repository.dart canonical search ownership
- quran_navigation.dart
- canonical /quran/surah/:surahNumber route
- exact ayah landing fixes
- in-reader search highlighting
- reader search sheet stability
- /quran/search
- /quran/knowledge-search
- playback
- localization

K. KEEP THE CHANGESET TIGHT
- Focus only on search memory and suggestions.
- Do not redesign search UI.
- Do not introduce heavy personalization or ML.
- Keep everything deterministic and maintainable.
