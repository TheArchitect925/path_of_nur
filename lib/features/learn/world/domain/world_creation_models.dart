enum WorldCreationCategoryId {
  universeSpace,
  earthNature,
  oceansWater,
  animalsLiving,
  humanCreation,
  timeCycles,
  weatherPhenomena,
  mountainsGeography,
  plantsSustenance,
  reflectionSigns,
  exploreCreation,
  muslimScientists,
}

enum WorldCreationDepth { beginner, intermediate, deep }

class VerseContent {
  const VerseContent({
    required this.surahNumber,
    required this.surahName,
    required this.ayahStart,
    required this.ayahEnd,
    required this.translationSource,
  });

  final int surahNumber;
  final String surahName;
  final int ayahStart;
  final int ayahEnd;
  final String translationSource;

  String get referenceLabel => ayahStart == ayahEnd
      ? '$surahNumber:$ayahStart'
      : '$surahNumber:$ayahStart-$ayahEnd';
}

class ScienceTimelinePoint {
  const ScienceTimelinePoint({
    required this.title,
    required this.period,
    required this.note,
  });

  final String title;
  final String period;
  final String note;
}

class ScienceLensContent {
  const ScienceLensContent({
    required this.title,
    required this.summary,
    required this.explanation,
    required this.timelinePoints,
    required this.cautionNote,
    required this.diagramHint,
    this.sourceLabels = const <String>[],
  });

  final String title;
  final String summary;
  final String explanation;
  final List<ScienceTimelinePoint> timelinePoints;
  final String cautionNote;
  final String diagramHint;
  final List<String> sourceLabels;
}

class WorldCreationLesson {
  const WorldCreationLesson({
    required this.id,
    required this.title,
    required this.slug,
    required this.category,
    required this.summary,
    required this.quranVerses,
    required this.quranObservation,
    required this.scienceLens,
    required this.reflection,
    required this.observationPrompt,
    required this.tags,
    required this.visualAssetKey,
    required this.depth,
    required this.relatedLessonIds,
    required this.featured,
    required this.sortOrder,
  });

  final String id;
  final String title;
  final String slug;
  final WorldCreationCategoryId category;
  final String summary;
  final List<VerseContent> quranVerses;
  final String quranObservation;
  final ScienceLensContent scienceLens;
  final String reflection;
  final String observationPrompt;
  final List<String> tags;
  final String visualAssetKey;
  final WorldCreationDepth depth;
  final List<String> relatedLessonIds;
  final bool featured;
  final int sortOrder;
}

class WorldCreationCategory {
  const WorldCreationCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.featuredVerse,
    required this.lessonIds,
    required this.icon,
    required this.sortOrder,
  });

  final WorldCreationCategoryId id;
  final String title;
  final String description;
  final VerseContent featuredVerse;
  final List<String> lessonIds;
  final String icon;
  final int sortOrder;
}

class ObservationChallenge {
  const ObservationChallenge({
    required this.id,
    required this.title,
    required this.category,
    required this.prompt,
    required this.verseReference,
    required this.reflectionPrompt,
    required this.xpReward,
    required this.seasonalTag,
    required this.timeOfDayTag,
    required this.featured,
  });

  final String id;
  final String title;
  final WorldCreationCategoryId category;
  final String prompt;
  final VerseContent verseReference;
  final String reflectionPrompt;
  final int xpReward;
  final String seasonalTag;
  final String timeOfDayTag;
  final bool featured;
}

class CreationObservation {
  const CreationObservation({
    required this.id,
    required this.imagePath,
    required this.category,
    required this.verseReference,
    required this.verseTextSnapshot,
    required this.userReflection,
    required this.createdAtIso,
    required this.optionalLocationName,
    required this.tags,
    required this.challengeId,
    required this.isFavorite,
  });

  final String id;
  final String? imagePath;
  final WorldCreationCategoryId category;
  final String verseReference;
  final String verseTextSnapshot;
  final String userReflection;
  final String createdAtIso;
  final String? optionalLocationName;
  final List<String> tags;
  final String? challengeId;
  final bool isFavorite;

  CreationObservation copyWith({
    String? imagePath,
    WorldCreationCategoryId? category,
    String? verseReference,
    String? verseTextSnapshot,
    String? userReflection,
    String? createdAtIso,
    String? optionalLocationName,
    List<String>? tags,
    String? challengeId,
    bool? isFavorite,
  }) {
    return CreationObservation(
      id: id,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      verseReference: verseReference ?? this.verseReference,
      verseTextSnapshot: verseTextSnapshot ?? this.verseTextSnapshot,
      userReflection: userReflection ?? this.userReflection,
      createdAtIso: createdAtIso ?? this.createdAtIso,
      optionalLocationName: optionalLocationName ?? this.optionalLocationName,
      tags: tags ?? this.tags,
      challengeId: challengeId ?? this.challengeId,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'imagePath': imagePath,
    'category': category.name,
    'verseReference': verseReference,
    'verseTextSnapshot': verseTextSnapshot,
    'userReflection': userReflection,
    'createdAtIso': createdAtIso,
    'optionalLocationName': optionalLocationName,
    'tags': tags,
    'challengeId': challengeId,
    'isFavorite': isFavorite,
  };

  static CreationObservation? fromJson(dynamic raw) {
    if (raw is! Map) return null;
    final id = raw['id']?.toString();
    final categoryName = raw['category']?.toString();
    final verseReference = raw['verseReference']?.toString();
    final verseTextSnapshot = raw['verseTextSnapshot']?.toString();
    final userReflection = raw['userReflection']?.toString();
    final createdAtIso = raw['createdAtIso']?.toString();
    if (id == null ||
        categoryName == null ||
        verseReference == null ||
        verseTextSnapshot == null ||
        userReflection == null ||
        createdAtIso == null) {
      return null;
    }

    final category = WorldCreationCategoryId.values.firstWhere(
      (item) => item.name == categoryName,
      orElse: () => WorldCreationCategoryId.reflectionSigns,
    );

    final tags = <String>[];
    final rawTags = raw['tags'];
    if (rawTags is List) {
      for (final tag in rawTags) {
        final parsed = tag.toString().trim();
        if (parsed.isNotEmpty) tags.add(parsed);
      }
    }

    return CreationObservation(
      id: id,
      imagePath: raw['imagePath']?.toString(),
      category: category,
      verseReference: verseReference,
      verseTextSnapshot: verseTextSnapshot,
      userReflection: userReflection,
      createdAtIso: createdAtIso,
      optionalLocationName: raw['optionalLocationName']?.toString(),
      tags: tags,
      challengeId: raw['challengeId']?.toString(),
      isFavorite: raw['isFavorite'] == true,
    );
  }
}

class ScientistProfile {
  const ScientistProfile({
    required this.id,
    required this.name,
    required this.era,
    required this.discipline,
    required this.summary,
    required this.contributionHighlights,
    required this.whyItMatters,
    required this.relatedTopics,
    required this.visualAssetKey,
  });

  final String id;
  final String name;
  final String era;
  final String discipline;
  final String summary;
  final List<String> contributionHighlights;
  final String whyItMatters;
  final List<String> relatedTopics;
  final String visualAssetKey;
}

class WorldDailySign {
  const WorldDailySign({
    required this.lessonId,
    required this.verse,
    required this.reflection,
    required this.prompt,
  });

  final String lessonId;
  final VerseContent verse;
  final String reflection;
  final String prompt;
}

class WorldCreationProgressState {
  const WorldCreationProgressState({
    required this.completedLessonIds,
    required this.savedLessonIds,
    required this.completedChallengeIds,
    required this.recentLessonIds,
    required this.observations,
    required this.guidedModeSessions,
    required this.nightModeSessions,
  });

  final Set<String> completedLessonIds;
  final Set<String> savedLessonIds;
  final Set<String> completedChallengeIds;
  final List<String> recentLessonIds;
  final List<CreationObservation> observations;
  final int guidedModeSessions;
  final int nightModeSessions;

  WorldCreationProgressState copyWith({
    Set<String>? completedLessonIds,
    Set<String>? savedLessonIds,
    Set<String>? completedChallengeIds,
    List<String>? recentLessonIds,
    List<CreationObservation>? observations,
    int? guidedModeSessions,
    int? nightModeSessions,
  }) {
    return WorldCreationProgressState(
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      savedLessonIds: savedLessonIds ?? this.savedLessonIds,
      completedChallengeIds:
          completedChallengeIds ?? this.completedChallengeIds,
      recentLessonIds: recentLessonIds ?? this.recentLessonIds,
      observations: observations ?? this.observations,
      guidedModeSessions: guidedModeSessions ?? this.guidedModeSessions,
      nightModeSessions: nightModeSessions ?? this.nightModeSessions,
    );
  }

  Map<String, dynamic> toJson() => {
    'completedLessonIds': completedLessonIds.toList(growable: false),
    'savedLessonIds': savedLessonIds.toList(growable: false),
    'completedChallengeIds': completedChallengeIds.toList(growable: false),
    'recentLessonIds': recentLessonIds,
    'observations': observations
        .map((item) => item.toJson())
        .toList(growable: false),
    'guidedModeSessions': guidedModeSessions,
    'nightModeSessions': nightModeSessions,
  };

  static WorldCreationProgressState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const WorldCreationProgressState(
        completedLessonIds: <String>{},
        savedLessonIds: <String>{},
        completedChallengeIds: <String>{},
        recentLessonIds: <String>[],
        observations: <CreationObservation>[],
        guidedModeSessions: 0,
        nightModeSessions: 0,
      );
    }

    Set<String> toSet(String key) {
      final raw = json[key];
      if (raw is! List) return <String>{};
      return raw
          .map((item) => item.toString())
          .where((e) => e.isNotEmpty)
          .toSet();
    }

    List<String> toList(String key) {
      final raw = json[key];
      if (raw is! List) return const <String>[];
      return raw
          .map((item) => item.toString())
          .where((e) => e.isNotEmpty)
          .toList(growable: false);
    }

    final observations = <CreationObservation>[];
    final rawObservations = json['observations'];
    if (rawObservations is List) {
      for (final row in rawObservations) {
        final parsed = CreationObservation.fromJson(row);
        if (parsed != null) observations.add(parsed);
      }
    }

    return WorldCreationProgressState(
      completedLessonIds: toSet('completedLessonIds'),
      savedLessonIds: toSet('savedLessonIds'),
      completedChallengeIds: toSet('completedChallengeIds'),
      recentLessonIds: toList('recentLessonIds'),
      observations: observations,
      guidedModeSessions: (json['guidedModeSessions'] as num?)?.toInt() ?? 0,
      nightModeSessions: (json['nightModeSessions'] as num?)?.toInt() ?? 0,
    );
  }
}
