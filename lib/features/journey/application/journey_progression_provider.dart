import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';
import '../../learn/quran/application/quran_providers.dart';
import '../../worship/domain/prayer_status.dart';
import '../../worship/application/dhikr_controller.dart';
import '../../worship/application/fasting_controller.dart';
import '../../worship/application/prayer_controller.dart';
import '../../worship/domain/fasting_status.dart';
import '../../../core/prayer/prayer_preferences.dart';

const _journeyProgressKey = 'journey.progress.v2';

class JourneyXpRules {
  const JourneyXpRules._();

  static const int xpPerPrayerCompleted = 24;
  static const int xpPerDhikrSession = 14;
  static const int xpPerFastingCompleted = 36;
  static const int xpPerFastingIntending = 8;
  static const int xpPerQuranEngagement = 18;
  static const int xpPerReflectionEntry = 12;

  static const double streakCompletionThreshold = 0.60;

  static int xpRequiredForLevel(int level) {
    if (level <= 1) return 0;
    final base = level - 1;
    return 120 * base * base;
  }

  static int levelForXp(int xp) {
    var level = 1;
    while (xp >= xpRequiredForLevel(level + 1)) {
      level += 1;
      if (level >= 1000) break;
    }
    return level;
  }
}

class JourneyActivitySnapshot {
  const JourneyActivitySnapshot({
    required this.now,
    required this.prayerCompletedToday,
    required this.prayerMissedToday,
    required this.fajrCompletedToday,
    required this.prayerProgress,
    required this.dhikrSessionsToday,
    required this.dhikrCountToday,
    required this.dhikrProgress,
    required this.fastingStatus,
    required this.quranEngagementsToday,
    required this.quranProgress,
    required this.reflectionEntriesToday,
    required this.reflectionProgress,
  });

  final DateTime now;
  final int prayerCompletedToday;
  final int prayerMissedToday;
  final bool fajrCompletedToday;
  final double prayerProgress;
  final int dhikrSessionsToday;
  final int dhikrCountToday;
  final double dhikrProgress;
  final FastingStatus fastingStatus;
  final int quranEngagementsToday;
  final double quranProgress;
  final int reflectionEntriesToday;
  final double reflectionProgress;

  JourneyActivitySnapshot copyWith({
    DateTime? now,
    int? prayerCompletedToday,
    int? prayerMissedToday,
    bool? fajrCompletedToday,
    double? prayerProgress,
    int? dhikrSessionsToday,
    int? dhikrCountToday,
    double? dhikrProgress,
    FastingStatus? fastingStatus,
    int? quranEngagementsToday,
    double? quranProgress,
    int? reflectionEntriesToday,
    double? reflectionProgress,
  }) {
    return JourneyActivitySnapshot(
      now: now ?? this.now,
      prayerCompletedToday: prayerCompletedToday ?? this.prayerCompletedToday,
      prayerMissedToday: prayerMissedToday ?? this.prayerMissedToday,
      fajrCompletedToday: fajrCompletedToday ?? this.fajrCompletedToday,
      prayerProgress: prayerProgress ?? this.prayerProgress,
      dhikrSessionsToday: dhikrSessionsToday ?? this.dhikrSessionsToday,
      dhikrCountToday: dhikrCountToday ?? this.dhikrCountToday,
      dhikrProgress: dhikrProgress ?? this.dhikrProgress,
      fastingStatus: fastingStatus ?? this.fastingStatus,
      quranEngagementsToday:
          quranEngagementsToday ?? this.quranEngagementsToday,
      quranProgress: quranProgress ?? this.quranProgress,
      reflectionEntriesToday:
          reflectionEntriesToday ?? this.reflectionEntriesToday,
      reflectionProgress: reflectionProgress ?? this.reflectionProgress,
    );
  }

  bool get fastingCompletedToday => fastingStatus == FastingStatus.completed;
  bool get fastingIntendingToday => fastingStatus == FastingStatus.intending;

  double get fastingProgress {
    if (fastingStatus == FastingStatus.completed) return 1;
    if (fastingStatus == FastingStatus.intending) return 0.55;
    if (fastingStatus == FastingStatus.notFasting) return 0.1;
    return 0.2;
  }

  double get dailyCompletionScore {
    return ((prayerProgress +
                dhikrProgress +
                quranProgress +
                reflectionProgress +
                fastingProgress) /
            5)
        .clamp(0.0, 1.0)
        .toDouble();
  }
}

class JourneyDayMetrics {
  const JourneyDayMetrics({
    this.prayerCompleted = 0,
    this.prayerMissed = 0,
    this.fajrCompleted = 0,
    this.dhikrSessions = 0,
    this.dhikrCount = 0,
    this.quranEngagements = 0,
    this.reflectionEntries = 0,
    this.fastingCompleted = 0,
    this.fastingIntending = 0,
  });

  final int prayerCompleted;
  final int prayerMissed;
  final int fajrCompleted;
  final int dhikrSessions;
  final int dhikrCount;
  final int quranEngagements;
  final int reflectionEntries;
  final int fastingCompleted;
  final int fastingIntending;

  JourneyDayMetrics copyWith({
    int? prayerCompleted,
    int? prayerMissed,
    int? fajrCompleted,
    int? dhikrSessions,
    int? dhikrCount,
    int? quranEngagements,
    int? reflectionEntries,
    int? fastingCompleted,
    int? fastingIntending,
  }) {
    return JourneyDayMetrics(
      prayerCompleted: prayerCompleted ?? this.prayerCompleted,
      prayerMissed: prayerMissed ?? this.prayerMissed,
      fajrCompleted: fajrCompleted ?? this.fajrCompleted,
      dhikrSessions: dhikrSessions ?? this.dhikrSessions,
      dhikrCount: dhikrCount ?? this.dhikrCount,
      quranEngagements: quranEngagements ?? this.quranEngagements,
      reflectionEntries: reflectionEntries ?? this.reflectionEntries,
      fastingCompleted: fastingCompleted ?? this.fastingCompleted,
      fastingIntending: fastingIntending ?? this.fastingIntending,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prayerCompleted': prayerCompleted,
      'prayerMissed': prayerMissed,
      'fajrCompleted': fajrCompleted,
      'dhikrSessions': dhikrSessions,
      'dhikrCount': dhikrCount,
      'quranEngagements': quranEngagements,
      'reflectionEntries': reflectionEntries,
      'fastingCompleted': fastingCompleted,
      'fastingIntending': fastingIntending,
    };
  }

  static JourneyDayMetrics fromJson(Map<String, dynamic>? json) {
    if (json == null) return const JourneyDayMetrics();
    return JourneyDayMetrics(
      prayerCompleted: _asInt(json['prayerCompleted']),
      prayerMissed: _asInt(json['prayerMissed']),
      fajrCompleted: _asInt(json['fajrCompleted']),
      dhikrSessions: _asInt(json['dhikrSessions']),
      dhikrCount: _asInt(json['dhikrCount']),
      quranEngagements: _asInt(json['quranEngagements']),
      reflectionEntries: _asInt(json['reflectionEntries']),
      fastingCompleted: _asInt(json['fastingCompleted']),
      fastingIntending: _asInt(json['fastingIntending']),
    );
  }
}

class JourneyProgressState {
  const JourneyProgressState({
    required this.totalPrayerCompleted,
    required this.totalDhikrSessions,
    required this.totalFastingCompleted,
    required this.totalFastingIntending,
    required this.totalQuranEngagements,
    required this.totalReflectionEntries,
    required this.localDropsContributionCount,
    required this.currentStreakDays,
    required this.bestStreakDays,
    required this.graceTokensRemaining,
    required this.graceTokenMonthlyAllowance,
    required this.graceTokenMonthKey,
    required this.graceProtectedDayKeys,
    required this.dayMetricsByKey,
    required this.dayScoreByKey,
  });

  final int totalPrayerCompleted;
  final int totalDhikrSessions;
  final int totalFastingCompleted;
  final int totalFastingIntending;
  final int totalQuranEngagements;
  final int totalReflectionEntries;
  final int localDropsContributionCount;
  final int currentStreakDays;
  final int bestStreakDays;
  final int graceTokensRemaining;
  final int graceTokenMonthlyAllowance;
  final String graceTokenMonthKey;
  final Set<String> graceProtectedDayKeys;
  final Map<String, JourneyDayMetrics> dayMetricsByKey;
  final Map<String, double> dayScoreByKey;

  JourneyProgressState copyWith({
    int? totalPrayerCompleted,
    int? totalDhikrSessions,
    int? totalFastingCompleted,
    int? totalFastingIntending,
    int? totalQuranEngagements,
    int? totalReflectionEntries,
    int? localDropsContributionCount,
    int? currentStreakDays,
    int? bestStreakDays,
    int? graceTokensRemaining,
    int? graceTokenMonthlyAllowance,
    String? graceTokenMonthKey,
    Set<String>? graceProtectedDayKeys,
    Map<String, JourneyDayMetrics>? dayMetricsByKey,
    Map<String, double>? dayScoreByKey,
  }) {
    return JourneyProgressState(
      totalPrayerCompleted: totalPrayerCompleted ?? this.totalPrayerCompleted,
      totalDhikrSessions: totalDhikrSessions ?? this.totalDhikrSessions,
      totalFastingCompleted:
          totalFastingCompleted ?? this.totalFastingCompleted,
      totalFastingIntending:
          totalFastingIntending ?? this.totalFastingIntending,
      totalQuranEngagements:
          totalQuranEngagements ?? this.totalQuranEngagements,
      totalReflectionEntries:
          totalReflectionEntries ?? this.totalReflectionEntries,
      localDropsContributionCount:
          localDropsContributionCount ?? this.localDropsContributionCount,
      currentStreakDays: currentStreakDays ?? this.currentStreakDays,
      bestStreakDays: bestStreakDays ?? this.bestStreakDays,
      graceTokensRemaining: graceTokensRemaining ?? this.graceTokensRemaining,
      graceTokenMonthlyAllowance:
          graceTokenMonthlyAllowance ?? this.graceTokenMonthlyAllowance,
      graceTokenMonthKey: graceTokenMonthKey ?? this.graceTokenMonthKey,
      graceProtectedDayKeys:
          graceProtectedDayKeys ?? this.graceProtectedDayKeys,
      dayMetricsByKey: dayMetricsByKey ?? this.dayMetricsByKey,
      dayScoreByKey: dayScoreByKey ?? this.dayScoreByKey,
    );
  }

  int get totalXp {
    return (totalPrayerCompleted * JourneyXpRules.xpPerPrayerCompleted) +
        (totalDhikrSessions * JourneyXpRules.xpPerDhikrSession) +
        (totalFastingCompleted * JourneyXpRules.xpPerFastingCompleted) +
        (totalFastingIntending * JourneyXpRules.xpPerFastingIntending) +
        (totalQuranEngagements * JourneyXpRules.xpPerQuranEngagement) +
        (totalReflectionEntries * JourneyXpRules.xpPerReflectionEntry);
  }

  int get level => JourneyXpRules.levelForXp(totalXp);

  int get nextLevelXpRemaining {
    final levelStart = JourneyXpRules.xpRequiredForLevel(level);
    final nextLevelStart = JourneyXpRules.xpRequiredForLevel(level + 1);
    final inLevel = totalXp - levelStart;
    return math.max(0, (nextLevelStart - levelStart) - inLevel);
  }

  double get xpProgress {
    final levelStart = JourneyXpRules.xpRequiredForLevel(level);
    final nextLevelStart = JourneyXpRules.xpRequiredForLevel(level + 1);
    final span = math.max(1, nextLevelStart - levelStart);
    final inLevel = (totalXp - levelStart).clamp(0, span);
    return (inLevel / span).clamp(0.0, 1.0).toDouble();
  }

  String get growthStageKey {
    final l = level;
    if (l >= 20) return 'treeOfLight';
    if (l >= 14) return 'youngTree';
    if (l >= 8) return 'sapling';
    if (l >= 4) return 'sprout';
    return 'seed';
  }

  List<String> get unlockedMilestoneKeys {
    final result = <String>[];
    if (bestStreakDays >= 7) result.add('first7days');
    if (totalDhikrSessions >= 100) result.add('dhikr100');
    if (totalPrayerCompleted >= 35) result.add('prayerWeek');
    if (totalQuranEngagements >= 7) result.add('learningStreak');
    if (totalFastingCompleted >= 1) result.add('fastingComplete');
    return result;
  }

  List<String> get upcomingMilestoneKeys {
    final locked = <String>[
      'first7days',
      'dhikr100',
      'prayerWeek',
      'learningStreak',
      'fastingComplete',
    ]..removeWhere(unlockedMilestoneKeys.contains);
    return locked;
  }

  List<String> get unlockedRewardKeys {
    final rewards = <String>[];
    if (level >= 5) rewards.add('wallpaper');
    if (level >= 9) rewards.add('reflection');
    if (level >= 14) rewards.add('theme');
    return rewards;
  }

  List<String> get upcomingRewardKeys {
    final all = <String>['wallpaper', 'reflection', 'theme', 'future'];
    final unlocked = unlockedRewardKeys;
    return all.where((item) => !unlocked.contains(item)).toList();
  }

  String get nextUnlockPreviewKey {
    final upcoming = upcomingRewardKeys;
    return upcoming.isEmpty ? 'future' : upcoming.first;
  }

  List<double> weeklyConsistencyBars(DateTime now) {
    final bars = <double>[];
    for (var i = 6; i >= 0; i -= 1) {
      final day = now.subtract(Duration(days: i));
      final key = LocalStore.todayKey(day);
      bars.add((dayScoreByKey[key] ?? 0.0).clamp(0.0, 1.0));
    }
    return bars;
  }

  static JourneyProgressState initial() {
    return const JourneyProgressState(
      totalPrayerCompleted: 0,
      totalDhikrSessions: 0,
      totalFastingCompleted: 0,
      totalFastingIntending: 0,
      totalQuranEngagements: 0,
      totalReflectionEntries: 0,
      localDropsContributionCount: 0,
      currentStreakDays: 0,
      bestStreakDays: 0,
      graceTokensRemaining: 2,
      graceTokenMonthlyAllowance: 2,
      graceTokenMonthKey: '',
      graceProtectedDayKeys: <String>{},
      dayMetricsByKey: {},
      dayScoreByKey: {},
    );
  }

  static JourneyProgressState fromJson(Map<String, dynamic>? json) {
    if (json == null) return initial();

    final metricsRaw = json['dayMetricsByKey'];
    final metrics = <String, JourneyDayMetrics>{};
    if (metricsRaw is Map) {
      for (final entry in metricsRaw.entries) {
        final key = entry.key.toString();
        final value = entry.value;
        if (value is Map<String, dynamic>) {
          metrics[key] = JourneyDayMetrics.fromJson(value);
        } else if (value is Map) {
          metrics[key] = JourneyDayMetrics.fromJson(
            value.map((k, v) => MapEntry(k.toString(), v)),
          );
        }
      }
    }

    final scoreRaw = json['dayScoreByKey'];
    final score = <String, double>{};
    if (scoreRaw is Map) {
      for (final entry in scoreRaw.entries) {
        final key = entry.key.toString();
        final value = entry.value;
        if (value is num) {
          score[key] = value.toDouble().clamp(0.0, 1.0);
        }
      }
    }

    return JourneyProgressState(
      totalPrayerCompleted: _asInt(json['totalPrayerCompleted']),
      totalDhikrSessions: _asInt(json['totalDhikrSessions']),
      totalFastingCompleted: _asInt(json['totalFastingCompleted']),
      totalFastingIntending: _asInt(json['totalFastingIntending']),
      totalQuranEngagements: _asInt(json['totalQuranEngagements']),
      totalReflectionEntries: _asInt(json['totalReflectionEntries']),
      localDropsContributionCount: _asInt(json['localDropsContributionCount']),
      currentStreakDays: _asInt(json['currentStreakDays']),
      bestStreakDays: _asInt(json['bestStreakDays']),
      graceTokensRemaining: _asInt(json['graceTokensRemaining']),
      graceTokenMonthlyAllowance: math.max(
        2,
        _asInt(json['graceTokenMonthlyAllowance']),
      ),
      graceTokenMonthKey: json['graceTokenMonthKey']?.toString() ?? '',
      graceProtectedDayKeys: _asStringSet(json['graceProtectedDayKeys']),
      dayMetricsByKey: metrics,
      dayScoreByKey: score,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPrayerCompleted': totalPrayerCompleted,
      'totalDhikrSessions': totalDhikrSessions,
      'totalFastingCompleted': totalFastingCompleted,
      'totalFastingIntending': totalFastingIntending,
      'totalQuranEngagements': totalQuranEngagements,
      'totalReflectionEntries': totalReflectionEntries,
      'localDropsContributionCount': localDropsContributionCount,
      'currentStreakDays': currentStreakDays,
      'bestStreakDays': bestStreakDays,
      'graceTokensRemaining': graceTokensRemaining,
      'graceTokenMonthlyAllowance': graceTokenMonthlyAllowance,
      'graceTokenMonthKey': graceTokenMonthKey,
      'graceProtectedDayKeys': graceProtectedDayKeys.toList(),
      'dayMetricsByKey': dayMetricsByKey.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      'dayScoreByKey': dayScoreByKey,
    };
  }
}

class JourneyProgressNotifier extends StateNotifier<JourneyProgressState> {
  JourneyProgressNotifier(this._store) : super(JourneyProgressState.initial()) {
    _load();
  }

  final LocalStore _store;

  void syncFromSnapshot(JourneyActivitySnapshot snapshot) {
    final monthKey = _monthKey(snapshot.now);
    var graceTokens = state.graceTokensRemaining;
    var graceAllowance = state.graceTokenMonthlyAllowance;
    var graceMonthKey = state.graceTokenMonthKey;
    var protectedDays = Set<String>.from(state.graceProtectedDayKeys);

    if (graceMonthKey != monthKey) {
      graceAllowance = _graceMonthlyAllowance(state.level);
      graceTokens = graceAllowance;
      graceMonthKey = monthKey;
      protectedDays = <String>{};
    }

    final dayKey = LocalStore.todayKey(snapshot.now);
    final currentDayMetrics =
        state.dayMetricsByKey[dayKey] ?? const JourneyDayMetrics();

    final nextDayMetrics = currentDayMetrics.copyWith(
      prayerCompleted: math.max(
        currentDayMetrics.prayerCompleted,
        snapshot.prayerCompletedToday,
      ),
      prayerMissed: math.max(
        currentDayMetrics.prayerMissed,
        snapshot.prayerMissedToday,
      ),
      fajrCompleted: math.max(
        currentDayMetrics.fajrCompleted,
        snapshot.fajrCompletedToday ? 1 : 0,
      ),
      dhikrSessions: math.max(
        currentDayMetrics.dhikrSessions,
        snapshot.dhikrSessionsToday,
      ),
      dhikrCount: math.max(
        currentDayMetrics.dhikrCount,
        snapshot.dhikrCountToday,
      ),
      quranEngagements: math.max(
        currentDayMetrics.quranEngagements,
        snapshot.quranEngagementsToday,
      ),
      reflectionEntries: math.max(
        currentDayMetrics.reflectionEntries,
        snapshot.reflectionEntriesToday,
      ),
      fastingCompleted: math.max(
        currentDayMetrics.fastingCompleted,
        snapshot.fastingCompletedToday ? 1 : 0,
      ),
      fastingIntending: math.max(
        currentDayMetrics.fastingIntending,
        snapshot.fastingIntendingToday ? 1 : 0,
      ),
    );

    final deltaPrayer =
        nextDayMetrics.prayerCompleted - currentDayMetrics.prayerCompleted;
    final deltaDhikr =
        nextDayMetrics.dhikrSessions - currentDayMetrics.dhikrSessions;
    final deltaQuran =
        nextDayMetrics.quranEngagements - currentDayMetrics.quranEngagements;
    final deltaReflection =
        nextDayMetrics.reflectionEntries - currentDayMetrics.reflectionEntries;
    final deltaFastCompleted =
        nextDayMetrics.fastingCompleted - currentDayMetrics.fastingCompleted;
    final deltaFastIntending =
        nextDayMetrics.fastingIntending - currentDayMetrics.fastingIntending;

    final nextDailyScore = math.max(
      state.dayScoreByKey[dayKey] ?? 0.0,
      snapshot.dailyCompletionScore,
    );

    final metricsByDay = Map<String, JourneyDayMetrics>.from(
      state.dayMetricsByKey,
    )..[dayKey] = nextDayMetrics;
    final scoreByDay = Map<String, double>.from(state.dayScoreByKey)
      ..[dayKey] = nextDailyScore;

    // If a protected day is later completed naturally, refund the token.
    if (protectedDays.contains(dayKey) &&
        nextDailyScore >= JourneyXpRules.streakCompletionThreshold) {
      protectedDays.remove(dayKey);
      graceTokens = (graceTokens + 1).clamp(0, graceAllowance).toInt();
    }

    final todayCompleted =
        nextDailyScore >= JourneyXpRules.streakCompletionThreshold;
    final yesterdayKey = LocalStore.todayKey(
      snapshot.now.subtract(const Duration(days: 1)),
    );
    final yesterdayCompleted =
        (scoreByDay[yesterdayKey] ?? 0.0) >=
        JourneyXpRules.streakCompletionThreshold;
    final needsProtection =
        !todayCompleted &&
        yesterdayCompleted &&
        !protectedDays.contains(dayKey);
    if (needsProtection && graceTokens > 0) {
      protectedDays.add(dayKey);
      graceTokens -= 1;
    }

    final protectedScoreByDay = Map<String, double>.from(scoreByDay);
    for (final key in protectedDays) {
      if ((protectedScoreByDay[key] ?? 0.0) <
          JourneyXpRules.streakCompletionThreshold) {
        protectedScoreByDay[key] = JourneyXpRules.streakCompletionThreshold;
      }
    }

    final streak = _computeStreaks(protectedScoreByDay, snapshot.now);

    final hasDelta =
        deltaPrayer > 0 ||
        deltaDhikr > 0 ||
        deltaQuran > 0 ||
        deltaReflection > 0 ||
        deltaFastCompleted > 0 ||
        deltaFastIntending > 0;
    final scoreChanged = nextDailyScore != (state.dayScoreByKey[dayKey] ?? 0.0);
    final streakChanged =
        streak.current != state.currentStreakDays ||
        streak.best != state.bestStreakDays;

    if (!hasDelta && !scoreChanged && !streakChanged) return;

    final dropDelta =
        (deltaPrayer * 2) +
        deltaDhikr +
        (deltaQuran * 2) +
        deltaReflection +
        (deltaFastCompleted * 3) +
        deltaFastIntending;

    state = state.copyWith(
      totalPrayerCompleted: state.totalPrayerCompleted + deltaPrayer,
      totalDhikrSessions: state.totalDhikrSessions + deltaDhikr,
      totalQuranEngagements: state.totalQuranEngagements + deltaQuran,
      totalReflectionEntries: state.totalReflectionEntries + deltaReflection,
      totalFastingCompleted: state.totalFastingCompleted + deltaFastCompleted,
      totalFastingIntending: state.totalFastingIntending + deltaFastIntending,
      localDropsContributionCount:
          state.localDropsContributionCount + math.max(0, dropDelta),
      currentStreakDays: streak.current,
      bestStreakDays: math.max(streak.best, state.bestStreakDays),
      graceTokensRemaining: graceTokens,
      graceTokenMonthlyAllowance: graceAllowance,
      graceTokenMonthKey: graceMonthKey,
      graceProtectedDayKeys: protectedDays,
      dayMetricsByKey: metricsByDay,
      dayScoreByKey: scoreByDay,
    );
    _save();
  }

  void _load() {
    state = JourneyProgressState.fromJson(
      _store.getJsonMap(_journeyProgressKey),
    );
  }

  void _save() {
    _store.setJsonMap(_journeyProgressKey, state.toJson());
  }
}

class JourneyComputedProgress {
  const JourneyComputedProgress({
    required this.level,
    required this.xp,
    required this.xpProgress,
    required this.nextLevelXpRemaining,
    required this.currentStreakDays,
    required this.bestStreakDays,
    required this.ringPrayer,
    required this.ringDhikr,
    required this.ringQuran,
    required this.ringReflection,
    required this.ringFasting,
    required this.weeklyConsistencyBars,
    required this.nextUnlockPreviewKey,
    required this.unlockedMilestoneKeys,
    required this.upcomingMilestoneKeys,
    required this.unlockedRewardKeys,
    required this.upcomingRewardKeys,
    required this.growthStageKey,
    required this.localDropsContributionCount,
    required this.monthlyBadges,
    required this.dailyBadges,
    required this.graceTokensRemaining,
    required this.graceTokenMonthlyAllowance,
    required this.weeklyProtectedDays,
  });

  final int level;
  final int xp;
  final double xpProgress;
  final int nextLevelXpRemaining;
  final int currentStreakDays;
  final int bestStreakDays;
  final double ringPrayer;
  final double ringDhikr;
  final double ringQuran;
  final double ringReflection;
  final double ringFasting;
  final List<double> weeklyConsistencyBars;
  final String nextUnlockPreviewKey;
  final List<String> unlockedMilestoneKeys;
  final List<String> upcomingMilestoneKeys;
  final List<String> unlockedRewardKeys;
  final List<String> upcomingRewardKeys;
  final String growthStageKey;
  final int localDropsContributionCount;
  final List<JourneyMonthlyBadge> monthlyBadges;
  final List<JourneyDailyBadge> dailyBadges;
  final int graceTokensRemaining;
  final int graceTokenMonthlyAllowance;
  final int weeklyProtectedDays;
}

class JourneyMonthlyBadge {
  const JourneyMonthlyBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.currentValue,
    required this.bronzeTarget,
    required this.silverTarget,
    required this.goldTarget,
    required this.platinumTarget,
    required this.tier,
    required this.progress,
    required this.earned,
  });

  final String id;
  final String title;
  final String description;
  final int currentValue;
  final int bronzeTarget;
  final int silverTarget;
  final int goldTarget;
  final int platinumTarget;
  final int tier;
  final double progress;
  final bool earned;
}

class JourneyDailyBadge {
  const JourneyDailyBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.earnedToday,
    required this.earnedCount,
  });

  final String id;
  final String title;
  final String description;
  final bool earnedToday;
  final int earnedCount;
}

final journeyActivitySnapshotProvider = Provider<JourneyActivitySnapshot>((
  ref,
) {
  final prayerSummary = ref.watch(prayerSummaryProvider);
  final prayerRecords = ref.watch(prayerControllerProvider);
  final prayerSchedule = ref.watch(prayerScheduleProvider);
  final dhikr = ref.watch(dhikrControllerProvider);
  final fasting = ref.watch(fastingControllerProvider);
  final quranProgress = ref.watch(quranReadingProgressProvider);
  final notes = ref.watch(quranNotesProvider);
  final bookmarks = ref.watch(quranBookmarksProvider);

  final now = DateTime.now();
  final todayKey = LocalStore.todayKey(now);

  final dhikrSessionsToday = dhikr.recentSessions.where((session) {
    return LocalStore.todayKey(session.finishedAt) == todayKey;
  }).length;
  final dhikrCountToday =
      dhikr.recentSessions
          .where((session) => LocalStore.todayKey(session.finishedAt) == todayKey)
          .fold<int>(0, (sum, session) => sum + session.count) +
      dhikr.currentCount;

  final quranUpdatedToday =
      LocalStore.todayKey(
        DateTime.tryParse(quranProgress.updatedAtIso) ?? now,
      ) ==
      todayKey;
  final bookmarksToday = bookmarks.where((bookmark) {
    final created = DateTime.tryParse(bookmark.createdAtIso);
    if (created == null) return false;
    return LocalStore.todayKey(created) == todayKey;
  }).length;
  final notesToday = notes.where((note) {
    final created = DateTime.tryParse(note.createdAtIso);
    if (created == null) return false;
    return LocalStore.todayKey(created) == todayKey;
  }).length;

  final dhikrProgress = dhikr.target <= 0
      ? 0.0
      : (dhikr.currentCount / dhikr.target).clamp(0.0, 1.0).toDouble();
  final prayerMissedToday = prayerRecords
      .where((record) => record.status.name == 'missed')
      .length;
  final fajrWindowEnd = prayerSchedule
      .where((item) => item.id == 'fajr')
      .map((item) => item.windowEndDateTime)
      .firstOrNull;
  final fajrCompletedToday = prayerRecords.any((record) {
    if (record.prayer.name != 'fajr' || record.status != PrayerStatus.completed) {
      return false;
    }
    final completedAt = record.completedAt;
    if (completedAt == null || fajrWindowEnd == null) return false;
    return completedAt.isBefore(fajrWindowEnd);
  });

  final quranProgressRatio = ref.watch(quranProgressRatioProvider);

  return JourneyActivitySnapshot(
    now: now,
    prayerCompletedToday: prayerSummary.completed,
    prayerMissedToday: prayerMissedToday,
    fajrCompletedToday: fajrCompletedToday,
    prayerProgress: prayerSummary.progress.clamp(0.0, 1.0).toDouble(),
    dhikrSessionsToday: dhikrSessionsToday,
    dhikrCountToday: dhikrCountToday,
    dhikrProgress: dhikrProgress,
    fastingStatus: fasting.todayStatus,
    quranEngagementsToday: (quranUpdatedToday ? 1 : 0) + bookmarksToday,
    quranProgress: quranProgressRatio.clamp(0.0, 1.0).toDouble(),
    reflectionEntriesToday: notesToday,
    reflectionProgress: (notesToday / 2).clamp(0.0, 1.0).toDouble(),
  );
});

final journeyProgressProvider =
    StateNotifierProvider<JourneyProgressNotifier, JourneyProgressState>((ref) {
      return JourneyProgressNotifier(ref.watch(localStoreProvider));
    });

final journeyComputedProgressProvider = Provider<JourneyComputedProgress>((
  ref,
) {
  final snapshot = ref.watch(journeyActivitySnapshotProvider);
  final state = ref.watch(journeyProgressProvider);

  return JourneyComputedProgress(
    level: state.level,
    xp: state.totalXp,
    xpProgress: state.xpProgress,
    nextLevelXpRemaining: state.nextLevelXpRemaining,
    currentStreakDays: state.currentStreakDays,
    bestStreakDays: state.bestStreakDays,
    ringPrayer: snapshot.prayerProgress,
    ringDhikr: snapshot.dhikrProgress,
    ringQuran: snapshot.quranProgress,
    ringReflection: snapshot.reflectionProgress,
    ringFasting: snapshot.fastingProgress,
    weeklyConsistencyBars: state.weeklyConsistencyBars(snapshot.now),
    nextUnlockPreviewKey: state.nextUnlockPreviewKey,
    unlockedMilestoneKeys: state.unlockedMilestoneKeys,
    upcomingMilestoneKeys: state.upcomingMilestoneKeys,
    unlockedRewardKeys: state.unlockedRewardKeys,
    upcomingRewardKeys: state.upcomingRewardKeys,
    growthStageKey: state.growthStageKey,
    localDropsContributionCount: state.localDropsContributionCount,
    monthlyBadges: _buildMonthlyBadges(state, snapshot.now),
    dailyBadges: _buildDailyBadges(state, snapshot.now),
    graceTokensRemaining: state.graceTokensRemaining,
    graceTokenMonthlyAllowance: state.graceTokenMonthlyAllowance,
    weeklyProtectedDays: state.graceProtectedDayKeys.where((key) {
      final day = DateTime.tryParse('${key}T00:00:00');
      if (day == null) return false;
      final threshold = snapshot.now.subtract(const Duration(days: 6));
      return !day.isBefore(
        DateTime(threshold.year, threshold.month, threshold.day),
      );
    }).length,
  );
});

final journeyProgressAutoSyncProvider = Provider<void>((ref) {
  ref.listen<JourneyActivitySnapshot>(journeyActivitySnapshotProvider, (
    _,
    snapshot,
  ) {
    Future<void>.microtask(
      () =>
          ref.read(journeyProgressProvider.notifier).syncFromSnapshot(snapshot),
    );
  }, fireImmediately: true);
});

final journeyProgressUpdateHelperProvider = Provider<JourneyProgressUpdateHelper>(
  (ref) => JourneyProgressUpdateHelper(ref),
);

class JourneyProgressUpdateHelper {
  const JourneyProgressUpdateHelper(this._ref);

  final Ref _ref;

  void addReflectionEntries(int count) {
    if (count <= 0) return;
    final snapshot = _ref.read(journeyActivitySnapshotProvider);
    final nextReflectionEntries = snapshot.reflectionEntriesToday + count;
    _ref.read(journeyProgressProvider.notifier).syncFromSnapshot(
      snapshot.copyWith(
        reflectionEntriesToday: nextReflectionEntries,
        reflectionProgress: (nextReflectionEntries / 2)
            .clamp(0.0, 1.0)
            .toDouble(),
      ),
    );
  }
}

List<JourneyMonthlyBadge> _buildMonthlyBadges(
  JourneyProgressState state,
  DateTime now,
) {
  final monthPrefix =
      '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-';
  var prayers = 0;
  var dhikr = 0;
  var quran = 0;
  var reflections = 0;
  var fastingCompleted = 0;
  var trackedDays = 0;

  for (final entry in state.dayMetricsByKey.entries) {
    if (!entry.key.startsWith(monthPrefix)) continue;
    trackedDays += 1;
    final m = entry.value;
    prayers += m.prayerCompleted;
    dhikr += m.dhikrSessions;
    quran += m.quranEngagements;
    reflections += m.reflectionEntries;
    fastingCompleted += m.fastingCompleted;
  }

  final prayerTarget = math.max(1, now.day * 5);
  final dhikrTarget = math.max(1, now.day ~/ 2);
  final quranTarget = math.max(1, now.day ~/ 2);
  final reflectionTarget = math.max(1, now.day ~/ 3);
  final consistencyTarget = math.max(1, now.day ~/ 2);

  var consistencyDays = 0;
  for (final day in state.dayScoreByKey.entries) {
    if (!day.key.startsWith(monthPrefix)) continue;
    if (day.value >= JourneyXpRules.streakCompletionThreshold) {
      consistencyDays += 1;
    }
  }

  JourneyMonthlyBadge buildBadge({
    required String id,
    required String title,
    required String description,
    required int current,
    required int target,
  }) {
    final bronzeTarget = math.max(1, (target * 0.40).round());
    final silverTarget = math.max(bronzeTarget + 1, (target * 0.70).round());
    final goldTarget = target;
    final platinumTarget = math.max(goldTarget + 1, (target * 1.30).round());
    final tier = current >= platinumTarget
        ? 4
        : current >= goldTarget
        ? 3
        : current >= silverTarget
        ? 2
        : current >= bronzeTarget
        ? 1
        : 0;
    return JourneyMonthlyBadge(
      id: id,
      title: title,
      description: description,
      currentValue: current,
      bronzeTarget: bronzeTarget,
      silverTarget: silverTarget,
      goldTarget: goldTarget,
      platinumTarget: platinumTarget,
      tier: tier,
      progress: (current / goldTarget).clamp(0.0, 1.0).toDouble(),
      earned: tier >= 1,
    );
  }

  return [
    buildBadge(
      id: 'prayer_guardian',
      title: 'Prayer Guardian',
      description: 'Offer prayers consistently through the month.',
      current: prayers,
      target: prayerTarget,
    ),
    buildBadge(
      id: 'dhikr_companion',
      title: 'Dhikr Companion',
      description: 'Keep remembrance sessions steady.',
      current: dhikr,
      target: dhikrTarget,
    ),
    buildBadge(
      id: 'quran_returner',
      title: 'Qur\'an Returner',
      description: 'Return to Qur\'an reading throughout the month.',
      current: quran,
      target: quranTarget,
    ),
    buildBadge(
      id: 'reflective_heart',
      title: 'Reflective Heart',
      description: 'Write reflection notes with sincerity.',
      current: reflections,
      target: reflectionTarget,
    ),
    buildBadge(
      id: 'steady_steps',
      title: 'Steady Steps',
      description: 'Reach strong daily consistency over the month.',
      current: consistencyDays,
      target: consistencyTarget,
    ),
    buildBadge(
      id: 'fasting_intent',
      title: 'Fasting Intent',
      description: 'Complete fasting days with clear intention.',
      current: fastingCompleted,
      target: 4,
    ),
    buildBadge(
      id: 'presence_keeper',
      title: 'Presence Keeper',
      description: 'Stay active across worship and learning together.',
      current: prayers + dhikr + quran + reflections,
      target: math.max(1, trackedDays * 3),
    ),
  ];
}

List<JourneyDailyBadge> _buildDailyBadges(
  JourneyProgressState state,
  DateTime now,
) {
  const dailyDhikrGoal = 500;
  final todayKey = LocalStore.todayKey(now);
  final today = state.dayMetricsByKey[todayKey] ?? const JourneyDayMetrics();

  int achievedDays(bool Function(JourneyDayMetrics metrics) predicate) {
    return state.dayMetricsByKey.values.where(predicate).length;
  }

  int streakAchievedDays(int minimumDays) {
    final keys = state.dayScoreByKey.keys.toList()..sort();
    var streak = 0;
    var earned = 0;
    for (final key in keys) {
      final score = state.dayScoreByKey[key] ?? 0.0;
      if (score >= JourneyXpRules.streakCompletionThreshold) {
        streak += 1;
        if (streak >= minimumDays) earned += 1;
      } else {
        streak = 0;
      }
    }
    return earned;
  }

  return [
    JourneyDailyBadge(
      id: 'all_prayers',
      title: 'All Prayers',
      description: 'Completed all 5 daily prayers.',
      earnedToday: today.prayerCompleted >= 5,
      earnedCount: achievedDays((metrics) => metrics.prayerCompleted >= 5),
    ),
    JourneyDailyBadge(
      id: 'daily_dhikr',
      title: 'Dhikr 500',
      description: 'Reached the 500 daily dhikr goal.',
      earnedToday: today.dhikrCount >= dailyDhikrGoal,
      earnedCount: achievedDays((metrics) => metrics.dhikrCount >= dailyDhikrGoal),
    ),
    JourneyDailyBadge(
      id: 'quran_return',
      title: 'Qur\'an Return',
      description: 'Returned to Qur\'an at least once today.',
      earnedToday: today.quranEngagements >= 1,
      earnedCount: achievedDays((metrics) => metrics.quranEngagements >= 1),
    ),
    JourneyDailyBadge(
      id: 'reflection',
      title: 'Reflection',
      description: 'Added at least one reflection today.',
      earnedToday: today.reflectionEntries >= 1,
      earnedCount: achievedDays((metrics) => metrics.reflectionEntries >= 1),
    ),
    JourneyDailyBadge(
      id: 'perfect_day',
      title: 'Perfect Day',
      description: 'Prayers, dhikr, Qur\'an, and reflection all completed.',
      earnedToday: today.prayerCompleted >= 5 &&
          today.dhikrCount >= dailyDhikrGoal &&
          today.quranEngagements >= 1 &&
          today.reflectionEntries >= 1,
      earnedCount: achievedDays(
        (metrics) =>
            metrics.prayerCompleted >= 5 &&
            metrics.dhikrCount >= dailyDhikrGoal &&
            metrics.quranEngagements >= 1 &&
            metrics.reflectionEntries >= 1,
      ),
    ),
    JourneyDailyBadge(
      id: 'no_missed_prayers',
      title: 'No Missed Prayers',
      description: 'Completed the day without marking any salah as missed.',
      earnedToday: today.prayerCompleted >= 5 && today.prayerMissed == 0,
      earnedCount: achievedDays(
        (metrics) => metrics.prayerCompleted >= 5 && metrics.prayerMissed == 0,
      ),
    ),
    JourneyDailyBadge(
      id: 'before_sunrise_fajr',
      title: 'Before Sunrise Fajr',
      description: 'Completed Fajr before sunrise with an exact recorded time.',
      earnedToday: today.fajrCompleted >= 1,
      earnedCount: achievedDays((metrics) => metrics.fajrCompleted >= 1),
    ),
    JourneyDailyBadge(
      id: 'streak_3',
      title: '3-Day Streak',
      description: 'Reached three consecutive strong days.',
      earnedToday: state.currentStreakDays >= 3,
      earnedCount: streakAchievedDays(3),
    ),
  ];
}

class _StreakResult {
  const _StreakResult(this.current, this.best);

  final int current;
  final int best;
}

_StreakResult _computeStreaks(Map<String, double> scoreByDay, DateTime now) {
  if (scoreByDay.isEmpty) return const _StreakResult(0, 0);

  final completedDays =
      scoreByDay.entries
          .where(
            (entry) => entry.value >= JourneyXpRules.streakCompletionThreshold,
          )
          .map((entry) => entry.key)
          .toList()
        ..sort();

  if (completedDays.isEmpty) return const _StreakResult(0, 0);

  final nowKey = LocalStore.todayKey(now);
  var current = 0;
  var cursor = now;
  while (true) {
    final key = LocalStore.todayKey(cursor);
    if (!completedDays.contains(key)) break;
    current += 1;
    cursor = cursor.subtract(const Duration(days: 1));
    if (current >= 400) break;
  }
  if (!completedDays.contains(nowKey)) {
    final yesterday = LocalStore.todayKey(
      now.subtract(const Duration(days: 1)),
    );
    if (!completedDays.contains(yesterday)) {
      current = 0;
    }
  }

  var best = 0;
  var run = 0;
  DateTime? previous;
  for (final key in completedDays) {
    final day = DateTime.tryParse('${key}T00:00:00');
    if (day == null) continue;
    if (previous == null) {
      run = 1;
    } else {
      final diff = day.difference(previous).inDays;
      run = diff == 1 ? run + 1 : 1;
    }
    previous = day;
    if (run > best) best = run;
  }

  return _StreakResult(current, best);
}

int _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.round();
  return 0;
}

Set<String> _asStringSet(Object? raw) {
  if (raw is! List) return <String>{};
  return raw.map((item) => item.toString()).toSet();
}

String _monthKey(DateTime date) {
  return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}';
}

int _graceMonthlyAllowance(int level) {
  if (level >= 20) return 4;
  if (level >= 10) return 3;
  return 2;
}
