# Phase 7 — Add In-Reader Quran Search Highlighting, Floating Search Pill, and Next/Prev Match Navigation

```text
===== PHASE 7 — ADD IN-READER QURAN SEARCH HIGHLIGHTING, FLOATING SEARCH PILL, AND NEXT/PREV MATCH NAVIGATION =====

PRIMARY OBJECTIVE === MAKE THE QURAN READER SUPPORT QUICK IN-READER SEARCH WITH VISIBLE MATCH HIGHLIGHTING, RECENT SEARCHES, AND NEXT/PREVIOUS MATCH JUMPING

You are working in the existing Flutter codebase for Path of Nūr.

This is an implementation task, not an audit.
The repo already has:
	•	hardened exact-ayah navigation
	•	unified canonical Quran search ownership
	•	English/transliteration/Arabic search
	•	polished result snippets/highlighting/filters on /quran/search

Do not redesign the app.
Do not create a competing Quran search engine.
Do not break routing, exact ayah opening, playback, localization, knowledge search, or the current search stack.

CONTEXT
The user can now search Qur’an content well from Home, Qur’an hub, Read Qur’an, and /quran/search.

The next step is to improve the in-reader experience itself:
	1.	when a user opens an ayah from search, the matched word/phrase should be highlighted inside the reader
	2.	the reader should have a small floating search pill above the bottom nav on the bottom right
	3.	the reader should let the user search within the Qur’an reader and jump to the next/previous ayah containing that searched word/phrase
	4.	the reader should show recent in-reader searches

GOAL
Add a production-ready in-reader search layer to the Qur’an reader that:
	•	highlights the active search term in the opened ayah(s)
	•	provides a compact floating search pill entry point
	•	supports recent reader searches
	•	supports next/previous matching ayah navigation
	•	preserves the current exact-ayah navigation and playback behavior

IMPORTANT SCOPE RULE
For this phase, prefer a tight and safe V1:
	•	default the in-reader search scope to the current surah
	•	do not overbuild a full global Quran search UI inside the reader
	•	reuse the existing canonical normalization/search support where practical
	•	keep the reader fast and uncluttered

IMPLEMENT THE FOLLOWING

A. HIGHLIGHT SEARCH TERM INSIDE THE READER
	•	When the reader is opened from a search result, preserve enough query/match context so the matched word/phrase can be highlighted inside the reader.
	•	Highlight should work for:
	•	translation matches
	•	transliteration matches if displayed in the reader
	•	Arabic matches if displayed in the reader
	•	Keep highlighting subtle, readable, and visually consistent with the existing theme.
	•	Do not over-style or clutter the verse presentation.
	•	If exact-range highlighting is not practical in every case, implement the strongest deterministic version that is safe and maintainable.

B. ADD A FLOATING SEARCH PILL TO THE QURAN READER
	•	Add a small floating search pill at the bottom right above the bottom nav in the Qur’an reader.
	•	Keep it compact and aligned with the current app design language.
	•	It should not become a large toolbar or intrusive overlay.
	•	It should feel like a quick-access action for searching inside the reader.

C. ADD AN IN-READER SEARCH PANEL / SHEET
	•	Tapping the floating search pill should open a lightweight search surface within the reader, such as a bottom sheet, modal panel, or similarly small reader-aligned interaction.
	•	The panel should allow:
	•	entering a query
	•	showing recent in-reader search terms
	•	re-running a recent search
	•	clearing the current query when needed
	•	Keep this focused and lightweight.

D. SUPPORT CURRENT-SURAH SEARCH
	•	For this phase, default in-reader search to the current surah only.
	•	Reuse the shared normalization/search support where practical so matching behavior stays consistent with the broader Quran search stack.
	•	The current-surah in-reader search should support literal matching for:
	•	translation
	•	transliteration if available locally
	•	Arabic
depending on which fields are already safely available in the reader state.

E. ADD NEXT / PREVIOUS MATCH NAVIGATION
	•	When a search query is active in the reader, provide controls to jump to:
	•	previous matching ayah
	•	next matching ayah
	•	Show current position information when practical, such as:
	•	1 of 4
	•	Jumping to next/previous should:
	•	scroll to the matching ayah
	•	keep the active search highlight visible
	•	avoid fighting with playback or follow-playback behavior
	•	Keep the implementation deterministic and bounded.

F. PRESERVE SEARCH CONTEXT FROM /quran/search
	•	When a user enters the reader from the canonical Qur’an search flow, preserve the query context so:
	•	the first opened ayah highlights the searched term
	•	the in-reader search pill/panel can reflect the active query
	•	Keep the current exact-ayāh route ownership intact.
	•	Do not break the existing route contract; extend it safely if needed.

G. ADD RECENT IN-READER SEARCHES
	•	Add lightweight recent search memory for the Qur’an reader search panel.
	•	Keep it local and simple.
	•	Show recent reader search terms in the reader search surface.
	•	Allow tap-to-run.
	•	Allow clearing or dismissing as appropriate.
	•	Do not overbuild sync/cloud/history complexity.

H. KEEP READER PERFORMANCE SAFE
	•	Do not let search highlighting or next/prev navigation destabilize reader startup.
	•	Do not block ayah rendering on search state.
	•	Do not reintroduce any issue where exact ayah landing fails.
	•	Keep playback/follow-playback behavior safe.

I. KEEP CANONICAL OWNERSHIP CLEAN
	•	Reuse the existing canonical normalization and search support where practical.
	•	Do not create a second unrelated search engine just for the reader.
	•	It is acceptable to add a reader-scoped search helper/controller if needed, but it must remain aligned with the canonical search rules and result matching approach.

J. TESTS + VALIDATION
Add or update focused tests for:
	•	search query context survives handoff from /quran/search into the reader
	•	active query highlighting appears in the reader
	•	current-surah in-reader search finds expected ayahs
	•	next/previous match navigation lands on the expected ayah
	•	recent reader searches are stored and shown correctly
	•	floating search pill appears only where appropriate
	•	exact ayah opening remains correct
	•	playback / follow-playback behavior is not broken

K. DO NOT BREAK
	•	quran_repository.dart canonical search ownership
	•	quran_navigation.dart
	•	canonical /quran/surah/:surahNumber route
	•	exact ayah landing fixes
	•	/quran/search
	•	/quran/knowledge-search
	•	playback
	•	localization
	•	reader startup reliability
	•	existing English/transliteration/Arabic search behavior

L. KEEP THE CHANGESET TIGHT
	•	Do not redesign the whole Qur’an reader.
	•	Do not add full global Qur’an search UI inside the reader in this phase.
	•	Do not start morphology/root search here.
	•	Focus only on reader-scoped search usability:
	•	highlight active match
	•	floating pill
	•	recent searches
	•	next/prev matching ayah navigation

DELIVERABLES
After implementing, provide:
	1.	Executive summary
	2.	Files changed
	3.	How search context is preserved into the reader
	4.	How in-reader highlighting works
	5.	How the floating search pill works
	6.	How the reader search panel works
	7.	How current-surah matching works
	8.	How next/previous match navigation works
	9.	How recent in-reader searches are stored/shown
	10.	Validation notes
	11.	Analyzer results
	12.	Test results
	13.	Any follow-up notes for a future “search whole Qur’an from inside reader” phase

At the very end, do a concise Codex audit summary so I can review the implementation cleanly.

===== END =====
```
