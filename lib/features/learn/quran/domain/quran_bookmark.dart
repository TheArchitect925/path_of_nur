class QuranBookmark {
  const QuranBookmark({
    required this.surahNumber,
    required this.ayahNumber,
    required this.createdAtIso,
  });

  final int surahNumber;
  final int ayahNumber;
  final String createdAtIso;

  Map<String, dynamic> toJson() => {
        'surahNumber': surahNumber,
        'ayahNumber': ayahNumber,
        'createdAtIso': createdAtIso,
      };

  static QuranBookmark? fromJson(dynamic json) {
    if (json is! Map) return null;
    final surah = json['surahNumber'];
    final ayah = json['ayahNumber'];
    final createdAtIso = json['createdAtIso']?.toString();
    if (surah is! int || ayah is! int || createdAtIso == null) return null;
    return QuranBookmark(
      surahNumber: surah,
      ayahNumber: ayah,
      createdAtIso: createdAtIso,
    );
  }
}
