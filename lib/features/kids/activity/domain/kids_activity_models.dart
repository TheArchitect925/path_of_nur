enum KidsActivityType {
  storyOpened,
  storyCompleted,
  quizCompleted,
  memoryCompleted,
  duaLessonOpened,
  duaLessonCompleted,
  duaPracticeCompleted,
  duaMyDayCompleted,
  arabicLetterCompleted,
  arabicReviewCompleted,
  arabicDailyMissionCompleted,
  seerahJourneyOpened,
  seerahNodeOpened,
  seerahNodeCompleted,
  seerahStageCompleted,
  seerahJourneyCompleted,
  bedtimeRoutineCompleted,
}

enum KidsActivityDomain { stories, duas, arabic, seerah, routines }

class KidsActivityEntry {
  const KidsActivityEntry({
    required this.id,
    required this.learnerId,
    required this.occurredAtIso,
    required this.type,
    required this.domain,
    required this.sourceRef,
    this.contentId,
    this.titleSnapshot,
    this.subtitleSnapshot,
    this.metadata = const <String, Object?>{},
  });

  final String id;
  final String learnerId;
  final String occurredAtIso;
  final KidsActivityType type;
  final KidsActivityDomain domain;
  final String sourceRef;
  final String? contentId;
  final String? titleSnapshot;
  final String? subtitleSnapshot;
  final Map<String, Object?> metadata;

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'learnerId': learnerId,
    'occurredAtIso': occurredAtIso,
    'type': type.name,
    'domain': domain.name,
    'sourceRef': sourceRef,
    'contentId': contentId,
    'titleSnapshot': titleSnapshot,
    'subtitleSnapshot': subtitleSnapshot,
    'metadata': metadata,
  };

  factory KidsActivityEntry.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError.notNull('json');
    }
    return KidsActivityEntry(
      id: json['id']?.toString() ?? '',
      learnerId: json['learnerId']?.toString() ?? '',
      occurredAtIso: json['occurredAtIso']?.toString() ?? '',
      type: KidsActivityType.values.firstWhere(
        (item) => item.name == json['type']?.toString(),
        orElse: () => KidsActivityType.storyOpened,
      ),
      domain: KidsActivityDomain.values.firstWhere(
        (item) => item.name == json['domain']?.toString(),
        orElse: () => KidsActivityDomain.stories,
      ),
      sourceRef: json['sourceRef']?.toString() ?? '',
      contentId: json['contentId']?.toString(),
      titleSnapshot: json['titleSnapshot']?.toString(),
      subtitleSnapshot: json['subtitleSnapshot']?.toString(),
      metadata: Map<String, Object?>.from(
        (json['metadata'] as Map?)?.map(
              (key, value) => MapEntry(key.toString(), value),
            ) ??
            const <String, Object?>{},
      ),
    );
  }
}

class KidsActivityLogState {
  const KidsActivityLogState({this.entries = const <KidsActivityEntry>[]});

  final List<KidsActivityEntry> entries;

  KidsActivityLogState copyWith({List<KidsActivityEntry>? entries}) {
    return KidsActivityLogState(entries: entries ?? this.entries);
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'entries': entries.map((item) => item.toJson()).toList(growable: false),
  };

  factory KidsActivityLogState.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const KidsActivityLogState();
    }
    return KidsActivityLogState(
      entries: ((json['entries'] as List?) ?? const <dynamic>[])
          .map((item) {
            if (item is Map<String, dynamic>) {
              return KidsActivityEntry.fromJson(item);
            }
            if (item is Map) {
              return KidsActivityEntry.fromJson(
                item.map((key, value) => MapEntry(key.toString(), value)),
              );
            }
            return null;
          })
          .whereType<KidsActivityEntry>()
          .toList(growable: false),
    );
  }
}
