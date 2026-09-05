import '../../../../core/prayer/prayer_preferences.dart';

enum SalahPrayerId { fajr, dhuhr, asr, maghrib, isha, witr, jummah }

enum SalahRecitationKind {
  reminder,
  takbir,
  openingSupplication,
  fatihah,
  additionalSurah,
  ruku,
  standingAfterRuku,
  sujud,
  sittingBetweenSujud,
  tashahhud,
  salawat,
  finalDua,
  taslim,
}

enum SalahSurahProgress { notStarted, learning, practiced, memorized }

enum GuidedSurahMode { random, fixed, practiceSpecific }

enum SurahLearningMode { listen, repeat, practice, memory }

enum PrayerPostureType {
  /// Standing with the hands raised for the takbir.
  takbir,
  qiyam,
  ruku,
  qawmah,
  sujud,
  jalsah,
  tashahhud,
  salamRight,
  salamLeft,
}

/// How long the guided flow rests in each posture after the recitation ends.
enum SalahTrainerPace { unhurried, steady, brisk }

extension SalahTrainerPaceX on SalahTrainerPace {
  double get holdMultiplier {
    switch (this) {
      case SalahTrainerPace.unhurried:
        return 1.8;
      case SalahTrainerPace.steady:
        return 1.0;
      case SalahTrainerPace.brisk:
        return 0.55;
    }
  }
}

/// Where the guided flow is inside the current step.
enum GuidedStepPhase { idle, entryTakbir, reciting, holding, completed }

/// What actually produced the sound for a recitation.
enum SalahAudioSourceKind { asset, tts, silent }

/// One recited unit: an ayah, a dhikr, or a dua. A step recites its segments
/// in order; a step with several segments is a surah played ayah by ayah.
class RecitationSegment {
  const RecitationSegment({
    required this.id,
    required this.arabicText,
    required this.transliteration,
    this.translation = '',
    this.audioAssetPath,
    this.surahNumber,
    this.ayahNumber,
  });

  final String id;
  final String arabicText;
  final String transliteration;
  final String translation;

  /// Bundled clip for this segment, if a recording ships. The audio service
  /// checks the asset manifest before trusting the path, so a slot can be
  /// declared before its file exists.
  final String? audioAssetPath;
  final int? surahNumber;
  final int? ayahNumber;

  bool get isAyah => surahNumber != null && ayahNumber != null;

  RecitationSegment copyWith({String? translation}) {
    return RecitationSegment(
      id: id,
      arabicText: arabicText,
      transliteration: transliteration,
      translation: translation ?? this.translation,
      audioAssetPath: audioAssetPath,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );
  }
}

class RecitationWordTimingModel {
  const RecitationWordTimingModel({
    required this.wordId,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.startMs,
    required this.endMs,
  });

  final String wordId;
  final String arabicText;
  final String transliteration;
  final String translation;
  final int startMs;
  final int endMs;
}

class RecitationTimingModel {
  const RecitationTimingModel({
    required this.totalDurationMs,
    required this.wordTimings,
  });

  static const RecitationTimingModel empty = RecitationTimingModel(
    totalDurationMs: 0,
    wordTimings: <RecitationWordTimingModel>[],
  );

  final int totalDurationMs;
  final List<RecitationWordTimingModel> wordTimings;

  bool get isEmpty => wordTimings.isEmpty;

  /// Splits on whitespace the way every highlighter in the trainer does, so a
  /// timing built here always has one entry per rendered word.
  static List<String> splitWords(String text) {
    return text
        .trim()
        .split(RegExp(r'\s+'))
        .where((item) => item.trim().isNotEmpty)
        .toList(growable: false);
  }

  /// A rough spoken length for text with no recording behind it.
  static int estimateSpokenMs(String arabic, {bool slow = false}) {
    final words = splitWords(arabic).length;
    final base = 900 + words * 300;
    return slow ? (base * 1.5).round() : base;
  }

  /// Spreads [totalDurationMs] across the words of [arabic], weighting longer
  /// words heavier. It is an approximation until real word timings exist, but
  /// it always ends exactly when the audio does.
  static RecitationTimingModel estimate({
    required String idPrefix,
    required String arabic,
    required String transliteration,
    required String translation,
    required int totalDurationMs,
  }) {
    final arabicWords = splitWords(arabic);
    if (arabicWords.isEmpty || totalDurationMs <= 0) {
      return RecitationTimingModel(
        totalDurationMs: totalDurationMs < 0 ? 0 : totalDurationMs,
        wordTimings: const <RecitationWordTimingModel>[],
      );
    }
    final transliterationWords = splitWords(transliteration);
    final translationWords = splitWords(translation);
    final weights = arabicWords
        .map((word) => word.runes.length.clamp(2, 12))
        .toList(growable: false);
    final totalWeight = weights.fold<int>(0, (sum, value) => sum + value);
    final segments = <RecitationWordTimingModel>[];
    var cursor = 0;
    for (var i = 0; i < arabicWords.length; i += 1) {
      final width = ((weights[i] / totalWeight) * totalDurationMs).round();
      final end = i == arabicWords.length - 1
          ? totalDurationMs
          : (cursor + width).clamp(cursor, totalDurationMs);
      segments.add(
        RecitationWordTimingModel(
          wordId: '$idPrefix-$i',
          arabicText: arabicWords[i],
          transliteration: i < transliterationWords.length
              ? transliterationWords[i]
              : '',
          translation: i < translationWords.length ? translationWords[i] : '',
          startMs: cursor,
          endMs: end,
        ),
      );
      cursor = end;
    }
    return RecitationTimingModel(
      totalDurationMs: totalDurationMs,
      wordTimings: segments,
    );
  }

  /// The word under the playhead at [elapsedMs], or the last word once the
  /// clip has run out.
  int activeWordAt(int elapsedMs) {
    if (wordTimings.isEmpty) return -1;
    for (var i = 0; i < wordTimings.length; i += 1) {
      if (elapsedMs < wordTimings[i].endMs) return i;
    }
    return wordTimings.length - 1;
  }
}

class AyahAudioModel {
  const AyahAudioModel({
    required this.surahNumber,
    required this.ayahNumber,
    required this.localAudioAssetPath,
  });

  final int surahNumber;
  final int ayahNumber;
  final String? localAudioAssetPath;
}

class PrayerStepModel {
  PrayerStepModel({
    required this.id,
    required this.title,
    required this.kind,
    required this.posture,
    required this.segments,
    required this.pauseAfterMs,
    this.isOptional = false,
    this.isDynamicSurah = false,
    this.surahId,
    this.repeatCount = 1,
    this.entryTakbir = false,
    this.isSilent = false,
    this.helperText,
    this.madhhabNotes = const <PrayerMadhab, String>{},
    this.segmentsByMadhhab = const <PrayerMadhab, List<RecitationSegment>>{},
    this.omittedFor = const <PrayerMadhab>{},
  }) : assert(segments.isNotEmpty, 'a step recites at least one segment');

  final String id;
  final String title;
  final SalahRecitationKind kind;
  final PrayerPostureType posture;
  final List<RecitationSegment> segments;

  /// Base rest after the recitation, before the pace multiplier.
  final int pauseAfterMs;
  final bool isOptional;

  /// The learner's chosen surah replaces this step's segments.
  final bool isDynamicSurah;

  /// A fixed surah (al-Fatihah) whose verses become this step's segments.
  final String? surahId;

  /// How many times the segments are recited; tasbih steps use three.
  final int repeatCount;

  /// The posture is entered with "Allahu akbar" before the recitation.
  final bool entryTakbir;

  /// A reminder that is shown, not recited.
  final bool isSilent;
  final String? helperText;

  /// How this step is commonly taught in each school, shown for the
  /// learner's madhhab setting.
  final Map<PrayerMadhab, String> madhhabNotes;

  /// Schools that recite a different text here (the Shafi'i opening dua).
  final Map<PrayerMadhab, List<RecitationSegment>> segmentsByMadhhab;

  /// Schools that skip this step altogether.
  final Set<PrayerMadhab> omittedFor;

  /// The step as the given school recites it.
  PrayerStepModel forMadhhab(PrayerMadhab madhhab) {
    final variant = segmentsByMadhhab[madhhab];
    return variant == null ? this : copyWith(segments: variant);
  }

  String get arabicText =>
      segments.map((segment) => segment.arabicText).join(' ');
  String get transliteration =>
      segments.map((segment) => segment.transliteration).join(' ');
  String get translation => segments
      .map((segment) => segment.translation)
      .where((value) => value.trim().isNotEmpty)
      .join(' ');

  bool get isTasbih => repeatCount > 1;

  PrayerStepModel copyWith({
    String? id,
    String? title,
    SalahRecitationKind? kind,
    PrayerPostureType? posture,
    List<RecitationSegment>? segments,
    int? pauseAfterMs,
    bool? isOptional,
    bool? isDynamicSurah,
    String? surahId,
    int? repeatCount,
    bool? entryTakbir,
    bool? isSilent,
    String? helperText,
    Map<PrayerMadhab, String>? madhhabNotes,
    Map<PrayerMadhab, List<RecitationSegment>>? segmentsByMadhhab,
    Set<PrayerMadhab>? omittedFor,
  }) {
    return PrayerStepModel(
      id: id ?? this.id,
      title: title ?? this.title,
      kind: kind ?? this.kind,
      posture: posture ?? this.posture,
      segments: segments ?? this.segments,
      pauseAfterMs: pauseAfterMs ?? this.pauseAfterMs,
      isOptional: isOptional ?? this.isOptional,
      isDynamicSurah: isDynamicSurah ?? this.isDynamicSurah,
      surahId: surahId ?? this.surahId,
      repeatCount: repeatCount ?? this.repeatCount,
      entryTakbir: entryTakbir ?? this.entryTakbir,
      isSilent: isSilent ?? this.isSilent,
      helperText: helperText ?? this.helperText,
      madhhabNotes: madhhabNotes ?? this.madhhabNotes,
      segmentsByMadhhab: segmentsByMadhhab ?? this.segmentsByMadhhab,
      omittedFor: omittedFor ?? this.omittedFor,
    );
  }
}

class RakaaModel {
  const RakaaModel({required this.index, required this.steps});

  /// 1-based position in the prayer; the label is localized at display time.
  final int index;
  final List<PrayerStepModel> steps;
}

class PrayerModel {
  const PrayerModel({
    required this.id,
    required this.title,
    required this.arabicTitle,
    required this.shortDescription,
    required this.sunnahRakahs,
    required this.fardRakahs,
    required this.recitationStyle,
    required this.overview,
    required this.guidedRakahs,
    this.madhhabGuidance = const <PrayerMadhab, String>{},
    this.specialNotes = const <String>[],
  });

  final SalahPrayerId id;
  final String title;
  final String arabicTitle;
  final String shortDescription;
  final String sunnahRakahs;
  final String fardRakahs;
  final String recitationStyle;
  final String overview;
  final List<RakaaModel> guidedRakahs;

  /// School-specific notes, keyed by the learner's madhhab setting.
  final Map<PrayerMadhab, String> madhhabGuidance;
  final List<String> specialNotes;
}

class SurahVerseModel {
  const SurahVerseModel({
    required this.ayahNumber,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.audio,
  });

  final int ayahNumber;
  final String arabicText;
  final String transliteration;
  final String translation;
  final AyahAudioModel audio;

  RecitationSegment toSegment(String surahId) {
    return RecitationSegment(
      id: '${surahId}_$ayahNumber',
      arabicText: arabicText,
      transliteration: transliteration,
      translation: translation,
      audioAssetPath: audio.localAudioAssetPath,
      surahNumber: audio.surahNumber,
      ayahNumber: ayahNumber,
    );
  }
}

class SurahModel {
  const SurahModel({
    required this.id,
    required this.surahNumber,
    required this.name,
    required this.arabicName,
    required this.summary,
    required this.reflection,
    required this.verses,
  });

  final String id;
  final int surahNumber;
  final String name;
  final String arabicName;
  final String summary;
  final String reflection;
  final List<SurahVerseModel> verses;

  List<RecitationSegment> get segments =>
      verses.map((verse) => verse.toSegment(id)).toList(growable: false);
}

class RecitationModel {
  const RecitationModel({
    required this.id,
    required this.title,
    required this.category,
    required this.segments,
    required this.searchTags,
    required this.relatedPrayerIds,
  });

  final String id;
  final String title;
  final String category;
  final List<RecitationSegment> segments;
  final List<String> searchTags;
  final List<SalahPrayerId> relatedPrayerIds;

  String get arabicText =>
      segments.map((segment) => segment.arabicText).join(' ');
  String get transliteration =>
      segments.map((segment) => segment.transliteration).join(' ');
  String get translation =>
      segments.map((segment) => segment.translation).join(' ');
}

class SalahEssentialTopic {
  const SalahEssentialTopic({
    required this.id,
    required this.title,
    required this.summary,
    required this.bullets,
  });

  final String id;
  final String title;
  final String summary;
  final List<String> bullets;
}

class GuidedPrayerStep {
  const GuidedPrayerStep({
    required this.prayerId,
    required this.rakahNumber,
    required this.step,
    this.surahId,
  });

  final SalahPrayerId prayerId;
  final int rakahNumber;
  final PrayerStepModel step;

  /// Set when the step recites a surah, whether fixed (al-Fatihah) or chosen.
  final String? surahId;
}

class SurahPlaybackState {
  const SurahPlaybackState({
    required this.isPlaying,
    required this.currentAyahIndex,
    required this.currentWordIndex,
    required this.positionMs,
    required this.repeatCount,
    required this.pauseAfterAyah,
    required this.slowMode,
    this.activeTiming,
    this.sourceKind,
  });

  final bool isPlaying;
  final int currentAyahIndex;
  final int currentWordIndex;
  final int positionMs;
  final int repeatCount;
  final bool pauseAfterAyah;
  final bool slowMode;

  /// Word timing for the ayah being played, scaled to the clip's real length.
  final RecitationTimingModel? activeTiming;
  final SalahAudioSourceKind? sourceKind;

  SurahPlaybackState copyWith({
    bool? isPlaying,
    int? currentAyahIndex,
    int? currentWordIndex,
    int? positionMs,
    int? repeatCount,
    bool? pauseAfterAyah,
    bool? slowMode,
    RecitationTimingModel? activeTiming,
    bool clearActiveTiming = false,
    SalahAudioSourceKind? sourceKind,
  }) {
    return SurahPlaybackState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentAyahIndex: currentAyahIndex ?? this.currentAyahIndex,
      currentWordIndex: currentWordIndex ?? this.currentWordIndex,
      positionMs: positionMs ?? this.positionMs,
      repeatCount: repeatCount ?? this.repeatCount,
      pauseAfterAyah: pauseAfterAyah ?? this.pauseAfterAyah,
      slowMode: slowMode ?? this.slowMode,
      activeTiming: clearActiveTiming
          ? null
          : activeTiming ?? this.activeTiming,
      sourceKind: sourceKind ?? this.sourceKind,
    );
  }
}

class GuidedPrayerSyncState {
  const GuidedPrayerSyncState({
    required this.isPlaying,
    required this.currentStepIndex,
    required this.currentWordIndex,
    required this.positionMs,
    required this.activePosture,
    this.currentSegmentIndex = 0,
    this.repeatIteration = 1,
    this.phase = GuidedStepPhase.idle,
    this.activeTiming,
    this.holdRemainingMs = 0,
    this.sourceKind,
  });

  final bool isPlaying;
  final int currentStepIndex;
  final int currentWordIndex;
  final int positionMs;
  final PrayerPostureType activePosture;

  /// Which of the step's segments is being recited.
  final int currentSegmentIndex;

  /// 1-based pass through a repeated (tasbih) step.
  final int repeatIteration;
  final GuidedStepPhase phase;

  /// Word timing for the active segment, scaled to the clip's real length.
  final RecitationTimingModel? activeTiming;

  /// Countdown while resting in the posture after the recitation.
  final int holdRemainingMs;
  final SalahAudioSourceKind? sourceKind;

  GuidedPrayerSyncState copyWith({
    bool? isPlaying,
    int? currentStepIndex,
    int? currentWordIndex,
    int? positionMs,
    PrayerPostureType? activePosture,
    int? currentSegmentIndex,
    int? repeatIteration,
    GuidedStepPhase? phase,
    RecitationTimingModel? activeTiming,
    bool clearActiveTiming = false,
    int? holdRemainingMs,
    SalahAudioSourceKind? sourceKind,
  }) {
    return GuidedPrayerSyncState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      currentWordIndex: currentWordIndex ?? this.currentWordIndex,
      positionMs: positionMs ?? this.positionMs,
      activePosture: activePosture ?? this.activePosture,
      currentSegmentIndex: currentSegmentIndex ?? this.currentSegmentIndex,
      repeatIteration: repeatIteration ?? this.repeatIteration,
      phase: phase ?? this.phase,
      activeTiming: clearActiveTiming
          ? null
          : activeTiming ?? this.activeTiming,
      holdRemainingMs: holdRemainingMs ?? this.holdRemainingMs,
      sourceKind: sourceKind ?? this.sourceKind,
    );
  }
}

/// Where a learner stopped inside a guided prayer, so the hub can resume it.
class SalahGuidedSession {
  const SalahGuidedSession({
    required this.prayerId,
    required this.surahId,
    required this.stepIndex,
    required this.totalSteps,
    required this.updatedAt,
  });

  final SalahPrayerId prayerId;
  final String surahId;
  final int stepIndex;
  final int totalSteps;
  final DateTime updatedAt;

  bool get hasProgress => stepIndex > 0 && stepIndex < totalSteps;

  Map<String, dynamic> toJson() => {
    'prayerId': prayerId.name,
    'surahId': surahId,
    'stepIndex': stepIndex,
    'totalSteps': totalSteps,
    'updatedAt': updatedAt.toIso8601String(),
  };

  static SalahGuidedSession? fromJson(dynamic raw) {
    if (raw is! Map) return null;
    final prayerName = raw['prayerId']?.toString();
    SalahPrayerId? prayerId;
    for (final item in SalahPrayerId.values) {
      if (item.name == prayerName) prayerId = item;
    }
    final surahId = raw['surahId']?.toString();
    final stepIndex = (raw['stepIndex'] as num?)?.toInt();
    final totalSteps = (raw['totalSteps'] as num?)?.toInt();
    if (prayerId == null ||
        surahId == null ||
        surahId.isEmpty ||
        stepIndex == null ||
        totalSteps == null) {
      return null;
    }
    return SalahGuidedSession(
      prayerId: prayerId,
      surahId: surahId,
      stepIndex: stepIndex,
      totalSteps: totalSteps,
      updatedAt:
          DateTime.tryParse(raw['updatedAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}

class SalahTrainerProgressState {
  const SalahTrainerProgressState({
    required this.surahProgressById,
    required this.recentPrayerIds,
    required this.completedPrayerIds,
    required this.learnedRecitationIds,
    required this.guidedSurahMode,
    required this.fixedSurahId,
    required this.practiceSurahId,
    this.sessionsByPrayerId = const <String, SalahGuidedSession>{},
  });

  final Map<String, SalahSurahProgress> surahProgressById;
  final List<String> recentPrayerIds;
  final Set<String> completedPrayerIds;
  final Set<String> learnedRecitationIds;
  final GuidedSurahMode guidedSurahMode;
  final String? fixedSurahId;
  final String? practiceSurahId;
  final Map<String, SalahGuidedSession> sessionsByPrayerId;

  SalahGuidedSession? sessionFor(SalahPrayerId prayerId) =>
      sessionsByPrayerId[prayerId.name];

  SalahTrainerProgressState copyWith({
    Map<String, SalahSurahProgress>? surahProgressById,
    List<String>? recentPrayerIds,
    Set<String>? completedPrayerIds,
    Set<String>? learnedRecitationIds,
    GuidedSurahMode? guidedSurahMode,
    String? fixedSurahId,
    String? practiceSurahId,
    Map<String, SalahGuidedSession>? sessionsByPrayerId,
    bool clearFixedSurah = false,
    bool clearPracticeSurah = false,
  }) {
    return SalahTrainerProgressState(
      surahProgressById: surahProgressById ?? this.surahProgressById,
      recentPrayerIds: recentPrayerIds ?? this.recentPrayerIds,
      completedPrayerIds: completedPrayerIds ?? this.completedPrayerIds,
      learnedRecitationIds: learnedRecitationIds ?? this.learnedRecitationIds,
      guidedSurahMode: guidedSurahMode ?? this.guidedSurahMode,
      fixedSurahId: clearFixedSurah ? null : fixedSurahId ?? this.fixedSurahId,
      practiceSurahId: clearPracticeSurah
          ? null
          : practiceSurahId ?? this.practiceSurahId,
      sessionsByPrayerId: sessionsByPrayerId ?? this.sessionsByPrayerId,
    );
  }

  Map<String, dynamic> toJson() => {
    'surahProgressById': {
      for (final entry in surahProgressById.entries)
        entry.key: entry.value.name,
    },
    'recentPrayerIds': recentPrayerIds,
    'completedPrayerIds': completedPrayerIds.toList(growable: false),
    'learnedRecitationIds': learnedRecitationIds.toList(growable: false),
    'guidedSurahMode': guidedSurahMode.name,
    'fixedSurahId': fixedSurahId,
    'practiceSurahId': practiceSurahId,
    'sessionsByPrayerId': {
      for (final entry in sessionsByPrayerId.entries)
        entry.key: entry.value.toJson(),
    },
  };

  static SalahTrainerProgressState fromJson(Map<String, dynamic>? json) {
    final surahProgressById = <String, SalahSurahProgress>{};
    final rawProgress = json?['surahProgressById'];
    if (rawProgress is Map) {
      for (final entry in rawProgress.entries) {
        final id = entry.key.toString();
        final rawValue = entry.value?.toString();
        if (id.isEmpty || rawValue == null) continue;
        final value = SalahSurahProgress.values.firstWhere(
          (item) => item.name == rawValue,
          orElse: () => SalahSurahProgress.notStarted,
        );
        surahProgressById[id] = value;
      }
    }

    List<String> toStringList(dynamic raw) {
      if (raw is! List) return const <String>[];
      return raw
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList(growable: false);
    }

    final rawMode = json?['guidedSurahMode']?.toString();
    final guidedSurahMode = GuidedSurahMode.values.firstWhere(
      (item) => item.name == rawMode,
      orElse: () => GuidedSurahMode.random,
    );

    final sessions = <String, SalahGuidedSession>{};
    final rawSessions = json?['sessionsByPrayerId'];
    if (rawSessions is Map) {
      for (final entry in rawSessions.entries) {
        final session = SalahGuidedSession.fromJson(entry.value);
        if (session != null) sessions[entry.key.toString()] = session;
      }
    }

    return SalahTrainerProgressState(
      surahProgressById: surahProgressById,
      recentPrayerIds: toStringList(json?['recentPrayerIds']),
      completedPrayerIds: toStringList(json?['completedPrayerIds']).toSet(),
      learnedRecitationIds: toStringList(json?['learnedRecitationIds']).toSet(),
      guidedSurahMode: guidedSurahMode,
      fixedSurahId: json?['fixedSurahId']?.toString(),
      practiceSurahId: json?['practiceSurahId']?.toString(),
      sessionsByPrayerId: sessions,
    );
  }
}

/// Learner preferences for the guided flow, persisted separately from
/// progress so resetting one never touches the other.
class SalahGuidedSettings {
  const SalahGuidedSettings({
    required this.pace,
    required this.tasbihRepeats,
    required this.showTransliteration,
    required this.showTranslation,
    required this.focusMode,
  });

  static const List<int> tasbihRepeatOptions = <int>[1, 3, 5];

  final SalahTrainerPace pace;

  /// How many times a ruku or sujud tasbih is recited.
  final int tasbihRepeats;
  final bool showTransliteration;
  final bool showTranslation;

  /// Large text and hidden chrome for following along hands-free.
  final bool focusMode;

  SalahGuidedSettings copyWith({
    SalahTrainerPace? pace,
    int? tasbihRepeats,
    bool? showTransliteration,
    bool? showTranslation,
    bool? focusMode,
  }) {
    return SalahGuidedSettings(
      pace: pace ?? this.pace,
      tasbihRepeats: tasbihRepeats ?? this.tasbihRepeats,
      showTransliteration: showTransliteration ?? this.showTransliteration,
      showTranslation: showTranslation ?? this.showTranslation,
      focusMode: focusMode ?? this.focusMode,
    );
  }

  Map<String, dynamic> toJson() => {
    'pace': pace.name,
    'tasbihRepeats': tasbihRepeats,
    'showTransliteration': showTransliteration,
    'showTranslation': showTranslation,
    'focusMode': focusMode,
  };

  static SalahGuidedSettings fromJson(
    Map<String, dynamic>? json, {
    required SalahGuidedSettings defaults,
  }) {
    if (json == null) return defaults;
    final rawPace = json['pace']?.toString();
    final pace = SalahTrainerPace.values.firstWhere(
      (item) => item.name == rawPace,
      orElse: () => defaults.pace,
    );
    final rawRepeats = (json['tasbihRepeats'] as num?)?.toInt();
    return SalahGuidedSettings(
      pace: pace,
      tasbihRepeats:
          rawRepeats != null && tasbihRepeatOptions.contains(rawRepeats)
          ? rawRepeats
          : defaults.tasbihRepeats,
      showTransliteration:
          json['showTransliteration'] as bool? ?? defaults.showTransliteration,
      showTranslation:
          json['showTranslation'] as bool? ?? defaults.showTranslation,
      focusMode: json['focusMode'] as bool? ?? defaults.focusMode,
    );
  }
}
