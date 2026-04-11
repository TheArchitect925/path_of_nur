# HOTFIX / POLISH — MAKE CURRENT SURAH READER SEARCH RESULTS BEHAVE LIKE WHOLE QURAN MODE, BUT LIMITED TO AYAH RESULTS ONLY

PRIMARY OBJECTIVE === ALIGN CURRENT SURAH READER SEARCH RESULT BEHAVIOR WITH THE WHOLE QURAN READER SEARCH MODE, WHILE LIMITING RESULTS TO AYAH MATCHES IN THE CURRENT SURAH ONLY

You are working in the existing Flutter codebase for Path of Nūr.

This is a focused polish task.
Do not redesign the app.
Do not create a new competing search system.
Do not break routing, exact ayah opening, playback, localization, knowledge search, or the current unified Qur’an search stack.

CONTEXT
Inside the reader search sheet, Whole Qur’an mode already behaves in the right general way:
- clear result rows
- direct ayah-focused result selection
- query-preserving jump behavior

We now want Current Surah mode to behave in the same general way, but limited to ayah results from the current surah only.

IMPORTANT
Ignore the previous suggestion about reusing the main search result styling separately.
Instead, make Current Surah mode behave like the Whole Qur’an mode already used inside the reader search sheet, while limiting the search scope to:
- current surah only
- ayah results only

GOAL
Update Current Surah mode in the reader search sheet so it behaves like Whole Qur’an mode in interaction pattern and result presentation, but only returns ayah matches from the current surah.

IMPLEMENT THE FOLLOWING

A. ALIGN CURRENT SURAH MODE WITH WHOLE QURAN MODE
- Make Current Surah mode use the same result-driven interaction pattern as Whole Qur’an mode inside the reader search sheet.
- Keep the UX consistent between the two modes.
- Do not leave Current Surah mode as a separate-feeling interaction model if Whole Qur’an mode is now the clearer pattern.

B. LIMIT CURRENT SURAH MODE TO AYAH RESULTS ONLY
- Current Surah mode should only return ayah matches from the current surah.
- Do not include broader discovery-style or non-ayah result types in this mode.
- Keep it focused on directly actionable ayah search results.

C. KEEP QUERY + HIGHLIGHT CONTEXT PRESERVED
- When a Current Surah result is selected:
- preserve the query
- preserve the matched field context when practical
- jump to the exact ayah
- keep reader highlighting active after navigation
- Do not weaken the existing exact-ayāh landing path.

D. KEEP NEXT/PREV SAFE
- If Current Surah mode already has next/previous navigation, preserve it if it still fits cleanly.
- If the new result-driven interaction model requires small adjustments, keep them tight and safe.
- Do not introduce regressions to current-surah navigation behavior.

E. KEEP THE SHEET LIGHTWEIGHT AND BOUNDED
- Preserve the bounded reader-search sheet architecture:
- fixed top controls
- one Expanded scroll region
- capped compact results
- Do not reintroduce overflow, wrong-build-scope, or teardown issues.

F. KEEP WHOLE QURAN MODE UNCHANGED
- Do not regress Whole Qur’an mode.
- Do not blur Current Surah and Whole Qur’an scope behavior.
- Just make Current Surah mode behave like the same type of compact ayah-result experience, but scoped locally.

G. DO NOT BREAK
- quran_repository.dart canonical search ownership
- quran_navigation.dart
- canonical /quran/surah/:surahNumber route
- exact ayah landing fixes
- reader-search sheet stability fixes
- in-reader highlighting
- /quran/search
- /quran/knowledge-search
- playback
- localization

H. KEEP THE CHANGESET TIGHT
- Focus only on making Current Surah mode behave like the Whole Qur’an search option inside the reader sheet, while limiting to current-surah ayah matches.
- Do not redesign the whole sheet.
- Do not introduce unrelated result-card work.

DELIVERABLES
After implementing, provide:
1. Executive summary
2. Files changed
3. How Current Surah mode now aligns with Whole Qur’an mode
4. How Current Surah results are limited to ayah-only matches
5. How query/highlight context remains preserved
6. Validation notes
7. Analyzer results
8. Test results
9. Any remaining follow-up notes

At the very end, include a concise Codex audit summary and explicitly confirm that:
- Current Surah mode now behaves like the Whole Qur’an mode inside the reader search sheet
- it is limited to current-surah ayah matches only
