import 'kids_dua_models.dart';

enum KidsDuaReadAlongMode { arabicOnly, arabicTransliteration, full }

enum KidsDuaRepeatMode { listen, readAlong, tapToRepeat, gentlePractice }

class KidsDuaAudioVariant {
  const KidsDuaAudioVariant({
    required this.variantId,
    required this.duaId,
    required this.languageCode,
    required this.narratorId,
    required this.narratorDisplayName,
    required this.voicePackId,
    required this.audioFileName,
    required this.assetPath,
    required this.estimatedDurationSeconds,
    required this.isBundledAsset,
    required this.isDownloaded,
    required this.isAvailable,
    required this.versionTag,
    required this.sourceType,
    this.checksum,
  });

  final String variantId;
  final String duaId;
  final String languageCode;
  final String narratorId;
  final String narratorDisplayName;
  final String voicePackId;
  final String audioFileName;
  final String assetPath;
  final int estimatedDurationSeconds;
  final bool isBundledAsset;
  final bool isDownloaded;
  final bool isAvailable;
  final String versionTag;
  final String sourceType;
  final String? checksum;
}

class KidsDuaSegment {
  const KidsDuaSegment({
    required this.segmentId,
    required this.duaId,
    required this.sortOrder,
    required this.arabicSegmentText,
    required this.transliterationSegmentText,
    this.translationSegmentText,
    this.audioStartOffset,
    this.audioEndOffset,
    this.tapRepeatAudioAssetPath,
    this.emphasisType,
  });

  final String segmentId;
  final String duaId;
  final int sortOrder;
  final String arabicSegmentText;
  final String transliterationSegmentText;
  final String? translationSegmentText;
  final Duration? audioStartOffset;
  final Duration? audioEndOffset;
  final String? tapRepeatAudioAssetPath;
  final String? emphasisType;
}

class KidsDuaLearningItem {
  const KidsDuaLearningItem({
    required this.duaId,
    required this.title,
    required this.category,
    required this.useCase,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.shortMeaning,
    required this.sourceReference,
    required this.ageGroupLabel,
    required this.tags,
    required this.sortOrder,
    required this.isFeatured,
    required this.bedtimeRelevance,
    required this.dailyRoutineRelevance,
    required this.emotionRelevance,
    required this.audioVariants,
    required this.segments,
    required this.lesson,
    this.coverAssetPath,
    this.backdropAssetPath,
  });

  final String duaId;
  final String title;
  final String category;
  final String useCase;
  final String arabicText;
  final String transliteration;
  final String translation;
  final String shortMeaning;
  final String sourceReference;
  final String ageGroupLabel;
  final List<String> tags;
  final int sortOrder;
  final bool isFeatured;
  final bool bedtimeRelevance;
  final bool dailyRoutineRelevance;
  final bool emotionRelevance;
  final List<KidsDuaAudioVariant> audioVariants;
  final List<KidsDuaSegment> segments;
  final KidsDuaLessonContent lesson;
  final String? coverAssetPath;
  final String? backdropAssetPath;

  bool get hasAnyAudioVariant => audioVariants.isNotEmpty;
}

class KidsDuaRecommendation {
  const KidsDuaRecommendation({
    required this.duaId,
    required this.titleKey,
    required this.reasonKey,
    required this.mode,
  });

  final String duaId;
  final String titleKey;
  final String reasonKey;
  final KidsDuaRepeatMode mode;
}

class KidsDuaReadAlongState {
  const KidsDuaReadAlongState({
    this.mode = KidsDuaReadAlongMode.full,
    this.activeSegmentId,
  });

  final KidsDuaReadAlongMode mode;
  final String? activeSegmentId;

  KidsDuaReadAlongState copyWith({
    KidsDuaReadAlongMode? mode,
    String? activeSegmentId,
    bool clearActiveSegmentId = false,
  }) {
    return KidsDuaReadAlongState(
      mode: mode ?? this.mode,
      activeSegmentId: clearActiveSegmentId
          ? null
          : (activeSegmentId ?? this.activeSegmentId),
    );
  }
}

class KidsDuaLearningSession {
  const KidsDuaLearningSession({
    required this.duaId,
    required this.mode,
    required this.startedAtIso,
    this.lastInteractedAtIso,
    this.activeSegmentId,
  });

  final String duaId;
  final KidsDuaRepeatMode mode;
  final String startedAtIso;
  final String? lastInteractedAtIso;
  final String? activeSegmentId;
}
