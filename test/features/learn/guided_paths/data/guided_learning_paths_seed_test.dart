import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/guided_paths/data/guided_learning_paths_seed.dart';

void main() {
  test('guided learning paths ship seven starter paths with seeded steps', () {
    expect(kGuidedLearningPaths, hasLength(7));
    expect(kGuidedLearningPaths.map((path) => path.id).toSet(), hasLength(7));
    for (final path in kGuidedLearningPaths) {
      expect(path.steps, isNotEmpty, reason: '${path.id} should have steps');
      for (final step in path.steps) {
        expect(step.pathId, path.id);
        expect(step.routeTarget.routeName, isNotEmpty);
      }
    }
  });

  test('quran beginner path points into canonical quran route owners', () {
    final quranPath = kGuidedLearningPaths.firstWhere(
      (path) => path.id == 'quran-beginner-starter',
    );

    expect(
      quranPath.steps.map((step) => step.routeTarget.routeName),
      orderedEquals(const <String>[
        'learnQuranBeginnerSoftBridge',
        'quranSummaryPage',
        'quranExplorer',
        'quranLearningPaths',
      ]),
    );
  });

  test('kids starter path remains on kids route family destinations', () {
    final kidsPath = kGuidedLearningPaths.firstWhere(
      (path) => path.id == 'kids-starter',
    );

    expect(
      kidsPath.steps.map((step) => step.routeTarget.routeName),
      orderedEquals(const <String>[
        'learnKidsStarterBridge',
        'kidsArabicLesson',
        'kidsStoryDetail',
        'learnKidsStarterNextSteps',
      ]),
    );

    expect(
      kidsPath.steps[1].routeTarget.pathParameters,
      containsPair('letterId', 'alif'),
    );
    expect(
      kidsPath.steps[2].routeTarget.pathParameters,
      containsPair('storyId', 'story_bismillah_before_eating_v1'),
    );
  });

  test(
    'stories starter path forms a narrative route through existing owners',
    () {
      final storiesPath = kGuidedLearningPaths.firstWhere(
        (path) => path.id == 'stories-starter',
      );

      expect(
        storiesPath.steps.map((step) => step.routeTarget.routeName),
        orderedEquals(const <String>[
          'learnStoriesPathBridge',
          'learnJourneyStage',
          'learnJourneyStage',
          'learnJourneyStage',
          'learnJourneyStage',
          'learnJourneyStage',
          'learnStoriesPathNextSteps',
        ]),
      );

      expect(
        storiesPath.steps[1].routeTarget.pathParameters,
        containsPair('journeyId', 'prophets-journey'),
      );
      expect(
        storiesPath.steps[1].routeTarget.pathParameters,
        containsPair('stageId', 'prophets-overview'),
      );
      expect(
        storiesPath.steps[4].routeTarget.pathParameters,
        containsPair('stageId', 'seerah-hijrah'),
      );
      expect(
        storiesPath.steps[5].routeTarget.pathParameters,
        containsPair('stageId', 'seerah-leadership-character'),
      );
    },
  );

  test('foundations path now routes through focused beginner-safe stages', () {
    final foundationsPath = kGuidedLearningPaths.firstWhere(
      (path) => path.id == 'foundations-starter',
    );

    expect(
      foundationsPath.steps.map((step) => step.id),
      orderedEquals(const <String>[
        'foundations-overview',
        'foundations-daily-duas',
        'foundations-salah-basics',
        'foundations-hadith-essentials',
      ]),
    );

    expect(
      foundationsPath.steps.map((step) => step.routeTarget.routeName),
      orderedEquals(const <String>[
        'learnJourneyStage',
        'learnJourneyStage',
        'learnJourneyStage',
        'learnFoundationsNextSteps',
      ]),
    );

    expect(
      foundationsPath.steps[0].routeTarget.pathParameters,
      containsPair('stageId', 'islam-what-is-islam'),
    );
    expect(
      foundationsPath.steps[1].routeTarget.pathParameters,
      containsPair('stageId', 'islam-who-is-allah'),
    );
    expect(
      foundationsPath.steps[2].routeTarget.pathParameters,
      containsPair('stageId', 'islam-five-pillars'),
    );
  });

  test('daily dhikr path now routes through lesson stages before the tool', () {
    final dhikrPath = kGuidedLearningPaths.firstWhere(
      (path) => path.id == 'daily-dhikr-starter',
    );

    expect(
      dhikrPath.steps.map((step) => step.id),
      orderedEquals(const <String>[
        'dhikr-intro-dua-hub',
        'dhikr-counter',
        'dhikr-after-salah',
        'dhikr-routine',
      ]),
    );

    expect(
      dhikrPath.steps.map((step) => step.routeTarget.routeName),
      orderedEquals(const <String>[
        'learnJourneyStage',
        'learnJourneyStage',
        'learnJourneyStage',
        'learnDailyDhikrNextSteps',
      ]),
    );

    expect(
      dhikrPath.steps[0].routeTarget.pathParameters,
      containsPair('stageId', 'dhikr-what-is'),
    );
    expect(
      dhikrPath.steps[1].routeTarget.pathParameters,
      containsPair('stageId', 'dhikr-morning-adhkar'),
    );
    expect(
      dhikrPath.steps[2].routeTarget.pathParameters,
      containsPair('stageId', 'dhikr-simple-routine'),
    );
  });

  test('salah path now opens with a calmer lesson-backed intro step', () {
    final salahPath = kGuidedLearningPaths.firstWhere(
      (path) => path.id == 'salah-starter',
    );

    expect(salahPath.steps.first.routeTarget.routeName, 'learnJourneyStage');
    expect(
      salahPath.steps.first.routeTarget.pathParameters,
      containsPair('journeyId', 'salah-foundations'),
    );
    expect(
      salahPath.steps.first.routeTarget.pathParameters,
      containsPair('stageId', 'salah-hub'),
    );
  });

  test('character path now moves through intro, practice, and reflection', () {
    final characterPath = kGuidedLearningPaths.firstWhere(
      (path) => path.id == 'character-starter',
    );

    expect(
      characterPath.steps.map((step) => step.id),
      orderedEquals(const <String>[
        'character-companion',
        'character-life-lessons',
        'character-quran-reflection',
        'character-guided-journey',
      ]),
    );

    expect(
      characterPath.steps.map((step) => step.routeTarget.routeName),
      orderedEquals(const <String>[
        'learnCharacterCompanion',
        'learnCharacterCompanion',
        'learnJourneyStage',
        'learnJourneyStage',
      ]),
    );

    expect(characterPath.steps[0].routeTarget.queryParameters, isEmpty);
    expect(
      characterPath.steps[1].routeTarget.queryParameters,
      containsPair('focus', 'sabr'),
    );
    expect(
      characterPath.steps[2].routeTarget.pathParameters,
      containsPair('stageId', 'character-kindness'),
    );
    expect(
      characterPath.steps[3].routeTarget.pathParameters,
      containsPair('stageId', 'character-completion'),
    );
  });
}
