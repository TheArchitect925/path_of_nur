# Path of Nūr Release Readiness Checklist

## 1) Tests
- Minimum reliable release gate:
  - `flutter analyze`
  - `flutter test test/core/reminders/local_notification_service_test.dart test/app/router_smoke_test.dart test/app/router_deep_links_test.dart test/app/localization_smoke_test.dart test/app/locale_integration_test.dart test/features/accounts_sync/sync_foundation_test.dart test/features/accounts_sync/accounts_sync_controller_test.dart`
- Broader non-blocking verification:
  - `flutter test`
  - `flutter test test/release_readiness_golden_test.dart`
  - `flutter test integration_test/core_user_flows_test.dart`
- Use the minimum reliable release gate as the ship/no-ship baseline.
- The integration smoke is current again, but it still depends on native test infrastructure and should be treated as a signed-device/manual-supporting check rather than the only ship gate.

## 2) Analyze & Build
- Static analysis: `flutter analyze`
- iOS debug smoke: `flutter run`
- iOS release smoke: `flutter build ios --release --dart-define=APP_FLAVOR=prod`
- Android release smoke: `flutter build appbundle --release --dart-define=APP_FLAVOR=prod`
- Android release signing must come from either:
  - `android/key.properties`
  - or environment variables: `ANDROID_KEYSTORE_PATH`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`
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
- Verify canonical product ownership:
  - `/learn` opens the Learning discovery landing, not the legacy Learn page
  - Settings is reached through `/settings` and Home/settings entry points, not a bottom-tab Profile destination
  - growth deep links normalize to `/journey/today`, `/journey/reflection`, `/journey/progress`, and `/journey/habits`
- Verify invalid circle IDs fallback to circles discovery.
- Verify unknown routes show safe fallback screen.

## 6) Accessibility
- Confirm bottom-nav has semantics labels and selected state.
- Check text scaling (system large fonts) on Home, Worship, Learn, Journey, Settings.
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

## 9) Signed-device QA
- Run the signed-device checklist in [docs/signed_device_qa_runbook.md](/Users/shahabmansoor/Developer/path_of_nur/docs/signed_device_qa_runbook.md).
- Log any signed-device failures with [docs/release_issue_template.md](/Users/shahabmansoor/Developer/path_of_nur/docs/release_issue_template.md).
