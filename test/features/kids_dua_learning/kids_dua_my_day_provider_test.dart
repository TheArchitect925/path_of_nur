import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/journey/application/journey_progression_provider.dart';
import 'package:path_of_nur/features/kids/activity/application/kids_activity_log_service.dart';
import 'package:path_of_nur/features/kids/activity/domain/kids_activity_models.dart';
import 'package:path_of_nur/features/kids_dua_learning/application/kids_dua_my_day_provider.dart';
import 'package:path_of_nur/features/kids_dua_learning/application/kids_dua_progress_provider.dart';
import 'package:path_of_nur/features/worship/domain/fasting_status.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('my day marks sections and day complete from tracked duas', () async {
    final container = await makeTestContainer(
      overrides: [
        kidsDuaNowProvider.overrideWithValue(() => DateTime(2026, 3, 18)),
        _journeySnapshotOverride(),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(kidsDuaMyDayProvider.notifier);

    notifier.completeDuaForToday('after-waking-up');
    notifier.completeDuaForToday('rabbi-zidnee-ilma');
    notifier.completeDuaForToday('before-eating');
    notifier.completeDuaForToday('after-eating');
    notifier.completeDuaForToday('leaving-home');
    notifier.completeDuaForToday('before-sleep');
    final result = notifier.completeDuaForToday('astaghfirullah');
    final state = container.read(kidsDuaMyDayProvider);

    expect(
      state.completedSectionIds,
      containsAll({'morning', 'meals', 'going-out', 'night'}),
    );
    expect(state.isDayComplete, isTrue);
    expect(result.dayCompletedNow, isTrue);
  });

  test(
    'my day resets when date changes but learned progress does not',
    () async {
      var now = DateTime(2026, 3, 18);
      final container = await makeTestContainer(
        overrides: [kidsDuaNowProvider.overrideWithValue(() => now)],
      );
      addTearDown(container.dispose);

      container
          .read(kidsDuaLearningProvider.notifier)
          .openLesson('before-eating');
      container
          .read(kidsDuaMyDayProvider.notifier)
          .completeDuaForToday('before-eating');

      now = DateTime(2026, 3, 19);
      container.read(kidsDuaMyDayProvider.notifier).resetIfNeeded();

      final myDayState = container.read(kidsDuaMyDayProvider);
      final progressState = container.read(kidsDuaLearningProvider);

      expect(myDayState.completedDuaIds, isEmpty);
      expect(
        progressState.progressByLessonId.containsKey('before-eating'),
        isTrue,
      );
    },
  );

  test('my day computes current and next suggested dua ids', () async {
    final container = await makeTestContainer(
      overrides: [
        kidsDuaNowProvider.overrideWithValue(() => DateTime(2026, 3, 18, 6)),
      ],
    );
    addTearDown(container.dispose);

    final state = container.read(kidsDuaMyDayProvider);

    expect(state.currentSuggestedDuaId, 'after-waking-up');
    expect(state.nextSuggestedDuaId, 'rabbi-zidnee-ilma');
  });

  test('my day completion logs canonical learner activity once', () async {
    final container = await makeTestContainer(
      overrides: [
        kidsDuaNowProvider.overrideWithValue(() => DateTime(2026, 3, 18, 21)),
        _journeySnapshotOverride(),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(kidsDuaMyDayProvider.notifier);
    notifier.completeDuaForToday('after-waking-up');
    notifier.completeDuaForToday('rabbi-zidnee-ilma');
    notifier.completeDuaForToday('before-eating');
    notifier.completeDuaForToday('after-eating');
    notifier.completeDuaForToday('leaving-home');
    notifier.completeDuaForToday('before-sleep');
    notifier.completeDuaForToday('astaghfirullah');
    notifier.completeDuaForToday('astaghfirullah');

    final activities = container
        .read(kidsActivityLogProvider.notifier)
        .recentActivities(types: const {KidsActivityType.duaMyDayCompleted});

    expect(activities, hasLength(1));
    expect(activities.first.contentId, 'astaghfirullah');
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
      streakExemptionActive: false,
    );
  });
}
