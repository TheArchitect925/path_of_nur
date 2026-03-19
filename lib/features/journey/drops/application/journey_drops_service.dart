import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ocean/application/ocean_drops_provider.dart';
import '../data/journey_drops_repository.dart';
import '../domain/journey_drops_models.dart';

final journeyDropsOceanAdapterProvider = Provider<JourneyDropsOceanSink>((ref) {
  return JourneyDropsOceanAdapter(ref.watch(oceanDropServiceProvider));
});

final journeyDropsServiceProvider = Provider<JourneyDropsService>((ref) {
  return JourneyDropsService(
    ref.watch(journeyDropsRepositoryProvider),
    oceanAdapter: ref.watch(journeyDropsOceanAdapterProvider),
  );
});

abstract class JourneyDropsOceanSink {
  const JourneyDropsOceanSink();

  void incrementDrops(
    int amount, {
    required DropSourceType sourceType,
    required String sourceRef,
    required DateTime occurredAt,
    Map<String, Object?> metadata = const <String, Object?>{},
  });
}

class JourneyDropsOceanAdapter extends JourneyDropsOceanSink {
  const JourneyDropsOceanAdapter(this._oceanService);

  final OceanDropService _oceanService;

  @override
  void incrementDrops(
    int amount, {
    required DropSourceType sourceType,
    required String sourceRef,
    required DateTime occurredAt,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {
    _oceanService.incrementDrops(
      amount,
      sourceModule: _oceanSourceModuleFor(sourceType),
      referenceId: sourceRef,
      metadata: <String, dynamic>{
        'timestamp': occurredAt.toIso8601String(),
        ...metadata,
      },
    );
  }

  String _oceanSourceModuleFor(DropSourceType sourceType) {
    return switch (sourceType) {
      DropSourceType.prayer => oceanSourcePrayer,
      DropSourceType.dhikr => oceanSourceDhikr,
      DropSourceType.learning => oceanSourceLearn,
      DropSourceType.quran => oceanSourceQuran,
      DropSourceType.fasting => oceanSourceGrowth,
    };
  }
}

class JourneyDropsService {
  JourneyDropsService(
    this._repository, {
    required JourneyDropsOceanSink oceanAdapter,
  }) : _oceanAdapter = oceanAdapter;

  final JourneyDropsRepository _repository;
  final JourneyDropsOceanSink _oceanAdapter;

  DropEvent? awardDrop({
    required DropSourceType type,
    required String sourceRef,
    required DateTime occurredAt,
    String? eventDateKey,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {
    if (_repository.existsBySourceRef(sourceRef)) return null;
    final event = DropEvent(
      eventId: 'drop_${type.name}_$sourceRef',
      sourceType: type,
      sourceRef: sourceRef,
      eventDateKey: eventDateKey ?? dropEventDateKey(occurredAt),
      occurredAt: occurredAt,
      createdAt: DateTime.now(),
      metadata: metadata,
    );
    final inserted = _repository.insertDropEvent(event);
    if (!inserted) return null;
    _repository.recomputeDropSummary(now: occurredAt);
    _oceanAdapter.incrementDrops(
      1,
      sourceType: type,
      sourceRef: sourceRef,
      occurredAt: occurredAt,
      metadata: metadata,
    );
    return event;
  }

  bool hasDropForSource(String sourceRef) =>
      _repository.existsBySourceRef(sourceRef);

  DropSummary getSummary() => _repository.getDropSummary();

  List<DropEvent> getHistory() => _repository.fetchAllDrops();

  DropEvent? awardPrayerDrop({
    required String prayerId,
    required String dayKey,
    required DateTime occurredAt,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {
    return awardDrop(
      type: DropSourceType.prayer,
      sourceRef: 'prayer:$dayKey:$prayerId',
      occurredAt: occurredAt,
      eventDateKey: dayKey,
      metadata: <String, Object?>{'prayerId': prayerId, ...metadata},
    );
  }

  DropEvent? awardDhikrDrop({
    required String sourceRef,
    required DateTime occurredAt,
    bool completed = false,
    bool thresholdReached = false,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {
    if (!completed && !thresholdReached) return null;
    return awardDrop(
      type: DropSourceType.dhikr,
      sourceRef: sourceRef,
      occurredAt: occurredAt,
      metadata: <String, Object?>{
        if (completed) 'completed': true,
        if (thresholdReached) 'thresholdReached': true,
        ...metadata,
      },
    );
  }

  DropEvent? awardLearningDrop({
    required String sourceRef,
    required DateTime occurredAt,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {
    return awardDrop(
      type: DropSourceType.learning,
      sourceRef: sourceRef,
      occurredAt: occurredAt,
      metadata: metadata,
    );
  }

  DropEvent? awardQuranDrop({
    required String sourceRef,
    required DateTime occurredAt,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {
    return awardDrop(
      type: DropSourceType.quran,
      sourceRef: sourceRef,
      occurredAt: occurredAt,
      metadata: metadata,
    );
  }

  DropEvent? awardFastingDrop({
    required String sourceRef,
    required DateTime occurredAt,
    String? dayKey,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {
    return awardDrop(
      type: DropSourceType.fasting,
      sourceRef: sourceRef,
      occurredAt: occurredAt,
      eventDateKey: dayKey,
      metadata: metadata,
    );
  }
}
