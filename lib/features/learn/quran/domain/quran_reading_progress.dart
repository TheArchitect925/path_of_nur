class QuranReadingProgress {
  const QuranReadingProgress({
    required this.surahNumber,
    required this.ayahNumber,
    required this.updatedAtIso,
  });

  final int surahNumber;
  final int ayahNumber;
  final String updatedAtIso;

  QuranReadingProgress copyWith({
    int? surahNumber,
    int? ayahNumber,
    String? updatedAtIso,
  }) {
    return QuranReadingProgress(
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      updatedAtIso: updatedAtIso ?? this.updatedAtIso,
    );
  }

  Map<String, dynamic> toJson() => {
        'surahNumber': surahNumber,
        'ayahNumber': ayahNumber,
        'updatedAtIso': updatedAtIso,
      };

  static QuranReadingProgress? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final surahNumber = json['surahNumber'];
    final ayahNumber = json['ayahNumber'];
    final updatedAtIso = json['updatedAtIso']?.toString();
    if (surahNumber is! int || ayahNumber is! int || updatedAtIso == null) {
      return null;
    }
    return QuranReadingProgress(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      updatedAtIso: updatedAtIso,
    );
  }
}
