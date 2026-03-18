import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';
import '../domain/kids_arabic_models.dart';
import 'kids_arabic_progress_provider.dart';
import 'kids_arabic_progression.dart';

const kidsArabicParentPreferencesStorageKey =
    'kids.arabic.parent.preferences.v1';

final kidsArabicParentPreferencesProvider =
    StateNotifierProvider<
      KidsArabicParentPreferencesNotifier,
      KidsArabicParentPreferences
    >((ref) {
      return KidsArabicParentPreferencesNotifier(ref);
    });

final kidsArabicParentAvailableFocusLettersProvider =
    Provider<List<KidsArabicLetter>>((ref) {
      final progress = ref.watch(kidsArabicProgressProvider);
      return kidsArabicProgressionLetters
          .where(
            (letter) => isKidsArabicLetterUnlocked(
              letterId: letter.id,
              completedLetterIds: progress.completedLetterIds,
            ),
          )
          .toList(growable: false);
    });

final kidsArabicParentAvailableReviewLettersProvider =
    Provider<List<KidsArabicLetter>>((ref) {
      final progress = ref.watch(kidsArabicProgressProvider);
      return kidsArabicProgressionLetters
          .where((letter) => progress.completedLetterIds.contains(letter.id))
          .toList(growable: false);
    });

final kidsArabicParentRecommendedActivityProvider =
    Provider<KidsArabicRecommendedActivity?>((ref) {
      final preferences = ref.watch(kidsArabicParentPreferencesProvider);
      final progress = ref.watch(kidsArabicProgressProvider);
      final dailyMission = ref.watch(kidsArabicDailyMissionProvider);
      final unlockedFocus = ref.watch(
        kidsArabicParentAvailableFocusLettersProvider,
      );
      final reviewLetters = ref.watch(
        kidsArabicParentAvailableReviewLettersProvider,
      );

      final focusIds = unlockedFocus.map((item) => item.id).toSet();
      final reviewIds = reviewLetters.map((item) => item.id).toSet();

      final focusLetterId = preferences.allowParentAssignedFocus
          ? preferences.parentAssignedLetterId
          : null;
      if (focusLetterId != null && focusIds.contains(focusLetterId)) {
        return KidsArabicRecommendedActivity(
          source: KidsArabicRecommendedActivitySource.parentAssignedFocus,
          letterId: focusLetterId,
          opensReview: false,
        );
      }

      final reviewLetterId = preferences.prioritizeReview
          ? preferences.parentAssignedReviewLetterId
          : null;
      if (reviewLetterId != null && reviewIds.contains(reviewLetterId)) {
        return KidsArabicRecommendedActivity(
          source: KidsArabicRecommendedActivitySource.parentAssignedReview,
          letterId: reviewLetterId,
          opensReview: true,
        );
      }

      if (dailyMission != null) {
        return KidsArabicRecommendedActivity(
          source: KidsArabicRecommendedActivitySource.dailyMission,
          letterId: dailyMission.targetLetterId,
          opensReview: dailyMission.type == KidsArabicDailyMissionType.review,
        );
      }

      for (final letter in kidsArabicProgressionLetters) {
        if (!isKidsArabicLetterUnlocked(
          letterId: letter.id,
          completedLetterIds: progress.completedLetterIds,
        )) {
          continue;
        }
        final lessonCount =
            progress.progressByLetterId[letter.id]?.lessonsCompleted ?? 0;
        if (lessonCount == 0) {
          return KidsArabicRecommendedActivity(
            source: KidsArabicRecommendedActivitySource.nextUnlockedLesson,
            letterId: letter.id,
            opensReview: false,
          );
        }
      }

      return null;
    });

final kidsArabicParentSummaryProvider = Provider<KidsArabicParentSummary>((
  ref,
) {
  final preferences = ref.watch(kidsArabicParentPreferencesProvider);
  final progress = ref.watch(kidsArabicProgressProvider);
  final daily = ref.watch(kidsArabicDailyProgressProvider);
  final recommendation = ref.watch(kidsArabicParentRecommendedActivityProvider);
  final now = ref.watch(kidsArabicNowProvider)();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final completionHistory = daily.completionDayKeys.toSet();

  final weeklyConsistency = List<KidsArabicWeeklyConsistencyDay>.generate(7, (
    index,
  ) {
    final date = startOfWeek.add(Duration(days: index));
    final dayKey = LocalStore.todayKey(date);
    return KidsArabicWeeklyConsistencyDay(
      dayKey: dayKey,
      weekday: date.weekday,
      completed: completionHistory.contains(dayKey),
    );
  }, growable: false);

  return KidsArabicParentSummary(
    lettersCompleted: progress.completedLetterIds.length,
    lessonsCompleted: progress.totalLessonsDone,
    currentStreak: daily.currentStreak,
    bestStreak: daily.bestStreak,
    activeDaysThisWeek: daily.weeklyCompletions,
    reviewNeededLetterIds: progress.reviewNeededLetterIds.toList(
      growable: false,
    ),
    latestCompletedLetterId: progress.lastLessonLetterId,
    recommendedNextLetterId: recommendation?.letterId,
    assignedFocusLetterId: preferences.allowParentAssignedFocus
        ? preferences.parentAssignedLetterId
        : null,
    weeklyCompletionCount: daily.weeklyCompletions,
    earnedStickerCount: progress.earnedStickerIds.length,
    weeklyConsistency: weeklyConsistency,
  );
});

final kidsArabicParentReviewLetterProvider = Provider<KidsArabicLetter?>((ref) {
  final preferences = ref.watch(kidsArabicParentPreferencesProvider);
  if (!preferences.prioritizeReview) return null;
  final reviewLetters = ref.watch(
    kidsArabicParentAvailableReviewLettersProvider,
  );
  for (final letter in reviewLetters) {
    if (letter.id == preferences.parentAssignedReviewLetterId) {
      return letter;
    }
  }
  return null;
});

class KidsArabicParentPreferencesNotifier
    extends StateNotifier<KidsArabicParentPreferences> {
  KidsArabicParentPreferencesNotifier(Ref ref)
    : _store = ref.read(localStoreProvider),
      super(KidsArabicParentPreferences.initial()) {
    _load();
  }

  final LocalStore _store;

  void _load() {
    state = KidsArabicParentPreferences.fromJson(
      _store.getJsonMap(kidsArabicParentPreferencesStorageKey),
    );
  }

  void _save() {
    _store.setJsonMap(kidsArabicParentPreferencesStorageKey, state.toJson());
  }

  void setGuidedProgressionEnabled(bool value) {
    state = state.copyWith(guidedProgressionEnabled: value);
    _save();
  }

  void setPrioritizeReview(bool value) {
    state = state.copyWith(prioritizeReview: value);
    _save();
  }

  void setShowTransliteration(bool value) {
    state = state.copyWith(showTransliteration: value);
    _save();
  }

  void setAudioAutoplay(bool value) {
    state = state.copyWith(audioAutoplay: value);
    _save();
  }

  void setAllowParentAssignedFocus(bool value) {
    state = state.copyWith(allowParentAssignedFocus: value);
    _save();
  }

  void setLessonSupportLevel(KidsArabicLessonSupportLevel value) {
    state = state.copyWith(lessonSupportLevel: value);
    _save();
  }

  bool assignFocusLetter(
    String? letterId, {
    required Set<String> validLetterIds,
  }) {
    if (letterId != null && !validLetterIds.contains(letterId)) {
      return false;
    }
    state = state.copyWith(
      parentAssignedLetterId: letterId,
      clearParentAssignedLetterId: letterId == null,
    );
    _save();
    return true;
  }

  bool assignReviewLetter(
    String? letterId, {
    required Set<String> validLetterIds,
  }) {
    if (letterId != null && !validLetterIds.contains(letterId)) {
      return false;
    }
    state = state.copyWith(
      parentAssignedReviewLetterId: letterId,
      clearParentAssignedReviewLetterId: letterId == null,
    );
    _save();
    return true;
  }
}
