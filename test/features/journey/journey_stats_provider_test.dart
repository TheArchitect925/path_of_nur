import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/journey/application/journey_stats_provider.dart';
import 'package:path_of_nur/shared/persistence/app_database.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  test(
    'journey stats aggregate lifetime adhkar from tracked completions',
    () async {
      final database = AppDatabase.inMemory();
      addTearDown(database.close);
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
          '2026-03-20',
          'dhuhr',
          'completed',
          '2026-03-20T13:15:00.000',
          null,
          null,
          null,
          null,
          '2026-03-20T13:15:00.000',
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

      final container = await makeTestContainer(database: database);
      addTearDown(container.dispose);

      final summary = container.read(journeyStatsSummaryProvider);
      expect(summary.totalSalahOffered, 2);
      expect(summary.totalPostSalahAdhkarCompleted, 1);
      expect(summary.dhikrCompletedSessions, 1);
      expect(summary.totalAdhkarCompletedLifetime, 2);
      expect(summary.totalDhikrSeconds, 120);
    },
  );

  test(
    'journey stats reflect install age against trustworthy tracked time',
    () async {
      final database = AppDatabase.inMemory();
      addTearDown(database.close);
      database.execute(
        '''
      INSERT INTO dhikr_sessions(
        scope_id, session_id, phrase_label, count, target, started_at_iso, finished_at_iso
      ) VALUES (?, ?, ?, ?, ?, ?, ?);
      ''',
        <Object?>[
          defaultStructuredDataScopeId,
          '2026-03-18T00:00:00.000|2026-03-18T00:02:00.000|33|33|SubhanAllah',
          'SubhanAllah',
          33,
          33,
          '2026-03-18T00:00:00.000',
          '2026-03-18T00:02:00.000',
        ],
      );

      final container = await makeTestContainer(
        database: database,
        seed: const <String, Object>{
          'journey.installStartedAtIso': '2026-03-18T00:00:00.000',
        },
        overrides: <Override>[
          journeyStatsNowProvider.overrideWithValue(
            DateTime.parse('2026-03-20T00:00:00.000'),
          ),
        ],
      );
      addTearDown(container.dispose);

      final summary = container.read(journeyStatsSummaryProvider);
      expect(summary.timeSinceInstallSeconds, 172800);
      expect(summary.totalTrackedWorshipGrowthSeconds, 120);
      expect(summary.otherUntrackedSeconds, 172680);
      expect(
        summary.trackedShareOfInstallTime,
        closeTo(120 / 172800, 0.000001),
      );
    },
  );
}
