# Path of Nūr Release Readiness Checklist

## 1) Tests
- Run unit/widget tests: `flutter test`
- Run golden tests (first-time baseline): `flutter test test/release_readiness_golden_test.dart --update-goldens`
- Run golden verification: `flutter test test/release_readiness_golden_test.dart`
- Run integration flows: `flutter test integration_test/core_user_flows_test.dart`

## 2) Analyze & Build
- Static analysis: `flutter analyze`
- iOS debug smoke: `flutter run`
- iOS release smoke: `flutter build ios --release --dart-define=APP_FLAVOR=prod`
- Before opening Xcode packaging flow: review **Attributions & Licenses** page and re-verify source permissions/licensing for Qur'an text, translations, transliteration, audio, and API usage.

## 3) Flavors
- Supported runtime flavors via `APP_FLAVOR`:
  - `dev`
  - `staging`
  - `prod`
- Example:
  - `flutter run --dart-define=APP_FLAVOR=dev`
  - `flutter build ipa --dart-define=APP_FLAVOR=prod`

## 4) Privacy / Permissions
- Verify `Info.plist` permission strings:
  - Location usage for prayer/Qibla/mosques.
- Ensure Privacy Policy and Terms routes are reachable:
  - `/legal/privacy`
  - `/legal/terms`
  - `/legal/support`
  - `/legal/attributions`

## 5) Deep Links & Route Guards
- Verify legacy redirects:
  - `/quran/explorer` -> `/learn/quran/explorer`
  - `/quran/search` -> `/learn/quran/search`
- Verify invalid circle IDs fallback to circles discovery.
- Verify unknown routes show safe fallback screen.

## 6) Accessibility
- Confirm bottom-nav has semantics labels and selected state.
- Check text scaling (system large fonts) on Home, Worship, Learn, Journey, Profile.
- Verify interactive tap targets remain comfortable (>= 44x44 where possible).

## 7) Telemetry (Local Instrumentation)
- Crash handler enabled at app bootstrap.
- Navigation screen views captured through telemetry observer.
- Logs retained locally for support diagnostics.

## 8) TestFlight Submission
- App icon / launch assets validated.
- Build number incremented.
- Release notes included.
- Support URL / privacy URL in App Store Connect.
- Export compliance / age rating completed.
