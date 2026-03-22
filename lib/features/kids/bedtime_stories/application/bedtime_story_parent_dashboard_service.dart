import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../../accounts_sync/application/accounts_sync_controller.dart';
import '../../activity/application/kids_activity_log_service.dart';
import '../../activity/domain/kids_activity_models.dart';
import '../../../kids_arabic/application/kids_arabic_parent_provider.dart';
import '../../../kids_arabic/application/kids_arabic_progress_provider.dart';
import '../../../kids_arabic/domain/kids_arabic_models.dart';
import '../../../kids_dua_learning/application/kids_dua_experience_provider.dart';
import '../../../kids_dua_learning/application/kids_dua_progress_provider.dart';
import '../../../kids_dua_learning/application/kids_dua_repository.dart';
import '../../../kids_dua_learning/domain/kids_dua_models.dart';
import '../../../learn/journey/application/family_learning_provider.dart';
import '../../../progression/application/learner_progression_service.dart';
import '../../../progression/domain/learner_progression_models.dart';
import '../../seerah/application/seerah_journey_progress_service.dart';
import '../../seerah/application/seerah_journey_repository.dart';
import '../../seerah/domain/seerah_journey_models.dart';
import '../domain/bedtime_story_learning_models.dart';
import '../domain/bedtime_story_models.dart';
import '../domain/bedtime_story_parent_dashboard_models.dart';
import 'bedtime_active_learner_service.dart';
import 'bedtime_story_learning_progress_service.dart';
import 'bedtime_story_learning_repository.dart';
import 'bedtime_story_progress_service.dart';
import 'bedtime_story_repository.dart';

final bedtimeStoryParentDashboardProvider =
    Provider<BedtimeParentDashboardSummary>((ref) {
      final service = BedtimeStoryParentDashboardService(ref);
      return service.buildSummary();
    });

class BedtimeStoryParentDashboardService {
  BedtimeStoryParentDashboardService(this._ref);

  final Ref _ref;

  BedtimeParentDashboardSummary buildSummary() {
    final allStories = _ref.watch(kidsIslamicStoriesProvider);
    final bedtimeStories = _ref.watch(bedtimeStoriesProvider);
    final prophetBedtimeStories = bedtimeStories
        .where((story) => story.isProphetStory)
        .toList(growable: false);
    final storyProgress = _ref.watch(bedtimeStoryProgressProvider);
    final learningState = _ref.watch(bedtimeStoryLearningProgressProvider);
    final learningRepo = _ref.watch(bedtimeStoryLearningRepositoryProvider);
    final seerahRepository = _ref.watch(kidsSeerahJourneyRepositoryProvider);
    _ref.watch(kidsSeerahJourneyProgressProvider);
    final seerahContinue = _ref.watch(kidsSeerahContinueJourneyProvider);
    final duaSummary = _ref.watch(kidsDuaProgressSummaryProvider);
    final duaLight = _ref.watch(kidsDuaLightSummaryProvider);
    final duaContinue = _ref.watch(kidsDuaContinueLessonItemProvider);
    final duaLearning = _ref.watch(kidsDuaLearningProvider);
    final duaLessons = _ref.watch(kidsDuaLessonsProvider);
    final arabicSummary = _ref.watch(kidsArabicParentSummaryProvider);
    final arabicRecommendation = _ref.watch(
      kidsArabicParentRecommendedActivityProvider,
    );
    final arabicLetters = _ref.watch(kidsArabicLettersProvider);
    final arabicProgress = _ref.watch(kidsArabicProgressProvider);
    final accounts = _ref.watch(accountsSyncControllerProvider);
    final familyContext = _ref.watch(activeFamilyLearningContextProvider);
    final learner = _ref.watch(bedtimeActiveLearnerProvider);
    final progressionState = _ref.watch(
      learnerProgressionControllerProvider(learner.learnerId),
    );
    _ref.watch(kidsActivityLogProvider);
    final activityController = _ref.read(kidsActivityLogProvider.notifier);
    final progressionController = _ref.read(
      learnerProgressionControllerProvider(learner.learnerId).notifier,
    );
    final progression = progressionController.buildSummary();
    final bedtimeProgression = progressionController.buildSummary(
      sourceModules: const <String>{
        'kids_bedtime_story',
        'kids_bedtime_story_learning',
        'kids_bedtime_routine',
      },
    );

    final completedProphetStoryParts = prophetBedtimeStories
        .where(
          (story) => (storyProgress.storyProgressById[story.id]?.isCompleted ?? false),
        )
        .toList(growable: false);
    final completedLibraryStories = allStories
        .where(
          (story) => (storyProgress.storyProgressById[story.id]?.isCompleted ?? false),
        )
        .toList(growable: false);
    final startedLibraryStories = allStories
        .where((story) {
          final progress = storyProgress.storyProgressById[story.id];
          return (progress?.hasProgress ?? false) || (progress?.isCompleted ?? false);
        })
        .toList(growable: false);

    final groupedStories = <String, List<BedtimeStorySeed>>{};
    for (final story in prophetBedtimeStories) {
      groupedStories.putIfAbsent(story.prophetId, () => <BedtimeStorySeed>[]).add(story);
    }
    final completedStoryGroups = groupedStories.values.where((group) {
      return group.every(
        (story) => storyProgress.storyProgressById[story.id]?.isCompleted ?? false,
      );
    }).length;

    final completedQuizzes = learningRepo.quizzes
        .where(
          (quiz) =>
              learningState.progressByActivityId[quiz.quizId]?.isCompleted ?? false,
        )
        .toList(growable: false);
    final completedMemory = learningRepo.memoryDecks
        .where(
          (deck) =>
              learningState.progressByActivityId[deck.deckId]?.isCompleted ?? false,
        )
        .toList(growable: false);

    final bedtimeActiveDates = _activityDateKeys(
      stories: prophetBedtimeStories,
      storyProgress: storyProgress,
      learningState: learningState,
    );
    final allActiveDates = progression.metrics.activeDayKeys.isNotEmpty
        ? progression.metrics.activeDayKeys
        : _activityDateKeys(
            stories: allStories,
            storyProgress: storyProgress,
            learningState: learningState,
          );
    final lastActiveDateIso = activityController.mostRecentActivity()?.occurredAtIso ??
        progression.metrics.lastActivityAtIso ??
        _latestActivityIso(
          stories: allStories,
          storyProgress: storyProgress,
          learningState: learningState,
        );

    final inferredBedtimeXp = completedProphetStoryParts.fold<int>(
          0,
          (sum, story) => sum + story.xpReward,
        ) +
        completedQuizzes.fold<int>(0, (sum, quiz) => sum + quiz.reward.xpReward) +
        completedMemory.fold<int>(0, (sum, deck) => sum + deck.reward.xpReward);
    final inferredBedtimeDrops = completedProphetStoryParts.fold<int>(
      0,
      (sum, story) => sum + story.oceanDropsReward,
    );

    final seerahSummaries = seerahRepository.journeys
        .map(
          (journey) => _ref.read(
            kidsSeerahJourneySummaryProvider(journey.journeyId),
          ),
        )
        .whereType<KidsSeerahJourneySummary>()
        .toList(growable: false);
    final totalSeerahStagesCompleted = seerahSummaries.fold<int>(
      0,
      (sum, item) => sum + item.completedStageCount,
    );
    final totalSeerahStagesAvailable = seerahSummaries.fold<int>(
      0,
      (sum, item) => sum + item.stages.length,
    );
    final totalSeerahJourneysCompleted = seerahSummaries
        .where((item) => item.isCompleted)
        .length;

    final overview = BedtimeParentOverviewSummary(
      learnerId: familyContext.activeChildProfile?.id ?? accounts.activeProfileId,
      learnerDisplayName: learner.effectiveDisplayName,
      currentLevel: progression.xpSummary.currentLevel,
      currentLevelTitle: progression.xpSummary.currentLevelTitle,
      xpProgressPercent: progression.xpSummary.progressPercent,
      xpRemainingToNextLevel: progression.xpSummary.xpRemainingToNextLevel,
      totalStoriesCompleted: completedStoryGroups,
      totalStoryPartsCompleted: completedProphetStoryParts.length,
      totalQuizzesCompleted: completedQuizzes.length,
      totalMemorySessionsCompleted: completedMemory.length,
      totalRecallActivitiesCompleted: completedQuizzes.length,
      totalBedtimeLearningSessions:
          storyProgress.recentStoryIds.length + learningState.recentActivityIds.length,
      totalXpEarnedFromBedtimeLearning: bedtimeProgression.metrics.totalXp > 0
          ? bedtimeProgression.metrics.totalXp
          : inferredBedtimeXp,
      totalOceanDropsEarnedFromBedtimeLearning:
          bedtimeProgression.metrics.totalDrops > 0
          ? bedtimeProgression.metrics.totalDrops
          : inferredBedtimeDrops,
      totalXpEarnedAcrossKidsLearning: progression.metrics.totalXp,
      totalOceanDropsEarnedAcrossKidsLearning: progression.metrics.totalDrops,
      totalKidsStoriesCompleted: progression.metrics.storyCompletions > 0
          ? progression.metrics.storyCompletions
          : completedLibraryStories.length,
      totalSeerahStagesCompleted: totalSeerahStagesCompleted,
      totalSeerahJourneysCompleted: totalSeerahJourneysCompleted,
      totalDuasLearned: duaSummary.learnedLessons,
      totalArabicLettersCompleted: arabicSummary.lettersCompleted,
      totalArabicReviewLetters: arabicSummary.reviewNeededLetterIds.length,
      currentBedtimeLearningStreak: _currentStreak(bedtimeActiveDates),
      longestBedtimeLearningStreak: _longestStreak(bedtimeActiveDates),
      lastBedtimeSessionDateIso: lastActiveDateIso,
      prophetsExploredCount: groupedStories.entries
          .where(
            (entry) => entry.value.any((story) {
              final progress = storyProgress.storyProgressById[story.id];
              return (progress?.hasProgress ?? false) || (progress?.isCompleted ?? false);
            }),
          )
          .length,
      lessonsLearned: _lessonsLearned(
        stories: allStories,
        storyProgress: storyProgress,
      ),
    );

    final habitSummary = BedtimeParentHabitSummary(
      currentStreak: progression.metrics.currentLearningStreakDays > 0
          ? progression.metrics.currentLearningStreakDays
          : _currentStreak(allActiveDates),
      longestStreak: progression.metrics.longestLearningStreakDays > 0
          ? progression.metrics.longestLearningStreakDays
          : _longestStreak(allActiveDates),
      activeDaysThisWeek: _activeDaysSince(allActiveDates, const Duration(days: 7)),
      activeDaysThisMonth: _activeDaysSince(allActiveDates, const Duration(days: 30)),
      averageSessionsPerWeek: _averageSessionsPerWeek(
        storyCount: storyProgress.recentStoryIds.length,
        learningCount: learningState.recentActivityIds.length + duaLearning.activityLog.length,
        activeDates: allActiveDates,
      ),
      lastActiveDateIso: lastActiveDateIso,
      activeDayKeys: allActiveDates,
    );

    return BedtimeParentDashboardSummary(
      overview: overview,
      habitSummary: habitSummary,
      continueLearning: _continueLearning(
        continueStory: _ref.watch(continueKidsStoryProvider),
        seerahContinue: seerahContinue,
        duaContinue: duaContinue,
        arabicRecommendation: arabicRecommendation,
        arabicLetters: arabicLetters,
        seerahRepository: seerahRepository,
      ),
      learningAreas: _learningAreas(
        storiesCompleted: progression.metrics.storyCompletions > 0
            ? progression.metrics.storyCompletions
            : completedLibraryStories.length,
        storiesTotal: allStories.length,
        startedStoriesCount: startedLibraryStories.length,
        seerahStagesCompleted: totalSeerahStagesCompleted,
        seerahStagesTotal: totalSeerahStagesAvailable,
        seerahJourneysCompleted: totalSeerahJourneysCompleted,
        duaSummary: duaSummary,
        duaLight: duaLight,
        duaLastActiveIso: activityController
                .mostRecentActivity(domains: const {KidsActivityDomain.duas})
                ?.occurredAtIso ??
            _latestDuaActivityIso(duaLearning.activityLog),
        arabicSummary: arabicSummary,
        arabicLastActiveIso: activityController
                .mostRecentActivity(domains: const {KidsActivityDomain.arabic})
                ?.occurredAtIso ??
            arabicProgress.dailyProgress.lastCompletedAt,
        activityController: activityController,
      ),
      learningRecentActivity: _learningRecentActivity(
        activityController: activityController,
        allStories: allStories,
        progressionState: progressionState,
        duaLessons: duaLessons,
        arabicLetters: arabicLetters,
        seerahRepository: seerahRepository,
      ),
      recentActivity: _recentActivity(
        stories: allStories,
        storyProgress: storyProgress,
        learningRepo: learningRepo,
        learningState: learningState,
      ),
      prophetProgress: _prophetProgress(
        groupedStories: groupedStories,
        storyProgress: storyProgress,
        learningRepo: learningRepo,
        learningState: learningState,
      ),
      recommendations: _recommendations(
        stories: allStories,
        storyProgress: storyProgress,
        learningRepo: learningRepo,
        learningState: learningState,
      ),
      progressionBadges: progression.unlockedBadges
          .map((item) => item.definition.badgeId)
          .toList(growable: false),
      progressionMilestones: progression.unlockedMilestones
          .map((item) => item.definition.milestoneId)
          .toList(growable: false),
    );
  }

  List<String> _lessonsLearned({
    required List<BedtimeStorySeed> stories,
    required BedtimeStoryLibraryProgress storyProgress,
  }) {
    final lessons = <String>{};
    for (final story in stories) {
      if (storyProgress.storyProgressById[story.id]?.isCompleted ?? false) {
        lessons.add(story.lesson);
      }
    }
    return lessons.take(8).toList(growable: false);
  }

  List<BedtimeParentProphetProgress> _prophetProgress({
    required Map<String, List<BedtimeStorySeed>> groupedStories,
    required BedtimeStoryLibraryProgress storyProgress,
    required BedtimeStoryLearningRepository learningRepo,
    required BedtimeStoryLearningProgressState learningState,
  }) {
    final items = <BedtimeParentProphetProgress>[];
    for (final entry in groupedStories.entries) {
      final stories = [...entry.value]..sort((a, b) => a.partNumber.compareTo(b.partNumber));
      final storyPartsCompleted = stories
          .where((story) => storyProgress.storyProgressById[story.id]?.isCompleted ?? false)
          .length;
      final started = stories.any((story) {
        final progress = storyProgress.storyProgressById[story.id];
        return (progress?.hasProgress ?? false) || (progress?.isCompleted ?? false);
      });
      final continueStory = stories.firstWhere(
        (story) => !(storyProgress.storyProgressById[story.id]?.isCompleted ?? false),
        orElse: () => stories.first,
      );
      final quizCompleted = stories.every((story) {
        final quiz = learningRepo.quizForStory(story.id);
        if (quiz == null) {
          return true;
        }
        return learningState.progressByActivityId[quiz.quizId]?.isCompleted ?? false;
      });
      final memoryCompleted = stories.every((story) {
        final deck = learningRepo.memoryDeckForStory(story.id);
        if (deck == null) {
          return true;
        }
        return learningState.progressByActivityId[deck.deckId]?.isCompleted ?? false;
      });
      items.add(
        BedtimeParentProphetProgress(
          prophetId: entry.key,
          title: stories.first.shortTitle,
          mainLesson: stories.first.lesson,
          storyPartsCompleted: storyPartsCompleted,
          totalStoryParts: stories.length,
          quizCompleted: quizCompleted,
          memoryCompleted: memoryCompleted,
          started: started,
          completed: storyPartsCompleted == stories.length,
          continueStoryId: continueStory.id,
        ),
      );
    }
    return items;
  }

  List<BedtimeParentRecentActivityItem> _recentActivity({
    required List<BedtimeStorySeed> stories,
    required BedtimeStoryLibraryProgress storyProgress,
    required BedtimeStoryLearningRepository learningRepo,
    required BedtimeStoryLearningProgressState learningState,
  }) {
    final items = <BedtimeParentRecentActivityItem>[];
    for (final story in stories) {
      final progress = storyProgress.storyProgressById[story.id];
      if (progress == null) {
        continue;
      }
      final completedAt = progress.completedAtIso;
      if (completedAt != null && completedAt.isNotEmpty) {
        items.add(
          BedtimeParentRecentActivityItem(
            id: 'story_complete_${story.id}',
            storyId: story.id,
            title: story.shortTitle,
            prophetId: story.prophetId,
            type: BedtimeParentActivityType.storyCompleted,
            occurredAtIso: completedAt,
            completionState: BedtimeStoryLearningCompletionState.completed,
          ),
        );
      } else if ((progress.lastPlayedAtIso ?? '').isNotEmpty) {
        items.add(
          BedtimeParentRecentActivityItem(
            id: 'story_listened_${story.id}',
            storyId: story.id,
            title: story.shortTitle,
            prophetId: story.prophetId,
            type: BedtimeParentActivityType.storyListened,
            occurredAtIso: progress.lastPlayedAtIso!,
            completionState: BedtimeStoryLearningCompletionState.inProgress,
          ),
        );
      } else if ((progress.startedAtIso ?? '').isNotEmpty) {
        items.add(
          BedtimeParentRecentActivityItem(
            id: 'story_started_${story.id}',
            storyId: story.id,
            title: story.shortTitle,
            prophetId: story.prophetId,
            type: BedtimeParentActivityType.storyStarted,
            occurredAtIso: progress.startedAtIso!,
            completionState: BedtimeStoryLearningCompletionState.inProgress,
          ),
        );
      }
    }

    for (final quiz in learningRepo.quizzes) {
      final progress = learningState.progressByActivityId[quiz.quizId];
      if ((progress?.firstCompletedAtIso ?? '').isNotEmpty) {
        items.add(
          BedtimeParentRecentActivityItem(
            id: 'quiz_complete_${quiz.quizId}',
            storyId: quiz.storyId,
            title: quiz.title,
            prophetId: quiz.prophetId,
            type: BedtimeParentActivityType.quizCompleted,
            occurredAtIso: progress!.firstCompletedAtIso!,
            completionState: BedtimeStoryLearningCompletionState.completed,
          ),
        );
      }
    }
    for (final deck in learningRepo.memoryDecks) {
      final progress = learningState.progressByActivityId[deck.deckId];
      if ((progress?.firstCompletedAtIso ?? '').isNotEmpty) {
        items.add(
          BedtimeParentRecentActivityItem(
            id: 'memory_complete_${deck.deckId}',
            storyId: deck.storyId,
            title: deck.title,
            prophetId: deck.prophetId,
            type: BedtimeParentActivityType.memoryCompleted,
            occurredAtIso: progress!.firstCompletedAtIso!,
            completionState: BedtimeStoryLearningCompletionState.completed,
          ),
        );
      }
    }

    items.sort((a, b) => b.occurredAtIso.compareTo(a.occurredAtIso));
    return items.take(12).toList(growable: false);
  }

  List<BedtimeParentRecommendation> _recommendations({
    required List<BedtimeStorySeed> stories,
    required BedtimeStoryLibraryProgress storyProgress,
    required BedtimeStoryLearningRepository learningRepo,
    required BedtimeStoryLearningProgressState learningState,
  }) {
    final recommendations = <BedtimeParentRecommendation>[];
    final continueStory = _ref.watch(continueKidsStoryProvider);
    if (continueStory != null) {
      recommendations.add(
        BedtimeParentRecommendation(
          type: BedtimeParentRecommendationType.continueStory,
          storyId: continueStory.id,
          title: continueStory.title,
          subtitle: continueStory.lesson,
        ),
      );
    }

    for (final story in stories) {
      final isCompleted = storyProgress.storyProgressById[story.id]?.isCompleted ?? false;
      if (!isCompleted) {
        continue;
      }
      final quiz = learningRepo.quizForStory(story.id);
      if (quiz != null &&
          !(learningState.progressByActivityId[quiz.quizId]?.isCompleted ?? false)) {
        recommendations.add(
          BedtimeParentRecommendation(
            type: BedtimeParentRecommendationType.completeQuiz,
            storyId: story.id,
            title: quiz.title,
            subtitle: quiz.shortDescription,
            activityMode: BedtimeStoryLearningMode.quiz,
          ),
        );
        break;
      }
    }

    for (final story in stories) {
      final isCompleted = storyProgress.storyProgressById[story.id]?.isCompleted ?? false;
      if (!isCompleted) {
        continue;
      }
      final deck = learningRepo.memoryDeckForStory(story.id);
      if (deck != null &&
          !(learningState.progressByActivityId[deck.deckId]?.isCompleted ?? false)) {
        recommendations.add(
          BedtimeParentRecommendation(
            type: BedtimeParentRecommendationType.completeMemory,
            storyId: story.id,
            title: deck.title,
            subtitle: deck.shortDescription,
            activityMode: BedtimeStoryLearningMode.memoryCards,
          ),
        );
        break;
      }
    }

    final nextStory = stories.firstWhere(
      (story) => !(storyProgress.storyProgressById[story.id]?.isCompleted ?? false),
      orElse: () => _ref.watch(tonightBedtimeStoryProvider) ?? stories.first,
    );
    recommendations.add(
      BedtimeParentRecommendation(
        type: BedtimeParentRecommendationType.nextStory,
        storyId: nextStory.id,
        title: nextStory.title,
        subtitle: nextStory.lesson,
      ),
    );

    final tonight = _ref.watch(tonightBedtimeStoryProvider);
    if (tonight != null && tonight.id != nextStory.id) {
      recommendations.add(
        BedtimeParentRecommendation(
          type: BedtimeParentRecommendationType.tonightStory,
          storyId: tonight.id,
          title: tonight.title,
          subtitle: tonight.lesson,
        ),
      );
    }
    return recommendations.take(4).toList(growable: false);
  }

  KidsParentContinueLearningItem? _continueLearning({
    required BedtimeStorySeed? continueStory,
    required KidsSeerahJourney? seerahContinue,
    required KidsDuaLessonContent? duaContinue,
    required KidsArabicRecommendedActivity? arabicRecommendation,
    required List<KidsArabicLetter> arabicLetters,
    required KidsSeerahJourneyRepository seerahRepository,
  }) {
    if (continueStory != null) {
      return KidsParentContinueLearningItem(
        type: KidsParentContinueType.story,
        title: continueStory.title,
        subtitle: continueStory.lesson,
        routeName: continueStory.bedtimeEligible
            ? 'kidsBedtimeStoryDetail'
            : 'kidsStoryDetail',
        pathParameters: {'storyId': continueStory.id},
      );
    }
    if (seerahContinue != null) {
      final summary = _ref.read(
        kidsSeerahJourneySummaryProvider(seerahContinue.journeyId),
      );
      final nextNodeId = summary?.nextNodeId;
      final nextNodeTitle = nextNodeId == null
          ? null
          : seerahRepository.nodeById(nextNodeId)?.title;
      return KidsParentContinueLearningItem(
        type: KidsParentContinueType.seerah,
        title: seerahContinue.title,
        subtitle: nextNodeTitle ?? seerahContinue.description,
        routeName: nextNodeId == null ? 'kidsSeerahJourney' : 'kidsSeerahNode',
        pathParameters: nextNodeId == null
            ? {'journeyId': seerahContinue.journeyId}
            : {'journeyId': seerahContinue.journeyId, 'nodeId': nextNodeId},
      );
    }
    if (duaContinue != null) {
      return KidsParentContinueLearningItem(
        type: KidsParentContinueType.dua,
        title: duaContinue.title,
        subtitle: duaContinue.miniLesson,
        routeName: 'kidsDuaLesson',
        pathParameters: {'duaId': duaContinue.id},
      );
    }
    if (arabicRecommendation != null) {
      final letter = arabicLetters.where((item) => item.id == arabicRecommendation.letterId).firstOrNull;
      if (letter == null) {
        return null;
      }
      return KidsParentContinueLearningItem(
        type: KidsParentContinueType.arabic,
        title: letter.nameEn,
        subtitle: letter.childFriendlyLine,
        routeName: arabicRecommendation.opensReview
            ? 'kidsArabicReview'
            : 'kidsArabicLesson',
        pathParameters: arabicRecommendation.opensReview
            ? const <String, String>{}
            : {'letterId': letter.id},
      );
    }
    final tonightStory = _ref.watch(featuredKidsStoryProvider);
    if (tonightStory == null) {
      return null;
    }
    return KidsParentContinueLearningItem(
      type: KidsParentContinueType.story,
      title: tonightStory.title,
      subtitle: tonightStory.lesson,
      routeName: tonightStory.bedtimeEligible
          ? 'kidsBedtimeStoryDetail'
          : 'kidsStoryDetail',
      pathParameters: {'storyId': tonightStory.id},
    );
  }

  List<KidsParentLearningAreaSummary> _learningAreas({
    required int storiesCompleted,
    required int storiesTotal,
    required int startedStoriesCount,
    required int seerahStagesCompleted,
    required int seerahStagesTotal,
    required int seerahJourneysCompleted,
    required KidsDuaProgressSummary duaSummary,
    required KidsDuaLightSummary duaLight,
    required String? duaLastActiveIso,
    required KidsArabicParentSummary arabicSummary,
    required String? arabicLastActiveIso,
    required KidsActivityLogController activityController,
  }) {
    return [
      KidsParentLearningAreaSummary(
        type: KidsParentLearningAreaType.stories,
        completedCount: storiesCompleted,
        totalCount: storiesTotal,
        secondaryCount: startedStoriesCount,
        lastActiveDateIso: activityController
                .mostRecentActivity(domains: const {KidsActivityDomain.stories})
                ?.occurredAtIso ??
            _latestActivityIso(
              stories: _ref.read(kidsIslamicStoriesProvider),
              storyProgress: _ref.read(bedtimeStoryProgressProvider),
              learningState: _ref.read(bedtimeStoryLearningProgressProvider),
            ),
        hasActivity: startedStoriesCount > 0,
      ),
      KidsParentLearningAreaSummary(
        type: KidsParentLearningAreaType.seerah,
        completedCount: seerahStagesCompleted,
        totalCount: seerahStagesTotal,
        secondaryCount: seerahJourneysCompleted,
        lastActiveDateIso: activityController
                .mostRecentActivity(domains: const {KidsActivityDomain.seerah})
                ?.occurredAtIso ??
            _latestProgressionIsoForModules(
              _ref.read(
                learnerProgressionControllerProvider(
                  _ref.read(bedtimeActiveLearnerProvider).learnerId,
                ),
              ),
              const {'kids_seerah'},
            ),
        hasActivity: seerahStagesCompleted > 0 || seerahJourneysCompleted > 0,
      ),
      KidsParentLearningAreaSummary(
        type: KidsParentLearningAreaType.duas,
        completedCount: duaSummary.learnedLessons,
        totalCount: duaSummary.totalLessons,
        secondaryCount: duaLight.currentStreakDays,
        lastActiveDateIso: duaLastActiveIso,
        hasActivity: duaSummary.learnedLessons > 0 || duaSummary.startedCategories > 0,
      ),
      KidsParentLearningAreaSummary(
        type: KidsParentLearningAreaType.arabic,
        completedCount: arabicSummary.lettersCompleted,
        totalCount: _ref.read(kidsArabicLettersProvider).length,
        secondaryCount: arabicSummary.reviewNeededLetterIds.length,
        lastActiveDateIso: arabicLastActiveIso,
        hasActivity: arabicSummary.lessonsCompleted > 0,
      ),
    ];
  }

  List<KidsParentRecentActivityItem> _learningRecentActivity({
    required KidsActivityLogController activityController,
    required List<BedtimeStorySeed> allStories,
    required LearnerProgressionState progressionState,
    required List<KidsDuaLessonContent> duaLessons,
    required List<KidsArabicLetter> arabicLetters,
    required KidsSeerahJourneyRepository seerahRepository,
  }) {
    final canonicalEntries = activityController.recentActivities(limit: 10);
    if (canonicalEntries.isNotEmpty) {
      final canonicalItems = canonicalEntries
          .map(
            (entry) => _canonicalActivityToRecentActivity(
              entry: entry,
              storyById: {for (final story in allStories) story.id: story},
              duaById: {for (final lesson in duaLessons) lesson.id: lesson},
              arabicById: {for (final letter in arabicLetters) letter.id: letter},
              seerahRepository: seerahRepository,
            ),
          )
          .whereType<KidsParentRecentActivityItem>()
          .toList(growable: false);
      if (canonicalItems.isNotEmpty) {
        return canonicalItems;
      }
    }
    final storyById = {
      for (final story in allStories) story.id: story,
    };
    final duaById = {
      for (final lesson in duaLessons) lesson.id: lesson,
    };
    final arabicById = {
      for (final letter in arabicLetters) letter.id: letter,
    };
    final items = <KidsParentRecentActivityItem>[];
    final entries = progressionState.entriesBySourceRef.values.toList(growable: false)
      ..sort((a, b) => b.occurredAtIso.compareTo(a.occurredAtIso));

    for (final entry in entries) {
      final item = _progressionEntryToRecentActivity(
        entry: entry,
        storyById: storyById,
        duaById: duaById,
        arabicById: arabicById,
        seerahRepository: seerahRepository,
      );
      if (item != null) {
        items.add(item);
      }
    }
    return items.take(10).toList(growable: false);
  }

  KidsParentRecentActivityItem? _canonicalActivityToRecentActivity({
    required KidsActivityEntry entry,
    required Map<String, BedtimeStorySeed> storyById,
    required Map<String, KidsDuaLessonContent> duaById,
    required Map<String, KidsArabicLetter> arabicById,
    required KidsSeerahJourneyRepository seerahRepository,
  }) {
    switch (entry.type) {
      case KidsActivityType.storyOpened:
      case KidsActivityType.storyCompleted:
        final story = entry.contentId == null ? null : storyById[entry.contentId!];
        return KidsParentRecentActivityItem(
          id: entry.id,
          title: entry.titleSnapshot ?? story?.shortTitle ?? '',
          subtitle: entry.subtitleSnapshot ?? story?.lesson ?? '',
          type: KidsParentRecentActivityType.story,
          occurredAtIso: entry.occurredAtIso,
        );
      case KidsActivityType.quizCompleted:
        final story = entry.contentId == null ? null : storyById[entry.contentId!];
        return KidsParentRecentActivityItem(
          id: entry.id,
          title: entry.titleSnapshot ?? story?.shortTitle ?? '',
          subtitle: entry.subtitleSnapshot ?? story?.lesson ?? '',
          type: KidsParentRecentActivityType.quiz,
          occurredAtIso: entry.occurredAtIso,
        );
      case KidsActivityType.memoryCompleted:
        final story = entry.contentId == null ? null : storyById[entry.contentId!];
        return KidsParentRecentActivityItem(
          id: entry.id,
          title: entry.titleSnapshot ?? story?.shortTitle ?? '',
          subtitle: entry.subtitleSnapshot ?? story?.lesson ?? '',
          type: KidsParentRecentActivityType.memory,
          occurredAtIso: entry.occurredAtIso,
        );
      case KidsActivityType.duaLessonOpened:
      case KidsActivityType.duaLessonCompleted:
        final lesson = entry.contentId == null ? null : duaById[entry.contentId!];
        return KidsParentRecentActivityItem(
          id: entry.id,
          title: entry.titleSnapshot ?? lesson?.title ?? '',
          subtitle: entry.subtitleSnapshot ?? lesson?.miniLesson ?? '',
          type: KidsParentRecentActivityType.duaLesson,
          occurredAtIso: entry.occurredAtIso,
        );
      case KidsActivityType.duaPracticeCompleted:
        final lesson = entry.contentId == null ? null : duaById[entry.contentId!];
        return KidsParentRecentActivityItem(
          id: entry.id,
          title: entry.titleSnapshot ?? lesson?.title ?? '',
          subtitle: entry.subtitleSnapshot ?? lesson?.miniLesson ?? '',
          type: KidsParentRecentActivityType.duaPractice,
          occurredAtIso: entry.occurredAtIso,
        );
      case KidsActivityType.duaMyDayCompleted:
        final lesson = entry.contentId == null ? null : duaById[entry.contentId!];
        return KidsParentRecentActivityItem(
          id: entry.id,
          title: entry.titleSnapshot ?? lesson?.title ?? '',
          subtitle: entry.subtitleSnapshot ?? lesson?.miniLesson ?? '',
          type: KidsParentRecentActivityType.duaMyDay,
          occurredAtIso: entry.occurredAtIso,
        );
      case KidsActivityType.arabicLetterCompleted:
      case KidsActivityType.arabicReviewCompleted:
      case KidsActivityType.arabicDailyMissionCompleted:
        final letter = entry.contentId == null ? null : arabicById[entry.contentId!];
        return KidsParentRecentActivityItem(
          id: entry.id,
          title: entry.titleSnapshot ?? letter?.nameEn ?? '',
          subtitle: entry.subtitleSnapshot ?? letter?.childFriendlyLine ?? '',
          type: entry.type == KidsActivityType.arabicDailyMissionCompleted
              ? KidsParentRecentActivityType.arabicDailyMission
              : KidsParentRecentActivityType.arabicLesson,
          occurredAtIso: entry.occurredAtIso,
        );
      case KidsActivityType.seerahJourneyOpened:
      case KidsActivityType.seerahNodeOpened:
      case KidsActivityType.seerahNodeCompleted:
        final node = entry.contentId == null ? null : seerahRepository.nodeById(entry.contentId!);
        return KidsParentRecentActivityItem(
          id: entry.id,
          title: entry.titleSnapshot ?? node?.title ?? '',
          subtitle: entry.subtitleSnapshot ?? node?.description ?? '',
          type: KidsParentRecentActivityType.seerahNode,
          occurredAtIso: entry.occurredAtIso,
        );
      case KidsActivityType.seerahStageCompleted:
        final stage = entry.contentId == null ? null : seerahRepository.stageById(entry.contentId!);
        return KidsParentRecentActivityItem(
          id: entry.id,
          title: entry.titleSnapshot ?? stage?.title ?? '',
          subtitle: entry.subtitleSnapshot ?? stage?.description ?? '',
          type: KidsParentRecentActivityType.seerahStage,
          occurredAtIso: entry.occurredAtIso,
        );
      case KidsActivityType.seerahJourneyCompleted:
        final journey = entry.contentId == null ? null : seerahRepository.journeyById(entry.contentId!);
        return KidsParentRecentActivityItem(
          id: entry.id,
          title: entry.titleSnapshot ?? journey?.title ?? '',
          subtitle: entry.subtitleSnapshot ?? journey?.description ?? '',
          type: KidsParentRecentActivityType.seerahJourney,
          occurredAtIso: entry.occurredAtIso,
        );
      case KidsActivityType.bedtimeRoutineCompleted:
        return KidsParentRecentActivityItem(
          id: entry.id,
          title: entry.titleSnapshot ?? '',
          subtitle: entry.subtitleSnapshot ?? '',
          type: KidsParentRecentActivityType.bedtimeRoutine,
          occurredAtIso: entry.occurredAtIso,
        );
    }
  }

  KidsParentRecentActivityItem? _progressionEntryToRecentActivity({
    required LearnerProgressionEntry entry,
    required Map<String, BedtimeStorySeed> storyById,
    required Map<String, KidsDuaLessonContent> duaById,
    required Map<String, KidsArabicLetter> arabicById,
    required KidsSeerahJourneyRepository seerahRepository,
  }) {
    switch (entry.activityType) {
      case LearnerProgressionActivityType.bedtimeStoryCompletion:
        final storyId = entry.metadata['storyId']?.toString();
        final story = storyId == null ? null : storyById[storyId];
        if (story == null) {
          return null;
        }
        return KidsParentRecentActivityItem(
          id: entry.sourceRef,
          title: story.shortTitle,
          subtitle: story.lesson,
          type: KidsParentRecentActivityType.story,
          occurredAtIso: entry.occurredAtIso,
        );
      case LearnerProgressionActivityType.bedtimeQuizCompletion:
        final storyId = entry.metadata['storyId']?.toString();
        final story = storyId == null ? null : storyById[storyId];
        return KidsParentRecentActivityItem(
          id: entry.sourceRef,
          title: story?.shortTitle ?? '',
          subtitle: story?.lesson ?? '',
          type: KidsParentRecentActivityType.quiz,
          occurredAtIso: entry.occurredAtIso,
        );
      case LearnerProgressionActivityType.bedtimeMemoryCompletion:
        final storyId = entry.metadata['storyId']?.toString();
        final story = storyId == null ? null : storyById[storyId];
        return KidsParentRecentActivityItem(
          id: entry.sourceRef,
          title: story?.shortTitle ?? '',
          subtitle: story?.lesson ?? '',
          type: KidsParentRecentActivityType.memory,
          occurredAtIso: entry.occurredAtIso,
        );
      case LearnerProgressionActivityType.duaLessonCompletion:
        final lessonId = entry.metadata['lessonId']?.toString() ??
            entry.sourceRef.split(':').elementAtOrNull(1);
        final lesson = lessonId == null ? null : duaById[lessonId];
        return KidsParentRecentActivityItem(
          id: entry.sourceRef,
          title: lesson?.title ?? '',
          subtitle: lesson?.miniLesson ?? '',
          type: KidsParentRecentActivityType.duaLesson,
          occurredAtIso: entry.occurredAtIso,
        );
      case LearnerProgressionActivityType.duaPracticeCompletion:
        return KidsParentRecentActivityItem(
          id: entry.sourceRef,
          title: '',
          subtitle: '',
          type: KidsParentRecentActivityType.duaPractice,
          occurredAtIso: entry.occurredAtIso,
        );
      case LearnerProgressionActivityType.duaMyDayCompletion:
        return KidsParentRecentActivityItem(
          id: entry.sourceRef,
          title: '',
          subtitle: '',
          type: KidsParentRecentActivityType.duaMyDay,
          occurredAtIso: entry.occurredAtIso,
        );
      case LearnerProgressionActivityType.kidsArabicLessonCompletion:
        final letterId = entry.sourceRef.split(':').elementAtOrNull(1);
        final letter = letterId == null ? null : arabicById[letterId];
        return KidsParentRecentActivityItem(
          id: entry.sourceRef,
          title: letter?.nameEn ?? '',
          subtitle: letter?.childFriendlyLine ?? '',
          type: KidsParentRecentActivityType.arabicLesson,
          occurredAtIso: entry.occurredAtIso,
        );
      case LearnerProgressionActivityType.kidsArabicDailyMissionCompletion:
        return KidsParentRecentActivityItem(
          id: entry.sourceRef,
          title: '',
          subtitle: '',
          type: KidsParentRecentActivityType.arabicDailyMission,
          occurredAtIso: entry.occurredAtIso,
        );
      case LearnerProgressionActivityType.bedtimeRoutineCompletion:
        return KidsParentRecentActivityItem(
          id: entry.sourceRef,
          title: '',
          subtitle: '',
          type: KidsParentRecentActivityType.bedtimeRoutine,
          occurredAtIso: entry.occurredAtIso,
        );
      case LearnerProgressionActivityType.seerahNodeCompletion:
        final nodeId = entry.metadata['nodeId']?.toString();
        final node = nodeId == null ? null : seerahRepository.nodeById(nodeId);
        return KidsParentRecentActivityItem(
          id: entry.sourceRef,
          title: node?.title ?? '',
          subtitle: node?.description ?? '',
          type: KidsParentRecentActivityType.seerahNode,
          occurredAtIso: entry.occurredAtIso,
        );
      case LearnerProgressionActivityType.seerahStageCompletion:
        final stageId = entry.metadata['stageId']?.toString();
        final stage = stageId == null ? null : seerahRepository.stageById(stageId);
        return KidsParentRecentActivityItem(
          id: entry.sourceRef,
          title: stage?.title ?? '',
          subtitle: stage?.description ?? '',
          type: KidsParentRecentActivityType.seerahStage,
          occurredAtIso: entry.occurredAtIso,
        );
      case LearnerProgressionActivityType.seerahJourneyCompletion:
        final journeyId = entry.metadata['journeyId']?.toString();
        final journey = journeyId == null ? null : seerahRepository.journeyById(journeyId);
        return KidsParentRecentActivityItem(
          id: entry.sourceRef,
          title: journey?.title ?? '',
          subtitle: journey?.description ?? '',
          type: KidsParentRecentActivityType.seerahJourney,
          occurredAtIso: entry.occurredAtIso,
        );
    }
  }

  String? _latestDuaActivityIso(List<KidsDuaActivityLogEntry> activityLog) {
    if (activityLog.isEmpty) {
      return null;
    }
    final ordered = [...activityLog]
      ..sort((a, b) => b.timestampIso.compareTo(a.timestampIso));
    return ordered.first.timestampIso;
  }

  String? _latestProgressionIsoForModules(
    LearnerProgressionState state,
    Set<String> sourceModules,
  ) {
    final entries = state.entriesBySourceRef.values
        .where((item) => sourceModules.contains(item.sourceModule))
        .toList(growable: false)
      ..sort((a, b) => b.occurredAtIso.compareTo(a.occurredAtIso));
    return entries.isEmpty ? null : entries.first.occurredAtIso;
  }

  List<String> _activityDateKeys({
    required List<BedtimeStorySeed> stories,
    required BedtimeStoryLibraryProgress storyProgress,
    required BedtimeStoryLearningProgressState learningState,
  }) {
    final keys = <String>{};
    for (final story in stories) {
      final progress = storyProgress.storyProgressById[story.id];
      for (final iso in <String?>[
        progress?.startedAtIso,
        progress?.lastPlayedAtIso,
        progress?.completedAtIso,
      ]) {
        final key = _dayKeyForIso(iso);
        if (key != null) {
          keys.add(key);
        }
      }
    }
    for (final progress in learningState.progressByActivityId.values) {
      for (final iso in <String?>[
        progress.startedAtIso,
        progress.firstCompletedAtIso,
      ]) {
        final key = _dayKeyForIso(iso);
        if (key != null) {
          keys.add(key);
        }
      }
    }
    return keys.toList(growable: false)..sort();
  }

  String? _latestActivityIso({
    required List<BedtimeStorySeed> stories,
    required BedtimeStoryLibraryProgress storyProgress,
    required BedtimeStoryLearningProgressState learningState,
  }) {
    final dates = <String>[];
    for (final story in stories) {
      final progress = storyProgress.storyProgressById[story.id];
      for (final iso in <String?>[
        progress?.completedAtIso,
        progress?.lastPlayedAtIso,
        progress?.startedAtIso,
      ]) {
        if ((iso ?? '').isNotEmpty) {
          dates.add(iso!);
        }
      }
    }
    for (final progress in learningState.progressByActivityId.values) {
      for (final iso in <String?>[
        progress.firstCompletedAtIso,
        progress.lastAccessedAtIso,
        progress.startedAtIso,
      ]) {
        if ((iso ?? '').isNotEmpty) {
          dates.add(iso!);
        }
      }
    }
    if (dates.isEmpty) {
      return null;
    }
    dates.sort();
    return dates.last;
  }

  String? _dayKeyForIso(String? iso) {
    if (iso == null || iso.isEmpty) {
      return null;
    }
    final date = DateTime.tryParse(iso);
    if (date == null) {
      return null;
    }
    return LocalStore.todayKey(date);
  }

  int _currentStreak(List<String> activeDayKeys) {
    if (activeDayKeys.isEmpty) {
      return 0;
    }
    final dates = activeDayKeys.map(_fromDayKey).whereType<DateTime>().toList()
      ..sort();
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);
    final normalizedLast = DateTime(
      dates.last.year,
      dates.last.month,
      dates.last.day,
    );
    final daysSinceLast = normalizedToday.difference(normalizedLast).inDays;
    if (daysSinceLast > 1) {
      return 0;
    }
    var streak = 1;
    for (var i = dates.length - 1; i > 0; i -= 1) {
      final diff = dates[i].difference(dates[i - 1]).inDays;
      if (diff == 1) {
        streak += 1;
      } else if (diff > 1) {
        break;
      }
    }
    return streak;
  }

  int _longestStreak(List<String> activeDayKeys) {
    if (activeDayKeys.isEmpty) {
      return 0;
    }
    final dates = activeDayKeys.map(_fromDayKey).whereType<DateTime>().toList()
      ..sort();
    var best = 1;
    var current = 1;
    for (var i = 1; i < dates.length; i += 1) {
      final diff = dates[i].difference(dates[i - 1]).inDays;
      if (diff == 1) {
        current += 1;
        if (current > best) {
          best = current;
        }
      } else if (diff > 1) {
        current = 1;
      }
    }
    return best;
  }

  int _activeDaysSince(List<String> activeDayKeys, Duration window) {
    final cutoff = DateTime.now().subtract(window);
    return activeDayKeys
        .map(_fromDayKey)
        .whereType<DateTime>()
        .where((date) => !date.isBefore(DateTime(cutoff.year, cutoff.month, cutoff.day)))
        .length;
  }

  double _averageSessionsPerWeek({
    required int storyCount,
    required int learningCount,
    required List<String> activeDates,
  }) {
    if (activeDates.isEmpty) {
      return 0;
    }
    final dates = activeDates.map(_fromDayKey).whereType<DateTime>().toList()..sort();
    final first = dates.first;
    final last = dates.last;
    final weeks = ((last.difference(first).inDays + 1) / 7).clamp(1, 1000);
    return (storyCount + learningCount) / weeks;
  }

  DateTime? _fromDayKey(String key) {
    final parts = key.split('-');
    if (parts.length != 3) {
      return null;
    }
    return DateTime.tryParse('${parts[0]}-${parts[1]}-${parts[2]}');
  }
}
