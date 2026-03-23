import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/kids_arabic_letters_data.dart';
import '../domain/kids_arabic_models.dart';
import '../domain/kids_arabic_word_models.dart';
import 'kids_arabic_mastery_provider.dart';
import 'kids_arabic_progress_provider.dart';
import 'kids_arabic_words_provider.dart';

enum KidsArabicPracticeFocusType {
  dailyNewLetter,
  dailyReviewLetter,
  dailyTraceLetter,
  continueLetter,
  continueWord,
  reviewLetter,
  reviewWord,
}

class KidsArabicPracticeFocus {
  const KidsArabicPracticeFocus({required this.type, this.letter, this.word});

  final KidsArabicPracticeFocusType type;
  final KidsArabicLetter? letter;
  final KidsArabicBeginnerWord? word;
}

class KidsArabicPracticePlan {
  const KidsArabicPracticePlan({
    required this.primaryFocus,
    required this.continueLetter,
    required this.continueWord,
    required this.reviewLetters,
    required this.reviewWords,
    required this.practicedToday,
    required this.completedLettersCount,
    required this.completedWordsCount,
  });

  final KidsArabicPracticeFocus? primaryFocus;
  final KidsArabicLetter? continueLetter;
  final KidsArabicBeginnerWord? continueWord;
  final List<KidsArabicLetter> reviewLetters;
  final List<KidsArabicBeginnerWord> reviewWords;
  final bool practicedToday;
  final int completedLettersCount;
  final int completedWordsCount;
}

final kidsArabicContinueLetterProvider = Provider<KidsArabicLetter?>((ref) {
  final statuses = ref.watch(kidsArabicMasteryStatusesProvider);
  for (final status in statuses) {
    if (status.state == KidsArabicMasteryState.practicing &&
        status.isUnlocked) {
      return status.letter;
    }
  }
  return null;
});

final kidsArabicContinueWordProvider = Provider<KidsArabicBeginnerWord?>((ref) {
  final unlockedWords = ref.watch(kidsArabicUnlockedWordsProvider);
  if (unlockedWords.isEmpty) {
    return null;
  }

  final progress = ref.watch(kidsArabicWordProgressProvider);
  final completedIds = progress.completedWordIds;
  final incompleteUnlocked = unlockedWords
      .where((word) => !completedIds.contains(word.id))
      .toList(growable: false);
  if (incompleteUnlocked.isEmpty) {
    return null;
  }

  final lastWordId = progress.lastWordId;
  if (lastWordId != null) {
    for (final word in incompleteUnlocked) {
      if (word.id == lastWordId) {
        return word;
      }
    }
  }

  return incompleteUnlocked.first;
});

final kidsArabicReviewWordCandidatesProvider =
    Provider<List<KidsArabicBeginnerWord>>((ref) {
      final words = ref.watch(kidsArabicBeginnerWordsProvider);
      final progress = ref.watch(kidsArabicWordProgressProvider);
      final lastWordId = progress.lastWordId;
      final completed = words
          .where((word) => progress.completedWordIds.contains(word.id))
          .toList(growable: false);
      if (completed.isEmpty || lastWordId == null) {
        return completed;
      }
      final prioritized = <KidsArabicBeginnerWord>[];
      for (final word in completed) {
        if (word.id == lastWordId) {
          prioritized.add(word);
        }
      }
      for (final word in completed) {
        if (word.id != lastWordId) {
          prioritized.add(word);
        }
      }
      return prioritized;
    });

final kidsArabicPracticePrimaryFocusProvider =
    Provider<KidsArabicPracticeFocus?>((ref) {
      final mission = ref.watch(kidsArabicDailyMissionProvider);
      final progress = ref.watch(kidsArabicProgressProvider);
      final practicedToday = progress.dailyProgress.todayMissionCompleted;
      final continueLetter = ref.watch(kidsArabicContinueLetterProvider);
      final continueWord = ref.watch(kidsArabicContinueWordProvider);
      final reviewLetters = ref.watch(kidsArabicReviewCandidatesProvider);
      final reviewWords = ref.watch(kidsArabicReviewWordCandidatesProvider);

      if (!practicedToday && mission != null) {
        final targetLetter = _letterById(mission.targetLetterId);
        switch (mission.type) {
          case KidsArabicDailyMissionType.newLetter:
            if (targetLetter != null) {
              return KidsArabicPracticeFocus(
                type: KidsArabicPracticeFocusType.dailyNewLetter,
                letter: targetLetter,
              );
            }
          case KidsArabicDailyMissionType.review:
            if (targetLetter != null) {
              return KidsArabicPracticeFocus(
                type: KidsArabicPracticeFocusType.dailyReviewLetter,
                letter: targetLetter,
              );
            }
          case KidsArabicDailyMissionType.tracePractice:
            if (targetLetter != null) {
              return KidsArabicPracticeFocus(
                type: KidsArabicPracticeFocusType.dailyTraceLetter,
                letter: targetLetter,
              );
            }
        }
      }

      if (continueLetter != null) {
        return KidsArabicPracticeFocus(
          type: KidsArabicPracticeFocusType.continueLetter,
          letter: continueLetter,
        );
      }
      if (continueWord != null) {
        return KidsArabicPracticeFocus(
          type: KidsArabicPracticeFocusType.continueWord,
          word: continueWord,
        );
      }
      if (reviewLetters.isNotEmpty) {
        return KidsArabicPracticeFocus(
          type: KidsArabicPracticeFocusType.reviewLetter,
          letter: reviewLetters.first,
        );
      }
      if (reviewWords.isNotEmpty) {
        return KidsArabicPracticeFocus(
          type: KidsArabicPracticeFocusType.reviewWord,
          word: reviewWords.first,
        );
      }
      return null;
    });

final kidsArabicPracticePlanProvider = Provider<KidsArabicPracticePlan>((ref) {
  final letterProgress = ref.watch(kidsArabicProgressProvider);
  final wordProgress = ref.watch(kidsArabicWordProgressProvider);
  return KidsArabicPracticePlan(
    primaryFocus: ref.watch(kidsArabicPracticePrimaryFocusProvider),
    continueLetter: ref.watch(kidsArabicContinueLetterProvider),
    continueWord: ref.watch(kidsArabicContinueWordProvider),
    reviewLetters: ref.watch(kidsArabicReviewCandidatesProvider),
    reviewWords: ref.watch(kidsArabicReviewWordCandidatesProvider),
    practicedToday: letterProgress.dailyProgress.todayMissionCompleted,
    completedLettersCount: letterProgress.completedLetterIds.length,
    completedWordsCount: wordProgress.completedWordIds.length,
  );
});

KidsArabicLetter? _letterById(String id) {
  for (final letter in kidsArabicLetters) {
    if (letter.id == id) {
      return letter;
    }
  }
  return null;
}
