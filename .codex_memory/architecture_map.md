# Architecture Map

Last updated: 2026-03-17

## Core app shell

- Entry: `lib/main.dart`
- App container: `PathOfNurApp` in `lib/app/app.dart`
- Navigation: `GoRouter` in `lib/app/app_router.dart`
- Shared support routes: `lib/app/routes/core_support_routes.dart`
- State management: Riverpod providers/notifiers across feature modules

## Persistence layers

- Lightweight/profile settings/state:
  - `SharedPreferences` through `LocalStore`
  - key examples:
    - `settings.profile`
    - `profile.locale`
    - `learn.journey.progress.v1`
    - `accounts_sync.state.v1`
- Structured local data:
  - `sqlite3` through `AppDatabase`
  - tables include:
    - `prayer_records`
    - `dhikr_state`
    - `dhikr_sessions`
    - `ocean_events`
    - `ocean_state`
    - `device_registry`
    - `sync_outbox`
    - `sync_cursor`

## Major domain boundaries

- `lib/features/onboarding`
  - first-run setup, onboarding preferences, reminder defaults
- `lib/features/home`
  - dashboard and day summary
- `lib/features/worship`
  - prayer, dhikr, fasting, khusu, qibla-linked flows
- `lib/features/learn`
  - the largest product area; contains multiple overlapping old/new learning systems
- `lib/features/journey`
  - growth/journey/rewards/habits/reflection
- `lib/features/profile`
  - settings-first ownership replacing the old profile-tab model
- `lib/features/accounts_sync`
  - profiles, accounts, backup/import/export, shared-device flow, sync foundations
- `lib/core/reminders`
  - notifications, adhan audio, live activity, scheduling
- `lib/features/watch_companion`
  - phone-side watch contract and diagnostics

## Architectural seams to preserve

- Settings is the current owner for profile/personalization surfaces.
- Learn is mid-migration:
  - journey-first `/learn`
  - dedicated Qur'an tab
  - legacy Learn hub still exists at `/learn/legacy`
- Sync is local-first with optional Apple iCloud transport.
- Watch/tv/platform companion code exists, but release docs are the source of truth for readiness.

## Known unstable seams

- Learn route ownership and information architecture
- Localization parity across active pages
- Settings/profile migration away from old profile-tab assumptions
- Platform-specific readiness around iOS simulator behavior, watch, macOS, and tvOS
