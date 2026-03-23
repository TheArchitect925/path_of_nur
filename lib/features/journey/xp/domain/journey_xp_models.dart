import '../../../../shared/persistence/local_store.dart';

enum XpEventType {
  prayerCompleted,
  prayerOnTimeBonus,
  allFivePrayersBonus,
  congregationPrayerBonus,
  masjidPrayerBonus,
  jumuahBonus,
  quranRead,
  learningCompleted,
  dhikrSetCompleted,
  fastingDay,
  taraweehCompleted,
  qiyamCompleted,
  laylatAlQadrMultiplier,
}

class XpContext {
  const XpContext({
    required this.sourceRef,
    required this.sourceModule,
    required this.occurredAt,
    this.eventDateKey,
    this.metadata = const <String, Object?>{},
    this.eligibleForLaylatAlQadrMultiplier = false,
  });

  final String sourceRef;
  final String sourceModule;
  final DateTime occurredAt;
  final String? eventDateKey;
  final Map<String, Object?> metadata;
  final bool eligibleForLaylatAlQadrMultiplier;

  String get resolvedEventDateKey =>
      eventDateKey ?? LocalStore.todayKey(occurredAt);

  XpContext copyWith({
    String? sourceRef,
    String? sourceModule,
    DateTime? occurredAt,
    String? eventDateKey,
    Map<String, Object?>? metadata,
    bool? eligibleForLaylatAlQadrMultiplier,
  }) {
    return XpContext(
      sourceRef: sourceRef ?? this.sourceRef,
      sourceModule: sourceModule ?? this.sourceModule,
      occurredAt: occurredAt ?? this.occurredAt,
      eventDateKey: eventDateKey ?? this.eventDateKey,
      metadata: metadata ?? this.metadata,
      eligibleForLaylatAlQadrMultiplier:
          eligibleForLaylatAlQadrMultiplier ??
          this.eligibleForLaylatAlQadrMultiplier,
    );
  }
}

class XpLedgerEntry {
  const XpLedgerEntry({
    required this.entryId,
    required this.eventType,
    required this.sourceRef,
    required this.sourceModule,
    required this.eventDateKey,
    required this.occurredAt,
    required this.baseXp,
    required this.awardedXp,
    required this.createdAt,
    this.metadata = const <String, Object?>{},
  });

  final String entryId;
  final XpEventType eventType;
  final String sourceRef;
  final String sourceModule;
  final String eventDateKey;
  final DateTime occurredAt;
  final int baseXp;
  final int awardedXp;
  final DateTime createdAt;
  final Map<String, Object?> metadata;

  Map<String, Object?> toJson() => <String, Object?>{
    'entryId': entryId,
    'eventType': eventType.name,
    'sourceRef': sourceRef,
    'sourceModule': sourceModule,
    'eventDateKey': eventDateKey,
    'occurredAt': occurredAt.toIso8601String(),
    'baseXp': baseXp,
    'awardedXp': awardedXp,
    'createdAt': createdAt.toIso8601String(),
    'metadata': metadata,
  };
}

class LevelDefinition {
  const LevelDefinition({
    required this.level,
    required this.totalXpRequired,
    required this.title,
  });

  final int level;
  final int totalXpRequired;
  final String title;
}

class XpSummary {
  const XpSummary({
    required this.totalXp,
    required this.todayXp,
    required this.currentLevel,
    required this.currentLevelTitle,
    required this.currentLevelStartXp,
    required this.nextLevel,
    required this.nextLevelTitle,
    required this.nextLevelTotalXp,
    required this.xpIntoLevel,
    required this.xpRequiredInLevel,
    required this.xpRemainingToNextLevel,
    required this.progressPercent,
    required this.updatedAt,
  });

  final int totalXp;
  final int todayXp;
  final int currentLevel;
  final String currentLevelTitle;
  final int currentLevelStartXp;
  final int? nextLevel;
  final String? nextLevelTitle;
  final int? nextLevelTotalXp;
  final int xpIntoLevel;
  final int xpRequiredInLevel;
  final int xpRemainingToNextLevel;
  final double progressPercent;
  final DateTime updatedAt;

  bool get isMaxLevel => nextLevel == null;

  Map<String, Object?> toJson() => <String, Object?>{
    'totalXp': totalXp,
    'todayXp': todayXp,
    'currentLevel': currentLevel,
    'currentLevelTitle': currentLevelTitle,
    'currentLevelStartXp': currentLevelStartXp,
    'nextLevel': nextLevel,
    'nextLevelTitle': nextLevelTitle,
    'nextLevelTotalXp': nextLevelTotalXp,
    'xpIntoLevel': xpIntoLevel,
    'xpRequiredInLevel': xpRequiredInLevel,
    'xpRemainingToNextLevel': xpRemainingToNextLevel,
    'progressPercent': progressPercent,
    'updatedAt': updatedAt.toIso8601String(),
  };
}
