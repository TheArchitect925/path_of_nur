import 'quran_content_refs.dart';
import 'quran_audio_resilience_models.dart';

class QuranAudioSourceId {
  const QuranAudioSourceId(this.value) : assert(value != '');

  final String value;
}

class QuranReciterId {
  const QuranReciterId(this.value) : assert(value != '');

  final String value;
}

enum QuranAudioMetadataConfidence {
  confirmedFromCode,
  inferredFromSourceShape,
  unknownNeedsManualReview,
}

class QuranAudioCollectionMetadata {
  const QuranAudioCollectionMetadata({
    required this.sourceId,
    required this.reciterId,
    required this.isAyahGranular,
    required this.includesBismillahInFatiha,
    required this.includesBismillahAtSurahStarts,
    required this.hasStandaloneBismillahClip,
    required this.surah9HasNoBismillahIntroInSource,
    required this.confidence,
    required this.manualReviewNeeded,
    this.standaloneBismillahRef,
    this.notes,
  });

  final QuranAudioSourceId sourceId;
  final QuranReciterId reciterId;
  final bool isAyahGranular;
  final bool includesBismillahInFatiha;
  final bool includesBismillahAtSurahStarts;
  final bool hasStandaloneBismillahClip;
  final QuranAudioRef? standaloneBismillahRef;
  final bool surah9HasNoBismillahIntroInSource;
  final String? notes;
  final QuranAudioMetadataConfidence confidence;
  final bool manualReviewNeeded;
}

class QuranAudioSourceMetadata {
  const QuranAudioSourceMetadata({
    required this.surahNumber,
    required this.ayahNumber,
    required this.reciterId,
    required this.source,
    required this.sourceType,
    required this.sourceContainsBismillahAtStart,
    required this.sourceId,
    required this.isAyahGranular,
    required this.includesBismillahInFatiha,
    required this.includesBismillahAtSurahStarts,
    required this.hasStandaloneBismillahClip,
    required this.surah9HasNoBismillahIntroInSource,
    required this.confidence,
    required this.manualReviewNeeded,
    this.standaloneBismillahRef,
    this.notes,
    this.isStandaloneBismillah = false,
    this.fallbackSource,
    this.fallbackSourceType,
  });

  final int surahNumber;
  final int ayahNumber;
  final String reciterId;
  final String source;
  final QuranPlaybackSourceType sourceType;
  final bool sourceContainsBismillahAtStart;
  final QuranAudioSourceId sourceId;
  final bool isAyahGranular;
  final bool includesBismillahInFatiha;
  final bool includesBismillahAtSurahStarts;
  final bool hasStandaloneBismillahClip;
  final QuranAudioRef? standaloneBismillahRef;
  final bool surah9HasNoBismillahIntroInSource;
  final String? notes;
  final QuranAudioMetadataConfidence confidence;
  final bool manualReviewNeeded;
  final bool isStandaloneBismillah;
  final String? fallbackSource;
  final QuranPlaybackSourceType? fallbackSourceType;

  bool get hasFallbackSource =>
      fallbackSource != null && fallbackSourceType != null;

  QuranAudioSourceMetadata copyWith({
    int? surahNumber,
    int? ayahNumber,
    String? reciterId,
    String? source,
    QuranPlaybackSourceType? sourceType,
    bool? sourceContainsBismillahAtStart,
    QuranAudioSourceId? sourceId,
    bool? isAyahGranular,
    bool? includesBismillahInFatiha,
    bool? includesBismillahAtSurahStarts,
    bool? hasStandaloneBismillahClip,
    QuranAudioRef? standaloneBismillahRef,
    bool clearStandaloneBismillahRef = false,
    bool? surah9HasNoBismillahIntroInSource,
    String? notes,
    bool clearNotes = false,
    QuranAudioMetadataConfidence? confidence,
    bool? manualReviewNeeded,
    bool? isStandaloneBismillah,
    String? fallbackSource,
    bool clearFallbackSource = false,
    QuranPlaybackSourceType? fallbackSourceType,
    bool clearFallbackSourceType = false,
  }) {
    return QuranAudioSourceMetadata(
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      reciterId: reciterId ?? this.reciterId,
      source: source ?? this.source,
      sourceType: sourceType ?? this.sourceType,
      sourceContainsBismillahAtStart:
          sourceContainsBismillahAtStart ?? this.sourceContainsBismillahAtStart,
      sourceId: sourceId ?? this.sourceId,
      isAyahGranular: isAyahGranular ?? this.isAyahGranular,
      includesBismillahInFatiha:
          includesBismillahInFatiha ?? this.includesBismillahInFatiha,
      includesBismillahAtSurahStarts:
          includesBismillahAtSurahStarts ?? this.includesBismillahAtSurahStarts,
      hasStandaloneBismillahClip:
          hasStandaloneBismillahClip ?? this.hasStandaloneBismillahClip,
      standaloneBismillahRef: clearStandaloneBismillahRef
          ? null
          : (standaloneBismillahRef ?? this.standaloneBismillahRef),
      surah9HasNoBismillahIntroInSource:
          surah9HasNoBismillahIntroInSource ??
          this.surah9HasNoBismillahIntroInSource,
      notes: clearNotes ? null : (notes ?? this.notes),
      confidence: confidence ?? this.confidence,
      manualReviewNeeded: manualReviewNeeded ?? this.manualReviewNeeded,
      isStandaloneBismillah: isStandaloneBismillah ?? this.isStandaloneBismillah,
      fallbackSource: clearFallbackSource
          ? null
          : (fallbackSource ?? this.fallbackSource),
      fallbackSourceType: clearFallbackSourceType
          ? null
          : (fallbackSourceType ?? this.fallbackSourceType),
    );
  }
}
