import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/journey_xp_repository.dart';
import '../domain/journey_xp_levels.dart';
import '../domain/journey_xp_models.dart';
import 'journey_xp_service.dart';

final journeyXpSummaryProvider =
    StateNotifierProvider<JourneyXpController, XpSummary>((ref) {
      return JourneyXpController(
        repository: ref.watch(journeyXpRepositoryProvider),
        service: ref.watch(journeyXpServiceProvider),
      );
    });

final currentXpLevelDefinitionProvider = Provider<LevelDefinition>((ref) {
  final summary = ref.watch(journeyXpSummaryProvider);
  return xpLevelForLevel(summary.currentLevel);
});

class JourneyXpController extends StateNotifier<XpSummary> {
  JourneyXpController({
    required JourneyXpRepository repository,
    required JourneyXpService service,
  }) : _repository = repository,
       _service = service,
       super(repository.getXpSummary());

  final JourneyXpRepository _repository;
  final JourneyXpService _service;

  void refresh() {
    state = _repository.getXpSummary();
  }

  List<XpLedgerEntry> awardPrayerXp({
    required String prayerId,
    required DateTime occurredAt,
    required String sourceRef,
    String sourceModule = 'prayer',
    String? dayKey,
    bool onTime = false,
    bool allFiveCompleted = false,
    bool inCongregation = false,
    bool isJumuah = false,
    bool eligibleForLaylatAlQadrMultiplier = false,
  }) {
    final entries = _service.awardPrayerXp(
      prayerId: prayerId,
      context: XpContext(
        sourceRef: sourceRef,
        sourceModule: sourceModule,
        occurredAt: occurredAt,
        eventDateKey: dayKey,
        eligibleForLaylatAlQadrMultiplier: eligibleForLaylatAlQadrMultiplier,
      ),
      onTime: onTime,
      allFiveCompleted: allFiveCompleted,
      inCongregation: inCongregation,
      isJumuah: isJumuah,
    );
    if (entries.isNotEmpty) refresh();
    return entries;
  }

  List<XpLedgerEntry> awardQuranXp({
    required String sourceRef,
    required DateTime occurredAt,
    String sourceModule = 'quran',
    String? dayKey,
    bool eligibleForLaylatAlQadrMultiplier = false,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {
    final entries = _service.awardQuranXp(
      context: XpContext(
        sourceRef: sourceRef,
        sourceModule: sourceModule,
        occurredAt: occurredAt,
        eventDateKey: dayKey,
        metadata: metadata,
        eligibleForLaylatAlQadrMultiplier: eligibleForLaylatAlQadrMultiplier,
      ),
    );
    if (entries.isNotEmpty) refresh();
    return entries;
  }

  List<XpLedgerEntry> awardLearningXp({
    required String sourceRef,
    required DateTime occurredAt,
    String sourceModule = 'learn',
    String? dayKey,
    bool eligibleForLaylatAlQadrMultiplier = false,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {
    final entries = _service.awardLearningXp(
      context: XpContext(
        sourceRef: sourceRef,
        sourceModule: sourceModule,
        occurredAt: occurredAt,
        eventDateKey: dayKey,
        metadata: metadata,
        eligibleForLaylatAlQadrMultiplier: eligibleForLaylatAlQadrMultiplier,
      ),
    );
    if (entries.isNotEmpty) refresh();
    return entries;
  }

  List<XpLedgerEntry> awardDhikrXp({
    required String sourceRef,
    required DateTime occurredAt,
    required bool completed,
    String sourceModule = 'dhikr',
    String? dayKey,
    bool eligibleForLaylatAlQadrMultiplier = false,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {
    final entries = _service.awardDhikrXp(
      context: XpContext(
        sourceRef: sourceRef,
        sourceModule: sourceModule,
        occurredAt: occurredAt,
        eventDateKey: dayKey,
        metadata: metadata,
        eligibleForLaylatAlQadrMultiplier: eligibleForLaylatAlQadrMultiplier,
      ),
      completed: completed,
    );
    if (entries.isNotEmpty) refresh();
    return entries;
  }

  List<XpLedgerEntry> awardFastingXp({
    required String sourceRef,
    required DateTime occurredAt,
    String sourceModule = 'fasting',
    String? dayKey,
    bool eligibleForLaylatAlQadrMultiplier = false,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {
    final entries = _service.awardFastingXp(
      context: XpContext(
        sourceRef: sourceRef,
        sourceModule: sourceModule,
        occurredAt: occurredAt,
        eventDateKey: dayKey,
        metadata: metadata,
        eligibleForLaylatAlQadrMultiplier: eligibleForLaylatAlQadrMultiplier,
      ),
    );
    if (entries.isNotEmpty) refresh();
    return entries;
  }

  List<XpLedgerEntry> awardTaraweehXp({
    required String sourceRef,
    required DateTime occurredAt,
    String sourceModule = 'prayer',
    String? dayKey,
    bool eligibleForLaylatAlQadrMultiplier = false,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {
    final entries = _service.awardTaraweehXp(
      context: XpContext(
        sourceRef: sourceRef,
        sourceModule: sourceModule,
        occurredAt: occurredAt,
        eventDateKey: dayKey,
        metadata: metadata,
        eligibleForLaylatAlQadrMultiplier: eligibleForLaylatAlQadrMultiplier,
      ),
    );
    if (entries.isNotEmpty) refresh();
    return entries;
  }

  List<XpLedgerEntry> awardQiyamXp({
    required String sourceRef,
    required DateTime occurredAt,
    String sourceModule = 'prayer',
    String? dayKey,
    bool eligibleForLaylatAlQadrMultiplier = false,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {
    final entries = _service.awardQiyamXp(
      context: XpContext(
        sourceRef: sourceRef,
        sourceModule: sourceModule,
        occurredAt: occurredAt,
        eventDateKey: dayKey,
        metadata: metadata,
        eligibleForLaylatAlQadrMultiplier: eligibleForLaylatAlQadrMultiplier,
      ),
    );
    if (entries.isNotEmpty) refresh();
    return entries;
  }
}
