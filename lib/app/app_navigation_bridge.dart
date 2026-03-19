import 'dart:io';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/navigation/platform_route_dispatcher.dart';
import 'app_router.dart';
import 'routes/router_deep_links.dart';

class AppNavigationBridge {
  AppNavigationBridge(this._router);

  static const MethodChannel _channel = MethodChannel('path_of_nur/navigation');

  final GoRouter _router;
  bool _initialized = false;
  StreamSubscription<String>? _routeSubscription;

  Future<void> bootstrap() async {
    if (!Platform.isIOS || _initialized) return;
    _initialized = true;
    _routeSubscription = PlatformRouteDispatcher.stream.listen(_openRoute);
    _channel.setMethodCallHandler((call) async {
      if (call.method != 'openRoute') return;
      final route = call.arguments?.toString();
      if (route == null || route.isEmpty) return;
      _openRoute(route);
    });
    try {
      final pending = await _channel.invokeMethod<String>('getPendingRoute');
      if (pending != null && pending.isNotEmpty) {
        _openRoute(pending);
      }
    } catch (_) {
      // Ignore native bridge failures.
    }
  }

  void dispose() {
    _routeSubscription?.cancel();
    _routeSubscription = null;
  }

  void _openRoute(String rawRoute) {
    final route = _resolveRoute(rawRoute);
    if (route == null || route.isEmpty) return;
    _router.go(route);
  }

  String? _resolveRoute(String rawRoute) {
    final candidate = rawRoute.trim();
    if (candidate.isEmpty) return null;
    final uri = Uri.tryParse(candidate);
    if (uri != null && uri.hasScheme) {
      return mapAppDeepLink(uri);
    }
    return candidate;
  }
}

final appNavigationBridgeBootstrapProvider = Provider<void>((ref) {
  final bridge = AppNavigationBridge(ref.read(appRouterProvider));
  Future<void>.microtask(bridge.bootstrap);
  ref.onDispose(bridge.dispose);
});
