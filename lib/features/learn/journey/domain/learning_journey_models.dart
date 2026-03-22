import 'package:flutter/material.dart';

enum LearningJourneyStageStatus { real, partial, placeholder }

enum LearningJourneyStageTargetType { existingRoute, existingPage, placeholder }

enum LearningJourneyDifficulty { beginner, intermediate, advanced }

class LearningJourneyIsland {
  const LearningJourneyIsland({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.order,
    required this.icon,
    required this.color,
    required this.accentColor,
    this.relatedTools = const <LearningJourneyToolLink>[],
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final int order;
  final IconData icon;
  final Color color;
  final Color accentColor;
  final List<LearningJourneyToolLink> relatedTools;
}

class LearningJourney {
  const LearningJourney({
    required this.id,
    required this.islandId,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.order,
    required this.stageIds,
    required this.learningOutcomes,
    this.difficulty = LearningJourneyDifficulty.beginner,
    this.estimatedDurationMinutes = 20,
    this.tags = const <String>[],
    this.isFeatured = false,
    this.isPublished = true,
    this.whyThisMatters,
    this.relatedTools = const <LearningJourneyToolLink>[],
    this.mappingNotes,
  });

  final String id;
  final String islandId;
  final String title;
  final String subtitle;
  final String description;
  final int order;
  final List<String> stageIds;
  final List<String> learningOutcomes;
  final LearningJourneyDifficulty difficulty;
  final int estimatedDurationMinutes;
  final List<String> tags;
  final bool isFeatured;
  final bool isPublished;
  final String? whyThisMatters;
  final List<LearningJourneyToolLink> relatedTools;
  final String? mappingNotes;

  int get totalLessons => stageIds.length;
}

class LearningJourneyToolLink {
  const LearningJourneyToolLink({
    required this.title,
    required this.subtitle,
    required this.routeName,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
  });

  final String title;
  final String subtitle;
  final String routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
}

class LearningJourneyStage {
  const LearningJourneyStage({
    required this.id,
    required this.journeyId,
    required this.title,
    required this.summary,
    required this.order,
    required this.status,
    required this.targetType,
    this.durationEstimateMinutes = 5,
    this.tags = const <String>[],
    this.xpReward = 8,
    this.dropReward = 1,
    this.targetReference,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
    this.relatedTools = const <LearningJourneyToolLink>[],
    this.notes,
    this.plannedIncludes = const <String>[],
  });

  final String id;
  final String journeyId;
  final String title;
  final String summary;
  final int order;
  final LearningJourneyStageStatus status;
  final LearningJourneyStageTargetType targetType;
  final int durationEstimateMinutes;
  final List<String> tags;
  final int xpReward;
  final int dropReward;
  final String? targetReference;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
  final List<LearningJourneyToolLink> relatedTools;
  final String? notes;
  final List<String> plannedIncludes;
}
