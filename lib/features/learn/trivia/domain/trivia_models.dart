import 'package:flutter/widgets.dart';

enum TriviaQuestionType { multipleChoice, trueFalse }

enum TriviaDifficulty { easy, medium, hard }

enum TriviaMode {
  quickChallenge,
  deepDive,
  dailyQuiz,
  survival,
  reviewMistakes,
}

enum TriviaKnowledgeStageState { locked, unlocked, completed }

enum TriviaContentStatus { active, draft, archived }

enum TriviaReviewMasteryState { newItem, learning, improving, mastered }

extension TriviaQuestionTypeLabel on TriviaQuestionType {
  String get label {
    switch (this) {
      case TriviaQuestionType.multipleChoice:
        return 'Multiple Choice';
      case TriviaQuestionType.trueFalse:
        return 'True / False';
    }
  }
}

extension TriviaDifficultyLabel on TriviaDifficulty {
  String get label {
    switch (this) {
      case TriviaDifficulty.easy:
        return 'Easy';
      case TriviaDifficulty.medium:
        return 'Medium';
      case TriviaDifficulty.hard:
        return 'Hard';
    }
  }
}

extension TriviaModeLabels on TriviaMode {
  String get label {
    switch (this) {
      case TriviaMode.quickChallenge:
        return 'Quick Challenge';
      case TriviaMode.deepDive:
        return 'Deep Dive';
      case TriviaMode.dailyQuiz:
        return 'Daily Quiz';
      case TriviaMode.survival:
        return 'Survival Mode';
      case TriviaMode.reviewMistakes:
        return 'Review Mistakes';
    }
  }

  String get subtitle {
    switch (this) {
      case TriviaMode.quickChallenge:
        return 'A short mixed session for steady practice.';
      case TriviaMode.deepDive:
        return 'A longer focused run with more depth.';
      case TriviaMode.dailyQuiz:
        return 'One curated set for today with first-completion rewards.';
      case TriviaMode.survival:
        return 'Continue until you miss or finish the pool.';
      case TriviaMode.reviewMistakes:
        return 'Return to questions that need another pass.';
    }
  }

  int get suggestedQuestionCount {
    switch (this) {
      case TriviaMode.quickChallenge:
        return 5;
      case TriviaMode.deepDive:
        return 10;
      case TriviaMode.dailyQuiz:
        return 5;
      case TriviaMode.survival:
        return 20;
      case TriviaMode.reviewMistakes:
        return 6;
    }
  }
}

extension TriviaMasteryLabel on TriviaReviewMasteryState {
  String get label {
    switch (this) {
      case TriviaReviewMasteryState.newItem:
        return 'New';
      case TriviaReviewMasteryState.learning:
        return 'Learning';
      case TriviaReviewMasteryState.improving:
        return 'Improving';
      case TriviaReviewMasteryState.mastered:
        return 'Mastered';
    }
  }
}

@immutable
class TriviaCategory {
  const TriviaCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconKey,
    this.displayOrder = 0,
    this.accentStyle,
    this.isVisible = true,
    this.ageSuitability,
    this.learningPathId,
  });

  final String id;
  final String title;
  final String subtitle;
  final String iconKey;
  final int displayOrder;
  final String? accentStyle;
  final bool isVisible;
  final String? ageSuitability;
  final String? learningPathId;
}

@immutable
class TriviaAnswerOption {
  const TriviaAnswerOption({required this.id, required this.label});

  final String id;
  final String label;

  Map<String, dynamic> toJson() => {'id': id, 'label': label};

  static TriviaAnswerOption? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final id = json['id']?.toString();
    final label = json['label']?.toString();
    if (id == null || id.isEmpty || label == null || label.isEmpty) {
      return null;
    }
    return TriviaAnswerOption(id: id, label: label);
  }
}

@immutable
class TriviaQuestion {
  const TriviaQuestion({
    required this.id,
    required this.categoryId,
    required this.type,
    required this.difficulty,
    required this.prompt,
    required this.options,
    required this.correctOptionId,
    required this.explanation,
    this.quranReference,
    this.sourceReference,
    this.learningNote,
    this.tags = const <String>[],
    this.status = TriviaContentStatus.active,
    this.dailyEligible = true,
    this.featured = false,
    this.beginnerFriendly = false,
    this.reflectionFriendly = false,
    this.reviewPrioritySeed = 0,
    this.modeEligibility = TriviaMode.values,
    this.packId,
    this.sortOrder = 0,
    this.cautionFlag,
    this.scholarReviewStatus,
  });

  final String id;
  final String categoryId;
  final TriviaQuestionType type;
  final TriviaDifficulty difficulty;
  final String prompt;
  final List<TriviaAnswerOption> options;
  final String correctOptionId;
  final String explanation;
  final String? quranReference;
  final String? sourceReference;
  final String? learningNote;
  final List<String> tags;
  final TriviaContentStatus status;
  final bool dailyEligible;
  final bool featured;
  final bool beginnerFriendly;
  final bool reflectionFriendly;
  final int reviewPrioritySeed;
  final List<TriviaMode> modeEligibility;
  final String? packId;
  final int sortOrder;
  final String? cautionFlag;
  final String? scholarReviewStatus;

  bool get isActive => status == TriviaContentStatus.active;

  TriviaAnswerOption? get correctOption {
    for (final option in options) {
      if (option.id == correctOptionId) return option;
    }
    return null;
  }
}

@immutable
class TriviaSessionQuestionState {
  const TriviaSessionQuestionState({
    required this.questionId,
    this.selectedOptionId,
    this.isCorrect,
    this.answeredAtIso,
  });

  final String questionId;
  final String? selectedOptionId;
  final bool? isCorrect;
  final String? answeredAtIso;

  bool get isAnswered => selectedOptionId != null && isCorrect != null;

  TriviaSessionQuestionState copyWith({
    String? selectedOptionId,
    bool? isCorrect,
    String? answeredAtIso,
  }) {
    return TriviaSessionQuestionState(
      questionId: questionId,
      selectedOptionId: selectedOptionId ?? this.selectedOptionId,
      isCorrect: isCorrect ?? this.isCorrect,
      answeredAtIso: answeredAtIso ?? this.answeredAtIso,
    );
  }

  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'selectedOptionId': selectedOptionId,
    'isCorrect': isCorrect,
    'answeredAtIso': answeredAtIso,
  };

  static TriviaSessionQuestionState? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final questionId = json['questionId']?.toString();
    if (questionId == null || questionId.isEmpty) return null;
    return TriviaSessionQuestionState(
      questionId: questionId,
      selectedOptionId: json['selectedOptionId']?.toString(),
      isCorrect: json['isCorrect'] as bool?,
      answeredAtIso: json['answeredAtIso']?.toString(),
    );
  }
}

@immutable
class TriviaSession {
  const TriviaSession({
    required this.id,
    required this.mode,
    required this.questionIds,
    required this.startedAtIso,
    this.categoryId,
    this.currentIndex = 0,
    this.questionStates = const <String, TriviaSessionQuestionState>{},
    this.dailyKey,
    this.dailyReplay = false,
    this.knowledgePathId,
    this.knowledgeStageId,
    this.knowledgeStageTitle,
    this.customXpReward,
    this.customOceanDropReward,
  });

  final String id;
  final TriviaMode mode;
  final String? categoryId;
  final List<String> questionIds;
  final int currentIndex;
  final Map<String, TriviaSessionQuestionState> questionStates;
  final String startedAtIso;
  final String? dailyKey;
  final bool dailyReplay;
  final String? knowledgePathId;
  final String? knowledgeStageId;
  final String? knowledgeStageTitle;
  final int? customXpReward;
  final int? customOceanDropReward;

  bool get isKnowledgePathSession =>
      knowledgePathId != null && knowledgeStageId != null;

  TriviaSession copyWith({
    int? currentIndex,
    Map<String, TriviaSessionQuestionState>? questionStates,
  }) {
    return TriviaSession(
      id: id,
      mode: mode,
      categoryId: categoryId,
      questionIds: questionIds,
      currentIndex: currentIndex ?? this.currentIndex,
      questionStates: questionStates ?? this.questionStates,
      startedAtIso: startedAtIso,
      dailyKey: dailyKey,
      dailyReplay: dailyReplay,
      knowledgePathId: knowledgePathId,
      knowledgeStageId: knowledgeStageId,
      knowledgeStageTitle: knowledgeStageTitle,
      customXpReward: customXpReward,
      customOceanDropReward: customOceanDropReward,
    );
  }

  String? get currentQuestionId {
    if (questionIds.isEmpty ||
        currentIndex < 0 ||
        currentIndex >= questionIds.length) {
      return null;
    }
    return questionIds[currentIndex];
  }

  int get answeredCount =>
      questionStates.values.where((item) => item.isAnswered).length;

  bool get isLastQuestion => currentIndex >= questionIds.length - 1;

  Map<String, dynamic> toJson() => {
    'id': id,
    'mode': mode.name,
    'categoryId': categoryId,
    'questionIds': questionIds,
    'currentIndex': currentIndex,
    'questionStates': questionStates.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
    'startedAtIso': startedAtIso,
    'dailyKey': dailyKey,
    'dailyReplay': dailyReplay,
    'knowledgePathId': knowledgePathId,
    'knowledgeStageId': knowledgeStageId,
    'knowledgeStageTitle': knowledgeStageTitle,
    'customXpReward': customXpReward,
    'customOceanDropReward': customOceanDropReward,
  };

  static TriviaSession? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final id = json['id']?.toString();
    if (id == null || id.isEmpty) return null;
    final mode =
        _modeFromName(json['mode']?.toString()) ?? TriviaMode.quickChallenge;
    final questionIds = <String>[];
    final rawQuestionIds = json['questionIds'];
    if (rawQuestionIds is List) {
      for (final item in rawQuestionIds) {
        final value = item?.toString();
        if (value != null && value.isNotEmpty) questionIds.add(value);
      }
    }
    final questionStates = <String, TriviaSessionQuestionState>{};
    final rawStates = json['questionStates'];
    if (rawStates is Map) {
      for (final entry in rawStates.entries) {
        final parsed = TriviaSessionQuestionState.fromJson(
          entry.value is Map<String, dynamic>
              ? entry.value as Map<String, dynamic>
              : entry.value is Map
              ? Map<String, dynamic>.from(entry.value as Map)
              : null,
        );
        if (parsed != null) {
          questionStates[entry.key.toString()] = parsed;
        }
      }
    }
    return TriviaSession(
      id: id,
      mode: mode,
      categoryId: json['categoryId']?.toString(),
      questionIds: questionIds,
      currentIndex: int.tryParse(json['currentIndex']?.toString() ?? '') ?? 0,
      questionStates: questionStates,
      startedAtIso:
          json['startedAtIso']?.toString() ?? DateTime.now().toIso8601String(),
      dailyKey: json['dailyKey']?.toString(),
      dailyReplay: json['dailyReplay'] == true,
      knowledgePathId: json['knowledgePathId']?.toString(),
      knowledgeStageId: json['knowledgeStageId']?.toString(),
      knowledgeStageTitle: json['knowledgeStageTitle']?.toString(),
      customXpReward: int.tryParse(json['customXpReward']?.toString() ?? ''),
      customOceanDropReward: int.tryParse(
        json['customOceanDropReward']?.toString() ?? '',
      ),
    );
  }
}

@immutable
class TriviaSessionResult {
  const TriviaSessionResult({
    required this.sessionId,
    required this.mode,
    required this.totalAnswered,
    required this.correctCount,
    required this.incorrectCount,
    required this.startedAtIso,
    required this.completedAtIso,
    required this.questionIds,
    required this.incorrectQuestionIds,
    required this.xpEarned,
    required this.oceanDropsEarned,
    this.categoryId,
    this.wasPerfect = false,
    this.wasDailyReplay = false,
    this.survivalRun = 0,
    this.knowledgePathId,
    this.knowledgeStageId,
    this.knowledgeStageTitle,
  });

  final String sessionId;
  final TriviaMode mode;
  final String? categoryId;
  final int totalAnswered;
  final int correctCount;
  final int incorrectCount;
  final String startedAtIso;
  final String completedAtIso;
  final List<String> questionIds;
  final List<String> incorrectQuestionIds;
  final int xpEarned;
  final int oceanDropsEarned;
  final bool wasPerfect;
  final bool wasDailyReplay;
  final int survivalRun;
  final String? knowledgePathId;
  final String? knowledgeStageId;
  final String? knowledgeStageTitle;

  double get accuracy {
    if (totalAnswered <= 0) return 0;
    return correctCount / totalAnswered;
  }

  int get durationSeconds {
    final started = DateTime.tryParse(startedAtIso);
    final completed = DateTime.tryParse(completedAtIso);
    if (started == null || completed == null) return 0;
    return completed.difference(started).inSeconds.clamp(0, 86400);
  }

  Map<String, dynamic> toJson() => {
    'sessionId': sessionId,
    'mode': mode.name,
    'categoryId': categoryId,
    'totalAnswered': totalAnswered,
    'correctCount': correctCount,
    'incorrectCount': incorrectCount,
    'startedAtIso': startedAtIso,
    'completedAtIso': completedAtIso,
    'questionIds': questionIds,
    'incorrectQuestionIds': incorrectQuestionIds,
    'xpEarned': xpEarned,
    'oceanDropsEarned': oceanDropsEarned,
    'wasPerfect': wasPerfect,
    'wasDailyReplay': wasDailyReplay,
    'survivalRun': survivalRun,
    'knowledgePathId': knowledgePathId,
    'knowledgeStageId': knowledgeStageId,
    'knowledgeStageTitle': knowledgeStageTitle,
  };

  static TriviaSessionResult? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final sessionId = json['sessionId']?.toString();
    if (sessionId == null || sessionId.isEmpty) return null;
    return TriviaSessionResult(
      sessionId: sessionId,
      mode:
          _modeFromName(json['mode']?.toString()) ?? TriviaMode.quickChallenge,
      categoryId: json['categoryId']?.toString(),
      totalAnswered: int.tryParse(json['totalAnswered']?.toString() ?? '') ?? 0,
      correctCount: int.tryParse(json['correctCount']?.toString() ?? '') ?? 0,
      incorrectCount:
          int.tryParse(json['incorrectCount']?.toString() ?? '') ?? 0,
      startedAtIso:
          json['startedAtIso']?.toString() ?? DateTime.now().toIso8601String(),
      completedAtIso:
          json['completedAtIso']?.toString() ??
          DateTime.now().toIso8601String(),
      questionIds: (json['questionIds'] as List? ?? const <dynamic>[])
          .map((item) => item.toString())
          .where((item) => item.isNotEmpty)
          .toList(growable: false),
      incorrectQuestionIds:
          (json['incorrectQuestionIds'] as List? ?? const <dynamic>[])
              .map((item) => item.toString())
              .where((item) => item.isNotEmpty)
              .toList(growable: false),
      xpEarned: int.tryParse(json['xpEarned']?.toString() ?? '') ?? 0,
      oceanDropsEarned:
          int.tryParse(json['oceanDropsEarned']?.toString() ?? '') ?? 0,
      wasPerfect: json['wasPerfect'] == true,
      wasDailyReplay: json['wasDailyReplay'] == true,
      survivalRun: int.tryParse(json['survivalRun']?.toString() ?? '') ?? 0,
      knowledgePathId: json['knowledgePathId']?.toString(),
      knowledgeStageId: json['knowledgeStageId']?.toString(),
      knowledgeStageTitle: json['knowledgeStageTitle']?.toString(),
    );
  }
}

@immutable
class TriviaKnowledgeStage {
  const TriviaKnowledgeStage({
    required this.id,
    required this.title,
    required this.learningText,
    required this.questionIds,
    this.reference,
    this.note,
    this.difficulty = TriviaDifficulty.easy,
    this.xpReward = 12,
    this.oceanDropReward = 1,
  });

  final String id;
  final String title;
  final String learningText;
  final String? reference;
  final String? note;
  final List<String> questionIds;
  final TriviaDifficulty difficulty;
  final int xpReward;
  final int oceanDropReward;
}

@immutable
class TriviaKnowledgePath {
  const TriviaKnowledgePath({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.stages,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<TriviaKnowledgeStage> stages;
}

@immutable
class TriviaKnowledgePathProgress {
  const TriviaKnowledgePathProgress({
    required this.pathId,
    this.completedStageIds = const <String>[],
    this.rewardedStageIds = const <String>[],
    this.currentStageId,
    this.completedAtIso,
    this.pathCompletionRewardGranted = false,
  });

  final String pathId;
  final List<String> completedStageIds;
  final List<String> rewardedStageIds;
  final String? currentStageId;
  final String? completedAtIso;
  final bool pathCompletionRewardGranted;

  bool isStageCompleted(String stageId) => completedStageIds.contains(stageId);

  bool isStageRewarded(String stageId) => rewardedStageIds.contains(stageId);

  TriviaKnowledgePathProgress copyWith({
    List<String>? completedStageIds,
    List<String>? rewardedStageIds,
    String? currentStageId,
    bool clearCurrentStageId = false,
    String? completedAtIso,
    bool clearCompletedAtIso = false,
    bool? pathCompletionRewardGranted,
  }) {
    return TriviaKnowledgePathProgress(
      pathId: pathId,
      completedStageIds: completedStageIds ?? this.completedStageIds,
      rewardedStageIds: rewardedStageIds ?? this.rewardedStageIds,
      currentStageId: clearCurrentStageId
          ? null
          : (currentStageId ?? this.currentStageId),
      completedAtIso: clearCompletedAtIso
          ? null
          : (completedAtIso ?? this.completedAtIso),
      pathCompletionRewardGranted:
          pathCompletionRewardGranted ?? this.pathCompletionRewardGranted,
    );
  }

  Map<String, dynamic> toJson() => {
    'pathId': pathId,
    'completedStageIds': completedStageIds,
    'rewardedStageIds': rewardedStageIds,
    'currentStageId': currentStageId,
    'completedAtIso': completedAtIso,
    'pathCompletionRewardGranted': pathCompletionRewardGranted,
  };

  static TriviaKnowledgePathProgress? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final pathId = json['pathId']?.toString();
    if (pathId == null || pathId.isEmpty) return null;
    return TriviaKnowledgePathProgress(
      pathId: pathId,
      completedStageIds:
          (json['completedStageIds'] as List? ?? const <dynamic>[])
              .map((item) => item.toString())
              .where((item) => item.isNotEmpty)
              .toList(growable: false),
      rewardedStageIds: (json['rewardedStageIds'] as List? ?? const <dynamic>[])
          .map((item) => item.toString())
          .where((item) => item.isNotEmpty)
          .toList(growable: false),
      currentStageId: json['currentStageId']?.toString(),
      completedAtIso: json['completedAtIso']?.toString(),
      pathCompletionRewardGranted: json['pathCompletionRewardGranted'] == true,
    );
  }
}

@immutable
class TriviaCategoryStats {
  const TriviaCategoryStats({
    required this.categoryId,
    this.questionsAnswered = 0,
    this.correct = 0,
    this.incorrect = 0,
    this.quizzesCompleted = 0,
  });

  final String categoryId;
  final int questionsAnswered;
  final int correct;
  final int incorrect;
  final int quizzesCompleted;

  double get accuracy {
    if (questionsAnswered <= 0) return 0;
    return correct / questionsAnswered;
  }

  TriviaCategoryStats copyWith({
    int? questionsAnswered,
    int? correct,
    int? incorrect,
    int? quizzesCompleted,
  }) {
    return TriviaCategoryStats(
      categoryId: categoryId,
      questionsAnswered: questionsAnswered ?? this.questionsAnswered,
      correct: correct ?? this.correct,
      incorrect: incorrect ?? this.incorrect,
      quizzesCompleted: quizzesCompleted ?? this.quizzesCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'categoryId': categoryId,
    'questionsAnswered': questionsAnswered,
    'correct': correct,
    'incorrect': incorrect,
    'quizzesCompleted': quizzesCompleted,
  };

  static TriviaCategoryStats? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final categoryId = json['categoryId']?.toString();
    if (categoryId == null || categoryId.isEmpty) return null;
    return TriviaCategoryStats(
      categoryId: categoryId,
      questionsAnswered:
          int.tryParse(json['questionsAnswered']?.toString() ?? '') ?? 0,
      correct: int.tryParse(json['correct']?.toString() ?? '') ?? 0,
      incorrect: int.tryParse(json['incorrect']?.toString() ?? '') ?? 0,
      quizzesCompleted:
          int.tryParse(json['quizzesCompleted']?.toString() ?? '') ?? 0,
    );
  }
}

@immutable
class TriviaUserStats {
  const TriviaUserStats({
    this.totalQuestionsAnswered = 0,
    this.totalQuizzesCompleted = 0,
    this.totalCorrect = 0,
    this.totalIncorrect = 0,
    this.totalTriviaXp = 0,
    this.totalTriviaOceanDrops = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.bestSurvivalRun = 0,
    this.dailyQuizStreak = 0,
    this.longestDailyQuizStreak = 0,
    this.lastCompletionDayKey,
    this.lastDailyQuizDayKey,
    this.categoryStats = const <String, TriviaCategoryStats>{},
    this.recentResults = const <TriviaSessionResult>[],
  });

  final int totalQuestionsAnswered;
  final int totalQuizzesCompleted;
  final int totalCorrect;
  final int totalIncorrect;
  final int totalTriviaXp;
  final int totalTriviaOceanDrops;
  final int currentStreak;
  final int longestStreak;
  final int bestSurvivalRun;
  final int dailyQuizStreak;
  final int longestDailyQuizStreak;
  final String? lastCompletionDayKey;
  final String? lastDailyQuizDayKey;
  final Map<String, TriviaCategoryStats> categoryStats;
  final List<TriviaSessionResult> recentResults;

  double get overallAccuracy {
    if (totalQuestionsAnswered <= 0) return 0;
    return totalCorrect / totalQuestionsAnswered;
  }

  TriviaUserStats copyWith({
    int? totalQuestionsAnswered,
    int? totalQuizzesCompleted,
    int? totalCorrect,
    int? totalIncorrect,
    int? totalTriviaXp,
    int? totalTriviaOceanDrops,
    int? currentStreak,
    int? longestStreak,
    int? bestSurvivalRun,
    int? dailyQuizStreak,
    int? longestDailyQuizStreak,
    String? lastCompletionDayKey,
    bool clearLastCompletionDayKey = false,
    String? lastDailyQuizDayKey,
    bool clearLastDailyQuizDayKey = false,
    Map<String, TriviaCategoryStats>? categoryStats,
    List<TriviaSessionResult>? recentResults,
  }) {
    return TriviaUserStats(
      totalQuestionsAnswered:
          totalQuestionsAnswered ?? this.totalQuestionsAnswered,
      totalQuizzesCompleted:
          totalQuizzesCompleted ?? this.totalQuizzesCompleted,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      totalIncorrect: totalIncorrect ?? this.totalIncorrect,
      totalTriviaXp: totalTriviaXp ?? this.totalTriviaXp,
      totalTriviaOceanDrops:
          totalTriviaOceanDrops ?? this.totalTriviaOceanDrops,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      bestSurvivalRun: bestSurvivalRun ?? this.bestSurvivalRun,
      dailyQuizStreak: dailyQuizStreak ?? this.dailyQuizStreak,
      longestDailyQuizStreak:
          longestDailyQuizStreak ?? this.longestDailyQuizStreak,
      lastCompletionDayKey: clearLastCompletionDayKey
          ? null
          : (lastCompletionDayKey ?? this.lastCompletionDayKey),
      lastDailyQuizDayKey: clearLastDailyQuizDayKey
          ? null
          : (lastDailyQuizDayKey ?? this.lastDailyQuizDayKey),
      categoryStats: categoryStats ?? this.categoryStats,
      recentResults: recentResults ?? this.recentResults,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalQuestionsAnswered': totalQuestionsAnswered,
    'totalQuizzesCompleted': totalQuizzesCompleted,
    'totalCorrect': totalCorrect,
    'totalIncorrect': totalIncorrect,
    'totalTriviaXp': totalTriviaXp,
    'totalTriviaOceanDrops': totalTriviaOceanDrops,
    'currentStreak': currentStreak,
    'longestStreak': longestStreak,
    'bestSurvivalRun': bestSurvivalRun,
    'dailyQuizStreak': dailyQuizStreak,
    'longestDailyQuizStreak': longestDailyQuizStreak,
    'lastCompletionDayKey': lastCompletionDayKey,
    'lastDailyQuizDayKey': lastDailyQuizDayKey,
    'categoryStats': categoryStats.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
    'recentResults': recentResults
        .map((item) => item.toJson())
        .toList(growable: false),
  };

  static TriviaUserStats fromJson(Map<String, dynamic>? json) {
    if (json == null) return const TriviaUserStats();
    final categoryStats = <String, TriviaCategoryStats>{};
    final rawCategoryStats = json['categoryStats'];
    if (rawCategoryStats is Map) {
      for (final entry in rawCategoryStats.entries) {
        final parsed = TriviaCategoryStats.fromJson(
          entry.value is Map<String, dynamic>
              ? entry.value as Map<String, dynamic>
              : entry.value is Map
              ? Map<String, dynamic>.from(entry.value as Map)
              : null,
        );
        if (parsed != null) {
          categoryStats[parsed.categoryId] = parsed;
        }
      }
    }
    final recentResults = <TriviaSessionResult>[];
    final rawRecentResults = json['recentResults'];
    if (rawRecentResults is List) {
      for (final item in rawRecentResults) {
        final parsed = TriviaSessionResult.fromJson(
          item is Map<String, dynamic>
              ? item
              : item is Map
              ? Map<String, dynamic>.from(item)
              : null,
        );
        if (parsed != null) recentResults.add(parsed);
      }
    }
    return TriviaUserStats(
      totalQuestionsAnswered:
          int.tryParse(json['totalQuestionsAnswered']?.toString() ?? '') ?? 0,
      totalQuizzesCompleted:
          int.tryParse(json['totalQuizzesCompleted']?.toString() ?? '') ?? 0,
      totalCorrect: int.tryParse(json['totalCorrect']?.toString() ?? '') ?? 0,
      totalIncorrect:
          int.tryParse(json['totalIncorrect']?.toString() ?? '') ?? 0,
      totalTriviaXp: int.tryParse(json['totalTriviaXp']?.toString() ?? '') ?? 0,
      totalTriviaOceanDrops:
          int.tryParse(json['totalTriviaOceanDrops']?.toString() ?? '') ?? 0,
      currentStreak: int.tryParse(json['currentStreak']?.toString() ?? '') ?? 0,
      longestStreak: int.tryParse(json['longestStreak']?.toString() ?? '') ?? 0,
      bestSurvivalRun:
          int.tryParse(json['bestSurvivalRun']?.toString() ?? '') ?? 0,
      dailyQuizStreak:
          int.tryParse(json['dailyQuizStreak']?.toString() ?? '') ?? 0,
      longestDailyQuizStreak:
          int.tryParse(json['longestDailyQuizStreak']?.toString() ?? '') ?? 0,
      lastCompletionDayKey: json['lastCompletionDayKey']?.toString(),
      lastDailyQuizDayKey: json['lastDailyQuizDayKey']?.toString(),
      categoryStats: categoryStats,
      recentResults: recentResults.take(10).toList(growable: false),
    );
  }
}

@immutable
class TriviaReviewItem {
  const TriviaReviewItem({
    required this.questionId,
    required this.categoryId,
    this.timesSeen = 0,
    this.timesCorrect = 0,
    this.timesIncorrect = 0,
    this.lastSeenIso,
    this.lastIncorrectIso,
    this.nextReviewIso,
    this.masteryState = TriviaReviewMasteryState.newItem,
    this.priority = 0,
  });

  final String questionId;
  final String categoryId;
  final int timesSeen;
  final int timesCorrect;
  final int timesIncorrect;
  final String? lastSeenIso;
  final String? lastIncorrectIso;
  final String? nextReviewIso;
  final TriviaReviewMasteryState masteryState;
  final int priority;

  bool get isMastered => masteryState == TriviaReviewMasteryState.mastered;

  TriviaReviewItem copyWith({
    int? timesSeen,
    int? timesCorrect,
    int? timesIncorrect,
    String? lastSeenIso,
    String? lastIncorrectIso,
    String? nextReviewIso,
    TriviaReviewMasteryState? masteryState,
    int? priority,
  }) {
    return TriviaReviewItem(
      questionId: questionId,
      categoryId: categoryId,
      timesSeen: timesSeen ?? this.timesSeen,
      timesCorrect: timesCorrect ?? this.timesCorrect,
      timesIncorrect: timesIncorrect ?? this.timesIncorrect,
      lastSeenIso: lastSeenIso ?? this.lastSeenIso,
      lastIncorrectIso: lastIncorrectIso ?? this.lastIncorrectIso,
      nextReviewIso: nextReviewIso ?? this.nextReviewIso,
      masteryState: masteryState ?? this.masteryState,
      priority: priority ?? this.priority,
    );
  }

  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'categoryId': categoryId,
    'timesSeen': timesSeen,
    'timesCorrect': timesCorrect,
    'timesIncorrect': timesIncorrect,
    'lastSeenIso': lastSeenIso,
    'lastIncorrectIso': lastIncorrectIso,
    'nextReviewIso': nextReviewIso,
    'masteryState': masteryState.name,
    'priority': priority,
  };

  static TriviaReviewItem? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final questionId = json['questionId']?.toString();
    final categoryId = json['categoryId']?.toString();
    if (questionId == null ||
        questionId.isEmpty ||
        categoryId == null ||
        categoryId.isEmpty) {
      return null;
    }
    return TriviaReviewItem(
      questionId: questionId,
      categoryId: categoryId,
      timesSeen: int.tryParse(json['timesSeen']?.toString() ?? '') ?? 0,
      timesCorrect: int.tryParse(json['timesCorrect']?.toString() ?? '') ?? 0,
      timesIncorrect:
          int.tryParse(json['timesIncorrect']?.toString() ?? '') ?? 0,
      lastSeenIso: json['lastSeenIso']?.toString(),
      lastIncorrectIso: json['lastIncorrectIso']?.toString(),
      nextReviewIso: json['nextReviewIso']?.toString(),
      masteryState:
          _masteryFromName(json['masteryState']?.toString()) ??
          TriviaReviewMasteryState.newItem,
      priority: int.tryParse(json['priority']?.toString() ?? '') ?? 0,
    );
  }
}

@immutable
class TriviaDailyQuizState {
  const TriviaDailyQuizState({
    required this.dayKey,
    required this.questionIds,
    this.completed = false,
    this.rewardGranted = false,
    this.lastSessionId,
  });

  final String dayKey;
  final List<String> questionIds;
  final bool completed;
  final bool rewardGranted;
  final String? lastSessionId;

  TriviaDailyQuizState copyWith({
    List<String>? questionIds,
    bool? completed,
    bool? rewardGranted,
    String? lastSessionId,
  }) {
    return TriviaDailyQuizState(
      dayKey: dayKey,
      questionIds: questionIds ?? this.questionIds,
      completed: completed ?? this.completed,
      rewardGranted: rewardGranted ?? this.rewardGranted,
      lastSessionId: lastSessionId ?? this.lastSessionId,
    );
  }

  Map<String, dynamic> toJson() => {
    'dayKey': dayKey,
    'questionIds': questionIds,
    'completed': completed,
    'rewardGranted': rewardGranted,
    'lastSessionId': lastSessionId,
  };

  static TriviaDailyQuizState? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final dayKey = json['dayKey']?.toString();
    if (dayKey == null || dayKey.isEmpty) return null;
    return TriviaDailyQuizState(
      dayKey: dayKey,
      questionIds: (json['questionIds'] as List? ?? const <dynamic>[])
          .map((item) => item.toString())
          .where((item) => item.isNotEmpty)
          .toList(growable: false),
      completed: json['completed'] == true,
      rewardGranted: json['rewardGranted'] == true,
      lastSessionId: json['lastSessionId']?.toString(),
    );
  }
}

@immutable
class TriviaRewardResult {
  const TriviaRewardResult({required this.xp, required this.oceanDrops});

  final int xp;
  final int oceanDrops;
}

@immutable
class IslamicTriviaState {
  const IslamicTriviaState({
    this.stats = const TriviaUserStats(),
    this.reviewItems = const <String, TriviaReviewItem>{},
    this.pathProgress = const <String, TriviaKnowledgePathProgress>{},
    this.activeSession,
    this.lastResult,
    this.dailyQuizState,
  });

  final TriviaUserStats stats;
  final Map<String, TriviaReviewItem> reviewItems;
  final Map<String, TriviaKnowledgePathProgress> pathProgress;
  final TriviaSession? activeSession;
  final TriviaSessionResult? lastResult;
  final TriviaDailyQuizState? dailyQuizState;

  IslamicTriviaState copyWith({
    TriviaUserStats? stats,
    Map<String, TriviaReviewItem>? reviewItems,
    Map<String, TriviaKnowledgePathProgress>? pathProgress,
    TriviaSession? activeSession,
    bool clearActiveSession = false,
    TriviaSessionResult? lastResult,
    bool clearLastResult = false,
    TriviaDailyQuizState? dailyQuizState,
    bool clearDailyQuizState = false,
  }) {
    return IslamicTriviaState(
      stats: stats ?? this.stats,
      reviewItems: reviewItems ?? this.reviewItems,
      pathProgress: pathProgress ?? this.pathProgress,
      activeSession: clearActiveSession
          ? null
          : (activeSession ?? this.activeSession),
      lastResult: clearLastResult ? null : (lastResult ?? this.lastResult),
      dailyQuizState: clearDailyQuizState
          ? null
          : (dailyQuizState ?? this.dailyQuizState),
    );
  }

  Map<String, dynamic> toJson() => {
    'stats': stats.toJson(),
    'reviewItems': reviewItems.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
    'pathProgress': pathProgress.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
    'activeSession': activeSession?.toJson(),
    'lastResult': lastResult?.toJson(),
    'dailyQuizState': dailyQuizState?.toJson(),
  };

  static IslamicTriviaState fromJson(Map<String, dynamic>? json) {
    if (json == null) return const IslamicTriviaState();
    final reviewItems = <String, TriviaReviewItem>{};
    final rawReviewItems = json['reviewItems'];
    if (rawReviewItems is Map) {
      for (final entry in rawReviewItems.entries) {
        final parsed = TriviaReviewItem.fromJson(
          entry.value is Map<String, dynamic>
              ? entry.value as Map<String, dynamic>
              : entry.value is Map
              ? Map<String, dynamic>.from(entry.value as Map)
              : null,
        );
        if (parsed != null) {
          reviewItems[parsed.questionId] = parsed;
        }
      }
    }
    final pathProgress = <String, TriviaKnowledgePathProgress>{};
    final rawPathProgress = json['pathProgress'];
    if (rawPathProgress is Map) {
      for (final entry in rawPathProgress.entries) {
        final parsed = TriviaKnowledgePathProgress.fromJson(
          entry.value is Map<String, dynamic>
              ? entry.value as Map<String, dynamic>
              : entry.value is Map
              ? Map<String, dynamic>.from(entry.value as Map)
              : null,
        );
        if (parsed != null) {
          pathProgress[parsed.pathId] = parsed;
        }
      }
    }
    return IslamicTriviaState(
      stats: TriviaUserStats.fromJson(
        json['stats'] is Map<String, dynamic>
            ? json['stats'] as Map<String, dynamic>
            : json['stats'] is Map
            ? Map<String, dynamic>.from(json['stats'] as Map)
            : null,
      ),
      reviewItems: reviewItems,
      pathProgress: pathProgress,
      activeSession: TriviaSession.fromJson(
        json['activeSession'] is Map<String, dynamic>
            ? json['activeSession'] as Map<String, dynamic>
            : json['activeSession'] is Map
            ? Map<String, dynamic>.from(json['activeSession'] as Map)
            : null,
      ),
      lastResult: TriviaSessionResult.fromJson(
        json['lastResult'] is Map<String, dynamic>
            ? json['lastResult'] as Map<String, dynamic>
            : json['lastResult'] is Map
            ? Map<String, dynamic>.from(json['lastResult'] as Map)
            : null,
      ),
      dailyQuizState: TriviaDailyQuizState.fromJson(
        json['dailyQuizState'] is Map<String, dynamic>
            ? json['dailyQuizState'] as Map<String, dynamic>
            : json['dailyQuizState'] is Map
            ? Map<String, dynamic>.from(json['dailyQuizState'] as Map)
            : null,
      ),
    );
  }
}

TriviaMode? _modeFromName(String? name) {
  for (final value in TriviaMode.values) {
    if (value.name == name) return value;
  }
  return null;
}

TriviaReviewMasteryState? _masteryFromName(String? name) {
  for (final value in TriviaReviewMasteryState.values) {
    if (value.name == name) return value;
  }
  return null;
}
