import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../kids_arabic/application/kids_arabic_phrases_provider.dart';
import '../../kids_arabic/application/kids_arabic_progress_provider.dart';
import '../../kids_arabic/application/kids_arabic_words_provider.dart';
import '../../kids_arabic/data/kids_arabic_letters_data.dart';
import '../../kids_arabic/domain/kids_arabic_models.dart';
import '../../kids_arabic/domain/kids_arabic_phrase_models.dart';
import '../../kids_arabic/domain/kids_arabic_word_models.dart';
import '../../learn/quran/application/quran_readiness_bridge_provider.dart';
import '../../learn/quran/domain/quran_readiness_bridge_models.dart';
import '../../learn/quran_teaching/application/quran_teaching_controller.dart';
import '../../learn/quran_teaching/domain/quran_teaching_models.dart';
import '../data/arabic_alphabet_catalog.dart';
import '../domain/arabic_learning_continuity_models.dart';
import '../domain/arabic_learning_progress_models.dart';
import 'arabic_learning_continuity_provider.dart';
import 'arabic_learning_review_provider.dart';

final arabicLearningProgressSummaryProvider =
    Provider.family<ArabicLearningProgressSummary, ArabicLearningAudience>((
      ref,
      audience,
    ) {
      switch (audience) {
        case ArabicLearningAudience.kids:
          return _buildKidsSummary(ref);
        case ArabicLearningAudience.adult:
          return _buildAdultSummary(ref);
      }
    });

ArabicLearningProgressSummary _buildKidsSummary(Ref ref) {
  final progress = ref.watch(kidsArabicProgressProvider);
  final wordProgress = ref.watch(kidsArabicWordProgressProvider);
  final words = ref.watch(kidsArabicBeginnerWordsProvider);
  final phraseProgress = ref.watch(kidsArabicMiniPhraseProgressProvider);
  final phrases = ref.watch(kidsArabicMiniPhrasesProvider);
  final continuation = ref.watch(
    arabicLearningContinuationProvider(ArabicLearningAudience.kids),
  );
  final review = ref.watch(
    arabicLearningReviewProvider(ArabicLearningAudience.kids),
  );

  final recentActivity = _kidsRecentActivity(
    progress: progress,
    wordProgress: wordProgress,
    words: words,
    phraseProgress: phraseProgress,
    phrases: phrases,
  );

  return ArabicLearningProgressSummary(
    audience: ArabicLearningAudience.kids,
    hasStarted:
        progress.totalLessonsDone > 0 ||
        wordProgress.totalWordLessonsDone > 0 ||
        phraseProgress.heardPhraseIds.isNotEmpty,
    totalLetters: kidsArabicLetters.length,
    engagedLetters: progress.completedLetterIds.length,
    totalWords: words.length,
    engagedWords: wordProgress.completedWordIds.length,
    totalPhrases: phrases.length,
    engagedPhrases: phraseProgress.heardPhraseIds.length,
    currentStreakDays: progress.localCurrentStreakDays,
    recentActivity: recentActivity,
    continuation: continuation,
    reviewSuggestion: _resolveSecondaryReview(
      continuation: continuation,
      review: review,
    ),
  );
}

ArabicLearningProgressSummary _buildAdultSummary(Ref ref) {
  final catalog = ref.watch(quranTeachingCatalogProvider);
  final progress = ref.watch(quranTeachingProgressProvider);
  final words = ref.watch(quranTeachingBeginnerWordsProvider);
  final wordProgress = ref.watch(quranTeachingBeginnerWordsProgressProvider);
  final bridgeProgress = ref.watch(
    quranReadinessBridgeProgressProvider(ArabicLearningAudience.adult),
  );
  final bridgeSnippets = ref.watch(quranReadinessBridgeSnippetsProvider);
  final continuation = ref.watch(
    arabicLearningContinuationProvider(ArabicLearningAudience.adult),
  );
  final review = ref.watch(
    arabicLearningReviewProvider(ArabicLearningAudience.adult),
  );

  final completedLetters = _adultCompletedLetterIds(
    catalog: catalog,
    completedLessonIds: progress.completedLessonIds,
  );

  return ArabicLearningProgressSummary(
    audience: ArabicLearningAudience.adult,
    hasStarted:
        progress.startedLessonIds.isNotEmpty ||
        progress.completedLessonIds.isNotEmpty ||
        wordProgress.lastWordId != null ||
        bridgeProgress.openedSnippetIds.isNotEmpty,
    totalLetters: arabicAlphabetCatalog.length,
    engagedLetters: completedLetters.length,
    totalWords: words.length,
    engagedWords: wordProgress.lastWordId == null ? 0 : 1,
    totalPhrases: bridgeSnippets.length,
    engagedPhrases: bridgeProgress.openedSnippetIds.length,
    completedLessons: progress.completedLessonIds.length,
    totalLessons: catalog.lessons.length,
    recentActivity: _adultRecentActivity(
      catalog: catalog,
      progress: progress,
      words: words,
      wordProgress: wordProgress,
      bridgeProgress: bridgeProgress,
      bridgeSnippets: bridgeSnippets,
    ),
    continuation: continuation,
    reviewSuggestion: _resolveSecondaryReview(
      continuation: continuation,
      review: review,
    ),
  );
}

ArabicLearningReviewSuggestion? _resolveSecondaryReview({
  required ArabicLearningContinuationSummary continuation,
  required ArabicLearningReviewSummary review,
}) {
  if (review.primarySuggestion.intent ==
          ArabicLearningContinuationIntent.review &&
      review.primarySuggestion.target.canonicalItemId !=
          continuation.primaryTarget.canonicalItemId) {
    return review.primarySuggestion;
  }
  for (final suggestion in review.secondarySuggestions) {
    if (suggestion.intent == ArabicLearningContinuationIntent.review) {
      return suggestion;
    }
  }
  return null;
}

ArabicLearningRecentActivity? _kidsRecentActivity({
  required KidsArabicProgressState progress,
  required KidsArabicWordProgressState wordProgress,
  required List<KidsArabicBeginnerWord> words,
  required KidsArabicMiniPhraseProgressState phraseProgress,
  required List<KidsArabicMiniPhrase> phrases,
}) {
  if (phraseProgress.lastPhraseId != null) {
    final phrase = phrases
        .where((item) => item.id == phraseProgress.lastPhraseId)
        .firstOrNull;
    if (phrase != null) {
      return ArabicLearningRecentActivity(
        contentType: ArabicLearningContinuationContentType.phrase,
        itemId: phrase.id,
        title: phrase.transliteration,
        arabicText: phrase.phraseAr,
      );
    }
  }
  if (wordProgress.lastWordId != null) {
    final word = words
        .where((item) => item.id == wordProgress.lastWordId)
        .firstOrNull;
    if (word != null) {
      return ArabicLearningRecentActivity(
        contentType: ArabicLearningContinuationContentType.word,
        itemId: word.id,
        title: word.transliteration,
        arabicText: word.wordAr,
      );
    }
  }
  if (progress.lastLessonLetterId != null) {
    final letter = kidsArabicLetters
        .where((item) => item.id == progress.lastLessonLetterId)
        .firstOrNull;
    if (letter != null) {
      return ArabicLearningRecentActivity(
        contentType: ArabicLearningContinuationContentType.letter,
        itemId: letter.id,
        title: letter.nameEn,
        arabicText: letter.glyph,
        occurredAt: progress.lastLessonDayKey == null
            ? null
            : DateTime.tryParse('${progress.lastLessonDayKey!}T00:00:00'),
      );
    }
  }
  return null;
}

Set<String> _adultCompletedLetterIds({
  required QuranTeachingCatalog catalog,
  required List<String> completedLessonIds,
}) {
  final ids = <String>{};
  for (final lessonId in completedLessonIds) {
    final lesson = catalog.lessonById(lessonId);
    if (lesson == null) {
      continue;
    }
    for (final step in lesson.steps) {
      final letter = arabicAlphabetLetterByQuranTeachingSeedId(step.id);
      if (letter != null) {
        ids.add(letter.id);
      }
    }
  }
  return ids;
}

ArabicLearningRecentActivity? _adultRecentActivity({
  required QuranTeachingCatalog catalog,
  required QuranTeachingProgressState progress,
  required List<QuranWordEntry> words,
  required QuranTeachingBeginnerWordsProgressState wordProgress,
  required QuranReadinessBridgeProgressState bridgeProgress,
  required List<QuranReadinessBridgeSnippet> bridgeSnippets,
}) {
  ArabicLearningRecentActivity? best;

  void consider(ArabicLearningRecentActivity? candidate) {
    if (candidate == null) {
      return;
    }
    if (best == null) {
      best = candidate;
      return;
    }
    final bestTime = best!.occurredAt;
    final candidateTime = candidate.occurredAt;
    if (candidateTime != null &&
        (bestTime == null || candidateTime.isAfter(bestTime))) {
      best = candidate;
    }
  }

  if (progress.lastLessonId != null) {
    final lesson = catalog.lessonById(progress.lastLessonId!);
    if (lesson != null) {
      consider(
        ArabicLearningRecentActivity(
          contentType: ArabicLearningContinuationContentType.lesson,
          itemId: lesson.id,
          title: lesson.title,
          occurredAt: progress.lastPracticedAt,
        ),
      );
    }
  }

  if (wordProgress.lastWordId != null) {
    final word = words
        .where(
          (item) =>
              (item.sharedBeginnerWordId ?? item.id) == wordProgress.lastWordId,
        )
        .firstOrNull;
    if (word != null) {
      consider(
        ArabicLearningRecentActivity(
          contentType: ArabicLearningContinuationContentType.word,
          itemId: word.sharedBeginnerWordId ?? word.id,
          title: word.transliteration,
          arabicText: word.arabic,
          occurredAt: wordProgress.lastOpenedAt,
        ),
      );
    }
  }

  if (bridgeProgress.lastSnippetId != null) {
    final snippet = bridgeSnippets
        .where((item) => item.id == bridgeProgress.lastSnippetId)
        .firstOrNull;
    if (snippet != null) {
      consider(
        ArabicLearningRecentActivity(
          contentType: ArabicLearningContinuationContentType.phrase,
          itemId: snippet.id,
          title: snippet.transliteration,
          arabicText: snippet.snippetArabic,
          occurredAt: bridgeProgress.lastOpenedAt,
        ),
      );
    }
  }

  return best;
}
