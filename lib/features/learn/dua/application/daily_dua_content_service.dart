import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/prayer/prayer_preferences.dart';
import '../../../../shared/application/daily_clock_provider.dart';
import '../../../../shared/application/special_mode_provider.dart';
import '../../../../shared/persistence/local_store.dart';
import '../../../../shared/utils/hijri_date_utils.dart';
import '../domain/dua_models.dart';
import 'dua_progress_provider.dart';
import 'dua_repository.dart';

const String duaSurfaceInApp = 'in_app';
const String duaSurfaceDailyCard = 'daily_card';
const String duaSurfaceHomeWidget = 'home_widget';
const String duaSurfaceLockscreen = 'lockscreen';
const String duaSurfaceWatch = 'watch';
const String duaSurfaceStandby = 'standby';

@immutable
class DailyDuaSelectionContext {
  const DailyDuaSelectionContext({
    required this.currentDateTime,
    required this.surface,
    this.timeContexts = const <String>[],
    this.dateContexts = const <String>[],
    this.weatherContexts = const <String>[],
    this.locationContexts = const <String>[],
    this.prayerContexts = const <String>[],
    this.situationContexts = const <String>[],
    this.maxItems = 3,
    this.allowGeneralVerified = false,
    this.excludeRecentlySeen = true,
    this.recentlySeenIds = const <String>[],
  });

  final DateTime currentDateTime;
  final String surface;
  final List<String> timeContexts;
  final List<String> dateContexts;
  final List<String> weatherContexts;
  final List<String> locationContexts;
  final List<String> prayerContexts;
  final List<String> situationContexts;
  final int maxItems;
  final bool allowGeneralVerified;
  final bool excludeRecentlySeen;
  final List<String> recentlySeenIds;

  String get dateKey => LocalStore.todayKey(currentDateTime);

  DailyDuaSelectionContext copyWith({
    DateTime? currentDateTime,
    String? surface,
    List<String>? timeContexts,
    List<String>? dateContexts,
    List<String>? weatherContexts,
    List<String>? locationContexts,
    List<String>? prayerContexts,
    List<String>? situationContexts,
    int? maxItems,
    bool? allowGeneralVerified,
    bool? excludeRecentlySeen,
    List<String>? recentlySeenIds,
  }) {
    return DailyDuaSelectionContext(
      currentDateTime: currentDateTime ?? this.currentDateTime,
      surface: surface ?? this.surface,
      timeContexts: timeContexts ?? this.timeContexts,
      dateContexts: dateContexts ?? this.dateContexts,
      weatherContexts: weatherContexts ?? this.weatherContexts,
      locationContexts: locationContexts ?? this.locationContexts,
      prayerContexts: prayerContexts ?? this.prayerContexts,
      situationContexts: situationContexts ?? this.situationContexts,
      maxItems: maxItems ?? this.maxItems,
      allowGeneralVerified: allowGeneralVerified ?? this.allowGeneralVerified,
      excludeRecentlySeen: excludeRecentlySeen ?? this.excludeRecentlySeen,
      recentlySeenIds: recentlySeenIds ?? this.recentlySeenIds,
    );
  }

  List<String> get activeContextKeys => <String>[
    ...timeContexts,
    ...dateContexts,
    ...weatherContexts,
    ...locationContexts,
    ...prayerContexts,
    ...situationContexts,
  ];
}

@immutable
class DailyDuaCandidate {
  const DailyDuaCandidate({
    required this.item,
    required this.score,
    required this.selectionReasons,
    required this.contextMatchCount,
    required this.isFallback,
  });

  final DuaItem item;
  final int score;
  final List<String> selectionReasons;
  final int contextMatchCount;
  final bool isFallback;

  bool get isCompactFriendly =>
      item.title.trim().length <= 42 &&
      item.translation.trim().length <= 160 &&
      item.arabic.trim().length <= 160;
}

@immutable
class DailyDuaBundle {
  const DailyDuaBundle({
    required this.context,
    required this.primary,
    required this.candidates,
  });

  final DailyDuaSelectionContext context;
  final DailyDuaCandidate? primary;
  final List<DailyDuaCandidate> candidates;
}

class DailyDuaContentService {
  const DailyDuaContentService();

  DailyDuaCandidate? getBestMatch({
    required DuaDataset dataset,
    required DailyDuaSelectionContext context,
  }) {
    final candidates = getContextualDuaCandidates(
      dataset: dataset,
      context: context,
    );
    return candidates.isEmpty ? null : candidates.first;
  }

  List<DailyDuaCandidate> getContextualDuaCandidates({
    required DuaDataset dataset,
    required DailyDuaSelectionContext context,
  }) {
    final ranked = <DailyDuaCandidate>[];
    for (final item in dataset.verifiedItems) {
      final candidate = _scoreItem(item: item, context: context);
      if (candidate != null) {
        ranked.add(candidate);
      }
    }

    ranked.sort((a, b) {
      final scoreComparison = b.score.compareTo(a.score);
      if (scoreComparison != 0) return scoreComparison;
      final matchComparison = b.contextMatchCount.compareTo(
        a.contextMatchCount,
      );
      if (matchComparison != 0) return matchComparison;
      final priorityComparison = b.item.priorityScore.compareTo(
        a.item.priorityScore,
      );
      if (priorityComparison != 0) return priorityComparison;
      if (a.item.isCore != b.item.isCore) {
        return a.item.isCore ? -1 : 1;
      }
      final rotationComparison = _dailyRotationValue(
        a.item.id,
        context.dateKey,
      ).compareTo(_dailyRotationValue(b.item.id, context.dateKey));
      if (rotationComparison != 0) return rotationComparison;
      final titleComparison = a.item.title.compareTo(b.item.title);
      if (titleComparison != 0) return titleComparison;
      return a.item.id.compareTo(b.item.id);
    });

    if (context.excludeRecentlySeen) {
      final nonRecent = ranked
          .where(
            (candidate) => !context.recentlySeenIds.contains(candidate.item.id),
          )
          .toList(growable: false);
      if (nonRecent.isNotEmpty) {
        return nonRecent.take(context.maxItems).toList(growable: false);
      }
    }

    return ranked.take(context.maxItems).toList(growable: false);
  }

  DailyDuaBundle getDailyDuaBundle({
    required DuaDataset dataset,
    required DailyDuaSelectionContext context,
  }) {
    final candidates = getContextualDuaCandidates(
      dataset: dataset,
      context: context,
    );
    return DailyDuaBundle(
      context: context,
      primary: candidates.isEmpty ? null : candidates.first,
      candidates: candidates,
    );
  }

  DailyDuaCandidate? getCompactDuaPrompt({
    required DuaDataset dataset,
    required DailyDuaSelectionContext context,
  }) {
    final candidates = getContextualDuaCandidates(
      dataset: dataset,
      context: context.copyWith(maxItems: 6),
    );
    for (final candidate in candidates) {
      if (candidate.isCompactFriendly) {
        return candidate;
      }
    }
    return candidates.isEmpty ? null : candidates.first;
  }

  DailyDuaCandidate? _scoreItem({
    required DuaItem item,
    required DailyDuaSelectionContext context,
  }) {
    if (item.completionStatus != DuaCompletionStatus.complete ||
        !item.hasContent) {
      return null;
    }
    if (item.excludeFromDefaultSurface || item.needsReview) {
      return null;
    }
    if (!item.isVerifiedStrong &&
        !(context.allowGeneralVerified && item.isVerifiedGeneral)) {
      return null;
    }
    if (item.surfaceEligibility.isNotEmpty &&
        !item.surfaceEligibility.contains(context.surface)) {
      return null;
    }

    var score = item.isVerifiedStrong ? 1000 : 720;
    final reasons = <String>[
      'trust:${item.verificationStatus}',
      if (item.surfaceEligibility.contains(context.surface))
        'surface:${context.surface}',
    ];
    var matchCount = 0;

    void applyContextMatches({
      required List<String> active,
      required List<String> available,
      required int exactWeight,
      required int broadWeight,
      required String reasonPrefix,
    }) {
      if (active.isEmpty) return;
      final availableSet = available
          .map((value) => value.trim())
          .where((value) => value.isNotEmpty)
          .toSet();
      if (availableSet.isEmpty) return;

      for (final value in active) {
        final normalized = value.trim();
        if (normalized.isEmpty) continue;
        if (availableSet.contains(normalized)) {
          score += exactWeight;
          matchCount += 1;
          reasons.add('$reasonPrefix:$normalized');
        } else if (availableSet.contains('any')) {
          score += broadWeight;
          reasons.add('$reasonPrefix:any');
        }
      }
    }

    applyContextMatches(
      active: context.timeContexts,
      available: item.timeContexts,
      exactWeight: 320,
      broadWeight: 28,
      reasonPrefix: 'time',
    );
    applyContextMatches(
      active: context.dateContexts,
      available: item.dateContexts,
      exactWeight: 330,
      broadWeight: 24,
      reasonPrefix: 'date',
    );
    applyContextMatches(
      active: context.weatherContexts,
      available: item.weatherContexts,
      exactWeight: 360,
      broadWeight: 20,
      reasonPrefix: 'weather',
    );
    applyContextMatches(
      active: context.locationContexts,
      available: item.locationContexts,
      exactWeight: 350,
      broadWeight: 20,
      reasonPrefix: 'location',
    );
    applyContextMatches(
      active: context.prayerContexts,
      available: item.prayerContexts,
      exactWeight: 380,
      broadWeight: 24,
      reasonPrefix: 'prayer',
    );
    applyContextMatches(
      active: context.situationContexts,
      available: item.situationContexts,
      exactWeight: 300,
      broadWeight: 18,
      reasonPrefix: 'situation',
    );

    final preferredPrimaryCategories = _preferredPrimaryCategories(context);
    if (preferredPrimaryCategories.contains(item.effectivePrimaryCategory)) {
      score += 95;
      reasons.add('primary:${item.effectivePrimaryCategory}');
    }

    final secondaryMatches = preferredPrimaryCategories
        .where(item.secondaryCategories.contains)
        .toList(growable: false);
    if (secondaryMatches.isNotEmpty) {
      score += secondaryMatches.length * 32;
      reasons.addAll(secondaryMatches.map((value) => 'secondary:$value'));
      matchCount += secondaryMatches.length;
    }

    score += item.priorityScore * 12;
    if (item.isCore) {
      score += 24;
      reasons.add('core');
    }

    final recentPenalty = _recentPenalty(item.id, context.recentlySeenIds);
    if (recentPenalty > 0) {
      score -= recentPenalty;
      reasons.add('recent_penalty:$recentPenalty');
    }

    final isFallback = matchCount == 0;
    if (isFallback) {
      score += _fallbackBoost(item);
      reasons.add('fallback:${item.effectivePrimaryCategory}');
    }

    return DailyDuaCandidate(
      item: item,
      score: score,
      selectionReasons: List<String>.unmodifiable(reasons),
      contextMatchCount: matchCount,
      isFallback: isFallback,
    );
  }

  Set<String> _preferredPrimaryCategories(DailyDuaSelectionContext context) {
    final categories = <String>{};
    for (final value in context.timeContexts) {
      switch (value) {
        case 'morning':
          categories.addAll(<String>{'morning', 'waking'});
          break;
        case 'upon_waking':
          categories.addAll(<String>{'waking', 'morning'});
          break;
        case 'evening':
          categories.add('evening');
          break;
        case 'night':
        case 'before_sleep':
          categories.add('sleep');
          break;
      }
    }

    for (final value in context.prayerContexts) {
      switch (value) {
        case 'after_salah':
          categories.add('after_salah');
          break;
        case 'before_salah':
        case 'fajr_window':
        case 'jumuah':
          categories.addAll(<String>{'morning', 'special_moments'});
          break;
        case 'iftar':
        case 'suhoor':
          categories.add('fasting');
          break;
      }
    }

    for (final value in context.dateContexts) {
      switch (value) {
        case 'friday':
        case 'ramadan':
        case 'laylat_al_qadr':
        case 'eid':
        case 'arafah':
          categories.addAll(<String>{'special_moments', 'fasting'});
          break;
      }
    }

    for (final value in context.weatherContexts) {
      if (value == 'rain' ||
          value == 'wind' ||
          value == 'storm' ||
          value == 'thunder') {
        categories.add('weather');
      }
    }

    for (final value in context.locationContexts) {
      switch (value) {
        case 'home_entering':
        case 'home_leaving':
          categories.add('home');
          break;
        case 'masjid_entering':
        case 'masjid_leaving':
          categories.add('masjid');
          break;
        case 'travel':
        case 'new_place':
          categories.add('travel');
          break;
        case 'bathroom_entering':
        case 'bathroom_leaving':
          categories.add('daily_life');
          break;
      }
    }

    for (final value in context.situationContexts) {
      switch (value) {
        case 'forgiveness':
          categories.add('forgiveness');
          break;
        case 'illness':
          categories.add('illness');
          break;
        case 'sneezing':
        case 'good_news':
          categories.add('social_interactions');
          break;
        case 'gratitude':
          categories.add('food_drink');
          break;
      }
    }
    return categories;
  }

  int _recentPenalty(String itemId, List<String> recentIds) {
    final index = recentIds.indexOf(itemId);
    if (index < 0) return 0;
    return 180 - (index * 12);
  }

  int _fallbackBoost(DuaItem item) {
    if (item.isVerifiedStrong && item.isCore) return 60;
    if (item.isVerifiedStrong) return 40;
    return 0;
  }

  int _dailyRotationValue(String itemId, String dateKey) {
    final value = '$dateKey:$itemId';
    var hash = 0;
    for (final codeUnit in value.codeUnits) {
      hash = ((hash * 31) + codeUnit) & 0x7fffffff;
    }
    return hash;
  }
}

final dailyDuaContentServiceProvider = Provider<DailyDuaContentService>((ref) {
  return const DailyDuaContentService();
});

DailyDuaSelectionContext buildDefaultDailyDuaSelectionContext({
  required DateTime now,
  required String surface,
  required bool ramadanContextActive,
  required String? currentPrayerId,
  required String? nextPrayerId,
  List<String> recentlySeenIds = const <String>[],
  int maxItems = 3,
  bool allowGeneralVerified = false,
  bool excludeRecentlySeen = true,
  List<String> weatherContexts = const <String>[],
  List<String> locationContexts = const <String>[],
  List<String> situationContexts = const <String>[],
}) {
  final hijriDate = toHijriDate(now);
  final dateContexts = <String>{
    if (now.weekday == DateTime.friday) 'friday',
    if (ramadanContextActive || hijriDate.month == 9) 'ramadan',
  };
  final prayerContexts = <String>{
    if ((currentPrayerId ?? '').trim() == 'fajr') 'fajr_window',
    if (now.weekday == DateTime.friday &&
        ((currentPrayerId ?? '').trim() == 'dhuhr' ||
            (nextPrayerId ?? '').trim() == 'dhuhr'))
      'jumuah',
  };

  return DailyDuaSelectionContext(
    currentDateTime: now,
    surface: surface,
    timeContexts: dailyDuaTimeContextsFor(now),
    dateContexts: dateContexts.toList(growable: false),
    weatherContexts: weatherContexts,
    locationContexts: locationContexts,
    prayerContexts: prayerContexts.toList(growable: false),
    situationContexts: situationContexts,
    maxItems: maxItems,
    allowGeneralVerified: allowGeneralVerified,
    excludeRecentlySeen: excludeRecentlySeen,
    recentlySeenIds: recentlySeenIds,
  );
}

final dailyDuaSelectionContextProvider = Provider<DailyDuaSelectionContext>((
  ref,
) {
  final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
  final specialMode = ref.watch(specialModeProvider);
  final prayerContext = ref.watch(prayerScheduleContextProvider);
  final recentIds = ref.watch(duaLearningProvider).recentIds;
  return buildDefaultDailyDuaSelectionContext(
    now: now,
    surface: duaSurfaceInApp,
    ramadanContextActive:
        specialMode.isRamadan || specialMode.ramadanDateWindowActive,
    currentPrayerId: prayerContext.currentPrayerId,
    nextPrayerId: prayerContext.nextPrayerId,
    recentlySeenIds: recentIds,
  );
});

final currentDailyDuaPromptProvider = Provider<AsyncValue<DailyDuaCandidate?>>((
  ref,
) {
  final datasetAsync = ref.watch(duaDatasetProvider);
  final service = ref.watch(dailyDuaContentServiceProvider);
  final context = ref.watch(dailyDuaSelectionContextProvider);
  return datasetAsync.whenData(
    (dataset) => service.getBestMatch(dataset: dataset, context: context),
  );
});

final currentDailyDuaCandidatesProvider =
    Provider<AsyncValue<List<DailyDuaCandidate>>>((ref) {
      final datasetAsync = ref.watch(duaDatasetProvider);
      final service = ref.watch(dailyDuaContentServiceProvider);
      final context = ref.watch(dailyDuaSelectionContextProvider);
      return datasetAsync.whenData(
        (dataset) => service.getContextualDuaCandidates(
          dataset: dataset,
          context: context,
        ),
      );
    });

final currentDailyDuaBundleProvider = Provider<AsyncValue<DailyDuaBundle>>((
  ref,
) {
  final datasetAsync = ref.watch(duaDatasetProvider);
  final service = ref.watch(dailyDuaContentServiceProvider);
  final context = ref.watch(dailyDuaSelectionContextProvider);
  return datasetAsync.whenData(
    (dataset) => service.getDailyDuaBundle(dataset: dataset, context: context),
  );
});

List<String> dailyDuaTimeContextsFor(DateTime now) {
  final values = <String>[];
  final hour = now.hour;
  if (hour >= 4 && hour < 12) {
    values.add('morning');
    if (hour < 9) {
      values.add('upon_waking');
    }
  } else if (hour >= 12 && hour < 17) {
    values.add('afternoon');
  } else if (hour >= 17 && hour < 21) {
    values.add('evening');
  } else {
    values.add('night');
    if (hour >= 21 || hour <= 1) {
      values.add('before_sleep');
    }
  }
  values.add('any');
  return values;
}
