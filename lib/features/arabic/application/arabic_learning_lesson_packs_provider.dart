import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../kids_arabic/application/kids_arabic_phrases_provider.dart';
import '../../kids_arabic/application/kids_arabic_progress_provider.dart';
import '../../kids_arabic/application/kids_arabic_progression.dart';
import '../../kids_arabic/application/kids_arabic_words_provider.dart';
import '../../learn/quran/application/quran_readiness_bridge_provider.dart';
import '../../learn/quran_teaching/application/quran_teaching_controller.dart';
import '../domain/arabic_content_authoring_models.dart';
import '../domain/arabic_learning_continuity_models.dart';
import '../domain/arabic_learning_lesson_pack_models.dart';
import 'arabic_content_authoring_provider.dart';
import 'arabic_learning_progress_provider.dart';

final arabicLearningLessonPacksProvider =
    Provider.family<List<ArabicLearningLessonPack>, ArabicLearningAudience>((
      ref,
      audience,
    ) {
      switch (audience) {
        case ArabicLearningAudience.kids:
          return _buildKidsLessonPacks(ref);
        case ArabicLearningAudience.adult:
          return _buildAdultLessonPacks(ref);
      }
    });

List<ArabicLearningLessonPack> _buildKidsLessonPacks(Ref ref) {
  final units = ref.watch(
    arabicContentUnitsProvider(ArabicLearningAudience.kids),
  );
  final compositions = ref.watch(
    arabicContentPackCompositionsProvider(ArabicLearningAudience.kids),
  );
  final progress = ref.watch(kidsArabicProgressProvider);
  final wordStatuses = ref.watch(kidsArabicWordStatusesProvider);
  final phrases = ref.watch(kidsArabicMiniPhrasesProvider);
  final phraseProgress = ref.watch(kidsArabicMiniPhraseProgressProvider);
  final readiness = ref.watch(
    quranReadinessBridgeSummaryProvider(ArabicLearningAudience.kids),
  );
  final continuation = ref
      .watch(arabicLearningProgressSummaryProvider(ArabicLearningAudience.kids))
      .continuation;

  final nextLetterId = kidsArabicStarterReleaseOrderIds.firstWhere(
    (id) => !progress.completedLetterIds.contains(id),
    orElse: () => kidsArabicStarterReleaseOrderIds.first,
  );
  final nextWordStatus = wordStatuses.firstWhere(
    (status) => status.isNextRecommended,
    orElse: () => wordStatuses.first,
  );
  final nextPhrase = phrases.firstWhere(
    (phrase) => !phraseProgress.heardPhraseIds.contains(phrase.id),
    orElse: () => phrases.first,
  );

  final compositionMap = {
    for (final composition in compositions) composition.id: composition,
  };

  final packs = <ArabicLearningLessonPack>[
    ArabicLearningLessonPack(
      id: 'kids_beginner_letters_pack',
      audience: ArabicLearningAudience.kids,
      type: ArabicLearningLessonPackType.letters,
      primaryTarget: ArabicLearningRouteTarget(
        kind: ArabicLearningRouteTargetKind.goNamed,
        contentType: ArabicLearningContinuationContentType.letter,
        canonicalItemId: nextLetterId,
        routeName: 'kidsArabicLesson',
        pathParameters: <String, String>{'letterId': nextLetterId},
      ),
      itemIds: compositionMap['kids_beginner_letters_pack']!.contentUnitIds,
      previewArabic: _previewArabicForUnitIds(
        units,
        compositionMap['kids_beginner_letters_pack']!.contentUnitIds,
      ),
      searchKeywords:
          compositionMap['kids_beginner_letters_pack']!.searchKeywords,
      sortOrder: compositionMap['kids_beginner_letters_pack']!.sortOrder,
    ),
    ArabicLearningLessonPack(
      id: 'kids_first_words_pack',
      audience: ArabicLearningAudience.kids,
      type: ArabicLearningLessonPackType.words,
      primaryTarget: ArabicLearningRouteTarget(
        kind: ArabicLearningRouteTargetKind.goNamed,
        contentType: ArabicLearningContinuationContentType.word,
        canonicalItemId: nextWordStatus.word.id,
        routeName: 'kidsArabicWordLesson',
        pathParameters: <String, String>{'wordId': nextWordStatus.word.id},
      ),
      itemIds: compositionMap['kids_first_words_pack']!.contentUnitIds,
      previewArabic: _previewArabicForUnitIds(
        units,
        compositionMap['kids_first_words_pack']!.contentUnitIds,
      ),
      searchKeywords: compositionMap['kids_first_words_pack']!.searchKeywords,
      sortOrder: compositionMap['kids_first_words_pack']!.sortOrder,
    ),
    ArabicLearningLessonPack(
      id: 'kids_mini_phrases_pack',
      audience: ArabicLearningAudience.kids,
      type: ArabicLearningLessonPackType.phrases,
      primaryTarget: ArabicLearningRouteTarget(
        kind: ArabicLearningRouteTargetKind.goNamed,
        contentType: ArabicLearningContinuationContentType.phrase,
        canonicalItemId: nextPhrase.id,
        routeName: 'kidsArabicMiniPhrases',
        queryParameters: <String, String>{'phrase': nextPhrase.id},
      ),
      itemIds: compositionMap['kids_mini_phrases_pack']!.contentUnitIds,
      previewArabic: _previewArabicForUnitIds(
        units,
        compositionMap['kids_mini_phrases_pack']!.contentUnitIds,
      ),
      searchKeywords: compositionMap['kids_mini_phrases_pack']!.searchKeywords,
      sortOrder: compositionMap['kids_mini_phrases_pack']!.sortOrder,
    ),
    ArabicLearningLessonPack(
      id: 'kids_daily_words_theme_pack',
      audience: ArabicLearningAudience.kids,
      type: ArabicLearningLessonPackType.theme,
      primaryTarget: _primaryTargetForUnitIds(
        units,
        compositionMap['kids_daily_words_theme_pack']!.contentUnitIds,
        fallback: ArabicLearningRouteTarget(
          kind: ArabicLearningRouteTargetKind.goNamed,
          contentType: ArabicLearningContinuationContentType.phrase,
          canonicalItemId: nextPhrase.id,
          routeName: 'kidsArabicMiniPhrases',
          queryParameters: <String, String>{'phrase': nextPhrase.id},
        ),
      ),
      itemIds: compositionMap['kids_daily_words_theme_pack']!.contentUnitIds,
      previewArabic: _previewArabicForUnitIds(
        units,
        compositionMap['kids_daily_words_theme_pack']!.contentUnitIds,
      ),
      searchKeywords:
          compositionMap['kids_daily_words_theme_pack']!.searchKeywords,
      sortOrder: compositionMap['kids_daily_words_theme_pack']!.sortOrder,
    ),
    ArabicLearningLessonPack(
      id: 'kids_prayer_words_theme_pack',
      audience: ArabicLearningAudience.kids,
      type: ArabicLearningLessonPackType.theme,
      primaryTarget: _primaryTargetForUnitIds(
        units,
        compositionMap['kids_prayer_words_theme_pack']!.contentUnitIds,
        fallback: ArabicLearningRouteTarget(
          kind: ArabicLearningRouteTargetKind.goNamed,
          contentType: ArabicLearningContinuationContentType.phrase,
          canonicalItemId: readiness.snippet.id,
          routeName: readiness.routeName,
          queryParameters: <String, String>{'snippet': readiness.snippet.id},
        ),
      ),
      itemIds: compositionMap['kids_prayer_words_theme_pack']!.contentUnitIds,
      previewArabic: _previewArabicForUnitIds(
        units,
        compositionMap['kids_prayer_words_theme_pack']!.contentUnitIds,
      ),
      searchKeywords:
          compositionMap['kids_prayer_words_theme_pack']!.searchKeywords,
      sortOrder: compositionMap['kids_prayer_words_theme_pack']!.sortOrder,
    ),
    ArabicLearningLessonPack(
      id: 'kids_quran_linked_words_theme_pack',
      audience: ArabicLearningAudience.kids,
      type: ArabicLearningLessonPackType.theme,
      primaryTarget: _primaryTargetForUnitIds(
        units,
        compositionMap['kids_quran_linked_words_theme_pack']!.contentUnitIds,
        fallback: ArabicLearningRouteTarget(
          kind: ArabicLearningRouteTargetKind.goNamed,
          contentType: ArabicLearningContinuationContentType.phrase,
          canonicalItemId: readiness.snippet.id,
          routeName: readiness.routeName,
          queryParameters: <String, String>{'snippet': readiness.snippet.id},
        ),
      ),
      itemIds:
          compositionMap['kids_quran_linked_words_theme_pack']!.contentUnitIds,
      previewArabic: _previewArabicForUnitIds(
        units,
        compositionMap['kids_quran_linked_words_theme_pack']!.contentUnitIds,
      ),
      searchKeywords:
          compositionMap['kids_quran_linked_words_theme_pack']!.searchKeywords,
      sortOrder:
          compositionMap['kids_quran_linked_words_theme_pack']!.sortOrder,
    ),
    ArabicLearningLessonPack(
      id: 'kids_review_pack',
      audience: ArabicLearningAudience.kids,
      type: ArabicLearningLessonPackType.review,
      primaryTarget: const ArabicLearningRouteTarget(
        kind: ArabicLearningRouteTargetKind.goNamed,
        contentType: ArabicLearningContinuationContentType.review,
        canonicalItemId: 'kids_review_pack',
        routeName: 'kidsArabicReview',
      ),
      itemIds: compositionMap['kids_review_pack']!.contentUnitIds,
      searchKeywords: compositionMap['kids_review_pack']!.searchKeywords,
      sortOrder: compositionMap['kids_review_pack']!.sortOrder,
    ),
    ArabicLearningLessonPack(
      id: 'kids_quran_readiness_pack',
      audience: ArabicLearningAudience.kids,
      type: ArabicLearningLessonPackType.bridge,
      primaryTarget: ArabicLearningRouteTarget(
        kind: ArabicLearningRouteTargetKind.goNamed,
        contentType: ArabicLearningContinuationContentType.phrase,
        canonicalItemId: readiness.snippet.id,
        routeName: readiness.routeName,
        queryParameters: <String, String>{'snippet': readiness.snippet.id},
      ),
      itemIds: compositionMap['kids_quran_readiness_pack']!.contentUnitIds,
      previewArabic: <String>[readiness.snippet.snippetArabic],
      searchKeywords:
          compositionMap['kids_quran_readiness_pack']!.searchKeywords,
      sortOrder: compositionMap['kids_quran_readiness_pack']!.sortOrder,
    ),
  ];

  return _sortPacks(
    _applyRecommendedPack(
      packs,
      continuation: continuation,
      reviewRouteName: 'kidsArabicReview',
    ),
  );
}

List<ArabicLearningLessonPack> _buildAdultLessonPacks(Ref ref) {
  final units = ref.watch(
    arabicContentUnitsProvider(ArabicLearningAudience.adult),
  );
  final compositions = ref.watch(
    arabicContentPackCompositionsProvider(ArabicLearningAudience.adult),
  );
  final catalog = ref.watch(quranTeachingCatalogProvider);
  final beginnerWords = ref.watch(quranTeachingBeginnerWordsProvider);
  final wordProgress = ref.watch(quranTeachingBeginnerWordsProgressProvider);
  final readiness = ref.watch(
    quranReadinessBridgeSummaryProvider(ArabicLearningAudience.adult),
  );
  final continuation = ref
      .watch(
        arabicLearningProgressSummaryProvider(ArabicLearningAudience.adult),
      )
      .continuation;

  final foundations = catalog.moduleById('foundations');
  final phraseReading = catalog.moduleById('phrase_reading');
  final tajweedBasics = catalog.moduleById('tajweed_basics');
  final nextWordId =
      wordProgress.lastWordId ??
      beginnerWords.firstOrNull?.sharedBeginnerWordId;

  final compositionMap = {
    for (final composition in compositions) composition.id: composition,
  };

  final packs = <ArabicLearningLessonPack>[
    if (foundations != null)
      ArabicLearningLessonPack(
        id: 'adult_beginner_letters_pack',
        audience: ArabicLearningAudience.adult,
        type: ArabicLearningLessonPackType.letters,
        primaryTarget: ArabicLearningRouteTarget(
          kind: ArabicLearningRouteTargetKind.adultModule,
          contentType: ArabicLearningContinuationContentType.lesson,
          canonicalItemId: foundations.id,
          moduleId: foundations.id,
        ),
        itemIds: compositionMap['adult_beginner_letters_pack']!.contentUnitIds,
        previewArabic: _previewArabicForUnitIds(
          units,
          compositionMap['adult_beginner_letters_pack']!.contentUnitIds,
        ),
        searchKeywords:
            compositionMap['adult_beginner_letters_pack']!.searchKeywords,
        sortOrder: compositionMap['adult_beginner_letters_pack']!.sortOrder,
      ),
    if (beginnerWords.isNotEmpty && nextWordId != null)
      ArabicLearningLessonPack(
        id: 'adult_first_words_pack',
        audience: ArabicLearningAudience.adult,
        type: ArabicLearningLessonPackType.words,
        primaryTarget: ArabicLearningRouteTarget(
          kind: ArabicLearningRouteTargetKind.adultBeginnerWords,
          contentType: ArabicLearningContinuationContentType.word,
          canonicalItemId: nextWordId,
          wordId: nextWordId,
        ),
        itemIds: compositionMap['adult_first_words_pack']!.contentUnitIds,
        previewArabic: _previewArabicForUnitIds(
          units,
          compositionMap['adult_first_words_pack']!.contentUnitIds,
        ),
        searchKeywords:
            compositionMap['adult_first_words_pack']!.searchKeywords,
        sortOrder: compositionMap['adult_first_words_pack']!.sortOrder,
      ),
    if (phraseReading != null)
      ArabicLearningLessonPack(
        id: 'adult_phrase_reading_pack',
        audience: ArabicLearningAudience.adult,
        type: ArabicLearningLessonPackType.reading,
        primaryTarget: ArabicLearningRouteTarget(
          kind: ArabicLearningRouteTargetKind.adultModule,
          contentType: ArabicLearningContinuationContentType.lesson,
          canonicalItemId: phraseReading.id,
          moduleId: phraseReading.id,
        ),
        itemIds: compositionMap['adult_phrase_reading_pack']!.contentUnitIds,
        previewArabic: _previewArabicForUnitIds(
          units,
          compositionMap['adult_phrase_reading_pack']!.contentUnitIds,
        ),
        searchKeywords:
            compositionMap['adult_phrase_reading_pack']!.searchKeywords,
        sortOrder: compositionMap['adult_phrase_reading_pack']!.sortOrder,
      ),
    ArabicLearningLessonPack(
      id: 'adult_daily_words_theme_pack',
      audience: ArabicLearningAudience.adult,
      type: ArabicLearningLessonPackType.theme,
      primaryTarget: _primaryTargetForUnitIds(
        units,
        compositionMap['adult_daily_words_theme_pack']!.contentUnitIds,
        fallback: ArabicLearningRouteTarget(
          kind: ArabicLearningRouteTargetKind.goNamed,
          contentType: ArabicLearningContinuationContentType.phrase,
          canonicalItemId: readiness.snippet.id,
          routeName: readiness.routeName,
          queryParameters: <String, String>{'snippet': readiness.snippet.id},
        ),
      ),
      itemIds: compositionMap['adult_daily_words_theme_pack']!.contentUnitIds,
      previewArabic: _previewArabicForUnitIds(
        units,
        compositionMap['adult_daily_words_theme_pack']!.contentUnitIds,
      ),
      searchKeywords:
          compositionMap['adult_daily_words_theme_pack']!.searchKeywords,
      sortOrder: compositionMap['adult_daily_words_theme_pack']!.sortOrder,
    ),
    ArabicLearningLessonPack(
      id: 'adult_prayer_words_theme_pack',
      audience: ArabicLearningAudience.adult,
      type: ArabicLearningLessonPackType.theme,
      primaryTarget: _primaryTargetForUnitIds(
        units,
        compositionMap['adult_prayer_words_theme_pack']!.contentUnitIds,
        fallback: ArabicLearningRouteTarget(
          kind: ArabicLearningRouteTargetKind.goNamed,
          contentType: ArabicLearningContinuationContentType.phrase,
          canonicalItemId: readiness.snippet.id,
          routeName: readiness.routeName,
          queryParameters: <String, String>{'snippet': readiness.snippet.id},
        ),
      ),
      itemIds: compositionMap['adult_prayer_words_theme_pack']!.contentUnitIds,
      previewArabic: _previewArabicForUnitIds(
        units,
        compositionMap['adult_prayer_words_theme_pack']!.contentUnitIds,
      ),
      searchKeywords:
          compositionMap['adult_prayer_words_theme_pack']!.searchKeywords,
      sortOrder: compositionMap['adult_prayer_words_theme_pack']!.sortOrder,
    ),
    ArabicLearningLessonPack(
      id: 'adult_quran_linked_words_theme_pack',
      audience: ArabicLearningAudience.adult,
      type: ArabicLearningLessonPackType.theme,
      primaryTarget: _primaryTargetForUnitIds(
        units,
        compositionMap['adult_quran_linked_words_theme_pack']!.contentUnitIds,
        fallback: ArabicLearningRouteTarget(
          kind: ArabicLearningRouteTargetKind.goNamed,
          contentType: ArabicLearningContinuationContentType.phrase,
          canonicalItemId: readiness.snippet.id,
          routeName: readiness.routeName,
          queryParameters: <String, String>{'snippet': readiness.snippet.id},
        ),
      ),
      itemIds:
          compositionMap['adult_quran_linked_words_theme_pack']!.contentUnitIds,
      previewArabic: _previewArabicForUnitIds(
        units,
        compositionMap['adult_quran_linked_words_theme_pack']!.contentUnitIds,
      ),
      searchKeywords:
          compositionMap['adult_quran_linked_words_theme_pack']!.searchKeywords,
      sortOrder:
          compositionMap['adult_quran_linked_words_theme_pack']!.sortOrder,
    ),
    ArabicLearningLessonPack(
      id: 'adult_review_pack',
      audience: ArabicLearningAudience.adult,
      type: ArabicLearningLessonPackType.review,
      primaryTarget: const ArabicLearningRouteTarget(
        kind: ArabicLearningRouteTargetKind.adultDailyReview,
        contentType: ArabicLearningContinuationContentType.review,
        canonicalItemId: 'adult_review_pack',
      ),
      itemIds: compositionMap['adult_review_pack']!.contentUnitIds,
      searchKeywords: compositionMap['adult_review_pack']!.searchKeywords,
      sortOrder: compositionMap['adult_review_pack']!.sortOrder,
    ),
    ArabicLearningLessonPack(
      id: 'adult_quran_readiness_pack',
      audience: ArabicLearningAudience.adult,
      type: ArabicLearningLessonPackType.bridge,
      primaryTarget: ArabicLearningRouteTarget(
        kind: ArabicLearningRouteTargetKind.goNamed,
        contentType: ArabicLearningContinuationContentType.phrase,
        canonicalItemId: readiness.snippet.id,
        routeName: readiness.routeName,
        queryParameters: <String, String>{'snippet': readiness.snippet.id},
      ),
      itemIds: compositionMap['adult_quran_readiness_pack']!.contentUnitIds,
      previewArabic: <String>[readiness.snippet.snippetArabic],
      searchKeywords:
          compositionMap['adult_quran_readiness_pack']!.searchKeywords,
      sortOrder: compositionMap['adult_quran_readiness_pack']!.sortOrder,
    ),
    if (tajweedBasics != null)
      ArabicLearningLessonPack(
        id: 'adult_tajweed_support_pack',
        audience: ArabicLearningAudience.adult,
        type: ArabicLearningLessonPackType.tajweedSupport,
        primaryTarget: ArabicLearningRouteTarget(
          kind: ArabicLearningRouteTargetKind.adultModule,
          contentType: ArabicLearningContinuationContentType.lesson,
          canonicalItemId: tajweedBasics.id,
          moduleId: tajweedBasics.id,
        ),
        itemIds: compositionMap['adult_tajweed_support_pack']!.contentUnitIds,
        previewArabic: _previewArabicForUnitIds(
          units,
          compositionMap['adult_tajweed_support_pack']!.contentUnitIds,
        ),
        searchKeywords:
            compositionMap['adult_tajweed_support_pack']!.searchKeywords,
        sortOrder: compositionMap['adult_tajweed_support_pack']!.sortOrder,
      ),
  ];

  return _sortPacks(
    _applyRecommendedPack(
      packs,
      continuation: continuation,
      reviewRouteName: null,
    ),
  );
}

List<String> _previewArabicForUnitIds(
  List<ArabicContentUnit> units,
  List<String> unitIds,
) {
  final preview = <String>[];
  for (final unitId in unitIds) {
    final unit = arabicContentUnitById(units, unitId);
    final arabicText = unit?.arabicText;
    if (arabicText == null || arabicText.isEmpty) {
      continue;
    }
    preview.add(arabicText);
    if (preview.length == 3) {
      break;
    }
  }
  return preview;
}

ArabicLearningRouteTarget _primaryTargetForUnitIds(
  List<ArabicContentUnit> units,
  List<String> unitIds, {
  required ArabicLearningRouteTarget fallback,
}) {
  for (final unitId in unitIds) {
    final unit = arabicContentUnitById(units, unitId);
    if (unit != null) {
      return unit.target;
    }
  }
  return fallback;
}

List<ArabicLearningLessonPack> _applyRecommendedPack(
  List<ArabicLearningLessonPack> packs, {
  required ArabicLearningContinuationSummary continuation,
  required String? reviewRouteName,
}) {
  final recommendedId = _recommendedPackIdForContinuation(
    packs,
    continuation: continuation,
    reviewRouteName: reviewRouteName,
  );
  return packs
      .map(
        (pack) => ArabicLearningLessonPack(
          id: pack.id,
          audience: pack.audience,
          type: pack.type,
          primaryTarget: pack.primaryTarget,
          sortOrder: pack.sortOrder,
          itemIds: pack.itemIds,
          searchKeywords: pack.searchKeywords,
          previewArabic: pack.previewArabic,
          isRecommended: pack.id == recommendedId,
        ),
      )
      .toList(growable: false);
}

String? _recommendedPackIdForContinuation(
  List<ArabicLearningLessonPack> packs, {
  required ArabicLearningContinuationSummary continuation,
  required String? reviewRouteName,
}) {
  final canonicalItemId = continuation.primaryTarget.canonicalItemId;
  for (final pack in packs) {
    if (pack.itemIds.any(
      (itemId) =>
          itemId == canonicalItemId || itemId.endsWith(':$canonicalItemId'),
    )) {
      return pack.id;
    }
    if (pack.primaryTarget.kind == continuation.primaryTarget.kind &&
        pack.primaryTarget.routeName == continuation.primaryTarget.routeName &&
        pack.primaryTarget.moduleId == continuation.primaryTarget.moduleId) {
      return pack.id;
    }
  }
  if (reviewRouteName != null &&
      continuation.intent == ArabicLearningContinuationIntent.review) {
    return packs
        .where((pack) => pack.primaryTarget.routeName == reviewRouteName)
        .map((pack) => pack.id)
        .firstOrNull;
  }
  return packs.firstOrNull?.id;
}

List<ArabicLearningLessonPack> _sortPacks(
  List<ArabicLearningLessonPack> packs,
) {
  final sorted = packs.toList(growable: false);
  sorted.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  return sorted;
}
