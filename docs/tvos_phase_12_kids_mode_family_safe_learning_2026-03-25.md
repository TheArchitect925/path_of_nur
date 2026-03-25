# Phase 12 — tvOS Kids Mode and Family-Safe Learning

Date: 2026-03-25

## Outcome

Phase 12 is now active in the tvOS target and shared rollout layer.

- Added a dedicated tvOS Kids route at `/learn/kids/fun-learning`
- Built a remote-first family-safe screen with:
  - hero
  - primary kids paths
  - featured story shelf plus reflection rail
  - family guidance shelf
- Enabled Kids in the shared tvOS parity and feature-flag system
- Added shared content-registry modules for Kids route onboarding
- Localized all new native tvOS strings in `ios/PathOfNurTV/Localizable.strings`

## Native tvOS implementation

Main files:

- `ios/PathOfNurTV/Screens/TVKidsScreen.swift`
- `ios/PathOfNurTV/Components/TVKidsSupportCard.swift`
- `ios/PathOfNurTV/ViewModels/TVAppViewModel.swift`
- `ios/PathOfNurTV/Data/TVSeedRepository.swift`
- `ios/PathOfNurTV/Models/TVNavigationModels.swift`
- `ios/PathOfNurTV/Models/TVModels.swift`

Behavior:

- Kids is now a sidebar route in the shared tvOS shell
- Focus memory is route-aware and restores between navigation and content
- The route is built for mixed-age family-room use rather than a touch-style kids app port
- Content keeps writing/input minimal and favors short stories, short-surah support, early Arabic, and calm bedtime exit patterns

## Shared rollout and parity updates

Shared Flutter-side tvOS files:

- `lib/features/tvos/data/tvos_foundation_registry.dart`
- `lib/features/tvos/data/tvos_content_registry.dart`
- `lib/features/tvos/application/tvos_content_registry.dart`

What changed:

- `TVOSSurfaceId.kids` is now an active `adaptation` surface
- `/learn/kids/fun-learning` is enabled for the current `testflight` release stage
- Kids route modules are now registered as:
  - `kids.primaryPaths`
  - `kids.featuredStories`
  - `kids.familyGuidance`

## Verification

Passed:

- `flutter test test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_content_parity_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart`
- `flutter analyze lib/features/tvos test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart`
- `xcodebuild -project ios/Runner.xcodeproj -target PathOfNurTV -configuration Release -sdk appletvos -destination generic/platform=tvOS build CODE_SIGNING_ALLOWED=NO`

## Notes

- Kids on tvOS remains an adaptation surface, not a direct mobile port.
- The current content is structured for future shared search/indexing expansion, but no tvOS kids search UI was added in this phase.
- Repo still contains tracked `ios/build` artifact noise from local native validation runs.
