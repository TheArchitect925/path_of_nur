import 'quran_content_refs.dart';

enum QuranReflectionSourceType {
  dailyAyah,
  ayahInsight,
  relatedAyah,
  pathItem,
  surahDetail,
  themeDetail,
  pathway,
  pathwayStop,
  ayahReflection,
  quranCompanionPrompt,
  readerContext,
}

class QuranReflectionEntry {
  const QuranReflectionEntry({
    required this.id,
    required this.sourceType,
    required this.title,
    required this.summary,
    required this.savedAtIso,
    required this.updatedAtIso,
    this.ref,
    this.sourceEnrichmentId,
    this.sourceId,
    this.sourceLabel,
    this.surahNumber,
    this.themeId,
    this.pathwayId,
    this.pathwayStopId,
    this.promptLabel,
    this.routeName,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
    this.isFavorite = false,
    this.note,
  });

  final String id;
  final QuranQuoteRef? ref;
  final QuranReflectionSourceType sourceType;
  final String title;
  final String summary;
  final String? sourceEnrichmentId;
  final String? sourceId;
  final String? sourceLabel;
  final int? surahNumber;
  final String? themeId;
  final String? pathwayId;
  final String? pathwayStopId;
  final String? promptLabel;
  final String? routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
  final bool isFavorite;
  final String? note;
  final String savedAtIso;
  final String updatedAtIso;

  QuranReflectionEntry copyWith({
    String? id,
    Object? ref = _sentinel,
    QuranReflectionSourceType? sourceType,
    String? title,
    String? summary,
    Object? note = _sentinel,
    String? sourceEnrichmentId,
    Object? sourceId = _sentinel,
    Object? sourceLabel = _sentinel,
    Object? surahNumber = _sentinel,
    Object? themeId = _sentinel,
    Object? pathwayId = _sentinel,
    Object? pathwayStopId = _sentinel,
    Object? promptLabel = _sentinel,
    Object? routeName = _sentinel,
    Map<String, String>? pathParameters,
    Map<String, String>? queryParameters,
    bool? isFavorite,
    String? savedAtIso,
    String? updatedAtIso,
  }) {
    return QuranReflectionEntry(
      id: id ?? this.id,
      ref: identical(ref, _sentinel) ? this.ref : ref as QuranQuoteRef?,
      sourceType: sourceType ?? this.sourceType,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      sourceEnrichmentId: sourceEnrichmentId ?? this.sourceEnrichmentId,
      sourceId: identical(sourceId, _sentinel)
          ? this.sourceId
          : sourceId as String?,
      sourceLabel: identical(sourceLabel, _sentinel)
          ? this.sourceLabel
          : sourceLabel as String?,
      surahNumber: identical(surahNumber, _sentinel)
          ? this.surahNumber
          : surahNumber as int?,
      themeId: identical(themeId, _sentinel)
          ? this.themeId
          : themeId as String?,
      pathwayId: identical(pathwayId, _sentinel)
          ? this.pathwayId
          : pathwayId as String?,
      pathwayStopId: identical(pathwayStopId, _sentinel)
          ? this.pathwayStopId
          : pathwayStopId as String?,
      promptLabel: identical(promptLabel, _sentinel)
          ? this.promptLabel
          : promptLabel as String?,
      routeName: identical(routeName, _sentinel)
          ? this.routeName
          : routeName as String?,
      pathParameters: pathParameters ?? this.pathParameters,
      queryParameters: queryParameters ?? this.queryParameters,
      isFavorite: isFavorite ?? this.isFavorite,
      note: identical(note, _sentinel) ? this.note : note as String?,
      savedAtIso: savedAtIso ?? this.savedAtIso,
      updatedAtIso: updatedAtIso ?? this.updatedAtIso,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    if (ref != null)
      'ref': {'surah': ref!.surah, 'ayah': ref!.ayah, 'ayahEnd': ref!.ayahEnd},
    'sourceType': sourceType.name,
    'title': title,
    'summary': summary,
    'sourceEnrichmentId': sourceEnrichmentId,
    'sourceId': sourceId,
    'sourceLabel': sourceLabel,
    'surahNumber': surahNumber,
    'themeId': themeId,
    'pathwayId': pathwayId,
    'pathwayStopId': pathwayStopId,
    'promptLabel': promptLabel,
    'routeName': routeName,
    'pathParameters': pathParameters,
    'queryParameters': queryParameters,
    'isFavorite': isFavorite,
    'note': note,
    'savedAtIso': savedAtIso,
    'updatedAtIso': updatedAtIso,
  };

  static QuranReflectionEntry? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final id = json['id']?.toString();
    final sourceTypeName = json['sourceType']?.toString();
    final title = json['title']?.toString();
    final summary = json['summary']?.toString();
    final savedAtIso = json['savedAtIso']?.toString();
    final updatedAtIso = json['updatedAtIso']?.toString();
    if (id == null ||
        title == null ||
        summary == null ||
        savedAtIso == null ||
        updatedAtIso == null ||
        sourceTypeName == null) {
      return null;
    }

    final sourceType = QuranReflectionSourceType.values.where(
      (value) => value.name == sourceTypeName,
    );
    if (sourceType.isEmpty) return null;

    QuranQuoteRef? refValue;
    final refJson = json['ref'];
    if (refJson is Map) {
      final surah = int.tryParse(refJson['surah']?.toString() ?? '');
      final ayah = int.tryParse(refJson['ayah']?.toString() ?? '');
      final ayahEnd = int.tryParse(refJson['ayahEnd']?.toString() ?? '');
      if (surah != null && ayah != null) {
        refValue = QuranQuoteRef(surah: surah, ayah: ayah, ayahEnd: ayahEnd);
      }
    }

    return QuranReflectionEntry(
      id: id,
      ref: refValue,
      sourceType: sourceType.first,
      title: title,
      summary: summary,
      sourceEnrichmentId: json['sourceEnrichmentId']?.toString(),
      sourceId: json['sourceId']?.toString(),
      sourceLabel: json['sourceLabel']?.toString(),
      surahNumber: int.tryParse(json['surahNumber']?.toString() ?? ''),
      themeId: json['themeId']?.toString(),
      pathwayId: json['pathwayId']?.toString(),
      pathwayStopId: json['pathwayStopId']?.toString(),
      promptLabel: json['promptLabel']?.toString(),
      routeName: json['routeName']?.toString(),
      pathParameters: _decodeStringMap(json['pathParameters']),
      queryParameters: _decodeStringMap(json['queryParameters']),
      isFavorite: json['isFavorite'] == true,
      note: json['note']?.toString(),
      savedAtIso: savedAtIso,
      updatedAtIso: updatedAtIso,
    );
  }
}

Map<String, String> _decodeStringMap(Object? raw) {
  if (raw is! Map) {
    return const <String, String>{};
  }
  return raw.map(
    (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
  );
}

const Object _sentinel = Object();
