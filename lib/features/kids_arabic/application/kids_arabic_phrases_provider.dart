import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';
import '../data/kids_arabic_mini_phrases_data.dart';
import '../domain/kids_arabic_phrase_models.dart';
import 'kids_arabic_progress_provider.dart';

String kidsArabicMiniPhraseProgressStorageKeyForLearner(String learnerId) =>
    'kids.arabic.mini_phrases.v1.$learnerId';

final kidsArabicMiniPhrasesProvider = Provider<List<KidsArabicMiniPhrase>>((ref) {
  return kidsArabicMiniPhrases;
});

final kidsArabicMiniPhraseProgressProvider = StateNotifierProvider<
    KidsArabicMiniPhraseProgressNotifier, KidsArabicMiniPhraseProgressState>((ref) {
  final notifier = KidsArabicMiniPhraseProgressNotifier(ref);
  ref.listen<String>(
    kidsArabicActiveLearnerProvider.select((value) => value.learnerId),
    (_, nextLearnerId) => notifier.updateActiveLearner(nextLearnerId),
  );
  return notifier;
});

final kidsArabicMiniPhraseHeardCountProvider = Provider<int>((ref) {
  return ref.watch(kidsArabicMiniPhraseProgressProvider).heardPhraseIds.length;
});

final kidsArabicMiniPhraseRecommendedProvider =
    Provider<KidsArabicMiniPhrase?>((ref) {
  final phrases = ref.watch(kidsArabicMiniPhrasesProvider);
  final progress = ref.watch(kidsArabicMiniPhraseProgressProvider);
  if (phrases.isEmpty) {
    return null;
  }
  final lastPhraseId = progress.lastPhraseId;
  if (lastPhraseId != null) {
    for (final phrase in phrases) {
      if (phrase.id == lastPhraseId) {
        return phrase;
      }
    }
  }
  for (final phrase in phrases) {
    if (!progress.heardPhraseIds.contains(phrase.id)) {
      return phrase;
    }
  }
  return phrases.first;
});

class KidsArabicMiniPhraseProgressNotifier
    extends StateNotifier<KidsArabicMiniPhraseProgressState> {
  KidsArabicMiniPhraseProgressNotifier(Ref ref)
      : _store = ref.read(localStoreProvider),
        _activeLearnerId = ref.read(kidsArabicActiveLearnerProvider).learnerId,
        super(
          KidsArabicMiniPhraseProgressState.fromJson(
            ref.read(localStoreProvider).getJsonMap(
                  kidsArabicMiniPhraseProgressStorageKeyForLearner(
                    ref.read(kidsArabicActiveLearnerProvider).learnerId,
                  ),
                ),
          ),
        );

  final LocalStore _store;
  String _activeLearnerId;

  void _save() {
    _store.setJsonMap(
      kidsArabicMiniPhraseProgressStorageKeyForLearner(_activeLearnerId),
      state.toJson(),
    );
  }

  void updateActiveLearner(String learnerId) {
    if (_activeLearnerId == learnerId) {
      return;
    }
    _activeLearnerId = learnerId;
    state = KidsArabicMiniPhraseProgressState.fromJson(
      _store.getJsonMap(kidsArabicMiniPhraseProgressStorageKeyForLearner(learnerId)),
    );
  }

  void markPhraseOpened(String phraseId) {
    state = state.copyWith(lastPhraseId: phraseId);
    _save();
  }

  void markPhraseHeard(String phraseId) {
    final nextHeard = Set<String>.from(state.heardPhraseIds)..add(phraseId);
    state = state.copyWith(
      heardPhraseIds: nextHeard,
      lastPhraseId: phraseId,
    );
    _save();
  }
}
