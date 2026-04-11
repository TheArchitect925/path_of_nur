# Phase 4 — Harden Quran Transliteration Search Into A Local Deterministic Shared Search Field

PRIMARY OBJECTIVE === MAKE QURAN TRANSLITERATION SEARCH FULLY LOCAL, DETERMINISTIC, OFFLINE-SAFE, AND UNIFIED WITH THE EXISTING CANONICAL QURAN SEARCH STACK

You are working in the existing Flutter codebase for Path of Nūr.

This is an implementation task, not an audit.
The repo already has:
	•	hardened exact-ayah navigation
	•	hardened V1 Quran text search
	•	unified Quran text search across homepage + Quran surfaces
	•	reader exact-ayāh visible landing fixes
Do not redesign the UI.
Do not create a competing Quran search engine.
Do not break routing, exact ayah opening, playback, localization, knowledge search, or existing discovery flows.

CONTEXT
The current search stack is already strong for local English translation search.
However, transliteration is still weaker because it has depended on a remote-first + cache path and is not yet a first-class deterministic local indexed field.

We now want transliteration search to become:
	•	local
	•	deterministic
	•	offline-safe
	•	normalized
	•	part of the same canonical Quran search ownership

GOAL
Add production-ready transliteration search support to the existing canonical Quran search stack so users can search transliterated Quran terms consistently across:
	•	homepage search
	•	Quran hub search
	•	Read Quran search
	•	/quran/search

EXAMPLES THAT SHOULD BE HANDLED WELL
	•	rahman
	•	ar-rahman
	•	al rahman
	•	rahmaan
	•	musa
	•	moosa
	•	ibrahim
	•	ibraheem
	•	yasin
	•	ya seen

DESIGN RULES
	•	Keep one canonical Quran search owner.
	•	Keep one unified result model.
	•	Keep one exact-ayah navigation path.
	•	Keep /quran/search as the canonical Quran text/transliteration search surface.
	•	Keep /quran/knowledge-search separate.
	•	Do not make transliteration a network dependency for search quality.
	•	Do not block reader rendering on transliteration loading.

IMPLEMENT THE FOLLOWING

A. INTRODUCE A DETERMINISTIC LOCAL TRANSLITERATION DATA SOURCE
	•	Audit the safest existing repo path for transliteration data ownership.
	•	Add a local deterministic transliteration dataset for Quran verses if one is not already bundled in a production-safe form.
	•	Ensure transliteration for verse search no longer depends on remote-first fetching for correctness.
	•	Keep the solution maintainable and versionable inside the repo.
	•	Do not break any existing transliteration display flows that already rely on cached data unless you are safely upgrading them.

B. EXTEND THE CANONICAL SEARCH INDEX
	•	Extend the existing canonical Quran search index under the current repository ownership.
	•	Add transliteration as a first-class indexed search field.
	•	Keep English translation, surah-name search, and transliteration all under the same canonical search ownership.
	•	Do not create a parallel transliteration search service.

C. ADD A SHARED TRANSLITERATION NORMALIZATION LAYER
	•	Extend the shared normalization path so transliteration variants normalize consistently.
	•	Handle at minimum:
	•	lowercase normalization
	•	punctuation cleanup
	•	whitespace cleanup
	•	hyphen/space normalization
	•	long-vowel simplification where appropriate
	•	article-prefix smoothing where appropriate (al, ar, etc.) when safe
	•	The goal is practical user-friendly search, not linguistically perfect transliteration science.
	•	Keep normalization understandable and maintainable.

D. IMPROVE RANKING FOR TRANSLITERATION QUERIES
	•	Ensure close transliteration matches rank above weaker fuzzy/substring matches.
	•	Preserve understandable ranking behavior.
	•	Do not overbuild a heavy fuzzy search engine unless there is already an obviously safe lightweight path in the repo.
	•	Make strong direct normalized matches feel reliable.

E. KEEP SEARCH SURFACES UNIFIED
	•	Homepage compact Quran results must be able to show transliteration-backed verse hits through the same canonical search path.
	•	Quran hub compact search must do the same.
	•	Read Quran search must do the same.
	•	/quran/search must continue to be the full canonical surface.
	•	/quran/knowledge-search must remain separate and unaffected.

F. KEEP RESULT NAVIGATION UNCHANGED
	•	Search result taps must still use the shared navigation helper and canonical reader route.
	•	Do not bypass the exact-ayah landing fixes.
	•	Do not reintroduce any dependency that causes search results to open at the top of the surah.

G. KEEP READER STARTUP SAFE
	•	Transliteration availability must not block the reader’s initial verse rendering.
	•	Any transliteration loading/display path must remain non-blocking for initial exact-ayah landing.
	•	Preserve the reader startup reliability work already completed.

H. TESTS + VALIDATION
Add or update focused tests for:
	•	transliteration query returns expected ayahs
	•	normalized variant queries map to the same or similar strong results
	•	rahman / ar-rahman / al rahman / rahmaan
	•	musa / moosa
	•	ibrahim / ibraheem
	•	homepage search can surface transliteration-backed Quran results
	•	Quran hub search can surface transliteration-backed Quran results
	•	Read Quran search can surface transliteration-backed Quran results
	•	/quran/search still works with transliteration queries
	•	/quran/knowledge-search remains separate and unaffected
	•	result taps still open the exact ayah correctly

I. DO NOT BREAK
	•	quran_repository.dart canonical search ownership
	•	quran_navigation.dart
	•	canonical /quran/surah/:surahNumber route
	•	exact ayah landing fixes
	•	homepage/Quran hub/Read Quran compact search behavior
	•	/quran/search
	•	/quran/knowledge-search
	•	playback
	•	localization
	•	reader startup reliability

J. KEEP THE CHANGESET TIGHT
	•	Do not start Arabic search in this phase.
	•	Do not redesign the search UI unless a tiny safe improvement is necessary.
	•	Focus only on making transliteration search production-ready, local, deterministic, and unified.
