# Quran Audio Source Audit + Bismillah Integrity

Last updated: 2026-03-18

## Executive summary

- Mobile Qur'an playback is currently sourced from EveryAyah ayah-level MP3 files via [quran_audio_repository.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/data/quran_audio_repository.dart).
- The active mobile playback stack is now centralized around:
  - [QuranPlaybackRequest](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/domain/quran_playback_request.dart)
  - [BismillahPlaybackMode](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/domain/bismillah_playback_mode.dart)
  - [QuranPlaybackPolicy](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/application/quran_playback_policy.dart)
  - [QuranPlaybackOrchestrator](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/application/quran_playback_orchestrator.dart)
  - [QuranPlayerController](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/application/quran_player_controller.dart)
- Current product behavior is locked to `alwaysPrependBismillah = true`.
- The repo can prove that mobile currently reuses Fatihah `1:1` as the canonical Bismillah pre-roll source.
- The repo cannot yet prove, from local code/assets alone, whether non-Fatihah surah-start EveryAyah files already embed Bismillah or whether Surah 9 behaves specially in upstream source audio.
- tvOS remains a repo-wide exception: it still plays raw EveryAyah ayah URLs directly through `AVPlayer` and does not yet adopt the mobile orchestrator.

## Phase 1: repo audit

### A. Qur'an audio-related code

#### Repositories / metadata

- [quran_audio_repository.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/data/quran_audio_repository.dart)
  - owns reciter list
  - builds EveryAyah URLs
  - resolves local cached ayah files
  - now exposes auditable collection metadata and canonical Bismillah metadata
- [quran_content_repository.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/data/quran_content_repository.dart)
  - wraps canonical Qur'an content/audio lookup for verse references
- [quran_word_timing_repository.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/data/quran_word_timing_repository.dart)
  - word sync timing metadata, not playback ownership

#### Playback policy / orchestration / controller

- [quran_playback_request.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/domain/quran_playback_request.dart)
- [bismillah_playback_mode.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/domain/bismillah_playback_mode.dart)
- [quran_audio_source_metadata.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/domain/quran_audio_source_metadata.dart)
- [quran_playback_policy.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/application/quran_playback_policy.dart)
- [quran_playback_orchestrator.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/application/quran_playback_orchestrator.dart)
- [quran_player_controller.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/application/quran_player_controller.dart)

#### Player adapters / UI entry points

- [quran_reader_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/presentation/quran_reader_page.dart)
  - primary mobile playback surface
  - start/jump/resume paths now prepare through the orchestrator and execute through `QuranPlayerController`
- [app_scaffold.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/shared/widgets/app_scaffold.dart)
  - global resume FAB now uses `resumeCurrentPlaybackWithBismillah()`
- [watch_quran_audio_contract.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/watch_companion/application/watch_quran_audio_contract.dart)
  - watch play/resume commands now use `resumeCurrentPlaybackWithBismillah()`
  - adjacent-surah transitions from watch next/previous now use `playAdjacentSurahWithBismillah(...)` at surah boundaries
- [quran_navigation.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/shared/widgets/quran_navigation.dart)
  - deep-link/autoplay helper into reader
- [quran_reference_block.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/shared/widgets/quran_reference_block.dart)
  - reference card “open in reader” autoplay path
- [quran_reference_viewer.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/presentation/widgets/quran_reference_viewer.dart)
  - reference viewer autoplay path
- [core_support_routes.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/app/routes/core_support_routes.dart)
  - routes `/quran/surah/:surahNumber` autoplay into `QuranReaderPage`

#### Background / live / lock surfaces

- [quran_live_activity_service.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/core/reminders/quran_live_activity_service.dart)
  - reflects live playback metadata, not playlist ownership
- iOS ActivityKit bridge in `ios/Runner/AppDelegate.swift`
  - receives playback card updates from the Flutter reader

#### Repo-wide exception outside the canonical mobile stack

- [TVAppViewModel.swift](/Users/shahabmansoor/Developer/path_of_nur/ios/PathOfNurTV/ViewModels/TVAppViewModel.swift)
  - still uses raw `AVPlayerItem(url:)`
  - not yet routed through a Bismillah-first orchestrator

### B. Audio sources and metadata found

- Remote endpoints
  - `https://everyayah.com/data/Husary_128kbps`
  - `https://everyayah.com/data/Alafasy_128kbps`
  - `https://everyayah.com/data/Abdul_Basit_Murattal_192kbps`
- Local cache
  - app document-directory files under `quran_audio/<reciterId>/<surah>/<code>.mp3`
- Hardcoded sample source
  - mobile sample preview uses `001001.mp3` from the selected reciter base URL
- tvOS source mapping
  - `TVSeedRepository.audioURL(...)` builds the same EveryAyah ayah-code URL pattern

### C. Audio source table

| Source / reciter | File / provider | Granularity | Separate Bismillah clip in repo | Fatihah contains Bismillah in-sequence | Other surahs contain Bismillah in-sequence | Surah 9 different | Duplicate risk today | Confidence | Manual review |
|---|---|---:|---:|---:|---:|---:|---|---|---:|
| EveryAyah Husary | [quran_audio_repository.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/data/quran_audio_repository.dart) | Ayah | No dedicated clip; mobile reuses `001001.mp3` | Yes, proven by current code path | Unknown from repo-only evidence | Unknown from repo-only evidence | Low in current `alwaysPrepend` mode because duplication prevention is intentionally not active; medium if future `sourceAware` were enabled without richer metadata | `confirmedFromCode` for Fatihah pre-roll source, otherwise `unknownNeedsManualReview` | Yes |
| EveryAyah Alafasy | [quran_audio_repository.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/data/quran_audio_repository.dart) | Ayah | No dedicated clip; mobile reuses `001001.mp3` | Yes, proven by current code path | Unknown from repo-only evidence | Unknown from repo-only evidence | Same as above | `confirmedFromCode` for Fatihah pre-roll source, otherwise `unknownNeedsManualReview` | Yes |
| EveryAyah Abdul Basit Murattal | [quran_audio_repository.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/data/quran_audio_repository.dart) | Ayah | No dedicated clip; mobile reuses `001001.mp3` | Yes, proven by current code path | Unknown from repo-only evidence | Unknown from repo-only evidence | Same as above | `confirmedFromCode` for Fatihah pre-roll source, otherwise `unknownNeedsManualReview` | Yes |
| tvOS EveryAyah Husary | [TVSeedRepository.swift](/Users/shahabmansoor/Developer/path_of_nur/ios/PathOfNurTV/Data/TVSeedRepository.swift) + [TVAppViewModel.swift](/Users/shahabmansoor/Developer/path_of_nur/ios/PathOfNurTV/ViewModels/TVAppViewModel.swift) | Ayah | No standalone clip modelled | Unknown from tvOS-only code | Unknown | Unknown | High because tvOS currently has no centralized Bismillah pre-roll layer | `unknownNeedsManualReview` | Yes |
| tvOS EveryAyah Alafasy | [TVSeedRepository.swift](/Users/shahabmansoor/Developer/path_of_nur/ios/PathOfNurTV/Data/TVSeedRepository.swift) + [TVAppViewModel.swift](/Users/shahabmansoor/Developer/path_of_nur/ios/PathOfNurTV/ViewModels/TVAppViewModel.swift) | Ayah | No standalone clip modelled | Unknown from tvOS-only code | Unknown | Unknown | High | `unknownNeedsManualReview` | Yes |
| tvOS EveryAyah Abdul Basit Murattal | [TVSeedRepository.swift](/Users/shahabmansoor/Developer/path_of_nur/ios/PathOfNurTV/Data/TVSeedRepository.swift) + [TVAppViewModel.swift](/Users/shahabmansoor/Developer/path_of_nur/ios/PathOfNurTV/ViewModels/TVAppViewModel.swift) | Ayah | No standalone clip modelled | Unknown from tvOS-only code | Unknown | Unknown | High | `unknownNeedsManualReview` | Yes |

## Phase 2: behavioral verification

| Scenario | Current code path | Bismillah played first | Target preserved | Duplicate risk | UI metadata risk |
|---|---|---:|---:|---:|---|
| Start surah from beginning | [quran_reader_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/presentation/quran_reader_page.dart) `_startSurahPlayback()` -> `_preparePlayback()` -> `QuranPlaybackOrchestrator` -> `QuranPlayerController.startPreparedPlayback()` | Yes | Yes | Low in current default mode | Low; reader state is updated with target ayah after prepared playback |
| Start Fatihah from beginning | Same as above | Yes | Yes | Low | Low |
| Resume after app background | [quran_reader_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/presentation/quran_reader_page.dart) `_toggleCurrentPlayback()` or [app_scaffold.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/shared/widgets/app_scaffold.dart) FAB -> `resumeCurrentPlaybackWithBismillah()` | Yes | Yes, via remembered session + position | Low | Low |
| Resume after app relaunch | [app_scaffold.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/shared/widgets/app_scaffold.dart) global resume -> [quran_player_controller.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/application/quran_player_controller.dart) which now falls back to the persisted recitation session when no in-memory session exists | Yes, when resumed through the controller-owned resume path | Yes | Low | Low |
| Jump to ayah inside surah | `_handleAyahPlay()` / `_playAyahAudio()` -> orchestrator | Yes | Yes | Low | Low |
| Jump to section/range inside surah | autoplay routes with `ayah` + `endAyah` -> `QuranReaderPage` -> `_startSurahPlaybackFromAyah()` / `_maybeAutoPlayFromRoute()` | Yes | Yes | Low | Low |
| Open from bookmark | [quran_bookmarks_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/presentation/quran_bookmarks_page.dart) currently navigates to reader at target ayah, not direct autoplay | Navigation only by default; if user then presses play, yes | Yes | Low | Low |
| Open from lesson card / quote / reference | [quran_navigation.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/shared/widgets/quran_navigation.dart), [quran_reference_block.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/shared/widgets/quran_reference_block.dart), [quran_reference_viewer.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/presentation/widgets/quran_reference_viewer.dart) -> autoplay route -> reader | Yes | Yes | Low | Low |
| Open from deep link / route autoplay | [core_support_routes.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/app/routes/core_support_routes.dart) `/quran/surah/:surahNumber?autoplay=...` -> reader | Yes | Yes | Low | Low |
| Watch play / resume | [watch_quran_audio_contract.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/watch_companion/application/watch_quran_audio_contract.dart) | Yes for shared mobile session resume | Yes | Low | Low |
| Watch next/previous at surah boundary | [watch_quran_audio_contract.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/watch_companion/application/watch_quran_audio_contract.dart) -> `playAdjacentSurahWithBismillah(...)` | Yes | Yes | Low | Low |
| Auto-advance to next surah | Not implemented as a canonical cross-surah feature in the current mobile stack | Not applicable | Not applicable | Unknown | Not applicable |

## Phase 3: canonical source model status

Implemented / adapted:

- [QuranVerseRef](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/domain/quran_content_refs.dart)
- [QuranAudioRef](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/domain/quran_content_refs.dart)
- [QuranPlaybackRequest](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/domain/quran_playback_request.dart)
- [QuranPlaybackReason](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/domain/quran_playback_request.dart)
- [QuranAudioSourceId](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/domain/quran_audio_source_metadata.dart)
- [QuranReciterId](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/domain/quran_audio_source_metadata.dart)
- [QuranAudioCollectionMetadata](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/domain/quran_audio_source_metadata.dart)
- [QuranAudioSourceMetadata](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/domain/quran_audio_source_metadata.dart)
- [BismillahPlaybackMode](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/domain/bismillah_playback_mode.dart)

Required metadata fields now carried in the canonical mobile metadata model:

- `sourceId`
- `reciterId`
- `isAyahGranular`
- `includesBismillahInFatiha`
- `includesBismillahAtSurahStarts`
- `hasStandaloneBismillahClip`
- `standaloneBismillahRef`
- `surah9HasNoBismillahIntroInSource`
- `notes`
- `confidence`
- `manualReviewNeeded`

## Phase 4: canonical Bismillah policy status

Centralized policy/orchestrator:

- [quran_playback_policy.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/application/quran_playback_policy.dart)
- [quran_playback_orchestrator.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/application/quran_playback_orchestrator.dart)

Centralized player executor:

- [quran_player_controller.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/application/quran_player_controller.dart)

Current product rule:

- [alwaysPrependBismillah](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/domain/bismillah_playback_mode.dart) is `true`
- default mode is `BismillahPlaybackMode.alwaysPrepend`

## Phase 5: file-by-file playback entry points

### Canonical mobile paths now using the orchestrator

- [quran_reader_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/presentation/quran_reader_page.dart)
  - ayah row play
  - current ayah resume
  - surah play
  - in-reader jump
  - autoplay from route/deep-link/reference/lesson
  - loop entry start
- [app_scaffold.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/shared/widgets/app_scaffold.dart)
  - global resume FAB
- [watch_quran_audio_contract.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/watch_companion/application/watch_quran_audio_contract.dart)
  - watch play / resume-last commands
  - watch adjacent-surah boundary transitions

### Still outside the canonical mobile orchestrator

- [TVAppViewModel.swift](/Users/shahabmansoor/Developer/path_of_nur/ios/PathOfNurTV/ViewModels/TVAppViewModel.swift)
  - raw `AVPlayer` playback per ayah
- [quran_reader_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/presentation/quran_reader_page.dart)
  - reciter sample preview still uses a direct `setUrl()` sample path; this is a preview tool, not canonical recitation playback

## Phase 6: risky display / manipulation logic

1. [quran_audio_repository.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/data/quran_audio_repository.dart)
   - Risk: the repo does not yet prove whether non-Fatihah surah-start EveryAyah files already include Bismillah.
   - Fix recommendation: add verified per-source metadata after manual source inspection.

2. [quran_audio_repository.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/data/quran_audio_repository.dart)
   - Risk: canonical Bismillah pre-roll currently reuses Fatihah `1:1`, not a dedicated standalone clip.
   - Fix recommendation: if product later requires a truly standalone clip, model and ship it explicitly instead of continuing to imply it exists.

3. [TVAppViewModel.swift](/Users/shahabmansoor/Developer/path_of_nur/ios/PathOfNurTV/ViewModels/TVAppViewModel.swift)
   - Risk: tvOS bypasses the mobile Bismillah orchestrator completely.
   - Fix recommendation: port the metadata/policy/orchestrator pattern to tvOS or explicitly scope tvOS out of the current product rule.

4. [quran_reader_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/presentation/quran_reader_page.dart)
   - Risk: reciter sample preview still uses direct player setup from the page.
   - Fix recommendation: leave as-is if sample preview is intentionally outside the canonical recitation rule; otherwise move it behind a separate preview adapter.

## Remaining uncertainties

- Whether EveryAyah non-Fatihah `XXX001.mp3` files contain Bismillah in-sequence for each reciter.
- Whether EveryAyah has any reciter/source inconsistency across the three current mobile reciters.
- Whether Surah 9 is represented differently in upstream source audio for these reciters.
- Whether a true standalone Bismillah clip exists in upstream provider metadata but is simply not modelled in this repo.

## Manual review items

- Verify upstream EveryAyah source structure for:
  - `001001.mp3`
  - `002001.mp3`
  - `009001.mp3`
  - equivalent files for each supported reciter
- Confirm whether product wants to keep reusing Fatihah `1:1` as the canonical Bismillah pre-roll source or replace it with a dedicated clip if available.
- Decide whether tvOS must adopt the same product rule before release claims say the rule is system-wide.
