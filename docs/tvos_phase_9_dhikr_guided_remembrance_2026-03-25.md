# tvOS Phase 9: Dhikr and Guided Remembrance Mode

Date: 2026-03-25

## Outcome

Phase 9 is now active in the tvOS target.

- Dhikr is a sidebar-enabled tvOS route at `/worship/dhikr`.
- The route is built as a guided-remembrance adaptation, not a blind counter-style port of touch interactions.
- Shared tvOS rollout and content registries now treat Dhikr as part of the current `testflight` stage.

## Native tvOS implementation

- Added a dedicated `Dhikr` route to the native tvOS shell.
- Added a guided-remembrance screen with three remote-first sections:
  - remembrance mode selection
  - phrase-by-phrase guided flow
  - dhikr companion guidance
- Added focus memory and restore behavior for Dhikr sections so users can move between sidebar and content without losing place.

## Guided content direction

- The route emphasizes:
  - calm pacing
  - large Arabic presentation
  - minimal remote input
  - family-room remembrance use
- The current guided modes are:
  - post-prayer remembrance
  - seeking forgiveness
  - quiet family remembrance
- Phrase content stays within widely known adhkar and avoids speculative teaching or dense fiqh-heavy controls.

## Shared tvOS foundation updates

- Dhikr parity status now moved from later-phase to active tvOS adaptation.
- Shared tvOS surface flags now enable `/worship/dhikr` in the current `testflight` stage.
- Shared tvOS section flags now include:
  - `dhikr.modes`
  - `dhikr.guidedFlow`
  - `dhikr.companion`
- Shared tvOS content registry now includes Dhikr route modules and onboarding.

## Verification

- `flutter test test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_content_parity_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart`
- `flutter analyze lib/features/tvos test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart`
- `xcodebuild -project ios/Runner.xcodeproj -target PathOfNurTV -configuration Release -sdk appletvos -destination generic/platform=tvOS build CODE_SIGNING_ALLOWED=NO`

All three passed after fixing:

- Learn bundle index drift introduced by the new Dhikr route modules
- a missing native theme token reference
- tvOS 15 compatibility for mode selection interaction

## Notes

- This phase does not add search.
- This phase does not change iOS/mobile Dhikr behavior.
- The route is production-shaped for tvOS foundations, but tvOS as a platform still requires later QA and release hardening before public launch claims.
