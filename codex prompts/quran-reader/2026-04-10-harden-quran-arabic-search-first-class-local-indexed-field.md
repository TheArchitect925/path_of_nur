# Phase 5 — Harden Quran Arabic Search As A First-Class Local Indexed Field

PRIMARY OBJECTIVE === MAKE QURAN ARABIC SEARCH FULLY LOCAL, DETERMINISTIC, OFFLINE-SAFE, AND UNIFIED WITH THE EXISTING CANONICAL QURAN SEARCH STACK

You are working in the existing Flutter codebase for Path of Nūr.

This is an implementation task, not an audit.
The repo already has:
- hardened exact-ayah navigation
- hardened V1 Quran text search
- unified Quran search across homepage + Quran surfaces
- reader exact-ayāh visible landing fixes
- local deterministic transliteration search
Do not redesign the UI.
Do not create a competing Quran search engine.
Do not break routing, exact ayah opening, playback, localization, knowledge search, or existing discovery flows.

CONTEXT
The current search stack already supports:
- English translation search
- phrase/sentence search
- local transliteration search
- unified results across Home, Qur’an hub, Read Qur’an, and /quran/search

The next step is to make Arabic search a first-class field in that same canonical search system.

Arabic search must be:
- local
- deterministic
- offline-safe
- normalized
- part of the same canonical Quran search ownership
- clearly separated from transliteration logic rather than hacked into it

GOAL
Add production-ready Quran Arabic search support to the existing canonical search stack so users can search Arabic words and phrases consistently across:
- homepage search
- Quran hub search
- Read Quran search
- /quran/search

EXAMPLES THAT SHOULD BE HANDLED WELL
- الرحمن
- رحمن
- الله
- موسى
- عيسى
- إبراهيم
- اهدنا
- الصراط المستقيم
- بسم الله
- يوم الدين

DESIGN RULES
- Keep one canonical Quran search owner.
- Keep one unified result model.
- Keep one exact-ayah navigation path.
- Keep /quran/search as the canonical Quran text search surface.
- Keep /quran/knowledge-search separate.
- Do not make Arabic search a network dependency.
- Do not block reader rendering on Arabic search work.
- Do not overload transliteration ranking logic to fake Arabic search.
- Arabic search must be its own field scorer/index path inside the same canonical repository owner.

IMPLEMENT THE FOLLOWING

A. EXTEND THE CANONICAL SEARCH INDEX WITH ARABIC AS A FIRST-CLASS FIELD
- Extend the existing canonical Quran search index under the current repository ownership.
- Add Arabic text as an indexed search field alongside:
  - English translation
  - surah names
  - transliteration
- Keep one search owner: QuranRepository.search(...).
- Do not create a separate Arabic-only search service.

B. ADD A SHARED ARABIC NORMALIZATION LAYER
- Extend the shared search normalization path so Arabic queries normalize consistently.
- Handle at minimum:
  - diacritic/tashkeel removal
  - tatweel removal
  - hamza/alif variant normalization where safe
  - ya/alif maqsura normalization where safe
  - taa marbuta normalization where safe if helpful
  - whitespace cleanup
  - punctuation cleanup
- Keep the rules practical and maintainable.
- The goal is user-friendly Arabic search, not building a full Arabic NLP engine.

C. SUPPORT ARABIC WORD + PHRASE SEARCH
- Ensure Arabic single-word searches work reliably on normalized Arabic verse text.
- Ensure Arabic phrase searches work as normalized substring search over stored normalized Arabic verse text.
- Preserve understandable and maintainable V1 behavior.
- Do not overbuild morphology/root search yet unless there is already a trivially safe repo utility.

D. IMPROVE RANKING FOR ARABIC QUERIES
- Ensure exact normalized Arabic field matches rank highest.
- Ensure phrase-start / phrase-contains matches score strongly.
- Ensure exact token-aware Arabic matches score above weak partial matches.
- Keep ranking understandable and maintainable.
- Do not add unnecessary heavyweight search infrastructure in this phase.

E. KEEP SEARCH SURFACES UNIFIED
- Homepage compact Quran results must support Arabic queries through the same canonical search path.
- Quran hub search must support Arabic queries through the same canonical search path.
- Read Quran search must support Arabic queries through the same canonical search path.
- /quran/search must continue as the full canonical search surface.
- /quran/knowledge-search must remain separate and unaffected.

F. KEEP RESULT NAVIGATION UNCHANGED
- Search result taps must still use the shared navigation helper and canonical reader route.
- Do not bypass the exact-ayāh landing fixes.
- Do not reintroduce any dependency that causes search results to open at the top of the surah.

G. KEEP READER STARTUP SAFE
- Arabic indexing/search support must not interfere with reader startup.
- Do not add any blocking search-related data fetch to reader opening.
- Preserve the reader startup reliability work already completed.

H. TESTS + VALIDATION
Add or update focused tests for:
- Arabic query returns expected ayahs
- normalized Arabic variant queries still return the expected ayahs
- Arabic phrase queries return expected ayahs
- homepage search can surface Arabic-backed Quran results
- Quran hub search can surface Arabic-backed Quran results
- Read Quran search can surface Arabic-backed Quran results
- /quran/search still works for Arabic queries
- /quran/knowledge-search remains separate and unaffected
- result taps still open the exact ayah correctly

I. RESULT CLARITY
- If the current UI already has a safe place to indicate why a result matched, add light-touch support for Arabic match clarity only if trivial and non-disruptive.
- Do not redesign the result cards in this phase.
- Avoid copy churn unless absolutely necessary.

J. DO NOT BREAK
- quran_repository.dart canonical search ownership
- quran_navigation.dart
- canonical /quran/surah/:surahNumber route
- exact ayah landing fixes
- homepage/Quran hub/Read Quran compact search behavior
- /quran/search
- /quran/knowledge-search
- playback
- localization
- reader startup reliability
- transliteration search behavior already completed

K. KEEP THE CHANGESET TIGHT
- Do not redesign the search UI in this phase.
- Do not start advanced semantic/topic search here.
- Do not start morphology/root search unless the repo already makes it trivial and safe.
- Focus only on making Arabic search production-ready, local, deterministic, and unified.

DELIVERABLES
After implementing, provide:
1. Executive summary
2. Files changed
3. How Arabic normalization works
4. How the canonical search index was extended for Arabic
5. How Arabic word search works
6. How Arabic phrase search works
7. How Arabic ranking works
8. How unified search surfaces now support Arabic
9. Validation notes
10. Analyzer results
11. Test results
12. Any follow-up notes for future result highlighting / filters / morphology work

At the very end, do a concise Codex audit summary so I can review the implementation cleanly.
