# Hotfix — Fix Quran Reader Search Pill Overlay Crash

```text
===== HOTFIX — FIX QURAN READER SEARCH PILL OVERLAY CRASH AND STABILIZE SEARCH/HIGHLIGHT UI =====

PRIMARY OBJECTIVE === FIX THE CURRENT MATERIAL OVERLAY ASSERTION AND STABILIZE THE QURAN READER SEARCH PILL / SEARCH PANEL FLOW

You are working in the existing Flutter codebase for Path of Nūr.

This is a focused hotfix task.
Do not redesign the UI.
Do not rewrite the Qur’an reader architecture unnecessarily.
Do not change the core search engine behavior unless required for stability.
Do not break exact-ayāh landing, playback, localization, or the unified Quran search stack.

KNOWN RUNTIME ERROR
The terminal is repeatedly throwing:

'package:flutter/src/material/material.dart': Failed assertion: line 768 pos 12: 'referenceBox.attached': is not true.

This strongly indicates that a Material overlay/menu/sheet anchor is being opened or positioned from a widget/render box that is no longer attached to the tree.

CONTEXT
The likely area is the newly added in-reader search flow:
	•	floating search pill
	•	search sheet/panel opening
	•	search/highlight updates
	•	next/prev ayah jumps
	•	reader rebuilds during active search UI

GOAL
Find and fix the actual UI lifecycle issue causing the detached reference box assertion, and stabilize the reader search/highlight interaction.

IMPLEMENT THE FOLLOWING

A. AUDIT THE SEARCH PILL OPENING PATH
	•	Find exactly how the floating reader search pill opens the search UI.
	•	Inspect whether it uses:
	•	showMenu
	•	PopupMenuButton
	•	MenuAnchor
	•	anchored overlay positioning
	•	GlobalKey.currentContext
	•	findRenderObject()
	•	or similar reference-box-dependent Material APIs
	•	Confirm whether the pill’s own widget context/render box is being used as the overlay reference.

B. FIX OVERLAY OPENING TO USE A STABLE CONTEXT
	•	Change the search sheet/panel opening path so it uses a stable reader-page-owned context/state rather than a transient floating-pill context.
	•	Prefer a stable page-owned bottom sheet/dialog path over an anchored popup if that is the safest fix.
	•	Do not rely on a render box that may detach during reader rebuilds.

C. GUARD ALL RENDER-BOX / CONTEXT USAGE
	•	If any reference-box-based logic remains, guard it strictly:
	•	mounted
	•	non-null context
	•	render object is RenderBox
	•	renderBox.attached == true
	•	Do not attempt to open or position overlays from detached widgets.

D. PREVENT SEARCH UI FROM FIGHTING REBUILDS
	•	Audit whether search/highlight updates, next/prev jumps, or route/query updates rebuild the pill while the search UI is being opened.
	•	Ensure the search UI opening path is not triggered during an unsafe lifecycle moment.
	•	If needed, defer opening via a safe post-frame callback from a stable mounted reader state.

E. STABILIZE SEARCH/HIGHLIGHT INTERACTION
	•	Confirm that active search highlighting does not repeatedly trigger unsafe overlay reopening or state churn.
	•	Ensure next/prev search navigation does not destabilize the search UI or recreate the pill reference during the open action.
	•	Keep the in-reader search UX intact.

F. VALIDATE THE FIX
Validate at minimum:
	•	tapping the floating search pill opens the search UI without assertion spam
	•	entering a query updates highlighting safely
	•	next/prev matching ayah navigation still works
	•	exact ayah opening from external /quran/search still works
	•	the floating pill remains stable after search state changes
	•	no repeated referenceBox.attached assertion remains

G. DO NOT BREAK
	•	quran_navigation.dart
	•	canonical /quran/surah/:surahNumber route
	•	exact ayah landing fixes
	•	in-reader search highlighting
	•	recent in-reader searches
	•	next/prev matching ayah navigation
	•	playback / follow-playback behavior
	•	/quran/search
	•	/quran/knowledge-search
	•	localization

H. KEEP THE CHANGESET TIGHT
	•	Fix the crash and the buggy search/highlight UI behavior only.
	•	Do not redesign the search pill UX unless required for stability.
	•	Prefer the smallest production-ready fix.

DELIVERABLES
After implementing, provide:
	1.	Executive summary
	2.	Exact root cause
	3.	Files changed
	4.	What overlay/opening path was unsafe
	5.	How it was stabilized
	6.	Validation notes
	7.	Analyzer results
	8.	Test results
	9.	Any remaining risk notes

At the very end, include a concise Codex audit summary and explicitly confirm whether the referenceBox.attached assertion is gone.

===== END =====
```
