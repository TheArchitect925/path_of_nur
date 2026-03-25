# tvOS Phase 15: Signs, Creation, and Visual Learning Experiences

Date: 2026-03-25

## Goal

Add a visual-learning stage to the tvOS Learn route that adapts the existing mobile World and Creation direction for large-screen observation, wonder, and calm discussion.

## What shipped

- Kept Phase 15 inside the existing `/learn` tvOS route instead of creating a separate TV-only creation route.
- Added a dedicated visual-learning stage below the existing Learn hub and story stages with:
  - large scenic visual cards
  - route-aware focus ownership
  - a selected-visual detail rail
  - observation-first prompts for shared viewing
- Added curated visual-learning collections for:
  - signs in the sky and measured rhythm
  - oceans and hidden depth
  - animals, life, and provision
  - horizons, weather, and changing states
- Added a fallback preview collection so the visual stage still feels intentional when the user is not focused on `World and Creation`.
- Extended the shared tvOS registry layer so Phase 15 now has explicit Learn module ownership for:
  - `learn.signsCreation`
  - `learn.visualObservation`

## Product rationale

- tvOS is not a blind port. Creation learning is strongest on TV when it begins with visual scale and simple comparison rather than dense text-heavy lesson lists.
- Shared product ownership is preserved. This stage adapts the existing Learn-owned World and Creation direction rather than inventing a separate tvOS educational flow.
- Family-room use stays central: large visuals, short prompts, minimal input, and reflection that leads back to humility and gratitude.

## Files changed

- `ios/PathOfNurTV/Screens/TVLearnScreen.swift`
- `ios/PathOfNurTV/Components/TVLearnVisualEntryCard.swift`
- `ios/PathOfNurTV/ViewModels/TVAppViewModel.swift`
- `ios/PathOfNurTV/Data/TVSeedRepository.swift`
- `ios/PathOfNurTV/Models/TVModels.swift`
- `ios/PathOfNurTV/Models/TVNavigationModels.swift`
- `ios/PathOfNurTV/Localizable.strings`
- `ios/Runner.xcodeproj/project.pbxproj`
- `lib/features/tvos/domain/tvos_content_registry_models.dart`
- `lib/features/tvos/data/tvos_content_registry.dart`
- `lib/features/tvos/data/tvos_foundation_registry.dart`
- `test/features/tvos/tvos_content_registry_test.dart`
- `test/features/tvos/tvos_feature_flags_test.dart`

## Verification

Commands run:

```bash
flutter test test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_content_parity_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart
flutter analyze lib/features/tvos test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart
xcodebuild -project ios/Runner.xcodeproj -target PathOfNurTV -configuration Release -sdk appletvos -destination generic/platform=tvOS build CODE_SIGNING_ALLOWED=NO
```

Results:

- tvOS Flutter test slice passed
- `flutter analyze` found no issues
- unsigned native tvOS Release build succeeded

## Search / indexing impact

- No new search UI was added in this phase.
- The visual-learning stage is still structured under stable `/learn` module keys, so later discovery or indexing can attach to the canonical Learn route without a separate tvOS-only search path.

## Enhancement options

1. Replace the seeded Phase 15 visual collections with shared World/Creation manifest-fed data once native/shared Learn bridging exists.
2. Add subtle ambient visual polish only if it remains performance-safe for Apple TV hardware and does not turn the stage into decorative motion without learning value.
3. Add Apple TV QA coverage for focus restore between stories, visual cards, and the navigation rail.
4. Decide whether a later phase should remember the household’s last-selected visual collection once profile/session continuity is in scope.

## Localization report

New translation keys added:

- visual-learning stage framing, including:
  - `Signs and visual learning`
  - `Selected visual path`
  - `Observe together`
  - `tvOS visual learning direction`
- preview collection copy for sky/order and life/water/mercy
- creation visual collection content keys for:
  - `Sun, moon, and measured rhythm`
  - `Oceans and hidden worlds`
  - `Animals, growth, and provision`
  - `Horizons, weather, and changing states`
  - their subtitles, support lines, accent labels, takeaway points, and observation prompts

Locale files/resources updated:

- `ios/PathOfNurTV/Localizable.strings`

Content intentionally left translation-ready but not fully translated:

- none in this pass
