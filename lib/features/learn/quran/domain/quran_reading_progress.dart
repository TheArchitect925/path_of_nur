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

class QuranReadingStats {
  const QuranReadingStats({
    required this.totalReadingSeconds,
    required this.totalSessions,
    required this.secondsByDayKey,
    this.lastSessionEndedAtIso,
  });

  final int totalReadingSeconds;
  final int totalSessions;
  final Map<String, int> secondsByDayKey;
  final String? lastSessionEndedAtIso;

  int get activeDaysCount =>
      secondsByDayKey.values.where((seconds) => seconds > 0).length;

  int secondsForDay(String dayKey) => secondsByDayKey[dayKey] ?? 0;

  QuranReadingStats copyWith({
    int? totalReadingSeconds,
    int? totalSessions,
    Map<String, int>? secondsByDayKey,
    String? lastSessionEndedAtIso,
    bool clearLastSessionEndedAtIso = false,
  }) {
    return QuranReadingStats(
      totalReadingSeconds: totalReadingSeconds ?? this.totalReadingSeconds,
      totalSessions: totalSessions ?? this.totalSessions,
      secondsByDayKey: secondsByDayKey ?? this.secondsByDayKey,
      lastSessionEndedAtIso: clearLastSessionEndedAtIso
          ? null
          : (lastSessionEndedAtIso ?? this.lastSessionEndedAtIso),
    );
  }

  Map<String, dynamic> toJson() => {
    'totalReadingSeconds': totalReadingSeconds,
    'totalSessions': totalSessions,
    'secondsByDayKey': secondsByDayKey,
    'lastSessionEndedAtIso': lastSessionEndedAtIso,
  };

  static QuranReadingStats fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const QuranReadingStats(
        totalReadingSeconds: 0,
        totalSessions: 0,
        secondsByDayKey: <String, int>{},
      );
    }

    final rawByDay = json['secondsByDayKey'];
    final secondsByDayKey = <String, int>{};
    if (rawByDay is Map) {
      for (final entry in rawByDay.entries) {
        final seconds = (entry.value as num?)?.toInt() ?? 0;
        if (entry.key.toString().isNotEmpty && seconds > 0) {
          secondsByDayKey[entry.key.toString()] = seconds;
        }
      }
    }

    return QuranReadingStats(
      totalReadingSeconds: (json['totalReadingSeconds'] as num?)?.toInt() ?? 0,
      totalSessions: (json['totalSessions'] as num?)?.toInt() ?? 0,
      secondsByDayKey: secondsByDayKey,
      lastSessionEndedAtIso: json['lastSessionEndedAtIso']?.toString(),
    );
  }
}

class QuranListeningStats {
  const QuranListeningStats({
    required this.totalListeningSeconds,
    required this.totalSessions,
    required this.secondsByDayKey,
    this.lastSessionEndedAtIso,
  });

  final int totalListeningSeconds;
  final int totalSessions;
  final Map<String, int> secondsByDayKey;
  final String? lastSessionEndedAtIso;

  int get activeDaysCount =>
      secondsByDayKey.values.where((seconds) => seconds > 0).length;

  int secondsForDay(String dayKey) => secondsByDayKey[dayKey] ?? 0;

  QuranListeningStats copyWith({
    int? totalListeningSeconds,
    int? totalSessions,
    Map<String, int>? secondsByDayKey,
    String? lastSessionEndedAtIso,
    bool clearLastSessionEndedAtIso = false,
  }) {
    return QuranListeningStats(
      totalListeningSeconds:
          totalListeningSeconds ?? this.totalListeningSeconds,
      totalSessions: totalSessions ?? this.totalSessions,
      secondsByDayKey: secondsByDayKey ?? this.secondsByDayKey,
      lastSessionEndedAtIso: clearLastSessionEndedAtIso
          ? null
          : (lastSessionEndedAtIso ?? this.lastSessionEndedAtIso),
    );
  }

  Map<String, dynamic> toJson() => {
    'totalListeningSeconds': totalListeningSeconds,
    'totalSessions': totalSessions,
    'secondsByDayKey': secondsByDayKey,
    'lastSessionEndedAtIso': lastSessionEndedAtIso,
  };

  static QuranListeningStats fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const QuranListeningStats(
        totalListeningSeconds: 0,
        totalSessions: 0,
        secondsByDayKey: <String, int>{},
      );
    }

    final rawByDay = json['secondsByDayKey'];
    final secondsByDayKey = <String, int>{};
    if (rawByDay is Map) {
      for (final entry in rawByDay.entries) {
        final seconds = (entry.value as num?)?.toInt() ?? 0;
        if (entry.key.toString().isNotEmpty && seconds > 0) {
          secondsByDayKey[entry.key.toString()] = seconds;
        }
      }
    }

    return QuranListeningStats(
      totalListeningSeconds:
          (json['totalListeningSeconds'] as num?)?.toInt() ?? 0,
      totalSessions: (json['totalSessions'] as num?)?.toInt() ?? 0,
      secondsByDayKey: secondsByDayKey,
      lastSessionEndedAtIso: json['lastSessionEndedAtIso']?.toString(),
    );
  }
}
