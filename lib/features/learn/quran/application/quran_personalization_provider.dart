import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/application/daily_clock_provider.dart';
import '../../../../shared/persistence/local_store.dart';
import '../../../worship/application/dhikr_controller.dart';
import '../../../worship/data/prayer_log_repository.dart';
import '../../../worship/domain/prayer_name.dart';
import '../../../worship/domain/prayer_status.dart';
import '../data/quran_ayah_action_repository.dart';
import '../domain/quran_ayah_action_models.dart';
import '../domain/quran_ayah_explanation_models.dart';
import '../domain/quran_content_refs.dart';
import '../domain/quran_guided_learning_path_models.dart';
import '../domain/quran_personalization_models.dart';
import '../domain/quran_reference_models.dart';
import '../domain/quran_user_intent_models.dart';
import 'quran_ayah_action_provider.dart';
import 'quran_ayah_explanation_provider.dart';
import 'quran_daily_reflection_provider.dart';
import 'quran_guided_learning_paths_provider.dart';
import 'quran_learning_system_service.dart';
import 'quran_providers.dart';
import 'quran_reflections_provider.dart';
import 'quran_user_intent_provider.dart';

const _quranPersonalizationStateKey = 'learn.quran.personalization_engine.v1';

class QuranPersonalizationState {
  const QuranPersonalizationState({
    required this.dismissedAyahKeysByDateKey,
    required this.recentPrimaryAyahKeys,
    required this.lastPresentedBundleKeyBySurface,
  });

  static const initial = QuranPersonalizationState(
    dismissedAyahKeysByDateKey: <String, Set<String>>{},
    recentPrimaryAyahKeys: <String>[],
    lastPresentedBundleKeyBySurface: <String, String>{},
  );

  final Map<String, Set<String>> dismissedAyahKeysByDateKey;
  final List<String> recentPrimaryAyahKeys;
  final Map<String, String> lastPresentedBundleKeyBySurface;

  QuranPersonalizationState copyWith({
    Map<String, Set<String>>? dismissedAyahKeysByDateKey,
    List<String>? recentPrimaryAyahKeys,
    Map<String, String>? lastPresentedBundleKeyBySurface,
  }) {
    return QuranPersonalizationState(
      dismissedAyahKeysByDateKey:
          dismissedAyahKeysByDateKey ?? this.dismissedAyahKeysByDateKey,
      recentPrimaryAyahKeys:
          recentPrimaryAyahKeys ?? this.recentPrimaryAyahKeys,
      lastPresentedBundleKeyBySurface:
          lastPresentedBundleKeyBySurface ??
          this.lastPresentedBundleKeyBySurface,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'dismissedAyahKeysByDateKey': <String, List<String>>{
      for (final entry in dismissedAyahKeysByDateKey.entries)
        entry.key: entry.value.toList(growable: false),
    },
    'recentPrimaryAyahKeys': recentPrimaryAyahKeys,
    'lastPresentedBundleKeyBySurface': lastPresentedBundleKeyBySurface,
  };

  static QuranPersonalizationState fromJson(Map<String, dynamic>? json) {
    if (json == null) return initial;
    final dismissed = <String, Set<String>>{};
    final rawDismissed = json['dismissedAyahKeysByDateKey'];
    if (rawDismissed is Map) {
      for (final entry in rawDismissed.entries) {
        final dateKey = entry.key.toString().trim();
        if (dateKey.isEmpty) continue;
        final values = entry.value is List
            ? entry.value as List
            : const <dynamic>[];
        final ayahKeys = values
            .map((item) => item.toString().trim())
            .where((item) => item.isNotEmpty)
            .toSet();
        if (ayahKeys.isNotEmpty) {
          dismissed[dateKey] = ayahKeys;
        }
      }
    }
    final recentPrimary = (json['recentPrimaryAyahKeys'] as List? ?? const [])
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
    final lastPresented = <String, String>{};
    final rawPresented = json['lastPresentedBundleKeyBySurface'];
    if (rawPresented is Map) {
      for (final entry in rawPresented.entries) {
        final key = entry.key.toString().trim();
        final value = entry.value.toString().trim();
        if (key.isEmpty || value.isEmpty) continue;
        lastPresented[key] = value;
      }
    }
    return QuranPersonalizationState(
      dismissedAyahKeysByDateKey: dismissed,
      recentPrimaryAyahKeys: recentPrimary,
      lastPresentedBundleKeyBySurface: lastPresented,
    );
  }
}

class QuranPersonalizationController
    extends StateNotifier<QuranPersonalizationState> {
  QuranPersonalizationController(this._store)
    : super(
        QuranPersonalizationState.fromJson(
          _store.getJsonMap(_quranPersonalizationStateKey),
        ),
      );

  final LocalStore _store;

  void _persist() {
    _store.setJsonMap(_quranPersonalizationStateKey, state.toJson());
  }

  void dismissForToday({
    required QuranPersonalizationSurface surface,
    required String ayahKey,
    DateTime? now,
  }) {
    final dateKey = LocalStore.todayKey(now ?? DateTime.now());
    final nextDismissed = <String, Set<String>>{
      for (final entry in state.dismissedAyahKeysByDateKey.entries)
        entry.key: Set<String>.from(entry.value),
    };
    nextDismissed.putIfAbsent(dateKey, () => <String>{}).add(ayahKey);
    state = state.copyWith(dismissedAyahKeysByDateKey: nextDismissed);
    _persist();
  }

  void recordPresentationIfNeeded({
    required QuranPersonalizationSurface surface,
    required String ayahKey,
    DateTime? now,
  }) {
    final dateKey = LocalStore.todayKey(now ?? DateTime.now());
    final surfaceKey = surface.name;
    final bundleKey = '$dateKey:$ayahKey';
    if (state.lastPresentedBundleKeyBySurface[surfaceKey] == bundleKey) {
      return;
    }

    final nextPresented = <String, String>{
      ...state.lastPresentedBundleKeyBySurface,
      surfaceKey: bundleKey,
    };
    final nextRecent = <String>[ayahKey];
    for (final existing in state.recentPrimaryAyahKeys) {
      if (existing == ayahKey) continue;
      nextRecent.add(existing);
      if (nextRecent.length >= 12) break;
    }
    state = state.copyWith(
      recentPrimaryAyahKeys: nextRecent,
      lastPresentedBundleKeyBySurface: nextPresented,
    );
    _persist();
  }
}

final quranPersonalizationStateProvider =
    StateNotifierProvider<
      QuranPersonalizationController,
      QuranPersonalizationState
    >((ref) {
      return QuranPersonalizationController(ref.watch(localStoreProvider));
    });

final quranPersonalizationProfileProvider =
    Provider.family<QuranPersonalizationProfile, bool>((ref, preferKids) {
      final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
      final dateKey = LocalStore.todayKey(now);
      final recentReadings = ref.watch(quranRecentReadingsProvider);
      final bookmarks = ref.watch(quranBookmarksProvider);
      final notes = ref.watch(quranNotesProvider);
      final reflections = ref.watch(quranReflectionsProvider);
      final actionState = ref.watch(quranAyahActionStateProvider);
      final memorizationProgress = ref.watch(quranMemorizationProgressProvider);
      final memorizationDue = ref.watch(quranMemorizationDueProvider);
      final intent = ref.watch(quranSelectedUserIntentProvider);
      final intentSummary = ref.watch(quranUserIntentSummaryProvider);
      final dailySummary = ref.watch(quranDailyCompanionSummaryProvider);
      final continuePath = ref.watch(quranGuidedContinuePathProvider);
      final dhikrState = ref.watch(dhikrControllerProvider);
      final personalizationState = ref.watch(quranPersonalizationStateProvider);
      final prayerEntries = ref
          .watch(prayerLogRepositoryProvider)
          .readDayEntries(dateKey);

      final prayerCompletedToday = PrayerName.values
          .where(
            (prayer) =>
                (prayerEntries[prayer]?.status ?? PrayerStatus.pending) ==
                PrayerStatus.completed,
          )
          .length;

      final sevenDaysAgo = now.subtract(const Duration(days: 7));
      final reflectionAyahKeys = reflections
          .where((entry) => entry.ref != null)
          .take(10)
          .map((entry) => '${entry.ref!.surah}:${entry.ref!.ayah}')
          .toSet();

      final bookmarkedAyahKeys = bookmarks
          .map((bookmark) => '${bookmark.surahNumber}:${bookmark.ayahNumber}')
          .toSet();

      final recentAyahKeys = recentReadings
          .take(8)
          .map((reading) => '${reading.surahNumber}:${reading.ayahNumber}')
          .toList(growable: false);

      final memorizationAyahKeys = memorizationProgress.values
          .map((entry) {
            final ref = quranMemorizationReferenceFromVerseId(entry.verseId);
            if (ref == null) return null;
            return '${ref.surahNumber}:${ref.ayahNumber}';
          })
          .whereType<String>()
          .toSet();

      final memorizationDueAyahKeys = memorizationDue
          .map((entry) {
            final ref = quranMemorizationReferenceFromVerseId(entry.verseId);
            if (ref == null) return null;
            return '${ref.surahNumber}:${ref.ayahNumber}';
          })
          .whereType<String>()
          .toSet();

      final dhikrSessionsLast7Days = dhikrState.recentSessions.where((session) {
        return !session.finishedAt.isBefore(sevenDaysAgo);
      }).length;

      return QuranPersonalizationProfile(
        now: now,
        dateKey: dateKey,
        timeSegment: _timeSegmentFor(now),
        isKidsProfile: preferKids,
        readingStreak: ref.watch(quranReadingStreakProvider),
        readingTimeTodaySeconds: ref.watch(
          quranReadingTimeTodaySecondsProvider,
        ),
        listeningTimeTodaySeconds: ref.watch(
          quranListeningTimeTodaySecondsProvider,
        ),
        recentAyahKeys: recentAyahKeys,
        bookmarkedAyahKeys: bookmarkedAyahKeys,
        reflectionAyahKeys: reflectionAyahKeys,
        memorizationAyahKeys: memorizationAyahKeys,
        memorizationDueAyahKeys: memorizationDueAyahKeys,
        completedActionAyahKeysToday:
            actionState.completedAyahKeysByDateKey[dateKey] ?? const <String>{},
        actionStreak: actionState.currentStreak,
        prayerCompletedToday: prayerCompletedToday,
        dhikrSessionsLast7Days: dhikrSessionsLast7Days,
        notesCount: notes.length,
        bookmarkCount: bookmarks.length,
        reflectionCount: reflections.length,
        selectedIntent: intent,
        activePathId: continuePath?.id,
        suggestedPathId: intentSummary.suggestedPath?.id,
        dailyAyahKey:
            '${dailySummary.reflection.assignment.entry.ref.surah}:${dailySummary.reflection.assignment.entry.ref.ayah}',
        recentPrimaryAyahKeys: personalizationState.recentPrimaryAyahKeys,
        dismissedAyahKeysToday:
            personalizationState.dismissedAyahKeysByDateKey[dateKey] ??
            const <String>{},
      );
    });

final quranPersonalizedRecommendationBundleProvider =
    Provider.family<
      QuranRecommendationBundle?,
      (QuranPersonalizationSurface surface, bool preferKids)
    >((ref, input) {
      final context = QuranRecommendationContext(
        surface: input.$1,
        preferKids: input.$2,
      );
      return _buildBundle(ref, context);
    });

final quranReaderPersonalizedRecommendationProvider =
    Provider.family<
      QuranRecommendedAyah?,
      (int surahNumber, int ayahNumber, bool preferKids)
    >((ref, input) {
      final context = QuranRecommendationContext(
        surface: input.$3
            ? QuranPersonalizationSurface.kidsReader
            : QuranPersonalizationSurface.reader,
        preferKids: input.$3,
        currentRef: QuranQuoteRef(surah: input.$1, ayah: input.$2),
      );
      final profile = ref.watch(quranPersonalizationProfileProvider(input.$3));
      final explanationRepository = ref.watch(
        quranAyahExplanationRepositoryProvider,
      );
      final actionRepository = ref.watch(quranAyahActionRepositoryProvider);
      final continuePath = ref.watch(quranGuidedContinuePathProvider);
      final suggestedPath = ref
          .watch(quranUserIntentSummaryProvider)
          .suggestedPath;

      final currentEntry = explanationRepository.getExplanation(
        surahNumber: input.$1,
        ayahNumber: input.$2,
      );
      final currentAction = currentEntry == null
          ? null
          : actionRepository.actionForEntry(currentEntry, preferKids: input.$3);
      final currentTags = currentAction?.tags.toSet() ?? const <String>{};

      QuranRecommendedAyah? best;
      for (final entry in explanationRepository.getAll()) {
        if (entry.surahNumber == input.$1 && entry.ayahNumber == input.$2) {
          continue;
        }
        final recommendation = _scoreEntry(
          ref,
          entry: entry,
          context: context,
          profile: profile,
          actionRepository: actionRepository,
          continuePath: continuePath,
          suggestedPath: suggestedPath,
        );
        if (recommendation == null) continue;
        var score = recommendation.score;
        final sharedTags = recommendation.matchedTags
            .where((tag) => currentTags.contains(tag))
            .length;
        if (sharedTags > 0) {
          score += sharedTags * 14;
        }
        if (entry.surahNumber == input.$1) {
          score += 12;
        }
        if (best == null || score > best.score) {
          best = QuranRecommendedAyah(
            ref: recommendation.ref,
            reasonCode: sharedTags > 0
                ? QuranRecommendationReasonCode.growthFocus
                : recommendation.reasonCode,
            score: score,
            matchedTags: recommendation.matchedTags,
            recommendedDetailLevel: recommendation.recommendedDetailLevel,
            explanationPreview: recommendation.explanationPreview,
            explanationBody: recommendation.explanationBody,
            actionRecommendation: recommendation.actionRecommendation,
            debugContributions: recommendation.debugContributions,
            freshnessPenaltyApplied: recommendation.freshnessPenaltyApplied,
            isContinuationCandidate: recommendation.isContinuationCandidate,
            suggestedJourney: recommendation.suggestedJourney,
          );
        }
      }
      return best;
    });

final quranReaderPersonalizedRecommendationsForSurahProvider =
    Provider.family<
      Map<int, QuranRecommendedAyah>,
      (int surahNumber, bool preferKids)
    >((ref, input) {
      final explanationRepository = ref.watch(
        quranAyahExplanationRepositoryProvider,
      );
      final recommendations = <int, QuranRecommendedAyah>{};
      for (final entry in explanationRepository.getExplanationsForSurah(
        input.$1,
      )) {
        final recommendation = ref.watch(
          quranReaderPersonalizedRecommendationProvider((
            input.$1,
            entry.ayahNumber,
            input.$2,
          )),
        );
        if (recommendation != null) {
          recommendations[entry.ayahNumber] = recommendation;
        }
      }
      return Map<int, QuranRecommendedAyah>.unmodifiable(recommendations);
    });

QuranRecommendationBundle? _buildBundle(
  Ref ref,
  QuranRecommendationContext context,
) {
  final profile = ref.watch(
    quranPersonalizationProfileProvider(context.preferKids),
  );
  final explanationRepository = ref.watch(
    quranAyahExplanationRepositoryProvider,
  );
  final actionRepository = ref.watch(quranAyahActionRepositoryProvider);
  final continuePath = ref.watch(quranGuidedContinuePathProvider);
  final suggestedPath = ref.watch(quranUserIntentSummaryProvider).suggestedPath;

  final ranked =
      explanationRepository
          .getAll()
          .map(
            (entry) => _scoreEntry(
              ref,
              entry: entry,
              context: context,
              profile: profile,
              actionRepository: actionRepository,
              continuePath: continuePath,
              suggestedPath: suggestedPath,
            ),
          )
          .whereType<QuranRecommendedAyah>()
          .toList(growable: false)
        ..sort((a, b) {
          final byScore = b.score.compareTo(a.score);
          if (byScore != 0) return byScore;
          return a.ayahKey.compareTo(b.ayahKey);
        });

  if (ranked.isEmpty) return null;
  final primary = ranked.first;
  final secondary = ranked
      .skip(1)
      .firstWhere(
        (item) => item.ayahKey != primary.ayahKey,
        orElse: () => primary,
      );

  return QuranRecommendationBundle(
    surface: context.surface,
    preferKids: context.preferKids,
    generatedDateKey: profile.dateKey,
    primary: primary,
    secondary: secondary.ayahKey == primary.ayahKey ? null : secondary,
    suggestedJourney: primary.suggestedJourney ?? secondary.suggestedJourney,
  );
}

QuranRecommendedAyah? _scoreEntry(
  Ref ref, {
  required QuranAyahExplanationEntry entry,
  required QuranRecommendationContext context,
  required QuranPersonalizationProfile profile,
  required QuranAyahActionRepository actionRepository,
  required QuranGuidedLearningPath? continuePath,
  required QuranGuidedLearningPath? suggestedPath,
}) {
  final ayahKey = entry.ayahKey;
  if (profile.dismissedAyahKeysToday.contains(ayahKey)) {
    return null;
  }
  if (context.currentRef != null &&
      ayahKey == '${context.currentRef!.surah}:${context.currentRef!.ayah}') {
    return null;
  }

  final recommendedDetailLevel = _recommendedDetailLevelFor(
    entry: entry,
    profile: profile,
    preferKids: context.preferKids,
  );
  final resolvedExplanation = entry.resolve(
    recommendedDetailLevel,
    languageCode: 'en',
  );
  final action = actionRepository.actionForEntry(
    entry,
    preferKids: context.preferKids,
  );
  if (resolvedExplanation == null || action == null) {
    return null;
  }

  final actionRecommendation = QuranAyahActionRecommendation(
    action: action,
    explanationPreview: resolvedExplanation.previewText.isNotEmpty
        ? resolvedExplanation.previewText
        : resolvedExplanation.body,
    explanationBody: resolvedExplanation.body,
    isCompletedToday: profile.completedActionAyahKeysToday.contains(ayahKey),
    score: 0,
    isDailyAnchor: false,
    isRecentReading: false,
    isFoundational: _isFoundationalEntry(entry),
  );

  final contributions = <QuranRecommendationSignalContribution>[];
  var isContinuationCandidate = false;
  QuranAdaptiveJourneySuggestion? suggestedJourney;

  final recentIndex = profile.recentAyahKeys.indexOf(ayahKey);
  if (recentIndex >= 0) {
    final score = 64 - (recentIndex * 7);
    contributions.add(
      QuranRecommendationSignalContribution(
        reasonCode: recentIndex == 0
            ? QuranRecommendationReasonCode.continueReading
            : QuranRecommendationReasonCode.keepMomentum,
        score: score,
        debugLabel: 'recent_reading[$recentIndex]',
      ),
    );
    isContinuationCandidate = true;
  }

  if (profile.dailyAyahKey == ayahKey) {
    contributions.add(
      const QuranRecommendationSignalContribution(
        reasonCode: QuranRecommendationReasonCode.dailyAnchor,
        score: 48,
        debugLabel: 'daily_anchor',
      ),
    );
    isContinuationCandidate = true;
  }

  if (profile.reflectionAyahKeys.contains(ayahKey)) {
    contributions.add(
      const QuranRecommendationSignalContribution(
        reasonCode: QuranRecommendationReasonCode.recentReflection,
        score: 38,
        debugLabel: 'recent_reflection',
      ),
    );
  }

  if (profile.bookmarkedAyahKeys.contains(ayahKey)) {
    contributions.add(
      const QuranRecommendationSignalContribution(
        reasonCode: QuranRecommendationReasonCode.keepMomentum,
        score: 18,
        debugLabel: 'bookmarked',
      ),
    );
  }

  if (profile.memorizationDueAyahKeys.contains(ayahKey)) {
    contributions.add(
      const QuranRecommendationSignalContribution(
        reasonCode: QuranRecommendationReasonCode.memorizationReview,
        score: 36,
        debugLabel: 'memorization_due',
      ),
    );
    isContinuationCandidate = true;
  } else if (profile.memorizationAyahKeys.contains(ayahKey)) {
    contributions.add(
      const QuranRecommendationSignalContribution(
        reasonCode: QuranRecommendationReasonCode.memorizationReview,
        score: 20,
        debugLabel: 'memorization_saved',
      ),
    );
  }

  final pathMatch = _entryMatchesPath(entry, continuePath);
  if (pathMatch && continuePath != null) {
    contributions.add(
      const QuranRecommendationSignalContribution(
        reasonCode: QuranRecommendationReasonCode.guidedPathFocus,
        score: 34,
        debugLabel: 'continue_path',
      ),
    );
    suggestedJourney = QuranAdaptiveJourneySuggestion(
      pathId: continuePath.id,
      reasonCode: QuranRecommendationReasonCode.guidedPathFocus,
      routeName: 'quranLearningPathDetail',
      pathParameters: <String, String>{'pathId': continuePath.id},
    );
    isContinuationCandidate = true;
  } else if (_entryMatchesPath(entry, suggestedPath) && suggestedPath != null) {
    contributions.add(
      const QuranRecommendationSignalContribution(
        reasonCode: QuranRecommendationReasonCode.growthFocus,
        score: 18,
        debugLabel: 'suggested_path',
      ),
    );
    suggestedJourney = QuranAdaptiveJourneySuggestion(
      pathId: suggestedPath.id,
      reasonCode: QuranRecommendationReasonCode.growthFocus,
      routeName: 'quranLearningPathDetail',
      pathParameters: <String, String>{'pathId': suggestedPath.id},
    );
  }

  if (!profile.hasHistory && _isFoundationalEntry(entry)) {
    contributions.add(
      const QuranRecommendationSignalContribution(
        reasonCode: QuranRecommendationReasonCode.beginnerFriendly,
        score: 24,
        debugLabel: 'no_history_foundational',
      ),
    );
  } else if (_isFoundationalEntry(entry) &&
      profile.selectedIntent == QuranUserIntent.understand) {
    contributions.add(
      const QuranRecommendationSignalContribution(
        reasonCode: QuranRecommendationReasonCode.beginnerFriendly,
        score: 16,
        debugLabel: 'understand_foundational',
      ),
    );
  }

  if (context.preferKids) {
    if (entry.hasKidsExplanation) {
      contributions.add(
        const QuranRecommendationSignalContribution(
          reasonCode: QuranRecommendationReasonCode.kidsFriendly,
          score: 22,
          debugLabel: 'kids_explanation',
        ),
      );
    }
    if (entry.surahNumber >= 93) {
      contributions.add(
        const QuranRecommendationSignalContribution(
          reasonCode: QuranRecommendationReasonCode.kidsFriendly,
          score: 10,
          debugLabel: 'short_surah',
        ),
      );
    }
    if (action.difficulty == QuranAyahActionDifficulty.easy) {
      contributions.add(
        const QuranRecommendationSignalContribution(
          reasonCode: QuranRecommendationReasonCode.kidsFriendly,
          score: 8,
          debugLabel: 'easy_action',
        ),
      );
    }
  }

  if (profile.prayerCompletedToday < 3 &&
      _matchesAnyTag(action.tags, const <String>[
        'prayer',
        'dua',
        'guidance',
      ])) {
    contributions.add(
      const QuranRecommendationSignalContribution(
        reasonCode: QuranRecommendationReasonCode.prayerSupport,
        score: 16,
        debugLabel: 'prayer_support',
      ),
    );
  }

  if (profile.dhikrSessionsLast7Days > 0 &&
      _matchesAnyTag(action.tags, const <String>[
        'dhikr',
        'remembrance',
        'protection',
        'heart',
      ])) {
    contributions.add(
      const QuranRecommendationSignalContribution(
        reasonCode: QuranRecommendationReasonCode.remembranceRhythm,
        score: 14,
        debugLabel: 'dhikr_rhythm',
      ),
    );
  }

  if (profile.selectedIntent == QuranUserIntent.reflect &&
      resolvedExplanation.reflectionPrompt?.trim().isNotEmpty == true) {
    contributions.add(
      const QuranRecommendationSignalContribution(
        reasonCode: QuranRecommendationReasonCode.growthFocus,
        score: 18,
        debugLabel: 'intent_reflect',
      ),
    );
  }

  if (profile.selectedIntent == QuranUserIntent.memorize &&
      (profile.memorizationDueAyahKeys.contains(ayahKey) ||
          entry.surahNumber >= 103)) {
    contributions.add(
      const QuranRecommendationSignalContribution(
        reasonCode: QuranRecommendationReasonCode.memorizationReview,
        score: 18,
        debugLabel: 'intent_memorize',
      ),
    );
  }

  if (profile.selectedIntent == QuranUserIntent.understand &&
      _isFoundationalEntry(entry)) {
    contributions.add(
      const QuranRecommendationSignalContribution(
        reasonCode: QuranRecommendationReasonCode.beginnerFriendly,
        score: 14,
        debugLabel: 'intent_understand',
      ),
    );
  }

  if (profile.selectedIntent == QuranUserIntent.guidedPath &&
      suggestedJourney != null) {
    contributions.add(
      const QuranRecommendationSignalContribution(
        reasonCode: QuranRecommendationReasonCode.guidedPathFocus,
        score: 14,
        debugLabel: 'intent_guided_path',
      ),
    );
  }

  final timeScore = _timeOfDayScore(profile.timeSegment, action.tags);
  if (timeScore > 0) {
    contributions.add(
      QuranRecommendationSignalContribution(
        reasonCode: QuranRecommendationReasonCode.gentleForToday,
        score: timeScore,
        debugLabel: 'time_of_day',
      ),
    );
  }

  if (context.surface == QuranPersonalizationSurface.growth &&
      (resolvedExplanation.reflectionPrompt?.trim().isNotEmpty == true ||
          _matchesAnyTag(action.tags, const <String>[
            'patience',
            'gratitude',
          ]))) {
    contributions.add(
      const QuranRecommendationSignalContribution(
        reasonCode: QuranRecommendationReasonCode.growthFocus,
        score: 12,
        debugLabel: 'growth_surface',
      ),
    );
  }

  if (context.surface == QuranPersonalizationSurface.quranHub &&
      suggestedJourney != null) {
    contributions.add(
      const QuranRecommendationSignalContribution(
        reasonCode: QuranRecommendationReasonCode.guidedPathFocus,
        score: 8,
        debugLabel: 'hub_path_bonus',
      ),
    );
  }

  if (context.surface == QuranPersonalizationSurface.reader &&
      context.currentRef != null &&
      entry.surahNumber == context.currentRef!.surah) {
    contributions.add(
      const QuranRecommendationSignalContribution(
        reasonCode: QuranRecommendationReasonCode.keepMomentum,
        score: 8,
        debugLabel: 'reader_same_surah',
      ),
    );
  }

  final recentPrimaryIndex = profile.recentPrimaryAyahKeys.indexOf(ayahKey);
  var freshnessPenaltyApplied = false;
  if (recentPrimaryIndex >= 0 && !isContinuationCandidate) {
    final penalty = 22 - (recentPrimaryIndex * 4);
    if (penalty > 0) {
      contributions.add(
        QuranRecommendationSignalContribution(
          reasonCode: QuranRecommendationReasonCode.gentleForToday,
          score: -penalty,
          debugLabel: 'cooldown_penalty[$recentPrimaryIndex]',
        ),
      );
      freshnessPenaltyApplied = true;
    }
  }

  if (profile.completedActionAyahKeysToday.contains(ayahKey)) {
    contributions.add(
      const QuranRecommendationSignalContribution(
        reasonCode: QuranRecommendationReasonCode.keepMomentum,
        score: -28,
        debugLabel: 'completed_today_penalty',
      ),
    );
  } else {
    contributions.add(
      const QuranRecommendationSignalContribution(
        reasonCode: QuranRecommendationReasonCode.keepMomentum,
        score: 6,
        debugLabel: 'incomplete_action_bonus',
      ),
    );
  }

  final totalScore = contributions.fold<int>(
    0,
    (sum, item) => sum + item.score,
  );
  if (totalScore <= 0) {
    return null;
  }

  final rankedReasons =
      contributions.where((item) => item.score > 0).toList(growable: false)
        ..sort((a, b) => b.score.compareTo(a.score));
  final primaryReason = rankedReasons.isEmpty
      ? QuranRecommendationReasonCode.gentleForToday
      : rankedReasons.first.reasonCode;

  return QuranRecommendedAyah(
    ref: QuranQuoteRef(surah: entry.surahNumber, ayah: entry.ayahNumber),
    reasonCode: primaryReason,
    score: totalScore,
    matchedTags: action.tags,
    recommendedDetailLevel: recommendedDetailLevel,
    explanationPreview: resolvedExplanation.previewText.isNotEmpty
        ? resolvedExplanation.previewText
        : resolvedExplanation.body,
    explanationBody: resolvedExplanation.body,
    actionRecommendation: actionRecommendation,
    debugContributions: contributions,
    freshnessPenaltyApplied: freshnessPenaltyApplied,
    isContinuationCandidate: isContinuationCandidate,
    suggestedJourney: suggestedJourney,
  );
}

QuranExplanationDetailLevel _recommendedDetailLevelFor({
  required QuranAyahExplanationEntry entry,
  required QuranPersonalizationProfile profile,
  required bool preferKids,
}) {
  if (preferKids) return QuranExplanationDetailLevel.kids;
  if (profile.selectedIntent == QuranUserIntent.memorize) {
    return QuranExplanationDetailLevel.simple;
  }
  if (profile.selectedIntent == QuranUserIntent.reflect) {
    return QuranExplanationDetailLevel.standard;
  }
  final studyHeavySignals =
      profile.notesCount + profile.reflectionCount + profile.bookmarkCount;
  if (studyHeavySignals >= 6 && entry.hasDeepExplanation) {
    return QuranExplanationDetailLevel.deep;
  }
  if (!profile.hasHistory || profile.readingStreak <= 1) {
    return QuranExplanationDetailLevel.simple;
  }
  return QuranExplanationDetailLevel.standard;
}

QuranPersonalizationTimeSegment _timeSegmentFor(DateTime now) {
  final hour = now.hour;
  if (hour < 11) return QuranPersonalizationTimeSegment.morning;
  if (hour < 17) return QuranPersonalizationTimeSegment.afternoon;
  if (hour < 21) return QuranPersonalizationTimeSegment.evening;
  return QuranPersonalizationTimeSegment.night;
}

bool _isFoundationalEntry(QuranAyahExplanationEntry entry) {
  return switch (entry.rolloutPack) {
    QuranAyahExplanationRolloutPack.foundations => true,
    QuranAyahExplanationRolloutPack.beginnerCoreAyahs => true,
    QuranAyahExplanationRolloutPack.kidsStarter => true,
    _ => false,
  };
}

bool _matchesAnyTag(List<String> tags, List<String> needles) {
  for (final tag in tags) {
    if (needles.contains(tag)) return true;
  }
  return false;
}

int _timeOfDayScore(
  QuranPersonalizationTimeSegment segment,
  List<String> tags,
) {
  return switch (segment) {
    QuranPersonalizationTimeSegment.morning =>
      _matchesAnyTag(tags, const <String>['guidance', 'learning', 'bismillah'])
          ? 10
          : 0,
    QuranPersonalizationTimeSegment.afternoon =>
      _matchesAnyTag(tags, const <String>['gratitude', 'kindness', 'service'])
          ? 8
          : 0,
    QuranPersonalizationTimeSegment.evening =>
      _matchesAnyTag(tags, const <String>['protection', 'dhikr', 'patience'])
          ? 12
          : 0,
    QuranPersonalizationTimeSegment.night =>
      _matchesAnyTag(tags, const <String>['protection', 'heart', 'repentance'])
          ? 14
          : 0,
  };
}

bool _entryMatchesPath(
  QuranAyahExplanationEntry entry,
  QuranGuidedLearningPath? path,
) {
  if (path == null) return false;
  if (path.surahNumber == entry.surahNumber &&
      (path.ayahNumber == null || path.ayahNumber == entry.ayahNumber)) {
    return true;
  }
  for (final step in path.steps) {
    for (final ref in step.ayahReferences) {
      final endAyah = ref.endAyahNumber ?? ref.ayahNumber;
      if (entry.surahNumber == ref.surahNumber &&
          entry.ayahNumber >= ref.ayahNumber &&
          entry.ayahNumber <= endAyah) {
        return true;
      }
    }
  }
  return false;
}
