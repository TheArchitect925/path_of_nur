enum HistoricalDateConfidence { exact, approximate, disputed }

enum HistoricalAlternateDateCalendar { gregorian, hijri }

enum HistoricalEventCategory {
  seerah,
  battles,
  prophets,
  revelation,
  khulafa,
  scholars,
  islamicHistory,
  worldHistory,
  births,
  deaths,
  sacredPlaces,
}

HistoricalEventCategory? historicalEventCategoryFromKey(String raw) {
  switch (raw) {
    case 'seerah':
      return HistoricalEventCategory.seerah;
    case 'battles':
      return HistoricalEventCategory.battles;
    case 'prophets':
      return HistoricalEventCategory.prophets;
    case 'revelation':
      return HistoricalEventCategory.revelation;
    case 'khulafa':
      return HistoricalEventCategory.khulafa;
    case 'scholars':
      return HistoricalEventCategory.scholars;
    case 'islamic_history':
      return HistoricalEventCategory.islamicHistory;
    case 'world_history':
      return HistoricalEventCategory.worldHistory;
    case 'births':
      return HistoricalEventCategory.births;
    case 'deaths':
      return HistoricalEventCategory.deaths;
    case 'sacred_places':
      return HistoricalEventCategory.sacredPlaces;
    default:
      return null;
  }
}

String historicalEventCategoryKey(HistoricalEventCategory category) {
  switch (category) {
    case HistoricalEventCategory.seerah:
      return 'seerah';
    case HistoricalEventCategory.battles:
      return 'battles';
    case HistoricalEventCategory.prophets:
      return 'prophets';
    case HistoricalEventCategory.revelation:
      return 'revelation';
    case HistoricalEventCategory.khulafa:
      return 'khulafa';
    case HistoricalEventCategory.scholars:
      return 'scholars';
    case HistoricalEventCategory.islamicHistory:
      return 'islamic_history';
    case HistoricalEventCategory.worldHistory:
      return 'world_history';
    case HistoricalEventCategory.births:
      return 'births';
    case HistoricalEventCategory.deaths:
      return 'deaths';
    case HistoricalEventCategory.sacredPlaces:
      return 'sacred_places';
  }
}

HistoricalDateConfidence historicalDateConfidenceFromKey(String raw) {
  switch (raw) {
    case 'approximate':
      return HistoricalDateConfidence.approximate;
    case 'disputed':
      return HistoricalDateConfidence.disputed;
    case 'exact':
    default:
      return HistoricalDateConfidence.exact;
  }
}

class HistoricalEventDate {
  const HistoricalEventDate({
    this.year,
    this.month,
    this.day,
    this.display,
    this.monthNameKey,
  });

  final int? year;
  final int? month;
  final int? day;
  final String? display;
  final String? monthNameKey;

  bool get hasMonthDay => month != null && day != null;

  factory HistoricalEventDate.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) {
      return const HistoricalEventDate();
    }
    return HistoricalEventDate(
      year: (json['year'] as num?)?.toInt(),
      month: (json['month'] as num?)?.toInt(),
      day: (json['day'] as num?)?.toInt(),
      display: json['display']?.toString(),
      monthNameKey: json['monthNameKey']?.toString(),
    );
  }
}

class HistoricalEventLocation {
  const HistoricalEventLocation({
    required this.name,
    this.latitude,
    this.longitude,
  });

  final String name;
  final double? latitude;
  final double? longitude;

  bool get hasCoordinates => latitude != null && longitude != null;

  factory HistoricalEventLocation.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) {
      return const HistoricalEventLocation(name: '');
    }
    return HistoricalEventLocation(
      name: json['name']?.toString() ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}

class HistoricalAlternateDate {
  const HistoricalAlternateDate({
    required this.calendar,
    this.year,
    this.month,
    this.day,
    this.note,
  });

  final HistoricalAlternateDateCalendar calendar;
  final int? year;
  final int? month;
  final int? day;
  final String? note;

  factory HistoricalAlternateDate.fromJson(Map<String, dynamic> json) {
    final calendar = switch (json['calendar']?.toString()) {
      'hijri' => HistoricalAlternateDateCalendar.hijri,
      _ => HistoricalAlternateDateCalendar.gregorian,
    };
    return HistoricalAlternateDate(
      calendar: calendar,
      year: (json['year'] as num?)?.toInt(),
      month: (json['month'] as num?)?.toInt(),
      day: (json['day'] as num?)?.toInt(),
      note: json['note']?.toString(),
    );
  }
}

class HistoricalSourceReference {
  const HistoricalSourceReference({
    required this.label,
    this.note,
    this.url,
  });

  final String label;
  final String? note;
  final String? url;

  factory HistoricalSourceReference.fromJson(Map<String, dynamic> json) {
    return HistoricalSourceReference(
      label: json['label']?.toString() ?? '',
      note: json['note']?.toString(),
      url: json['url']?.toString(),
    );
  }
}

class HistoricalRelatedContentHook {
  const HistoricalRelatedContentHook({
    required this.label,
    required this.routeName,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
  });

  final String label;
  final String routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;

  factory HistoricalRelatedContentHook.fromJson(Map<String, dynamic> json) {
    Map<String, String> readMap(String key) {
      final raw = json[key];
      if (raw is! Map) return const <String, String>{};
      return raw.map(
        (key, value) => MapEntry(key.toString(), value.toString()),
      );
    }

    return HistoricalRelatedContentHook(
      label: json['label']?.toString() ?? '',
      routeName: json['routeName']?.toString() ?? '',
      pathParameters: readMap('pathParameters'),
      queryParameters: readMap('queryParameters'),
    );
  }
}

class HistoricalEvent {
  const HistoricalEvent({
    required this.id,
    required this.slug,
    required this.title,
    this.shortTitle,
    required this.summaryShort,
    this.summaryLong,
    required this.categories,
    required this.tags,
    required this.gregorian,
    required this.hijri,
    required this.location,
    required this.significancePoints,
    required this.lessons,
    required this.relatedEntities,
    required this.relatedContentIds,
    required this.relatedContentHooks,
    required this.featuredPriority,
    this.imageAssetPath,
    this.illustrationAssetPath,
    required this.sources,
    required this.isPublished,
    required this.dateConfidence,
    required this.alternateDates,
    this.sourceNotes,
  });

  final String id;
  final String slug;
  final String title;
  final String? shortTitle;
  final String summaryShort;
  final String? summaryLong;
  final List<HistoricalEventCategory> categories;
  final List<String> tags;
  final HistoricalEventDate gregorian;
  final HistoricalEventDate hijri;
  final HistoricalEventLocation location;
  final List<String> significancePoints;
  final List<String> lessons;
  final List<String> relatedEntities;
  final List<String> relatedContentIds;
  final List<HistoricalRelatedContentHook> relatedContentHooks;
  final int featuredPriority;
  final String? imageAssetPath;
  final String? illustrationAssetPath;
  final List<HistoricalSourceReference> sources;
  final bool isPublished;
  final HistoricalDateConfidence dateConfidence;
  final List<HistoricalAlternateDate> alternateDates;
  final String? sourceNotes;

  bool get hasLocation => location.name.trim().isNotEmpty;
  bool get hasLongSummary =>
      summaryLong != null && summaryLong!.trim().isNotEmpty;
  bool get hasLessons => lessons.isNotEmpty;
  bool get hasRelatedContent => relatedContentHooks.isNotEmpty;

  factory HistoricalEvent.fromJson(Map<String, dynamic> json) {
    List<String> readStringList(String key) {
      final raw = json[key];
      if (raw is! List) return const <String>[];
      return raw.map((item) => item.toString().trim()).where((item) {
        return item.isNotEmpty;
      }).toList(growable: false);
    }

    final rawCategories = readStringList('categories');
    final categories = rawCategories
        .map(historicalEventCategoryFromKey)
        .whereType<HistoricalEventCategory>()
        .toList(growable: false);

    final rawSources = json['sources'];
    final rawAlternateDates = json['alternateDates'];
    final rawHooks = json['relatedContentHooks'];

    return HistoricalEvent(
      id: json['id']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      shortTitle: json['shortTitle']?.toString(),
      summaryShort: json['summaryShort']?.toString() ?? '',
      summaryLong: json['summaryLong']?.toString(),
      categories: categories,
      tags: readStringList('tags'),
      gregorian: HistoricalEventDate.fromJson(
        json['gregorian'] is Map<String, dynamic>
            ? json['gregorian'] as Map<String, dynamic>
            : (json['gregorian'] as Map?)?.map(
                (key, value) => MapEntry(key.toString(), value),
              ),
      ),
      hijri: HistoricalEventDate.fromJson(
        json['hijri'] is Map<String, dynamic>
            ? json['hijri'] as Map<String, dynamic>
            : (json['hijri'] as Map?)?.map(
                (key, value) => MapEntry(key.toString(), value),
              ),
      ),
      location: HistoricalEventLocation.fromJson(
        json['location'] is Map<String, dynamic>
            ? json['location'] as Map<String, dynamic>
            : (json['location'] as Map?)?.map(
                (key, value) => MapEntry(key.toString(), value),
              ),
      ),
      significancePoints: readStringList('significance'),
      lessons: readStringList('lessons'),
      relatedEntities: readStringList('relatedEntities'),
      relatedContentIds: readStringList('relatedContentIds'),
      relatedContentHooks: rawHooks is List
          ? rawHooks
                .whereType<Map>()
                .map(
                  (item) => HistoricalRelatedContentHook.fromJson(
                    item.map((key, value) => MapEntry(key.toString(), value)),
                  ),
                )
                .where((item) => item.label.isNotEmpty && item.routeName.isNotEmpty)
                .toList(growable: false)
          : const <HistoricalRelatedContentHook>[],
      featuredPriority: (json['featuredPriority'] as num?)?.toInt() ?? 0,
      imageAssetPath: json['imageAssetPath']?.toString(),
      illustrationAssetPath: json['illustrationAssetPath']?.toString(),
      sources: rawSources is List
          ? rawSources
                .whereType<Map>()
                .map(
                  (item) => HistoricalSourceReference.fromJson(
                    item.map((key, value) => MapEntry(key.toString(), value)),
                  ),
                )
                .where((item) => item.label.isNotEmpty)
                .toList(growable: false)
          : const <HistoricalSourceReference>[],
      isPublished: json['isPublished'] != false,
      dateConfidence: historicalDateConfidenceFromKey(
        json['dateConfidence']?.toString() ?? 'exact',
      ),
      alternateDates: rawAlternateDates is List
          ? rawAlternateDates
                .whereType<Map>()
                .map(
                  (item) => HistoricalAlternateDate.fromJson(
                    item.map((key, value) => MapEntry(key.toString(), value)),
                  ),
                )
                .toList(growable: false)
          : const <HistoricalAlternateDate>[],
      sourceNotes: json['sourceNotes']?.toString(),
    );
  }
}

class HistoricalTodayMatch {
  const HistoricalTodayMatch({
    required this.event,
    required this.matchesGregorian,
    required this.matchesHijri,
  });

  final HistoricalEvent event;
  final bool matchesGregorian;
  final bool matchesHijri;

  int get rankingBucket {
    if (matchesGregorian && matchesHijri) return 0;
    if (matchesHijri) return 1;
    if (matchesGregorian) return 2;
    return 3;
  }
}

class HistoricalUpcomingEvent {
  const HistoricalUpcomingEvent({
    required this.event,
    required this.occurrenceDate,
  });

  final HistoricalEvent event;
  final DateTime occurrenceDate;
}
