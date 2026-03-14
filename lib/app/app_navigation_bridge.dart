import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app_router.dart';

class AppNavigationBridge {
  AppNavigationBridge(this._router);

  static const MethodChannel _channel = MethodChannel(
    'path_of_nur/navigation',
  );

  final GoRouter _router;
  bool _initialized = false;

  Future<void> bootstrap() async {
    if (!Platform.isIOS || _initialized) return;
    _initialized = true;
    _channel.setMethodCallHandler((call) async {
      if (call.method != 'openRoute') return;
      final route = call.arguments?.toString();
      if (route == null || route.isEmpty) return;
      _router.go(route);
    });
    try {
      final pending = await _channel.invokeMethod<String>('getPendingRoute');
      if (pending != null && pending.isNotEmpty) {
        _router.go(pending);
      }
    } catch (_) {
      // Ignore native bridge failures.
    }
  }
}

final appNavigationBridgeBootstrapProvider = Provider<void>((ref) {
  final bridge = AppNavigationBridge(ref.read(appRouterProvider));
  Future<void>.microtask(bridge.bootstrap);
});
