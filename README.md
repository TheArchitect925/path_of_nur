# Path of Nūr

Path of Nūr is a Flutter application for daily Islamic practice, Qur'an engagement, guided learning, reflection, and habit-building. The project combines worship tools, learning systems, local-first personalization, and profile-aware routines in a single app.

## Project overview

The app is designed to support:
- daily worship habits
- Qur'an reading and study
- guided Islamic learning
- reflection and growth tracking
- profile-aware use on personal and shared devices

The current codebase is local-first and mobile-first. It includes substantial product work for iOS and Android, with Apple expansion work planned separately for watchOS and tvOS.

## App purpose

Path of Nūr aims to help users:
- stay consistent with prayer, dhikr, fasting, and Qur'an practice
- learn through structured, UI-driven Islamic learning surfaces
- build healthy spiritual routines over time
- use the app safely on personal or shared family devices

## Platform status

Current practical status:
- `iOS`: active target
- `Android`: active Flutter target
- `watchOS`: planned, not a production companion app in this repo yet
- `tvOS`: planned, not a production app target in this repo yet

Release posture:
- the current repo is strongest on iOS/mobile Flutter workflows
- watchOS and tvOS should be treated as future platform work, not finished products

## Major features

- Worship
  - prayer tracking
  - dhikr
  - fasting
  - khushu focus
  - qibla support
- Qur'an
  - reader
  - search
  - bookmarks
  - notes
  - topics
  - top words
  - word review
  - Names of Allah
- Learn
  - learning journey shell
  - prophets
  - hadith
  - duas
  - quizzes and trivia
  - salah learning
  - Qur'anic Arabic / teaching flows
  - life and world learning surfaces
- Journey / Growth
  - daily growth entry
  - reflection
  - habits
  - paths
  - ocean rewards
  - wallpapers
- Profiles / Sync
  - profile-aware experience
  - shared-device safety flow
  - backup / import / export
  - local-first sync foundations

## Tech stack

- Flutter
- Dart
- Riverpod
- GoRouter
- Intl / ARB localization
- Shared Preferences
- SQLite
- Local notifications
- Audio / background audio
- Camera / geolocation / permissions

## Setup

### Prerequisites

- Flutter SDK installed and on `PATH`
- Xcode for iOS work
- Android Studio or Android SDK for Android work
- CocoaPods for iOS dependency installation

### First-time setup

```bash
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
```

For iOS:

```bash
cd ios
pod install
cd ..
```

## Localization workflow

Localization uses ARB files under `lib/l10n/`.

Common commands:

```bash
flutter gen-l10n
flutter analyze
```

Notes:
- keep placeholder shapes aligned across locale files
- do not hardcode user-facing strings in new UI work
- treat `app_en.arb` as the source of truth for key structure

## Common Flutter commands

Run the app:

```bash
flutter run
```

Run on a specific device:

```bash
flutter devices
flutter run -d <device-id>
```

Format code:

```bash
dart format .
```

Static analysis:

```bash
flutter analyze
```

Generate localization output:

```bash
flutter gen-l10n
```

## Test commands

Run the full test suite:

```bash
flutter test
```

Run a focused file:

```bash
flutter test test/app/router_smoke_test.dart
```

## Release and build notes

iOS:

```bash
flutter build ios --release
```

Android APK:

```bash
flutter build apk --release
```

Android App Bundle:

```bash
flutter build appbundle --release
```

Important:
- signing, certificates, provisioning, and store metadata are manual release responsibilities
- watchOS and tvOS release flows are not complete in this repo yet
- local backup/import/export is part of the current practical data-safety story

## Current status and known limitations

- the app is feature-rich but still has active hardening work in progress
- watchOS and tvOS are planned, not finished release targets
- some broad translation coverage outside the highest-priority release UI slices may still be incomplete depending on locale
- cloud sync should not be treated as a finished backend product in this repository

Useful internal docs:
- [RELEASE_READINESS_CHECKLIST.md](RELEASE_READINESS_CHECKLIST.md)
- [docs/release_target_readiness.md](docs/release_target_readiness.md)
- [docs/apple_icloud_sync_release_checklist.md](docs/apple_icloud_sync_release_checklist.md)

## Repository structure

High-level layout:

```text
lib/
  app/                  App bootstrap, router, shell
  core/                 Shared services, persistence, notifications, prayer logic
  features/             Product feature areas
  l10n/                 ARB localization files
  shared/               Shared widgets, theme, utilities
test/                   Widget and integration-oriented test coverage
ios/                    iOS host app and Apple platform project files
android/                Android host app files
docs/                   Audit notes, release docs, engineering follow-ups
```

Feature ownership is primarily under `lib/features/`, while cross-cutting concerns live under `lib/core/` and `lib/shared/`.

## Development notes

Before making broad changes:
- read [AGENTS.md](AGENTS.md)
- check any current backlog or audit doc relevant to your area
- keep product routes explicit instead of adding generic fallback scaffolding
- preserve localization discipline and Islamic content guardrails already established in the repo

For day-to-day contributor commands and PR checks, see [DEVELOPMENT.md](DEVELOPMENT.md).
