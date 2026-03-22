enum BedtimeStoryQueueType {
  singleStory,
  continueSeries,
  bedtimePlaylist,
  tonightQueue,
  recommendedQueue,
}

enum BedtimeStorySleepTimerMode { off, duration, endOfStory }

class BedtimeStoryQueueState {
  const BedtimeStoryQueueState({
    this.storyIds = const <String>[],
    this.currentIndex = 0,
    this.queueType = BedtimeStoryQueueType.singleStory,
    this.autoplayEnabled = true,
    this.lastUpdatedAtIso,
  });

  final List<String> storyIds;
  final int currentIndex;
  final BedtimeStoryQueueType queueType;
  final bool autoplayEnabled;
  final String? lastUpdatedAtIso;

  bool get hasQueue => storyIds.isNotEmpty;
  String? get currentStoryId =>
      hasQueue && currentIndex >= 0 && currentIndex < storyIds.length
      ? storyIds[currentIndex]
      : null;
  bool get hasNext => hasQueue && currentIndex < storyIds.length - 1;
  bool get hasPrevious => hasQueue && currentIndex > 0;

  BedtimeStoryQueueState copyWith({
    List<String>? storyIds,
    int? currentIndex,
    BedtimeStoryQueueType? queueType,
    bool? autoplayEnabled,
    String? lastUpdatedAtIso,
    bool clearLastUpdatedAtIso = false,
  }) {
    return BedtimeStoryQueueState(
      storyIds: storyIds ?? this.storyIds,
      currentIndex: currentIndex ?? this.currentIndex,
      queueType: queueType ?? this.queueType,
      autoplayEnabled: autoplayEnabled ?? this.autoplayEnabled,
      lastUpdatedAtIso: clearLastUpdatedAtIso
          ? null
          : (lastUpdatedAtIso ?? this.lastUpdatedAtIso),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'storyIds': storyIds,
    'currentIndex': currentIndex,
    'queueType': queueType.name,
    'autoplayEnabled': autoplayEnabled,
    'lastUpdatedAtIso': lastUpdatedAtIso,
  };

  static BedtimeStoryQueueState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const BedtimeStoryQueueState();
    }
    return BedtimeStoryQueueState(
      storyIds: (json['storyIds'] as List?)
              ?.map((item) => item.toString())
              .toList(growable: false) ??
          const <String>[],
      currentIndex: (json['currentIndex'] as num?)?.toInt() ?? 0,
      queueType: _queueTypeFromString(json['queueType']?.toString()),
      autoplayEnabled: json['autoplayEnabled'] as bool? ?? true,
      lastUpdatedAtIso: json['lastUpdatedAtIso']?.toString(),
    );
  }

  static BedtimeStoryQueueType _queueTypeFromString(String? value) {
    for (final type in BedtimeStoryQueueType.values) {
      if (type.name == value) {
        return type;
      }
    }
    return BedtimeStoryQueueType.singleStory;
  }
}

class BedtimeStorySleepTimerState {
  const BedtimeStorySleepTimerState({
    this.mode = BedtimeStorySleepTimerMode.off,
    this.durationMinutes,
    this.remainingSeconds,
    this.startedAtIso,
  });

  final BedtimeStorySleepTimerMode mode;
  final int? durationMinutes;
  final int? remainingSeconds;
  final String? startedAtIso;

  bool get isActive => mode != BedtimeStorySleepTimerMode.off;

  BedtimeStorySleepTimerState copyWith({
    BedtimeStorySleepTimerMode? mode,
    int? durationMinutes,
    bool clearDurationMinutes = false,
    int? remainingSeconds,
    bool clearRemainingSeconds = false,
    String? startedAtIso,
    bool clearStartedAtIso = false,
  }) {
    return BedtimeStorySleepTimerState(
      mode: mode ?? this.mode,
      durationMinutes: clearDurationMinutes
          ? null
          : (durationMinutes ?? this.durationMinutes),
      remainingSeconds: clearRemainingSeconds
          ? null
          : (remainingSeconds ?? this.remainingSeconds),
      startedAtIso: clearStartedAtIso
          ? null
          : (startedAtIso ?? this.startedAtIso),
    );
  }
}
