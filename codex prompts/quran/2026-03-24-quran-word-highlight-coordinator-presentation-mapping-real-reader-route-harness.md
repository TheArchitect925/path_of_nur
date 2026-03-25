===== PHASE 3 PROMPT — WORD-HIGHLIGHT COORDINATOR, PRESENTATION MAPPING & REAL READER ROUTE HARNESS =====

PRIMARY OBJECTIVE === BUILDING WORD-HIGHLIGHT COORDINATOR, PRESENTATION MAPPING & REAL READER ROUTE HARNESS

You are working in the existing Flutter codebase for Path of Nūr.

This phase builds directly on top of the completed Qur’an playback stabilization and playback-state extraction passes.

Current known state after the latest pass:
- active ayah playback identity is now normalized through quran_reader_playback_controller.dart
- quran_reader_page.dart no longer owns the main playback truth
- pause/play drift and active ayah highlight drift were fixed
- reciter switching during active playback is now safe enough for production use
- fake playback feed coverage now exists for the reader-facing playback controller and lighter harness tests

Main remaining risks from the latest audit:
- word-timing / word-highlight lifecycle is still coupled to quran_reader_page.dart
- now-playing label copy is still generated inside the shared playback controller instead of presentation mapping
- there is still no fuller fake-player harness around the real QuranReaderPage route itself
- watch/tvOS consumers still need review against the normalized playback-state contract

Your task in this phase is to:
1. extract word-highlight lifecycle ownership into a dedicated coordinator
2. move reader-facing now-playing copy out of the shared playback controller into presentation mapping
3. add a fuller fake-player harness around the real QuranReaderPage route/widget
4. preserve all working playback, highlight, reciter, session, memorization, notes, bookmarks, and download behavior
5. keep the architecture production-ready and additive

IMPORTANT:
This is not a rewrite.
This is not a redesign.
This is a targeted architecture-hardening and behavior-validation phase.

CRITICAL SAFETY RULES
- Audit first before changing anything.
- Do not rebuild the Qur’an player from scratch.
- Do not remove/delete working logic for no reason.
- Preserve the existing pause/play/highlight fixes.
- Preserve the current active ayah resolver and reader playback controller ownership model.
- Do not introduce a second competing highlight source of truth.
- Keep changes additive, maintainable, and production-ready.
- At the very end, provide one consolidated audit summary.

==================================================
STEP 1 — AUDIT FIRST
==================================================

Before editing code, audit and summarize the current word-highlight and presentation ownership:

- where word-highlight timing data is loaded
- where word-highlight subscriptions/listeners are created
- where word-highlight state is stored
- where the current active word is derived
- how active word depends on active ayah / playback position
- what happens when timing data is absent
- what happens when playback is paused, resumed, or sought
- what happens when a reciter is changed during active playback
- where now-playing label strings/copy are currently produced
- where localized presentation mapping should safely live
- how the real QuranReaderPage route is currently tested
- what test seams already exist for a fuller fake-player reader harness

Then identify the safest extraction boundary.

Do not over-extract.
Do not move rendering-only concerns into deep controller layers.
Do not move business playback truth back into the page.

==================================================
STEP 2 — DEFINE THE WORD-HIGHLIGHT TARGET OWNERSHIP
==================================================

Create or refine a dedicated coordinator/service/provider for reader word-highlight lifecycle.

Suggested responsibilities:
- consume normalized reader playback state
- consume timing/alignment data if available
- derive current active word index/range
- handle degraded mode when timing data is unavailable
- react safely to:
  - play
  - pause
  - resume
  - seek
  - tapped-ayah playback
  - restored session
  - reciter switch
- expose reader-facing highlight state cleanly to the page

Suggested structure:
- QuranWordHighlightCoordinator
- QuranWordHighlightState
- provider/controller wrapper if appropriate
- clear fallback modes such as:
  - no_timing_available
  - ayah_only_highlight
  - word_highlight_ready

Important:
- one normalized highlight ownership path
- page consumes state instead of owning the lifecycle
- ayah-level highlight must remain reliable even if word timing is missing

==================================================
STEP 3 — EXTRACT WORD-HIGHLIGHT LIFECYCLE FROM THE PAGE
==================================================

Move as much of the non-UI word-highlight lifecycle as is safely practical out of quran_reader_page.dart and into the dedicated coordinator/provider layer.

Target candidates:
- timing stream interpretation
- playback position to word mapping
- active word reset/resume rules
- seek resync handling
- reciter-switch invalidation/resync behavior
- fallback handling when timing data is missing or delayed

Rules:
- do not break current ayah highlight behavior
- do not regress pause/play fixes
- do not duplicate state between page and coordinator
- keep rendering-only decisions in the UI layer if appropriate
- keep disposal/subscription handling safe

==================================================
STEP 4 — DEFINE PRESENTATION MAPPING BOUNDARY
==================================================

Move reader-facing now-playing copy/presentation mapping out of the shared playback controller.

Requirements:
- controller should expose normalized semantic state and metadata
- presentation layer should map that into localized labels/copy
- do not hardcode reader-facing copy inside deep shared controller logic
- preserve existing behavior and metadata richness
- keep localization clean and maintainable

Examples of presentation concerns that should live outside the core controller:
- “Now reciting”
- “Paused at Ayah X”
- reader-facing labels derived from playback/session state
- any localized or style-specific copy decisions

Choose the safest boundary, such as:
- presentation mapper
- page-level helper fed by controller state
- lightweight presentation model/provider

Do not overcomplicate.
Do not push localization down into deep playback logic.

==================================================
STEP 5 — HARDEN WORD-HIGHLIGHT BEHAVIOR
==================================================

After extraction, harden word-highlight behavior.

Requirements:
- active word highlighting works when timing data exists
- ayah-level highlight still works when timing data does not exist
- seek updates the word highlight correctly when possible
- pause preserves a sensible highlight state
- resume continues correctly
- tapped-ayah playback updates highlight immediately
- reciter switch invalidates and rehydrates timing/highlight state safely
- restored session behaves correctly
- harmless rebuilds do not erase highlight state

If exact word timing is unavailable, degrade gracefully and honestly.
Do not fake word-level precision.

==================================================
STEP 6 — ADD A FULLER REAL READER ROUTE HARNESS
==================================================

Build a fuller fake-player-based harness around the real QuranReaderPage route/widget, not just the lighter reader-facing controller harness.

Goals:
- test the actual reader page behavior with a fake playback feed
- validate visible highlight behavior and page reactions
- ensure the real route/widget does not regress

Cover at minimum:
- initial idle reader state
- tapped ayah starts playback
- pause updates visible reader state
- resume updates visible reader state
- active ayah highlight is visible
- word-highlight behavior with timing-ready and timing-missing cases
- seek changes update reader highlight
- reciter switch updates reader state safely
- restored session shows correct reader state
- now-playing presentation mapping is correct at the UI layer

If needed, add a reusable test seam cleanly.
Do not create brittle tests that only mirror implementation details.

==================================================
STEP 7 — ADD/UPDATE TARGETED TESTS
==================================================

In addition to the real reader harness, add or update targeted tests for:
- QuranWordHighlightCoordinator state mapping
- fallback behavior when timing data is missing
- resync after seek
- resync after resume
- reciter-switch highlight reset/recovery
- now-playing presentation mapping
- no-regression coverage for active ayah highlight
- no-regression coverage for pause/play state visibility
- stored session not falsely presenting active word highlight before playback resumes

Prefer behavior-focused tests.
Protect against the exact drift and lifecycle bugs already seen.

==================================================
STEP 8 — REVIEW DEGRADATION / FALLBACK UX
==================================================

Audit whether small safe reader UX improvements are needed for degraded highlight states.

Examples:
- keep ayah highlight strong when word timing is unavailable
- avoid flicker or misleading partial word highlight
- optionally show no extra UI at all when timing is unavailable rather than confusing beta behavior

Do not redesign the page.
Only make small safe improvements if they help clarity and trust.

==================================================
STEP 9 — REVIEW WATCH / TVOS PARITY CONTRACT
==================================================

Perform a targeted review of watch/tvOS Qur’an playback consumers against the normalized playback-state and word-highlight contract.

Requirements:
- identify whether any consumer depends on old page-owned assumptions
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
- remove only truly obsolete duplicate word-highlight logic
- keep playback/controller/coordinator ownership boundaries clear
- keep localization boundaries clean
- keep subscriptions/disposal safe
- do not regress working features

==================================================
STEP 11 — FINAL DELIVERABLE
==================================================

At the end, provide:

1. Audit summary before changes
2. What word-highlight/page ownership remained before this pass
3. What was extracted into the dedicated coordinator/provider ownership
4. How now-playing presentation mapping was moved out of the shared controller
5. What real QuranReaderPage harness/tests were added
6. Files changed
7. What still remains page-owned and why
8. What architectural risks still remain
9. What fallback/degraded behavior now exists for missing timing data
10. Recommended next phase

==================================================
FINAL AUDIT AT THE VERY END
==================================================

At the very end, provide one consolidated audit summary of:
- what now owns word-highlight lifecycle
- whether quran_reader_page.dart is materially safer now
- whether now-playing copy is properly presentation-owned
- what test coverage now protects the real reader page
- what still remains risky
- what should be built next as Phase 4 for the Qur’an player

Do not go haywire.
Do not delete or remove working logic for no reason.
Preserve the stabilized playback/highlight fixes.
Extract carefully, centralize safely, and harden with real reader-page coverage.

===== END PROMPT =====
