import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/journey_xp_repository.dart';
import '../domain/journey_xp_models.dart';

final journeyXpServiceProvider = Provider<JourneyXpService>((ref) {
  return JourneyXpService(ref.watch(journeyXpRepositoryProvider));
});

class JourneyXpRuleConfig {
  const JourneyXpRuleConfig({
    this.prayerCompleted = 12,
    this.prayerOnTimeBonus = 4,
    this.allFivePrayersBonus = 15,
    this.congregationPrayerBonus = 6,
    this.jumuahBonus = 12,
    this.quranRead = 5,
    this.learningCompleted = 10,
    this.dhikrSetCompleted = 4,
    this.fastingDay = 18,
    this.taraweehCompleted = 10,
    this.qiyamCompleted = 12,
    this.laylatAlQadrMultiplier = 5,
    this.laylatAlQadrMultiplierEnabled = false,
  });

  final int prayerCompleted;
  final int prayerOnTimeBonus;
  final int allFivePrayersBonus;
  final int congregationPrayerBonus;
  final int jumuahBonus;
  final int quranRead;
  final int learningCompleted;
  final int dhikrSetCompleted;
  final int fastingDay;
  final int taraweehCompleted;
  final int qiyamCompleted;
  final int laylatAlQadrMultiplier;
  final bool laylatAlQadrMultiplierEnabled;
}

class JourneyXpService {
  JourneyXpService(
    this._repository, {
    JourneyXpRuleConfig config = const JourneyXpRuleConfig(),
  }) : _config = config;

  final JourneyXpRepository _repository;
  final JourneyXpRuleConfig _config;

  List<XpLedgerEntry> awardPrayerXp({
    required String prayerId,
    required XpContext context,
    bool onTime = false,
    bool allFiveCompleted = false,
    bool inCongregation = false,
    bool isJumuah = false,
  }) {
    final entries = <XpLedgerEntry>[];
    entries.addAll(
      _awardSingle(
        eventType: XpEventType.prayerCompleted,
        xp: _config.prayerCompleted,
        context: context,
        metadata: <String, Object?>{'prayerId': prayerId},
      ),
    );
    if (onTime) {
      entries.addAll(
        _awardSingle(
          eventType: XpEventType.prayerOnTimeBonus,
          xp: _config.prayerOnTimeBonus,
          context: context,
          metadata: <String, Object?>{
            'prayerId': prayerId,
            'timing': 'on_time',
          },
        ),
      );
    }
    if (inCongregation) {
      entries.addAll(
        _awardSingle(
          eventType: XpEventType.congregationPrayerBonus,
          xp: _config.congregationPrayerBonus,
          context: context,
          metadata: <String, Object?>{'prayerId': prayerId},
        ),
      );
    }
    if (allFiveCompleted) {
      entries.addAll(
        _awardSingle(
          eventType: XpEventType.allFivePrayersBonus,
          xp: _config.allFivePrayersBonus,
          context: context.copyWith(
            sourceRef: 'all_five_prayers:${context.resolvedEventDateKey}',
          ),
          metadata: <String, Object?>{'dayKey': context.resolvedEventDateKey},
        ),
      );
    }
    if (isJumuah) {
      entries.addAll(
        _awardSingle(
          eventType: XpEventType.jumuahBonus,
          xp: _config.jumuahBonus,
          context: context.copyWith(
            sourceRef: 'jumuah:${context.resolvedEventDateKey}',
          ),
          metadata: <String, Object?>{'dayKey': context.resolvedEventDateKey},
        ),
      );
    }
    if (entries.isNotEmpty) {
      _repository.recomputeXpSummary(now: context.occurredAt);
    }
    return entries;
  }

  List<XpLedgerEntry> awardQuranXp({required XpContext context}) {
    final entries = _awardSingle(
      eventType: XpEventType.quranRead,
      xp: _config.quranRead,
      context: context,
    );
    if (entries.isNotEmpty) {
      _repository.recomputeXpSummary(now: context.occurredAt);
    }
    return entries;
  }

  List<XpLedgerEntry> awardLearningXp({
    required XpContext context,
    int? xp,
  }) {
    final entries = _awardSingle(
      eventType: XpEventType.learningCompleted,
      xp: xp ?? _config.learningCompleted,
      context: context,
    );
    if (entries.isNotEmpty) {
      _repository.recomputeXpSummary(now: context.occurredAt);
    }
    return entries;
  }

  List<XpLedgerEntry> awardDhikrXp({
    required XpContext context,
    required bool completed,
  }) {
    if (!completed) return const <XpLedgerEntry>[];
    final entries = _awardSingle(
      eventType: XpEventType.dhikrSetCompleted,
      xp: _config.dhikrSetCompleted,
      context: context,
    );
    if (entries.isNotEmpty) {
      _repository.recomputeXpSummary(now: context.occurredAt);
    }
    return entries;
  }

  List<XpLedgerEntry> awardFastingXp({required XpContext context}) {
    final entries = _awardSingle(
      eventType: XpEventType.fastingDay,
      xp: _config.fastingDay,
      context: context.copyWith(
        sourceRef:
            'fasting:${context.resolvedEventDateKey}:${context.sourceRef}',
      ),
    );
    if (entries.isNotEmpty) {
      _repository.recomputeXpSummary(now: context.occurredAt);
    }
    return entries;
  }

  List<XpLedgerEntry> awardTaraweehXp({required XpContext context}) {
    final entries = _awardSingle(
      eventType: XpEventType.taraweehCompleted,
      xp: _config.taraweehCompleted,
      context: context,
    );
    if (entries.isNotEmpty) {
      _repository.recomputeXpSummary(now: context.occurredAt);
    }
    return entries;
  }

  List<XpLedgerEntry> awardQiyamXp({required XpContext context}) {
    final entries = _awardSingle(
      eventType: XpEventType.qiyamCompleted,
      xp: _config.qiyamCompleted,
      context: context,
    );
    if (entries.isNotEmpty) {
      _repository.recomputeXpSummary(now: context.occurredAt);
    }
    return entries;
  }

  List<XpLedgerEntry> _awardSingle({
    required XpEventType eventType,
    required int xp,
    required XpContext context,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {
    if (_repository.hasLedgerEntryForSource(eventType, context.sourceRef)) {
      return const <XpLedgerEntry>[];
    }
    final mergedMetadata = <String, Object?>{...context.metadata, ...metadata};
    final entry = XpLedgerEntry(
      entryId:
          'xp_${eventType.name}_${context.sourceRef}_${context.occurredAt.microsecondsSinceEpoch}',
      eventType: eventType,
      sourceRef: context.sourceRef,
      sourceModule: context.sourceModule,
      eventDateKey: context.resolvedEventDateKey,
      occurredAt: context.occurredAt,
      baseXp: xp,
      awardedXp: xp,
      createdAt: DateTime.now(),
      metadata: mergedMetadata,
    );
    final inserted = _repository.addLedgerEntry(entry);
    if (!inserted) return const <XpLedgerEntry>[];

    final results = <XpLedgerEntry>[entry];
    final multiplierEntry = _maybeLaylatMultiplierEntry(
      baseEntry: entry,
      context: context,
    );
    if (multiplierEntry != null &&
        _repository.addLedgerEntry(multiplierEntry)) {
      results.add(multiplierEntry);
    }
    return results;
  }

  XpLedgerEntry? _maybeLaylatMultiplierEntry({
    required XpLedgerEntry baseEntry,
    required XpContext context,
  }) {
    if (!_config.laylatAlQadrMultiplierEnabled ||
        !context.eligibleForLaylatAlQadrMultiplier ||
        _config.laylatAlQadrMultiplier <= 1) {
      return null;
    }
    final bonusXp = baseEntry.awardedXp * (_config.laylatAlQadrMultiplier - 1);
    if (bonusXp <= 0) return null;
    return XpLedgerEntry(
      entryId: 'xp_laylat_${baseEntry.entryId}',
      eventType: XpEventType.laylatAlQadrMultiplier,
      sourceRef: '${baseEntry.sourceRef}:laylat',
      sourceModule: baseEntry.sourceModule,
      eventDateKey: baseEntry.eventDateKey,
      occurredAt: baseEntry.occurredAt,
      baseXp: bonusXp,
      awardedXp: bonusXp,
      createdAt: DateTime.now(),
      metadata: <String, Object?>{
        'baseEventType': baseEntry.eventType.name,
        'multiplier': _config.laylatAlQadrMultiplier,
      },
    );
  }
}
