import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/ocean/application/ocean_drops_provider.dart';
import 'package:path_of_nur/shared/persistence/app_database.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  test('ocean drops deduplicate same prayer reward on the same logical day', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    final service = container.read(oceanDropServiceProvider);

    final first = service.awardDrop(
      actionType: oceanActionPrayerCompleted,
      sourceModule: oceanSourcePrayer,
      referenceId: 'fajr',
      metadata: const <String, dynamic>{'timestamp': '2026-03-14T05:15:00'},
    );
    final second = service.awardDrop(
      actionType: oceanActionPrayerCompleted,
      sourceModule: oceanSourcePrayer,
      referenceId: 'fajr',
      metadata: const <String, dynamic>{'timestamp': '2026-03-14T05:20:00'},
    );

    expect(first, 1);
    expect(second, 0);
    expect(service.getTotalDrops(), 1);
    expect(container.read(oceanDropsProvider).events, hasLength(1));
  });

  test('ocean drops persist and rebuild deterministically after reload', () async {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final containerA = await makeTestContainer(database: database);
    addTearDown(containerA.dispose);
    final serviceA = containerA.read(oceanDropServiceProvider);

    serviceA.awardDrop(
      actionType: oceanActionPrayerCompleted,
      sourceModule: oceanSourcePrayer,
      referenceId: 'dhuhr',
      metadata: const <String, dynamic>{'timestamp': '2026-03-14T13:10:00'},
    );
    serviceA.awardDrop(
      actionType: oceanActionLearningSegmentCompleted,
      sourceModule: oceanSourceLearn,
      referenceId: 'lesson-1',
      metadata: const <String, dynamic>{'timestamp': '2026-03-14T19:10:00'},
    );

    final prefs = containerA.read(sharedPreferencesProvider);
    final containerB = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(database),
      ],
    );
    addTearDown(containerB.dispose);

    final state = containerB.read(oceanDropsProvider);
    expect(state.stats.totalDropsLifetime, 2);
    expect(state.events.map((event) => event.sourceModule).toSet(), containsAll(<String>{
      oceanSourcePrayer,
      oceanSourceLearn,
    }));
  });

  test('free dhikr carry awards only when 100-count threshold is crossed', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    final service = container.read(oceanDropServiceProvider);

    final first = service.awardDrop(
      actionType: oceanActionDhikrFreeHundredReached,
      sourceModule: oceanSourceDhikr,
      referenceId: 'global',
      metadata: const <String, dynamic>{
        'countDelta': 70,
        'timestamp': '2026-03-14T20:00:00',
      },
    );
    final second = service.awardDrop(
      actionType: oceanActionDhikrFreeHundredReached,
      sourceModule: oceanSourceDhikr,
      referenceId: 'global',
      metadata: const <String, dynamic>{
        'countDelta': 40,
        'timestamp': '2026-03-14T20:10:00',
      },
    );

    expect(first, 0);
    expect(second, 1);
    expect(container.read(oceanDropsProvider).stats.freeDhikrCarryCount, 10);
  });
}
