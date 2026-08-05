import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/journey/application/journey_progression_provider.dart';
import 'package:path_of_nur/features/kids_dua_learning/application/kids_dua_progress_provider.dart';
import 'package:path_of_nur/features/kids_dua_learning/data/kids_dua_seed_data.dart';
import 'package:path_of_nur/features/worship/domain/fasting_status.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'completing a kids dua lesson persists progress and unlocks first reward',
    () async {
      final container = await makeTestContainer(
        overrides: [_journeySnapshotOverride()],
      );
      addTearDown(container.dispose);

      final lesson = kidsDuaStarterLessons.first;
      final result = container
          .read(kidsDuaLearningProvider.notifier)
          .completeLesson(lesson.id);
      final state = container.read(kidsDuaLearningProvider);

      expect(result.firstCompletion, isTrue);
      expect(result.xpAwarded, kidsDuaLessonXp);
      expect(state.learnedLessonIds, contains(lesson.id));
      expect(state.unlockedRewardIds, contains('first-dua'));
    },
  );

  test(
    'practice sessions accumulate and unlock practice reward once',
    () async {
      final container = await makeTestContainer(
        overrides: [_journeySnapshotOverride()],
      );
      addTearDown(container.dispose);

      final notifier = container.read(kidsDuaLearningProvider.notifier);
      final ids = kidsDuaStarterLessons
          .take(3)
          .map((item) => item.id)
          .toList(growable: false);
      notifier.recordPracticeSession(
        practicedLessonIds: ids,
        correctAnswers: 2,
        totalQuestions: 3,
      );
      notifier.recordPracticeSession(
        practicedLessonIds: ids,
        correctAnswers: 2,
        totalQuestions: 3,
      );
      final third = notifier.recordPracticeSession(
        practicedLessonIds: ids,
        correctAnswers: 3,
        totalQuestions: 3,
      );
      final state = container.read(kidsDuaLearningProvider);

      expect(state.totalPracticeSessions, 3);
      expect(state.unlockedRewardIds, contains('practice-bloom'));
      expect(
        third.newRewardIds.where((id) => id == 'practice-bloom').length,
        1,
      );
    },
  );

  test(
    'completing every dua in a category unlocks that category sticker once',
    () async {
      final container = await makeTestContainer(
        overrides: [_journeySnapshotOverride()],
      );
      addTearDown(container.dispose);

      final notifier = container.read(kidsDuaLearningProvider.notifier);
      final dailyBasics = kidsDuaStarterLessons
          .where((item) => item.categoryId == 'daily_basics')
          .toList(growable: false);

      dynamic lastResult;
      for (final lesson in dailyBasics) {
        lastResult = notifier.completeLesson(lesson.id);
      }

      final state = container.read(kidsDuaLearningProvider);

      expect(
        state.stickerUnlockedAtById.containsKey('daily_basics_sticker'),
        isTrue,
      );
      expect(lastResult, isNotNull);
      expect(lastResult!.newStickerIds, contains('daily_basics_sticker'));
    },
  );
}

Override _journeySnapshotOverride() {
  final now = DateTime(2026, 3, 18);
  return journeyActivitySnapshotProvider.overrideWith((ref) {
    final journey = ref.watch(journeyProgressProvider);
    final todayKey = LocalStore.todayKey(now);
    final metrics =
        journey.dayMetricsByKey[todayKey] ?? const JourneyDayMetrics();
    return JourneyActivitySnapshot(
      now: now,
      prayerCompletedToday: 0,
      prayerMissedToday: 0,
      fajrCompletedToday: false,
      prayerProgress: 0,
      dhikrSessionsToday: 0,
      dhikrCountToday: 0,
      dhikrProgress: 0,
      fastingStatus: FastingStatus.notFasting,
      quranEngagementsToday: 0,
      quranProgress: 0,
      reflectionEntriesToday: 0,
      reflectionProgress: 0,
      learningStageCompletionsToday: metrics.learningStageCompletions,
      streakExemptionActive: false,
    );
  });
}
