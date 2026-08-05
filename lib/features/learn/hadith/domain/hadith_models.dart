enum HadithLessonStatus { notStarted, inProgress, completed }

class HadithComparativeInsight {
  const HadithComparativeInsight({
    required this.tradition,
    required this.themeSummary,
    this.referenceNote,
  });

  final String tradition;
  final String themeSummary;
  final String? referenceNote;
}

class HadithLesson {
  const HadithLesson({
    required this.id,
    required this.themeId,
    required this.subcategoryId,
    required this.title,
    required this.subtitle,
    required this.overview,
    required this.hadithPerspective,
    required this.quranicConnection,
    required this.practicalTakeaway,
    required this.keyConcepts,
    required this.reflectionPrompt,
    required this.relatedLessonIds,
    required this.comparativeInsights,
    required this.order,
  });

  final String id;
  final String themeId;
  final String subcategoryId;
  final String title;
  final String subtitle;
  final String overview;
  final String hadithPerspective;
  final String quranicConnection;
  final String practicalTakeaway;
  final List<String> keyConcepts;
  final String reflectionPrompt;
  final List<String> relatedLessonIds;
  final List<HadithComparativeInsight> comparativeInsights;
  final int order;
}

class HadithSubcategory {
  const HadithSubcategory({
    required this.id,
    required this.themeId,
    required this.title,
    required this.summary,
    required this.lessonIds,
    required this.order,
  });

  final String id;
  final String themeId;
  final String title;
  final String summary;
  final List<String> lessonIds;
  final int order;
}

class HadithTheme {
  const HadithTheme({
    required this.id,
    required this.title,
    required this.summary,
    required this.whyItMatters,
    required this.subcategoryIds,
    required this.relatedThemeIds,
    required this.order,
  });

  final String id;
  final String title;
  final String summary;
  final String whyItMatters;
  final List<String> subcategoryIds;
  final List<String> relatedThemeIds;
  final int order;
}

class HadithCurriculum {
  const HadithCurriculum({
    required this.themes,
    required this.subcategories,
    required this.lessons,
    required this.suggestedThemeOrder,
    required this.featuredLessonId,
  });

  final List<HadithTheme> themes;
  final List<HadithSubcategory> subcategories;
  final List<HadithLesson> lessons;
  final List<String> suggestedThemeOrder;
  final String featuredLessonId;
}

class HadithLessonProgress {
  const HadithLessonProgress({
    required this.lessonId,
    required this.status,
    required this.lastOpenedIso,
    required this.completedIso,
    required this.openCount,
  });

  final String lessonId;
  final HadithLessonStatus status;
  final String? lastOpenedIso;
  final String? completedIso;
  final int openCount;

  HadithLessonProgress copyWith({
    HadithLessonStatus? status,
    String? lastOpenedIso,
    String? completedIso,
    int? openCount,
  }) {
    return HadithLessonProgress(
      lessonId: lessonId,
      status: status ?? this.status,
      lastOpenedIso: lastOpenedIso ?? this.lastOpenedIso,
      completedIso: completedIso ?? this.completedIso,
      openCount: openCount ?? this.openCount,
    );
  }

  Map<String, dynamic> toJson() => {
    'lessonId': lessonId,
    'status': status.name,
    'lastOpenedIso': lastOpenedIso,
    'completedIso': completedIso,
    'openCount': openCount,
  };

  static HadithLessonProgress? fromJson(dynamic raw) {
    if (raw is! Map) return null;
    final lessonId = raw['lessonId']?.toString();
    final statusName = raw['status']?.toString();
    if (lessonId == null || statusName == null) return null;

    HadithLessonStatus? status;
    for (final item in HadithLessonStatus.values) {
      if (item.name == statusName) {
        status = item;
        break;
      }
    }
    if (status == null) return null;

    return HadithLessonProgress(
      lessonId: lessonId,
      status: status,
      lastOpenedIso: raw['lastOpenedIso']?.toString(),
      completedIso: raw['completedIso']?.toString(),
      openCount: (raw['openCount'] as num?)?.toInt() ?? 0,
    );
  }
}
