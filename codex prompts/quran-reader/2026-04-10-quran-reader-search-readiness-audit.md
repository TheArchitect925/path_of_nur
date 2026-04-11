===== PHASE AUDIT — QURAN READER + SEARCH READINESS =====

PRIMARY OBJECTIVE === AUDIT THE EXISTING QURAN READER, QURAN DATA LAYER, AND SEARCH READINESS

You are auditing the existing Flutter codebase for Path of Nūr.

Do not implement anything yet.
Audit first and report findings clearly.
Do not redesign existing UI.
Do not remove or break current reader, playback, routing, localization, or insights behavior.
We need a factual repo-grounded audit of what already exists and what is missing for production-grade Quran search.

AUDIT GOALS
We want to determine whether the app can support:
1. word search across the Quran
2. full sentence / phrase search across the Quran
3. transliteration search
4. opening search results directly into the Quran reader at the exact ayah
5. future Arabic search later

ANSWER THE FOLLOWING QUESTIONS CLEARLY

A. CURRENT DATA ARCHITECTURE
1. Where is the main Quran data loaded from?
2. Is the Quran stored locally in the app, fetched remotely, or both?
3. Is there a single full Quran dataset available anywhere in the repo, or is data only loaded per surah?
4. What files/models/services/providers are responsible for loading Quran ayahs?
5. Does the app already have a way to load all ayahs across all surahs at once?
6. If not, what is the safest current extension point to add that capability?

B. AYAH DATA MODEL
7. What does the main ayah model contain today?
8. Does each ayah already include:
   - surah number
   - ayah number
   - Arabic text
   - translation text
   - transliteration text
   - verse key or unique id
9. If translations are present, are they embedded in the ayah model or loaded separately?
10. If transliteration is present, where is it stored and how is it loaded?
11. Are there multiple translations or just one active translation source?
12. Is the data structure stable enough to support indexing without major refactor?

C. READER READINESS
13. How does the Quran reader currently open a surah?
14. Can the reader already open directly to a specific ayah?
15. Can the reader already auto-scroll to a specific ayah after opening?
16. What route, arguments, or state are used to deep-link into a specific ayah?
17. Is search-to-reader navigation already partially implemented anywhere?
18. Are there any weaknesses in the current reader flow that would make search result jumping unreliable?

D. EXISTING SEARCH
19. Is there already a Quran search page in the repo?
20. If yes, what exactly does it search today?
21. Is current search real, partial, placeholder, mocked, or limited to a subset of Quran content?
22. Does current search work across the entire Quran or only parts of it?
23. Does current search support exact word search?
24. Does current search support phrase or sentence search?
25. Does current search support transliteration search?
26. How are current results ranked and displayed?
27. What are the current limitations or blockers?

E. INSIGHTS / DISCOVERY LAYER
28. Are there existing ayah insights, themes, topics, or guided path systems tied to ayahs?
29. If yes, where do they live?
30. Could these insight/theme datasets later be integrated into Quran search results?
31. Are these insight datasets separate from the Quran ayah dataset or merged into it?
32. Would adding search risk conflicting with existing insight browsing or discovery pages?

F. INDEXING READINESS
33. Based on the current repo, is it better to:
   - build a local index at runtime from existing data
   - ship a prebuilt index asset
   - use SQLite / FTS
   - or another approach
34. For the current app architecture, what is the safest and most maintainable production-ready approach?
35. Would a local JSON/map-based inverted index be sufficient for V1?
36. Would phrase search require a different structure from simple word indexing?
37. What would be needed to support transliteration normalization such as:
   - rahman
   - ar-rahman
   - al rahman
   - rahmaan
38. Are there existing utilities in the repo for normalization, tokenization, or text cleanup that can be reused?

G. PERFORMANCE / OFFLINE / SCALE
39. Would full-Quran word indexing be safe to run locally on device?
40. Would it be better to precompute the index during development/build time?
41. Are there memory or startup concerns with loading all ayahs for search?
42. Is the current app architecture already offline-first enough for local Quran search?
43. What search approach best fits the current architecture without introducing unnecessary complexity?

H. ROUTING / OWNERSHIP
44. What are the canonical Quran routes today?
45. What route should search results use to open the reader at a specific ayah?
46. Are there any alias routes or ownership conflicts that should be cleaned up before adding production Quran search?

I. FINAL RECOMMENDATION
47. Based on the repo as it exists today, what is the recommended production-ready implementation path for:
   - English translation word search
   - phrase / sentence search
   - transliteration search
48. What can be reused as-is?
49. What must be added new?
50. What should explicitly not be changed to avoid regressions?

DELIVERABLE FORMAT
Provide:
1. Executive summary
2. Current architecture findings
3. Search readiness assessment
4. Confirm whether the app is using:
   - full Quran dataset access
   - per-surah loading only
   - or a hybrid
5. Exact files involved
6. Gaps / blockers
7. Recommended implementation path for V1
8. Risk notes / regression watchouts

IMPORTANT
Do not implement yet.
Do not guess.
Base all conclusions only on actual repo findings.
If unsure, say exactly what could not be confirmed and which file would answer it.

At the very end, provide:
- a concise “build recommendation”
- and a concise “do not break” checklist

===== END AUDIT =====
