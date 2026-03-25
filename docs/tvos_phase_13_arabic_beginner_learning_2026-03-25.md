# Phase 13 — Arabic Letters and Beginner Learning on TV

Date: 2026-03-25

## Outcome

Phase 13 is now active in the tvOS target and shared rollout layer.

- Added a dedicated tvOS Arabic route at `/quran/arabic`
- Built a remote-first beginner Arabic screen with:
  - hero
  - primary Arabic path shelf
  - letter-group browse shelf plus detail rail
  - family and learner guidance shelf
- Enabled Arabic in the shared tvOS parity and feature-flag system
- Added shared content-registry modules for Arabic route onboarding
- Localized all new native tvOS strings in `ios/PathOfNurTV/Localizable.strings`

## Native tvOS implementation

Main files:

- `ios/PathOfNurTV/Screens/TVArabicScreen.swift`
- `ios/PathOfNurTV/Components/TVArabicLetterGroupCard.swift`
- `ios/PathOfNurTV/Components/TVArabicSupportCard.swift`
- `ios/PathOfNurTV/ViewModels/TVAppViewModel.swift`
- `ios/PathOfNurTV/Data/TVSeedRepository.swift`
- `ios/PathOfNurTV/Models/TVNavigationModels.swift`
- `ios/PathOfNurTV/Models/TVModels.swift`

Behavior:

- Arabic is now a sidebar route under Qur’an ownership
- Focus memory is route-aware and restores between navigation and content
- The route emphasizes seeing, hearing, and simple recognition instead of typing, tracing, or dense lesson drill flows
- Content uses grouped letters, first-word framing, and a gentle Qur’an-readiness handoff for large-screen beginner learning

## Shared rollout and parity updates

Shared Flutter-side tvOS files:

- `lib/features/tvos/data/tvos_foundation_registry.dart`
- `lib/features/tvos/data/tvos_content_registry.dart`
- `lib/features/tvos/application/tvos_content_registry.dart`

What changed:

- `TVOSSurfaceId.arabic` is now an active `adaptation` surface
- `/quran/arabic` is enabled for the current `testflight` release stage
- Arabic route modules are now registered as:
  - `arabic.primaryPaths`
  - `arabic.letterGroups`
  - `arabic.familyGuidance`

## Verification

Passed:

- `flutter test test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_content_parity_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart`
- `flutter analyze lib/features/tvos test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart`
- `xcodebuild -project ios/Runner.xcodeproj -target PathOfNurTV -configuration Release -sdk appletvos -destination generic/platform=tvOS build CODE_SIGNING_ALLOWED=NO`

## Notes

- Arabic on tvOS remains an adaptation surface, not a direct mobile port.
- No tvOS Arabic search UI was added in this phase, but the route is structured with stable module keys and reusable grouped-letter metadata for later indexing/discovery work.
- Repo still contains tracked `ios/build` artifact noise from local native validation runs.
