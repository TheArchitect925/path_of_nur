import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/garden/application/garden_service.dart';
import 'package:path_of_nur/features/journey/application/journey_stats_provider.dart';
import 'package:path_of_nur/features/journey/xp/domain/journey_xp_models.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/bedtime_family_models.dart';
import 'package:path_of_nur/features/learn/journey/domain/learning_path_models.dart';
import 'package:path_of_nur/features/progression/domain/learner_progression_models.dart';

void main() {
  group('GardenService', () {
    const service = GardenService();

    test('builds learner-scoped garden state from progression summary', () {
      final state = service.buildState(
        learner: const BedtimeLearnerIdentity(
          learnerId: 'child_1',
          displayName: 'Maryam',
          avatarReference: 'moon',
          ageGroup: LearningAgeGroup.kids,
          guardianProfileId: 'guardian_1',
          isFallbackLearner: false,
          preferences: BedtimeLearnerPreferences(),
        ),
        summary: LearnerProgressionSummary(
          metrics: _metrics(
            totalXp: 180,
            totalDrops: 120,
            stories: 8,
            quizzes: 4,
            memory: 3,
            duaLessons: 5,
            duaPractice: 12,
            routines: 9,
            seerahNodes: 4,
            seerahStages: 1,
            streak: 6,
            longestStreak: 9,
            activeDays: const ['2026-03-17', '2026-03-18', '2026-03-19'],
          ),
          xpSummary: _xpSummary(totalXp: 180, level: 8, progressPercent: 0.46),
          unlockedBadges: const <LearnerProgressionBadgeUnlock>[],
          unlockedMilestones: const <LearnerProgressionMilestoneUnlock>[],
        ),
        progressionState: LearnerProgressionState(
          entriesBySourceRef: <String, LearnerProgressionEntry>{
            'story:1': const LearnerProgressionEntry(
              sourceRef: 'story:1',
              activityType:
                  LearnerProgressionActivityType.bedtimeStoryCompletion,
              sourceModule: 'kids_story',
              occurredAtIso: '2026-03-20T20:00:00.000',
              xpAwarded: 5,
              oceanDropsAwarded: 1,
            ),
          },
          lastUpdatedAtIso: '2026-03-20T20:00:00.000',
        ),
        globalJourneyStats: _journeyStats(),
        globalJourneyXp: _xpSummary(
          totalXp: 300,
          level: 10,
          progressPercent: 0.2,
        ),
        globalJourneyDrops: 45,
      );

      expect(state.learnerId, 'child_1');
      expect(state.isFallbackLearner, isFalse);
      expect(state.totalOceanDrops, 120);
      expect(state.currentGardenLevel, 8);
      expect(state.currentVisualStage.sortOrder, greaterThanOrEqualTo(2));
      expect(state.milestones.where((item) => item.unlocked).length, 5);
      expect(state.recentGrowth, hasLength(1));
      expect(state.dimensions.length, 6);
    });

    test('uses fallback journey totals for fallback learner mode', () {
      final state = service.buildState(
        learner: const BedtimeLearnerIdentity(
          learnerId: 'fallback_1',
          displayName: 'Device learner',
          avatarReference: 'moon',
          ageGroup: LearningAgeGroup.kids,
          guardianProfileId: 'guardian_1',
          isFallbackLearner: true,
          preferences: BedtimeLearnerPreferences(),
        ),
        summary: LearnerProgressionSummary(
          metrics: _metrics(
            totalXp: 0,
            totalDrops: 0,
            stories: 0,
            quizzes: 0,
            memory: 0,
            duaLessons: 0,
            duaPractice: 0,
            routines: 0,
            seerahNodes: 0,
            seerahStages: 0,
            streak: 0,
            longestStreak: 0,
            activeDays: const <String>[],
          ),
          xpSummary: _xpSummary(totalXp: 0, level: 1, progressPercent: 0),
          unlockedBadges: const <LearnerProgressionBadgeUnlock>[],
          unlockedMilestones: const <LearnerProgressionMilestoneUnlock>[],
        ),
        progressionState: const LearnerProgressionState(),
        globalJourneyStats: _journeyStats(
          salah: 90,
          adhkar: 40,
          activeDays: 20,
          currentStreak: 5,
          bestStreak: 12,
        ),
        globalJourneyXp: _xpSummary(
          totalXp: 240,
          level: 9,
          progressPercent: 0.5,
        ),
        globalJourneyDrops: 50,
      );

      expect(state.isFallbackLearner, isTrue);
      expect(state.totalXp, 240);
      expect(state.totalOceanDrops, 50);
      expect(state.prayerFoundationScore, greaterThan(0));
      expect(state.currentVisualStage.sortOrder, greaterThanOrEqualTo(1));
    });
  });
}

LearnerProgressionMetrics _metrics({
  required int totalXp,
  required int totalDrops,
  required int stories,
  required int quizzes,
  required int memory,
  required int duaLessons,
  required int duaPractice,
  required int routines,
  required int seerahNodes,
  required int seerahStages,
  required int streak,
  required int longestStreak,
  required List<String> activeDays,
}) {
  return LearnerProgressionMetrics(
    totalXp: totalXp,
    totalDrops: totalDrops,
    kidsArabicLessonCompletions: 0,
    kidsArabicDailyMissionCompletions: 0,
    storyCompletions: stories,
    quizCompletions: quizzes,
    memoryCompletions: memory,
    duaLessonCompletions: duaLessons,
    duaPracticeSessions: duaPractice,
    duaMyDayCompletions: 0,
    bedtimeRoutineCompletions: routines,
    seerahNodeCompletions: seerahNodes,
    seerahStageCompletions: seerahStages,
    seerahJourneyCompletions: 0,
    currentLearningStreakDays: streak,
    longestLearningStreakDays: longestStreak,
    lastActivityAtIso: activeDays.isEmpty
        ? null
        : '${activeDays.last}T20:00:00.000',
    activeDayKeys: activeDays,
  );
}

XpSummary _xpSummary({
  required int totalXp,
  required int level,
  required double progressPercent,
}) {
  return XpSummary(
    totalXp: totalXp,
    todayXp: 0,
    currentLevel: level,
    currentLevelTitle: 'Learner',
    currentLevelStartXp: 0,
    nextLevel: level + 1,
    nextLevelTitle: 'Next',
    nextLevelTotalXp: totalXp + 100,
    xpIntoLevel: 0,
    xpRequiredInLevel: 100,
    xpRemainingToNextLevel: 100,
    progressPercent: progressPercent,
    updatedAt: DateTime(2026, 3, 21, 20),
  );
}

JourneyStatsSummary _journeyStats({
  int salah = 0,
  int adhkar = 0,
  int activeDays = 0,
  int currentStreak = 0,
  int bestStreak = 0,
}) {
  return JourneyStatsSummary(
    installStartedAt: DateTime(2026, 1, 1),
    timeSinceInstallSeconds: 100,
    totalTrackedWorshipGrowthSeconds: 0,
    trackedShareOfInstallTime: 0,
    otherUntrackedSeconds: 0,
    totalSalahOffered: salah,
    totalAdhkarCompletedLifetime: adhkar,
    totalPostSalahAdhkarCompleted: 0,
    totalDhikrSeconds: 0,
    totalQuranReadingSeconds: 0,
    todayQuranReadingSeconds: 0,
    totalQuranReadingSessions: 0,
    totalQuranListeningSeconds: 0,
    todayQuranListeningSeconds: 0,
    totalQuranListeningSessions: 0,
    dhikrCompletedSessions: 0,
    lessonsCompleted: 0,
    activeDays: activeDays,
    currentStreakDays: currentStreak,
    bestStreakDays: bestStreak,
  );
}
