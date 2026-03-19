import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/journey/drops/application/journey_drops_providers.dart';
import 'package:path_of_nur/features/journey/drops/application/journey_drops_service.dart';
import 'package:path_of_nur/features/journey/drops/data/journey_drops_repository.dart';
import 'package:path_of_nur/features/journey/drops/domain/garden_milestones.dart';
import 'package:path_of_nur/features/journey/drops/domain/journey_drops_models.dart';
import 'package:path_of_nur/shared/persistence/app_database.dart';

import '../../test_helpers/app_test_harness.dart';

class _FakeOceanSink extends JourneyDropsOceanSink {
  const _FakeOceanSink();

  @override
  void incrementDrops(
    int amount, {
    required DropSourceType sourceType,
    required String sourceRef,
    required DateTime occurredAt,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {}
}

void main() {
  test('duplicate prevention blocks repeated source refs', () {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final repository = JourneyDropsRepository(
      database: database,
      scopeId: 'test',
    );
    final service = JourneyDropsService(
      repository,
      oceanAdapter: const _FakeOceanSink(),
    );

    final first = service.awardLearningDrop(
      sourceRef: 'learning:lesson-alpha',
      occurredAt: DateTime(2026, 3, 18, 9),
    );
    final second = service.awardLearningDrop(
      sourceRef: 'learning:lesson-alpha',
      occurredAt: DateTime(2026, 3, 18, 10),
    );

    expect(first, isNotNull);
    expect(second, isNull);
    expect(repository.getDropSummary().totalDrops, 1);
  });

  test('summary counts lifetime and today totals correctly', () {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final repository = JourneyDropsRepository(
      database: database,
      scopeId: 'test',
    );
    final service = JourneyDropsService(
      repository,
      oceanAdapter: const _FakeOceanSink(),
    );

    service.awardPrayerDrop(
      prayerId: 'fajr',
      dayKey: '2026-03-18',
      occurredAt: DateTime(2026, 3, 18, 5, 15),
    );
    service.awardDhikrDrop(
      sourceRef: 'dhikr:session-1',
      occurredAt: DateTime(2026, 3, 18, 7),
      completed: true,
    );
    service.awardLearningDrop(
      sourceRef: 'learning:lesson-beta',
      occurredAt: DateTime(2026, 3, 17, 12),
    );
    service.awardQuranDrop(
      sourceRef: 'quran:lesson-gamma',
      occurredAt: DateTime(2026, 3, 18, 18),
    );

    final summary = repository.getDropSummary();
    expect(summary.totalDrops, 4);
    expect(summary.todayDrops, 3);
  });

  test('milestones unlock at the expected thresholds', () {
    expect(gardenMilestones.first.isUnlocked(1), isTrue);
    expect(gardenMilestones[1].isUnlocked(9), isFalse);
    expect(gardenMilestones[1].isUnlocked(10), isTrue);
    expect(gardenMilestones.last.isUnlocked(999), isFalse);
    expect(gardenMilestones.last.isUnlocked(1000), isTrue);
  });

  test('controller refreshes summary after award hooks', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final controller = container.read(journeyDropSummaryProvider.notifier);
    controller.awardPrayerDrop(
      prayerId: 'asr',
      dayKey: '2026-03-18',
      occurredAt: DateTime(2026, 3, 18, 16, 40),
    );

    final summary = container.read(journeyDropSummaryProvider);
    expect(summary.totalDrops, 1);
    expect(summary.todayDrops, 1);
  });
}
