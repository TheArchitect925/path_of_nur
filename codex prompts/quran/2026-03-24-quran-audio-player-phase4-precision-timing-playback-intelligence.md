===== PHASE 4 PROMPT — PRECISION AYAH TIMING + PLAYBACK INTELLIGENCE =====

PRIMARY OBJECTIVE === BUILDING QURAN AUDIO PLAYER

You are working inside the existing Flutter codebase for Path of Nūr.

This phase builds on the already-restored canonical Qur’an audio runtime.

The previous phase is COMPLETE.
Do not rebuild the player foundation again.
Do not create a second playback stack.
Do not regress the restored mini player, full-screen player, follow mode, or persistence contracts.

CURRENT KNOWN GOOD BASELINE
The following is already restored and must remain canonical:

- quran_player_controller.dart → engine owner
- quran_reader_playback_controller.dart → UI-facing state owner
- quran_playback_orchestrator.dart → session/queue logic
- quran_audio_repository.dart → reciters, source resolution, downloads
- quran_providers.dart → provider entry, settings, persistence

Already working and must remain intact:
- load / play / pause / stop
- seek
- completion handling
- reciter-aware playback
- mini player above navigator
- full-screen player
- ayah-aware playback state
- ayah highlight during playback
- next/previous ayah
- next/previous surah where state supports it
- reading while listening
- Follow Ayah Mode ON by default
- Follow Ayah Mode persisted via learn.quran.followPlayback
- preserved contracts:
  - learn.quran.audioSettings
  - learn.quran.recitationSession
  - learn.quran.listeningStats
  - reciter system
  - downloads/source resolution
  - watch contract
  - live activity contract

==================================================
CRITICAL RULES
==================================================

1. DO NOT create a second playback architecture.
2. DO NOT replace the canonical runtime.
3. DO NOT break existing player surfaces.
4. DO NOT break persistence keys or stored session behavior.
5. DO NOT break download/source contracts.
6. DO NOT break non-Qur’an audio.
7. DO NOT push more playback logic into quran_reader_page.dart.
8. DO NOT perform broad unrelated refactors.
9. Build this as production-ready behavior, not placeholder polish.
10. End with a full Codex audit summary.

==================================================
PHASE GOAL
==================================================

This phase is about making the player feel accurate, intelligent, and system-integrated.

Build these major improvements:

1. PRECISION AYAH TIMING POLISH
2. SMART CONTINUE LISTENING
3. TAP AYAH TO JUMP PLAYBACK
4. BACKGROUND AUDIO + NATIVE MEDIA CONTROLS
5. SMOOTHER FOLLOW AYAH MODE

This phase should make the Qur’an player feel premium and dependable, without bloating the architecture.

==================================================
A. PRECISION AYAH TIMING POLISH
==================================================

Improve ayah highlighting accuracy during playback.

Goals:
- reduce drift between the actual playback and the highlighted ayah
- reduce premature ayah transitions
- reduce delayed highlight transitions
- improve transition consistency between ayahs
- keep highlight timing calm and trustworthy

Requirements:
- audit the current ayah timing / highlighting path first
- reuse existing timing/highlight contracts where possible
- do not replace good foundations blindly
- improve timing calculation, transition thresholds, buffering handling, and handoff logic
- keep the canonical owner of playback state intact

Expected result:
- the active ayah should change at the right moment more consistently
- the user should feel that the reader and audio are actually synced

Important:
If true word-level or ultra-precise ayah boundaries are not fully supported by the current metadata/contracts, improve accuracy as far as the current architecture safely allows and document remaining limitations clearly.

Prefer reuse/refactor of:
- quran_word_highlight_sync.dart
- quran_word_highlight_coordinator.dart
- quran_reader_follow_mode_coordinator.dart
- any timing logic already linked to quran_reader_playback_controller.dart or quran_player_controller.dart

==================================================
B. SMART CONTINUE LISTENING
==================================================

Restore and polish a proper Continue Listening experience.

Requirements:
- use existing session and persistence contracts
- do not invent a separate resume system beside learn.quran.recitationSession
- surface a clear current listening state such as:
  - Surah
  - Ayah
  - Reciter
  - last known position if relevant

Implement:
1. Continue Listening card or surface in the Qur’an reader flow where it fits cleanly
2. resume actions:
   - resume from last ayah / last point
   - restart from beginning of surah
3. reader-facing clarity:
   - “You stopped at Surah X, Ayah Y”

Keep it elegant and minimal.

If adding Home integration is too broad for this phase, keep the contract and implementation ready for later reuse, but at least restore it properly in the Qur’an experience.

==================================================
C. TAP AYAH TO JUMP PLAYBACK
==================================================

Implement bidirectional sync.

Current system:
- player → reader highlight

Add:
- reader → player jump

Requirements:
- tapping an ayah should jump playback to that ayah when playback context is active or when the user intentionally starts playback from there
- this must use the canonical playback path
- no side-channel playback logic
- current highlight must update correctly after the jump
- Follow Ayah Mode should continue behaving correctly after jump
- minimize UI delay between tap and playback update

Handle carefully:
- if an ayah is unavailable locally/remotely for the current reciter/source state
- if the jump requires orchestration/session rebuild
- if the user taps while buffering

Document exact fallback behavior.

==================================================
D. BACKGROUND AUDIO + NATIVE MEDIA CONTROLS
==================================================

This phase must make the player behave like a real mobile audio system.

Requirements:
- playback continues in background as appropriate
- native phone media surface reflects Qur’an playback
- user can play/pause from the phone’s native player controls
- support lock-screen / notification controls where the current architecture supports them safely
- support remote controls such as headphones / Bluetooth / car controls as far as existing audio stack allows

Important:
- use the existing canonical runtime
- do not bolt on a parallel background controller
- preserve watch/live activity contracts
- if current architecture already has background bootstrap/hooks, wire and align them cleanly instead of rebuilding them sideways

Technical direction:
- prefer the smallest, cleanest integration path that matches the already-restored single canonical player runtime
- if current package usage already supports this, refactor/complete that path
- if platform metadata/session wiring is incomplete, fix only what is needed

The result should feel native and stable, not partially wired.

==================================================
E. SMOOTHER FOLLOW AYAH MODE
==================================================

Follow Ayah Mode already exists and is ON by default.
Now polish it.

Goals:
- reduce jitter
- reduce over-scrolling
- avoid constant tiny scroll adjustments
- keep the active ayah comfortably visible
- preserve manual readability while listening

Implement smarter follow behavior such as:
- threshold-based auto-scroll
- calm anchor positioning
- reduced scroll thrash during fast transitions
- sensible behavior when the user manually scrolls
- smoother handling near page edges / long ayahs

Behavior requirements:
- when Follow Ayah Mode is ON:
  - highlight active ayah
  - auto-follow smoothly
- when OFF:
  - playback continues
  - no auto-follow
  - existing highlight behavior remains consistent with current implementation unless a cleaner architecture improvement is required

==================================================
F. PAGE THINNING (TARGETED ONLY)
==================================================

The prior phase noted that some playback helpers still remain in quran_reader_page.dart.

In this phase:
- extract only the remaining playback helpers that are clearly better owned by controller/coordinator layers
- do not do a giant page rewrite
- keep the reader page thinner than before
- UI should render state and dispatch actions only

Only move what directly helps:
- timing precision
- tap-to-jump behavior
- follow-mode smoothness
- continue listening integration

==================================================
G. PERSISTENCE / CONTRACT SAFETY
==================================================

Must preserve and reuse:
- learn.quran.audioSettings
- learn.quran.recitationSession
- learn.quran.listeningStats
- learn.quran.followPlayback

Must preserve:
- reciter system
- downloads and local/remote resolution
- watch contract
- live activity contract

If any watch/live activity integration cannot be fully polished in this phase, do not break it.
Keep it compatible and document what remains for later alignment.

==================================================
H. TESTING
==================================================

Reuse and extend the existing strong test base.

At minimum add or update tests for:
1. ayah timing transition accuracy behavior
2. highlight transition correctness
3. tap ayah to jump playback
4. continue listening state restoration
5. resume from ayah / restart from surah behavior
6. Follow Ayah Mode smooth-scroll contract
7. background/native control state exposure where testable
8. no second playback stack introduced
9. preserved persistence keys and session restoration behavior
10. reader page still not owning new playback complexity
11. focused widget tests for mini/full player continuity after new integration

Also run:
- flutter gen-l10n if needed
- focused flutter analyze
- focused playback / reader / scaffold tests

==================================================
I. FILE PRIORITIES
==================================================

Prioritize working in or through:
- quran_player_controller.dart
- quran_reader_playback_controller.dart
- quran_playback_orchestrator.dart
- quran_audio_repository.dart
- quran_providers.dart

Then only touch UI/surface files as needed:
- quran_reader_page.dart
- quran_reader_playback_presentation.dart
- quran_playback_controls_card.dart
- quran_expanded_player_sheet.dart
- app_scaffold.dart

Only touch these if required for native/background integration alignment:
- main.dart
- quran_live_activity_service.dart
- watch_quran_audio_contract.dart

==================================================
J. WHAT NOT TO DO
==================================================

Do NOT:
- add offline diagnostics yet
- add watch-specific UX yet
- add memorization loops yet
- add heavy new analytics
- add a separate resume engine
- rebuild the mini player again from scratch
- replace the canonical controllers
- introduce messy one-off page-local fixes

==================================================
K. DELIVERABLES
==================================================

At the end provide:

1. IMPLEMENTATION SUMMARY
- what was improved
- what was reused
- what was refactored
- what user-facing intelligence was added

2. FILES CHANGED
- added
- modified
- removed

3. PRECISION TIMING RESULT
State clearly:
- what changed in ayah timing/highlight behavior
- what improved
- what remains approximate

4. CONTINUE LISTENING RESULT
State clearly:
- where it appears
- what data it shows
- how resume works
- how restart-from-surah works

5. TAP-TO-JUMP RESULT
State clearly:
- how ayah tap behavior now works
- any fallback or edge-case behavior

6. BACKGROUND / NATIVE CONTROL RESULT
State clearly:
- whether background playback works
- whether native media controls reflect playback
- what play/pause/remote actions are supported
- any platform limitations still remaining

7. FOLLOW AYAH MODE POLISH RESULT
State clearly:
- what changed in scroll behavior
- how jitter/thrash was reduced
- how manual scroll interaction is handled

8. CONTRACTS PRESERVED
Confirm status of:
- audioSettings
- recitationSession
- listeningStats
- followPlayback
- downloads/source resolution
- watch contract
- live activity contract

9. DEFERRED ITEMS
What should come next and why.

10. FINAL CODEX AUDIT
End with:
- what was completed
- what remains
- what is now safe to clean up
- what next phase should be

==================================================
L. NEXT PHASE RECOMMENDATION
==================================================

After this phase, recommend the best follow-up from:
- offline diagnostics + repair download UX
- memorization loop foundations
- watch/live activity polish
- final reader-page playback helper extraction
- deeper resume intelligence
- preload / buffering improvements

IMPORTANT PRODUCT INTENT
This is not just an audio player polish pass.
It is a Qur’an reading + listening intelligence pass.

The final result should feel:
- calm
- accurate
- native
- dependable
- reader-first
- architecture-safe
