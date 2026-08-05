import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../../ocean/application/ocean_drops_provider.dart';
import '../domain/trivia_models.dart';
import 'trivia_repository.dart';

final triviaControllerProvider =
    StateNotifierProvider<TriviaController, IslamicTriviaState>((ref) {
      return TriviaController(
        ref.watch(localStoreProvider),
        ref.read(triviaRepositoryProvider),
        ref.read(oceanDropServiceProvider),
      );
    });

class TriviaController extends StateNotifier<IslamicTriviaState> {
  TriviaController(this._store, this._repository, this._oceanDrops)
    : super(const IslamicTriviaState()) {
    _load();
  }

  static const _storageKey = 'learn.islamicTrivia.state.v1';

  final LocalStore _store;
  final TriviaRepository _repository;
  final OceanDropService _oceanDrops;

  List<TriviaCategory> get categories => _repository.categories;
  List<TriviaKnowledgePath> get knowledgePaths => _repository.knowledgePaths;

  TriviaQuestion? questionById(String id) => _repository.questionById(id);
  TriviaKnowledgePath? knowledgePathById(String id) =>
      _repository.knowledgePathById(id);

  TriviaKnowledgePathProgress pathProgress(String pathId) {
    return state.pathProgress[pathId] ??
        TriviaKnowledgePathProgress(pathId: pathId);
  }

  TriviaKnowledgeStageState stageState(
    TriviaKnowledgePath path,
    TriviaKnowledgeStage stage,
  ) {
    final progress = pathProgress(path.id);
    if (progress.isStageCompleted(stage.id)) {
      return TriviaKnowledgeStageState.completed;
    }
    final stageIndex = path.stages.indexWhere((item) => item.id == stage.id);
    if (stageIndex <= 0) return TriviaKnowledgeStageState.unlocked;
    final previousStage = path.stages[stageIndex - 1];
    return progress.isStageCompleted(previousStage.id)
        ? TriviaKnowledgeStageState.unlocked
        : TriviaKnowledgeStageState.locked;
  }

  double pathCompletionRatio(String pathId) {
    final path = knowledgePathById(pathId);
    if (path == null || path.stages.isEmpty) return 0;
    final progress = pathProgress(pathId);
    return progress.completedStageIds.length / path.stages.length;
  }

  bool startKnowledgePathStage({
    required String pathId,
    required String stageId,
  }) {
    final path = knowledgePathById(pathId);
    if (path == null) return false;
    TriviaKnowledgeStage? stage;
    for (final item in path.stages) {
      if (item.id == stageId) {
        stage = item;
        break;
      }
    }
    if (stage == null) return false;
    if (stageState(path, stage) == TriviaKnowledgeStageState.locked) {
      return false;
    }
    final questions = _repository.questionsForIds(stage.questionIds);
    if (questions.isEmpty) return false;
    final progress = pathProgress(pathId);
    final stageRewarded = progress.isStageRewarded(stageId);
    state = state.copyWith(
      activeSession: TriviaSession(
        id: 'trivia_path_${path.id}_${stage.id}_${DateTime.now().microsecondsSinceEpoch}',
        mode: TriviaMode.deepDive,
        categoryId: questions.isEmpty ? null : questions.first.categoryId,
        questionIds: questions.map((item) => item.id).toList(growable: false),
        startedAtIso: DateTime.now().toIso8601String(),
        knowledgePathId: path.id,
        knowledgeStageId: stage.id,
        knowledgeStageTitle: stage.title,
        customXpReward: stageRewarded ? 0 : stage.xpReward,
        customOceanDropReward: stageRewarded ? 0 : stage.oceanDropReward,
      ),
      clearLastResult: true,
      pathProgress: {
        ...state.pathProgress,
        path.id: progress.copyWith(currentStageId: stage.id),
      },
    );
    _save();
    return true;
  }

  TriviaQuestion? get currentQuestion {
    final questionId = state.activeSession?.currentQuestionId;
    if (questionId == null) return null;
    return questionById(questionId);
  }

  TriviaSessionQuestionState? currentQuestionState() {
    final session = state.activeSession;
    final questionId = session?.currentQuestionId;
    if (session == null || questionId == null) return null;
    return session.questionStates[questionId];
  }

  List<TriviaQuestion> activeQuestions() {
    final session = state.activeSession;
    if (session == null) return const <TriviaQuestion>[];
    return _repository.questionsForIds(session.questionIds);
  }

  int get dueReviewCount {
    final now = DateTime.now();
    return state.reviewItems.values.where((item) {
      if (item.isMastered) return false;
      final due = DateTime.tryParse(item.nextReviewIso ?? '');
      if (due == null) return true;
      return !due.isAfter(now);
    }).length;
  }

  int get masteredReviewCount =>
      state.reviewItems.values.where((item) => item.isMastered).length;

  bool startSession({required TriviaMode mode, String? categoryId}) {
    final now = DateTime.now();
    final sessionQuestions = switch (mode) {
      TriviaMode.quickChallenge => _repository.pickRandomQuestions(
        mode: mode,
        categoryId: categoryId,
        desiredCount: mode.suggestedQuestionCount,
        random: Random(now.microsecondsSinceEpoch),
      ),
      TriviaMode.deepDive => _repository.pickRandomQuestions(
        mode: mode,
        categoryId: categoryId,
        desiredCount: mode.suggestedQuestionCount,
        random: Random(now.microsecondsSinceEpoch),
      ),
      TriviaMode.survival => _repository.pickRandomQuestions(
        mode: mode,
        categoryId: categoryId,
        desiredCount: _repository
            .playableQuestions(mode: mode, categoryId: categoryId)
            .length,
        random: Random(now.microsecondsSinceEpoch),
      ),
      TriviaMode.reviewMistakes => _repository.reviewQuestions(
        reviewItems: _reviewPool(now),
        count: mode.suggestedQuestionCount,
      ),
      TriviaMode.dailyQuiz => _buildDailySessionQuestions(
        now,
        categoryId: categoryId,
      ),
    };

    if (sessionQuestions.isEmpty) return false;

    final dayKey = LocalStore.todayKey(now);
    final isDailyReplay =
        mode == TriviaMode.dailyQuiz &&
        state.dailyQuizState?.dayKey == dayKey &&
        state.dailyQuizState?.completed == true;

    state = state.copyWith(
      activeSession: TriviaSession(
        id: 'trivia_${mode.name}_${now.microsecondsSinceEpoch}',
        mode: mode,
        categoryId: categoryId,
        questionIds: sessionQuestions
            .map((item) => item.id)
            .toList(growable: false),
        startedAtIso: now.toIso8601String(),
        dailyKey: mode == TriviaMode.dailyQuiz ? dayKey : null,
        dailyReplay: isDailyReplay,
      ),
      clearLastResult: false,
      dailyQuizState: mode == TriviaMode.dailyQuiz
          ? TriviaDailyQuizState(
              dayKey: dayKey,
              questionIds: sessionQuestions
                  .map((item) => item.id)
                  .toList(growable: false),
              completed: state.dailyQuizState?.dayKey == dayKey
                  ? state.dailyQuizState?.completed ?? false
                  : false,
              rewardGranted: state.dailyQuizState?.dayKey == dayKey
                  ? state.dailyQuizState?.rewardGranted ?? false
                  : false,
              lastSessionId: state.dailyQuizState?.dayKey == dayKey
                  ? state.dailyQuizState?.lastSessionId
                  : null,
            )
          : state.dailyQuizState,
    );
    _save();
    return true;
  }

  bool answerCurrent(String optionId) {
    final session = state.activeSession;
    final question = currentQuestion;
    if (session == null || question == null) return false;
    final currentState = currentQuestionState();
    if (currentState?.isAnswered == true) {
      return currentState?.isCorrect == true;
    }
    final isCorrect = question.correctOptionId == optionId;
    final nextStates =
        Map<String, TriviaSessionQuestionState>.from(session.questionStates)
          ..[question.id] = TriviaSessionQuestionState(
            questionId: question.id,
            selectedOptionId: optionId,
            isCorrect: isCorrect,
            answeredAtIso: DateTime.now().toIso8601String(),
          );
    state = state.copyWith(
      activeSession: session.copyWith(questionStates: nextStates),
    );
    _save();
    return isCorrect;
  }

  bool nextQuestion() {
    final session = state.activeSession;
    final question = currentQuestion;
    if (session == null || question == null) return false;
    final currentState = currentQuestionState();
    if (currentState?.isAnswered != true) return false;

    final shouldFinishNow = session.mode == TriviaMode.survival
        ? currentState?.isCorrect != true || session.isLastQuestion
        : session.isLastQuestion;

    if (shouldFinishNow) {
      _finishSession();
      return true;
    }

    state = state.copyWith(
      activeSession: session.copyWith(currentIndex: session.currentIndex + 1),
    );
    _save();
    return false;
  }

  void resumeLater() {
    _save();
  }

  void discardActiveSession() {
    state = state.copyWith(clearActiveSession: true);
    _save();
  }

  void clearLastResult() {
    state = state.copyWith(clearLastResult: true);
    _save();
  }

  bool retryLastSession() {
    final result = state.lastResult;
    if (result == null) return false;
    return startSession(mode: result.mode, categoryId: result.categoryId);
  }

  TriviaCategoryStats statsForCategory(String categoryId) {
    return state.stats.categoryStats[categoryId] ??
        TriviaCategoryStats(categoryId: categoryId);
  }

  String? strongestCategoryId() {
    final values = state.stats.categoryStats.values
        .where((item) => item.questionsAnswered > 0)
        .toList(growable: false);
    if (values.isEmpty) return null;
    values.sort((a, b) => b.accuracy.compareTo(a.accuracy));
    return values.first.categoryId;
  }

  String? weakestCategoryId() {
    final values = state.stats.categoryStats.values
        .where((item) => item.questionsAnswered > 0)
        .toList(growable: false);
    if (values.isEmpty) return null;
    values.sort((a, b) => a.accuracy.compareTo(b.accuracy));
    return values.first.categoryId;
  }

  List<TriviaReviewItem> dueReviewItems() {
    final now = DateTime.now();
    final items = _reviewPool(now);
    items.sort((a, b) => b.priority.compareTo(a.priority));
    return items;
  }

  void _load() {
    state = IslamicTriviaState.fromJson(_store.getJsonMap(_storageKey));
    final active = state.activeSession;
    if (active != null &&
        _repository.questionsForIds(active.questionIds).isEmpty) {
      state = state.copyWith(clearActiveSession: true);
      _save();
    }
  }

  void _save() {
    _store.setJsonMap(_storageKey, state.toJson());
  }

  List<TriviaQuestion> _buildDailySessionQuestions(
    DateTime now, {
    String? categoryId,
  }) {
    final dayKey = LocalStore.todayKey(now);
    final existing = state.dailyQuizState;
    if (existing != null &&
        existing.dayKey == dayKey &&
        existing.questionIds.isNotEmpty) {
      final questions = _repository.questionsForIds(existing.questionIds);
      if (questions.isNotEmpty) return questions;
    }
    return _repository.buildDailyQuiz(day: now, categoryId: categoryId);
  }

  List<TriviaReviewItem> _reviewPool(DateTime now) {
    return state.reviewItems.values
        .where((item) {
          if (item.isMastered) return false;
          final due = DateTime.tryParse(item.nextReviewIso ?? '');
          return due == null || !due.isAfter(now);
        })
        .toList(growable: false);
  }

  void _finishSession() {
    final session = state.activeSession;
    if (session == null) return;
    final answeredStates = session.questionStates.values
        .where((item) => item.isAnswered)
        .toList(growable: false);
    final correctCount = answeredStates
        .where((item) => item.isCorrect == true)
        .length;
    final incorrectCount = answeredStates.length - correctCount;
    final reward = _calculateRewards(
      mode: session.mode,
      correctCount: correctCount,
      answeredCount: answeredStates.length,
      isDailyReplay: session.dailyReplay,
      session: session,
    );
    final now = DateTime.now();
    final result = TriviaSessionResult(
      sessionId: session.id,
      mode: session.mode,
      categoryId: session.categoryId,
      totalAnswered: answeredStates.length,
      correctCount: correctCount,
      incorrectCount: incorrectCount,
      startedAtIso: session.startedAtIso,
      completedAtIso: now.toIso8601String(),
      questionIds: answeredStates
          .map((item) => item.questionId)
          .toList(growable: false),
      incorrectQuestionIds: answeredStates
          .where((item) => item.isCorrect == false)
          .map((item) => item.questionId)
          .toList(growable: false),
      xpEarned: reward.xp,
      oceanDropsEarned: reward.oceanDrops,
      wasPerfect: answeredStates.isNotEmpty && incorrectCount == 0,
      wasDailyReplay: session.dailyReplay,
      survivalRun: session.mode == TriviaMode.survival ? correctCount : 0,
      knowledgePathId: session.knowledgePathId,
      knowledgeStageId: session.knowledgeStageId,
      knowledgeStageTitle: session.knowledgeStageTitle,
    );

    final nextReviewItems = _updatedReviewItems(
      current: state.reviewItems,
      session: session,
      now: now,
    );
    final nextStats = _updatedStats(
      current: state.stats,
      result: result,
      session: session,
      now: now,
    );
    final nextDailyState = session.mode == TriviaMode.dailyQuiz
        ? TriviaDailyQuizState(
            dayKey: session.dailyKey ?? LocalStore.todayKey(now),
            questionIds: session.questionIds,
            completed: true,
            rewardGranted: !session.dailyReplay,
            lastSessionId: session.id,
          )
        : state.dailyQuizState;
    final pathReward = _completeKnowledgePathStage(session, now);

    state = state.copyWith(
      stats: nextStats,
      reviewItems: nextReviewItems,
      pathProgress: pathReward.updatedProgress,
      clearActiveSession: true,
      lastResult: result,
      dailyQuizState: nextDailyState,
    );
    final totalDrops = reward.oceanDrops + pathReward.reward.oceanDrops;
    if (totalDrops > 0) {
      for (var index = 0; index < totalDrops; index += 1) {
        _oceanDrops.awardDrop(
          actionType: oceanActionQuizCompleted,
          sourceModule: oceanSourceQuiz,
          referenceId: '${result.sessionId}_$index',
          metadata: {'timestamp': now.toIso8601String()},
        );
      }
    }
    if (pathReward.reward.xp > 0 || pathReward.reward.oceanDrops > 0) {
      state = state.copyWith(
        lastResult: TriviaSessionResult(
          sessionId: result.sessionId,
          mode: result.mode,
          categoryId: result.categoryId,
          totalAnswered: result.totalAnswered,
          correctCount: result.correctCount,
          incorrectCount: result.incorrectCount,
          startedAtIso: result.startedAtIso,
          completedAtIso: result.completedAtIso,
          questionIds: result.questionIds,
          incorrectQuestionIds: result.incorrectQuestionIds,
          xpEarned: result.xpEarned + pathReward.reward.xp,
          oceanDropsEarned:
              result.oceanDropsEarned + pathReward.reward.oceanDrops,
          wasPerfect: result.wasPerfect,
          wasDailyReplay: result.wasDailyReplay,
          survivalRun: result.survivalRun,
          knowledgePathId: result.knowledgePathId,
          knowledgeStageId: result.knowledgeStageId,
          knowledgeStageTitle: result.knowledgeStageTitle,
        ),
      );
    }
    _save();
  }

  TriviaRewardResult _calculateRewards({
    required TriviaMode mode,
    required int correctCount,
    required int answeredCount,
    required bool isDailyReplay,
    TriviaSession? session,
  }) {
    if (answeredCount <= 0) {
      return const TriviaRewardResult(xp: 0, oceanDrops: 0);
    }
    if (session?.isKnowledgePathSession == true) {
      return TriviaRewardResult(
        xp: session?.customXpReward ?? 0,
        oceanDrops: session?.customOceanDropReward ?? 0,
      );
    }

    var xp = 0;
    var drops = 0;
    switch (mode) {
      case TriviaMode.quickChallenge:
        xp = 10 + (correctCount * 2);
        drops = 1;
        break;
      case TriviaMode.deepDive:
        xp = 18 + (correctCount * 2);
        drops = 1;
        break;
      case TriviaMode.dailyQuiz:
        xp = isDailyReplay ? 6 + correctCount : 20 + (correctCount * 2);
        drops = isDailyReplay ? 0 : 1;
        break;
      case TriviaMode.survival:
        xp = 6 + (correctCount * 3);
        drops = correctCount >= 3 ? 1 : 0;
        break;
      case TriviaMode.reviewMistakes:
        xp = 6 + correctCount;
        drops = correctCount >= 5 ? 1 : 0;
        break;
    }
    if (correctCount == answeredCount) {
      xp += 4;
    }
    return TriviaRewardResult(xp: xp, oceanDrops: drops);
  }

  Map<String, TriviaReviewItem> _updatedReviewItems({
    required Map<String, TriviaReviewItem> current,
    required TriviaSession session,
    required DateTime now,
  }) {
    final next = Map<String, TriviaReviewItem>.from(current);
    for (final stateEntry in session.questionStates.values) {
      if (!stateEntry.isAnswered) continue;
      final question = questionById(stateEntry.questionId);
      if (question == null) continue;
      final existing =
          next[question.id] ??
          TriviaReviewItem(
            questionId: question.id,
            categoryId: question.categoryId,
          );
      final nextSeen = existing.timesSeen + 1;
      if (stateEntry.isCorrect == true) {
        final correctCount = existing.timesCorrect + 1;
        final nextMastery = _promoteMastery(
          existing.masteryState,
          correctCount,
        );
        next[question.id] = existing.copyWith(
          timesSeen: nextSeen,
          timesCorrect: correctCount,
          lastSeenIso: now.toIso8601String(),
          nextReviewIso: now.add(_intervalFor(nextMastery)).toIso8601String(),
          masteryState: nextMastery,
          priority: max(0, existing.priority - 1),
        );
      } else {
        final incorrectCount = existing.timesIncorrect + 1;
        next[question.id] = existing.copyWith(
          timesSeen: nextSeen,
          timesIncorrect: incorrectCount,
          lastSeenIso: now.toIso8601String(),
          lastIncorrectIso: now.toIso8601String(),
          nextReviewIso: now.add(const Duration(hours: 12)).toIso8601String(),
          masteryState: _demoteMastery(existing.masteryState),
          priority: existing.priority + 2,
        );
      }
    }
    return next;
  }

  TriviaUserStats _updatedStats({
    required TriviaUserStats current,
    required TriviaSessionResult result,
    required TriviaSession session,
    required DateTime now,
  }) {
    final dayKey = LocalStore.todayKey(now);
    final categoryStats = Map<String, TriviaCategoryStats>.from(
      current.categoryStats,
    );
    for (final questionId in result.questionIds) {
      final question = questionById(questionId);
      if (question == null) continue;
      final existing =
          categoryStats[question.categoryId] ??
          TriviaCategoryStats(categoryId: question.categoryId);
      final wasCorrect = !result.incorrectQuestionIds.contains(questionId);
      categoryStats[question.categoryId] = existing.copyWith(
        questionsAnswered: existing.questionsAnswered + 1,
        correct: existing.correct + (wasCorrect ? 1 : 0),
        incorrect: existing.incorrect + (wasCorrect ? 0 : 1),
      );
    }
    if (result.questionIds.isNotEmpty) {
      final focusCategory =
          result.categoryId ??
          questionById(result.questionIds.first)?.categoryId;
      if (focusCategory != null) {
        final existing =
            categoryStats[focusCategory] ??
            TriviaCategoryStats(categoryId: focusCategory);
        categoryStats[focusCategory] = existing.copyWith(
          quizzesCompleted: existing.quizzesCompleted + 1,
        );
      }
    }

    var streak = current.currentStreak;
    var longestStreak = current.longestStreak;
    if (current.lastCompletionDayKey != dayKey) {
      final previous = current.lastCompletionDayKey == null
          ? null
          : DateTime.tryParse(current.lastCompletionDayKey!);
      final currentDay = DateTime.parse(dayKey);
      if (previous != null && currentDay.difference(previous).inDays == 1) {
        streak += 1;
      } else {
        streak = 1;
      }
      if (streak > longestStreak) longestStreak = streak;
    }

    var dailyQuizStreak = current.dailyQuizStreak;
    var longestDailyQuizStreak = current.longestDailyQuizStreak;
    String? lastDailyQuizDayKey = current.lastDailyQuizDayKey;
    if (session.mode == TriviaMode.dailyQuiz && !session.dailyReplay) {
      if (current.lastDailyQuizDayKey != dayKey) {
        final previous = current.lastDailyQuizDayKey == null
            ? null
            : DateTime.tryParse(current.lastDailyQuizDayKey!);
        final currentDay = DateTime.parse(dayKey);
        if (previous != null && currentDay.difference(previous).inDays == 1) {
          dailyQuizStreak += 1;
        } else {
          dailyQuizStreak = 1;
        }
        if (dailyQuizStreak > longestDailyQuizStreak) {
          longestDailyQuizStreak = dailyQuizStreak;
        }
        lastDailyQuizDayKey = dayKey;
      }
    }

    final recentResults = [
      result,
      ...current.recentResults,
    ].take(8).toList(growable: false);

    return current.copyWith(
      totalQuestionsAnswered:
          current.totalQuestionsAnswered + result.totalAnswered,
      totalQuizzesCompleted: current.totalQuizzesCompleted + 1,
      totalCorrect: current.totalCorrect + result.correctCount,
      totalIncorrect: current.totalIncorrect + result.incorrectCount,
      totalTriviaXp: current.totalTriviaXp + result.xpEarned,
      totalTriviaOceanDrops:
          current.totalTriviaOceanDrops + result.oceanDropsEarned,
      currentStreak: streak,
      longestStreak: longestStreak,
      bestSurvivalRun: max(current.bestSurvivalRun, result.survivalRun),
      dailyQuizStreak: dailyQuizStreak,
      longestDailyQuizStreak: longestDailyQuizStreak,
      lastCompletionDayKey: dayKey,
      lastDailyQuizDayKey: lastDailyQuizDayKey,
      categoryStats: categoryStats,
      recentResults: recentResults,
    );
  }

  TriviaReviewMasteryState _promoteMastery(
    TriviaReviewMasteryState current,
    int correctCount,
  ) {
    if (correctCount >= 3) return TriviaReviewMasteryState.mastered;
    switch (current) {
      case TriviaReviewMasteryState.newItem:
        return TriviaReviewMasteryState.learning;
      case TriviaReviewMasteryState.learning:
        return TriviaReviewMasteryState.improving;
      case TriviaReviewMasteryState.improving:
      case TriviaReviewMasteryState.mastered:
        return current;
    }
  }

  TriviaReviewMasteryState _demoteMastery(TriviaReviewMasteryState current) {
    switch (current) {
      case TriviaReviewMasteryState.mastered:
        return TriviaReviewMasteryState.improving;
      case TriviaReviewMasteryState.improving:
        return TriviaReviewMasteryState.learning;
      case TriviaReviewMasteryState.learning:
      case TriviaReviewMasteryState.newItem:
        return TriviaReviewMasteryState.newItem;
    }
  }

  Duration _intervalFor(TriviaReviewMasteryState mastery) {
    switch (mastery) {
      case TriviaReviewMasteryState.newItem:
        return const Duration(hours: 12);
      case TriviaReviewMasteryState.learning:
        return const Duration(days: 1);
      case TriviaReviewMasteryState.improving:
        return const Duration(days: 3);
      case TriviaReviewMasteryState.mastered:
        return const Duration(days: 7);
    }
  }

  _KnowledgePathCompletionResult _completeKnowledgePathStage(
    TriviaSession session,
    DateTime now,
  ) {
    if (!session.isKnowledgePathSession) {
      return _KnowledgePathCompletionResult(
        updatedProgress: state.pathProgress,
        reward: const TriviaRewardResult(xp: 0, oceanDrops: 0),
      );
    }
    final path = knowledgePathById(session.knowledgePathId!);
    if (path == null) {
      return _KnowledgePathCompletionResult(
        updatedProgress: state.pathProgress,
        reward: const TriviaRewardResult(xp: 0, oceanDrops: 0),
      );
    }
    final progress = pathProgress(path.id);
    final completedStages = {
      ...progress.completedStageIds,
      session.knowledgeStageId!,
    };
    final rewardedStages = {...progress.rewardedStageIds};
    var bonusXp = 0;
    var bonusDrops = 0;
    if (!rewardedStages.contains(session.knowledgeStageId!)) {
      rewardedStages.add(session.knowledgeStageId!);
    }
    final allCompleted = completedStages.length >= path.stages.length;
    var rewardGranted = progress.pathCompletionRewardGranted;
    String? completedAtIso = progress.completedAtIso;
    if (allCompleted && !rewardGranted) {
      bonusXp += 20;
      bonusDrops += 3;
      rewardGranted = true;
      completedAtIso = now.toIso8601String();
    }
    String? nextStage;
    for (final stage in path.stages) {
      if (!completedStages.contains(stage.id)) {
        nextStage = stage.id;
        break;
      }
    }
    final updated = progress.copyWith(
      completedStageIds: completedStages.toList(growable: false),
      rewardedStageIds: rewardedStages.toList(growable: false),
      currentStageId: nextStage,
      clearCurrentStageId: nextStage == null,
      completedAtIso: completedAtIso,
      pathCompletionRewardGranted: rewardGranted,
    );
    return _KnowledgePathCompletionResult(
      updatedProgress: {...state.pathProgress, path.id: updated},
      reward: TriviaRewardResult(xp: bonusXp, oceanDrops: bonusDrops),
    );
  }
}

class _KnowledgePathCompletionResult {
  const _KnowledgePathCompletionResult({
    required this.updatedProgress,
    required this.reward,
  });

  final Map<String, TriviaKnowledgePathProgress> updatedProgress;
  final TriviaRewardResult reward;
}
