import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../../accounts_sync/application/accounts_sync_controller.dart';
import '../../activity/application/kids_activity_log_service.dart';
import '../../activity/domain/kids_activity_models.dart';
import '../../../progression/application/learner_progression_service.dart';
import '../../../progression/domain/learner_progression_models.dart';
import '../../bedtime_stories/application/bedtime_active_learner_service.dart';
import '../../bedtime_stories/application/bedtime_story_learning_progress_service.dart';
import '../../bedtime_stories/application/bedtime_story_learning_repository.dart';
import '../../bedtime_stories/application/bedtime_story_progress_service.dart';
import '../../bedtime_stories/domain/bedtime_story_learning_models.dart';
import '../../bedtime_stories/domain/bedtime_story_models.dart';
import '../domain/seerah_journey_models.dart';
import 'seerah_journey_repository.dart';

const legacyKidsSeerahJourneyProgressKey = 'kids.seerah.progress.v1';

String kidsSeerahJourneyProgressStorageKeyForLearner(String learnerId) =>
    'kids.seerah.progress.v2.$learnerId';

final kidsSeerahJourneyProgressProvider =
    StateNotifierProvider<
      KidsSeerahJourneyProgressController,
      KidsSeerahJourneyProgressState
    >((ref) {
      final controller = KidsSeerahJourneyProgressController(ref);
      ref.listen<String>(
        bedtimeActiveLearnerProvider.select((value) => value.learnerId),
        (_, next) => controller.updateActiveLearner(next),
      );
      return controller;
    });

final kidsSeerahJourneySummaryProvider =
    Provider.family<KidsSeerahJourneySummary?, String>((ref, journeyId) {
      return ref
          .watch(kidsSeerahJourneyProgressProvider.notifier)
          .buildSummary(journeyId);
    });

final kidsSeerahContinueJourneyProvider = Provider<KidsSeerahJourney?>((ref) {
  return ref
      .watch(kidsSeerahJourneyProgressProvider.notifier)
      .continueJourney();
});

class KidsSeerahJourneyProgressController
    extends StateNotifier<KidsSeerahJourneyProgressState> {
  KidsSeerahJourneyProgressController(this._ref)
    : _store = _ref.read(localStoreProvider),
      _activeLearnerId = _ref.read(bedtimeActiveLearnerProvider).learnerId,
      super(
        KidsSeerahJourneyProgressState.fromJson(
          _ref
              .read(localStoreProvider)
              .getJsonMap(
                kidsSeerahJourneyProgressStorageKeyForLearner(
                  _ref.read(bedtimeActiveLearnerProvider).learnerId,
                ),
              ),
        ),
      ) {
    _migrateLegacyProgressIfNeeded();
  }

  final Ref _ref;
  final LocalStore _store;
  String _activeLearnerId;

  KidsSeerahJourney? continueJourney() {
    final repository = _ref.read(kidsSeerahJourneyRepositoryProvider);
    for (final journeyId
        in state.recentNodeIds
            .map((nodeId) => repository.nodeById(nodeId)?.stageId)
            .whereType<String>()
            .map((stageId) => repository.stageById(stageId)?.journeyId)
            .whereType<String>()) {
      final summary = buildSummary(journeyId);
      if (summary != null && !summary.isCompleted) {
        return summary.journey;
      }
    }
    for (final journeyId in state.startedJourneyIds) {
      final summary = buildSummary(journeyId);
      if (summary != null && !summary.isCompleted) {
        return summary.journey;
      }
    }
    return repository.featuredJourney();
  }

  void updateActiveLearner(String learnerId) {
    if (learnerId == _activeLearnerId) {
      return;
    }
    _activeLearnerId = learnerId;
    state = KidsSeerahJourneyProgressState.fromJson(
      _store.getJsonMap(
        kidsSeerahJourneyProgressStorageKeyForLearner(learnerId),
      ),
    );
    _migrateLegacyProgressIfNeeded();
  }

  void openJourney(String journeyId) {
    state = state.copyWith(
      startedJourneyIds: {...state.startedJourneyIds, journeyId},
    );
    final journey = _ref
        .read(kidsSeerahJourneyRepositoryProvider)
        .journeyById(journeyId);
    _ref
        .read(kidsActivityLogProvider.notifier)
        .log(
          type: KidsActivityType.seerahJourneyOpened,
          domain: KidsActivityDomain.seerah,
          sourceRef: 'kids_seerah_journey_open:$journeyId',
          contentId: journeyId,
          titleSnapshot: journey?.title,
          subtitleSnapshot: journey?.description,
          dedupeWindow: const Duration(minutes: 2),
          metadata: <String, Object?>{
            'feature': 'kids_seerah',
            'journeyId': journeyId,
          },
        );
    _persist();
  }

  void openNode({required String journeyId, required String nodeId}) {
    final recent = List<String>.from(state.recentNodeIds)
      ..remove(nodeId)
      ..insert(0, nodeId);
    if (recent.length > 24) {
      recent.removeRange(24, recent.length);
    }
    state = state.copyWith(
      startedJourneyIds: {...state.startedJourneyIds, journeyId},
      recentNodeIds: recent,
    );
    final node = _ref
        .read(kidsSeerahJourneyRepositoryProvider)
        .nodeById(nodeId);
    _ref
        .read(kidsActivityLogProvider.notifier)
        .log(
          type: KidsActivityType.seerahNodeOpened,
          domain: KidsActivityDomain.seerah,
          sourceRef: 'kids_seerah_node_open:$nodeId',
          contentId: nodeId,
          titleSnapshot: node?.title,
          subtitleSnapshot: node?.description,
          dedupeWindow: const Duration(minutes: 2),
          metadata: <String, Object?>{
            'feature': 'kids_seerah',
            'journeyId': journeyId,
            'nodeId': nodeId,
          },
        );
    _persist();
  }

  KidsSeerahRewardOutcome completeManualNode({
    required String journeyId,
    required KidsSeerahJourneyNode node,
  }) {
    final alreadyCompleted = state.manualCompletedNodeIds.contains(node.nodeId);
    var nextState = state;
    var xpAwarded = 0;
    if (!alreadyCompleted) {
      nextState = nextState.copyWith(
        startedJourneyIds: {...nextState.startedJourneyIds, journeyId},
        manualCompletedNodeIds: {
          ...nextState.manualCompletedNodeIds,
          node.nodeId,
        },
      );
      if (node.nodeXpReward > 0 &&
          !nextState.rewardedNodeIds.contains(node.nodeId)) {
        xpAwarded += node.nodeXpReward;
        nextState = nextState.copyWith(
          rewardedNodeIds: {...nextState.rewardedNodeIds, node.nodeId},
        );
        _awardProgression(
          sourceRef: 'kids_seerah_node:${node.nodeId}:complete',
          activityType: LearnerProgressionActivityType.seerahNodeCompletion,
          xp: node.nodeXpReward,
          drops: 0,
          metadata: <String, Object?>{
            'feature': 'kids_seerah',
            'journeyId': journeyId,
            'nodeId': node.nodeId,
            'nodeType': node.nodeType.name,
          },
        );
        _ref
            .read(kidsActivityLogProvider.notifier)
            .log(
              type: KidsActivityType.seerahNodeCompleted,
              domain: KidsActivityDomain.seerah,
              sourceRef: 'kids_seerah_node_complete:${node.nodeId}',
              contentId: node.nodeId,
              titleSnapshot: node.title,
              subtitleSnapshot: node.description,
              metadata: <String, Object?>{
                'feature': 'kids_seerah',
                'journeyId': journeyId,
                'nodeId': node.nodeId,
                'nodeType': node.nodeType.name,
              },
            );
      }
    }

    state = nextState;
    final syncOutcome = syncJourney(journeyId);
    return KidsSeerahRewardOutcome(
      nodeCompleted: !alreadyCompleted,
      stageCompleted: syncOutcome.stageCompleted,
      journeyCompleted: syncOutcome.journeyCompleted,
      xpAwarded: xpAwarded + syncOutcome.xpAwarded,
      dropsAwarded: syncOutcome.dropsAwarded,
    );
  }

  KidsSeerahRewardOutcome syncJourney(String journeyId) {
    final summary = buildSummary(journeyId);
    if (summary == null) {
      return const KidsSeerahRewardOutcome();
    }

    var xpAwarded = 0;
    var dropsAwarded = 0;
    var stageCompleted = false;
    var journeyCompleted = false;
    var nextState = state;

    for (final stage in summary.stages) {
      if (!stage.isCompleted ||
          nextState.completedStageIds.contains(stage.stage.stageId)) {
        continue;
      }
      nextState = nextState.copyWith(
        completedStageIds: {
          ...nextState.completedStageIds,
          stage.stage.stageId,
        },
      );
      if (!nextState.rewardedStageIds.contains(stage.stage.stageId)) {
        const stageXp = 4;
        xpAwarded += stageXp;
        nextState = nextState.copyWith(
          rewardedStageIds: {
            ...nextState.rewardedStageIds,
            stage.stage.stageId,
          },
        );
        _awardProgression(
          sourceRef: 'kids_seerah_stage:${stage.stage.stageId}:complete',
          activityType: LearnerProgressionActivityType.seerahStageCompletion,
          xp: stageXp,
          drops: 0,
          metadata: <String, Object?>{
            'feature': 'kids_seerah',
            'journeyId': journeyId,
            'stageId': stage.stage.stageId,
          },
        );
        _ref
            .read(kidsActivityLogProvider.notifier)
            .log(
              type: KidsActivityType.seerahStageCompleted,
              domain: KidsActivityDomain.seerah,
              sourceRef: 'kids_seerah_stage_complete:${stage.stage.stageId}',
              contentId: stage.stage.stageId,
              titleSnapshot: stage.stage.title,
              subtitleSnapshot: stage.stage.description,
              metadata: <String, Object?>{
                'feature': 'kids_seerah',
                'journeyId': journeyId,
                'stageId': stage.stage.stageId,
              },
            );
      }
      stageCompleted = true;
    }

    if (summary.isCompleted &&
        !nextState.completedJourneyIds.contains(journeyId)) {
      nextState = nextState.copyWith(
        completedJourneyIds: {...nextState.completedJourneyIds, journeyId},
      );
      if (!nextState.rewardedJourneyIds.contains(journeyId)) {
        const journeyXp = 10;
        const journeyDrops = 1;
        xpAwarded += journeyXp;
        dropsAwarded += journeyDrops;
        nextState = nextState.copyWith(
          rewardedJourneyIds: {...nextState.rewardedJourneyIds, journeyId},
        );
        _awardProgression(
          sourceRef: 'kids_seerah_journey:$journeyId:complete',
          activityType: LearnerProgressionActivityType.seerahJourneyCompletion,
          xp: journeyXp,
          drops: journeyDrops,
          metadata: <String, Object?>{
            'feature': 'kids_seerah',
            'journeyId': journeyId,
          },
        );
        _ref
            .read(kidsActivityLogProvider.notifier)
            .log(
              type: KidsActivityType.seerahJourneyCompleted,
              domain: KidsActivityDomain.seerah,
              sourceRef: 'kids_seerah_journey_complete:$journeyId',
              contentId: journeyId,
              titleSnapshot: summary.journey.title,
              subtitleSnapshot: summary.journey.description,
              metadata: <String, Object?>{
                'feature': 'kids_seerah',
                'journeyId': journeyId,
              },
            );
      }
      journeyCompleted = true;
    }

    state = nextState;
    _persist();
    return KidsSeerahRewardOutcome(
      stageCompleted: stageCompleted,
      journeyCompleted: journeyCompleted,
      xpAwarded: xpAwarded,
      dropsAwarded: dropsAwarded,
    );
  }

  KidsSeerahJourneySummary? buildSummary(String journeyId) {
    final repository = _ref.read(kidsSeerahJourneyRepositoryProvider);
    final storyProgress = _ref.read(bedtimeStoryProgressProvider);
    final learningProgress = _ref.read(bedtimeStoryLearningProgressProvider);
    final journey = repository.journeyById(journeyId);
    if (journey == null) {
      return null;
    }

    final stageSummaries = <KidsSeerahJourneyStageSummary>[];
    for (final stage in repository.stagesForJourney(journeyId)) {
      final previousCompleted = stage.unlockAfterStageId == null
          ? true
          : stageSummaries.any(
              (item) =>
                  item.stage.stageId == stage.unlockAfterStageId &&
                  item.isCompleted,
            );
      final nodes = repository
          .nodesForStage(stage.stageId)
          .map((node) {
            final isCompleted = _isNodeCompleted(
              node,
              storyProgress: storyProgress.storyProgressById,
              learningProgress: learningProgress.progressByActivityId,
            );
            return KidsSeerahJourneyNodeSummary(
              node: node,
              isCompleted: isCompleted,
              isUnlocked: previousCompleted,
            );
          })
          .toList(growable: false);
      final isCompleted =
          nodes.isNotEmpty && nodes.every((node) => node.isCompleted);
      stageSummaries.add(
        KidsSeerahJourneyStageSummary(
          stage: stage,
          nodes: nodes,
          isUnlocked: previousCompleted,
          isCompleted: isCompleted,
        ),
      );
    }

    String? nextNodeId;
    for (final stage in stageSummaries) {
      if (!stage.isUnlocked) {
        continue;
      }
      for (final node in stage.nodes) {
        if (!node.isCompleted) {
          nextNodeId = node.node.nodeId;
          break;
        }
      }
      if (nextNodeId != null) {
        break;
      }
    }

    return KidsSeerahJourneySummary(
      journey: journey,
      stages: stageSummaries,
      isCompleted:
          stageSummaries.isNotEmpty &&
          stageSummaries.every((stage) => stage.isCompleted),
      lastOpenedNodeId: state.recentNodeIds.firstOrNull,
      nextNodeId: nextNodeId,
    );
  }

  bool _isNodeCompleted(
    KidsSeerahJourneyNode node, {
    required Map<String, BedtimeStoryProgress> storyProgress,
    required Map<String, BedtimeStoryLearningActivityProgress> learningProgress,
  }) {
    switch (node.nodeType) {
      case KidsSeerahJourneyNodeType.storyEvent:
      case KidsSeerahJourneyNodeType.companionStory:
        final storyId = node.relatedStoryId;
        if (storyId == null) {
          return false;
        }
        return storyProgress[storyId]?.isCompleted ?? false;
      case KidsSeerahJourneyNodeType.quiz:
        final storyId = node.relatedQuizStoryId ?? node.relatedStoryId;
        if (storyId == null) {
          return false;
        }
        final quiz = _ref.read(bedtimeStoryQuizByStoryIdProvider(storyId));
        if (quiz == null) {
          return false;
        }
        return learningProgress[quiz.quizId]?.isCompleted ?? false;
      case KidsSeerahJourneyNodeType.reflection:
      case KidsSeerahJourneyNodeType.milestone:
        return state.manualCompletedNodeIds.contains(node.nodeId);
    }
  }

  void _persist() {
    _store.setJsonMap(
      kidsSeerahJourneyProgressStorageKeyForLearner(_activeLearnerId),
      state.toJson(),
    );
  }

  void _migrateLegacyProgressIfNeeded() {
    final scopedKey = kidsSeerahJourneyProgressStorageKeyForLearner(
      _activeLearnerId,
    );
    final scoped = _store.getJsonMap(scopedKey);
    if (scoped != null) {
      state = KidsSeerahJourneyProgressState.fromJson(scoped);
      return;
    }
    final legacy = _store.getJsonMap(legacyKidsSeerahJourneyProgressKey);
    if (legacy == null) {
      return;
    }
    state = KidsSeerahJourneyProgressState.fromJson(legacy);
    _store.setJsonMap(scopedKey, state.toJson());
    _store.remove(legacyKidsSeerahJourneyProgressKey);
  }

  bool _shouldMirrorRewardsToJourney() {
    final learner = _ref.read(bedtimeActiveLearnerProvider);
    final accounts = _ref.read(accountsSyncControllerProvider);
    return learner.isLinkedChildProfile &&
        accounts.activeProfileId == learner.linkedChildProfileId;
  }

  void _awardProgression({
    required LearnerProgressionActivityType activityType,
    required int xp,
    required int drops,
    required String sourceRef,
    required Map<String, Object?> metadata,
  }) {
    _ref
        .read(learnerProgressionControllerProvider(_activeLearnerId).notifier)
        .award(
          sourceRef: sourceRef,
          activityType: activityType,
          sourceModule: 'kids_seerah',
          xp: xp,
          drops: drops,
          occurredAt: DateTime.now(),
          metadata: {
            ...metadata,
            'xpAmount': xp,
            'dropAmount': drops,
            'bedtimeLearnerId': _activeLearnerId,
          },
          mirrorToJourney: _shouldMirrorRewardsToJourney(),
        );
  }
}
