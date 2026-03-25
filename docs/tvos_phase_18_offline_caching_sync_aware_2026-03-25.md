# tvOS Phase 18: Offline Content, Caching, and Sync-Aware Behavior

Date: 2026-03-25

## Goal

Add a production-ready resilience foundation for tvOS so active Apple TV surfaces communicate dependable local availability, cache-safe usage, and companion-device sync expectations without pretending tvOS owns full backup or profile management.

## Scope Shipped

- Added a shared Flutter-side resilience contract in [tvos_resilience_models.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/tvos/domain/tvos_resilience_models.dart).
- Added route-aware offline and sync snapshot building in [tvos_resilience.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/tvos/application/tvos_resilience.dart).
- Added resilience tests in [tvos_resilience_test.dart](/Users/shahabmansoor/Developer/path_of_nur/test/features/tvos/tvos_resilience_test.dart).
- Added a native tvOS system status card in [TVSystemStatusCard.swift](/Users/shahabmansoor/Developer/path_of_nur/ios/PathOfNurTV/Components/TVSystemStatusCard.swift).
- Added a route-aware native status snapshot in [TVSeedRepository.swift](/Users/shahabmansoor/Developer/path_of_nur/ios/PathOfNurTV/Data/TVSeedRepository.swift).
- Exposed the status card in the shared shell through [TVNavigationSidebar.swift](/Users/shahabmansoor/Developer/path_of_nur/ios/PathOfNurTV/Components/TVNavigationSidebar.swift) and [TVAppViewModel.swift](/Users/shahabmansoor/Developer/path_of_nur/ios/PathOfNurTV/ViewModels/TVAppViewModel.swift).

## Product Outcome

- tvOS now models active routes as offline-capable instead of implying constant live connectivity.
- Home, Qur'an, and Saved emphasize bundled or cached continuity with companion-device sync handoff.
- Prayer and Dhikr emphasize worship-safe local continuity during connection gaps.
- Learn, Kids, Arabic, and Games emphasize bundled or cache-safe learning with iPhone or iPad handoff for heavier sync work.
- tvOS still does not expose full backup, restore, profile, or sync-management UI. That remains intentionally deferred to later phases.

## Architecture Notes

- The shared resilience snapshot is route-aware and module-aware.
- The snapshot reuses existing sync foundation state, local preference storage, and structured persistence counts instead of inventing a tvOS-only sync model.
- The current native sidebar status card is seeded from route groups. It is intentionally aligned to the shared resilience contract so a later Flutter-to-native bridge can replace the seed logic without redesigning the shell.
- No iOS or Flutter mobile behavior was changed.

## Verification

Passed:

- `flutter analyze lib/features/tvos test/features/tvos/tvos_resilience_test.dart test/features/tvos/tvos_content_registry_test.dart test/features/tvos/tvos_feature_flags_test.dart`
- `flutter test test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_content_parity_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart test/features/tvos/tvos_resilience_test.dart`
- `xcodebuild -project ios/Runner.xcodeproj -target PathOfNurTV -configuration Release -sdk appletvos -destination generic/platform=tvOS build CODE_SIGNING_ALLOWED=NO CLANG_MODULE_CACHE_PATH=/tmp/path_of_nur_phase18_modulecache`

Native build note:

- Xcode emitted a non-blocking metadata warning about App Intents extraction being skipped because `AppIntents.framework` is not linked for this target.

## Search And Indexing Impact

- None in this phase.
- This pass focused on resilience state, local continuity, and shell communication rather than discovery or indexing.

## Follow-Up Direction

- Bridge the shared resilience snapshot into native tvOS once the export layer exists, replacing the remaining route-group seeding.
- Run real Apple TV QA for cold launch without network, resume after connection loss, and post-backup or sign-in refresh behavior.
- Keep backup and restore authoring on iPhone or iPad unless a later settings phase can prove a calm tvOS-safe version.
