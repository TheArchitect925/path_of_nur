# Build Health Enhancement Backlog

Last updated: 2026-03-18

## Follow-up options from the build health pass

1. Investigate the repeated `This FlutterEngine was already invoked.` simulator/runtime log and confirm whether it is expected warm-up behavior or duplicate engine bootstrap.
2. Add a CI-safe iOS simulator smoke command that runs `flutter analyze`, key route/widget tests, and a lightweight `xcodebuild`/`flutter run` validation.
3. Reduce the current localization debt surfaced during launch so simulator builds stop printing large untranslated-message counts.
4. Add a small Xcode project regression check for embedded target bundle identifiers so watch/live activity/tvOS bundle ID drift is caught before install time.
5. Add a narrow iOS watch-sync bridge regression test or native validation helper for property-list-safe payload persistence, so future watch snapshot schema changes cannot crash on `UserDefaults`.
6. Investigate the duplicate startup publish / `This FlutterEngine was already invoked.` log to confirm whether the watch runtime bridge is being bootstrapped twice or whether this is expected engine warm-up behavior.
7. Add a small release-preflight checklist or script that verifies `pubspec.yaml`, `MARKETING_VERSION`, and `CURRENT_PROJECT_VERSION` stay aligned before each App Store/TestFlight archive.
