===== PHASE 3 PROMPT — QURAN AUDIO PLAYER REBUILD ON TOP OF THE EXISTING CANONICAL RUNTIME =====

PRIMARY OBJECTIVE === BUILDING QURAN AUDIO PLAYER

You are working inside the existing Flutter codebase for Path of Nūr.

This phase is NOT a greenfield rebuild.
The audit confirmed that the remaining Qur’an audio runtime is still real, layered, and still referenced.

You must rebuild the Qur’an audio player by reusing and refactoring the existing canonical runtime, not by creating a second parallel stack.

AUDIT-CONFIRMED FOUNDATION
The strongest reusable playback foundation already exists in:

1. quran_player_controller.dart
2. quran_reader_playback_controller.dart
3. quran_playback_orchestrator.dart
4. quran_audio_repository.dart
5. quran_providers.dart

Also reuse where appropriate:
- quran_playback_policy.dart
- quran_audio_resilience.dart
- quran_reader_playback_state.dart
- quran_audio_source_metadata.dart
- quran_playback_request.dart
- quran_word_highlight_sync.dart
- quran_word_highlight_coordinator.dart
- quran_reader_follow_mode_coordinator.dart

Important:
Do NOT start from quran_reader_page.dart.
Do NOT create a new playback architecture beside the existing controller/orchestrator/repository path.
Do NOT replace reusable existing contracts unless they are proven to block the rebuild.

==================================================
MANDATORY RULES
==================================================

1. Preserve the existing canonical runtime wherever it is sound.
2. Do not build a second player stack.
3. Do not break:
   - reciter contracts
   - download/source resolution contracts
   - persistence keys
   - watch contract unless intentionally deferred
   - live activity integration unless intentionally deferred
   - non-Qur’an audio systems
4. Keep the reader page thin.
5. Move playback behavior out of page-local logic where needed.
6. Re-enable the visible player experience through the canonical runtime only.
7. Keep this production-ready, not a placeholder.
8. End with a full Codex audit summary.

==================================================
A. WHAT THE AUDIT ALREADY PROVED
==================================================

The audit already established:

- The visible Qur’an audio surface was disabled, but the runtime underneath still exists and is still referenced.
- The controller/orchestrator/state/repository stack is real and still active in the codebase.
- The biggest architectural issue is that quran_reader_page.dart still owns too much playback behavior.
- There are no core runtime files that are provably dead.
- Existing persistence keys must be preserved:
  - learn.quran.audioSettings
  - learn.quran.recitationSession
  - learn.quran.listeningStats
- Existing download/source contracts must be preserved.
- The rebuild must not create a second parallel playback path.

You must treat those findings as the source of truth for this phase.

==================================================
B. IMPLEMENTATION GOAL FOR THIS PHASE
==================================================

Rebuild and re-enable the Qur’an audio player foundation on top of the existing canonical runtime.

This phase should deliver a real, user-visible, stable Qur’an player experience while keeping the architecture clean.

This phase should restore and support:

FOUNDATION
- one canonical playback path
- load / play / pause / stop
- seek if already cleanly supported
- completion handling
- error handling
- reciter-aware playback
- stored session/settings preservation
- stable controller/provider ownership

READER-LINKED EXPERIENCE
- compact mini player above the app navigator by default
- expandable full-screen player
- visible reader verses while playback continues
- current ayah highlight during playback
- Follow Ayah Mode ON by default
- reader auto-follow/scroll when Follow Ayah Mode is enabled
- next ayah
- previous ayah if cleanly supported
- next surah
- previous surah if cleanly supported

Important:
Do not force every advanced legacy surface back in this same pass.
Re-enable the core canonical experience first, but include the mini player + full-screen player + ayah highlight + follow mode if they can be attached cleanly through the existing runtime.

==================================================
C. CANONICAL OWNERSHIP MODEL
==================================================

Preserve and clarify the ownership model:

1. quran_player_controller.dart
- remains or becomes the canonical engine owner
- should own actual playback engine interaction
- should not be duplicated elsewhere

2. quran_reader_playback_controller.dart
- remains or becomes the canonical UI-facing playback state owner
- should expose reader/player state cleanly
- should not duplicate low-level engine work

3. quran_playback_orchestrator.dart
- remains or becomes the canonical queue/session preparation layer
- should prepare playback requests and session flow cleanly

4. quran_audio_repository.dart
- remains canonical for reciters, URLs, downloads, local/remote source resolution
- do not break its contracts

5. quran_providers.dart
- remains the shared provider entry point for player/settings/stored session/listening stats
- re-enable the audio surface through these providers instead of bypassing them

The reader page must consume this architecture, not own it.

==================================================
D. PLAYER PRESENTATION REQUIREMENTS
==================================================

Restore the player in 2 surfaces:

1. MINI PLAYER (DEFAULT)
- visible above the app bottom navigator
- should not block the verses
- should not cover the navigator
- should feel calm, compact, premium, and Qur’an-specific
- should allow the user to continue reading while listening

Mini player should include at minimum:
- play/pause
- stop
- current surah
- current ayah reference
- reciter name
- next ayah
- next surah
- expand/open full-screen player affordance

2. FULL-SCREEN PLAYER
- expandable from the mini player
- richer but still calm playback surface
- Qur’an-specific, not a generic music player
- should show:
  - surah
  - ayah
  - reciter
  - progress
  - play/pause
  - stop
  - next/previous ayah where safely supported
  - next/previous surah where safely supported
  - Follow Ayah Mode toggle/setting entry

==================================================
E. FOLLOW AYAH MODE
==================================================

Implement or restore a real persisted player setting:

Follow Ayah Mode

Requirements:
- ON by default
- persisted through the existing settings storage path if possible
- restored in future sessions
- connected to the canonical playback state, not a widget-local boolean

Behavior when ON:
- currently playing ayah is highlighted
- reader follows the active ayah across the page
- auto-scroll should be calm and readable
- avoid harsh jumping and scroll thrash
- preserve readability and accessibility

Behavior when OFF:
- playback continues normally
- choose the cleanest architecture for whether highlight remains visible
- auto-follow/scroll must be disabled
- document the exact behavior implemented

Prefer reuse/refactor of:
- quran_word_highlight_sync.dart
- quran_word_highlight_coordinator.dart
- quran_reader_follow_mode_coordinator.dart

Do not replace these blindly if they are already structurally sound.

==================================================
F. AYAH-AWARE PLAYBACK
==================================================

This player must behave like a Qur’an reader companion, not a generic audio bar.

Implement or restore clean support for:
- active surah awareness
- active ayah awareness
- next ayah
- previous ayah if the architecture supports it safely
- next surah
- previous surah if the architecture supports it safely

Important:
Use the existing controller/orchestrator/repository stack and any existing ayah/highlight contracts where possible.

Do not fake precision if the current runtime does not yet support exact timing perfectly.
If the timing/highlight relationship is approximate in this phase, make it explicit in the final audit and preserve clean extension points for a later precision-sync phase.

==================================================
G. REFACTOR TARGETS
==================================================

This phase should specifically reduce page-bound playback behavior.

Refactor as needed so that:
- quran_reader_page.dart is thinner
- page-local playback logic is migrated into controller/coordinator layers where appropriate
- UI only renders and dispatches actions
- playback state ownership is not duplicated between page and controller

Likely acceptable targets for cleanup/refactor:
- hidden page-local playback branches inside quran_reader_page.dart
- stale shell/shortcut gating in app_scaffold.dart and major_page_shortcuts.dart, only as needed for the rebuilt surface
- hidden-gate wiring that blocks the canonical player from rendering

Do not do large unrelated cleanup.

==================================================
H. PERSISTENCE + CONTRACT PRESERVATION
==================================================

Preserve and reuse the existing persistence/storage contracts.

Must preserve:
- learn.quran.audioSettings
- learn.quran.recitationSession
- learn.quran.listeningStats

Handle carefully:
- stored reciter
- stored playback session
- stored settings
- listening stats
- any continue-recitation/session metadata already supported

Do not break:
- download/local-vs-remote source resolution
- watch contract unless intentionally deferred
- live activity contract unless intentionally deferred

If watch/live activity behavior is deferred, keep the contracts stable and clearly document the deferment instead of breaking them.

==================================================
I. PACKAGE / ENGINE RULE
==================================================

Use the existing playback engine path already owned by the canonical runtime.
Do not bolt in a second just_audio-based controller beside the current one.

If the existing canonical controller already uses just_audio under the hood:
- preserve that
- refactor safely
- do not duplicate it

If there are package/config fixes needed for the canonical path:
- make only the smallest necessary platform/runtime fixes
- keep the architecture centered on the existing runtime files identified in the audit

==================================================
J. TESTING
==================================================

Reuse and extend the strongest existing test foundation, especially:

- quran_playback_orchestrator_test.dart
- quran_reader_playback_controller_test.dart
- quran_audio_resilience_test.dart
- quran_audio_repository_metadata_test.dart
- app_scaffold_quran_mini_player_test.dart
- quran_reader_page_route_harness_test.dart
- quran_playback_entrypoint_scan_test.dart

Add or update tests for:
- canonical playback path restored
- load/play/pause/stop
- completion handling
- reciter/session/settings preservation
- mini player visible above navigator
- full-screen player expansion
- current ayah highlight state
- Follow Ayah Mode default ON
- Follow Ayah Mode persistence
- reader auto-follow contract
- next ayah / previous ayah behavior where implemented
- next surah / previous surah behavior where implemented
- no second parallel playback stack introduced
- analyzer clean on changed files

==================================================
K. FILE WORK RULES
==================================================

Prioritize changes in:
- quran_player_controller.dart
- quran_reader_playback_controller.dart
- quran_playback_orchestrator.dart
- quran_audio_repository.dart
- quran_providers.dart

Then reattach UI through:
- quran_reader_page.dart
- quran_reader_playback_presentation.dart
- app_scaffold.dart
- major_page_shortcuts.dart

Only touch these if needed for contract preservation:
- watch_quran_audio_contract.dart
- quran_live_activity_service.dart
- main.dart background bootstrap

Do not remove core runtime files unless they become provably dead after this rebuild pass.

==================================================
L. WHAT NOT TO DO IN THIS PHASE
==================================================

Do NOT:
- create a second playback stack
- start from the reader page
- replace the repository/orchestrator/controller path wholesale
- break storage keys
- break downloads
- break watch/live activity contracts accidentally
- restore every advanced surface if it makes the architecture messy
- push too much player logic back into quran_reader_page.dart

==================================================
M. DELIVERABLES
==================================================

At the end provide:

1. IMPLEMENTATION SUMMARY
- what was reused as-is
- what was refactored
- what was newly added
- what visible player surfaces were restored

2. FILES CHANGED
- added
- modified
- removed

3. CANONICAL ARCHITECTURE AFTER THIS PASS
State clearly:
- engine owner
- UI-facing state owner
- orchestrator owner
- repository owner
- provider entry points
- reader integration contract

4. PLAYER CAPABILITIES NOW WORKING
Be exact.

5. FOLLOW AYAH MODE BEHAVIOR
State exactly:
- default behavior
- persistence behavior
- highlight behavior
- auto-follow behavior
- any limitations in this phase

6. CONTRACTS PRESERVED
State whether the following remained intact:
- audioSettings
- recitationSession
- listeningStats
- downloads/source resolution
- watch contract
- live activity contract

7. DEFERRED ITEMS
Anything intentionally left for a later phase.

8. FINAL CODEX AUDIT
End with:
- what was completed
- what remains
- what cleanup is now safe
- whether any hidden page-local logic is still left
- what the next best phase should be

==================================================
N. NEXT PHASE RECOMMENDATION
==================================================

After this phase, recommend the best next follow-up from:
- precision ayah timing polish
- continue listening restoration/polish
- background controls polish
- watch/live-activity alignment
- downloads/offline improvements
- final retirement of stale hidden branches

IMPORTANT:
This implementation must feel like a real Qur’an reader companion:
- mini player above navigator by default
- full-screen player on demand
- current ayah highlighted during playback
- Follow Ayah Mode on by default
- reader stays visible while listening
- controller/orchestrator/repository foundation remains canonical
- reader page becomes thinner, not heavier
