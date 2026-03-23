import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/accounts_sync/application/accounts_sync_controller.dart';
import '../../../features/accounts_sync/application/sync_foundation.dart';
import '../../../shared/persistence/app_database.dart';
import '../../../shared/persistence/local_store.dart';
import '../../../shared/persistence/structured_data_scope.dart';
import '../domain/daily_prayer_record.dart';
import '../domain/prayer_name.dart';
import '../domain/prayer_status.dart';
import '../domain/prayer_tracker_fields.dart';

class PrayerLogDayEntry {
  const PrayerLogDayEntry({
    required this.status,
    this.completedAtIso,
    this.postSalahAdhkarCompletedAtIso,
    this.timing,
    this.place,
    this.notes,
    this.updatedAtIso,
  });

  final PrayerStatus status;
  final String? completedAtIso;
  final String? postSalahAdhkarCompletedAtIso;
  final PrayerOfferTiming? timing;
  final PrayerOfferPlace? place;
  final String? notes;
  final String? updatedAtIso;

  PrayerLogDayEntry copyWith({
    PrayerStatus? status,
    String? completedAtIso,
    String? postSalahAdhkarCompletedAtIso,
    PrayerOfferTiming? timing,
    PrayerOfferPlace? place,
    String? notes,
    String? updatedAtIso,
    bool clearCompletedAtIso = false,
    bool clearPostSalahAdhkarCompletedAtIso = false,
    bool clearTiming = false,
    bool clearPlace = false,
    bool clearNotes = false,
    bool clearUpdatedAtIso = false,
  }) {
    return PrayerLogDayEntry(
      status: status ?? this.status,
      completedAtIso: clearCompletedAtIso
          ? null
          : completedAtIso ?? this.completedAtIso,
      postSalahAdhkarCompletedAtIso: clearPostSalahAdhkarCompletedAtIso
          ? null
          : postSalahAdhkarCompletedAtIso ?? this.postSalahAdhkarCompletedAtIso,
      timing: clearTiming ? null : timing ?? this.timing,
      place: clearPlace ? null : place ?? this.place,
      notes: clearNotes ? null : notes ?? this.notes,
      updatedAtIso: clearUpdatedAtIso
          ? null
          : updatedAtIso ?? this.updatedAtIso,
    );
  }
}

class PrayerLogRepository {
  PrayerLogRepository({
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

  String get _migrationKey => 'migration.prayer_logs.v1.$_scopeId';

  void ensureMigrated() {
    final migrationState = _database.meta(_migrationKey);
    if (migrationState == 'done' || migrationState == 'running') {
      return;
    }
    final existingRows = _database.select(
      'SELECT 1 FROM prayer_records WHERE scope_id = ? LIMIT 1;',
      <Object?>[_scopeId],
    );
    if (existingRows.isNotEmpty) {
      _database.setMeta(_migrationKey, 'done');
      return;
    }
    _database.setMeta(_migrationKey, 'running');
    final snapshot = _legacyStore.dumpAll();
    final prayerKeys = snapshot.keys
        .where(
          (key) =>
              key.startsWith('worship.prayer.') && key != 'worship.prayer.qada',
        )
        .toList(growable: false);
    for (final key in prayerKeys) {
      final dayKey = key.replaceFirst('worship.prayer.', '');
      final raw = _legacyStore.getJsonMap(key);
      if (raw == null) {
        continue;
      }
      final entries = <PrayerName, PrayerLogDayEntry>{};
      for (final prayer in PrayerName.values) {
        final row = raw[prayer.name];
        final statusName = row is String
            ? row
            : row is Map
            ? row['status']?.toString()
            : null;
        PrayerStatus status = PrayerStatus.pending;
        for (final item in PrayerStatus.values) {
          if (item.name == statusName) {
            status = item;
            break;
          }
        }
        PrayerOfferTiming? timing;
        PrayerOfferPlace? place;
        if (row is Map) {
          for (final item in PrayerOfferTiming.values) {
            if (item.name == row['timing']?.toString()) {
              timing = item;
            }
          }
          for (final item in PrayerOfferPlace.values) {
            if (item.name == row['place']?.toString()) {
              place = item;
            }
          }
        }
        entries[prayer] = PrayerLogDayEntry(
          status: status,
          completedAtIso: row is Map ? row['completedAtIso']?.toString() : null,
          postSalahAdhkarCompletedAtIso: row is Map
              ? row['postSalahAdhkarCompletedAtIso']?.toString()
              : null,
          timing: timing,
          place: place,
          notes: row is Map ? row['notes']?.toString() : null,
          updatedAtIso: row is Map ? row['updatedAtIso']?.toString() : null,
        );
      }
      _writeDayEntries(
        dayKey,
        entries,
        updatedAtIso: DateTime.now().toIso8601String(),
      );
    }
    _database.setMeta(_migrationKey, 'done');
  }

  List<DailyPrayerRecord> readDailyRecords(String dayKey) {
    ensureMigrated();
    final entries = readDayEntries(dayKey);
    return PrayerName.values
        .map(
          (prayer) => DailyPrayerRecord(
            prayer: prayer,
            status: entries[prayer]?.status ?? PrayerStatus.pending,
            completedAtIso: entries[prayer]?.completedAtIso,
            postSalahAdhkarCompletedAtIso:
                entries[prayer]?.postSalahAdhkarCompletedAtIso,
          ),
        )
        .toList(growable: false);
  }

  Map<PrayerName, PrayerLogDayEntry> readDayEntries(String dayKey) {
    ensureMigrated();
    final rows = _database.select(
      '''
      SELECT prayer, status, completed_at_iso, post_salah_adhkar_completed_at_iso, timing, place, notes, updated_at_iso
      FROM prayer_records
      WHERE scope_id = ? AND day_key = ?;
      ''',
      <Object?>[_scopeId, dayKey],
    );
    final output = <PrayerName, PrayerLogDayEntry>{};
    for (final row in rows) {
      final prayerName = row['prayer']?.toString();
      final prayer = PrayerName.values
          .where((item) => item.name == prayerName)
          .firstOrNull;
      if (prayer == null) continue;
      final statusName = row['status']?.toString();
      final status =
          PrayerStatus.values
              .where((item) => item.name == statusName)
              .firstOrNull ??
          PrayerStatus.pending;
      final timingName = row['timing']?.toString();
      final placeName = row['place']?.toString();
      output[prayer] = PrayerLogDayEntry(
        status: status,
        completedAtIso: row['completed_at_iso']?.toString(),
        postSalahAdhkarCompletedAtIso: row['post_salah_adhkar_completed_at_iso']
            ?.toString(),
        timing: PrayerOfferTiming.values
            .where((item) => item.name == timingName)
            .firstOrNull,
        place: PrayerOfferPlace.values
            .where((item) => item.name == placeName)
            .firstOrNull,
        notes: row['notes']?.toString(),
        updatedAtIso: row['updated_at_iso']?.toString(),
      );
    }
    return output;
  }

  void saveDailyRecords(String dayKey, List<DailyPrayerRecord> records) {
    saveDayEntries(dayKey, <PrayerName, PrayerLogDayEntry>{
      for (final record in records)
        record.prayer: PrayerLogDayEntry(
          status: record.status,
          completedAtIso: record.completedAtIso,
          postSalahAdhkarCompletedAtIso: record.postSalahAdhkarCompletedAtIso,
        ),
    });
  }

  void saveDayEntries(
    String dayKey,
    Map<PrayerName, PrayerLogDayEntry> entries,
  ) {
    ensureMigrated();
    final updatedAtIso = DateTime.now().toIso8601String();
    _writeDayEntries(dayKey, entries, updatedAtIso: updatedAtIso);
    _syncRecorder?.recordPrayerDayWrite(
      scopeId: _scopeId,
      dayKey: dayKey,
      updatedAtIso: updatedAtIso,
      records: [
        for (final prayer in PrayerName.values)
          <String, dynamic>{
            'prayer': prayer.name,
            'status': (entries[prayer]?.status ?? PrayerStatus.pending).name,
            'completedAtIso': entries[prayer]?.completedAtIso,
            'postSalahAdhkarCompletedAtIso':
                entries[prayer]?.postSalahAdhkarCompletedAtIso,
            'timing': entries[prayer]?.timing?.name,
            'place': entries[prayer]?.place?.name,
            'notes': entries[prayer]?.notes,
            'updatedAtIso': updatedAtIso,
          },
      ],
    );
  }

  void _writeDayEntries(
    String dayKey,
    Map<PrayerName, PrayerLogDayEntry> entries, {
    required String updatedAtIso,
  }) {
    _database.transaction<void>(() {
      for (final prayer in PrayerName.values) {
        final entry =
            entries[prayer] ??
            const PrayerLogDayEntry(status: PrayerStatus.pending);
        _database.execute(
          '''
          INSERT OR REPLACE INTO prayer_records(
            scope_id, day_key, prayer, status, completed_at_iso, post_salah_adhkar_completed_at_iso, timing, place, notes, updated_at_iso
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
          ''',
          <Object?>[
            _scopeId,
            dayKey,
            prayer.name,
            entry.status.name,
            entry.status == PrayerStatus.completed
                ? entry.completedAtIso
                : null,
            entry.status == PrayerStatus.completed
                ? entry.postSalahAdhkarCompletedAtIso
                : null,
            entry.timing?.name,
            entry.place?.name,
            entry.notes,
            entry.updatedAtIso ?? updatedAtIso,
          ],
        );
      }
    });
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

final prayerLogRepositoryProvider = Provider<PrayerLogRepository>((ref) {
  ref.watch(profileScopeVersionProvider);
  return PrayerLogRepository(
    database: ref.watch(appDatabaseProvider),
    legacyStore: ref.watch(localStoreProvider),
    scopeId: ref.watch(structuredDataScopeProvider),
    syncRecorder: ref.watch(syncMutationRecorderProvider),
  );
});
