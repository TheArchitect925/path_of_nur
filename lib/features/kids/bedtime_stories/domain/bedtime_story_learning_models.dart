import 'bedtime_story_models.dart';

enum BedtimeStoryLearningDifficulty { gentle, growing }

enum BedtimeStoryLearningMode {
  story,
  storyMode,
  quiz,
  memoryCards,
  recall,
  dailyLoop,
}

enum BedtimeStoryLearningCompletionState { notStarted, inProgress, completed }

enum BedtimeStoryQuizQuestionType {
  multipleChoice,
  trueFalse,
  recallChoice,
  memoryAssociation,
  sequenceOrdering,
}

class BedtimeStoryLearningRewardMetadata {
  const BedtimeStoryLearningRewardMetadata({
    required this.xpReward,
    required this.oceanDropsReward,
  });

  final int xpReward;
  final int oceanDropsReward;
}

class BedtimeStoryQuizOption {
  const BedtimeStoryQuizOption({required this.id, required this.text});

  final String id;
  final String text;
}

class BedtimeStoryQuizQuestion {
  const BedtimeStoryQuizQuestion({
    required this.questionId,
    required this.prompt,
    required this.questionType,
    required this.answerOptions,
    required this.correctAnswerId,
    required this.explanation,
    this.hint,
    this.illustrationAssetPath,
    this.relatedSceneId,
    this.audioPromptAssetPath,
  });

  final String questionId;
  final String prompt;
  final BedtimeStoryQuizQuestionType questionType;
  final List<BedtimeStoryQuizOption> answerOptions;
  final String correctAnswerId;
  final String explanation;
  final String? hint;
  final String? illustrationAssetPath;
  final String? relatedSceneId;
  final String? audioPromptAssetPath;
}

class BedtimeStoryQuizCompletionRule {
  const BedtimeStoryQuizCompletionRule({
    required this.minimumAnsweredQuestions,
    required this.minimumCorrectAnswers,
  });

  final int minimumAnsweredQuestions;
  final int minimumCorrectAnswers;
}

class BedtimeStoryQuizSeed {
  const BedtimeStoryQuizSeed({
    required this.quizId,
    required this.storyId,
    required this.prophetId,
    required this.title,
    required this.shortDescription,
    required this.ageGroup,
    required this.sortOrder,
    required this.questions,
    required this.completionRule,
    required this.reward,
    required this.relatedStoryIds,
    required this.relatedSceneIds,
    required this.isFeatured,
    required this.isLocked,
    required this.unlockXp,
    required this.difficulty,
  });

  final String quizId;
  final String storyId;
  final String prophetId;
  final String title;
  final String shortDescription;
  final BedtimeStoryAgeGroup ageGroup;
  final int sortOrder;
  final List<BedtimeStoryQuizQuestion> questions;
  final BedtimeStoryQuizCompletionRule completionRule;
  final BedtimeStoryLearningRewardMetadata reward;
  final List<String> relatedStoryIds;
  final List<String> relatedSceneIds;
  final bool isFeatured;
  final bool isLocked;
  final int unlockXp;
  final BedtimeStoryLearningDifficulty difficulty;
}

class BedtimeStoryMemoryCardPair {
  const BedtimeStoryMemoryCardPair({
    required this.pairId,
    required this.prompt,
    required this.answer,
    this.promptIllustrationAssetPath,
    this.answerIllustrationAssetPath,
    this.relatedSceneId,
  });

  final String pairId;
  final String prompt;
  final String answer;
  final String? promptIllustrationAssetPath;
  final String? answerIllustrationAssetPath;
  final String? relatedSceneId;
}

class BedtimeStoryMemoryDeckSeed {
  const BedtimeStoryMemoryDeckSeed({
    required this.deckId,
    required this.storyId,
    required this.prophetId,
    required this.title,
    required this.shortDescription,
    required this.ageGroup,
    required this.sortOrder,
    required this.pairs,
    required this.reward,
    required this.relatedStoryIds,
    required this.isFeatured,
    required this.isLocked,
    required this.unlockXp,
    required this.difficulty,
  });

  final String deckId;
  final String storyId;
  final String prophetId;
  final String title;
  final String shortDescription;
  final BedtimeStoryAgeGroup ageGroup;
  final int sortOrder;
  final List<BedtimeStoryMemoryCardPair> pairs;
  final BedtimeStoryLearningRewardMetadata reward;
  final List<String> relatedStoryIds;
  final bool isFeatured;
  final bool isLocked;
  final int unlockXp;
  final BedtimeStoryLearningDifficulty difficulty;
}

class BedtimeStoryLearningActivityProgress {
  const BedtimeStoryLearningActivityProgress({
    required this.storyId,
    required this.mode,
    this.currentStepIndex = 0,
    this.totalSteps = 0,
    this.correctCount = 0,
    this.completedStepIds = const <String>[],
    this.startedAtIso,
    this.lastAccessedAtIso,
    this.firstCompletedAtIso,
    this.rewardGrantedAtIso,
  });

  final String storyId;
  final BedtimeStoryLearningMode mode;
  final int currentStepIndex;
  final int totalSteps;
  final int correctCount;
  final List<String> completedStepIds;
  final String? startedAtIso;
  final String? lastAccessedAtIso;
  final String? firstCompletedAtIso;
  final String? rewardGrantedAtIso;

  BedtimeStoryLearningCompletionState get completionState {
    if ((firstCompletedAtIso ?? '').isNotEmpty) {
      return BedtimeStoryLearningCompletionState.completed;
    }
    if ((startedAtIso ?? '').isNotEmpty || currentStepIndex > 0) {
      return BedtimeStoryLearningCompletionState.inProgress;
    }
    return BedtimeStoryLearningCompletionState.notStarted;
  }

  bool get isCompleted =>
      completionState == BedtimeStoryLearningCompletionState.completed;
  bool get hasRewardGranted => (rewardGrantedAtIso ?? '').isNotEmpty;

  BedtimeStoryLearningActivityProgress copyWith({
    String? storyId,
    BedtimeStoryLearningMode? mode,
    int? currentStepIndex,
    int? totalSteps,
    int? correctCount,
    List<String>? completedStepIds,
    String? startedAtIso,
    bool clearStartedAtIso = false,
    String? lastAccessedAtIso,
    String? firstCompletedAtIso,
    bool clearFirstCompletedAtIso = false,
    String? rewardGrantedAtIso,
    bool clearRewardGrantedAtIso = false,
  }) {
    return BedtimeStoryLearningActivityProgress(
      storyId: storyId ?? this.storyId,
      mode: mode ?? this.mode,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      totalSteps: totalSteps ?? this.totalSteps,
      correctCount: correctCount ?? this.correctCount,
      completedStepIds: completedStepIds ?? this.completedStepIds,
      startedAtIso: clearStartedAtIso
          ? null
          : (startedAtIso ?? this.startedAtIso),
      lastAccessedAtIso: lastAccessedAtIso ?? this.lastAccessedAtIso,
      firstCompletedAtIso: clearFirstCompletedAtIso
          ? null
          : (firstCompletedAtIso ?? this.firstCompletedAtIso),
      rewardGrantedAtIso: clearRewardGrantedAtIso
          ? null
          : (rewardGrantedAtIso ?? this.rewardGrantedAtIso),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'storyId': storyId,
    'mode': mode.name,
    'currentStepIndex': currentStepIndex,
    'totalSteps': totalSteps,
    'correctCount': correctCount,
    'completedStepIds': completedStepIds,
    'startedAtIso': startedAtIso,
    'lastAccessedAtIso': lastAccessedAtIso,
    'firstCompletedAtIso': firstCompletedAtIso,
    'rewardGrantedAtIso': rewardGrantedAtIso,
  };

  static BedtimeStoryLearningActivityProgress fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const BedtimeStoryLearningActivityProgress(
        storyId: '',
        mode: BedtimeStoryLearningMode.quiz,
      );
    }
    return BedtimeStoryLearningActivityProgress(
      storyId: json['storyId']?.toString() ?? '',
      mode: _modeFromString(json['mode']?.toString()),
      currentStepIndex: (json['currentStepIndex'] as num?)?.toInt() ?? 0,
      totalSteps: (json['totalSteps'] as num?)?.toInt() ?? 0,
      correctCount: (json['correctCount'] as num?)?.toInt() ?? 0,
      completedStepIds: (json['completedStepIds'] as List?)
              ?.map((item) => item.toString())
              .toList(growable: false) ??
          const <String>[],
      startedAtIso: json['startedAtIso']?.toString(),
      lastAccessedAtIso: json['lastAccessedAtIso']?.toString(),
      firstCompletedAtIso: json['firstCompletedAtIso']?.toString(),
      rewardGrantedAtIso: json['rewardGrantedAtIso']?.toString(),
    );
  }

  static BedtimeStoryLearningMode _modeFromString(String? value) {
    for (final mode in BedtimeStoryLearningMode.values) {
      if (mode.name == value) {
        return mode;
      }
    }
    return BedtimeStoryLearningMode.quiz;
  }
}

class BedtimeStoryLearningProgressState {
  const BedtimeStoryLearningProgressState({
    this.progressByActivityId =
        const <String, BedtimeStoryLearningActivityProgress>{},
    this.recentActivityIds = const <String>[],
  });

  final Map<String, BedtimeStoryLearningActivityProgress> progressByActivityId;
  final List<String> recentActivityIds;

  BedtimeStoryLearningProgressState copyWith({
    Map<String, BedtimeStoryLearningActivityProgress>? progressByActivityId,
    List<String>? recentActivityIds,
  }) {
    return BedtimeStoryLearningProgressState(
      progressByActivityId: progressByActivityId ?? this.progressByActivityId,
      recentActivityIds: recentActivityIds ?? this.recentActivityIds,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'progressByActivityId': progressByActivityId.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
    'recentActivityIds': recentActivityIds,
  };

  static BedtimeStoryLearningProgressState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const BedtimeStoryLearningProgressState();
    }
    final progressById = <String, BedtimeStoryLearningActivityProgress>{};
    final rawMap = json['progressByActivityId'];
    if (rawMap is Map) {
      for (final entry in rawMap.entries) {
        progressById[entry.key.toString()] =
            BedtimeStoryLearningActivityProgress.fromJson(
              entry.value is Map<String, dynamic>
                  ? entry.value as Map<String, dynamic>
                  : (entry.value as Map?)?.map(
                      (key, value) => MapEntry(key.toString(), value),
                    ),
            );
      }
    }
    return BedtimeStoryLearningProgressState(
      progressByActivityId: progressById,
      recentActivityIds: (json['recentActivityIds'] as List?)
              ?.map((item) => item.toString())
              .toList(growable: false) ??
          const <String>[],
    );
  }
}

class BedtimeStoryLearningCompletionOutcome {
  const BedtimeStoryLearningCompletionOutcome({
    required this.firstCompletion,
    required this.xpAwarded,
  });

  final bool firstCompletion;
  final int xpAwarded;
}

class BedtimeStoryLearningSuggestion {
  const BedtimeStoryLearningSuggestion({
    required this.activityId,
    required this.storyId,
    required this.mode,
    required this.title,
    required this.subtitle,
  });

  final String activityId;
  final String storyId;
  final BedtimeStoryLearningMode mode;
  final String title;
  final String subtitle;
}
