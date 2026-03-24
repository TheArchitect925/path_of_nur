import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../kids_arabic/application/kids_arabic_phrases_provider.dart';
import '../../kids_arabic/application/kids_arabic_practice_provider.dart';
import '../../kids_arabic/application/kids_arabic_progress_provider.dart';
import '../../kids_arabic/application/kids_arabic_progression.dart';
import '../../kids_arabic/application/kids_arabic_words_provider.dart';
import '../../kids_arabic/data/kids_arabic_mini_phrases_data.dart';
import '../../kids_arabic/domain/kids_arabic_models.dart';
import '../../kids_arabic/domain/kids_arabic_phrase_models.dart';
import '../../kids_arabic/domain/kids_arabic_word_models.dart';
import '../../learn/quran_teaching/application/quran_teaching_controller.dart';
import '../../learn/quran_teaching/application/quran_teaching_smart_review_controller.dart';
import '../../learn/quran_teaching/data/quran_teaching_seed_data.dart';
import '../../learn/quran_teaching/domain/quran_teaching_models.dart';
import '../domain/arabic_learning_continuity_models.dart';

final arabicLearningReviewProvider =
    Provider.family<ArabicLearningReviewSummary, ArabicLearningAudience>((
      ref,
      audience,
    ) {
      switch (audience) {
        case ArabicLearningAudience.kids:
          return _buildKidsReviewSummary(ref);
        case ArabicLearningAudience.adult:
          return _buildAdultReviewSummary(ref);
      }
    });

ArabicLearningReviewSummary _buildKidsReviewSummary(Ref ref) {
  final progress = ref.watch(kidsArabicProgressProvider);
  final wordProgress = ref.watch(kidsArabicWordProgressProvider);
  final phraseProgress = ref.watch(kidsArabicMiniPhraseProgressProvider);
  final practicePlan = ref.watch(kidsArabicPracticePlanProvider);

  final firstLetter = kidsArabicProgressionLetters.first;
  final hasStartedLetters = progress.totalLessonsDone > 0;
  final hasStartedWords = wordProgress.totalWordLessonsDone > 0;
  final hasStartedPhrases =
      phraseProgress.lastPhraseId != null ||
      phraseProgress.heardPhraseIds.isNotEmpty;

  if (!hasStartedLetters && !hasStartedWords && !hasStartedPhrases) {
    return ArabicLearningReviewSummary(
      audience: ArabicLearningAudience.kids,
      primarySuggestion: _kidsStartSuggestion(firstLetter),
    );
  }

  final suggestions = <ArabicLearningReviewSuggestion>[];
  final seen = <String>{};

  void addSuggestion(ArabicLearningReviewSuggestion? suggestion) {
    if (suggestion == null) {
      return;
    }
    final key =
        '${suggestion.target.kind.name}:${suggestion.target.canonicalItemId}';
    if (!seen.add(key)) {
      return;
    }
    suggestions.add(suggestion);
  }

  addSuggestion(_kidsSuggestionFromFocus(practicePlan.primaryFocus));
  if (practicePlan.reviewLetters.isNotEmpty) {
    addSuggestion(
      _kidsLetterReviewSuggestion(practicePlan.reviewLetters.first),
    );
  }
  if (practicePlan.reviewWords.isNotEmpty) {
    addSuggestion(_kidsWordReviewSuggestion(practicePlan.reviewWords.first));
  }
  addSuggestion(_kidsPhraseSuggestion(phraseProgress: phraseProgress));

  if (suggestions.isEmpty) {
    suggestions.add(_kidsStartSuggestion(firstLetter));
  }

  return ArabicLearningReviewSummary(
    audience: ArabicLearningAudience.kids,
    primarySuggestion: suggestions.first,
    secondarySuggestions: suggestions.skip(1).take(2).toList(growable: false),
  );
}

ArabicLearningReviewSummary _buildAdultReviewSummary(Ref ref) {
  final catalog = ref.watch(quranTeachingCatalogProvider);
  final progress = ref.watch(quranTeachingProgressProvider);
  final recommendedLesson = ref.watch(quranTeachingRecommendedLessonProvider);
  final dailyReview = ref.watch(quranTeachingDailyReviewSummaryProvider);
  final wordProgress = ref.watch(quranTeachingBeginnerWordsProgressProvider);
  final words = ref.watch(quranTeachingBeginnerWordsProvider);

  QuranTeachingLesson? unfinishedLesson;
  for (final lessonId in progress.recentLessonIds) {
    if (progress.completedLessonIds.contains(lessonId) ||
        !progress.startedLessonIds.contains(lessonId)) {
      continue;
    }
    final lesson = catalog.lessonById(lessonId);
    final module = lesson == null ? null : catalog.moduleById(lesson.moduleId);
    if (lesson == null || module == null) {
      continue;
    }
    if (isLessonUnlocked(
      lesson: lesson,
      module: module,
      catalog: catalog,
      progress: progress,
    )) {
      unfinishedLesson = lesson;
      break;
    }
  }
  if (unfinishedLesson == null && progress.lastLessonId != null) {
    final lesson = catalog.lessonById(progress.lastLessonId!);
    final module = lesson == null ? null : catalog.moduleById(lesson.moduleId);
    if (lesson != null &&
        module != null &&
        progress.startedLessonIds.contains(lesson.id) &&
        !progress.completedLessonIds.contains(lesson.id) &&
        isLessonUnlocked(
          lesson: lesson,
          module: module,
          catalog: catalog,
          progress: progress,
        )) {
      unfinishedLesson = lesson;
    }
  }

  QuranWordEntry? lastWord;
  if (wordProgress.lastWordId != null) {
    for (final word in words) {
      if ((word.sharedBeginnerWordId ?? word.id) == wordProgress.lastWordId) {
        lastWord = word;
        break;
      }
    }
  }

  final hasReview = dailyReview.hasDueItems || dailyReview.inProgress;
  final reviewSuggestion = hasReview ? _adultReviewSuggestion() : null;
  final wordIsNewer =
      lastWord != null &&
      wordProgress.lastOpenedAt != null &&
      (progress.lastPracticedAt == null ||
          wordProgress.lastOpenedAt!.isAfter(progress.lastPracticedAt!));

  final suggestions = <ArabicLearningReviewSuggestion>[];
  final seen = <String>{};

  void addSuggestion(ArabicLearningReviewSuggestion? suggestion) {
    if (suggestion == null) {
      return;
    }
    final key =
        '${suggestion.target.kind.name}:${suggestion.target.canonicalItemId}';
    if (!seen.add(key)) {
      return;
    }
    suggestions.add(suggestion);
  }

  addSuggestion(
    unfinishedLesson == null
        ? null
        : _adultLessonSuggestion(
            lesson: unfinishedLesson,
            intent: ArabicLearningContinuationIntent.resume,
            lastTouchedAt: progress.lastPracticedAt,
          ),
  );
  if (wordIsNewer) {
    addSuggestion(
      _adultWordSuggestion(
        word: lastWord,
        intent: ArabicLearningContinuationIntent.resume,
        lastTouchedAt: wordProgress.lastOpenedAt,
      ),
    );
  }
  addSuggestion(reviewSuggestion);
  addSuggestion(
    recommendedLesson == null
        ? null
        : _adultLessonSuggestion(
            lesson: recommendedLesson,
            intent:
                progress.completedLessonIds.isEmpty &&
                    progress.startedLessonIds.isEmpty &&
                    lastWord == null
                ? ArabicLearningContinuationIntent.start
                : ArabicLearningContinuationIntent.continueForward,
          ),
  );
  if (!wordIsNewer && lastWord != null) {
    addSuggestion(
      _adultWordSuggestion(
        word: lastWord,
        intent: ArabicLearningContinuationIntent.review,
        lastTouchedAt: wordProgress.lastOpenedAt,
      ),
    );
  }

  if (suggestions.isEmpty) {
    final firstLesson = quranTeachingCatalog.lessons.first;
    suggestions.add(
      _adultLessonSuggestion(
        lesson: firstLesson,
        intent: ArabicLearningContinuationIntent.start,
      ),
    );
  }

  return ArabicLearningReviewSummary(
    audience: ArabicLearningAudience.adult,
    primarySuggestion: suggestions.first,
    secondarySuggestions: suggestions.skip(1).take(2).toList(growable: false),
  );
}

ArabicLearningReviewSuggestion _kidsStartSuggestion(KidsArabicLetter letter) {
  return ArabicLearningReviewSuggestion(
    audience: ArabicLearningAudience.kids,
    intent: ArabicLearningContinuationIntent.start,
    contentType: ArabicLearningContinuationContentType.letter,
    target: ArabicLearningRouteTarget(
      kind: ArabicLearningRouteTargetKind.goNamed,
      contentType: ArabicLearningContinuationContentType.letter,
      canonicalItemId: letter.id,
      routeName: 'kidsArabicLesson',
      pathParameters: <String, String>{'letterId': letter.id},
    ),
    itemId: letter.id,
    title: letter.nameEn,
    arabicText: letter.nameAr,
  );
}

ArabicLearningReviewSuggestion? _kidsSuggestionFromFocus(
  KidsArabicPracticeFocus? focus,
) {
  if (focus == null) {
    return null;
  }
  switch (focus.type) {
    case KidsArabicPracticeFocusType.dailyNewLetter:
    case KidsArabicPracticeFocusType.dailyTraceLetter:
    case KidsArabicPracticeFocusType.continueLetter:
      final letter = focus.letter!;
      return ArabicLearningReviewSuggestion(
        audience: ArabicLearningAudience.kids,
        intent: focus.type == KidsArabicPracticeFocusType.continueLetter
            ? ArabicLearningContinuationIntent.resume
            : ArabicLearningContinuationIntent.continueForward,
        contentType: ArabicLearningContinuationContentType.letter,
        target: ArabicLearningRouteTarget(
          kind: ArabicLearningRouteTargetKind.goNamed,
          contentType: ArabicLearningContinuationContentType.letter,
          canonicalItemId: letter.id,
          routeName: 'kidsArabicLesson',
          pathParameters: <String, String>{'letterId': letter.id},
        ),
        itemId: letter.id,
        title: letter.nameEn,
        arabicText: letter.nameAr,
      );
    case KidsArabicPracticeFocusType.dailyReviewLetter:
    case KidsArabicPracticeFocusType.reviewLetter:
      return _kidsLetterReviewSuggestion(focus.letter!);
    case KidsArabicPracticeFocusType.continueWord:
      final word = focus.word!;
      return ArabicLearningReviewSuggestion(
        audience: ArabicLearningAudience.kids,
        intent: ArabicLearningContinuationIntent.continueForward,
        contentType: ArabicLearningContinuationContentType.word,
        target: ArabicLearningRouteTarget(
          kind: ArabicLearningRouteTargetKind.goNamed,
          contentType: ArabicLearningContinuationContentType.word,
          canonicalItemId: word.id,
          routeName: 'kidsArabicWordLesson',
          pathParameters: <String, String>{'wordId': word.id},
        ),
        itemId: word.id,
        title: word.transliteration,
        arabicText: word.wordAr,
      );
    case KidsArabicPracticeFocusType.reviewWord:
      return _kidsWordReviewSuggestion(focus.word!);
  }
}

ArabicLearningReviewSuggestion _kidsLetterReviewSuggestion(
  KidsArabicLetter letter,
) {
  return ArabicLearningReviewSuggestion(
    audience: ArabicLearningAudience.kids,
    intent: ArabicLearningContinuationIntent.review,
    contentType: ArabicLearningContinuationContentType.review,
    target: const ArabicLearningRouteTarget(
      kind: ArabicLearningRouteTargetKind.goNamed,
      contentType: ArabicLearningContinuationContentType.review,
      canonicalItemId: 'kids_letter_review',
      routeName: 'kidsArabicReview',
    ),
    itemId: letter.id,
    title: letter.nameEn,
    arabicText: letter.nameAr,
  );
}

ArabicLearningReviewSuggestion _kidsWordReviewSuggestion(
  KidsArabicBeginnerWord word,
) {
  return ArabicLearningReviewSuggestion(
    audience: ArabicLearningAudience.kids,
    intent: ArabicLearningContinuationIntent.review,
    contentType: ArabicLearningContinuationContentType.word,
    target: ArabicLearningRouteTarget(
      kind: ArabicLearningRouteTargetKind.goNamed,
      contentType: ArabicLearningContinuationContentType.word,
      canonicalItemId: word.id,
      routeName: 'kidsArabicReadingMode',
      queryParameters: <String, String>{'word': word.id},
    ),
    itemId: word.id,
    title: word.transliteration,
    arabicText: word.wordAr,
  );
}

ArabicLearningReviewSuggestion? _kidsPhraseSuggestion({
  required KidsArabicMiniPhraseProgressState phraseProgress,
}) {
  final lastPhraseId = phraseProgress.lastPhraseId;
  if (lastPhraseId == null) {
    return null;
  }
  final phrase = kidsArabicMiniPhrases.firstWhere(
    (item) => item.id == lastPhraseId,
    orElse: () => kidsArabicMiniPhrases.first,
  );
  final heard = phraseProgress.heardPhraseIds.contains(phrase.id);
  return ArabicLearningReviewSuggestion(
    audience: ArabicLearningAudience.kids,
    intent: heard
        ? ArabicLearningContinuationIntent.review
        : ArabicLearningContinuationIntent.resume,
    contentType: ArabicLearningContinuationContentType.phrase,
    target: ArabicLearningRouteTarget(
      kind: ArabicLearningRouteTargetKind.goNamed,
      contentType: ArabicLearningContinuationContentType.phrase,
      canonicalItemId: phrase.id,
      routeName: 'kidsArabicMiniPhrases',
      queryParameters: <String, String>{'phrase': phrase.id},
    ),
    itemId: phrase.id,
    title: phrase.transliteration,
    arabicText: phrase.phraseAr,
  );
}

ArabicLearningReviewSuggestion _adultLessonSuggestion({
  required QuranTeachingLesson lesson,
  required ArabicLearningContinuationIntent intent,
  DateTime? lastTouchedAt,
}) {
  return ArabicLearningReviewSuggestion(
    audience: ArabicLearningAudience.adult,
    intent: intent,
    contentType: ArabicLearningContinuationContentType.lesson,
    target: ArabicLearningRouteTarget(
      kind: ArabicLearningRouteTargetKind.adultLesson,
      contentType: ArabicLearningContinuationContentType.lesson,
      canonicalItemId: lesson.id,
      lessonId: lesson.id,
      moduleId: lesson.moduleId,
    ),
    itemId: lesson.id,
    title: lesson.title,
    subtitle: lesson.subtitle,
    lastTouchedAt: lastTouchedAt,
  );
}

ArabicLearningReviewSuggestion _adultWordSuggestion({
  required QuranWordEntry word,
  required ArabicLearningContinuationIntent intent,
  DateTime? lastTouchedAt,
}) {
  return ArabicLearningReviewSuggestion(
    audience: ArabicLearningAudience.adult,
    intent: intent,
    contentType: ArabicLearningContinuationContentType.word,
    target: ArabicLearningRouteTarget(
      kind: ArabicLearningRouteTargetKind.adultBeginnerWords,
      contentType: ArabicLearningContinuationContentType.word,
      canonicalItemId: word.sharedBeginnerWordId ?? word.id,
      wordId: word.sharedBeginnerWordId ?? word.id,
    ),
    itemId: word.sharedBeginnerWordId ?? word.id,
    title: word.transliteration,
    subtitle: word.meaning,
    arabicText: word.arabic,
    lastTouchedAt: lastTouchedAt,
  );
}

ArabicLearningReviewSuggestion _adultReviewSuggestion() {
  return const ArabicLearningReviewSuggestion(
    audience: ArabicLearningAudience.adult,
    intent: ArabicLearningContinuationIntent.review,
    contentType: ArabicLearningContinuationContentType.review,
    target: ArabicLearningRouteTarget(
      kind: ArabicLearningRouteTargetKind.adultDailyReview,
      contentType: ArabicLearningContinuationContentType.review,
      canonicalItemId: 'adult_daily_review',
    ),
    itemId: 'adult_daily_review',
  );
}
