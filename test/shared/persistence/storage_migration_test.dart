import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_of_nur/features/ocean/application/ocean_drops_provider.dart';
import 'package:path_of_nur/features/worship/data/dhikr_repository.dart';
import 'package:path_of_nur/features/worship/data/prayer_log_repository.dart';
import 'package:path_of_nur/features/worship/domain/prayer_name.dart';
import 'package:path_of_nur/features/worship/domain/prayer_status.dart';
import 'package:path_of_nur/shared/persistence/app_database.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

void main() {
  Future<(LocalStore, AppDatabase)> setUpStores(Map<String, Object> seed) async {
    SharedPreferences.setMockInitialValues(seed);
    final prefs = await SharedPreferences.getInstance();
    final localStore = LocalStore(prefs);
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    return (localStore, database);
  }

  test('prayer repository migrates legacy day records and is idempotent', () async {
    final (localStore, database) = await setUpStores(<String, Object>{
      'worship.prayer.2026-03-14':
          '{"fajr":{"status":"completed","completedAtIso":"2026-03-14T05:11:00"},"dhuhr":{"status":"pending","completedAtIso":null}}',
    });

    final repository = PrayerLogRepository(
      database: database,
      legacyStore: localStore,
      scopeId: 'profile-a',
    );

    final first = repository.readDailyRecords('2026-03-14');
    final second = repository.readDailyRecords('2026-03-14');

    expect(
      first.firstWhere((record) => record.prayer == PrayerName.fajr).status,
      PrayerStatus.completed,
    );
    expect(second.length, 5);
    expect(
      database.meta('migration.prayer_logs.v1.profile-a'),
      'done',
    );
  });

  test('dhikr repository migrates and round-trips legacy state safely', () async {
    final (localStore, database) = await setUpStores(<String, Object>{
      'worship.dhikr':
          '{"selectedPresetId":"subhanallah","target":99,"currentCount":17,"recentSessions":[{"phraseLabel":"SubhanAllah","count":33,"target":33,"startedAt":"2026-03-14T09:00:00","finishedAt":"2026-03-14T09:02:00"}]}',
    });

    final repository = DhikrRepository(
      database: database,
      legacyStore: localStore,
      scopeId: 'profile-a',
    );

    final initial = repository.load();
    repository.saveState(
      selectedPresetId: initial.selectedPresetId,
      target: initial.target,
      currentCount: 18,
    );
    final reloaded = repository.load();

    expect(initial.target, 99);
    expect(initial.currentCount, 17);
    expect(initial.recentSessions, hasLength(1));
    expect(reloaded.currentCount, 18);
    expect(database.meta('migration.dhikr.v1.profile-a'), 'done');
  });

  test('ocean repository migrates legacy blob and keeps dedup-relevant events stable', () async {
    final (localStore, database) = await setUpStores(<String, Object>{
      'journey.oceanDrops.v2':
          '{"stats":{"totalDropsLifetime":1,"dropsToday":1,"dropsThisWeek":1,"dropsThisMonth":1,"freeDhikrCarryCount":0,"lastDropAwardedAt":"2026-03-14T13:10:00"},"personalStats":{},"communityStats":{},"events":[{"id":"prayer_completed|prayer|dhuhr|2026-03-14","timestamp":"2026-03-14T13:10:00","actionType":"prayer_completed","sourceModule":"prayer","amount":1,"referenceId":"dhuhr","metadata":{"timestamp":"2026-03-14T13:10:00"}}],"dailyDropHistory":{"2026-03-14":1},"awardedEligibilityKeys":["prayer_completed|prayer|dhuhr|2026-03-14"],"freeDhikrBlocksAwarded":0,"communityBaselineDrops":"500000"}',
    });

    final repository = OceanDropsRepository(
      database: database,
      legacyStore: localStore,
      scopeId: 'profile-a',
    );

    final first = repository.load();
    final second = repository.load();

    expect(first.events, hasLength(1));
    expect(first.awardedEligibilityKeys, contains('prayer_completed|prayer|dhuhr|2026-03-14'));
    expect(second.dailyDropHistory['2026-03-14'], 1);
    expect(database.meta('migration.ocean_drops.v1.profile-a'), 'done');
  });

  test('repositories handle malformed or empty legacy data without crashing', () async {
    final (localStore, database) = await setUpStores(<String, Object>{
      'worship.prayer.2026-03-14': '[]',
      'worship.dhikr': '"bad"',
      'journey.oceanDrops.v2': '{"events":"bad"}',
    });

    final prayerRepository = PrayerLogRepository(
      database: database,
      legacyStore: localStore,
      scopeId: 'profile-a',
    );
    final dhikrRepository = DhikrRepository(
      database: database,
      legacyStore: localStore,
      scopeId: 'profile-a',
    );
    final oceanRepository = OceanDropsRepository(
      database: database,
      legacyStore: localStore,
      scopeId: 'profile-a',
    );

    expect(() => prayerRepository.readDailyRecords('2026-03-14'), returnsNormally);
    expect(() => dhikrRepository.load(), returnsNormally);
    expect(() => oceanRepository.load(), returnsNormally);
  });
}
