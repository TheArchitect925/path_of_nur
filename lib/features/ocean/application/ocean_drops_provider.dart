import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../journal/application/journal_provider.dart';
import '../../../shared/persistence/local_store.dart';
import '../../journey/application/journey_progression_provider.dart';

enum OceanDropSource {
  prayer,
  dhikr,
  fasting,
  quran,
  reflection,
  learning,
  milestone,
}

class OceanDropEvent {
  const OceanDropEvent({
    required this.source,
    required this.drops,
    required this.dateKey,
  });

  final OceanDropSource source;
  final int drops;
  final String dateKey;

  Map<String, dynamic> toJson() => {
    'source': source.name,
    'drops': drops,
    'dateKey': dateKey,
  };

  static OceanDropEvent? fromJson(dynamic raw) {
    if (raw is! Map) return null;
    final sourceName = raw['source']?.toString();
    final drops = raw['drops'];
    final dateKey = raw['dateKey']?.toString();
    if (sourceName == null || drops is! int || dateKey == null) return null;
    OceanDropSource? source;
    for (final item in OceanDropSource.values) {
      if (item.name == sourceName) {
        source = item;
        break;
      }
    }
    if (source == null) return null;
    return OceanDropEvent(source: source, drops: drops, dateKey: dateKey);
  }
}

class OceanDropsState {
  const OceanDropsState({
    required this.totalLocalDrops,
    required this.todayDrops,
    required this.weekDrops,
    required this.events,
    required this.communityPlaceholderDrops,
    required this.lastSyncDayKey,
    required this.lastPrayerCompleted,
    required this.lastDhikrSessions,
    required this.lastQuranEngagements,
    required this.lastReflectionEntries,
    required this.lastFastingCompleted,
    required this.lastLearningCompletions,
    required this.lastUnlockedMilestones,
  });

  final int totalLocalDrops;
  final int todayDrops;
  final int weekDrops;
  final List<OceanDropEvent> events;
  final int communityPlaceholderDrops;
  final String lastSyncDayKey;
  final int lastPrayerCompleted;
  final int lastDhikrSessions;
  final int lastQuranEngagements;
  final int lastReflectionEntries;
  final int lastFastingCompleted;
  final int lastLearningCompletions;
  final int lastUnlockedMilestones;

  String get symbolicStage {
    if (totalLocalDrops >= 5000) return 'vast';
    if (totalLocalDrops >= 2500) return 'rising';
    if (totalLocalDrops >= 1200) return 'flowing';
    if (totalLocalDrops >= 500) return 'stream';
    return 'spring';
  }

  OceanDropsState copyWith({
    int? totalLocalDrops,
    int? todayDrops,
    int? weekDrops,
    List<OceanDropEvent>? events,
    int? communityPlaceholderDrops,
    String? lastSyncDayKey,
    int? lastPrayerCompleted,
    int? lastDhikrSessions,
    int? lastQuranEngagements,
    int? lastReflectionEntries,
    int? lastFastingCompleted,
    int? lastLearningCompletions,
    int? lastUnlockedMilestones,
  }) {
    return OceanDropsState(
      totalLocalDrops: totalLocalDrops ?? this.totalLocalDrops,
      todayDrops: todayDrops ?? this.todayDrops,
      weekDrops: weekDrops ?? this.weekDrops,
      events: events ?? this.events,
      communityPlaceholderDrops:
          communityPlaceholderDrops ?? this.communityPlaceholderDrops,
      lastSyncDayKey: lastSyncDayKey ?? this.lastSyncDayKey,
      lastPrayerCompleted: lastPrayerCompleted ?? this.lastPrayerCompleted,
      lastDhikrSessions: lastDhikrSessions ?? this.lastDhikrSessions,
      lastQuranEngagements: lastQuranEngagements ?? this.lastQuranEngagements,
      lastReflectionEntries:
          lastReflectionEntries ?? this.lastReflectionEntries,
      lastFastingCompleted: lastFastingCompleted ?? this.lastFastingCompleted,
      lastLearningCompletions:
          lastLearningCompletions ?? this.lastLearningCompletions,
      lastUnlockedMilestones:
          lastUnlockedMilestones ?? this.lastUnlockedMilestones,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalLocalDrops': totalLocalDrops,
    'todayDrops': todayDrops,
    'weekDrops': weekDrops,
    'events': events.map((e) => e.toJson()).toList(),
    'communityPlaceholderDrops': communityPlaceholderDrops,
    'lastSyncDayKey': lastSyncDayKey,
    'lastPrayerCompleted': lastPrayerCompleted,
    'lastDhikrSessions': lastDhikrSessions,
    'lastQuranEngagements': lastQuranEngagements,
    'lastReflectionEntries': lastReflectionEntries,
    'lastFastingCompleted': lastFastingCompleted,
    'lastLearningCompletions': lastLearningCompletions,
    'lastUnlockedMilestones': lastUnlockedMilestones,
  };

  static OceanDropsState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const OceanDropsState(
        totalLocalDrops: 0,
        todayDrops: 0,
        weekDrops: 0,
        events: [],
        communityPlaceholderDrops: 500000,
        lastSyncDayKey: '',
        lastPrayerCompleted: 0,
        lastDhikrSessions: 0,
        lastQuranEngagements: 0,
        lastReflectionEntries: 0,
        lastFastingCompleted: 0,
        lastLearningCompletions: 0,
        lastUnlockedMilestones: 0,
      );
    }
    final rawEvents = json['events'];
    final events = <OceanDropEvent>[];
    if (rawEvents is List) {
      for (final row in rawEvents) {
        final parsed = OceanDropEvent.fromJson(row);
        if (parsed != null) {
          events.add(parsed);
        }
      }
    }

    return OceanDropsState(
      totalLocalDrops: json['totalLocalDrops'] as int? ?? 0,
      todayDrops: json['todayDrops'] as int? ?? 0,
      weekDrops: json['weekDrops'] as int? ?? 0,
      events: events,
      communityPlaceholderDrops:
          json['communityPlaceholderDrops'] as int? ?? 500000,
      lastSyncDayKey: json['lastSyncDayKey'] as String? ?? '',
      lastPrayerCompleted: json['lastPrayerCompleted'] as int? ?? 0,
      lastDhikrSessions: json['lastDhikrSessions'] as int? ?? 0,
      lastQuranEngagements: json['lastQuranEngagements'] as int? ?? 0,
      lastReflectionEntries: json['lastReflectionEntries'] as int? ?? 0,
      lastFastingCompleted: json['lastFastingCompleted'] as int? ?? 0,
      lastLearningCompletions: json['lastLearningCompletions'] as int? ?? 0,
      lastUnlockedMilestones: json['lastUnlockedMilestones'] as int? ?? 0,
    );
  }
}

const oceanDropRules = <OceanDropSource, int>{
  OceanDropSource.prayer: 6,
  OceanDropSource.dhikr: 4,
  OceanDropSource.fasting: 12,
  OceanDropSource.quran: 5,
  OceanDropSource.reflection: 5,
  OceanDropSource.learning: 3,
  OceanDropSource.milestone: 10,
};

class OceanDropsNotifier extends StateNotifier<OceanDropsState> {
  OceanDropsNotifier(this._store)
    : super(OceanDropsState.fromJson(_store.getJsonMap(_storageKey))) {
    _recalculateTimeWindows();
  }

  static const _storageKey = 'journey.oceanDrops';
  final LocalStore _store;

  void trackSource(OceanDropSource source, {int multiplier = 1}) {
    final amount = (oceanDropRules[source] ?? 0) * multiplier;
    if (amount <= 0) return;
    final today = LocalStore.todayKey();

    final nextEvents = <OceanDropEvent>[
      OceanDropEvent(source: source, drops: amount, dateKey: today),
      ...state.events,
    ].take(500).toList();

    state = state.copyWith(
      totalLocalDrops: state.totalLocalDrops + amount,
      events: nextEvents,
    );
    _recalculateTimeWindows();
    _save();
  }

  void syncFromSnapshot(JourneyActivitySnapshot snapshot) {
    final dayKey = LocalStore.todayKey(snapshot.now);
    var baselinePrayer = state.lastPrayerCompleted;
    var baselineDhikr = state.lastDhikrSessions;
    var baselineQuran = state.lastQuranEngagements;
    var baselineReflection = state.lastReflectionEntries;
    var baselineFasting = state.lastFastingCompleted;

    if (state.lastSyncDayKey != dayKey) {
      baselinePrayer = 0;
      baselineDhikr = 0;
      baselineQuran = 0;
      baselineReflection = 0;
      baselineFasting = 0;
    }

    final deltaPrayer = snapshot.prayerCompletedToday - baselinePrayer;
    final deltaDhikr = snapshot.dhikrSessionsToday - baselineDhikr;
    final deltaQuran = snapshot.quranEngagementsToday - baselineQuran;
    final deltaReflection =
        snapshot.reflectionEntriesToday - baselineReflection;
    final deltaFasting =
        (snapshot.fastingCompletedToday ? 1 : 0) - baselineFasting;

    if (deltaPrayer > 0) {
      trackSource(OceanDropSource.prayer, multiplier: deltaPrayer);
    }
    if (deltaDhikr > 0) {
      trackSource(OceanDropSource.dhikr, multiplier: deltaDhikr);
    }
    if (deltaQuran > 0) {
      trackSource(OceanDropSource.quran, multiplier: deltaQuran);
    }
    if (deltaReflection > 0) {
      trackSource(OceanDropSource.reflection, multiplier: deltaReflection);
    }
    if (deltaFasting > 0) {
      trackSource(OceanDropSource.fasting, multiplier: deltaFasting);
    }

    state = state.copyWith(
      lastSyncDayKey: dayKey,
      lastPrayerCompleted: snapshot.prayerCompletedToday,
      lastDhikrSessions: snapshot.dhikrSessionsToday,
      lastQuranEngagements: snapshot.quranEngagementsToday,
      lastReflectionEntries: snapshot.reflectionEntriesToday,
      lastFastingCompleted: snapshot.fastingCompletedToday ? 1 : 0,
    );
    _save();
  }

  void syncDerived({
    required int learningCompletions,
    required int unlockedMilestones,
  }) {
    final deltaLearning = learningCompletions - state.lastLearningCompletions;
    final deltaMilestones = unlockedMilestones - state.lastUnlockedMilestones;

    if (deltaLearning > 0) {
      trackSource(OceanDropSource.learning, multiplier: deltaLearning);
    }
    if (deltaMilestones > 0) {
      trackSource(OceanDropSource.milestone, multiplier: deltaMilestones);
    }

    if (deltaLearning <= 0 && deltaMilestones <= 0) return;

    state = state.copyWith(
      lastLearningCompletions: learningCompletions,
      lastUnlockedMilestones: unlockedMilestones,
    );
    _save();
  }

  void _recalculateTimeWindows() {
    final now = DateTime.now();
    final todayKey = LocalStore.todayKey(now);
    final weekThreshold = now.subtract(const Duration(days: 6));

    var today = 0;
    var week = 0;

    for (final event in state.events) {
      if (event.dateKey == todayKey) {
        today += event.drops;
      }
      final date = DateTime.tryParse(event.dateKey);
      if (date != null &&
          !date.isBefore(
            DateTime(
              weekThreshold.year,
              weekThreshold.month,
              weekThreshold.day,
            ),
          )) {
        week += event.drops;
      }
    }

    state = state.copyWith(todayDrops: today, weekDrops: week);
  }

  void _save() {
    _store.setJsonMap(_storageKey, state.toJson());
  }
}

final oceanDropsProvider =
    StateNotifierProvider<OceanDropsNotifier, OceanDropsState>(
      (ref) => OceanDropsNotifier(ref.watch(localStoreProvider)),
    );

final oceanDropsAutoSyncProvider = Provider<void>((ref) {
  ref.listen<JourneyActivitySnapshot>(journeyActivitySnapshotProvider, (
    _,
    snapshot,
  ) {
    Future<void>.microtask(
      () => ref.read(oceanDropsProvider.notifier).syncFromSnapshot(snapshot),
    );
  }, fireImmediately: true);
});

final oceanDropsDerivedSyncProvider = Provider<void>((ref) {
  ref.listen<JourneyComputedProgress>(journeyComputedProgressProvider, (
    _,
    next,
  ) {
    Future<void>.microtask(() {
      final progress = next;
      final journal = ref.read(journalProvider);
      final learningCompletions = journal.entries
          .where((entry) => entry.type == JournalEntryType.learning)
          .length;
      final unlockedMilestones = progress.unlockedMilestoneKeys.length;
      ref
          .read(oceanDropsProvider.notifier)
          .syncDerived(
            learningCompletions: learningCompletions,
            unlockedMilestones: unlockedMilestones,
          );
    });
  }, fireImmediately: true);
});

final oceanGroupedHistoryProvider =
    Provider<Map<String, Map<OceanDropSource, int>>>((ref) {
      final state = ref.watch(oceanDropsProvider);
      final grouped = <String, Map<OceanDropSource, int>>{};
      for (final event in state.events) {
        final day = grouped.putIfAbsent(
          event.dateKey,
          () => <OceanDropSource, int>{},
        );
        day[event.source] = (day[event.source] ?? 0) + event.drops;
      }
      return grouped;
    });

final oceanMilestoneThresholdsProvider = Provider<List<int>>((ref) {
  return const [100, 300, 500, 1200, 2500, 5000];
});

class OceanMilestoneProgress {
  const OceanMilestoneProgress({
    required this.threshold,
    required this.reached,
    required this.progressToNext,
  });

  final int threshold;
  final bool reached;
  final double progressToNext;
}

class OceanTimelinePoint {
  const OceanTimelinePoint({
    required this.label,
    required this.totalDrops,
    required this.sources,
  });

  final String label;
  final int totalDrops;
  final Map<OceanDropSource, int> sources;
}

final oceanProgressionMapProvider = Provider<List<OceanMilestoneProgress>>((
  ref,
) {
  final state = ref.watch(oceanDropsProvider);
  final milestones = ref.watch(oceanMilestoneThresholdsProvider);
  final result = <OceanMilestoneProgress>[];
  for (var i = 0; i < milestones.length; i += 1) {
    final threshold = milestones[i];
    final previous = i == 0 ? 0 : milestones[i - 1];
    final span = (threshold - previous).clamp(1, 100000);
    final clamped = (state.totalLocalDrops - previous).clamp(0, span);
    result.add(
      OceanMilestoneProgress(
        threshold: threshold,
        reached: state.totalLocalDrops >= threshold,
        progressToNext: (clamped / span).clamp(0.0, 1.0).toDouble(),
      ),
    );
  }
  return result;
});

final oceanHistoricalTimelineProvider = Provider<List<OceanTimelinePoint>>((
  ref,
) {
  final grouped = ref.watch(oceanGroupedHistoryProvider);
  final ordered = grouped.entries.toList()
    ..sort((a, b) => b.key.compareTo(a.key));
  return ordered.take(12).map((entry) {
    final total = entry.value.values.fold<int>(0, (sum, value) => sum + value);
    return OceanTimelinePoint(
      label: entry.key,
      totalDrops: total,
      sources: Map<OceanDropSource, int>.from(entry.value),
    );
  }).toList();
});
