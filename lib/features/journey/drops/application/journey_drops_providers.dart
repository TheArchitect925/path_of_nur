import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'garden_unlock_service.dart';
import '../data/journey_drops_repository.dart';
import '../domain/garden_milestones.dart';
import '../domain/journey_drops_models.dart';
import 'journey_drops_service.dart';

final journeyDropSummaryProvider =
    StateNotifierProvider<JourneyDropController, DropSummary>((ref) {
      return JourneyDropController(
        repository: ref.watch(journeyDropsRepositoryProvider),
        service: ref.watch(journeyDropsServiceProvider),
      );
    });

final journeyDropHistoryProvider = Provider<List<DropEvent>>((ref) {
  ref.watch(journeyDropSummaryProvider);
  return ref.watch(journeyDropsRepositoryProvider).fetchAllDrops();
});

final gardenMilestonesProvider = Provider<List<GardenMilestone>>((ref) {
  return gardenMilestones;
});

final nextGardenMilestoneProvider = Provider<GardenMilestone?>((ref) {
  final milestones = ref.watch(gardenMilestonesProvider);
  final totalDrops = ref.watch(journeyDropSummaryProvider).totalDrops;
  return ref.watch(gardenUnlockServiceProvider).nextLockedMilestone(
    milestones,
    totalDrops,
  );
});

final gardenProgressSummaryProvider = Provider<GardenProgressSummary>((ref) {
  final milestones = ref.watch(gardenMilestonesProvider);
  final totalDrops = ref.watch(journeyDropSummaryProvider).totalDrops;
  return ref.watch(gardenUnlockServiceProvider).buildProgressSummary(
    milestones,
    totalDrops: totalDrops,
  );
});

final unlockedGardenMilestonesProvider = Provider<List<GardenMilestone>>((ref) {
  final milestones = ref.watch(gardenMilestonesProvider);
  final totalDrops = ref.watch(journeyDropSummaryProvider).totalDrops;
  final service = ref.watch(gardenUnlockServiceProvider);
  return milestones
      .where((milestone) => service.isUnlocked(milestone, totalDrops))
      .toList(growable: false);
});

class JourneyDropController extends StateNotifier<DropSummary> {
  JourneyDropController({
    required JourneyDropsRepository repository,
    required JourneyDropsService service,
  }) : _repository = repository,
       _service = service,
       super(repository.getDropSummary());

  final JourneyDropsRepository _repository;
  final JourneyDropsService _service;

  void refresh() {
    state = _repository.getDropSummary();
  }

  DropEvent? awardPrayerDrop({
    required String prayerId,
    required String dayKey,
    required DateTime occurredAt,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {
    final event = _service.awardPrayerDrop(
      prayerId: prayerId,
      dayKey: dayKey,
      occurredAt: occurredAt,
      metadata: metadata,
    );
    if (event != null) refresh();
    return event;
  }

  DropEvent? awardDhikrDrop({
    required String sourceRef,
    required DateTime occurredAt,
    bool completed = false,
    bool thresholdReached = false,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {
    final event = _service.awardDhikrDrop(
      sourceRef: sourceRef,
      occurredAt: occurredAt,
      completed: completed,
      thresholdReached: thresholdReached,
      metadata: metadata,
    );
    if (event != null) refresh();
    return event;
  }

  DropEvent? awardLearningDrop({
    required String sourceRef,
    required DateTime occurredAt,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {
    final event = _service.awardLearningDrop(
      sourceRef: sourceRef,
      occurredAt: occurredAt,
      metadata: metadata,
    );
    if (event != null) refresh();
    return event;
  }

  DropEvent? awardQuranDrop({
    required String sourceRef,
    required DateTime occurredAt,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {
    final event = _service.awardQuranDrop(
      sourceRef: sourceRef,
      occurredAt: occurredAt,
      metadata: metadata,
    );
    if (event != null) refresh();
    return event;
  }

  DropEvent? awardFastingDrop({
    required String sourceRef,
    required DateTime occurredAt,
    String? dayKey,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {
    final event = _service.awardFastingDrop(
      sourceRef: sourceRef,
      occurredAt: occurredAt,
      dayKey: dayKey,
      metadata: metadata,
    );
    if (event != null) refresh();
    return event;
  }
}
