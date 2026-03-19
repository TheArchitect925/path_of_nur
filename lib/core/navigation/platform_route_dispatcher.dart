import 'dart:async';

final class PlatformRouteDispatcher {
  PlatformRouteDispatcher._();

  static final StreamController<String> _controller =
      StreamController<String>.broadcast();

  static Stream<String> get stream => _controller.stream;

  static void dispatch(String route) {
    final normalized = route.trim();
    if (normalized.isEmpty) return;
    _controller.add(normalized);
  }
}
