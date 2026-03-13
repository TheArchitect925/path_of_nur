import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ocean/application/ocean_drops_provider.dart';
import '../../../../shared/persistence/local_store.dart';
import '../domain/prophet_quiz.dart';
import 'prophet_quiz_pool_service.dart';

class ProphetQuizState {
  const ProphetQuizState({
    this.totalQuizzesTaken = 0,
    this.bestScore = 0,
    this.lastScore = 0,
    this.lastDifficulty = ProphetQuizDifficulty.easy,
    this.lastMode,
    this.lastProphetId,
    this.lastEraId,
    this.inProgress = false,
    this.activeQuestionIds = const <String>[],
    this.currentIndex = 0,
    this.selectedAnswers = const <String, int>{},
    this.lastResult,
  });

  final int totalQuizzesTaken;
  final int bestScore;
  final int lastScore;
  final ProphetQuizDifficulty lastDifficulty;
  final ProphetQuizMode? lastMode;
  final String? lastProphetId;
  final String? lastEraId;
  final bool inProgress;
  final List<String> activeQuestionIds;
  final int currentIndex;
  final Map<String, int> selectedAnswers;
  final ProphetQuizResult? lastResult;

  ProphetQuizState copyWith({
    int? totalQuizzesTaken,
    int? bestScore,
    int? lastScore,
    ProphetQuizDifficulty? lastDifficulty,
    ProphetQuizMode? lastMode,
    bool clearLastMode = false,
    String? lastProphetId,
    bool clearLastProphetId = false,
    String? lastEraId,
    bool clearLastEraId = false,
    bool? inProgress,
    List<String>? activeQuestionIds,
    int? currentIndex,
    Map<String, int>? selectedAnswers,
    ProphetQuizResult? lastResult,
    bool clearLastResult = false,
  }) {
    return ProphetQuizState(
      totalQuizzesTaken: totalQuizzesTaken ?? this.totalQuizzesTaken,
      bestScore: bestScore ?? this.bestScore,
      lastScore: lastScore ?? this.lastScore,
      lastDifficulty: lastDifficulty ?? this.lastDifficulty,
      lastMode: clearLastMode ? null : (lastMode ?? this.lastMode),
      lastProphetId: clearLastProphetId
          ? null
          : (lastProphetId ?? this.lastProphetId),
      lastEraId: clearLastEraId ? null : (lastEraId ?? this.lastEraId),
      inProgress: inProgress ?? this.inProgress,
      activeQuestionIds: activeQuestionIds ?? this.activeQuestionIds,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      lastResult: clearLastResult ? null : (lastResult ?? this.lastResult),
    );
  }

  int get totalQuestions => activeQuestionIds.length;

  bool get isQuizComplete =>
      inProgress &&
      currentIndex >= activeQuestionIds.length &&
      activeQuestionIds.isNotEmpty;
}

class ProphetQuizController extends StateNotifier<ProphetQuizState> {
  ProphetQuizController(this._store, this._oceanDrops)
    : super(const ProphetQuizState()) {
    _load();
  }

  final LocalStore _store;
  final OceanDropService _oceanDrops;
  final List<ProphetQuizQuestion> _questionPool =
      ProphetQuizPoolService.buildExpandedPool();

  static const _key = 'learn.prophets.quiz.state';

  List<ProphetQuizQuestion> get questionPool => _questionPool;

  void _load() {
    final raw = _store.getJsonMap(_key);
    if (raw == null) return;

    final difficultyName = raw['lastDifficulty']?.toString();
    final modeName = raw['lastMode']?.toString();
    final idsRaw = raw['activeQuestionIds'];
    final answersRaw = raw['selectedAnswers'];

    final ids = <String>[];
    if (idsRaw is List) {
      for (final item in idsRaw) {
        if (item is String && item.trim().isNotEmpty) ids.add(item);
      }
    }

    final answers = <String, int>{};
    if (answersRaw is Map) {
      for (final entry in answersRaw.entries) {
        final value = int.tryParse(entry.value.toString());
        if (value != null) answers[entry.key.toString()] = value;
      }
    }

    final total = int.tryParse(raw['lastTotal']?.toString() ?? '') ?? 0;
    final score = int.tryParse(raw['lastScore']?.toString() ?? '') ?? 0;

    state = ProphetQuizState(
      totalQuizzesTaken:
          int.tryParse(raw['totalQuizzesTaken']?.toString() ?? '') ?? 0,
      bestScore: int.tryParse(raw['bestScore']?.toString() ?? '') ?? 0,
      lastScore: score,
      lastDifficulty: _difficultyFromName(difficultyName),
      lastMode: _modeFromName(modeName),
      lastProphetId: _nullableString(raw['lastProphetId']),
      lastEraId: _nullableString(raw['lastEraId']),
      inProgress: raw['inProgress'] == true,
      activeQuestionIds: ids,
      currentIndex: int.tryParse(raw['currentIndex']?.toString() ?? '') ?? 0,
      selectedAnswers: answers,
      lastResult: total > 0
          ? ProphetQuizResult(score: score, total: total)
          : null,
    );
  }

  void _save() {
    final data = <String, dynamic>{
      'totalQuizzesTaken': state.totalQuizzesTaken,
      'bestScore': state.bestScore,
      'lastScore': state.lastScore,
      'lastTotal': state.lastResult?.total ?? 0,
      'lastDifficulty': state.lastDifficulty.name,
      'lastMode': state.lastMode?.name,
      'lastProphetId': state.lastProphetId,
      'lastEraId': state.lastEraId,
      'inProgress': state.inProgress,
      'activeQuestionIds': state.activeQuestionIds,
      'currentIndex': state.currentIndex,
      'selectedAnswers': state.selectedAnswers,
    };
    _store.setJsonMap(_key, data);
  }

  void startQuiz({
    required ProphetQuizDifficulty difficulty,
    ProphetQuizMode? mode,
    String? prophetId,
    String? eraId,
    int totalQuestions = 5,
  }) {
    final filtered = questionPool.where((q) {
      if (q.difficulty != difficulty) return false;
      if (mode != null && q.mode != mode) return false;
      if (prophetId != null && prophetId.isNotEmpty) {
        if (q.relatedProphetId != prophetId) return false;
      }
      if (eraId != null && eraId.isNotEmpty) {
        if (q.eraId != eraId) return false;
      }
      return true;
    }).toList();

    final source = filtered.isNotEmpty
        ? filtered
        : questionPool.where((q) {
            if (q.difficulty != difficulty) return false;
            if (prophetId != null &&
                prophetId.isNotEmpty &&
                q.relatedProphetId != prophetId) {
              return false;
            }
            if (eraId != null && eraId.isNotEmpty && q.eraId != eraId) {
              return false;
            }
            return true;
          }).toList();
    final pool = source.isNotEmpty ? source : questionPool;

    final shuffled = [...pool]..shuffle(Random());
    final picked = shuffled
        .take(totalQuestions.clamp(3, 10))
        .map((e) => e.id)
        .toList();

    state = state.copyWith(
      inProgress: true,
      activeQuestionIds: picked,
      currentIndex: 0,
      selectedAnswers: const <String, int>{},
      lastDifficulty: difficulty,
      lastMode: mode,
      lastProphetId: prophetId,
      lastEraId: eraId,
      clearLastResult: true,
    );
    _save();
  }

  void answerCurrent(int selectedIndex) {
    if (!state.inProgress ||
        state.currentIndex >= state.activeQuestionIds.length) {
      return;
    }
    final qid = state.activeQuestionIds[state.currentIndex];
    final answers = {...state.selectedAnswers, qid: selectedIndex};
    state = state.copyWith(selectedAnswers: answers);
    _save();
  }

  void nextQuestion() {
    if (!state.inProgress) return;
    final next = state.currentIndex + 1;
    if (next >= state.activeQuestionIds.length) {
      _finishQuiz();
      return;
    }
    state = state.copyWith(currentIndex: next);
    _save();
  }

  void abandonQuiz() {
    state = state.copyWith(
      inProgress: false,
      activeQuestionIds: const <String>[],
      currentIndex: 0,
      selectedAnswers: const <String, int>{},
    );
    _save();
  }

  List<ProphetQuizQuestion> activeQuestions() {
    final byId = {for (final q in questionPool) q.id: q};
    return state.activeQuestionIds
        .map((id) => byId[id])
        .whereType<ProphetQuizQuestion>()
        .toList();
  }

  int scoreForCurrentRun() {
    var score = 0;
    final byId = {for (final q in questionPool) q.id: q};
    for (final entry in state.selectedAnswers.entries) {
      final q = byId[entry.key];
      if (q != null && q.correctAnswerIndex == entry.value) score += 1;
    }
    return score;
  }

  void _finishQuiz() {
    final score = scoreForCurrentRun();
    final total = state.activeQuestionIds.length;
    final referenceId = [
      state.lastMode?.name ?? 'general',
      state.lastDifficulty.name,
      state.lastProphetId ?? 'all',
      state.lastEraId ?? 'all',
    ].join(':');
    final best = score > state.bestScore ? score : state.bestScore;
    state = state.copyWith(
      inProgress: false,
      currentIndex: state.activeQuestionIds.length,
      totalQuizzesTaken: state.totalQuizzesTaken + 1,
      bestScore: best,
      lastScore: score,
      lastResult: ProphetQuizResult(score: score, total: total),
    );
    _save();
    _oceanDrops.awardDrop(
      actionType: oceanActionQuizCompleted,
      sourceModule: oceanSourceQuiz,
      referenceId: referenceId,
      metadata: {'timestamp': DateTime.now().toIso8601String()},
    );
  }

  ProphetQuizDifficulty _difficultyFromName(String? name) {
    if (name == null) return ProphetQuizDifficulty.easy;
    for (final item in ProphetQuizDifficulty.values) {
      if (item.name == name) return item;
    }
    return ProphetQuizDifficulty.easy;
  }

  ProphetQuizMode? _modeFromName(String? name) {
    if (name == null || name.isEmpty) return null;
    for (final item in ProphetQuizMode.values) {
      if (item.name == name) return item;
    }
    return null;
  }

  String? _nullableString(Object? value) {
    final asString = value?.toString();
    if (asString == null || asString.trim().isEmpty) return null;
    return asString;
  }
}

final prophetQuizControllerProvider =
    StateNotifierProvider<ProphetQuizController, ProphetQuizState>((ref) {
      return ProphetQuizController(
        ref.watch(localStoreProvider),
        ref.read(oceanDropServiceProvider),
      );
    });
