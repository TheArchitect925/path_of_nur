import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/wudu_content.dart';

enum WuduTrainerMode { guided, checklist, kids }

class WuduTrainerState {
  const WuduTrainerState({
    this.mode = WuduTrainerMode.guided,
    this.currentStepIndex = 0,
    this.completedStepNumbers = const <int>{},
    this.skippedStepNumbers = const <int>{},
    this.reviewModeEnabled = false,
    this.guidedFinished = false,
    this.lastOutOfOrderStepNumber,
  });

  final WuduTrainerMode mode;
  final int currentStepIndex;
  final Set<int> completedStepNumbers;
  final Set<int> skippedStepNumbers;
  final bool reviewModeEnabled;
  final bool guidedFinished;
  final int? lastOutOfOrderStepNumber;

  int get totalSteps => wuduContent.steps.length;

  int get currentStepNumber {
    if (currentStepIndex < 0) return 1;
    if (currentStepIndex >= totalSteps) return totalSteps;
    return currentStepIndex + 1;
  }

  bool get allStepsProcessed {
    return (completedStepNumbers.length + skippedStepNumbers.length) >=
        totalSteps;
  }

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
      lastOutOfOrderStepNumber: clearOutOfOrder
          ? null
          : (lastOutOfOrderStepNumber ?? this.lastOutOfOrderStepNumber),
    );
  }
}

class WuduTrainerController extends StateNotifier<WuduTrainerState> {
  WuduTrainerController() : super(const WuduTrainerState());

  void setMode(WuduTrainerMode mode) {
    state = state.copyWith(mode: mode, clearOutOfOrder: true);
  }

  void toggleReviewMode() {
    state = state.copyWith(reviewModeEnabled: !state.reviewModeEnabled);
  }

  void jumpToStepIndex(int index) {
    final clamped = index.clamp(0, state.totalSteps - 1);
    state = state.copyWith(
      currentStepIndex: clamped,
      mode: WuduTrainerMode.guided,
      guidedFinished: false,
      clearOutOfOrder: true,
    );
  }

  void goPrevious() {
    if (state.currentStepIndex <= 0) return;
    state = state.copyWith(
      currentStepIndex: state.currentStepIndex - 1,
      clearOutOfOrder: true,
    );
  }

  void goNext() {
    if (!state.canMoveNext) return;
    if (state.currentStepIndex >= state.totalSteps - 1) {
      state = state.copyWith(guidedFinished: true, clearOutOfOrder: true);
      return;
    }
    state = state.copyWith(
      currentStepIndex: state.currentStepIndex + 1,
      clearOutOfOrder: true,
    );
  }

  void completeCurrentStep() {
    _markStepCompleted(state.currentStepNumber);
    _advanceAfterAction();
  }

  void skipCurrentStep() {
    _markStepSkipped(state.currentStepNumber);
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
  }

  void resetProgress() {
    state = const WuduTrainerState();
  }

  void restartGuided() {
    state = state.copyWith(
      mode: WuduTrainerMode.guided,
      currentStepIndex: 0,
      guidedFinished: false,
      clearOutOfOrder: true,
    );
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

  void _markStepSkipped(int stepNumber) {
    final completed = {...state.completedStepNumbers}..remove(stepNumber);
    final skipped = {...state.skippedStepNumbers, stepNumber};
    HapticFeedback.selectionClick();
    state = state.copyWith(
      completedStepNumbers: completed,
      skippedStepNumbers: skipped,
      clearOutOfOrder: true,
    );
  }

  void _advanceAfterAction() {
    if (state.currentStepIndex >= state.totalSteps - 1) {
      state = state.copyWith(guidedFinished: true, clearOutOfOrder: true);
      return;
    }
    state = state.copyWith(
      currentStepIndex: state.currentStepIndex + 1,
      clearOutOfOrder: true,
    );
  }

  bool _isStepRecommended(int stepNumber) {
    for (var index = 1; index < stepNumber; index += 1) {
      if (!state.completedStepNumbers.contains(index)) {
        return false;
      }
    }
    return true;
  }
}

final wuduTrainerControllerProvider =
    StateNotifierProvider<WuduTrainerController, WuduTrainerState>(
      (ref) => WuduTrainerController(),
    );
