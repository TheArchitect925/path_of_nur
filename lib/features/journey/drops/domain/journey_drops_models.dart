import '../../../../shared/persistence/local_store.dart';

enum DropSourceType { prayer, dhikr, learning, quran, fasting }

class DropEvent {
  const DropEvent({
    required this.eventId,
    required this.sourceType,
    required this.sourceRef,
    required this.eventDateKey,
    required this.occurredAt,
    required this.createdAt,
    this.metadata = const <String, Object?>{},
  });

  final String eventId;
  final DropSourceType sourceType;
  final String sourceRef;
  final String eventDateKey;
  final DateTime occurredAt;
  final DateTime createdAt;
  final Map<String, Object?> metadata;

  Map<String, Object?> toJson() => <String, Object?>{
    'eventId': eventId,
    'sourceType': sourceType.name,
    'sourceRef': sourceRef,
    'eventDateKey': eventDateKey,
    'occurredAtIso': occurredAt.toIso8601String(),
    'createdAtIso': createdAt.toIso8601String(),
    'metadata': metadata,
  };
}

class DropSummary {
  const DropSummary({
    required this.totalDrops,
    required this.todayDrops,
    required this.updatedAt,
  });

  final int totalDrops;
  final int todayDrops;
  final DateTime updatedAt;

  Map<String, Object?> toJson() => <String, Object?>{
    'totalDrops': totalDrops,
    'todayDrops': todayDrops,
    'updatedAtIso': updatedAt.toIso8601String(),
  };
}

class GardenMilestone {
  const GardenMilestone({
    required this.id,
    required this.requiredDrops,
    required this.titleKey,
    required this.descriptionKey,
    required this.imageAsset,
  });

  final String id;
  final int requiredDrops;
  final String titleKey;
  final String descriptionKey;
  final String imageAsset;

  bool isUnlocked(int dropTotal) => dropTotal >= requiredDrops;
}

class GardenProgressSummary {
  const GardenProgressSummary({
    required this.totalDrops,
    required this.unlockedCount,
    required this.totalMilestones,
    required this.nextRequiredDrops,
    required this.dropsRemaining,
    required this.progressToNext,
  });

  final int totalDrops;
  final int unlockedCount;
  final int totalMilestones;
  final int? nextRequiredDrops;
  final int dropsRemaining;
  final double progressToNext;

  bool get allUnlocked => unlockedCount >= totalMilestones;
}

String dropEventDateKey(DateTime occurredAt) => LocalStore.todayKey(occurredAt);
