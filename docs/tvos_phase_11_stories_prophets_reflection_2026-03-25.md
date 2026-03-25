# tvOS Phase 11: Stories, Prophets, and Reflection Content

Date: 2026-03-25

## Goal

Extend the tvOS Learn route from a structural hub into a real story-first learning surface with Prophets, Seerah, and short reflection content that suits family-room use.

## What shipped

- Kept Phase 11 inside the existing `/learn` tvOS route instead of creating a separate TV-only story product.
- Added a dedicated story-and-reflection stage below the Learn hub shelves with:
  - a focused story shelf
  - route-aware focus ownership
  - a selected-story detail rail
  - a reflection prompt block for shared discussion
- Added curated content collections for:
  - Prophets
  - Seerah
  - Daily Wisdom
- Added a fallback preview collection so the story stage still feels intentional when the user is focused on broader Learn items such as Journey or Explore.
- Extended the shared tvOS registry layer so Phase 11 now has explicit Learn module ownership for:
  - `learn.prophetsStories`
  - `learn.seerahReflection`
  - `learn.dailyWisdom`

## Product rationale

- tvOS is not a blind port. Instead of copying dense lists from mobile, this phase turns stories and reflection into large, calm, discussion-friendly cards.
- Shared product ownership is preserved. Prophets, Seerah, and Daily Wisdom remain Learn-owned content families; tvOS adapts the presentation rather than inventing parallel routing.
- Family-room use stays central: minimal input, readable summaries, and one clear reflection prompt at a time.

## Files changed

- `ios/PathOfNurTV/Screens/TVLearnScreen.swift`
- `ios/PathOfNurTV/Components/TVLearnStoryEntryCard.swift`
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
- The new story/reflection content is still structured with stable module IDs and section keys, so later tvOS discovery or indexing can attach to one canonical `/learn` surface instead of page-local matching.

## Enhancement options

1. Replace the seeded Prophets, Seerah, and Daily Wisdom tvOS collections with shared manifest-fed content once a native/shared Learn bridge exists.
2. Add a lightweight story-detail expansion pattern only if it stays inside the Learn route and does not fragment the shell into too many early subroutes.
3. Add Apple TV QA coverage for focus handoff between Learn shelves, the Phase 11 story stage, and the navigation rail.
4. Decide whether future Seerah or reflection continuity should remember the last selected story card per profile/household once the profiles phase is in scope.

## Localization report

New translation keys added:

- story/reflection stage framing, including:
  - `Featured stories and reflection`
  - `Selected story`
  - `Reflect together`
  - `tvOS stories direction`
- preview collection copy for Prophets, Seerah, and Daily Wisdom
- Prophets collection content keys for:
  - `Nuh`
  - `Ibrahim`
  - `Musa`
  - `Yusuf`
  - their subtitles, support lines, takeaway points, and reflection prompts
- Seerah collection content keys for:
  - `Makkah endurance`
  - `The Hijrah`
  - `Madinah brotherhood`
  - `A mercy-led return`
  - their subtitles, support lines, takeaway points, and reflection prompts
- Daily Wisdom collection content keys for:
  - `Start with intention`
  - `Return to salah`
  - `Protect the tongue`
  - `Quiet gratitude`
  - their subtitles, support lines, takeaway points, and reflection prompts

Locale files/resources updated:

- `ios/PathOfNurTV/Localizable.strings`

Content intentionally left translation-ready but not fully translated:

- none in this pass
