class QuranCoreWord {
  const QuranCoreWord({
    required this.rank,
    required this.transliteration,
    required this.meaning,
    required this.occurrences,
  });

  final int rank;
  final String transliteration;
  final String meaning;
  final int occurrences;

  factory QuranCoreWord.fromJson(Map<String, dynamic> json) {
    int asInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      return int.tryParse(value?.toString() ?? '') ?? 0;
    }

    return QuranCoreWord(
      rank: asInt(json['rank']),
      transliteration: json['transliteration']?.toString() ?? '',
      meaning: json['meaning']?.toString() ?? '',
      occurrences: asInt(json['occurrences']),
    );
  }
}
