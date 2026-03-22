import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/journey/application/journey_progression_provider.dart';
import 'package:path_of_nur/features/learn/journey/application/learning_journey_progress_provider.dart';
import 'package:path_of_nur/features/learn/journey/data/learning_journey_registry.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'settings.prayer': jsonEncode(<String, Object?>{
        'location': 'toronto',
        'useDeviceLocation': false,
        'manualLatitude': 43.6532,
        'manualLongitude': -79.3832,
      }),
    });
    prefs = await SharedPreferences.getInstance();
  });

  test('unlock logic is sequential', () {
    final journey = LearningJourneyRegistry.journeyById('islam-foundations')!;
    final firstStageId = journey.stageIds.first;
    final secondStageId = journey.stageIds[1];

    expect(
      isLearningJourneyStageUnlocked(
        journey: journey,
        stageId: firstStageId,
        completedStageIds: const <String>{},
      ),
      isTrue,
    );
    expect(
      isLearningJourneyStageUnlocked(
        journey: journey,
        stageId: secondStageId,
        completedStageIds: const <String>{},
      ),
      isFalse,
    );
    expect(
      isLearningJourneyStageUnlocked(
        journey: journey,
        stageId: secondStageId,
        completedStageIds: {firstStageId},
      ),
      isTrue,
    );
  });

  test('recordStageOpened stores journey start and last accessed data', () {
    final container = createContainer();
    addTearDown(container.dispose);
    final notifier = container.read(learningJourneyProgressProvider.notifier);

    notifier.recordStageOpened(
      journeyId: 'islam-foundations',
      stageId: 'islam-what-is-islam',
    );

    final state = container.read(learningJourneyProgressProvider);
    expect(state.startedJourneyIds, contains('islam-foundations'));
    expect(
      state.startedAtIsoByJourney['islam-foundations'],
      isNotNull,
    );
    expect(
      state.lastAccessedAtIsoByJourney['islam-foundations'],
      isNotNull,
    );
    expect(state.lastOpenedJourneyId, 'islam-foundations');
    expect(state.lastOpenedStageId, 'islam-what-is-islam');
  });

  test('completeStage tracks last completed lesson and XP reward once', () {
    final container = createContainer();
    addTearDown(container.dispose);
    final notifier = container.read(learningJourneyProgressProvider.notifier);

    final result = notifier.completeStage(
      journeyId: 'islam-foundations',
      stageId: 'islam-what-is-islam',
    );
    final duplicate = notifier.completeStage(
      journeyId: 'islam-foundations',
      stageId: 'islam-what-is-islam',
    );

    final state = container.read(learningJourneyProgressProvider);
    expect(result.stageCompleted, isTrue);
    expect(result.xpAwarded, JourneyXpRules.xpPerLearningStageCompletion);
    expect(state.completedStageIds, contains('islam-what-is-islam'));
    expect(
      state.lastCompletedStageIdByJourney['islam-foundations'],
      'islam-what-is-islam',
    );
    expect(duplicate.stageCompleted, isFalse);
    expect(duplicate.xpAwarded, 0);
  });

  test('completing all lessons marks journey as completed', () {
    final container = createContainer();
    addTearDown(container.dispose);
    final notifier = container.read(learningJourneyProgressProvider.notifier);
    final journey = LearningJourneyRegistry.journeyById('islam-foundations')!;

    for (final stageId in journey.stageIds) {
      notifier.completeStage(journeyId: journey.id, stageId: stageId);
    }

    final state = container.read(learningJourneyProgressProvider);
    expect(state.completedAtIsoByJourney[journey.id], isNotNull);
    expect(
      state.lastCompletedStageIdByJourney[journey.id],
      journey.stageIds.last,
    );
    expect(
      firstUnlockedIncompleteLearningJourneyStageId(
        journey,
        state.completedStageIds,
      ),
      isNull,
    );
  });
}
