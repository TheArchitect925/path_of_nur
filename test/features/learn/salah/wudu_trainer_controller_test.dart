import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/journey/application/journey_progression_provider.dart';
import 'package:path_of_nur/features/learn/salah/application/wudu_trainer_controller.dart';
import 'package:path_of_nur/features/learn/salah/data/wudu_content.dart';
import 'package:path_of_nur/features/learn/salah/models/wudu_models.dart';
import 'package:path_of_nur/features/ocean/application/ocean_drops_provider.dart';
import 'package:path_of_nur/features/worship/domain/fasting_status.dart';
import 'package:path_of_nur/shared/persistence/app_database.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Override journeySnapshotOverride() {
    return journeyActivitySnapshotProvider.overrideWith(
      (ref) => JourneyActivitySnapshot(
        now: DateTime(2026, 4, 8, 12),
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
        learningStageCompletionsToday: 0,
      ),
    );
  }

  test('resume state persists across app reopen', () async {
    final first = await makeTestContainer(
      overrides: <Override>[journeySnapshotOverride()],
    );
    addTearDown(first.dispose);

    final firstController = first.read(wuduTrainerControllerProvider.notifier);
    firstController.completeCurrentStep();

    final firstState = first.read(wuduTrainerControllerProvider);
    expect(firstState.currentStepNumber, 2);
    expect(firstState.completedStepNumbers, contains(1));
    expect(firstState.shouldOfferResume, isTrue);

    final persisted = first
        .read(localStoreProvider)
        .dumpAll()
        .map((key, value) => MapEntry(key, value as Object));

    final reopened = await makeTestContainer(seed: persisted);
    addTearDown(reopened.dispose);

    final reopenedState = reopened.read(wuduTrainerControllerProvider);
    expect(reopenedState.currentStepNumber, 2);
    expect(reopenedState.completedStepNumbers, contains(1));
    expect(reopenedState.shouldOfferResume, isTrue);
  });

  test('invalid persisted state falls back to a safe resume step', () async {
    final container = await makeTestContainer(
      seed: <String, Object>{
        'learn.salah.wudu.trainer.v2': jsonEncode(<String, Object?>{
          'mode': 'guided',
          'currentStepIndex': 99,
          'completedStepNumbers': <int>[1, 2, 999],
          'skippedStepNumbers': <int>[2, 3, -1],
          'reviewModeEnabled': true,
          'guidedFinished': false,
          'completedOnce': false,
          'lastOutOfOrderStepNumber': 999,
        }),
      },
    );
    addTearDown(container.dispose);

    final state = container.read(wuduTrainerControllerProvider);
    expect(state.currentStepNumber, 3);
    expect(state.completedStepNumbers, {1, 2});
    expect(state.skippedStepNumbers, {3});
    expect(state.resumeStepIndex, 2);
    expect(state.resumeStepNumber, 3);
  });

  test(
    'completion, review re-entry, and restart do not duplicate rewards',
    () async {
      final database = AppDatabase.inMemory();
      addTearDown(database.close);

      final first = await makeTestContainer(
        database: database,
        overrides: <Override>[journeySnapshotOverride()],
      );
      addTearDown(first.dispose);

      final controller = first.read(wuduTrainerControllerProvider.notifier);
      for (var i = 0; i < wuduTrainerStepCount; i += 1) {
        controller.completeCurrentStep();
      }

      final completedState = first.read(wuduTrainerControllerProvider);
      final firstJourneyStats = first.read(journeyProgressProvider);
      final firstDrops = first.read(oceanDropsProvider).totalLocalDrops;

      expect(completedState.completedOnce, isTrue);
      expect(completedState.guidedFinished, isTrue);
      expect(completedState.rewardSummary, isNotNull);
      expect(firstJourneyStats.totalLearningStageCompletions, 1);
      expect(firstDrops, greaterThan(0));

      controller.openReviewAllSteps();
      final reviewState = first.read(wuduTrainerControllerProvider);
      expect(reviewState.mode, WuduTrainerMode.checklist);
      expect(reviewState.completedOnce, isTrue);

      final persisted = first
          .read(localStoreProvider)
          .dumpAll()
          .map((key, value) => MapEntry(key, value as Object));

      final reopened = await makeTestContainer(
        seed: persisted,
        database: database,
        overrides: <Override>[journeySnapshotOverride()],
      );
      addTearDown(reopened.dispose);
      final reopenedController = reopened.read(
        wuduTrainerControllerProvider.notifier,
      );
      final reopenedState = reopened.read(wuduTrainerControllerProvider);
      expect(reopenedState.mode, WuduTrainerMode.checklist);
      expect(reopenedState.completedOnce, isTrue);

      reopenedController.showCompletionSummary();
      expect(
        reopened.read(wuduTrainerControllerProvider).guidedFinished,
        isTrue,
      );

      reopenedController.restartGuided();
      final restartedState = reopened.read(wuduTrainerControllerProvider);
      expect(restartedState.currentStepNumber, 1);
      expect(restartedState.completedStepNumbers, isEmpty);
      expect(restartedState.completedOnce, isTrue);

      for (var i = 0; i < wuduTrainerStepCount; i += 1) {
        reopenedController.completeCurrentStep();
      }

      final secondJourneyStats = reopened.read(journeyProgressProvider);
      final secondDrops = reopened.read(oceanDropsProvider).totalLocalDrops;

      expect(secondJourneyStats.totalLearningStageCompletions, 1);
      expect(secondDrops, firstDrops);
    },
  );

  test('quiz blueprint generator stays aligned to the step sequence', () {
    final steps = const <WuduStep>[
      WuduStep(
        id: 'a',
        number: 1,
        title: 'A',
        subtitle: 'First',
        iconKey: 'one',
        imageAssetPath: 'a.png',
      ),
      WuduStep(
        id: 'b',
        number: 2,
        title: 'B',
        subtitle: 'Second',
        iconKey: 'two',
        imageAssetPath: 'b.png',
      ),
      WuduStep(
        id: 'c',
        number: 3,
        title: 'C',
        subtitle: 'Third',
        iconKey: 'three',
        imageAssetPath: 'c.png',
      ),
    ];

    final seeds = buildWuduQuizSeeds(steps);

    expect(seeds, isNotEmpty);
    expect(
      seeds.where((seed) => seed.type == WuduQuizPromptType.whatComesNext),
      hasLength(2),
    );
    expect(
      seeds.any(
        (seed) =>
            seed.type == WuduQuizPromptType.whatComesNext &&
            seed.targetStepId == 'b' &&
            seed.relatedStepIds.first == 'a',
      ),
      isTrue,
    );
    expect(
      seeds.any(
        (seed) =>
            seed.type == WuduQuizPromptType.orderStep &&
            seed.targetStepId == 'c',
      ),
      isTrue,
    );
  });
}
