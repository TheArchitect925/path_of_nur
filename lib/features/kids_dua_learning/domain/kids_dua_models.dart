import 'package:flutter/material.dart';

enum KidsDuaLessonStatus { notStarted, inProgress, learned }

enum KidsDuaDailyDuaState { notLearned, inProgress, learned }

enum KidsDuaTimeBlock { earlyMorning, midday, afternoon, evening, night }

enum KidsDuaPracticeQuestionType { matchSituation, meaning, behavior }

enum KidsDuaDailyActivityType {
  lessonCompleted,
  myDaySectionCompleted,
  todayFocusCompleted,
  practiceCorrect,
  learnedDuaPracticed,
}

enum KidsDuaLightLevel { seed, glow, lantern, moon, star, radiant }

enum KidsDuaReminderContextType {
  morning,
  midday,
  evening,
  bedtime,
  gentleRecovery,
}

enum KidsDuaActivityLogType {
  lessonCompleted,
  myDayCompleted,
  myDayStepCompleted,
  practiceCorrect,
  drawingSaved,
  storyCompleted,
}

class KidsDuaBehaviorScenario {
  const KidsDuaBehaviorScenario({
    required this.id,
    required this.situation,
    required this.correctDuaId,
    required this.distractorOptions,
    required this.message,
  });

  final String id;
  final String situation;
  final String correctDuaId;
  final List<String> distractorOptions;
  final String message;
}

class KidsDuaDaySection {
  const KidsDuaDaySection({
    required this.id,
    required this.titleKey,
    required this.icon,
    required this.duaIds,
    required this.order,
  });

  final String id;
  final String titleKey;
  final IconData icon;
  final List<String> duaIds;
  final int order;
}

class KidsDuaMyDayGuidance {
  const KidsDuaMyDayGuidance({
    required this.activeSection,
    required this.rightNowLesson,
    required this.rightNowState,
    required this.rightNowReasonKey,
    required this.nextUpLesson,
    required this.nextUpSection,
  });

  final KidsDuaDaySection activeSection;
  final KidsDuaLessonContent? rightNowLesson;
  final KidsDuaDailyDuaState? rightNowState;
  final String rightNowReasonKey;
  final KidsDuaLessonContent? nextUpLesson;
  final KidsDuaDaySection? nextUpSection;
}

class KidsDuaCategory {
  const KidsDuaCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.sortOrder,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final int sortOrder;
}

class KidsDuaPhraseChunk {
  const KidsDuaPhraseChunk({
    required this.id,
    required this.arabic,
    required this.transliteration,
  });

  final String id;
  final String arabic;
  final String transliteration;
}

class KidsDuaLessonContent {
  const KidsDuaLessonContent({
    required this.id,
    required this.slug,
    required this.categoryId,
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
    required this.miniLesson,
    required this.whenToSay,
    required this.phraseChunks,
    required this.sourceType,
    required this.sourceReference,
    required this.audioAssetPath,
    required this.rewardStickerId,
    required this.sortOrder,
    required this.level,
    required this.icon,
    this.practicePrompt,
  });

  final String id;
  final String slug;
  final String categoryId;
  final String title;
  final String arabic;
  final String transliteration;
  final String meaning;
  final String miniLesson;
  final String whenToSay;
  final List<KidsDuaPhraseChunk> phraseChunks;
  final String sourceType;
  final String sourceReference;
  final String audioAssetPath;
  final String rewardStickerId;
  final int sortOrder;
  final int level;
  final IconData icon;
  final String? practicePrompt;

  KidsDuaLessonContent copyWith({
    String? title,
    String? transliteration,
    String? meaning,
    String? miniLesson,
    String? whenToSay,
    String? practicePrompt,
    bool clearPracticePrompt = false,
  }) {
    return KidsDuaLessonContent(
      id: id,
      slug: slug,
      categoryId: categoryId,
      title: title ?? this.title,
      arabic: arabic,
      transliteration: transliteration ?? this.transliteration,
      meaning: meaning ?? this.meaning,
      miniLesson: miniLesson ?? this.miniLesson,
      whenToSay: whenToSay ?? this.whenToSay,
      phraseChunks: phraseChunks,
      sourceType: sourceType,
      sourceReference: sourceReference,
      audioAssetPath: audioAssetPath,
      rewardStickerId: rewardStickerId,
      sortOrder: sortOrder,
      level: level,
      icon: icon,
      practicePrompt: clearPracticePrompt
          ? null
          : practicePrompt ?? this.practicePrompt,
    );
  }
}

class KidsDuaLessonProgress {
  const KidsDuaLessonProgress({
    required this.lessonId,
    required this.openCount,
    required this.timesPracticed,
    this.listenCount = 0,
    this.segmentRepeatCount = 0,
    this.startedAtIso,
    this.completedAtIso,
    this.readAlongCompletedAtIso,
    this.lastPracticedAtIso,
    this.lastLearningMode,
  });

  final String lessonId;
  final int openCount;
  final int timesPracticed;
  final int listenCount;
  final int segmentRepeatCount;
  final String? startedAtIso;
  final String? completedAtIso;
  final String? readAlongCompletedAtIso;
  final String? lastPracticedAtIso;
  final String? lastLearningMode;

  KidsDuaLessonStatus get status {
    if (completedAtIso != null && completedAtIso!.isNotEmpty) {
      return KidsDuaLessonStatus.learned;
    }
    if (startedAtIso != null && startedAtIso!.isNotEmpty) {
      return KidsDuaLessonStatus.inProgress;
    }
    return KidsDuaLessonStatus.notStarted;
  }

  KidsDuaLessonProgress copyWith({
    int? openCount,
    int? timesPracticed,
    int? listenCount,
    int? segmentRepeatCount,
    String? startedAtIso,
    String? completedAtIso,
    String? readAlongCompletedAtIso,
    String? lastPracticedAtIso,
    String? lastLearningMode,
    bool clearCompletedAtIso = false,
    bool clearReadAlongCompletedAtIso = false,
    bool clearLastPracticedAtIso = false,
    bool clearLastLearningMode = false,
  }) {
    return KidsDuaLessonProgress(
      lessonId: lessonId,
      openCount: openCount ?? this.openCount,
      timesPracticed: timesPracticed ?? this.timesPracticed,
      listenCount: listenCount ?? this.listenCount,
      segmentRepeatCount: segmentRepeatCount ?? this.segmentRepeatCount,
      startedAtIso: startedAtIso ?? this.startedAtIso,
      completedAtIso: clearCompletedAtIso
          ? null
          : (completedAtIso ?? this.completedAtIso),
      readAlongCompletedAtIso: clearReadAlongCompletedAtIso
          ? null
          : (readAlongCompletedAtIso ?? this.readAlongCompletedAtIso),
      lastPracticedAtIso: clearLastPracticedAtIso
          ? null
          : (lastPracticedAtIso ?? this.lastPracticedAtIso),
      lastLearningMode: clearLastLearningMode
          ? null
          : (lastLearningMode ?? this.lastLearningMode),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'lessonId': lessonId,
    'openCount': openCount,
    'timesPracticed': timesPracticed,
    'listenCount': listenCount,
    'segmentRepeatCount': segmentRepeatCount,
    'startedAtIso': startedAtIso,
    'completedAtIso': completedAtIso,
    'readAlongCompletedAtIso': readAlongCompletedAtIso,
    'lastPracticedAtIso': lastPracticedAtIso,
    'lastLearningMode': lastLearningMode,
  };

  static KidsDuaLessonProgress fromJson(Map<String, dynamic> json) {
    return KidsDuaLessonProgress(
      lessonId: json['lessonId']?.toString() ?? '',
      openCount: (json['openCount'] as num?)?.toInt() ?? 0,
      timesPracticed: (json['timesPracticed'] as num?)?.toInt() ?? 0,
      listenCount: (json['listenCount'] as num?)?.toInt() ?? 0,
      segmentRepeatCount: (json['segmentRepeatCount'] as num?)?.toInt() ?? 0,
      startedAtIso: json['startedAtIso']?.toString(),
      completedAtIso: json['completedAtIso']?.toString(),
      readAlongCompletedAtIso: json['readAlongCompletedAtIso']?.toString(),
      lastPracticedAtIso: json['lastPracticedAtIso']?.toString(),
      lastLearningMode: json['lastLearningMode']?.toString(),
    );
  }
}

class KidsDuaRewardItem {
  const KidsDuaRewardItem({
    required this.id,
    required this.titleKey,
    required this.subtitleKey,
    required this.icon,
    required this.color,
    this.requiredCompletedDuas = 0,
    this.requiredPracticeSessions = 0,
    this.requiredCategoryId,
  });

  final String id;
  final String titleKey;
  final String subtitleKey;
  final IconData icon;
  final Color color;
  final int requiredCompletedDuas;
  final int requiredPracticeSessions;
  final String? requiredCategoryId;
}

class KidsDuaSticker {
  const KidsDuaSticker({
    required this.id,
    required this.categoryId,
    required this.titleKey,
    required this.icon,
    required this.color,
  });

  final String id;
  final String categoryId;
  final String titleKey;
  final IconData icon;
  final Color color;
}

class KidsDuaPracticeResult {
  const KidsDuaPracticeResult({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.practicedLessonIds,
    required this.newRewardIds,
  });

  final int totalQuestions;
  final int correctAnswers;
  final List<String> practicedLessonIds;
  final List<String> newRewardIds;
}

class KidsDuaPracticeQuestion {
  const KidsDuaPracticeQuestion({
    required this.id,
    required this.type,
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.relatedDuaId,
    required this.difficulty,
    this.explanation,
  });

  final String id;
  final KidsDuaPracticeQuestionType type;
  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String relatedDuaId;
  final String? explanation;
  final int difficulty;
}

class KidsDuaReminderPrompt {
  const KidsDuaReminderPrompt({
    required this.id,
    required this.contextType,
    required this.titleKey,
    required this.bodyKey,
    required this.suggestedHour,
    required this.categoryBias,
    required this.enabledByDefault,
  });

  final String id;
  final KidsDuaReminderContextType contextType;
  final String titleKey;
  final String bodyKey;
  final int suggestedHour;
  final String? categoryBias;
  final bool enabledByDefault;
}

class KidsDuaDrawing {
  const KidsDuaDrawing({
    required this.id,
    required this.duaId,
    required this.imagePath,
    required this.createdAt,
    required this.lastEditedAt,
  });

  final String id;
  final String duaId;
  final String imagePath;
  final String createdAt;
  final String lastEditedAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'duaId': duaId,
    'imagePath': imagePath,
    'createdAt': createdAt,
    'lastEditedAt': lastEditedAt,
  };

  static KidsDuaDrawing fromJson(Map<String, dynamic> json) {
    return KidsDuaDrawing(
      id: json['id']?.toString() ?? '',
      duaId: json['duaId']?.toString() ?? '',
      imagePath: json['imagePath']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      lastEditedAt: json['lastEditedAt']?.toString() ?? '',
    );
  }
}

class KidsDuaActivityLogEntry {
  const KidsDuaActivityLogEntry({
    required this.id,
    required this.type,
    required this.dateKey,
    required this.timestampIso,
    this.duaId,
  });

  final String id;
  final KidsDuaActivityLogType type;
  final String dateKey;
  final String timestampIso;
  final String? duaId;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'type': type.name,
    'dateKey': dateKey,
    'timestampIso': timestampIso,
    'duaId': duaId,
  };

  static KidsDuaActivityLogEntry fromJson(Map<String, dynamic> json) {
    final typeName = json['type']?.toString() ?? '';
    return KidsDuaActivityLogEntry(
      id: json['id']?.toString() ?? '',
      type: KidsDuaActivityLogType.values.firstWhere(
        (item) => item.name == typeName,
        orElse: () => KidsDuaActivityLogType.lessonCompleted,
      ),
      dateKey: json['dateKey']?.toString() ?? '',
      timestampIso: json['timestampIso']?.toString() ?? '',
      duaId: json['duaId']?.toString(),
    );
  }
}

class KidsDuaCreativeState {
  const KidsDuaCreativeState({
    required this.drawings,
    required this.parentViewEnabled,
  });

  final List<KidsDuaDrawing> drawings;
  final bool parentViewEnabled;

  KidsDuaCreativeState copyWith({
    List<KidsDuaDrawing>? drawings,
    bool? parentViewEnabled,
  }) {
    return KidsDuaCreativeState(
      drawings: drawings ?? this.drawings,
      parentViewEnabled: parentViewEnabled ?? this.parentViewEnabled,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'drawings': drawings.map((item) => item.toJson()).toList(growable: false),
    'parentViewEnabled': parentViewEnabled,
  };

  static KidsDuaCreativeState initial() => const KidsDuaCreativeState(
    drawings: <KidsDuaDrawing>[],
    parentViewEnabled: false,
  );

  static KidsDuaCreativeState fromJson(Map<String, dynamic>? json) {
    if (json == null) return initial();
    return KidsDuaCreativeState(
      drawings: ((json['drawings'] as List?) ?? const [])
          .whereType<Map>()
          .map(
            (item) => KidsDuaDrawing.fromJson(
              item.map((key, value) => MapEntry(key.toString(), value)),
            ),
          )
          .toList(growable: false),
      parentViewEnabled: json['parentViewEnabled'] == true,
    );
  }
}

class KidsDuaParentDashboard {
  const KidsDuaParentDashboard({
    required this.totalDuasLearned,
    required this.streakDays,
    required this.lightLevel,
    required this.todayCompleted,
    required this.categoryProgress,
    required this.recentActivity,
    required this.drawings,
  });

  final int totalDuasLearned;
  final int streakDays;
  final KidsDuaLightLevel lightLevel;
  final bool todayCompleted;
  final List<KidsDuaParentCategoryProgress> categoryProgress;
  final List<KidsDuaActivityLogEntry> recentActivity;
  final List<KidsDuaDrawing> drawings;
}

class KidsDuaParentCategoryProgress {
  const KidsDuaParentCategoryProgress({
    required this.categoryId,
    required this.categoryTitle,
    required this.learnedCount,
    required this.totalCount,
  });

  final String categoryId;
  final String categoryTitle;
  final int learnedCount;
  final int totalCount;
}

enum KidsDuaStoryIllustrationType {
  bedroom,
  table,
  sky,
  home,
  learning,
  emotional,
}

enum KidsDuaStoryTimeOfDay { morning, day, evening, night }

enum KidsDuaStoryVisualMood { calm, happy, sad, wonder, neutral }

class KidsDuaStorySceneVisual {
  const KidsDuaStorySceneVisual({
    required this.illustrationType,
    required this.timeOfDay,
    required this.mood,
    this.elements = const <String>[],
  });

  final KidsDuaStoryIllustrationType illustrationType;
  final KidsDuaStoryTimeOfDay timeOfDay;
  final KidsDuaStoryVisualMood mood;
  final List<String> elements;

  factory KidsDuaStorySceneVisual.infer({
    required String illustrationHint,
    required String sceneMood,
  }) {
    final hint = illustrationHint.toLowerCase();
    final moodText = sceneMood.toLowerCase();

    KidsDuaStoryIllustrationType type = KidsDuaStoryIllustrationType.home;
    if (_containsAny(hint, const <String>[
      'bed',
      'bedroom',
      'blanket',
      'moonlight',
      'sleep',
      'pillow',
    ])) {
      type = KidsDuaStoryIllustrationType.bedroom;
    } else if (_containsAny(hint, const <String>[
      'table',
      'plate',
      'meal',
      'food',
      'eating',
      'dinner',
      'tummy',
    ])) {
      type = KidsDuaStoryIllustrationType.table;
    } else if (_containsAny(hint, const <String>[
      'book',
      'reading',
      'study',
      'learning',
      'pages',
    ])) {
      type = KidsDuaStoryIllustrationType.learning;
    } else if (_containsAny(hint, const <String>[
      'dark',
      'worried',
      'sad',
      'cry',
      'help',
      'task',
      'alone',
      'soft smile',
    ])) {
      type = KidsDuaStoryIllustrationType.emotional;
    } else if (_containsAny(hint, const <String>[
      'sky',
      'stars',
      'rain',
      'flower',
      'garden',
      'car',
      'window',
      'outdoor',
    ])) {
      type = KidsDuaStoryIllustrationType.sky;
    }

    KidsDuaStoryTimeOfDay timeOfDay = KidsDuaStoryTimeOfDay.day;
    if (_containsAny(hint, const <String>['night', 'moon', 'stars', 'dark'])) {
      timeOfDay = KidsDuaStoryTimeOfDay.night;
    } else if (_containsAny(hint, const <String>['sunrise', 'morning'])) {
      timeOfDay = KidsDuaStoryTimeOfDay.morning;
    } else if (_containsAny(hint, const <String>['evening', 'sunset'])) {
      timeOfDay = KidsDuaStoryTimeOfDay.evening;
    }

    KidsDuaStoryVisualMood mood = KidsDuaStoryVisualMood.neutral;
    if (_containsAny(moodText, const <String>[
      'sad',
      'heavy',
      'uneasy',
      'struggling',
      'afraid',
      'relief',
    ])) {
      mood = KidsDuaStoryVisualMood.sad;
    } else if (_containsAny(moodText, const <String>[
      'wonder',
      'amazed',
      'curious',
    ])) {
      mood = KidsDuaStoryVisualMood.wonder;
    } else if (_containsAny(moodText, const <String>[
      'joy',
      'happy',
      'cheerful',
      'grateful',
      'excited',
      'friendly',
      'kind',
      'brave',
      'hopeful',
      'delighted',
    ])) {
      mood = KidsDuaStoryVisualMood.happy;
    } else if (_containsAny(moodText, const <String>[
      'calm',
      'peaceful',
      'restful',
      'cozy',
      'loving',
      'safe',
      'secure',
      'comforting',
      'warm',
      'tender',
      'focused',
    ])) {
      mood = KidsDuaStoryVisualMood.calm;
    }

    final elements = <String>[
      if (_containsAny(hint, const <String>['moon'])) 'moon',
      if (_containsAny(hint, const <String>['stars'])) 'stars',
      if (_containsAny(hint, const <String>['food', 'plate', 'meal'])) 'food',
      if (_containsAny(hint, const <String>['mother', 'parent', 'mama']))
        'parent',
      if (_containsAny(hint, const <String>['child'])) 'child',
    ];

    return KidsDuaStorySceneVisual(
      illustrationType: type,
      timeOfDay: timeOfDay,
      mood: mood,
      elements: elements,
    );
  }

  static bool _containsAny(String value, List<String> needles) {
    return needles.any(value.contains);
  }
}

class KidsDuaStoryScene {
  const KidsDuaStoryScene({
    required this.id,
    required this.storyId,
    required this.order,
    required this.text,
    required this.illustrationHint,
    required this.mood,
    required this.highlightPhrase,
    this.visual,
  });

  final String id;
  final String storyId;
  final int order;
  final String text;
  final String illustrationHint;
  final String mood;
  final String highlightPhrase;
  final KidsDuaStorySceneVisual? visual;

  KidsDuaStorySceneVisual get resolvedVisual =>
      visual ??
      KidsDuaStorySceneVisual.infer(
        illustrationHint: illustrationHint,
        sceneMood: mood,
      );
}

class KidsDuaStory {
  const KidsDuaStory({
    required this.id,
    required this.duaId,
    required this.slug,
    required this.title,
    required this.category,
    required this.ageGroup,
    required this.estimatedDurationSec,
    required this.introLine,
    required this.closingLine,
    required this.narrationText,
    required this.scenes,
    required this.illustrationKeys,
  });

  final String id;
  final String duaId;
  final String slug;
  final String title;
  final String category;
  final String ageGroup;
  final int estimatedDurationSec;
  final String introLine;
  final String closingLine;
  final String narrationText;
  final List<KidsDuaStoryScene> scenes;
  final List<String> illustrationKeys;

  int get sceneCount => scenes.length;
}

class KidsDuaStoryProgress {
  const KidsDuaStoryProgress({
    required this.storyId,
    required this.viewedSceneCount,
    required this.completed,
    this.lastViewedAt,
  });

  final String storyId;
  final int viewedSceneCount;
  final bool completed;
  final String? lastViewedAt;

  KidsDuaStoryProgress copyWith({
    int? viewedSceneCount,
    bool? completed,
    String? lastViewedAt,
  }) {
    return KidsDuaStoryProgress(
      storyId: storyId,
      viewedSceneCount: viewedSceneCount ?? this.viewedSceneCount,
      completed: completed ?? this.completed,
      lastViewedAt: lastViewedAt ?? this.lastViewedAt,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'storyId': storyId,
    'viewedSceneCount': viewedSceneCount,
    'completed': completed,
    'lastViewedAt': lastViewedAt,
  };

  static KidsDuaStoryProgress fromJson(Map<String, dynamic> json) {
    return KidsDuaStoryProgress(
      storyId: json['storyId']?.toString() ?? '',
      viewedSceneCount: (json['viewedSceneCount'] as num?)?.toInt() ?? 0,
      completed: json['completed'] == true,
      lastViewedAt: json['lastViewedAt']?.toString(),
    );
  }
}

class KidsDuaCompletionResult {
  const KidsDuaCompletionResult({
    required this.xpAwarded,
    required this.oceanDropsAwarded,
    required this.newRewardIds,
    required this.newStickerIds,
    required this.firstCompletion,
  });

  final int xpAwarded;
  final int oceanDropsAwarded;
  final List<String> newRewardIds;
  final List<String> newStickerIds;
  final bool firstCompletion;
}

class KidsDuaMyDayCompletionResult {
  const KidsDuaMyDayCompletionResult({
    required this.dayCompletedNow,
    required this.xpAwarded,
    required this.oceanDropsAwarded,
  });

  final bool dayCompletedNow;
  final int xpAwarded;
  final int oceanDropsAwarded;
}

class DailyUsageState {
  const DailyUsageState({
    required this.date,
    required this.completedDuaIds,
    required this.completedSectionIds,
    required this.currentSuggestedDuaId,
    required this.nextSuggestedDuaId,
    required this.isDayComplete,
    required this.dayCompletionRewarded,
  });

  final String date;
  final Set<String> completedDuaIds;
  final Set<String> completedSectionIds;
  final String? currentSuggestedDuaId;
  final String? nextSuggestedDuaId;
  final bool isDayComplete;
  final bool dayCompletionRewarded;

  DailyUsageState copyWith({
    String? date,
    Set<String>? completedDuaIds,
    Set<String>? completedSectionIds,
    String? currentSuggestedDuaId,
    String? nextSuggestedDuaId,
    bool clearCurrentSuggestedDuaId = false,
    bool clearNextSuggestedDuaId = false,
    bool? isDayComplete,
    bool? dayCompletionRewarded,
  }) {
    return DailyUsageState(
      date: date ?? this.date,
      completedDuaIds: completedDuaIds ?? this.completedDuaIds,
      completedSectionIds: completedSectionIds ?? this.completedSectionIds,
      currentSuggestedDuaId: clearCurrentSuggestedDuaId
          ? null
          : (currentSuggestedDuaId ?? this.currentSuggestedDuaId),
      nextSuggestedDuaId: clearNextSuggestedDuaId
          ? null
          : (nextSuggestedDuaId ?? this.nextSuggestedDuaId),
      isDayComplete: isDayComplete ?? this.isDayComplete,
      dayCompletionRewarded:
          dayCompletionRewarded ?? this.dayCompletionRewarded,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'date': date,
    'completedDuaIds': completedDuaIds.toList(growable: false),
    'completedSectionIds': completedSectionIds.toList(growable: false),
    'currentSuggestedDuaId': currentSuggestedDuaId,
    'nextSuggestedDuaId': nextSuggestedDuaId,
    'isDayComplete': isDayComplete,
    'dayCompletionRewarded': dayCompletionRewarded,
  };

  static DailyUsageState initial(String date) => DailyUsageState(
    date: date,
    completedDuaIds: const <String>{},
    completedSectionIds: const <String>{},
    currentSuggestedDuaId: null,
    nextSuggestedDuaId: null,
    isDayComplete: false,
    dayCompletionRewarded: false,
  );

  static DailyUsageState fromJson(Map<String, dynamic>? json, String date) {
    if (json == null) return initial(date);
    final rawDate = json['date']?.toString() ?? date;
    if (rawDate != date) return initial(date);
    return DailyUsageState(
      date: rawDate,
      completedDuaIds: ((json['completedDuaIds'] as List?) ?? const [])
          .map((item) => item.toString())
          .toSet(),
      completedSectionIds: ((json['completedSectionIds'] as List?) ?? const [])
          .map((item) => item.toString())
          .toSet(),
      currentSuggestedDuaId: json['currentSuggestedDuaId']?.toString(),
      nextSuggestedDuaId: json['nextSuggestedDuaId']?.toString(),
      isDayComplete: json['isDayComplete'] == true,
      dayCompletionRewarded: json['dayCompletionRewarded'] == true,
    );
  }
}

class KidsDuaLearningState {
  const KidsDuaLearningState({
    required this.progressByLessonId,
    required this.unlockedRewardIds,
    required this.stickerUnlockedAtById,
    required this.completedStoryIds,
    required this.storyProgressById,
    required this.recentStoryIds,
    required this.recentLessonIds,
    required this.totalFeatureXpAwarded,
    required this.totalFeatureDropsAwarded,
    required this.totalPracticeSessions,
    required this.currentStreakDays,
    required this.longestStreakDays,
    required this.lastActiveDate,
    required this.todayCompleted,
    required this.lastGraceUsedDate,
    required this.activityLog,
  });

  final Map<String, KidsDuaLessonProgress> progressByLessonId;
  final Set<String> unlockedRewardIds;
  final Map<String, String> stickerUnlockedAtById;
  final Set<String> completedStoryIds;
  final Map<String, KidsDuaStoryProgress> storyProgressById;
  final List<String> recentStoryIds;
  final List<String> recentLessonIds;
  final int totalFeatureXpAwarded;
  final int totalFeatureDropsAwarded;
  final int totalPracticeSessions;
  final int currentStreakDays;
  final int longestStreakDays;
  final String? lastActiveDate;
  final bool todayCompleted;
  final String? lastGraceUsedDate;
  final List<KidsDuaActivityLogEntry> activityLog;

  Set<String> get learnedLessonIds => progressByLessonId.entries
      .where((entry) => entry.value.status == KidsDuaLessonStatus.learned)
      .map((entry) => entry.key)
      .toSet();

  KidsDuaLearningState copyWith({
    Map<String, KidsDuaLessonProgress>? progressByLessonId,
    Set<String>? unlockedRewardIds,
    Map<String, String>? stickerUnlockedAtById,
    Set<String>? completedStoryIds,
    Map<String, KidsDuaStoryProgress>? storyProgressById,
    List<String>? recentStoryIds,
    List<String>? recentLessonIds,
    int? totalFeatureXpAwarded,
    int? totalFeatureDropsAwarded,
    int? totalPracticeSessions,
    int? currentStreakDays,
    int? longestStreakDays,
    String? lastActiveDate,
    bool? todayCompleted,
    String? lastGraceUsedDate,
    List<KidsDuaActivityLogEntry>? activityLog,
    bool clearLastActiveDate = false,
    bool clearLastGraceUsedDate = false,
  }) {
    return KidsDuaLearningState(
      progressByLessonId: progressByLessonId ?? this.progressByLessonId,
      unlockedRewardIds: unlockedRewardIds ?? this.unlockedRewardIds,
      stickerUnlockedAtById:
          stickerUnlockedAtById ?? this.stickerUnlockedAtById,
      completedStoryIds: completedStoryIds ?? this.completedStoryIds,
      storyProgressById: storyProgressById ?? this.storyProgressById,
      recentStoryIds: recentStoryIds ?? this.recentStoryIds,
      recentLessonIds: recentLessonIds ?? this.recentLessonIds,
      totalFeatureXpAwarded:
          totalFeatureXpAwarded ?? this.totalFeatureXpAwarded,
      totalFeatureDropsAwarded:
          totalFeatureDropsAwarded ?? this.totalFeatureDropsAwarded,
      totalPracticeSessions:
          totalPracticeSessions ?? this.totalPracticeSessions,
      currentStreakDays: currentStreakDays ?? this.currentStreakDays,
      longestStreakDays: longestStreakDays ?? this.longestStreakDays,
      lastActiveDate: clearLastActiveDate
          ? null
          : (lastActiveDate ?? this.lastActiveDate),
      todayCompleted: todayCompleted ?? this.todayCompleted,
      lastGraceUsedDate: clearLastGraceUsedDate
          ? null
          : (lastGraceUsedDate ?? this.lastGraceUsedDate),
      activityLog: activityLog ?? this.activityLog,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'progressByLessonId': progressByLessonId.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
    'unlockedRewardIds': unlockedRewardIds.toList(growable: false),
    'stickerUnlockedAtById': stickerUnlockedAtById,
    'completedStoryIds': completedStoryIds.toList(growable: false),
    'storyProgressById': storyProgressById.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
    'recentStoryIds': recentStoryIds,
    'recentLessonIds': recentLessonIds,
    'totalFeatureXpAwarded': totalFeatureXpAwarded,
    'totalFeatureDropsAwarded': totalFeatureDropsAwarded,
    'totalPracticeSessions': totalPracticeSessions,
    'currentStreakDays': currentStreakDays,
    'longestStreakDays': longestStreakDays,
    'lastActiveDate': lastActiveDate,
    'todayCompleted': todayCompleted,
    'lastGraceUsedDate': lastGraceUsedDate,
    'activityLog': activityLog
        .map((item) => item.toJson())
        .toList(growable: false),
  };

  static KidsDuaLearningState initial() => const KidsDuaLearningState(
    progressByLessonId: <String, KidsDuaLessonProgress>{},
    unlockedRewardIds: <String>{},
    stickerUnlockedAtById: <String, String>{},
    completedStoryIds: <String>{},
    storyProgressById: <String, KidsDuaStoryProgress>{},
    recentStoryIds: <String>[],
    recentLessonIds: <String>[],
    totalFeatureXpAwarded: 0,
    totalFeatureDropsAwarded: 0,
    totalPracticeSessions: 0,
    currentStreakDays: 0,
    longestStreakDays: 0,
    lastActiveDate: null,
    todayCompleted: false,
    lastGraceUsedDate: null,
    activityLog: <KidsDuaActivityLogEntry>[],
  );

  static KidsDuaLearningState fromJson(Map<String, dynamic>? json) {
    if (json == null) return initial();
    final rawProgress = json['progressByLessonId'];
    final progressByLessonId = <String, KidsDuaLessonProgress>{};
    if (rawProgress is Map) {
      for (final entry in rawProgress.entries) {
        final value = entry.value;
        if (value is Map<String, dynamic>) {
          progressByLessonId[entry.key.toString()] =
              KidsDuaLessonProgress.fromJson(value);
        } else if (value is Map) {
          progressByLessonId[entry.key
              .toString()] = KidsDuaLessonProgress.fromJson(
            value.map((k, v) => MapEntry(k.toString(), v)),
          );
        }
      }
    }
    final unlocked = ((json['unlockedRewardIds'] as List?) ?? const [])
        .map((item) => item.toString())
        .toSet();
    final completedStories = ((json['completedStoryIds'] as List?) ?? const [])
        .map((item) => item.toString())
        .toSet();
    final rawStoryProgress = json['storyProgressById'];
    final storyProgressById = <String, KidsDuaStoryProgress>{};
    if (rawStoryProgress is Map) {
      for (final entry in rawStoryProgress.entries) {
        final value = entry.value;
        if (value is Map<String, dynamic>) {
          storyProgressById[entry.key.toString()] =
              KidsDuaStoryProgress.fromJson(value);
        } else if (value is Map) {
          storyProgressById[entry.key
              .toString()] = KidsDuaStoryProgress.fromJson(
            value.map((k, v) => MapEntry(k.toString(), v)),
          );
        }
      }
    }
    final unlockedStickers = <String, String>{};
    final rawStickers = json['stickerUnlockedAtById'];
    if (rawStickers is Map) {
      for (final entry in rawStickers.entries) {
        unlockedStickers[entry.key.toString()] = entry.value.toString();
      }
    }
    final recent = ((json['recentLessonIds'] as List?) ?? const [])
        .map((item) => item.toString())
        .toList(growable: false);
    return KidsDuaLearningState(
      progressByLessonId: progressByLessonId,
      unlockedRewardIds: unlocked,
      stickerUnlockedAtById: unlockedStickers,
      completedStoryIds: completedStories,
      storyProgressById: storyProgressById,
      recentStoryIds: ((json['recentStoryIds'] as List?) ?? const [])
          .map((item) => item.toString())
          .toList(growable: false),
      recentLessonIds: recent,
      totalFeatureXpAwarded:
          (json['totalFeatureXpAwarded'] as num?)?.toInt() ?? 0,
      totalFeatureDropsAwarded:
          (json['totalFeatureDropsAwarded'] as num?)?.toInt() ?? 0,
      totalPracticeSessions:
          (json['totalPracticeSessions'] as num?)?.toInt() ?? 0,
      currentStreakDays: (json['currentStreakDays'] as num?)?.toInt() ?? 0,
      longestStreakDays: (json['longestStreakDays'] as num?)?.toInt() ?? 0,
      lastActiveDate: json['lastActiveDate']?.toString(),
      todayCompleted: json['todayCompleted'] == true,
      lastGraceUsedDate: json['lastGraceUsedDate']?.toString(),
      activityLog: ((json['activityLog'] as List?) ?? const [])
          .whereType<Map>()
          .map(
            (item) => KidsDuaActivityLogEntry.fromJson(
              item.map((key, value) => MapEntry(key.toString(), value)),
            ),
          )
          .toList(growable: false),
    );
  }
}
