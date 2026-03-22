class QuranCoreWord {
  const QuranCoreWord({
    required this.rank,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
    required this.occurrences,
    this.rootLetters,
    this.meaningExpansion,
  });

  final int rank;
  final String arabic;
  final String transliteration;
  final String meaning;
  final int occurrences;
  final String? rootLetters;
  final String? meaningExpansion;

  bool get hasRootLetters => (rootLetters ?? '').trim().isNotEmpty;

  bool get hasMeaningExpansion => (meaningExpansion ?? '').trim().isNotEmpty;

  factory QuranCoreWord.fromJson(Map<String, dynamic> json) {
    int asInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      return int.tryParse(value?.toString() ?? '') ?? 0;
    }

    return QuranCoreWord(
      rank: asInt(json['rank']),
      arabic: json['arabic']?.toString() ?? '',
      transliteration: json['transliteration']?.toString() ?? '',
      meaning: json['meaning']?.toString() ?? '',
      occurrences: asInt(json['occurrences']),
      rootLetters: json['rootLetters']?.toString(),
      meaningExpansion: json['meaningExpansion']?.toString(),
    );
  }
}
