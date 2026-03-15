import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/worship/application/prayer_controller.dart';
import 'package:path_of_nur/features/worship/data/prayer_log_repository.dart';
import 'package:path_of_nur/features/worship/domain/prayer_name.dart';
import 'package:path_of_nur/features/worship/domain/prayer_status.dart';
import 'package:path_of_nur/shared/persistence/app_database.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  test('prayer controller persists completion and summary for active day', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final notifier = container.read(prayerControllerProvider.notifier);
    notifier.cycleStatus(PrayerName.fajr);

    final records = container.read(prayerControllerProvider);
    final summary = container.read(prayerSummaryProvider);
    final stored = container
        .read(prayerLogRepositoryProvider)
        .readDayEntries(LocalStore.todayKey());

    expect(
      records.firstWhere((record) => record.prayer == PrayerName.fajr).status,
      PrayerStatus.completed,
    );
    expect(summary.completed, 1);
    expect(summary.total, 5);
    expect(stored[PrayerName.fajr]?.status, PrayerStatus.completed);
  });

  test('prayer controller reloads persisted state for another container', () async {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final containerA = await makeTestContainer(database: database);
    addTearDown(containerA.dispose);
    final notifierA = containerA.read(prayerControllerProvider.notifier);
    notifierA.cycleStatus(PrayerName.asr);

    final prefs = containerA.read(sharedPreferencesProvider);
    final containerB = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(database),
      ],
    );
    addTearDown(containerB.dispose);

    final records = containerB.read(prayerControllerProvider);
    expect(
      records.firstWhere((record) => record.prayer == PrayerName.asr).status,
      PrayerStatus.completed,
    );
  });

  test('duplicate writes settle into the expected final status without corruption', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    final notifier = container.read(prayerControllerProvider.notifier);

    notifier.cycleStatus(PrayerName.maghrib);
    notifier.cycleStatus(PrayerName.maghrib);

    final record = container
        .read(prayerControllerProvider)
        .firstWhere((item) => item.prayer == PrayerName.maghrib);
    final stored = container
        .read(prayerLogRepositoryProvider)
        .readDayEntries(LocalStore.todayKey());

    expect(record.status, PrayerStatus.missed);
    expect(stored[PrayerName.maghrib]?.status, PrayerStatus.missed);
    expect(record.completedAtIso, isNull);
  });
}
