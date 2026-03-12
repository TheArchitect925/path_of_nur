class DivineLifeLesson {
  const DivineLifeLesson({
    required this.id,
    required this.title,
    required this.shortSummary,
    required this.themeId,
    required this.situationIds,
    required this.quranReference,
    required this.surahName,
    required this.surahNumber,
    required this.ayahStart,
    required this.ayahEnd,
    required this.reflection,
    required this.practicalTakeaway,
    required this.actionSteps,
    required this.reflectionPrompts,
    required this.tags,
    required this.relatedLessonIds,
    required this.estimatedReadMinutes,
    required this.featuredPriority,
    this.arabicText,
    this.translationText,
  });

  final String id;
  final String title;
  final String shortSummary;
  final String themeId;
  final List<String> situationIds;
  final String quranReference;
  final String surahName;
  final int surahNumber;
  final int ayahStart;
  final int ayahEnd;
  final String? arabicText;
  final String? translationText;
  final String reflection;
  final String practicalTakeaway;
  final List<String> actionSteps;
  final List<String> reflectionPrompts;
  final List<String> tags;
  final List<String> relatedLessonIds;
  final int estimatedReadMinutes;
  final int featuredPriority;
}

class DivineLifeTheme {
  const DivineLifeTheme({
    required this.id,
    required this.title,
    required this.description,
    required this.lessonIds,
    required this.sortOrder,
  });

  final String id;
  final String title;
  final String description;
  final List<String> lessonIds;
  final int sortOrder;
}

class DivineLifeSituation {
  const DivineLifeSituation({
    required this.id,
    required this.title,
    required this.description,
    required this.lessonIds,
    required this.sortOrder,
  });

  final String id;
  final String title;
  final String description;
  final List<String> lessonIds;
  final int sortOrder;
}

class DivineLifeNote {
  const DivineLifeNote({
    required this.lessonId,
    required this.noteText,
    required this.updatedAtIso,
  });

  final String lessonId;
  final String noteText;
  final String updatedAtIso;

  DivineLifeNote copyWith({
    String? noteText,
    String? updatedAtIso,
  }) {
    return DivineLifeNote(
      lessonId: lessonId,
      noteText: noteText ?? this.noteText,
      updatedAtIso: updatedAtIso ?? this.updatedAtIso,
    );
  }

  Map<String, dynamic> toJson() => {
    'lessonId': lessonId,
    'noteText': noteText,
    'updatedAtIso': updatedAtIso,
  };

  static DivineLifeNote? fromJson(dynamic raw) {
    if (raw is! Map) return null;
    final lessonId = raw['lessonId']?.toString();
    final noteText = raw['noteText']?.toString();
    final updatedAtIso = raw['updatedAtIso']?.toString();
    if (lessonId == null || noteText == null || updatedAtIso == null) {
      return null;
    }
    return DivineLifeNote(
      lessonId: lessonId,
      noteText: noteText,
      updatedAtIso: updatedAtIso,
    );
  }
}

class LearningModule {
  const LearningModule({
    required this.id,
    required this.title,
    required this.summary,
    required this.routeName,
  });

  final String id;
  final String title;
  final String summary;
  final String routeName;
}

class LearningItem {
  const LearningItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.routeName,
    required this.pathParameters,
    this.tags = const <String>[],
  });

  final String id;
  final String title;
  final String summary;
  final String routeName;
  final Map<String, String> pathParameters;
  final List<String> tags;
}

enum LearningContentView { lessons, themes, situations, reflection }
