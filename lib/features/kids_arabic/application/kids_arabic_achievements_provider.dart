import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';
import '../domain/kids_arabic_achievement_models.dart';
import '../domain/kids_arabic_models.dart';
import '../domain/kids_arabic_word_models.dart';
import 'kids_arabic_progress_provider.dart';
import 'kids_arabic_words_provider.dart';

String kidsArabicAchievementsUiStorageKeyForLearner(String learnerId) =>
    'kids.arabic.achievements.ui.v1.$learnerId';

final kidsArabicAchievementsUiProvider =
    StateNotifierProvider<
      KidsArabicAchievementsUiNotifier,
      KidsArabicAchievementUiState
    >((ref) {
      final notifier = KidsArabicAchievementsUiNotifier(ref);
      ref.listen<String>(
        kidsArabicActiveLearnerProvider.select((value) => value.learnerId),
        (_, nextLearnerId) => notifier.updateActiveLearner(nextLearnerId),
      );
      return notifier;
    });

final kidsArabicUnlockedAchievementIdsProvider = Provider<Set<String>>((ref) {
  final progress = ref.watch(kidsArabicProgressProvider);
  final wordProgress = ref.watch(kidsArabicWordProgressProvider);
  return _deriveUnlockedAchievementIds(
    progress: progress,
    wordProgress: wordProgress,
  );
});

final kidsArabicAchievementStatusesProvider =
    Provider<List<KidsArabicAchievementStatus>>((ref) {
      final unlockedIds = ref.watch(kidsArabicUnlockedAchievementIdsProvider);
      final latest = ref.watch(kidsArabicLatestAchievementProvider);
      return kidsArabicAchievementDefinitions
          .map(
            (definition) => KidsArabicAchievementStatus(
              definition: definition,
              unlocked: unlockedIds.contains(definition.id),
              isLatest: latest?.id == definition.id,
            ),
          )
          .toList(growable: false);
    });

final kidsArabicLatestAchievementProvider =
    Provider<KidsArabicAchievementDefinition?>((ref) {
      final unlockedIds = ref.watch(kidsArabicUnlockedAchievementIdsProvider);
      KidsArabicAchievementDefinition? latest;
      for (final definition in kidsArabicAchievementDefinitions) {
        if (!unlockedIds.contains(definition.id)) {
          continue;
        }
        latest = definition;
      }
      return latest;
    });

final kidsArabicAchievementCelebrationProvider =
    Provider<KidsArabicAchievementDefinition?>((ref) {
      final unlockedIds = ref.watch(kidsArabicUnlockedAchievementIdsProvider);
      final uiState = ref.watch(kidsArabicAchievementsUiProvider);
      KidsArabicAchievementDefinition? latestUnseen;
      for (final definition in kidsArabicAchievementDefinitions) {
        if (!unlockedIds.contains(definition.id) ||
            uiState.seenCelebrationIds.contains(definition.id)) {
          continue;
        }
        latestUnseen = definition;
      }
      return latestUnseen;
    });

final kidsArabicAchievementSummaryProvider =
    Provider<KidsArabicAchievementSummary>((ref) {
      final progress = ref.watch(kidsArabicProgressProvider);
      final wordProgress = ref.watch(kidsArabicWordProgressProvider);
      final unlockedIds = ref.watch(kidsArabicUnlockedAchievementIdsProvider);
      var badgesUnlocked = 0;
      var milestonesUnlocked = 0;
      for (final definition in kidsArabicAchievementDefinitions) {
        if (!unlockedIds.contains(definition.id)) {
          continue;
        }
        if (definition.kind == KidsArabicAchievementKind.badge) {
          badgesUnlocked += 1;
        } else {
          milestonesUnlocked += 1;
        }
      }
      return KidsArabicAchievementSummary(
        badgesUnlocked: badgesUnlocked,
        milestonesUnlocked: milestonesUnlocked,
        lettersCompleted: progress.completedLetterIds.length,
        wordsCompleted: wordProgress.completedWordIds.length,
        latestAchievement: ref.watch(kidsArabicLatestAchievementProvider),
      );
    });

final kidsArabicMilestoneStatusesProvider =
    Provider<List<KidsArabicAchievementStatus>>((ref) {
      return ref
          .watch(kidsArabicAchievementStatusesProvider)
          .where(
            (status) =>
                status.definition.kind == KidsArabicAchievementKind.milestone,
          )
          .toList(growable: false);
    });

class KidsArabicAchievementsUiNotifier
    extends StateNotifier<KidsArabicAchievementUiState> {
  KidsArabicAchievementsUiNotifier(Ref ref)
    : _store = ref.read(localStoreProvider),
      _activeLearnerId = ref.read(kidsArabicActiveLearnerProvider).learnerId,
      super(
        KidsArabicAchievementUiState.fromJson(
          ref
              .read(localStoreProvider)
              .getJsonMap(
                kidsArabicAchievementsUiStorageKeyForLearner(
                  ref.read(kidsArabicActiveLearnerProvider).learnerId,
                ),
              ),
        ),
      );

  final LocalStore _store;
  String _activeLearnerId;

  void _save() {
    _store.setJsonMap(
      kidsArabicAchievementsUiStorageKeyForLearner(_activeLearnerId),
      state.toJson(),
    );
  }

  void updateActiveLearner(String learnerId) {
    if (_activeLearnerId == learnerId) {
      return;
    }
    _activeLearnerId = learnerId;
    state = KidsArabicAchievementUiState.fromJson(
      _store.getJsonMap(
        kidsArabicAchievementsUiStorageKeyForLearner(learnerId),
      ),
    );
  }

  void markCelebrationSeen(String achievementId) {
    if (state.seenCelebrationIds.contains(achievementId)) {
      return;
    }
    state = state.copyWith(
      seenCelebrationIds: Set<String>.from(state.seenCelebrationIds)
        ..add(achievementId),
    );
    _save();
  }
}

Set<String> _deriveUnlockedAchievementIds({
  required KidsArabicProgressState progress,
  required KidsArabicWordProgressState wordProgress,
}) {
  final unlocked = Set<String>.from(progress.earnedStickerIds);
  final completedLetters = progress.completedLetterIds.length;
  final completedWords = wordProgress.completedWordIds.length;

  if (completedLetters >= 3) {
    unlocked.add('three-letters');
  }
  if (completedWords >= 1) {
    unlocked.add('first-word');
  }
  if (progress.totalReviewRoundsDone >= 1) {
    unlocked.add('first-review');
  }
  if (completedWords >= 3) {
    unlocked.add('beginner-word-set');
  }
  return unlocked;
}
