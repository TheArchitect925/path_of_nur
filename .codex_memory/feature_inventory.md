# Feature Inventory

Last updated: 2026-03-18

Status legend:

- `implemented`
- `partial`
- `scaffolded`
- `deprecated/removed`
- `risky/inconsistent`

## Onboarding

- implemented:
  - onboarding flow
  - language/locale preference capture
  - learning age group / experience / salah consistency inputs
  - prayer method and madhab capture
  - reminder defaults and dhikr preference capture
- risky/inconsistent:
  - onboarding choices must continue to flow into localization, prayer prefs, and learn path setup without drift

## Home

- implemented:
  - main dashboard
  - daily overview and prayer-facing summary
- partial:
  - still carries localization debt in active surfaces
- risky/inconsistent:
  - should stay aligned with Worship and Growth summaries, not become a separate state silo

## Worship

- implemented:
  - prayer tracking/status
  - dhikr presets/sessions
  - fasting support
  - khusu focus
  - qibla finder
- partial:
  - some copy/localization debt remains
- deprecated/removed:
  - `worship_page_legacy.dart`

## Qur'an

- implemented:
  - top-level Qur'an tab
  - reader, explorer, search, bookmarks, notes
  - topics, names of Allah, top words, word review
  - Qur'an learning and Qur'anic Arabic entrypoints
- risky/inconsistent:
  - old Learn-owned aliases still exist and can confuse ownership
  - new work should prefer Qur'an-owned routes and avoid duplicating reader/study entrypoints

## Learn

- implemented:
  - journey-first `/learn`
  - large set of existing learn domains and shared tools
  - legacy Learn hub still available at `/learn/legacy`
- partial:
  - multiple systems overlap:
    - learning journey
    - legacy Learn hub
    - hub-by-section routes
    - dedicated domain routes
- risky/inconsistent:
  - strongest architectural seam in the repo
  - easiest place for duplicate work

## Journey / growth

- implemented:
  - growth home/today/reflection/journey/habits
  - path detail and habit detail
  - Ocean drops and wallpaper unlock integration
- partial:
  - some richer node-detail ideas were removed and not yet replaced with real surfaces
- deprecated/removed:
  - `journey_legacy_page.dart`
  - `journey_widgets.dart`

## Settings

- implemented:
  - settings-first ownership for profile/personalization, appearance, notifications, privacy, language, about
  - links into accounts/sync and family learning management
- partial:
  - high localization debt
  - route migration still keeps `/profile/*` compatibility aliases
- deprecated/removed:
  - top-level `profile_page.dart`

## Profiles / accounts

- implemented:
  - profile/account/domain models
  - shared-device mode
  - profile picker
  - profile/account/device management pages
- partial:
  - auth/account providers are modelled, but production backend auth is not present
- risky/inconsistent:
  - avoid implying full cloud account infrastructure exists

## Sync / backup / import / export

- implemented:
  - outbox/cursor storage
  - manual backup/export/import flows
  - iCloud transport bridge on Apple platforms
- partial:
  - production cloud sync is not implemented in this repo
- risky/inconsistent:
  - docs explicitly constrain release posture to local-first + manual backup + iCloud

## Notifications / reminders / adhan

- implemented:
  - local notification service
  - reminder scheduler
  - adhan audio selection and playback
  - fasting/prayer live activity support
- partial:
  - some platform-specific validation still needed

## Media / audio

- implemented:
  - just_audio + background audio for Qur'an
  - adhan audio assets and preview
  - Qur'anic Arabic teaching audio assets
- risky/inconsistent:
  - avoid new media flows that bypass existing audio providers/repositories

## Watch / TV / platform-specific surfaces

- implemented:
  - watch contract logic and QA/testing docs
  - native Apple Watch V1 companion app integrated into `ios/Runner.xcodeproj`
  - watch Home, Prayer check-in, Dhikr counter, Progress, and Utility surfaces
  - watch/iPhone WatchConnectivity bridge with cached snapshot + queued action recovery
  - complication/widget foundation for next prayer and daily progress
- partial:
  - watch real-data behavior still depends on the Flutter snapshot/reconciler bridge being active on the phone
  - release validation is incomplete
- partial:
  - canonical tvOS native surface in `ios/PathOfNurTV`
  - mirrored Home prayer and Qur'an V1 shell with seeded data and native playback wiring
- risky/inconsistent:
  - code presence does not equal release readiness
  - mirrored Home prayer and Qur'an surfaces should stay in parity review with mobile changes unless platform constraints justify divergence
  - watch reward projection is intentionally optimistic and must defer final truth to phone-side app logic
