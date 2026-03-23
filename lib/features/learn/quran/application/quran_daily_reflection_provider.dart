import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../../journey/drops/application/journey_drops_providers.dart';
import '../../../journey/xp/application/journey_xp_providers.dart';
import '../domain/quran_ayah_enrichment_models.dart';
import 'quran_ayah_enrichment_provider.dart';
import 'quran_learning_progression_provider.dart';
import 'quran_learning_personalization_provider.dart';
import 'quran_providers.dart';

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
  });

  final String dateKey;
  final QuranAyahEnrichmentEntry entry;
  final bool isFirstTimeStarter;
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
      final now = DateTime.now();
      final dateKey = LocalStore.todayKey(now);
      final assignment = _resolveDailyAssignment(
        entries: entries,
        state: state,
        recentReadings: recentReadings,
        today: now,
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

QuranDailyReflectionAssignment _resolveDailyAssignment({
  required List<QuranAyahEnrichmentEntry> entries,
  required QuranDailyReflectionState state,
  required List<QuranRecentReading> recentReadings,
  required DateTime today,
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

  final hasHistory = state.history.isNotEmpty || recentReadings.isNotEmpty;
  if (!hasHistory) {
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
  final seed = (today.year * 372) + (today.month * 31) + today.day;
  return QuranDailyReflectionAssignment(
    dateKey: todayKey,
    entry: candidates[seed % candidates.length],
    isFirstTimeStarter: false,
  );
}

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
