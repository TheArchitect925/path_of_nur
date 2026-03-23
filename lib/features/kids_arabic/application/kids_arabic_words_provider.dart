import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';
import '../data/kids_arabic_beginner_words_data.dart';
import '../domain/kids_arabic_word_models.dart';
import 'kids_arabic_progress_provider.dart';

String kidsArabicWordProgressStorageKeyForLearner(String learnerId) =>
    'kids.arabic.words.v1.$learnerId';

class KidsArabicWordStatus {
  const KidsArabicWordStatus({
    required this.word,
    required this.unlocked,
    required this.completed,
    required this.isNextRecommended,
  });

  final KidsArabicBeginnerWord word;
  final bool unlocked;
  final bool completed;
  final bool isNextRecommended;
}

final kidsArabicBeginnerWordsProvider = Provider<List<KidsArabicBeginnerWord>>((
  ref,
) {
  return kidsArabicBeginnerWords;
});

final kidsArabicWordProgressProvider =
    StateNotifierProvider<
      KidsArabicWordProgressNotifier,
      KidsArabicWordProgressState
    >((ref) {
      final notifier = KidsArabicWordProgressNotifier(ref);
      ref.listen<String>(
        kidsArabicActiveLearnerProvider.select((value) => value.learnerId),
        (_, nextLearnerId) => notifier.updateActiveLearner(nextLearnerId),
      );
      return notifier;
    });

final kidsArabicWordStatusesProvider = Provider<List<KidsArabicWordStatus>>((
  ref,
) {
  final words = ref.watch(kidsArabicBeginnerWordsProvider);
  final progress = ref.watch(kidsArabicWordProgressProvider);
  final completedLetters = ref
      .watch(kidsArabicProgressProvider)
      .completedLetterIds;
  String? nextRecommendedId;
  for (final word in words) {
    final unlocked = completedLetters.containsAll(
      word.requiredCompletedLetterIds,
    );
    if (unlocked && !progress.completedWordIds.contains(word.id)) {
      nextRecommendedId = word.id;
      break;
    }
  }
  return words
      .map(
        (word) => KidsArabicWordStatus(
          word: word,
          unlocked: completedLetters.containsAll(
            word.requiredCompletedLetterIds,
          ),
          completed: progress.completedWordIds.contains(word.id),
          isNextRecommended: nextRecommendedId == word.id,
        ),
      )
      .toList(growable: false);
});

final kidsArabicNextRecommendedWordProvider = Provider<KidsArabicBeginnerWord?>(
  (ref) {
    final statuses = ref.watch(kidsArabicWordStatusesProvider);
    for (final status in statuses) {
      if (status.isNextRecommended) {
        return status.word;
      }
    }
    return null;
  },
);

final kidsArabicUnlockedWordsProvider = Provider<List<KidsArabicBeginnerWord>>((
  ref,
) {
  return ref
      .watch(kidsArabicWordStatusesProvider)
      .where((status) => status.unlocked)
      .map((status) => status.word)
      .toList(growable: false);
});

final kidsArabicReadingRecommendedWordProvider =
    Provider<KidsArabicBeginnerWord?>((ref) {
      final nextRecommended = ref.watch(kidsArabicNextRecommendedWordProvider);
      if (nextRecommended != null) {
        return nextRecommended;
      }

      final unlockedWords = ref.watch(kidsArabicUnlockedWordsProvider);
      if (unlockedWords.isEmpty) {
        return null;
      }

      final progress = ref.watch(kidsArabicWordProgressProvider);
      if (progress.lastWordId != null) {
        for (final word in unlockedWords) {
          if (word.id == progress.lastWordId) {
            return word;
          }
        }
      }

      return unlockedWords.first;
    });

final kidsArabicCompletedWordsCountProvider = Provider<int>((ref) {
  return ref.watch(kidsArabicWordProgressProvider).completedWordIds.length;
});

class KidsArabicWordProgressNotifier
    extends StateNotifier<KidsArabicWordProgressState> {
  KidsArabicWordProgressNotifier(Ref ref)
    : _store = ref.read(localStoreProvider),
      _activeLearnerId = ref.read(kidsArabicActiveLearnerProvider).learnerId,
      super(
        KidsArabicWordProgressState.fromJson(
          ref
              .read(localStoreProvider)
              .getJsonMap(
                kidsArabicWordProgressStorageKeyForLearner(
                  ref.read(kidsArabicActiveLearnerProvider).learnerId,
                ),
              ),
        ),
      );

  final LocalStore _store;
  String _activeLearnerId;

  void _save() {
    _store.setJsonMap(
      kidsArabicWordProgressStorageKeyForLearner(_activeLearnerId),
      state.toJson(),
    );
  }

  void updateActiveLearner(String learnerId) {
    if (_activeLearnerId == learnerId) {
      return;
    }
    _activeLearnerId = learnerId;
    state = KidsArabicWordProgressState.fromJson(
      _store.getJsonMap(kidsArabicWordProgressStorageKeyForLearner(learnerId)),
    );
  }

  void completeWord(String wordId) {
    final nextCompleted = Set<String>.from(state.completedWordIds)..add(wordId);
    state = state.copyWith(
      completedWordIds: nextCompleted,
      totalWordLessonsDone: state.totalWordLessonsDone + 1,
      lastWordId: wordId,
    );
    _save();
  }
}
