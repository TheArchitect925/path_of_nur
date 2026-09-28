import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/locale_provider.dart';
import '../../../../features/journey/xp/application/journey_xp_providers.dart';
import '../../../../features/ocean/application/ocean_drops_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/persistence/local_store.dart';
import '../../analytics/application/learn_analytics_service.dart';
import '../../analytics/domain/learn_analytics_models.dart';
import '../../enrichment/application/learn_enrichment_provider.dart';
import '../../journey/application/family_learning_provider.dart';
import '../../shared/domain/learn_system_models.dart';
import '../data/guided_learning_paths_seed.dart';
import '../domain/guided_learning_path_models.dart';

const _guidedLearningPathsStateKey = 'learn.guided_paths.state.v1';

class GuidedLearningPathsController
    extends StateNotifier<GuidedLearningPathsState> {
  GuidedLearningPathsController(
    this._store,
    this._oceanDrops,
    this._xpController,
    this._analytics,
    this._enrichment,
  ) : super(
        GuidedLearningPathsState.fromJson(
          _store.getJsonMap(_guidedLearningPathsStateKey),
        ),
      );

  final LocalStore _store;
  final OceanDropService _oceanDrops;
  final JourneyXpController _xpController;
  final LearnAnalyticsService _analytics;
  final LearnEnrichmentController _enrichment;

  void _persist() {
    _store.setJsonMap(_guidedLearningPathsStateKey, state.toJson());
  }

  GuidedLearningPathProgress progressFor(String pathId) {
    return state.progressByPathId[pathId] ??
        GuidedLearningPathProgress(
          pathId: pathId,
          startedAtIso: null,
          completedStepIds: const <String>{},
          lastActiveStepId: null,
          lastUpdatedAtIso: null,
        );
  }

  void markPathStarted(
    GuidedLearningPath path, {
    String? activeStepId,
    String sourceSurface = 'guided_path',
  }) {
    final current = progressFor(path.id);
    final now = DateTime.now().toIso8601String();
    final wasStarted = current.isStarted;
    final updated = current.copyWith(
      startedAtIso: current.startedAtIso ?? now,
      lastActiveStepId: activeStepId ?? current.lastActiveStepId,
      lastUpdatedAtIso: now,
    );
    final next = Map<String, GuidedLearningPathProgress>.from(
      state.progressByPathId,
    )..[path.id] = updated;
    state = state.copyWith(progressByPathId: next);
    _persist();

    _enrichment.recordPathStarted(
      path: path,
      previousProgress: current,
      occurredAt: DateTime.parse(now),
    );

    if (!wasStarted) {
      _analytics.logGuidedPathStarted(
        pathId: path.id,
        sourceSurface: sourceSurface,
        audience: _audienceFor(path.audience),
      );
    } else {
      _analytics.logGuidedPathResumed(
        pathId: path.id,
        sourceSurface: sourceSurface,
        stepId: activeStepId,
      );
    }
  }

  void markStepOpened(
    GuidedLearningPath path,
    GuidedLearningPathStep step, {
    String sourceSurface = 'guided_path',
  }) {
    markPathStarted(path, activeStepId: step.id, sourceSurface: sourceSurface);
    _analytics.logGuidedPathStepOpened(
      pathId: path.id,
      stepId: step.id,
      sourceSurface: sourceSurface,
    );
  }

  void markStepCompleted(
    GuidedLearningPath path,
    GuidedLearningPathStep step, {
    String sourceSurface = 'guided_path',
  }) {
    final current = progressFor(path.id);
    if (current.completedStepIds.contains(step.id)) {
      markPathStarted(
        path,
        activeStepId: step.id,
        sourceSurface: sourceSurface,
      );
      return;
    }

    final now = DateTime.now();
    final completed = Set<String>.from(current.completedStepIds)..add(step.id);
    final allComplete = completed.length >= path.steps.length;
    final nextStep = _firstIncompleteStep(path, completed);
    final updated = current.copyWith(
      startedAtIso: current.startedAtIso ?? now.toIso8601String(),
      completedStepIds: completed,
      lastActiveStepId: nextStep?.id ?? step.id,
      lastUpdatedAtIso: now.toIso8601String(),
      completedAtIso: allComplete ? now.toIso8601String() : null,
      clearCompletedAtIso: !allComplete,
    );
    final next = Map<String, GuidedLearningPathProgress>.from(
      state.progressByPathId,
    )..[path.id] = updated;
    state = state.copyWith(progressByPathId: next);
    _persist();

    _enrichment.recordStepCompleted(
      path: path,
      previousProgress: current,
      occurredAt: now,
    );

    _analytics.logGuidedPathStepCompleted(
      pathId: path.id,
      stepId: step.id,
      sourceSurface: sourceSurface,
    );

    if (step.reward.learningXp > 0) {
      _xpController.awardLearningXp(
        sourceRef: 'guided_path_step:${path.id}:${step.id}',
        occurredAt: now,
        xp: step.reward.learningXp,
        metadata: <String, Object?>{'pathId': path.id, 'stepId': step.id},
      );
    }
    if (step.reward.oceanActionType != null &&
        step.reward.oceanSourceModule != null) {
      _oceanDrops.awardDrop(
        actionType: step.reward.oceanActionType!,
        sourceModule: step.reward.oceanSourceModule!,
        referenceId: 'guided_path_step:${path.id}:${step.id}',
        metadata: <String, dynamic>{'pathId': path.id, 'stepId': step.id},
      );
    }
    if (allComplete) {
      _enrichment.recordPathCompleted(path: path, occurredAt: now);
      _analytics.logGuidedPathCompleted(
        pathId: path.id,
        sourceSurface: sourceSurface,
      );
      _oceanDrops.awardDrop(
        actionType: oceanActionLearningJourneyCompleted,
        sourceModule: oceanSourceLearn,
        referenceId: 'guided_path_complete:${path.id}',
        metadata: <String, dynamic>{'pathId': path.id},
      );
      _xpController.awardLearningXp(
        sourceRef: 'guided_path_complete:${path.id}',
        occurredAt: now,
        xp: 12,
        metadata: <String, Object?>{'pathId': path.id, 'scope': 'completion'},
      );
    }
  }

  LearnAnalyticsAudience _audienceFor(GuidedLearningPathAudience audience) {
    return switch (audience) {
      GuidedLearningPathAudience.general => LearnAnalyticsAudience.general,
      GuidedLearningPathAudience.kids => LearnAnalyticsAudience.kids,
    };
  }

  GuidedLearningPathStep? _firstIncompleteStep(
    GuidedLearningPath path,
    Set<String> completed,
  ) {
    for (final step in path.steps) {
      if (!completed.contains(step.id)) return step;
    }
    return null;
  }
}

final guidedLearningPathsProvider = Provider<List<GuidedLearningPath>>((ref) {
  return kGuidedLearningPaths;
});

final guidedLearningPathsControllerProvider =
    StateNotifierProvider<
      GuidedLearningPathsController,
      GuidedLearningPathsState
    >((ref) {
      return GuidedLearningPathsController(
        ref.watch(localStoreProvider),
        ref.watch(oceanDropServiceProvider),
        ref.watch(journeyXpSummaryProvider.notifier),
        ref.watch(learnAnalyticsServiceProvider),
        ref.watch(learnEnrichmentControllerProvider.notifier),
      );
    });

final guidedLearningPathByIdProvider =
    Provider.family<GuidedLearningPath?, String>((ref, pathId) {
      for (final path in ref.watch(guidedLearningPathsProvider)) {
        if (path.id == pathId) return path;
      }
      return null;
    });

final guidedLearningPathProgressProvider =
    Provider.family<GuidedLearningPathProgress, String>((ref, pathId) {
      final state = ref.watch(guidedLearningPathsControllerProvider);
      return state.progressByPathId[pathId] ??
          GuidedLearningPathProgress(
            pathId: pathId,
            startedAtIso: null,
            completedStepIds: const <String>{},
            lastActiveStepId: null,
            lastUpdatedAtIso: null,
          );
    });

final guidedLearningPathResumeProvider =
    Provider<GuidedLearningPathResumeSummary>((ref) {
      final paths = ref.watch(guidedLearningPathsProvider);
      final progressState = ref.watch(guidedLearningPathsControllerProvider);
      final visibilityPolicy = ref.watch(
        activeFamilyLearningContextProvider.select(
          (value) => value.visibilityPolicy,
        ),
      );

      GuidedLearningPath? activePath;
      GuidedLearningPathProgress? activeProgress;
      for (final path in paths) {
        if (visibilityPolicy.isChildProfile &&
            path.audience != GuidedLearningPathAudience.kids) {
          continue;
        }
        final progress = progressState.progressByPathId[path.id];
        if (progress == null || !progress.isStarted || progress.isCompleted) {
          continue;
        }
        if (activeProgress == null ||
            (progress.lastUpdatedAtIso ?? '').compareTo(
                  activeProgress.lastUpdatedAtIso ?? '',
                ) >
                0) {
          activePath = path;
          activeProgress = progress;
        }
      }

      if (activePath == null || activeProgress == null) {
        return const GuidedLearningPathResumeSummary(
          activePath: null,
          nextStep: null,
        );
      }

      GuidedLearningPathStep? nextStep;
      if (activeProgress.lastActiveStepId != null) {
        for (final step in activePath.steps) {
          if (step.id == activeProgress.lastActiveStepId &&
              !activeProgress.completedStepIds.contains(step.id)) {
            nextStep = step;
            break;
          }
        }
      }
      nextStep ??= _firstIncompleteStepForProgress(activePath, activeProgress);
      return GuidedLearningPathResumeSummary(
        activePath: activePath,
        nextStep: nextStep,
      );
    });

GuidedLearningPathStep? _firstIncompleteStepForProgress(
  GuidedLearningPath path,
  GuidedLearningPathProgress progress,
) {
  for (final step in path.steps) {
    if (!progress.completedStepIds.contains(step.id)) return step;
  }
  return null;
}

final localizedGuidedLearningPathsProvider =
    Provider<List<LocalizedGuidedLearningPath>>((ref) {
      final locale = ref.watch(appLocaleProvider) ?? defaultAppLocale;
      final l10n = lookupAppLocalizations(locale);
      return ref
          .watch(guidedLearningPathsProvider)
          .map(
            (path) => LocalizedGuidedLearningPath(
              path: path,
              title: localizedGuidedLearningPathTitle(l10n, path.id),
              subtitle: localizedGuidedLearningPathSubtitle(l10n, path.id),
              description: localizedGuidedLearningPathDescription(
                l10n,
                path.id,
              ),
              steps: path.steps
                  .map(
                    (step) => LocalizedGuidedLearningPathStep(
                      step: step,
                      title: localizedGuidedLearningPathStepTitle(
                        l10n,
                        path.id,
                        step.id,
                      ),
                      subtitle: localizedGuidedLearningPathStepSubtitle(
                        l10n,
                        path.id,
                        step.id,
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          )
          .toList(growable: false);
    });

final localizedGuidedLearningPathByIdProvider =
    Provider.family<LocalizedGuidedLearningPath?, String>((ref, pathId) {
      for (final path in ref.watch(localizedGuidedLearningPathsProvider)) {
        if (path.path.id == pathId) return path;
      }
      return null;
    });

final guidedLearningPathContinueItemProvider =
    Provider<LearnUnifiedContentItem?>((ref) {
      final localizedPaths = ref.watch(localizedGuidedLearningPathsProvider);
      final resume = ref.watch(guidedLearningPathResumeProvider);
      if (!resume.hasActivePath) return null;
      final localizedPath = localizedPaths.firstWhere(
        (item) => item.path.id == resume.activePath!.id,
      );
      final localizedStep = localizedPath.steps.firstWhere(
        (item) => item.step.id == resume.nextStep!.id,
      );
      return LearnUnifiedContentItem(
        id: 'guided-path:${localizedPath.path.id}:${localizedStep.step.id}',
        type: LearnItemType.pathStep,
        domain: switch (localizedPath.path.bucketId) {
          'quran' => LearnUnifiedDomain.quran,
          'worship' => LearnUnifiedDomain.salah,
          'character' => LearnUnifiedDomain.lifeLessons,
          'kids' => LearnUnifiedDomain.prophets,
          _ => LearnUnifiedDomain.hadith,
        },
        title: localizedPath.title,
        subtitle: localizedStep.title,
        summary: localizedStep.subtitle,
        tags: localizedPath.path.tags,
        themeIds: localizedPath.path.tags,
        difficulty: LearnDifficulty.beginner,
        estimatedReadMinutes: localizedStep.step.estimatedMinutes,
        relatedItemIds: const <String>[],
        reflectionPrompts: const <String>[],
        practiceActions: const <String>[],
        isFeatured: true,
        isDailyEligible: false,
        routeName: 'learnGuidedPathDetail',
        pathParameters: <String, String>{'pathId': localizedPath.path.id},
      );
    });

class LocalizedGuidedLearningPath {
  const LocalizedGuidedLearningPath({
    required this.path,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.steps,
  });

  final GuidedLearningPath path;
  final String title;
  final String subtitle;
  final String description;
  final List<LocalizedGuidedLearningPathStep> steps;
}

class LocalizedGuidedLearningPathStep {
  const LocalizedGuidedLearningPathStep({
    required this.step,
    required this.title,
    required this.subtitle,
  });

  final GuidedLearningPathStep step;
  final String title;
  final String subtitle;
}

String localizedGuidedLearningPathTitle(AppLocalizations l10n, String pathId) {
  return switch (pathId) {
    'foundations-starter' => l10n.guidedPathFoundationsTitle,
    'salah-starter' => l10n.guidedPathSalahTitle,
    'quran-beginner-starter' => l10n.guidedPathQuranBeginnerTitle,
    'daily-dhikr-starter' => l10n.guidedPathDailyDhikrTitle,
    'character-starter' => l10n.guidedPathCharacterTitle,
    'stories-starter' => l10n.guidedPathStoriesTitle,
    'kids-starter' => l10n.guidedPathKidsStarterTitle,
    _ => l10n.guidedLearningPathsTitle,
  };
}

String localizedGuidedLearningPathSubtitle(
  AppLocalizations l10n,
  String pathId,
) {
  return switch (pathId) {
    'foundations-starter' => l10n.guidedPathFoundationsSubtitle,
    'salah-starter' => l10n.guidedPathSalahSubtitle,
    'quran-beginner-starter' => l10n.guidedPathQuranBeginnerSubtitle,
    'daily-dhikr-starter' => l10n.guidedPathDailyDhikrSubtitle,
    'character-starter' => l10n.guidedPathCharacterSubtitle,
    'stories-starter' => l10n.guidedPathStoriesSubtitle,
    'kids-starter' => l10n.guidedPathKidsStarterSubtitle,
    _ => l10n.guidedLearningPathsSectionSubtitle,
  };
}

String localizedGuidedLearningPathDescription(
  AppLocalizations l10n,
  String pathId,
) {
  return switch (pathId) {
    'foundations-starter' => l10n.guidedPathFoundationsDescription,
    'salah-starter' => l10n.guidedPathSalahDescription,
    'quran-beginner-starter' => l10n.guidedPathQuranBeginnerDescription,
    'daily-dhikr-starter' => l10n.guidedPathDailyDhikrDescription,
    'character-starter' => l10n.guidedPathCharacterDescription,
    'stories-starter' => l10n.guidedPathStoriesDescription,
    'kids-starter' => l10n.guidedPathKidsStarterDescription,
    _ => l10n.guidedLearningPathsSectionSubtitle,
  };
}

String localizedGuidedLearningPathStepTitle(
  AppLocalizations l10n,
  String pathId,
  String stepId,
) {
  return switch ('$pathId/$stepId') {
    'foundations-starter/foundations-overview' =>
      l10n.guidedPathFoundationsStepOverviewTitle,
    'foundations-starter/foundations-daily-duas' =>
      l10n.guidedPathFoundationsStepDuasTitle,
    'foundations-starter/foundations-salah-basics' =>
      l10n.guidedPathFoundationsStepSalahTitle,
    'foundations-starter/foundations-hadith-essentials' =>
      l10n.guidedPathFoundationsStepHadithTitle,
    'salah-starter/salah-learn-hub' => l10n.guidedPathSalahStepHubTitle,
    'salah-starter/salah-wudu-guide' => l10n.guidedPathSalahStepWuduGuideTitle,
    'salah-starter/salah-wudu-trainer' =>
      l10n.guidedPathSalahStepWuduTrainerTitle,
    'salah-starter/salah-guided-prayer' =>
      l10n.guidedPathSalahStepGuidedPrayerTitle,
    'quran-beginner-starter/quran-beginner-summary' =>
      l10n.guidedPathQuranStepSummaryTitle,
    'quran-beginner-starter/quran-beginner-daily' =>
      l10n.guidedPathQuranStepDailyTitle,
    'quran-beginner-starter/quran-beginner-reader' =>
      l10n.guidedPathQuranStepReaderTitle,
    'quran-beginner-starter/quran-beginner-pathways' =>
      l10n.guidedPathQuranStepPathsTitle,
    'daily-dhikr-starter/dhikr-intro-dua-hub' =>
      l10n.guidedPathDhikrStepIntroTitle,
    'daily-dhikr-starter/dhikr-counter' => l10n.guidedPathDhikrStepCounterTitle,
    'daily-dhikr-starter/dhikr-after-salah' =>
      l10n.guidedPathDhikrStepAfterSalahTitle,
    'daily-dhikr-starter/dhikr-routine' => l10n.guidedPathDhikrStepRoutineTitle,
    'character-starter/character-companion' =>
      l10n.guidedPathCharacterStepCompanionTitle,
    'character-starter/character-life-lessons' =>
      l10n.guidedPathCharacterStepLessonsTitle,
    'character-starter/character-quran-reflection' =>
      l10n.guidedPathCharacterStepQuranTitle,
    'character-starter/character-guided-journey' =>
      l10n.guidedPathCharacterStepJourneyTitle,
    'stories-starter/stories-intro' => l10n.guidedPathStoriesStepIntroTitle,
    'stories-starter/stories-prophets-entry' =>
      l10n.guidedPathStoriesStepProphetsEntryTitle,
    'stories-starter/stories-prophets-journey' =>
      l10n.guidedPathStoriesStepProphetsJourneyTitle,
    'stories-starter/stories-seerah-intro' =>
      l10n.guidedPathStoriesStepSeerahIntroTitle,
    'stories-starter/stories-seerah-key-moment' =>
      l10n.guidedPathStoriesStepSeerahMomentTitle,
    'stories-starter/stories-reflection' =>
      l10n.guidedPathStoriesStepReflectionTitle,
    'stories-starter/stories-next-steps' => l10n.guidedPathStoriesStepNextTitle,
    'kids-starter/kids-quran' => l10n.guidedPathKidsStepQuranTitle,
    'kids-starter/kids-arabic' => l10n.guidedPathKidsStepArabicTitle,
    'kids-starter/kids-stories' => l10n.guidedPathKidsStepStoriesTitle,
    'kids-starter/kids-games' => l10n.guidedPathKidsStepGamesTitle,
    _ => l10n.guidedLearningPathStepOpenAction,
  };
}

String localizedGuidedLearningPathStepSubtitle(
  AppLocalizations l10n,
  String pathId,
  String stepId,
) {
  return switch ('$pathId/$stepId') {
    'foundations-starter/foundations-overview' =>
      l10n.guidedPathFoundationsStepOverviewSubtitle,
    'foundations-starter/foundations-daily-duas' =>
      l10n.guidedPathFoundationsStepDuasSubtitle,
    'foundations-starter/foundations-salah-basics' =>
      l10n.guidedPathFoundationsStepSalahSubtitle,
    'foundations-starter/foundations-hadith-essentials' =>
      l10n.guidedPathFoundationsStepHadithSubtitle,
    'salah-starter/salah-learn-hub' => l10n.guidedPathSalahStepHubSubtitle,
    'salah-starter/salah-wudu-guide' =>
      l10n.guidedPathSalahStepWuduGuideSubtitle,
    'salah-starter/salah-wudu-trainer' =>
      l10n.guidedPathSalahStepWuduTrainerSubtitle,
    'salah-starter/salah-guided-prayer' =>
      l10n.guidedPathSalahStepGuidedPrayerSubtitle,
    'quran-beginner-starter/quran-beginner-summary' =>
      l10n.guidedPathQuranStepSummarySubtitle,
    'quran-beginner-starter/quran-beginner-daily' =>
      l10n.guidedPathQuranStepDailySubtitle,
    'quran-beginner-starter/quran-beginner-reader' =>
      l10n.guidedPathQuranStepReaderSubtitle,
    'quran-beginner-starter/quran-beginner-pathways' =>
      l10n.guidedPathQuranStepPathsSubtitle,
    'daily-dhikr-starter/dhikr-intro-dua-hub' =>
      l10n.guidedPathDhikrStepIntroSubtitle,
    'daily-dhikr-starter/dhikr-counter' =>
      l10n.guidedPathDhikrStepCounterSubtitle,
    'daily-dhikr-starter/dhikr-after-salah' =>
      l10n.guidedPathDhikrStepAfterSalahSubtitle,
    'daily-dhikr-starter/dhikr-routine' =>
      l10n.guidedPathDhikrStepRoutineSubtitle,
    'character-starter/character-companion' =>
      l10n.guidedPathCharacterStepCompanionSubtitle,
    'character-starter/character-life-lessons' =>
      l10n.guidedPathCharacterStepLessonsSubtitle,
    'character-starter/character-quran-reflection' =>
      l10n.guidedPathCharacterStepQuranSubtitle,
    'character-starter/character-guided-journey' =>
      l10n.guidedPathCharacterStepJourneySubtitle,
    'stories-starter/stories-intro' => l10n.guidedPathStoriesStepIntroSubtitle,
    'stories-starter/stories-prophets-entry' =>
      l10n.guidedPathStoriesStepProphetsEntrySubtitle,
    'stories-starter/stories-prophets-journey' =>
      l10n.guidedPathStoriesStepProphetsJourneySubtitle,
    'stories-starter/stories-seerah-intro' =>
      l10n.guidedPathStoriesStepSeerahIntroSubtitle,
    'stories-starter/stories-seerah-key-moment' =>
      l10n.guidedPathStoriesStepSeerahMomentSubtitle,
    'stories-starter/stories-reflection' =>
      l10n.guidedPathStoriesStepReflectionSubtitle,
    'stories-starter/stories-next-steps' =>
      l10n.guidedPathStoriesStepNextSubtitle,
    'kids-starter/kids-quran' => l10n.guidedPathKidsStepQuranSubtitle,
    'kids-starter/kids-arabic' => l10n.guidedPathKidsStepArabicSubtitle,
    'kids-starter/kids-stories' => l10n.guidedPathKidsStepStoriesSubtitle,
    'kids-starter/kids-games' => l10n.guidedPathKidsStepGamesSubtitle,
    _ => '',
  };
}
