class QuranUniverseVerseLink {
  const QuranUniverseVerseLink({
    required this.id,
    required this.verseReference,
    required this.surahNumber,
    this.startAyah,
    this.endAyah,
    this.label,
    this.prophetIds = const <String>[],
    this.themeIds = const <String>[],
    this.lessonIds = const <String>[],
    this.locationIds = const <String>[],
  });

  final String id;
  final String verseReference;
  final int surahNumber;
  final int? startAyah;
  final int? endAyah;
  final String? label;
  final List<String> prophetIds;
  final List<String> themeIds;
  final List<String> lessonIds;
  final List<String> locationIds;
}

enum QuranUniverseNodeType { quran, hadith, prophet, theme, concept }

class QuranUniverseNode {
  const QuranUniverseNode({
    required this.id,
    required this.type,
    required this.title,
    required this.reference,
    required this.summary,
    this.connections = const <String>[],
  });

  final String id;
  final QuranUniverseNodeType type;
  final String title;
  final String reference;
  final String summary;
  final List<String> connections;
}

class QuranUniverseProphetLens {
  const QuranUniverseProphetLens({
    required this.prophetId,
    required this.summary,
    this.relatedProphetIds = const <String>[],
    this.locationIds = const <String>[],
    this.themeIds = const <String>[],
    this.lessonIds = const <String>[],
  });

  final String prophetId;
  final String summary;
  final List<String> relatedProphetIds;
  final List<String> locationIds;
  final List<String> themeIds;
  final List<String> lessonIds;
}
