===== PHASE 3 — UNIFY QURAN SEARCH ACROSS ALL QURAN ENTRY POINTS + HOMEPAGE =====

PRIMARY OBJECTIVE === MAKE QURAN TEXT SEARCH A SINGLE SHARED CAPABILITY USED CONSISTENTLY ACROSS HOMEPAGE AND ALL QURAN SEARCH ENTRY SURFACES

You are working in the existing Flutter codebase for Path of Nūr.

This is an implementation task, not an audit.
The repo already has:
	•	hardened exact-ayah navigation
	•	hardened V1 Quran text search
Do not redesign the app unnecessarily.
Do not create competing Quran search engines.
Do not break routing, exact ayah opening, playback, localization, knowledge search, or existing discovery flows.

CONTEXT
The app currently has multiple search entry points related to Quran usage, including:
	•	homepage search
	•	Holy Quran main page search
	•	Read Quran page search
	•	dedicated /quran/search

These should not behave like disconnected search systems.
Users should be able to search Quran words and phrases consistently from all Quran-related search entry points, plus from homepage search.

GOAL
Unify Quran search so that all Quran-related search entry points and homepage search can surface the same canonical Quran text-search results using the existing hardened search stack.

DESIGN RULES
	•	Keep one canonical Quran text-search owner.
	•	Keep one normalization path.
	•	Keep one index/ranking path.
	•	Keep one exact-ayah navigation path.
	•	Do not merge Quran text search with knowledge search.
	•	Do not duplicate search logic across pages.

IMPLEMENT THE FOLLOWING

A. IDENTIFY ALL RELEVANT SEARCH ENTRY POINTS
Audit and update all existing Quran-related search entry points, including at minimum:
	•	homepage search
	•	Holy Quran landing/main page search
	•	Read Quran page search
	•	/quran/search
Also check for any other Quran-specific search boxes or search launchers already in the repo.

B. MAKE QURAN TEXT SEARCH CANONICAL EVERYWHERE
	•	Ensure all Quran-related search entry points use the same canonical Quran text-search path already established in the repo.
	•	Do not create alternate search logic per page.
	•	Reuse the existing canonical repository/provider search ownership.

C. HOMEPAGE SEARCH INTEGRATION
	•	Update homepage search so users can find Quran verses there too.
	•	Homepage search should be able to surface Quran word and phrase matches using the same canonical Quran search logic.
	•	Keep homepage search usable and not overloaded.
	•	It is acceptable for homepage search to show a compact Quran results section with a “see all Quran results” action that routes into the dedicated Quran search page with the query preserved.

D. QURAN PAGE SEARCH INTEGRATION
	•	Ensure Holy Quran landing/main page and Read Quran page search entry points both support the same Quran word/phrase search capability.
	•	If those pages currently use stubs, narrow search, or only route to limited filters, replace that behavior with the canonical Quran text search path.
	•	Preserve page-specific UX where appropriate, but unify the actual search logic underneath.

E. KEEP DEDICATED SEARCH SURFACES SEPARATE BY ROLE
	•	/quran/search remains the canonical Quran text-search surface.
	•	/quran/knowledge-search remains the separate knowledge/discovery surface.
	•	Do not merge or blur these two responsibilities.

F. KEEP RESULT MODELS + NAVIGATION CONSISTENT
	•	Reuse the shared result model and ranking behavior from the current hardened Quran text-search path.
	•	Preserve result taps opening the exact ayah through the shared navigation helper and canonical reader route.
	•	Do not bypass Phase 1 exact-ayah navigation hardening.

G. QUERY HANDOFF / PREFILL
	•	Where a lighter search box exists on homepage or other Quran pages, it is acceptable to:
	•	show a compact result preview inline
	•	and/or push into /quran/search with the query prefilled
	•	Preserve the user’s typed query across the handoff.

H. KEEP THE UI COHESIVE
	•	Do not redesign the whole search UX unless necessary.
	•	Make the smallest production-ready changes needed to unify behavior.
	•	Preserve existing app styling, layout language, and localization behavior.

I. TESTS + VALIDATION
Add or update focused tests for:
	•	homepage search can surface Quran text results
	•	Quran landing/main page search uses canonical Quran text search
	•	Read Quran page search uses canonical Quran text search
	•	/quran/search still works as canonical text-search surface
	•	/quran/knowledge-search remains separate and unaffected
	•	result tap from all updated entry points still opens the exact ayah correctly

J. DO NOT BREAK
	•	quran_repository.dart canonical search ownership
	•	quran_navigation.dart
	•	canonical /quran/surah/:surahNumber route
	•	exact ayah opening improvements
	•	/quran/search
	•	/quran/knowledge-search
	•	playback
	•	localization
	•	existing discovery flows

K. KEEP THE CHANGESET TIGHT
	•	Do not start transliteration hardening in this phase unless a tiny safe reuse falls out naturally.
	•	Do not start Arabic search in this phase.
	•	Focus only on unifying Quran text search entry points.

DELIVERABLES
After implementing, provide:
	1.	Executive summary
	2.	All search entry points updated
	3.	Files changed
	4.	How canonical Quran search ownership was reused
	5.	How homepage search now surfaces Quran results
	6.	How Quran landing/main page search was unified
	7.	How Read Quran page search was unified
	8.	How /quran/search and /quran/knowledge-search stayed clearly separate
	9.	Validation notes
	10.	Analyzer results
	11.	Test results
	12.	Any follow-up notes

At the very end, do a concise Codex audit summary so I can review the implementation cleanly.

===== END =====
