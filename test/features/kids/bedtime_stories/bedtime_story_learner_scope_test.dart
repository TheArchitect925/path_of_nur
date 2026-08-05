import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/application/bedtime_active_learner_service.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/application/bedtime_story_learning_progress_service.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/application/bedtime_story_progress_service.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/bedtime_story_learning_models.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('Bedtime learner scoping', () {
    test('story progress stays isolated per learner', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      final controller = container.read(bedtimeStoryProgressProvider.notifier);

      controller.updateActiveLearner('child_a');
      controller.openStory('story_prophet_adam_bedtime_v1');
      expect(
        controller
            .progressFor('story_prophet_adam_bedtime_v1')
            .completionState
            .name,
        'inProgress',
      );

      controller.updateActiveLearner('child_b');
      expect(
        controller
            .progressFor('story_prophet_adam_bedtime_v1')
            .completionState
            .name,
        'notStarted',
      );

      controller.openStory('story_prophet_nuh_bedtime_v1');
      controller.updateActiveLearner('child_a');
      expect(
        controller
            .progressFor('story_prophet_adam_bedtime_v1')
            .completionState
            .name,
        'inProgress',
      );
      expect(
        controller
            .progressFor('story_prophet_nuh_bedtime_v1')
            .completionState
            .name,
        'notStarted',
      );
    });

    test('learning progress stays isolated per learner', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      final controller = container.read(
        bedtimeStoryLearningProgressProvider.notifier,
      );

      controller.updateActiveLearner('child_a');
      controller.openActivity(
        activityId: 'quiz_story_prophet_adam_bedtime_v1',
        storyId: 'story_prophet_adam_bedtime_v1',
        mode: BedtimeStoryLearningMode.quiz,
        totalSteps: 3,
      );

      controller.updateActiveLearner('child_b');
      expect(
        controller
            .progressFor('quiz_story_prophet_adam_bedtime_v1')
            .completionState
            .name,
        'notStarted',
      );
    });

    test(
      'legacy bedtime progress migrates once into active learner scope',
      () async {
        SharedPreferences.setMockInitialValues(<String, Object>{
          legacyBedtimeStoryProgressKey: jsonEncode(<String, Object?>{
            'storyProgressById': <String, Object?>{
              'story_prophet_adam_bedtime_v1': <String, Object?>{
                'currentPositionMs': 1000,
                'totalDurationMs': 2000,
                'totalListenedMs': 1000,
                'startedAtIso': DateTime.now().toIso8601String(),
              },
            },
          }),
        });
        final prefs = await SharedPreferences.getInstance();
        final container = ProviderContainer(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        );
        addTearDown(container.dispose);

        container.read(bedtimeStoryProgressProvider);

        expect(prefs.getString(legacyBedtimeStoryProgressKey), isNull);
        expect(
          prefs.getString(
            bedtimeStoryProgressStorageKeyForLearner(
              bedtimeFallbackLearnerIdForProfile('device_local'),
            ),
          ),
          isNotNull,
        );
      },
    );
  });
}
