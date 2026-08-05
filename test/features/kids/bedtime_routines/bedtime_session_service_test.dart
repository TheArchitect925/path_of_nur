import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids/bedtime_routines/application/bedtime_session_service.dart';
import 'package:path_of_nur/features/kids/bedtime_routines/data/bedtime_routine_seed.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/application/bedtime_story_progress_service.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/bedtime_story_models.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('BedtimeCompanionSessionController', () {
    test('keeps companion session state isolated per learner', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      final controller = container.read(
        bedtimeCompanionSessionProvider.notifier,
      );
      final state = container.read(bedtimeCompanionSessionProvider);
      final duaStepId = kDefaultBedtimeRoutinePlan.steps
          .firstWhere((step) => step.stepId == 'step_bedtime_dua')
          .stepId;

      controller.updateActiveLearner('child_a');
      controller.completeStep(duaStepId);
      expect(
        container
            .read(bedtimeCompanionSessionProvider)
            .activeSession
            ?.stepProgressById[duaStepId]
            ?.state
            .name,
        'completed',
      );

      controller.updateActiveLearner('child_b');
      expect(
        container
            .read(bedtimeCompanionSessionProvider)
            .activeSession
            ?.stepProgressById[duaStepId]
            ?.state
            .name,
        'notStarted',
      );

      expect(
        prefs.getString(bedtimeCompanionStorageKeyForLearner('child_a')),
        isNotNull,
      );
      expect(
        prefs.getString(bedtimeCompanionStorageKeyForLearner('child_b')),
        isNotNull,
      );

      expect(state.activeSession, isNotNull);
    });

    test('marks the story step complete once story progress starts', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      final storyProgress = container.read(
        bedtimeStoryProgressProvider.notifier,
      );
      final controller = container.read(
        bedtimeCompanionSessionProvider.notifier,
      );
      final storyId = container
          .read(bedtimeCompanionSessionProvider)
          .activeSession
          ?.suggestedStoryId;

      expect(storyId, isNotNull);
      storyProgress.recordPlaybackSnapshot(
        storyId: storyId!,
        currentPosition: const Duration(seconds: 12),
        totalDuration: const Duration(seconds: 90),
        source: BedtimeStoryPlaybackSource.asset,
      );
      controller.syncExternalProgress();

      final session = container
          .read(bedtimeCompanionSessionProvider)
          .activeSession;
      expect(
        session?.stepProgressById['step_story_time']?.state.name,
        'completed',
      );
      expect(session?.suggestedStoryId, isNotEmpty);
    });
  });
}
