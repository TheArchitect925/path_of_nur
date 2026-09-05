import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/garden/application/garden_scene_provider.dart';
import 'package:path_of_nur/features/garden/application/garden_service.dart';
import 'package:path_of_nur/features/garden/data/garden_stage_catalog.dart';
import 'package:path_of_nur/features/garden/domain/garden_models.dart';
import 'package:path_of_nur/features/garden/domain/garden_scene_models.dart';
import 'package:path_of_nur/features/journey/xp/domain/journey_xp_models.dart';
import 'package:path_of_nur/features/progression/domain/learner_progression_models.dart';
import 'package:path_of_nur/shared/persistence/structured_data_scope.dart';

import '../../test_helpers/garden_fixtures.dart' show makeGardenTestContainer;

final _stubGardenState = StateProvider.family<GardenState, String>((
  ref,
  learnerId,
) {
  return _state(learnerId: learnerId);
});

Future<ProviderContainer> _makeContainer() {
  return makeGardenTestContainer(
    overrides: [
      gardenStateProvider.overrideWith(
        (ref, String learnerId) => ref.watch(_stubGardenState(learnerId)),
      ),
    ],
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('spec recomputes when the garden state changes', () async {
    final container = await _makeContainer();
    addTearDown(container.dispose);

    final first = container.read(gardenSceneSpecProvider('learner_a'));
    expect(first.elementById(GardenSceneElementId.olive)!.variantLevel, 0);

    container.read(_stubGardenState('learner_a').notifier).state = _state(
      learnerId: 'learner_a',
      prayer: 0.3,
      drops: 120,
    );
    final second = container.read(gardenSceneSpecProvider('learner_a'));
    expect(second.elementById(GardenSceneElementId.olive)!.variantLevel, 1);
    expect(second.water.streamTier, 3);
  });

  test(
    'first visit is silent, growth after baseline celebrates, marking seen clears it',
    () async {
      final container = await _makeContainer();
      addTearDown(container.dispose);
      final controller = container.read(gardenSceneSeenControllerProvider);

      final first = container.read(gardenSceneSpecProvider('learner_a'));
      expect(first.hasNewGrowth, isFalse);
      await controller.ensureBaseline(first, now: DateTime(2026, 8, 29));

      container.read(_stubGardenState('learner_a').notifier).state = _state(
        learnerId: 'learner_a',
        prayer: 0.3,
        remembrance: 0.25,
      );
      final grown = container.read(gardenSceneSpecProvider('learner_a'));
      expect(
        grown.newlyAppeared,
        containsAll([GardenSceneElementId.olive, GardenSceneElementId.rayhan]),
      );
      expect(
        grown.elementById(GardenSceneElementId.olive)!.isNewSinceLastVisit,
        isTrue,
      );

      await controller.markSceneSeen(grown, now: DateTime(2026, 8, 29, 12));
      final acknowledged = container.read(gardenSceneSpecProvider('learner_a'));
      expect(acknowledged.hasNewGrowth, isFalse);
      expect(
        acknowledged
            .elementById(GardenSceneElementId.olive)!
            .isNewSinceLastVisit,
        isFalse,
      );
    },
  );

  test('ensureBaseline never overwrites an existing memento', () async {
    final container = await _makeContainer();
    addTearDown(container.dispose);
    final controller = container.read(gardenSceneSeenControllerProvider);
    final repository = container.read(gardenSceneMementoRepositoryProvider);

    final first = container.read(gardenSceneSpecProvider('learner_a'));
    await controller.ensureBaseline(first, now: DateTime(2026, 8, 29));
    final saved = repository.read('learner_a')!;

    container.read(_stubGardenState('learner_a').notifier).state = _state(
      learnerId: 'learner_a',
      prayer: 0.9,
    );
    final grown = container.read(gardenSceneSpecProvider('learner_a'));
    await controller.ensureBaseline(grown, now: DateTime(2026, 8, 30));

    final after = repository.read('learner_a')!;
    expect(
      after.savedAtIso,
      saved.savedAtIso,
      reason: 'baseline must not swallow pending celebrations',
    );
    expect(
      container.read(gardenSceneSpecProvider('learner_a')).hasNewGrowth,
      isTrue,
    );
  });

  test('mementos are isolated per learner', () async {
    final container = await _makeContainer();
    addTearDown(container.dispose);
    final controller = container.read(gardenSceneSeenControllerProvider);

    final specA = container.read(gardenSceneSpecProvider('learner_a'));
    await controller.ensureBaseline(specA, now: DateTime(2026, 8, 29));

    for (final learner in ['learner_a', 'learner_b']) {
      container.read(_stubGardenState(learner).notifier).state = _state(
        learnerId: learner,
        prayer: 0.4,
      );
    }
    expect(
      container.read(gardenSceneSpecProvider('learner_a')).newlyAppeared,
      contains(GardenSceneElementId.olive),
    );
    expect(
      container.read(gardenSceneSpecProvider('learner_b')).hasNewGrowth,
      isFalse,
      reason: 'learner_b has no baseline yet — first visit is silent',
    );
  });

  test(
    'memento keys are scoped so shared-device profiles never collide',
    () async {
      final container = await _makeContainer();
      addTearDown(container.dispose);
      final repository = container.read(gardenSceneMementoRepositoryProvider);
      final scopeId = container.read(structuredDataScopeProvider);
      expect(
        repository.keyForLearner('learner_a'),
        'garden.scene.lastSeen.v1.$scopeId.learner_a',
      );
    },
  );

  test('activeGardenSceneSpecProvider follows the active learner', () async {
    final container = await _makeContainer();
    addTearDown(container.dispose);
    final active = container.read(activeGardenSceneSpecProvider);
    expect(active.learnerId, isNotEmpty);
    expect(active.elements, isNotEmpty);
  });
}

GardenState _state({
  required String learnerId,
  double prayer = 0,
  double learning = 0,
  double remembrance = 0,
  double consistency = 0,
  double wisdom = 0,
  int drops = 0,
  int maturity = 0,
}) {
  final stage = gardenVisualStages.lastWhere(
    (item) => maturity >= item.minMaturityPercent,
    orElse: () => gardenVisualStages.first,
  );
  return GardenState(
    learnerId: learnerId,
    isFallbackLearner: true,
    currentGardenLevel: 1,
    currentVisualStage: stage,
    nextVisualStage: null,
    totalXp: 0,
    totalOceanDrops: drops,
    prayerFoundationScore: prayer,
    learningGrowthScore: learning,
    remembranceLightScore: remembrance,
    consistencyScore: consistency,
    wisdomFruitScore: wisdom,
    lastUpdatedIso: null,
    lastVisualRefreshAtIso: null,
    unlockedVisualIds: const [],
    ambientState: GardenAmbientState.quietDawn,
    progressToNextStage: 0,
    maturityPercent: maturity,
    xpSummary: XpSummary(
      totalXp: 0,
      todayXp: 0,
      currentLevel: 1,
      currentLevelTitle: 'Niyyah',
      currentLevelStartXp: 0,
      nextLevel: 2,
      nextLevelTitle: 'Next',
      nextLevelTotalXp: 100,
      xpIntoLevel: 0,
      xpRequiredInLevel: 100,
      xpRemainingToNextLevel: 100,
      progressPercent: 0,
      updatedAt: DateTime(2026, 8, 29),
    ),
    metrics: const LearnerProgressionMetrics(
      totalXp: 0,
      totalDrops: 0,
      kidsArabicLessonCompletions: 0,
      kidsArabicDailyMissionCompletions: 0,
      storyCompletions: 0,
      quizCompletions: 0,
      memoryCompletions: 0,
      duaLessonCompletions: 0,
      duaPracticeSessions: 0,
      duaMyDayCompletions: 0,
      bedtimeRoutineCompletions: 0,
      seerahNodeCompletions: 0,
      seerahStageCompletions: 0,
      seerahJourneyCompletions: 0,
      currentLearningStreakDays: 0,
      longestLearningStreakDays: 0,
      lastActivityAtIso: null,
      activeDayKeys: [],
    ),
    dimensions: const [],
    insights: const [],
    recentGrowth: const [],
    milestones: const [],
  );
}
