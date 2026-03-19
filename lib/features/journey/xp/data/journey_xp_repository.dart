import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/app_database.dart';
import '../../../../shared/persistence/local_store.dart';
import '../../../../shared/persistence/structured_data_scope.dart';
import '../domain/journey_xp_levels.dart';
import '../domain/journey_xp_models.dart';

final journeyXpRepositoryProvider = Provider<JourneyXpRepository>((ref) {
  return JourneyXpRepository(
    database: ref.watch(appDatabaseProvider),
    scopeId: ref.watch(structuredDataScopeProvider),
  );
});

class JourneyXpRepository {
  JourneyXpRepository({required AppDatabase database, required String scopeId})
    : _database = database,
      _scopeId = scopeId;

  final AppDatabase _database;
  final String _scopeId;

  bool addLedgerEntry(XpLedgerEntry entry) {
    if (hasLedgerEntryForSource(entry.eventType, entry.sourceRef)) {
      return false;
    }
    _database.execute(
      '''
      INSERT INTO xp_ledger_entries(
        scope_id, entry_id, event_type, source_ref, event_date_key,
        source_module, occurred_at_iso, base_xp, awarded_xp, metadata_json,
        created_at_iso
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
      ''',
      <Object?>[
        _scopeId,
        entry.entryId,
        entry.eventType.name,
        entry.sourceRef,
        entry.eventDateKey,
        entry.sourceModule,
        entry.occurredAt.toIso8601String(),
        entry.baseXp,
        entry.awardedXp,
        jsonEncode(entry.metadata),
        entry.createdAt.toIso8601String(),
      ],
    );
    return true;
  }

  bool hasLedgerEntryForSource(XpEventType eventType, String sourceRef) {
    final rows = _database.select(
      '''
      SELECT entry_id FROM xp_ledger_entries
      WHERE scope_id = ? AND event_type = ? AND source_ref = ?
      LIMIT 1;
      ''',
      <Object?>[_scopeId, eventType.name, sourceRef],
    );
    return rows.isNotEmpty;
  }

  List<XpLedgerEntry> getLedgerEntriesInRange(DateTime start, DateTime end) {
    final rows = _database.select(
      '''
      SELECT entry_id, event_type, source_ref, event_date_key, source_module,
             occurred_at_iso, base_xp, awarded_xp, metadata_json, created_at_iso
      FROM xp_ledger_entries
      WHERE scope_id = ? AND occurred_at_iso >= ? AND occurred_at_iso <= ?
      ORDER BY occurred_at_iso ASC, created_at_iso ASC;
      ''',
      <Object?>[_scopeId, start.toIso8601String(), end.toIso8601String()],
    );
    return rows.map(_entryFromRow).toList(growable: false);
  }

  List<XpLedgerEntry> getAllLedgerEntries() {
    final rows = _database.select(
      '''
      SELECT entry_id, event_type, source_ref, event_date_key, source_module,
             occurred_at_iso, base_xp, awarded_xp, metadata_json, created_at_iso
      FROM xp_ledger_entries
      WHERE scope_id = ?
      ORDER BY occurred_at_iso ASC, created_at_iso ASC;
      ''',
      <Object?>[_scopeId],
    );
    return rows.map(_entryFromRow).toList(growable: false);
  }

  XpSummary getXpSummary() {
    final rows = _database.select(
      '''
      SELECT total_xp, today_xp, current_level, current_title, next_level,
             next_title, current_level_start_xp, next_level_total_xp,
             xp_into_level, xp_required_in_level, xp_remaining_to_next,
             progress_percent, updated_at_iso
      FROM xp_summary
      WHERE scope_id = ?
      LIMIT 1;
      ''',
      <Object?>[_scopeId],
    );
    if (rows.isEmpty) {
      return recomputeXpSummary();
    }
    final row = rows.first;
    return XpSummary(
      totalXp: (row['total_xp'] as num?)?.toInt() ?? 0,
      todayXp: (row['today_xp'] as num?)?.toInt() ?? 0,
      currentLevel: (row['current_level'] as num?)?.toInt() ?? 1,
      currentLevelTitle: row['current_title']?.toString() ?? 'Niyyah',
      currentLevelStartXp:
          (row['current_level_start_xp'] as num?)?.toInt() ?? 0,
      nextLevel: (row['next_level'] as num?)?.toInt(),
      nextLevelTitle: row['next_title']?.toString(),
      nextLevelTotalXp: (row['next_level_total_xp'] as num?)?.toInt(),
      xpIntoLevel: (row['xp_into_level'] as num?)?.toInt() ?? 0,
      xpRequiredInLevel: (row['xp_required_in_level'] as num?)?.toInt() ?? 1,
      xpRemainingToNextLevel:
          (row['xp_remaining_to_next'] as num?)?.toInt() ?? 0,
      progressPercent: ((row['progress_percent'] as num?)?.toDouble() ?? 0.0)
          .clamp(0, 1),
      updatedAt:
          DateTime.tryParse(row['updated_at_iso']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  XpSummary recomputeXpSummary({DateTime? now}) {
    final entries = getAllLedgerEntries();
    final timestamp = now ?? DateTime.now();
    final todayKey = _todayKey(timestamp);
    final totalXp = entries.fold<int>(0, (sum, entry) => sum + entry.awardedXp);
    final todayXp = entries
        .where((entry) => entry.eventDateKey == todayKey)
        .fold<int>(0, (sum, entry) => sum + entry.awardedXp);
    final current = xpLevelForTotalXp(totalXp);
    final next = xpNextLevelForTotalXp(totalXp);
    final currentStartXp = current.totalXpRequired;
    final nextXp = next?.totalXpRequired;
    final xpIntoLevel = totalXp - currentStartXp;
    final xpRequiredInLevel = nextXp == null
        ? 1
        : (nextXp - currentStartXp).clamp(1, 1 << 30);
    final remaining = nextXp == null ? 0 : (nextXp - totalXp).clamp(0, nextXp);
    final progress = nextXp == null
        ? 1.0
        : (xpIntoLevel / xpRequiredInLevel).clamp(0.0, 1.0).toDouble();
    final summary = XpSummary(
      totalXp: totalXp,
      todayXp: todayXp,
      currentLevel: current.level,
      currentLevelTitle: current.title,
      currentLevelStartXp: currentStartXp,
      nextLevel: next?.level,
      nextLevelTitle: next?.title,
      nextLevelTotalXp: nextXp,
      xpIntoLevel: xpIntoLevel.clamp(0, 1 << 30),
      xpRequiredInLevel: xpRequiredInLevel,
      xpRemainingToNextLevel: remaining,
      progressPercent: progress,
      updatedAt: timestamp,
    );
    _database.execute(
      '''
      INSERT INTO xp_summary(
        scope_id, total_xp, today_xp, current_level, current_title, next_level,
        next_title, current_level_start_xp, next_level_total_xp, xp_into_level,
        xp_required_in_level, xp_remaining_to_next, progress_percent,
        updated_at_iso
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(scope_id) DO UPDATE SET
        total_xp = excluded.total_xp,
        today_xp = excluded.today_xp,
        current_level = excluded.current_level,
        current_title = excluded.current_title,
        next_level = excluded.next_level,
        next_title = excluded.next_title,
        current_level_start_xp = excluded.current_level_start_xp,
        next_level_total_xp = excluded.next_level_total_xp,
        xp_into_level = excluded.xp_into_level,
        xp_required_in_level = excluded.xp_required_in_level,
        xp_remaining_to_next = excluded.xp_remaining_to_next,
        progress_percent = excluded.progress_percent,
        updated_at_iso = excluded.updated_at_iso;
      ''',
      <Object?>[
        _scopeId,
        summary.totalXp,
        summary.todayXp,
        summary.currentLevel,
        summary.currentLevelTitle,
        summary.nextLevel,
        summary.nextLevelTitle,
        summary.currentLevelStartXp,
        summary.nextLevelTotalXp,
        summary.xpIntoLevel,
        summary.xpRequiredInLevel,
        summary.xpRemainingToNextLevel,
        summary.progressPercent,
        summary.updatedAt.toIso8601String(),
      ],
    );
    return summary;
  }

  XpLedgerEntry _entryFromRow(Map<String, Object?> row) {
    final metadata = row['metadata_json'] == null
        ? const <String, Object?>{}
        : Map<String, Object?>.from(
            jsonDecode(row['metadata_json'] as String) as Map,
          );
    return XpLedgerEntry(
      entryId: row['entry_id']!.toString(),
      eventType: XpEventType.values.firstWhere(
        (type) => type.name == row['event_type']?.toString(),
      ),
      sourceRef: row['source_ref']!.toString(),
      sourceModule: row['source_module']!.toString(),
      eventDateKey: row['event_date_key']!.toString(),
      occurredAt: DateTime.parse(row['occurred_at_iso']!.toString()),
      baseXp: (row['base_xp'] as num?)?.toInt() ?? 0,
      awardedXp: (row['awarded_xp'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(row['created_at_iso']!.toString()),
      metadata: metadata,
    );
  }

  String _todayKey(DateTime dateTime) => LocalStore.todayKey(dateTime);
}
