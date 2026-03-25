# tvOS Phase 4: Shared Domain and Content Parity Layer

Date: 2026-03-25

## Scope completed

- Added a shared Flutter-side parity payload layer for the currently mirrored tvOS routes:
  - `/home`
  - `/quran`
- Reused the existing mobile/shared providers instead of creating tvOS-only duplicates:
  - `worshipSummaryProvider`
  - `quranContinueReadingSummaryProvider`
  - `quranDailyVerseProvider`
  - `quranRecitationSessionProvider`
  - `quranSurahListProvider`
  - `quranAudioFunctionEnabledProvider`
- Added JSON-ready parity models so future native bridging/export work can consume a stable contract.

## New shared parity files

- `lib/features/tvos/domain/tvos_parity_payload_models.dart`
  - canonical mirrored section IDs
  - Home/Qur'an parity payload models
  - browse/playback/home summary payload contracts
- `lib/features/tvos/data/tvos_content_parity_manifest.dart`
  - mirrored section manifest
  - curated Qur'an browse manifest for the current tvOS staged set
- `lib/features/tvos/application/tvos_content_parity.dart`
  - pure builders for Home and Qur'an parity payloads
  - provider-backed shared parity bundle sourced from the real app state

## Parity decisions

- Home parity now depends on the same worship + continue-reading + daily-verse sources already used by the mobile product direction.
- Qur'an parity now depends on the same continue-reading, daily verse, surah metadata, and recitation session state already owned by the shared Qur'an system.
- The curated tvOS browse set is no longer trapped in the native seed layer; it now has a shared Flutter-side manifest for parity review.

## Verification

- `flutter test test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_content_parity_test.dart`
- `flutter analyze lib/features/tvos test/features/tvos/tvos_content_parity_test.dart`
- Result: passed

## Notes

- This phase did not replace the native tvOS seed repository yet.
- The new parity payload layer is the stable contract future native bridge/export work should read from.
- No iOS/mobile behavior was changed.

## Recommended next follow-ups

1. Phase 21 should use these shared parity payloads when feature-flagging mirrored vs later-phase tvOS sections.
2. Phase 22 should onboard future tvOS sections through the same manifest/payload shape rather than new ad hoc native registries.
3. A later native bridge/export pass should consume `TVOSParityPayloadBundle` instead of keeping Home/Qur'an parity logic in local-only tvOS seeds.
