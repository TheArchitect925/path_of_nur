import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../../../shared/persistence/app_database.dart';
import '../../../shared/persistence/local_store.dart';
import '../../../shared/persistence/structured_data_scope.dart';

const String syncDomainPrayerLog = 'prayer_log';
const String syncDomainDhikrState = 'dhikr_state';
const String syncDomainDhikrSessions = 'dhikr_sessions';
const String syncDomainOceanEvent = 'ocean_event';

const String _deviceIdStorageKey = 'accounts_sync.device_id.v1';

class AppDeviceIdentity {
  const AppDeviceIdentity({
    required this.deviceId,
    required this.deviceName,
    required this.platformKey,
  });

  final String deviceId;
  final String deviceName;
  final String platformKey;
}

class SyncOutboxEntry {
  const SyncOutboxEntry({
    required this.outboxId,
    required this.scopeId,
    required this.domain,
    required this.entityKey,
    required this.payload,
    required this.deviceId,
    required this.dedupKey,
    required this.createdAtIso,
    required this.updatedAtIso,
    required this.status,
    required this.attemptCount,
    this.lastError,
  });

  final String outboxId;
  final String scopeId;
  final String domain;
  final String entityKey;
  final Map<String, dynamic> payload;
  final String deviceId;
  final String dedupKey;
  final String createdAtIso;
  final String updatedAtIso;
  final String status;
  final int attemptCount;
  final String? lastError;
}

class SyncInboundChange {
  const SyncInboundChange({
    required this.scopeId,
    required this.domain,
    required this.entityKey,
    required this.payload,
    required this.changedAtIso,
    required this.deviceId,
    required this.revision,
    this.dedupKey,
  });

  final String scopeId;
  final String domain;
  final String entityKey;
  final Map<String, dynamic> payload;
  final String changedAtIso;
  final String deviceId;
  final String revision;
  final String? dedupKey;
}

class SyncTransportRequest {
  const SyncTransportRequest({
    required this.scopeId,
    required this.accountId,
    required this.deviceId,
    required this.cursor,
    required this.outboxEntries,
  });

  final String scopeId;
  final String? accountId;
  final String deviceId;
  final String? cursor;
  final List<SyncOutboxEntry> outboxEntries;
}

class SyncTransportResponse {
  const SyncTransportResponse({
    required this.online,
    required this.acceptedDedupKeys,
    required this.inboundChanges,
    this.nextCursor,
    this.errorMessage,
    this.statusCode,
    this.transportLabel,
  });

  final bool online;
  final List<String> acceptedDedupKeys;
  final List<SyncInboundChange> inboundChanges;
  final String? nextCursor;
  final String? errorMessage;
  final String? statusCode;
  final String? transportLabel;
}

abstract class SyncTransport {
  const SyncTransport();

  Future<SyncTransportResponse> sync(SyncTransportRequest request);
}

class UnavailableSyncTransport extends SyncTransport {
  const UnavailableSyncTransport({this.reason = 'Transport unavailable'});

  final String reason;

  @override
  Future<SyncTransportResponse> sync(SyncTransportRequest request) async {
    return SyncTransportResponse(
      online: false,
      acceptedDedupKeys: const <String>[],
      inboundChanges: const <SyncInboundChange>[],
      errorMessage: reason,
      statusCode: 'transport_unavailable',
    );
  }
}

class ICloudSyncTransport extends SyncTransport {
  const ICloudSyncTransport();

  @visibleForTesting
  static const MethodChannel channel = MethodChannel('path_of_nur/icloud_sync');

  static const int _maxRetainedChanges = 512;

  @override
  Future<SyncTransportResponse> sync(SyncTransportRequest request) async {
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.iOS &&
            defaultTargetPlatform != TargetPlatform.macOS)) {
      return const SyncTransportResponse(
        online: false,
        acceptedDedupKeys: <String>[],
        inboundChanges: <SyncInboundChange>[],
        errorMessage: 'iCloud sync is only available on Apple devices',
        statusCode: 'unsupported_platform',
        transportLabel: 'iCloud',
      );
    }

    try {
      final available =
          await channel.invokeMethod<bool>('isAvailable') ?? false;
      if (!available) {
        return const SyncTransportResponse(
          online: false,
          acceptedDedupKeys: <String>[],
          inboundChanges: <SyncInboundChange>[],
          errorMessage: 'iCloud is unavailable or not signed in',
          statusCode: 'icloud_unavailable',
          transportLabel: 'iCloud',
        );
      }

      final key = 'sync.scope.${request.scopeId}';
      final raw = await channel.invokeMethod<String>(
        'readValue',
        <String, Object?>{'key': key},
      );
      final document = _ICloudScopeDocument.fromJsonString(
        scopeId: request.scopeId,
        raw: raw,
      );
      final merged = document.merge(
        request.outboxEntries,
        maxRetainedChanges: _maxRetainedChanges,
      );
      if (merged.changed) {
        final writeSucceeded = await channel.invokeMethod<bool>(
          'writeValue',
          <String, Object?>{
            'key': key,
            'value': merged.document.toJsonString(),
          },
        );
        if (writeSucceeded != true) {
          return const SyncTransportResponse(
            online: false,
            acceptedDedupKeys: <String>[],
            inboundChanges: <SyncInboundChange>[],
            errorMessage:
                'iCloud write failed. Check signing and ubiquity key-value capability.',
            statusCode: 'icloud_write_failed',
            transportLabel: 'iCloud',
          );
        }
      }

      final cursor = int.tryParse(request.cursor ?? '') ?? 0;
      final inboundChanges = merged.document.changes
          .where(
            (change) =>
                change.sequence > cursor &&
                change.deviceId != request.deviceId,
          )
          .map(
            (change) => SyncInboundChange(
              scopeId: request.scopeId,
              domain: change.domain,
              entityKey: change.entityKey,
              payload: change.payload,
              changedAtIso: change.changedAtIso,
              deviceId: change.deviceId,
              revision: change.revision,
              dedupKey: change.dedupKey,
            ),
          )
          .toList(growable: false);

      return SyncTransportResponse(
        online: true,
        acceptedDedupKeys: request.outboxEntries
            .map((entry) => entry.dedupKey)
            .toList(growable: false),
        inboundChanges: inboundChanges,
        nextCursor: merged.document.maxSequence.toString(),
        statusCode: request.outboxEntries.isEmpty && inboundChanges.isEmpty
            ? 'noop'
            : 'ok',
        transportLabel: 'iCloud',
      );
    } catch (error) {
      return SyncTransportResponse(
        online: false,
        acceptedDedupKeys: const <String>[],
        inboundChanges: const <SyncInboundChange>[],
        errorMessage: error.toString(),
        statusCode: 'transport_error',
        transportLabel: 'iCloud',
      );
    }
  }
}

class _ICloudScopeDocument {
  const _ICloudScopeDocument({
    required this.scopeId,
    required this.changes,
  });

  final String scopeId;
  final List<_ICloudScopeChange> changes;

  int get maxSequence => changes.isEmpty
      ? 0
      : changes
          .map((change) => change.sequence)
          .reduce((value, element) => value > element ? value : element);

  String toJsonString() {
    return jsonEncode(<String, dynamic>{
      'schemaVersion': 1,
      'scopeId': scopeId,
      'changes': [
        for (final change in changes)
          <String, dynamic>{
            'sequence': change.sequence,
            'dedupKey': change.dedupKey,
            'domain': change.domain,
            'entityKey': change.entityKey,
            'payload': change.payload,
            'deviceId': change.deviceId,
            'changedAtIso': change.changedAtIso,
            'revision': change.revision,
          },
      ],
    });
  }

  static _ICloudScopeDocument fromJsonString({
    required String scopeId,
    required String? raw,
  }) {
    if (raw == null || raw.isEmpty) {
      return _ICloudScopeDocument(scopeId: scopeId, changes: const []);
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return _ICloudScopeDocument(scopeId: scopeId, changes: const []);
      }
      final changesRaw = decoded['changes'];
      final changes = <_ICloudScopeChange>[];
      if (changesRaw is List) {
        for (final row in changesRaw) {
          if (row is! Map) continue;
          final payload = row['payload'];
          changes.add(
            _ICloudScopeChange(
              sequence: (row['sequence'] as num?)?.toInt() ?? 0,
              dedupKey: row['dedupKey']?.toString() ?? '',
              domain: row['domain']?.toString() ?? '',
              entityKey: row['entityKey']?.toString() ?? '',
              payload: payload is Map
                  ? payload.map((key, value) => MapEntry(key.toString(), value))
                  : const <String, dynamic>{},
              deviceId: row['deviceId']?.toString() ?? '',
              changedAtIso: row['changedAtIso']?.toString() ??
                  DateTime.fromMillisecondsSinceEpoch(0).toIso8601String(),
              revision: row['revision']?.toString() ?? '0',
            ),
          );
        }
      }
      changes.sort((a, b) => a.sequence.compareTo(b.sequence));
      return _ICloudScopeDocument(
        scopeId: decoded['scopeId']?.toString() ?? scopeId,
        changes: changes,
      );
    } catch (_) {
      return _ICloudScopeDocument(scopeId: scopeId, changes: const []);
    }
  }

  _ICloudMergeResult merge(
    List<SyncOutboxEntry> outboxEntries, {
    required int maxRetainedChanges,
  }) {
    if (outboxEntries.isEmpty) {
      return _ICloudMergeResult(document: this, changed: false);
    }
    final byDedup = <String, _ICloudScopeChange>{
      for (final change in changes) change.dedupKey: change,
    };
    var nextSequence = maxSequence;
    var changed = false;
    for (final entry in outboxEntries) {
      final existing = byDedup[entry.dedupKey];
      final existingAt =
          DateTime.tryParse(existing?.changedAtIso ?? '') ??
              DateTime.fromMillisecondsSinceEpoch(0);
      final incomingAt =
          DateTime.tryParse(entry.updatedAtIso) ?? DateTime.now();
      if (existing != null &&
          existing.deviceId != entry.deviceId &&
          incomingAt.isBefore(existingAt)) {
        continue;
      }
      nextSequence += 1;
      byDedup[entry.dedupKey] = _ICloudScopeChange(
        sequence: nextSequence,
        dedupKey: entry.dedupKey,
        domain: entry.domain,
        entityKey: entry.entityKey,
        payload: entry.payload,
        deviceId: entry.deviceId,
        changedAtIso: entry.updatedAtIso,
        revision: nextSequence.toString(),
      );
      changed = true;
    }
    final nextChanges = byDedup.values.toList()
      ..sort((a, b) => a.sequence.compareTo(b.sequence));
    final retained = nextChanges.length <= maxRetainedChanges
        ? nextChanges
        : nextChanges.sublist(nextChanges.length - maxRetainedChanges);
    return _ICloudMergeResult(
      document: _ICloudScopeDocument(scopeId: scopeId, changes: retained),
      changed: changed,
    );
  }
}

class _ICloudScopeChange {
  const _ICloudScopeChange({
    required this.sequence,
    required this.dedupKey,
    required this.domain,
    required this.entityKey,
    required this.payload,
    required this.deviceId,
    required this.changedAtIso,
    required this.revision,
  });

  final int sequence;
  final String dedupKey;
  final String domain;
  final String entityKey;
  final Map<String, dynamic> payload;
  final String deviceId;
  final String changedAtIso;
  final String revision;
}

class _ICloudMergeResult {
  const _ICloudMergeResult({
    required this.document,
    required this.changed,
  });

  final _ICloudScopeDocument document;
  final bool changed;
}

class SyncRunReport {
  const SyncRunReport({
    required this.succeeded,
    required this.online,
    required this.pendingCount,
    required this.uploadedCount,
    required this.appliedInboundCount,
    required this.completedAtIso,
    required this.recentEvents,
    this.errorMessage,
    required this.transportLabel,
    required this.transportAvailable,
    required this.resultSummary,
    this.statusCode,
  });

  final bool succeeded;
  final bool online;
  final int pendingCount;
  final int uploadedCount;
  final int appliedInboundCount;
  final String completedAtIso;
  final List<String> recentEvents;
  final String? errorMessage;
  final String transportLabel;
  final bool transportAvailable;
  final String resultSummary;
  final String? statusCode;
}

class SyncOutboxRepository {
  SyncOutboxRepository(this._database);

  final AppDatabase _database;

  void registerDevice(AppDeviceIdentity identity, {String? accountId}) {
    final now = DateTime.now().toIso8601String();
    _database.execute(
      '''
      INSERT INTO device_registry(
        device_id, device_name, platform, account_id, registered_at_iso, last_seen_at_iso
      ) VALUES (?, ?, ?, ?, ?, ?)
      ON CONFLICT(device_id) DO UPDATE SET
        device_name = excluded.device_name,
        platform = excluded.platform,
        account_id = excluded.account_id,
        last_seen_at_iso = excluded.last_seen_at_iso;
      ''',
      <Object?>[
        identity.deviceId,
        identity.deviceName,
        identity.platformKey,
        accountId,
        now,
        now,
      ],
    );
  }

  void enqueueReplace({
    required String scopeId,
    required String domain,
    required String entityKey,
    required Map<String, dynamic> payload,
    required String deviceId,
    required String dedupKey,
  }) {
    final now = DateTime.now().toIso8601String();
    final outboxId = '$scopeId|$domain|$entityKey';
    _database.execute(
      '''
      INSERT INTO sync_outbox(
        outbox_id, scope_id, domain, entity_key, payload_json, device_id,
        dedup_key, created_at_iso, updated_at_iso, status, attempt_count, last_error
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(dedup_key) DO UPDATE SET
        payload_json = excluded.payload_json,
        device_id = excluded.device_id,
        updated_at_iso = excluded.updated_at_iso,
        status = 'pending',
        last_error = NULL;
      ''',
      <Object?>[
        outboxId,
        scopeId,
        domain,
        entityKey,
        jsonEncode(payload),
        deviceId,
        dedupKey,
        now,
        now,
        'pending',
        0,
        null,
      ],
    );
  }

  List<SyncOutboxEntry> pendingEntries(String scopeId) {
    final rows = _database.select(
      '''
      SELECT outbox_id, scope_id, domain, entity_key, payload_json, device_id,
             dedup_key, created_at_iso, updated_at_iso, status, attempt_count, last_error
      FROM sync_outbox
      WHERE scope_id = ? AND status IN ('pending', 'failed')
      ORDER BY updated_at_iso ASC;
      ''',
      <Object?>[scopeId],
    );
    return [
      for (final row in rows)
        SyncOutboxEntry(
          outboxId: row['outbox_id'] as String,
          scopeId: row['scope_id'] as String,
          domain: row['domain'] as String,
          entityKey: row['entity_key'] as String,
          payload: row['payload_json'] == null
              ? const <String, dynamic>{}
              : (jsonDecode(row['payload_json'] as String) as Map)
                  .map((key, value) => MapEntry(key.toString(), value)),
          deviceId: row['device_id'] as String,
          dedupKey: row['dedup_key'] as String,
          createdAtIso: row['created_at_iso'] as String,
          updatedAtIso: row['updated_at_iso'] as String,
          status: row['status'] as String,
          attemptCount: row['attempt_count'] as int,
          lastError: row['last_error']?.toString(),
        ),
    ];
  }

  int pendingCount(String scopeId) {
    final rows = _database.select(
      'SELECT COUNT(*) AS count FROM sync_outbox WHERE scope_id = ? AND status IN (\'pending\', \'failed\');',
      <Object?>[scopeId],
    );
    return rows.first['count'] as int? ?? 0;
  }

  void markUploaded(List<String> dedupKeys) {
    if (dedupKeys.isEmpty) return;
    _database.transaction<void>(() {
      for (final dedupKey in dedupKeys) {
        _database.execute(
          'UPDATE sync_outbox SET status = \'synced\', last_error = NULL WHERE dedup_key = ?;',
          <Object?>[dedupKey],
        );
      }
    });
  }

  void markFailed(List<String> dedupKeys, String errorMessage) {
    if (dedupKeys.isEmpty) return;
    _database.transaction<void>(() {
      for (final dedupKey in dedupKeys) {
        _database.execute(
          '''
          UPDATE sync_outbox
          SET status = 'failed',
              attempt_count = attempt_count + 1,
              last_error = ?
          WHERE dedup_key = ?;
          ''',
          <Object?>[errorMessage, dedupKey],
        );
      }
    });
  }

  String? cursor(String scopeId, String transportKey) {
    final rows = _database.select(
      'SELECT cursor_value FROM sync_cursor WHERE scope_id = ? AND transport_key = ? LIMIT 1;',
      <Object?>[scopeId, transportKey],
    );
    return rows.isEmpty ? null : rows.first['cursor_value']?.toString();
  }

  void saveCursor(String scopeId, String transportKey, String? cursorValue) {
    final now = DateTime.now().toIso8601String();
    _database.execute(
      '''
      INSERT INTO sync_cursor(scope_id, transport_key, cursor_value, last_sync_at_iso)
      VALUES(?, ?, ?, ?)
      ON CONFLICT(scope_id, transport_key) DO UPDATE SET
        cursor_value = excluded.cursor_value,
        last_sync_at_iso = excluded.last_sync_at_iso;
      ''',
      <Object?>[scopeId, transportKey, cursorValue, now],
    );
  }
}

class SyncMutationRecorder {
  const SyncMutationRecorder(this._outboxRepository, this._deviceIdentity);

  final SyncOutboxRepository _outboxRepository;
  final AppDeviceIdentity _deviceIdentity;

  void recordPrayerDayWrite({
    required String scopeId,
    required String dayKey,
    required String updatedAtIso,
    required List<Map<String, dynamic>> records,
  }) {
    _outboxRepository.enqueueReplace(
      scopeId: scopeId,
      domain: syncDomainPrayerLog,
      entityKey: dayKey,
      deviceId: _deviceIdentity.deviceId,
      dedupKey: '$scopeId|$syncDomainPrayerLog|$dayKey',
      payload: <String, dynamic>{
        'scopeId': scopeId,
        'dayKey': dayKey,
        'updatedAtIso': updatedAtIso,
        'records': records,
      },
    );
  }

  void recordDhikrStateWrite({
    required String scopeId,
    required String updatedAtIso,
    required String selectedPresetId,
    required int target,
    required int currentCount,
  }) {
    _outboxRepository.enqueueReplace(
      scopeId: scopeId,
      domain: syncDomainDhikrState,
      entityKey: 'current',
      deviceId: _deviceIdentity.deviceId,
      dedupKey: '$scopeId|$syncDomainDhikrState|current',
      payload: <String, dynamic>{
        'scopeId': scopeId,
        'updatedAtIso': updatedAtIso,
        'selectedPresetId': selectedPresetId,
        'target': target,
        'currentCount': currentCount,
      },
    );
  }

  void recordDhikrSessionsWrite({
    required String scopeId,
    required List<Map<String, dynamic>> sessions,
  }) {
    _outboxRepository.enqueueReplace(
      scopeId: scopeId,
      domain: syncDomainDhikrSessions,
      entityKey: 'recent',
      deviceId: _deviceIdentity.deviceId,
      dedupKey: '$scopeId|$syncDomainDhikrSessions|recent',
      payload: <String, dynamic>{
        'scopeId': scopeId,
        'sessions': sessions,
      },
    );
  }

  void recordOceanEvent(Map<String, dynamic> eventPayload) {
    final scopeId = eventPayload['scopeId']?.toString();
    final eventId = eventPayload['id']?.toString();
    if (scopeId == null || eventId == null) return;
    _outboxRepository.enqueueReplace(
      scopeId: scopeId,
      domain: syncDomainOceanEvent,
      entityKey: eventId,
      deviceId: _deviceIdentity.deviceId,
      dedupKey: '$scopeId|$syncDomainOceanEvent|$eventId',
      payload: eventPayload,
    );
  }
}

class SyncConflictResolver {
  const SyncConflictResolver(this._database);

  final AppDatabase _database;

  int applyInboundChanges(List<SyncInboundChange> changes) {
    var applied = 0;
    _database.transaction<void>(() {
      for (final change in changes) {
        applied += _applyChange(change);
      }
    });
    return applied;
  }

  int _applyChange(SyncInboundChange change) {
    switch (change.domain) {
      case syncDomainPrayerLog:
        return _applyPrayerLog(change);
      case syncDomainDhikrState:
        return _applyDhikrState(change);
      case syncDomainDhikrSessions:
        return _applyDhikrSessions(change);
      case syncDomainOceanEvent:
        return _applyOceanEvent(change);
    }
    return 0;
  }

  int _applyPrayerLog(SyncInboundChange change) {
    final dayKey = change.payload['dayKey']?.toString() ?? change.entityKey;
    final records = change.payload['records'];
    if (records is! List) return 0;
    var applied = 0;
    for (final row in records) {
      if (row is! Map) continue;
      final prayer = row['prayer']?.toString();
      if (prayer == null || prayer.isEmpty) continue;
      final incomingUpdatedAt = row['updatedAtIso']?.toString() ??
          change.payload['updatedAtIso']?.toString() ??
          change.changedAtIso;
      final existing = _database.select(
        '''
        SELECT updated_at_iso
        FROM prayer_records
        WHERE scope_id = ? AND day_key = ? AND prayer = ?
        LIMIT 1;
        ''',
        <Object?>[change.scopeId, dayKey, prayer],
      );
      final existingUpdatedAt = existing.isEmpty
          ? null
          : DateTime.tryParse(existing.first['updated_at_iso']?.toString() ?? '');
      final incoming = DateTime.tryParse(incomingUpdatedAt);
      if (existingUpdatedAt != null && incoming != null && incoming.isBefore(existingUpdatedAt)) {
        continue;
      }
      _database.execute(
        '''
        INSERT OR REPLACE INTO prayer_records(
          scope_id, day_key, prayer, status, completed_at_iso, timing, place, notes, updated_at_iso
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
        ''',
        <Object?>[
          change.scopeId,
          dayKey,
          prayer,
          row['status']?.toString() ?? 'pending',
          row['completedAtIso']?.toString(),
          row['timing']?.toString(),
          row['place']?.toString(),
          row['notes']?.toString(),
          incomingUpdatedAt,
        ],
      );
      applied += 1;
    }
    return applied;
  }

  int _applyDhikrState(SyncInboundChange change) {
    final incomingUpdatedAt = change.payload['updatedAtIso']?.toString() ?? change.changedAtIso;
    final existing = _database.select(
      'SELECT updated_at_iso FROM dhikr_state WHERE scope_id = ? LIMIT 1;',
      <Object?>[change.scopeId],
    );
    final existingUpdatedAt = existing.isEmpty
        ? null
        : DateTime.tryParse(existing.first['updated_at_iso']?.toString() ?? '');
    final incoming = DateTime.tryParse(incomingUpdatedAt);
    if (existingUpdatedAt != null && incoming != null && incoming.isBefore(existingUpdatedAt)) {
      return 0;
    }
    _database.execute(
      '''
      INSERT OR REPLACE INTO dhikr_state(
        scope_id, selected_preset_id, target, current_count, updated_at_iso
      ) VALUES (?, ?, ?, ?, ?);
      ''',
      <Object?>[
        change.scopeId,
        change.payload['selectedPresetId']?.toString() ?? 'subhanallah',
        (change.payload['target'] as num?)?.toInt() ?? 33,
        (change.payload['currentCount'] as num?)?.toInt() ?? 0,
        incomingUpdatedAt,
      ],
    );
    return 1;
  }

  int _applyDhikrSessions(SyncInboundChange change) {
    final sessions = change.payload['sessions'];
    if (sessions is! List) return 0;
    var applied = 0;
    for (final row in sessions) {
      if (row is! Map) continue;
      final sessionId = row['sessionId']?.toString();
      if (sessionId == null || sessionId.isEmpty) continue;
      final existing = _database.select(
        'SELECT session_id FROM dhikr_sessions WHERE session_id = ? LIMIT 1;',
        <Object?>[sessionId],
      );
      if (existing.isNotEmpty) {
        continue;
      }
      _database.execute(
        '''
        INSERT OR REPLACE INTO dhikr_sessions(
          scope_id, session_id, phrase_label, count, target, started_at_iso, finished_at_iso
        ) VALUES (?, ?, ?, ?, ?, ?, ?);
        ''',
        <Object?>[
          change.scopeId,
          sessionId,
          row['phraseLabel']?.toString() ?? 'Dhikr',
          (row['count'] as num?)?.toInt() ?? 0,
          (row['target'] as num?)?.toInt() ?? 33,
          row['startedAtIso']?.toString() ?? change.changedAtIso,
          row['finishedAtIso']?.toString() ?? change.changedAtIso,
        ],
      );
      applied += 1;
    }
    return applied;
  }

  int _applyOceanEvent(SyncInboundChange change) {
    final eventId = change.payload['id']?.toString() ?? change.entityKey;
    final existing = _database.select(
      'SELECT event_id FROM ocean_events WHERE event_id = ? LIMIT 1;',
      <Object?>[eventId],
    );
    if (existing.isNotEmpty) return 0;
    _database.execute(
      '''
      INSERT OR REPLACE INTO ocean_events(
        scope_id, event_id, timestamp_iso, date_key, action_type,
        source_module, amount, reference_id, metadata_json, eligibility_key
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
      ''',
      <Object?>[
        change.scopeId,
        eventId,
        change.payload['timestamp']?.toString() ?? change.changedAtIso,
        change.payload['dateKey']?.toString() ?? '',
        change.payload['actionType']?.toString() ?? '',
        change.payload['sourceModule']?.toString() ?? '',
        (change.payload['amount'] as num?)?.toInt() ?? 1,
        change.payload['referenceId']?.toString(),
        change.payload['metadata'] == null ? null : jsonEncode(change.payload['metadata']),
        change.payload['eligibilityKey']?.toString(),
      ],
    );
    return 1;
  }
}

class SyncEngine {
  const SyncEngine({
    required this.outboxRepository,
    required this.conflictResolver,
    required this.cloudTransport,
    required this.iCloudTransport,
  });

  final SyncOutboxRepository outboxRepository;
  final SyncConflictResolver conflictResolver;
  final SyncTransport cloudTransport;
  final SyncTransport iCloudTransport;

  Future<SyncRunReport> syncScope({
    required String scopeId,
    required String? accountId,
    required String deviceId,
    required String syncModeName,
  }) async {
    final completedAtIso = DateTime.now().toIso8601String();
    final transport = switch (syncModeName) {
      'pathOfNurCloud' => cloudTransport,
      'iCloud' => iCloudTransport,
      _ => null,
    };
    if (transport == null) {
      return SyncRunReport(
        succeeded: true,
        online: false,
        pendingCount: outboxRepository.pendingCount(scopeId),
        uploadedCount: 0,
        appliedInboundCount: 0,
        completedAtIso: completedAtIso,
        recentEvents: const <String>['Local-only mode active'],
        transportLabel: 'Local storage',
        transportAvailable: false,
        resultSummary: 'Local-only mode active',
        statusCode: 'local_only',
      );
    }

    final pending = outboxRepository.pendingEntries(scopeId);
    final transportKey = syncModeName;
    final request = SyncTransportRequest(
      scopeId: scopeId,
      accountId: accountId,
      deviceId: deviceId,
      cursor: outboxRepository.cursor(scopeId, transportKey),
      outboxEntries: pending,
    );

    final response = await transport.sync(request);
    if (!response.online) {
      if (pending.isNotEmpty) {
        outboxRepository.markFailed(
          pending.map((entry) => entry.dedupKey).toList(growable: false),
          response.errorMessage ?? 'Offline',
        );
      }
      return SyncRunReport(
        succeeded: false,
        online: false,
        pendingCount: outboxRepository.pendingCount(scopeId),
        uploadedCount: 0,
        appliedInboundCount: 0,
        completedAtIso: completedAtIso,
        recentEvents: <String>[response.errorMessage ?? 'Sync unavailable'],
        errorMessage: response.errorMessage,
        transportLabel: response.transportLabel ?? transportKey,
        transportAvailable: false,
        resultSummary: response.errorMessage ?? 'Sync unavailable',
        statusCode: response.statusCode ?? 'transport_unavailable',
      );
    }

    outboxRepository.markUploaded(response.acceptedDedupKeys);
    final appliedInboundCount = conflictResolver.applyInboundChanges(response.inboundChanges);
    outboxRepository.saveCursor(scopeId, transportKey, response.nextCursor);
    return SyncRunReport(
      succeeded: true,
      online: true,
      pendingCount: outboxRepository.pendingCount(scopeId),
      uploadedCount: response.acceptedDedupKeys.length,
      appliedInboundCount: appliedInboundCount,
      completedAtIso: completedAtIso,
      recentEvents: <String>[
        if (response.acceptedDedupKeys.isNotEmpty)
          'Uploaded ${response.acceptedDedupKeys.length} changes',
        if (appliedInboundCount > 0) 'Applied $appliedInboundCount inbound changes',
        if (response.acceptedDedupKeys.isEmpty && appliedInboundCount == 0)
          'No changes to sync',
      ],
      transportLabel: response.transportLabel ?? transportKey,
      transportAvailable: true,
      resultSummary: response.acceptedDedupKeys.isEmpty && appliedInboundCount == 0
          ? 'No changes to sync'
          : 'Sync completed successfully',
      statusCode: response.statusCode ?? 'ok',
    );
  }
}

String _platformKey() {
  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
      return 'ios';
    case TargetPlatform.android:
      return 'android';
    case TargetPlatform.macOS:
      return 'macos';
    case TargetPlatform.windows:
      return 'windows';
    case TargetPlatform.linux:
      return 'linux';
    case TargetPlatform.fuchsia:
      return 'fuchsia';
  }
}

String _defaultDeviceName() {
  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
      return 'Apple Device';
    case TargetPlatform.android:
      return 'Android Device';
    case TargetPlatform.macOS:
      return 'Mac';
    case TargetPlatform.windows:
      return 'Windows PC';
    case TargetPlatform.linux:
      return 'Linux Device';
    case TargetPlatform.fuchsia:
      return 'Path of Nur Device';
  }
}

final deviceIdentityProvider = Provider<AppDeviceIdentity>((ref) {
  final store = ref.watch(localStoreProvider);
  final existing = store.getString(_deviceIdStorageKey);
  final deviceId = existing ?? 'device_${DateTime.now().microsecondsSinceEpoch}';
  if (existing == null) {
    store.setString(_deviceIdStorageKey, deviceId);
  }
  return AppDeviceIdentity(
    deviceId: deviceId,
    deviceName: _defaultDeviceName(),
    platformKey: _platformKey(),
  );
});

final syncOutboxRepositoryProvider = Provider<SyncOutboxRepository>((ref) {
  final repository = SyncOutboxRepository(ref.watch(appDatabaseProvider));
  repository.registerDevice(ref.watch(deviceIdentityProvider));
  return repository;
});

final syncMutationRecorderProvider = Provider<SyncMutationRecorder>((ref) {
  return SyncMutationRecorder(
    ref.watch(syncOutboxRepositoryProvider),
    ref.watch(deviceIdentityProvider),
  );
});

final syncConflictResolverProvider = Provider<SyncConflictResolver>((ref) {
  return SyncConflictResolver(ref.watch(appDatabaseProvider));
});

final cloudSyncTransportProvider = Provider<SyncTransport>((ref) {
  return const UnavailableSyncTransport(reason: 'Cloud sync transport not configured');
});

final iCloudSyncTransportProvider = Provider<SyncTransport>((ref) {
  return const ICloudSyncTransport();
});

final syncEngineProvider = Provider<SyncEngine>((ref) {
  return SyncEngine(
    outboxRepository: ref.watch(syncOutboxRepositoryProvider),
    conflictResolver: ref.watch(syncConflictResolverProvider),
    cloudTransport: ref.watch(cloudSyncTransportProvider),
    iCloudTransport: ref.watch(iCloudSyncTransportProvider),
  );
});

final syncPendingCountProvider = Provider<int>((ref) {
  final scopeId = ref.watch(structuredDataScopeProvider);
  return ref.watch(syncOutboxRepositoryProvider).pendingCount(scopeId);
});
