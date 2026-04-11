===== PHASE 11 — ADD QURAN SEARCH TYPE SELECTOR (ALL / TEXT / THEME / TOPIC / SURAH) =====

PRIMARY OBJECTIVE === LET USERS CHOOSE WHAT KIND OF QURAN SEARCH THEY WANT WHILE KEEPING THE EXISTING SEARCH STACK CANONICAL, CLEAR, AND NON-CONFUSING

You are working in the existing Flutter codebase for Path of Nūr.

This is an implementation task, not an audit.
The repo already has:
	•	hardened exact-ayah navigation
	•	unified canonical Quran search ownership
	•	English/transliteration/Arabic text search
	•	polished snippets/highlighting/filters on /quran/search
	•	in-reader search with Current Surah / Whole Qur’an modes
	•	separate /quran/knowledge-search
	•	search memory / recents / suggestions scoped correctly

Do not redesign the app.
Do not create competing search engines.
Do not break routing, exact ayah opening, playback, localization, reader search, or the current unified Quran search stack.

CONTEXT
The current search is strong technically, but users still need a clearer way to tell the app what kind of search they mean.

We want a lightweight search-type selector on the main Quran search experience so users can choose between:
	•	All
	•	Text
	•	Theme
	•	Topic
	•	Surah

GOAL
Add a search-type selector to the dedicated Qur’an search experience that makes search intent clearer and routes users to the right search behavior without fragmenting ownership.

IMPORTANT PRODUCT RULES
	•	Default mode should be All.
	•	Text is the existing deterministic canonical Qur’an text search:
	•	translation
	•	transliteration
	•	Arabic
	•	surah names where already supported
	•	Theme and Topic should use the repo’s existing curated/knowledge/theme/reference systems where possible.
	•	Surah should focus on direct surah lookup behavior.
	•	/quran/knowledge-search must remain a separate surface and should not be merged away.
	•	This phase is about mode selection and routing clarity, not about building a brand-new search engine for each mode.

DESIGN RULES
	•	Keep one canonical search owner for text search.
	•	Keep the UI compact and understandable.
	•	Avoid clutter.
	•	Do not overload the reader search sheet in this phase.
	•	Implement the selector first on /quran/search.
	•	Keep All as the broadest mixed/federated result mode.
	•	Keep Text as the strongest literal search mode.

IMPLEMENT THE FOLLOWING

A. ADD A SEARCH TYPE SELECTOR TO /quran/search
	•	Add a compact search-type selector near the top of the dedicated Qur’an search page.
	•	Use these modes:
	•	All
	•	Text
	•	Theme
	•	Topic
	•	Surah
	•	Keep the control compact and visually aligned with the current search page.
	•	Default to All.

B. DEFINE MODE OWNERSHIP CLEARLY
Implement these mode behaviors:
	1.	ALL

	•	Show a mixed/federated result experience.
	•	Include the strongest relevant result groups from available sources, such as:
	•	text results
	•	theme hits
	•	topic/knowledge hits
	•	surah hits
	•	Keep grouping understandable and non-confusing.

	2.	TEXT

	•	Use the existing canonical Qur’an text search stack.
	•	This remains the deterministic literal search mode.
	•	It should cover:
	•	translation
	•	transliteration
	•	Arabic
	•	surah-name/surah-number matching where already supported by the current text engine

	3.	THEME

	•	Reuse the repo’s existing theme/discovery/ayah enrichment/search infrastructure where possible.
	•	Do not invent an entirely new theme engine if the repo already has theme-linked search/data.

	4.	TOPIC

	•	Reuse the existing topic/reference graph/knowledge-search-backed structures where possible.
	•	Keep it distinct from pure text search.

	5.	SURAH

	•	Focus on direct surah lookup by:
	•	surah name
	•	surah number
	•	common surah search patterns
	•	Keep this simple and fast.

C. KEEP /quran/knowledge-search SEPARATE
	•	Do not merge away /quran/knowledge-search.
	•	This phase may reuse its underlying data sources where appropriate, but /quran/search should remain the main surface for the new mode selector.
	•	Keep route ownership clear.

D. ROUTE QUERY + MODE CLEANLY
	•	Preserve the search query while switching modes.
	•	Preserve mode in the page state and route if appropriate.
	•	If routing is updated, keep it simple and safe, for example with a query param such as type=....
	•	Do not break existing q, field, or exact-ayah result behavior.

E. KEEP RESULT NAVIGATION CORRECT
	•	Text-result taps must still use the shared navigation helper and exact-ayāh route path.
	•	Theme/topic/topic-linked ayah results must also keep safe navigation behavior where applicable.
	•	Do not weaken exact-ayāh landing.

F. KEEP RESULT PRESENTATION CLEAR
	•	In All, grouped sections are acceptable and preferred.
	•	In Text, show text results only.
	•	In Theme, show theme-driven results only.
	•	In Topic, show topic-driven results only.
	•	In Surah, show surah lookup results only.
	•	Use existing result presentation components where practical.
	•	Do not redesign everything from scratch.

G. KEEP THE CHANGESET TIGHT
	•	Do not redesign the full search page beyond what is needed to add the selector and mode-aware result routing.
	•	Do not overload the reader search sheet with this selector in this phase.
	•	Do not introduce morphology/root search here.
	•	Do not add ML/personalization in this phase.

H. TESTS + VALIDATION
Add or update focused tests for:
	•	default mode is All
	•	switching modes preserves query
	•	Text mode still uses canonical text search
	•	Theme mode uses the intended theme/discovery path
	•	Topic mode uses the intended topic/reference path
	•	Surah mode returns direct surah matches
	•	route/query mode preservation works if route state is updated
	•	exact-ayāh navigation still works from text results
	•	/quran/knowledge-search remains separate and unaffected

I. DO NOT BREAK
	•	quran_repository.dart canonical text-search ownership
	•	quran_navigation.dart
	•	canonical /quran/surah/:surahNumber route
	•	exact ayah landing fixes
	•	/quran/search
	•	/quran/knowledge-search
	•	playback
	•	localization
	•	reader search stability
	•	existing search memory / recents / suggestions on /quran/search

J. LOCALIZATION
Add translation-ready labels for:
	•	All
	•	Text
	•	Theme
	•	Topic
	•	Surah
Keep naming concise and user-friendly.

DELIVERABLES
After implementing, provide:
	1.	Executive summary
	2.	Files changed
	3.	How the mode selector works
	4.	How each mode is mapped to existing repo-owned search behavior
	5.	How query/mode preservation works
	6.	How result navigation remains safe
	7.	Validation notes
	8.	Analyzer results
	9.	Test results
	10.	Any follow-up notes for future refinements like remembering preferred mode or extending mode selection to reader search

At the very end, do a concise Codex audit summary and explicitly confirm that:
	•	/quran/search now supports All / Text / Theme / Topic / Surah
	•	Text still uses the canonical text search stack
	•	/quran/knowledge-search remains separate

===== END =====
