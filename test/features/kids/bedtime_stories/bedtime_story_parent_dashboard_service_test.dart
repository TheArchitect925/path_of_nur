import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids/activity/application/kids_activity_log_service.dart';
import 'package:path_of_nur/features/kids/activity/domain/kids_activity_models.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/application/bedtime_active_learner_service.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/application/bedtime_story_parent_dashboard_service.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/bedtime_family_models.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/bedtime_story_parent_dashboard_models.dart';
import 'package:path_of_nur/features/learn/journey/domain/learning_path_models.dart';
import 'package:path_of_nur/features/progression/application/learner_progression_service.dart';
import 'package:path_of_nur/features/progression/domain/learner_progression_models.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Bedtime story parent dashboard summary', () {
    test('falls back safely when no bedtime history exists', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      final summary = container.read(bedtimeStoryParentDashboardProvider);
      expect(summary.overview.totalStoriesCompleted, 0);
      expect(summary.overview.totalStoryPartsCompleted, 0);
      expect(summary.overview.totalQuizzesCompleted, 0);
      expect(summary.overview.totalMemorySessionsCompleted, 0);
      expect(summary.learningAreas, hasLength(4));
      expect(summary.continueLearning, isNotNull);
      expect(summary.learningRecentActivity, isEmpty);
      expect(summary.recentActivity, isEmpty);
      expect(summary.recommendations, isNotEmpty);
    });

    test(
      'summarizes bedtime progress, learning activity, and rewards',
      () async {
        final now = DateTime.now();
        final today = now.toIso8601String();
        final yesterday = now
            .subtract(const Duration(days: 1))
            .toIso8601String();
        SharedPreferences.setMockInitialValues(<String, Object>{
          'kids.bedtime_stories.progress.v1': jsonEncode(<String, Object?>{
            'storyProgressById': <String, Object?>{
              'story_prophet_adam_bedtime_v1': <String, Object?>{
                'currentPositionMs': 95000,
                'totalDurationMs': 95000,
                'totalListenedMs': 95000,
                'startedAtIso': yesterday,
                'lastPlayedAtIso': yesterday,
                'completedAtIso': yesterday,
                'completionRewardGrantedAtIso': yesterday,
                'lastPlaybackSource': 'asset',
              },
              'story_prophet_nuh_bedtime_v1': <String, Object?>{
                'currentPositionMs': 45000,
                'totalDurationMs': 100000,
                'totalListenedMs': 45000,
                'startedAtIso': today,
                'lastPlayedAtIso': today,
                'lastPlaybackSource': 'asset',
              },
            },
            'recentStoryIds': <String>[
              'story_prophet_nuh_bedtime_v1',
              'story_prophet_adam_bedtime_v1',
            ],
            'completedSeriesProphetIds': <String>[],
          }),
          'kids.bedtime_stories.learning_progress.v1': jsonEncode(
            <String, Object?>{
              'progressByActivityId': <String, Object?>{
                'quiz_story_prophet_adam_bedtime_v1': <String, Object?>{
                  'storyId': 'story_prophet_adam_bedtime_v1',
                  'mode': 'quiz',
                  'currentStepIndex': 3,
                  'totalSteps': 3,
                  'correctCount': 3,
                  'completedStepIds': <String>['adam_q1', 'adam_q2', 'adam_q3'],
                  'startedAtIso': yesterday,
                  'lastAccessedAtIso': yesterday,
                  'firstCompletedAtIso': yesterday,
                  'rewardGrantedAtIso': yesterday,
                },
                'memory_story_prophet_adam_bedtime_v1': <String, Object?>{
                  'storyId': 'story_prophet_adam_bedtime_v1',
                  'mode': 'memoryCards',
                  'currentStepIndex': 4,
                  'totalSteps': 4,
                  'completedStepIds': <String>[
                    'adam_pair_1',
                    'adam_pair_2',
                    'adam_pair_3',
                    'adam_pair_4',
                  ],
                  'startedAtIso': today,
                  'lastAccessedAtIso': today,
                  'firstCompletedAtIso': today,
                  'rewardGrantedAtIso': today,
                },
              },
              'recentActivityIds': <String>[
                'memory_story_prophet_adam_bedtime_v1',
                'quiz_story_prophet_adam_bedtime_v1',
              ],
            },
          ),
        });
        final prefs = await SharedPreferences.getInstance();
        final container = ProviderContainer(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        );
        addTearDown(container.dispose);

        final summary = container.read(bedtimeStoryParentDashboardProvider);
        expect(summary.overview.totalStoryPartsCompleted, 1);
        expect(summary.overview.totalStoriesCompleted, 1);
        expect(summary.overview.totalQuizzesCompleted, 1);
        expect(summary.overview.totalMemorySessionsCompleted, 1);
        expect(summary.overview.totalXpEarnedFromBedtimeLearning, 19);
        expect(summary.overview.totalOceanDropsEarnedFromBedtimeLearning, 1);
        expect(summary.overview.prophetsExploredCount, greaterThanOrEqualTo(2));
        expect(summary.learningAreas, hasLength(4));
        expect(summary.habitSummary.currentStreak, 2);
        expect(summary.recentActivity, isNotEmpty);
        expect(summary.recommendations, isNotEmpty);
      },
    );

    test('summary follows the active learner progression state', () async {
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
      Future<ProviderContainer> makeContainer(
        BedtimeLearnerIdentity learner,
      ) async {
        SharedPreferences.setMockInitialValues(<String, Object>{});
        final prefs = await SharedPreferences.getInstance();
        return ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            bedtimeAvailableLearnersProvider.overrideWith(
              (ref) => const [learnerA, learnerB],
            ),
            bedtimeActiveLearnerProvider.overrideWith((ref) => learner),
          ],
        );
      }

      final firstContainer = await makeContainer(learnerA);
      addTearDown(firstContainer.dispose);
      firstContainer
          .read(learnerProgressionControllerProvider('child_a').notifier)
          .award(
            sourceRef: 'bedtime_story_a',
            activityType: LearnerProgressionActivityType.bedtimeStoryCompletion,
            sourceModule: 'kids_bedtime_story',
            xp: 5,
            drops: 1,
          );
      final first = firstContainer.read(bedtimeStoryParentDashboardProvider);
      expect(first.overview.learnerDisplayName, 'Maryam');
      expect(first.overview.totalXpEarnedFromBedtimeLearning, 5);
      expect(first.overview.totalOceanDropsEarnedFromBedtimeLearning, 1);

      final secondContainer = await makeContainer(learnerB);
      addTearDown(secondContainer.dispose);
      secondContainer
          .read(learnerProgressionControllerProvider('child_b').notifier)
          .award(
            sourceRef: 'bedtime_story_b',
            activityType: LearnerProgressionActivityType.bedtimeStoryCompletion,
            sourceModule: 'kids_bedtime_story',
            xp: 11,
            drops: 2,
          );
      final second = secondContainer.read(bedtimeStoryParentDashboardProvider);
      expect(second.overview.learnerDisplayName, 'Yusuf');
      expect(second.overview.totalXpEarnedFromBedtimeLearning, 11);
      expect(second.overview.totalOceanDropsEarnedFromBedtimeLearning, 2);
    });

    test(
      'prefers canonical kids activity log for broader recent activity',
      () async {
        const learner = BedtimeLearnerIdentity(
          learnerId: 'child_a',
          displayName: 'Maryam',
          avatarReference: '🌙',
          ageGroup: LearningAgeGroup.kids,
          guardianProfileId: 'guardian_1',
          isFallbackLearner: false,
          preferences: BedtimeLearnerPreferences(),
        );
        SharedPreferences.setMockInitialValues(<String, Object>{});
        final prefs = await SharedPreferences.getInstance();
        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            bedtimeAvailableLearnersProvider.overrideWith(
              (ref) => const [learner],
            ),
            bedtimeActiveLearnerProvider.overrideWith((ref) => learner),
          ],
        );
        addTearDown(container.dispose);

        container
            .read(kidsActivityLogProvider.notifier)
            .log(
              type: KidsActivityType.storyCompleted,
              domain: KidsActivityDomain.stories,
              sourceRef: 'story:adam:complete',
              contentId: 'story_prophet_adam_bedtime_v1',
              titleSnapshot: 'Prophet Adam',
              subtitleSnapshot: 'Trust Allah',
              occurredAt: DateTime(2026, 3, 21, 20),
            );

        final summary = container.read(bedtimeStoryParentDashboardProvider);
        expect(summary.learningRecentActivity, isNotEmpty);
        expect(summary.learningRecentActivity.first.title, 'Prophet Adam');
        expect(
          summary.learningRecentActivity.first.type,
          KidsParentRecentActivityType.story,
        );
      },
    );

    test(
      'maps canonical dua my day activity into broader recent activity',
      () async {
        const learner = BedtimeLearnerIdentity(
          learnerId: 'child_a',
          displayName: 'Maryam',
          avatarReference: '🌙',
          ageGroup: LearningAgeGroup.kids,
          guardianProfileId: 'guardian_1',
          isFallbackLearner: false,
          preferences: BedtimeLearnerPreferences(),
        );
        SharedPreferences.setMockInitialValues(<String, Object>{});
        final prefs = await SharedPreferences.getInstance();
        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            bedtimeAvailableLearnersProvider.overrideWith(
              (ref) => const [learner],
            ),
            bedtimeActiveLearnerProvider.overrideWith((ref) => learner),
          ],
        );
        addTearDown(container.dispose);

        container
            .read(kidsActivityLogProvider.notifier)
            .log(
              type: KidsActivityType.duaMyDayCompleted,
              domain: KidsActivityDomain.duas,
              sourceRef: 'kids_dua_my_day_complete:2026-03-21',
              contentId: 'before-sleep',
              titleSnapshot: 'Before Sleep',
              subtitleSnapshot: 'A calm dua for bedtime',
              occurredAt: DateTime(2026, 3, 21, 21),
            );

        final summary = container.read(bedtimeStoryParentDashboardProvider);
        expect(summary.learningRecentActivity, isNotEmpty);
        expect(
          summary.learningRecentActivity.first.type,
          KidsParentRecentActivityType.duaMyDay,
        );
        expect(summary.learningRecentActivity.first.title, 'Before Sleep');
      },
    );

    test(
      'builds a sparse but real broader summary from progression-only activity',
      () async {
        const learner = BedtimeLearnerIdentity(
          learnerId: 'child_a',
          displayName: 'Maryam',
          avatarReference: '🌙',
          ageGroup: LearningAgeGroup.kids,
          guardianProfileId: 'guardian_1',
          isFallbackLearner: false,
          preferences: BedtimeLearnerPreferences(),
        );
        SharedPreferences.setMockInitialValues(<String, Object>{});
        final prefs = await SharedPreferences.getInstance();
        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            bedtimeAvailableLearnersProvider.overrideWith(
              (ref) => const [learner],
            ),
            bedtimeActiveLearnerProvider.overrideWith((ref) => learner),
          ],
        );
        addTearDown(container.dispose);

        final progression = container.read(
          learnerProgressionControllerProvider(learner.learnerId).notifier,
        );
        progression.award(
          sourceRef: 'kids_dua_sleep',
          activityType: LearnerProgressionActivityType.duaLessonCompletion,
          sourceModule: 'kids_dua',
          xp: 8,
          drops: 1,
        );

        final summary = container.read(bedtimeStoryParentDashboardProvider);
        expect(summary.overview.learnerDisplayName, 'Maryam');
        expect(summary.overview.totalXpEarnedAcrossKidsLearning, 8);
        expect(summary.overview.totalOceanDropsEarnedAcrossKidsLearning, 1);
        expect(summary.continueLearning, isNotNull);
        expect(summary.learningAreas, hasLength(4));
        expect(summary.learningRecentActivity, isNotEmpty);
        expect(
          summary.learningRecentActivity.first.type,
          anyOf(
            KidsParentRecentActivityType.duaLesson,
            KidsParentRecentActivityType.duaPractice,
            KidsParentRecentActivityType.duaMyDay,
          ),
        );
      },
    );
  });
}
