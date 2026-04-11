===== PHASE AUDIT — HADITH READER PARITY, THEMES / LESSONS CANONICALIZATION, AND QURAN / HADITH / DUA / LEARNING CONNECTION READINESS =====

PRIMARY OBJECTIVE === AUDIT THE EXISTING HADITH EXPERIENCE, THEME/TOPIC/LESSON STRUCTURE, AND CROSS-DOMAIN CONNECTION READINESS SO WE CAN BUILD A CANONICAL HADITH READER AND A TRUSTED QURAN ↔ HADITH ↔ DUA ↔ LEARNING CONNECTION SYSTEM

You are auditing the existing Flutter codebase for Path of Nūr.

Do not implement anything yet.
Audit first and report findings clearly.
Do not redesign the app yet.
Do not guess.
Base conclusions only on actual repo findings.

CONTEXT
The direction for Hadith is now broader than just “add search.”

We want to build a canonical Hadith experience that includes:
- a strong Hadith reader aligned visually with the Qur’an reader
- trusted/core Hadith collections and a clean reader/detail experience
- canonical themes, main topics, and lesson structures
- Qur’an ↔ Hadith connections
- Hadith ↔ Duas connections
- Hadith / Qur’an / Duas / Creation / other Learning Hub lessons tied together in a coherent way

We already know:
- there is a newer verified Hadith foundation path
- there are existing Hadith themes/collections/pages
- there are Qur’an links on some Hadith entries
- there are other content domains in Learn such as Duas, Creation, and broader lessons

We now need a factual repo-grounded audit of:
1. what structure already exists for Hadith themes/topics/lessons
2. whether the current Hadith UI can become a proper reader that visually matches the Qur’an reader
3. what connection metadata already exists across Qur’an, Hadith, Duas, Creation, and learning content
4. what canonical connection model should be prepared before implementation

AUDIT GOALS
We want to determine:
1. how close the current Hadith UI already is to a true reader
2. what trusted collections/books/chapters/reference structure already exists
3. what themes/topics/lessons/tags already exist for Hadith
4. whether themes/topics/lessons are canonical or duplicated
5. what Qur’an ↔ Hadith links already exist
6. what Hadith ↔ Dua / Creation / other learning links already exist
7. what data architecture is needed to support a cross-domain connection system
8. the best phased implementation plan

ANSWER THE FOLLOWING QUESTIONS CLEARLY

A. HADITH READER READINESS
1. What files currently own the Hadith detail/lesson page and related reader-like UI?
2. How close is the current Hadith detail experience to being a true canonical Hadith reader?
3. What parts of the Qur’an reader design/system could be reused safely for Hadith reader parity?
4. What parts of the Qur’an reader should NOT be reused directly because Hadith has different structure/content needs?
5. What reader features already exist for Hadith today:
   - Arabic
   - translation
   - source citation
   - grade/authenticity
   - narrator
   - lessons/reflection
   - copy/share
   - save/bookmark
   - related items
6. What is missing for a production-grade Hadith reader?

B. TRUSTED BOOK / COLLECTION STRUCTURE
7. What collections/books currently exist in the active Hadith foundation data?
8. Are these app-defined collections, canonical source books, or a mix?
9. Is there already usable source-book/chapter/reference structure?
10. What is missing to support a proper “major authentic books” experience?
11. Can the current data already support a browse hierarchy like:
   - collection/book
   - chapter
   - hadith
12. If not, what is missing?

C. THEMES / TOPICS / LESSONS / TAGS
13. What theme/topic/lesson/tag fields already exist in the Hadith foundation model and seeded data?
14. Are these fields canonical and consistently used, or are they loosely editorial?
15. Are there duplicated or overlapping concept systems such as:
   - themes
   - app collections
   - lessons
   - tags
   - paths
   - quiz/review categories
16. Which of these should likely become canonical for the future Hadith library/search/discovery experience?
17. What is the current quality of “lesson” or “what this teaches” metadata?
18. Is there enough structure today to power:
   - theme pages
   - topic pages
   - lesson/takeaway sections
   - related content recommendations

D. QURAN ↔ HADITH CONNECTION READINESS
19. What Qur’an link fields already exist in the Hadith foundation model/data?
20. Are those links already used anywhere in the UI?
21. Are the links canonical verse references or just loose strings?
22. Can the current model support:
   - related ayahs on a Hadith reader page
   - related hadith on a Qur’an page
23. What is missing to build a clean Qur’an ↔ Hadith connection layer?

E. HADITH ↔ DUA / LEARNING HUB CONNECTION READINESS
24. What data/models/routes already exist for Duas in the repo that could connect to Hadith?
25. What data/models/routes already exist for Creation / World / Signs / other learning content that could connect to Hadith or Qur’an?
26. Are there already shared content-reference models, graph models, ids, tags, or connection-ready objects used across learning domains?
27. Do Duas already connect to:
   - Qur’an
   - Hadith
   - themes/topics
28. Do Creation / Stories / other learning lessons already connect to:
   - Qur’an
   - Hadith
   - themes/topics
29. Are these connections canonical, partial, or mostly absent?
30. What files currently own any cross-domain connection logic?

F. CROSS-DOMAIN CONNECTION MODEL READINESS
31. Does the repo already have any general-purpose content graph/reference model that could be reused for:
   - Qur’an ↔ Hadith
   - Hadith ↔ Dua
   - Qur’an ↔ Dua
   - Hadith/Qur’an ↔ Creation lessons
   - Hadith/Qur’an ↔ other Learn content
32. If yes, how mature is it?
33. If not, what shape should a future connection model likely take based on repo patterns?
34. Should connections likely be modeled as:
   - direct ids/refs on entries
   - a central graph/index
   - editorial link bundles
   - or a hybrid
35. What relationship types would likely be needed, based on repo content and product direction? Examples:
   - explains
   - reinforces
   - related theme
   - related practice
   - related dua
   - related creation/sign
   - same lesson/topic

G. SEARCH / DISCOVERY READINESS FOR HADITH
36. Based on the current Hadith data and metadata, what kind of search can realistically be built later:
   - text search
   - topic search
   - collection/book search
   - lesson search
   - Qur’an-linked search
37. What metadata gaps must be solved first before a strong Hadith search experience is built?
38. Could the future Hadith search also surface connected Duas / Qur’an / Learn content in an “All” mode, or is the repo not ready for that yet?

H. UI / PRODUCT PARITY WITH QURAN READER
39. What parts of the Qur’an search/reader product patterns are good candidates for Hadith parity?
40. Which patterns should likely be mirrored later for Hadith:
   - dedicated search page
   - compact search previews
   - recents/suggestions
   - in-reader search
   - related content
   - filters/type selector
41. What parts should stay different because Hadith is reference/book/chapter-oriented instead of surah/ayah-oriented?

I. GAP ANALYSIS
42. What is already strong and reusable for this direction?
43. What is weak, duplicated, or risky?
44. What must be canonicalized before building Hadith reader/search/connections?
45. What is the highest-risk area if we move too fast?

J. RECOMMENDED PHASED PLAN
46. What is the best phased build order now?
47. Recommended phases should ideally cover:
   - Hadith source/book/chapter/reference normalization
   - Hadith reader parity
   - canonical themes/topics/lessons ownership
   - cross-domain connection model
   - Hadith search foundation
   - later search/discovery polish
48. What should explicitly not be changed yet to avoid regressions?

AUDIT INSTRUCTIONS
- Audit first before proposing implementation.
- Focus on actual repo ownership and real existing metadata.
- Be honest if something is not yet canonical enough.
- If something cannot be confirmed, name the exact file or gap preventing confirmation.

DELIVERABLE FORMAT
Provide:
1. Executive summary
2. Hadith reader readiness findings
3. Hadith theme/topic/lesson findings
4. Qur’an ↔ Hadith connection findings
5. Dua / Creation / Learn cross-domain connection findings
6. Connection-model readiness findings
7. Exact files involved
8. Gaps / blockers
9. Recommended phased plan
10. Regression watchouts

IMPORTANT
Do not implement yet.
At the very end, provide:
- a concise “build first” checklist
- a concise “do not break” checklist

Focus file areas first:
- lib/features/**hadith**
- lib/features/**dua**
- lib/features/**quran**
- Creation / stories / world / signs / learn content domains
- route files under lib/app/routes/**
- shared graph/reference/content-link/provider models anywhere in Learn
- local content assets / seeded data / editorial override paths
- any widget/card surfaces already showing related content across domains

===== END =====
