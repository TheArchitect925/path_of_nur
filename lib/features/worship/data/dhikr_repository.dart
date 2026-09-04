import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/accounts_sync/application/accounts_sync_controller.dart';
import '../../../features/accounts_sync/application/sync_foundation.dart';
import '../../../shared/persistence/app_database.dart';
import '../../../shared/persistence/local_store.dart';
import '../../../shared/persistence/structured_data_scope.dart';
import '../domain/dhikr_day_total.dart';
import '../domain/dhikr_session.dart';

class DhikrStoredState {
  const DhikrStoredState({
    required this.selectedPresetId,
    required this.target,
    required this.currentCount,
    required this.currentSessionStartedAt,
    required this.recentSessions,
    required this.updatedAtIso,
    this.dailyTotals = const <String, DhikrDayTotal>{},
    this.phraseTotals = const <String, int>{},
  });

  final String selectedPresetId;
  final int target;
  final int currentCount;
  final DateTime? currentSessionStartedAt;
  final List<DhikrSession> recentSessions;
  final String updatedAtIso;
  final Map<String, DhikrDayTotal> dailyTotals;
  final Map<String, int> phraseTotals;
}

class DhikrRepository {
  DhikrRepository({
    required AppDatabase database,
    required LocalStore legacyStore,
    required String scopeId,
    SyncMutationRecorder? syncRecorder,
  }) : _database = database,
       _legacyStore = legacyStore,
       _scopeId = scopeId,
       _syncRecorder = syncRecorder;

  final AppDatabase _database;
  final LocalStore _legacyStore;
  final String _scopeId;
  final SyncMutationRecorder? _syncRecorder;

  String get _migrationKey => 'migration.dhikr.v1.$_scopeId';
  String get _totalsMigrationKey => 'migration.dhikr.totals.v1.$_scopeId';

  void ensureMigrated() {
    final migrationState = _database.meta(_migrationKey);
    if (migrationState == 'done' || migrationState == 'running') {
      return;
    }
    final hasState = _database.select(
      'SELECT 1 FROM dhikr_state WHERE scope_id = ? LIMIT 1;',
      <Object?>[_scopeId],
    );
    final hasSessions = _database.select(
      'SELECT 1 FROM dhikr_sessions WHERE scope_id = ? LIMIT 1;',
      <Object?>[_scopeId],
    );
    if (hasState.isNotEmpty || hasSessions.isNotEmpty) {
      _database.setMeta(_migrationKey, 'done');
      return;
    }
    _database.setMeta(_migrationKey, 'running');
    final data = _legacyStore.getJsonMap('worship.dhikr');
    if (data != null) {
      final selectedPresetId =
          data['selectedPresetId']?.toString() ?? 'subhanallah';
      final target = (data['target'] as num?)?.toInt() ?? 33;
      final currentCount = (data['currentCount'] as num?)?.toInt() ?? 0;
      _writeState(
        selectedPresetId: selectedPresetId,
        target: target,
        currentCount: currentCount,
        currentSessionStartedAtIso: null,
        updatedAtIso: DateTime.now().toIso8601String(),
      );

      final sessionsRaw = data['recentSessions'];
      if (sessionsRaw is List) {
        final sessions = <DhikrSession>[];
        for (final row in sessionsRaw) {
          if (row is! Map) continue;
          final phraseLabel = row['phraseLabel']?.toString();
          final count = (row['count'] as num?)?.toInt();
          final target = (row['target'] as num?)?.toInt();
          final startedAt = DateTime.tryParse(
            row['startedAt']?.toString() ?? '',
          );
          final finishedAt = DateTime.tryParse(
            row['finishedAt']?.toString() ?? '',
          );
          if (phraseLabel == null ||
              count == null ||
              target == null ||
              startedAt == null ||
              finishedAt == null) {
            continue;
          }
          sessions.add(
            DhikrSession(
              phraseLabel: phraseLabel,
              count: count,
              target: target,
              startedAt: startedAt,
              finishedAt: finishedAt,
            ),
          );
        }
        _replaceRecentSessions(sessions);
      }
    }
    _database.setMeta(_migrationKey, 'done');
  }

  DhikrStoredState load() {
    ensureMigrated();
    _ensureTotalsBackfilled();
    final stateRows = _database.select(
      '''
      SELECT selected_preset_id, target, current_count, updated_at_iso
             , current_session_started_at_iso
      FROM dhikr_state
      WHERE scope_id = ?
      LIMIT 1;
      ''',
      <Object?>[_scopeId],
    );
    final sessionRows = _database.select(
      '''
      SELECT phrase_label, count, target, started_at_iso, finished_at_iso
      FROM dhikr_sessions
      WHERE scope_id = ?
      ORDER BY finished_at_iso DESC
      LIMIT 30;
      ''',
      <Object?>[_scopeId],
    );
    return DhikrStoredState(
      selectedPresetId: stateRows.isEmpty
          ? 'subhanallah'
          : stateRows.first['selected_preset_id'] as String,
      target: stateRows.isEmpty ? 33 : (stateRows.first['target'] as int),
      currentCount: stateRows.isEmpty
          ? 0
          : (stateRows.first['current_count'] as int),
      currentSessionStartedAt: stateRows.isEmpty
          ? null
          : DateTime.tryParse(
              stateRows.first['current_session_started_at_iso'] as String? ??
                  '',
            ),
      updatedAtIso: stateRows.isEmpty
          ? DateTime.fromMillisecondsSinceEpoch(0).toIso8601String()
          : stateRows.first['updated_at_iso'] as String,
      recentSessions: [
        for (final row in sessionRows)
          DhikrSession(
            phraseLabel: row['phrase_label'] as String,
            count: row['count'] as int,
            target: row['target'] as int,
            startedAt:
                DateTime.tryParse(row['started_at_iso'] as String) ??
                DateTime.now(),
            finishedAt:
                DateTime.tryParse(row['finished_at_iso'] as String) ??
                DateTime.now(),
          ),
      ],
      dailyTotals: loadDailyTotals(),
      phraseTotals: loadPhraseTotals(),
    );
  }

  /// Per-day totals, newest first, capped at roughly two years.
  Map<String, DhikrDayTotal> loadDailyTotals() {
    final rows = _database.select(
      '''
      SELECT date_key, count, sessions, routines_json
      FROM dhikr_daily_totals
      WHERE scope_id = ?
      ORDER BY date_key DESC
      LIMIT 800;
      ''',
      <Object?>[_scopeId],
    );
    final totals = <String, DhikrDayTotal>{};
    for (final row in rows) {
      final dateKey = row['date_key'] as String;
      totals[dateKey] = DhikrDayTotal(
        dateKey: dateKey,
        count: (row['count'] as int?) ?? 0,
        sessions: (row['sessions'] as int?) ?? 0,
        routineEntries: _decodeRoutineEntries(row['routines_json']),
      );
    }
    return totals;
  }

  Map<String, int> loadPhraseTotals() {
    final rows = _database.select(
      'SELECT phrase_label, count FROM dhikr_phrase_totals WHERE scope_id = ?;',
      <Object?>[_scopeId],
    );
    return <String, int>{
      for (final row in rows)
        row['phrase_label'] as String: (row['count'] as int?) ?? 0,
    };
  }

  void upsertDayTotal(DhikrDayTotal total) {
    ensureMigrated();
    _writeDayTotal(total);
  }

  void _writeDayTotal(DhikrDayTotal total) {
    _database.execute(
      '''
      INSERT OR REPLACE INTO dhikr_daily_totals(
        scope_id, date_key, count, sessions, routines_json, updated_at_iso
      ) VALUES (?, ?, ?, ?, ?, ?);
      ''',
      <Object?>[
        _scopeId,
        total.dateKey,
        total.count,
        total.sessions,
        jsonEncode(total.routineEntries),
        DateTime.now().toIso8601String(),
      ],
    );
  }

  void setPhraseTotal(String phraseLabel, int count) {
    ensureMigrated();
    _database.execute(
      '''
      INSERT OR REPLACE INTO dhikr_phrase_totals(scope_id, phrase_label, count)
      VALUES (?, ?, ?);
      ''',
      <Object?>[_scopeId, phraseLabel, count],
    );
  }

  /// Totals arrived after sessions did. The first load folds whatever
  /// sessions survive (at most thirty) into the new tables so existing users
  /// start with some history rather than none.
  void _ensureTotalsBackfilled() {
    if (_database.meta(_totalsMigrationKey) == 'done') return;
    final existing = _database.select(
      'SELECT 1 FROM dhikr_daily_totals WHERE scope_id = ? LIMIT 1;',
      <Object?>[_scopeId],
    );
    if (existing.isEmpty) {
      final sessionRows = _database.select(
        '''
        SELECT phrase_label, count, finished_at_iso
        FROM dhikr_sessions
        WHERE scope_id = ?;
        ''',
        <Object?>[_scopeId],
      );
      final totals = <String, DhikrDayTotal>{};
      final phrases = <String, int>{};
      for (final row in sessionRows) {
        final finishedAt = DateTime.tryParse(row['finished_at_iso'] as String);
        final count = (row['count'] as int?) ?? 0;
        if (finishedAt == null || count <= 0) continue;
        final key = dhikrDayKey(finishedAt);
        final day =
            totals[key] ?? DhikrDayTotal(dateKey: key, count: 0, sessions: 0);
        totals[key] = day.copyWith(
          count: day.count + count,
          sessions: day.sessions + 1,
        );
        final label = row['phrase_label'] as String;
        phrases[label] = (phrases[label] ?? 0) + count;
      }
      _database.transaction<void>(() {
        for (final total in totals.values) {
          _writeDayTotal(total);
        }
        for (final entry in phrases.entries) {
          _database.execute(
            '''
            INSERT OR REPLACE INTO dhikr_phrase_totals(scope_id, phrase_label, count)
            VALUES (?, ?, ?);
            ''',
            <Object?>[_scopeId, entry.key, entry.value],
          );
        }
      });
    }
    _database.setMeta(_totalsMigrationKey, 'done');
  }

  static List<String> _decodeRoutineEntries(Object? raw) {
    if (raw is! String || raw.isEmpty) return const <String>[];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.map((item) => item.toString()).toList(growable: false);
      }
    } catch (_) {
      // A malformed row loses its routine marks, never the day's count.
    }
    return const <String>[];
  }

  void saveState({
    required String selectedPresetId,
    required int target,
    required int currentCount,
    DateTime? currentSessionStartedAt,
  }) {
    ensureMigrated();
    final updatedAtIso = DateTime.now().toIso8601String();
    _writeState(
      selectedPresetId: selectedPresetId,
      target: target,
      currentCount: currentCount,
      currentSessionStartedAtIso: currentSessionStartedAt?.toIso8601String(),
      updatedAtIso: updatedAtIso,
    );
    _syncRecorder?.recordDhikrStateWrite(
      scopeId: _scopeId,
      updatedAtIso: updatedAtIso,
      selectedPresetId: selectedPresetId,
      target: target,
      currentCount: currentCount,
    );
  }

  void _writeState({
    required String selectedPresetId,
    required int target,
    required int currentCount,
    required String? currentSessionStartedAtIso,
    required String updatedAtIso,
  }) {
    _database.execute(
      '''
      INSERT OR REPLACE INTO dhikr_state(
        scope_id, selected_preset_id, target, current_count,
        current_session_started_at_iso, updated_at_iso
      ) VALUES (?, ?, ?, ?, ?, ?);
      ''',
      <Object?>[
        _scopeId,
        selectedPresetId,
        target,
        currentCount,
        currentSessionStartedAtIso,
        updatedAtIso,
      ],
    );
  }

  void replaceRecentSessions(List<DhikrSession> sessions) {
    ensureMigrated();
    _replaceRecentSessions(sessions);
    _syncRecorder?.recordDhikrSessionsWrite(
      scopeId: _scopeId,
      sessions: [
        for (final session in sessions.take(30))
          <String, dynamic>{
            'sessionId':
                '${session.startedAt.toIso8601String()}|${session.finishedAt.toIso8601String()}|${session.count}|${session.target}|${session.phraseLabel}',
            'phraseLabel': session.phraseLabel,
            'count': session.count,
            'target': session.target,
            'startedAtIso': session.startedAt.toIso8601String(),
            'finishedAtIso': session.finishedAt.toIso8601String(),
          },
      ],
    );
  }

  void _replaceRecentSessions(List<DhikrSession> sessions) {
    _database.transaction<void>(() {
      _database.execute(
        'DELETE FROM dhikr_sessions WHERE scope_id = ?;',
        <Object?>[_scopeId],
      );
      for (final session in sessions.take(30)) {
        final sessionId =
            '${session.startedAt.toIso8601String()}|${session.finishedAt.toIso8601String()}|${session.count}|${session.target}|${session.phraseLabel}';
        _database.execute(
          '''
          INSERT OR REPLACE INTO dhikr_sessions(
            scope_id, session_id, phrase_label, count, target, started_at_iso, finished_at_iso
          ) VALUES (?, ?, ?, ?, ?, ?, ?);
          ''',
          <Object?>[
            _scopeId,
            sessionId,
            session.phraseLabel,
            session.count,
            session.target,
            session.startedAt.toIso8601String(),
            session.finishedAt.toIso8601String(),
          ],
        );
      }
    });
  }
}

final dhikrRepositoryProvider = Provider<DhikrRepository>((ref) {
  ref.watch(profileScopeVersionProvider);
  return DhikrRepository(
    database: ref.watch(appDatabaseProvider),
    legacyStore: ref.watch(localStoreProvider),
    scopeId: ref.watch(structuredDataScopeProvider),
    syncRecorder: ref.watch(syncMutationRecorderProvider),
  );
});
