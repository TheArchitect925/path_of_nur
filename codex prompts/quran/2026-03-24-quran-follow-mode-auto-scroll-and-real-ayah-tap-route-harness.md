===== PHASE 4 PROMPT — FOLLOW-MODE, AUTO-SCROLL COORDINATION & REAL AYAH-TAP ROUTE HARNESS =====

PRIMARY OBJECTIVE === BUILDING FOLLOW-MODE, AUTO-SCROLL COORDINATION & REAL AYAH-TAP ROUTE HARNESS

You are working in the existing Flutter codebase for Path of Nūr.

This phase builds directly on top of the completed Qur’an playback stabilization, playback-state extraction, and word-highlight coordinator passes.

Current known state after the latest pass:
- active ayah playback identity is normalized through shared reader playback state/controller layers
- quran_reader_page.dart no longer owns the main playback truth
- pause/play drift and active ayah highlight drift were fixed
- reciter switching during active playback is safe enough for production use
- word-highlight lifecycle is now owned by a dedicated coordinator
- reader-facing now-playing copy is presentation-owned, not deep controller-owned
- a real reader-page route harness now exists

Main remaining risks from the latest audit:
- quran_reader_page.dart is still heavier than ideal because follow-mode and auto-scroll behavior remain route-owned
- route-level tests still do not exercise a real ayah-tap control path strongly enough
- watch/tvOS playback consumers still need review against the newer playback and word-highlight contract

Your task in this phase is to:
1. extract follow-mode and auto-scroll coordination out of quran_reader_page.dart into a dedicated coordinator/provider
2. make scroll-follow behavior safer, calmer, and less drift-prone
3. add a stronger real-route ayah-tap harness that exercises visible reader controls
4. preserve all working playback, highlight, reciter, session, memorization, notes, bookmarks, and download behavior
5. keep the architecture production-ready and additive

IMPORTANT:
This is not a rewrite.
This is not a redesign.
This is a targeted reader-UX coordination and test-hardening phase.

CRITICAL SAFETY RULES
- Audit first before changing anything.
- Do not rebuild the Qur’an reader/player from scratch.
- Do not remove/delete working logic for no reason.
- Preserve the existing pause/play/highlight fixes.
- Preserve the current playback controller, word-highlight coordinator, and presentation mapping ownership model.
- Do not introduce a second competing source of truth for active ayah or active scroll target.
- Keep changes additive, maintainable, and production-ready.
- At the very end, provide one consolidated audit summary.

==================================================
STEP 1 — AUDIT FIRST
==================================================

Before editing code, audit and summarize the current follow-mode and scroll ownership:

- where follow-mode state currently lives
- where auto-scroll decisions are currently made
- how active ayah changes trigger scroll behavior
- how the page detects whether the user is manually scrolling
- whether there are existing debounce/throttle/guard mechanisms
- how scroll behavior reacts to:
  - play
  - pause
  - resume
  - seek
  - tapped-ayah playback
  - restored session
  - reciter switch
- whether highlight changes and scroll changes can race or fight each other
- where visible ayah cards and their play/tap surfaces are rendered
- what current test seams exist for route-level ayah-tap interaction
- whether there are any current regressions or jank risks in the reader scroll path

Then identify the safest extraction boundary.

Do not over-extract.
Do not move purely visual animation details into deep business layers.
Do not move playback truth back into the page.

==================================================
STEP 2 — DEFINE THE FOLLOW-MODE TARGET OWNERSHIP
==================================================

Create or refine a dedicated coordinator/service/provider for reader follow-mode and auto-scroll lifecycle.

Suggested responsibilities:
- consume normalized reader playback state
- consume visible reader position / route scroll context as needed
- decide whether follow-mode is enabled
- decide when a scroll should happen
- decide when user interaction should temporarily suspend follow-mode behavior
- expose a simple reader-facing state for:
  - follow-mode enabled/disabled
  - should auto-scroll
  - target ayah for scroll
  - whether follow is currently suspended because of user interaction
  - whether a scroll is already in progress

Suggested structure:
- QuranReaderFollowModeCoordinator
- QuranReaderFollowModeState
- provider/controller wrapper if appropriate

Important:
- one normalized ownership path for follow-mode decisions
- page consumes state instead of privately deciding everything
- UI still owns rendering and actual scroll execution where needed, but not the lifecycle logic itself

==================================================
STEP 3 — EXTRACT FOLLOW-MODE / AUTO-SCROLL LIFECYCLE FROM THE PAGE
==================================================

Move as much of the non-UI follow-mode lifecycle as is safely practical out of quran_reader_page.dart and into the dedicated coordinator/provider layer.

Target candidates:
- determining whether current playback state should trigger scroll
- deciding whether follow-mode should remain active after manual user scroll
- resuming follow after tapped ayah playback or explicit user action
- guard logic to avoid repeated/jittery scroll calls
- seek/resume-triggered follow resync
- restoring session and deciding whether the reader should jump to the active ayah

Rules:
- do not break active ayah highlight behavior
- do not regress pause/play fixes
- do not duplicate state between page and coordinator
- keep actual widget scroll mechanics in the UI layer if necessary
- keep disposal/subscription handling safe

==================================================
STEP 4 — HARDEN FOLLOW-MODE BEHAVIOR
==================================================

After extraction, harden follow-mode behavior.

Requirements:
- active playback can keep the currently playing ayah in view when follow-mode is enabled
- manual user scrolling can temporarily suspend automatic follow behavior
- the app does not fight the user while they are exploring the page
- a clear path exists to re-enter follow-mode when appropriate
- seek updates can reposition correctly when needed
- tapped-ayah playback can bring the selected ayah into view safely
- pause preserves a sensible scroll state
- resume continues correctly
- harmless rebuilds do not cause scroll jumps
- reciter switching does not cause confusing scroll drift

Do not create noisy, jumpy, or aggressive scrolling behavior.
Prefer calm, predictable behavior.

==================================================
STEP 5 — DECIDE FOLLOW-MODE UX
==================================================

Audit and implement the safest reader UX for follow-mode.

Possible acceptable directions:
- a visible follow-mode toggle in the reader controls
- implicit follow-mode while playing, with temporary suspension on user scroll
- a lightweight “Return to current ayah” action when follow is suspended
- a compact status chip or indicator if useful

Choose the best product-safe path based on the current reader UI.

Requirements:
- the UX must be understandable
- the user must not feel trapped by auto-scroll
- the user must be able to regain the playing ayah easily
- do not clutter the page

==================================================
STEP 6 — ADD A STRONGER REAL AYAH-TAP ROUTE HARNESS
==================================================

Extend route-level test coverage so the real QuranReaderPage route is exercised through a visible ayah-tap control path.

Goals:
- interact with the actual route/widget more realistically
- validate that tapping a visible ayah play control drives playback correctly
- validate that highlight and follow behavior update correctly from that path
- reduce reliance on only abstracted lighter harness layers

Cover at minimum:
- initial idle reader state
- tapping a real visible ayah play/tap control starts playback
- tapped ayah becomes the active ayah
- visible reader state updates correctly
- follow/scroll behavior responds appropriately
- pause/resume after ayah tap works
- seek-style update after ayah tap works
- reciter switch after ayah tap behaves safely
- route-level now-playing presentation remains correct

If a stable test seam is needed for visible ayah cards, add it cleanly and minimally.
Do not make production UI ugly just for testing.

==================================================
STEP 7 — ADD/UPDATE TARGETED TESTS
==================================================

In addition to the stronger real route harness, add or update targeted tests for:
- QuranReaderFollowModeCoordinator state mapping
- auto-scroll eligibility decisions
- suspension after manual scroll
- resuming follow-mode safely
- seek-triggered follow resync
- tapped-ayah playback follow behavior
- no-regression coverage for active ayah highlight
- no-regression coverage for pause/play state visibility
- route-level ayah-tap playback behavior

Prefer behavior-focused tests.
Protect against the exact lifecycle drift and route-level fragility already seen.

==================================================
STEP 8 — REVIEW READER UX FALLBACKS
==================================================

Audit whether small safe reader UX improvements are needed around follow-mode and scroll fallback states.

Examples:
- a calm “Return to current ayah” affordance when follow is suspended
- stronger visible active ayah treatment while follow is off
- avoiding scroll jumps when timing data or layout changes arrive late

Do not redesign the page.
Only make small safe improvements if they materially improve clarity and trust.

==================================================
STEP 9 — REVIEW WATCH / TVOS PARITY CONTRACT
==================================================

Perform a targeted review of watch/tvOS Qur’an playback consumers against the normalized playback, word-highlight, and follow-mode contract.

Requirements:
- identify whether any consumer depends on old route-owned assumptions
- identify any parity risks
- document safe follow-up work
- make only small shared-contract improvements if clearly beneficial in this phase

Do not begin a platform rewrite.
This is a parity review and safe contract-alignment pass only.

==================================================
STEP 10 — ANALYZER / CLEANUP
==================================================

After implementation:
- run analyzer on all touched files
- fix warnings/errors where reasonable
- remove only truly obsolete duplicate follow-mode/scroll lifecycle logic
- keep playback/controller/coordinator ownership boundaries clear
- keep subscriptions/disposal safe
- do not regress working features

==================================================
STEP 11 — FINAL DELIVERABLE
==================================================

At the end, provide:

1. Audit summary before changes
2. What follow-mode/page ownership remained before this pass
3. What was extracted into the dedicated coordinator/provider ownership
4. How follow-mode and auto-scroll behavior now works
5. What stronger real QuranReaderPage ayah-tap harness/tests were added
6. Files changed
7. What still remains page-owned and why
8. What architectural risks still remain
9. What fallback behavior now exists when follow-mode is suspended or auto-scroll is not appropriate
10. Recommended next phase

==================================================
FINAL AUDIT AT THE VERY END
==================================================

At the very end, provide one consolidated audit summary of:
- what now owns follow-mode and auto-scroll lifecycle
- whether quran_reader_page.dart is materially safer now
- what test coverage now protects real route-level ayah-tap behavior
- what still remains risky
- what should be built next as Phase 5 for the Qur’an player

Do not go haywire.
Do not delete or remove working logic for no reason.
Preserve the stabilized playback/highlight fixes.
Extract carefully, centralize safely, and harden with real route-level reader coverage.

===== END PROMPT =====
