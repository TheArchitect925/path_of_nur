import 'dart:math' as math;

import 'package:intl/intl.dart';

class CommunityOceanStats {
  const CommunityOceanStats({
    required this.totalCommunityDrops,
    required this.todayCommunityDrops,
    required this.thisWeekCommunityDrops,
    required this.thisMonthCommunityDrops,
    required this.lastUpdatedAt,
  });

  final BigInt totalCommunityDrops;
  final BigInt todayCommunityDrops;
  final BigInt thisWeekCommunityDrops;
  final BigInt thisMonthCommunityDrops;
  final DateTime? lastUpdatedAt;

  CommunityOceanStats copyWith({
    BigInt? totalCommunityDrops,
    BigInt? todayCommunityDrops,
    BigInt? thisWeekCommunityDrops,
    BigInt? thisMonthCommunityDrops,
    DateTime? lastUpdatedAt,
    bool clearLastUpdatedAt = false,
  }) {
    return CommunityOceanStats(
      totalCommunityDrops: totalCommunityDrops ?? this.totalCommunityDrops,
      todayCommunityDrops: todayCommunityDrops ?? this.todayCommunityDrops,
      thisWeekCommunityDrops:
          thisWeekCommunityDrops ?? this.thisWeekCommunityDrops,
      thisMonthCommunityDrops:
          thisMonthCommunityDrops ?? this.thisMonthCommunityDrops,
      lastUpdatedAt: clearLastUpdatedAt
          ? null
          : (lastUpdatedAt ?? this.lastUpdatedAt),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'totalCommunityDrops': totalCommunityDrops.toString(),
    'todayCommunityDrops': todayCommunityDrops.toString(),
    'thisWeekCommunityDrops': thisWeekCommunityDrops.toString(),
    'thisMonthCommunityDrops': thisMonthCommunityDrops.toString(),
    'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
  };

  static CommunityOceanStats fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return CommunityOceanStats(
        totalCommunityDrops: BigInt.zero,
        todayCommunityDrops: BigInt.zero,
        thisWeekCommunityDrops: BigInt.zero,
        thisMonthCommunityDrops: BigInt.zero,
        lastUpdatedAt: null,
      );
    }
    return CommunityOceanStats(
      totalCommunityDrops: parseBigInt(json['totalCommunityDrops']),
      todayCommunityDrops: parseBigInt(json['todayCommunityDrops']),
      thisWeekCommunityDrops: parseBigInt(json['thisWeekCommunityDrops']),
      thisMonthCommunityDrops: parseBigInt(json['thisMonthCommunityDrops']),
      lastUpdatedAt: DateTime.tryParse(json['lastUpdatedAt']?.toString() ?? ''),
    );
  }
}

class PersonalWaterStats {
  const PersonalWaterStats({
    required this.totalPersonalDrops,
    required this.personalDropsToday,
    required this.personalDropsThisWeek,
    required this.personalDropsThisMonth,
    required this.lastContributionAt,
  });

  final BigInt totalPersonalDrops;
  final int personalDropsToday;
  final int personalDropsThisWeek;
  final int personalDropsThisMonth;
  final DateTime? lastContributionAt;

  PersonalWaterStats copyWith({
    BigInt? totalPersonalDrops,
    int? personalDropsToday,
    int? personalDropsThisWeek,
    int? personalDropsThisMonth,
    DateTime? lastContributionAt,
    bool clearLastContributionAt = false,
  }) {
    return PersonalWaterStats(
      totalPersonalDrops: totalPersonalDrops ?? this.totalPersonalDrops,
      personalDropsToday: personalDropsToday ?? this.personalDropsToday,
      personalDropsThisWeek:
          personalDropsThisWeek ?? this.personalDropsThisWeek,
      personalDropsThisMonth:
          personalDropsThisMonth ?? this.personalDropsThisMonth,
      lastContributionAt: clearLastContributionAt
          ? null
          : (lastContributionAt ?? this.lastContributionAt),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'totalPersonalDrops': totalPersonalDrops.toString(),
    'personalDropsToday': personalDropsToday,
    'personalDropsThisWeek': personalDropsThisWeek,
    'personalDropsThisMonth': personalDropsThisMonth,
    'lastContributionAt': lastContributionAt?.toIso8601String(),
  };

  static PersonalWaterStats fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return PersonalWaterStats(
        totalPersonalDrops: BigInt.zero,
        personalDropsToday: 0,
        personalDropsThisWeek: 0,
        personalDropsThisMonth: 0,
        lastContributionAt: null,
      );
    }
    return PersonalWaterStats(
      totalPersonalDrops: parseBigInt(json['totalPersonalDrops']),
      personalDropsToday: (json['personalDropsToday'] as num?)?.toInt() ?? 0,
      personalDropsThisWeek:
          (json['personalDropsThisWeek'] as num?)?.toInt() ?? 0,
      personalDropsThisMonth:
          (json['personalDropsThisMonth'] as num?)?.toInt() ?? 0,
      lastContributionAt: DateTime.tryParse(
        json['lastContributionAt']?.toString() ?? '',
      ),
    );
  }
}

class CommunityOceanStage {
  const CommunityOceanStage({
    required this.id,
    required this.title,
    required this.shortLabel,
    required this.requiredDrops,
    required this.description,
  });

  final String id;
  final String title;
  final String shortLabel;
  final BigInt requiredDrops;
  final String description;
}

class PersonalWaterStage {
  const PersonalWaterStage({
    required this.id,
    required this.title,
    required this.requiredDrops,
    required this.description,
  });

  final String id;
  final String title;
  final BigInt requiredDrops;
  final String description;
}

class StageProgress<T> {
  const StageProgress({
    required this.currentStage,
    required this.nextStage,
    required this.currentDrops,
    required this.previousThreshold,
    required this.nextThreshold,
    required this.progress,
    required this.dropsRemainingToNext,
    required this.hasReachedCurrentStage,
  });

  final T currentStage;
  final T? nextStage;
  final BigInt currentDrops;
  final BigInt previousThreshold;
  final BigInt? nextThreshold;
  final double progress;
  final BigInt dropsRemainingToNext;
  final bool hasReachedCurrentStage;
}

class ReadableWaterAmount {
  const ReadableWaterAmount({
    required this.value,
    required this.unit,
    required this.shortLabel,
  });

  final String value;
  final String unit;
  final String shortLabel;

  String get fullLabel => '$value $unit';
}

final List<CommunityOceanStage> communityOceanStages = <CommunityOceanStage>[
  CommunityOceanStage(
    id: 'spring',
    title: 'Spring',
    shortLabel: 'Spring',
    requiredDrops: BigInt.from(2000000),
    description: 'The first quiet gathering where shared drops begin to pool.',
  ),
  CommunityOceanStage(
    id: 'stream',
    title: 'Stream',
    shortLabel: 'Stream',
    requiredDrops: BigInt.from(1200000000),
    description:
        'A steady current shaped by many small acts arriving together.',
  ),
  CommunityOceanStage(
    id: 'pond',
    title: 'Pond',
    shortLabel: 'Pond',
    requiredDrops: BigInt.from(50000000000),
    description: 'Still water deep enough to reflect a wider sky.',
  ),
  CommunityOceanStage(
    id: 'lake',
    title: 'Lake',
    shortLabel: 'Lake',
    requiredDrops: BigInt.from(9600000000000),
    description:
        'A broad body of water formed by patient, persistent offering.',
  ),
  CommunityOceanStage(
    id: 'great_lake',
    title: 'Great Lake',
    shortLabel: 'Great Lake',
    requiredDrops: BigInt.parse('80000000000000000'),
    description: 'A scale that reminds the heart how much can gather slowly.',
  ),
  CommunityOceanStage(
    id: 'inland_sea',
    title: 'Inland Sea',
    shortLabel: 'Inland Sea',
    requiredDrops: BigInt.parse('33120000000000000000'),
    description:
        'An inland expanse carrying the weight of countless contributions.',
  ),
  CommunityOceanStage(
    id: 'great_waters',
    title: 'Great Waters',
    shortLabel: 'Great Waters',
    requiredDrops: BigInt.parse('451460000000000000000'),
    description: 'Waters so vast that the horizon itself begins to soften.',
  ),
  CommunityOceanStage(
    id: 'ocean_of_creation',
    title: 'Ocean of Creation',
    shortLabel: 'Ocean of Creation',
    requiredDrops: BigInt.parse('26700000000000000000000000'),
    description: 'A symbolic horizon of immensity, awe, and shared striving.',
  ),
];

final List<PersonalWaterStage> personalWaterStages = <PersonalWaterStage>[
  PersonalWaterStage(
    id: 'drop',
    title: 'Drop',
    requiredDrops: BigInt.one,
    description: 'A first offering has entered the water path.',
  ),
  PersonalWaterStage(
    id: 'ripple',
    title: 'Ripple',
    requiredDrops: BigInt.from(25),
    description: 'Small steady acts begin to leave a visible trace.',
  ),
  PersonalWaterStage(
    id: 'spring',
    title: 'Spring',
    requiredDrops: BigInt.from(100),
    description: 'Your path begins to gather into a gentle source.',
  ),
  PersonalWaterStage(
    id: 'stream',
    title: 'Stream',
    requiredDrops: BigInt.from(500),
    description: 'Consistency forms a living current of devotion.',
  ),
  PersonalWaterStage(
    id: 'brook',
    title: 'Brook',
    requiredDrops: BigInt.from(1500),
    description: 'A quiet brook shaped by regular acts over time.',
  ),
  PersonalWaterStage(
    id: 'pond',
    title: 'Pond',
    requiredDrops: BigInt.from(5000),
    description: 'Your drops begin to gather into something still and lasting.',
  ),
  PersonalWaterStage(
    id: 'quiet_lake',
    title: 'Quiet Lake',
    requiredDrops: BigInt.from(15000),
    description: 'A calmer depth now reflects a longer journey.',
  ),
  PersonalWaterStage(
    id: 'flowing_water',
    title: 'Flowing Water',
    requiredDrops: BigInt.from(50000),
    description: 'A mature, continuous current shaped by many sincere days.',
  ),
];

const List<String> communityOceanReflectionLines = <String>[
  'Small acts gather into deep waters.',
  'Every drop still matters.',
  'Vast creation, meaningful contribution.',
  'Today’s drops joined something greater.',
];

BigInt parseBigInt(Object? raw, {BigInt? fallback}) {
  final effectiveFallback = fallback ?? BigInt.zero;
  if (raw == null) return effectiveFallback;
  if (raw is BigInt) return raw;
  if (raw is int) return BigInt.from(raw);
  if (raw is num) return BigInt.from(raw.toInt());
  return BigInt.tryParse(raw.toString()) ?? effectiveFallback;
}

abstract class CommunityOceanSyncAdapter {
  const CommunityOceanSyncAdapter();

  BigInt resolveBaseline(BigInt existingBaseline);
}

class LocalCommunityOceanSyncAdapter extends CommunityOceanSyncAdapter {
  const LocalCommunityOceanSyncAdapter({this.seedCommunityDrops = '500000'});

  final String seedCommunityDrops;

  @override
  BigInt resolveBaseline(BigInt existingBaseline) {
    final configured = parseBigInt(seedCommunityDrops);
    return existingBaseline > configured ? existingBaseline : configured;
  }
}

class CommunityOceanLogic {
  const CommunityOceanLogic._();

  static final BigInt dropsPerMilliliter = BigInt.from(20);
  static final BigInt dropsPerLiter = BigInt.from(20000);
  static final BigInt dropsPerCubicMeter = BigInt.from(20000000);
  static final BigInt oceanOfCreationBenchmark =
      communityOceanStages.last.requiredDrops;

  static StageProgress<CommunityOceanStage> getCommunityStageProgress(
    BigInt totalDrops,
  ) {
    final current = getCurrentCommunityStage(totalDrops);
    final next = getNextCommunityStage(totalDrops);
    final previousThreshold = hasReachedAnyCommunityStage(totalDrops)
        ? current.requiredDrops
        : BigInt.zero;
    final nextThreshold = next?.requiredDrops;
    final currentProgress = _progressBetween(
      value: totalDrops,
      start: previousThreshold,
      end: nextThreshold ?? current.requiredDrops,
      clampAtOne: next == null,
    );
    return StageProgress<CommunityOceanStage>(
      currentStage: current,
      nextStage: next,
      currentDrops: totalDrops,
      previousThreshold: previousThreshold,
      nextThreshold: nextThreshold,
      progress: currentProgress,
      dropsRemainingToNext: next == null
          ? BigInt.zero
          : _positiveDifference(next.requiredDrops, totalDrops),
      hasReachedCurrentStage: hasReachedAnyCommunityStage(totalDrops),
    );
  }

  static CommunityOceanStage getCurrentCommunityStage(BigInt totalDrops) {
    for (final stage in communityOceanStages.reversed) {
      if (totalDrops >= stage.requiredDrops) {
        return stage;
      }
    }
    return communityOceanStages.first;
  }

  static CommunityOceanStage? getNextCommunityStage(BigInt totalDrops) {
    for (final stage in communityOceanStages) {
      if (totalDrops < stage.requiredDrops) {
        return stage;
      }
    }
    return null;
  }

  static BigInt getDropsRemainingToNextStage(BigInt totalDrops) {
    final next = getNextCommunityStage(totalDrops);
    if (next == null) return BigInt.zero;
    return _positiveDifference(next.requiredDrops, totalDrops);
  }

  static bool hasReachedAnyCommunityStage(BigInt totalDrops) {
    return totalDrops >= communityOceanStages.first.requiredDrops;
  }

  static StageProgress<PersonalWaterStage> getPersonalStageProgress(
    BigInt personalDrops,
  ) {
    final current = getCurrentPersonalStage(personalDrops);
    final next = getNextPersonalStage(personalDrops);
    final reachedCurrent = personalDrops >= current.requiredDrops;
    final previousThreshold = reachedCurrent
        ? current.requiredDrops
        : BigInt.zero;
    final nextThreshold = next?.requiredDrops;
    return StageProgress<PersonalWaterStage>(
      currentStage: current,
      nextStage: next,
      currentDrops: personalDrops,
      previousThreshold: previousThreshold,
      nextThreshold: nextThreshold,
      progress: _progressBetween(
        value: personalDrops,
        start: previousThreshold,
        end: nextThreshold ?? current.requiredDrops,
        clampAtOne: next == null,
      ),
      dropsRemainingToNext: next == null
          ? BigInt.zero
          : _positiveDifference(next.requiredDrops, personalDrops),
      hasReachedCurrentStage: reachedCurrent,
    );
  }

  static PersonalWaterStage getCurrentPersonalStage(BigInt personalDrops) {
    for (final stage in personalWaterStages.reversed) {
      if (personalDrops >= stage.requiredDrops) {
        return stage;
      }
    }
    return personalWaterStages.first;
  }

  static PersonalWaterStage? getNextPersonalStage(BigInt personalDrops) {
    for (final stage in personalWaterStages) {
      if (personalDrops < stage.requiredDrops) {
        return stage;
      }
    }
    return null;
  }

  static BigInt convertDropsToMilliliters(BigInt drops) {
    return drops ~/ dropsPerMilliliter;
  }

  static double convertDropsToLiters(BigInt drops) {
    return _bigIntToDouble(drops) / _bigIntToDouble(dropsPerLiter);
  }

  static double convertDropsToCubicMeters(BigInt drops) {
    return _bigIntToDouble(drops) / _bigIntToDouble(dropsPerCubicMeter);
  }

  static ReadableWaterAmount convertDropsToReadableWater(BigInt drops) {
    if (drops < dropsPerLiter) {
      final milliliters = _formatFractional(drops, dropsPerMilliliter, 2);
      return ReadableWaterAmount(
        value: milliliters,
        unit: 'mL',
        shortLabel: '$milliliters mL',
      );
    }
    if (drops < dropsPerCubicMeter) {
      final liters = _formatFractional(drops, dropsPerLiter, 2);
      return ReadableWaterAmount(
        value: liters,
        unit: 'L',
        shortLabel: '$liters L',
      );
    }
    final cubicMeters = _formatFractional(drops, dropsPerCubicMeter, 2);
    return ReadableWaterAmount(
      value: cubicMeters,
      unit: 'm³',
      shortLabel: '$cubicMeters m³',
    );
  }

  static String formatLargeDropCount(BigInt drops) {
    const suffixes = <String>[
      '',
      'K',
      'M',
      'B',
      'T',
      'Q',
      'Qi',
      'Sx',
      'Sp',
      'Oc',
      'No',
    ];
    var value = drops;
    var suffixIndex = 0;
    final thousand = BigInt.from(1000);
    while (value >= thousand && suffixIndex < suffixes.length - 1) {
      value = value ~/ thousand;
      suffixIndex += 1;
    }

    if (suffixIndex == 0) return drops.toString();

    final divisor = thousand.pow(suffixIndex);
    final whole = drops ~/ divisor;
    final remainder = drops % divisor;
    final tenths = ((remainder * BigInt.from(10)) ~/ divisor).toInt();
    if (whole >= BigInt.from(100) || tenths == 0) {
      return '${whole.toString()}${suffixes[suffixIndex]}';
    }
    return '${whole.toString()}.$tenths${suffixes[suffixIndex]}';
  }

  static String formatLargeDropCountForLocale(BigInt drops, String locale) {
    const suffixes = <String>[
      '',
      'K',
      'M',
      'B',
      'T',
      'Q',
      'Qi',
      'Sx',
      'Sp',
      'Oc',
      'No',
    ];
    var value = drops;
    var suffixIndex = 0;
    final thousand = BigInt.from(1000);
    while (value >= thousand && suffixIndex < suffixes.length - 1) {
      value = value ~/ thousand;
      suffixIndex += 1;
    }

    if (suffixIndex == 0) {
      return NumberFormat.decimalPattern(locale).format(
        int.tryParse(drops.toString()) ?? double.parse(drops.toString()),
      );
    }

    final divisor = thousand.pow(suffixIndex);
    final whole = drops ~/ divisor;
    final remainder = drops % divisor;
    final tenths = ((remainder * BigInt.from(10)) ~/ divisor).toInt();
    final formattedWhole = NumberFormat.decimalPattern(
      locale,
    ).format(int.tryParse(whole.toString()) ?? double.parse(whole.toString()));
    if (whole >= BigInt.from(100) || tenths == 0) {
      return '$formattedWhole${suffixes[suffixIndex]}';
    }
    return '$formattedWhole.$tenths${suffixes[suffixIndex]}';
  }

  static String formatReadablePercentage(double value) {
    final percentage = (value * 100).clamp(0, 100);
    if (percentage >= 10) return '${percentage.toStringAsFixed(0)}%';
    if (percentage >= 1) return '${percentage.toStringAsFixed(1)}%';
    if (percentage <= 0) return '0%';
    return '<1%';
  }

  static String formatReadablePercentageForLocale(double value, String locale) {
    final percentage = (value * 100).clamp(0, 100);
    if (percentage >= 10) {
      return '${NumberFormat.decimalPattern(locale).format(percentage.round())}%';
    }
    if (percentage >= 1) {
      return '${NumberFormat.decimalPatternDigits(locale: locale, decimalDigits: 1).format(percentage)}%';
    }
    if (percentage <= 0) return '0%';
    return '<1%';
  }

  static String formatContributionPercent({
    required BigInt contribution,
    required BigInt total,
  }) {
    if (total <= BigInt.zero || contribution <= BigInt.zero) return '0%';
    final ratio = _bigIntToDouble(contribution) / _bigIntToDouble(total);
    return formatReadablePercentage(ratio);
  }

  static String formatContributionPercentForLocale({
    required BigInt contribution,
    required BigInt total,
    required String locale,
  }) {
    if (total <= BigInt.zero || contribution <= BigInt.zero) return '0%';
    final ratio = _bigIntToDouble(contribution) / _bigIntToDouble(total);
    return formatReadablePercentageForLocale(ratio, locale);
  }

  static String formatReadableStageDistance(BigInt drops) {
    final water = convertDropsToReadableWater(drops);
    return '${formatLargeDropCount(drops)} drops • ${water.shortLabel}';
  }

  static double oceanBenchmarkProgress(BigInt communityDrops) {
    return _progressBetween(
      value: communityDrops,
      start: BigInt.zero,
      end: oceanOfCreationBenchmark,
    );
  }

  static double _progressBetween({
    required BigInt value,
    required BigInt start,
    required BigInt end,
    bool clampAtOne = false,
  }) {
    final span = end - start;
    if (span <= BigInt.zero) return 1;
    final offset = value - start;
    final ratio = _bigIntToDouble(offset) / _bigIntToDouble(span);
    final max = clampAtOne ? 1.0 : math.max(1.0, ratio);
    return ratio.clamp(0.0, max);
  }

  static BigInt _positiveDifference(BigInt target, BigInt current) {
    final difference = target - current;
    return difference > BigInt.zero ? difference : BigInt.zero;
  }

  static double _bigIntToDouble(BigInt value) {
    return double.parse(value.toString());
  }

  static String _formatFractional(
    BigInt numerator,
    BigInt denominator,
    int scale,
  ) {
    final whole = numerator ~/ denominator;
    final remainder = numerator % denominator;
    if (remainder == BigInt.zero) return whole.toString();

    final factor = BigInt.from(math.pow(10, scale).toInt());
    final fraction = ((remainder * factor) ~/ denominator).toString().padLeft(
      scale,
      '0',
    );
    final trimmed = fraction.replaceFirst(RegExp(r'0+$'), '');
    if (trimmed.isEmpty) return whole.toString();
    return '${whole.toString()}.$trimmed';
  }
}
