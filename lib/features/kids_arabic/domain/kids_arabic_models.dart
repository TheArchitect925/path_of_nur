import 'package:flutter/material.dart';

class KidsArabicLetter {
  const KidsArabicLetter({
    required this.id,
    required this.glyph,
    required this.nameEn,
    required this.nameAr,
    required this.transliteration,
    required this.soundHint,
    required this.strokeCount,
    required this.exampleWord,
    required this.exampleWordAr,
    required this.exampleWordEn,
    required this.childFriendlyLine,
    required this.rewardXp,
    required this.rewardDrops,
  });

  final String id;
  final String glyph;
  final String nameEn;
  final String nameAr;
  final String transliteration;
  final String soundHint;
  final int strokeCount;
  final String exampleWord;
  final String exampleWordAr;
  final String exampleWordEn;
  final String childFriendlyLine;
  final int rewardXp;
  final int rewardDrops;
}

enum KidsArabicTraceResult { completed, good, excellent }

class KidsArabicTraceMetrics {
  const KidsArabicTraceMetrics({
    required this.strokeCount,
    required this.pointCount,
    this.guidedProgress = 0,
    this.alignmentScore = 0,
    this.completedGuideStrokes = 0,
    this.totalGuideStrokes = 1,
    this.activeGuideStrokeIndex = 0,
    this.minimumEffortMet = false,
    this.successPulse = false,
  });

  final int strokeCount;
  final int pointCount;
  final double guidedProgress;
  final double alignmentScore;
  final int completedGuideStrokes;
  final int totalGuideStrokes;
  final int activeGuideStrokeIndex;
  final bool minimumEffortMet;
  final bool successPulse;
}

class KidsArabicLetterProgress {
  const KidsArabicLetterProgress({
    required this.letterId,
    required this.lessonsCompleted,
    required this.correctReviews,
    required this.incorrectReviews,
    this.bestTraceResultName,
    this.firstCompletedDayKey,
    this.lastCompletedDayKey,
  });

  final String letterId;
  final int lessonsCompleted;
  final int correctReviews;
  final int incorrectReviews;
  final String? bestTraceResultName;
  final String? firstCompletedDayKey;
  final String? lastCompletedDayKey;

  KidsArabicTraceResult? get bestTraceResult {
    final raw = bestTraceResultName;
    if (raw == null || raw.isEmpty) return null;
    return KidsArabicTraceResult.values.byName(raw);
  }

  KidsArabicLetterProgress copyWith({
    int? lessonsCompleted,
    int? correctReviews,
    int? incorrectReviews,
    String? bestTraceResultName,
    bool clearBestTraceResultName = false,
    String? firstCompletedDayKey,
    String? lastCompletedDayKey,
  }) {
    return KidsArabicLetterProgress(
      letterId: letterId,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      correctReviews: correctReviews ?? this.correctReviews,
      incorrectReviews: incorrectReviews ?? this.incorrectReviews,
      bestTraceResultName: clearBestTraceResultName
          ? null
          : (bestTraceResultName ?? this.bestTraceResultName),
      firstCompletedDayKey: firstCompletedDayKey ?? this.firstCompletedDayKey,
      lastCompletedDayKey: lastCompletedDayKey ?? this.lastCompletedDayKey,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'letterId': letterId,
    'lessonsCompleted': lessonsCompleted,
    'correctReviews': correctReviews,
    'incorrectReviews': incorrectReviews,
    'bestTraceResultName': bestTraceResultName,
    'firstCompletedDayKey': firstCompletedDayKey,
    'lastCompletedDayKey': lastCompletedDayKey,
  };

  static KidsArabicLetterProgress fromJson(Map<String, dynamic> json) {
    return KidsArabicLetterProgress(
      letterId: json['letterId']?.toString() ?? '',
      lessonsCompleted: (json['lessonsCompleted'] as num?)?.toInt() ?? 0,
      correctReviews: (json['correctReviews'] as num?)?.toInt() ?? 0,
      incorrectReviews: (json['incorrectReviews'] as num?)?.toInt() ?? 0,
      bestTraceResultName: json['bestTraceResultName']?.toString(),
      firstCompletedDayKey: json['firstCompletedDayKey']?.toString(),
      lastCompletedDayKey: json['lastCompletedDayKey']?.toString(),
    );
  }
}

class KidsArabicStickerDefinition {
  const KidsArabicStickerDefinition({
    required this.id,
    required this.requiredCompletedLetters,
    required this.icon,
    required this.color,
  });

  final String id;
  final int requiredCompletedLetters;
  final IconData icon;
  final Color color;
}

enum KidsArabicDailyMissionType { newLetter, review, tracePractice }

class KidsArabicDailyMission {
  const KidsArabicDailyMission({
    required this.id,
    required this.type,
    required this.targetLetterId,
    required this.targetCount,
    required this.generatedForDate,
    required this.isCompleted,
    this.completedAt,
  });

  final String id;
  final KidsArabicDailyMissionType type;
  final String targetLetterId;
  final int targetCount;
  final String generatedForDate;
  final bool isCompleted;
  final String? completedAt;

  KidsArabicDailyMission copyWith({
    String? id,
    KidsArabicDailyMissionType? type,
    String? targetLetterId,
    int? targetCount,
    String? generatedForDate,
    bool? isCompleted,
    String? completedAt,
    bool clearCompletedAt = false,
  }) {
    return KidsArabicDailyMission(
      id: id ?? this.id,
      type: type ?? this.type,
      targetLetterId: targetLetterId ?? this.targetLetterId,
      targetCount: targetCount ?? this.targetCount,
      generatedForDate: generatedForDate ?? this.generatedForDate,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'type': type.name,
    'targetLetterId': targetLetterId,
    'targetCount': targetCount,
    'generatedForDate': generatedForDate,
    'isCompleted': isCompleted,
    'completedAt': completedAt,
  };

  static KidsArabicDailyMission? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final id = json['id']?.toString();
    final typeName = json['type']?.toString();
    final targetLetterId = json['targetLetterId']?.toString();
    final generatedForDate = json['generatedForDate']?.toString();
    if (id == null ||
        typeName == null ||
        targetLetterId == null ||
        generatedForDate == null) {
      return null;
    }
    final type = KidsArabicDailyMissionType.values.where(
      (value) => value.name == typeName,
    );
    if (type.isEmpty) return null;
    return KidsArabicDailyMission(
      id: id,
      type: type.first,
      targetLetterId: targetLetterId,
      targetCount: (json['targetCount'] as num?)?.toInt() ?? 1,
      generatedForDate: generatedForDate,
      isCompleted: json['isCompleted'] == true,
      completedAt: json['completedAt']?.toString(),
    );
  }
}

class KidsArabicDailyProgress {
  const KidsArabicDailyProgress({
    required this.lastCompletedAt,
    required this.currentStreak,
    required this.bestStreak,
    required this.totalActiveDays,
    required this.weeklyCompletions,
    required this.graceDaysAvailable,
    required this.todayMissionId,
    required this.todayMissionCompleted,
    required this.completionDayKeys,
  });

  final String? lastCompletedAt;
  final int currentStreak;
  final int bestStreak;
  final int totalActiveDays;
  final int weeklyCompletions;
  final int graceDaysAvailable;
  final String? todayMissionId;
  final bool todayMissionCompleted;
  final List<String> completionDayKeys;

  bool completedOnDay(String dayKey) {
    final raw = lastCompletedAt;
    if (raw == null || raw.isEmpty) return false;
    return raw.startsWith(dayKey);
  }

  KidsArabicDailyProgress copyWith({
    String? lastCompletedAt,
    bool clearLastCompletedAt = false,
    int? currentStreak,
    int? bestStreak,
    int? totalActiveDays,
    int? weeklyCompletions,
    int? graceDaysAvailable,
    String? todayMissionId,
    bool clearTodayMissionId = false,
    bool? todayMissionCompleted,
    List<String>? completionDayKeys,
  }) {
    return KidsArabicDailyProgress(
      lastCompletedAt: clearLastCompletedAt
          ? null
          : (lastCompletedAt ?? this.lastCompletedAt),
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      totalActiveDays: totalActiveDays ?? this.totalActiveDays,
      weeklyCompletions: weeklyCompletions ?? this.weeklyCompletions,
      graceDaysAvailable: graceDaysAvailable ?? this.graceDaysAvailable,
      todayMissionId: clearTodayMissionId
          ? null
          : (todayMissionId ?? this.todayMissionId),
      todayMissionCompleted:
          todayMissionCompleted ?? this.todayMissionCompleted,
      completionDayKeys: completionDayKeys ?? this.completionDayKeys,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'lastCompletedAt': lastCompletedAt,
    'currentStreak': currentStreak,
    'bestStreak': bestStreak,
    'totalActiveDays': totalActiveDays,
    'weeklyCompletions': weeklyCompletions,
    'graceDaysAvailable': graceDaysAvailable,
    'todayMissionId': todayMissionId,
    'todayMissionCompleted': todayMissionCompleted,
    'completionDayKeys': completionDayKeys,
  };

  static KidsArabicDailyProgress initial() => const KidsArabicDailyProgress(
    lastCompletedAt: null,
    currentStreak: 0,
    bestStreak: 0,
    totalActiveDays: 0,
    weeklyCompletions: 0,
    graceDaysAvailable: 1,
    todayMissionId: null,
    todayMissionCompleted: false,
    completionDayKeys: <String>[],
  );

  static KidsArabicDailyProgress fromJson(Map<String, dynamic>? json) {
    if (json == null) return initial();
    final rawHistory = json['completionDayKeys'];
    final completionDayKeys = rawHistory is List
        ? rawHistory.map((item) => item.toString()).toList(growable: false)
        : const <String>[];
    return KidsArabicDailyProgress(
      lastCompletedAt: json['lastCompletedAt']?.toString(),
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      bestStreak: (json['bestStreak'] as num?)?.toInt() ?? 0,
      totalActiveDays: (json['totalActiveDays'] as num?)?.toInt() ?? 0,
      weeklyCompletions: (json['weeklyCompletions'] as num?)?.toInt() ?? 0,
      graceDaysAvailable: (json['graceDaysAvailable'] as num?)?.toInt() ?? 1,
      todayMissionId: json['todayMissionId']?.toString(),
      todayMissionCompleted: json['todayMissionCompleted'] == true,
      completionDayKeys: completionDayKeys,
    );
  }
}

class KidsArabicProgressState {
  const KidsArabicProgressState({
    required this.progressByLetterId,
    required this.reviewNeededLetterIds,
    required this.earnedStickerIds,
    required this.totalLessonsDone,
    required this.totalReviewRoundsDone,
    required this.totalFeatureXpAwarded,
    required this.totalFeatureDropsAwarded,
    required this.localCurrentStreakDays,
    required this.localBestStreakDays,
    required this.dailyProgress,
    this.dailyMission,
    this.lastLessonLetterId,
    this.lastLessonDayKey,
  });

  final Map<String, KidsArabicLetterProgress> progressByLetterId;
  final Set<String> reviewNeededLetterIds;
  final Set<String> earnedStickerIds;
  final int totalLessonsDone;
  final int totalReviewRoundsDone;
  final int totalFeatureXpAwarded;
  final int totalFeatureDropsAwarded;
  final int localCurrentStreakDays;
  final int localBestStreakDays;
  final KidsArabicDailyProgress dailyProgress;
  final KidsArabicDailyMission? dailyMission;
  final String? lastLessonLetterId;
  final String? lastLessonDayKey;

  Set<String> get completedLetterIds => progressByLetterId.entries
      .where((entry) => entry.value.lessonsCompleted > 0)
      .map((entry) => entry.key)
      .toSet();

  KidsArabicProgressState copyWith({
    Map<String, KidsArabicLetterProgress>? progressByLetterId,
    Set<String>? reviewNeededLetterIds,
    Set<String>? earnedStickerIds,
    int? totalLessonsDone,
    int? totalReviewRoundsDone,
    int? totalFeatureXpAwarded,
    int? totalFeatureDropsAwarded,
    int? localCurrentStreakDays,
    int? localBestStreakDays,
    KidsArabicDailyProgress? dailyProgress,
    KidsArabicDailyMission? dailyMission,
    bool clearDailyMission = false,
    String? lastLessonLetterId,
    bool clearLastLessonLetterId = false,
    String? lastLessonDayKey,
    bool clearLastLessonDayKey = false,
  }) {
    return KidsArabicProgressState(
      progressByLetterId: progressByLetterId ?? this.progressByLetterId,
      reviewNeededLetterIds:
          reviewNeededLetterIds ?? this.reviewNeededLetterIds,
      earnedStickerIds: earnedStickerIds ?? this.earnedStickerIds,
      totalLessonsDone: totalLessonsDone ?? this.totalLessonsDone,
      totalReviewRoundsDone:
          totalReviewRoundsDone ?? this.totalReviewRoundsDone,
      totalFeatureXpAwarded:
          totalFeatureXpAwarded ?? this.totalFeatureXpAwarded,
      totalFeatureDropsAwarded:
          totalFeatureDropsAwarded ?? this.totalFeatureDropsAwarded,
      localCurrentStreakDays:
          localCurrentStreakDays ?? this.localCurrentStreakDays,
      localBestStreakDays: localBestStreakDays ?? this.localBestStreakDays,
      dailyProgress: dailyProgress ?? this.dailyProgress,
      dailyMission: clearDailyMission
          ? null
          : (dailyMission ?? this.dailyMission),
      lastLessonLetterId: clearLastLessonLetterId
          ? null
          : (lastLessonLetterId ?? this.lastLessonLetterId),
      lastLessonDayKey: clearLastLessonDayKey
          ? null
          : (lastLessonDayKey ?? this.lastLessonDayKey),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'progressByLetterId': progressByLetterId.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
    'reviewNeededLetterIds': reviewNeededLetterIds.toList(growable: false),
    'earnedStickerIds': earnedStickerIds.toList(growable: false),
    'totalLessonsDone': totalLessonsDone,
    'totalReviewRoundsDone': totalReviewRoundsDone,
    'totalFeatureXpAwarded': totalFeatureXpAwarded,
    'totalFeatureDropsAwarded': totalFeatureDropsAwarded,
    'localCurrentStreakDays': localCurrentStreakDays,
    'localBestStreakDays': localBestStreakDays,
    'dailyProgress': dailyProgress.toJson(),
    'dailyMission': dailyMission?.toJson(),
    'lastLessonLetterId': lastLessonLetterId,
    'lastLessonDayKey': lastLessonDayKey,
  };

  static KidsArabicProgressState initial() => KidsArabicProgressState(
    progressByLetterId: <String, KidsArabicLetterProgress>{},
    reviewNeededLetterIds: <String>{},
    earnedStickerIds: <String>{},
    totalLessonsDone: 0,
    totalReviewRoundsDone: 0,
    totalFeatureXpAwarded: 0,
    totalFeatureDropsAwarded: 0,
    localCurrentStreakDays: 0,
    localBestStreakDays: 0,
    dailyProgress: KidsArabicDailyProgress.initial(),
    dailyMission: null,
    lastLessonLetterId: null,
    lastLessonDayKey: null,
  );

  static KidsArabicProgressState fromJson(Map<String, dynamic>? json) {
    if (json == null) return initial();
    final progressRaw = json['progressByLetterId'];
    final progressByLetterId = <String, KidsArabicLetterProgress>{};
    if (progressRaw is Map) {
      for (final entry in progressRaw.entries) {
        final value = entry.value;
        if (value is Map<String, dynamic>) {
          progressByLetterId[entry.key.toString()] =
              KidsArabicLetterProgress.fromJson(value);
        } else if (value is Map) {
          progressByLetterId[entry.key
              .toString()] = KidsArabicLetterProgress.fromJson(
            value.map((k, v) => MapEntry(k.toString(), v)),
          );
        }
      }
    }
    Set<String> asSet(dynamic raw) {
      if (raw is! List) return <String>{};
      return raw.map((item) => item.toString()).toSet();
    }

    return KidsArabicProgressState(
      progressByLetterId: progressByLetterId,
      reviewNeededLetterIds: asSet(json['reviewNeededLetterIds']),
      earnedStickerIds: asSet(json['earnedStickerIds']),
      totalLessonsDone: (json['totalLessonsDone'] as num?)?.toInt() ?? 0,
      totalReviewRoundsDone:
          (json['totalReviewRoundsDone'] as num?)?.toInt() ?? 0,
      totalFeatureXpAwarded:
          (json['totalFeatureXpAwarded'] as num?)?.toInt() ?? 0,
      totalFeatureDropsAwarded:
          (json['totalFeatureDropsAwarded'] as num?)?.toInt() ?? 0,
      localCurrentStreakDays:
          (json['localCurrentStreakDays'] as num?)?.toInt() ?? 0,
      localBestStreakDays: (json['localBestStreakDays'] as num?)?.toInt() ?? 0,
      dailyProgress: KidsArabicDailyProgress.fromJson(
        json['dailyProgress'] is Map<String, dynamic>
            ? json['dailyProgress'] as Map<String, dynamic>
            : json['dailyProgress'] is Map
            ? (json['dailyProgress'] as Map).map(
                (k, v) => MapEntry(k.toString(), v),
              )
            : null,
      ),
      dailyMission: KidsArabicDailyMission.fromJson(
        json['dailyMission'] is Map<String, dynamic>
            ? json['dailyMission'] as Map<String, dynamic>
            : json['dailyMission'] is Map
            ? (json['dailyMission'] as Map).map(
                (k, v) => MapEntry(k.toString(), v),
              )
            : null,
      ),
      lastLessonLetterId: json['lastLessonLetterId']?.toString(),
      lastLessonDayKey: json['lastLessonDayKey']?.toString(),
    );
  }
}

class KidsArabicCompletionResult {
  const KidsArabicCompletionResult({
    required this.traceResult,
    required this.xpAwarded,
    required this.oceanDropsAwarded,
    required this.newStickerIds,
    required this.localStreakDays,
    required this.firstMeaningfulCompletion,
    this.dailyMissionResult,
  });

  final KidsArabicTraceResult traceResult;
  final int xpAwarded;
  final int oceanDropsAwarded;
  final List<String> newStickerIds;
  final int localStreakDays;
  final bool firstMeaningfulCompletion;
  final KidsArabicDailyMissionCompletionResult? dailyMissionResult;
}

class KidsArabicDailyMissionCompletionResult {
  const KidsArabicDailyMissionCompletionResult({
    required this.missionId,
    required this.currentStreak,
    required this.bestStreak,
    required this.totalActiveDays,
    required this.weeklyCompletions,
    required this.graceUsed,
    required this.xpAwarded,
    required this.oceanDropsAwarded,
  });

  final String missionId;
  final int currentStreak;
  final int bestStreak;
  final int totalActiveDays;
  final int weeklyCompletions;
  final bool graceUsed;
  final int xpAwarded;
  final int oceanDropsAwarded;
}

enum KidsArabicLessonSupportLevel { gentle, standard, extraHelp }

class KidsArabicParentPreferences {
  const KidsArabicParentPreferences({
    required this.guidedProgressionEnabled,
    required this.prioritizeReview,
    required this.showTransliteration,
    required this.audioAutoplay,
    required this.allowParentAssignedFocus,
    required this.parentAssignedLetterId,
    required this.parentAssignedReviewLetterId,
    required this.lessonSupportLevel,
  });

  final bool guidedProgressionEnabled;
  final bool prioritizeReview;
  final bool showTransliteration;
  final bool audioAutoplay;
  final bool allowParentAssignedFocus;
  final String? parentAssignedLetterId;
  final String? parentAssignedReviewLetterId;
  final KidsArabicLessonSupportLevel lessonSupportLevel;

  KidsArabicParentPreferences copyWith({
    bool? guidedProgressionEnabled,
    bool? prioritizeReview,
    bool? showTransliteration,
    bool? audioAutoplay,
    bool? allowParentAssignedFocus,
    String? parentAssignedLetterId,
    bool clearParentAssignedLetterId = false,
    String? parentAssignedReviewLetterId,
    bool clearParentAssignedReviewLetterId = false,
    KidsArabicLessonSupportLevel? lessonSupportLevel,
  }) {
    return KidsArabicParentPreferences(
      guidedProgressionEnabled:
          guidedProgressionEnabled ?? this.guidedProgressionEnabled,
      prioritizeReview: prioritizeReview ?? this.prioritizeReview,
      showTransliteration: showTransliteration ?? this.showTransliteration,
      audioAutoplay: audioAutoplay ?? this.audioAutoplay,
      allowParentAssignedFocus:
          allowParentAssignedFocus ?? this.allowParentAssignedFocus,
      parentAssignedLetterId: clearParentAssignedLetterId
          ? null
          : (parentAssignedLetterId ?? this.parentAssignedLetterId),
      parentAssignedReviewLetterId: clearParentAssignedReviewLetterId
          ? null
          : (parentAssignedReviewLetterId ?? this.parentAssignedReviewLetterId),
      lessonSupportLevel: lessonSupportLevel ?? this.lessonSupportLevel,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'guidedProgressionEnabled': guidedProgressionEnabled,
    'prioritizeReview': prioritizeReview,
    'showTransliteration': showTransliteration,
    'audioAutoplay': audioAutoplay,
    'allowParentAssignedFocus': allowParentAssignedFocus,
    'parentAssignedLetterId': parentAssignedLetterId,
    'parentAssignedReviewLetterId': parentAssignedReviewLetterId,
    'lessonSupportLevel': lessonSupportLevel.name,
  };

  static KidsArabicParentPreferences initial() =>
      const KidsArabicParentPreferences(
        guidedProgressionEnabled: true,
        prioritizeReview: false,
        showTransliteration: true,
        audioAutoplay: false,
        allowParentAssignedFocus: false,
        parentAssignedLetterId: null,
        parentAssignedReviewLetterId: null,
        lessonSupportLevel: KidsArabicLessonSupportLevel.standard,
      );

  static KidsArabicParentPreferences fromJson(Map<String, dynamic>? json) {
    if (json == null) return initial();
    final levelName = json['lessonSupportLevel']?.toString();
    final level = KidsArabicLessonSupportLevel.values.where(
      (item) => item.name == levelName,
    );
    return KidsArabicParentPreferences(
      guidedProgressionEnabled: json['guidedProgressionEnabled'] != false,
      prioritizeReview: json['prioritizeReview'] == true,
      showTransliteration: json['showTransliteration'] != false,
      audioAutoplay: json['audioAutoplay'] == true,
      allowParentAssignedFocus: json['allowParentAssignedFocus'] == true,
      parentAssignedLetterId: json['parentAssignedLetterId']?.toString(),
      parentAssignedReviewLetterId: json['parentAssignedReviewLetterId']
          ?.toString(),
      lessonSupportLevel: level.isEmpty
          ? KidsArabicLessonSupportLevel.standard
          : level.first,
    );
  }
}

class KidsArabicWeeklyConsistencyDay {
  const KidsArabicWeeklyConsistencyDay({
    required this.dayKey,
    required this.weekday,
    required this.completed,
  });

  final String dayKey;
  final int weekday;
  final bool completed;
}

class KidsArabicParentSummary {
  const KidsArabicParentSummary({
    required this.lettersCompleted,
    required this.lessonsCompleted,
    required this.currentStreak,
    required this.bestStreak,
    required this.activeDaysThisWeek,
    required this.reviewNeededLetterIds,
    required this.latestCompletedLetterId,
    required this.recommendedNextLetterId,
    required this.assignedFocusLetterId,
    required this.weeklyCompletionCount,
    required this.earnedStickerCount,
    required this.weeklyConsistency,
  });

  final int lettersCompleted;
  final int lessonsCompleted;
  final int currentStreak;
  final int bestStreak;
  final int activeDaysThisWeek;
  final List<String> reviewNeededLetterIds;
  final String? latestCompletedLetterId;
  final String? recommendedNextLetterId;
  final String? assignedFocusLetterId;
  final int weeklyCompletionCount;
  final int earnedStickerCount;
  final List<KidsArabicWeeklyConsistencyDay> weeklyConsistency;
}

enum KidsArabicRecommendedActivitySource {
  parentAssignedFocus,
  parentAssignedReview,
  dailyMission,
  nextUnlockedLesson,
}

class KidsArabicRecommendedActivity {
  const KidsArabicRecommendedActivity({
    required this.source,
    required this.letterId,
    required this.opensReview,
  });

  final KidsArabicRecommendedActivitySource source;
  final String letterId;
  final bool opensReview;
}
