import 'dart:math' as math;

import 'package:adhan/adhan.dart' as adhan;
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

import '../../../core/diagnostics/app_telemetry.dart';
import '../../../core/prayer/prayer_preferences.dart';
import '../../../features/journey/application/growth_seasonal.dart';
import '../../../features/ocean/application/ocean_drops_provider.dart';
import '../../../shared/application/daily_clock_provider.dart';
import '../../../shared/persistence/local_store.dart';
import '../data/celestial_verse_catalog.dart';
import '../domain/celestial_models.dart';

final celestialCalculationServiceProvider = Provider<CelestialCalculationService>(
  (ref) => const CelestialCalculationService(),
);

final celestialVerseSelectorProvider = Provider<CelestialVerseSelector>(
  (ref) => const CelestialVerseSelector(celestialVerseCatalog),
);

final celestialWidgetBridgeProvider = Provider<CelestialWidgetBridge>(
  (ref) => const CelestialWidgetBridge(),
);

final celestialObservationRepositoryProvider = Provider<CelestialObservationRepository>(
  (ref) => CelestialObservationRepository(ref.watch(localStoreProvider)),
);

final celestialHintRepositoryProvider = Provider<CelestialHintRepository>(
  (ref) => CelestialHintRepository(ref.watch(localStoreProvider)),
);

final celestialActionServiceProvider = Provider<CelestialActionService>(
  (ref) => CelestialActionService(
    store: ref.watch(localStoreProvider),
    oceanDrops: ref.watch(oceanDropsProvider.notifier),
    observations: ref.watch(celestialObservationRepositoryProvider),
    hints: ref.watch(celestialHintRepositoryProvider),
  ),
);

final celestialCompassHeadingProvider = StreamProvider<double?>((ref) {
  return FlutterCompass.events?.map((event) {
        final heading = event.heading;
        if (heading == null || heading.isNaN) return null;
        return (heading % 360 + 360) % 360;
      }) ??
      const Stream<double?>.empty();
});

final celestialObservationsProvider =
    StateNotifierProvider<CelestialObservationsController, List<CelestialObservation>>((ref) {
      return CelestialObservationsController(
        ref.watch(celestialObservationRepositoryProvider),
      );
    });

final celestialHintDismissedProvider = StateProvider<bool>((ref) {
  return ref.watch(celestialHintRepositoryProvider).isHomeHintDismissed();
});

final celestialSnapshotProvider = FutureProvider<CelestialSnapshot>((ref) async {
  final prefs = ref.watch(prayerSettingsProvider).preferences;
  final location = ref.watch(prayerLocationProvider);
  final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
  final displayLabel =
      await ref.watch(prayerLocationDisplayLabelProvider.future).onError((_, _) {
        return prefs.location;
      });
  final selector = ref.watch(celestialVerseSelectorProvider);
  final calculator = ref.watch(celestialCalculationServiceProvider);
  final snapshot = calculator.buildSnapshot(
    timestamp: now,
    latitude: location.latitude,
    longitude: location.longitude,
    locationLabel: displayLabel,
    timezoneLabel: now.timeZoneName,
    verseSelector: selector,
  );
  await ref.read(celestialWidgetBridgeProvider).writeSnapshot(snapshot);
  AppTelemetry.logEvent(
    'celestial_widget_payload_updated',
    metadata: <String, Object?>{
      'location': snapshot.locationLabel,
      'state': snapshot.solarData.state.name,
    },
  );
  return snapshot;
});

class CelestialObservationsController extends StateNotifier<List<CelestialObservation>> {
  CelestialObservationsController(this._repository) : super(_repository.load());

  final CelestialObservationRepository _repository;

  Future<void> reload() async {
    state = _repository.load();
  }

  Future<void> toggleFavorite(String id) async {
    final next = <CelestialObservation>[];
    for (final item in state) {
      next.add(item.id == id ? item.copyWith(isFavorite: !item.isFavorite) : item);
    }
    state = next;
    await _repository.saveAll(next);
  }

  Future<void> remove(String id) async {
    final next = state.where((item) => item.id != id).toList(growable: false);
    state = next;
    await _repository.saveAll(next);
  }
}

class CelestialHintRepository {
  const CelestialHintRepository(this._store);

  final LocalStore _store;
  static const _homeHintKey = 'celestial.homeHintDismissed';

  bool isHomeHintDismissed() => _store.getBool(_homeHintKey) ?? false;

  Future<void> dismissHomeHint() => _store.setBool(_homeHintKey, true);
}

class CelestialObservationRepository {
  const CelestialObservationRepository(this._store);

  final LocalStore _store;
  static const _key = 'celestial.observations.v1';

  List<CelestialObservation> load() {
    final raw = _store.getJsonList(_key);
    if (raw == null) return const <CelestialObservation>[];
    return raw
        .map(CelestialObservation.fromJson)
        .whereType<CelestialObservation>()
        .toList(growable: false);
  }

  Future<void> save(CelestialObservation observation) async {
    final existing = load().where((item) => item.id != observation.id).toList(growable: true);
    existing.insert(0, observation);
    await saveAll(existing.take(120).toList(growable: false));
  }

  Future<void> saveAll(List<CelestialObservation> items) {
    return _store.setJsonList(
      _key,
      items.map((item) => item.toJson()).toList(growable: false),
    );
  }
}

class CelestialActionService {
  const CelestialActionService({
    required LocalStore store,
    required OceanDropService oceanDrops,
    required CelestialObservationRepository observations,
    required CelestialHintRepository hints,
  }) : _store = store,
       _oceanDrops = oceanDrops,
       _observations = observations,
       _hints = hints;

  final LocalStore _store;
  final OceanDropService _oceanDrops;
  final CelestialObservationRepository _observations;
  final CelestialHintRepository _hints;

  Future<void> markCardOpened() async {
    final key = 'celestial.cardOpened.${LocalStore.todayKey()}';
    if (_store.getBool(key) ?? false) return;
    await _store.setBool(key, true);
    _oceanDrops.awardDrop(
      actionType: oceanActionCelestialCardOpened,
      sourceModule: oceanSourceCelestial,
      referenceId: LocalStore.todayKey(),
    );
    AppTelemetry.logEvent('celestial_card_viewed');
  }

  Future<void> markExplorerOpened() async {
    final key = 'celestial.explorerOpened.${LocalStore.todayKey()}';
    if (!(_store.getBool(key) ?? false)) {
      await _store.setBool(key, true);
      _oceanDrops.awardDrop(
        actionType: oceanActionSkyExplorerOpened,
        sourceModule: oceanSourceCelestial,
        referenceId: LocalStore.todayKey(),
      );
    }
    AppTelemetry.logEvent('sky_explorer_opened');
  }

  Future<void> markVerseOpened(CelestialVerse verse) async {
    _oceanDrops.awardDrop(
      actionType: oceanActionCelestialVerseOpened,
      sourceModule: oceanSourceCelestial,
      referenceId: '${LocalStore.todayKey()}-${verse.id}',
    );
    AppTelemetry.logEvent(
      'celestial_verse_opened',
      metadata: <String, Object?>{'verse': verse.ayahReference},
    );
  }

  Future<void> saveObservation({
    required CelestialSnapshot snapshot,
    required CelestialVerse verse,
    required String note,
    double? headingDegrees,
    String? photoPath,
  }) async {
    final observation = CelestialObservation(
      id: 'obs_${DateTime.now().microsecondsSinceEpoch}',
      timestamp: snapshot.timestamp,
      locationLabel: snapshot.locationLabel,
      moonPhaseName: snapshot.lunarData.phaseName,
      skyState: snapshot.solarData.state,
      verseReference: verse.ayahReference,
      verseTranslation: verse.translation,
      reflectionNote: note.trim(),
      latitude: snapshot.latitude,
      longitude: snapshot.longitude,
      headingDegrees: headingDegrees,
      photoPath: photoPath,
    );
    await _observations.save(observation);
    _oceanDrops.awardDrop(
      actionType: oceanActionCelestialObservationSaved,
      sourceModule: oceanSourceCelestial,
      referenceId: observation.id,
    );
    AppTelemetry.logEvent(
      'celestial_observation_saved',
      metadata: <String, Object?>{'phase': snapshot.lunarData.phaseName},
    );
  }

  Future<void> dismissHomeHint() => _hints.dismissHomeHint();
}

class CelestialWidgetBridge {
  const CelestialWidgetBridge();

  static const _androidName = 'PathOfNurCelestialWidget';
  static const _iosName = 'PathOfNurCelestialWidget';

  Future<void> writeSnapshot(CelestialSnapshot snapshot) async {
    final payload = CelestialWidgetPayload(
      locationLabel: snapshot.locationLabel,
      dateLabel: DateFormat.yMMMMd().format(snapshot.timestamp),
      sunriseLabel: _formatTime(snapshot.solarData.sunrise),
      sunsetLabel: _formatTime(snapshot.solarData.sunset),
      moonriseLabel: _formatOptionalTime(snapshot.lunarData.moonrise),
      moonsetLabel: _formatOptionalTime(snapshot.lunarData.moonset),
      moonPhaseLabel:
          '${snapshot.lunarData.phaseName} • ${snapshot.lunarData.illuminationPercent}%',
      progressLabel: _progressLabel(snapshot),
      reflectionLine: snapshot.verseOfMoment.shortReflection,
    );
    final json = payload.toJson();
    for (final entry in json.entries) {
      await HomeWidget.saveWidgetData<String>(entry.key, '${entry.value}');
    }
    await HomeWidget.updateWidget(
      androidName: _androidName,
      iOSName: _iosName,
    );
  }

  static String _progressLabel(CelestialSnapshot snapshot) {
    final pct = (snapshot.solarData.progress * 100).round();
    switch (snapshot.solarData.state) {
      case CelestialSkyState.day:
        return '$pct% through daylight';
      case CelestialSkyState.night:
        return '$pct% through the night';
      case CelestialSkyState.dawn:
        return 'Dawn is unfolding';
      case CelestialSkyState.dusk:
        return 'Dusk is settling';
    }
  }
}

class CelestialVerseSelector {
  const CelestialVerseSelector(this._catalog);

  final List<CelestialVerse> _catalog;

  CelestialVerse selectForSnapshot({
    required CelestialSkyState skyState,
    required LunarData lunarData,
    required DateTime timestamp,
  }) {
    final target = switch (skyState) {
      CelestialSkyState.day => CelestialObjectType.sun,
      CelestialSkyState.dawn || CelestialSkyState.dusk => CelestialObjectType.signs,
      CelestialSkyState.night => lunarData.illuminationPercent >= 35
          ? CelestialObjectType.moon
          : CelestialObjectType.stars,
    };
    final eligible = _catalog.where((item) => item.objectType == target).toList(growable: false);
    if (eligible.isEmpty) {
      return _catalog[timestamp.day % _catalog.length];
    }
    eligible.sort((a, b) => b.priority.compareTo(a.priority));
    return eligible[timestamp.day % eligible.length];
  }
}

class CelestialCalculationService {
  const CelestialCalculationService();

  static const double _synodicMonthDays = 29.53058867;
  static const Duration _moonTravelTime = Duration(hours: 12, minutes: 24);
  static final DateTime _knownNewMoon = DateTime.utc(2000, 1, 6, 18, 14);

  CelestialSnapshot buildSnapshot({
    required DateTime timestamp,
    required double latitude,
    required double longitude,
    required String locationLabel,
    required String timezoneLabel,
    required CelestialVerseSelector verseSelector,
  }) {
    final params = adhan.CalculationMethod.muslim_world_league.getParameters();
    final coordinates = adhan.Coordinates(latitude, longitude);
    final prayerTimes = adhan.PrayerTimes(
      coordinates,
      adhan.DateComponents.from(timestamp),
      params,
    );

    final solar = _buildSolarData(
      timestamp: timestamp,
      sunrise: prayerTimes.sunrise,
      sunset: prayerTimes.maghrib,
      solarNoon: prayerTimes.dhuhr,
    );
    final lunar = _buildLunarData(
      timestamp: timestamp,
      sunrise: prayerTimes.sunrise,
      sunset: prayerTimes.maghrib,
    );
    final nextEvent = _nextEvent(
      timestamp: timestamp,
      solar: solar,
      lunar: lunar,
    );
    final verse = verseSelector.selectForSnapshot(
      skyState: solar.state,
      lunarData: lunar,
      timestamp: timestamp,
    );

    return CelestialSnapshot(
      timestamp: timestamp,
      locationLabel: locationLabel,
      latitude: latitude,
      longitude: longitude,
      timezoneLabel: timezoneLabel,
      hijriDate: growthToHijriDate(timestamp),
      solarData: solar,
      lunarData: lunar,
      nextEvent: nextEvent,
      verseOfMoment: verse,
    );
  }

  CelestialDirectionalReading buildDirectionalReading({
    required CelestialSnapshot snapshot,
    required double? headingDegrees,
  }) {
    final solarReading = _directionForSun(
      timestamp: snapshot.timestamp,
      latitude: snapshot.latitude,
      solar: snapshot.solarData,
      headingDegrees: headingDegrees,
    );
    final lunarReading = _directionForMoon(
      snapshot: snapshot,
      headingDegrees: headingDegrees,
    );
    return CelestialDirectionalReading(
      headingDegrees: headingDegrees,
      sun: solarReading,
      moon: lunarReading,
    );
  }

  SolarData _buildSolarData({
    required DateTime timestamp,
    required DateTime sunrise,
    required DateTime sunset,
    required DateTime solarNoon,
  }) {
    const twilight = Duration(minutes: 45);
    final dawnStart = sunrise.subtract(twilight);
    final duskEnd = sunset.add(twilight);
    final isDay = !timestamp.isBefore(sunrise) && timestamp.isBefore(sunset);
    final state = !timestamp.isBefore(dawnStart) && timestamp.isBefore(sunrise)
        ? CelestialSkyState.dawn
        : isDay
            ? CelestialSkyState.day
            : !timestamp.isBefore(sunset) && timestamp.isBefore(duskEnd)
                ? CelestialSkyState.dusk
                : CelestialSkyState.night;

    final progress = switch (state) {
      CelestialSkyState.day => _fraction(sunrise, sunset, timestamp),
      CelestialSkyState.night => _fraction(sunset, sunrise.add(const Duration(days: 1)), timestamp.isBefore(sunrise) ? timestamp.add(const Duration(days: 1)) : timestamp),
      CelestialSkyState.dawn => _fraction(dawnStart, sunrise, timestamp),
      CelestialSkyState.dusk => _fraction(sunset, duskEnd, timestamp),
    };

    return SolarData(
      sunrise: sunrise,
      sunset: sunset,
      solarNoon: solarNoon,
      state: state,
      progress: progress,
      isAboveHorizon: isDay,
    );
  }

  LunarData _buildLunarData({
    required DateTime timestamp,
    required DateTime sunrise,
    required DateTime sunset,
  }) {
    final daysSinceKnown =
        timestamp.toUtc().difference(_knownNewMoon).inMinutes / 1440;
    final age = ((daysSinceKnown % _synodicMonthDays) + _synodicMonthDays) % _synodicMonthDays;
    final phaseValue = age / _synodicMonthDays;
    final illumination = (((1 - math.cos(phaseValue * math.pi * 2)) / 2) * 100).round();

    final riseOffsetHours = phaseValue * 24;
    var moonrise = sunrise.add(Duration(minutes: (riseOffsetHours * 60).round()));
    if (moonrise.day != sunrise.day) {
      moonrise = DateTime(
        sunrise.year,
        sunrise.month,
        sunrise.day,
        moonrise.hour,
        moonrise.minute,
      );
    }
    final moonset = moonrise.add(_moonTravelTime);
    final isAboveHorizon = !timestamp.isBefore(moonrise) && timestamp.isBefore(moonset);

    return LunarData(
      moonrise: moonrise,
      moonset: moonset,
      phaseName: _moonPhaseName(age),
      phaseValue: phaseValue,
      illuminationPercent: illumination,
      ageInCycleDays: age,
      isAboveHorizon: isAboveHorizon,
      riseSetApproximate: true,
    );
  }

  CelestialEvent _nextEvent({
    required DateTime timestamp,
    required SolarData solar,
    required LunarData lunar,
  }) {
    final candidates = <CelestialEvent>[
      CelestialEvent(
        type: CelestialEventType.sunrise,
        time: _normalizeFutureEvent(timestamp, solar.sunrise),
        label: 'Sunrise',
        relativeDescription: _relativeTime(_normalizeFutureEvent(timestamp, solar.sunrise), timestamp),
      ),
      CelestialEvent(
        type: CelestialEventType.sunset,
        time: _normalizeFutureEvent(timestamp, solar.sunset),
        label: 'Sunset',
        relativeDescription: _relativeTime(_normalizeFutureEvent(timestamp, solar.sunset), timestamp),
      ),
      if (lunar.moonrise != null)
        CelestialEvent(
          type: CelestialEventType.moonrise,
          time: _normalizeFutureEvent(timestamp, lunar.moonrise!),
          label: 'Moonrise',
          relativeDescription: _relativeTime(_normalizeFutureEvent(timestamp, lunar.moonrise!), timestamp),
        ),
      if (lunar.moonset != null)
        CelestialEvent(
          type: CelestialEventType.moonset,
          time: _normalizeFutureEvent(timestamp, lunar.moonset!),
          label: 'Moonset',
          relativeDescription: _relativeTime(_normalizeFutureEvent(timestamp, lunar.moonset!), timestamp),
        ),
    ]..sort((a, b) => a.time.compareTo(b.time));

    return candidates.first;
  }

  CelestialDirectionMarker _directionForSun({
    required DateTime timestamp,
    required double latitude,
    required SolarData solar,
    required double? headingDegrees,
  }) {
    final dayOfYear = int.parse(DateFormat('D').format(timestamp));
    final declination = -23.44 * math.cos((2 * math.pi / 365) * (dayOfYear + 10));
    final middayAltitude = (90 - (latitude - declination).abs()).clamp(8, 85).toDouble();
    if (!solar.isAboveHorizon) {
      return CelestialDirectionMarker(
        label: 'Sun',
        status: solar.state == CelestialSkyState.dawn ? 'Near rise' : 'Below horizon',
        guidance: solar.state == CelestialSkyState.dawn
            ? 'Look toward the eastern horizon.'
            : 'The sun is below the horizon right now.',
        azimuthDegrees: solar.state == CelestialSkyState.night ? 90 : 270,
        altitudeDegrees: -8,
        relativeBearingDegrees: _relativeBearing(headingDegrees, solar.state == CelestialSkyState.night ? 90 : 270),
        isVisible: false,
      );
    }
    final azimuth = 90 + (solar.progress * 180);
    final altitude = math.sin(solar.progress * math.pi) * middayAltitude;
    return CelestialDirectionMarker(
      label: 'Sun',
      status: 'Visible',
      guidance: _guidanceForBearing(_relativeBearing(headingDegrees, azimuth), 'sun'),
      azimuthDegrees: azimuth,
      altitudeDegrees: altitude,
      relativeBearingDegrees: _relativeBearing(headingDegrees, azimuth),
      isVisible: true,
    );
  }

  CelestialDirectionMarker _directionForMoon({
    required CelestialSnapshot snapshot,
    required double? headingDegrees,
  }) {
    final moonrise = snapshot.lunarData.moonrise;
    final moonset = snapshot.lunarData.moonset;
    if (moonrise == null || moonset == null) {
      return CelestialDirectionMarker(
        label: 'Moon',
        status: 'Unavailable',
        guidance: 'Moonrise and moonset are approximate here and unavailable for this moment.',
        azimuthDegrees: 0,
        altitudeDegrees: -12,
        relativeBearingDegrees: null,
        isVisible: false,
      );
    }
    final moonProgress = snapshot.timestamp.isBefore(moonrise)
        ? 0.0
        : snapshot.timestamp.isAfter(moonset)
            ? 1.0
            : _fraction(moonrise, moonset, snapshot.timestamp);
    final azimuth = 90 + (moonProgress * 180);
    final altitude = snapshot.lunarData.isAboveHorizon
        ? math.sin(moonProgress * math.pi) * 55
        : -10.0;
    return CelestialDirectionMarker(
      label: 'Moon',
      status: snapshot.lunarData.isAboveHorizon ? 'Visible' : 'Below horizon',
      guidance: snapshot.lunarData.isAboveHorizon
          ? _guidanceForBearing(_relativeBearing(headingDegrees, azimuth), 'moon')
          : 'The moon is below the horizon right now.',
      azimuthDegrees: azimuth,
      altitudeDegrees: altitude,
      relativeBearingDegrees: _relativeBearing(headingDegrees, azimuth),
      isVisible: snapshot.lunarData.isAboveHorizon,
    );
  }

  static double _fraction(DateTime start, DateTime end, DateTime value) {
    final total = end.difference(start).inSeconds;
    if (total <= 0) return 0;
    final elapsed = value.difference(start).inSeconds.clamp(0, total);
    return (elapsed / total).clamp(0.0, 1.0).toDouble();
  }

  static DateTime _normalizeFutureEvent(DateTime now, DateTime event) {
    if (event.isAfter(now)) return event;
    return event.add(const Duration(days: 1));
  }

  static String _moonPhaseName(double age) {
    if (age < 1.5) return 'New moon';
    if (age < 6.5) return 'Waxing crescent';
    if (age < 8.5) return 'First quarter';
    if (age < 13.5) return 'Waxing gibbous';
    if (age < 16.5) return 'Full moon';
    if (age < 21.5) return 'Waning gibbous';
    if (age < 23.5) return 'Last quarter';
    if (age < 28.5) return 'Waning crescent';
    return 'New moon';
  }

  static String _relativeTime(DateTime target, DateTime now) {
    final diff = target.difference(now);
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60).abs();
    if (hours <= 0) {
      return 'in ${diff.inMinutes.abs()} min';
    }
    return 'in ${hours}h ${minutes}m';
  }

  static double? _relativeBearing(double? headingDegrees, double azimuthDegrees) {
    if (headingDegrees == null) return null;
    final delta = ((azimuthDegrees - headingDegrees + 540) % 360) - 180;
    return delta;
  }

  static String _guidanceForBearing(double? bearing, String label) {
    if (bearing == null) {
      return 'Compass unavailable. Approximate the $label direction from the horizon.';
    }
    final absBearing = bearing.abs();
    if (absBearing < 12) return 'Look straight ahead for the $label.';
    if (bearing < 0) return 'Turn about ${absBearing.round()}° left for the $label.';
    return 'Turn about ${absBearing.round()}° right for the $label.';
  }
}

class CelestialDirectionalReading {
  const CelestialDirectionalReading({
    required this.headingDegrees,
    required this.sun,
    required this.moon,
  });

  final double? headingDegrees;
  final CelestialDirectionMarker sun;
  final CelestialDirectionMarker moon;
}

class CelestialDirectionMarker {
  const CelestialDirectionMarker({
    required this.label,
    required this.status,
    required this.guidance,
    required this.azimuthDegrees,
    required this.altitudeDegrees,
    required this.relativeBearingDegrees,
    required this.isVisible,
  });

  final String label;
  final String status;
  final String guidance;
  final double azimuthDegrees;
  final double altitudeDegrees;
  final double? relativeBearingDegrees;
  final bool isVisible;
}

String _formatTime(DateTime value) => DateFormat.jm().format(value);

String _formatOptionalTime(DateTime? value) {
  if (value == null) return 'Unavailable';
  return DateFormat.jm().format(value);
}
