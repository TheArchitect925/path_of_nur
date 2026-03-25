# Quran Audio Runtime Audit Phase 2

Date: 2026-03-24

## Executive Summary

The visible Qur'an audio surface is currently disabled, but the underlying runtime is still present and still internally coherent. The codebase already contains a layered playback stack built on `just_audio`, shared Riverpod ownership, source-resolution/failure handling, reciter/download metadata, session persistence, watch snapshot plumbing, and route/widget test coverage.

The main issue is not the absence of an architecture. The main issue is that:

- the runtime is hidden behind `quranAudioFunctionEnabledProvider = false`
- the reader page still owns too much playback-specific behavior
- shell/watch/live-activity integrations still depend on the hidden runtime
- the next rebuild phase must choose one canonical runtime and restore the UI onto it instead of creating a second parallel stack

The canonical rebuild base should be:

1. `lib/features/learn/quran/application/quran_player_controller.dart`
2. `lib/features/learn/quran/application/quran_playback_orchestrator.dart`
3. `lib/features/learn/quran/application/quran_reader_playback_controller.dart`
4. `lib/features/learn/quran/data/quran_audio_repository.dart`
5. `lib/features/learn/quran/application/quran_providers.dart`

## Current Architecture Snapshot

### Playback State Ownership

Canonical playback state currently lives across:

- `quranSharedAudioPlayerProvider` in `quran_providers.dart`
- `quranActivePlaybackSessionProvider` in `quran_player_controller.dart`
- `quranPlaybackSourceStateProvider` in `quran_audio_resilience.dart`
- `quranReaderPlaybackControllerProvider` and `quranGlobalPlaybackStateProvider` in `quran_reader_playback_controller.dart`

This is mostly a valid shared-state model. The largest ownership leak is that `quran_reader_page.dart` still contains page-bound transport, live-activity, sample-preview, and download interactions.

### Engine Ownership

The canonical engine owner is:

- `lib/features/learn/quran/application/quran_player_controller.dart`

It owns:

- subscriptions to `AudioPlayer` state streams
- active playback session tracking
- prepared playback execution
- resume-from-session behavior
- adjacent-surah playback entry
- reciter switching
- error and source-state updates

Queue construction and Bismillah policy are delegated cleanly to:

- `lib/features/learn/quran/application/quran_playback_orchestrator.dart`
- `lib/features/learn/quran/application/quran_playback_policy.dart`

### UI Ownership

The visible player UI was previously owned by:

- `lib/features/learn/quran/presentation/quran_reader_page.dart`
- `lib/shared/widgets/app_scaffold.dart`
- `lib/shared/widgets/major_page_shortcuts.dart`

Those surfaces are now hidden or gated, but their wiring still exists.

### Persistence Ownership

Persistence currently lives in:

- `lib/features/learn/quran/application/quran_providers.dart`

Important stored keys:

- `learn.quran.audioSettings`
- `learn.quran.recitationSession`
- `learn.quran.listeningStats`

Other reader keys still coexist beside audio keys, such as reading progress and display settings.

### Reciter Ownership

Canonical reciter metadata and source resolution live in:

- `lib/features/learn/quran/data/quran_audio_repository.dart`

The active selected reciter lives in:

- `QuranAudioSettings.reciterId`
- persisted through `quranAudioSettingsProvider`

### Downloads Ownership

Canonical download metadata and on-disk source resolution live in:

- `lib/features/learn/quran/data/quran_audio_repository.dart`

This layer already resolves local-vs-remote metadata, validates downloaded surah assets, and preserves contracts worth reusing.

### Ayah Playback Ownership

Ayah-aware playback is split across:

- `quran_playback_orchestrator.dart`
- `quran_player_controller.dart`
- `quran_reader_playback_controller.dart`
- `quran_reader_transport.dart`
- `quran_word_highlight_sync.dart`
- `quran_word_highlight_coordinator.dart`
- `quran_reader_follow_mode_coordinator.dart`

The contracts exist, but the reader page still coordinates too much of the triggering logic.

### Background Playback Ownership

Background/session initialization still exists in:

- `lib/main.dart` via `JustAudioBackground.init(...)`

Additional integrations still depend on playback state:

- `lib/core/reminders/quran_live_activity_service.dart`
- `lib/features/watch_companion/application/watch_quran_audio_contract.dart`

## Remaining Runtime Inventory

### Canonical Core Runtime

#### `lib/features/learn/quran/application/quran_player_controller.dart`
- Purpose: canonical playback engine/controller
- Referenced: yes
- Status: canonical
- Reuse posture: reuse and refactor in place
- Notes:
  - already owns player stream subscriptions, prepared playback execution, resume, reciter switching, and adjacent-surah playback
  - best starting point for the rebuild

#### `lib/features/learn/quran/application/quran_playback_orchestrator.dart`
- Purpose: playback queue construction and session preparation
- Referenced: yes
- Status: canonical
- Reuse posture: reuse as-is, with only targeted cleanup
- Notes:
  - isolates queue creation better than the page

#### `lib/features/learn/quran/application/quran_playback_policy.dart`
- Purpose: Bismillah and playback policy decisions
- Referenced: yes
- Status: canonical helper
- Reuse posture: reuse as-is

#### `lib/features/learn/quran/application/quran_reader_playback_controller.dart`
- Purpose: presentation-facing playback state mapping
- Referenced: yes
- Status: canonical
- Reuse posture: reuse and keep as reader/global UI state owner

#### `lib/features/learn/quran/application/quran_audio_resilience.dart`
- Purpose: source-resolution, fallback, buffering, and failure state ownership
- Referenced: yes
- Status: canonical
- Reuse posture: reuse as-is

#### `lib/features/learn/quran/application/quran_providers.dart`
- Purpose: shared player provider, settings persistence, session persistence, listening stats
- Referenced: yes
- Status: canonical, but currently feature-gated
- Reuse posture: reuse and ungate in rebuild

#### `lib/features/learn/quran/data/quran_audio_repository.dart`
- Purpose: reciters, URLs, downloads, local-vs-remote source metadata
- Referenced: yes
- Status: canonical
- Reuse posture: reuse as-is

### Secondary Runtime Support

#### `lib/features/learn/quran/application/quran_reader_playback_state.dart`
- Purpose: immutable playback state model for reader/global presentation
- Referenced: yes
- Status: canonical model
- Reuse posture: reuse

#### `lib/features/learn/quran/application/quran_reader_transport.dart`
- Purpose: reader transport helpers
- Referenced: yes
- Status: partial support layer
- Reuse posture: review during rebuild; likely retain in smaller role

#### `lib/features/learn/quran/application/quran_word_highlight_sync.dart`
- Purpose: word timing sync contract
- Referenced: yes
- Status: canonical future-sync contract
- Reuse posture: preserve contract even if not fully restored in Phase 1 rebuild

#### `lib/features/learn/quran/application/quran_word_highlight_coordinator.dart`
- Purpose: lifecycle/ownership for word highlight state
- Referenced: yes
- Status: canonical future-sync support
- Reuse posture: preserve

#### `lib/features/learn/quran/application/quran_reader_follow_mode_coordinator.dart`
- Purpose: follow-mode and playback-scroll coordination
- Referenced: yes
- Status: canonical support coordinator
- Reuse posture: preserve

#### `lib/features/learn/quran/domain/quran_audio_source_metadata.dart`
- Purpose: source metadata and fallback contract
- Referenced: yes
- Status: canonical model
- Reuse posture: reuse

#### `lib/features/learn/quran/domain/quran_audio_resilience_models.dart`
- Purpose: failure/source-state models
- Referenced: yes
- Status: canonical model
- Reuse posture: reuse

#### `lib/features/learn/quran/domain/quran_playback_request.dart`
- Purpose: playback target model
- Referenced: yes
- Status: canonical model
- Reuse posture: reuse

### Presentation and Entry Surfaces Still Carrying Runtime Coupling

#### `lib/features/learn/quran/presentation/quran_reader_page.dart`
- Purpose: reader page
- Referenced: yes
- Status: canonical page, but playback coupling is too high
- Reuse posture: refactor, do not replace wholesale
- Notes:
  - still imports playback/audio services
  - still owns large chunks of audio UI and page-bound behavior
  - current hidden-state branches should not become the long-term rebuild pattern

#### `lib/features/learn/quran/presentation/quran_reader_playback_presentation.dart`
- Purpose: now-playing/status/source labels
- Referenced: yes
- Status: canonical presentation helper
- Reuse posture: reuse

#### `lib/shared/widgets/app_scaffold.dart`
- Purpose: shell mini-player host
- Referenced: yes
- Status: canonical shell host, currently hidden
- Reuse posture: reuse after rebuild

#### `lib/shared/widgets/major_page_shortcuts.dart`
- Purpose: shared shortcuts including Qur'an continue listening
- Referenced: yes
- Status: canonical entry surface, currently gated
- Reuse posture: reuse after rebuild

### Shared Dependency and Platform Hooks

#### `lib/main.dart`
- Purpose: app entrypoint and `just_audio_background` init
- Referenced: yes
- Status: canonical app bootstrap
- Reuse posture: preserve

#### `lib/core/reminders/quran_live_activity_service.dart`
- Purpose: iOS live activity integration for Qur'an playback
- Referenced: yes
- Status: partial platform integration
- Reuse posture: wrap or reattach later; not required for foundation restore

#### `lib/features/watch_companion/application/watch_quran_audio_contract.dart`
- Purpose: watch snapshot/availability/commands for Qur'an playback
- Referenced: yes
- Status: real integration, but downstream of playback runtime
- Reuse posture: postpone reactivation until mobile rebuild is stable

### Tests Still Describing Expected Architecture

Strong reuse candidates:

- `test/features/learn/quran/quran_playback_orchestrator_test.dart`
- `test/features/learn/quran/quran_reader_playback_controller_test.dart`
- `test/features/learn/quran/quran_audio_resilience_test.dart`
- `test/features/learn/quran/quran_audio_repository_metadata_test.dart`
- `test/features/learn/quran/quran_reader_playback_state_test.dart`
- `test/features/learn/quran/quran_word_highlight_sync_test.dart`
- `test/features/learn/quran/quran_reader_follow_mode_coordinator_test.dart`
- `test/features/learn/quran/quran_word_highlight_coordinator_test.dart`
- `test/shared/widgets/app_scaffold_quran_mini_player_test.dart`
- `test/features/learn/quran/quran_reader_page_route_harness_test.dart`
- `test/features/learn/quran/quran_playback_entrypoint_scan_test.dart`
- `test/features/learn/quran/quran_global_playback_state_test.dart`

These tests reveal that the codebase already expects:

- controller-owned playback entrypoints
- shared shell/watch playback ownership
- prepared playback queues outside the page
- state mapping separate from low-level `AudioPlayer`

## Shared Dependency Map

### `just_audio`

Used by the remaining runtime through:

- `quranSharedAudioPlayerProvider`
- `quran_player_controller.dart`
- reader page local interactions
- watch command contract

### `audio_service`

Still imported by the reader page and used for media tags/metadata ownership during playback queue preparation. The runtime remains coupled to background/media-session semantics even though the UI is hidden.

### `just_audio_background`

Initialized in `lib/main.dart`. Background setup still exists and is safe to preserve. The rebuild should reuse this instead of replacing it with a second background stack.

### Shared App Scaffolding

The hidden player still depends on:

- `AppScaffold` shell mini-player host
- shared route/shortcut surfaces
- shared localization/status builders

### Global Providers/Controllers

Qur'an playback still depends on:

- `localStoreProvider`
- reader settings/audio settings/session providers
- reciter repository
- surah map and current ayah providers

## Dead, Fragile, and High-Risk Areas

### Fragile / High-Risk

#### Reader page playback ownership

`quran_reader_page.dart` still owns too much:

- sample preview behavior
- download/remove-download actions
- playback settings presentation
- floating player visibility logic
- live activity updates
- some direct player interactions

This is the biggest rebuild risk because it invites a second page-owned playback stack.

#### Hidden but still coupled shell/watch/live-activity entry points

The runtime is hidden, not removed. That means:

- shell mini-player host remains
- watch contract still builds snapshots and sends commands
- live-activity service still exists

If the rebuild restores playback without rechecking these hooks, stale behaviors could reappear unexpectedly.

#### Feature-flag branch accumulation

The current disable strategy uses gating rather than cleanup. That is safe short term, but it becomes risky if the rebuild adds new code paths without removing the old hidden branches.

### Dead or Near-Dead Candidates

None of the core runtime files are provably dead today.

The most likely future retirement candidates are:

- page-local playback helpers inside `quran_reader_page.dart` after controller migration
- hidden UI-only audio branches once a rebuilt player is live
- stale shell/watch/live-activity glue if product scope intentionally narrows

This audit does **not** support deleting the core runtime yet.

## Reusable Components Worth Preserving

Preserve as-is or with minimal refactor:

- reciter models and reciter source of truth in `quran_audio_repository.dart`
- URL/local-source builders in `quran_audio_repository.dart`
- playback request model in `quran_playback_request.dart`
- playback session and persistence keys in `quran_providers.dart`
- source/failure state models in `quran_audio_resilience.dart`
- queue preparation in `quran_playback_orchestrator.dart`
- global/reader playback state mapping in `quran_reader_playback_controller.dart`
- word-highlight/follow-mode contracts
- test harnesses around orchestrator, state, mini-player, and route entrypoints
- localized playback status labels in `quran_reader_playback_presentation.dart`

## Risks and Constraints Before Rebuild

1. The reader page still contains too much playback behavior and must not become the canonical owner again.
2. Existing persistence keys should be preserved to avoid losing last reciter/session/settings.
3. Download contracts already exist and should not be broken during the foundation phase.
4. Background, watch, and live-activity hooks must be treated as downstream integrations, not foundation blockers.
5. The app currently hides audio through a feature flag; the rebuild should restore one canonical path, not remove the flag and expose half-migrated branches.

## Recommended Target Architecture for Rebuild

### Canonical Domain Layer

- `quran_playback_request.dart`
- `quran_audio_source_metadata.dart`
- `quran_audio_resilience_models.dart`
- reciter model from `quran_audio_repository.dart`

### Canonical Application Layer

- `quran_player_controller.dart` as engine owner
- `quran_playback_orchestrator.dart` as queue preparer
- `quran_reader_playback_controller.dart` as UI-facing state owner
- `quran_audio_resilience.dart` as source/failure state owner
- `quran_providers.dart` as persistence/shared-player owner

### Canonical Infrastructure Layer

- `quran_audio_repository.dart`
- shared `AudioPlayer` provider
- existing `just_audio_background` bootstrap

### Presentation Layer

- restore only a minimal player surface first:
  - play/pause
  - progress
  - reciter display/selection
  - surah and ayah context
  - error and buffering state
- keep mini-player and continue-listening restoration as controlled follow-on steps if needed

## Proposed Phased Rebuild Plan

1. Foundation playback engine reactivation
   - keep one canonical controller
   - restore load/play/pause/seek/end-state
   - preserve stored session and reciter settings

2. Reader playback state and minimal UI restore
   - reconnect reader to shared playback state
   - keep reader page thin
   - restore safe play/pause/progress and now-playing state

3. Reciter and source handling
   - restore reciter switch UX
   - restore local/remote source resolution and safe failures

4. Surah-level transport polish
   - previous/next
   - adjacent surah behavior
   - background-safe progress updates

5. Ayah-aware sync restoration
   - reconnect highlight and follow-mode against shared state
   - do not invent new sync ownership

6. Downloads/offline and continue-listening restoration
   - restore download UI
   - restore mini-player and shortcut entry points

7. Platform integration pass
   - watch
   - live activity
   - notification/lock-screen verification

8. Cleanup/archive pass
   - remove old hidden branches
   - archive retired page-local logic
   - keep one canonical playback path

## Post-Rebuild Cleanup Candidates

Safe retirement candidates **after** the rebuilt player is live:

- hidden audio branches in `quran_reader_page.dart`
- obsolete page-local playback helpers in `quran_reader_page.dart`
- stale conditional mini-player gating once the rebuilt shell path is restored
- any watch/live-activity glue that is intentionally deferred and no longer matches rebuilt contracts

## Recommended Starting Point

The rebuild should start from:

1. `lib/features/learn/quran/application/quran_player_controller.dart`
2. `lib/features/learn/quran/application/quran_reader_playback_controller.dart`
3. `lib/features/learn/quran/application/quran_playback_orchestrator.dart`
4. `lib/features/learn/quran/data/quran_audio_repository.dart`
5. `lib/features/learn/quran/application/quran_providers.dart`

Do **not** start from the reader page. Start from the controller/state/repository stack and reattach the reader afterward.
