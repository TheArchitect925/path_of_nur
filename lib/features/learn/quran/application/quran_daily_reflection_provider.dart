import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/application/daily_clock_provider.dart';
import '../../../../shared/persistence/local_store.dart';
import '../../../journey/drops/application/journey_drops_providers.dart';
import '../../../journey/xp/application/journey_xp_providers.dart';
import '../../journey/application/learning_journey_progress_provider.dart';
import '../../journey/data/learning_journey_theme_mapping.dart';
import '../domain/quran_ayah_enrichment_models.dart';
import '../domain/quran_daily_companion_models.dart';
import '../domain/quran_guided_learning_path_models.dart';
import '../domain/quran_reference_models.dart';
import '../domain/quran_user_intent_models.dart';
import 'quran_ayah_enrichment_provider.dart';
import 'quran_learning_progression_provider.dart';
import 'quran_learning_personalization_provider.dart';
import 'quran_guided_learning_paths_provider.dart';
import 'quran_providers.dart';
import 'quran_reference_graph_provider.dart';
import 'quran_learning_system_service.dart';
import 'quran_user_intent_provider.dart';

const _quranDailyReflectionStateKey = 'learn.quran.daily_reflection.v1';

class QuranDailyReflectionHistoryItem {
  const QuranDailyReflectionHistoryItem({
    required this.dateKey,
    required this.entryId,
  });

  final String dateKey;
  final String entryId;

  Map<String, dynamic> toJson() => {'dateKey': dateKey, 'entryId': entryId};

  static QuranDailyReflectionHistoryItem? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final dateKey = json['dateKey']?.toString();
    final entryId = json['entryId']?.toString();
    if (dateKey == null ||
        dateKey.isEmpty ||
        entryId == null ||
        entryId.isEmpty) {
      return null;
    }
    return QuranDailyReflectionHistoryItem(dateKey: dateKey, entryId: entryId);
  }
}

Map<String, dynamic>? _asStringDynamicMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
  }
  return null;
}

List<dynamic> _asDynamicList(dynamic value) {
  if (value is List<dynamic>) return value;
  if (value is List) return List<dynamic>.from(value);
  return const [];
}

class QuranDailyReflectionState {
  const QuranDailyReflectionState({
    required this.assignedDateKey,
    required this.assignedEntryId,
    required this.completedDateKeys,
    required this.history,
    required this.currentStreak,
    required this.bestStreak,
    required this.lastCompletedDateKey,
  });

  final String? assignedDateKey;
  final String? assignedEntryId;
  final Set<String> completedDateKeys;
  final List<QuranDailyReflectionHistoryItem> history;
  final int currentStreak;
  final int bestStreak;
  final String? lastCompletedDateKey;

  bool isCompletedForDay(String dateKey) => completedDateKeys.contains(dateKey);

  QuranDailyReflectionState copyWith({
    String? assignedDateKey,
    String? assignedEntryId,
    Set<String>? completedDateKeys,
    List<QuranDailyReflectionHistoryItem>? history,
    int? currentStreak,
    int? bestStreak,
    String? lastCompletedDateKey,
  }) {
    return QuranDailyReflectionState(
      assignedDateKey: assignedDateKey ?? this.assignedDateKey,
      assignedEntryId: assignedEntryId ?? this.assignedEntryId,
      completedDateKeys: completedDateKeys ?? this.completedDateKeys,
      history: history ?? this.history,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastCompletedDateKey: lastCompletedDateKey ?? this.lastCompletedDateKey,
    );
  }

  Map<String, dynamic> toJson() => {
    'assignedDateKey': assignedDateKey,
    'assignedEntryId': assignedEntryId,
    'completedDateKeys': completedDateKeys.toList(growable: false),
    'history': history.map((item) => item.toJson()).toList(growable: false),
    'currentStreak': currentStreak,
    'bestStreak': bestStreak,
    'lastCompletedDateKey': lastCompletedDateKey,
  };

  static QuranDailyReflectionState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const QuranDailyReflectionState(
        assignedDateKey: null,
        assignedEntryId: null,
        completedDateKeys: <String>{},
        history: <QuranDailyReflectionHistoryItem>[],
        currentStreak: 0,
        bestStreak: 0,
        lastCompletedDateKey: null,
      );
    }
    final rawCompleted = _asDynamicList(json['completedDateKeys']);
    final rawHistory = _asDynamicList(json['history']);
    return QuranDailyReflectionState(
      assignedDateKey: json['assignedDateKey']?.toString(),
      assignedEntryId: json['assignedEntryId']?.toString(),
      completedDateKeys: rawCompleted.map((item) => item.toString()).toSet(),
      history: rawHistory
          .map(
            (item) => QuranDailyReflectionHistoryItem.fromJson(
              _asStringDynamicMap(item),
            ),
          )
          .whereType<QuranDailyReflectionHistoryItem>()
          .toList(growable: false),
      currentStreak: int.tryParse(json['currentStreak']?.toString() ?? '') ?? 0,
      bestStreak: int.tryParse(json['bestStreak']?.toString() ?? '') ?? 0,
      lastCompletedDateKey: json['lastCompletedDateKey']?.toString(),
    );
  }
}

class QuranDailyReflectionAssignment {
  const QuranDailyReflectionAssignment({
    required this.dateKey,
    required this.entry,
    required this.isFirstTimeStarter,
    this.selectionSource = QuranDailyLoopSelectionSource.curatedRotation,
  });

  final String dateKey;
  final QuranAyahEnrichmentEntry entry;
  final bool isFirstTimeStarter;
  final QuranDailyLoopSelectionSource selectionSource;
}

class QuranDailyReflectionSummary {
  const QuranDailyReflectionSummary({
    required this.assignment,
    required this.isCompletedToday,
    required this.currentStreak,
    required this.bestStreak,
    required this.primaryPrompt,
    required this.insightItems,
    required this.hasHistory,
  });

  final QuranDailyReflectionAssignment assignment;
  final bool isCompletedToday;
  final int currentStreak;
  final int bestStreak;
  final String primaryPrompt;
  final List<QuranAyahDisplayItem> insightItems;
  final bool hasHistory;
}

class QuranDailyReflectionController
    extends StateNotifier<QuranDailyReflectionState> {
  QuranDailyReflectionController(this._ref)
    : _store = _ref.read(localStoreProvider),
      super(
        QuranDailyReflectionState.fromJson(
          _ref
              .read(localStoreProvider)
              .getJsonMap(_quranDailyReflectionStateKey),
        ),
      );

  final Ref _ref;
  final LocalStore _store;

  static const int defaultRepeatWindowDays = 21;
  static const int defaultHistoryRetentionDays = 120;
  static const int dailyReflectionXp = 10;

  void _persist() {
    _store.setJsonMap(_quranDailyReflectionStateKey, state.toJson());
  }

  bool completeToday({
    required QuranDailyReflectionAssignment assignment,
    DateTime? now,
  }) {
    final date = now ?? DateTime.now();
    final todayKey = assignment.dateKey;
    if (state.completedDateKeys.contains(todayKey)) return false;

    final updatedHistory = _historyWithAssignment(
      assignment: assignment,
      today: date,
    );
    final completed = Set<String>.from(state.completedDateKeys)..add(todayKey);
    final streak = _computeStreak(completed, date);
    final best = math.max(state.bestStreak, streak);

    state = state.copyWith(
      assignedDateKey: todayKey,
      assignedEntryId: assignment.entry.id,
      completedDateKeys: completed,
      history: updatedHistory,
      currentStreak: streak,
      bestStreak: best,
      lastCompletedDateKey: todayKey,
    );
    _persist();

    _ref
        .read(quranReadingProgressProvider.notifier)
        .touchLocation(
          surahNumber: assignment.entry.ref.surah,
          ayahNumber: assignment.entry.ref.ayah,
        );

    final categoryId = _categoryIdForDomain(assignment.entry.domain);
    _ref
        .read(quranLearningPersonalizationStateProvider.notifier)
        .markDomainOpened(categoryId);

    final sourceRef = 'quran_daily_reflection:$todayKey';
    _ref
        .read(journeyXpSummaryProvider.notifier)
        .awardQuranXp(
          sourceRef: sourceRef,
          occurredAt: date,
          metadata: <String, Object?>{
            'entryId': assignment.entry.id,
            'surah': assignment.entry.ref.surah,
            'ayah': assignment.entry.ref.ayah,
          },
        );
    _ref
        .read(journeyDropSummaryProvider.notifier)
        .awardQuranDrop(
          sourceRef: sourceRef,
          occurredAt: date,
          metadata: <String, Object?>{
            'entryId': assignment.entry.id,
            'surah': assignment.entry.ref.surah,
            'ayah': assignment.entry.ref.ayah,
          },
        );

    _ref
        .read(quranLearningProgressStateProvider.notifier)
        .completeEntry(
          entry: assignment.entry,
          sourceSurface: 'daily_reflection',
          awardEntryReward: false,
          now: date,
        );

    return true;
  }

  List<QuranDailyReflectionHistoryItem> _historyWithAssignment({
    required QuranDailyReflectionAssignment assignment,
    required DateTime today,
  }) {
    final trimmed = state.history.where(
      (item) => item.dateKey != assignment.dateKey,
    );
    final next = <QuranDailyReflectionHistoryItem>[
      ...trimmed,
      QuranDailyReflectionHistoryItem(
        dateKey: assignment.dateKey,
        entryId: assignment.entry.id,
      ),
    ];
    final threshold = today.subtract(
      const Duration(days: defaultHistoryRetentionDays),
    );
    return next
        .where((item) {
          final day = _dayFromKey(item.dateKey);
          return day != null && !day.isBefore(threshold);
        })
        .toList(growable: false);
  }

  int _computeStreak(Set<String> completed, DateTime now) {
    if (completed.isEmpty) return 0;
    var streak = 0;
    var cursor = DateTime(now.year, now.month, now.day);
    while (completed.contains(LocalStore.todayKey(cursor))) {
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }
}

final quranDailyReflectionStateProvider =
    StateNotifierProvider<
      QuranDailyReflectionController,
      QuranDailyReflectionState
    >((ref) => QuranDailyReflectionController(ref));

final quranDailyReflectionSummaryProvider =
    Provider<QuranDailyReflectionSummary>((ref) {
      final state = ref.watch(quranDailyReflectionStateProvider);
      final entries = ref.watch(quranAyahEnrichmentEntriesProvider);
      final recentReadings = ref.watch(quranRecentReadingsProvider);
      final activeIntent = ref.watch(quranSelectedUserIntentProvider);
      final journeyContext = _resolveDailyLoopJourneyContext(ref);
      final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
      final dateKey = LocalStore.todayKey(now);
      final assignment = _resolveDailyAssignment(
        entries: entries,
        state: state,
        recentReadings: recentReadings,
        today: now,
        intent: activeIntent,
        journeyContext: journeyContext,
      );

      final displayItems = ref.watch(
        quranAyahDisplayItemsForRangeProvider(assignment.entry.ref),
      );
      final insightItems = displayItems
          .where((item) => item.type != QuranAyahDisplayItemType.relatedAyah)
          .where(
            (item) => item.type != QuranAyahDisplayItemType.reflectionPrompt,
          )
          .take(2)
          .toList(growable: false);

      final primaryPrompt = assignment.entry.reflectionPrompts.isNotEmpty
          ? assignment.entry.reflectionPrompts.first
          : assignment.entry.summary;

      return QuranDailyReflectionSummary(
        assignment: assignment,
        isCompletedToday: state.isCompletedForDay(dateKey),
        currentStreak: state.currentStreak,
        bestStreak: state.bestStreak,
        primaryPrompt: primaryPrompt,
        insightItems: insightItems,
        hasHistory: state.history.isNotEmpty || recentReadings.isNotEmpty,
      );
    });

final quranDailyCompanionSummaryProvider = Provider<QuranDailyCompanionSummary>(
  (ref) {
    final reflection = ref.watch(quranDailyReflectionSummaryProvider);
    final assignment = reflection.assignment;
    final entry = assignment.entry;
    final relatedLinks = ref
        .watch(
          quranContextualKnowledgeLinksForVerseProvider((
            entry.ref.surah,
            entry.ref.ayah,
          )),
        )
        .take(2)
        .toList(growable: false);
    final journeyContext = _resolveDailyLoopJourneyContext(ref);
    final verseThemes = ref.watch(
      quranThemesForVerseProvider((entry.ref.surah, entry.ref.ayah)),
    );
    final themes = _resolveDailyThemes(
      ref,
      verseThemes: verseThemes,
      journeyContext: journeyContext,
    );
    final memorizationEntry = ref.watch(
      quranMemorizationEntryForAyahProvider((entry.ref.surah, entry.ref.ayah)),
    );
    final activeIntent = ref.watch(quranSelectedUserIntentProvider);
    final intentSummary = ref.watch(quranUserIntentSummaryProvider);
    final continuePath = ref.watch(quranGuidedContinuePathProvider);
    final featuredPaths = ref.watch(quranGuidedFeaturedLearningPathsProvider);
    final suggestedPath = _resolveSuggestedPath(
      featuredPaths: featuredPaths,
      continuePath: continuePath,
      themes: themes,
      entry: entry,
      intent: activeIntent,
      intentSuggestedPath: intentSummary.suggestedPath,
    );

    return QuranDailyCompanionSummary(
      reflection: reflection,
      meaningCue: _dailyMeaningCue(entry, activeIntent),
      practicalTakeaway: _dailyPracticalTakeaway(entry, reflection, activeIntent),
      relatedLinks: relatedLinks,
      themes: themes,
      memorizationEntry: memorizationEntry,
      activeIntent: activeIntent,
      preferredReaderMode: activeIntent == null
          ? QuranReaderStudyMode.reading
          : quranPreferredReaderModeForIntent(
              activeIntent,
              hasHighlightedTopic: themes.isNotEmpty,
            ),
      continuePath: continuePath,
      suggestedPath: suggestedPath,
      selectionSource: assignment.selectionSource,
      journeyContext: journeyContext,
    );
  },
);

QuranDailyReflectionAssignment _resolveDailyAssignment({
  required List<QuranAyahEnrichmentEntry> entries,
  required QuranDailyReflectionState state,
  required List<QuranRecentReading> recentReadings,
  required DateTime today,
  required QuranUserIntent? intent,
  required QuranDailyLoopJourneyContext? journeyContext,
}) {
  final todayKey = LocalStore.todayKey(today);
  final eligible =
      entries
          .where((entry) => entry.reflectionPrompts.isNotEmpty)
          .where(
            (entry) => entry.linkStrength != QuranAyahLinkStrength.contextual,
          )
          .toList(growable: false)
        ..sort(_compareDailyEntries);

  final starter = eligible.firstWhere(
    (entry) => entry.id == 'worship_salah_20_14',
    orElse: () => eligible.first,
  );
  final journeyEntry = _entryForJourneyContext(
    eligible,
    journeyContext: journeyContext,
  );

  final hasHistory = state.history.isNotEmpty || recentReadings.isNotEmpty;
  if (!hasHistory) {
    if (journeyEntry != null) {
      return QuranDailyReflectionAssignment(
        dateKey: todayKey,
        entry: journeyEntry,
        isFirstTimeStarter: false,
        selectionSource: QuranDailyLoopSelectionSource.journeyTheme,
      );
    }
    return QuranDailyReflectionAssignment(
      dateKey: todayKey,
      entry: starter,
      isFirstTimeStarter: true,
    );
  }

  if (state.assignedDateKey == todayKey &&
      state.assignedEntryId != null &&
      state.assignedEntryId!.isNotEmpty) {
    final assigned = eligible.where(
      (entry) => entry.id == state.assignedEntryId,
    );
    if (assigned.isNotEmpty) {
      return QuranDailyReflectionAssignment(
        dateKey: todayKey,
        entry: assigned.first,
        isFirstTimeStarter: false,
      );
    }
  }

  final historyEntry = state.history.where((item) => item.dateKey == todayKey);
  if (historyEntry.isNotEmpty) {
    final matched = eligible.where(
      (entry) => entry.id == historyEntry.first.entryId,
    );
    if (matched.isNotEmpty) {
      return QuranDailyReflectionAssignment(
        dateKey: todayKey,
        entry: matched.first,
        isFirstTimeStarter: false,
      );
    }
  }

  if (journeyEntry != null) {
    return QuranDailyReflectionAssignment(
      dateKey: todayKey,
      entry: journeyEntry,
      isFirstTimeStarter: false,
      selectionSource: QuranDailyLoopSelectionSource.journeyTheme,
    );
  }

  final threshold = DateTime(today.year, today.month, today.day).subtract(
    const Duration(
      days: QuranDailyReflectionController.defaultRepeatWindowDays - 1,
    ),
  );
  final recentEntryIds = state.history
      .where((item) {
        final date = _dayFromKey(item.dateKey);
        return date != null && !date.isBefore(threshold);
      })
      .map((item) => item.entryId)
      .toSet();

  final pool = eligible
      .where((entry) => !recentEntryIds.contains(entry.id))
      .toList(growable: false);
  final candidates = pool.isNotEmpty ? pool : eligible;
  final rankedCandidates = _rankDailyCandidates(candidates, intent: intent);
  final seed = (today.year * 372) + (today.month * 31) + today.day;
  return QuranDailyReflectionAssignment(
    dateKey: todayKey,
    entry: rankedCandidates[seed % rankedCandidates.length],
    isFirstTimeStarter: false,
    selectionSource: QuranDailyLoopSelectionSource.curatedRotation,
  );
}

QuranDailyLoopJourneyContext? _resolveDailyLoopJourneyContext(Ref ref) {
  final continueState = ref.watch(learningJourneyContinueProvider);
  final stage = continueState.stage;
  final journey = continueState.journey;
  if (journey == null || stage == null) return null;
  final mapping = learningJourneyThemeMappingForStage(stage.id);
  if (mapping == null) return null;
  return QuranDailyLoopJourneyContext(
    journeyId: journey.id,
    stageId: stage.id,
    topicIds: List<String>.from(mapping.quranTopicIds),
    connectionStrength: mapping.connectionStrength,
    suggestedReaderMode: mapping.suggestedReaderMode,
    suggestedLearningPathId: mapping.suggestedLearningPathId,
  );
}

List<QuranTopic> _resolveDailyThemes(
  Ref ref, {
  required List<QuranTopic> verseThemes,
  required QuranDailyLoopJourneyContext? journeyContext,
}) {
  if (verseThemes.isNotEmpty) {
    return verseThemes.take(2).toList(growable: false);
  }
  if (journeyContext == null) return const <QuranTopic>[];

  final topics = <QuranTopic>[];
  for (final topicId in journeyContext.topicIds) {
    final topic = ref.watch(quranTopicByIdProvider(topicId));
    if (topic == null) continue;
    topics.add(topic);
    if (topics.length >= 2) break;
  }
  return topics;
}

QuranAyahEnrichmentEntry? _entryForJourneyContext(
  List<QuranAyahEnrichmentEntry> eligible, {
  required QuranDailyLoopJourneyContext? journeyContext,
}) {
  if (journeyContext == null) return null;
  final mapping = learningJourneyThemeMappingForStage(journeyContext.stageId);
  if (mapping == null) return null;

  return eligible.where((entry) {
    final topicMatch =
        journeyContext.topicIds.isEmpty ||
        journeyContext.topicIds.any(
          (topicId) => _entryLooksAlignedToTopic(entry, topicId),
        );
    final verseMatch =
        entry.ref.surah == mapping.surahNumber &&
        entry.ref.ayah <= (mapping.endAyahNumber ?? mapping.ayahNumber) &&
        (entry.ref.ayahEnd ?? entry.ref.ayah) >= mapping.ayahNumber;
    return topicMatch && verseMatch;
  }).firstOrNull;
}

List<QuranAyahEnrichmentEntry> _rankDailyCandidates(
  List<QuranAyahEnrichmentEntry> candidates, {
  required QuranUserIntent? intent,
}) {
  if (intent == null || candidates.length <= 1) return candidates;
  final ranked = List<QuranAyahEnrichmentEntry>.from(candidates);
  ranked.sort((a, b) {
    final scoreDiff = _dailyIntentScore(b, intent) - _dailyIntentScore(a, intent);
    if (scoreDiff != 0) return scoreDiff;
    return _compareDailyEntries(a, b);
  });
  return ranked;
}

int _dailyIntentScore(QuranAyahEnrichmentEntry entry, QuranUserIntent intent) {
  switch (intent) {
    case QuranUserIntent.understand:
      return _scoreByDomain(entry, const {
            QuranAyahEnrichmentDomain.guidanceDailyLife: 4,
            QuranAyahEnrichmentDomain.tawhidBelief: 3,
            QuranAyahEnrichmentDomain.prophetsLessons: 2,
          }) +
          (entry.hasAction ? 1 : 0);
    case QuranUserIntent.reflect:
      return _scoreByLessonType(entry, const {
            QuranAyahEnrichmentLessonType.reflection: 4,
            QuranAyahEnrichmentLessonType.practicalTakeaway: 3,
            QuranAyahEnrichmentLessonType.reminder: 2,
          }) +
          _scoreByDomain(entry, const {
            QuranAyahEnrichmentDomain.guidanceDailyLife: 2,
            QuranAyahEnrichmentDomain.characterAdab: 2,
            QuranAyahEnrichmentDomain.worshipRemembrance: 1,
          });
    case QuranUserIntent.memorize:
      return (_memorizationPrioritySurahs.contains(entry.ref.surah) ? 4 : 0) +
          _scoreByDomain(entry, const {
            QuranAyahEnrichmentDomain.worshipRemembrance: 2,
            QuranAyahEnrichmentDomain.guidanceDailyLife: 1,
          });
    case QuranUserIntent.themes:
      return (entry.tags.isNotEmpty ? 3 : 0) +
          (entry.linkStrength == QuranAyahLinkStrength.direct ? 2 : 0) +
          _scoreByDomain(entry, const {
            QuranAyahEnrichmentDomain.characterAdab: 2,
            QuranAyahEnrichmentDomain.signsInCreation: 2,
            QuranAyahEnrichmentDomain.guidanceDailyLife: 1,
          });
    case QuranUserIntent.guidedPath:
      return (entry.sourceRouteName == 'quranAyahInsightsPathDetail' ? 4 : 0) +
          (entry.hasAction ? 2 : 0) +
          _scoreByDomain(entry, const {
            QuranAyahEnrichmentDomain.guidanceDailyLife: 2,
            QuranAyahEnrichmentDomain.worshipRemembrance: 1,
            QuranAyahEnrichmentDomain.prophetsLessons: 1,
          });
  }
}

int _scoreByDomain(
  QuranAyahEnrichmentEntry entry,
  Map<QuranAyahEnrichmentDomain, int> scores,
) {
  return scores[entry.domain] ?? 0;
}

int _scoreByLessonType(
  QuranAyahEnrichmentEntry entry,
  Map<QuranAyahEnrichmentLessonType, int> scores,
) {
  return scores[entry.lessonType] ?? 0;
}

bool _entryLooksAlignedToTopic(QuranAyahEnrichmentEntry entry, String topicId) {
  return switch (topicId) {
    'patience' => entry.tags.contains(QuranAyahEnrichmentTag.sabr),
    'gratitude' => entry.tags.contains(QuranAyahEnrichmentTag.shukr),
    'humility' => entry.domain == QuranAyahEnrichmentDomain.characterAdab,
    'remembrance' => entry.domain == QuranAyahEnrichmentDomain.worshipRemembrance,
    'repentance' => entry.tags.contains(QuranAyahEnrichmentTag.repentance),
    'trust-in-allah' => entry.tags.contains(QuranAyahEnrichmentTag.tawakkul),
    'mercy' => entry.tags.contains(QuranAyahEnrichmentTag.mercy),
    _ => false,
  };
}

const Set<int> _memorizationPrioritySurahs = <int>{
  1,
  18,
  55,
  67,
  93,
  94,
  103,
  108,
  109,
  112,
  113,
  114,
};

int _compareDailyEntries(
  QuranAyahEnrichmentEntry a,
  QuranAyahEnrichmentEntry b,
) {
  final priority = a.displayPriority.compareTo(b.displayPriority);
  if (priority != 0) return priority;
  final strength = a.linkStrength.priorityValue.compareTo(
    b.linkStrength.priorityValue,
  );
  if (strength != 0) return strength;
  return a.id.compareTo(b.id);
}

DateTime? _dayFromKey(String raw) {
  final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(raw);
  if (match == null) return null;
  final year = int.tryParse(match.group(1)!);
  final month = int.tryParse(match.group(2)!);
  final day = int.tryParse(match.group(3)!);
  if (year == null || month == null || day == null) return null;
  return DateTime(year, month, day);
}

String _categoryIdForDomain(QuranAyahEnrichmentDomain domain) {
  return switch (domain) {
    QuranAyahEnrichmentDomain.signsInCreation ||
    QuranAyahEnrichmentDomain.worldNature => 'signs-in-creation',
    QuranAyahEnrichmentDomain.worshipRemembrance => 'worship-remembrance',
    QuranAyahEnrichmentDomain.characterAdab => 'character-adab',
    QuranAyahEnrichmentDomain.tawhidBelief => 'tawhid-belief',
    QuranAyahEnrichmentDomain.akhirahAccountability => 'akhirah-accountability',
    QuranAyahEnrichmentDomain.prophetsLessons => 'prophets-lessons',
    QuranAyahEnrichmentDomain.guidanceDailyLife => 'guidance-daily-life',
  };
}

String _dailyMeaningCue(
  QuranAyahEnrichmentEntry entry,
  QuranUserIntent? intent,
) {
  if (entry.summary.trim().isNotEmpty) {
    return entry.summary.trim();
  }
  if (intent == QuranUserIntent.reflect && entry.reflectionPrompts.isNotEmpty) {
    return entry.reflectionPrompts.first.trim();
  }
  if (entry.body.trim().isNotEmpty) {
    return _firstSentence(entry.body);
  }
  if (entry.reflectionPrompts.isNotEmpty) {
    return entry.reflectionPrompts.first.trim();
  }
  return entry.title.trim();
}

String _dailyPracticalTakeaway(
  QuranAyahEnrichmentEntry entry,
  QuranDailyReflectionSummary reflection,
  QuranUserIntent? intent,
) {
  if (intent == QuranUserIntent.reflect &&
      entry.reflectionPrompts.isNotEmpty) {
    return entry.reflectionPrompts.first.trim();
  }
  if (entry.body.trim().isNotEmpty) {
    return _firstSentence(entry.body);
  }
  if (entry.reflectionPrompts.length > 1) {
    return entry.reflectionPrompts[1].trim();
  }
  return reflection.primaryPrompt.trim();
}

String _firstSentence(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return trimmed;
  final parts = trimmed.split(RegExp(r'(?<=[.!?])\s+'));
  return parts.first.trim();
}

QuranGuidedLearningPath? _resolveSuggestedPath({
  required List<QuranGuidedLearningPath> featuredPaths,
  required QuranGuidedLearningPath? continuePath,
  required List<QuranTopic> themes,
  required QuranAyahEnrichmentEntry entry,
  required QuranUserIntent? intent,
  required QuranGuidedLearningPath? intentSuggestedPath,
}) {
  if (intentSuggestedPath != null) return intentSuggestedPath;
  if (continuePath != null) return continuePath;

  if (intent == QuranUserIntent.themes) {
    for (final theme in themes) {
      for (final path in featuredPaths) {
        if (path.themeId == theme.id) return path;
      }
    }
  }

  for (final theme in themes) {
    for (final path in featuredPaths) {
      if (path.themeId == theme.id) return path;
    }
  }

  for (final path in featuredPaths) {
    if (path.surahNumber == entry.ref.surah &&
        path.ayahNumber == entry.ref.ayah) {
      return path;
    }
  }

  for (final path in featuredPaths) {
    if (path.type == QuranGuidedLearningPathType.beginnerUnderstanding) {
      return path;
    }
  }

  return featuredPaths.isEmpty ? null : featuredPaths.first;
}
