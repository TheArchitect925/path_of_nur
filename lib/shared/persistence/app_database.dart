import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqlite3/sqlite3.dart';

const String defaultStructuredDataScopeId = '__default__';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase.inMemory();
  ref.onDispose(database.close);
  return database;
});

class AppDatabase {
  AppDatabase._(this._db) {
    _initialize();
  }

  factory AppDatabase.openFile(String path) {
    return AppDatabase._(sqlite3.open(path));
  }

  factory AppDatabase.inMemory() {
    return AppDatabase._(sqlite3.openInMemory());
  }

  final Database _db;

  void _initialize() {
    _db.execute('PRAGMA foreign_keys = ON;');
    _db.execute('''
      CREATE TABLE IF NOT EXISTS app_meta(
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      );
    ''');
    _db.execute('''
      CREATE TABLE IF NOT EXISTS prayer_records(
        scope_id TEXT NOT NULL,
        day_key TEXT NOT NULL,
        prayer TEXT NOT NULL,
        status TEXT NOT NULL,
        completed_at_iso TEXT,
        timing TEXT,
        place TEXT,
        notes TEXT,
        updated_at_iso TEXT NOT NULL,
        PRIMARY KEY(scope_id, day_key, prayer)
      );
    ''');
    _db.execute('''
      CREATE TABLE IF NOT EXISTS dhikr_state(
        scope_id TEXT PRIMARY KEY,
        selected_preset_id TEXT NOT NULL,
        target INTEGER NOT NULL,
        current_count INTEGER NOT NULL,
        updated_at_iso TEXT NOT NULL
      );
    ''');
    _db.execute('''
      CREATE TABLE IF NOT EXISTS dhikr_sessions(
        scope_id TEXT NOT NULL,
        session_id TEXT PRIMARY KEY,
        phrase_label TEXT NOT NULL,
        count INTEGER NOT NULL,
        target INTEGER NOT NULL,
        started_at_iso TEXT NOT NULL,
        finished_at_iso TEXT NOT NULL
      );
    ''');
    _db.execute('''
      CREATE TABLE IF NOT EXISTS ocean_events(
        scope_id TEXT NOT NULL,
        event_id TEXT PRIMARY KEY,
        timestamp_iso TEXT NOT NULL,
        date_key TEXT NOT NULL,
        action_type TEXT NOT NULL,
        source_module TEXT NOT NULL,
        amount INTEGER NOT NULL,
        reference_id TEXT,
        metadata_json TEXT,
        eligibility_key TEXT
      );
    ''');
    _db.execute('''
      CREATE TABLE IF NOT EXISTS ocean_state(
        scope_id TEXT PRIMARY KEY,
        free_dhikr_carry_count INTEGER NOT NULL,
        free_dhikr_blocks_awarded INTEGER NOT NULL,
        community_baseline_drops TEXT NOT NULL,
        last_drop_awarded_at_iso TEXT
      );
    ''');
    _db.execute('''
      CREATE TABLE IF NOT EXISTS device_registry(
        device_id TEXT PRIMARY KEY,
        device_name TEXT NOT NULL,
        platform TEXT NOT NULL,
        account_id TEXT,
        registered_at_iso TEXT NOT NULL,
        last_seen_at_iso TEXT NOT NULL
      );
    ''');
    _db.execute('''
      CREATE TABLE IF NOT EXISTS sync_outbox(
        outbox_id TEXT PRIMARY KEY,
        scope_id TEXT NOT NULL,
        domain TEXT NOT NULL,
        entity_key TEXT NOT NULL,
        payload_json TEXT NOT NULL,
        device_id TEXT NOT NULL,
        dedup_key TEXT NOT NULL UNIQUE,
        created_at_iso TEXT NOT NULL,
        updated_at_iso TEXT NOT NULL,
        status TEXT NOT NULL,
        attempt_count INTEGER NOT NULL DEFAULT 0,
        last_error TEXT
      );
    ''');
    _db.execute('''
      CREATE TABLE IF NOT EXISTS sync_cursor(
        scope_id TEXT NOT NULL,
        transport_key TEXT NOT NULL,
        cursor_value TEXT,
        last_sync_at_iso TEXT,
        PRIMARY KEY(scope_id, transport_key)
      );
    ''');
    _db.execute(
      'CREATE INDEX IF NOT EXISTS idx_prayer_scope_day ON prayer_records(scope_id, day_key);',
    );
    _db.execute(
      'CREATE INDEX IF NOT EXISTS idx_dhikr_scope_finished ON dhikr_sessions(scope_id, finished_at_iso DESC);',
    );
    _db.execute(
      'CREATE INDEX IF NOT EXISTS idx_ocean_scope_date ON ocean_events(scope_id, date_key);',
    );
    _db.execute(
      'CREATE INDEX IF NOT EXISTS idx_ocean_scope_eligibility ON ocean_events(scope_id, eligibility_key);',
    );
    _db.execute(
      'CREATE INDEX IF NOT EXISTS idx_sync_outbox_scope_status ON sync_outbox(scope_id, status, updated_at_iso);',
    );
  }

  ResultSet select(String sql, [List<Object?> parameters = const <Object?>[]]) {
    final statement = _db.prepare(sql);
    try {
      return statement.select(parameters);
    } finally {
      statement.dispose();
    }
  }

  void execute(String sql, [List<Object?> parameters = const <Object?>[]]) {
    final statement = _db.prepare(sql);
    try {
      statement.execute(parameters);
    } finally {
      statement.dispose();
    }
  }

  T transaction<T>(T Function() action) {
    _db.execute('BEGIN IMMEDIATE TRANSACTION;');
    try {
      final result = action();
      _db.execute('COMMIT;');
      return result;
    } catch (_) {
      _db.execute('ROLLBACK;');
      rethrow;
    }
  }

  String? meta(String key) {
    final rows = select(
      'SELECT value FROM app_meta WHERE key = ? LIMIT 1;',
      <Object?>[key],
    );
    if (rows.isEmpty) return null;
    return rows.first['value'] as String?;
  }

  void setMeta(String key, String value) {
    execute(
      '''
      INSERT INTO app_meta(key, value)
      VALUES(?, ?)
      ON CONFLICT(key) DO UPDATE SET value = excluded.value;
      ''',
      <Object?>[key, value],
    );
  }

  void deleteScopedData(String scopeId) {
    transaction<void>(() {
      _deleteScopedDataRows(scopeId);
    });
  }

  void _deleteScopedDataRows(String scopeId) {
    execute('DELETE FROM prayer_records WHERE scope_id = ?;', <Object?>[scopeId]);
    execute('DELETE FROM dhikr_state WHERE scope_id = ?;', <Object?>[scopeId]);
    execute('DELETE FROM dhikr_sessions WHERE scope_id = ?;', <Object?>[scopeId]);
    execute('DELETE FROM ocean_events WHERE scope_id = ?;', <Object?>[scopeId]);
    execute('DELETE FROM ocean_state WHERE scope_id = ?;', <Object?>[scopeId]);
  }

  Map<String, dynamic> exportStructuredData(String scopeId) {
    final prayerRows = select(
      '''
      SELECT day_key, prayer, status, completed_at_iso, timing, place, notes, updated_at_iso
      FROM prayer_records
      WHERE scope_id = ?
      ORDER BY day_key, prayer;
      ''',
      <Object?>[scopeId],
    );
    final dhikrStateRows = select(
      '''
      SELECT selected_preset_id, target, current_count, updated_at_iso
      FROM dhikr_state
      WHERE scope_id = ?
      LIMIT 1;
      ''',
      <Object?>[scopeId],
    );
    final dhikrSessionRows = select(
      '''
      SELECT session_id, phrase_label, count, target, started_at_iso, finished_at_iso
      FROM dhikr_sessions
      WHERE scope_id = ?
      ORDER BY finished_at_iso DESC;
      ''',
      <Object?>[scopeId],
    );
    final oceanEventRows = select(
      '''
      SELECT event_id, timestamp_iso, date_key, action_type, source_module, amount,
             reference_id, metadata_json, eligibility_key
      FROM ocean_events
      WHERE scope_id = ?
      ORDER BY timestamp_iso DESC;
      ''',
      <Object?>[scopeId],
    );
    final oceanStateRows = select(
      '''
      SELECT free_dhikr_carry_count, free_dhikr_blocks_awarded, community_baseline_drops,
             last_drop_awarded_at_iso
      FROM ocean_state
      WHERE scope_id = ?
      LIMIT 1;
      ''',
      <Object?>[scopeId],
    );

    return <String, dynamic>{
      'prayerRecords': [
        for (final row in prayerRows)
          <String, dynamic>{
            'dayKey': row['day_key'],
            'prayer': row['prayer'],
            'status': row['status'],
            'completedAtIso': row['completed_at_iso'],
            'timing': row['timing'],
            'place': row['place'],
            'notes': row['notes'],
            'updatedAtIso': row['updated_at_iso'],
          },
      ],
      'dhikrState': dhikrStateRows.isEmpty
          ? null
          : <String, dynamic>{
              'selectedPresetId': dhikrStateRows.first['selected_preset_id'],
              'target': dhikrStateRows.first['target'],
              'currentCount': dhikrStateRows.first['current_count'],
              'updatedAtIso': dhikrStateRows.first['updated_at_iso'],
            },
      'dhikrSessions': [
        for (final row in dhikrSessionRows)
          <String, dynamic>{
            'sessionId': row['session_id'],
            'phraseLabel': row['phrase_label'],
            'count': row['count'],
            'target': row['target'],
            'startedAtIso': row['started_at_iso'],
            'finishedAtIso': row['finished_at_iso'],
          },
      ],
      'oceanState': oceanStateRows.isEmpty
          ? null
          : <String, dynamic>{
              'freeDhikrCarryCount':
                  oceanStateRows.first['free_dhikr_carry_count'],
              'freeDhikrBlocksAwarded':
                  oceanStateRows.first['free_dhikr_blocks_awarded'],
              'communityBaselineDrops':
                  oceanStateRows.first['community_baseline_drops'],
              'lastDropAwardedAtIso':
                  oceanStateRows.first['last_drop_awarded_at_iso'],
            },
      'oceanEvents': [
        for (final row in oceanEventRows)
          <String, dynamic>{
            'id': row['event_id'],
            'timestamp': row['timestamp_iso'],
            'dateKey': row['date_key'],
            'actionType': row['action_type'],
            'sourceModule': row['source_module'],
            'amount': row['amount'],
            'referenceId': row['reference_id'],
            'metadata': row['metadata_json'] == null
                ? null
                : jsonDecode(row['metadata_json'] as String),
            'eligibilityKey': row['eligibility_key'],
          },
      ],
    };
  }

  void importStructuredData(String scopeId, Map<String, dynamic>? payload) {
    if (payload == null) return;
    transaction<void>(() {
      _deleteScopedDataRows(scopeId);

      final prayerRows = payload['prayerRecords'];
      if (prayerRows is List) {
        for (final row in prayerRows) {
          if (row is! Map) continue;
          execute(
            '''
            INSERT OR REPLACE INTO prayer_records(
              scope_id, day_key, prayer, status, completed_at_iso, timing, place, notes, updated_at_iso
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
            ''',
            <Object?>[
              scopeId,
              row['dayKey']?.toString(),
              row['prayer']?.toString(),
              row['status']?.toString() ?? 'pending',
              row['completedAtIso']?.toString(),
              row['timing']?.toString(),
              row['place']?.toString(),
              row['notes']?.toString(),
              row['updatedAtIso']?.toString() ?? DateTime.now().toIso8601String(),
            ],
          );
        }
      }

      final dhikrState = payload['dhikrState'];
      if (dhikrState is Map) {
        execute(
          '''
          INSERT OR REPLACE INTO dhikr_state(
            scope_id, selected_preset_id, target, current_count, updated_at_iso
          ) VALUES (?, ?, ?, ?, ?);
          ''',
          <Object?>[
            scopeId,
            dhikrState['selectedPresetId']?.toString() ?? 'subhanallah',
            (dhikrState['target'] as num?)?.toInt() ?? 33,
            (dhikrState['currentCount'] as num?)?.toInt() ?? 0,
            dhikrState['updatedAtIso']?.toString() ?? DateTime.now().toIso8601String(),
          ],
        );
      }

      final dhikrSessions = payload['dhikrSessions'];
      if (dhikrSessions is List) {
        for (final row in dhikrSessions) {
          if (row is! Map) continue;
          execute(
            '''
            INSERT OR REPLACE INTO dhikr_sessions(
              scope_id, session_id, phrase_label, count, target, started_at_iso, finished_at_iso
            ) VALUES (?, ?, ?, ?, ?, ?, ?);
            ''',
            <Object?>[
              scopeId,
              row['sessionId']?.toString(),
              row['phraseLabel']?.toString() ?? 'Dhikr',
              (row['count'] as num?)?.toInt() ?? 0,
              (row['target'] as num?)?.toInt() ?? 33,
              row['startedAtIso']?.toString() ?? DateTime.now().toIso8601String(),
              row['finishedAtIso']?.toString() ?? DateTime.now().toIso8601String(),
            ],
          );
        }
      }

      final oceanState = payload['oceanState'];
      if (oceanState is Map) {
        execute(
          '''
          INSERT OR REPLACE INTO ocean_state(
            scope_id, free_dhikr_carry_count, free_dhikr_blocks_awarded,
            community_baseline_drops, last_drop_awarded_at_iso
          ) VALUES (?, ?, ?, ?, ?);
          ''',
          <Object?>[
            scopeId,
            (oceanState['freeDhikrCarryCount'] as num?)?.toInt() ?? 0,
            (oceanState['freeDhikrBlocksAwarded'] as num?)?.toInt() ?? 0,
            oceanState['communityBaselineDrops']?.toString() ??
                BigInt.from(500000).toString(),
            oceanState['lastDropAwardedAtIso']?.toString(),
          ],
        );
      }

      final oceanEvents = payload['oceanEvents'];
      if (oceanEvents is List) {
        for (final row in oceanEvents) {
          if (row is! Map) continue;
          execute(
            '''
            INSERT OR REPLACE INTO ocean_events(
              scope_id, event_id, timestamp_iso, date_key, action_type,
              source_module, amount, reference_id, metadata_json, eligibility_key
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
            ''',
            <Object?>[
              scopeId,
              row['id']?.toString(),
              row['timestamp']?.toString() ?? DateTime.now().toIso8601String(),
              row['dateKey']?.toString() ?? '',
              row['actionType']?.toString() ?? '',
              row['sourceModule']?.toString() ?? '',
              (row['amount'] as num?)?.toInt() ?? 1,
              row['referenceId']?.toString(),
              row['metadata'] == null ? null : jsonEncode(row['metadata']),
              row['eligibilityKey']?.toString(),
            ],
          );
        }
      }
    });
  }

  void close() => _db.dispose();
}
