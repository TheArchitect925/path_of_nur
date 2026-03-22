import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_of_nur/features/progression/application/learner_progression_service.dart';
import 'package:path_of_nur/features/progression/domain/learner_progression_models.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Learner progression service', () {
    test('awards once per source and computes levels and badges', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      final controller = container.read(
        learnerProgressionControllerProvider('child_a').notifier,
      );

      final first = controller.award(
        sourceRef: 'story:adam:complete',
        activityType: LearnerProgressionActivityType.bedtimeStoryCompletion,
        sourceModule: 'kids_bedtime_story',
        xp: 5,
        drops: 1,
        occurredAt: DateTime(2026, 3, 20, 20),
      );
      final duplicate = controller.award(
        sourceRef: 'story:adam:complete',
        activityType: LearnerProgressionActivityType.bedtimeStoryCompletion,
        sourceModule: 'kids_bedtime_story',
        xp: 5,
        drops: 1,
        occurredAt: DateTime(2026, 3, 20, 20, 5),
      );
      final second = controller.award(
        sourceRef: 'quiz:adam:complete',
        activityType: LearnerProgressionActivityType.bedtimeQuizCompletion,
        sourceModule: 'kids_bedtime_story_learning',
        xp: 8,
        drops: 0,
        occurredAt: DateTime(2026, 3, 21, 20),
      );

      final summary = container.read(
        learnerProgressionSummaryProvider('child_a'),
      );

      expect(first.wasDuplicate, isFalse);
      expect(duplicate.wasDuplicate, isTrue);
      expect(second.awardedXp, 8);
      expect(summary.metrics.totalXp, 13);
      expect(summary.metrics.totalDrops, 1);
      expect(summary.metrics.storyCompletions, 1);
      expect(summary.metrics.quizCompletions, 1);
      expect(summary.unlockedBadges.map((item) => item.definition.badgeId), contains('badge_first_story'));
      expect(summary.unlockedBadges.map((item) => item.definition.badgeId), contains('badge_first_quiz'));
      expect(summary.metrics.currentLearningStreakDays, 2);
      expect(summary.xpSummary.currentLevel, greaterThanOrEqualTo(1));
    });

    test('unlocks milestones for cumulative progress', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      final controller = container.read(
        learnerProgressionControllerProvider('child_b').notifier,
      );

      for (var index = 0; index < 10; index += 1) {
        controller.award(
          sourceRef: 'story:$index',
          activityType: LearnerProgressionActivityType.bedtimeStoryCompletion,
          sourceModule: 'kids_bedtime_story',
          xp: 5,
          drops: 1,
          occurredAt: DateTime(2026, 3, 1 + index, 19),
        );
      }

      final summary = container.read(
        learnerProgressionSummaryProvider('child_b'),
      );
      expect(
        summary.unlockedMilestones.map((item) => item.definition.milestoneId),
        contains('milestone_stories_10'),
      );
      expect(
        summary.unlockedBadges.map((item) => item.definition.badgeId),
        contains('badge_stories_10'),
      );
    });
  });
}
