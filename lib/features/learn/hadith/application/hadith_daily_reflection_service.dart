import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../../journey/application/journey_progression_provider.dart';
import '../domain/hadith_foundation_models.dart';
import 'hadith_foundation_repository.dart';

const _hadithDailyStateKey = 'learn.hadith.daily.reflection.v1';

class HadithDailyHistoryItem {
  const HadithDailyHistoryItem({required this.dateKey, required this.entryId});

  final String dateKey;
  final String entryId;

  Map<String, dynamic> toJson() => {'dateKey': dateKey, 'entryId': entryId};

  static HadithDailyHistoryItem? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final dateKey = json['dateKey']?.toString();
    final entryId = json['entryId']?.toString();
    if (dateKey == null ||
        dateKey.isEmpty ||
        entryId == null ||
        entryId.isEmpty) {
      return null;
    }
    return HadithDailyHistoryItem(dateKey: dateKey, entryId: entryId);
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

class HadithDailyReflectionState {
  const HadithDailyReflectionState({
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
  final List<HadithDailyHistoryItem> history;
  final int currentStreak;
  final int bestStreak;
  final String? lastCompletedDateKey;

  bool isCompletedForDay(String dateKey) => completedDateKeys.contains(dateKey);

  HadithDailyReflectionState copyWith({
    String? assignedDateKey,
    String? assignedEntryId,
    Set<String>? completedDateKeys,
    List<HadithDailyHistoryItem>? history,
    int? currentStreak,
    int? bestStreak,
    String? lastCompletedDateKey,
  }) {
    return HadithDailyReflectionState(
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

  static HadithDailyReflectionState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const HadithDailyReflectionState(
        assignedDateKey: null,
        assignedEntryId: null,
        completedDateKeys: <String>{},
        history: <HadithDailyHistoryItem>[],
        currentStreak: 0,
        bestStreak: 0,
        lastCompletedDateKey: null,
      );
    }
    final rawCompleted = _asDynamicList(json['completedDateKeys']);
    final rawHistory = _asDynamicList(json['history']);
    return HadithDailyReflectionState(
      assignedDateKey: json['assignedDateKey']?.toString(),
      assignedEntryId: json['assignedEntryId']?.toString(),
      completedDateKeys: rawCompleted.map((item) => item.toString()).toSet(),
      history: rawHistory
          .map(
            (item) =>
                HadithDailyHistoryItem.fromJson(_asStringDynamicMap(item)),
          )
          .whereType<HadithDailyHistoryItem>()
          .toList(growable: false),
      currentStreak: int.tryParse(json['currentStreak']?.toString() ?? '') ?? 0,
      bestStreak: int.tryParse(json['bestStreak']?.toString() ?? '') ?? 0,
      lastCompletedDateKey: json['lastCompletedDateKey']?.toString(),
    );
  }
}

class HadithDailyReflectionController
    extends StateNotifier<HadithDailyReflectionState> {
  HadithDailyReflectionController(
    this._store, {
    this.repeatWindowDays = defaultRepeatWindowDays,
    this.historyRetentionDays = defaultHistoryRetentionDays,
  }) : super(
         HadithDailyReflectionState.fromJson(
           _store.getJsonMap(_hadithDailyStateKey),
         ),
       );

  final LocalStore _store;
  final int repeatWindowDays;
  final int historyRetentionDays;

  static const int defaultRepeatWindowDays = 14;
  static const int defaultHistoryRetentionDays = 90;

  void _persist() {
    _store.setJsonMap(_hadithDailyStateKey, state.toJson());
  }

  void assignTodayEntry(List<HadithEntry> entries, {DateTime? now}) {
    final date = now ?? DateTime.now();
    final todayKey = LocalStore.todayKey(date);
    if (state.assignedDateKey == todayKey &&
        state.assignedEntryId != null &&
        state.assignedEntryId!.isNotEmpty) {
      return;
    }

    final candidates = _dailyEligible(entries);
    if (candidates.isEmpty) return;

    final recentIds = _recentEntryIds(todayKey);
    final nonRepeating = candidates
        .where((entry) => !recentIds.contains(entry.id))
        .toList(growable: false);
    final pool = nonRepeating.isEmpty ? candidates : nonRepeating;
    final selected = _deterministicPick(pool, date);

    final trimmedHistory = _trimHistory([
      ...state.history.where((item) => item.dateKey != todayKey),
      HadithDailyHistoryItem(dateKey: todayKey, entryId: selected.id),
    ], todayKey);

    state = state.copyWith(
      assignedDateKey: todayKey,
      assignedEntryId: selected.id,
      history: trimmedHistory,
    );
    _persist();
  }

  bool completeToday({DateTime? now}) {
    final date = now ?? DateTime.now();
    final todayKey = LocalStore.todayKey(date);
    if (state.completedDateKeys.contains(todayKey)) return false;

    final completed = Set<String>.from(state.completedDateKeys)..add(todayKey);
    final streak = _computeStreak(completed, date);
    final best = math.max(state.bestStreak, streak);

    state = state.copyWith(
      completedDateKeys: completed,
      currentStreak: streak,
      bestStreak: best,
      lastCompletedDateKey: todayKey,
    );
    _persist();
    return true;
  }

  List<HadithEntry> _dailyEligible(List<HadithEntry> entries) {
    final explicit = entries
        .where(
          (entry) =>
              entry.isDailyEligible &&
              entry.quranConnections.isNotEmpty &&
              entry.source.isNotEmpty &&
              entry.grading.isNotEmpty,
        )
        .toList(growable: false);
    if (explicit.isNotEmpty) return explicit;
    return entries
        .where(
          (entry) =>
              entry.quranConnections.isNotEmpty &&
              entry.source.isNotEmpty &&
              entry.grading.isNotEmpty,
        )
        .toList(growable: false);
  }

  Set<String> _recentEntryIds(String todayKey) {
    final todayDate = _dayFromKey(todayKey);
    if (todayDate == null) return <String>{};
    final threshold = todayDate.subtract(Duration(days: repeatWindowDays - 1));
    return state.history
        .where((item) {
          final date = _dayFromKey(item.dateKey);
          return date != null && !date.isBefore(threshold);
        })
        .map((item) => item.entryId)
        .toSet();
  }

  HadithEntry _deterministicPick(List<HadithEntry> pool, DateTime date) {
    final sorted = [...pool]..sort((a, b) => a.id.compareTo(b.id));
    final seed = (date.year * 372) + date.month * 31 + date.day;
    return sorted[seed % sorted.length];
  }

  List<HadithDailyHistoryItem> _trimHistory(
    List<HadithDailyHistoryItem> history,
    String todayKey,
  ) {
    final todayDate = _dayFromKey(todayKey);
    if (todayDate == null) return history;
    final threshold = todayDate.subtract(Duration(days: historyRetentionDays));
    return history
        .where((item) {
          final day = _dayFromKey(item.dateKey);
          return day != null && !day.isBefore(threshold);
        })
        .toList(growable: false);
  }

  int _computeStreak(Set<String> completed, DateTime now) {
    var cursor = DateTime(now.year, now.month, now.day);
    var streak = 0;
    while (true) {
      final key = LocalStore.todayKey(cursor);
      if (!completed.contains(key)) break;
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  DateTime? _dayFromKey(String key) => DateTime.tryParse('${key}T00:00:00');
}

class HadithDailyReflectionBundle {
  const HadithDailyReflectionBundle({
    required this.date,
    required this.dateKey,
    required this.entry,
    required this.isCompletedToday,
    required this.currentStreak,
    required this.bestStreak,
  });

  final DateTime date;
  final String dateKey;
  final HadithEntry? entry;
  final bool isCompletedToday;
  final int currentStreak;
  final int bestStreak;
}

final hadithDailyReflectionControllerProvider =
    StateNotifierProvider<
      HadithDailyReflectionController,
      HadithDailyReflectionState
    >((ref) {
      return HadithDailyReflectionController(ref.watch(localStoreProvider));
    });

// bundle provider simply exposes the current state and selected entry for
// the current date.  it is intentionally pure; side effects (assigning the
// today's entry) should happen outside of this provider so we don't mutate
// state while a provider is being built.  the landing page takes care of
// invoking the controller when it first renders.
final hadithDailyReflectionBundleProvider =
    Provider<HadithDailyReflectionBundle>((ref) {
      final now = DateTime.now();
      final todayKey = LocalStore.todayKey(now);
      final state = ref.watch(hadithDailyReflectionControllerProvider);
      final entryId = state.assignedDateKey == todayKey
          ? state.assignedEntryId
          : null;
      final entry = entryId == null
          ? null
          : ref.watch(hadithEntryByIdProvider(entryId));

      return HadithDailyReflectionBundle(
        date: now,
        dateKey: todayKey,
        entry: entry,
        isCompletedToday: state.isCompletedForDay(todayKey),
        currentStreak: state.currentStreak,
        bestStreak: state.bestStreak,
      );
    });

Future<bool> completeHadithDailyReflection(WidgetRef ref) async {
  final wasNew = ref
      .read(hadithDailyReflectionControllerProvider.notifier)
      .completeToday();
  if (!wasNew) return false;

  final snapshot = ref.read(journeyActivitySnapshotProvider);
  final nextReflectionEntries = snapshot.reflectionEntriesToday + 1;
  final adjusted = JourneyActivitySnapshot(
    now: snapshot.now,
    prayerCompletedToday: snapshot.prayerCompletedToday,
    prayerProgress: snapshot.prayerProgress,
    dhikrSessionsToday: snapshot.dhikrSessionsToday,
    dhikrProgress: snapshot.dhikrProgress,
    fastingStatus: snapshot.fastingStatus,
    quranEngagementsToday: snapshot.quranEngagementsToday,
    quranProgress: snapshot.quranProgress,
    reflectionEntriesToday: nextReflectionEntries,
    reflectionProgress: (nextReflectionEntries / 2).clamp(0.0, 1.0).toDouble(),
  );
  ref.read(journeyProgressProvider.notifier).syncFromSnapshot(adjusted);
  return true;
}
