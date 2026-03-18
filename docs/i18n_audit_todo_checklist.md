# i18n Audit TODO Checklist

Derived from `docs/i18n_audit_report.md`.

## Phase 1

- [ ] Sweep direct hardcoded labels, buttons, dialogs, and section headers in high-traffic presentation widgets.
- [ ] Fix Accounts / Sync, Onboarding, Home, Learn, and Ocean first.
- [ ] Localize shared widgets such as location pickers and Quran action blocks.

## Phase 2

- [ ] Localize Settings / Profile and prayer-related configuration flows.
- [ ] Localize notification content and reminder channel labels.
- [ ] Localize learning/family/kids/community surfaces end to end.

## Phase 3

- [ ] Introduce formatting/template/plural helpers.
- [ ] Refactor helper-return APIs and enum label mappers.
- [ ] Normalize shared widget contracts around localized inputs.

## Phase 4

- [ ] Run the scan again after fixes.
- [ ] Reduce untranslated locale counts.
- [ ] Verify RTL, overflow, semantics, and notifications manually.

## Quick Wins

- [ ] `lib/core/reminders/local_notification_service.dart:221` — Path of Nur
- [ ] `lib/core/reminders/local_notification_service.dart:311` — Path of Nur
- [ ] `lib/core/reminders/local_notification_service.dart:332` — Dhikr reminder
- [ ] `lib/core/reminders/local_notification_service.dart:336` — Daily reflection
- [ ] `lib/core/reminders/local_notification_service.dart:338` — Fasting reminder
- [ ] `lib/core/reminders/local_notification_service.dart:340` — Cycle check-in
- [ ] `lib/core/reminders/local_notification_service.dart:351` — Take a calm moment for dhikr.
- [ ] `lib/core/reminders/local_notification_service.dart:355` — Capture a brief reflection before your day ends.
- [ ] `lib/core/reminders/local_notification_service.dart:357` — Prepare your intention for fasting today.
- [ ] `lib/core/reminders/local_notification_service.dart:359` — Review your status and resume prayer reminders when ready.
- [ ] `lib/core/reminders/local_notification_service.dart:428` — Path of Nur
- [ ] `lib/features/accounts_sync/application/accounts_sync_controller.dart:1454` — This iPhone
- [ ] `lib/features/accounts_sync/application/accounts_sync_controller.dart:1456` — This iPad
- [ ] `lib/features/accounts_sync/application/accounts_sync_controller.dart:1458` — Apple Watch
- [ ] `lib/features/accounts_sync/application/accounts_sync_controller.dart:1460` — This Apple Device
- [ ] `lib/features/accounts_sync/application/accounts_sync_controller.dart:1462` — This Android Phone
- [ ] `lib/features/accounts_sync/application/accounts_sync_controller.dart:1464` — This Android Tablet
- [ ] `lib/features/accounts_sync/application/accounts_sync_controller.dart:1466` — Wear OS Watch
- [ ] `lib/features/accounts_sync/application/accounts_sync_controller.dart:1468` — Android TV
- [ ] `lib/features/accounts_sync/application/sync_foundation.dart:993` — Apple Device
- [ ] `lib/features/accounts_sync/application/sync_foundation.dart:995` — Android Device
- [ ] `lib/features/accounts_sync/application/sync_foundation.dart:999` — Windows PC
- [ ] `lib/features/accounts_sync/application/sync_foundation.dart:1001` — Linux Device
- [ ] `lib/features/accounts_sync/application/sync_foundation.dart:1003` — Path of Nur Device
- [ ] `lib/features/celestial/application/celestial_services.dart:287` — Dawn is unfolding
- [ ] `lib/features/celestial/application/celestial_services.dart:289` — Dusk is settling
- [ ] `lib/features/celestial/application/celestial_services.dart:596` — New moon
- [ ] `lib/features/celestial/application/celestial_services.dart:597` — Waxing crescent
- [ ] `lib/features/celestial/application/celestial_services.dart:598` — First quarter
- [ ] `lib/features/celestial/application/celestial_services.dart:599` — Waxing gibbous
- [ ] `lib/features/celestial/application/celestial_services.dart:600` — Full moon
- [ ] `lib/features/celestial/application/celestial_services.dart:601` — Waning gibbous
- [ ] `lib/features/celestial/application/celestial_services.dart:602` — Last quarter
- [ ] `lib/features/celestial/application/celestial_services.dart:603` — Waning crescent
- [ ] `lib/features/celestial/application/celestial_services.dart:604` — New moon
- [ ] `lib/features/celestial/presentation/celestial_explorer_page.dart:265` — Sky reflection saved.
- [ ] `lib/features/celestial/presentation/celestial_explorer_page.dart:270` — Save reflection
- [ ] `lib/features/celestial/presentation/celestial_explorer_page.dart:292` — What did the sky make you notice today?
- [ ] `lib/features/celestial/presentation/widgets/celestial_cycle_card.dart:199` — Moon phase
- [ ] `lib/features/celestial/presentation/widgets/celestial_cycle_card.dart:207` — Next event