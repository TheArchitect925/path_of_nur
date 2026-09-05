import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/diagnostics/app_telemetry.dart';
import '../../../core/prayer/prayer_preferences.dart';
import '../../../shared/application/daily_clock_provider.dart';
import '../../journey/application/journey_progression_provider.dart';
import '../../journey/xp/application/journey_xp_providers.dart';
import '../../profile/application/profile_settings_provider.dart';
import '../../worship/application/dhikr_controller.dart';
import '../../worship/application/prayer_controller.dart';
import 'watch_quran_audio_contract.dart';
import 'watch_sync_contract.dart';

const _appleWatchSyncChannel = MethodChannel('path_of_nur/watch_sync');

class AppleWatchRuntimeBridge with WidgetsBindingObserver {
  AppleWatchRuntimeBridge(this._ref);

  final Ref _ref;
  bool _started = false;
  bool _publishScheduled = false;

  void start() {
    if (_started) return;
    _started = true;
    WidgetsBinding.instance.addObserver(this);
    _appleWatchSyncChannel.setMethodCallHandler(_handleNativeCall);
    unawaited(_publishAll());
    unawaited(_drainPendingActions());
  }

  void dispose() {
    if (!_started) return;
    WidgetsBinding.instance.removeObserver(this);
    _appleWatchSyncChannel.setMethodCallHandler(null);
    _started = false;
  }

  void schedulePublish() {
    if (!_started || _publishScheduled) return;
    _publishScheduled = true;
    Future<void>.microtask(() async {
      _publishScheduled = false;
      await _publishAll();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_publishAll());
      unawaited(_drainPendingActions());
    }
  }

  Future<dynamic> _handleNativeCall(MethodCall call) async {
    switch (call.method) {
      case 'requestLatestWatchSnapshot':
        final payload = _buildPayload();
        await _publishAll();
        return payload;
      case 'ingestWatchAction':
        final raw = (call.arguments as Map?)?.cast<Object?, Object?>();
        if (raw == null) {
          return <String, dynamic>{
            'ack': <String, dynamic>{
              'actionId': 'missing',
              'processed': false,
              'processedAt': DateTime.now().toIso8601String(),
              'resultType': 'failed_validation',
              'notes': 'Missing watch action payload',
            },
            'snapshot': _ref
                .read(watchDailySnapshotBuilderProvider)
                .build()
                .toJson(),
          };
        }
        return _ref
            .read(appleWatchBridgeAdapterProvider)
            .ingestActionPayload(
              raw.map((key, value) => MapEntry(key.toString(), value)),
            );
      case 'requestQuranPlaybackSnapshot':
        return _ref
            .read(appleWatchQuranBridgeAdapterProvider)
            .buildPlaybackPayload();
      case 'applyQuranPlaybackCommand':
        return _ref
            .read(appleWatchQuranBridgeAdapterProvider)
            .applyCommand(call.arguments as String? ?? 'resumeLast');
      default:
        throw PlatformException(
          code: 'unimplemented',
          message: 'Unknown watch sync method ${call.method}',
        );
    }
  }

  Future<void> _publishAll() async {
    try {
      final payload = _buildPayload();
      await _appleWatchSyncChannel.invokeMethod<void>(
        'updateWatchSnapshot',
        payload['snapshot'],
      );
      await _appleWatchSyncChannel.invokeMethod<void>(
        'updateWatchSettings',
        payload['settings'],
      );
    } catch (error, stackTrace) {
      AppTelemetry.logEvent(
        'watch_sync_publish_failed',
        metadata: <String, Object?>{
          'error': error.toString(),
          'stack': stackTrace.toString(),
        },
      );
    }
  }

  Map<String, Map<String, dynamic>> _buildPayload() {
    return <String, Map<String, dynamic>>{
      'snapshot': _ref.read(watchDailySnapshotBuilderProvider).build().toJson(),
      'settings': _ref
          .read(watchSettingsSnapshotBuilderProvider)
          .build()
          .toJson(),
    };
  }

  Future<void> _drainPendingActions() async {
    try {
      final rawActions = await _appleWatchSyncChannel
          .invokeMethod<List<dynamic>>('fetchPendingWatchActions');
      if (rawActions == null || rawActions.isEmpty) {
        return;
      }
      final processedIds = <String>[];
      for (final raw in rawActions) {
        if (raw is! Map) continue;
        final payload = raw.map(
          (key, value) => MapEntry(key.toString(), value),
        );
        final actionId = payload['actionId']?.toString();
        if (actionId == null || actionId.isEmpty) {
          continue;
        }
        await _ref
            .read(appleWatchBridgeAdapterProvider)
            .ingestActionPayload(payload);
        processedIds.add(actionId);
      }
      if (processedIds.isNotEmpty) {
        await _appleWatchSyncChannel.invokeMethod<void>(
          'acknowledgePendingWatchActions',
          <String, dynamic>{'actionIds': processedIds},
        );
        await _publishAll();
      }
    } catch (error, stackTrace) {
      AppTelemetry.logEvent(
        'watch_sync_drain_failed',
        metadata: <String, Object?>{
          'error': error.toString(),
          'stack': stackTrace.toString(),
        },
      );
    }
  }
}

final appleWatchRuntimeBridgeBootstrapProvider = Provider<void>((ref) {
  final bridge = AppleWatchRuntimeBridge(ref);
  bridge.start();
  ref.onDispose(bridge.dispose);

  ref.listen(
    prayerControllerProvider,
    (previous, next) => bridge.schedulePublish(),
  );
  ref.listen(
    dhikrControllerProvider,
    (previous, next) => bridge.schedulePublish(),
  );
  ref.listen(
    journeyProgressProvider,
    (previous, next) => bridge.schedulePublish(),
  );
  ref.listen(
    journeyXpSummaryProvider,
    (previous, next) => bridge.schedulePublish(),
  );
  ref.listen(
    prayerSettingsProvider,
    (previous, next) => bridge.schedulePublish(),
  );
  ref.listen(
    profileSettingsProvider,
    (previous, next) => bridge.schedulePublish(),
  );
  ref.listen(
    prayerScheduleContextProvider.select(
      (value) => '${value.currentPrayerId ?? ''}|${value.nextPrayerId ?? ''}',
    ),
    (previous, next) => bridge.schedulePublish(),
  );
  ref.listen(dailyKeyProvider, (previous, next) => bridge.schedulePublish());
});
