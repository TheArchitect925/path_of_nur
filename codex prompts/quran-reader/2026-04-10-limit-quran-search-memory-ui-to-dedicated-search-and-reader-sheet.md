# Hotfix / Polish — Limit Quran Search Memory UI To The Dedicated Search Window And Reader Search Pill

PRIMARY OBJECTIVE === REMOVE RECENT / SUGGESTED SEARCH UI FROM COMPACT SEARCH SURFACES AND SHOW IT ONLY INSIDE THE DEDICATED QURAN SEARCH WINDOW AND THE READER SEARCH PILL WINDOW

You are working in the existing Flutter codebase for Path of Nūr.

This is a focused polish task.
Do not redesign the app.
Do not change the canonical Qur’an search engine.
Do not break routing, exact ayah opening, playback, localization, or the current unified Qur’an search stack.

CONTEXT
Recent searches and suggested searches were added across multiple Qur’an-related search surfaces.
This now feels too broad and cluttered.

We want:
- compact surfaces to stay minimal
- recent/suggested search memory to live only inside dedicated search experiences

GOAL
Remove recent/suggested search sections from compact/shared search surfaces and keep them only inside:
1. the dedicated Qur’an search page (/quran/search)
2. the reader search pill sheet/window

IMPLEMENT THE FOLLOWING

A. REMOVE SEARCH MEMORY UI FROM COMPACT SURFACES
- Remove recent searches UI from:
- Home search
- Qur’an hub search launcher
- Read Qur’an compact search surface
- Remove suggested searches UI from those same compact surfaces.
- Keep those surfaces lightweight and query-focused.

B. KEEP SEARCH MEMORY IN THE RIGHT PLACES
- Keep recent searches visible in /quran/search when query is empty.
- Keep suggested searches visible in /quran/search when query is empty.
- Keep recent searches visible in the reader search pill sheet/window when query is empty.
- Keep suggested searches visible in the reader search pill sheet/window when query is empty.

C. DO NOT REMOVE THE STORAGE LAYER
- Do not remove the underlying recent/saved/suggested search storage/provider logic unless cleanup is clearly safe.
- This is a UI-scope reduction, not a search-memory feature rollback.
- Saved searches on /quran/search should remain intact.

D. KEEP CANONICAL SEARCH BEHAVIOR UNCHANGED
- Running a recent/suggested search from /quran/search or the reader search pill must still:
- use the canonical search path
- preserve exact ayah navigation
- preserve highlight/matched-field context where already supported

E. CLEAN UP ONLY WHAT IS NOW UNUSED
- Remove compact-surface-only widgets, hooks, or parameters only if they are no longer needed.
- Do not over-refactor.
- Prefer the smallest production-ready cleanup.

F. VALIDATE
At minimum validate:
- Home search no longer shows recents/suggestions
- Qur’an hub search no longer shows recents/suggestions
- Read Qur’an compact search no longer shows recents/suggestions
- /quran/search still shows recents/suggestions
- reader search pill sheet/window still shows recents/suggestions
- saved searches on /quran/search still work
- exact ayah navigation still works

G. DO NOT BREAK
- quran_repository.dart canonical search ownership
- quran_navigation.dart
- canonical /quran/surah/:surahNumber route
- exact ayah landing fixes
- reader search pill stability
- /quran/search
- /quran/knowledge-search
- playback
- localization

H. KEEP THE CHANGESET TIGHT
- Focus only on where recent/suggested search UI is shown.
- Do not redesign the search pages.
- Do not alter the search engine.
