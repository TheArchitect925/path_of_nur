import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/persistence/local_store.dart';
import '../../../journey/drops/application/journey_drops_service.dart';
import '../../../journey/xp/application/journey_xp_providers.dart';
import '../data/wudu_content.dart';
import '../models/wudu_models.dart';

const _wuduQuizStorageKey = 'learn.salah.wudu.quiz.v1';
const _wuduQuizSchemaVersion = 1;

class WuduQuizRewardSummary {
  const WuduQuizRewardSummary({
    required this.xpAwarded,
    required this.oceanDropsAwarded,
  });

  final int xpAwarded;
  final int oceanDropsAwarded;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'xpAwarded': xpAwarded,
    'oceanDropsAwarded': oceanDropsAwarded,
  };

  static WuduQuizRewardSummary? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return WuduQuizRewardSummary(
      xpAwarded: (json['xpAwarded'] as num?)?.toInt() ?? 0,
      oceanDropsAwarded: (json['oceanDropsAwarded'] as num?)?.toInt() ?? 0,
    );
  }
}

class WuduQuizState {
  const WuduQuizState({
    this.currentQuestionIndex = 0,
    this.selectedAnswers = const <String, String>{},
    this.submittedQuestionIds = const <String>{},
    this.finished = false,
    this.completedOnce = false,
    this.lastCompletedAtIso,
    this.lastViewedAtIso,
    this.rewardSummary,
  });

  final int currentQuestionIndex;
  final Map<String, String> selectedAnswers;
  final Set<String> submittedQuestionIds;
  final bool finished;
  final bool completedOnce;
  final String? lastCompletedAtIso;
  final String? lastViewedAtIso;
  final WuduQuizRewardSummary? rewardSummary;

  bool get hasPartialProgress =>
      selectedAnswers.isNotEmpty || submittedQuestionIds.isNotEmpty;

  bool get hasAnsweredCurrentQuestion =>
      selectedAnswers.isNotEmpty || submittedQuestionIds.isNotEmpty;

  bool isSubmitted(String questionId) =>
      submittedQuestionIds.contains(questionId);

  String? selectedAnswerFor(String questionId) => selectedAnswers[questionId];

  WuduQuizState copyWith({
    int? currentQuestionIndex,
    Map<String, String>? selectedAnswers,
    Set<String>? submittedQuestionIds,
    bool? finished,
    bool? completedOnce,
    String? lastCompletedAtIso,
    String? lastViewedAtIso,
    WuduQuizRewardSummary? rewardSummary,
  }) {
    return WuduQuizState(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      submittedQuestionIds: submittedQuestionIds ?? this.submittedQuestionIds,
      finished: finished ?? this.finished,
      completedOnce: completedOnce ?? this.completedOnce,
      lastCompletedAtIso: lastCompletedAtIso ?? this.lastCompletedAtIso,
      lastViewedAtIso: lastViewedAtIso ?? this.lastViewedAtIso,
      rewardSummary: rewardSummary ?? this.rewardSummary,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'schemaVersion': _wuduQuizSchemaVersion,
    'currentQuestionIndex': currentQuestionIndex,
    'selectedAnswers': selectedAnswers,
    'submittedQuestionIds': submittedQuestionIds.toList(growable: false),
    'finished': finished,
    'completedOnce': completedOnce,
    'lastCompletedAtIso': lastCompletedAtIso,
    'lastViewedAtIso': lastViewedAtIso,
    'rewardSummary': rewardSummary?.toJson(),
  };

  static WuduQuizState fromJson(Map<String, dynamic>? json) {
    if (json == null) return const WuduQuizState();
    return WuduQuizState(
      currentQuestionIndex:
          (json['currentQuestionIndex'] as num?)?.toInt() ?? 0,
      selectedAnswers: _toStringMap(json['selectedAnswers']),
      submittedQuestionIds: _toStringSet(json['submittedQuestionIds']),
      finished: json['finished'] == true,
      completedOnce: json['completedOnce'] == true,
      lastCompletedAtIso: json['lastCompletedAtIso']?.toString(),
      lastViewedAtIso: json['lastViewedAtIso']?.toString(),
      rewardSummary: WuduQuizRewardSummary.fromJson(
        json['rewardSummary'] is Map<String, dynamic>
            ? json['rewardSummary'] as Map<String, dynamic>
            : json['rewardSummary'] is Map
            ? (json['rewardSummary'] as Map).map(
                (key, value) => MapEntry(key.toString(), value),
              )
            : null,
      ),
    );
  }
}

class WuduQuizController extends StateNotifier<WuduQuizState> {
  WuduQuizController(this._ref)
    : _store = _ref.read(localStoreProvider),
      super(const WuduQuizState()) {
    _load();
  }

  final Ref _ref;
  final LocalStore _store;

  void _load() {
    state = _normalizeState(
      WuduQuizState.fromJson(_store.getJsonMap(_wuduQuizStorageKey)),
    );
  }

  void _save() {
    state = _normalizeState(state).copyWith(lastViewedAtIso: _nowIso());
    unawaited(_store.setJsonMap(_wuduQuizStorageKey, state.toJson()));
  }

  void selectAnswer(String questionId, String optionId) {
    if (state.finished || state.isSubmitted(questionId)) return;
    state = state.copyWith(
      selectedAnswers: <String, String>{
        ...state.selectedAnswers,
        questionId: optionId,
      },
    );
    _save();
  }

  void submitCurrentAnswer() {
    if (state.finished) return;
    final content = _quizContent();
    final question = content.questions[_questionIndex(content)];
    final selected = state.selectedAnswerFor(question.id);
    if (selected == null || selected.isEmpty) return;
    state = state.copyWith(
      submittedQuestionIds: <String>{
        ...state.submittedQuestionIds,
        question.id,
      },
    );
    _save();
  }

  void goNext() {
    if (state.finished) return;
    final content = _quizContent();
    final question = content.questions[_questionIndex(content)];
    if (!state.isSubmitted(question.id)) return;
    if (state.currentQuestionIndex >= content.questions.length - 1) {
      _completeQuiz();
      return;
    }
    state = state.copyWith(
      currentQuestionIndex: state.currentQuestionIndex + 1,
    );
    _save();
  }

  void restartQuiz() {
    state = state.copyWith(
      currentQuestionIndex: 0,
      selectedAnswers: <String, String>{},
      submittedQuestionIds: <String>{},
      finished: false,
    );
    _save();
  }

  int scoreFor(List<String> questionIds) {
    final content = _quizContent();
    var score = 0;
    for (final question in content.questions.where(
      (q) => questionIds.contains(q.id),
    )) {
      if (state.selectedAnswerFor(question.id) == question.correctOptionId) {
        score += 1;
      }
    }
    return score;
  }

  int totalQuestions() => _quizContent().questions.length;

  int totalScore() =>
      scoreFor(_quizContent().questions.map((q) => q.id).toList());

  WuduQuizQuestion currentQuestion() {
    final content = _quizContent();
    return content.questions[_questionIndex(content)];
  }

  bool currentAnswerIsCorrect() {
    final question = currentQuestion();
    return state.selectedAnswerFor(question.id) == question.correctOptionId;
  }

  void _completeQuiz() {
    final now = DateTime.now();
    final score = totalScore();
    final questionCount = totalQuestions();
    final xpEntries = _ref
        .read(journeyXpSummaryProvider.notifier)
        .awardLearningXp(
          sourceRef: 'learn:wudu_quiz:complete',
          occurredAt: now,
          sourceModule: 'learn_wudu_quiz',
          xp: 6,
          metadata: <String, Object?>{
            'quizId': 'wudu_quiz_v1',
            'score': score,
            'questionCount': questionCount,
          },
        );
    final drop = _ref
        .read(journeyDropsServiceProvider)
        .awardLearningDrop(
          sourceRef: 'learn:wudu_quiz:complete',
          occurredAt: now,
          metadata: <String, Object?>{'quizId': 'wudu_quiz_v1', 'score': score},
        );
    state = state.copyWith(
      finished: true,
      completedOnce: true,
      lastCompletedAtIso: now.toIso8601String(),
      rewardSummary: WuduQuizRewardSummary(
        xpAwarded: xpEntries.fold<int>(
          0,
          (sum, entry) => sum + entry.awardedXp,
        ),
        oceanDropsAwarded: drop == null ? 0 : 1,
      ),
    );
    _save();
  }

  int _questionIndex(WuduQuizContent content) =>
      state.currentQuestionIndex.clamp(0, content.questions.length - 1);

  WuduQuizContent _quizContent() => _ref.read(wuduQuizContentProvider);

  WuduQuizState _normalizeState(WuduQuizState input) {
    final content = _quizContent();
    final validQuestionIds = content.questions.map((q) => q.id).toSet();
    final selectedAnswers = <String, String>{
      for (final entry in input.selectedAnswers.entries)
        if (validQuestionIds.contains(entry.key)) entry.key: entry.value,
    };
    final submitted = input.submittedQuestionIds
        .where(validQuestionIds.contains)
        .toSet();
    final currentIndex = input.finished
        ? (content.questions.length - 1).clamp(0, content.questions.length - 1)
        : input.currentQuestionIndex.clamp(0, content.questions.length - 1);

    final normalizedFinished =
        input.finished && submitted.length >= content.questions.length;
    final normalizedCompleted = input.completedOnce || normalizedFinished;

    return input.copyWith(
      currentQuestionIndex: currentIndex,
      selectedAnswers: selectedAnswers,
      submittedQuestionIds: submitted,
      finished: normalizedFinished,
      completedOnce: normalizedCompleted,
    );
  }

  String _nowIso() => DateTime.now().toIso8601String();
}

final wuduQuizControllerProvider =
    StateNotifierProvider<WuduQuizController, WuduQuizState>(
      (ref) => WuduQuizController(ref),
      dependencies: <ProviderOrFamily>[wuduQuizContentProvider],
    );

final wuduQuizLocalizationsProvider = Provider<AppLocalizations>(
  (ref) {
    throw UnimplementedError('Override only in the Wudu quiz subtree.');
  },
  dependencies: const <ProviderOrFamily>[],
);

final wuduQuizContentProvider = Provider<WuduQuizContent>(
  (ref) {
    final l10n = ref.watch(wuduQuizLocalizationsProvider);
    return buildWuduQuizContent(l10n, buildWuduStepContent(l10n));
  },
  dependencies: <ProviderOrFamily>[wuduQuizLocalizationsProvider],
);

Map<String, String> _toStringMap(dynamic raw) {
  if (raw is! Map) return const <String, String>{};
  return raw.map((key, value) => MapEntry(key.toString(), value.toString()));
}

Set<String> _toStringSet(dynamic raw) {
  if (raw is! List) return const <String>{};
  return raw.map((value) => value.toString()).toSet();
}
