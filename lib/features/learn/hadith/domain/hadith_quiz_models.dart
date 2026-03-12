import 'hadith_foundation_models.dart';

enum HadithQuizQuestionType {
  multipleChoice,
  scenarioBased,
  fillInPhrase,
  quranConnection,
  reflection,
}

extension HadithQuizQuestionTypeLabel on HadithQuizQuestionType {
  String get label {
    switch (this) {
      case HadithQuizQuestionType.multipleChoice:
        return 'Multiple Choice';
      case HadithQuizQuestionType.scenarioBased:
        return 'Scenario';
      case HadithQuizQuestionType.fillInPhrase:
        return 'Fill-in Phrase';
      case HadithQuizQuestionType.quranConnection:
        return 'Qur\'an Connection';
      case HadithQuizQuestionType.reflection:
        return 'Reflection';
    }
  }
}

class HadithQuizQuestion {
  const HadithQuizQuestion({
    required this.id,
    required this.type,
    required this.text,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.lessonId,
  });

  final String id;
  final HadithQuizQuestionType type;
  final String text;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final String lessonId;
}

class HadithChapterQuiz {
  const HadithChapterQuiz({
    required this.id,
    required this.pathId,
    required this.chapterId,
    required this.title,
    required this.description,
    required this.questions,
    required this.quranReflection,
  });

  final String id;
  final String pathId;
  final String chapterId;
  final String title;
  final String description;
  final List<HadithQuizQuestion> questions;
  final QuranConnection quranReflection;
}

class HadithQuizSession {
  const HadithQuizSession({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.questions,
    required this.quranReflection,
    this.pathId,
    this.chapterId,
  });

  final String id;
  final String title;
  final String subtitle;
  final List<HadithQuizQuestion> questions;
  final QuranConnection quranReflection;
  final String? pathId;
  final String? chapterId;
}

class HadithReviewSchedule {
  const HadithReviewSchedule({
    required this.lessonId,
    required this.nextReviewDate,
    required this.intervalDays,
    required this.reviewCount,
  });

  final String lessonId;
  final DateTime nextReviewDate;
  final int intervalDays;
  final int reviewCount;

  HadithReviewSchedule copyWith({
    DateTime? nextReviewDate,
    int? intervalDays,
    int? reviewCount,
  }) {
    return HadithReviewSchedule(
      lessonId: lessonId,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      intervalDays: intervalDays ?? this.intervalDays,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  Map<String, dynamic> toJson() => {
    'lessonId': lessonId,
    'nextReviewDate': nextReviewDate.toIso8601String(),
    'intervalDays': intervalDays,
    'reviewCount': reviewCount,
  };

  static HadithReviewSchedule? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final lessonId = json['lessonId']?.toString();
    final nextReviewDateRaw = json['nextReviewDate']?.toString();
    if (lessonId == null || lessonId.isEmpty || nextReviewDateRaw == null) {
      return null;
    }
    final date = DateTime.tryParse(nextReviewDateRaw);
    if (date == null) return null;
    return HadithReviewSchedule(
      lessonId: lessonId,
      nextReviewDate: date,
      intervalDays: int.tryParse(json['intervalDays']?.toString() ?? '') ?? 1,
      reviewCount: int.tryParse(json['reviewCount']?.toString() ?? '') ?? 0,
    );
  }
}

class HadithQuizResultSummary {
  const HadithQuizResultSummary({
    required this.score,
    required this.total,
    required this.xpAwarded,
    required this.encouragement,
    required this.quranReflection,
    required this.chapterMilestoneUnlocked,
    required this.pathMilestoneUnlocked,
  });

  final int score;
  final int total;
  final int xpAwarded;
  final String encouragement;
  final QuranConnection quranReflection;
  final bool chapterMilestoneUnlocked;
  final bool pathMilestoneUnlocked;

  double get ratio {
    if (total <= 0) return 0;
    return (score / total).clamp(0.0, 1.0);
  }
}
