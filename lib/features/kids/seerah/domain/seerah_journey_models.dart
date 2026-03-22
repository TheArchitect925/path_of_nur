import '../../bedtime_stories/domain/bedtime_story_models.dart';

enum KidsSeerahJourneyNodeType {
  storyEvent,
  companionStory,
  reflection,
  quiz,
  milestone,
}

class KidsSeerahJourney {
  const KidsSeerahJourney({
    required this.journeyId,
    required this.title,
    required this.description,
    required this.ageGroup,
    required this.totalStages,
    required this.isFeatured,
    required this.coverAssetPath,
    required this.backdropAssetPath,
    required this.tags,
    required this.timeline,
  });

  final String journeyId;
  final String title;
  final String description;
  final BedtimeStoryAgeGroup ageGroup;
  final int totalStages;
  final bool isFeatured;
  final String coverAssetPath;
  final String backdropAssetPath;
  final List<String> tags;
  final List<KidsSeerahTimelineMarker> timeline;
}

class KidsSeerahJourneyStage {
  const KidsSeerahJourneyStage({
    required this.stageId,
    required this.journeyId,
    required this.title,
    required this.description,
    required this.sortOrder,
    required this.nodeIds,
    required this.estimatedDurationMinutes,
    this.unlockAfterStageId,
  });

  final String stageId;
  final String journeyId;
  final String title;
  final String description;
  final int sortOrder;
  final List<String> nodeIds;
  final int estimatedDurationMinutes;
  final String? unlockAfterStageId;
}

class KidsSeerahJourneyNode {
  const KidsSeerahJourneyNode({
    required this.nodeId,
    required this.stageId,
    required this.title,
    required this.description,
    required this.nodeType,
    required this.sortOrder,
    this.relatedStoryId,
    this.relatedCompanionId,
    this.relatedQuizStoryId,
    this.relatedQuizId,
    this.relatedSceneIds = const <String>[],
    this.reflectionPrompt,
    this.reflectionChoices = const <String>[],
    this.nodeXpReward = 0,
  });

  final String nodeId;
  final String stageId;
  final String title;
  final String description;
  final KidsSeerahJourneyNodeType nodeType;
  final int sortOrder;
  final String? relatedStoryId;
  final String? relatedCompanionId;
  final String? relatedQuizStoryId;
  final String? relatedQuizId;
  final List<String> relatedSceneIds;
  final String? reflectionPrompt;
  final List<String> reflectionChoices;
  final int nodeXpReward;
}

class KidsSeerahTimelineMarker {
  const KidsSeerahTimelineMarker({
    required this.markerId,
    required this.journeyId,
    required this.stageId,
    required this.label,
    required this.sortOrder,
  });

  final String markerId;
  final String journeyId;
  final String stageId;
  final String label;
  final int sortOrder;
}

class KidsSeerahCompanionStoryLink {
  const KidsSeerahCompanionStoryLink({
    required this.companionId,
    required this.name,
    required this.title,
    required this.shortSummary,
    required this.lesson,
    required this.relatedSeerahEventIds,
    required this.storyId,
    required this.ageGroup,
    required this.tags,
  });

  final String companionId;
  final String name;
  final String title;
  final String shortSummary;
  final String lesson;
  final List<String> relatedSeerahEventIds;
  final String storyId;
  final BedtimeStoryAgeGroup ageGroup;
  final List<String> tags;
}

class KidsSeerahJourneyProgressState {
  const KidsSeerahJourneyProgressState({
    this.startedJourneyIds = const <String>{},
    this.manualCompletedNodeIds = const <String>{},
    this.rewardedNodeIds = const <String>{},
    this.completedStageIds = const <String>{},
    this.rewardedStageIds = const <String>{},
    this.completedJourneyIds = const <String>{},
    this.rewardedJourneyIds = const <String>{},
    this.recentNodeIds = const <String>[],
  });

  final Set<String> startedJourneyIds;
  final Set<String> manualCompletedNodeIds;
  final Set<String> rewardedNodeIds;
  final Set<String> completedStageIds;
  final Set<String> rewardedStageIds;
  final Set<String> completedJourneyIds;
  final Set<String> rewardedJourneyIds;
  final List<String> recentNodeIds;

  KidsSeerahJourneyProgressState copyWith({
    Set<String>? startedJourneyIds,
    Set<String>? manualCompletedNodeIds,
    Set<String>? rewardedNodeIds,
    Set<String>? completedStageIds,
    Set<String>? rewardedStageIds,
    Set<String>? completedJourneyIds,
    Set<String>? rewardedJourneyIds,
    List<String>? recentNodeIds,
  }) {
    return KidsSeerahJourneyProgressState(
      startedJourneyIds: startedJourneyIds ?? this.startedJourneyIds,
      manualCompletedNodeIds: manualCompletedNodeIds ?? this.manualCompletedNodeIds,
      rewardedNodeIds: rewardedNodeIds ?? this.rewardedNodeIds,
      completedStageIds: completedStageIds ?? this.completedStageIds,
      rewardedStageIds: rewardedStageIds ?? this.rewardedStageIds,
      completedJourneyIds: completedJourneyIds ?? this.completedJourneyIds,
      rewardedJourneyIds: rewardedJourneyIds ?? this.rewardedJourneyIds,
      recentNodeIds: recentNodeIds ?? this.recentNodeIds,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'startedJourneyIds': startedJourneyIds.toList(growable: false),
    'manualCompletedNodeIds': manualCompletedNodeIds.toList(growable: false),
    'rewardedNodeIds': rewardedNodeIds.toList(growable: false),
    'completedStageIds': completedStageIds.toList(growable: false),
    'rewardedStageIds': rewardedStageIds.toList(growable: false),
    'completedJourneyIds': completedJourneyIds.toList(growable: false),
    'rewardedJourneyIds': rewardedJourneyIds.toList(growable: false),
    'recentNodeIds': recentNodeIds,
  };

  factory KidsSeerahJourneyProgressState.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const KidsSeerahJourneyProgressState();
    }
    Set<String> readSet(String key) {
      return ((json[key] as List?) ?? const <dynamic>[])
          .map((item) => item.toString())
          .toSet();
    }

    return KidsSeerahJourneyProgressState(
      startedJourneyIds: readSet('startedJourneyIds'),
      manualCompletedNodeIds: readSet('manualCompletedNodeIds'),
      rewardedNodeIds: readSet('rewardedNodeIds'),
      completedStageIds: readSet('completedStageIds'),
      rewardedStageIds: readSet('rewardedStageIds'),
      completedJourneyIds: readSet('completedJourneyIds'),
      rewardedJourneyIds: readSet('rewardedJourneyIds'),
      recentNodeIds: ((json['recentNodeIds'] as List?) ?? const <dynamic>[])
          .map((item) => item.toString())
          .toList(growable: false),
    );
  }
}

class KidsSeerahJourneyNodeSummary {
  const KidsSeerahJourneyNodeSummary({
    required this.node,
    required this.isCompleted,
    required this.isUnlocked,
  });

  final KidsSeerahJourneyNode node;
  final bool isCompleted;
  final bool isUnlocked;
}

class KidsSeerahJourneyStageSummary {
  const KidsSeerahJourneyStageSummary({
    required this.stage,
    required this.nodes,
    required this.isUnlocked,
    required this.isCompleted,
  });

  final KidsSeerahJourneyStage stage;
  final List<KidsSeerahJourneyNodeSummary> nodes;
  final bool isUnlocked;
  final bool isCompleted;

  int get completedNodeCount => nodes.where((node) => node.isCompleted).length;
}

class KidsSeerahJourneySummary {
  const KidsSeerahJourneySummary({
    required this.journey,
    required this.stages,
    required this.isCompleted,
    required this.lastOpenedNodeId,
    required this.nextNodeId,
  });

  final KidsSeerahJourney journey;
  final List<KidsSeerahJourneyStageSummary> stages;
  final bool isCompleted;
  final String? lastOpenedNodeId;
  final String? nextNodeId;

  int get completedStageCount => stages.where((stage) => stage.isCompleted).length;
  int get totalNodeCount =>
      stages.fold<int>(0, (sum, stage) => sum + stage.nodes.length);
  int get completedNodeCount => stages.fold<int>(
    0,
    (sum, stage) => sum + stage.completedNodeCount,
  );
}

class KidsSeerahRewardOutcome {
  const KidsSeerahRewardOutcome({
    this.nodeCompleted = false,
    this.stageCompleted = false,
    this.journeyCompleted = false,
    this.xpAwarded = 0,
    this.dropsAwarded = 0,
  });

  final bool nodeCompleted;
  final bool stageCompleted;
  final bool journeyCompleted;
  final int xpAwarded;
  final int dropsAwarded;
}
