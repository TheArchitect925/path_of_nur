import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/application/daily_clock_provider.dart';
import '../domain/quran_guided_learning_path_models.dart';
import '../domain/quran_hub_recommendation_models.dart';
import '../domain/quran_surah_summary_models.dart';
import '../domain/quran_theme_discovery_models.dart';
import '../domain/quran_user_intent_models.dart';
import 'quran_daily_reflection_provider.dart';
import 'quran_guided_learning_paths_provider.dart';
import 'quran_providers.dart';
import 'quran_surah_summary_provider.dart';
import 'quran_theme_discovery_provider.dart';
import 'quran_user_intent_provider.dart';

final quranHubContextSnapshotProvider = Provider<QuranHubContextSnapshot>((
  ref,
) {
  final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
  final continueSummary = ref.watch(quranContinueReadingSummaryProvider);
  final recentReadings = ref.watch(quranRecentReadingsProvider);
  final selectedIntent = ref.watch(quranSelectedUserIntentProvider);
  final continuePath = ref.watch(quranGuidedContinuePathProvider);
  final dailySummary = ref.watch(quranDailyCompanionSummaryProvider);
  final surahSummaries = ref.watch(quranSurahSummaryListProvider);

  final summaryBySurah = <int, QuranSurahSummaryEntry>{
    for (final entry in surahSummaries) entry.surahNumber: entry,
  };

  final recentThemeIds = <String>[];
  for (final reading in recentReadings.take(4)) {
    final entry = summaryBySurah[reading.surahNumber];
    final themeId = _preferredThemeIdForSurahEntry(entry);
    if (themeId != null && !recentThemeIds.contains(themeId)) {
      recentThemeIds.add(themeId);
    }
  }

  final recentPathIds = <String>[];
  if (continuePath != null) {
    recentPathIds.add(continuePath.id);
  }

  final dailyThemeId = dailySummary.themes.isEmpty
      ? null
      : dailySummary.themes.first.id;

  return QuranHubContextSnapshot(
    now: now,
    timeSegment: _timeSegmentFor(now),
    isFriday: now.weekday == DateTime.friday,
    readingStreak: ref.watch(quranReadingStreakProvider),
    readingTimeTodaySeconds: ref.watch(quranReadingTimeTodaySecondsProvider),
    listeningTimeTodaySeconds: ref.watch(
      quranListeningTimeTodaySecondsProvider,
    ),
    selectedIntentWireName: selectedIntent?.wireName,
    continueSurahNumber: continueSummary.surahNumber,
    continueAyahNumber: continueSummary.ayahNumber,
    activePathId: continuePath?.id,
    dailyThemeId: dailyThemeId,
    recentSurahNumbers: recentReadings
        .map((reading) => reading.surahNumber)
        .toSet()
        .take(4)
        .toList(growable: false),
    recentThemeIds: recentThemeIds,
    recentPathIds: recentPathIds,
  );
});

final quranHubRecommendationsProvider = Provider<List<QuranHubRecommendation>>((
  ref,
) {
  final snapshot = ref.watch(quranHubContextSnapshotProvider);
  final continueSummary = ref.watch(quranContinueReadingSummaryProvider);
  final userIntentSummary = ref.watch(quranUserIntentSummaryProvider);
  final continuePath = ref.watch(quranGuidedContinuePathProvider);
  final surahSummaries = ref.watch(quranSurahSummaryListProvider);
  final resolvedThemes = ref.watch(quranResolvedThemesProvider);
  final dailySummary = ref.watch(quranDailyCompanionSummaryProvider);

  final summaryBySurah = <int, QuranSurahSummaryEntry>{
    for (final entry in surahSummaries) entry.surahNumber: entry,
  };
  final themeById = <String, QuranThemeResolvedTopic>{
    for (final theme in resolvedThemes) theme.definition.id: theme,
  };

  final candidates = <QuranHubRecommendation>[];

  if (continuePath != null) {
    final progress = ref.watch(
      quranGuidedPathProgressByIdProvider(continuePath.id),
    );
    final completedCount = progress?.completedStopIds.length ?? 0;
    final totalStops = continuePath.steps.length;
    candidates.add(
      QuranHubRecommendation(
        id: 'resume-path:${continuePath.id}',
        type: QuranHubRecommendationType.resumePathway,
        source: QuranHubRecommendationSource.path,
        reason: QuranHubRecommendationReason.continueWhereLeftOff,
        destinationType: QuranHubRecommendationDestinationType.pathwayDetail,
        priority: 300,
        routeName: 'quranLearningPathDetail',
        pathParameters: {'pathId': continuePath.id},
        pathId: continuePath.id,
        progressCompleted: completedCount,
        progressTotal: totalStops,
        isPrimary: true,
      ),
    );
  }

  if (continueSummary.ayahNumber > 1) {
    final reason = snapshot.readingStreak >= 3
        ? QuranHubRecommendationReason.keepMomentum
        : QuranHubRecommendationReason.continueWhereLeftOff;
    candidates.add(
      QuranHubRecommendation(
        id: 'continue-surah:${continueSummary.surahNumber}:${continueSummary.ayahNumber}',
        type: QuranHubRecommendationType.continueSurah,
        source: QuranHubRecommendationSource.recent,
        reason: reason,
        destinationType: QuranHubRecommendationDestinationType.readerEntry,
        priority: snapshot.readingStreak >= 3 ? 286 : 280,
        routeName: 'quranReader',
        pathParameters: {'surahNumber': continueSummary.surahNumber.toString()},
        queryParameters: {'ayah': continueSummary.ayahNumber.toString()},
        surahNumber: continueSummary.surahNumber,
        ayahNumber: continueSummary.ayahNumber,
      ),
    );
  }

  final timeReason = switch (snapshot.timeSegment) {
    QuranHubTimeSegment.morning => QuranHubRecommendationReason.forThisMorning,
    QuranHubTimeSegment.afternoon =>
      QuranHubRecommendationReason.forThisAfternoon,
    QuranHubTimeSegment.evening => QuranHubRecommendationReason.forThisEvening,
    QuranHubTimeSegment.night => QuranHubRecommendationReason.forTonight,
  };
  candidates.add(
    QuranHubRecommendation(
      id: 'time-daily:${dailySummary.reflection.assignment.entry.id}:${snapshot.timeSegment.name}',
      type: QuranHubRecommendationType.timeOfDayPick,
      source: QuranHubRecommendationSource.time,
      reason: timeReason,
      destinationType: QuranHubRecommendationDestinationType.dailyCompanion,
      priority: 260,
      routeName: 'quranDailyCompanion',
      surahNumber: dailySummary.reflection.assignment.entry.ref.surah,
      ayahNumber: dailySummary.reflection.assignment.entry.ref.ayah,
      topicId: snapshot.dailyThemeId,
    ),
  );

  if (snapshot.isFriday) {
    candidates.add(
      const QuranHubRecommendation(
        id: 'friday-pick:18',
        type: QuranHubRecommendationType.fridayPick,
        source: QuranHubRecommendationSource.friday,
        reason: QuranHubRecommendationReason.fridayReflection,
        destinationType: QuranHubRecommendationDestinationType.surahDetail,
        priority: 255,
        routeName: 'quranSummaryDetailPage',
        pathParameters: {'surahNumber': '18'},
        surahNumber: 18,
      ),
    );
  }

  final growthPath = userIntentSummary.suggestedPath;
  if (growthPath != null && growthPath.id != continuePath?.id) {
    candidates.add(
      QuranHubRecommendation(
        id: 'growth-path:${growthPath.id}',
        type: QuranHubRecommendationType.growthFocusPick,
        source: QuranHubRecommendationSource.intent,
        reason: QuranHubRecommendationReason.basedOnGrowthFocus,
        destinationType: QuranHubRecommendationDestinationType.pathwayDetail,
        priority: 240,
        routeName: 'quranLearningPathDetail',
        pathParameters: {'pathId': growthPath.id},
        pathId: growthPath.id,
      ),
    );
  }

  final growthThemeId = _preferredThemeIdForIntent(
    userIntentSummary.selectedIntent,
  );
  if (growthThemeId != null) {
    final resolvedTheme = themeById[growthThemeId];
    if (resolvedTheme != null) {
      candidates.add(
        QuranHubRecommendation(
          id: 'growth-theme:${resolvedTheme.definition.id}',
          type: QuranHubRecommendationType.themeSuggestion,
          source: QuranHubRecommendationSource.intent,
          reason: QuranHubRecommendationReason.basedOnGrowthFocus,
          destinationType: QuranHubRecommendationDestinationType.themeDetail,
          priority: 232,
          routeName: 'quranTopicDetail',
          pathParameters: {'topicId': resolvedTheme.definition.id},
          topicId: resolvedTheme.definition.id,
        ),
      );
    }
  }

  final recentSurahEntry = _firstRecentSurahEntry(
    snapshot: snapshot,
    summaryBySurah: summaryBySurah,
  );
  if (recentSurahEntry != null) {
    final recentThemeId =
        _preferredThemeIdForSurahEntry(recentSurahEntry) ??
        snapshot.dailyThemeId;
    if (recentThemeId != null && recentThemeId != growthThemeId) {
      final relatedTheme = themeById[recentThemeId];
      if (relatedTheme != null) {
        candidates.add(
          QuranHubRecommendation(
            id: 'related-theme:${relatedTheme.definition.id}:${recentSurahEntry.surahNumber}',
            type: QuranHubRecommendationType.relatedFollowUp,
            source: QuranHubRecommendationSource.related,
            reason: QuranHubRecommendationReason.basedOnRecentReading,
            destinationType: QuranHubRecommendationDestinationType.themeDetail,
            priority: 224,
            routeName: 'quranTopicDetail',
            pathParameters: {'topicId': relatedTheme.definition.id},
            topicId: relatedTheme.definition.id,
            surahNumber: recentSurahEntry.surahNumber,
          ),
        );

        final followUpPath = _pathForTheme(
          ref: ref,
          themeId: relatedTheme.definition.id,
          excludedPathId: continuePath?.id,
        );
        if (followUpPath != null) {
          candidates.add(
            QuranHubRecommendation(
              id: 'related-path:${followUpPath.id}:${relatedTheme.definition.id}',
              type: QuranHubRecommendationType.pathwaySuggestion,
              source: QuranHubRecommendationSource.related,
              reason: QuranHubRecommendationReason.connectedToYourJourney,
              destinationType:
                  QuranHubRecommendationDestinationType.pathwayDetail,
              priority: 220,
              routeName: 'quranLearningPathDetail',
              pathParameters: {'pathId': followUpPath.id},
              pathId: followUpPath.id,
              topicId: relatedTheme.definition.id,
            ),
          );
        }
      }
    }
  }

  final evergreenPath = ref.watch(
    quranGuidedLearningPathByIdProvider('tawhid-foundations'),
  );
  if (evergreenPath != null) {
    candidates.add(
      QuranHubRecommendation(
        id: 'fallback-path:${evergreenPath.id}',
        type: QuranHubRecommendationType.pathwaySuggestion,
        source: QuranHubRecommendationSource.fallback,
        reason: snapshot.hasActivity
            ? QuranHubRecommendationReason.startHere
            : QuranHubRecommendationReason.basedOnGrowthFocus,
        destinationType: QuranHubRecommendationDestinationType.pathwayDetail,
        priority: 120,
        routeName: 'quranLearningPathDetail',
        pathParameters: {'pathId': evergreenPath.id},
        pathId: evergreenPath.id,
      ),
    );
  }

  if (themeById.containsKey('guidance')) {
    candidates.add(
      const QuranHubRecommendation(
        id: 'fallback-theme:guidance',
        type: QuranHubRecommendationType.themeSuggestion,
        source: QuranHubRecommendationSource.fallback,
        reason: QuranHubRecommendationReason.startHere,
        destinationType: QuranHubRecommendationDestinationType.themeDetail,
        priority: 118,
        routeName: 'quranTopicDetail',
        pathParameters: {'topicId': 'guidance'},
        topicId: 'guidance',
      ),
    );
  }

  candidates.add(
    const QuranHubRecommendation(
      id: 'fallback-surah:1',
      type: QuranHubRecommendationType.reflectionPrompt,
      source: QuranHubRecommendationSource.fallback,
      reason: QuranHubRecommendationReason.startHere,
      destinationType: QuranHubRecommendationDestinationType.surahDetail,
      priority: 116,
      routeName: 'quranSummaryDetailPage',
      pathParameters: {'surahNumber': '1'},
      surahNumber: 1,
    ),
  );

  final unique = <QuranHubRecommendation>[];
  final ids = <String>{};
  final routeKeys = <String>{};

  final sorted = candidates.toList(growable: false)
    ..sort((a, b) {
      final primary = (b.isPrimary ? 1 : 0).compareTo(a.isPrimary ? 1 : 0);
      if (primary != 0) return primary;
      final priority = b.priority.compareTo(a.priority);
      if (priority != 0) return priority;
      return a.id.compareTo(b.id);
    });

  for (final candidate in sorted) {
    if (!ids.add(candidate.id)) continue;
    if (!routeKeys.add(candidate.routeKey)) continue;
    unique.add(candidate);
    if (unique.length >= 4) break;
  }

  return unique;
});

final quranHubPrimaryRecommendationProvider = Provider<QuranHubRecommendation?>(
  (ref) {
    final items = ref.watch(quranHubRecommendationsProvider);
    if (items.isEmpty) return null;
    return items.first;
  },
);

final quranHubSecondaryRecommendationsProvider =
    Provider<List<QuranHubRecommendation>>((ref) {
      final items = ref.watch(quranHubRecommendationsProvider);
      if (items.length <= 1) return const <QuranHubRecommendation>[];
      return items.skip(1).toList(growable: false);
    });

final quranHubRecommendationTopicProvider =
    Provider.family<QuranThemeResolvedTopic?, String>((ref, topicId) {
      return ref.watch(quranResolvedThemeByIdProvider(topicId));
    });

QuranHubTimeSegment _timeSegmentFor(DateTime now) {
  final hour = now.hour;
  if (hour < 12) return QuranHubTimeSegment.morning;
  if (hour < 17) return QuranHubTimeSegment.afternoon;
  if (hour < 21) return QuranHubTimeSegment.evening;
  return QuranHubTimeSegment.night;
}

QuranSurahSummaryEntry? _firstRecentSurahEntry({
  required QuranHubContextSnapshot snapshot,
  required Map<int, QuranSurahSummaryEntry> summaryBySurah,
}) {
  for (final surahNumber in snapshot.recentSurahNumbers) {
    final entry = summaryBySurah[surahNumber];
    if (entry != null) return entry;
  }
  final continueSurah = snapshot.continueSurahNumber;
  if (continueSurah != null) {
    return summaryBySurah[continueSurah];
  }
  return null;
}

String? _preferredThemeIdForIntent(QuranUserIntent? intent) {
  return switch (intent) {
    QuranUserIntent.understand => 'guidance',
    QuranUserIntent.reflect => 'mercy',
    QuranUserIntent.memorize => 'dua',
    QuranUserIntent.themes => 'gratitude',
    QuranUserIntent.guidedPath => 'tawhid',
    null => null,
  };
}

String? _preferredThemeIdForSurahEntry(QuranSurahSummaryEntry? entry) {
  if (entry == null) return null;
  for (final tag in entry.themeTags) {
    final id = _themeIdForTag(tag);
    if (id != null) return id;
  }
  return null;
}

String? _themeIdForTag(QuranSurahThemeTag tag) {
  return switch (tag) {
    QuranSurahThemeTag.tawhid => 'tawhid',
    QuranSurahThemeTag.revelation => 'revelation',
    QuranSurahThemeTag.guidance => 'guidance',
    QuranSurahThemeTag.mercy => 'mercy',
    QuranSurahThemeTag.judgment => 'judgment',
    QuranSurahThemeTag.patience => 'patience',
    QuranSurahThemeTag.repentance => 'repentance',
    QuranSurahThemeTag.prophethood => 'prophets',
    QuranSurahThemeTag.resurrection => 'resurrection',
    QuranSurahThemeTag.worship => 'worship',
    QuranSurahThemeTag.law => null,
    QuranSurahThemeTag.community => null,
    QuranSurahThemeTag.gratitude => 'gratitude',
    QuranSurahThemeTag.justice => null,
    QuranSurahThemeTag.signsOfCreation => 'signs-of-creation',
    QuranSurahThemeTag.hypocrisy => null,
    QuranSurahThemeTag.charity => null,
    QuranSurahThemeTag.family => 'family',
    QuranSurahThemeTag.struggle => 'patience',
    QuranSurahThemeTag.paradiseAndHell => 'paradise-and-hell',
  };
}

QuranGuidedLearningPath? _pathForTheme({
  required Ref ref,
  required String themeId,
  String? excludedPathId,
}) {
  final paths = ref.watch(quranGuidedLearningPathsProvider);
  for (final path in paths) {
    if (path.id == excludedPathId) continue;
    if (path.themeId == themeId || path.relatedThemeIds.contains(themeId)) {
      return path;
    }
  }
  return null;
}
