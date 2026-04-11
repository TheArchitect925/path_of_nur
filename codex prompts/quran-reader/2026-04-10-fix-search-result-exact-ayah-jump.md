# Phase 3.5 — Fix Search Result To Exact Ayah Jump In Quran Reader

PRIMARY OBJECTIVE === MAKE QURAN SEARCH RESULT TAPS LAND ON THE EXACT TARGET AYAH, NOT JUST THE TOP OF THE SURAH

You are working in the existing Flutter codebase for Path of Nūr.

This is an implementation task with focused audit-first validation inside the task.
Do not redesign the UI.
Do not rewrite the Quran reader architecture unnecessarily.
Do not break playback, localization, search unification, routing, or knowledge search.

KNOWN LIVE ISSUE
Even after the prior hardening work, tapping a Quran search result still opens the correct surah but lands at the top of the surah instead of the exact target ayah.

This means the system is still not reliably completing the final route-to-rendered-ayah jump.

GOAL
Fix the exact remaining issue so that tapping a Quran search result always lands the user on the correct ayah in the reader.

IMPORTANT
This task is specifically about the real end-to-end runtime path from:
search result tap
→ shared navigation helper / route
→ reader route state
→ ayah load
→ ayah widget readiness
→ final visible scroll position

Do not stop at confirming that the route contains ayah.
The bug is only fixed when the visible reader actually lands on the correct ayah.

IMPLEMENT THE FOLLOWING

A. TRACE THE ACTUAL SEARCH RESULT TAP PATH
	•	Trace the exact tap path used by:
	•	/quran/search
	•	homepage compact Quran results
	•	Quran hub search results
	•	Read Quran search results
	•	Confirm whether every one of these paths truly uses the same shared navigation helper and passes the same ayah argument.
	•	If any path still manually builds routes or drops arguments, fix it.

B. VERIFY RUNTIME ROUTE STATE ARRIVAL
	•	Confirm the reader receives the expected:
	•	surah number
	•	ayah number
	•	any endAyah / playback params if present
	•	Add temporary structured diagnostics if helpful during implementation, then remove or keep only safe minimal logging if appropriate.
	•	Do not guess. Confirm the live execution path.

C. AUDIT FINAL SCROLL EXECUTION IN THE READER
	•	Audit the exact code that performs the initial ayah jump in quran_reader_page.dart.
	•	Confirm:
	•	target ayah key creation
	•	target ayah widget presence
	•	target render object readiness
	•	correct scrollable ancestor
	•	no competing second scroll/reset after the initial jump
	•	Confirm whether:
	•	the jump is happening too early
	•	ensureVisible is targeting the wrong context
	•	the scroll offset math is incorrect
	•	a rebuild or playback startup is resetting scroll afterward
	•	the keyed ayah map does not match the final rendered ayah card structure

D. MAKE THE FINAL JUMP DETERMINISTIC
	•	Fix the reader so the initial route-targeted ayah jump only completes when the target ayah widget is truly ready inside the visible scrollable.
	•	If needed, use a bounded staged readiness check that waits for:
	1.	ayahs loaded
	2.	keys registered
	3.	target context mounted
	4.	target render object attached
	5.	correct scrollable available
	•	Then perform the jump.
	•	Ensure no later startup behavior pulls the user back toward the top.

E. VALIDATE THE VISUAL RESULT, NOT JUST THE ARGUMENTS
	•	The fix is only complete if the actual visible reader lands on the target ayah.
	•	Validate this for at minimum:
	•	/quran/search result tap
	•	homepage compact Quran result tap
	•	Quran hub result tap
	•	Read Quran result tap
	•	If one shared helper is used by all of them, still validate all four surfaces.

F. ADD HIGH-VALUE TEST COVERAGE
Add or update tests as realistically as the repo allows.
At minimum:
	•	route integrity tests remain passing
	•	add focused coverage for search-result route handoff
	•	add the strongest practical test coverage possible for target ayah jump readiness without introducing brittle test design
If a full widget/integration test is the right way to prove the final visible jump, add it if practical and safe.

G. DO NOT BREAK
	•	canonical /quran/surah/:surahNumber route
	•	ayah / endAyah route contract
	•	quran_navigation.dart
	•	unified Quran search ownership
	•	/quran/search
	•	homepage / Quran hub / Read Quran compact result behavior
	•	playback and follow-playback behavior
	•	/quran/knowledge-search
	•	localization
	•	existing reader UI

H. KEEP THE CHANGESET TIGHT
	•	Do not begin transliteration work in this task.
	•	Do not begin Arabic search in this task.
	•	Focus only on making search-result-to-reader exact ayah jumps actually work.

DELIVERABLES
After implementing, provide:
	1.	Executive summary
	2.	Exact root cause of why the page was still landing at the top
	3.	Files changed
	4.	Whether all search entry points were truly using the same navigation path
	5.	What was wrong in the reader jump lifecycle
	6.	How the final jump was made deterministic
	7.	Validation notes for:
	•	/quran/search
	•	homepage search
	•	Quran hub search
	•	Read Quran search
	8.	Analyzer results
	9.	Test results
	10.	Any remaining risk notes

At the very end, include a concise Codex audit summary and explicitly state whether the visible reader now lands on the exact ayah.
