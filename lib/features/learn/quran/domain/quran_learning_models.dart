class QuranLearningVerse {
  const QuranLearningVerse({
    required this.id,
    required this.surah,
    required this.ayah,
    required this.arabicText,
    required this.translation,
    required this.explanation,
    required this.lessons,
    required this.relatedHadith,
    required this.reflectionPrompts,
    this.pathIds = const <String>[],
    this.themeTag,
  });

  final String id;
  final int surah;
  final int ayah;
  final String arabicText;
  final String translation;
  final String explanation;
  final List<String> lessons;
  final List<String> relatedHadith;
  final List<String> reflectionPrompts;
  final List<String> pathIds;
  final String? themeTag;
}

enum MemorizationStage {
  newVerse,
  repeating,
  phrasePractice,
  hiddenRecall,
  mastered,
}

class MemorizationProgress {
  const MemorizationProgress({
    required this.verseId,
    required this.stage,
    required this.lastReviewed,
    required this.nextReview,
    this.reviewCount = 0,
  });

  final String verseId;
  final MemorizationStage stage;
  final DateTime? lastReviewed;
  final DateTime nextReview;
  final int reviewCount;

  MemorizationProgress copyWith({
    MemorizationStage? stage,
    DateTime? lastReviewed,
    DateTime? nextReview,
    int? reviewCount,
  }) {
    return MemorizationProgress(
      verseId: verseId,
      stage: stage ?? this.stage,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      nextReview: nextReview ?? this.nextReview,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  Map<String, dynamic> toJson() => {
    'verseId': verseId,
    'stage': stage.name,
    'lastReviewed': lastReviewed?.toIso8601String(),
    'nextReview': nextReview.toIso8601String(),
    'reviewCount': reviewCount,
  };

  static MemorizationProgress? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final verseId = json['verseId']?.toString();
    final nextReviewRaw = json['nextReview']?.toString();
    if (verseId == null || verseId.isEmpty || nextReviewRaw == null) {
      return null;
    }
    final nextReview = DateTime.tryParse(nextReviewRaw);
    if (nextReview == null) return null;

    final stageName = json['stage']?.toString();
    var stage = MemorizationStage.newVerse;
    for (final value in MemorizationStage.values) {
      if (value.name == stageName) {
        stage = value;
        break;
      }
    }

    return MemorizationProgress(
      verseId: verseId,
      stage: stage,
      lastReviewed: DateTime.tryParse(json['lastReviewed']?.toString() ?? ''),
      nextReview: nextReview,
      reviewCount: int.tryParse(json['reviewCount']?.toString() ?? '') ?? 0,
    );
  }
}

class QuranLearningPath {
  const QuranLearningPath({
    required this.id,
    required this.title,
    required this.description,
    required this.verseIds,
  });

  final String id;
  final String title;
  final String description;
  final List<String> verseIds;
}
