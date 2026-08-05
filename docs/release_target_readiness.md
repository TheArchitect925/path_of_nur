# Path of Nūr Release Target Readiness

This document is the honest first-release scope, based on the currently validated codebase.

## Recommended first public release scope

- iOS
- iPadOS
- English and German runtime locales

Repo-side Xcode validation on 2026-04-11 is now green enough to begin signed archive work and physical-device QA for the Apple surfaces that already exist in the project:

- `Runner` via `Runner.xcworkspace`
- `PrayerLiveActivityExtension` via `Runner.xcworkspace`
- `PathOfNurHomeWidgets` via `Runner.xcworkspace`
- `PathOfNurWatch Watch App`
- `PathOfNurWatchComplications`
- `PathOfNurTV`

That means the project is ready for real Apple-device QA. It does not yet mean every Apple surface is ready to be publicly advertised in the first App Store release.

## Conditional release targets

- macOS
  - viable if signed-build validation confirms:
    - iCloud key-value sync works
    - local notifications permission flow works
    - backup/export/import works with the signed sandboxed app
  - local unsigned debug runs are supported, but signed Release/Profile validation is still required before claiming macOS as a release target

## Not first-public-release ready

- Apple Watch
  - native watchOS companion targets build cleanly after the 2026-04-11 watch complication localization fix
  - treat watchOS as physical-QA ready, not launch-claimed
  - do not advertise it as shipping until paired-device signing, complication/device behavior, notification actions, sync replay, and rollover flows are validated end to end

- tvOS
  - a canonical native tvOS shell now exists under `ios/PathOfNurTV` in the `PathOfNurTV` target
  - the current V1 scope is Home + Qur'an, aligned to the mobile app direction as closely as practical
  - the target now builds cleanly and is ready for Apple TV device QA
  - it is still not first-public-release ready
  - do not include tvOS in the first public release scope until signed distribution proof, Apple TV remote QA, and product-scope validation are complete

- iPhone widgets and Live Activities
  - `PathOfNurHomeWidgets` and `PrayerLiveActivityExtension` now build through the workspace-backed release path
  - treat them as iPhone companion surfaces that are ready for signed-device QA
  - do not assume ship readiness until widget placement, refresh, lock-screen presentation, and live activity state transitions are validated on physical devices

- Path of Nūr Cloud Sync
  - not release-ready because there is no real production backend transport in this repository
  - current safe release path is:
    - local-only
    - manual backup
    - Apple iCloud sync on Apple devices

## Current Apple sync posture

- iCloud sync is implemented through `NSUbiquitousKeyValueStore`
- it is suitable for the current bounded profile sync document
- it is not a substitute for a full backend event journal

## Release recommendation

Ship the first release as a stable local-first app with:

- structured local persistence
- profile isolation
- manual backup/import/export
- Apple iCloud sync on signed Apple devices
- English and German localization for V1, with broader locale rollout deferred until validated
- German Qur'an translation deferred until V1.1

Hold back unvalidated companion and TV surfaces until their native signed-build and physical-QA paths are complete.

Use [apple_xcode_physical_qa_matrix_2026-04-11.md](/Users/shahabmansoor/Developer/path_of_nur/docs/apple_xcode_physical_qa_matrix_2026-04-11.md) as the current Apple release-prep and on-device QA matrix.
