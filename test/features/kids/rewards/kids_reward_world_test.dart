import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/application/bedtime_story_progress_service.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/data/kids_islamic_story_seed.dart';
import 'package:path_of_nur/features/kids/rewards/application/kids_reward_world_provider.dart';
import 'package:path_of_nur/features/kids/rewards/domain/kids_sticker_models.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';
import 'package:path_of_nur/features/kids_dua_learning/application/kids_dua_progress_provider.dart';
import 'package:path_of_nur/features/kids_dua_learning/application/kids_dua_repository.dart';

import '../../../test_helpers/app_test_harness.dart';

/// K4: one reward world over the stores that already exist. Finishing a
/// story, a letter and a duʿā through their own providers yields three
/// stickers of three kinds and one streak of one day.
void main() {
  final now = DateTime(2026, 9, 4, 15);

  test('the streak counts consecutive days ending today or yesterday', () {
    DateTime day(int d) => DateTime(2026, 9, d, 10);
    expect(kidsStreakDaysFrom(const [], now), 0);
    expect(kidsStreakDaysFrom([day(4)], now), 1);
    expect(kidsStreakDaysFrom([day(2), day(3), day(4)], now), 3);
    // Nothing yet today, but yesterday counts: the streak is alive.
    expect(kidsStreakDaysFrom([day(2), day(3)], now), 2);
    // A gap before yesterday breaks it.
    expect(kidsStreakDaysFrom([day(1), day(3)], now), 1);
    // Two days ago is too old.
    expect(kidsStreakDaysFrom([day(1), day(2)], now), 0);
  });

  test('an empty world has no stickers and no streak', () async {
    final container = await makeTestContainer(
      overrides: [kidsRewardNowProvider.overrideWithValue(() => now)],
    );
    addTearDown(container.dispose);
    final world = container.read(kidsRewardWorldProvider);
    expect(world.stickers, isEmpty);
    expect(world.streakDays, 0);
    expect(world.completedToday, isFalse);
  });

  test('a story, a letter and a duʿā each become a sticker', () async {
    final container = await makeTestContainer(
      overrides: [kidsRewardNowProvider.overrideWithValue(() => now)],
    );
    addTearDown(container.dispose);

    final story = kKidsIslamicStories.first;
    container
        .read(bedtimeStoryProgressProvider.notifier)
        .completeStory(story, completionSource: 'test', occurredAt: now);
    final alif = kidsArabicLetters.firstWhere((letter) => letter.id == 'alif');
    container
        .read(kidsArabicProgressProvider.notifier)
        .completeLesson(letter: alif, traceResult: KidsArabicTraceResult.good);
    final lesson = container.read(kidsDuaLessonsProvider).first;
    container.read(kidsDuaLearningProvider.notifier).completeLesson(lesson.id);

    final world = container.read(kidsRewardWorldProvider);
    expect(
      world.ofKind(KidsStickerKind.story).map((s) => s.id),
      contains('story:${story.id}'),
    );
    expect(
      world.ofKind(KidsStickerKind.letter).map((s) => s.title),
      contains(alif.nameEn),
    );
    expect(
      world.ofKind(KidsStickerKind.dua).map((s) => s.title),
      contains(lesson.title),
    );
    // The story sticker wears the cover; the letter sticker its glyph.
    expect(
      world.ofKind(KidsStickerKind.story).first.imageAsset,
      story.coverAssetPath,
    );
    expect(world.ofKind(KidsStickerKind.letter).first.glyph, alif.glyph);
    expect(world.completedToday, isTrue);
    expect(world.streakDays, greaterThanOrEqualTo(1));
  });
}
