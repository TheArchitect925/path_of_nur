import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../../accounts_sync/application/accounts_sync_controller.dart';
import '../../activity/application/kids_activity_log_service.dart';
import '../../activity/domain/kids_activity_models.dart';
import '../../../progression/application/learner_progression_service.dart';
import '../../../progression/domain/learner_progression_models.dart';
import '../../bedtime_stories/application/bedtime_active_learner_service.dart';
import '../../bedtime_stories/application/bedtime_story_progress_service.dart';
import '../../bedtime_stories/domain/bedtime_story_models.dart';
import '../domain/bedtime_routine_models.dart';
import 'bedtime_routine_repository.dart';

String bedtimeCompanionStorageKeyForLearner(String learnerId) =>
    'kids.bedtime_companion.session.v1.$learnerId';

final bedtimeCompanionSessionProvider = StateNotifierProvider<
  BedtimeCompanionSessionController,
  BedtimeCompanionState
>((ref) {
  final controller = BedtimeCompanionSessionController(ref);
  ref.listen<String>(
    bedtimeActiveLearnerProvider.select((value) => value.learnerId),
    (_, nextLearnerId) => controller.updateActiveLearner(nextLearnerId),
  );
  ref.listen<BedtimeStoryLibraryProgress>(
    bedtimeStoryProgressProvider,
    (previous, next) => controller.syncExternalProgress(),
  );
  return controller;
});

class BedtimeCompanionSessionController
    extends StateNotifier<BedtimeCompanionState> {
  BedtimeCompanionSessionController(this._ref)
    : _store = _ref.read(localStoreProvider),
      _activeLearnerId = _ref.read(bedtimeActiveLearnerProvider).learnerId,
      super(
        BedtimeCompanionState.fromJson(
          _ref.read(localStoreProvider).getJsonMap(
                bedtimeCompanionStorageKeyForLearner(
                  _ref.read(bedtimeActiveLearnerProvider).learnerId,
                ),
              ),
        ),
      ) {
    ensureSessionForToday();
    syncExternalProgress();
  }

  final Ref _ref;
  final LocalStore _store;
  String _activeLearnerId;

  BedtimeRoutineSession ensureSessionForToday() {
    final today = LocalStore.todayKey();
    final current = state.activeSession;
    if (current != null && current.dateKey == today) {
      return current;
    }
    final repository = _ref.read(bedtimeRoutineRepositoryProvider);
    final plan = repository.defaultPlan();
    final story = repository.tonightStory();
    final primaryDua = repository.primaryBedtimeDua();
    final secondary = repository.secondaryBedtimeDuas();
    final session = BedtimeRoutineSession(
      sessionId: 'bedtime_${_activeLearnerId}_$today',
      learnerId: _activeLearnerId,
      planId: plan.planId,
      dateKey: today,
      startedAtIso: DateTime.now().toIso8601String(),
      lastUpdatedAtIso: DateTime.now().toIso8601String(),
      suggestedStoryId: story?.id,
      primaryDuaId: primaryDua?.duaId,
      secondaryDuaIds: secondary.map((item) => item.duaId).toList(growable: false),
      stepProgressById: {
        for (final step in plan.steps) step.stepId: const BedtimeRoutineStepProgress(),
      },
    );
    state = state.copyWith(activeSession: session);
    _persist();
    return session;
  }

  void updateActiveLearner(String learnerId) {
    if (_activeLearnerId == learnerId) {
      return;
    }
    _activeLearnerId = learnerId;
    state = BedtimeCompanionState.fromJson(
      _store.getJsonMap(bedtimeCompanionStorageKeyForLearner(learnerId)),
    );
    ensureSessionForToday();
    syncExternalProgress();
  }

  void startStep(String stepId) {
    final session = ensureSessionForToday();
    final current = session.stepProgressById[stepId] ?? const BedtimeRoutineStepProgress();
    if (current.state == BedtimeRoutineCompletionState.completed) {
      return;
    }
    _updateStep(
      stepId,
      current.copyWith(
        state: BedtimeRoutineCompletionState.inProgress,
        startedAtIso: current.startedAtIso ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  void completeStep(
    String stepId, {
    String? selectedChoiceId,
    bool skipped = false,
  }) {
    final session = ensureSessionForToday();
    final current = session.stepProgressById[stepId] ?? const BedtimeRoutineStepProgress();
    _updateStep(
      stepId,
      current.copyWith(
        state: skipped
            ? BedtimeRoutineCompletionState.skipped
            : BedtimeRoutineCompletionState.completed,
        startedAtIso: current.startedAtIso ?? DateTime.now().toIso8601String(),
        completedAtIso: DateTime.now().toIso8601String(),
        selectedChoiceId: selectedChoiceId,
      ),
    );
    _syncSessionCompletion();
  }

  void syncExternalProgress() {
    final session = ensureSessionForToday();
    final storyId = session.suggestedStoryId;
    final storyProgress = storyId == null
        ? null
        : _ref.read(bedtimeStoryProgressProvider).storyProgressById[storyId];

    if (storyProgress != null) {
      final storyStepId = _stepIdFor(BedtimeRoutineStepType.storyTime);
      final step = session.stepProgressById[storyStepId] ??
          const BedtimeRoutineStepProgress();
      final nextState = storyProgress.isCompleted || storyProgress.hasProgress
          ? BedtimeRoutineCompletionState.completed
          : step.state;
      if (nextState != step.state) {
        _updateStep(
          storyStepId,
          step.copyWith(
            state: nextState,
            startedAtIso: step.startedAtIso ?? storyProgress.startedAtIso,
            completedAtIso: nextState == BedtimeRoutineCompletionState.completed
                ? (step.completedAtIso ?? storyProgress.completedAtIso)
                : step.completedAtIso,
          ),
          persist: false,
        );
      }
    }

    _syncSessionCompletion();
  }

  void _updateStep(
    String stepId,
    BedtimeRoutineStepProgress next, {
    bool persist = true,
  }) {
    final session = ensureSessionForToday();
    final nextMap = Map<String, BedtimeRoutineStepProgress>.from(
      session.stepProgressById,
    )..[stepId] = next;
    state = state.copyWith(
      activeSession: session.copyWith(
        stepProgressById: nextMap,
        lastUpdatedAtIso: DateTime.now().toIso8601String(),
        reflectionChoiceId: next.selectedChoiceId ?? session.reflectionChoiceId,
      ),
    );
    if (persist) {
      _persist();
    }
  }

  void _syncSessionCompletion() {
    final session = state.activeSession;
    if (session == null) {
      return;
    }
    final plan = _ref.read(bedtimeRoutineRepositoryProvider).defaultPlan();
    final requiredComplete = plan.steps.where((step) => !step.isOptional).every((step) {
      final progress = session.stepProgressById[step.stepId];
      return progress?.state == BedtimeRoutineCompletionState.completed ||
          progress?.state == BedtimeRoutineCompletionState.skipped;
    });
    if (requiredComplete && !session.isCompleted) {
      final completed = session.copyWith(
        completedAtIso: DateTime.now().toIso8601String(),
        lastUpdatedAtIso: DateTime.now().toIso8601String(),
      );
      final nextRecent = <BedtimeRoutineSession>[
        completed,
        ...state.recentSessions.where((item) => item.sessionId != completed.sessionId),
      ];
      if (nextRecent.length > 14) {
        nextRecent.removeRange(14, nextRecent.length);
      }
      state = state.copyWith(activeSession: completed, recentSessions: nextRecent);
      final learner = _ref.read(bedtimeActiveLearnerProvider);
      final accounts = _ref.read(accountsSyncControllerProvider);
      final shouldMirror = learner.isLinkedChildProfile &&
          accounts.activeProfileId == learner.linkedChildProfileId;
      _ref
          .read(learnerProgressionControllerProvider(_activeLearnerId).notifier)
          .award(
            sourceRef: 'bedtime_routine:${completed.sessionId}:complete',
            activityType:
                LearnerProgressionActivityType.bedtimeRoutineCompletion,
            sourceModule: 'kids_bedtime_routine',
            xp: 2,
            drops: 0,
            occurredAt: DateTime.now(),
            metadata: <String, Object?>{
              'feature': 'kids_bedtime_routine',
              'planId': completed.planId,
              'dateKey': completed.dateKey,
              'storyId': completed.suggestedStoryId,
              'primaryDuaId': completed.primaryDuaId,
            },
            mirrorToJourney: shouldMirror,
          );
      _ref.read(kidsActivityLogProvider.notifier).log(
        type: KidsActivityType.bedtimeRoutineCompleted,
        domain: KidsActivityDomain.routines,
        sourceRef: 'bedtime_routine_complete:${completed.sessionId}',
        contentId: completed.sessionId,
        titleSnapshot: null,
        subtitleSnapshot: null,
        occurredAt: DateTime.now(),
        metadata: <String, Object?>{
          'feature': 'kids_bedtime_routine',
          'planId': completed.planId,
          'dateKey': completed.dateKey,
          'storyId': completed.suggestedStoryId,
          'primaryDuaId': completed.primaryDuaId,
        },
      );
      _persist();
      return;
    }
    _persist();
  }

  String _stepIdFor(BedtimeRoutineStepType type) {
    final plan = _ref.read(bedtimeRoutineRepositoryProvider).defaultPlan();
    return plan.steps.firstWhere((step) => step.stepType == type).stepId;
  }

  void _persist() {
    _store.setJsonMap(
      bedtimeCompanionStorageKeyForLearner(_activeLearnerId),
      state.toJson(),
    );
  }
}
