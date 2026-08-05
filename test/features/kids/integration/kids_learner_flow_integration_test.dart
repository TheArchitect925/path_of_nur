import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/kids/activity/application/kids_activity_log_service.dart';
import 'package:path_of_nur/features/kids/activity/domain/kids_activity_models.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/application/bedtime_active_learner_service.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/application/bedtime_story_parent_dashboard_service.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/bedtime_family_models.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/bedtime_story_parent_dashboard_models.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/presentation/bedtime_story_parent_dashboard_page.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';
import 'package:path_of_nur/features/learn/journey/domain/learning_path_models.dart';
import 'package:path_of_nur/features/progression/application/learner_progression_service.dart';
import 'package:path_of_nur/features/progression/presentation/learner_progression_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const learnerA = BedtimeLearnerIdentity(
    learnerId: 'child_a',
    linkedChildProfileId: 'child_a',
    displayName: 'Maryam',
    avatarReference: '🌙',
    ageGroup: LearningAgeGroup.kids,
    guardianProfileId: 'guardian_1',
    isFallbackLearner: false,
    preferences: BedtimeLearnerPreferences(),
  );
  const learnerB = BedtimeLearnerIdentity(
    learnerId: 'child_b',
    linkedChildProfileId: 'child_b',
    displayName: 'Yusuf',
    avatarReference: '⭐',
    ageGroup: LearningAgeGroup.kids,
    guardianProfileId: 'guardian_1',
    isFallbackLearner: false,
    preferences: BedtimeLearnerPreferences(),
  );

  List<Override> learnerOverrides(BedtimeLearnerIdentity activeLearner) {
    return <Override>[
      bedtimeAvailableLearnersProvider.overrideWith(
        (ref) => const <BedtimeLearnerIdentity>[learnerA, learnerB],
      ),
      bedtimeActiveLearnerProvider.overrideWith((ref) => activeLearner),
    ];
  }

  test(
    'kids arabic completion flows through learner scope, progression, activity, and parent summary',
    () async {
      final container = await makeTestContainer(
        overrides: <Override>[
          ...learnerOverrides(learnerA),
          kidsArabicNowProvider.overrideWithValue(
            () => DateTime(2026, 3, 22, 9),
          ),
        ],
      );

      final letter = kidsArabicLetters.firstWhere((item) => item.id == 'alif');
      final learnerANotifier = container.read(
        kidsArabicProgressProvider.notifier,
      );
      final result = learnerANotifier.completeLesson(
        letter: letter,
        traceResult: KidsArabicTraceResult.completed,
      );

      final learnerAArabic = container.read(kidsArabicProgressProvider);
      final learnerAProgression = container.read(
        learnerProgressionSummaryProvider(learnerA.learnerId),
      );
      final learnerAActivities = container
          .read(kidsActivityLogProvider.notifier)
          .recentActivities(limit: 10);
      final learnerAParent = container.read(
        bedtimeStoryParentDashboardProvider,
      );

      expect(result.firstMeaningfulCompletion, isTrue);
      expect(learnerAArabic.completedLetterIds, contains('alif'));
      expect(learnerAProgression.metrics.kidsArabicLessonCompletions, 1);
      expect(learnerAProgression.metrics.totalXp, greaterThan(0));
      expect(learnerAProgression.metrics.totalDrops, greaterThan(0));
      expect(
        learnerAActivities.any(
          (entry) => entry.type == KidsActivityType.arabicLetterCompleted,
        ),
        isTrue,
      );
      expect(
        learnerAParent.learningRecentActivity.any(
          (item) =>
              item.type == KidsParentRecentActivityType.arabicLesson ||
              item.type == KidsParentRecentActivityType.arabicDailyMission,
        ),
        isTrue,
      );
      expect(
        learnerAParent.overview.totalXpEarnedAcrossKidsLearning,
        greaterThan(0),
      );
      expect(
        learnerAParent.overview.totalArabicLettersCompleted,
        greaterThanOrEqualTo(1),
      );

      final persisted = container
          .read(localStoreProvider)
          .dumpAll()
          .map((key, value) => MapEntry(key, value as Object));
      container.dispose();

      final learnerBContainer = await makeTestContainer(
        seed: persisted,
        overrides: <Override>[
          ...learnerOverrides(learnerB),
          kidsArabicNowProvider.overrideWithValue(
            () => DateTime(2026, 3, 22, 9),
          ),
        ],
      );
      addTearDown(learnerBContainer.dispose);

      final learnerBArabicBefore = learnerBContainer.read(
        kidsArabicProgressProvider,
      );
      final learnerBActivitiesBefore = learnerBContainer
          .read(kidsActivityLogProvider.notifier)
          .recentActivities(limit: 10);
      final learnerBParentBefore = learnerBContainer.read(
        bedtimeStoryParentDashboardProvider,
      );

      expect(learnerBArabicBefore.completedLetterIds, isEmpty);
      expect(learnerBActivitiesBefore, isEmpty);
      expect(learnerBParentBefore.overview.totalArabicLettersCompleted, 0);

      final learnerBNotifier = learnerBContainer.read(
        kidsArabicProgressProvider.notifier,
      );
      learnerBNotifier.completeLesson(
        letter: kidsArabicLetters.firstWhere((item) => item.id == 'ba'),
        traceResult: KidsArabicTraceResult.good,
      );

      final learnerBArabicAfter = learnerBContainer.read(
        kidsArabicProgressProvider,
      );
      final learnerBProgression = learnerBContainer.read(
        learnerProgressionSummaryProvider(learnerB.learnerId),
      );
      expect(learnerBArabicAfter.completedLetterIds, contains('ba'));
      expect(learnerBProgression.metrics.kidsArabicLessonCompletions, 1);

      final persistedAgain = learnerBContainer
          .read(localStoreProvider)
          .dumpAll()
          .map((key, value) => MapEntry(key, value as Object));

      final learnerAReopened = await makeTestContainer(
        seed: persistedAgain,
        overrides: <Override>[
          ...learnerOverrides(learnerA),
          kidsArabicNowProvider.overrideWithValue(
            () => DateTime(2026, 3, 22, 9),
          ),
        ],
      );
      addTearDown(learnerAReopened.dispose);

      final learnerAArabicAgain = learnerAReopened.read(
        kidsArabicProgressProvider,
      );
      final learnerAProgressionAgain = learnerAReopened.read(
        learnerProgressionSummaryProvider(learnerA.learnerId),
      );
      expect(learnerAArabicAgain.completedLetterIds, contains('alif'));
      expect(learnerAArabicAgain.completedLetterIds, isNot(contains('ba')));
      expect(learnerAProgressionAgain.metrics.kidsArabicLessonCompletions, 1);
    },
  );

  testWidgets(
    'canonical kids routes render the active learner state after a real arabic completion and learner switch',
    (tester) async {
      final container = await makeTestContainer(
        overrides: <Override>[
          ...learnerOverrides(learnerA),
          kidsArabicNowProvider.overrideWithValue(
            () => DateTime(2026, 3, 22, 9),
          ),
          dailyNowProvider.overrideWith(
            (ref) =>
                Stream<DateTime>.value(DateTime.parse('2026-03-22T09:00:00')),
          ),
        ],
      );

      final letter = kidsArabicLetters.firstWhere((item) => item.id == 'alif');
      container
          .read(kidsArabicProgressProvider.notifier)
          .completeLesson(
            letter: letter,
            traceResult: KidsArabicTraceResult.completed,
          );

      final router = container.read(appRouterProvider);
      router.go('/learn/kids/progression');
      await tester.pumpWidget(buildRouterTestApp(container));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(LearnerProgressionPage), findsOneWidget);
      var l10n = AppLocalizations.of(
        tester.element(find.byType(LearnerProgressionPage)),
      );
      expect(
        find.text(l10n.progressionPageHeroTitle('Maryam')),
        findsOneWidget,
      );

      router.go('/learn/kids/bedtime-stories/parents');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.byType(BedtimeStoryParentDashboardPage), findsOneWidget);
      l10n = AppLocalizations.of(
        tester.element(find.byType(BedtimeStoryParentDashboardPage)),
      );
      expect(
        find.text(l10n.bedtimeParentWelcomeSubtitleWithName('Maryam')),
        findsOneWidget,
      );

      final persisted = container
          .read(localStoreProvider)
          .dumpAll()
          .map((key, value) => MapEntry(key, value as Object));
      final learnerBContainer = await makeTestContainer(
        seed: persisted,
        overrides: <Override>[
          ...learnerOverrides(learnerB),
          kidsArabicNowProvider.overrideWithValue(
            () => DateTime(2026, 3, 22, 9),
          ),
          dailyNowProvider.overrideWith(
            (ref) =>
                Stream<DateTime>.value(DateTime.parse('2026-03-22T09:00:00')),
          ),
        ],
      );
      learnerBContainer
          .read(appRouterProvider)
          .go('/learn/kids/bedtime-stories/parents');
      await tester.pumpWidget(buildRouterTestApp(learnerBContainer));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(
        find.text(l10n.bedtimeParentWelcomeSubtitleWithName('Yusuf')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
