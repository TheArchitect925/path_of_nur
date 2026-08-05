import 'package:flutter/material.dart';

import '../../creation_explorer/domain/creation_explorer_models.dart';

enum CreationChallengeType { observe, detect, reflect, skyEvent, photoJournal }

enum CreationChallengeDifficulty { gentle, steady, deeper }

enum CreationChallengeStatus { available, completed, expired }

enum CreationExplorerMode { creationExplorer, skyExplorer, journal }

enum CreationChallengeRuleType {
  openExplorer,
  detectCategory,
  saveObservation,
  saveReflection,
  checkSkyEvent,
  manualConfirm,
}

enum ChallengeEvidenceType {
  explorerOpen,
  detection,
  observation,
  reflection,
  manual,
}

enum ChallengeSlot { daily, bonus, weekly }

class CreationChallenge {
  const CreationChallenge({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.challengeType,
    required this.requiredActionCount,
    required this.rewardDrops,
    required this.difficulty,
    required this.isBonus,
    required this.completionRule,
    required this.icon,
    this.targetCategoryId,
    this.targetExplorerMode,
    this.verseId,
    this.reflectionPrompt,
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final CreationChallengeType challengeType;
  final CreationCategoryId? targetCategoryId;
  final CreationExplorerMode? targetExplorerMode;
  final int requiredActionCount;
  final int rewardDrops;
  final CreationChallengeDifficulty difficulty;
  final bool isBonus;
  final String? verseId;
  final String? reflectionPrompt;
  final CreationChallengeRuleType completionRule;
  final IconData icon;
}

class ChallengeCompletion {
  const ChallengeCompletion({
    required this.id,
    required this.challengeId,
    required this.completedAt,
    required this.evidenceType,
    required this.awardedDrops,
    this.evidenceRefId,
    this.notes,
  });

  final String id;
  final String challengeId;
  final DateTime completedAt;
  final ChallengeEvidenceType evidenceType;
  final String? evidenceRefId;
  final String? notes;
  final int awardedDrops;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'challengeId': challengeId,
    'completedAt': completedAt.toIso8601String(),
    'evidenceType': evidenceType.name,
    'evidenceRefId': evidenceRefId,
    'notes': notes,
    'awardedDrops': awardedDrops,
  };

  static ChallengeCompletion? fromJson(dynamic raw) {
    if (raw is! Map) return null;
    final id = raw['id']?.toString();
    final challengeId = raw['challengeId']?.toString();
    final completedAt = DateTime.tryParse(raw['completedAt']?.toString() ?? '');
    final evidenceTypeName = raw['evidenceType']?.toString();
    if (id == null ||
        challengeId == null ||
        completedAt == null ||
        evidenceTypeName == null) {
      return null;
    }
    ChallengeEvidenceType? evidenceType;
    for (final item in ChallengeEvidenceType.values) {
      if (item.name == evidenceTypeName) {
        evidenceType = item;
        break;
      }
    }
    if (evidenceType == null) return null;
    return ChallengeCompletion(
      id: id,
      challengeId: challengeId,
      completedAt: completedAt,
      evidenceType: evidenceType,
      evidenceRefId: raw['evidenceRefId']?.toString(),
      notes: raw['notes']?.toString(),
      awardedDrops: (raw['awardedDrops'] as num?)?.toInt() ?? 0,
    );
  }
}

class ChallengeHistoryEntry {
  const ChallengeHistoryEntry({
    required this.id,
    required this.date,
    required this.challengeId,
    required this.completed,
    required this.skipped,
    required this.explorerSource,
    this.categoryId,
  });

  final String id;
  final DateTime date;
  final String challengeId;
  final bool completed;
  final bool skipped;
  final CreationExplorerMode explorerSource;
  final CreationCategoryId? categoryId;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'date': date.toIso8601String(),
    'challengeId': challengeId,
    'completed': completed,
    'skipped': skipped,
    'explorerSource': explorerSource.name,
    'categoryId': categoryId?.name,
  };

  static ChallengeHistoryEntry? fromJson(dynamic raw) {
    if (raw is! Map) return null;
    final id = raw['id']?.toString();
    final challengeId = raw['challengeId']?.toString();
    final date = DateTime.tryParse(raw['date']?.toString() ?? '');
    final explorerName = raw['explorerSource']?.toString();
    if (id == null ||
        challengeId == null ||
        date == null ||
        explorerName == null) {
      return null;
    }
    CreationExplorerMode? explorerSource;
    for (final item in CreationExplorerMode.values) {
      if (item.name == explorerName) {
        explorerSource = item;
        break;
      }
    }
    if (explorerSource == null) return null;
    CreationCategoryId? categoryId;
    final categoryName = raw['categoryId']?.toString();
    if (categoryName != null) {
      for (final item in CreationCategoryId.values) {
        if (item.name == categoryName) {
          categoryId = item;
          break;
        }
      }
    }
    return ChallengeHistoryEntry(
      id: id,
      date: date,
      challengeId: challengeId,
      completed: raw['completed'] == true,
      skipped: raw['skipped'] == true,
      explorerSource: explorerSource,
      categoryId: categoryId,
    );
  }
}

class CreationChallengeAssignment {
  const CreationChallengeAssignment({
    required this.slot,
    required this.challengeId,
    required this.startAt,
    required this.endAt,
  });

  final ChallengeSlot slot;
  final String challengeId;
  final DateTime startAt;
  final DateTime endAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'slot': slot.name,
    'challengeId': challengeId,
    'startAt': startAt.toIso8601String(),
    'endAt': endAt.toIso8601String(),
  };

  static CreationChallengeAssignment? fromJson(dynamic raw) {
    if (raw is! Map) return null;
    final slotName = raw['slot']?.toString();
    final challengeId = raw['challengeId']?.toString();
    final startAt = DateTime.tryParse(raw['startAt']?.toString() ?? '');
    final endAt = DateTime.tryParse(raw['endAt']?.toString() ?? '');
    if (slotName == null ||
        challengeId == null ||
        startAt == null ||
        endAt == null) {
      return null;
    }
    ChallengeSlot? slot;
    for (final item in ChallengeSlot.values) {
      if (item.name == slotName) {
        slot = item;
        break;
      }
    }
    if (slot == null) return null;
    return CreationChallengeAssignment(
      slot: slot,
      challengeId: challengeId,
      startAt: startAt,
      endAt: endAt,
    );
  }
}

class CreationChallengeEvidence {
  const CreationChallengeEvidence({
    required this.ruleType,
    required this.source,
    required this.occurredAt,
    this.categoryId,
    this.refId,
    this.notes,
  });

  final CreationChallengeRuleType ruleType;
  final CreationExplorerMode source;
  final DateTime occurredAt;
  final CreationCategoryId? categoryId;
  final String? refId;
  final String? notes;
}

class CreationChallengeState {
  const CreationChallengeState({
    required this.assignments,
    required this.completions,
    required this.history,
  });

  final Map<ChallengeSlot, CreationChallengeAssignment> assignments;
  final List<ChallengeCompletion> completions;
  final List<ChallengeHistoryEntry> history;

  CreationChallengeState copyWith({
    Map<ChallengeSlot, CreationChallengeAssignment>? assignments,
    List<ChallengeCompletion>? completions,
    List<ChallengeHistoryEntry>? history,
  }) {
    return CreationChallengeState(
      assignments: assignments ?? this.assignments,
      completions: completions ?? this.completions,
      history: history ?? this.history,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'assignments': assignments.map(
      (key, value) => MapEntry(key.name, value.toJson()),
    ),
    'completions': completions
        .map((item) => item.toJson())
        .toList(growable: false),
    'history': history.map((item) => item.toJson()).toList(growable: false),
  };

  static CreationChallengeState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CreationChallengeState(
        assignments: <ChallengeSlot, CreationChallengeAssignment>{},
        completions: <ChallengeCompletion>[],
        history: <ChallengeHistoryEntry>[],
      );
    }
    final assignments = <ChallengeSlot, CreationChallengeAssignment>{};
    final rawAssignments = json['assignments'];
    if (rawAssignments is Map) {
      for (final entry in rawAssignments.entries) {
        final assignment = CreationChallengeAssignment.fromJson(entry.value);
        if (assignment != null) assignments[assignment.slot] = assignment;
      }
    }
    final completions = ((json['completions'] as List?) ?? const [])
        .map(ChallengeCompletion.fromJson)
        .whereType<ChallengeCompletion>()
        .toList(growable: false);
    final history = ((json['history'] as List?) ?? const [])
        .map(ChallengeHistoryEntry.fromJson)
        .whereType<ChallengeHistoryEntry>()
        .toList(growable: false);
    return CreationChallengeState(
      assignments: assignments,
      completions: completions,
      history: history,
    );
  }
}

class CreationChallengeSummary {
  const CreationChallengeSummary({
    required this.slot,
    required this.challenge,
    required this.assignment,
    required this.status,
    this.completion,
  });

  final ChallengeSlot slot;
  final CreationChallenge challenge;
  final CreationChallengeAssignment assignment;
  final CreationChallengeStatus status;
  final ChallengeCompletion? completion;

  bool get isCompleted => status == CreationChallengeStatus.completed;
}
