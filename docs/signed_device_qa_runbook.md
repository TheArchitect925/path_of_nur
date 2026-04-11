# Signed device QA runbook

This document is the final practical QA pass for signed builds and real devices.

Use it after the repo-side release gate is green and before calling the app release-ready.

## Android signed-release checklist

### Required signing inputs

Provide one of these:

- `android/key.properties` with:
  - `storeFile`
  - `storePassword`
  - `keyAlias`
  - `keyPassword`
- or environment variables:
  - `ANDROID_KEYSTORE_PATH`
  - `ANDROID_KEYSTORE_PASSWORD`
  - `ANDROID_KEY_ALIAS`
  - `ANDROID_KEY_PASSWORD`

### Build steps

1. Add the real keystore inputs.
2. Run:

```bash
flutter build appbundle --release --dart-define=APP_FLAVOR=prod
```

3. If an installable device artifact is needed, also run:

```bash
flutter build apk --release --dart-define=APP_FLAVOR=prod
```

### Expected result

- the build succeeds with real release signing
- the build does not fall back to debug signing
- if signing inputs are missing, Gradle fails immediately with a clear message

### Remaining Android uncertainty

- real notification action behavior still requires physical Android testing
- final store upload validation still depends on the actual signed artifact

## Apple signed-build checklist

### Archive / TestFlight steps

1. Open `ios/Runner.xcworkspace`.
2. Select the `Runner` scheme.
3. Confirm the intended Apple team is selected.
4. Confirm automatic signing resolves for:
   - `Runner`
   - `PrayerLiveActivityExtension`
   - `PathOfNurHomeWidgets`
   - `PathOfNurWatch Watch App`
   - `PathOfNurWatch Watch App Extension`
   - `PathOfNurWatchComplications`
5. Confirm the bundle identifiers resolve as expected.
6. Use a generic iOS device destination.
7. Archive the Release build.
8. Validate the archive.
9. Install the signed build on device or upload to TestFlight.
10. If tvOS is part of the release train, archive `PathOfNurTV` separately only after Apple TV device QA is complete.

### Must-check signing items

- `aps-environment` and provisioning profile match in `ios/Runner/Runner.entitlements`
- iCloud capability enabled for the signed `Runner` target
- app group capability alignment for Runner and all included Apple companions:
  - `PathOfNurHomeWidgets`
  - `PathOfNurWatch Watch App Extension`
  - `PathOfNurWatchComplications`
- live activity extension signing resolves cleanly

### Must-check Apple runtime items

- prayer notification actions on a signed iPhone build
- Dynamic Island and lock screen live activity behavior
- iPhone widget rendering, refresh, and deep-link behavior
- iCloud availability on a signed-in Apple device
- iCloud propagation across two Apple devices
- Qur'an playback with background and lock-screen controls
- Apple Watch snapshot sync, prayer completion replay, dhikr sync, and complication freshness
- Apple TV focus and remote navigation sanity if tvOS is being prepared for distribution

## Device QA matrix

| Flow | Platform | Test steps | Expected result | Severity if broken |
|---|---|---|---|---|
| Prayer reminder appears | Android, iPhone | Enable prayer reminders and wait for the scheduled reminder. | Reminder appears at the expected time with the expected title, body, and actions. | High |
| Remind me in 5 min | Android, iPhone | Tap `Remind me in 5 min` from a prayer notification. | A replacement reminder appears about 5 minutes later without duplicate stacking. | High |
| Remind me in 10 min | Android, iPhone | Tap `Remind me in 10 min` from a prayer notification. | A replacement reminder appears about 10 minutes later without duplicate stacking. | High |
| Mark Salah as offered | Android, iPhone | Tap `Mark Salah as offered` from a prayer notification. | The correct prayer and logical date update to offered and follow-up reminders clear. | High |
| Notification tap route | Android, iPhone | Tap the notification body instead of an action button. | The app opens the intended route cleanly. | Medium |
| Qur'an playback with screen lock/background | iPhone, iPad | Start Qur'an playback, lock the device, use system controls, then return to the app. | Playback state remains coherent and resumes correctly. | High |
| Dynamic Island prayer state transitions | iPhone | Observe a prayer live activity near a prayer boundary. | Dynamic Island shows stable current and next prayer state transitions. | High |
| Lock screen prayer state transitions | iPhone | Observe the prayer live activity on the lock screen across a prayer boundary. | Lock screen state updates correctly without stale countdown behavior. | High |
| Home historical Salah editing | Android, iPhone, iPad | Change the Home prayer date, mark or unmark a historical salah, then return to today. | Historical state persists correctly and today remains correct. | Medium |
| iCloud availability and write success | iPhone, iPad | Sign into iCloud, enable the feature path, and trigger a sync write. | The app reports iCloud available and the write succeeds. | High |
| iCloud propagation to second Apple device | iPhone, iPad | Make a synced change on device A and observe device B on the same iCloud account. | The change appears on the second device after sync propagation. | High |

## Failure logging

Use the issue template in [release_issue_template.md](/Users/shahabmansoor/Developer/path_of_nur/docs/release_issue_template.md).

## Recommended fix batching if QA fails

Split failures into small targeted batches:

1. Android signing or packaging failures
2. Apple signing, entitlements, or archive failures
3. Notification action failures
4. Live activity or playback failures
5. iCloud availability or propagation failures
6. Lower-risk state bugs such as historical Salah editing
