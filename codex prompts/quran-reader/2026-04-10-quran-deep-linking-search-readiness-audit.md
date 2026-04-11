===== PHASE AUDIT — QURAN DEEP LINKING + SEARCH READINESS =====

PRIMARY OBJECTIVE === AUDIT THE EXISTING QURAN READER, QURAN DATA LAYER, DEEP-LINK-TO-AYAH BEHAVIOR, AND SEARCH READINESS

You are auditing the existing Flutter codebase for Path of Nūr.

Do not implement anything yet.
Audit first and report findings clearly.
Do not redesign existing UI.
Do not remove or break current reader, playback, routing, localization, dua flows, or insights behavior.
We need a factual repo-grounded audit of what already exists, why exact ayah navigation is failing, and what is missing for production-grade Quran search.

CRITICAL PRIORITY
Before search is built, audit why existing flows that should open the Quran reader at a specific ayah are not landing on the correct ayah.

Known issue example:
- if the user taps a dua sourced from the Quran
- the app opens the correct surah
- but it does NOT reliably take the user to the exact ayah on the page

This must be audited first because Quran search will depend on the same navigation behavior.

AUDIT GOALS
We want to determine:
1. why exact ayah deep-linking is failing today
2. whether the current reader can be made reliable for search result navigation
3. whether the app can support:
   - word search across the Quran
   - full sentence / phrase search across the Quran
   - transliteration search
   - opening search results directly into the Quran reader at the exact ayah
   - future Arabic search later

ANSWER THE FOLLOWING QUESTIONS CLEARLY

A. CURRENT DEEP-LINK-TO-AYAH BEHAVIOR
1. What current flows in the repo attempt to open the Quran reader at a specific surah and ayah?
2. Which pages/features currently send users into the Quran reader with a target ayah?
   - include duas from Quran
   - ayah insights
   - bookmarks
   - notifications
   - any other relevant flows
3. What parameters are currently passed when opening the Quran reader?
4. Is the ayah number actually being passed through correctly from source pages?
5. Is the router preserving the ayah argument correctly?
6. Does the Quran reader page receive the correct initial ayah value?
7. Once the reader receives the ayah value, what logic is supposed to scroll to it?
8. Is the scroll-to-ayah logic running too early before layout completes?
9. Are GlobalKeys / item keys being created for all ayahs correctly?
10. Is the target ayah key present at the moment scroll is attempted?
11. Is there any race condition involving async ayah loading, post-frame callbacks, or repeated rebuilds?
12. Does the reader fall back to the surah start because the ayah scroll logic fails silently?
13. Is the issue caused by:
   - bad route arguments
   - missing argument propagation
   - late data loading
   - wrong ayah indexing
   - incorrect scroll key mapping
   - virtualization / list building behavior
   - nested scroll/container issues
   - auto-scroll timing
   - state reset after navigation
   - or something else
14. Is the current failure isolated to certain entry points like dua cards, or is it a general reader deep-link problem?
15. What is the exact root cause based on the repo?

B. QURAN READER READINESS
16. How does the Quran reader currently open a surah?
17. Can the reader already open directly to a specific ayah in theory?
18. Can the reader already auto-scroll to a specific ayah after opening in a fully reliable way?
19. What route, arguments, or state are used to deep-link into a specific ayah?
20. Is there any existing partial implementation for search-to-reader navigation?
21. What weaknesses in the current reader flow would make search result jumping unreliable even if search existed?

C. CURRENT DATA ARCHITECTURE
22. Where is the main Quran data loaded from?
23. Is the Quran stored locally in the app, fetched remotely, or both?
24. Is there a single full Quran dataset available anywhere in the repo, or is data only loaded per surah?
25. What files/models/services/providers are responsible for loading Quran ayahs?
26. Does the app already have a way to load all ayahs across all surahs at once?
27. If not, what is the safest current extension point to add that capability?

D. AYAH DATA MODEL
28. What does the main ayah model contain today?
29. Does each ayah already include:
   - surah number
   - ayah number
   - Arabic text
   - translation text
   - transliteration text
   - verse key or unique id
30. If translations are present, are they embedded in the ayah model or loaded separately?
31. If transliteration is present, where is it stored and how is it loaded?
32. Are there multiple translations or just one active translation source?
33. Is the data structure stable enough to support indexing without major refactor?

E. EXISTING SEARCH
34. Is there already a Quran search page in the repo?
35. If yes, what exactly does it search today?
36. Is current search real, partial, placeholder, mocked, or limited to a subset of Quran content?
37. Does current search work across the entire Quran or only parts of it?
38. Does current search support exact word search?
39. Does current search support phrase or sentence search?
40. Does current search support transliteration search?
41. How are current results ranked and displayed?
42. What are the current limitations or blockers?

F. INSIGHTS / DISCOVERY LAYER
43. Are there existing ayah insights, themes, topics, or guided path systems tied to ayahs?
44. If yes, where do they live?
45. Could these insight/theme datasets later be integrated into Quran search results?
46. Are these insight datasets separate from the Quran ayah dataset or merged into it?
47. Would adding search risk conflicting with existing insight browsing or discovery pages?

G. INDEXING READINESS
48. Based on the current repo, is it better to:
   - build a local index at runtime from existing data
   - ship a prebuilt index asset
   - use SQLite / FTS
   - or another approach
49. For the current app architecture, what is the safest and most maintainable production-ready approach?
50. Would a local JSON/map-based inverted index be sufficient for V1?
51. Would phrase search require a different structure from simple word indexing?
52. What would be needed to support transliteration normalization such as:
   - rahman
   - ar-rahman
   - al rahman
   - rahmaan
53. Are there existing utilities in the repo for normalization, tokenization, or text cleanup that can be reused?

H. PERFORMANCE / OFFLINE / SCALE
54. Would full-Quran word indexing be safe to run locally on device?
55. Would it be better to precompute the index during development/build time?
56. Are there memory or startup concerns with loading all ayahs for search?
57. Is the current app architecture already offline-first enough for local Quran search?
58. What search approach best fits the current architecture without introducing unnecessary complexity?

I. ROUTING / OWNERSHIP
59. What are the canonical Quran routes today?
60. What route should deep-linking and future search results use to open the reader at a specific ayah?
61. Are there any alias routes or ownership conflicts that should be cleaned up before adding production Quran search?

J. FINAL RECOMMENDATION
62. Based on the repo as it exists today, what is the recommended fix path for reliable exact ayah navigation?
63. What can be reused as-is?
64. What must be corrected before Quran search is implemented?
65. Based on the repo as it exists today, what is the recommended production-ready implementation path for:
   - English translation word search
   - phrase / sentence search
   - transliteration search
66. What should explicitly not be changed to avoid regressions?

AUDIT INSTRUCTIONS
- Audit first before changing anything.
- Trace the full path from source action to router to reader to scroll behavior.
- Follow the exact execution path for at least one known failing flow, especially a dua-from-Quran flow.
- Confirm whether the problem is argument passing, state handling, data timing, or scroll logic.
- Base conclusions only on actual repo findings.
- Do not guess.
- If something cannot be confirmed, say exactly which file or flow prevented confirmation.

DELIVERABLE FORMAT
Provide:
1. Executive summary
2. Root-cause findings for “open surah but not exact ayah”
3. Exact files involved in the failing navigation path
4. Current reader deep-link readiness assessment
5. Current Quran data architecture findings
6. Search readiness assessment
7. Confirm whether the app is using:
   - full Quran dataset access
   - per-surah loading only
   - or a hybrid
8. Gaps / blockers
9. Recommended fix path for exact ayah deep-linking
10. Recommended implementation path for V1 Quran search
11. Risk notes / regression watchouts

IMPORTANT
Do not implement yet.
At the very end, provide:
- a concise “fix first” checklist
- a concise “search after that” checklist
- a concise “do not break” checklist

===== END AUDIT =====
