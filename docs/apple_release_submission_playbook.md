# Apple release submission playbook

This document is the practical release-prep guide for Path of Nūr on Apple platforms.

It is intentionally operational, not aspirational.

## Repo-side fixes already applied

- the iOS `Runner` target no longer advertises `tvOS` support in Xcode build settings
- `Runner` now targets only `iphoneos` and `iphonesimulator`
- `Runner` now targets device family `1,2` only

This removes archive ambiguity and makes the current Apple project truth match the actual repo structure.

## Current platform truth

### In repo today

- `iOS Runner` app target exists and is the real shipping app target
- `PrayerLiveActivityExtension` exists and is embedded by the iOS app
- `PathOfNurWatch Watch App` exists as a native companion watch app target
- `PathOfNurWatch Watch App Extension` exists as the companion watch extension target
- `PathOfNurTV` exists as a separate native tvOS app target
- iOS app icons exist in `ios/Runner/Assets.xcassets/AppIcon.appiconset`
- iOS `Info.plist` includes location, camera, audio background, URL scheme, and live activities settings
- Flutter build versioning is driven from `pubspec.yaml`

### Not in repo today

- no native tvOS feature-complete release implementation

## Release scope recommendation

### Safe now

- iOS / iPhone
- iPadOS, assuming final device QA passes

### Not submission-ready yet

- watchOS
- tvOS

Those platforms should be treated as future release work, not a checkbox on the current submission.

## Preflight checks

Run these before opening Xcode for a release archive:

```bash
flutter pub get
flutter gen-l10n
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

Recommended focused checks:

```bash
flutter test test/app/router_smoke_test.dart
flutter test test/app/localization_smoke_test.dart
flutter test test/reminder_scheduler_daily_update_test.dart
```

## Versioning

Flutter source of truth:

- file: `pubspec.yaml`
- current format: `version: <marketing-version>+<build-number>`

Apple mapping:

- `CFBundleShortVersionString` <- `FLUTTER_BUILD_NAME`
- `CFBundleVersion` <- `FLUTTER_BUILD_NUMBER`

Before each submission:

1. increment `pubspec.yaml` version
2. run `flutter pub get`
3. rebuild/archive from the updated version

## Localization build steps

Path of Nūr uses ARB-driven localization generation.

Before archive:

```bash
flutter gen-l10n
flutter analyze
flutter test
```

Release check:

- confirm `lib/l10n/` is in sync
- confirm no placeholder-shape mismatches were introduced
- confirm target release locales are actually translated enough for release scope

## iOS host configuration review

### Current Info.plist coverage

`ios/Runner/Info.plist` currently includes:

- `NSLocationAlwaysAndWhenInUseUsageDescription`
- `NSLocationWhenInUseUsageDescription`
- `NSCameraUsageDescription`
- `NSSupportsLiveActivities`
- `NSSupportsLiveActivitiesFrequentUpdates`
- `UIBackgroundModes = audio`
- custom URL scheme `pathofnur`

### Current entitlements

`ios/Runner/Runner.entitlements` currently includes:

- `com.apple.developer.ubiquity-kvstore-identifier`

This supports the current Apple key-value sync posture, but it still requires correct signing and enabled capability in Xcode.

### Current asset truth

- iOS app icons exist in `ios/Runner/Assets.xcassets/AppIcon.appiconset`
- watchOS asset catalog scaffolding exists in `ios/PathOfNurWatch Watch App/Assets.xcassets`, but it does not contain release-ready icon payloads yet
- tvOS asset catalog scaffolding exists in `ios/PathOfNurTV/Assets.xcassets`, but it does not contain release-ready icon payloads yet

### Current bundle structure

Project-level placeholder base:

- `APP_BUNDLE_ID_BASE = com.company.pathofnur`
- `APPLE_DEVELOPMENT_TEAM = YOURTEAMID`

Derived target bundle identifiers:

- iOS app: `$(APP_BUNDLE_ID_BASE)`
- Runner tests: `$(APP_TEST_BUNDLE_ID)` -> `$(APP_BUNDLE_ID_BASE).tests`
- Live Activity extension: `$(APP_LIVE_ACTIVITY_BUNDLE_ID)` -> `$(APP_BUNDLE_ID_BASE).prayerliveactivity`
- watch app: `$(APP_WATCH_APP_BUNDLE_ID)` -> `$(APP_BUNDLE_ID_BASE).watchkitapp`
- watch extension: `$(APP_WATCH_EXTENSION_BUNDLE_ID)` -> `$(APP_WATCH_APP_BUNDLE_ID).watchkitextension`
- tvOS app: `$(APP_TV_BUNDLE_ID)` -> `$(APP_BUNDLE_ID_BASE).tv`
- URL identifier: `$(APP_URL_IDENTIFIER)` -> `$(APP_BUNDLE_ID_BASE)`

Bundle-ID handoff rule:

1. change `APP_BUNDLE_ID_BASE` at the project level
2. let the derived bundle identifiers update automatically
3. do not hand-edit each target unless the suffix pattern itself needs to change

Signing handoff rule:

1. change `APPLE_DEVELOPMENT_TEAM` at the project level
2. let every Apple target inherit the same team automatically
3. only override a target if the receiving Apple account truly requires an exception

### Live Activities

Current extension:

- `PrayerLiveActivityExtension`

Current repo reality:

- the extension exists
- the iOS app embeds it
- release validation still needs real-device testing on a signed build

## iOS archive steps

### Flutter build prep

```bash
flutter build ios --release
```

If using flavor/build defines for release work, keep them explicit:

```bash
flutter build ios --release --dart-define=APP_FLAVOR=prod
```

### Xcode archive flow

1. open `ios/Runner.xcworkspace`
2. select the `Runner` scheme
3. confirm:
   - correct `APPLE_DEVELOPMENT_TEAM` for the receiving Apple team
   - correct `APP_BUNDLE_ID_BASE` for the receiving Apple team
   - signing certificate/provisioning profile resolve cleanly
   - iCloud capability is enabled if iCloud sync is intended
   - Push/notification-related capabilities match the actual product plan
   - derived bundle IDs resolve as expected for:
     - iOS app
     - Live Activity extension
     - watch app / watch extension
     - tvOS app
4. choose a physical-device generic destination
5. `Product` -> `Archive`
6. validate archive in Organizer
7. upload to App Store Connect / TestFlight

## watchOS inclusion notes

Current status:

- native watch companion targets now exist in the Apple project:
  - `PathOfNurWatch Watch App`
  - `PathOfNurWatch Watch App Extension`

Implication:

- the repo now has a real watch companion structure
- watchOS is still not feature-complete or submission-ready

Future work required before claiming watch support:

1. replace placeholder watch app icons with real release assets
2. add real watch companion features such as prayer status, dhikr, and quick actions
3. validate paired install and upgrade behavior on physical devices
4. complete watch-specific signing/provisioning in Xcode
5. decide whether watch ships in the same release train as iOS

## tvOS separate archive notes

Current status:

- a native tvOS app target now exists in the Apple project:
  - `PathOfNurTV`

Implication:

- the repo now has a real separate tvOS app structure
- tvOS is still not feature-complete or submission-ready

Future work required before tvOS submission:

1. replace placeholder tvOS app icons with real release assets
2. build the real tvOS feature set and remote-navigation behavior
3. validate focus engine, Siri Remote input, and playback behavior on physical hardware
4. complete tvOS signing/provisioning in Xcode
5. archive from the `PathOfNurTV` scheme, not the iOS `Runner` scheme

## App Store Connect preparation checklist

### In App Store Connect

- app record created
- bundle identifier matches signed archive
- version/build number match the archive
- privacy policy URL added
- support URL added
- categories selected
- age rating completed
- export compliance answered
- App Privacy questionnaire completed
- TestFlight test information added
- screenshots uploaded
- app description/subtitle/keywords prepared
- release notes prepared

### In Xcode / archive validation

- signing resolves cleanly
- no missing capabilities
- no missing icons
- archive validation passes
- extension bundles sign correctly

## Common failure points

### Signing and entitlements

- team not set for all targets
- `Runner` signs but `PrayerLiveActivityExtension` does not
- iCloud entitlement present in file but capability not enabled in Signing & Capabilities

### Platform truth mismatches

- claiming watchOS support with no watch target
- claiming tvOS support from iOS target settings only

### Metadata and assets

- missing App Store screenshots
- missing marketing icon variants
- display-name inconsistencies
- unfinished App Store Connect text fields

### Localization

- shipping locales with incomplete translations
- regenerating l10n too late and changing signatures immediately before archive

### Notifications / live activities

- no real-device validation for notification permissions
- no real-device validation for live activities behavior

## Release blocker checklist

### Fixed in repo

- practical release submission playbook exists
- current iOS host configuration is documented
- current platform truth is documented
- versioning source of truth is documented
- release validation command set is documented
- iOS `Runner` no longer falsely declares `tvOS` support in Xcode target settings

### Manual outside repo

- Apple signing team selection in Xcode
- provisioning profiles / certificates
- App Store Connect record setup
- privacy/support URLs
- screenshots and store metadata
- real-device notification/live activity QA
- final decision on whether iCloud sync is enabled for release

### Blockers for iOS/TestFlight

- signing not configured in local Xcode environment
- extension signing mismatch
- missing App Store Connect metadata
- missing real-device final QA

### Blockers for watchOS submission

- watch feature set is only scaffolded today
- watch app icons are not release-ready
- no real paired-device QA has been completed
- manual watch signing and provisioning are still required

### Blockers for tvOS submission

- tvOS feature set is only scaffolded today
- tvOS app icons are not release-ready
- no real Apple TV hardware QA has been completed
- manual tvOS signing and provisioning are still required
