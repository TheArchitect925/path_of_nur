import 'arabic_learning_continuity_models.dart';

enum ArabicLearningLessonPackType {
  letters,
  words,
  phrases,
  theme,
  reading,
  review,
  bridge,
  tajweedSupport,
}

class ArabicLearningLessonPack {
  const ArabicLearningLessonPack({
    required this.id,
    required this.audience,
    required this.type,
    required this.primaryTarget,
    required this.sortOrder,
    this.itemIds = const <String>[],
    this.searchKeywords = const <String>[],
    this.previewArabic = const <String>[],
    this.isRecommended = false,
  });

  final String id;
  final ArabicLearningAudience audience;
  final ArabicLearningLessonPackType type;
  final ArabicLearningRouteTarget primaryTarget;
  final int sortOrder;
  final List<String> itemIds;
  final List<String> searchKeywords;
  final List<String> previewArabic;
  final bool isRecommended;
}
