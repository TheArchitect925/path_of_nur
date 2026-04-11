# Apple Xcode Physical QA Matrix

Last updated: 2026-04-11

This document is the current Apple release-prep checklist for Path of Nūr.

It is intentionally split into:

- repo-side build validation already completed
- physical-device QA still required before calling any Apple surface release-ready

## Repo-side build validation completed

Validated with `CODE_SIGNING_ALLOWED=NO` using the correct Xcode entrypoints:

- `Runner` via `ios/Runner.xcworkspace`
- `PrayerLiveActivityExtension` via `ios/Runner.xcworkspace`
- `PathOfNurHomeWidgets` via `ios/Runner.xcworkspace`
- `PathOfNurWatch Watch App` via `ios/Runner.xcodeproj`
- `PathOfNurWatchComplications` via `ios/Runner.xcodeproj`
- `PathOfNurTV` via `ios/Runner.xcodeproj`

## Important build truth

- iPhone and widget-related builds must be validated from `Runner.xcworkspace`, not only `Runner.xcodeproj`, because CocoaPods-backed plugins such as `audio_service` are resolved through the workspace.
- The watch complication target had one repo-owned compile blocker and it is now fixed:
  - added missing spiritual-prompt and open-app watch string keys to the shared watch string surface and complication/watch localization files

## Remaining non-blocking warnings to keep in view

- `Runner` app icon asset set still reports `5 unassigned children`
- `Runner/AppDelegate.swift` has one harmless warning around a redundant conditional downcast
- several Pod and plugin warnings remain, especially:
  - deprecated iOS APIs in `AppAuth`, `flutter_local_notifications`, `flutter_tts`, `share_plus`, `geolocator_apple`
  - `sqlite3` warning volume during Release builds
  - `home_widget` sendability warnings

These warnings did not block the validated Release builds, but they should stay on the cleanup list.

## Xcode archive steps

1. Open `ios/Runner.xcworkspace`.
2. Select the `Runner` scheme.
3. Choose a generic iPhone device destination.
4. Confirm signing for:
   - `Runner`
   - `PrayerLiveActivityExtension`
   - `PathOfNurHomeWidgets`
   - `PathOfNurWatch Watch App`
   - `PathOfNurWatch Watch App Extension`
   - `PathOfNurWatchComplications`
5. Archive `Runner`.
6. Validate the archive before TestFlight upload.
7. Open the tvOS project target separately and archive `PathOfNurTV` only after Apple TV QA is complete.

## Bundle identifiers and target map

- iPhone app: `com.shahab.pathOfNur`
- Live activity extension: `com.shahab.pathOfNur.prayerliveactivity`
- tvOS app: `com.shahab.pathOfNur.tv`
- watch app: `com.shahab.pathOfNur.watchkitapp`
- watch extension: `com.shahab.pathOfNur.watchkitapp.watchkitextension`
- watch complications: `com.shahab.pathOfNur.watchkitapp.watchkitextension.widgets`
- home widgets: `com.shahab.pathOfNur.homewidgets`

## Entitlement alignment to verify in signed builds

- development team resolves to `BL333P27N8`
- app group resolves consistently to `group.com.pathofnur.watch` across:
  - `Runner`
  - `PathOfNurHomeWidgets`
  - `PathOfNurWatch Watch App Extension`
  - `PathOfNurWatchComplications`
- `aps-environment` matches the chosen signing profile
- iCloud / ubiquity key-value entitlement resolves correctly on signed `Runner`

## Physical QA matrix

### iPhone app

- cold launch from a fresh install
- onboarding/profile boot path
- prayer schedule visibility and Today/Home coherence
- Qur'an reader launch, playback, background audio, lock-screen controls
- Hadith reader, Hadith search, and source browse launch
- reminder action routing
- backup/iCloud availability state on a signed device

### iPhone widgets

- add each widget family to the home screen
- confirm snapshot rendering for:
  - Next Prayer
  - Prayer Overview
  - Daily Dhikr
  - Journey Progress
- confirm refresh after prayer completion and dhikr changes
- confirm widget deep links open the intended iPhone destination
- confirm empty/fallback state if app-group data is stale or absent

### Live Activities

- start a prayer live activity and confirm lock-screen presentation
- confirm Dynamic Island presentation on supported iPhones
- verify state transition at prayer boundaries
- verify dismissal/end behavior after the relevant prayer window

### Apple Watch app

- install on a paired watch
- confirm Home, Prayer, Dhikr, Progress, and Utility load
- confirm snapshot fallback if phone is unreachable
- mark one prayer complete and confirm phone/watch state convergence
- complete one dhikr flow and confirm no duplicate rewards or duplicate sync
- test watch deep links and open-app routing from notifications and complications

### Apple Watch complications

- add the next prayer complication
- add the prayer progress complication
- add the auto dhikr complication
- add the spiritual prompt complication
- confirm stale/no-data fallback is readable
- confirm taps open the intended watch destination
- confirm prayer-boundary and day-rollover freshness

### tvOS

- launch with Siri Remote only
- confirm Home focus order remains calm and predictable
- open Qur'an browse/reader paths
- verify no dead-end focus traps
- verify large-title/header readability on a real TV

## Pass criteria for this phase

- every existing Apple surface installs and opens on the intended physical hardware
- no entitlement mismatch prevents startup or companion communication
- watch complications and iPhone widgets render real data and degrade gracefully
- live activity state changes remain coherent on lock screen and Dynamic Island
- tvOS remote navigation stays usable

## Current honest status

- repo-side Apple build validation: ready
- signed archive validation: still required
- physical device QA: still required
- first public release claim for Apple Watch / tvOS: not yet justified
