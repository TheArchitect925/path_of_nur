import '../../presentation/models/learn_category_item.dart';

enum LearnUnifiedDomain {
  quran,
  hadith,
  prophets,
  lifeLessons,
  salah,
  namesOfAllah,
  babyNames,
  quizzes,
  notes,
}

enum LearnItemType {
  verse,
  hadith,
  prophet,
  lifeLesson,
  salahPrayer,
  surah,
  recitation,
  name,
  babyName,
  quiz,
  note,
  reflection,
  pathStep,
}

enum LearnDifficulty { beginner, intermediate, advanced }

enum LearnRelationType {
  supports,
  explains,
  expands,
  relatedTheme,
  sameTopic,
  sameProphet,
  practiceRelated,
  dailyCandidate,
}

class LearnUnifiedContentItem {
  const LearnUnifiedContentItem({
    required this.id,
    required this.type,
    required this.domain,
    required this.title,
    required this.subtitle,
    required this.summary,
    required this.tags,
    required this.themeIds,
    required this.difficulty,
    required this.estimatedReadMinutes,
    required this.relatedItemIds,
    required this.reflectionPrompts,
    required this.practiceActions,
    required this.isFeatured,
    required this.isDailyEligible,
    this.routeName,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
  });

  final String id;
  final LearnItemType type;
  final LearnUnifiedDomain domain;
  final String title;
  final String subtitle;
  final String summary;
  final List<String> tags;
  final List<String> themeIds;
  final LearnDifficulty difficulty;
  final int estimatedReadMinutes;
  final List<String> relatedItemIds;
  final List<String> reflectionPrompts;
  final List<String> practiceActions;
  final bool isFeatured;
  final bool isDailyEligible;
  final String? routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
}

class LearnSharedTheme {
  const LearnSharedTheme({
    required this.id,
    required this.label,
    required this.summary,
  });

  final String id;
  final String label;
  final String summary;
}

class LearnUnifiedPathStep {
  const LearnUnifiedPathStep({
    required this.id,
    required this.itemId,
    required this.label,
    required this.type,
  });

  final String id;
  final String itemId;
  final String label;
  final LearnItemType type;
}

class LearnUnifiedPath {
  const LearnUnifiedPath({
    required this.id,
    required this.title,
    required this.summary,
    required this.themeIds,
    required this.steps,
  });

  final String id;
  final String title;
  final String summary;
  final List<String> themeIds;
  final List<LearnUnifiedPathStep> steps;
}

class LearnDailyItemSelection {
  const LearnDailyItemSelection({
    required this.dateKey,
    required this.item,
    required this.theme,
  });

  final String dateKey;
  final LearnUnifiedContentItem item;
  final LearnSharedTheme theme;
}

class LearnUnifiedRelation {
  const LearnUnifiedRelation({
    required this.fromItemId,
    required this.toItemId,
    required this.type,
  });

  final String fromItemId;
  final String toItemId;
  final LearnRelationType type;
}

class LearnUnifiedProgressState {
  const LearnUnifiedProgressState({
    required this.startedIds,
    required this.completedIds,
    required this.savedIds,
    required this.reflectedIds,
    required this.practicedIds,
    required this.reviewedIds,
    required this.memorizedIds,
    required this.lastUpdatedIsoByItemId,
    required this.notesByItemId,
  });

  final Set<String> startedIds;
  final Set<String> completedIds;
  final Set<String> savedIds;
  final Set<String> reflectedIds;
  final Set<String> practicedIds;
  final Set<String> reviewedIds;
  final Set<String> memorizedIds;
  final Map<String, String> lastUpdatedIsoByItemId;
  final Map<String, String> notesByItemId;

  LearnUnifiedProgressState copyWith({
    Set<String>? startedIds,
    Set<String>? completedIds,
    Set<String>? savedIds,
    Set<String>? reflectedIds,
    Set<String>? practicedIds,
    Set<String>? reviewedIds,
    Set<String>? memorizedIds,
    Map<String, String>? lastUpdatedIsoByItemId,
    Map<String, String>? notesByItemId,
  }) {
    return LearnUnifiedProgressState(
      startedIds: startedIds ?? this.startedIds,
      completedIds: completedIds ?? this.completedIds,
      savedIds: savedIds ?? this.savedIds,
      reflectedIds: reflectedIds ?? this.reflectedIds,
      practicedIds: practicedIds ?? this.practicedIds,
      reviewedIds: reviewedIds ?? this.reviewedIds,
      memorizedIds: memorizedIds ?? this.memorizedIds,
      lastUpdatedIsoByItemId:
          lastUpdatedIsoByItemId ?? this.lastUpdatedIsoByItemId,
      notesByItemId: notesByItemId ?? this.notesByItemId,
    );
  }

  Map<String, dynamic> toJson() => {
    'startedIds': startedIds.toList(growable: false),
    'completedIds': completedIds.toList(growable: false),
    'savedIds': savedIds.toList(growable: false),
    'reflectedIds': reflectedIds.toList(growable: false),
    'practicedIds': practicedIds.toList(growable: false),
    'reviewedIds': reviewedIds.toList(growable: false),
    'memorizedIds': memorizedIds.toList(growable: false),
    'lastUpdatedIsoByItemId': lastUpdatedIsoByItemId,
    'notesByItemId': notesByItemId,
  };

  static LearnUnifiedProgressState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const LearnUnifiedProgressState(
        startedIds: <String>{},
        completedIds: <String>{},
        savedIds: <String>{},
        reflectedIds: <String>{},
        practicedIds: <String>{},
        reviewedIds: <String>{},
        memorizedIds: <String>{},
        lastUpdatedIsoByItemId: <String, String>{},
        notesByItemId: <String, String>{},
      );
    }

    Set<String> toSet(String key) {
      final raw = json[key] as List<dynamic>? ?? const <dynamic>[];
      return raw.map((item) => item.toString()).toSet();
    }

    Map<String, String> toStringMap(String key) {
      final raw = json[key];
      if (raw is! Map) return const <String, String>{};
      final output = <String, String>{};
      for (final entry in raw.entries) {
        output[entry.key.toString()] = entry.value?.toString() ?? '';
      }
      return output;
    }

    return LearnUnifiedProgressState(
      startedIds: toSet('startedIds'),
      completedIds: toSet('completedIds'),
      savedIds: toSet('savedIds'),
      reflectedIds: toSet('reflectedIds'),
      practicedIds: toSet('practicedIds'),
      reviewedIds: toSet('reviewedIds'),
      memorizedIds: toSet('memorizedIds'),
      lastUpdatedIsoByItemId: toStringMap('lastUpdatedIsoByItemId'),
      notesByItemId: toStringMap('notesByItemId'),
    );
  }
}

class LearnSearchFilterState {
  const LearnSearchFilterState({
    this.query = '',
    this.type,
    this.themeId,
    this.savedOnly = false,
    this.difficulty,
    this.pathId,
  });

  final String query;
  final LearnItemType? type;
  final String? themeId;
  final bool savedOnly;
  final LearnDifficulty? difficulty;
  final String? pathId;

  LearnSearchFilterState copyWith({
    String? query,
    LearnItemType? type,
    bool clearType = false,
    String? themeId,
    bool clearTheme = false,
    bool? savedOnly,
    LearnDifficulty? difficulty,
    bool clearDifficulty = false,
    String? pathId,
    bool clearPath = false,
  }) {
    return LearnSearchFilterState(
      query: query ?? this.query,
      type: clearType ? null : (type ?? this.type),
      themeId: clearTheme ? null : (themeId ?? this.themeId),
      savedOnly: savedOnly ?? this.savedOnly,
      difficulty: clearDifficulty ? null : (difficulty ?? this.difficulty),
      pathId: clearPath ? null : (pathId ?? this.pathId),
    );
  }
}

class LearnUnifiedSummaryV2 {
  const LearnUnifiedSummaryV2({
    required this.continueItem,
    required this.dailyItem,
    required this.savedCount,
    required this.noteCount,
    required this.startedCount,
    required this.completedCount,
  });

  final LearnUnifiedContentItem? continueItem;
  final LearnDailyItemSelection dailyItem;
  final int savedCount;
  final int noteCount;
  final int startedCount;
  final int completedCount;
}

class LearnDomainCard {
  const LearnDomainCard({
    required this.domain,
    required this.title,
    required this.subtitle,
    required this.learnCategory,
  });

  final LearnUnifiedDomain domain;
  final String title;
  final String subtitle;
  final LearnCategoryItem learnCategory;
}
