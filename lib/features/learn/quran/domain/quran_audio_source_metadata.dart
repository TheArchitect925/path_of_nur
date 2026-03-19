import 'quran_content_refs.dart';

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
  });

  final int surahNumber;
  final int ayahNumber;
  final String reciterId;
  final String source;
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
}
