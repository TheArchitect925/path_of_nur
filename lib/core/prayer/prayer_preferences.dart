import 'dart:math' as math;

import 'package:adhan/adhan.dart' as adhan;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../shared/application/daily_clock_provider.dart';
import '../../shared/persistence/local_store.dart';

enum PrayerCalculationMethod {
  muslimWorldLeague,
  egyptian,
  isna,
  karachi,
  ummAlQura,
}

enum PrayerMadhab { shafii, hanafi, maliki, hanbali }

enum PrayerNotificationMode {
  none,
  notificationOnly,
  adhanWithSound,
  reminderBeforeQaza,
}

class PrayerPreferences {
  const PrayerPreferences({
    required this.location,
    required this.madhab,
    required this.calculationMethod,
  });

  final String location;
  final PrayerMadhab madhab;
  final PrayerCalculationMethod calculationMethod;

  PrayerPreferences copyWith({
    String? location,
    PrayerMadhab? madhab,
    PrayerCalculationMethod? calculationMethod,
  }) {
    return PrayerPreferences(
      location: location ?? this.location,
      madhab: madhab ?? this.madhab,
      calculationMethod: calculationMethod ?? this.calculationMethod,
    );
  }
}

class PrayerScheduleItem {
  const PrayerScheduleItem({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.category,
    required this.offerDateTime,
    required this.windowStartDateTime,
    required this.windowEndDateTime,
    required this.qazaDateTime,
    required this.totalRakats,
  });

  final String id;
  final String name;
  final String arabicName;
  final String category;
  final DateTime offerDateTime;
  final DateTime windowStartDateTime;
  final DateTime windowEndDateTime;
  final DateTime qazaDateTime;
  final int totalRakats;

  String get offerTime => _formatTime(offerDateTime);
  String get windowStart => _formatTime(windowStartDateTime);
  String get windowEnd => _formatTime(windowEndDateTime);
  String get qaza => _formatTime(qazaDateTime);
}

class PrayerScheduleContext {
  const PrayerScheduleContext({
    required this.items,
    required this.nextPrayerId,
    required this.currentPrayerId,
    required this.remainingToNext,
    required this.progressToNext,
  });

  final List<PrayerScheduleItem> items;
  final String? nextPrayerId;
  final String? currentPrayerId;
  final Duration remainingToNext;
  final double progressToNext;
}

class PrayerLocationState {
  const PrayerLocationState({
    required this.latitude,
    required this.longitude,
    required this.usingDeviceLocation,
  });

  final double latitude;
  final double longitude;
  final bool usingDeviceLocation;
}

class PrayerSettingsState {
  const PrayerSettingsState({
    required this.preferences,
    required this.notificationModes,
  });

  final PrayerPreferences preferences;
  final Map<String, PrayerNotificationMode> notificationModes;

  PrayerSettingsState copyWith({
    PrayerPreferences? preferences,
    Map<String, PrayerNotificationMode>? notificationModes,
  }) {
    return PrayerSettingsState(
      preferences: preferences ?? this.preferences,
      notificationModes: notificationModes ?? this.notificationModes,
    );
  }
}

class _CityMeta {
  const _CityMeta({
    required this.label,
    required this.latitude,
    required this.longitude,
  });

  final String label;
  final double latitude;
  final double longitude;
}

const _cityMeta = <String, _CityMeta>{
  'Toronto, Canada': _CityMeta(
    label: 'Toronto, Canada',
    latitude: 43.6532,
    longitude: -79.3832,
  ),
  'Dubai, UAE': _CityMeta(
    label: 'Dubai, UAE',
    latitude: 25.2048,
    longitude: 55.2708,
  ),
  'London, UK': _CityMeta(
    label: 'London, UK',
    latitude: 51.5072,
    longitude: -0.1276,
  ),
  'Istanbul, Turkey': _CityMeta(
    label: 'Istanbul, Turkey',
    latitude: 41.0082,
    longitude: 28.9784,
  ),
  'Riyadh, Saudi Arabia': _CityMeta(
    label: 'Riyadh, Saudi Arabia',
    latitude: 24.7136,
    longitude: 46.6753,
  ),
};

final Map<String, String> prayerMethodLabels = {
  'MWL': 'Muslim World League',
  'EGY': 'Egyptian General Authority',
  'ISNA': 'Islamic Society of North America',
  'KAR': 'University of Karachi',
  'QUR': 'Umm al-Qura University',
};

final Map<String, String> prayerMadhabLabels = {
  "Shafi'i": "Shafi'i",
  'Hanafi': 'Hanafi',
  'Maliki': 'Maliki',
  'Hanbali': 'Hanbali',
};

final Map<PrayerCalculationMethod, String> prayerMethodKey = {
  PrayerCalculationMethod.muslimWorldLeague: 'MWL',
  PrayerCalculationMethod.egyptian: 'EGY',
  PrayerCalculationMethod.isna: 'ISNA',
  PrayerCalculationMethod.karachi: 'KAR',
  PrayerCalculationMethod.ummAlQura: 'QUR',
};

final Map<PrayerMadhab, String> prayerMadhabKey = {
  PrayerMadhab.shafii: "Shafi'i",
  PrayerMadhab.hanafi: 'Hanafi',
  PrayerMadhab.maliki: 'Maliki',
  PrayerMadhab.hanbali: 'Hanbali',
};

final prayerSettingsProvider =
    StateNotifierProvider<PrayerSettingsController, PrayerSettingsState>((ref) {
      const defaults = PrayerPreferences(
        location: 'Toronto, Canada',
        madhab: PrayerMadhab.shafii,
        calculationMethod: PrayerCalculationMethod.muslimWorldLeague,
      );
      return PrayerSettingsController(
        defaults: defaults,
        store: ref.watch(localStoreProvider),
      );
    });

class PrayerSettingsController extends StateNotifier<PrayerSettingsState> {
  PrayerSettingsController({
    required PrayerPreferences defaults,
    required LocalStore store,
  }) : _store = store,
       super(
         PrayerSettingsState(
           preferences: defaults,
           notificationModes: {
             'fajr': PrayerNotificationMode.none,
             'dhuhr': PrayerNotificationMode.none,
             'asr': PrayerNotificationMode.none,
             'maghrib': PrayerNotificationMode.none,
             'isha': PrayerNotificationMode.none,
             'tahajjud': PrayerNotificationMode.none,
           },
         ),
       ) {
    _load(defaults);
  }

  final LocalStore _store;

  void updateLocation(String location) {
    state = state.copyWith(
      preferences: state.preferences.copyWith(location: location),
    );
    _save();
  }

  void updateMadhab(PrayerMadhab madhab) {
    state = state.copyWith(
      preferences: state.preferences.copyWith(madhab: madhab),
    );
    _save();
  }

  void updateMethod(PrayerCalculationMethod method) {
    state = state.copyWith(
      preferences: state.preferences.copyWith(calculationMethod: method),
    );
    _save();
  }

  void updateNotificationMode(String prayerId, PrayerNotificationMode mode) {
    final updated = Map<String, PrayerNotificationMode>.from(
      state.notificationModes,
    );
    updated[prayerId] = mode;
    state = state.copyWith(notificationModes: updated);
    _save();
  }

  void _load(PrayerPreferences defaults) {
    final data = _store.getJsonMap('settings.prayer');
    if (data == null) return;

    final location = data['location'] as String?;
    final madhabName = data['madhab'] as String?;
    final methodName = data['calculationMethod'] as String?;
    final notificationsRaw = data['notificationModes'];

    PrayerMadhab madhab = defaults.madhab;
    for (final item in PrayerMadhab.values) {
      if (item.name == madhabName) {
        madhab = item;
        break;
      }
    }

    PrayerCalculationMethod method = defaults.calculationMethod;
    for (final item in PrayerCalculationMethod.values) {
      if (item.name == methodName) {
        method = item;
        break;
      }
    }

    final restoredNotifications = Map<String, PrayerNotificationMode>.from(
      state.notificationModes,
    );
    if (notificationsRaw is Map) {
      for (final entry in notificationsRaw.entries) {
        final key = entry.key.toString();
        final valueName = entry.value?.toString();
        for (final mode in PrayerNotificationMode.values) {
          if (mode.name == valueName) {
            restoredNotifications[key] = mode;
            break;
          }
        }
      }
    }

    state = state.copyWith(
      preferences: PrayerPreferences(
        location: location ?? defaults.location,
        madhab: madhab,
        calculationMethod: method,
      ),
      notificationModes: restoredNotifications,
    );
  }

  void _save() {
    _store.setJsonMap('settings.prayer', {
      'location': state.preferences.location,
      'madhab': state.preferences.madhab.name,
      'calculationMethod': state.preferences.calculationMethod.name,
      'notificationModes': {
        for (final entry in state.notificationModes.entries)
          entry.key: entry.value.name,
      },
    });
  }
}

class PrayerLocationNotifier extends StateNotifier<PrayerLocationState> {
  PrayerLocationNotifier(this._store, this._preferences)
    : super(_fallbackForLocation(_preferences.location)) {
    _loadLastKnown();
    _refresh();
  }

  final LocalStore _store;
  final PrayerPreferences _preferences;

  static PrayerLocationState _fallbackForLocation(String location) {
    final fallback = _cityMeta[location] ?? _cityMeta.values.first;
    return PrayerLocationState(
      latitude: fallback.latitude,
      longitude: fallback.longitude,
      usingDeviceLocation: false,
    );
  }

  Future<void> _refresh() async {
    final status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      state = _fallbackForLocation(_preferences.location);
      return;
    }

    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      state = _fallbackForLocation(_preferences.location);
      return;
    }

    Position? pos;
    try {
      pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );
    } catch (_) {
      pos = await Geolocator.getLastKnownPosition();
    }

    if (pos == null) {
      state = _fallbackForLocation(_preferences.location);
      return;
    }

    state = PrayerLocationState(
      latitude: pos.latitude,
      longitude: pos.longitude,
      usingDeviceLocation: true,
    );
    _store.setJsonMap('settings.prayer.deviceCoordinates', {
      'lat': pos.latitude,
      'lng': pos.longitude,
    });
  }

  void _loadLastKnown() {
    final data = _store.getJsonMap('settings.prayer.deviceCoordinates');
    if (data == null) return;
    final lat = data['lat'];
    final lng = data['lng'];
    if (lat is num && lng is num) {
      state = PrayerLocationState(
        latitude: lat.toDouble(),
        longitude: lng.toDouble(),
        usingDeviceLocation: true,
      );
    }
  }
}

final prayerLocationProvider =
    StateNotifierProvider<PrayerLocationNotifier, PrayerLocationState>((ref) {
      final settings = ref.watch(prayerSettingsProvider).preferences;
      return PrayerLocationNotifier(ref.watch(localStoreProvider), settings);
    });

final availablePrayerLocationsProvider = Provider<List<String>>(
  (ref) => _cityMeta.keys.toList(),
);

final prayerScheduleProvider = Provider<List<PrayerScheduleItem>>((ref) {
  final settings = ref.watch(prayerSettingsProvider).preferences;
  final location = ref.watch(prayerLocationProvider);
  final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
  return buildPrayerScheduleForDate(
    date: now,
    latitude: location.latitude,
    longitude: location.longitude,
    settings: settings,
  );
});

final prayerScheduleContextProvider = Provider<PrayerScheduleContext>((ref) {
  final schedule = ref.watch(prayerScheduleProvider);
  final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
  if (schedule.isEmpty) {
    return const PrayerScheduleContext(
      items: [],
      nextPrayerId: null,
      currentPrayerId: null,
      remainingToNext: Duration.zero,
      progressToNext: 0,
    );
  }

  PrayerScheduleItem? current;
  PrayerScheduleItem? next;

  for (var i = 0; i < schedule.length; i += 1) {
    final item = schedule[i];
    if (!now.isBefore(item.windowStartDateTime) &&
        now.isBefore(item.windowEndDateTime)) {
      current = item;
      next = i + 1 < schedule.length ? schedule[i + 1] : null;
      break;
    }
    if (now.isBefore(item.windowStartDateTime)) {
      next = item;
      break;
    }
  }

  next ??= schedule.first;
  if (current == null && now.isAfter(schedule.last.windowEndDateTime)) {
    current = schedule.last;
  }

  final nextStart = next.windowStartDateTime;
  final prevAnchor =
      current?.windowStartDateTime ?? now.subtract(const Duration(hours: 1));
  final total = math.max(1, nextStart.difference(prevAnchor).inSeconds);
  final elapsed = now.difference(prevAnchor).inSeconds.clamp(0, total);
  final progress = (elapsed / total).clamp(0.0, 1.0).toDouble();

  return PrayerScheduleContext(
    items: schedule,
    nextPrayerId: next.id,
    currentPrayerId: current?.id,
    remainingToNext: nextStart.difference(now),
    progressToNext: progress,
  );
});

List<PrayerScheduleItem> buildPrayerScheduleForDate({
  required DateTime date,
  required double latitude,
  required double longitude,
  required PrayerPreferences settings,
}) {
  final coordinates = adhan.Coordinates(latitude, longitude);
  final params = _adhanMethod(settings.calculationMethod).getParameters();
  params.madhab = settings.madhab == PrayerMadhab.hanafi
      ? adhan.Madhab.hanafi
      : adhan.Madhab.shafi;

  final today = adhan.PrayerTimes(
    coordinates,
    adhan.DateComponents.from(date),
    params,
  );

  final tomorrow = adhan.PrayerTimes(
    coordinates,
    adhan.DateComponents.from(date.add(const Duration(days: 1))),
    params,
  );

  final tahajjudStart = today.isha.add(
    Duration(
      seconds: ((tomorrow.fajr.difference(today.isha).inSeconds) * 0.66)
          .round(),
    ),
  );

  return [
    PrayerScheduleItem(
      id: 'fajr',
      name: 'Fajr',
      arabicName: 'الفجر',
      category: 'Fardh',
      offerDateTime: today.fajr,
      windowStartDateTime: today.fajr,
      windowEndDateTime: today.sunrise,
      qazaDateTime: today.sunrise,
      totalRakats: 2,
    ),
    PrayerScheduleItem(
      id: 'dhuhr',
      name: 'Dhuhr',
      arabicName: 'الظهر',
      category: 'Fardh',
      offerDateTime: today.dhuhr,
      windowStartDateTime: today.dhuhr,
      windowEndDateTime: today.asr,
      qazaDateTime: today.asr,
      totalRakats: 4,
    ),
    PrayerScheduleItem(
      id: 'asr',
      name: 'Asr',
      arabicName: 'العصر',
      category: 'Fardh',
      offerDateTime: today.asr,
      windowStartDateTime: today.asr,
      windowEndDateTime: today.maghrib,
      qazaDateTime: today.maghrib,
      totalRakats: 4,
    ),
    PrayerScheduleItem(
      id: 'maghrib',
      name: 'Maghrib',
      arabicName: 'المغرب',
      category: 'Fardh',
      offerDateTime: today.maghrib,
      windowStartDateTime: today.maghrib,
      windowEndDateTime: today.isha,
      qazaDateTime: today.isha,
      totalRakats: 3,
    ),
    PrayerScheduleItem(
      id: 'isha',
      name: 'Isha',
      arabicName: 'العشاء',
      category: 'Fardh',
      offerDateTime: today.isha,
      windowStartDateTime: today.isha,
      windowEndDateTime: tahajjudStart,
      qazaDateTime: tahajjudStart,
      totalRakats: 4,
    ),
    PrayerScheduleItem(
      id: 'tahajjud',
      name: 'Tahajjud',
      arabicName: 'التهجد',
      category: 'Nafl',
      offerDateTime: tahajjudStart,
      windowStartDateTime: tahajjudStart,
      windowEndDateTime: tomorrow.fajr,
      qazaDateTime: tomorrow.fajr,
      totalRakats: 3,
    ),
  ];
}

String _formatTime(DateTime value) => DateFormat.jm().format(value);

adhan.CalculationMethod _adhanMethod(PrayerCalculationMethod method) {
  switch (method) {
    case PrayerCalculationMethod.muslimWorldLeague:
      return adhan.CalculationMethod.muslim_world_league;
    case PrayerCalculationMethod.egyptian:
      return adhan.CalculationMethod.egyptian;
    case PrayerCalculationMethod.isna:
      return adhan.CalculationMethod.north_america;
    case PrayerCalculationMethod.karachi:
      return adhan.CalculationMethod.karachi;
    case PrayerCalculationMethod.ummAlQura:
      return adhan.CalculationMethod.umm_al_qura;
  }
}
