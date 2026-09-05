import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/guided_paths/data/guided_learning_paths_seed.dart';
import 'package:path_of_nur/features/learn/journey/application/learning_journey_progress_provider.dart';
import 'package:path_of_nur/features/learn/journey/application/learning_path_provider.dart';
import 'package:path_of_nur/features/learn/journey/data/learning_journey_registry.dart';
import 'package:path_of_nur/features/learn/journey/data/learning_path_registry.dart';
import 'package:path_of_nur/features/learn/journey/domain/learning_path_models.dart';
import 'package:path_of_nur/features/learn/trivia/data/trivia_knowledge_paths.dart';
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

  test('every phase mapping points at real guided and trivia paths', () {
    final guidedIds = kGuidedLearningPaths.map((path) => path.id).toSet();
    final triviaIds = triviaKnowledgePaths.map((path) => path.id).toSet();

    for (final path in LearningPathRegistry.paths) {
      for (final phase in path.phases) {
        for (final guidedId in phase.guidedPathIds) {
          expect(
            guidedIds,
            contains(guidedId),
            reason: '${phase.id} references unknown guided path $guidedId',
          );
          expect(
            guidedId,
            isNot('kids-starter'),
            reason: 'the adult spine must not pull in the kids starter path',
          );
        }
        final triviaId = phase.triviaPathId;
        if (triviaId != null) {
          expect(
            triviaIds,
            contains(triviaId),
            reason: '${phase.id} references unknown trivia path $triviaId',
          );
        }
        for (final journeyId in phase.journeyIds) {
          expect(
            LearningJourneyRegistry.journeyById(journeyId),
            isNotNull,
            reason: '${phase.id} references unknown journey $journeyId',
          );
        }
      }
    }
  });

  test('every adult guided path appears somewhere on the spine', () {
    final referenced = <String>{
      for (final path in LearningPathRegistry.paths)
        for (final phase in path.phases) ...phase.guidedPathIds,
    };
    final adultGuidedIds = kGuidedLearningPaths
        .where((path) => path.id != 'kids-starter')
        .map((path) => path.id);
    for (final id in adultGuidedIds) {
      expect(
        referenced,
        contains(id),
        reason: 'guided path $id is orphaned from every leveled path',
      );
    }
  });

  test('level switch round-trip preserves stage progress and completion', () {
    final container = createContainer();
    addTearDown(container.dispose);

    final progress = container.read(learningJourneyProgressProvider.notifier);
    final journey = LearningJourneyRegistry.journeyById('islam-foundations')!;
    for (final stageId in journey.stageIds) {
      progress.completeStage(journeyId: journey.id, stageId: stageId);
    }

    final selection = container.read(learningPathSelectionProvider.notifier);
    selection.setLevel(LearningPathLevel.beginner);
    final before = container.read(learningPathStateProvider)!;
    expect(before.completedJourneyIds, contains('islam-foundations'));
    final stagesBefore = Set<String>.from(
      container.read(learningJourneyProgressProvider).completedStageIds,
    );

    selection.setLevel(LearningPathLevel.practicing);
    selection.setLevel(LearningPathLevel.beginner);

    final after = container.read(learningPathStateProvider)!;
    expect(
      container.read(learningJourneyProgressProvider).completedStageIds,
      stagesBefore,
    );
    expect(after.completedJourneyIds, before.completedJourneyIds);
    expect(after.currentPhase.id, before.currentPhase.id);
    expect(after.completedPhaseIds, before.completedPhaseIds);
  });
}
