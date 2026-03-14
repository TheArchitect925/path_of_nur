import 'package:flutter/material.dart';

enum QuranTeachingLearnerLevel {
  completelyNew,
  knowSomeLetters,
  readSlowly,
  improveReading,
  openReference,
}

enum QuranTeachingAccessMode { guided, broad, open }

enum QuranTeachingModuleType {
  foundations,
  readingBasics,
  readingRules,
  tajweedBasics,
  recognizeWords,
  phraseReading,
  surahPractice,
}

enum QuranTeachingLessonKind { standard, words, surah }

enum QuranTeachingStepType {
  letterIntroduction,
  letterShapes,
  harakat,
  wordFormation,
  rule,
  phrase,
}

enum QuranTeachingQuizType {
  audioSelectLetter,
  audioSelectHarakahForm,
  promptSelectCorrectForm,
  identifyLetter,
  matchLetterToPicture,
  matchPictureToLetter,
  wordAudio,
  ruleIdentification,
  tapInOrderBuildWord,
  trueFalse,
}

enum QuranTeachingTextVisibility { arabicOnly, arabicWithTransliteration, hidden }

enum QuranTeachingAudioPackCategory {
  alphabet,
  harakat,
  firstWords,
  commonWords,
  phrases,
  surahLines,
}

enum QuranTeachingMistakeState { newMistake, dueReview, improving, mastered }

class QuranAudioCue {
  const QuranAudioCue({
    required this.id,
    required this.label,
    this.assetPath,
    this.remoteUrl,
    this.alternateAudioAssetPaths = const <String>[],
    this.fallbackTextLabel,
    this.isAssetOptional = true,
    this.voicePackId,
    this.playbackVariant,
    this.reciterId,
    this.durationMs,
  });

  final String id;
  final String label;
  final String? assetPath;
  final String? remoteUrl;
  final List<String> alternateAudioAssetPaths;
  final String? fallbackTextLabel;
  final bool isAssetOptional;
  final String? voicePackId;
  final String? playbackVariant;
  final String? reciterId;
  final int? durationMs;
}

class QuranVisualAnchor {
  const QuranVisualAnchor({
    required this.label,
    required this.hint,
    required this.icon,
    this.imageAssetPath,
    this.isAssetOptional = true,
  });

  final String label;
  final String hint;
  final IconData icon;
  final String? imageAssetPath;
  final bool isAssetOptional;
}

class QuranTeachingExample {
  const QuranTeachingExample({
    required this.arabic,
    this.transliteration,
    this.meaning,
    this.note,
    this.audio,
    this.visualAnchor,
    this.verseReference,
    this.frequencyLabel,
    this.imageAssetPath,
  });

  final String arabic;
  final String? transliteration;
  final String? meaning;
  final String? note;
  final QuranAudioCue? audio;
  final QuranVisualAnchor? visualAnchor;
  final String? verseReference;
  final String? frequencyLabel;
  final String? imageAssetPath;
}

class QuranTeachingStep {
  const QuranTeachingStep({
    required this.id,
    required this.title,
    required this.type,
    required this.focusArabic,
    required this.explanation,
    this.transliteration,
    this.helperText,
    this.audio,
    this.visualAnchor,
    this.sourceReference,
    this.examples = const <QuranTeachingExample>[],
  });

  final String id;
  final String title;
  final QuranTeachingStepType type;
  final String focusArabic;
  final String explanation;
  final String? transliteration;
  final String? helperText;
  final QuranAudioCue? audio;
  final QuranVisualAnchor? visualAnchor;
  final String? sourceReference;
  final List<QuranTeachingExample> examples;
}

class QuranTeachingQuizOption {
  const QuranTeachingQuizOption({
    required this.id,
    required this.label,
    this.secondaryLabel,
    this.arabic,
    this.icon,
    this.audio,
    this.imageAssetPath,
  });

  final String id;
  final String label;
  final String? secondaryLabel;
  final String? arabic;
  final IconData? icon;
  final QuranAudioCue? audio;
  final String? imageAssetPath;
}

class QuranTeachingQuizItem {
  const QuranTeachingQuizItem({
    required this.id,
    required this.type,
    required this.prompt,
    required this.feedbackCorrect,
    required this.feedbackIncorrect,
    this.promptArabic,
    this.promptSecondary,
    this.audio,
    this.promptImageAssetPath,
    this.options = const <QuranTeachingQuizOption>[],
    this.correctOptionIds = const <String>[],
    this.buildOrder = const <String>[],
    this.truthAnswer = true,
  });

  final String id;
  final QuranTeachingQuizType type;
  final String prompt;
  final String? promptArabic;
  final String? promptSecondary;
  final QuranAudioCue? audio;
  final String? promptImageAssetPath;
  final List<QuranTeachingQuizOption> options;
  final List<String> correctOptionIds;
  final List<String> buildOrder;
  final bool truthAnswer;
  final String feedbackCorrect;
  final String feedbackIncorrect;
}

class QuranTeachingLesson {
  const QuranTeachingLesson({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.subtitle,
    required this.summary,
    required this.kind,
    required this.order,
    required this.estimatedSeconds,
    required this.searchTerms,
    this.tags = const <String>[],
    this.steps = const <QuranTeachingStep>[],
    this.quizzes = const <QuranTeachingQuizItem>[],
  });

  final String id;
  final String moduleId;
  final String title;
  final String subtitle;
  final String summary;
  final QuranTeachingLessonKind kind;
  final int order;
  final int estimatedSeconds;
  final List<String> searchTerms;
  final List<String> tags;
  final List<QuranTeachingStep> steps;
  final List<QuranTeachingQuizItem> quizzes;
}

class QuranWordEntry {
  const QuranWordEntry({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
    required this.frequencyLabel,
    this.audio,
    this.exampleSnippet,
    this.exampleReference,
    this.commonSurahs = const <String>[],
    this.imageAssetPath,
    this.categoryTag,
  });

  final String id;
  final String arabic;
  final String transliteration;
  final String meaning;
  final String frequencyLabel;
  final QuranAudioCue? audio;
  final String? exampleSnippet;
  final String? exampleReference;
  final List<String> commonSurahs;
  final String? imageAssetPath;
  final String? categoryTag;
}

class QuranWordGroup {
  const QuranWordGroup({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.words,
  });

  final String id;
  final String title;
  final String subtitle;
  final List<QuranWordEntry> words;
}

class QuranSurahPracticeEntry {
  const QuranSurahPracticeEntry({
    required this.id,
    required this.surahNumber,
    required this.title,
    required this.arabicTitle,
    required this.transliteration,
    required this.subtitle,
    required this.verseCount,
    required this.focus,
    this.ayahPreview = const <String>[],
  });

  final String id;
  final int surahNumber;
  final String title;
  final String arabicTitle;
  final String transliteration;
  final String subtitle;
  final int verseCount;
  final String focus;
  final List<String> ayahPreview;
}

class QuranTeachingModule {
  const QuranTeachingModule({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.type,
    required this.order,
    required this.icon,
    required this.color,
    this.lessonIds = const <String>[],
    this.wordGroups = const <QuranWordGroup>[],
    this.surahPractice = const <QuranSurahPracticeEntry>[],
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final QuranTeachingModuleType type;
  final int order;
  final IconData icon;
  final Color color;
  final List<String> lessonIds;
  final List<QuranWordGroup> wordGroups;
  final List<QuranSurahPracticeEntry> surahPractice;
}

class QuranTeachingAudioPracticeItem {
  const QuranTeachingAudioPracticeItem({
    required this.id,
    required this.audio,
    this.arabic,
    this.transliteration,
    this.meaning,
    this.visualAnchor,
    this.imageAssetPath,
    this.tags = const <String>[],
    this.difficulty,
    this.sourceLessonId,
    this.sourceModuleId,
  });

  final String id;
  final QuranAudioCue audio;
  final String? arabic;
  final String? transliteration;
  final String? meaning;
  final QuranVisualAnchor? visualAnchor;
  final String? imageAssetPath;
  final List<String> tags;
  final String? difficulty;
  final String? sourceLessonId;
  final String? sourceModuleId;
}

class QuranTeachingAudioPracticePack {
  const QuranTeachingAudioPracticePack({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.moduleId,
    required this.items,
  });

  final String id;
  final String title;
  final String description;
  final QuranTeachingAudioPackCategory category;
  final String moduleId;
  final List<QuranTeachingAudioPracticeItem> items;
}

class QuranTeachingCatalog {
  const QuranTeachingCatalog({
    required this.modules,
    required this.lessons,
    this.audioPracticePacks = const <QuranTeachingAudioPracticePack>[],
  });

  final List<QuranTeachingModule> modules;
  final List<QuranTeachingLesson> lessons;
  final List<QuranTeachingAudioPracticePack> audioPracticePacks;

  QuranTeachingLesson? lessonById(String id) {
    for (final lesson in lessons) {
      if (lesson.id == id) return lesson;
    }
    return null;
  }

  QuranTeachingModule? moduleById(String id) {
    for (final module in modules) {
      if (module.id == id) return module;
    }
    return null;
  }

  QuranTeachingAudioPracticePack? audioPackById(String id) {
    for (final pack in audioPracticePacks) {
      if (pack.id == id) return pack;
    }
    return null;
  }

  List<QuranTeachingLesson> lessonsForModule(String moduleId) {
    return lessons
        .where((lesson) => lesson.moduleId == moduleId)
        .toList(growable: true)
      ..sort((a, b) => a.order.compareTo(b.order));
  }
}

class QuranTeachingProgressState {
  const QuranTeachingProgressState({
    this.learnerLevel,
    this.visualModeEnabled = false,
    this.completedLessonIds = const <String>[],
    this.startedLessonIds = const <String>[],
    this.reviewLaterLessonIds = const <String>[],
    this.recentLessonIds = const <String>[],
    this.quizBestScores = const <String, double>{},
    this.lastLessonId,
    this.lastPracticedAt,
  });

  final QuranTeachingLearnerLevel? learnerLevel;
  final bool visualModeEnabled;
  final List<String> completedLessonIds;
  final List<String> startedLessonIds;
  final List<String> reviewLaterLessonIds;
  final List<String> recentLessonIds;
  final Map<String, double> quizBestScores;
  final String? lastLessonId;
  final DateTime? lastPracticedAt;

  QuranTeachingAccessMode get accessMode {
    switch (learnerLevel) {
      case QuranTeachingLearnerLevel.completelyNew:
        return QuranTeachingAccessMode.guided;
      case QuranTeachingLearnerLevel.knowSomeLetters:
      case QuranTeachingLearnerLevel.readSlowly:
      case QuranTeachingLearnerLevel.improveReading:
        return QuranTeachingAccessMode.broad;
      case QuranTeachingLearnerLevel.openReference:
        return QuranTeachingAccessMode.open;
      case null:
        return QuranTeachingAccessMode.guided;
    }
  }

  QuranTeachingProgressState copyWith({
    QuranTeachingLearnerLevel? learnerLevel,
    bool? visualModeEnabled,
    List<String>? completedLessonIds,
    List<String>? startedLessonIds,
    List<String>? reviewLaterLessonIds,
    List<String>? recentLessonIds,
    Map<String, double>? quizBestScores,
    String? lastLessonId,
    DateTime? lastPracticedAt,
    bool clearLastLesson = false,
  }) {
    return QuranTeachingProgressState(
      learnerLevel: learnerLevel ?? this.learnerLevel,
      visualModeEnabled: visualModeEnabled ?? this.visualModeEnabled,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      startedLessonIds: startedLessonIds ?? this.startedLessonIds,
      reviewLaterLessonIds:
          reviewLaterLessonIds ?? this.reviewLaterLessonIds,
      recentLessonIds: recentLessonIds ?? this.recentLessonIds,
      quizBestScores: quizBestScores ?? this.quizBestScores,
      lastLessonId: clearLastLesson ? null : lastLessonId ?? this.lastLessonId,
      lastPracticedAt: lastPracticedAt ?? this.lastPracticedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'learnerLevel': learnerLevel?.name,
    'visualModeEnabled': visualModeEnabled,
    'completedLessonIds': completedLessonIds,
    'startedLessonIds': startedLessonIds,
    'reviewLaterLessonIds': reviewLaterLessonIds,
    'recentLessonIds': recentLessonIds,
    'quizBestScores': quizBestScores,
    'lastLessonId': lastLessonId,
    'lastPracticedAt': lastPracticedAt?.toIso8601String(),
  };

  static QuranTeachingProgressState fromJson(Map<String, dynamic>? json) {
    if (json == null) return const QuranTeachingProgressState();

    QuranTeachingLearnerLevel? learnerLevel;
    final learnerLevelRaw = json['learnerLevel']?.toString();
    for (final value in QuranTeachingLearnerLevel.values) {
      if (value.name == learnerLevelRaw) {
        learnerLevel = value;
        break;
      }
    }

    final quizBestScores = <String, double>{};
    final rawScores = json['quizBestScores'];
    if (rawScores is Map) {
      for (final entry in rawScores.entries) {
        final parsed = double.tryParse(entry.value.toString());
        if (parsed != null) {
          quizBestScores[entry.key.toString()] = parsed;
        }
      }
    }

    List<String> readStringList(String key) {
      final raw = json[key];
      if (raw is! List) return const <String>[];
      return raw.map((item) => item.toString()).toList(growable: false);
    }

    return QuranTeachingProgressState(
      learnerLevel: learnerLevel,
      visualModeEnabled: json['visualModeEnabled'] == true,
      completedLessonIds: readStringList('completedLessonIds'),
      startedLessonIds: readStringList('startedLessonIds'),
      reviewLaterLessonIds: readStringList('reviewLaterLessonIds'),
      recentLessonIds: readStringList('recentLessonIds'),
      quizBestScores: quizBestScores,
      lastLessonId: json['lastLessonId']?.toString(),
      lastPracticedAt: DateTime.tryParse(
        json['lastPracticedAt']?.toString() ?? '',
      ),
    );
  }
}

class QuranTeachingListenOnlyState {
  const QuranTeachingListenOnlyState({
    this.selectedPackId,
    this.currentIndex = 0,
    this.isPlaying = false,
    this.autoAdvance = true,
    this.repeatCurrent = false,
    this.shuffle = false,
    this.visualModeEnabled = false,
    this.textVisibility = QuranTeachingTextVisibility.arabicWithTransliteration,
    this.playbackSpeed = 1.0,
    this.lastPlayedAt,
  });

  final String? selectedPackId;
  final int currentIndex;
  final bool isPlaying;
  final bool autoAdvance;
  final bool repeatCurrent;
  final bool shuffle;
  final bool visualModeEnabled;
  final QuranTeachingTextVisibility textVisibility;
  final double playbackSpeed;
  final DateTime? lastPlayedAt;

  QuranTeachingListenOnlyState copyWith({
    String? selectedPackId,
    int? currentIndex,
    bool? isPlaying,
    bool? autoAdvance,
    bool? repeatCurrent,
    bool? shuffle,
    bool? visualModeEnabled,
    QuranTeachingTextVisibility? textVisibility,
    double? playbackSpeed,
    DateTime? lastPlayedAt,
    bool clearPack = false,
  }) {
    return QuranTeachingListenOnlyState(
      selectedPackId: clearPack ? null : selectedPackId ?? this.selectedPackId,
      currentIndex: currentIndex ?? this.currentIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      autoAdvance: autoAdvance ?? this.autoAdvance,
      repeatCurrent: repeatCurrent ?? this.repeatCurrent,
      shuffle: shuffle ?? this.shuffle,
      visualModeEnabled: visualModeEnabled ?? this.visualModeEnabled,
      textVisibility: textVisibility ?? this.textVisibility,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'selectedPackId': selectedPackId,
    'currentIndex': currentIndex,
    'isPlaying': isPlaying,
    'autoAdvance': autoAdvance,
    'repeatCurrent': repeatCurrent,
    'shuffle': shuffle,
    'visualModeEnabled': visualModeEnabled,
    'textVisibility': textVisibility.name,
    'playbackSpeed': playbackSpeed,
    'lastPlayedAt': lastPlayedAt?.toIso8601String(),
  };

  static QuranTeachingListenOnlyState fromJson(Map<String, dynamic>? json) {
    if (json == null) return const QuranTeachingListenOnlyState();
    var textVisibility = QuranTeachingTextVisibility.arabicWithTransliteration;
    final visibilityRaw = json['textVisibility']?.toString();
    for (final value in QuranTeachingTextVisibility.values) {
      if (value.name == visibilityRaw) {
        textVisibility = value;
        break;
      }
    }
    return QuranTeachingListenOnlyState(
      selectedPackId: json['selectedPackId']?.toString(),
      currentIndex: int.tryParse(json['currentIndex']?.toString() ?? '') ?? 0,
      isPlaying: json['isPlaying'] == true,
      autoAdvance: json['autoAdvance'] != false,
      repeatCurrent: json['repeatCurrent'] == true,
      shuffle: json['shuffle'] == true,
      visualModeEnabled: json['visualModeEnabled'] == true,
      textVisibility: textVisibility,
      playbackSpeed:
          double.tryParse(json['playbackSpeed']?.toString() ?? '') ?? 1.0,
      lastPlayedAt: DateTime.tryParse(json['lastPlayedAt']?.toString() ?? ''),
    );
  }
}

class QuranTeachingMistakeItem {
  const QuranTeachingMistakeItem({
    required this.quizId,
    required this.lessonId,
    required this.moduleId,
    required this.quizType,
    required this.prompt,
    required this.feedbackCorrect,
    required this.feedbackIncorrect,
    required this.correctOptionIds,
    required this.lastWrongAt,
    this.promptArabic,
    this.promptSecondary,
    this.audio,
    this.promptImageAssetPath,
    this.options = const <QuranTeachingQuizOption>[],
    this.buildOrder = const <String>[],
    this.truthAnswer = true,
    this.lastSelectedOptionId,
    this.lastSelectedTokens = const <String>[],
    this.totalWrongCount = 1,
    this.totalReviewCount = 0,
    this.successStreak = 0,
    this.state = QuranTeachingMistakeState.newMistake,
    this.nextDueAt,
  });

  final String quizId;
  final String lessonId;
  final String moduleId;
  final QuranTeachingQuizType quizType;
  final String prompt;
  final String? promptArabic;
  final String? promptSecondary;
  final QuranAudioCue? audio;
  final String? promptImageAssetPath;
  final List<QuranTeachingQuizOption> options;
  final List<String> correctOptionIds;
  final List<String> buildOrder;
  final bool truthAnswer;
  final String feedbackCorrect;
  final String feedbackIncorrect;
  final String? lastSelectedOptionId;
  final List<String> lastSelectedTokens;
  final DateTime lastWrongAt;
  final int totalWrongCount;
  final int totalReviewCount;
  final int successStreak;
  final QuranTeachingMistakeState state;
  final DateTime? nextDueAt;

  double get priorityScore {
    final due = nextDueAt == null || !nextDueAt!.isAfter(DateTime.now()) ? 1.0 : 0.0;
    return totalWrongCount * 1.6 + (3 - successStreak) + due + (totalReviewCount == 0 ? 1 : 0);
  }

  QuranTeachingMistakeItem copyWith({
    String? lastSelectedOptionId,
    List<String>? lastSelectedTokens,
    DateTime? lastWrongAt,
    int? totalWrongCount,
    int? totalReviewCount,
    int? successStreak,
    QuranTeachingMistakeState? state,
    DateTime? nextDueAt,
  }) {
    return QuranTeachingMistakeItem(
      quizId: quizId,
      lessonId: lessonId,
      moduleId: moduleId,
      quizType: quizType,
      prompt: prompt,
      promptArabic: promptArabic,
      promptSecondary: promptSecondary,
      audio: audio,
      promptImageAssetPath: promptImageAssetPath,
      options: options,
      correctOptionIds: correctOptionIds,
      buildOrder: buildOrder,
      truthAnswer: truthAnswer,
      feedbackCorrect: feedbackCorrect,
      feedbackIncorrect: feedbackIncorrect,
      lastSelectedOptionId: lastSelectedOptionId ?? this.lastSelectedOptionId,
      lastSelectedTokens: lastSelectedTokens ?? this.lastSelectedTokens,
      lastWrongAt: lastWrongAt ?? this.lastWrongAt,
      totalWrongCount: totalWrongCount ?? this.totalWrongCount,
      totalReviewCount: totalReviewCount ?? this.totalReviewCount,
      successStreak: successStreak ?? this.successStreak,
      state: state ?? this.state,
      nextDueAt: nextDueAt ?? this.nextDueAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'quizId': quizId,
    'lessonId': lessonId,
    'moduleId': moduleId,
    'quizType': quizType.name,
    'prompt': prompt,
    'promptArabic': promptArabic,
    'promptSecondary': promptSecondary,
    'promptImageAssetPath': promptImageAssetPath,
    'audio': audio == null
        ? null
        : {
            'id': audio!.id,
            'label': audio!.label,
            'assetPath': audio!.assetPath,
            'remoteUrl': audio!.remoteUrl,
          },
    'options': options
        .map(
          (option) => {
            'id': option.id,
            'label': option.label,
            'secondaryLabel': option.secondaryLabel,
            'arabic': option.arabic,
            'imageAssetPath': option.imageAssetPath,
            'iconCodePoint': option.icon?.codePoint,
            'audio': option.audio == null
                ? null
                : {
                    'id': option.audio!.id,
                    'label': option.audio!.label,
                    'assetPath': option.audio!.assetPath,
                    'remoteUrl': option.audio!.remoteUrl,
                  },
          },
        )
        .toList(growable: false),
    'correctOptionIds': correctOptionIds,
    'buildOrder': buildOrder,
    'truthAnswer': truthAnswer,
    'feedbackCorrect': feedbackCorrect,
    'feedbackIncorrect': feedbackIncorrect,
    'lastSelectedOptionId': lastSelectedOptionId,
    'lastSelectedTokens': lastSelectedTokens,
    'lastWrongAt': lastWrongAt.toIso8601String(),
    'totalWrongCount': totalWrongCount,
    'totalReviewCount': totalReviewCount,
    'successStreak': successStreak,
    'state': state.name,
    'nextDueAt': nextDueAt?.toIso8601String(),
  };

  static QuranTeachingMistakeItem? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final quizId = json['quizId']?.toString();
    final lessonId = json['lessonId']?.toString();
    final moduleId = json['moduleId']?.toString();
    final prompt = json['prompt']?.toString();
    final wrongAtRaw = json['lastWrongAt']?.toString();
    if (quizId == null ||
        lessonId == null ||
        moduleId == null ||
        prompt == null ||
        wrongAtRaw == null) {
      return null;
    }
    final lastWrongAt = DateTime.tryParse(wrongAtRaw);
    if (lastWrongAt == null) return null;

    var quizType = QuranTeachingQuizType.identifyLetter;
    final quizTypeRaw = json['quizType']?.toString();
    for (final value in QuranTeachingQuizType.values) {
      if (value.name == quizTypeRaw) {
        quizType = value;
        break;
      }
    }

    var state = QuranTeachingMistakeState.newMistake;
    final stateRaw = json['state']?.toString();
    for (final value in QuranTeachingMistakeState.values) {
      if (value.name == stateRaw) {
        state = value;
        break;
      }
    }

    QuranAudioCue? parseAudio(dynamic raw) {
      if (raw is! Map) return null;
      final id = raw['id']?.toString();
      final label = raw['label']?.toString();
      if (id == null || label == null) return null;
      return QuranAudioCue(
        id: id,
        label: label,
        assetPath: raw['assetPath']?.toString(),
        remoteUrl: raw['remoteUrl']?.toString(),
      );
    }

    final options = <QuranTeachingQuizOption>[];
    final rawOptions = json['options'];
    if (rawOptions is List) {
      for (final item in rawOptions) {
        if (item is! Map) continue;
        final id = item['id']?.toString();
        final label = item['label']?.toString();
        if (id == null || label == null) continue;
        final codePoint =
            int.tryParse(item['iconCodePoint']?.toString() ?? '');
        options.add(
          QuranTeachingQuizOption(
            id: id,
            label: label,
            secondaryLabel: item['secondaryLabel']?.toString(),
            arabic: item['arabic']?.toString(),
            imageAssetPath: item['imageAssetPath']?.toString(),
            icon: codePoint == null ? null : IconData(codePoint, fontFamily: 'MaterialIcons'),
            audio: parseAudio(item['audio']),
          ),
        );
      }
    }

    List<String> stringList(String key) {
      final raw = json[key];
      if (raw is! List) return const <String>[];
      return raw.map((item) => item.toString()).toList(growable: false);
    }

    return QuranTeachingMistakeItem(
      quizId: quizId,
      lessonId: lessonId,
      moduleId: moduleId,
      quizType: quizType,
      prompt: prompt,
      promptArabic: json['promptArabic']?.toString(),
      promptSecondary: json['promptSecondary']?.toString(),
      audio: parseAudio(json['audio']),
      promptImageAssetPath: json['promptImageAssetPath']?.toString(),
      options: options,
      correctOptionIds: stringList('correctOptionIds'),
      buildOrder: stringList('buildOrder'),
      truthAnswer: json['truthAnswer'] != false,
      feedbackCorrect: json['feedbackCorrect']?.toString() ?? 'Correct.',
      feedbackIncorrect:
          json['feedbackIncorrect']?.toString() ?? 'Try this one again.',
      lastSelectedOptionId: json['lastSelectedOptionId']?.toString(),
      lastSelectedTokens: stringList('lastSelectedTokens'),
      lastWrongAt: lastWrongAt,
      totalWrongCount:
          int.tryParse(json['totalWrongCount']?.toString() ?? '') ?? 1,
      totalReviewCount:
          int.tryParse(json['totalReviewCount']?.toString() ?? '') ?? 0,
      successStreak:
          int.tryParse(json['successStreak']?.toString() ?? '') ?? 0,
      state: state,
      nextDueAt: DateTime.tryParse(json['nextDueAt']?.toString() ?? ''),
    );
  }
}
