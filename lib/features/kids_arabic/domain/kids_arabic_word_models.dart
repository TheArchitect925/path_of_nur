import '../application/kids_arabic_starter_tracing.dart';

class KidsArabicJoiningExample {
  const KidsArabicJoiningExample({
    required this.letterId,
    required this.standaloneGlyph,
    required this.joinedGlyph,
  });

  final String letterId;
  final String standaloneGlyph;
  final String joinedGlyph;
}

class KidsArabicBeginnerWord {
  const KidsArabicBeginnerWord({
    required this.id,
    required this.wordAr,
    required this.transliteration,
    required this.letterIds,
    required this.requiredCompletedLetterIds,
    required this.guide,
    required this.joiningExamples,
  });

  final String id;
  final String wordAr;
  final String transliteration;
  final List<String> letterIds;
  final Set<String> requiredCompletedLetterIds;
  final KidsArabicTracingGuide guide;
  final List<KidsArabicJoiningExample> joiningExamples;
}

class KidsArabicWordProgressState {
  const KidsArabicWordProgressState({
    required this.completedWordIds,
    required this.totalWordLessonsDone,
    this.lastWordId,
  });

  final Set<String> completedWordIds;
  final int totalWordLessonsDone;
  final String? lastWordId;

  KidsArabicWordProgressState copyWith({
    Set<String>? completedWordIds,
    int? totalWordLessonsDone,
    String? lastWordId,
    bool clearLastWordId = false,
  }) {
    return KidsArabicWordProgressState(
      completedWordIds: completedWordIds ?? this.completedWordIds,
      totalWordLessonsDone: totalWordLessonsDone ?? this.totalWordLessonsDone,
      lastWordId: clearLastWordId ? null : (lastWordId ?? this.lastWordId),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'completedWordIds': completedWordIds.toList(growable: false),
    'totalWordLessonsDone': totalWordLessonsDone,
    'lastWordId': lastWordId,
  };

  static KidsArabicWordProgressState initial() =>
      const KidsArabicWordProgressState(
        completedWordIds: <String>{},
        totalWordLessonsDone: 0,
        lastWordId: null,
      );

  static KidsArabicWordProgressState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return initial();
    }
    final completedWordIds = json['completedWordIds'] is List
        ? (json['completedWordIds'] as List)
              .map((item) => item.toString())
              .toSet()
        : <String>{};
    return KidsArabicWordProgressState(
      completedWordIds: completedWordIds,
      totalWordLessonsDone:
          (json['totalWordLessonsDone'] as num?)?.toInt() ?? 0,
      lastWordId: json['lastWordId']?.toString(),
    );
  }
}
