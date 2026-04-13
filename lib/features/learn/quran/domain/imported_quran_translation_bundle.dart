class ImportedQuranTranslationBundle {
  const ImportedQuranTranslationBundle({
    required this.code,
    required this.translatorName,
    required this.sourceProvider,
    required this.verseTextsByVerseKey,
    this.sourceResourceId,
    this.notes,
  });

  final String code;
  final String translatorName;
  final String sourceProvider;
  final int? sourceResourceId;
  final String? notes;
  final Map<String, String> verseTextsByVerseKey;

  bool get hasAnyVerses => verseTextsByVerseKey.isNotEmpty;
  int get verseCount => verseTextsByVerseKey.length;

  String? translationForVerseKey(String verseKey) =>
      verseTextsByVerseKey[verseKey];
}
