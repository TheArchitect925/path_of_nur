import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/data/bedtime_story_seed.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/data/kids_islamic_story_seed.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/data/kids_story_scene_plans.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/bedtime_story_models.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/kids_story_pages.dart';

/// K3: every story a child can open shows a real picture on every page, and
/// the pictures change as the story moves. The picture books carry their
/// own; the older stories get theirs from the scene plans.
void main() {
  final stories = <BedtimeStorySeed>[
    ...kBedtimeProphetStories,
    ...kKidsIslamicStories,
  ];

  test('every story has at least two scenes, on disk, in order', () {
    for (final story in stories) {
      final scenes = story.sceneIllustrations;
      expect(
        scenes.length,
        greaterThanOrEqualTo(2),
        reason: '${story.id} has ${scenes.length} scene(s)',
      );
      for (var i = 0; i < scenes.length; i++) {
        // Picture books number scenes by spread, plans by position; both
        // must only ever climb.
        if (i > 0) {
          expect(
            scenes[i].sortOrder,
            greaterThan(scenes[i - 1].sortOrder),
            reason: '${story.id} scene order',
          );
        }
        expect(scenes[i].storyId, story.id);
        expect(
          File(scenes[i].imageAssetPath).existsSync(),
          isTrue,
          reason:
              '${story.id} points at a missing file: '
              '${scenes[i].imageAssetPath}',
        );
      }
    }
  });

  test('scene ids stay unique across every story', () {
    final ids = stories.expand((s) => s.sceneIllustrations.map((i) => i.id));
    expect(ids.toSet().length, ids.length);
  });

  test('a plan only ever names a real story', () {
    final known = stories.map((s) => s.id).toSet();
    for (final id in kidsStoryScenePlanIds) {
      expect(known, contains(id), reason: '$id has a plan but no seed');
    }
  });

  test('the reader shows a picture on every page and turns it over', () {
    for (final story in stories) {
      final pages = kidsStoryPagesFor(story);
      final assets = pages.map((p) => p.illustrationAsset).toList();
      expect(assets, everyElement(isNotNull), reason: story.id);
      expect(
        assets.toSet().length,
        greaterThanOrEqualTo(2),
        reason: '${story.id} shows the same picture on every page',
      );
    }
  });
}
