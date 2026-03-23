import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_of_nur/features/worship/application/prayer_controller.dart';
import 'package:path_of_nur/features/worship/data/prayer_log_repository.dart';
import 'package:path_of_nur/features/worship/domain/prayer_name.dart';
import 'package:path_of_nur/features/worship/domain/prayer_status.dart';
import 'package:path_of_nur/features/worship/domain/prayer_tracker_fields.dart';
import 'package:path_of_nur/shared/persistence/app_database.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:path_of_nur/features/journey/xp/application/journey_xp_providers.dart';
import 'package:path_of_nur/features/worship/application/dhikr_controller.dart';

void main() {
  Future<ProviderContainer> makePrayerContainer({
    AppDatabase? database,
    Map<String, Object> seed = const <String, Object>{},
  }) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'app.onboardingCompleted': true,
      ...seed,
    });
    final prefs = await SharedPreferences.getInstance();
    final appDatabase = database ?? AppDatabase.inMemory();
    return ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(appDatabase),
      ],
    );
  }

  test(
    'prayer controller persists completion and summary for active day',
    () async {
      final container = await makePrayerContainer();
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
    },
  );

  test(
    'prayer controller reloads persisted state for another container',
    () async {
      final database = AppDatabase.inMemory();
      addTearDown(database.close);
      final containerA = await makePrayerContainer(database: database);
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
    },
  );

  test(
    'duplicate writes settle into the expected final status without corruption',
    () async {
      final container = await makePrayerContainer();
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
    },
  );

  test(
    'quick completion records offered time and preserves later metadata updates',
    () async {
      final container = await makePrayerContainer();
      addTearDown(container.dispose);
      final notifier = container.read(prayerControllerProvider.notifier);

      notifier.markCompleted(PrayerName.fajr);
      final initialEntry = notifier.readActiveDayEntry(PrayerName.fajr);

      expect(initialEntry?.status, PrayerStatus.completed);
      expect(initialEntry?.completedAtIso, isNotNull);
      expect(initialEntry?.timing, isNull);
      expect(initialEntry?.place, isNull);

      notifier.saveCompletionDetails(
        PrayerName.fajr,
        timing: PrayerOfferTiming.onTime,
        place: PrayerOfferPlace.congregation,
      );

      final updatedEntry = container
          .read(prayerLogRepositoryProvider)
          .readDayEntries(LocalStore.todayKey())[PrayerName.fajr];
      expect(updatedEntry?.completedAtIso, initialEntry?.completedAtIso);
      expect(updatedEntry?.timing, PrayerOfferTiming.onTime);
      expect(updatedEntry?.place, PrayerOfferPlace.congregation);
    },
  );

  test(
    'detail edits award prayer context xp safely without duplicate bonuses',
    () async {
      final container = await makePrayerContainer();
      addTearDown(container.dispose);
      final notifier = container.read(prayerControllerProvider.notifier);

      notifier.markCompleted(PrayerName.fajr);
      expect(container.read(journeyXpSummaryProvider).totalXp, 12);

      notifier.saveCompletionDetails(
        PrayerName.fajr,
        timing: PrayerOfferTiming.onTime,
        place: PrayerOfferPlace.congregation,
      );
      expect(container.read(journeyXpSummaryProvider).totalXp, 22);

      notifier.saveCompletionDetails(
        PrayerName.fajr,
        timing: PrayerOfferTiming.onTime,
        place: PrayerOfferPlace.congregation,
      );
      expect(container.read(journeyXpSummaryProvider).totalXp, 22);

      notifier.saveCompletionDetails(
        PrayerName.fajr,
        timing: PrayerOfferTiming.onTime,
        place: PrayerOfferPlace.masjid,
      );
      expect(container.read(journeyXpSummaryProvider).totalXp, 26);
    },
  );

  test(
    'post-salah dhikr logging is linked once and does not duplicate on repeat taps',
    () async {
      final container = await makePrayerContainer();
      addTearDown(container.dispose);
      final notifier = container.read(prayerControllerProvider.notifier);

      notifier.markCompleted(PrayerName.maghrib);

      final first = notifier.logPostSalahDhikr(PrayerName.maghrib);
      final second = notifier.logPostSalahDhikr(PrayerName.maghrib);

      final record = container
          .read(prayerLogRepositoryProvider)
          .readDayEntries(LocalStore.todayKey())[PrayerName.maghrib];
      final dhikrState = container.read(dhikrControllerProvider);

      expect(first, isTrue);
      expect(second, isFalse);
      expect(record?.postSalahAdhkarCompletedAtIso, isNotNull);
      expect(dhikrState.recentSessions, hasLength(1));
      expect(dhikrState.recentSessions.first.phraseLabel, 'Post-Salah Dhikr');
      expect(dhikrState.recentSessions.first.count, 100);
      expect(container.read(journeyXpSummaryProvider).totalXp, 16);
    },
  );
}
