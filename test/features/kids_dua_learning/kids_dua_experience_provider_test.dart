import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/journey/application/journey_progression_provider.dart';
import 'package:path_of_nur/features/kids_dua_learning/application/kids_dua_experience_provider.dart';
import 'package:path_of_nur/features/kids_dua_learning/application/kids_dua_progress_provider.dart';
import 'package:path_of_nur/features/kids_dua_learning/data/kids_dua_seed_data.dart';
import 'package:path_of_nur/features/kids_dua_learning/domain/kids_dua_models.dart';
import 'package:path_of_nur/features/worship/domain/fasting_status.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('featured lesson prefers an unlearned lesson for the day', () async {
    final container = await makeTestContainer(
      overrides: [
        kidsDuaNowProvider.overrideWithValue(() => DateTime(2026, 3, 18)),
        _journeySnapshotOverride(),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(kidsDuaLearningProvider.notifier);
    notifier.completeLesson(kidsDuaStarterLessons.first.id);

    final featured = container.read(kidsDuaFeaturedLessonProvider);

    expect(featured, isNotNull);
    expect(featured!.id, isNot(kidsDuaStarterLessons.first.id));
  });

  test('today focus prefers not-learned duas before learned review', () async {
    final container = await makeTestContainer(
      overrides: [
        kidsDuaNowProvider.overrideWithValue(() => DateTime(2026, 3, 18)),
        _journeySnapshotOverride(),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(kidsDuaLearningProvider.notifier);
    notifier.completeLesson(kidsDuaStarterLessons.first.id);

    final focus = container.read(kidsDuaTodayFocusProvider);

    expect(focus, isNotNull);
    expect(focus!.lesson.id, isNot(kidsDuaStarterLessons.first.id));
    expect(focus.state, isNot(KidsDuaDailyDuaState.learned));
  });

  test('continue lesson prefers recent in-progress lesson', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final notifier = container.read(kidsDuaLearningProvider.notifier);
    final first = kidsDuaStarterLessons.first;
    final second = kidsDuaStarterLessons[1];

    notifier.openLesson(first.id);
    notifier.openLesson(second.id);

    final continueLesson = container.read(kidsDuaContinueLessonItemProvider);

    expect(continueLesson, isNotNull);
    expect(continueLesson!.id, second.id);
  });

  test('practice questions use only unlocked lessons', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final notifier = container.read(kidsDuaLearningProvider.notifier);
    final first = kidsDuaStarterLessons.first;
    final second = kidsDuaStarterLessons[1];

    notifier.openLesson(first.id);
    notifier.openLesson(second.id);

    final questions = container.read(kidsDuaPracticeQuestionsProvider);

    expect(questions, isNotEmpty);
    for (final question in questions) {
      expect({first.id, second.id}, contains(question.relatedDuaId));
    }
  });

  test('light summary reflects streak state and reminder context', () async {
    final container = await makeTestContainer(
      overrides: [
        kidsDuaNowProvider.overrideWithValue(() => DateTime(2026, 3, 18, 21)),
      ],
    );
    addTearDown(container.dispose);

    container
        .read(kidsDuaLearningProvider.notifier)
        .registerMeaningfulActivity(KidsDuaDailyActivityType.lessonCompleted);

    final summary = container.read(kidsDuaLightSummaryProvider);

    expect(summary.currentStreakDays, 1);
    expect(summary.todayCompleted, isTrue);
    expect(summary.lightLevel, KidsDuaLightLevel.glow);
    expect(
      summary.reminderPrompt.contextType,
      KidsDuaReminderContextType.bedtime,
    );
  });
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
    );
  });
}
