enum ArabicBeginnerContentType { word, phrase }

class ArabicBeginnerWordEntry {
  const ArabicBeginnerWordEntry({
    required this.id,
    required this.arabicText,
    required this.transliteration,
    required this.simpleMeaning,
    required this.letterIds,
    this.categoryTag = 'beginner_word',
    this.audioLookupId,
    this.audioAssetPath,
    this.sourceReference,
  });

  final String id;
  final String arabicText;
  final String transliteration;
  final String simpleMeaning;
  final List<String> letterIds;
  final String categoryTag;
  final String? audioLookupId;
  final String? audioAssetPath;
  final String? sourceReference;
}

class ArabicBeginnerPhraseEntry {
  const ArabicBeginnerPhraseEntry({
    required this.id,
    required this.arabicText,
    required this.transliteration,
    required this.simpleMeaning,
    this.categoryTag = 'mini_phrase',
    this.letterIds = const <String>[],
    this.audioLookupId,
    this.audioAssetPath,
    this.sourceReference,
  });

  final String id;
  final String arabicText;
  final String transliteration;
  final String simpleMeaning;
  final String categoryTag;
  final List<String> letterIds;
  final String? audioLookupId;
  final String? audioAssetPath;
  final String? sourceReference;
}
