# Growth Phase 2 Audit Backlog

Date: 2026-03-24

## Highest Priority

- Localize seeded Growth content in [growth_seed_data.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/journey/application/growth_seed_data.dart), [growth_seed_content.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/journey/application/growth_seed_content.dart), [growth_seasonal.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/journey/application/growth_seasonal.dart), [growth_garden.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/journey/application/growth_garden.dart), and reward/milestone definitions in [journey_progression_provider.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/journey/application/journey_progression_provider.dart).
- Localize hardcoded statistics sharing copy in [growth_statistics_share_service.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/journey/application/growth_statistics_share_service.dart).
- Decide which Growth extension points should become real production features instead of staying no-op:
  - reminders
  - cloud sync
  - reward packs
  - habit packs
  - family encouragement

## Product / UX

- Review duplication between the top “journey depth” card and the featured statistics/garden cards on [growth_home_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/journey/presentation/growth_home_page.dart).
- Consider whether Growth needs a first-class search or filter surface for habits, paths, reflections, and rewards instead of relying only on browse/navigation.
- Revisit whether `Today`, `Journey`, `Statistics`, and `Garden` are the clearest top-level cluster or if one should be demoted.

## Data / Completeness

- Audit whether reward titles, milestone labels, and seasonal packs should be treated as locale-backed data instead of embedded English seed metadata.
- Review whether growth widget sync is sufficient for continuity or if real cross-device persistence is required for launch confidence.
- Evaluate whether reminder scheduling should stay intentionally disabled or become a supported feature.

## Cleanup

- Replace one-off route pushes in [growth_home_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/journey/presentation/growth_home_page.dart) with a smaller shared destination model if the surface keeps growing.
- Review remaining English fallback values in non-English ARBs for `growthHome*`, `growthStatistics*`, and `spiritualGrowth*`.
