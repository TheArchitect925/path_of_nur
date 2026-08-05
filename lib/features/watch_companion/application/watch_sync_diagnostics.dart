import 'package:flutter/foundation.dart';

class WatchSyncDiagnostics {
  static void log(String category, Map<String, Object?> fields) {
    if (!kDebugMode) return;
    final payload = fields.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join(' ');
    debugPrint('[watch_sync] $category $payload');
  }
}
