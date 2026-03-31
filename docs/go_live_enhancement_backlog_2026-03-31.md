# Go-Live Enhancement Backlog

Date: 2026-03-31

These are enhancement options beyond the strict launch blockers.

## Highest-value enhancements

- Add a release-locale gate so App Store language claims cannot exceed the set of locales that pass key parity, placeholder parity, and manual QA.
- Add a one-command signed-device smoke checklist for iPhone/iPad covering first launch, reminders, background Qur'an playback, backup, restore, and auth.
- Add targeted widget/integration coverage for Settings and Accounts/Sync empty/error/loading states.
- Add a focused performance audit and incremental refactor plan for the largest active surfaces:
  - Qur'an reader
  - Home
  - Settings
  - Accounts/Sync
- Add a launch dashboard doc that records the latest green analyzer/test/build/archive/device-QA status in one place.

## Apple / platform enhancements

- Fix the watch archive packaging issue by making the watch app archive expose `CFBundleIconName=AppIcon` and ensuring the icon catalog is release-complete.
- Add a CI-safe Apple bundle/archive check that catches watch icon packaging regressions before manual release prep.
- Add a small script that summarizes resolved Apple bundle IDs, development team values, and embedded-target relationships from Xcode build settings.
- Add explicit go/no-go evidence capture for signed archives, TestFlight uploads, and real-device QA runs.

## Localization enhancements

- Repair locale placeholder mismatches before any further translation import work.
- Narrow the first-release locale set unless there is capacity to complete and QA all currently declared locales.
- Add CI enforcement for localization validation so missing keys and placeholder mismatches fail before release branches drift.
- Finish Settings and Accounts/Sync localization as the highest-value remaining product surfaces.

## Product-truth enhancements

- Add a launch copy review to ensure marketing/store text does not imply:
  - watch launch readiness
  - tvOS launch readiness
  - full production cloud sync
- Add a concise user-facing backup/sync explanation inside the app so the local-first posture is clear before launch.
