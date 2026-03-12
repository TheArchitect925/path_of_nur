class HadithLearningPathChapter {
  const HadithLearningPathChapter({
    required this.id,
    required this.title,
    required this.intro,
    required this.lessonIds,
    this.hasReviewShell = true,
  });

  final String id;
  final String title;
  final String intro;
  final List<String> lessonIds;
  final bool hasReviewShell;
}

class HadithLearningPath {
  const HadithLearningPath({
    required this.id,
    required this.title,
    this.subtitle,
    required this.description,
    required this.lessonIds,
    this.chapters = const <HadithLearningPathChapter>[],
  });

  final String id;
  final String title;
  final String? subtitle;
  final String description;
  final List<String> lessonIds;
  final List<HadithLearningPathChapter> chapters;
}
