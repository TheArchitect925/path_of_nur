import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/accounts_sync/application/accounts_sync_controller.dart';
import '../../../features/accounts_sync/application/sync_foundation.dart';
import '../../../shared/persistence/app_database.dart';
import '../../../shared/persistence/local_store.dart';
import '../../../shared/persistence/structured_data_scope.dart';
import '../domain/dhikr_session.dart';

class DhikrStoredState {
  const DhikrStoredState({
    required this.selectedPresetId,
    required this.target,
    required this.currentCount,
    required this.currentSessionStartedAt,
    required this.recentSessions,
    required this.updatedAtIso,
  });

  final String selectedPresetId;
  final int target;
  final int currentCount;
  final DateTime? currentSessionStartedAt;
  final List<DhikrSession> recentSessions;
  final String updatedAtIso;
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
    );
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
