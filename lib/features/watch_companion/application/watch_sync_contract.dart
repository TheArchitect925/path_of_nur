import 'dart:ui' show Locale;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/locale_provider.dart';
import '../../../core/prayer/prayer_preferences.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/application/daily_clock_provider.dart';
import '../../../shared/persistence/local_store.dart';
import '../../journey/application/journey_progression_provider.dart';
import '../../journey/xp/application/journey_xp_providers.dart';
import '../../ios_widgets/application/spiritual_widget_content_engine.dart';
import '../../learn/dua/application/daily_dua_content_service.dart';
import '../../ocean/application/ocean_drops_provider.dart';
import '../../profile/application/profile_settings_provider.dart';
import '../../worship/application/dhikr_controller.dart';
import '../../worship/application/prayer_controller.dart';
import '../../worship/data/dhikr_repository.dart';
import '../../worship/data/prayer_log_repository.dart';
import '../../worship/domain/dhikr_session.dart';
import '../../worship/domain/prayer_name.dart';
import '../../worship/domain/prayer_status.dart';
import '../../worship/domain/prayer_tracker_fields.dart';
import 'watch_sync_diagnostics.dart';
import 'watch_sync_validation.dart';

const _watchSyncStorageKey = 'watch.sync.contract.v1';
const _watchSyncSourceVersion = '1';
const _watchSnapshotSchemaVersion = 1;

enum WatchDeviceType { appleWatch, wearOs }

enum WatchActionType {
  prayerStatusUpdated,
  prayerComplete,
  prayerUncomplete,
  dhikrSessionStarted,
  dhikrIncrement,
  dhikrReset,
  dhikrSessionCompleted,
  postPrayerAdhkarCompleted,
  snoozeRequested,
  notificationActionLogged,
}

enum WatchAckResultType {
  applied,
  ignoredDuplicate,
  ignoredStale,
  conflictResolved,
  failedValidation,
}

class WatchDailySnapshot {
  const WatchDailySnapshot({
    required this.schemaVersion,
    required this.snapshotId,
    required this.generatedAt,
    required this.date,
    required this.timezone,
    required this.nextPrayerId,
    required this.nextPrayerTime,
    required this.currentPrayerId,
    required this.completedPrayerCount,
    required this.totalPrayerCount,
    required this.dhikrTodayCount,
    required this.xpToday,
    required this.oceanDropsToday,
    required this.streakDays,
    required this.currentLevel,
    required this.growthStageKey,
    required this.prayers,
    required this.activeDhikrSession,
    required this.spiritualPrompt,
    required this.lastSyncAt,
    required this.sourceVersion,
  });

  final int schemaVersion;
  final String snapshotId;
  final DateTime generatedAt;
  final String date;
  final String timezone;
  final String? nextPrayerId;
  final DateTime? nextPrayerTime;
  final String? currentPrayerId;
  final int completedPrayerCount;
  final int totalPrayerCount;
  final int dhikrTodayCount;
  final int xpToday;
  final int oceanDropsToday;
  final int streakDays;
  final int currentLevel;
  final String growthStageKey;
  final List<WatchPrayerStatusContract> prayers;
  final WatchDhikrSessionSnapshot? activeDhikrSession;
  final WatchSpiritualPromptSnapshot? spiritualPrompt;
  final DateTime lastSyncAt;
  final String sourceVersion;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'schemaVersion': schemaVersion,
    'snapshotId': snapshotId,
    'generatedAt': generatedAt.toIso8601String(),
    'date': date,
    'timezone': timezone,
    'nextPrayerId': nextPrayerId,
    'nextPrayerTime': nextPrayerTime?.toIso8601String(),
    'currentPrayerId': currentPrayerId,
    'completedPrayerCount': completedPrayerCount,
    'totalPrayerCount': totalPrayerCount,
    'dhikrTodayCount': dhikrTodayCount,
    'xpToday': xpToday,
    'oceanDropsToday': oceanDropsToday,
    'streakDays': streakDays,
    'currentLevel': currentLevel,
    'growthStageKey': growthStageKey,
    'prayers': prayers.map((item) => item.toJson()).toList(),
    'activeDhikrSession': activeDhikrSession?.toJson(),
    'spiritualPrompt': spiritualPrompt?.toJson(),
    'lastSyncAt': lastSyncAt.toIso8601String(),
    'sourceVersion': sourceVersion,
  };
}

class WatchSpiritualPromptSnapshot {
  const WatchSpiritualPromptSnapshot({
    required this.kind,
    required this.title,
    required this.shortText,
    required this.inlineText,
    required this.circularText,
  });

  final String kind;
  final String title;
  final String shortText;
  final String inlineText;
  final String circularText;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'kind': kind,
    'title': title,
    'shortText': shortText,
    'inlineText': inlineText,
    'circularText': circularText,
  };
}

class WatchPrayerStatusContract {
  const WatchPrayerStatusContract({
    required this.prayerId,
    required this.displayName,
    required this.scheduledTime,
    required this.status,
    required this.completedAt,
    required this.timing,
    required this.source,
  });

  final String prayerId;
  final String displayName;
  final DateTime scheduledTime;
  final String status;
  final DateTime? completedAt;
  final String? timing;
  final String source;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'prayerId': prayerId,
    'displayName': displayName,
    'scheduledTime': scheduledTime.toIso8601String(),
    'status': status,
    'completedAt': completedAt?.toIso8601String(),
    'timing': timing,
    'source': source,
  };
}

class WatchDhikrSessionSnapshot {
  const WatchDhikrSessionSnapshot({
    required this.sessionId,
    required this.mode,
    required this.targetCount,
    required this.currentCount,
    required this.startedAt,
    required this.updatedAt,
    required this.completed,
    required this.rewardEligible,
    required this.source,
  });

  final String sessionId;
  final String mode;
  final int? targetCount;
  final int currentCount;
  final DateTime startedAt;
  final DateTime updatedAt;
  final bool completed;
  final bool rewardEligible;
  final String source;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'sessionId': sessionId,
    'mode': mode,
    'targetCount': targetCount,
    'currentCount': currentCount,
    'startedAt': startedAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'completed': completed,
    'rewardEligible': rewardEligible,
    'source': source,
  };
}

class WatchSettingsSnapshot {
  const WatchSettingsSnapshot({
    required this.schemaVersion,
    required this.prayerNotificationsEnabled,
    required this.enabledPrayerIds,
    required this.followUpReminderEnabled,
    required this.followUpDelayMinutes,
    required this.snoozeDurationMinutes,
    required this.dhikrReminderEnabled,
    required this.quietModeEnabled,
    required this.watchThemeMode,
    required this.lastUpdatedAt,
  });

  final int schemaVersion;
  final bool prayerNotificationsEnabled;
  final List<String> enabledPrayerIds;
  final bool followUpReminderEnabled;
  final int followUpDelayMinutes;
  final int snoozeDurationMinutes;
  final bool dhikrReminderEnabled;
  final bool quietModeEnabled;
  final String? watchThemeMode;
  final DateTime lastUpdatedAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'schemaVersion': schemaVersion,
    'prayerNotificationsEnabled': prayerNotificationsEnabled,
    'enabledPrayerIds': enabledPrayerIds,
    'followUpReminderEnabled': followUpReminderEnabled,
    'followUpDelayMinutes': followUpDelayMinutes,
    'snoozeDurationMinutes': snoozeDurationMinutes,
    'dhikrReminderEnabled': dhikrReminderEnabled,
    'quietModeEnabled': quietModeEnabled,
    'watchThemeMode': watchThemeMode,
    'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
  };
}

class WatchActionEnvelope {
  const WatchActionEnvelope({
    required this.actionId,
    required this.deviceType,
    required this.actionType,
    required this.createdAt,
    required this.logicalDate,
    required this.payload,
    this.deviceId,
    this.sourceVersion,
  });

  final String actionId;
  final WatchDeviceType deviceType;
  final String? deviceId;
  final WatchActionType actionType;
  final DateTime createdAt;
  final String logicalDate;
  final Map<String, dynamic> payload;
  final String? sourceVersion;

  static WatchActionEnvelope? fromJson(Map<String, dynamic> json) {
    final actionId = json['actionId']?.toString();
    final deviceTypeRaw = json['deviceType']?.toString();
    final actionTypeRaw = json['actionType']?.toString();
    final createdAt = DateTime.tryParse(json['createdAt']?.toString() ?? '');
    final logicalDate = json['logicalDate']?.toString();
    final payload = json['payload'] is Map
        ? (json['payload'] as Map).map(
            (key, value) => MapEntry(key.toString(), value),
          )
        : null;
    if (actionId == null ||
        createdAt == null ||
        logicalDate == null ||
        payload == null) {
      return null;
    }
    final deviceType = switch (deviceTypeRaw) {
      'apple_watch' => WatchDeviceType.appleWatch,
      'wear_os' => WatchDeviceType.wearOs,
      _ => null,
    };
    final actionType = switch (actionTypeRaw) {
      'prayer_status_updated' => WatchActionType.prayerStatusUpdated,
      'prayer_complete' => WatchActionType.prayerComplete,
      'prayer_uncomplete' => WatchActionType.prayerUncomplete,
      'dhikr_session_started' => WatchActionType.dhikrSessionStarted,
      'dhikr_increment' => WatchActionType.dhikrIncrement,
      'dhikr_reset' => WatchActionType.dhikrReset,
      'dhikr_session_completed' => WatchActionType.dhikrSessionCompleted,
      'post_prayer_adhkar_completed' =>
        WatchActionType.postPrayerAdhkarCompleted,
      'snooze_requested' => WatchActionType.snoozeRequested,
      'notification_action_logged' => WatchActionType.notificationActionLogged,
      _ => null,
    };
    if (deviceType == null || actionType == null) return null;
    return WatchActionEnvelope(
      actionId: actionId,
      deviceType: deviceType,
      deviceId: json['deviceId']?.toString(),
      actionType: actionType,
      createdAt: createdAt,
      logicalDate: logicalDate,
      payload: payload,
      sourceVersion: json['sourceVersion']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'actionId': actionId,
    'deviceType': deviceType == WatchDeviceType.appleWatch
        ? 'apple_watch'
        : 'wear_os',
    'deviceId': deviceId,
    'actionType': switch (actionType) {
      WatchActionType.prayerStatusUpdated => 'prayer_status_updated',
      WatchActionType.prayerComplete => 'prayer_complete',
      WatchActionType.prayerUncomplete => 'prayer_uncomplete',
      WatchActionType.dhikrSessionStarted => 'dhikr_session_started',
      WatchActionType.dhikrIncrement => 'dhikr_increment',
      WatchActionType.dhikrReset => 'dhikr_reset',
      WatchActionType.dhikrSessionCompleted => 'dhikr_session_completed',
      WatchActionType.postPrayerAdhkarCompleted =>
        'post_prayer_adhkar_completed',
      WatchActionType.snoozeRequested => 'snooze_requested',
      WatchActionType.notificationActionLogged => 'notification_action_logged',
    },
    'createdAt': createdAt.toIso8601String(),
    'logicalDate': logicalDate,
    'payload': payload,
    'sourceVersion': sourceVersion,
  };
}

class WatchSyncAck {
  const WatchSyncAck({
    required this.actionId,
    required this.processed,
    required this.processedAt,
    required this.resultType,
    this.resultingSnapshotId,
    this.notes,
  });

  final String actionId;
  final bool processed;
  final DateTime processedAt;
  final WatchAckResultType resultType;
  final String? resultingSnapshotId;
  final String? notes;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'actionId': actionId,
    'processed': processed,
    'processedAt': processedAt.toIso8601String(),
    'resultType': switch (resultType) {
      WatchAckResultType.applied => 'applied',
      WatchAckResultType.ignoredDuplicate => 'ignored_duplicate',
      WatchAckResultType.ignoredStale => 'ignored_stale',
      WatchAckResultType.conflictResolved => 'conflict_resolved',
      WatchAckResultType.failedValidation => 'failed_validation',
    },
    'resultingSnapshotId': resultingSnapshotId,
    'notes': notes,
  };
}

class WatchActionResponse {
  const WatchActionResponse({required this.ack, required this.snapshot});

  final WatchSyncAck ack;
  final WatchDailySnapshot snapshot;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'ack': ack.toJson(),
    'snapshot': snapshot.toJson(),
  };
}

class _WatchSyncStoreState {
  const _WatchSyncStoreState({
    required this.acks,
    required this.dhikrSessions,
    required this.prayerTargets,
    required this.lastSyncAt,
  });

  final Map<String, Map<String, dynamic>> acks;
  final Map<String, Map<String, dynamic>> dhikrSessions;
  final Map<String, Map<String, dynamic>> prayerTargets;
  final DateTime? lastSyncAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'acks': acks,
    'dhikrSessions': dhikrSessions,
    'prayerTargets': prayerTargets,
    'lastSyncAt': lastSyncAt?.toIso8601String(),
  };

  factory _WatchSyncStoreState.fromJson(Map<String, dynamic>? json) {
    Map<String, Map<String, dynamic>> mapOfMaps(String key) {
      final raw = json?[key];
      if (raw is! Map) return <String, Map<String, dynamic>>{};
      return raw.map((key, value) {
        if (value is Map) {
          return MapEntry(
            key.toString(),
            value.map((k, v) => MapEntry(k.toString(), v)),
          );
        }
        return MapEntry(key.toString(), <String, dynamic>{});
      });
    }

    return _WatchSyncStoreState(
      acks: mapOfMaps('acks'),
      dhikrSessions: mapOfMaps('dhikrSessions'),
      prayerTargets: mapOfMaps('prayerTargets'),
      lastSyncAt: DateTime.tryParse(json?['lastSyncAt']?.toString() ?? ''),
    );
  }
}

class WatchSyncAckService {
  WatchSyncAckService(this._store);

  final LocalStore _store;

  _WatchSyncStoreState _state() =>
      _WatchSyncStoreState.fromJson(_store.getJsonMap(_watchSyncStorageKey));

  Future<void> _save(_WatchSyncStoreState state) {
    return _store.setJsonMap(_watchSyncStorageKey, state.toJson());
  }

  WatchSyncAck? lookupAck(String actionId) {
    final row = _state().acks[actionId];
    if (row == null) return null;
    return WatchSyncAck(
      actionId: actionId,
      processed: row['processed'] == true,
      processedAt:
          DateTime.tryParse(row['processedAt']?.toString() ?? '') ??
          DateTime.now(),
      resultType: switch (row['resultType']?.toString()) {
        'applied' => WatchAckResultType.applied,
        'ignored_duplicate' => WatchAckResultType.ignoredDuplicate,
        'ignored_stale' => WatchAckResultType.ignoredStale,
        'conflict_resolved' => WatchAckResultType.conflictResolved,
        _ => WatchAckResultType.failedValidation,
      },
      resultingSnapshotId: row['resultingSnapshotId']?.toString(),
      notes: row['notes']?.toString(),
    );
  }

  Future<void> persistAck(WatchSyncAck ack) async {
    final state = _state();
    final nextAcks = Map<String, Map<String, dynamic>>.from(state.acks)
      ..[ack.actionId] = ack.toJson();
    await _save(
      _WatchSyncStoreState(
        acks: _truncate(nextAcks, 300),
        dhikrSessions: state.dhikrSessions,
        prayerTargets: state.prayerTargets,
        lastSyncAt: DateTime.now(),
      ),
    );
  }

  Map<String, dynamic>? dhikrSession(String sessionId) {
    return _state().dhikrSessions[sessionId];
  }

  Future<void> persistDhikrSession(
    String sessionId,
    Map<String, dynamic> payload,
  ) async {
    final state = _state();
    final next = Map<String, Map<String, dynamic>>.from(state.dhikrSessions)
      ..[sessionId] = payload;
    await _save(
      _WatchSyncStoreState(
        acks: state.acks,
        dhikrSessions: _truncate(next, 200),
        prayerTargets: state.prayerTargets,
        lastSyncAt: DateTime.now(),
      ),
    );
  }

  Map<String, dynamic>? prayerTargetState(String targetKey) {
    return _state().prayerTargets[targetKey];
  }

  Future<void> persistPrayerTargetState(
    String targetKey,
    Map<String, dynamic> payload,
  ) async {
    final state = _state();
    final next = Map<String, Map<String, dynamic>>.from(state.prayerTargets)
      ..[targetKey] = payload;
    await _save(
      _WatchSyncStoreState(
        acks: state.acks,
        dhikrSessions: state.dhikrSessions,
        prayerTargets: _truncate(next, 200),
        lastSyncAt: DateTime.now(),
      ),
    );
  }

  DateTime? lastSyncAt() => _state().lastSyncAt;

  Map<String, Map<String, dynamic>> _truncate(
    Map<String, Map<String, dynamic>> input,
    int maxEntries,
  ) {
    if (input.length <= maxEntries) return input;
    final entries = input.entries.toList()
      ..sort((a, b) {
        final left =
            DateTime.tryParse(a.value['processedAt']?.toString() ?? '') ??
            DateTime.tryParse(a.value['updatedAt']?.toString() ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0);
        final right =
            DateTime.tryParse(b.value['processedAt']?.toString() ?? '') ??
            DateTime.tryParse(b.value['updatedAt']?.toString() ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0);
        return right.compareTo(left);
      });
    return {
      for (final entry in entries.take(maxEntries)) entry.key: entry.value,
    };
  }
}

class WatchDailySnapshotBuilder {
  WatchDailySnapshotBuilder(this._ref);

  final Ref _ref;

  WatchDailySnapshot build() {
    final now = _ref.read(dailyNowProvider).value ?? DateTime.now();
    final todayKey = LocalStore.todayKey(now);
    final locale = _ref.read(appLocaleProvider) ?? const Locale('en');
    final l10n = lookupAppLocalizations(locale);
    final schedule = _ref.read(prayerScheduleProvider);
    final context = _ref.read(prayerScheduleContextProvider);
    final prayerRecords = _ref.read(prayerControllerProvider);
    final dhikr = _ref.read(dhikrControllerProvider);
    final xpSummary = _ref.read(journeyXpSummaryProvider);
    final journey = _ref.read(journeyComputedProgressProvider);
    final journeySnapshot = _ref.read(journeyActivitySnapshotProvider);
    final spiritualBundle = _ref
        .read(spiritualWidgetContentEngineProvider)
        .build(now: now, duaSurface: duaSurfaceWatch);
    final ackService = _ref.read(watchSyncAckServiceProvider);
    final activeDhikr = _activeDhikrSessionFromStore(
      ackService.dhikrSession('__active__'),
      dhikr,
      now,
    );
    final completedPrayerCount = prayerRecords
        .where((record) => record.status == PrayerStatus.completed)
        .length;

    final snapshot = WatchDailySnapshot(
      schemaVersion: _watchSnapshotSchemaVersion,
      snapshotId: 'watch_snapshot_${todayKey}_${now.microsecondsSinceEpoch}',
      generatedAt: now,
      date: todayKey,
      timezone: now.timeZoneName,
      nextPrayerId: context.nextPrayerId,
      nextPrayerTime: _nextPrayerTimeFor(schedule, context.nextPrayerId),
      currentPrayerId: context.currentPrayerId,
      completedPrayerCount: completedPrayerCount,
      totalPrayerCount: 5,
      dhikrTodayCount: journeySnapshot.dhikrCountToday,
      xpToday: xpSummary.todayXp,
      oceanDropsToday: _ref.read(oceanDropServiceProvider).getDropsToday(),
      streakDays: journey.currentStreakDays,
      currentLevel: xpSummary.currentLevel,
      growthStageKey: journey.growthStageKey,
      prayers: [
        for (final item in schedule.where((item) => _isTrackedPrayer(item.id)))
          WatchPrayerStatusContract(
            prayerId: item.id,
            displayName: item.name,
            scheduledTime: item.offerDateTime,
            status: _statusForPrayer(prayerRecords, item.id),
            completedAt: _completedAtForPrayer(prayerRecords, item.id),
            timing: _timingForPrayer(item.id, todayKey),
            source: 'phone',
          ),
      ],
      activeDhikrSession: activeDhikr,
      spiritualPrompt: _spiritualPromptSnapshot(
        l10n: l10n,
        bundle: spiritualBundle,
      ),
      lastSyncAt: ackService.lastSyncAt() ?? now,
      sourceVersion: _watchSyncSourceVersion,
    );
    WatchSyncDiagnostics.log('snapshot_generated', <String, Object?>{
      'snapshotId': snapshot.snapshotId,
      'date': snapshot.date,
      'nextPrayerId': snapshot.nextPrayerId,
      'completedPrayerCount': snapshot.completedPrayerCount,
      'dhikrTodayCount': snapshot.dhikrTodayCount,
      'issues': validateWatchDailySnapshot(snapshot).length,
    });
    return snapshot;
  }

  WatchSpiritualPromptSnapshot _spiritualPromptSnapshot({
    required AppLocalizations l10n,
    required SpiritualWidgetContentBundle bundle,
  }) {
    final prompt = bundle.watchPrompt;
    final title = switch (prompt.kind) {
      'dua' => switch (bundle.timeOfDay) {
        SpiritualTimeOfDay.morning => l10n.homeWidgetsMorningDuaReady,
        SpiritualTimeOfDay.afternoon => l10n.homeWidgetsDailyDuaReady,
        SpiritualTimeOfDay.evening => l10n.homeWidgetsEveningDuaReady,
        SpiritualTimeOfDay.night => l10n.homeWidgetsNightDuaReady,
      },
      'hadith' => l10n.homeWidgetsHadithTodayInline,
      'ayah' => l10n.homeWidgetsAyahTodayInline,
      _ => l10n.homeWidgetsReflectionInline,
    };
    final circularText = switch (prompt.kind) {
      'dua' => 'D',
      'hadith' => 'H',
      'ayah' => 'A',
      _ => 'R',
    };
    return WatchSpiritualPromptSnapshot(
      kind: prompt.kind,
      title: title,
      shortText: prompt.sourceShortText,
      inlineText: title,
      circularText: circularText,
    );
  }

  WatchDhikrSessionSnapshot? _activeDhikrSessionFromStore(
    Map<String, dynamic>? stored,
    DhikrSessionState dhikr,
    DateTime now,
  ) {
    if (stored != null) {
      final currentCount = (stored['currentCount'] as num?)?.toInt() ?? 0;
      if (currentCount > 0 || stored['completed'] == true) {
        return WatchDhikrSessionSnapshot(
          sessionId: stored['sessionId']?.toString() ?? 'watch-active',
          mode: stored['mode']?.toString() ?? _modeFromTarget(dhikr.target),
          targetCount: (stored['targetCount'] as num?)?.toInt(),
          currentCount: currentCount,
          startedAt:
              DateTime.tryParse(stored['startedAt']?.toString() ?? '') ?? now,
          updatedAt:
              DateTime.tryParse(stored['updatedAt']?.toString() ?? '') ?? now,
          completed: stored['completed'] == true,
          rewardEligible: stored['rewardEligible'] == true,
          source: 'synced',
        );
      }
    }
    if (dhikr.currentCount <= 0) return null;
    return WatchDhikrSessionSnapshot(
      sessionId: 'phone-active-${LocalStore.todayKey(now)}',
      mode: _modeFromTarget(dhikr.target),
      targetCount: dhikr.target >= 100 ? null : dhikr.target,
      currentCount: dhikr.currentCount,
      startedAt: now,
      updatedAt: now,
      completed: dhikr.hasTargetReached,
      rewardEligible: dhikr.hasTargetReached,
      source: 'phone',
    );
  }

  DateTime? _nextPrayerTimeFor(
    List<PrayerScheduleItem> schedule,
    String? nextPrayerId,
  ) {
    if (nextPrayerId == null) return null;
    for (final item in schedule) {
      if (item.id == nextPrayerId) return item.offerDateTime;
    }
    return null;
  }

  String _modeFromTarget(int target) {
    if (target == 33) return 'preset_33';
    if (target == 34) return 'preset_34';
    if (target == 99) return 'preset_99';
    return 'free';
  }

  bool _isTrackedPrayer(String id) =>
      id == 'fajr' ||
      id == 'dhuhr' ||
      id == 'asr' ||
      id == 'maghrib' ||
      id == 'isha';

  String _statusForPrayer(List<dynamic> prayerRecords, String prayerId) {
    for (final record in prayerRecords) {
      final recordPrayerId = _prayerIdFromRecord(record);
      if (recordPrayerId == prayerId) {
        return switch (record.status as PrayerStatus) {
          PrayerStatus.completed => 'completed',
          PrayerStatus.missed => 'missed',
          PrayerStatus.pending => 'pending',
        };
      }
    }
    return 'pending';
  }

  DateTime? _completedAtForPrayer(
    List<dynamic> prayerRecords,
    String prayerId,
  ) {
    for (final record in prayerRecords) {
      final recordPrayerId = _prayerIdFromRecord(record);
      if (recordPrayerId == prayerId) {
        return DateTime.tryParse(record.completedAtIso ?? '');
      }
    }
    return null;
  }

  String? _timingForPrayer(String prayerId, String dayKey) {
    final prayer = PrayerName.values
        .where((item) => item.name == prayerId)
        .firstOrNull;
    if (prayer == null) return null;
    return _ref
        .read(prayerLogRepositoryProvider)
        .readDayEntries(dayKey)[prayer]
        ?.timing
        ?.name;
  }

  String? _prayerIdFromRecord(dynamic record) {
    final prayer = record.prayer;
    final raw = prayer?.toString();
    if (raw == null || raw.isEmpty) return null;
    final parts = raw.split('.');
    return parts.isEmpty ? raw : parts.last;
  }
}

class WatchSettingsSnapshotBuilder {
  WatchSettingsSnapshotBuilder(this._ref);

  final Ref _ref;

  WatchSettingsSnapshot build() {
    final prayerSettings = _ref.read(prayerSettingsProvider);
    final profileSettings = _ref.read(profileSettingsProvider);
    final enabledPrayerIds = prayerSettings.notificationModes.entries
        .where((entry) => _isTrackedPrayer(entry.key))
        .where((entry) => entry.value != PrayerNotificationMode.none)
        .map((entry) => entry.key)
        .toList();
    final prayerNotificationsEnabled =
        profileSettings.prayerReminders && enabledPrayerIds.isNotEmpty;
    final watchThemeMode = _watchThemeModeForProfile(profileSettings);
    final snapshot = WatchSettingsSnapshot(
      schemaVersion: _watchSnapshotSchemaVersion,
      prayerNotificationsEnabled: prayerNotificationsEnabled,
      enabledPrayerIds: enabledPrayerIds,
      followUpReminderEnabled:
          prayerNotificationsEnabled &&
          profileSettings.prayerReminderFollowUpEnabled,
      followUpDelayMinutes: profileSettings.prayerReminderFollowUpDelayMinutes,
      snoozeDurationMinutes: profileSettings.prayerReminderSnoozeMinutes,
      dhikrReminderEnabled: profileSettings.dhikrReminders,
      // Gentle mode is the closest persisted phone-side preference today.
      quietModeEnabled: profileSettings.gentleModeEnabled,
      watchThemeMode: watchThemeMode,
      lastUpdatedAt:
          prayerSettings.preferences.lastModeSwitchAt ?? DateTime.now(),
    );
    WatchSyncDiagnostics.log('settings_snapshot_generated', <String, Object?>{
      'prayerNotificationsEnabled': snapshot.prayerNotificationsEnabled,
      'enabledPrayerIds': snapshot.enabledPrayerIds.join(','),
      'dhikrReminderEnabled': snapshot.dhikrReminderEnabled,
      'watchThemeMode': snapshot.watchThemeMode,
      'followUpDelayMinutes': snapshot.followUpDelayMinutes,
      'snoozeDurationMinutes': snapshot.snoozeDurationMinutes,
      'issues': validateSettingsSnapshot(snapshot).length,
    });
    return snapshot;
  }

  bool _isTrackedPrayer(String id) =>
      id == 'fajr' ||
      id == 'dhuhr' ||
      id == 'asr' ||
      id == 'maghrib' ||
      id == 'isha';

  String? _watchThemeModeForProfile(ProfileSettingsState profileSettings) {
    return profileSettings.appThemeMode.name;
  }
}

class WatchRewardReconciliationService {
  WatchRewardReconciliationService(this._ref);

  final Ref _ref;

  int applyPrayerReward({
    required String prayerId,
    required String logicalDate,
  }) {
    return _ref
        .read(oceanDropServiceProvider)
        .awardDrop(
          actionType: oceanActionPrayerCompleted,
          sourceModule: oceanSourcePrayer,
          referenceId: prayerId,
          metadata: <String, dynamic>{'timestamp': '${logicalDate}T12:00:00'},
        );
  }

  int applyDhikrReward({
    required String sessionId,
    required String mode,
    required int countDelta,
    required int targetCount,
    required DateTime timestamp,
  }) {
    if (mode == 'free') {
      return _ref
          .read(oceanDropServiceProvider)
          .awardDrop(
            actionType: oceanActionDhikrFreeHundredReached,
            sourceModule: oceanSourceDhikr,
            referenceId: sessionId,
            metadata: <String, dynamic>{
              'countDelta': countDelta,
              'timestamp': timestamp.toIso8601String(),
            },
          );
    }
    return _ref
        .read(oceanDropServiceProvider)
        .awardDrop(
          actionType: oceanActionDhikrSetCompleted,
          sourceModule: oceanSourceDhikr,
          referenceId: sessionId,
          metadata: <String, dynamic>{
            'target': targetCount,
            'timestamp': timestamp.toIso8601String(),
          },
        );
  }
}

class WatchSummaryRefreshService {
  WatchSummaryRefreshService(this._ref);

  final Ref _ref;

  WatchDailySnapshot rebuildSnapshot() {
    final today = LocalStore.todayKey();
    _ref
        .read(prayerControllerProvider.notifier)
        .onDayChanged(today, force: true);
    _ref.read(dhikrControllerProvider.notifier).reloadFromStorage();
    _ref
        .read(journeyProgressProvider.notifier)
        .syncFromSnapshot(_ref.read(journeyActivitySnapshotProvider));
    return _ref.read(watchDailySnapshotBuilderProvider).build();
  }
}

class WatchActionReconciler {
  WatchActionReconciler(this._ref);

  final Ref _ref;

  Future<WatchSyncAck> reconcile(WatchActionEnvelope action) async {
    final validationIssues = validateWatchActionEnvelope(action);
    if (validationIssues.isNotEmpty) {
      final ack = _simpleAck(
        action,
        WatchAckResultType.failedValidation,
        notes: validationIssues.map((issue) => issue.message).join('; '),
      );
      WatchSyncDiagnostics.log(
        'watch_action_failed_validation',
        <String, Object?>{
          'actionId': action.actionId,
          'actionType': action.actionType.name,
          'issues': ack.notes,
        },
      );
      return _persistAck(ack);
    }

    final ackService = _ref.read(watchSyncAckServiceProvider);
    final existingAck = ackService.lookupAck(action.actionId);
    if (existingAck != null) {
      WatchSyncDiagnostics.log('watch_action_duplicate', <String, Object?>{
        'actionId': action.actionId,
        'actionType': action.actionType.name,
        'resultType': existingAck.resultType.name,
      });
      return existingAck;
    }

    WatchSyncDiagnostics.log('watch_action_received', <String, Object?>{
      'actionId': action.actionId,
      'deviceType': action.deviceType.name,
      'actionType': action.actionType.name,
      'logicalDate': action.logicalDate,
    });

    return switch (action.actionType) {
      WatchActionType.prayerStatusUpdated => _reconcilePrayerStatusUpdate(
        action,
      ),
      WatchActionType.prayerComplete => _reconcilePrayer(
        action,
        complete: true,
      ),
      WatchActionType.prayerUncomplete => _reconcilePrayer(
        action,
        complete: false,
      ),
      WatchActionType.dhikrSessionStarted => _reconcileDhikrStarted(action),
      WatchActionType.dhikrIncrement => _reconcileDhikrIncrement(action),
      WatchActionType.dhikrReset => _reconcileDhikrReset(action),
      WatchActionType.dhikrSessionCompleted => _reconcileDhikrCompleted(action),
      WatchActionType.postPrayerAdhkarCompleted => _simpleAck(
        action,
        WatchAckResultType.applied,
        notes: 'Post-prayer adhkar completion logged',
      ),
      WatchActionType.snoozeRequested => _simpleAck(
        action,
        WatchAckResultType.applied,
        notes: 'Snooze logged',
      ),
      WatchActionType.notificationActionLogged => _simpleAck(
        action,
        WatchAckResultType.applied,
        notes: 'Notification action logged',
      ),
    };
  }

  Future<WatchSyncAck> _reconcilePrayer(
    WatchActionEnvelope action, {
    required bool complete,
  }) async {
    final prayerId = action.payload['prayerId']?.toString();
    if (!_isTrackedPrayer(prayerId)) {
      return _persistAck(
        _simpleAck(
          action,
          WatchAckResultType.failedValidation,
          notes: 'Invalid prayerId',
        ),
      );
    }
    if (DateTime.tryParse('${action.logicalDate}T00:00:00') == null) {
      return _persistAck(
        _simpleAck(
          action,
          WatchAckResultType.failedValidation,
          notes: 'Invalid logicalDate',
        ),
      );
    }

    final targetKey = '${action.logicalDate}|$prayerId';
    final ackService = _ref.read(watchSyncAckServiceProvider);
    final previous = ackService.prayerTargetState(targetKey);
    final currentState = _readPrayerStatus(action.logicalDate, prayerId!);
    final currentStatus = currentState.$1;
    if (currentStatus == (complete ? 'completed' : 'pending')) {
      final duplicateAck = _simpleAck(
        action,
        WatchAckResultType.ignoredDuplicate,
        notes: 'Prayer already in requested state',
      );
      WatchSyncDiagnostics.log('prayer_action_duplicate', <String, Object?>{
        'actionId': action.actionId,
        'prayerId': prayerId,
        'logicalDate': action.logicalDate,
      });
      return _persistAck(duplicateAck);
    }

    final previousAt = DateTime.tryParse(
      previous?['updatedAt']?.toString() ?? '',
    );
    if (previousAt != null && action.createdAt.isBefore(previousAt)) {
      final staleAck = _simpleAck(
        action,
        WatchAckResultType.ignoredStale,
        notes: 'Older than current phone state',
      );
      WatchSyncDiagnostics.log('prayer_action_stale', <String, Object?>{
        'actionId': action.actionId,
        'prayerId': prayerId,
        'logicalDate': action.logicalDate,
      });
      return _persistAck(staleAck);
    }

    _writePrayerStatus(
      dayKey: action.logicalDate,
      prayerId: prayerId,
      status: complete ? 'completed' : 'pending',
      completedAt: complete ? action.createdAt : null,
      timing: complete ? 'on_time' : currentState.$2,
    );
    if (action.logicalDate == LocalStore.todayKey()) {
      _ref
          .read(prayerControllerProvider.notifier)
          .onDayChanged(action.logicalDate, force: true);
    }
    if (complete) {
      _ref
          .read(watchRewardReconciliationServiceProvider)
          .applyPrayerReward(
            prayerId: prayerId,
            logicalDate: action.logicalDate,
          );
    }
    WatchSyncDiagnostics.log('prayer_action_applied', <String, Object?>{
      'actionId': action.actionId,
      'prayerId': prayerId,
      'logicalDate': action.logicalDate,
      'complete': complete,
    });
    await ackService.persistPrayerTargetState(targetKey, <String, dynamic>{
      'status': complete ? 'completed' : 'pending',
      'timing': complete ? 'on_time' : currentState.$2,
      'updatedAt': action.createdAt.toIso8601String(),
      'source': action.deviceType == WatchDeviceType.appleWatch
          ? 'apple_watch'
          : 'wear_os',
    });
    final ack = _simpleAck(
      action,
      previous == null
          ? WatchAckResultType.applied
          : WatchAckResultType.conflictResolved,
    );
    return _persistAck(ack);
  }

  Future<WatchSyncAck> _reconcilePrayerStatusUpdate(
    WatchActionEnvelope action,
  ) async {
    final prayerId = action.payload['prayerId']?.toString();
    final status = action.payload['status']?.toString();
    final timing = action.payload['timing']?.toString();
    if (!_isTrackedPrayer(prayerId)) {
      return _persistAck(
        _simpleAck(
          action,
          WatchAckResultType.failedValidation,
          notes: 'Invalid prayerId',
        ),
      );
    }
    if (status != 'pending' && status != 'completed' && status != 'missed') {
      return _persistAck(
        _simpleAck(
          action,
          WatchAckResultType.failedValidation,
          notes: 'Invalid prayer status',
        ),
      );
    }
    if (DateTime.tryParse('${action.logicalDate}T00:00:00') == null) {
      return _persistAck(
        _simpleAck(
          action,
          WatchAckResultType.failedValidation,
          notes: 'Invalid logicalDate',
        ),
      );
    }

    final targetKey = '${action.logicalDate}|$prayerId';
    final ackService = _ref.read(watchSyncAckServiceProvider);
    final previous = ackService.prayerTargetState(targetKey);
    final currentState = _readPrayerStatus(action.logicalDate, prayerId!);
    if (currentState.$1 == status && currentState.$2 == timing) {
      WatchSyncDiagnostics.log('prayer_action_duplicate', <String, Object?>{
        'actionId': action.actionId,
        'prayerId': prayerId,
        'logicalDate': action.logicalDate,
      });
      return _persistAck(
        _simpleAck(
          action,
          WatchAckResultType.ignoredDuplicate,
          notes: 'Prayer already in requested state',
        ),
      );
    }

    final previousAt = DateTime.tryParse(
      previous?['updatedAt']?.toString() ?? '',
    );
    if (previousAt != null && action.createdAt.isBefore(previousAt)) {
      WatchSyncDiagnostics.log('prayer_action_stale', <String, Object?>{
        'actionId': action.actionId,
        'prayerId': prayerId,
        'logicalDate': action.logicalDate,
      });
      return _persistAck(
        _simpleAck(
          action,
          WatchAckResultType.ignoredStale,
          notes: 'Older than current phone state',
        ),
      );
    }

    _writePrayerStatus(
      dayKey: action.logicalDate,
      prayerId: prayerId,
      status: status!,
      completedAt: status == 'completed' ? action.createdAt : null,
      timing: timing,
    );
    if (action.logicalDate == LocalStore.todayKey()) {
      _ref
          .read(prayerControllerProvider.notifier)
          .onDayChanged(action.logicalDate, force: true);
    }
    if (status == 'completed') {
      _ref
          .read(watchRewardReconciliationServiceProvider)
          .applyPrayerReward(
            prayerId: prayerId,
            logicalDate: action.logicalDate,
          );
    }
    WatchSyncDiagnostics.log('prayer_action_applied', <String, Object?>{
      'actionId': action.actionId,
      'prayerId': prayerId,
      'logicalDate': action.logicalDate,
      'status': status,
      'timing': timing,
    });
    await ackService.persistPrayerTargetState(targetKey, <String, dynamic>{
      'status': status,
      'timing': timing,
      'updatedAt': action.createdAt.toIso8601String(),
      'source': action.deviceType == WatchDeviceType.appleWatch
          ? 'apple_watch'
          : 'wear_os',
    });
    final ack = _simpleAck(
      action,
      previous == null
          ? WatchAckResultType.applied
          : WatchAckResultType.conflictResolved,
    );
    return _persistAck(ack);
  }

  Future<WatchSyncAck> _reconcileDhikrStarted(
    WatchActionEnvelope action,
  ) async {
    final sessionId = action.payload['sessionId']?.toString();
    if (sessionId == null || sessionId.isEmpty) {
      return _persistAck(
        _simpleAck(
          action,
          WatchAckResultType.failedValidation,
          notes: 'Missing sessionId',
        ),
      );
    }
    final mode = action.payload['mode']?.toString() ?? 'free';
    final targetCount = _payloadInt(action.payload, 'targetCount');
    await _persistDhikrSession(<String, dynamic>{
      'sessionId': sessionId,
      'logicalDate': action.logicalDate,
      'mode': mode,
      'targetCount': targetCount,
      'currentCount': 0,
      'startedAt': action.createdAt.toIso8601String(),
      'updatedAt': action.createdAt.toIso8601String(),
      'completed': false,
      'rewardApplied': false,
    });
    _writeDhikrStoreCurrentCount(
      currentCount: 0,
      target: targetCount ?? _targetFromMode(mode),
    );
    return _persistAck(_simpleAck(action, WatchAckResultType.applied));
  }

  Future<WatchSyncAck> _reconcileDhikrIncrement(
    WatchActionEnvelope action,
  ) async {
    final sessionId = action.payload['sessionId']?.toString();
    if (sessionId == null || sessionId.isEmpty) {
      return _persistAck(
        _simpleAck(
          action,
          WatchAckResultType.failedValidation,
          notes: 'Missing sessionId',
        ),
      );
    }
    final ackService = _ref.read(watchSyncAckServiceProvider);
    final session = Map<String, dynamic>.from(
      ackService.dhikrSession(sessionId) ??
          <String, dynamic>{
            'sessionId': sessionId,
            'logicalDate': action.logicalDate,
            'mode': action.payload['mode']?.toString() ?? 'free',
            'targetCount': _payloadInt(action.payload, 'targetCount'),
            'currentCount': 0,
            'startedAt': action.createdAt.toIso8601String(),
            'updatedAt': action.createdAt.toIso8601String(),
            'completed': false,
            'rewardApplied': false,
          },
    );
    final storedCount = (session['currentCount'] as num?)?.toInt() ?? 0;
    final incomingCount = _payloadInt(action.payload, 'count');
    final amount = _payloadInt(action.payload, 'amount') ?? 1;
    final nextCount = incomingCount ?? storedCount + amount;
    final delta = incomingCount != null
        ? (incomingCount - storedCount)
        : amount;
    if (delta <= 0 || session['completed'] == true) {
      WatchSyncDiagnostics.log('dhikr_increment_duplicate', <String, Object?>{
        'actionId': action.actionId,
        'sessionId': sessionId,
      });
      return _persistAck(
        _simpleAck(
          action,
          WatchAckResultType.ignoredDuplicate,
          notes: 'Increment already processed',
        ),
      );
    }

    session['currentCount'] = nextCount;
    session['updatedAt'] = action.createdAt.toIso8601String();
    await _persistDhikrSession(session);
    _writeDhikrStoreCurrentCount(
      currentCount: nextCount,
      target:
          (session['targetCount'] as num?)?.toInt() ??
          _targetFromMode(session['mode']?.toString() ?? 'free'),
    );
    if ((session['mode']?.toString() ?? 'free') == 'free') {
      _ref
          .read(watchRewardReconciliationServiceProvider)
          .applyDhikrReward(
            sessionId: sessionId,
            mode: 'free',
            countDelta: delta,
            targetCount: 0,
            timestamp: action.createdAt,
          );
    }
    WatchSyncDiagnostics.log('dhikr_increment_applied', <String, Object?>{
      'actionId': action.actionId,
      'sessionId': sessionId,
      'count': nextCount,
      'delta': delta,
    });
    return _persistAck(_simpleAck(action, WatchAckResultType.applied));
  }

  Future<WatchSyncAck> _reconcileDhikrReset(WatchActionEnvelope action) async {
    final mode = action.payload['mode']?.toString() ?? 'free';
    _writeDhikrStoreCurrentCount(
      currentCount: 0,
      target: _targetFromMode(mode),
    );
    final sessionId = action.payload['sessionId']?.toString();
    if (sessionId != null && sessionId.isNotEmpty) {
      final existing = _ref
          .read(watchSyncAckServiceProvider)
          .dhikrSession(sessionId);
      if (existing != null) {
        await _persistDhikrSession({
          ...existing,
          'currentCount': 0,
          'updatedAt': action.createdAt.toIso8601String(),
        });
      }
    }
    return _persistAck(_simpleAck(action, WatchAckResultType.applied));
  }

  Future<WatchSyncAck> _reconcileDhikrCompleted(
    WatchActionEnvelope action,
  ) async {
    final sessionId = action.payload['sessionId']?.toString();
    if (sessionId == null || sessionId.isEmpty) {
      return _persistAck(
        _simpleAck(
          action,
          WatchAckResultType.failedValidation,
          notes: 'Missing sessionId',
        ),
      );
    }
    final ackService = _ref.read(watchSyncAckServiceProvider);
    final session = Map<String, dynamic>.from(
      ackService.dhikrSession(sessionId) ??
          <String, dynamic>{
            'sessionId': sessionId,
            'logicalDate': action.logicalDate,
            'mode': action.payload['mode']?.toString() ?? 'free',
            'targetCount': _payloadInt(action.payload, 'targetCount'),
            'currentCount': _payloadInt(action.payload, 'count') ?? 0,
            'startedAt':
                action.payload['startedAt']?.toString() ??
                action.createdAt.toIso8601String(),
            'updatedAt': action.createdAt.toIso8601String(),
            'completed': false,
            'rewardApplied': false,
          },
    );
    if (session['completed'] == true) {
      WatchSyncDiagnostics.log('dhikr_session_duplicate', <String, Object?>{
        'actionId': action.actionId,
        'sessionId': sessionId,
      });
      return _persistAck(
        _simpleAck(
          action,
          WatchAckResultType.ignoredDuplicate,
          notes: 'Session already completed',
        ),
      );
    }
    final mode = session['mode']?.toString() ?? 'free';
    final targetCount =
        (session['targetCount'] as num?)?.toInt() ?? _targetFromMode(mode);
    final count =
        _payloadInt(action.payload, 'count') ??
        (session['currentCount'] as num?)?.toInt() ??
        0;
    session['completed'] = true;
    session['currentCount'] = count;
    session['updatedAt'] = action.createdAt.toIso8601String();

    var rewardApplied = session['rewardApplied'] == true;
    if (!rewardApplied && mode != 'free') {
      _ref
          .read(watchRewardReconciliationServiceProvider)
          .applyDhikrReward(
            sessionId: sessionId,
            mode: mode,
            countDelta: count,
            targetCount: targetCount,
            timestamp: action.createdAt,
          );
      rewardApplied = true;
      WatchSyncDiagnostics.log('reward_applied', <String, Object?>{
        'actionId': action.actionId,
        'sessionId': sessionId,
        'mode': mode,
      });
    }
    session['rewardApplied'] = rewardApplied;
    await _persistDhikrSession(session);
    _appendCompletedDhikrSession(
      sessionId: sessionId,
      mode: mode,
      count: count,
      target: targetCount,
      startedAt:
          DateTime.tryParse(session['startedAt']?.toString() ?? '') ??
          action.createdAt,
      finishedAt: action.createdAt,
    );
    return _persistAck(_simpleAck(action, WatchAckResultType.applied));
  }

  WatchSyncAck _simpleAck(
    WatchActionEnvelope action,
    WatchAckResultType resultType, {
    String? notes,
  }) {
    return WatchSyncAck(
      actionId: action.actionId,
      processed: resultType != WatchAckResultType.failedValidation,
      processedAt: DateTime.now(),
      resultType: resultType,
      notes: notes,
    );
  }

  Future<WatchSyncAck> _persistAck(WatchSyncAck ack) async {
    await _ref.read(watchSyncAckServiceProvider).persistAck(ack);
    return ack;
  }

  Future<void> _persistDhikrSession(Map<String, dynamic> session) async {
    await _ref
        .read(watchSyncAckServiceProvider)
        .persistDhikrSession(session['sessionId'].toString(), session);
    if (session['completed'] != true) {
      await _ref
          .read(watchSyncAckServiceProvider)
          .persistDhikrSession('__active__', session);
    }
  }

  (String, String?) _readPrayerStatus(String dayKey, String prayerId) {
    final prayer = PrayerName.values
        .where((item) => item.name == prayerId)
        .firstOrNull;
    if (prayer == null) return ('pending', null);
    final row = _ref
        .read(prayerLogRepositoryProvider)
        .readDayEntries(dayKey)[prayer];
    final status = switch (row?.status) {
      PrayerStatus.completed => 'completed',
      PrayerStatus.missed => 'missed',
      _ => 'pending',
    };
    return (status, row?.timing?.name);
  }

  void _writePrayerStatus({
    required String dayKey,
    required String prayerId,
    required String status,
    required DateTime? completedAt,
    required String? timing,
  }) {
    final prayer = PrayerName.values
        .where((item) => item.name == prayerId)
        .firstOrNull;
    if (prayer == null) return;
    final repository = _ref.read(prayerLogRepositoryProvider);
    final next = Map<PrayerName, PrayerLogDayEntry>.from(
      repository.readDayEntries(dayKey),
    );
    final previous = next[prayer];
    next[prayer] = PrayerLogDayEntry(
      status: switch (status) {
        'completed' => PrayerStatus.completed,
        'missed' => PrayerStatus.missed,
        _ => PrayerStatus.pending,
      },
      completedAtIso: status == 'completed'
          ? completedAt?.toIso8601String()
          : null,
      timing: PrayerOfferTiming.values
          .where((item) => item.name == timing)
          .firstOrNull,
      place: previous?.place,
      notes: previous?.notes,
    );
    repository.saveDayEntries(dayKey, next);
  }

  void _writeDhikrStoreCurrentCount({
    required int currentCount,
    required int target,
  }) {
    final repository = _ref.read(dhikrRepositoryProvider);
    final existing = repository.load();
    repository.saveState(
      selectedPresetId: existing.selectedPresetId,
      target: target,
      currentCount: currentCount,
    );
    _ref.read(dhikrControllerProvider.notifier).reloadFromStorage();
  }

  void _appendCompletedDhikrSession({
    required String sessionId,
    required String mode,
    required int count,
    required int target,
    required DateTime startedAt,
    required DateTime finishedAt,
  }) {
    final repository = _ref.read(dhikrRepositoryProvider);
    final existing = repository.load();
    final sessions = <DhikrSession>[
      DhikrSession(
        phraseLabel: _phraseLabelForMode(mode),
        count: count,
        target: target,
        startedAt: startedAt,
        finishedAt: finishedAt,
      ),
      ...existing.recentSessions.where(
        (session) =>
            session.startedAt != startedAt ||
            session.finishedAt != finishedAt ||
            session.count != count ||
            session.target != target ||
            session.phraseLabel != _phraseLabelForMode(mode),
      ),
    ].take(30).toList(growable: false);
    repository.saveState(
      selectedPresetId: existing.selectedPresetId,
      target: target,
      currentCount: 0,
    );
    repository.replaceRecentSessions(sessions);
    _ref.read(dhikrControllerProvider.notifier).reloadFromStorage();
  }

  int _targetFromMode(String mode) {
    switch (mode) {
      case 'preset_33':
        return 33;
      case 'preset_34':
        return 34;
      case 'preset_99':
        return 99;
      default:
        return 100;
    }
  }

  String _phraseLabelForMode(String mode) {
    switch (mode) {
      case 'preset_33':
        return 'SubhanAllah';
      case 'preset_34':
        return 'Allahu Akbar';
      case 'preset_99':
        return 'SubhanAllah';
      case 'auto_subhan_allah':
        return 'SubhanAllah';
      case 'auto_alhamdulillah':
        return 'Alhamdulillah';
      case 'auto_allahu_akbar':
        return 'Allahu Akbar';
      case 'auto_astaghfirullah':
        return 'Astaghfirullah';
      default:
        return 'Dhikr';
    }
  }

  int? _payloadInt(Map<String, dynamic> payload, String key) {
    final value = payload[key];
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  bool _isTrackedPrayer(String? prayerId) =>
      prayerId == 'fajr' ||
      prayerId == 'dhuhr' ||
      prayerId == 'asr' ||
      prayerId == 'maghrib' ||
      prayerId == 'isha';
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

class WatchActionIngestionService {
  WatchActionIngestionService(this._ref);

  final Ref _ref;

  Future<WatchActionResponse> ingest(WatchActionEnvelope action) async {
    final ack = await _ref
        .read(watchActionReconcilerProvider)
        .reconcile(action);
    final snapshot = ack.resultType == WatchAckResultType.failedValidation
        ? _fallbackSnapshot()
        : _safeRebuildSnapshot();
    final finalAck = WatchSyncAck(
      actionId: ack.actionId,
      processed: ack.processed,
      processedAt: ack.processedAt,
      resultType: ack.resultType,
      resultingSnapshotId: snapshot.snapshotId,
      notes: ack.notes,
    );
    await _ref.read(watchSyncAckServiceProvider).persistAck(finalAck);
    WatchSyncDiagnostics.log('snapshot_returned', <String, Object?>{
      'actionId': action.actionId,
      'snapshotId': snapshot.snapshotId,
      'resultType': finalAck.resultType.name,
    });
    return WatchActionResponse(ack: finalAck, snapshot: snapshot);
  }

  WatchDailySnapshot _safeRebuildSnapshot() {
    try {
      return _ref.read(watchSummaryRefreshServiceProvider).rebuildSnapshot();
    } catch (_) {
      return _fallbackSnapshot();
    }
  }

  WatchDailySnapshot _fallbackSnapshot() {
    final now = DateTime.now();
    return WatchDailySnapshot(
      schemaVersion: _watchSnapshotSchemaVersion,
      snapshotId: 'watch_snapshot_fallback_${now.microsecondsSinceEpoch}',
      generatedAt: now,
      date: LocalStore.todayKey(now),
      timezone: now.timeZoneName,
      nextPrayerId: null,
      nextPrayerTime: null,
      currentPrayerId: null,
      completedPrayerCount: 0,
      totalPrayerCount: 5,
      dhikrTodayCount: 0,
      xpToday: 0,
      oceanDropsToday: 0,
      spiritualPrompt: null,
      streakDays: 0,
      currentLevel: 1,
      growthStageKey: 'spring',
      prayers: const [],
      activeDhikrSession: null,
      lastSyncAt: now,
      sourceVersion: _watchSyncSourceVersion,
    );
  }
}

class AppleWatchBridgeAdapter {
  AppleWatchBridgeAdapter(this._ref);

  final Ref _ref;

  Map<String, dynamic> buildDailySnapshotPayload() {
    return _ref.read(watchDailySnapshotBuilderProvider).build().toJson();
  }

  Map<String, dynamic> buildSettingsPayload() {
    return _ref.read(watchSettingsSnapshotBuilderProvider).build().toJson();
  }

  Future<Map<String, dynamic>> ingestActionPayload(
    Map<String, dynamic> payload,
  ) async {
    final envelope = WatchActionEnvelope.fromJson(payload);
    if (envelope == null) {
      return WatchActionResponse(
        ack: WatchSyncAck(
          actionId: payload['actionId']?.toString() ?? 'unknown',
          processed: false,
          processedAt: DateTime.now(),
          resultType: WatchAckResultType.failedValidation,
          notes: 'Malformed watch action payload',
        ),
        snapshot: _ref.read(watchDailySnapshotBuilderProvider).build(),
      ).toJson();
    }
    final response = await _ref
        .read(watchActionIngestionServiceProvider)
        .ingest(envelope);
    return response.toJson();
  }
}

class WearOsBridgeAdapter {
  WearOsBridgeAdapter(this._ref);

  final Ref _ref;

  Map<String, dynamic> buildDailySnapshotPayload() {
    return _ref.read(watchDailySnapshotBuilderProvider).build().toJson();
  }

  Map<String, dynamic> buildSettingsPayload() {
    return _ref.read(watchSettingsSnapshotBuilderProvider).build().toJson();
  }

  Future<Map<String, dynamic>> ingestActionPayload(
    Map<String, dynamic> payload,
  ) async {
    final envelope = WatchActionEnvelope.fromJson(payload);
    if (envelope == null) {
      return WatchActionResponse(
        ack: WatchSyncAck(
          actionId: payload['actionId']?.toString() ?? 'unknown',
          processed: false,
          processedAt: DateTime.now(),
          resultType: WatchAckResultType.failedValidation,
          notes: 'Malformed watch action payload',
        ),
        snapshot: _ref.read(watchDailySnapshotBuilderProvider).build(),
      ).toJson();
    }
    final response = await _ref
        .read(watchActionIngestionServiceProvider)
        .ingest(envelope);
    return response.toJson();
  }
}

final watchSyncAckServiceProvider = Provider<WatchSyncAckService>((ref) {
  return WatchSyncAckService(ref.watch(localStoreProvider));
});

final watchDailySnapshotBuilderProvider = Provider<WatchDailySnapshotBuilder>((
  ref,
) {
  return WatchDailySnapshotBuilder(ref);
});

final watchSettingsSnapshotBuilderProvider =
    Provider<WatchSettingsSnapshotBuilder>((ref) {
      return WatchSettingsSnapshotBuilder(ref);
    });

final watchRewardReconciliationServiceProvider =
    Provider<WatchRewardReconciliationService>((ref) {
      return WatchRewardReconciliationService(ref);
    });

final watchSummaryRefreshServiceProvider = Provider<WatchSummaryRefreshService>(
  (ref) {
    return WatchSummaryRefreshService(ref);
  },
);

final watchActionReconcilerProvider = Provider<WatchActionReconciler>((ref) {
  return WatchActionReconciler(ref);
});

final watchActionIngestionServiceProvider =
    Provider<WatchActionIngestionService>((ref) {
      return WatchActionIngestionService(ref);
    });

final appleWatchBridgeAdapterProvider = Provider<AppleWatchBridgeAdapter>((
  ref,
) {
  return AppleWatchBridgeAdapter(ref);
});

final wearOsBridgeAdapterProvider = Provider<WearOsBridgeAdapter>((ref) {
  return WearOsBridgeAdapter(ref);
});
