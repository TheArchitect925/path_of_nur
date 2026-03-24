import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../kids_arabic/application/kids_arabic_phrases_provider.dart';
import '../../kids_arabic/application/kids_arabic_progress_provider.dart';
import '../../kids_arabic/application/kids_arabic_words_provider.dart';
import '../../learn/quran/application/quran_readiness_bridge_provider.dart';
import '../../learn/quran/application/quran_short_surah_readiness_provider.dart';
import '../../learn/quran_teaching/application/quran_teaching_controller.dart';
import '../data/arabic_alphabet_catalog.dart';
import '../data/arabic_beginner_content_catalog.dart';
import '../data/arabic_content_authoring_catalog.dart';
import '../domain/arabic_content_authoring_models.dart';
import '../domain/arabic_learning_continuity_models.dart';
import 'arabic_learning_route_target_helpers.dart';

final arabicContentUnitsProvider =
    Provider.family<List<ArabicContentUnit>, ArabicLearningAudience>((
      ref,
      audience,
    ) {
      switch (audience) {
        case ArabicLearningAudience.kids:
          return _buildKidsContentUnits(ref);
        case ArabicLearningAudience.adult:
          return _buildAdultContentUnits(ref);
      }
    });

final arabicContentPackCompositionsProvider =
    Provider.family<List<ArabicContentPackComposition>, ArabicLearningAudience>((
      ref,
      audience,
    ) {
      switch (audience) {
        case ArabicLearningAudience.kids:
          return kidsArabicContentPackCompositions;
        case ArabicLearningAudience.adult:
          return adultArabicContentPackCompositions;
      }
    });

ArabicContentUnit? arabicContentUnitById(
  List<ArabicContentUnit> units,
  String id,
) {
  for (final unit in units) {
    if (unit.id == id) {
      return unit;
    }
  }
  return null;
}

List<ArabicContentUnit> _buildKidsContentUnits(Ref ref) {
  final unlockedLetterIds = ref.watch(kidsArabicUnlockedLetterIdsProvider);
  final wordStatuses = ref.watch(kidsArabicWordStatusesProvider);
  final phrases = ref.watch(kidsArabicMiniPhrasesProvider);
  final phraseProgress = ref.watch(kidsArabicMiniPhraseProgressProvider);
  final bridgeSnippets = ref.watch(quranReadinessBridgeSnippetsProvider);
  final shortSurahs = ref.watch(quranShortSurahReadinessSurahsProvider);

  return <ArabicContentUnit>[
    for (final letter in arabicAlphabetCatalog)
      ArabicContentUnit(
        id: arabicLetterContentUnitId(letter.id),
        audience: ArabicLearningAudience.kids,
        type: ArabicContentUnitType.letter,
        target: ArabicLearningRouteTarget(
          kind: ArabicLearningRouteTargetKind.goNamed,
          contentType: ArabicLearningContinuationContentType.letter,
          canonicalItemId: letter.id,
          routeName: 'kidsArabicLesson',
          pathParameters: <String, String>{'letterId': letter.id},
        ),
        sortOrder: 100 + letter.order,
        title: letter.kidsNameEn,
        subtitle: letter.soundHint,
        arabicText: letter.glyph,
        transliteration: letter.kidsTransliteration,
        keywords: <String>[letter.nameAr, if (letter.supportsTracing) 'tracing'],
        relatedLetterIds: <String>[letter.id],
        isAvailable: unlockedLetterIds.contains(letter.id),
      ),
    for (final status in wordStatuses)
      ArabicContentUnit(
        id: arabicWordContentUnitId(status.word.id),
        audience: ArabicLearningAudience.kids,
        type: ArabicContentUnitType.word,
        target: ArabicLearningRouteTarget(
          kind: ArabicLearningRouteTargetKind.goNamed,
          contentType: ArabicLearningContinuationContentType.word,
          canonicalItemId: status.word.id,
          routeName: 'kidsArabicWordLesson',
          pathParameters: <String, String>{'wordId': status.word.id},
        ),
        sortOrder: 200 + wordStatuses.indexOf(status),
        title: status.word.transliteration,
        arabicText: status.word.wordAr,
        transliteration: status.word.transliteration,
        summary: arabicSharedBeginnerWordById(status.word.id)?.simpleMeaning,
        audioAssetPath: arabicSharedBeginnerWordById(status.word.id)?.audioAssetPath,
        sourceReference: arabicSharedBeginnerWordById(status.word.id)?.sourceReference,
        keywords: <String>[status.word.id],
        relatedLetterIds: status.word.letterIds,
        isAvailable: status.unlocked,
      ),
    for (final phrase in phrases)
      ArabicContentUnit(
        id: arabicPhraseContentUnitId(phrase.id),
        audience: ArabicLearningAudience.kids,
        type: ArabicContentUnitType.phrase,
        target: ArabicLearningRouteTarget(
          kind: ArabicLearningRouteTargetKind.goNamed,
          contentType: ArabicLearningContinuationContentType.phrase,
          canonicalItemId: phrase.id,
          routeName: 'kidsArabicMiniPhrases',
          queryParameters: <String, String>{'phrase': phrase.id},
        ),
        sortOrder: 300 + phrases.indexOf(phrase),
        title: phrase.transliteration,
        arabicText: phrase.phraseAr,
        transliteration: phrase.transliteration,
        summary: arabicSharedMiniPhraseById(phrase.id)?.simpleMeaning,
        audioAssetPath: arabicSharedMiniPhraseById(phrase.id)?.audioAssetPath,
        sourceReference: arabicSharedMiniPhraseById(phrase.id)?.sourceReference,
        keywords: <String>[
          phrase.id,
          if (phraseProgress.heardPhraseIds.contains(phrase.id)) 'heard',
        ],
        relatedLetterIds: arabicSharedMiniPhraseById(phrase.id)?.letterIds ?? const <String>[],
        relatedPhraseIds: <String>[phrase.id],
      ),
    const ArabicContentUnit(
      id: 'review:kids_core',
      audience: ArabicLearningAudience.kids,
      type: ArabicContentUnitType.review,
      target: ArabicLearningRouteTarget(
        kind: ArabicLearningRouteTargetKind.goNamed,
        contentType: ArabicLearningContinuationContentType.review,
        canonicalItemId: 'kids_review_pack',
        routeName: 'kidsArabicReview',
      ),
      sortOrder: 400,
      keywords: <String>['review', 'practice'],
    ),
    for (final snippet in bridgeSnippets)
      ArabicContentUnit(
        id: arabicBridgeContentUnitId(snippet.id),
        audience: ArabicLearningAudience.kids,
        type: ArabicContentUnitType.quranBridgeSnippet,
        target: ArabicLearningRouteTarget(
          kind: ArabicLearningRouteTargetKind.goNamed,
          contentType: ArabicLearningContinuationContentType.phrase,
          canonicalItemId: snippet.id,
          routeName: 'kidsArabicQuranReadiness',
          queryParameters: <String, String>{'snippet': snippet.id},
        ),
        sortOrder: 500 + snippet.order,
        title: snippet.transliteration,
        subtitle: '${snippet.surahName} ${snippet.ref.locationLabel}',
        arabicText: snippet.snippetArabic,
        transliteration: snippet.transliteration,
        summary: snippet.simpleMeaning,
        audioAssetPath: snippet.audioAssetPath,
        sourceReference: snippet.ref.locationLabel,
        keywords: <String>[
          snippet.surahName,
          ...snippet.familiarWords.map((word) => word.id),
        ],
        relatedWordIds: snippet.familiarWords.map((word) => word.id).toList(growable: false),
        relatedPhraseIds: snippet.sharedPhrase == null
            ? const <String>[]
            : <String>[snippet.sharedPhrase!.id],
      ),
    for (final surah in shortSurahs)
      ArabicContentUnit(
        id: arabicShortSurahContentUnitId(surah.surahNumber),
        audience: ArabicLearningAudience.kids,
        type: ArabicContentUnitType.quranShortSurah,
        target: ArabicLearningRouteTarget(
          kind: ArabicLearningRouteTargetKind.goNamed,
          contentType: ArabicLearningContinuationContentType.phrase,
          canonicalItemId: surah.id,
          routeName: 'kidsArabicShortSurahs',
          queryParameters: <String, String>{'surah': '${surah.surahNumber}'},
        ),
        sortOrder: 600 + surah.order,
        title: surah.surahTransliteratedName,
        arabicText: surah.surahArabicName,
        summary: '${surah.ayahCount} ayahs',
        keywords: <String>[
          '${surah.surahNumber}',
          ...surah.familiarSnippets.map((snippet) => snippet.id),
        ],
        relatedPhraseIds: surah.familiarSnippets
            .where((snippet) => snippet.sharedPhrase != null)
            .map((snippet) => snippet.sharedPhrase!.id)
            .toList(growable: false),
      ),
  ];
}

List<ArabicContentUnit> _buildAdultContentUnits(Ref ref) {
  final catalog = ref.watch(quranTeachingCatalogProvider);
  final beginnerWords = ref.watch(quranTeachingBeginnerWordsProvider);
  final bridgeSnippets = ref.watch(quranReadinessBridgeSnippetsProvider);
  final shortSurahs = ref.watch(quranShortSurahReadinessSurahsProvider);

  return <ArabicContentUnit>[
    for (final letter in arabicAlphabetCatalog)
      ArabicContentUnit(
        id: arabicLetterContentUnitId(letter.id),
        audience: ArabicLearningAudience.adult,
        type: ArabicContentUnitType.letter,
        target: adultLetterRouteTarget(letter, catalog),
        sortOrder: 100 + letter.order,
        title: letter.adultNameEn,
        subtitle: letter.soundHint,
        arabicText: letter.glyph,
        transliteration: letter.adultTransliteration,
        keywords: <String>[letter.nameAr, 'alphabet'],
        relatedLetterIds: <String>[letter.id],
      ),
    for (final word in beginnerWords)
      ArabicContentUnit(
        id: arabicWordContentUnitId(word.sharedBeginnerWordId ?? word.id),
        audience: ArabicLearningAudience.adult,
        type: ArabicContentUnitType.word,
        target: ArabicLearningRouteTarget(
          kind: ArabicLearningRouteTargetKind.adultBeginnerWords,
          contentType: ArabicLearningContinuationContentType.word,
          canonicalItemId: word.sharedBeginnerWordId ?? word.id,
          wordId: word.sharedBeginnerWordId ?? word.id,
        ),
        sortOrder: 200 + beginnerWords.indexOf(word),
        title: word.transliteration,
        subtitle: word.exampleReference,
        arabicText: word.arabic,
        transliteration: word.transliteration,
        summary: word.meaning,
        audioAssetPath: word.audio?.assetPath,
        sourceReference: word.exampleReference,
        keywords: <String>[
          ...word.commonSurahs,
          if (word.categoryTag != null) word.categoryTag!,
        ],
        relatedLetterIds: word.letterIds,
        relatedWordIds: <String>[word.sharedBeginnerWordId ?? word.id],
      ),
    for (final phrase in arabicSharedMiniPhrases)
      if (adultPhraseRouteTarget(phrase.id) case final target?)
        ArabicContentUnit(
          id: arabicPhraseContentUnitId(phrase.id),
          audience: ArabicLearningAudience.adult,
          type: ArabicContentUnitType.phrase,
          target: target,
          sortOrder: 300 + arabicSharedMiniPhrases.indexOf(phrase),
          title: phrase.transliteration,
          subtitle: phrase.sourceReference,
          arabicText: phrase.arabicText,
          transliteration: phrase.transliteration,
          summary: phrase.simpleMeaning,
          audioAssetPath: phrase.audioAssetPath,
          sourceReference: phrase.sourceReference,
          keywords: <String>[phrase.id, phrase.categoryTag],
          relatedLetterIds: phrase.letterIds,
          relatedPhraseIds: <String>[phrase.id],
        ),
    const ArabicContentUnit(
      id: 'review:adult_core',
      audience: ArabicLearningAudience.adult,
      type: ArabicContentUnitType.review,
      target: ArabicLearningRouteTarget(
        kind: ArabicLearningRouteTargetKind.adultDailyReview,
        contentType: ArabicLearningContinuationContentType.review,
        canonicalItemId: 'adult_review_pack',
      ),
      sortOrder: 400,
      keywords: <String>['review', 'practice'],
    ),
    for (final module in catalog.modules.where(
      (module) => module.id == 'foundations' ||
          module.id == 'phrase_reading' ||
          module.id == 'tajweed_basics',
    ))
      ArabicContentUnit(
        id: arabicModuleContentUnitId(module.id),
        audience: ArabicLearningAudience.adult,
        type: ArabicContentUnitType.module,
        target: ArabicLearningRouteTarget(
          kind: ArabicLearningRouteTargetKind.adultModule,
          contentType: ArabicLearningContinuationContentType.lesson,
          canonicalItemId: module.id,
          moduleId: module.id,
        ),
        sortOrder: 450 + module.order,
        title: module.title,
        subtitle: module.subtitle,
        summary: module.description,
        keywords: <String>[module.id, module.type.name],
      ),
    for (final snippet in bridgeSnippets)
      ArabicContentUnit(
        id: arabicBridgeContentUnitId(snippet.id),
        audience: ArabicLearningAudience.adult,
        type: ArabicContentUnitType.quranBridgeSnippet,
        target: ArabicLearningRouteTarget(
          kind: ArabicLearningRouteTargetKind.goNamed,
          contentType: ArabicLearningContinuationContentType.phrase,
          canonicalItemId: snippet.id,
          routeName: 'quranArabicReadiness',
          queryParameters: <String, String>{'snippet': snippet.id},
        ),
        sortOrder: 500 + snippet.order,
        title: snippet.transliteration,
        subtitle: '${snippet.surahName} ${snippet.ref.locationLabel}',
        arabicText: snippet.snippetArabic,
        transliteration: snippet.transliteration,
        summary: snippet.simpleMeaning,
        audioAssetPath: snippet.audioAssetPath,
        sourceReference: snippet.ref.locationLabel,
        keywords: <String>[
          snippet.surahName,
          ...snippet.familiarWords.map((word) => word.id),
        ],
        relatedWordIds: snippet.familiarWords.map((word) => word.id).toList(growable: false),
        relatedPhraseIds: snippet.sharedPhrase == null
            ? const <String>[]
            : <String>[snippet.sharedPhrase!.id],
      ),
    for (final surah in shortSurahs)
      ArabicContentUnit(
        id: arabicShortSurahContentUnitId(surah.surahNumber),
        audience: ArabicLearningAudience.adult,
        type: ArabicContentUnitType.quranShortSurah,
        target: ArabicLearningRouteTarget(
          kind: ArabicLearningRouteTargetKind.goNamed,
          contentType: ArabicLearningContinuationContentType.phrase,
          canonicalItemId: surah.id,
          routeName: 'quranArabicShortSurahs',
          queryParameters: <String, String>{'surah': '${surah.surahNumber}'},
        ),
        sortOrder: 600 + surah.order,
        title: surah.surahTransliteratedName,
        arabicText: surah.surahArabicName,
        summary: '${surah.ayahCount} ayahs',
        keywords: <String>[
          '${surah.surahNumber}',
          ...surah.familiarSnippets.map((snippet) => snippet.id),
        ],
        relatedPhraseIds: surah.familiarSnippets
            .where((snippet) => snippet.sharedPhrase != null)
            .map((snippet) => snippet.sharedPhrase!.id)
            .toList(growable: false),
      ),
  ];
}
