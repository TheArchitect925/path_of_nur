# Do Not Rebuild

Last updated: 2026-03-17

## Intentionally removed files / pages

- `lib/features/journey/presentation/journey_legacy_page.dart`
- `lib/features/journey/presentation/widgets/journey_widgets.dart`
- `lib/features/learn/presentation/pages/learn_section_placeholder_page.dart`
- `lib/features/profile/presentation/profile_page.dart`
- `lib/features/shared/section_detail_page.dart`
- `lib/features/worship/presentation/worship_page_legacy.dart`

## Retired ownership patterns

- do not recreate a separate top-level Profile tab/page as the primary settings owner
- do not add new `/profile/*` route families for new work
  - existing `/profile/*` routes are compatibility aliases only
- do not restore `/learn` as a generic legacy hub by default
  - current source of truth is journey-first `/learn`
- do not create new generic learn section placeholder pages
- do not reintroduce broad “legacy journey” pages

## Removed or retiring concepts that should not come back casually

- `journey-rings` placeholder concept
- `journey-streak` placeholder concept
- `journey-milestones` placeholder concept
- `journey-unlocks` placeholder concept
- dead-end placeholder category taps in Learn

## Product assumptions future work must not override

- do not assume production Path of Nūr Cloud Sync exists in this repo
- do not assume watch or tvOS folders mean those surfaces are release-ready
- do not create parallel Qur'an entry systems when equivalent Qur'an routes already exist
- do not rebuild large learn hubs from scratch when active domain routes or journey wrappers already exist

## Safe replacement rule

When a removed or legacy pattern looks tempting, first extend one of these instead:

- `SettingsPage`
- `LearningJourneyHomePage`
- `QuranAppHubPage`
- existing `/accounts-sync*` flows
- existing growth/journey pages
