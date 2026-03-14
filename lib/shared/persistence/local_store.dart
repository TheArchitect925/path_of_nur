import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in main().');
});

final localStoreProvider = Provider<LocalStore>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalStore(prefs);
});

class LocalStore {
  const LocalStore(this._prefs);

  final SharedPreferences _prefs;

  static String todayKey([DateTime? now]) {
    final date = now ?? DateTime.now();
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String? getString(String key) => _prefs.getString(key);

  Future<bool> setString(String key, String value) => _prefs.setString(key, value);

  bool? getBool(String key) => _prefs.getBool(key);

  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  int? getInt(String key) => _prefs.getInt(key);

  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  Future<bool> remove(String key) => _prefs.remove(key);

  Map<String, dynamic>? getJsonMap(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) {
      return decoded.map((k, v) => MapEntry(k.toString(), v));
    }
    return null;
  }

  Future<bool> setJsonMap(String key, Map<String, dynamic> value) {
    return _prefs.setString(key, jsonEncode(value));
  }

  List<dynamic>? getJsonList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    final decoded = jsonDecode(raw);
    return decoded is List ? decoded : null;
  }

  Future<bool> setJsonList(String key, List<dynamic> value) {
    return _prefs.setString(key, jsonEncode(value));
  }

  Map<String, dynamic> dumpAll() {
    final values = <String, dynamic>{};
    for (final key in _prefs.getKeys()) {
      values[key] = _prefs.get(key);
    }
    return values;
  }

  Future<void> removeMany(Iterable<String> keys) async {
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }

  Future<void> restoreAll(
    Map<String, dynamic> values, {
    Iterable<String> replaceKeys = const [],
  }) async {
    if (replaceKeys.isNotEmpty) {
      await removeMany(replaceKeys);
    }
    for (final entry in values.entries) {
      final value = entry.value;
      if (value is String) {
        await _prefs.setString(entry.key, value);
      } else if (value is bool) {
        await _prefs.setBool(entry.key, value);
      } else if (value is int) {
        await _prefs.setInt(entry.key, value);
      } else if (value is double) {
        await _prefs.setDouble(entry.key, value);
      } else if (value is List) {
        await _prefs.setStringList(
          entry.key,
          value.map((item) => item.toString()).toList(),
        );
      }
    }
  }
}
