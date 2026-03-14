import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';
import 'community_ocean.dart';

const String oceanActionPrayerCompleted = 'prayer_completed';
const String oceanActionMakeupPrayerCompleted = 'makeup_prayer_completed';
const String oceanActionOptionalPrayerCompleted = 'optional_prayer_completed';
const String oceanActionDhikrSetCompleted = 'dhikr_set_completed';
const String oceanActionDhikrFreeHundredReached = 'dhikr_free_100_reached';
const String oceanActionQuranPageCompleted = 'quran_page_completed';
const String oceanActionQuranSurahCompleted = 'quran_surah_completed';
const String oceanActionLearningSegmentCompleted = 'learning_segment_completed';
const String oceanActionLessonCompleted = 'lesson_completed';
const String oceanActionProphetStoryCompleted = 'prophet_story_completed';
const String oceanActionHadithLessonCompleted = 'hadith_lesson_completed';
const String oceanActionDuaLessonCompleted = 'dua_lesson_completed';
const String oceanActionQuizCompleted = 'quiz_completed';
const String oceanActionHabitCompleted = 'habit_completed';
const String oceanActionReflectionCompleted = 'reflection_completed';
const String oceanActionSalahTrainingCompleted = 'salah_training_completed';
const String oceanActionJournalEntryCompleted = 'journal_entry_completed';
const String oceanActionCelestialCardOpened = 'celestial_card_opened';
const String oceanActionSkyExplorerOpened = 'sky_explorer_opened';
const String oceanActionCelestialVerseOpened = 'celestial_verse_opened';
const String oceanActionCelestialObservationSaved =
    'celestial_observation_saved';
const String oceanActionCreationExplorerOpened = 'creation_explorer_opened';
const String oceanActionCreationObservationSaved =
    'creation_observation_saved';
const String oceanActionCreationReflectionWritten =
    'creation_reflection_written';
const String oceanActionCreationChallengeCompleted =
    'creation_challenge_completed';

const String oceanSourceHome = 'home';
const String oceanSourcePrayer = 'prayer';
const String oceanSourceDhikr = 'dhikr';
const String oceanSourceQuran = 'quran';
const String oceanSourceLearn = 'learn';
const String oceanSourceQuiz = 'quiz';
const String oceanSourceHabits = 'habits';
const String oceanSourceSalahTrainer = 'salah_trainer';
const String oceanSourceDua = 'dua';
const String oceanSourceNotes = 'notes';
const String oceanSourceGrowth = 'growth';
const String oceanSourceCelestial = 'celestial';
const String oceanSourceCreation = 'creation';

enum _OceanDropScope { oncePerDay, oncePerWeek, onceLifetime, perEvent }

class OceanDropEvent {
  const OceanDropEvent({
    required this.id,
    required this.timestamp,
    required this.actionType,
    required this.sourceModule,
    required this.amount,
    this.referenceId,
    this.metadata,
  });

  final String id;
  final DateTime timestamp;
  final String actionType;
  final String sourceModule;
  final int amount;
  final String? referenceId;
  final Map<String, dynamic>? metadata;

  String get dateKey => LocalStore.todayKey(timestamp);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'actionType': actionType,
        'sourceModule': sourceModule,
        'amount': amount,
        'referenceId': referenceId,
        'metadata': metadata,
      };

  static OceanDropEvent? fromJson(dynamic raw) {
    if (raw is! Map) return null;
    final id = raw['id']?.toString();
    final timestamp = DateTime.tryParse(raw['timestamp']?.toString() ?? '');
    final actionType = raw['actionType']?.toString();
    final sourceModule = raw['sourceModule']?.toString();
    if (id == null ||
        timestamp == null ||
        actionType == null ||
        sourceModule == null) {
      return null;
    }
    final metadata = raw['metadata'] is Map
        ? (raw['metadata'] as Map)
              .map((key, value) => MapEntry(key.toString(), value))
        : null;
    return OceanDropEvent(
      id: id,
      timestamp: timestamp,
      actionType: actionType,
      sourceModule: sourceModule,
      amount: (raw['amount'] as num?)?.toInt() ?? 1,
      referenceId: raw['referenceId']?.toString(),
      metadata: metadata,
    );
  }
}

class OceanDropStats {
  const OceanDropStats({
    required this.totalDropsLifetime,
    required this.dropsToday,
    required this.dropsThisWeek,
    required this.dropsThisMonth,
    required this.freeDhikrCarryCount,
    required this.lastDropAwardedAt,
  });

  final int totalDropsLifetime;
  final int dropsToday;
  final int dropsThisWeek;
  final int dropsThisMonth;
  final int freeDhikrCarryCount;
  final DateTime? lastDropAwardedAt;

  OceanDropStats copyWith({
    int? totalDropsLifetime,
    int? dropsToday,
    int? dropsThisWeek,
    int? dropsThisMonth,
    int? freeDhikrCarryCount,
    DateTime? lastDropAwardedAt,
    bool clearLastDropAwardedAt = false,
  }) {
    return OceanDropStats(
      totalDropsLifetime: totalDropsLifetime ?? this.totalDropsLifetime,
      dropsToday: dropsToday ?? this.dropsToday,
      dropsThisWeek: dropsThisWeek ?? this.dropsThisWeek,
      dropsThisMonth: dropsThisMonth ?? this.dropsThisMonth,
      freeDhikrCarryCount: freeDhikrCarryCount ?? this.freeDhikrCarryCount,
      lastDropAwardedAt: clearLastDropAwardedAt
          ? null
          : (lastDropAwardedAt ?? this.lastDropAwardedAt),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'totalDropsLifetime': totalDropsLifetime,
        'dropsToday': dropsToday,
        'dropsThisWeek': dropsThisWeek,
        'dropsThisMonth': dropsThisMonth,
        'freeDhikrCarryCount': freeDhikrCarryCount,
        'lastDropAwardedAt': lastDropAwardedAt?.toIso8601String(),
      };

  static OceanDropStats fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const OceanDropStats(
        totalDropsLifetime: 0,
        dropsToday: 0,
        dropsThisWeek: 0,
        dropsThisMonth: 0,
        freeDhikrCarryCount: 0,
        lastDropAwardedAt: null,
      );
    }
    return OceanDropStats(
      totalDropsLifetime: (json['totalDropsLifetime'] as num?)?.toInt() ?? 0,
      dropsToday: (json['dropsToday'] as num?)?.toInt() ?? 0,
      dropsThisWeek: (json['dropsThisWeek'] as num?)?.toInt() ?? 0,
      dropsThisMonth: (json['dropsThisMonth'] as num?)?.toInt() ?? 0,
      freeDhikrCarryCount: (json['freeDhikrCarryCount'] as num?)?.toInt() ?? 0,
      lastDropAwardedAt:
          DateTime.tryParse(json['lastDropAwardedAt']?.toString() ?? ''),
    );
  }
}

class OceanDropsState {
  const OceanDropsState({
    required this.stats,
    required this.personalStats,
    required this.communityStats,
    required this.events,
    required this.dailyDropHistory,
    required this.awardedEligibilityKeys,
    required this.freeDhikrBlocksAwarded,
    required this.communityBaselineDrops,
  });

  final OceanDropStats stats;
  final PersonalWaterStats personalStats;
  final CommunityOceanStats communityStats;
  final List<OceanDropEvent> events;
  final Map<String, int> dailyDropHistory;
  final Set<String> awardedEligibilityKeys;
  final int freeDhikrBlocksAwarded;
  final BigInt communityBaselineDrops;

  int get totalLocalDrops => personalStats.totalPersonalDrops.toInt();
  int get todayDrops => stats.dropsToday;
  int get weekDrops => stats.dropsThisWeek;
  int get monthDrops => stats.dropsThisMonth;
  int get freeDhikrCarryCount => stats.freeDhikrCarryCount;
  BigInt get totalCommunityDrops => communityStats.totalCommunityDrops;

  String get symbolicStage {
    if (totalLocalDrops >= 5000) return 'vast';
    if (totalLocalDrops >= 2500) return 'rising';
    if (totalLocalDrops >= 1200) return 'flowing';
    if (totalLocalDrops >= 500) return 'stream';
    return 'spring';
  }

  OceanDropsState copyWith({
    OceanDropStats? stats,
    PersonalWaterStats? personalStats,
    CommunityOceanStats? communityStats,
    List<OceanDropEvent>? events,
    Map<String, int>? dailyDropHistory,
    Set<String>? awardedEligibilityKeys,
    int? freeDhikrBlocksAwarded,
    BigInt? communityBaselineDrops,
  }) {
    return OceanDropsState(
      stats: stats ?? this.stats,
      personalStats: personalStats ?? this.personalStats,
      communityStats: communityStats ?? this.communityStats,
      events: events ?? this.events,
      dailyDropHistory: dailyDropHistory ?? this.dailyDropHistory,
      awardedEligibilityKeys:
          awardedEligibilityKeys ?? this.awardedEligibilityKeys,
      freeDhikrBlocksAwarded:
          freeDhikrBlocksAwarded ?? this.freeDhikrBlocksAwarded,
      communityBaselineDrops:
          communityBaselineDrops ?? this.communityBaselineDrops,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'stats': stats.toJson(),
        'personalStats': personalStats.toJson(),
        'communityStats': communityStats.toJson(),
        'events': events.map((event) => event.toJson()).toList(),
        'dailyDropHistory': dailyDropHistory,
        'awardedEligibilityKeys': awardedEligibilityKeys.toList(),
        'freeDhikrBlocksAwarded': freeDhikrBlocksAwarded,
        'communityBaselineDrops': communityBaselineDrops.toString(),
      };

  static OceanDropsState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return OceanDropsState(
        stats: OceanDropStats.fromJson(null),
        personalStats: PersonalWaterStats.fromJson(null),
        communityStats: CommunityOceanStats.fromJson(null),
        events: const <OceanDropEvent>[],
        dailyDropHistory: const <String, int>{},
        awardedEligibilityKeys: const <String>{},
        freeDhikrBlocksAwarded: 0,
        communityBaselineDrops: BigInt.from(500000),
      );
    }
    final events = <OceanDropEvent>[];
    for (final row in (json['events'] as List? ?? const <dynamic>[])) {
      final parsed = OceanDropEvent.fromJson(row);
      if (parsed != null) events.add(parsed);
    }
    return OceanDropsState(
      stats: OceanDropStats.fromJson(
        (json['stats'] as Map?)?.map((key, value) => MapEntry(key.toString(), value)),
      ),
      personalStats: PersonalWaterStats.fromJson(
        (json['personalStats'] as Map?)
            ?.map((key, value) => MapEntry(key.toString(), value)),
      ),
      communityStats: CommunityOceanStats.fromJson(
        (json['communityStats'] as Map?)
            ?.map((key, value) => MapEntry(key.toString(), value)),
      ),
      events: events,
      dailyDropHistory: ((json['dailyDropHistory'] as Map?) ?? const {})
          .map((key, value) => MapEntry(key.toString(), (value as num?)?.toInt() ?? 0)),
      awardedEligibilityKeys: (json['awardedEligibilityKeys'] as List? ?? const [])
          .map((item) => item.toString())
          .toSet(),
      freeDhikrBlocksAwarded:
          (json['freeDhikrBlocksAwarded'] as num?)?.toInt() ?? 0,
      communityBaselineDrops:
          parseBigInt(json['communityBaselineDrops'], fallback: BigInt.from(500000)),
    );
  }
}

class OceanDropService extends StateNotifier<OceanDropsState> {
  OceanDropService(
    this._store, {
    CommunityOceanSyncAdapter communitySyncAdapter =
        const LocalCommunityOceanSyncAdapter(),
  })  : _communitySyncAdapter = communitySyncAdapter,
        super(OceanDropsState.fromJson(_store.getJsonMap(_storageKey))) {
    _refreshStats();
  }

  static const _storageKey = 'journey.oceanDrops.v2';

  final LocalStore _store;
  final CommunityOceanSyncAdapter _communitySyncAdapter;

  int awardDrop({
    required String actionType,
    required String sourceModule,
    String? referenceId,
    Map<String, dynamic>? metadata,
  }) {
    if (actionType == oceanActionDhikrFreeHundredReached) {
      return _awardFreeDhikrDrops(
        sourceModule: sourceModule,
        referenceId: referenceId,
        metadata: metadata,
      );
    }

    final now = _timestampFromMetadata(metadata) ?? DateTime.now();
    final dayKey = LocalStore.todayKey(now);
    final eligibilityKey = _eligibilityKeyFor(
      actionType: actionType,
      sourceModule: sourceModule,
      referenceId: referenceId,
      metadata: metadata,
      timestamp: now,
    );
    if (eligibilityKey != null &&
        state.awardedEligibilityKeys.contains(eligibilityKey)) {
      return 0;
    }

    final event = OceanDropEvent(
      id: eligibilityKey ??
          '${actionType}_${referenceId ?? sourceModule}_${now.microsecondsSinceEpoch}',
      timestamp: now,
      actionType: actionType,
      sourceModule: sourceModule,
      amount: 1,
      referenceId: referenceId,
      metadata: metadata,
    );

    final nextHistory = Map<String, int>.from(state.dailyDropHistory)
      ..update(dayKey, (value) => value + 1, ifAbsent: () => 1);
    final nextKeys = Set<String>.from(state.awardedEligibilityKeys);
    if (eligibilityKey != null) nextKeys.add(eligibilityKey);

    state = state.copyWith(
      events: [event, ...state.events].take(2000).toList(),
      dailyDropHistory: nextHistory,
      awardedEligibilityKeys: nextKeys,
      stats: state.stats.copyWith(lastDropAwardedAt: now),
    );
    _refreshStats();
    _persist();
    return 1;
  }

  int _awardFreeDhikrDrops({
    required String sourceModule,
    String? referenceId,
    Map<String, dynamic>? metadata,
  }) {
    final delta = (metadata?['countDelta'] as num?)?.toInt() ?? 0;
    if (delta <= 0) return 0;
    final now = _timestampFromMetadata(metadata) ?? DateTime.now();
    final total = state.stats.freeDhikrCarryCount + delta;
    final newDrops = total ~/ 100;
    final carry = total % 100;

    if (newDrops <= 0) {
      state = state.copyWith(
        stats: state.stats.copyWith(
          freeDhikrCarryCount: carry,
          lastDropAwardedAt: state.stats.lastDropAwardedAt,
        ),
      );
      _persist();
      return 0;
    }

    final nextHistory = Map<String, int>.from(state.dailyDropHistory);
    final nextKeys = Set<String>.from(state.awardedEligibilityKeys);
    final nextEvents = List<OceanDropEvent>.from(state.events);
    var awarded = 0;
    var blocksAwarded = state.freeDhikrBlocksAwarded;

    for (var i = 0; i < newDrops; i += 1) {
      blocksAwarded += 1;
      final milestoneId =
          'dhikr_free_100_reached:${referenceId ?? 'global'}:$blocksAwarded';
      if (nextKeys.contains(milestoneId)) {
        continue;
      }
      nextKeys.add(milestoneId);
      final timestamp = now.add(Duration(milliseconds: i));
      final dayKey = LocalStore.todayKey(timestamp);
      nextHistory.update(dayKey, (value) => value + 1, ifAbsent: () => 1);
      nextEvents.insert(
        0,
        OceanDropEvent(
          id: milestoneId,
          timestamp: timestamp,
          actionType: oceanActionDhikrFreeHundredReached,
          sourceModule: sourceModule,
          amount: 1,
          referenceId: referenceId,
          metadata: {
            ...?metadata,
            'milestone': blocksAwarded * 100,
          },
        ),
      );
      awarded += 1;
    }

    state = state.copyWith(
      events: nextEvents.take(2000).toList(),
      dailyDropHistory: nextHistory,
      awardedEligibilityKeys: nextKeys,
      freeDhikrBlocksAwarded: blocksAwarded,
      stats: state.stats.copyWith(
        freeDhikrCarryCount: carry,
        lastDropAwardedAt: awarded > 0 ? now : state.stats.lastDropAwardedAt,
      ),
    );
    _refreshStats();
    _persist();
    return awarded;
  }

  int getTotalDrops() => state.stats.totalDropsLifetime;
  int getDropsToday() => state.stats.dropsToday;
  int getDropsThisWeek() => state.stats.dropsThisWeek;
  int getDropsThisMonth() => state.stats.dropsThisMonth;
  Map<String, int> getDailyDropHistory() =>
      Map<String, int>.from(state.dailyDropHistory);
  PersonalWaterStats getPersonalWaterStats() => state.personalStats;
  CommunityOceanStats getCommunityOceanStats() => state.communityStats;

  void updateCommunityBaseline(BigInt totalDrops) {
    final baseline = totalDrops > BigInt.zero ? totalDrops : BigInt.zero;
    if (baseline == state.communityBaselineDrops) return;
    state = state.copyWith(communityBaselineDrops: baseline);
    _refreshStats();
    _persist();
  }

  void _refreshStats() {
    final now = DateTime.now();
    final todayKey = LocalStore.todayKey(now);
    final startOfWeek = _startOfWeek(now);
    final startOfMonth = DateTime(now.year, now.month, 1);

    var week = 0;
    var month = 0;
    for (final entry in state.dailyDropHistory.entries) {
      final date = DateTime.tryParse(entry.key);
      if (date == null) continue;
      if (!date.isBefore(startOfWeek)) week += entry.value;
      if (!date.isBefore(startOfMonth)) month += entry.value;
    }

    final totalPersonalDrops = BigInt.from(
      state.dailyDropHistory.values.fold<int>(
        0,
        (sum, count) => sum + count,
      ),
    );
    final baseline = _communitySyncAdapter.resolveBaseline(
      state.communityBaselineDrops,
    );
    final totalCommunityDrops = baseline + totalPersonalDrops;
    final todayCommunityDrops = BigInt.from(state.dailyDropHistory[todayKey] ?? 0);
    final weekCommunityDrops = BigInt.from(week);
    final monthCommunityDrops = BigInt.from(month);

    state = state.copyWith(
      stats: state.stats.copyWith(
        totalDropsLifetime: totalPersonalDrops.toInt(),
        dropsToday: state.dailyDropHistory[todayKey] ?? 0,
        dropsThisWeek: week,
        dropsThisMonth: month,
      ),
      personalStats: state.personalStats.copyWith(
        totalPersonalDrops: totalPersonalDrops,
        personalDropsToday: state.dailyDropHistory[todayKey] ?? 0,
        personalDropsThisWeek: week,
        personalDropsThisMonth: month,
        lastContributionAt: state.stats.lastDropAwardedAt,
      ),
      communityStats: state.communityStats.copyWith(
        totalCommunityDrops: totalCommunityDrops,
        todayCommunityDrops: todayCommunityDrops,
        thisWeekCommunityDrops: weekCommunityDrops,
        thisMonthCommunityDrops: monthCommunityDrops,
        lastUpdatedAt: now,
      ),
      communityBaselineDrops: baseline,
    );
  }

  DateTime _startOfWeek(DateTime value) {
    final day = DateTime(value.year, value.month, value.day);
    return day.subtract(Duration(days: day.weekday - 1));
  }

  DateTime? _timestampFromMetadata(Map<String, dynamic>? metadata) {
    final raw = metadata?['timestamp']?.toString();
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  String? _eligibilityKeyFor({
    required String actionType,
    required String sourceModule,
    required String? referenceId,
    required Map<String, dynamic>? metadata,
    required DateTime timestamp,
  }) {
    final scope = _scopeFor(actionType);
    final effectiveRef = referenceId ??
        metadata?['referenceId']?.toString() ??
        metadata?['slot']?.toString() ??
        metadata?['page']?.toString();
    switch (scope) {
      case _OceanDropScope.oncePerDay:
        return '$actionType|$sourceModule|${effectiveRef ?? 'global'}|${LocalStore.todayKey(timestamp)}';
      case _OceanDropScope.oncePerWeek:
        return '$actionType|$sourceModule|${effectiveRef ?? 'global'}|${LocalStore.todayKey(_startOfWeek(timestamp))}';
      case _OceanDropScope.onceLifetime:
        return '$actionType|$sourceModule|${effectiveRef ?? 'global'}';
      case _OceanDropScope.perEvent:
        if (effectiveRef == null || effectiveRef.isEmpty) return null;
        return '$actionType|$sourceModule|$effectiveRef';
    }
  }

  _OceanDropScope _scopeFor(String actionType) {
    switch (actionType) {
      case oceanActionPrayerCompleted:
      case oceanActionMakeupPrayerCompleted:
      case oceanActionOptionalPrayerCompleted:
      case oceanActionHabitCompleted:
      case oceanActionQuranPageCompleted:
      case oceanActionCelestialCardOpened:
      case oceanActionSkyExplorerOpened:
      case oceanActionCelestialVerseOpened:
      case oceanActionCreationExplorerOpened:
        return _OceanDropScope.oncePerDay;
      case oceanActionLearningSegmentCompleted:
      case oceanActionLessonCompleted:
      case oceanActionProphetStoryCompleted:
      case oceanActionHadithLessonCompleted:
      case oceanActionDuaLessonCompleted:
      case oceanActionQuizCompleted:
      case oceanActionQuranSurahCompleted:
      case oceanActionSalahTrainingCompleted:
        return _OceanDropScope.onceLifetime;
      case oceanActionDhikrSetCompleted:
      case oceanActionReflectionCompleted:
      case oceanActionJournalEntryCompleted:
      case oceanActionCelestialObservationSaved:
      case oceanActionCreationObservationSaved:
      case oceanActionCreationReflectionWritten:
      case oceanActionCreationChallengeCompleted:
        return _OceanDropScope.perEvent;
      case oceanActionDhikrFreeHundredReached:
        return _OceanDropScope.perEvent;
    }
    return _OceanDropScope.perEvent;
  }

  void _persist() {
    _store.setJsonMap(_storageKey, state.toJson());
  }
}

final communityOceanSyncAdapterProvider =
    Provider<CommunityOceanSyncAdapter>((ref) {
  return const LocalCommunityOceanSyncAdapter();
});

final oceanDropsProvider =
    StateNotifierProvider<OceanDropService, OceanDropsState>((ref) {
      return OceanDropService(
        ref.watch(localStoreProvider),
        communitySyncAdapter: ref.watch(communityOceanSyncAdapterProvider),
      );
    });

final oceanDropServiceProvider = Provider<OceanDropService>((ref) {
  return ref.read(oceanDropsProvider.notifier);
});

final oceanDropsAutoSyncProvider = Provider<void>((ref) {});
final oceanDropsDerivedSyncProvider = Provider<void>((ref) {});

final personalWaterStatsProvider = Provider<PersonalWaterStats>((ref) {
  return ref.watch(oceanDropsProvider.select((state) => state.personalStats));
});

final communityOceanStatsProvider = Provider<CommunityOceanStats>((ref) {
  return ref.watch(oceanDropsProvider.select((state) => state.communityStats));
});

final communityOceanStageProgressProvider =
    Provider<StageProgress<CommunityOceanStage>>((ref) {
  final stats = ref.watch(communityOceanStatsProvider);
  return CommunityOceanLogic.getCommunityStageProgress(
    stats.totalCommunityDrops,
  );
});

final personalWaterStageProgressProvider =
    Provider<StageProgress<PersonalWaterStage>>((ref) {
  final stats = ref.watch(personalWaterStatsProvider);
  return CommunityOceanLogic.getPersonalStageProgress(
    stats.totalPersonalDrops,
  );
});

final oceanGroupedHistoryProvider =
    Provider<Map<String, Map<String, int>>>((ref) {
      final state = ref.watch(oceanDropsProvider);
      final grouped = <String, Map<String, int>>{};
      for (final event in state.events) {
        final day = grouped.putIfAbsent(
          event.dateKey,
          () => <String, int>{},
        );
        day[event.sourceModule] = (day[event.sourceModule] ?? 0) + event.amount;
      }
      return grouped;
    });

final oceanMilestoneThresholdsProvider = Provider<List<int>>((ref) {
  return const <int>[100, 300, 500, 1200, 2500, 5000];
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
  final Map<String, int> sources;
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
    final span = math.max(1, threshold - previous);
    final inBand = (state.totalLocalDrops - previous).clamp(0, span);
    result.add(
      OceanMilestoneProgress(
        threshold: threshold,
        reached: state.totalLocalDrops >= threshold,
        progressToNext: (inBand / span).clamp(0.0, 1.0).toDouble(),
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
      sources: Map<String, int>.from(entry.value),
    );
  }).toList();
});
