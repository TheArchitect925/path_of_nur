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

  void _ensureColumn({
    required String table,
    required String column,
    required String definition,
  }) {
    final rows = _db.select('PRAGMA table_info($table);');
    final hasColumn = rows.any((row) => row['name']?.toString() == column);
    if (hasColumn) return;
    _db.execute('ALTER TABLE $table ADD COLUMN $column $definition;');
  }

  void _initialize() {
    _db.execute('PRAGMA foreign_keys = ON;');
    _db.execute('PRAGMA busy_timeout = 5000;');
    _db.execute('PRAGMA temp_store = MEMORY;');
    _db.execute('PRAGMA journal_mode = WAL;');
    _db.execute('PRAGMA synchronous = NORMAL;');
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
        post_salah_adhkar_completed_at_iso TEXT,
        timing TEXT,
        place TEXT,
        notes TEXT,
        updated_at_iso TEXT NOT NULL,
        PRIMARY KEY(scope_id, day_key, prayer)
      );
    ''');
    _ensureColumn(
      table: 'prayer_records',
      column: 'post_salah_adhkar_completed_at_iso',
      definition: 'TEXT',
    );
    _db.execute('''
      CREATE TABLE IF NOT EXISTS dhikr_state(
        scope_id TEXT PRIMARY KEY,
        selected_preset_id TEXT NOT NULL,
        target INTEGER NOT NULL,
        current_count INTEGER NOT NULL,
        current_session_started_at_iso TEXT,
        updated_at_iso TEXT NOT NULL
      );
    ''');
    _ensureColumn(
      table: 'dhikr_state',
      column: 'current_session_started_at_iso',
      definition: 'TEXT',
    );
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
      CREATE TABLE IF NOT EXISTS xp_ledger_entries(
        scope_id TEXT NOT NULL,
        entry_id TEXT PRIMARY KEY,
        event_type TEXT NOT NULL,
        source_ref TEXT NOT NULL,
        event_date_key TEXT NOT NULL,
        source_module TEXT NOT NULL,
        occurred_at_iso TEXT NOT NULL,
        base_xp INTEGER NOT NULL,
        awarded_xp INTEGER NOT NULL,
        metadata_json TEXT,
        created_at_iso TEXT NOT NULL
      );
    ''');
    _db.execute('''
      CREATE TABLE IF NOT EXISTS xp_summary(
        scope_id TEXT PRIMARY KEY,
        total_xp INTEGER NOT NULL,
        today_xp INTEGER NOT NULL,
        current_level INTEGER NOT NULL,
        current_title TEXT NOT NULL,
        next_level INTEGER,
        next_title TEXT,
        current_level_start_xp INTEGER NOT NULL,
        next_level_total_xp INTEGER,
        xp_into_level INTEGER NOT NULL,
        xp_required_in_level INTEGER NOT NULL,
        xp_remaining_to_next INTEGER NOT NULL,
        progress_percent REAL NOT NULL,
        updated_at_iso TEXT NOT NULL
      );
    ''');
    _db.execute('''
      CREATE TABLE IF NOT EXISTS drop_events(
        scope_id TEXT NOT NULL,
        event_id TEXT PRIMARY KEY,
        source_type TEXT NOT NULL,
        source_ref TEXT NOT NULL,
        event_date_key TEXT NOT NULL,
        occurred_at_iso TEXT NOT NULL,
        metadata_json TEXT,
        created_at_iso TEXT NOT NULL
      );
    ''');
    _db.execute('''
      CREATE TABLE IF NOT EXISTS drop_summary(
        scope_id TEXT PRIMARY KEY,
        total_drops INTEGER NOT NULL,
        today_drops INTEGER NOT NULL,
        updated_at_iso TEXT NOT NULL
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
      'CREATE INDEX IF NOT EXISTS idx_xp_scope_date ON xp_ledger_entries(scope_id, event_date_key);',
    );
    _db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_xp_scope_event_source ON xp_ledger_entries(scope_id, event_type, source_ref);',
    );
    _db.execute(
      'CREATE INDEX IF NOT EXISTS idx_drop_scope_date ON drop_events(scope_id, event_date_key);',
    );
    _db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_drop_scope_source ON drop_events(scope_id, source_ref);',
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
    execute('DELETE FROM prayer_records WHERE scope_id = ?;', <Object?>[
      scopeId,
    ]);
    execute('DELETE FROM dhikr_state WHERE scope_id = ?;', <Object?>[scopeId]);
    execute('DELETE FROM dhikr_sessions WHERE scope_id = ?;', <Object?>[
      scopeId,
    ]);
    execute('DELETE FROM ocean_events WHERE scope_id = ?;', <Object?>[scopeId]);
    execute('DELETE FROM ocean_state WHERE scope_id = ?;', <Object?>[scopeId]);
    execute('DELETE FROM xp_ledger_entries WHERE scope_id = ?;', <Object?>[
      scopeId,
    ]);
    execute('DELETE FROM xp_summary WHERE scope_id = ?;', <Object?>[scopeId]);
    execute('DELETE FROM drop_events WHERE scope_id = ?;', <Object?>[scopeId]);
    execute('DELETE FROM drop_summary WHERE scope_id = ?;', <Object?>[scopeId]);
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
    final xpLedgerRows = select(
      '''
      SELECT entry_id, event_type, source_ref, event_date_key, source_module,
             occurred_at_iso, base_xp, awarded_xp, metadata_json, created_at_iso
      FROM xp_ledger_entries
      WHERE scope_id = ?
      ORDER BY occurred_at_iso DESC, created_at_iso DESC;
      ''',
      <Object?>[scopeId],
    );
    final xpSummaryRows = select(
      '''
      SELECT total_xp, today_xp, current_level, current_title, next_level,
             next_title, current_level_start_xp, next_level_total_xp,
             xp_into_level, xp_required_in_level, xp_remaining_to_next,
             progress_percent, updated_at_iso
      FROM xp_summary
      WHERE scope_id = ?
      LIMIT 1;
      ''',
      <Object?>[scopeId],
    );
    final dropEventRows = select(
      '''
      SELECT event_id, source_type, source_ref, event_date_key,
             occurred_at_iso, metadata_json, created_at_iso
      FROM drop_events
      WHERE scope_id = ?
      ORDER BY occurred_at_iso DESC, created_at_iso DESC;
      ''',
      <Object?>[scopeId],
    );
    final dropSummaryRows = select(
      '''
      SELECT total_drops, today_drops, updated_at_iso
      FROM drop_summary
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
            'postSalahAdhkarCompletedAtIso':
                row['post_salah_adhkar_completed_at_iso'],
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
      'xpLedgerEntries': [
        for (final row in xpLedgerRows)
          <String, dynamic>{
            'entryId': row['entry_id'],
            'eventType': row['event_type'],
            'sourceRef': row['source_ref'],
            'eventDateKey': row['event_date_key'],
            'sourceModule': row['source_module'],
            'occurredAtIso': row['occurred_at_iso'],
            'baseXp': row['base_xp'],
            'awardedXp': row['awarded_xp'],
            'metadata': row['metadata_json'] == null
                ? null
                : jsonDecode(row['metadata_json'] as String),
            'createdAtIso': row['created_at_iso'],
          },
      ],
      'xpSummary': xpSummaryRows.isEmpty
          ? null
          : <String, dynamic>{
              'totalXp': xpSummaryRows.first['total_xp'],
              'todayXp': xpSummaryRows.first['today_xp'],
              'currentLevel': xpSummaryRows.first['current_level'],
              'currentTitle': xpSummaryRows.first['current_title'],
              'nextLevel': xpSummaryRows.first['next_level'],
              'nextTitle': xpSummaryRows.first['next_title'],
              'currentLevelStartXp':
                  xpSummaryRows.first['current_level_start_xp'],
              'nextLevelTotalXp': xpSummaryRows.first['next_level_total_xp'],
              'xpIntoLevel': xpSummaryRows.first['xp_into_level'],
              'xpRequiredInLevel': xpSummaryRows.first['xp_required_in_level'],
              'xpRemainingToNext': xpSummaryRows.first['xp_remaining_to_next'],
              'progressPercent': xpSummaryRows.first['progress_percent'],
              'updatedAtIso': xpSummaryRows.first['updated_at_iso'],
            },
      'dropEvents': [
        for (final row in dropEventRows)
          <String, dynamic>{
            'eventId': row['event_id'],
            'sourceType': row['source_type'],
            'sourceRef': row['source_ref'],
            'eventDateKey': row['event_date_key'],
            'occurredAtIso': row['occurred_at_iso'],
            'metadata': row['metadata_json'] == null
                ? null
                : jsonDecode(row['metadata_json'] as String),
            'createdAtIso': row['created_at_iso'],
          },
      ],
      'dropSummary': dropSummaryRows.isEmpty
          ? null
          : <String, dynamic>{
              'totalDrops': dropSummaryRows.first['total_drops'],
              'todayDrops': dropSummaryRows.first['today_drops'],
              'updatedAtIso': dropSummaryRows.first['updated_at_iso'],
            },
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
              scope_id, day_key, prayer, status, completed_at_iso, post_salah_adhkar_completed_at_iso, timing, place, notes, updated_at_iso
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
            ''',
            <Object?>[
              scopeId,
              row['dayKey']?.toString(),
              row['prayer']?.toString(),
              row['status']?.toString() ?? 'pending',
              row['completedAtIso']?.toString(),
              row['postSalahAdhkarCompletedAtIso']?.toString(),
              row['timing']?.toString(),
              row['place']?.toString(),
              row['notes']?.toString(),
              row['updatedAtIso']?.toString() ??
                  DateTime.now().toIso8601String(),
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
            dhikrState['updatedAtIso']?.toString() ??
                DateTime.now().toIso8601String(),
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
              row['startedAtIso']?.toString() ??
                  DateTime.now().toIso8601String(),
              row['finishedAtIso']?.toString() ??
                  DateTime.now().toIso8601String(),
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

      final xpLedgerEntries = payload['xpLedgerEntries'];
      if (xpLedgerEntries is List) {
        for (final row in xpLedgerEntries) {
          if (row is! Map) continue;
          execute(
            '''
            INSERT OR REPLACE INTO xp_ledger_entries(
              scope_id, entry_id, event_type, source_ref, event_date_key,
              source_module, occurred_at_iso, base_xp, awarded_xp,
              metadata_json, created_at_iso
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
            ''',
            <Object?>[
              scopeId,
              row['entryId']?.toString(),
              row['eventType']?.toString() ?? '',
              row['sourceRef']?.toString() ?? '',
              row['eventDateKey']?.toString() ?? '',
              row['sourceModule']?.toString() ?? '',
              row['occurredAtIso']?.toString() ??
                  DateTime.now().toIso8601String(),
              (row['baseXp'] as num?)?.toInt() ?? 0,
              (row['awardedXp'] as num?)?.toInt() ?? 0,
              row['metadata'] == null ? null : jsonEncode(row['metadata']),
              row['createdAtIso']?.toString() ??
                  DateTime.now().toIso8601String(),
            ],
          );
        }
      }

      final xpSummary = payload['xpSummary'];
      if (xpSummary is Map) {
        execute(
          '''
          INSERT OR REPLACE INTO xp_summary(
            scope_id, total_xp, today_xp, current_level, current_title,
            next_level, next_title, current_level_start_xp,
            next_level_total_xp, xp_into_level, xp_required_in_level,
            xp_remaining_to_next, progress_percent, updated_at_iso
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
          ''',
          <Object?>[
            scopeId,
            (xpSummary['totalXp'] as num?)?.toInt() ?? 0,
            (xpSummary['todayXp'] as num?)?.toInt() ?? 0,
            (xpSummary['currentLevel'] as num?)?.toInt() ?? 1,
            xpSummary['currentTitle']?.toString() ?? 'Niyyah',
            (xpSummary['nextLevel'] as num?)?.toInt(),
            xpSummary['nextTitle']?.toString(),
            (xpSummary['currentLevelStartXp'] as num?)?.toInt() ?? 0,
            (xpSummary['nextLevelTotalXp'] as num?)?.toInt(),
            (xpSummary['xpIntoLevel'] as num?)?.toInt() ?? 0,
            (xpSummary['xpRequiredInLevel'] as num?)?.toInt() ?? 1,
            (xpSummary['xpRemainingToNext'] as num?)?.toInt() ?? 0,
            (xpSummary['progressPercent'] as num?)?.toDouble() ?? 0.0,
            xpSummary['updatedAtIso']?.toString() ??
                DateTime.now().toIso8601String(),
          ],
        );
      }

      final dropEvents = payload['dropEvents'];
      if (dropEvents is List) {
        for (final row in dropEvents) {
          if (row is! Map) continue;
          execute(
            '''
            INSERT OR REPLACE INTO drop_events(
              scope_id, event_id, source_type, source_ref, event_date_key,
              occurred_at_iso, metadata_json, created_at_iso
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?);
            ''',
            <Object?>[
              scopeId,
              row['eventId']?.toString(),
              row['sourceType']?.toString() ?? '',
              row['sourceRef']?.toString() ?? '',
              row['eventDateKey']?.toString() ?? '',
              row['occurredAtIso']?.toString() ??
                  DateTime.now().toIso8601String(),
              row['metadata'] == null ? null : jsonEncode(row['metadata']),
              row['createdAtIso']?.toString() ??
                  DateTime.now().toIso8601String(),
            ],
          );
        }
      }

      final dropSummary = payload['dropSummary'];
      if (dropSummary is Map) {
        execute(
          '''
          INSERT OR REPLACE INTO drop_summary(
            scope_id, total_drops, today_drops, updated_at_iso
          ) VALUES (?, ?, ?, ?);
          ''',
          <Object?>[
            scopeId,
            (dropSummary['totalDrops'] as num?)?.toInt() ?? 0,
            (dropSummary['todayDrops'] as num?)?.toInt() ?? 0,
            dropSummary['updatedAtIso']?.toString() ??
                DateTime.now().toIso8601String(),
          ],
        );
      }
    });
  }

  void close() => _db.dispose();
}
