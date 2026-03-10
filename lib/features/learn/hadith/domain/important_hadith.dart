class ImportantHadithEntry {
  const ImportantHadithEntry({
    required this.number,
    required this.title,
    required this.collectionId,
    required this.collectionTitle,
    required this.summary,
    required this.practicalReflection,
    required this.source,
    required this.themes,
    this.arabicTitle,
  });

  final int number;
  final String title;
  final String? arabicTitle;
  final String collectionId;
  final String collectionTitle;
  final String summary;
  final String practicalReflection;
  final String source;
  final List<String> themes;
}
