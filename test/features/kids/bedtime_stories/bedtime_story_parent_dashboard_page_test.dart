import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/application/bedtime_active_learner_service.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/application/bedtime_story_parent_dashboard_service.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/bedtime_family_models.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/bedtime_story_parent_dashboard_models.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/presentation/bedtime_story_parent_dashboard_page.dart';
import 'package:path_of_nur/features/learn/journey/domain/learning_path_models.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const learnerA = BedtimeLearnerIdentity(
    learnerId: 'child_a',
    displayName: 'Maryam',
    avatarReference: '🌙',
    ageGroup: LearningAgeGroup.kids,
    guardianProfileId: 'guardian_1',
    isFallbackLearner: false,
    preferences: BedtimeLearnerPreferences(),
  );
  const learnerB = BedtimeLearnerIdentity(
    learnerId: 'child_b',
    displayName: 'Yusuf',
    avatarReference: '⭐',
    ageGroup: LearningAgeGroup.kids,
    guardianProfileId: 'guardian_1',
    isFallbackLearner: false,
    preferences: BedtimeLearnerPreferences(),
  );

  BedtimeParentDashboardSummary summaryFor(BedtimeLearnerIdentity learner) {
    return BedtimeParentDashboardSummary(
      overview: BedtimeParentOverviewSummary(
        learnerId: learner.learnerId,
        learnerDisplayName: learner.displayName,
        currentLevel: learner.learnerId == 'child_a' ? 3 : 1,
        currentLevelTitle: learner.learnerId == 'child_a'
            ? 'Learner'
            : 'Seeker',
        xpProgressPercent: learner.learnerId == 'child_a' ? 0.6 : 0.2,
        xpRemainingToNextLevel: learner.learnerId == 'child_a' ? 12 : 18,
        totalStoriesCompleted: learner.learnerId == 'child_a' ? 2 : 0,
        totalStoryPartsCompleted: learner.learnerId == 'child_a' ? 3 : 0,
        totalQuizzesCompleted: learner.learnerId == 'child_a' ? 1 : 0,
        totalMemorySessionsCompleted: 0,
        totalRecallActivitiesCompleted: 0,
        totalBedtimeLearningSessions: learner.learnerId == 'child_a' ? 4 : 0,
        totalXpEarnedFromBedtimeLearning: learner.learnerId == 'child_a'
            ? 19
            : 0,
        totalOceanDropsEarnedFromBedtimeLearning: learner.learnerId == 'child_a'
            ? 1
            : 0,
        totalXpEarnedAcrossKidsLearning: learner.learnerId == 'child_a'
            ? 36
            : 4,
        totalOceanDropsEarnedAcrossKidsLearning: learner.learnerId == 'child_a'
            ? 3
            : 0,
        totalKidsStoriesCompleted: learner.learnerId == 'child_a' ? 3 : 0,
        totalSeerahStagesCompleted: learner.learnerId == 'child_a' ? 2 : 0,
        totalSeerahJourneysCompleted: learner.learnerId == 'child_a' ? 1 : 0,
        totalDuasLearned: learner.learnerId == 'child_a' ? 2 : 0,
        totalArabicLettersCompleted: learner.learnerId == 'child_a' ? 4 : 0,
        totalArabicReviewLetters: learner.learnerId == 'child_a' ? 1 : 0,
        currentBedtimeLearningStreak: learner.learnerId == 'child_a' ? 2 : 0,
        longestBedtimeLearningStreak: learner.learnerId == 'child_a' ? 2 : 0,
        lastBedtimeSessionDateIso: learner.learnerId == 'child_a'
            ? DateTime(2026, 3, 21).toIso8601String()
            : null,
        prophetsExploredCount: learner.learnerId == 'child_a' ? 2 : 0,
        lessonsLearned: learner.learnerId == 'child_a'
            ? const ['Trust Allah']
            : const [],
      ),
      habitSummary: BedtimeParentHabitSummary(
        currentStreak: learner.learnerId == 'child_a' ? 2 : 0,
        longestStreak: learner.learnerId == 'child_a' ? 2 : 0,
        activeDaysThisWeek: learner.learnerId == 'child_a' ? 2 : 0,
        activeDaysThisMonth: learner.learnerId == 'child_a' ? 2 : 0,
        averageSessionsPerWeek: learner.learnerId == 'child_a' ? 4.0 : 0.0,
        lastActiveDateIso: learner.learnerId == 'child_a'
            ? DateTime(2026, 3, 21).toIso8601String()
            : null,
        activeDayKeys: learner.learnerId == 'child_a'
            ? const ['2026-03-20', '2026-03-21']
            : const [],
      ),
      continueLearning: learner.learnerId == 'child_a'
          ? const KidsParentContinueLearningItem(
              type: KidsParentContinueType.story,
              title: 'Prophet Adam',
              subtitle: 'Trust Allah',
              routeName: 'kidsBedtimeStoryDetail',
              pathParameters: {'storyId': 'story_prophet_adam_bedtime_v1'},
            )
          : null,
      learningAreas: [
        KidsParentLearningAreaSummary(
          type: KidsParentLearningAreaType.stories,
          completedCount: learner.learnerId == 'child_a' ? 3 : 0,
          totalCount: 12,
          secondaryCount: learner.learnerId == 'child_a' ? 4 : 0,
          lastActiveDateIso: learner.learnerId == 'child_a'
              ? DateTime(2026, 3, 21).toIso8601String()
              : null,
          hasActivity: learner.learnerId == 'child_a',
        ),
        KidsParentLearningAreaSummary(
          type: KidsParentLearningAreaType.seerah,
          completedCount: learner.learnerId == 'child_a' ? 2 : 0,
          totalCount: 8,
          secondaryCount: learner.learnerId == 'child_a' ? 1 : 0,
          lastActiveDateIso: null,
          hasActivity: learner.learnerId == 'child_a',
        ),
        KidsParentLearningAreaSummary(
          type: KidsParentLearningAreaType.duas,
          completedCount: learner.learnerId == 'child_a' ? 2 : 0,
          totalCount: 9,
          secondaryCount: learner.learnerId == 'child_a' ? 2 : 0,
          lastActiveDateIso: null,
          hasActivity: learner.learnerId == 'child_a',
        ),
        KidsParentLearningAreaSummary(
          type: KidsParentLearningAreaType.arabic,
          completedCount: learner.learnerId == 'child_a' ? 4 : 0,
          totalCount: 28,
          secondaryCount: learner.learnerId == 'child_a' ? 1 : 0,
          lastActiveDateIso: null,
          hasActivity: learner.learnerId == 'child_a',
        ),
      ],
      learningRecentActivity: learner.learnerId == 'child_a'
          ? [
              KidsParentRecentActivityItem(
                id: 'story_1',
                title: 'Prophet Adam',
                subtitle: 'Trust Allah',
                type: KidsParentRecentActivityType.story,
                occurredAtIso: DateTime(2026, 3, 21).toIso8601String(),
              ),
            ]
          : const [],
      recentActivity: const [],
      prophetProgress: const [],
      recommendations: const [],
      progressionBadges: const [],
      progressionMilestones: const [],
    );
  }

  Future<ProviderContainer> pumpPage(
    WidgetTester tester, {
    required BedtimeLearnerIdentity activeLearner,
  }) async {
    final container = await makeTestContainer(
      overrides: [
        bedtimeAvailableLearnersProvider.overrideWith(
          (ref) => const [learnerA, learnerB],
        ),
        bedtimeActiveLearnerProvider.overrideWith((ref) => activeLearner),
        bedtimeStoryParentDashboardProvider.overrideWith(
          (ref) => summaryFor(activeLearner),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const Scaffold(body: BedtimeStoryParentDashboardPage()),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    return container;
  }

  testWidgets('renders learner-specific summary state', (tester) async {
    final container = await pumpPage(tester, activeLearner: learnerA);
    final l10n = AppLocalizations.of(
      tester.element(find.byType(BedtimeStoryParentDashboardPage)),
    );

    Future<void> expectTextRevealed(String text) async {
      if (!tester.any(find.text(text))) {
        await tester.scrollUntilVisible(
          find.text(text),
          400,
          scrollable: find.byType(Scrollable).first,
          maxScrolls: 60,
        );
      }
      expect(find.text(text), findsOneWidget);
    }

    await expectTextRevealed(
      l10n.bedtimeParentWelcomeSubtitleWithName('Maryam'),
    );
    container.dispose();

    await pumpPage(tester, activeLearner: learnerB);
    await tester.pump(const Duration(milliseconds: 200));

    // The scroll offset carries over from the first pump; reset it so the
    // hero card is reachable by forward scrolling.
    tester
        .state<ScrollableState>(find.byType(Scrollable).first)
        .position
        .jumpTo(0);
    await tester.pump();

    await expectTextRevealed(
      l10n.bedtimeParentWelcomeSubtitleWithName('Yusuf'),
    );
  });
}
