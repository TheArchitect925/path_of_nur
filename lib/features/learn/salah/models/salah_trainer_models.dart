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
  qiyam,
  ruku,
  qawmah,
  sujud,
  jalsah,
  tashahhud,
  salamRight,
  salamLeft,
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

  final int totalDurationMs;
  final List<RecitationWordTimingModel> wordTimings;
}

class AyahAudioModel {
  const AyahAudioModel({
    required this.surahNumber,
    required this.ayahNumber,
    required this.localAudioAssetPath,
    required this.totalDurationMs,
    required this.timing,
  });

  final int surahNumber;
  final int ayahNumber;
  final String? localAudioAssetPath;
  final int totalDurationMs;
  final RecitationTimingModel timing;
}

class SurahAudioModel {
  const SurahAudioModel({
    required this.surahId,
    required this.reciterId,
    required this.ayahs,
  });

  final String surahId;
  final String reciterId;
  final List<AyahAudioModel> ayahs;
}

class PrayerStepModel {
  const PrayerStepModel({
    required this.id,
    required this.title,
    required this.kind,
    required this.posture,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.pauseAfterMs,
    this.audioAssetPath,
    this.ttsText,
    this.isOptional = false,
    this.isDynamicSurah = false,
    this.helperText,
  });

  final String id;
  final String title;
  final SalahRecitationKind kind;
  final PrayerPostureType posture;
  final String arabicText;
  final String transliteration;
  final String translation;
  final int pauseAfterMs;
  final String? audioAssetPath;
  final String? ttsText;
  final bool isOptional;
  final bool isDynamicSurah;
  final String? helperText;

  PrayerStepModel copyWith({
    String? id,
    String? title,
    SalahRecitationKind? kind,
    PrayerPostureType? posture,
    String? arabicText,
    String? transliteration,
    String? translation,
    int? pauseAfterMs,
    String? audioAssetPath,
    String? ttsText,
    bool? isOptional,
    bool? isDynamicSurah,
    String? helperText,
  }) {
    return PrayerStepModel(
      id: id ?? this.id,
      title: title ?? this.title,
      kind: kind ?? this.kind,
      posture: posture ?? this.posture,
      arabicText: arabicText ?? this.arabicText,
      transliteration: transliteration ?? this.transliteration,
      translation: translation ?? this.translation,
      pauseAfterMs: pauseAfterMs ?? this.pauseAfterMs,
      audioAssetPath: audioAssetPath ?? this.audioAssetPath,
      ttsText: ttsText ?? this.ttsText,
      isOptional: isOptional ?? this.isOptional,
      isDynamicSurah: isDynamicSurah ?? this.isDynamicSurah,
      helperText: helperText ?? this.helperText,
    );
  }
}

class RakaaModel {
  const RakaaModel({
    required this.index,
    required this.title,
    required this.steps,
  });

  final int index;
  final String title;
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
    this.madhhabGuidance = const <String, String>{},
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
  final Map<String, String> madhhabGuidance;
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
    required this.audio,
  });

  final String id;
  final int surahNumber;
  final String name;
  final String arabicName;
  final String summary;
  final String reflection;
  final List<SurahVerseModel> verses;
  final SurahAudioModel audio;
}

class RecitationModel {
  const RecitationModel({
    required this.id,
    required this.title,
    required this.category,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.searchTags,
    required this.relatedPrayerIds,
    this.audioAssetPath,
    this.ttsText,
  });

  final String id;
  final String title;
  final String category;
  final String arabicText;
  final String transliteration;
  final String translation;
  final List<String> searchTags;
  final List<SalahPrayerId> relatedPrayerIds;
  final String? audioAssetPath;
  final String? ttsText;
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
  });

  final bool isPlaying;
  final int currentAyahIndex;
  final int currentWordIndex;
  final int positionMs;
  final int repeatCount;
  final bool pauseAfterAyah;
  final bool slowMode;

  SurahPlaybackState copyWith({
    bool? isPlaying,
    int? currentAyahIndex,
    int? currentWordIndex,
    int? positionMs,
    int? repeatCount,
    bool? pauseAfterAyah,
    bool? slowMode,
  }) {
    return SurahPlaybackState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentAyahIndex: currentAyahIndex ?? this.currentAyahIndex,
      currentWordIndex: currentWordIndex ?? this.currentWordIndex,
      positionMs: positionMs ?? this.positionMs,
      repeatCount: repeatCount ?? this.repeatCount,
      pauseAfterAyah: pauseAfterAyah ?? this.pauseAfterAyah,
      slowMode: slowMode ?? this.slowMode,
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
  });

  final bool isPlaying;
  final int currentStepIndex;
  final int currentWordIndex;
  final int positionMs;
  final PrayerPostureType activePosture;

  GuidedPrayerSyncState copyWith({
    bool? isPlaying,
    int? currentStepIndex,
    int? currentWordIndex,
    int? positionMs,
    PrayerPostureType? activePosture,
  }) {
    return GuidedPrayerSyncState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      currentWordIndex: currentWordIndex ?? this.currentWordIndex,
      positionMs: positionMs ?? this.positionMs,
      activePosture: activePosture ?? this.activePosture,
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
  });

  final Map<String, SalahSurahProgress> surahProgressById;
  final List<String> recentPrayerIds;
  final Set<String> completedPrayerIds;
  final Set<String> learnedRecitationIds;
  final GuidedSurahMode guidedSurahMode;
  final String? fixedSurahId;
  final String? practiceSurahId;

  SalahTrainerProgressState copyWith({
    Map<String, SalahSurahProgress>? surahProgressById,
    List<String>? recentPrayerIds,
    Set<String>? completedPrayerIds,
    Set<String>? learnedRecitationIds,
    GuidedSurahMode? guidedSurahMode,
    String? fixedSurahId,
    String? practiceSurahId,
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

    return SalahTrainerProgressState(
      surahProgressById: surahProgressById,
      recentPrayerIds: toStringList(json?['recentPrayerIds']),
      completedPrayerIds: toStringList(json?['completedPrayerIds']).toSet(),
      learnedRecitationIds: toStringList(json?['learnedRecitationIds']).toSet(),
      guidedSurahMode: guidedSurahMode,
      fixedSurahId: json?['fixedSurahId']?.toString(),
      practiceSurahId: json?['practiceSurahId']?.toString(),
    );
  }
}
