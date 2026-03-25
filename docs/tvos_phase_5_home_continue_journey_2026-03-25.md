# tvOS Phase 5: Home Screen and Continue Your Journey

Date: 2026-03-25

## Goal

Advance the native tvOS Home surface from a basic mirrored summary into a family-room-first landing experience that keeps prayer visible, makes the next Qur'an step obvious, and preserves remote-friendly focus behavior.

## What shipped

- Added a dedicated `Continue your journey` lane near the top of the tvOS Home screen.
- Introduced a reusable native `TVContinueJourneyItem` model for remote-first Home actions.
- Added a reusable native `TVContinueJourneyCard` component styled with the shared tvOS design tokens from Phase 2.
- Reordered Home emphasis so the flow is:
  1. hero
  2. continue journey
  3. prayer rhythm
  4. daily light
  5. featured Qur'an paths
- Kept prayer visible and calm instead of turning Home into a touch-style dashboard port.
- Preserved the mirrored Home/Qur'an product relationship by routing Qur'an continuation and listening actions into the shared tvOS Qur'an surface.

## Interaction decisions

- `Continue reading` navigates into the tvOS Qur'an route.
- `Resume listening` navigates into the tvOS Qur'an route.
- `Stay with today's prayer rhythm` keeps the user anchored on Home instead of forcing an unnecessary route jump.
- Focus tracking normalizes any `home.continueJourney.*` item into the same remembered Home section so focus restore stays predictable when the user returns from navigation or another route.

## Files changed

- `ios/PathOfNurTV/Models/TVModels.swift`
- `ios/PathOfNurTV/Components/TVContinueJourneyCard.swift`
- `ios/PathOfNurTV/Data/TVSeedRepository.swift`
- `ios/PathOfNurTV/ViewModels/TVAppViewModel.swift`
- `ios/PathOfNurTV/Screens/TVHomeScreen.swift`
- `ios/PathOfNurTV/Localizable.strings`
- `ios/Runner.xcodeproj/project.pbxproj`

## Why this shape

- tvOS is not a blind iOS port. The Home screen now emphasizes a small number of large, calm, readable next-step cards instead of a dense mobile-style control surface.
- Shared product direction was preserved. Prayer remains first-class, while Qur'an continuation and listening stay close to the top-level Home flow.
- The implementation is production-shaped for later phases because it adds a reusable model/component pair rather than one-off Home-only layout code.

## Verification

Command run:

```bash
xcodebuild -project ios/Runner.xcodeproj -target PathOfNurTV -configuration Release -sdk appletvos -destination generic/platform=tvOS build CODE_SIGNING_ALLOWED=NO
```

Result:

- build succeeded

## Search / indexing impact

- none in this phase

## Enhancement options

1. Replace the remaining seeded continue-journey entries with shared parity payload data once the native bridge/export layer lands.
2. Add a lightweight resume-state distinction between `continue reading` and `resume listening` so each card reflects real session state instead of staged copy only.
3. Add focused tvOS QA around horizontal shelf return behavior after navigating Home -> Qur'an -> Home.
4. Consider using Top Shelf later for the same continue-journey state once the tvOS update pipeline phase is in scope.

## Localization report

New translation keys added:

- `Continue your journey`
- `Resume the strongest next step quickly: Qur'an reading, listening, or today's worship rhythm.`
- `Return to the same Qur'an route from the place you left off.`
- `Resume listening`
- `Re-enter the listening flow with calm playback controls and highlighted ayahs.`
- `Best for family-room listening, reflection, and recitation.`
- `Next worship step`
- `Stay with today's prayer rhythm`
- `See the current and next salah first, then return to the Qur'an with intention.`
- `Prayer remains the first frame of the tvOS home experience.`
- `Prayer remains the calm first glance on TV: current, next, then the full day.`
- `Keep one verse close, then step back into the Qur'an when the room is ready.`

Locale files/resources updated:

- `ios/PathOfNurTV/Localizable.strings`

Content intentionally left translation-ready but not fully translated:

- none in this pass
