# Release Readiness Audit

Date: 2026-03-25

Scope:
- Follow-up audit after the full app feature inventory.
- Focused on practical release readiness for the documented first-release scope.
- Anchored in current release docs, continuity inventory, route/test coverage, and current command validation.

## 1. Current release posture

Recommended first-release scope remains:
- iOS
- iPadOS

Conditional only:
- macOS

Not first-release ready:
- Apple Watch
- tvOS
- any claimed production cloud-sync platform

Source references:
- `docs/release_target_readiness.md`
- `.codex_memory/platform_inventory.md`

## 2. Validation run in this audit

### Passed

- documented minimum release test slice passed:
  - `test/core/reminders/local_notification_service_test.dart`
  - `test/app/router_smoke_test.dart`
  - `test/app/router_deep_links_test.dart`
  - `test/app/localization_smoke_test.dart`
  - `test/app/locale_integration_test.dart`
  - `test/features/accounts_sync/sync_foundation_test.dart`
  - `test/features/accounts_sync/accounts_sync_controller_test.dart`

### Failed

- `flutter analyze`
  - current failure:
    - `test/features/learn/quran/quran_reader_playback_harness_test.dart:40`
    - `QuranReaderPlaybackControlsCard` is referenced but not defined in the current imported surface

## 3. Release gate status summary

### A. Static analysis gate

Status:
- `not ready`

Reason:
- the documented baseline static-analysis gate is currently red

Impact:
- even though the minimum test slice passes, the repository is not at a clean ship baseline until the analyzer error is resolved

### B. Routing and navigation confidence

Status:
- `mostly ready with known compatibility debt`

Strengths:
- top-level shell routing is covered by router smoke tests
- deep-link normalization exists for home, worship, growth, quran, learn, garden, and tracking
- onboarding and shared-device redirects are implemented and tested
- legacy route compatibility is intentionally covered in tests

Risks:
- Learn and Qur'an still retain compatibility aliases that can confuse ownership
- release risk is not mainly broken routing today; it is product clarity and long-term maintenance drift

### C. Localization readiness

Status:
- `partially ready`

Strengths:
- generated localization is wired and smoke-tested across supported locales
- locale propagation and Arabic RTL behavior are already covered in tests

Known blockers:
- localization backlog still identifies hardcoded user-facing strings across high-value screens
- highest-risk localization pages remain:
  - `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart`
  - `lib/features/profile/presentation/settings_page.dart`
  - `lib/features/journey/presentation/growth_reflection_page.dart`
  - `lib/features/worship/presentation/widgets/dhikr_section.dart`
  - `lib/features/worship/presentation/widgets/prayer_section.dart`
  - `lib/features/onboarding/presentation/onboarding_page.dart`

Assessment:
- locale infrastructure is release-capable
- copy coverage is not yet release-complete across active high-traffic surfaces

### D. Accounts / sync / backup readiness

Status:
- `feature-complete but QA-gated`

Strengths:
- local-first posture is documented honestly
- manual import/export/backup, restore preview, auto-backup, and sync-scope controls are implemented
- core accounts/sync tests in the documented release slice are passing

Open release risks:
- real-device QA is still required for:
  - Apple sign-in
  - Google sign-in
  - iCloud backup transport
  - Google Drive appData backup transport
  - restore confirmation flows
  - auto-backup lifecycle triggers

Assessment:
- good code-level confidence
- not safe to overstate production readiness without device verification

### E. Accessibility readiness

Status:
- `unknown / incomplete`

What is in place:
- release checklist explicitly calls out text scaling and tap-target review
- some modern shared scaffolds and shells should help consistency

What is missing from this audit:
- no current device-verified evidence was found here for:
  - large-text passes across top tabs
  - VoiceOver/TalkBack ordering on major screens
  - touch-target validation on dense dashboards and game boards

Assessment:
- accessibility should be treated as an open release workstream, not assumed complete

### F. Performance risk on high-traffic surfaces

Status:
- `moderate risk`

High-risk-by-surface observations:
- `lib/features/learn/quran/presentation/quran_reader_page.dart`
  - very large route page (`4441` lines)
  - likely highest-risk surface for rebuild pressure, playback UI coupling, and regression churn
- `lib/features/home/presentation/home_page.dart`
  - very large dashboard page (`2952` lines)
  - likely sensitive to rebuild scope, async summary loading, and layout depth
- `lib/features/profile/presentation/settings_page.dart`
  - very large settings surface (`3108` lines)
  - localization debt and control density increase QA complexity
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart`
  - very large flow page (`2947` lines)
  - feature breadth and copy density make it a release-risk hotspot

Assessment:
- no measured profiling was run in this pass
- page size and feature density make Qur'an reader, Home, Settings, and Accounts/Sync the strongest candidates for targeted performance review before release

### G. Platform readiness

Status:
- `mixed`

iOS / iPadOS:
- best current release target

macOS:
- conditional only pending signed-build validation

Apple Watch:
- code and native target presence exist
- still not launch-ready without paired-device QA, signing, and notification/sync validation

tvOS:
- active V1 shell exists
- parity expectation exists
- still not launch-ready

## 4. Top release blockers

1. `flutter analyze` is currently failing because of the broken Qur'an playback harness test reference.
2. Localization is not yet complete on major active screens, especially Settings and Accounts/Sync.
3. Sync/backup flows need real signed-device validation before release claims are trustworthy.
4. Accessibility validation is still under-documented for large text and screen readers on primary tabs.

## 5. Top non-blocking but important risks

1. Learn/Qur'an compatibility aliases can still blur product ownership.
2. Very large pages raise maintainability and performance risk even where current behavior is functional.
3. Discovery/community extras exist, but their release priority is less clear than core worship/Qur'an/learn flows.

## 6. Recommended next actions in order

1. Fix the analyzer failure in `test/features/learn/quran/quran_reader_playback_harness_test.dart`.
2. Run a targeted localization completion pass for:
   - Settings
   - Accounts/Sync
   - active Worship sections
   - key onboarding copy
3. Run signed-device QA for:
   - Apple sign-in
   - Google sign-in
   - iCloud backup/restore
   - Google Drive backup/restore
   - auto-backup lifecycle triggers
4. Run accessibility QA on:
   - Home
   - Worship
   - Learn
   - Journey
   - Settings
   - Qur'an reader
5. Run a focused performance audit on:
   - Qur'an reader
   - Home dashboard
   - Settings
   - Accounts/Sync

## 7. Release recommendation

Do not treat the app as clean ship-ready today.

Closest honest statement:
- the project has strong feature breadth and a passing minimum route/localization/accounts test slice
- iOS and iPadOS remain the right first-release target
- release readiness is currently held back by one analyzer regression, localization debt on high-traffic screens, and incomplete signed-device/accessibility validation
