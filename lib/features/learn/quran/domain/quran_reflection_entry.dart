import 'quran_content_refs.dart';

enum QuranReflectionSourceType { dailyAyah, ayahInsight, relatedAyah, pathItem }

class QuranReflectionEntry {
  const QuranReflectionEntry({
    required this.id,
    required this.ref,
    required this.sourceType,
    required this.title,
    required this.summary,
    required this.savedAtIso,
    required this.updatedAtIso,
    this.sourceEnrichmentId,
    this.note,
  });

  final String id;
  final QuranQuoteRef ref;
  final QuranReflectionSourceType sourceType;
  final String title;
  final String summary;
  final String? sourceEnrichmentId;
  final String? note;
  final String savedAtIso;
  final String updatedAtIso;

  QuranReflectionEntry copyWith({
    String? id,
    QuranQuoteRef? ref,
    QuranReflectionSourceType? sourceType,
    String? title,
    String? summary,
    Object? note = _sentinel,
    String? sourceEnrichmentId,
    String? savedAtIso,
    String? updatedAtIso,
  }) {
    return QuranReflectionEntry(
      id: id ?? this.id,
      ref: ref ?? this.ref,
      sourceType: sourceType ?? this.sourceType,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      sourceEnrichmentId: sourceEnrichmentId ?? this.sourceEnrichmentId,
      note: identical(note, _sentinel) ? this.note : note as String?,
      savedAtIso: savedAtIso ?? this.savedAtIso,
      updatedAtIso: updatedAtIso ?? this.updatedAtIso,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'ref': {'surah': ref.surah, 'ayah': ref.ayah, 'ayahEnd': ref.ayahEnd},
    'sourceType': sourceType.name,
    'title': title,
    'summary': summary,
    'sourceEnrichmentId': sourceEnrichmentId,
    'note': note,
    'savedAtIso': savedAtIso,
    'updatedAtIso': updatedAtIso,
  };

  static QuranReflectionEntry? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final id = json['id']?.toString();
    final refJson = json['ref'];
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
        refJson is! Map ||
        sourceTypeName == null) {
      return null;
    }

    final surah = int.tryParse(refJson['surah']?.toString() ?? '');
    final ayah = int.tryParse(refJson['ayah']?.toString() ?? '');
    final ayahEnd = int.tryParse(refJson['ayahEnd']?.toString() ?? '');
    if (surah == null || ayah == null) return null;

    final sourceType = QuranReflectionSourceType.values.where(
      (value) => value.name == sourceTypeName,
    );
    if (sourceType.isEmpty) return null;

    return QuranReflectionEntry(
      id: id,
      ref: QuranQuoteRef(surah: surah, ayah: ayah, ayahEnd: ayahEnd),
      sourceType: sourceType.first,
      title: title,
      summary: summary,
      sourceEnrichmentId: json['sourceEnrichmentId']?.toString(),
      note: json['note']?.toString(),
      savedAtIso: savedAtIso,
      updatedAtIso: updatedAtIso,
    );
  }
}

const Object _sentinel = Object();
