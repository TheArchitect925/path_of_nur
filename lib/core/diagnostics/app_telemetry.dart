import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTelemetry {
  AppTelemetry._();

  static SharedPreferences? _prefs;
  static const String _crashKey = 'diagnostics.crash_log_v1';
  static const String _analyticsKey = 'diagnostics.analytics_log_v1';

  static void bootstrap(SharedPreferences prefs) {
    _prefs = prefs;
    _installCrashHandlers();
    logEvent(
      'app_bootstrap',
      metadata: {'mode': kReleaseMode ? 'release' : 'debug'},
    );
  }

  static void logScreen(String name) {
    logEvent('screen_view', metadata: {'screen': name});
  }

  static void logError(
    String name, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> metadata = const {},
  }) {
    logEvent(
      name,
      metadata: <String, Object?>{
        ...metadata,
        if (error != null) 'error': error.toString(),
        if (stackTrace != null) 'stack': stackTrace.toString(),
      },
    );
  }

  static void logEvent(
    String name, {
    Map<String, Object?> metadata = const {},
  }) {
    final prefs = _prefs;
    if (prefs == null) return;
    final entries = prefs.getStringList(_analyticsKey) ?? const <String>[];
    final payload = jsonEncode({
      'name': name,
      'atIso': DateTime.now().toIso8601String(),
      'metadata': metadata,
    });
    final next = <String>[payload, ...entries].take(120).toList();
    prefs.setStringList(_analyticsKey, next);
  }

  static List<String> getCrashLog() {
    return _prefs?.getStringList(_crashKey) ?? const <String>[];
  }

  static void _installCrashHandlers() {
    final previousOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      previousOnError?.call(details);
      _recordCrash(
        type: 'flutter_error',
        message: details.exceptionAsString(),
        stack: details.stack,
      );
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      _recordCrash(
        type: 'platform_error',
        message: error.toString(),
        stack: stack,
      );
      return false;
    };
  }

  static void _recordCrash({
    required String type,
    required String message,
    StackTrace? stack,
  }) {
    final prefs = _prefs;
    if (prefs == null) return;
    final current = prefs.getStringList(_crashKey) ?? const <String>[];
    final payload = jsonEncode({
      'type': type,
      'message': message,
      'stack': stack?.toString(),
      'atIso': DateTime.now().toIso8601String(),
    });
    final next = <String>[payload, ...current].take(40).toList();
    prefs.setStringList(_crashKey, next);
  }
}

class TelemetryNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    final name = route.settings.name ?? route.settings.arguments?.toString();
    if (name != null && name.trim().isNotEmpty) {
      AppTelemetry.logScreen(name);
    }
  }
}
