# tvOS Phase 8: Prayer Section for tvOS

Date: 2026-03-25

## Goal

Add a real tvOS Prayer route that adapts the mobile prayer-first direction into a remote-first, glanceable family-room surface.

## What shipped

- Added a new sidebar-enabled `/worship/prayer` tvOS route instead of keeping prayer limited to the Home summary.
- Built a native Prayer screen with:
  - a prayer hero stage
  - a current-and-next summary block
  - a full-day prayer schedule shelf
  - a calm prayer companion shelf for preparation, presence, and post-prayer return
- Reused the existing native prayer snapshot logic already used by Home instead of creating a second prayer-timing state system.
- Added route-specific focus ownership for:
  - current/next summary
  - full-day schedule
  - prayer companion cards
- Extended the shared tvOS registry and feature-flag layer so Phase 8 now has explicit Prayer route ownership for:
  - `prayer.currentNext`
  - `prayer.schedule`
  - `prayer.companion`

## Product rationale

- tvOS is not a blind port. Prayer on TV should be calm and immediate: current, next, then the day, without turning into a dense configuration screen.
- Shared product ownership is preserved. The route adapts existing Worship prayer direction rather than inventing a separate tvOS prayer product.
- Family-room use stays central: large timing cards, readable status, and simple companion reminders instead of repeated manual input.

## Files changed

- `ios/PathOfNurTV/Screens/TVPrayerScreen.swift`
- `ios/PathOfNurTV/Components/TVPrayerFocusCard.swift`
- `ios/PathOfNurTV/ViewModels/TVAppViewModel.swift`
- `ios/PathOfNurTV/Data/TVSeedRepository.swift`
- `ios/PathOfNurTV/Models/TVModels.swift`
- `ios/PathOfNurTV/Models/TVNavigationModels.swift`
- `ios/PathOfNurTV/App/TVRootView.swift`
- `ios/PathOfNurTV/Components/TVNavigationSidebar.swift`
- `ios/PathOfNurTV/Localizable.strings`
- `ios/Runner.xcodeproj/project.pbxproj`
- `lib/features/tvos/domain/tvos_content_registry_models.dart`
- `lib/features/tvos/data/tvos_content_registry.dart`
- `lib/features/tvos/application/tvos_content_registry.dart`
- `lib/features/tvos/data/tvos_foundation_registry.dart`
- `test/features/tvos/tvos_foundation_registry_test.dart`
- `test/features/tvos/tvos_feature_flags_test.dart`
- `test/features/tvos/tvos_content_registry_test.dart`

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

- No search UI was added in this phase.
- The Prayer route now has stable tvOS module keys and route ownership, so later prayer discovery or indexing can attach to one canonical `/worship/prayer` surface rather than page-local matching.

## Enhancement options

1. Replace the current native prayer snapshot data with a stronger shared prayer parity bridge once a stable mobile/shared contract is available.
2. Add Apple TV QA coverage for route-entry timing refresh, prayer-boundary rollover, and focus restore across the three prayer sections.
3. Decide whether a later phase should let Home continue deep-linking into the dedicated Prayer route or keep some users in the Home prayer summary depending on context.
4. Add one low-friction post-prayer dhikr handoff later only if it remains remote-friendly and does not turn the Prayer route into a broad worship hub.

## Localization report

New translation keys added:

- prayer route framing, including:
  - `Prayer`
  - `Current, next, and full-day salah guidance rebuilt for calm television viewing.`
  - `A calm television prayer route built around the current, next, and full-day salah rhythm.`
  - `Prayer on tvOS keeps the mobile prayer-first direction, but adapts it into a glanceable family-room flow.`
- section titles and subtitles for:
  - `Current and next salah`
  - `Today's prayer rhythm`
  - `Prayer companion`
  - `Prayer route note`
- companion card copy for:
  - `Prepare with calm`
  - `Protect presence`
  - `Return with intention`
- updated shell subtitle:
  - `Built for remote-first navigation and curated Home, Qur'an, Learn, and Prayer parity.`

Locale files/resources updated:

- `ios/PathOfNurTV/Localizable.strings`

Content intentionally left translation-ready but not fully translated:

- none in this pass
