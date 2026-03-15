import 'quran_teaching_icon_registry.dart';
import 'quran_teaching_models.dart';

enum QuranTeachingReviewContentType {
  letter,
  letterForm,
  harakahSound,
  longVowel,
  shortWord,
  quranWord,
  phrase,
  rule,
  visualModeItem,
  quizItem,
  mistakeReviewItem,
}

enum QuranTeachingMemoryState {
  newItem,
  practicing,
  familiar,
  recognized,
  mastered,
}

enum QuranTeachingReviewSource {
  lesson,
  dailyReview,
  mistakeReview,
  extraPractice,
}

class QuranTeachingReviewRecord {
  const QuranTeachingReviewRecord({
    required this.id,
    required this.lessonId,
    required this.moduleId,
    required this.contentType,
    required this.prompt,
    required this.tags,
    required this.memoryState,
    required this.nextDueAt,
    this.promptArabic,
    this.promptSecondary,
    this.transliteration,
    this.meaning,
    this.hintText,
    this.audio,
    this.promptImageAssetPath,
    this.options = const <QuranTeachingQuizOption>[],
    this.correctOptionIds = const <String>[],
    this.buildOrder = const <String>[],
    this.truthAnswer = true,
    this.availableInVisualMode = false,
    this.lastReviewedAt,
    this.lastSessionDateKey,
    this.lastReviewSource,
    this.reviewCount = 0,
    this.successCount = 0,
    this.failureCount = 0,
    this.correctStreak = 0,
    this.priorityBoost = 0,
  });

  final String id;
  final String lessonId;
  final String moduleId;
  final QuranTeachingReviewContentType contentType;
  final String prompt;
  final String? promptArabic;
  final String? promptSecondary;
  final String? transliteration;
  final String? meaning;
  final String? hintText;
  final QuranAudioCue? audio;
  final String? promptImageAssetPath;
  final List<QuranTeachingQuizOption> options;
  final List<String> correctOptionIds;
  final List<String> buildOrder;
  final bool truthAnswer;
  final List<String> tags;
  final bool availableInVisualMode;
  final QuranTeachingMemoryState memoryState;
  final DateTime? lastReviewedAt;
  final DateTime nextDueAt;
  final String? lastSessionDateKey;
  final QuranTeachingReviewSource? lastReviewSource;
  final int reviewCount;
  final int successCount;
  final int failureCount;
  final int correctStreak;
  final int priorityBoost;

  bool get isDue => !nextDueAt.isAfter(DateTime.now());

  double get priorityScore {
    final dueWeight = isDue ? 2.0 : 0.0;
    return failureCount * 1.7 +
        priorityBoost +
        dueWeight +
        (reviewCount == 0 ? 1.0 : 0.0) +
        (4 - correctStreak.clamp(0, 4));
  }

  QuranTeachingReviewRecord copyWith({
    String? prompt,
    String? promptArabic,
    String? promptSecondary,
    String? transliteration,
    String? meaning,
    String? hintText,
    QuranAudioCue? audio,
    String? promptImageAssetPath,
    List<QuranTeachingQuizOption>? options,
    List<String>? correctOptionIds,
    List<String>? buildOrder,
    bool? truthAnswer,
    List<String>? tags,
    bool? availableInVisualMode,
    QuranTeachingMemoryState? memoryState,
    DateTime? lastReviewedAt,
    DateTime? nextDueAt,
    String? lastSessionDateKey,
    QuranTeachingReviewSource? lastReviewSource,
    int? reviewCount,
    int? successCount,
    int? failureCount,
    int? correctStreak,
    int? priorityBoost,
  }) {
    return QuranTeachingReviewRecord(
      id: id,
      lessonId: lessonId,
      moduleId: moduleId,
      contentType: contentType,
      prompt: prompt ?? this.prompt,
      promptArabic: promptArabic ?? this.promptArabic,
      promptSecondary: promptSecondary ?? this.promptSecondary,
      transliteration: transliteration ?? this.transliteration,
      meaning: meaning ?? this.meaning,
      hintText: hintText ?? this.hintText,
      audio: audio ?? this.audio,
      promptImageAssetPath: promptImageAssetPath ?? this.promptImageAssetPath,
      options: options ?? this.options,
      correctOptionIds: correctOptionIds ?? this.correctOptionIds,
      buildOrder: buildOrder ?? this.buildOrder,
      truthAnswer: truthAnswer ?? this.truthAnswer,
      tags: tags ?? this.tags,
      availableInVisualMode: availableInVisualMode ?? this.availableInVisualMode,
      memoryState: memoryState ?? this.memoryState,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      nextDueAt: nextDueAt ?? this.nextDueAt,
      lastSessionDateKey: lastSessionDateKey ?? this.lastSessionDateKey,
      lastReviewSource: lastReviewSource ?? this.lastReviewSource,
      reviewCount: reviewCount ?? this.reviewCount,
      successCount: successCount ?? this.successCount,
      failureCount: failureCount ?? this.failureCount,
      correctStreak: correctStreak ?? this.correctStreak,
      priorityBoost: priorityBoost ?? this.priorityBoost,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'lessonId': lessonId,
    'moduleId': moduleId,
    'contentType': contentType.name,
    'prompt': prompt,
    'promptArabic': promptArabic,
    'promptSecondary': promptSecondary,
    'transliteration': transliteration,
    'meaning': meaning,
    'hintText': hintText,
    'audio': _audioToJson(audio),
    'promptImageAssetPath': promptImageAssetPath,
    'options': options.map(_optionToJson).toList(growable: false),
    'correctOptionIds': correctOptionIds,
    'buildOrder': buildOrder,
    'truthAnswer': truthAnswer,
    'tags': tags,
    'availableInVisualMode': availableInVisualMode,
    'memoryState': memoryState.name,
    'lastReviewedAt': lastReviewedAt?.toIso8601String(),
    'nextDueAt': nextDueAt.toIso8601String(),
    'lastSessionDateKey': lastSessionDateKey,
    'lastReviewSource': lastReviewSource?.name,
    'reviewCount': reviewCount,
    'successCount': successCount,
    'failureCount': failureCount,
    'correctStreak': correctStreak,
    'priorityBoost': priorityBoost,
  };

  static QuranTeachingReviewRecord? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final id = json['id']?.toString();
    final lessonId = json['lessonId']?.toString();
    final moduleId = json['moduleId']?.toString();
    final prompt = json['prompt']?.toString();
    final nextDueAt = DateTime.tryParse(json['nextDueAt']?.toString() ?? '');
    if (id == null ||
        lessonId == null ||
        moduleId == null ||
        prompt == null ||
        nextDueAt == null) {
      return null;
    }

    var contentType = QuranTeachingReviewContentType.quizItem;
    final contentTypeRaw = json['contentType']?.toString();
    for (final value in QuranTeachingReviewContentType.values) {
      if (value.name == contentTypeRaw) {
        contentType = value;
        break;
      }
    }

    var memoryState = QuranTeachingMemoryState.newItem;
    final memoryRaw = json['memoryState']?.toString();
    for (final value in QuranTeachingMemoryState.values) {
      if (value.name == memoryRaw) {
        memoryState = value;
        break;
      }
    }

    QuranTeachingReviewSource? lastReviewSource;
    final sourceRaw = json['lastReviewSource']?.toString();
    for (final value in QuranTeachingReviewSource.values) {
      if (value.name == sourceRaw) {
        lastReviewSource = value;
        break;
      }
    }

    return QuranTeachingReviewRecord(
      id: id,
      lessonId: lessonId,
      moduleId: moduleId,
      contentType: contentType,
      prompt: prompt,
      promptArabic: json['promptArabic']?.toString(),
      promptSecondary: json['promptSecondary']?.toString(),
      transliteration: json['transliteration']?.toString(),
      meaning: json['meaning']?.toString(),
      hintText: json['hintText']?.toString(),
      audio: _audioFromJson(json['audio']),
      promptImageAssetPath: json['promptImageAssetPath']?.toString(),
      options: _readOptions(json['options']),
      correctOptionIds: _readStringList(json['correctOptionIds']),
      buildOrder: _readStringList(json['buildOrder']),
      truthAnswer: json['truthAnswer'] != false,
      tags: _readStringList(json['tags']),
      availableInVisualMode: json['availableInVisualMode'] == true,
      memoryState: memoryState,
      lastReviewedAt: DateTime.tryParse(
        json['lastReviewedAt']?.toString() ?? '',
      ),
      nextDueAt: nextDueAt,
      lastSessionDateKey: json['lastSessionDateKey']?.toString(),
      lastReviewSource: lastReviewSource,
      reviewCount: int.tryParse(json['reviewCount']?.toString() ?? '') ?? 0,
      successCount: int.tryParse(json['successCount']?.toString() ?? '') ?? 0,
      failureCount:
          int.tryParse(json['failureCount']?.toString() ?? '') ?? 0,
      correctStreak:
          int.tryParse(json['correctStreak']?.toString() ?? '') ?? 0,
      priorityBoost:
          int.tryParse(json['priorityBoost']?.toString() ?? '') ?? 0,
    );
  }
}

class QuranTeachingWeakArea {
  const QuranTeachingWeakArea({
    required this.tag,
    required this.failureCount,
    required this.successCount,
    required this.reviewCount,
    this.lastSeenAt,
  });

  final String tag;
  final int failureCount;
  final int successCount;
  final int reviewCount;
  final DateTime? lastSeenAt;

  double get priorityScore {
    return failureCount * 1.8 +
        (failureCount - successCount).clamp(0, failureCount) * 0.9 +
        (reviewCount == 0 ? 1 : 0);
  }

  QuranTeachingWeakArea copyWith({
    int? failureCount,
    int? successCount,
    int? reviewCount,
    DateTime? lastSeenAt,
  }) {
    return QuranTeachingWeakArea(
      tag: tag,
      failureCount: failureCount ?? this.failureCount,
      successCount: successCount ?? this.successCount,
      reviewCount: reviewCount ?? this.reviewCount,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'tag': tag,
    'failureCount': failureCount,
    'successCount': successCount,
    'reviewCount': reviewCount,
    'lastSeenAt': lastSeenAt?.toIso8601String(),
  };

  static QuranTeachingWeakArea? fromJson(Map<String, dynamic>? json) {
    final tag = json?['tag']?.toString();
    if (tag == null) return null;
    return QuranTeachingWeakArea(
      tag: tag,
      failureCount: int.tryParse(json?['failureCount']?.toString() ?? '') ?? 0,
      successCount: int.tryParse(json?['successCount']?.toString() ?? '') ?? 0,
      reviewCount: int.tryParse(json?['reviewCount']?.toString() ?? '') ?? 0,
      lastSeenAt: DateTime.tryParse(json?['lastSeenAt']?.toString() ?? ''),
    );
  }
}

class QuranTeachingDailyReviewSession {
  const QuranTeachingDailyReviewSession({
    required this.dateKey,
    required this.itemRefs,
    required this.estimatedMinutes,
    required this.mixSummary,
    this.completedItemRefs = const <String>[],
    this.correctCount = 0,
    this.needsMoreCount = 0,
    this.startedAt,
    this.completedAt,
  });

  final String dateKey;
  final List<String> itemRefs;
  final int estimatedMinutes;
  final String mixSummary;
  final List<String> completedItemRefs;
  final int correctCount;
  final int needsMoreCount;
  final DateTime? startedAt;
  final DateTime? completedAt;

  bool get isComplete =>
      itemRefs.isNotEmpty && completedItemRefs.length >= itemRefs.length;

  QuranTeachingDailyReviewSession copyWith({
    List<String>? itemRefs,
    int? estimatedMinutes,
    String? mixSummary,
    List<String>? completedItemRefs,
    int? correctCount,
    int? needsMoreCount,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return QuranTeachingDailyReviewSession(
      dateKey: dateKey,
      itemRefs: itemRefs ?? this.itemRefs,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      mixSummary: mixSummary ?? this.mixSummary,
      completedItemRefs: completedItemRefs ?? this.completedItemRefs,
      correctCount: correctCount ?? this.correctCount,
      needsMoreCount: needsMoreCount ?? this.needsMoreCount,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'dateKey': dateKey,
    'itemRefs': itemRefs,
    'estimatedMinutes': estimatedMinutes,
    'mixSummary': mixSummary,
    'completedItemRefs': completedItemRefs,
    'correctCount': correctCount,
    'needsMoreCount': needsMoreCount,
    'startedAt': startedAt?.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
  };

  static QuranTeachingDailyReviewSession? fromJson(Map<String, dynamic>? json) {
    final dateKey = json?['dateKey']?.toString();
    if (dateKey == null) return null;
    return QuranTeachingDailyReviewSession(
      dateKey: dateKey,
      itemRefs: _readStringList(json?['itemRefs']),
      estimatedMinutes:
          int.tryParse(json?['estimatedMinutes']?.toString() ?? '') ?? 0,
      mixSummary: json?['mixSummary']?.toString() ?? '',
      completedItemRefs: _readStringList(json?['completedItemRefs']),
      correctCount: int.tryParse(json?['correctCount']?.toString() ?? '') ?? 0,
      needsMoreCount:
          int.tryParse(json?['needsMoreCount']?.toString() ?? '') ?? 0,
      startedAt: DateTime.tryParse(json?['startedAt']?.toString() ?? ''),
      completedAt: DateTime.tryParse(json?['completedAt']?.toString() ?? ''),
    );
  }
}

class QuranTeachingCompletedReviewSession {
  const QuranTeachingCompletedReviewSession({
    required this.dateKey,
    required this.itemCount,
    required this.correctCount,
    required this.needsMoreCount,
    required this.completedAt,
  });

  final String dateKey;
  final int itemCount;
  final int correctCount;
  final int needsMoreCount;
  final DateTime completedAt;

  Map<String, dynamic> toJson() => {
    'dateKey': dateKey,
    'itemCount': itemCount,
    'correctCount': correctCount,
    'needsMoreCount': needsMoreCount,
    'completedAt': completedAt.toIso8601String(),
  };

  static QuranTeachingCompletedReviewSession? fromJson(
    Map<String, dynamic>? json,
  ) {
    final dateKey = json?['dateKey']?.toString();
    final completedAt =
        DateTime.tryParse(json?['completedAt']?.toString() ?? '');
    if (dateKey == null || completedAt == null) return null;
    return QuranTeachingCompletedReviewSession(
      dateKey: dateKey,
      itemCount: int.tryParse(json?['itemCount']?.toString() ?? '') ?? 0,
      correctCount: int.tryParse(json?['correctCount']?.toString() ?? '') ?? 0,
      needsMoreCount:
          int.tryParse(json?['needsMoreCount']?.toString() ?? '') ?? 0,
      completedAt: completedAt,
    );
  }
}

class QuranTeachingSmartReviewState {
  const QuranTeachingSmartReviewState({
    this.records = const <String, QuranTeachingReviewRecord>{},
    this.weakAreas = const <String, QuranTeachingWeakArea>{},
    this.todaySession,
    this.completedSessions = const <QuranTeachingCompletedReviewSession>[],
  });

  final Map<String, QuranTeachingReviewRecord> records;
  final Map<String, QuranTeachingWeakArea> weakAreas;
  final QuranTeachingDailyReviewSession? todaySession;
  final List<QuranTeachingCompletedReviewSession> completedSessions;

  QuranTeachingSmartReviewState copyWith({
    Map<String, QuranTeachingReviewRecord>? records,
    Map<String, QuranTeachingWeakArea>? weakAreas,
    QuranTeachingDailyReviewSession? todaySession,
    List<QuranTeachingCompletedReviewSession>? completedSessions,
    bool clearSession = false,
  }) {
    return QuranTeachingSmartReviewState(
      records: records ?? this.records,
      weakAreas: weakAreas ?? this.weakAreas,
      todaySession: clearSession ? null : todaySession ?? this.todaySession,
      completedSessions: completedSessions ?? this.completedSessions,
    );
  }

  Map<String, dynamic> toJson() => {
    'records': records.map((key, value) => MapEntry(key, value.toJson())),
    'weakAreas':
        weakAreas.map((key, value) => MapEntry(key, value.toJson())),
    'todaySession': todaySession?.toJson(),
    'completedSessions':
        completedSessions.map((item) => item.toJson()).toList(growable: false),
  };

  static QuranTeachingSmartReviewState fromJson(Map<String, dynamic>? json) {
    if (json == null) return const QuranTeachingSmartReviewState();

    final records = <String, QuranTeachingReviewRecord>{};
    final weakAreas = <String, QuranTeachingWeakArea>{};

    final rawRecords = json['records'];
    if (rawRecords is Map) {
      for (final entry in rawRecords.entries) {
        final parsed = QuranTeachingReviewRecord.fromJson(
          entry.value as Map<String, dynamic>?,
        );
        if (parsed != null) {
          records[entry.key.toString()] = parsed;
        }
      }
    }

    final rawWeakAreas = json['weakAreas'];
    if (rawWeakAreas is Map) {
      for (final entry in rawWeakAreas.entries) {
        final parsed = QuranTeachingWeakArea.fromJson(
          entry.value as Map<String, dynamic>?,
        );
        if (parsed != null) {
          weakAreas[entry.key.toString()] = parsed;
        }
      }
    }

    final completedSessions = <QuranTeachingCompletedReviewSession>[];
    final rawCompleted = json['completedSessions'];
    if (rawCompleted is List) {
      for (final item in rawCompleted) {
        final parsed = QuranTeachingCompletedReviewSession.fromJson(
          item as Map<String, dynamic>?,
        );
        if (parsed != null) {
          completedSessions.add(parsed);
        }
      }
    }

    return QuranTeachingSmartReviewState(
      records: records,
      weakAreas: weakAreas,
      todaySession: QuranTeachingDailyReviewSession.fromJson(
        json['todaySession'] as Map<String, dynamic>?,
      ),
      completedSessions: completedSessions,
    );
  }
}

Map<String, dynamic>? _audioToJson(QuranAudioCue? audio) {
  if (audio == null) return null;
  return {
    'id': audio.id,
    'label': audio.label,
    'assetPath': audio.assetPath,
    'remoteUrl': audio.remoteUrl,
    'alternateAudioAssetPaths': audio.alternateAudioAssetPaths,
    'fallbackTextLabel': audio.fallbackTextLabel,
    'isAssetOptional': audio.isAssetOptional,
    'voicePackId': audio.voicePackId,
    'playbackVariant': audio.playbackVariant,
    'reciterId': audio.reciterId,
    'durationMs': audio.durationMs,
  };
}

QuranAudioCue? _audioFromJson(dynamic raw) {
  if (raw is! Map) return null;
  final id = raw['id']?.toString();
  final label = raw['label']?.toString();
  if (id == null || label == null) return null;
  return QuranAudioCue(
    id: id,
    label: label,
    assetPath: raw['assetPath']?.toString(),
    remoteUrl: raw['remoteUrl']?.toString(),
    alternateAudioAssetPaths: _readStringList(raw['alternateAudioAssetPaths']),
    fallbackTextLabel: raw['fallbackTextLabel']?.toString(),
    isAssetOptional: raw['isAssetOptional'] != false,
    voicePackId: raw['voicePackId']?.toString(),
    playbackVariant: raw['playbackVariant']?.toString(),
    reciterId: raw['reciterId']?.toString(),
    durationMs: int.tryParse(raw['durationMs']?.toString() ?? ''),
  );
}

Map<String, dynamic> _optionToJson(QuranTeachingQuizOption option) => {
  'id': option.id,
  'label': option.label,
  'secondaryLabel': option.secondaryLabel,
  'arabic': option.arabic,
  ...QuranTeachingIconRegistry.iconToJson(option.icon),
  'audio': _audioToJson(option.audio),
  'imageAssetPath': option.imageAssetPath,
};

List<QuranTeachingQuizOption> _readOptions(dynamic raw) {
  if (raw is! List) return const <QuranTeachingQuizOption>[];
  final options = <QuranTeachingQuizOption>[];
  for (final item in raw) {
    if (item is! Map) continue;
    final id = item['id']?.toString();
    final label = item['label']?.toString();
    if (id == null || label == null) continue;
    options.add(
      QuranTeachingQuizOption(
        id: id,
        label: label,
        secondaryLabel: item['secondaryLabel']?.toString(),
        arabic: item['arabic']?.toString(),
        icon: QuranTeachingIconRegistry.iconFromJson(item),
        audio: _audioFromJson(item['audio']),
        imageAssetPath: item['imageAssetPath']?.toString(),
      ),
    );
  }
  return options;
}

List<String> _readStringList(dynamic raw) {
  if (raw is! List) return const <String>[];
  return raw.map((item) => item.toString()).toList(growable: false);
}
