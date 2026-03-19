import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/app_database.dart';
import '../../../../shared/persistence/local_store.dart';
import '../../../../shared/persistence/structured_data_scope.dart';
import '../domain/journey_drops_models.dart';

final journeyDropsRepositoryProvider = Provider<JourneyDropsRepository>((ref) {
  return JourneyDropsRepository(
    database: ref.watch(appDatabaseProvider),
    scopeId: ref.watch(structuredDataScopeProvider),
  );
});

class JourneyDropsRepository {
  JourneyDropsRepository({
    required AppDatabase database,
    required String scopeId,
  }) : _database = database,
       _scopeId = scopeId;

  final AppDatabase _database;
  final String _scopeId;

  bool insertDropEvent(DropEvent event) {
    if (existsBySourceRef(event.sourceRef)) return false;
    _database.execute(
      '''
      INSERT INTO drop_events(
        scope_id, event_id, source_type, source_ref, event_date_key,
        occurred_at_iso, metadata_json, created_at_iso
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?);
      ''',
      <Object?>[
        _scopeId,
        event.eventId,
        event.sourceType.name,
        event.sourceRef,
        event.eventDateKey,
        event.occurredAt.toIso8601String(),
        jsonEncode(event.metadata),
        event.createdAt.toIso8601String(),
      ],
    );
    return true;
  }

  bool existsBySourceRef(String sourceRef) {
    final rows = _database.select(
      '''
      SELECT event_id FROM drop_events
      WHERE scope_id = ? AND source_ref = ?
      LIMIT 1;
      ''',
      <Object?>[_scopeId, sourceRef],
    );
    return rows.isNotEmpty;
  }

  List<DropEvent> fetchAllDrops() {
    final rows = _database.select(
      '''
      SELECT event_id, source_type, source_ref, event_date_key,
             occurred_at_iso, metadata_json, created_at_iso
      FROM drop_events
      WHERE scope_id = ?
      ORDER BY occurred_at_iso DESC, created_at_iso DESC;
      ''',
      <Object?>[_scopeId],
    );
    return rows.map(_eventFromRow).toList(growable: false);
  }

  List<DropEvent> fetchDropsByDateRange(DateTime start, DateTime end) {
    final rows = _database.select(
      '''
      SELECT event_id, source_type, source_ref, event_date_key,
             occurred_at_iso, metadata_json, created_at_iso
      FROM drop_events
      WHERE scope_id = ? AND occurred_at_iso >= ? AND occurred_at_iso <= ?
      ORDER BY occurred_at_iso DESC, created_at_iso DESC;
      ''',
      <Object?>[_scopeId, start.toIso8601String(), end.toIso8601String()],
    );
    return rows.map(_eventFromRow).toList(growable: false);
  }

  DropSummary getDropSummary() {
    final rows = _database.select(
      '''
      SELECT total_drops, today_drops, updated_at_iso
      FROM drop_summary
      WHERE scope_id = ?
      LIMIT 1;
      ''',
      <Object?>[_scopeId],
    );
    if (rows.isEmpty) return recomputeDropSummary();
    final row = rows.first;
    return DropSummary(
      totalDrops: (row['total_drops'] as num?)?.toInt() ?? 0,
      todayDrops: (row['today_drops'] as num?)?.toInt() ?? 0,
      updatedAt:
          DateTime.tryParse(row['updated_at_iso']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  DropSummary recomputeDropSummary({DateTime? now}) {
    final entries = fetchAllDrops();
    final timestamp = now ?? DateTime.now();
    final todayKey = LocalStore.todayKey(timestamp);
    final summary = DropSummary(
      totalDrops: entries.length,
      todayDrops: entries.where((item) => item.eventDateKey == todayKey).length,
      updatedAt: timestamp,
    );
    _database.execute(
      '''
      INSERT INTO drop_summary(scope_id, total_drops, today_drops, updated_at_iso)
      VALUES (?, ?, ?, ?)
      ON CONFLICT(scope_id) DO UPDATE SET
        total_drops = excluded.total_drops,
        today_drops = excluded.today_drops,
        updated_at_iso = excluded.updated_at_iso;
      ''',
      <Object?>[
        _scopeId,
        summary.totalDrops,
        summary.todayDrops,
        summary.updatedAt.toIso8601String(),
      ],
    );
    return summary;
  }

  DropEvent _eventFromRow(Map<String, Object?> row) {
    final metadata = row['metadata_json'] == null
        ? const <String, Object?>{}
        : Map<String, Object?>.from(
            jsonDecode(row['metadata_json'] as String) as Map,
          );
    return DropEvent(
      eventId: row['event_id']!.toString(),
      sourceType: DropSourceType.values.firstWhere(
        (item) => item.name == row['source_type']?.toString(),
      ),
      sourceRef: row['source_ref']!.toString(),
      eventDateKey: row['event_date_key']!.toString(),
      occurredAt: DateTime.parse(row['occurred_at_iso']!.toString()),
      createdAt: DateTime.parse(row['created_at_iso']!.toString()),
      metadata: metadata,
    );
  }
}
