import '../../../features/journey/application/growth_seasonal.dart';

enum CelestialObjectType {
  sun,
  moon,
  stars,
  night,
  day,
  heavens,
  orbit,
  phases,
  signs,
}

enum CelestialSkyState { dawn, day, dusk, night }

enum CelestialEventType { sunrise, sunset, moonrise, moonset }

enum CelestialUsageContext { homeCard, overview, explore, journal }

class SolarData {
  const SolarData({
    required this.sunrise,
    required this.sunset,
    required this.solarNoon,
    required this.state,
    required this.progress,
    required this.isAboveHorizon,
  });

  final DateTime sunrise;
  final DateTime sunset;
  final DateTime solarNoon;
  final CelestialSkyState state;
  final double progress;
  final bool isAboveHorizon;
}

class LunarData {
  const LunarData({
    required this.moonrise,
    required this.moonset,
    required this.phaseName,
    required this.phaseValue,
    required this.illuminationPercent,
    required this.ageInCycleDays,
    required this.isAboveHorizon,
    required this.riseSetApproximate,
  });

  final DateTime? moonrise;
  final DateTime? moonset;
  final String phaseName;
  final double phaseValue;
  final int illuminationPercent;
  final double ageInCycleDays;
  final bool isAboveHorizon;
  final bool riseSetApproximate;
}

class CelestialEvent {
  const CelestialEvent({
    required this.type,
    required this.time,
    required this.label,
    required this.relativeDescription,
  });

  final CelestialEventType type;
  final DateTime time;
  final String label;
  final String relativeDescription;
}

class CelestialVerse {
  const CelestialVerse({
    required this.id,
    required this.objectType,
    required this.ayahReference,
    required this.translation,
    required this.shortReflection,
    required this.tags,
    required this.priority,
    required this.usageContexts,
    this.arabicText,
  });

  final String id;
  final CelestialObjectType objectType;
  final String ayahReference;
  final String? arabicText;
  final String translation;
  final String shortReflection;
  final List<String> tags;
  final int priority;
  final List<CelestialUsageContext> usageContexts;
}

class CelestialSnapshot {
  const CelestialSnapshot({
    required this.timestamp,
    required this.locationLabel,
    required this.latitude,
    required this.longitude,
    required this.timezoneLabel,
    required this.hijriDate,
    required this.solarData,
    required this.lunarData,
    required this.nextEvent,
    required this.verseOfMoment,
  });

  final DateTime timestamp;
  final String locationLabel;
  final double latitude;
  final double longitude;
  final String timezoneLabel;
  final GrowthHijriDate hijriDate;
  final SolarData solarData;
  final LunarData lunarData;
  final CelestialEvent nextEvent;
  final CelestialVerse verseOfMoment;
}

class CelestialObservation {
  const CelestialObservation({
    required this.id,
    required this.timestamp,
    required this.locationLabel,
    required this.moonPhaseName,
    required this.skyState,
    required this.verseReference,
    required this.verseTranslation,
    required this.reflectionNote,
    this.latitude,
    this.longitude,
    this.headingDegrees,
    this.photoPath,
    this.isFavorite = false,
  });

  final String id;
  final DateTime timestamp;
  final String locationLabel;
  final String moonPhaseName;
  final CelestialSkyState skyState;
  final String verseReference;
  final String verseTranslation;
  final String reflectionNote;
  final double? latitude;
  final double? longitude;
  final double? headingDegrees;
  final String? photoPath;
  final bool isFavorite;

  CelestialObservation copyWith({bool? isFavorite}) {
    return CelestialObservation(
      id: id,
      timestamp: timestamp,
      locationLabel: locationLabel,
      moonPhaseName: moonPhaseName,
      skyState: skyState,
      verseReference: verseReference,
      verseTranslation: verseTranslation,
      reflectionNote: reflectionNote,
      latitude: latitude,
      longitude: longitude,
      headingDegrees: headingDegrees,
      photoPath: photoPath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'locationLabel': locationLabel,
    'moonPhaseName': moonPhaseName,
    'skyState': skyState.name,
    'verseReference': verseReference,
    'verseTranslation': verseTranslation,
    'reflectionNote': reflectionNote,
    'latitude': latitude,
    'longitude': longitude,
    'headingDegrees': headingDegrees,
    'photoPath': photoPath,
    'isFavorite': isFavorite,
  };

  static CelestialObservation? fromJson(dynamic raw) {
    if (raw is! Map) return null;
    final id = raw['id']?.toString();
    final timestamp = DateTime.tryParse(raw['timestamp']?.toString() ?? '');
    final locationLabel = raw['locationLabel']?.toString();
    final moonPhaseName = raw['moonPhaseName']?.toString();
    final verseReference = raw['verseReference']?.toString();
    final verseTranslation = raw['verseTranslation']?.toString();
    final reflectionNote = raw['reflectionNote']?.toString();
    final skyStateName = raw['skyState']?.toString();
    if (id == null ||
        timestamp == null ||
        locationLabel == null ||
        moonPhaseName == null ||
        verseReference == null ||
        verseTranslation == null ||
        reflectionNote == null ||
        skyStateName == null) {
      return null;
    }

    CelestialSkyState? skyState;
    for (final item in CelestialSkyState.values) {
      if (item.name == skyStateName) {
        skyState = item;
        break;
      }
    }
    if (skyState == null) return null;

    return CelestialObservation(
      id: id,
      timestamp: timestamp,
      locationLabel: locationLabel,
      moonPhaseName: moonPhaseName,
      skyState: skyState,
      verseReference: verseReference,
      verseTranslation: verseTranslation,
      reflectionNote: reflectionNote,
      latitude: (raw['latitude'] as num?)?.toDouble(),
      longitude: (raw['longitude'] as num?)?.toDouble(),
      headingDegrees: (raw['headingDegrees'] as num?)?.toDouble(),
      photoPath: raw['photoPath']?.toString(),
      isFavorite: raw['isFavorite'] as bool? ?? false,
    );
  }
}

class CelestialWidgetPayload {
  const CelestialWidgetPayload({
    required this.locationLabel,
    required this.dateLabel,
    required this.sunriseLabel,
    required this.sunsetLabel,
    required this.moonriseLabel,
    required this.moonsetLabel,
    required this.moonPhaseLabel,
    required this.progressLabel,
    required this.reflectionLine,
  });

  final String locationLabel;
  final String dateLabel;
  final String sunriseLabel;
  final String sunsetLabel;
  final String moonriseLabel;
  final String moonsetLabel;
  final String moonPhaseLabel;
  final String progressLabel;
  final String reflectionLine;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'locationLabel': locationLabel,
    'dateLabel': dateLabel,
    'sunriseLabel': sunriseLabel,
    'sunsetLabel': sunsetLabel,
    'moonriseLabel': moonriseLabel,
    'moonsetLabel': moonsetLabel,
    'moonPhaseLabel': moonPhaseLabel,
    'progressLabel': progressLabel,
    'reflectionLine': reflectionLine,
  };
}
