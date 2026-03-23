import 'package:flutter/material.dart';

enum KidsArabicAchievementKind { badge, milestone }

class KidsArabicAchievementDefinition {
  const KidsArabicAchievementDefinition({
    required this.id,
    required this.kind,
    required this.icon,
    required this.color,
    required this.sortOrder,
  });

  final String id;
  final KidsArabicAchievementKind kind;
  final IconData icon;
  final Color color;
  final int sortOrder;
}

class KidsArabicAchievementUiState {
  const KidsArabicAchievementUiState({required this.seenCelebrationIds});

  final Set<String> seenCelebrationIds;

  KidsArabicAchievementUiState copyWith({Set<String>? seenCelebrationIds}) {
    return KidsArabicAchievementUiState(
      seenCelebrationIds: seenCelebrationIds ?? this.seenCelebrationIds,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'seenCelebrationIds': seenCelebrationIds.toList(growable: false),
  };

  static KidsArabicAchievementUiState initial() =>
      const KidsArabicAchievementUiState(seenCelebrationIds: <String>{});

  static KidsArabicAchievementUiState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return initial();
    }
    final rawIds = json['seenCelebrationIds'];
    final ids = rawIds is List
        ? rawIds.map((item) => item.toString()).toSet()
        : <String>{};
    return KidsArabicAchievementUiState(seenCelebrationIds: ids);
  }
}

class KidsArabicAchievementStatus {
  const KidsArabicAchievementStatus({
    required this.definition,
    required this.unlocked,
    required this.isLatest,
  });

  final KidsArabicAchievementDefinition definition;
  final bool unlocked;
  final bool isLatest;
}

class KidsArabicAchievementSummary {
  const KidsArabicAchievementSummary({
    required this.badgesUnlocked,
    required this.milestonesUnlocked,
    required this.lettersCompleted,
    required this.wordsCompleted,
    required this.latestAchievement,
  });

  final int badgesUnlocked;
  final int milestonesUnlocked;
  final int lettersCompleted;
  final int wordsCompleted;
  final KidsArabicAchievementDefinition? latestAchievement;
}

const kidsArabicAchievementDefinitions = <KidsArabicAchievementDefinition>[
  KidsArabicAchievementDefinition(
    id: 'first-letter',
    kind: KidsArabicAchievementKind.badge,
    icon: Icons.star_rounded,
    color: Color(0xFFF3C86A),
    sortOrder: 10,
  ),
  KidsArabicAchievementDefinition(
    id: 'three-letters',
    kind: KidsArabicAchievementKind.milestone,
    icon: Icons.looks_3_rounded,
    color: Color(0xFFB4D676),
    sortOrder: 20,
  ),
  KidsArabicAchievementDefinition(
    id: 'first-five',
    kind: KidsArabicAchievementKind.badge,
    icon: Icons.auto_awesome_rounded,
    color: Color(0xFFB9D77B),
    sortOrder: 30,
  ),
  KidsArabicAchievementDefinition(
    id: 'first-word',
    kind: KidsArabicAchievementKind.milestone,
    icon: Icons.spellcheck_rounded,
    color: Color(0xFF8FD0E8),
    sortOrder: 40,
  ),
  KidsArabicAchievementDefinition(
    id: 'ten-letters',
    kind: KidsArabicAchievementKind.badge,
    icon: Icons.celebration_rounded,
    color: Color(0xFF93C8E8),
    sortOrder: 50,
  ),
  KidsArabicAchievementDefinition(
    id: 'first-review',
    kind: KidsArabicAchievementKind.milestone,
    icon: Icons.refresh_rounded,
    color: Color(0xFFF0BE7D),
    sortOrder: 60,
  ),
  KidsArabicAchievementDefinition(
    id: 'beginner-word-set',
    kind: KidsArabicAchievementKind.milestone,
    icon: Icons.menu_book_rounded,
    color: Color(0xFFCFB2F4),
    sortOrder: 70,
  ),
  KidsArabicAchievementDefinition(
    id: 'full-alphabet',
    kind: KidsArabicAchievementKind.badge,
    icon: Icons.emoji_events_rounded,
    color: Color(0xFFE2B4EC),
    sortOrder: 80,
  ),
];

KidsArabicAchievementDefinition? kidsArabicAchievementById(String id) {
  for (final definition in kidsArabicAchievementDefinitions) {
    if (definition.id == id) {
      return definition;
    }
  }
  return null;
}
