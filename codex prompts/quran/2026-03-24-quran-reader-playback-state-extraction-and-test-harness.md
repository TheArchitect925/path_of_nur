# Phase 2 Prompt — Quran Reader Playback State Extraction & Test Harness

PRIMARY OBJECTIVE === BUILDING QURAN READER PLAYBACK STATE EXTRACTION & TEST HARNESS

You are working in the existing Flutter codebase for Path of Nūr.

This phase builds directly on top of the completed Qur’an player audit/stabilization pass.

Current known state after the latest pass:
- play / pause / active ayah highlight drift was stabilized
- a shared playback-state resolver now exists
- the reader page now derives the active ayah more safely from real player/session state
- analyzer and targeted tests are passing
- the biggest remaining risk is still architectural: quran_reader_page.dart is too heavy and still owns too much playback lifecycle behavior directly

Your task in this phase is to:
1. extract the remaining reader playback lifecycle into a shared provider/controller layer
2. reduce page-local ownership of active playback state
3. add a proper fake-player-based reader-page test harness
4. harden reciter switching during active playback
5. preserve all existing working behavior

IMPORTANT:
This is not a rewrite.
This is not a visual redesign.
This is a targeted architecture-hardening and test-coverage phase.

CRITICAL SAFETY RULES
- Audit first before changing anything.
- Do not rebuild the Qur’an player from scratch.
- Do not remove/delete working playback, notes, bookmarks, memorization, download, or session logic for no reason.
- Preserve the existing stabilized pause/highlight fixes.
- Prefer extraction and normalization over rewrites.
- Do not introduce a second competing playback state source of truth.
- Keep the final system production-ready and maintainable.
- At the very end, provide one consolidated audit summary.

==================================================
STEP 1 — AUDIT FIRST
==================================================

Before editing code, audit and summarize the post-stabilization Qur’an playback state ownership:

- what state is still page-owned in quran_reader_page.dart
- what is already handled by quran_player_controller.dart
- what is already handled by quran_playback_orchestrator.dart
- what is already handled by quran_providers.dart
- what is already handled by quran_reader_playback_state.dart
- where subscriptions are still created/disposed in the page
- where word-highlight state still lives
- where floating transport state still lives
- where current ayah / now-reciting labels still derive from
- where session restore logic still lives
- how reciter switching currently behaves during active playback
- which parts can be safely extracted now without destabilizing the player

Then identify the safest extraction boundary.

Do not over-extract.
Do not move logic just for cleanliness if it increases risk.

==================================================
STEP 2 — DEFINE THE TARGET STATE MODEL
==================================================

Create or refine a shared reader playback state model/provider/controller that becomes the single normalized reader-facing playback source of truth.

Suggested responsibilities:
- active surah
- active ayah
- active word if available
- playback status (idle / loading / playing / paused / completed / error)
- current position
- total duration
- resolved current recitation session
- transport availability
- now-playing label / metadata
- reciter identity
- highlight readiness / timing availability
- follow-mode readiness if relevant
- whether playback was launched from a tapped ayah, resume session, or transport action

Suggested structure:
- QuranReaderPlaybackState model
- QuranReaderPlaybackController / provider
- normalized mapping from player streams + session state + fallback resolver

Important:
- one source of truth
- page consumes state rather than recreating it
- no duplicate drift-prone active-ayah fields left behind unless absolutely necessary

==================================================
STEP 3 — EXTRACT PAGE-OWNED PLAYBACK LIFECYCLE
==================================================

Move as much of the remaining playback lifecycle as is safely practical out of quran_reader_page.dart and into the shared playback state/controller layer.

Target candidates:
- active ayah lifecycle ownership
- floating transport state derivation
- now-reciting label derivation
- player state subscription interpretation
- session restore state normalization
- transport index resolution helpers
- playback position -> UI playback state mapping

Rules:
- do not break existing UI behavior
- do not regress pause/play/highlight fixes
- do not introduce circular provider dependencies
- keep disposal/subscription handling safe
- prefer additive extraction and then cleanup

==================================================
STEP 4 — CLEAN UP LOCAL PAGE STATE
==================================================

Reduce fragile page-local state in quran_reader_page.dart.

Specifically audit and reduce:
- duplicate active ayah identifiers
- stale local playback flags
- parallel “is playing” decisions
- local transport state that can now come from the shared playback state
- page-managed fallback fields that should now live in the controller/provider

Goal:
The page should render and dispatch actions, not privately own the real playback identity model.

Do not force complete purity if some UI-local state is still appropriate.
Only remove what is drift-prone or duplicated.

==================================================
STEP 5 — HARDEN RECITER SWITCHING DURING ACTIVE PLAYBACK
==================================================

Investigate and improve reciter switching during active playback.

Audit:
- what happens if the user changes reciter while audio is playing
- what happens to current ayah
- what happens to highlight state
- what happens to seek position
- what happens to session persistence
- what happens if the new reciter asset/audio is unavailable

Implement the safest production-ready behavior.

Possible acceptable behaviors depending on current architecture:
- preserve current ayah and restart playback for the same ayah under the new reciter
- preserve the approximate reading/playback position where feasible
- pause and rebuffer safely with clear state transitions
- gracefully fall back if the new reciter source is not immediately available

Requirements:
- no broken or hidden state
- no stale highlight after switch
- no silent failure
- no incorrect now-playing label
- no player/session/controller drift

==================================================
STEP 6 — NORMALIZE WORD-HIGHLIGHT OWNERSHIP
==================================================

Audit whether word-highlight ownership should remain page-local or partially move into the shared playback state/controller boundary.

If safe and beneficial:
- move the non-UI ownership logic out of the page
- keep rendering-specific details in the UI layer
- preserve beta timing-dependent behavior
- make the page less responsible for timing-sync lifecycle

If a full extraction is too risky now:
- at minimum reduce coupling
- document the boundary clearly
- ensure ayah-level highlight remains robust even when word timing is missing

==================================================
STEP 7 — BUILD A REAL FAKE-PLAYER TEST HARNESS
==================================================

Add a proper fake-player-based reader-page playback test harness.

The goal is to test reader page behavior end-to-end without relying only on narrow unit tests.

Cover at minimum:
- initial idle state
- play from tapped ayah
- pause after play
- resume after pause
- active ayah highlight updates from player stream
- seek updates active ayah highlight
- reciter switch during active playback
- session restore with correct highlight
- floating transport state correctness
- now-playing label correctness

If a reusable fake player abstraction is needed, create it cleanly.

Do not build brittle tests that only mirror implementation details.
Test behavior.

==================================================
STEP 8 — ADD/UPDATE TEST COVERAGE
==================================================

In addition to the reader-page harness, add/update targeted tests for:

- QuranReaderPlaybackState provider/controller mapping
- playback state resolution precedence
- pause/play state transitions
- session restore state mapping
- reciter switching state transitions
- active ayah derivation after seek
- fallback behavior when timing data is unavailable
- no-regression coverage for the stabilized highlight bug

Prefer tests that protect against the exact drift bugs already seen.

==================================================
STEP 9 — REVIEW TRANSPORT PARITY
==================================================

Without overbuilding, review whether the shared playback state/controller makes it easier to expose or normalize:
- previous ayah
- next ayah
- previous surah
- next surah
- repeat/replay states
- background playback status
- mini-player readiness

Do not fully build a giant transport overhaul in this phase unless it is small and low-risk.
But do note and wire safe state support where it helps the architecture.

==================================================
STEP 10 — TVOS PARITY REVIEW
==================================================

Perform a targeted review of the tvOS Qur’an playback owner against the new normalized playback-state rules.

Requirements:
- identify whether tvOS has parallel active-ayah resolution logic
- identify whether the same drift risk exists there
- document parity risks
- make only small safe shared-state/parity improvements if clearly beneficial in this phase

Do not start a full tvOS rewrite.
This is a parity review and safe alignment pass only.

==================================================
STEP 11 — ANALYZER / CLEANUP
==================================================

After implementation:
- run analyzer on all touched files
- fix warnings/errors where reasonable
- remove only truly obsolete duplicate playback state logic
- keep naming consistent
- keep provider/controller ownership boundaries clear
- keep subscriptions/disposal safe
- do not regress working features

==================================================
STEP 12 — FINAL DELIVERABLE
==================================================

At the end, provide:

1. Audit summary before changes
2. What remaining page-owned playback state was found
3. What was extracted into shared playback state/controller ownership
4. How quran_reader_page.dart became smaller/safer
5. How reciter switching now behaves during active playback
6. What fake-player harness/tests were added
7. Files changed
8. What still remains page-owned and why
9. What architectural risks still remain
10. Recommended next phase

==================================================
FINAL AUDIT AT THE VERY END
==================================================

At the very end, provide one consolidated audit summary of:
- what playback state ownership now looks like
- what is still too heavy in quran_reader_page.dart
- whether reciter switching is now safe
- what test coverage now protects the player
- what still remains risky
- what should be built next as Phase 3 for the Qur’an player

Do not go haywire.
Do not delete or remove working logic for no reason.
Preserve the stabilized bug fixes.
Extract carefully, centralize safely, and harden with real tests.
