enum DailyLearningItemType {
  prophet,
  era,
  theme,
  lesson,
  verseLink,
  humanPattern,
  coreMessage,
}

class DailyLearningItem {
  const DailyLearningItem({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.subtitle,
    this.linkedProphetId,
    this.linkedEraId,
    this.linkedThemeId,
    this.linkedLessonId,
    this.linkedGrowthHabitId,
    this.linkedQuranReference,
    this.dailyQuizQuestionId,
  });

  final String id;
  final DailyLearningItemType type;
  final String title;
  final String? subtitle;
  final String body;
  final String? linkedProphetId;
  final String? linkedEraId;
  final String? linkedThemeId;
  final String? linkedLessonId;
  final String? linkedGrowthHabitId;
  final String? linkedQuranReference;
  final String? dailyQuizQuestionId;
}

class DailyLearningDayStatus {
  const DailyLearningDayStatus({
    required this.dateKey,
    this.cardOpened = false,
    this.quizAnswered = false,
    this.quizQuestionId,
    this.quizSelectedIndex,
    this.quizCorrect,
    this.lastLinkedProphetId,
  });

  final String dateKey;
  final bool cardOpened;
  final bool quizAnswered;
  final String? quizQuestionId;
  final int? quizSelectedIndex;
  final bool? quizCorrect;
  final String? lastLinkedProphetId;

  bool get isCompleted => cardOpened && quizAnswered;

  DailyLearningDayStatus copyWith({
    bool? cardOpened,
    bool? quizAnswered,
    String? quizQuestionId,
    bool clearQuizQuestionId = false,
    int? quizSelectedIndex,
    bool clearQuizSelectedIndex = false,
    bool? quizCorrect,
    bool clearQuizCorrect = false,
    String? lastLinkedProphetId,
    bool clearLastLinkedProphetId = false,
  }) {
    return DailyLearningDayStatus(
      dateKey: dateKey,
      cardOpened: cardOpened ?? this.cardOpened,
      quizAnswered: quizAnswered ?? this.quizAnswered,
      quizQuestionId: clearQuizQuestionId
          ? null
          : (quizQuestionId ?? this.quizQuestionId),
      quizSelectedIndex: clearQuizSelectedIndex
          ? null
          : (quizSelectedIndex ?? this.quizSelectedIndex),
      quizCorrect: clearQuizCorrect ? null : (quizCorrect ?? this.quizCorrect),
      lastLinkedProphetId: clearLastLinkedProphetId
          ? null
          : (lastLinkedProphetId ?? this.lastLinkedProphetId),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateKey': dateKey,
      'cardOpened': cardOpened,
      'quizAnswered': quizAnswered,
      'quizQuestionId': quizQuestionId,
      'quizSelectedIndex': quizSelectedIndex,
      'quizCorrect': quizCorrect,
      'lastLinkedProphetId': lastLinkedProphetId,
    };
  }

  static DailyLearningDayStatus fromJson(Map<String, dynamic> json) {
    return DailyLearningDayStatus(
      dateKey: json['dateKey']?.toString() ?? '',
      cardOpened: json['cardOpened'] == true,
      quizAnswered: json['quizAnswered'] == true,
      quizQuestionId: json['quizQuestionId']?.toString(),
      quizSelectedIndex: int.tryParse(
        json['quizSelectedIndex']?.toString() ?? '',
      ),
      quizCorrect: json['quizCorrect'] is bool
          ? json['quizCorrect'] as bool
          : null,
      lastLinkedProphetId: json['lastLinkedProphetId']?.toString(),
    );
  }
}
