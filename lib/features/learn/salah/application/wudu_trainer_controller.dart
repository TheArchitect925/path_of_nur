import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../journey/application/learning_journey_progress_provider.dart';
import '../data/wudu_content.dart';

const _wuduTrainerStorageKey = 'learn.salah.wudu.trainer.v2';
const _wuduTrainerSchemaVersion = 3;

enum WuduTrainerMode { guided, checklist }

class WuduTrainerRewardSummary {
  const WuduTrainerRewardSummary({
    required this.stageCompleted,
    required this.xpAwarded,
    required this.oceanDropsAwarded,
    required this.currentStreakDays,
  });

  final bool stageCompleted;
  final int xpAwarded;
  final int oceanDropsAwarded;
  final int currentStreakDays;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'stageCompleted': stageCompleted,
    'xpAwarded': xpAwarded,
    'oceanDropsAwarded': oceanDropsAwarded,
    'currentStreakDays': currentStreakDays,
  };

  static WuduTrainerRewardSummary? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return WuduTrainerRewardSummary(
      stageCompleted: json['stageCompleted'] == true,
      xpAwarded: (json['xpAwarded'] as num?)?.toInt() ?? 0,
      oceanDropsAwarded: (json['oceanDropsAwarded'] as num?)?.toInt() ?? 0,
      currentStreakDays: (json['currentStreakDays'] as num?)?.toInt() ?? 0,
    );
  }
}

class WuduTrainerState {
  const WuduTrainerState({
    this.mode = WuduTrainerMode.guided,
    this.currentStepIndex = 0,
    this.completedStepNumbers = const <int>{},
    this.skippedStepNumbers = const <int>{},
    this.reviewModeEnabled = false,
    this.guidedFinished = false,
    this.completedOnce = false,
    this.lastCompletedAtIso,
    this.lastViewedAtIso,
    this.rewardSummary,
    this.lastOutOfOrderStepNumber,
  });

  final WuduTrainerMode mode;
  final int currentStepIndex;
  final Set<int> completedStepNumbers;
  final Set<int> skippedStepNumbers;
  final bool reviewModeEnabled;
  final bool guidedFinished;
  final bool completedOnce;
  final String? lastCompletedAtIso;
  final String? lastViewedAtIso;
  final WuduTrainerRewardSummary? rewardSummary;
  final int? lastOutOfOrderStepNumber;

  int get totalSteps => wuduTrainerStepCount;

  int get currentStepNumber {
    if (currentStepIndex < 0) return 1;
    if (currentStepIndex >= totalSteps) return totalSteps;
    return currentStepIndex + 1;
  }

  bool get hasPartialProgress =>
      currentStepIndex > 0 ||
      completedStepNumbers.isNotEmpty ||
      skippedStepNumbers.isNotEmpty;

  bool get shouldOfferResume => hasPartialProgress && !guidedFinished;

  bool get allStepsCompleted => completedStepNumbers.length >= totalSteps;

  int get resumeStepIndex {
    if (guidedFinished || allStepsCompleted) {
      return 0;
    }
    for (var stepNumber = 1; stepNumber <= totalSteps; stepNumber += 1) {
      if (!completedStepNumbers.contains(stepNumber)) {
        return stepNumber - 1;
      }
    }
    return currentStepIndex.clamp(0, totalSteps - 1);
  }

  int get resumeStepNumber => resumeStepIndex + 1;

  bool isCompleted(int stepNumber) => completedStepNumbers.contains(stepNumber);

  bool isSkipped(int stepNumber) => skippedStepNumbers.contains(stepNumber);

  bool isProcessed(int stepNumber) =>
      isCompleted(stepNumber) || isSkipped(stepNumber);

  bool get canMoveNext {
    if (guidedFinished) return false;
    if (reviewModeEnabled) return true;
    return isProcessed(currentStepNumber);
  }

  WuduTrainerState copyWith({
    WuduTrainerMode? mode,
    int? currentStepIndex,
    Set<int>? completedStepNumbers,
    Set<int>? skippedStepNumbers,
    bool? reviewModeEnabled,
    bool? guidedFinished,
    bool? completedOnce,
    String? lastCompletedAtIso,
    String? lastViewedAtIso,
    WuduTrainerRewardSummary? rewardSummary,
    int? lastOutOfOrderStepNumber,
    bool clearOutOfOrder = false,
  }) {
    return WuduTrainerState(
      mode: mode ?? this.mode,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      completedStepNumbers: completedStepNumbers ?? this.completedStepNumbers,
      skippedStepNumbers: skippedStepNumbers ?? this.skippedStepNumbers,
      reviewModeEnabled: reviewModeEnabled ?? this.reviewModeEnabled,
      guidedFinished: guidedFinished ?? this.guidedFinished,
      completedOnce: completedOnce ?? this.completedOnce,
      lastCompletedAtIso: lastCompletedAtIso ?? this.lastCompletedAtIso,
      lastViewedAtIso: lastViewedAtIso ?? this.lastViewedAtIso,
      rewardSummary: rewardSummary ?? this.rewardSummary,
      lastOutOfOrderStepNumber: clearOutOfOrder
          ? null
          : (lastOutOfOrderStepNumber ?? this.lastOutOfOrderStepNumber),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'schemaVersion': _wuduTrainerSchemaVersion,
    'mode': mode.name,
    'currentStepIndex': currentStepIndex,
    'completedStepNumbers': completedStepNumbers.toList(growable: false),
    'skippedStepNumbers': skippedStepNumbers.toList(growable: false),
    'reviewModeEnabled': reviewModeEnabled,
    'guidedFinished': guidedFinished,
    'completedOnce': completedOnce,
    'lastCompletedAtIso': lastCompletedAtIso,
    'lastViewedAtIso': lastViewedAtIso,
    'rewardSummary': rewardSummary?.toJson(),
  };

  static WuduTrainerState fromJson(Map<String, dynamic>? json) {
    if (json == null) return const WuduTrainerState();
    final modeName = json['mode']?.toString();
    final mode = WuduTrainerMode.values.firstWhere(
      (value) => value.name == modeName,
      orElse: () => WuduTrainerMode.guided,
    );
    return WuduTrainerState(
      mode: mode,
      currentStepIndex:
          (json['currentStepIndex'] as num?)?.toInt().clamp(
            0,
            wuduTrainerStepCount - 1,
          ) ??
          0,
      completedStepNumbers: _toIntSet(json['completedStepNumbers']),
      skippedStepNumbers: _toIntSet(json['skippedStepNumbers']),
      reviewModeEnabled: json['reviewModeEnabled'] == true,
      guidedFinished: json['guidedFinished'] == true,
      completedOnce: json['completedOnce'] == true,
      lastCompletedAtIso: json['lastCompletedAtIso']?.toString(),
      lastViewedAtIso: json['lastViewedAtIso']?.toString(),
      rewardSummary: WuduTrainerRewardSummary.fromJson(
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

class WuduTrainerController extends StateNotifier<WuduTrainerState> {
  WuduTrainerController(this._ref)
    : _store = _ref.read(localStoreProvider),
      super(const WuduTrainerState()) {
    _load();
  }

  final Ref _ref;
  final LocalStore _store;

  void _load() {
    state = _normalizeState(
      WuduTrainerState.fromJson(_store.getJsonMap(_wuduTrainerStorageKey)),
    );
  }

  void _save() {
    state = state.copyWith(
      currentStepIndex: state.currentStepIndex.clamp(0, state.totalSteps - 1),
      completedStepNumbers: state.completedStepNumbers
          .where(
            (stepNumber) => stepNumber >= 1 && stepNumber <= wuduTrainerStepCount,
          )
          .toSet(),
      skippedStepNumbers: state.skippedStepNumbers
          .where(
            (stepNumber) =>
                stepNumber >= 1 && stepNumber <= wuduTrainerStepCount,
          )
          .toSet(),
      lastViewedAtIso: _nowIso(),
      clearOutOfOrder:
          state.lastOutOfOrderStepNumber != null &&
          (state.lastOutOfOrderStepNumber! < 1 ||
              state.lastOutOfOrderStepNumber! > wuduTrainerStepCount),
    );
    unawaited(_store.setJsonMap(_wuduTrainerStorageKey, state.toJson()));
  }

  void setMode(WuduTrainerMode mode) {
    state = state.copyWith(mode: mode, clearOutOfOrder: true);
    _save();
  }

  void toggleReviewMode() {
    state = state.copyWith(reviewModeEnabled: !state.reviewModeEnabled);
    _save();
  }

  void openReviewAllSteps() {
    state = state.copyWith(
      mode: WuduTrainerMode.checklist,
      reviewModeEnabled: true,
      clearOutOfOrder: true,
    );
    _save();
  }

  void showCompletionSummary() {
    if (!state.completedOnce) return;
    state = state.copyWith(
      mode: WuduTrainerMode.guided,
      guidedFinished: true,
      reviewModeEnabled: false,
      clearOutOfOrder: true,
    );
    _save();
  }

  void jumpToStepIndex(int index) {
    state = state.copyWith(
      currentStepIndex: index.clamp(0, state.totalSteps - 1),
      mode: WuduTrainerMode.guided,
      guidedFinished: false,
      clearOutOfOrder: true,
    );
    _save();
  }

  void goPrevious() {
    if (state.currentStepIndex <= 0) return;
    state = state.copyWith(
      currentStepIndex: state.currentStepIndex - 1,
      clearOutOfOrder: true,
    );
    _save();
  }

  void goNext() {
    if (!state.canMoveNext) return;
    if (state.currentStepIndex >= state.totalSteps - 1) {
      _finalizeCompletion();
      return;
    }
    state = state.copyWith(
      currentStepIndex: state.currentStepIndex + 1,
      clearOutOfOrder: true,
    );
    _save();
  }

  void completeCurrentStep() {
    _markStepCompleted(state.currentStepNumber);
    _advanceAfterAction();
  }

  void toggleChecklistStep(int stepNumber) {
    final completed = {...state.completedStepNumbers};
    final skipped = {...state.skippedStepNumbers};
    final isOutOfOrder = !_isStepRecommended(stepNumber);

    if (completed.contains(stepNumber)) {
      completed.remove(stepNumber);
    } else {
      completed.add(stepNumber);
      skipped.remove(stepNumber);
    }

    HapticFeedback.selectionClick();
    state = state.copyWith(
      completedStepNumbers: completed,
      skippedStepNumbers: skipped,
      lastOutOfOrderStepNumber: isOutOfOrder ? stepNumber : null,
      clearOutOfOrder: !isOutOfOrder,
    );
    if (state.allStepsCompleted) {
      _finalizeCompletion();
      return;
    }
    _save();
  }

  void resetProgress() {
    state = state.copyWith(
      currentStepIndex: 0,
      completedStepNumbers: <int>{},
      skippedStepNumbers: <int>{},
      reviewModeEnabled: false,
      guidedFinished: false,
      clearOutOfOrder: true,
    );
    _save();
  }

  void restartGuided() {
    state = state.copyWith(
      mode: WuduTrainerMode.guided,
      currentStepIndex: 0,
      completedStepNumbers: <int>{},
      skippedStepNumbers: <int>{},
      reviewModeEnabled: false,
      guidedFinished: false,
      clearOutOfOrder: true,
    );
    _save();
  }

  void _markStepCompleted(int stepNumber) {
    final completed = {...state.completedStepNumbers, stepNumber};
    final skipped = {...state.skippedStepNumbers}..remove(stepNumber);
    HapticFeedback.lightImpact();
    state = state.copyWith(
      completedStepNumbers: completed,
      skippedStepNumbers: skipped,
      clearOutOfOrder: true,
    );
  }

  void _advanceAfterAction() {
    if (state.currentStepIndex >= state.totalSteps - 1) {
      _finalizeCompletion();
      return;
    }
    state = state.copyWith(
      currentStepIndex: state.currentStepIndex + 1,
      clearOutOfOrder: true,
    );
    _save();
  }

  void _finalizeCompletion() {
    final result = _ref
        .read(learningJourneyProgressProvider.notifier)
        .completeStage(journeyId: 'journey-of-wudu', stageId: 'wudu-trainer');
    state = state.copyWith(
      guidedFinished: true,
      completedOnce: true,
      lastCompletedAtIso: _nowIso(),
      rewardSummary: WuduTrainerRewardSummary(
        stageCompleted: result.stageCompleted,
        xpAwarded: result.xpAwarded,
        oceanDropsAwarded: result.oceanDropsAwarded,
        currentStreakDays: result.currentStreakDays,
      ),
      clearOutOfOrder: true,
    );
    _save();
  }

  bool _isStepRecommended(int stepNumber) {
    for (var index = 1; index < stepNumber; index += 1) {
      if (!state.completedStepNumbers.contains(index)) {
        return false;
      }
    }
    return true;
  }

  WuduTrainerState _normalizeState(WuduTrainerState input) {
    final completed = input.completedStepNumbers
        .where(
          (stepNumber) => stepNumber >= 1 && stepNumber <= wuduTrainerStepCount,
        )
        .toSet();
    final skipped = input.skippedStepNumbers
        .where(
          (stepNumber) =>
              stepNumber >= 1 &&
              stepNumber <= wuduTrainerStepCount &&
              !completed.contains(stepNumber),
        )
        .toSet();

    final isComplete =
        input.completedOnce || completed.length >= wuduTrainerStepCount;
    final currentIndex = isComplete
        ? (input.currentStepIndex.clamp(0, wuduTrainerStepCount - 1))
        : _resumeIndexFor(
            currentIndex: input.currentStepIndex,
            completed: completed,
          );

    return input.copyWith(
      currentStepIndex: currentIndex,
      completedStepNumbers: completed,
      skippedStepNumbers: skipped,
      completedOnce: isComplete,
      guidedFinished: isComplete ? input.guidedFinished : false,
      clearOutOfOrder:
          input.lastOutOfOrderStepNumber != null &&
          (input.lastOutOfOrderStepNumber! < 1 ||
              input.lastOutOfOrderStepNumber! > wuduTrainerStepCount),
    );
  }

  int _resumeIndexFor({
    required int currentIndex,
    required Set<int> completed,
  }) {
    final clampedCurrent = currentIndex.clamp(0, wuduTrainerStepCount - 1);
    final currentStepNumber = clampedCurrent + 1;
    if (!completed.contains(currentStepNumber)) {
      return clampedCurrent;
    }
    for (
      var stepNumber = 1;
      stepNumber <= wuduTrainerStepCount;
      stepNumber += 1
    ) {
      if (!completed.contains(stepNumber)) {
        return stepNumber - 1;
      }
    }
    return clampedCurrent;
  }

  String _nowIso() => DateTime.now().toIso8601String();
}

final wuduTrainerControllerProvider =
    StateNotifierProvider<WuduTrainerController, WuduTrainerState>(
      (ref) => WuduTrainerController(ref),
    );

Set<int> _toIntSet(dynamic raw) {
  if (raw is! List) return <int>{};
  return raw.map((value) => (value as num?)?.toInt()).whereType<int>().toSet();
}
