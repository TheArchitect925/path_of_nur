import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/journey/application/growth_statistics_provider.dart';
import 'package:path_of_nur/features/journey/application/journey_stats_provider.dart';
import 'package:path_of_nur/features/journey/drops/data/journey_drops_repository.dart';
import 'package:path_of_nur/features/journey/drops/domain/journey_drops_models.dart';
import 'package:path_of_nur/features/journey/xp/data/journey_xp_repository.dart';
import 'package:path_of_nur/features/journey/xp/domain/journey_xp_models.dart';
import 'package:path_of_nur/shared/persistence/app_database.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  test(
    'growth statistics aggregate weekly and monthly summaries safely',
    () async {
      final database = AppDatabase.inMemory();
      addTearDown(database.close);

      final container = await makeTestContainer(
        database: database,
        seed: const <String, Object>{
          'learn.quran.readingStats': <String, Object>{
            'totalReadingSeconds': 2700,
            'totalSessions': 3,
            'secondsByDayKey': <String, int>{
              '2026-03-18': 600,
              '2026-03-19': 900,
              '2026-03-20': 1200,
            },
          },
          'learn.quran.listeningStats': <String, Object>{
            'totalListeningSeconds': 1200,
            'totalSessions': 2,
            'secondsByDayKey': <String, int>{'2026-03-21': 1200},
          },
          'journey.installStartedAtIso': '2026-03-01T00:00:00.000',
        },
        overrides: <Override>[
          journeyStatsNowProvider.overrideWithValue(
            DateTime.parse('2026-03-22T12:00:00.000'),
          ),
        ],
      );
      addTearDown(container.dispose);

      database.execute(
        '''
      INSERT INTO prayer_records(
        scope_id, day_key, prayer, status, completed_at_iso,
        post_salah_adhkar_completed_at_iso, timing, place, notes, updated_at_iso
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
      ''',
        <Object?>[
          defaultStructuredDataScopeId,
          '2026-03-20',
          'fajr',
          'completed',
          '2026-03-20T05:15:00.000',
          '2026-03-20T05:25:00.000',
          null,
          null,
          null,
          '2026-03-20T05:25:00.000',
        ],
      );
      database.execute(
        '''
      INSERT INTO prayer_records(
        scope_id, day_key, prayer, status, completed_at_iso,
        post_salah_adhkar_completed_at_iso, timing, place, notes, updated_at_iso
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
      ''',
        <Object?>[
          defaultStructuredDataScopeId,
          '2026-03-21',
          'dhuhr',
          'completed',
          '2026-03-21T13:15:00.000',
          null,
          null,
          null,
          null,
          '2026-03-21T13:15:00.000',
        ],
      );
      database.execute(
        '''
      INSERT INTO dhikr_sessions(
        scope_id, session_id, phrase_label, count, target, started_at_iso, finished_at_iso
      ) VALUES (?, ?, ?, ?, ?, ?, ?);
      ''',
        <Object?>[
          defaultStructuredDataScopeId,
          '2026-03-20T06:00:00.000|2026-03-20T06:02:00.000|33|33|SubhanAllah',
          'SubhanAllah',
          33,
          33,
          '2026-03-20T06:00:00.000',
          '2026-03-20T06:02:00.000',
        ],
      );
      database.execute(
        '''
      INSERT INTO dhikr_sessions(
        scope_id, session_id, phrase_label, count, target, started_at_iso, finished_at_iso
      ) VALUES (?, ?, ?, ?, ?, ?, ?);
      ''',
        <Object?>[
          defaultStructuredDataScopeId,
          '2026-03-21T20:00:00.000|2026-03-21T20:03:00.000|50|50|Alhamdulillah',
          'Alhamdulillah',
          50,
          50,
          '2026-03-21T20:00:00.000',
          '2026-03-21T20:03:00.000',
        ],
      );

      final xpRepository = container.read(journeyXpRepositoryProvider);
      xpRepository.addLedgerEntry(
        XpLedgerEntry(
          entryId: 'xp-1',
          eventType: XpEventType.prayerCompleted,
          sourceRef: 'prayer-2026-03-20-fajr',
          sourceModule: 'prayer',
          eventDateKey: '2026-03-20',
          occurredAt: DateTime.parse('2026-03-20T05:15:00.000'),
          baseXp: 24,
          awardedXp: 24,
          createdAt: DateTime.parse('2026-03-20T05:15:00.000'),
        ),
      );
      xpRepository.addLedgerEntry(
        XpLedgerEntry(
          entryId: 'xp-2',
          eventType: XpEventType.quranRead,
          sourceRef: 'quran-2026-03-21',
          sourceModule: 'quran',
          eventDateKey: '2026-03-21',
          occurredAt: DateTime.parse('2026-03-21T18:00:00.000'),
          baseXp: 18,
          awardedXp: 18,
          createdAt: DateTime.parse('2026-03-21T18:00:00.000'),
        ),
      );

      final dropsRepository = container.read(journeyDropsRepositoryProvider);
      dropsRepository.insertDropEvent(
        DropEvent(
          eventId: 'drop-1',
          sourceType: DropSourceType.prayer,
          sourceRef: 'prayer-2026-03-20-fajr',
          eventDateKey: '2026-03-20',
          occurredAt: DateTime.parse('2026-03-20T05:15:00.000'),
          createdAt: DateTime.parse('2026-03-20T05:15:00.000'),
        ),
      );
      dropsRepository.insertDropEvent(
        DropEvent(
          eventId: 'drop-2',
          sourceType: DropSourceType.quran,
          sourceRef: 'quran-2026-03-21',
          eventDateKey: '2026-03-21',
          occurredAt: DateTime.parse('2026-03-21T18:00:00.000'),
          createdAt: DateTime.parse('2026-03-21T18:00:00.000'),
        ),
      );

      final dashboard = container.read(growthStatisticsDashboardProvider);

      expect(dashboard.weeklySummary.prayersCompleted, 2);
      expect(dashboard.weeklySummary.dhikrCount, 83);
      expect(dashboard.weeklySummary.quranSeconds, 3900);
      expect(dashboard.weeklySummary.xpGained, 42);
      expect(dashboard.weeklySummary.dropsGained, 2);
      expect(dashboard.monthlySummary.quranSeconds, 3900);
      expect(dashboard.weeklyTrend.length, 7);
      expect(dashboard.monthlyTrend.length, 4);
      expect(dashboard.bestDay, isNotNull);
      expect(dashboard.bestDay!.dayKey, '2026-03-20');
      expect(dashboard.rewardsInsight.weeklyXp, 42);
      expect(dashboard.rewardsInsight.weeklyDrops, 2);
      expect(dashboard.rewardsInsight.topXpModule, 'prayer');
    },
  );

  test(
    'growth statistics handle sparse data without fake best-day insights',
    () async {
      final database = AppDatabase.inMemory();
      addTearDown(database.close);

      final container = await makeTestContainer(
        database: database,
        overrides: <Override>[
          journeyStatsNowProvider.overrideWithValue(
            DateTime.parse('2026-03-22T12:00:00.000'),
          ),
        ],
      );
      addTearDown(container.dispose);

      final dashboard = container.read(growthStatisticsDashboardProvider);

      expect(dashboard.weeklySummary.hasActivity, isFalse);
      expect(dashboard.monthlySummary.hasActivity, isFalse);
      expect(dashboard.bestDay, isNull);
      expect(dashboard.rewardsInsight.hasAnyRewardSignal, isFalse);
      expect(dashboard.weeklyTrend.every((point) => point.value == 0), isTrue);
    },
  );
}
