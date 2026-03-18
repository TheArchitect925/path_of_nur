import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids_dua_learning/data/kids_dua_story_seed_data.dart';

void main() {
  test('v1 story seed contains all 23 prepared stories', () {
    expect(kidsDuaStories.length, 23);
  });

  test('each story has ordered scenes and a linked dua id', () {
    for (final story in kidsDuaStories) {
      expect(story.duaId, isNotEmpty);
      expect(story.slug, isNotEmpty);
      expect(story.scenes, isNotEmpty);
      final orders =
          story.scenes.map((scene) => scene.order).toList(growable: false)
            ..sort();
      expect(orders.first, 1);
    }
  });

  test('story categories include the canonical V1 groups in the seed set', () {
    final categories = kidsDuaStories.map((item) => item.category).toSet();
    expect(
      categories,
      containsAll(<String>{
        'bedtime',
        'daily_life',
        'family',
        'feelings',
        'food',
        'forgiveness',
        'gratitude',
        'learning',
        'manners',
        'morning',
        'nature',
        'travel',
        'wonder',
      }),
    );
  });
}
