import '../../../learn/quran/domain/quran_content_refs.dart';
import 'bedtime_story_illustration_models.dart';

enum BedtimeStoryCategory {
  prophets,
  companions,
  characterAdab,
  dailyLifeDuas,
  ramadanEid,
  familyKindness,
}

enum KidsIslamicStoryCollectionType {
  prophets,
  companions,
  characterAdab,
  dailyLifeDuas,
  ramadanEid,
  familyKindness,
  bedtime,
}

enum KidsIslamicStoryType {
  prophet,
  companion,
  adab,
  duaLesson,
  dailyLife,
  seerahKids,
  ramadan,
  eid,
  masjid,
  kindness,
  honesty,
  patience,
  gratitude,
  family,
  forgiveness,
  animals,
}

enum KidsIslamicStoryTheme {
  trustInAllah,
  kindness,
  honesty,
  patience,
  gratitude,
  family,
  sharing,
  helpingOthers,
  manners,
  dua,
  forgiveness,
  masjid,
  ramadan,
  eid,
  compassionForAnimals,
  truthfulness,
}

enum KidsIslamicStorySourceCategory {
  quran,
  hadith,
  seerahInspired,
  islamicManners,
}

enum BedtimeStoryAgeGroup { kidsEarly, kids, kidsPlus }

enum BedtimeStoryCompletionState { notStarted, inProgress, completed }

enum BedtimeStoryPlaybackSource { asset, remote, missingAsset }

class BedtimeStorySeed {
  const BedtimeStorySeed({
    required this.id,
    this.prophetId = '',
    required this.title,
    required this.shortTitle,
    required this.category,
    this.collectionType = KidsIslamicStoryCollectionType.prophets,
    this.storyType = KidsIslamicStoryType.prophet,
    this.themes = const <KidsIslamicStoryTheme>[],
    required this.ageGroup,
    this.summary = '',
    required this.audioFileName,
    this.audioManifestRef = '',
    required this.ttsText,
    required this.lesson,
    this.quranQuote,
    this.quranReference,
    this.quranQuoteRef,
    this.hadithQuote,
    this.hadithReference,
    this.sourceCategory = KidsIslamicStorySourceCategory.quran,
    this.sourceNote,
    required this.estimatedDurationSeconds,
    required this.isFeatured,
    required this.isMultipart,
    required this.partNumber,
    required this.totalParts,
    required this.tags,
    required this.sortOrder,
    required this.coverAssetPath,
    required this.backdropAssetPath,
    required this.narratorDisplayName,
    required this.isLocked,
    required this.unlockXp,
    required this.oceanDropsReward,
    required this.xpReward,
    required this.isDownloadedByDefault,
    required this.isAvailableOffline,
    required this.recommendedForTonight,
    required this.relatedStoryIds,
    this.storyFamilyId = '',
    this.sceneSeedRef,
    this.quizRefs = const <String>[],
    this.memoryRefs = const <String>[],
    this.bedtimeEligible = true,
    this.routineEligible = true,
    this.quietReflectionFriendly = true,
    this.suitableForYoungerLearners = false,
    this.sceneIllustrations = const <BedtimeStorySceneIllustration>[],
  });

  final String id;
  final String prophetId;
  final String storyFamilyId;
  final String title;
  final String shortTitle;
  final BedtimeStoryCategory category;
  final KidsIslamicStoryCollectionType collectionType;
  final KidsIslamicStoryType storyType;
  final List<KidsIslamicStoryTheme> themes;
  final BedtimeStoryAgeGroup ageGroup;
  final String summary;
  final String audioFileName;
  final String audioManifestRef;
  final String ttsText;
  final String lesson;
  final String? quranQuote;
  final String? quranReference;
  final QuranQuoteRef? quranQuoteRef;
  final String? hadithQuote;
  final String? hadithReference;
  final KidsIslamicStorySourceCategory sourceCategory;
  final String? sourceNote;
  final int estimatedDurationSeconds;
  final bool isFeatured;
  final bool isMultipart;
  final int partNumber;
  final int totalParts;
  final List<String> tags;
  final int sortOrder;
  final String coverAssetPath;
  final String backdropAssetPath;
  final String narratorDisplayName;
  final bool isLocked;
  final int unlockXp;
  final int oceanDropsReward;
  final int xpReward;
  final bool isDownloadedByDefault;
  final bool isAvailableOffline;
  final bool recommendedForTonight;
  final List<String> relatedStoryIds;
  final String? sceneSeedRef;
  final List<String> quizRefs;
  final List<String> memoryRefs;
  final bool bedtimeEligible;
  final bool routineEligible;
  final bool quietReflectionFriendly;
  final bool suitableForYoungerLearners;
  final List<BedtimeStorySceneIllustration> sceneIllustrations;

  Duration get estimatedDuration => Duration(seconds: estimatedDurationSeconds);
  String get effectiveStoryFamilyId => storyFamilyId.isNotEmpty
      ? storyFamilyId
      : (prophetId.isNotEmpty ? prophetId : id);
  bool get isProphetStory => storyType == KidsIslamicStoryType.prophet;
  bool get hasQuranReference =>
      (quranQuote ?? '').isNotEmpty &&
      (quranReference ?? '').isNotEmpty &&
      quranQuoteRef != null;
  bool get hasHadithReference =>
      (hadithQuote ?? '').isNotEmpty && (hadithReference ?? '').isNotEmpty;

  BedtimeStorySeed copyWith({
    String? title,
    String? shortTitle,
    String? summary,
    String? lesson,
    String? sourceNote,
    bool clearSourceNote = false,
    List<String>? tags,
  }) {
    return BedtimeStorySeed(
      id: id,
      prophetId: prophetId,
      title: title ?? this.title,
      shortTitle: shortTitle ?? this.shortTitle,
      category: category,
      collectionType: collectionType,
      storyType: storyType,
      themes: themes,
      ageGroup: ageGroup,
      summary: summary ?? this.summary,
      audioFileName: audioFileName,
      audioManifestRef: audioManifestRef,
      ttsText: ttsText,
      lesson: lesson ?? this.lesson,
      quranQuote: quranQuote,
      quranReference: quranReference,
      quranQuoteRef: quranQuoteRef,
      hadithQuote: hadithQuote,
      hadithReference: hadithReference,
      sourceCategory: sourceCategory,
      sourceNote: clearSourceNote ? null : sourceNote ?? this.sourceNote,
      estimatedDurationSeconds: estimatedDurationSeconds,
      isFeatured: isFeatured,
      isMultipart: isMultipart,
      partNumber: partNumber,
      totalParts: totalParts,
      tags: tags ?? this.tags,
      sortOrder: sortOrder,
      coverAssetPath: coverAssetPath,
      backdropAssetPath: backdropAssetPath,
      narratorDisplayName: narratorDisplayName,
      isLocked: isLocked,
      unlockXp: unlockXp,
      oceanDropsReward: oceanDropsReward,
      xpReward: xpReward,
      isDownloadedByDefault: isDownloadedByDefault,
      isAvailableOffline: isAvailableOffline,
      recommendedForTonight: recommendedForTonight,
      relatedStoryIds: relatedStoryIds,
      storyFamilyId: storyFamilyId,
      sceneSeedRef: sceneSeedRef,
      quizRefs: quizRefs,
      memoryRefs: memoryRefs,
      bedtimeEligible: bedtimeEligible,
      routineEligible: routineEligible,
      quietReflectionFriendly: quietReflectionFriendly,
      suitableForYoungerLearners: suitableForYoungerLearners,
      sceneIllustrations: sceneIllustrations,
    );
  }
}

class BedtimeStoryProgress {
  const BedtimeStoryProgress({
    this.currentPositionMs = 0,
    this.totalDurationMs = 0,
    this.totalListenedMs = 0,
    this.startedAtIso,
    this.lastAccessedAtIso,
    this.lastPlayedAtIso,
    this.completedAtIso,
    this.completionRewardGrantedAtIso,
    this.lastPlaybackSource,
  });

  final int currentPositionMs;
  final int totalDurationMs;
  final int totalListenedMs;
  final String? startedAtIso;
  final String? lastAccessedAtIso;
  final String? lastPlayedAtIso;
  final String? completedAtIso;
  final String? completionRewardGrantedAtIso;
  final BedtimeStoryPlaybackSource? lastPlaybackSource;

  BedtimeStoryCompletionState get completionState {
    if ((completedAtIso ?? '').isNotEmpty) {
      return BedtimeStoryCompletionState.completed;
    }
    if ((startedAtIso ?? '').isNotEmpty || currentPositionMs > 0) {
      return BedtimeStoryCompletionState.inProgress;
    }
    return BedtimeStoryCompletionState.notStarted;
  }

  bool get isCompleted =>
      completionState == BedtimeStoryCompletionState.completed;
  bool get hasCompletionRewardGranted =>
      (completionRewardGrantedAtIso ?? '').isNotEmpty;
  bool get hasProgress => currentPositionMs > 0 || totalListenedMs > 0;

  BedtimeStoryProgress copyWith({
    int? currentPositionMs,
    int? totalDurationMs,
    int? totalListenedMs,
    String? startedAtIso,
    bool clearStartedAtIso = false,
    String? lastAccessedAtIso,
    String? lastPlayedAtIso,
    String? completedAtIso,
    bool clearCompletedAtIso = false,
    String? completionRewardGrantedAtIso,
    bool clearCompletionRewardGrantedAtIso = false,
    BedtimeStoryPlaybackSource? lastPlaybackSource,
  }) {
    return BedtimeStoryProgress(
      currentPositionMs: currentPositionMs ?? this.currentPositionMs,
      totalDurationMs: totalDurationMs ?? this.totalDurationMs,
      totalListenedMs: totalListenedMs ?? this.totalListenedMs,
      startedAtIso: clearStartedAtIso
          ? null
          : (startedAtIso ?? this.startedAtIso),
      lastAccessedAtIso: lastAccessedAtIso ?? this.lastAccessedAtIso,
      lastPlayedAtIso: lastPlayedAtIso ?? this.lastPlayedAtIso,
      completedAtIso: clearCompletedAtIso
          ? null
          : (completedAtIso ?? this.completedAtIso),
      completionRewardGrantedAtIso: clearCompletionRewardGrantedAtIso
          ? null
          : (completionRewardGrantedAtIso ?? this.completionRewardGrantedAtIso),
      lastPlaybackSource: lastPlaybackSource ?? this.lastPlaybackSource,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'currentPositionMs': currentPositionMs,
    'totalDurationMs': totalDurationMs,
    'totalListenedMs': totalListenedMs,
    'startedAtIso': startedAtIso,
    'lastAccessedAtIso': lastAccessedAtIso,
    'lastPlayedAtIso': lastPlayedAtIso,
    'completedAtIso': completedAtIso,
    'completionRewardGrantedAtIso': completionRewardGrantedAtIso,
    'lastPlaybackSource': lastPlaybackSource?.name,
  };

  static BedtimeStoryProgress fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const BedtimeStoryProgress();
    }
    return BedtimeStoryProgress(
      currentPositionMs: (json['currentPositionMs'] as num?)?.toInt() ?? 0,
      totalDurationMs: (json['totalDurationMs'] as num?)?.toInt() ?? 0,
      totalListenedMs: (json['totalListenedMs'] as num?)?.toInt() ?? 0,
      startedAtIso: json['startedAtIso']?.toString(),
      lastAccessedAtIso: json['lastAccessedAtIso']?.toString(),
      lastPlayedAtIso: json['lastPlayedAtIso']?.toString(),
      completedAtIso: json['completedAtIso']?.toString(),
      completionRewardGrantedAtIso: json['completionRewardGrantedAtIso']
          ?.toString(),
      lastPlaybackSource: _playbackSourceFromString(
        json['lastPlaybackSource']?.toString(),
      ),
    );
  }

  static BedtimeStoryPlaybackSource? _playbackSourceFromString(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    for (final source in BedtimeStoryPlaybackSource.values) {
      if (source.name == value) {
        return source;
      }
    }
    return null;
  }
}

class BedtimeStoryLibraryProgress {
  const BedtimeStoryLibraryProgress({
    this.storyProgressById = const <String, BedtimeStoryProgress>{},
    this.recentStoryIds = const <String>[],
    this.completedSeriesProphetIds = const <String>{},
  });

  final Map<String, BedtimeStoryProgress> storyProgressById;
  final List<String> recentStoryIds;
  final Set<String> completedSeriesProphetIds;

  BedtimeStoryLibraryProgress copyWith({
    Map<String, BedtimeStoryProgress>? storyProgressById,
    List<String>? recentStoryIds,
    Set<String>? completedSeriesProphetIds,
  }) {
    return BedtimeStoryLibraryProgress(
      storyProgressById: storyProgressById ?? this.storyProgressById,
      recentStoryIds: recentStoryIds ?? this.recentStoryIds,
      completedSeriesProphetIds:
          completedSeriesProphetIds ?? this.completedSeriesProphetIds,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'storyProgressById': storyProgressById.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
    'recentStoryIds': recentStoryIds,
    'completedSeriesProphetIds': completedSeriesProphetIds.toList(
      growable: false,
    ),
  };

  static BedtimeStoryLibraryProgress fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const BedtimeStoryLibraryProgress();
    }
    final rawProgress = json['storyProgressById'];
    final progressById = <String, BedtimeStoryProgress>{};
    if (rawProgress is Map) {
      for (final entry in rawProgress.entries) {
        progressById[entry.key.toString()] = BedtimeStoryProgress.fromJson(
          entry.value is Map<String, dynamic>
              ? entry.value as Map<String, dynamic>
              : (entry.value as Map?)?.map(
                  (key, value) => MapEntry(key.toString(), value),
                ),
        );
      }
    }
    final recent =
        (json['recentStoryIds'] as List?)
            ?.map((item) => item.toString())
            .toList(growable: false) ??
        const <String>[];
    final completedSeries =
        (json['completedSeriesProphetIds'] as List?)
            ?.map((item) => item.toString())
            .toSet() ??
        const <String>{};
    return BedtimeStoryLibraryProgress(
      storyProgressById: progressById,
      recentStoryIds: recent,
      completedSeriesProphetIds: completedSeries,
    );
  }
}

class BedtimeStoryAudioState {
  const BedtimeStoryAudioState({
    this.currentStoryId,
    this.playbackSource = BedtimeStoryPlaybackSource.missingAsset,
    this.currentPosition = Duration.zero,
    this.totalDuration = Duration.zero,
    this.isPlaying = false,
    this.isLoading = false,
    this.isCompleted = false,
    this.lastPlayedAtIso,
    this.errorMessage,
    this.isAssetAvailable = false,
  });

  final String? currentStoryId;
  final BedtimeStoryPlaybackSource playbackSource;
  final Duration currentPosition;
  final Duration totalDuration;
  final bool isPlaying;
  final bool isLoading;
  final bool isCompleted;
  final String? lastPlayedAtIso;
  final String? errorMessage;
  final bool isAssetAvailable;

  BedtimeStoryAudioState copyWith({
    String? currentStoryId,
    bool clearCurrentStoryId = false,
    BedtimeStoryPlaybackSource? playbackSource,
    Duration? currentPosition,
    Duration? totalDuration,
    bool? isPlaying,
    bool? isLoading,
    bool? isCompleted,
    String? lastPlayedAtIso,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? isAssetAvailable,
  }) {
    return BedtimeStoryAudioState(
      currentStoryId: clearCurrentStoryId
          ? null
          : (currentStoryId ?? this.currentStoryId),
      playbackSource: playbackSource ?? this.playbackSource,
      currentPosition: currentPosition ?? this.currentPosition,
      totalDuration: totalDuration ?? this.totalDuration,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      isCompleted: isCompleted ?? this.isCompleted,
      lastPlayedAtIso: lastPlayedAtIso ?? this.lastPlayedAtIso,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      isAssetAvailable: isAssetAvailable ?? this.isAssetAvailable,
    );
  }
}

class BedtimeStoryCompletionOutcome {
  const BedtimeStoryCompletionOutcome({
    required this.firstCompletion,
    required this.xpAwarded,
    required this.dropsAwarded,
    required this.seriesCompleted,
  });

  final bool firstCompletion;
  final int xpAwarded;
  final int dropsAwarded;
  final bool seriesCompleted;
}
