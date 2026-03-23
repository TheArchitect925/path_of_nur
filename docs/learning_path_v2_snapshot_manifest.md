# Learning Path V2 Snapshot Manifest

Date: 2026-03-23

## Snapshot name

`learning-path-v2`

## Snapshot location

`/Users/shahabmansoor/Developer/Path of Nur Deleted and Cleaned Items/2026-03-23/learning-path-v2`

## Snapshot intent

This snapshot captures the current Learn `Learning Journey` / `Learning Path` feature state after the recent Learn, Kids, and Games routing passes, so the feature can be restored later if a future change needs rollback.

## Included feature files

### Core Learning Journey feature

- `lib/features/learn/journey/application/family_learning_provider.dart`
- `lib/features/learn/journey/application/learn_together_provider.dart`
- `lib/features/learn/journey/application/learning_journey_progress_provider.dart`
- `lib/features/learn/journey/application/learning_path_provider.dart`
- `lib/features/learn/journey/data/learning_journey_lesson_content.dart`
- `lib/features/learn/journey/data/learning_journey_localized_lesson_content.dart`
- `lib/features/learn/journey/data/learning_journey_localized_metadata.dart`
- `lib/features/learn/journey/data/learning_journey_registry.dart`
- `lib/features/learn/journey/data/learning_journey_runtime_localizations.dart`
- `lib/features/learn/journey/data/learning_path_registry.dart`
- `lib/features/learn/journey/domain/family_learning_models.dart`
- `lib/features/learn/journey/domain/learn_together_models.dart`
- `lib/features/learn/journey/domain/learning_journey_lesson_models.dart`
- `lib/features/learn/journey/domain/learning_journey_models.dart`
- `lib/features/learn/journey/domain/learning_path_models.dart`
- `lib/features/learn/journey/presentation/family_learning_management_page.dart`
- `lib/features/learn/journey/presentation/learn_browse_all_page.dart`
- `lib/features/learn/journey/presentation/learning_journey_detail_page.dart`
- `lib/features/learn/journey/presentation/learning_journey_home_page.dart`
- `lib/features/learn/journey/presentation/learning_journey_island_page.dart`
- `lib/features/learn/journey/presentation/learning_journey_lesson_page.dart`
- `lib/features/learn/journey/presentation/learning_journey_placeholder_lesson_page.dart`
- `lib/features/learn/journey/presentation/learning_journey_stage_page.dart`
- `lib/features/learn/journey/presentation/widgets/learning_journey_widgets.dart`

### Route and entry-link files captured with the feature

- `lib/app/routes/learn_routes.dart`
- `lib/features/learn/presentation/application/learn_hub_providers.dart`
- `lib/features/learn/presentation/data/learn_hub_taxonomy.dart`
- `lib/features/learn/presentation/pages/learning_journey_island_hub_page.dart`
- `lib/features/learn/presentation/pages/learning_section_landing_page.dart`

## Canonical routes represented in the snapshot

- `/learn/journey-home`
- `/learn/learning-journey`
- `/learn/island/:islandId`
- `/learn/journey/:journeyId`
- `/learn/journey/:journeyId/stage/:stageId`

## Restore note

If you want to roll back this feature later, restore the captured files from the snapshot directory back into the repo with their same relative paths, then run `flutter analyze` and the Learning Journey / Learn routing tests before keeping the rollback.
