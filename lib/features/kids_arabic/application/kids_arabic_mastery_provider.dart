import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/kids_arabic_models.dart';
import 'kids_arabic_progress_provider.dart';

enum KidsArabicMasteryState { notStarted, practicing, completed }

enum KidsArabicMasteryRecommendationType {
  continueSequence,
  reviewLetter,
  celebrateProgress,
}

class KidsArabicMasteryLetterStatus {
  const KidsArabicMasteryLetterStatus({
    required this.letter,
    required this.state,
    required this.reviewRecommended,
    required this.isUnlocked,
    required this.isNextRecommended,
  });

  final KidsArabicLetter letter;
  final KidsArabicMasteryState state;
  final bool reviewRecommended;
  final bool isUnlocked;
  final bool isNextRecommended;
}

class KidsArabicMasterySummary {
  const KidsArabicMasterySummary({
    required this.totalLetters,
    required this.completedCount,
    required this.practicingCount,
    required this.reviewCount,
  });

  final int totalLetters;
  final int completedCount;
  final int practicingCount;
  final int reviewCount;
}

class KidsArabicMasteryRecommendation {
  const KidsArabicMasteryRecommendation({
    required this.type,
    required this.letter,
  });

  final KidsArabicMasteryRecommendationType type;
  final KidsArabicLetter letter;
}

final kidsArabicMasteryStatusesProvider =
    Provider<List<KidsArabicMasteryLetterStatus>>((ref) {
      final orderedLetters = ref.watch(kidsArabicProgressionLettersProvider);
      final progress = ref.watch(kidsArabicProgressProvider);
      final unlockedLetterIds = ref.watch(kidsArabicUnlockedLetterIdsProvider);
      final practicingLetterId = orderedLetters
          .where((letter) => unlockedLetterIds.contains(letter.id))
          .map((letter) => letter.id)
          .firstWhere(
            (letterId) => !progress.completedLetterIds.contains(letterId),
            orElse: () => '',
          );
      final reviewNeeded = progress.reviewNeededLetterIds;
      return orderedLetters
          .map(
            (letter) => KidsArabicMasteryLetterStatus(
              letter: letter,
              state: progress.completedLetterIds.contains(letter.id)
                  ? KidsArabicMasteryState.completed
                  : unlockedLetterIds.contains(letter.id)
                  ? KidsArabicMasteryState.practicing
                  : KidsArabicMasteryState.notStarted,
              reviewRecommended: reviewNeeded.contains(letter.id),
              isUnlocked: unlockedLetterIds.contains(letter.id),
              isNextRecommended: letter.id == practicingLetterId,
            ),
          )
          .toList(growable: false);
    });

final kidsArabicMasterySummaryProvider = Provider<KidsArabicMasterySummary>((
  ref,
) {
  final statuses = ref.watch(kidsArabicMasteryStatusesProvider);
  return KidsArabicMasterySummary(
    totalLetters: statuses.length,
    completedCount: statuses
        .where((item) => item.state == KidsArabicMasteryState.completed)
        .length,
    practicingCount: statuses
        .where((item) => item.state == KidsArabicMasteryState.practicing)
        .length,
    reviewCount: statuses.where((item) => item.reviewRecommended).length,
  );
});

final kidsArabicReviewCandidatesProvider = Provider<List<KidsArabicLetter>>((
  ref,
) {
  final statuses = ref.watch(kidsArabicMasteryStatusesProvider);
  return statuses
      .where((item) => item.reviewRecommended)
      .map((item) => item.letter)
      .toList(growable: false);
});

final kidsArabicNextRecommendedLetterProvider = Provider<KidsArabicLetter?>((
  ref,
) {
  final recommendation = ref.watch(kidsArabicMasteryRecommendationProvider);
  return recommendation?.letter;
});

final kidsArabicMasteryRecommendationProvider =
    Provider<KidsArabicMasteryRecommendation?>((ref) {
      final statuses = ref.watch(kidsArabicMasteryStatusesProvider);
      KidsArabicLetter? reviewCandidate;
      for (final item in statuses) {
        if (item.reviewRecommended) {
          reviewCandidate = item.letter;
          break;
        }
      }
      if (reviewCandidate != null) {
        return KidsArabicMasteryRecommendation(
          type: KidsArabicMasteryRecommendationType.reviewLetter,
          letter: reviewCandidate,
        );
      }

      KidsArabicLetter? nextLetter;
      for (final item in statuses) {
        if (item.isNextRecommended) {
          nextLetter = item.letter;
          break;
        }
      }
      if (nextLetter != null) {
        return KidsArabicMasteryRecommendation(
          type: KidsArabicMasteryRecommendationType.continueSequence,
          letter: nextLetter,
        );
      }

      KidsArabicLetter? lastCompleted;
      for (final item in statuses) {
        if (item.state == KidsArabicMasteryState.completed) {
          lastCompleted = item.letter;
        }
      }
      if (lastCompleted == null) {
        return null;
      }
      return KidsArabicMasteryRecommendation(
        type: KidsArabicMasteryRecommendationType.celebrateProgress,
        letter: lastCompleted,
      );
    });
