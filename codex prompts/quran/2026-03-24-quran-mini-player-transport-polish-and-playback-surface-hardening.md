===== PHASE 5 PROMPT — MINI-PLAYER, TRANSPORT POLISH & PLAYBACK SURFACE HARDENING =====

PRIMARY OBJECTIVE === BUILDING MINI-PLAYER, TRANSPORT POLISH & PLAYBACK SURFACE HARDENING

You are working in the existing Flutter codebase for Path of Nūr.

This phase builds directly on top of the completed Qur’an playback stabilization, playback-state extraction, word-highlight coordinator, presentation mapping, and follow-mode/auto-scroll coordination passes.

Current known state after the latest passes:
- active ayah playback identity is normalized through shared playback state/controller layers
- pause/play drift and active ayah highlight drift were fixed
- reciter switching during active playback is now safe enough for production use
- word-highlight lifecycle is owned by a dedicated coordinator
- now-playing copy is presentation-owned
- follow-mode and auto-scroll lifecycle are no longer supposed to remain ad hoc page truth
- route-level harness coverage now exists and is improving

Main remaining product gaps:
- the playback surface still needs a cleaner persistent mini-player experience
- transport controls need stronger parity and consistency
- previous/next surah navigation needs better surfacing and safer behavior
- repeat controls are not yet first-class and clear
- playback continuity should feel more visible and trustworthy across reader and non-reader surfaces

Your task in this phase is to:
1. build or harden a real persistent Qur’an mini-player surface
2. polish transport controls and state consistency
3. expose previous/next ayah and previous/next surah behavior more clearly where appropriate
4. improve repeat/replay controls and their state handling
5. preserve all working playback, highlight, reciter, session, memorization, notes, bookmarks, download, and reader behavior
6. keep the architecture production-ready and additive

IMPORTANT:
This is not a rewrite.
This is not a redesign of the whole Qur’an experience.
This is a targeted playback-surface and transport-hardening phase.

CRITICAL SAFETY RULES
- Audit first before changing anything.
- Do not rebuild the Qur’an player from scratch.
- Do not remove/delete working logic for no reason.
- Preserve the existing playback/highlight/reciter fixes.
- Preserve the current controller/coordinator ownership model.
- Do not introduce a second competing source of truth for transport state.
- Keep changes additive, maintainable, and production-ready.
- At the very end, provide one consolidated audit summary.

==================================================
STEP 1 — AUDIT FIRST
==================================================

Before editing code, audit and summarize the current playback surfaces and transport behavior:

- what playback controls currently exist in the reader page
- whether any mini-player or persistent playback surface already exists
- what playback entry points exist outside the reader page
- how previous/next ayah is currently handled
- how previous/next surah is currently handled
- whether transport availability is already exposed through shared playback state
- how repeat/replay logic currently works
- whether repeat range, replay ayah, or surah replay exist in code but are weakly surfaced
- how background playback state is surfaced to the user
- how session continuity is surfaced outside the reader
- whether transport state, highlight state, and session state can still drift in any edge cases
- where the safest location is for a persistent mini-player surface in the existing app architecture

Then identify the safest additive implementation path.

Do not overbuild.
Do not redesign unrelated navigation or tabs.

==================================================
STEP 2 — DEFINE THE MINI-PLAYER TARGET
==================================================

Create or refine a production-ready mini-player surface for Qur’an playback.

The mini-player should:
- clearly show that Qur’an playback is active or paused
- show now-playing metadata in a calm, elegant, compact format
- provide quick controls such as:
  - play/pause
  - open full reader/player
  - optionally previous/next ayah or replay if appropriate
- remain visually aligned with Path of Nūr styling
- not feel noisy, intrusive, or cluttered

Potential placements depending on current architecture:
- anchored above bottom navigation
- persistent within the reader shell
- route-aware overlay for Qur’an playback surfaces
- shared playback bar used only for Qur’an reading/listening

Choose the safest path based on the existing app structure.

Requirements:
- mini-player must be driven by shared playback state, not page-local state
- it must not disappear incorrectly during active playback
- it must react correctly to play, pause, seek, ayah change, surah change, session restore, and reciter switch
- tapping it should take the user back into the correct fuller playback experience

==================================================
STEP 3 — HARDEN TRANSPORT STATE MODEL
==================================================

Audit and refine transport state exposure.

The shared state should clearly support:
- canPlay
- canPause
- canSeek
- canGoToPreviousAyah
- canGoToNextAyah
- canGoToPreviousSurah
- canGoToNextSurah
- repeat/replay state if applicable
- current playback status
- current ayah / surah context
- end-of-surah state
- loading/buffering state

If some of this already exists, normalize it cleanly.
Do not leave transport enablement as scattered UI-only logic.

==================================================
STEP 4 — SURFACE PREVIOUS / NEXT AYAH CLEANLY
==================================================

Review and improve previous/next ayah transport behavior.

Requirements:
- controls should be visibly and behaviorally consistent
- they should use the normalized playback/session state
- they should keep active ayah highlight correct
- they should keep follow-mode/scroll behavior correct
- they should update mini-player and reader surfaces consistently
- they should behave safely at ayah boundaries
- if playback is paused, transport should preserve sensible paused state unless product logic says otherwise

Do not allow transport actions to create drift between session, highlight, and visible UI.

==================================================
STEP 5 — SURFACE PREVIOUS / NEXT SURAH SAFELY
==================================================

Audit and improve previous/next surah support.

Requirements:
- only expose this where it makes product sense
- current playback/session should transition cleanly to the adjacent surah
- highlight and follow state should reset/reinitialize safely
- reciter and playback settings should remain consistent
- session persistence should update correctly
- mini-player and reader surfaces should reflect the new surah immediately
- if the next/previous surah source is unavailable, fail safely and honestly

Do not fake next/previous surah support if edge cases are not safe yet.
If necessary, expose it first in a limited but reliable way.

==================================================
STEP 6 — HARDEN REPEAT / REPLAY CONTROLS
==================================================

Audit and improve repeat/replay behavior.

Evaluate current support for:
- replay current ayah
- repeat current ayah
- repeat selected range
- repeat whole surah if present or partially present

Implement or harden only what is safely supportable in this phase.

Requirements:
- repeat state must have one reliable ownership path
- visible controls must reflect actual active repeat state
- replay/repeat must not break highlight state
- replay/repeat must not fight follow-mode
- replay/repeat must not break session persistence
- repeat state should degrade safely if some advanced mode is not ready

If whole-surah repeat is still not safe, do not pretend it fully exists.
Prefer reliable limited controls over misleading UI.

==================================================
STEP 7 — IMPROVE PLAYBACK CONTINUITY SURFACES
==================================================

Strengthen how the user experiences continuity across the app.

Potential improvements:
- mini-player reflects active session outside the reader
- continue recitation entry feels more tightly aligned with the active playback session
- transition from mini-player to full reader/player is seamless
- paused state remains understandable across surfaces
- session restoration feels intentional and not ghost-like

Do not redesign unrelated home/learn architecture.
Make focused playback continuity improvements only where they add trust.

==================================================
STEP 8 — HARDEN MINI-PLAYER / READER TRANSITIONS
==================================================

Ensure transitions between mini-player and full reader are safe.

Requirements:
- opening the reader from the mini-player lands in the correct surah/ayah/session context
- returning from the reader does not lose active playback state
- active ayah highlight remains correct after reopening
- follow-mode state behaves sensibly
- reciter metadata remains accurate
- transport controls remain in sync between surfaces

This must be driven by normalized shared state, not fragile route-local assumptions.

==================================================
STEP 9 — ADD REAL ROUTE / SURFACE TEST COVERAGE
==================================================

Add or update tests for the new playback surfaces and transport behavior.

At minimum cover:
- mini-player visible when playback is active
- mini-player reflects pause/play state correctly
- tapping mini-player opens the correct reader context
- previous/next ayah updates active ayah and highlight
- previous/next surah transitions safely if surfaced
- repeat/replay controls reflect real state
- session continuity across route transitions
- no-regression coverage for pause/play/highlight correctness
- no-regression coverage for reciter switching
- no-regression coverage for follow-mode interaction after transport events

Prefer behavior-focused tests and real route/surface harnesses where practical.

==================================================
STEP 10 — REVIEW UX POLISH OPPORTUNITIES
==================================================

Audit whether small safe UX improvements are needed, such as:
- stronger currently playing visual treatment in mini-player
- clearer paused-state wording
- compact repeat indicator
- better end-of-surah handling
- graceful empty/inactive mini-player behavior

Do not redesign the app.
Only make small safe improvements that materially improve trust and usability.

==================================================
STEP 11 — REVIEW WATCH / TVOS / CROSS-SURFACE CONTRACT
==================================================

Perform a targeted review of watch/tvOS and other playback consumers against the normalized playback and mini-player/transport contract.

Requirements:
- identify whether any surface assumes old transport ownership
- identify any parity risks
- document safe follow-up work
- make only small shared-contract improvements if clearly beneficial in this phase

Do not begin a platform rewrite.
This is a contract-alignment and parity review only.

==================================================
STEP 12 — ANALYZER / CLEANUP
==================================================

After implementation:
- run analyzer on all touched files
- fix warnings/errors where reasonable
- remove only truly obsolete duplicate transport surface logic
- keep playback/controller/coordinator ownership boundaries clear
- keep route/surface state consistent
- do not regress working features

==================================================
STEP 13 — FINAL DELIVERABLE
==================================================

At the end, provide:

1. Audit summary before changes
2. What playback surfaces existed before this pass
3. What mini-player / persistent playback surface was added or improved
4. How previous/next ayah now works
5. How previous/next surah now works
6. What repeat/replay behavior is truly supported
7. What tests were added/updated
8. Files changed
9. What still remains partial or risky
10. Recommended next phase

==================================================
FINAL AUDIT AT THE VERY END
==================================================

At the very end, provide one consolidated audit summary of:
- what playback surfaces now exist
- whether mini-player behavior is production-safe
- what transport parity is now truly supported
- what repeat/replay features are real vs still partial
- what still remains risky
- what should be built next as Phase 6 for the Qur’an player

Do not go haywire.
Do not delete or remove working logic for no reason.
Preserve the stabilized playback/highlight fixes.
Harden the playback surface carefully and keep transport state normalized.

===== END PROMPT =====
