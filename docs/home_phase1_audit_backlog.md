# Home Phase 1 Audit Backlog

Date: 2026-03-24

## Highest Priority

- Extract Home prayer schedule and logging lifecycle from [home_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/home/presentation/home_page.dart) into a dedicated view-model/coordinator so Home stops owning date navigation, log lookups, and action routing inline.
- Split [home_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/home/presentation/home_page.dart) into smaller feature widgets or files; the current file is too large and mixes composition, data orchestration, search, prayer logic, and experimental dead code.
- Localize or redesign Home search keywords so search discoverability is not English-biased on non-English locales.

## Data / Content

- Localize seeded celestial reflection copy in [celestial_verse_catalog.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/celestial/data/celestial_verse_catalog.dart).
- Plan localization support for historical seeded summaries in [historical_calendar_seed.json](/Users/shahabmansoor/Developer/path_of_nur/assets/data/historical_calendar_seed.json).
- Audit whether Home should keep surfacing fixed daily dhikr target assumptions from [app_summary_providers.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/shared/application/app_summary_providers.dart).

## UX / Product

- Revisit whether the prayer cluster should expose “current prayer” and “next prayer” more distinctly on smaller screens.
- Decide whether the Home learning section should stay as an expansion tile or become a calmer summary plus one clear CTA.
- Review whether the floating shortcut dock duplicates too much of the new major-page shortcut system.

## Cleanup

- Remove or revive dead Home widgets currently suppressed with `unused_element` ignores.
- Replace remaining one-off Home color constants with shared semantic tokens where practical without changing the global theme.
