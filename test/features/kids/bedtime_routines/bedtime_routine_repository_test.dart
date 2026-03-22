import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids/bedtime_routines/application/bedtime_routine_repository.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/application/bedtime_active_learner_service.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/bedtime_family_models.dart';
import 'package:path_of_nur/features/learn/journey/domain/learning_path_models.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('BedtimeRoutineRepository', () {
    test('puts the bedtime dua before the story by default', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      final plan = container.read(bedtimeRoutinePlanProvider);
      expect(plan.steps[0].stepType.name, 'getReadyForBed');
      expect(plan.steps[1].stepType.name, 'bedtimeDua');
      expect(plan.steps[2].stepType.name, 'storyTime');

      final primaryDua = container.read(bedtimePrimaryDuaProvider);
      expect(primaryDua?.duaId, 'before-sleep');
    });

    test('supports story-first order and simplified mode from learner preferences', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          bedtimeActiveLearnerProvider.overrideWithValue(
            BedtimeLearnerIdentity(
              learnerId: 'child_story_first',
              displayName: 'Amina',
              avatarReference: 'moon',
              ageGroup: LearningAgeGroup.kids,
              guardianProfileId: 'parent_1',
              isFallbackLearner: false,
              preferences: const BedtimeLearnerPreferences(
                prefersBedtimeDuaFirst: false,
                simplifiedBedtimeRoutine: true,
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final plan = container.read(bedtimeRoutinePlanProvider);
      expect(plan.steps[1].stepType.name, 'storyTime');
      expect(plan.steps[2].stepType.name, 'bedtimeDua');
      expect(
        plan.steps.any((item) => item.stepType.name == 'gratitudeReflection'),
        isFalse,
      );
    });
  });
}
