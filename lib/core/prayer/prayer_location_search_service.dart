import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/persistence/local_store.dart';

class PrayerLocationSearchResult {
  const PrayerLocationSearchResult({
    required this.label,
    required this.latitude,
    required this.longitude,
  });

  final String label;
  final double latitude;
  final double longitude;
}

class PrayerLocationPickerSelection {
  const PrayerLocationPickerSelection.device({required this.label})
    : latitude = null,
      longitude = null,
      useDeviceLocation = true;

  const PrayerLocationPickerSelection.manual({
    required this.label,
    required this.latitude,
    required this.longitude,
  }) : useDeviceLocation = false;

  final String label;
  final double? latitude;
  final double? longitude;
  final bool useDeviceLocation;
}

class PrayerRecentLocation {
  const PrayerRecentLocation({
    required this.label,
    required this.latitude,
    required this.longitude,
  });

  final String label;
  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() => {
    'label': label,
    'latitude': latitude,
    'longitude': longitude,
  };

  static PrayerRecentLocation? fromJson(dynamic raw) {
    if (raw is! Map) return null;
    final label = raw['label']?.toString().trim();
    final latitude = raw['latitude'];
    final longitude = raw['longitude'];
    if (label == null ||
        label.isEmpty ||
        latitude is! num ||
        longitude is! num) {
      return null;
    }
    return PrayerRecentLocation(
      label: label,
      latitude: latitude.toDouble(),
      longitude: longitude.toDouble(),
    );
  }
}

class PrayerLocationSearchService {
  static const _recentLocationsKey = 'settings.prayer.recentLocations';
  static const _host = 'nominatim.openstreetmap.org';
  static const _userAgent = 'PathOfNur/1.1 (manual prayer location search)';

  Future<List<PrayerLocationSearchResult>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) return const [];

    final uri = Uri.https(_host, '/search', {
      'q': trimmed,
      'format': 'jsonv2',
      'limit': '10',
      'addressdetails': '1',
    });
    final payload = await _getJsonList(uri);
    return payload
        .map(_parseSearchResult)
        .whereType<PrayerLocationSearchResult>()
        .toList(growable: false);
  }

  Future<String?> reverseLookup({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.https(_host, '/reverse', {
      'lat': '$latitude',
      'lon': '$longitude',
      'format': 'jsonv2',
      'zoom': '10',
    });
    final payload = await _getJsonMap(uri);
    final address = payload['address'];
    if (address is Map) {
      final city = address['city'] ?? address['town'] ?? address['village'];
      final state = address['state'];
      final country = address['country'];
      final parts = [city, state, country]
          .whereType<String>()
          .map((part) => part.trim())
          .where((part) => part.isNotEmpty)
          .toList(growable: false);
      if (parts.isNotEmpty) {
        return parts.take(3).join(', ');
      }
    }
    final displayName = payload['display_name'];
    if (displayName is String && displayName.trim().isNotEmpty) {
      return displayName.split(',').take(3).join(',').trim();
    }
    return null;
  }

  PrayerLocationSearchResult? _parseSearchResult(dynamic item) {
    if (item is! Map) return null;
    final lat = double.tryParse('${item['lat'] ?? ''}');
    final lon = double.tryParse('${item['lon'] ?? ''}');
    final displayName = item['display_name']?.toString().trim();
    if (lat == null ||
        lon == null ||
        displayName == null ||
        displayName.isEmpty) {
      return null;
    }
    return PrayerLocationSearchResult(
      label: displayName.split(',').take(3).join(',').trim(),
      latitude: lat,
      longitude: lon,
    );
  }

  Future<List<dynamic>> _getJsonList(Uri uri) async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(HttpHeaders.userAgentHeader, _userAgent);
      final response = await request.close();
      if (response.statusCode != 200) {
        throw HttpException(
          'Location search failed with ${response.statusCode}',
          uri: uri,
        );
      }
      final body = await response.transform(utf8.decoder).join();
      final decoded = jsonDecode(body);
      if (decoded is List<dynamic>) return decoded;
      return const [];
    } finally {
      client.close(force: true);
    }
  }

  Future<Map<String, dynamic>> _getJsonMap(Uri uri) async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(HttpHeaders.userAgentHeader, _userAgent);
      final response = await request.close();
      if (response.statusCode != 200) {
        throw HttpException(
          'Reverse geocoding failed with ${response.statusCode}',
          uri: uri,
        );
      }
      final body = await response.transform(utf8.decoder).join();
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) {
        return decoded.map((key, value) => MapEntry('$key', value));
      }
      return const {};
    } finally {
      client.close(force: true);
    }
  }
}

final prayerLocationSearchServiceProvider =
    Provider<PrayerLocationSearchService>(
      (ref) => PrayerLocationSearchService(),
    );

final prayerRecentLocationsProvider = Provider<List<PrayerRecentLocation>>((
  ref,
) {
  final store = ref.watch(localStoreProvider);
  final raw = store.getJsonList(
    PrayerLocationSearchService._recentLocationsKey,
  );
  if (raw == null) return const [];
  return raw
      .map(PrayerRecentLocation.fromJson)
      .whereType<PrayerRecentLocation>()
      .toList(growable: false);
});

class PrayerRecentLocationsStore {
  const PrayerRecentLocationsStore(this._store);

  final LocalStore _store;

  Future<void> save(PrayerRecentLocation recent) async {
    final existing = load()
        .where((item) => item.label.toLowerCase() != recent.label.toLowerCase())
        .toList(growable: true);
    existing.insert(0, recent);
    await _store.setJsonList(
      PrayerLocationSearchService._recentLocationsKey,
      existing.take(6).map((item) => item.toJson()).toList(growable: false),
    );
  }

  List<PrayerRecentLocation> load() {
    final raw = _store.getJsonList(
      PrayerLocationSearchService._recentLocationsKey,
    );
    if (raw == null) return const [];
    return raw
        .map(PrayerRecentLocation.fromJson)
        .whereType<PrayerRecentLocation>()
        .toList(growable: false);
  }
}

final prayerRecentLocationsStoreProvider = Provider<PrayerRecentLocationsStore>(
  (ref) => PrayerRecentLocationsStore(ref.watch(localStoreProvider)),
);
