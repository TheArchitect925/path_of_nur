import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/locale_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../profile/application/profile_settings_provider.dart';
import '../../../worship/application/dhikr_controller.dart';
import '../../guided_paths/application/guided_learning_paths_provider.dart';
import '../../guided_paths/domain/guided_learning_path_models.dart';
import '../../journey/application/family_learning_provider.dart';
import '../../quran/application/quran_learning_personalization_provider.dart';
import '../../quran/application/quran_providers.dart';
import '../../shared/application/learn_system_engine_provider.dart';
import '../../shared/domain/learn_system_models.dart';
import '../domain/learning_personalization_models.dart';
import 'learning_recommendation_engine.dart';

final learningRecommendationEngineProvider =
    Provider<LearningRecommendationEngine>((_) {
      return const LearningRecommendationEngine();
    });

final learningSignalsProvider = Provider<LearningSignals>((ref) {
  final now = DateTime.now();
  final visibilityPolicy = ref.watch(
    activeFamilyLearningContextProvider.select(
      (value) => value.visibilityPolicy,
    ),
  );
  final profileSettings = ref.watch(profileSettingsProvider);
  final guidedPaths = ref.watch(guidedLearningPathsProvider);
  final guidedPathState = ref.watch(guidedLearningPathsControllerProvider);
  final guidedPathResume = ref.watch(guidedLearningPathResumeProvider);
  final learnProgress = ref.watch(learnUnifiedProgressProvider);
  final learnItems = ref.watch(learnUnifiedItemsProvider);
  final quranRecentReadings = ref.watch(quranRecentReadingsProvider);
  final quranReadingSecondsToday = ref.watch(
    quranReadingTimeTodaySecondsProvider,
  );
  final quranPersonalization = ref.watch(
    quranLearningPersonalizationStateProvider,
  );
  final dhikrState = ref.watch(dhikrControllerProvider);

  final pathLastUpdatedAtById = <String, DateTime>{};
  final pathCompletedAtById = <String, DateTime>{};
  final startedPathIds = <String>{};
  final completedPathIds = <String>{};

  for (final path in guidedPaths) {
    final progress = guidedPathState.progressByPathId[path.id];
    if (progress == null) continue;
    if (progress.isStarted) {
      startedPathIds.add(path.id);
    }
    if (progress.isCompleted) {
      completedPathIds.add(path.id);
    }
    final updatedAt = _tryParseIso(progress.lastUpdatedAtIso);
    if (updatedAt != null) {
      pathLastUpdatedAtById[path.id] = updatedAt;
    }
    final completedAt = _tryParseIso(progress.completedAtIso);
    if (completedAt != null) {
      pathCompletedAtById[path.id] = completedAt;
    }
  }

  final itemsById = <String, LearnUnifiedContentItem>{
    for (final item in learnItems) item.id: item,
  };
  final updatedItemIds = learnProgress.lastUpdatedIsoByItemId.keys.toList()
    ..sort((a, b) {
      final aIso = learnProgress.lastUpdatedIsoByItemId[a];
      final bIso = learnProgress.lastUpdatedIsoByItemId[b];
      return (bIso ?? '').compareTo(aIso ?? '');
    });
  final recentLearnDomains = <LearnUnifiedDomain>[];
  for (final itemId in updatedItemIds) {
    final item = itemsById[itemId];
    if (item == null) continue;
    if (!recentLearnDomains.contains(item.domain)) {
      recentLearnDomains.add(item.domain);
    }
    if (recentLearnDomains.length >= 6) break;
  }

  final sevenDaysAgo = now.subtract(const Duration(days: 7));
  final quranReadingCountLast7Days = quranRecentReadings.where((reading) {
    final openedAt = _tryParseIso(reading.openedAtIso);
    return openedAt != null && !openedAt.isBefore(sevenDaysAgo);
  }).length;
  final dhikrSessionsLast7Days = dhikrState.recentSessions.where((session) {
    return !session.finishedAt.isBefore(sevenDaysAgo);
  }).length;

  var salahActivityCount = 0;
  for (final itemId in learnProgress.startedIds) {
    if (itemId.startsWith('salah:')) {
      salahActivityCount += 1;
    }
  }
  for (final itemId in learnProgress.practicedIds) {
    if (itemId.startsWith('salah:')) {
      salahActivityCount += 1;
    }
  }
  for (final itemId in learnProgress.memorizedIds) {
    if (itemId.startsWith('salah:')) {
      salahActivityCount += 1;
    }
  }

  DateTime? lastLearnActivityAt;
  void consider(DateTime? candidate) {
    if (candidate == null) return;
    if (lastLearnActivityAt == null ||
        candidate.isAfter(lastLearnActivityAt!)) {
      lastLearnActivityAt = candidate;
    }
  }

  for (final iso in learnProgress.lastUpdatedIsoByItemId.values) {
    consider(_tryParseIso(iso));
  }
  for (final date in pathLastUpdatedAtById.values) {
    consider(date);
  }
  for (final reading in quranRecentReadings.take(6)) {
    consider(_tryParseIso(reading.openedAtIso));
  }
  for (final session in dhikrState.recentSessions.take(6)) {
    consider(session.finishedAt);
  }

  return LearningSignals(
    isChildProfile: visibilityPolicy.isChildProfile,
    ramadanModeEnabled: profileSettings.ramadanModeEnabled,
    now: now,
    activePathId: guidedPathResume.activePath?.id,
    activeStepId: guidedPathResume.nextStep?.id,
    completedPathIds: completedPathIds,
    startedPathIds: startedPathIds,
    pathLastUpdatedAtById: pathLastUpdatedAtById,
    pathCompletedAtById: pathCompletedAtById,
    recentLearnDomains: recentLearnDomains,
    quranReadingCountLast7Days: quranReadingCountLast7Days,
    quranReadingSecondsToday: quranReadingSecondsToday,
    quranHasPersonalizationSignals: quranPersonalization.hasSignals,
    dhikrSessionsLast7Days: dhikrSessionsLast7Days,
    salahActivityCount: salahActivityCount,
    learnStartedCount: learnProgress.startedIds.length,
    learnCompletedCount: learnProgress.completedIds.length,
    learnSavedCount: learnProgress.savedIds.length,
    learnNotesCount: learnProgress.notesByItemId.length,
    lastLearnActivityAt: lastLearnActivityAt,
  );
});

final learningPersonalizationSummaryProvider =
    Provider<LearningPersonalizationSummary>((ref) {
      final visibilityPolicy = ref.watch(
        activeFamilyLearningContextProvider.select(
          (value) => value.visibilityPolicy,
        ),
      );
      final visiblePaths = ref
          .watch(guidedLearningPathsProvider)
          .where(
            (path) =>
                !visibilityPolicy.isChildProfile ||
                path.audience == GuidedLearningPathAudience.kids,
          )
          .toList(growable: false);
      return ref
          .watch(learningRecommendationEngineProvider)
          .build(
            signals: ref.watch(learningSignalsProvider),
            visiblePaths: visiblePaths,
          );
    });

final localizedLearningPersonalizationSummaryProvider =
    Provider<LocalizedLearningPersonalizationSummary>((ref) {
      final locale =
          ref.watch(appLocaleProvider) ??
          AppLocalizations.supportedLocales.first;
      final l10n = lookupAppLocalizations(locale);
      final summary = ref.watch(learningPersonalizationSummaryProvider);
      final localizedPaths = ref.watch(localizedGuidedLearningPathsProvider);
      final guidedPathState = ref.watch(guidedLearningPathsControllerProvider);
      final pathById = <String, LocalizedGuidedLearningPath>{
        for (final path in localizedPaths) path.path.id: path,
      };
      final primary = summary.primaryRecommendation;
      final path = primary.pathId == null ? null : pathById[primary.pathId];

      final title = switch (primary.kind) {
        LearningRecommendationKind.continueGuidedPathStep =>
          l10n.learnPersonalizationContinuePathTitle(path?.title ?? ''),
        LearningRecommendationKind.resumeGuidedPath =>
          l10n.learnPersonalizationResumePathTitle(path?.title ?? ''),
        LearningRecommendationKind.startGuidedPath =>
          l10n.learnPersonalizationStartPathTitle(path?.title ?? ''),
      };

      String subtitle;
      if (primary.kind == LearningRecommendationKind.continueGuidedPathStep &&
          path != null &&
          primary.stepId != null) {
        final localizedStep = path.steps
            .where((step) => step.step.id == primary.stepId)
            .firstOrNull;
        subtitle = localizedStep?.title ?? path.subtitle;
      } else {
        subtitle = path?.subtitle ?? '';
      }

      String? progressLabel;
      double? progressValue;
      if (primary.pathId != null && path != null) {
        final progress =
            guidedPathState.progressByPathId[primary.pathId!] ??
            GuidedLearningPathProgress(
              pathId: primary.pathId!,
              startedAtIso: null,
              completedStepIds: const <String>{},
              lastActiveStepId: null,
              lastUpdatedAtIso: null,
            );
        final completed = progress.completedStepIds.length;
        final total = path.path.steps.length;
        progressLabel = l10n.guidedLearningPathProgressValue(completed, total);
        progressValue = total == 0 ? 0 : completed / total;
      }

      final secondarySuggestions = summary.secondarySuggestions
          .map((suggestion) {
            final localizedPath = pathById[suggestion.pathId];
            if (localizedPath == null) {
              return null;
            }
            return LocalizedPathSuggestion(
              pathId: suggestion.pathId,
              title: localizedPath.title,
              subtitle: _localizedReasonText(l10n, suggestion.reason),
              routeTarget: LearningRecommendationRouteTarget(
                routeName: 'learnGuidedPathDetail',
                pathParameters: <String, String>{'pathId': suggestion.pathId},
              ),
            );
          })
          .whereType<LocalizedPathSuggestion>()
          .toList(growable: false);

      return LocalizedLearningPersonalizationSummary(
        title: title,
        subtitle: subtitle,
        reasonText: _localizedReasonText(l10n, primary.reason),
        primaryActionLabel:
            primary.kind == LearningRecommendationKind.continueGuidedPathStep
            ? l10n.learnPersonalizationContinueStepAction
            : l10n.learnPersonalizationOpenPathAction,
        primaryActionRouteTarget: primary.routeTarget,
        secondaryActionLabel:
            primary.kind == LearningRecommendationKind.continueGuidedPathStep &&
                primary.pathId != null
            ? l10n.learnPersonalizationViewPathAction
            : null,
        secondaryActionRouteTarget:
            primary.kind == LearningRecommendationKind.continueGuidedPathStep &&
                primary.pathId != null
            ? LearningRecommendationRouteTarget(
                routeName: 'learnGuidedPathDetail',
                pathParameters: <String, String>{'pathId': primary.pathId!},
              )
            : null,
        progressLabel: progressLabel,
        progressValue: progressValue,
        contextBadgeLabel: _localizedContextBadge(l10n, primary.contextTag),
        secondarySuggestionsTitle: l10n.learnPersonalizationSecondaryTitle,
        secondarySuggestions: secondarySuggestions,
      );
    });

String _localizedReasonText(
  AppLocalizations l10n,
  LearningRecommendationReason reason,
) {
  switch (reason) {
    case LearningRecommendationReason.activeGuidedPath:
      return l10n.learnPersonalizationBecauseActivePath;
    case LearningRecommendationReason.sequencedAfterCompletion:
      return l10n.learnPersonalizationBecauseSequencedAfterCompletion;
    case LearningRecommendationReason.quranMomentum:
      return l10n.learnPersonalizationBecauseQuranMomentum;
    case LearningRecommendationReason.dhikrMomentum:
      return l10n.learnPersonalizationBecauseDhikrMomentum;
    case LearningRecommendationReason.salahMomentum:
      return l10n.learnPersonalizationBecauseSalahMomentum;
    case LearningRecommendationReason.kidsProfile:
      return l10n.learnPersonalizationBecauseKidsProfile;
    case LearningRecommendationReason.noHistory:
      return l10n.learnPersonalizationBecauseNoHistory;
    case LearningRecommendationReason.inactiveReentry:
      return l10n.learnPersonalizationBecauseInactiveReentry;
    case LearningRecommendationReason.fridayRhythm:
      return l10n.learnPersonalizationBecauseFridayRhythm;
    case LearningRecommendationReason.ramadanRhythm:
      return l10n.learnPersonalizationBecauseRamadanRhythm;
    case LearningRecommendationReason.keepMomentum:
      return l10n.learnPersonalizationBecauseKeepMomentum;
    case LearningRecommendationReason.safeFallback:
      return l10n.learnPersonalizationBecauseSafeFallback;
  }
}

String? _localizedContextBadge(
  AppLocalizations l10n,
  LearningRecommendationContextTag? tag,
) {
  if (tag == null) return null;
  switch (tag) {
    case LearningRecommendationContextTag.friday:
      return l10n.learnPersonalizationFridayBadge;
    case LearningRecommendationContextTag.ramadan:
      return l10n.learnPersonalizationRamadanBadge;
    case LearningRecommendationContextTag.momentum:
      return l10n.learnPersonalizationMomentumBadge;
  }
}

DateTime? _tryParseIso(String? iso) {
  if (iso == null || iso.isEmpty) return null;
  return DateTime.tryParse(iso);
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
