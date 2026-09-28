import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/prayer/prayer_preferences.dart';

/// Estimated door-to-masjid travel minutes for the Jumu'ah leave reminder.
///
/// Only runs in [JumuahLeaveReminderMode.locationEstimate] with a masjid
/// chosen: reads the device position while the app is in use, measures the
/// straight-line distance, and assumes unhurried city travel (~28 km/h)
/// plus parking-and-walking slack. Returns null when unavailable — callers
/// fall back to the stored fixed minutes.
final jumuahTravelEstimateMinutesProvider = FutureProvider<int?>((ref) async {
  final preferences = ref.watch(prayerSettingsProvider).preferences;
  if (preferences.jumuahLeaveReminderMode !=
      JumuahLeaveReminderMode.locationEstimate) {
    return null;
  }
  final lat = preferences.jumuahMosqueLatitude;
  final lng = preferences.jumuahMosqueLongitude;
  if (lat == null || lng == null) return null;
  try {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
        timeLimit: Duration(seconds: 8),
      ),
    );
    final meters = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      lat,
      lng,
    );
    const cityKmPerHour = 28.0;
    const parkingSlackMinutes = 7;
    final minutes = (meters / 1000 / cityKmPerHour * 60) + parkingSlackMinutes;
    return minutes.round().clamp(8, 120);
  } catch (_) {
    return null;
  }
});
