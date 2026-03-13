import 'package:flutter/material.dart';

import 'prophet_name_formatter.dart';

enum ProphetLocationConfidence { symbolic, approximate, traditional, strong }

enum ProphetEraGroup {
  earlyHumanity,
  earlyCivilizations,
  postFloodPeoples,
  ageOfIbrahim,
  childrenOfIsrael,
  laterIsraeliteProphets,
  finalMessenger,
}

extension ProphetLocationConfidenceX on ProphetLocationConfidence {
  String get label {
    switch (this) {
      case ProphetLocationConfidence.symbolic:
        return 'Symbolic location';
      case ProphetLocationConfidence.approximate:
        return 'Approximate region';
      case ProphetLocationConfidence.traditional:
        return 'Traditional association';
      case ProphetLocationConfidence.strong:
        return 'Strong historical association';
    }
  }

  String get guidance {
    switch (this) {
      case ProphetLocationConfidence.symbolic:
        return 'This map point is symbolic and used for learning context only.';
      case ProphetLocationConfidence.approximate:
        return 'This location is approximate and shown as a broad region.';
      case ProphetLocationConfidence.traditional:
        return 'This location follows traditional Islamic association.';
      case ProphetLocationConfidence.strong:
        return 'This location has a stronger historical association.';
    }
  }
}

extension ProphetEraGroupX on ProphetEraGroup {
  String get title {
    switch (this) {
      case ProphetEraGroup.earlyHumanity:
        return 'Early Humanity';
      case ProphetEraGroup.earlyCivilizations:
        return 'Early Civilizations';
      case ProphetEraGroup.postFloodPeoples:
        return 'Post-Flood Peoples';
      case ProphetEraGroup.ageOfIbrahim:
        return 'Age of Ibrahim';
      case ProphetEraGroup.childrenOfIsrael:
        return 'Children of Israel';
      case ProphetEraGroup.laterIsraeliteProphets:
        return 'Later Israelite Prophets';
      case ProphetEraGroup.finalMessenger:
        return 'Final Messenger';
    }
  }

  String get subtitle {
    switch (this) {
      case ProphetEraGroup.earlyHumanity:
        return 'The beginning of human life, worship, and repentance.';
      case ProphetEraGroup.earlyCivilizations:
        return 'Growing societies and calls back to tawhid.';
      case ProphetEraGroup.postFloodPeoples:
        return 'Communities rebuilt after the flood with renewed guidance.';
      case ProphetEraGroup.ageOfIbrahim:
        return 'A foundational era of faith, migration, and sacrifice.';
      case ProphetEraGroup.childrenOfIsrael:
        return 'Guidance through law, justice, and covenant.';
      case ProphetEraGroup.laterIsraeliteProphets:
        return 'Renewal, repentance, and mercy in later generations.';
      case ProphetEraGroup.finalMessenger:
        return 'Completion of revelation and universal mercy.';
    }
  }

  Color get tint {
    switch (this) {
      case ProphetEraGroup.earlyHumanity:
        return const Color(0xFF8D6E63);
      case ProphetEraGroup.earlyCivilizations:
        return const Color(0xFF6D8A73);
      case ProphetEraGroup.postFloodPeoples:
        return const Color(0xFF5B7A8B);
      case ProphetEraGroup.ageOfIbrahim:
        return const Color(0xFF87653A);
      case ProphetEraGroup.childrenOfIsrael:
        return const Color(0xFF6A6F9A);
      case ProphetEraGroup.laterIsraeliteProphets:
        return const Color(0xFF7C5D8E);
      case ProphetEraGroup.finalMessenger:
        return const Color(0xFF8A5A2E);
    }
  }
}

@immutable
class ProphetEntry {
  const ProphetEntry({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.timelineOrder,
    required this.eraGroup,
    required this.eraTitle,
    required this.regionLabel,
    required this.shortSummary,
    required this.overview,
    required this.storySummary,
    required this.keyLessons,
    required this.quranReferences,
    required this.locationConfidence,
    required this.sortOrder,
    this.titleLabel,
    this.eraSubtitle,
    this.latitude,
    this.longitude,
    this.locationLabel,
    this.heroAsset,
    this.themeKey,
    this.isFeatured = false,
  });

  final String id;
  final String name;
  final String arabicName;
  final String? titleLabel;
  final int timelineOrder;
  final ProphetEraGroup eraGroup;
  final String eraTitle;
  final String? eraSubtitle;
  final String regionLabel;
  final String shortSummary;
  final String overview;
  final String storySummary;
  final List<String> keyLessons;
  final List<String> quranReferences;
  final double? latitude;
  final double? longitude;
  final String? locationLabel;
  final ProphetLocationConfidence locationConfidence;
  final String? heroAsset;
  final String? themeKey;
  final bool isFeatured;
  final int sortOrder;

  bool get hasMapLocation => latitude != null && longitude != null;

  String get honoredName => formatProphetName(name);
  String get titledHonoredName => formatProphetName(name, includeTitle: true);
  String get honoredArabicName => formatProphetArabicName(arabicName, name);
}
