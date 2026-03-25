# tvOS Phase 19: Profiles, Household Usage, and Session Continuity

Date: 2026-03-25

## Goal

Add a tvOS-safe household surface for profile switching and session continuity without porting the full mobile accounts, backup, or settings management experience onto Apple TV.

## Scope Shipped

- Added a native `Profiles` route to the tvOS shell at `/accounts-sync/profiles`.
- Added household profile models, session continuity cards, and support guidance cards in:
  - [TVModels.swift](/Users/shahabmansoor/Developer/path_of_nur/ios/PathOfNurTV/Models/TVModels.swift)
  - [TVNavigationModels.swift](/Users/shahabmansoor/Developer/path_of_nur/ios/PathOfNurTV/Models/TVNavigationModels.swift)
- Added persisted per-profile route continuity and active-profile session state in:
  - [TVAppViewModel.swift](/Users/shahabmansoor/Developer/path_of_nur/ios/PathOfNurTV/ViewModels/TVAppViewModel.swift)
- Added the new native screen and cards in:
  - [TVProfilesScreen.swift](/Users/shahabmansoor/Developer/path_of_nur/ios/PathOfNurTV/Screens/TVProfilesScreen.swift)
  - [TVHouseholdProfileCard.swift](/Users/shahabmansoor/Developer/path_of_nur/ios/PathOfNurTV/Components/TVHouseholdProfileCard.swift)
  - [TVSessionContinuityCard.swift](/Users/shahabmansoor/Developer/path_of_nur/ios/PathOfNurTV/Components/TVSessionContinuityCard.swift)
  - [TVHouseholdSupportCard.swift](/Users/shahabmansoor/Developer/path_of_nur/ios/PathOfNurTV/Components/TVHouseholdSupportCard.swift)
- Extended seeded tvOS route data and shell status messaging in:
  - [TVSeedRepository.swift](/Users/shahabmansoor/Developer/path_of_nur/ios/PathOfNurTV/Data/TVSeedRepository.swift)
  - [TVNavigationSidebar.swift](/Users/shahabmansoor/Developer/path_of_nur/ios/PathOfNurTV/Components/TVNavigationSidebar.swift)

## Shared tvOS Policy Layer

- Promoted `profiles` from staged iOS-only posture to an enabled tvOS adaptation surface in:
  - [tvos_foundation_registry.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/tvos/data/tvos_foundation_registry.dart)
- Added canonical Phase 19 route modules in:
  - [tvos_content_registry_models.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/tvos/domain/tvos_content_registry_models.dart)
  - [tvos_content_registry.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/tvos/data/tvos_content_registry.dart)
  - [tvos_content_registry.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/tvos/application/tvos_content_registry.dart)
- Extended resilience modeling so the new route is treated as sync-aware and companion-managed in:
  - [tvos_resilience.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/tvos/application/tvos_resilience.dart)

## Product Outcome

- tvOS now has a real family-room profile route rather than implying that household continuity is deferred entirely to iPhone or iPad.
- The route focuses on:
  - quick profile switching
  - per-profile last-route continuity
  - shared-device guidance
- The route intentionally does not expose:
  - full account editing
  - backup authoring
  - restore controls
  - dense permissions management

That work remains on companion devices and future settings-owned tvOS preferences.

## Verification

Passed:

- `flutter analyze lib/features/tvos test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart test/features/tvos/tvos_resilience_test.dart`
- `flutter test test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_content_parity_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart test/features/tvos/tvos_resilience_test.dart`
- `xcodebuild -project ios/Runner.xcodeproj -target PathOfNurTV -configuration Release -sdk appletvos -destination generic/platform=tvOS build CODE_SIGNING_ALLOWED=NO CLANG_MODULE_CACHE_PATH=/tmp/path_of_nur_phase19_modulecache`

Native build note:

- Xcode still emitted the same non-blocking App Intents metadata warning because `AppIntents.framework` is not linked for this target.

## Search And Indexing Impact

- None in this phase.
- This pass added household routing, continuity state, and shared-device guidance rather than new searchable learning or Qur'an content.

## Follow-Up Direction

- Bridge tvOS household/profile state to the shared Flutter account and active-profile truth once a native-to-shared export path exists.
- Run real Apple TV household QA for repeated switching, sleep-wake resume, and mixed-age room use.
- Keep full account, backup, and permission authoring off tvOS unless the settings phase can prove a calm television-safe version.
