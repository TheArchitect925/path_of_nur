import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/enrichment/application/learn_enrichment_provider.dart';
import 'package:path_of_nur/features/learn/guided_paths/data/guided_learning_paths_seed.dart';
import 'package:path_of_nur/features/learn/guided_paths/domain/guided_learning_path_models.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<ProviderContainer> makeContainer({
    Map<String, Object> seed = const <String, Object>{},
  }) async {
    SharedPreferences.setMockInitialValues(seed);
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);
    return container;
  }

  GuidedLearningPath pathById(String id) {
    return kGuidedLearningPaths.firstWhere((path) => path.id == id);
  }

  GuidedLearningPathProgress emptyProgress(String pathId) {
    return GuidedLearningPathProgress(
      pathId: pathId,
      startedAtIso: null,
      completedStepIds: const <String>{},
      lastActiveStepId: null,
      lastUpdatedAtIso: null,
    );
  }

  test('first path start unlocks only one milestone and one memory', () async {
    final container = await makeContainer();
    final controller = container.read(
      learnEnrichmentControllerProvider.notifier,
    );
    final path = pathById('foundations-starter');
    final now = DateTime.utc(2026, 3, 31, 12);

    controller.recordPathStarted(
      path: path,
      previousProgress: emptyProgress(path.id),
      occurredAt: now,
    );
    controller.recordPathStarted(
      path: path,
      previousProgress: GuidedLearningPathProgress(
        pathId: path.id,
        startedAtIso: now.toIso8601String(),
        completedStepIds: const <String>{},
        lastActiveStepId: path.steps.first.id,
        lastUpdatedAtIso: now.toIso8601String(),
      ),
      occurredAt: now.add(const Duration(minutes: 1)),
    );

    final state = container.read(learnEnrichmentControllerProvider);
    expect(
      state.unlockedAtByMilestoneId.containsKey(
        'learn_milestone_first_path_started',
      ),
      isTrue,
    );
    expect(
      state.memories
          .where(
            (item) => item.milestoneId == 'learn_milestone_first_path_started',
          )
          .length,
      1,
    );
  });

  test('quran step milestones and weekly rhythm unlock safely', () async {
    final container = await makeContainer();
    final controller = container.read(
      learnEnrichmentControllerProvider.notifier,
    );
    final path = pathById('quran-beginner-starter');

    controller.recordStepCompleted(
      path: path,
      previousProgress: emptyProgress(path.id),
      occurredAt: DateTime.utc(2026, 3, 25),
    );
    controller.recordStepCompleted(
      path: path,
      previousProgress: GuidedLearningPathProgress(
        pathId: path.id,
        startedAtIso: DateTime.utc(2026, 3, 25).toIso8601String(),
        completedStepIds: {path.steps.first.id},
        lastActiveStepId: path.steps.first.id,
        lastUpdatedAtIso: DateTime.utc(2026, 3, 25).toIso8601String(),
      ),
      occurredAt: DateTime.utc(2026, 3, 27),
    );
    controller.recordStepCompleted(
      path: path,
      previousProgress: GuidedLearningPathProgress(
        pathId: path.id,
        startedAtIso: DateTime.utc(2026, 3, 25).toIso8601String(),
        completedStepIds: {path.steps.first.id, path.steps[1].id},
        lastActiveStepId: path.steps[1].id,
        lastUpdatedAtIso: DateTime.utc(2026, 3, 27).toIso8601String(),
      ),
      occurredAt: DateTime.utc(2026, 3, 30),
    );

    final state = container.read(learnEnrichmentControllerProvider);
    expect(
      state.unlockedAtByMilestoneId.containsKey(
        'learn_milestone_first_step_completed',
      ),
      isTrue,
    );
    expect(
      state.unlockedAtByMilestoneId.containsKey(
        'learn_milestone_first_quran_step_completed',
      ),
      isTrue,
    );
    expect(
      state.unlockedAtByMilestoneId.containsKey(
        'learn_milestone_three_steps_week',
      ),
      isTrue,
    );
  });

  test(
    'completion milestones and encouragement remain calm and deduped',
    () async {
      final container = await makeContainer(
        seed: const <String, Object>{
          'learn.enrichment.state.v1':
              '{"unlockedAtByMilestoneId":{"learn_milestone_return_after_break":"2026-03-31T12:00:00.000Z"},"acknowledgedAtByMilestoneId":{},"memories":[{"id":"memory:learn_milestone_return_after_break","milestoneId":"learn_milestone_return_after_break","occurredAtIso":"2026-03-31T12:00:00.000Z","pathId":"foundations-starter"}],"recentStepCompletedAtIsos":[]}',
        },
      );
      final controller = container.read(
        learnEnrichmentControllerProvider.notifier,
      );
      final kidsPath = pathById('kids-starter');

      controller.recordPathCompleted(
        path: kidsPath,
        occurredAt: DateTime.utc(2026, 3, 31, 13),
      );
      controller.recordPathCompleted(
        path: kidsPath,
        occurredAt: DateTime.utc(2026, 3, 31, 14),
      );

      final state = container.read(learnEnrichmentControllerProvider);
      expect(
        state.memories
            .where(
              (item) =>
                  item.milestoneId ==
                  'learn_milestone_first_kids_path_completed',
            )
            .length,
        1,
      );
      expect(container.read(localizedLearningEncouragementProvider), isNotNull);
    },
  );
}
