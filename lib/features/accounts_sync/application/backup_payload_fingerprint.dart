import 'dart:convert';

import 'package:crypto/crypto.dart';

String backupPayloadFingerprint(String payload) {
  final decoded = jsonDecode(payload);
  if (decoded is! Map) {
    return sha256.convert(utf8.encode(payload)).toString();
  }
  final normalized = _normalizeMap(
    decoded.map((key, value) => MapEntry(key.toString(), value)),
  );
  return sha256.convert(utf8.encode(jsonEncode(normalized))).toString();
}

Map<String, dynamic> _normalizeMap(Map<String, dynamic> source) {
  final normalized = <String, dynamic>{};
  for (final entry in source.entries) {
    if (entry.key == 'exportedAt') {
      continue;
    }
    if (entry.key == 'metadata' && entry.value is Map) {
      final metadata = Map<String, dynamic>.from(
        (entry.value as Map).map((key, value) => MapEntry(key.toString(), value)),
      )
        ..remove('exportedAtIso')
        ..remove('lastBackupAtIso');
      normalized[entry.key] = _normalizeValue(metadata);
      continue;
    }
    normalized[entry.key] = _normalizeValue(entry.value);
  }
  return normalized;
}

dynamic _normalizeValue(dynamic value) {
  if (value is Map) {
    return _normalizeMap(
      value.map((key, innerValue) => MapEntry(key.toString(), innerValue)),
    );
  }
  if (value is List) {
    return value.map(_normalizeValue).toList(growable: false);
  }
  return value;
}
