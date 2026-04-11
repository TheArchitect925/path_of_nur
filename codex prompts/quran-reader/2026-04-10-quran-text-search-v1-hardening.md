===== PHASE 2 — HARDEN V1 QURAN TEXT SEARCH =====

PRIMARY OBJECTIVE === TURN THE EXISTING QURAN SEARCH INTO A CLEAN, PRODUCTION-READY V1 LOCAL TEXT SEARCH USING THE CURRENT REPO ARCHITECTURE

You are working in the existing Flutter codebase for Path of Nūr.

This is an implementation task, not an audit.
The repo has already been audited.
Phase 1 exact-ayah navigation reliability has already been fixed.
Do not redesign the UI.
Do not create a parallel Quran search system.
Do not break reader routing, exact ayah opening, playback, localization, knowledge search, or current discovery flows.

CONTEXT
The audit confirmed:
	•	the repo already has a real Quran search surface at /quran/search
	•	quran_repository.dart already owns real full-Quran text search behavior
	•	the architecture is hybrid: core Arabic + active translation are local through package:quran
	•	transliteration exists but is remote-first and not yet first-class deterministic bundled local data
	•	/quran/knowledge-search is a separate discovery surface and should remain separate
	•	exact ayah opening is now reliable enough to support search result jumps

GOAL
Harden V1 Quran text search into a clean production-ready local search for:
	1.	English translation word search
	2.	English translation phrase / sentence search
	3.	Surah-name search
while preserving the current canonical reader jump path.

DO NOT try to fully productionize transliteration indexing in this phase unless there is an extremely safe existing local path already in the repo.
Treat transliteration as secondary/non-blocking in this phase.

IMPLEMENT THE FOLLOWING

A. KEEP CANONICAL OWNERSHIP CLEAN
	•	Keep quran_repository.dart as the canonical text-search owner.
	•	Keep /quran/search as the canonical Quran text-search surface.
	•	Do not create a second competing text-search engine.
	•	Do not merge /quran/search with /quran/knowledge-search.
	•	Keep knowledge/discovery search separate.

B. INTRODUCE A SHARED NORMALIZATION LAYER
	•	Create or extract a shared normalization utility for Quran text search.
	•	Centralize normalization that is currently duplicated across files.
	•	For this phase, support at minimum:
	•	lowercase normalization
	•	whitespace cleanup
	•	punctuation cleanup
	•	stable phrase normalization for English search
	•	safe preparation hooks for future transliteration and Arabic normalization
	•	Reuse existing normalization logic where appropriate instead of duplicating again.

C. HARDEN THE LOCAL TEXT SEARCH INDEX
	•	Improve the current repository-backed search path into a clear local V1 index/search structure.
	•	Use the existing all-ayah access path already present in quran_repository.dart.
	•	Build or maintain a local normalized search index for:
	•	active English translation text
	•	surah names
	•	normalized full verse text for phrase search
	•	Keep V1 implementation lightweight and maintainable.
	•	A simple in-memory normalized index is acceptable for this phase if it is production-safe and clean.
	•	Do not introduce unnecessary SQLite/FTS complexity unless the current repo already has a very obvious drop-in path.

D. SUPPORT WORD + PHRASE SEARCH CLEANLY
	•	Ensure exact word search works reliably on normalized translation text.
	•	Ensure phrase / sentence search works as normalized substring search over stored normalized verse text.
	•	Preserve or improve result ranking so phrase/exact matches rank above weaker matches.
	•	Keep the ranking understandable and maintainable.
	•	Do not overbuild a complicated relevance engine yet.

E. CLEANLY SEPARATE TEXT HITS FROM DISCOVERY HITS
	•	Audit the current result mixing in /quran/search.
	•	For V1, make Quran text hits the primary canonical result set on the text-search surface.
	•	If discovery/theme/knowledge hits are still shown, make the separation explicit and non-confusing.
	•	Do not let knowledge/discovery results weaken the clarity of direct Quran verse search.

F. PRESERVE RESULT-TO-READER NAVIGATION
	•	Keep search result taps using the existing canonical reader path and shared verse-navigation helper.
	•	Do not bypass the exact-ayah navigation improvements from Phase 1.
	•	Preserve canonical /quran/surah/:surahNumber ownership and existing ayah query behavior.

G. TRANSLITERATION SCOPE FOR THIS PHASE
	•	Do not make transliteration a blocking dependency for V1 text search.
	•	If the current search surface already shows transliteration-aware results, keep it safe and non-breaking.
	•	But do not pretend transliteration is fully production-grade local indexed search yet if it still depends on remote-first data.
	•	If helpful, gently isolate current transliteration behavior so the English text-search path remains deterministic and offline-safe.

H. PERFORMANCE + OFFLINE SAFETY
	•	Keep the implementation offline-safe for English translation search.
	•	Avoid introducing reader startup or app startup regressions.
	•	Keep search responsive and maintainable.
	•	Prefer building/reusing the index lazily within the canonical repository path unless an existing preload path is clearly safer.

I. TESTS + VALIDATION
Add or update focused tests for:
	•	English word search returns expected ayah results
	•	English phrase search returns expected ayah results
	•	surah-name search still works
	•	stronger exact/phrase matches rank above weaker matches
	•	search results still open the exact ayah correctly through the canonical reader flow
	•	/quran/knowledge-search remains separate and unaffected

J. DO NOT BREAK
	•	quran_repository.dart as canonical search ownership
	•	/quran/search
	•	/quran/knowledge-search
	•	quran_navigation.dart
	•	canonical /quran/surah/:surahNumber route
	•	exact ayah opening improvements from Phase 1
	•	playback / localization / discovery flows

K. KEEP THE CHANGESET TIGHT
	•	Make the smallest production-ready change set that meaningfully hardens V1 Quran text search.
	•	Do not start full Arabic search in this phase.
	•	Do not start full production transliteration indexing in this phase unless the repo already makes it trivial and safe.
	•	Do not introduce unnecessary architecture churn.

DELIVERABLES
After implementing, provide:
	1.	Executive summary
	2.	Files changed
	3.	What was reused vs what was newly added
	4.	How normalization was centralized
	5.	How the V1 local text-search index works
	6.	How word search works
	7.	How phrase/sentence search works
	8.	How result ranking was improved
	9.	How text search and knowledge search were kept separate
	10.	Validation notes
	11.	Analyzer results
	12.	Test results
	13.	Follow-up notes for Phase 3 transliteration hardening

At the very end, do a concise Codex audit summary so I can review the implementation cleanly.

===== END =====
