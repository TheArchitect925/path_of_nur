# tvOS Phase 7: Qur'an Audio Playback and Full-Screen Listening Mode

Date: 2026-03-25

## Goal

Advance the tvOS Qur'an playback layer from a supporting transport card into a real audio-first large-screen experience while preserving the browse-and-reader structure established in Phase 6.

## What shipped

- Added a native full-screen `Listening mode` entered from the existing Qur'an playback card.
- Reused the existing tvOS Qur'an playback state instead of creating a second player stack.
- Added a calm full-screen ayah stage with:
  - large Arabic presentation
  - optional transliteration
  - optional translation
  - current surah/ayah context
  - active reciter visibility
- Added remote-friendly listening controls for:
  - previous ayah
  - play/pause
  - next ayah
  - reciter switching
  - repeat current ayah
  - translation toggle
  - transliteration toggle
- Kept the existing in-route playback card and made it the entry point into full-screen listening mode instead of splitting playback into a separate tvOS route.

## Product rationale

- tvOS is not a blind port. The new listening experience is calm, large, and audio-first rather than a direct copy of touch-screen controls.
- Shared product direction was preserved: tvOS still follows the mobile Qur'an direction, but full-screen focused recitation is adapted for remote-first navigation.
- This pass leaves browse and reading intact. Playback now complements those surfaces without replacing them.

## Files changed

- `ios/PathOfNurTV/Screens/TVQuranListeningModeScreen.swift`
- `ios/PathOfNurTV/Screens/TVQuranScreen.swift`
- `ios/PathOfNurTV/Components/TVQuranPlaybackCard.swift`
- `ios/PathOfNurTV/ViewModels/TVAppViewModel.swift`
- `ios/PathOfNurTV/Localizable.strings`
- `ios/Runner.xcodeproj/project.pbxproj`

## Verification

Command run:

```bash
xcodebuild -project ios/Runner.xcodeproj -target PathOfNurTV -configuration Release -sdk appletvos -destination generic/platform=tvOS build CODE_SIGNING_ALLOWED=NO
```

Result:

- unsigned native tvOS Release build succeeded

## Search / indexing impact

- none in this phase

## Enhancement options

1. Add subtle ayah-transition motion and progress affordances inside listening mode once the tvOS performance phase is in scope.
2. Consider a sleep-timer or session-end handoff later, but only if it can stay remote-friendly and low-friction.
3. Bridge listening-mode display preferences to shared Qur'an reader settings once a native/shared preference contract is introduced.
4. Add QA coverage for playback continuity when users exit listening mode back into the browse/reader route while audio is still playing.

## Localization report

New translation keys added:

- `Playback supports the reading flow here, with full listening mode ready for focused recitation on TV.`
- `Listening mode`
- `Exit listening mode`
- `Repeat ayah on`
- `Repeat ayah off`
- `Translation on`
- `Translation off`
- `Transliteration on`
- `Transliteration off`
- `Audio controls`
- `Open listening mode`
- `Listening with %@ %d:%d`
- `Audio is playing`
- `Audio is paused`
- `Repeat current ayah is on`
- `Stay in a calm full-screen listening flow while switching reciters or moving ayah by ayah.`

Locale files/resources updated:

- `ios/PathOfNurTV/Localizable.strings`

Content intentionally left translation-ready but not fully translated:

- none in this pass
