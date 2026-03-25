# tvOS Phase 6: Qur'an Browse and Reading Experience

Date: 2026-03-25

## Goal

Advance the native tvOS Qur'an route from a general mirrored utility page into a stronger large-screen reading destination with:

- a calmer browse-first entry flow
- curated remote-friendly browse collections
- a clearer reader stage
- supporting playback that stays subordinate to reading in this phase

## What shipped

- Reframed the tvOS Qur'an hero around browse-and-read usage instead of a generic all-in-one utility summary.
- Added horizontally browsable curated Qur'an collection cards for:
  - continue path
  - short family-reading surahs
  - reflection path
- Added a dedicated reader summary stage above the ayah list so the selected surah and ayah context stay visible.
- Moved playback lower in the route and documented it as supporting the reading flow in this phase rather than owning the screen.
- Changed the default tvOS Qur'an preferred content section from playback to browse.
- Corrected the shared tvOS content registry so the staged playback module belongs to Phase 6 route ownership, matching the shipped mirrored Qur'an route.

## Product rationale

- tvOS is not a blind port. The route now reads like a large-screen reading space rather than a touch-style page with playback at the top.
- Shared product direction was preserved: continue reading, daily verse, browse, and playback still exist, but the interaction order now favors reading and calm selection.
- Family-room constraints were respected by keeping the browse lane simple, the text large, and the controls low-friction.

## Files changed

- `ios/PathOfNurTV/Screens/TVQuranScreen.swift`
- `ios/PathOfNurTV/ViewModels/TVAppViewModel.swift`
- `ios/PathOfNurTV/Data/TVSeedRepository.swift`
- `ios/PathOfNurTV/Models/TVModels.swift`
- `ios/PathOfNurTV/Models/TVNavigationModels.swift`
- `ios/PathOfNurTV/Components/TVQuranBrowseCollectionCard.swift`
- `ios/PathOfNurTV/Components/TVQuranReaderSummaryCard.swift`
- `ios/PathOfNurTV/Localizable.strings`
- `ios/Runner.xcodeproj/project.pbxproj`
- `lib/features/tvos/data/tvos_content_registry.dart`
- `test/features/tvos/tvos_content_registry_test.dart`

## Verification

Commands run:

```bash
flutter test test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_content_parity_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart
flutter analyze lib/features/tvos test/features/tvos/tvos_content_registry_test.dart test/features/tvos/tvos_feature_flags_test.dart
xcodebuild -project ios/Runner.xcodeproj -target PathOfNurTV -configuration Release -sdk appletvos -destination generic/platform=tvOS build CODE_SIGNING_ALLOWED=NO
```

Results:

- all Flutter tvOS foundation tests passed
- `flutter analyze` passed with no issues
- unsigned native tvOS Release build succeeded

## Search / indexing impact

- none in this phase
- the new browse collections are structured as explicit model data, so shared indexing could be added later without rewriting the route

## Enhancement options

1. Replace the curated native browse collections with shared parity-fed recommendation bundles when the native bridge/export layer is introduced.
2. Add a dedicated verse-opening action from the daily verse summary into the exact selected ayah once the deeper reader navigation contract is formalized.
3. Add a lightweight “recent surahs” or “family recitation” collection driven by real shared usage state instead of static seeds.
4. Keep playback in this supporting role for now, then use Phase 7 to add full-screen listening mode without reworking the browse/reader foundation again.

## Localization report

New translation keys added:

- `A large-screen Qur'an route for calm browsing, reading, and supporting playback.`
- `Qur'an keeps the same mobile-aligned direction here, but the interaction is rebuilt for remote focus and family-room reading.`
- `Resume where you left off`
- `Keeps the current mobile-aligned continue-reading path close to the first browse shelf.`
- `Quick browse`
- `Short surahs for family reading`
- `Move through Al-Ikhlas, Al-Falaq, and An-Nas in one calm shelf.`
- `Best for short recitation, review, and shared listening in the room.`
- `Reflection path`
- `Opening and relief`
- `Keep Al-Fatihah and Ash-Sharh close for reading with focus and ease.`
- `A simple large-screen reading path for reflection, comfort, and repetition.`
- `Continue your reading`
- `Return to the current reading path first, then browse or listen from the same place.`
- `Today's verse`
- `Keep one ayah visible on TV, then step into reading with the same calm focus.`
- `Choose a guided shelf first, then move into the full surah list without leaving the reading route.`
- `Reading now`
- `Selected ayah: %@ %d:%d`
- `Browse on the left, then read on the right with large Arabic text, transliteration, and translation kept together.`
- `Playback supports the reading flow here. Full listening-mode expansion belongs to the next phase.`

Locale files/resources updated:

- `ios/PathOfNurTV/Localizable.strings`

Content intentionally left translation-ready but not fully translated:

- none in this pass
