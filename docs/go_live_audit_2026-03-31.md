# Go-Live Audit

Date: 2026-03-31

Scope:
- Full-system release-readiness audit for the current repository state
- Evidence gathered from continuity memory, release docs, validation scripts, analysis, tests, localization validation, and Apple preflight/archive tooling

## Recommended release scope today

Safe first-release scope:
- iOS
- iPadOS

Do not include in go-live scope yet:
- Apple Watch
- tvOS
- any claim of full production cloud sync
- multilingual release beyond locales that are truly translated and QA-validated

## What passed in this audit

- `flutter analyze`
- documented minimum release test slice:
  - `test/core/reminders/local_notification_service_test.dart`
  - `test/app/router_smoke_test.dart`
  - `test/app/router_deep_links_test.dart`
  - `test/app/localization_smoke_test.dart`
  - `test/app/locale_integration_test.dart`
  - `test/features/accounts_sync/sync_foundation_test.dart`
  - `test/features/accounts_sync/accounts_sync_controller_test.dart`
- Apple signing doctor
- iOS simulator build via `scripts/ci_ios_watchos_preflight.sh`
- watchOS simulator build via `scripts/ci_ios_watchos_preflight.sh`
- no-codesign iOS archive via `scripts/ci_ios_watchos_preflight.sh`

## What failed or remains blocked

### 1. Multilingual release readiness is not safe yet

`tools/localization_validate.py` still reports missing keys and placeholder mismatches across non-English locales:
- `ar`: missing `2`, extra `70`, placeholder mismatches `0`
- `bn`: missing `2`, extra `73`, placeholder mismatches `61`
- `de`: missing `2`, extra `70`, placeholder mismatches `0`
- `fa`: missing `2`, extra `73`, placeholder mismatches `68`
- `fa_AF`: missing `2`, extra `73`, placeholder mismatches `68`
- `ha`: missing `2`, extra `73`, placeholder mismatches `0`
- `hi`: missing `2`, extra `70`, placeholder mismatches `36`
- `id`: missing `2`, extra `73`, placeholder mismatches `61`
- `ku`: missing `2`, extra `72`, placeholder mismatches `21`
- `ms`: missing `2`, extra `73`, placeholder mismatches `61`
- `pa`: missing `2`, extra `73`, placeholder mismatches `15`
- `ps`: missing `2`, extra `72`, placeholder mismatches `0`
- `tg`: missing `2`, extra `72`, placeholder mismatches `0`
- `tr`: missing `2`, extra `72`, placeholder mismatches `35`
- `ur`: missing `2`, extra `70`, placeholder mismatches `0`

Supporting i18n audit docs also still describe much larger translation-coverage debt across active user flows, especially Settings, Accounts/Sync, Prayer, Notifications, Growth, Home, and large Learn/Qur'an-learning surfaces.

### 2. Apple Watch is still not launch-ready

The native watch simulator build now succeeds, but archive packaging validation still fails with:
- `Watch app archive is missing CFBundleIconName=AppIcon`

This confirms watch support should stay out of launch scope until archive packaging, icon assets, signing, and paired-device QA are completed.

### 3. Signed-device QA is still a release gate

Repository validation is strong, but these still require real hardware or signed distribution verification:
- prayer notification actions on iPhone and Android
- Dynamic Island / lock-screen live activity behavior
- background and lock-screen Qur'an playback
- Apple sign-in
- Google sign-in
- iCloud backup transport and cross-device propagation
- Google Drive backup transport and restore
- auto-backup launch/resume/background behavior
- accessibility with large text and screen readers on primary tabs

### 4. Product scope needs honest launch messaging

Current repo and docs are clear that the real release posture is:
- local-first
- manual backup/import/export
- Apple iCloud support on signed Apple devices

The app should not be marketed as if it already has a full cloud-account backend.

## High-risk surfaces to target before launch

These are large, high-traffic files that deserve focused stability/performance review:
- `lib/features/learn/quran/presentation/quran_reader_page.dart` (`4441` lines)
- `lib/features/home/presentation/home_page.dart` (`2952` lines)
- `lib/features/profile/presentation/settings_page.dart` (`3108` lines)
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart` (`2947` lines)

## Go-live recommendation

Status today:
- not yet ready for a broad public go-live

Closest honest release recommendation:
- proceed toward an iOS/iPadOS-only launch
- keep watchOS and tvOS out of public release claims
- treat multilingual release as blocked until locale integrity and translation coverage are intentionally narrowed or completed

## Required next actions before go-live

1. Decide the real launch locale set.
   - If launch is English-only, update public/store language claims accordingly.
   - If multilingual launch is required, finish locale integrity and translation QA first.
2. Complete signed-device QA for notifications, playback, auth, backup/restore, and live activities.
3. Keep Apple Watch out of launch until archive packaging, icons, signing, and paired-device QA pass.
4. Run a final accessibility pass on Home, Worship, Learn, Journey, Settings, and Qur'an.
5. Do one focused performance/hardening pass on Qur'an reader, Home, Settings, and Accounts/Sync.
6. Re-run Apple archive validation after any Apple asset or capability changes.
