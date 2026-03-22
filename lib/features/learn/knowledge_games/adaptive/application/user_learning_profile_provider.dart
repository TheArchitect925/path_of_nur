import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/persistence/local_store.dart';
import '../../../ayah_completion/application/ayah_completion_progress_provider.dart';
import '../../../ayah_completion/application/ayah_completion_repository.dart';
import '../../../crossword/application/crossword_progress_provider.dart';
import '../../../crossword/application/crossword_repository.dart';
import '../../../hadith_reflection/application/hadith_reflection_progress_provider.dart';
import '../../../hadith_reflection/application/hadith_reflection_repository.dart';
import '../../../matching/application/matching_progress_provider.dart';
import '../../../matching/application/matching_repository.dart';
import '../../../word_search/application/word_search_progress_provider.dart';
import '../../../word_search/application/word_search_repository.dart';
import '../domain/user_learning_profile_models.dart';
import 'adaptive_learning_engine.dart';

const _userLearningProfileStorageKey = 'learn.knowledge_games.adaptive_profile.v1';

final adaptiveLearningEngineProvider = Provider<AdaptiveLearningEngine>(
  (_) => const AdaptiveLearningEngine(),
);

class UserLearningProfileSnapshotNotifier
    extends StateNotifier<UserLearningProfile> {
  UserLearningProfileSnapshotNotifier(this._store)
    : super(
        UserLearningProfile.fromJson(
          _store.getJsonMap(_userLearningProfileStorageKey),
        ),
      );

  final LocalStore _store;

  void replace(UserLearningProfile profile) {
    state = profile;
    _store.setJsonMap(_userLearningProfileStorageKey, profile.toJson());
  }
}

final userLearningProfileSnapshotProvider = StateNotifierProvider<
  UserLearningProfileSnapshotNotifier,
  UserLearningProfile
>((ref) {
  return UserLearningProfileSnapshotNotifier(ref.watch(localStoreProvider));
});

final computedUserLearningProfileProvider =
    FutureProvider<UserLearningProfile>((ref) async {
      final engine = ref.watch(adaptiveLearningEngineProvider);
      final crosswordCatalog = await ref.watch(crosswordCatalogProvider.future);
      final wordSearchCatalog = await ref.watch(wordSearchCatalogProvider.future);
      final matchingCatalog = await ref.watch(matchingCatalogProvider.future);
      final ayahCompletionCatalog = await ref.watch(
        ayahCompletionCatalogProvider.future,
      );
      final hadithReflectionCatalog = await ref.watch(
        hadithReflectionCatalogProvider.future,
      );
      return engine.buildProfile(
        crosswordCatalog: crosswordCatalog,
        crosswordProgress: ref.watch(crosswordProgressProvider),
        wordSearchCatalog: wordSearchCatalog,
        wordSearchProgress: ref.watch(wordSearchProgressProvider),
        matchingCatalog: matchingCatalog,
        matchingProgress: ref.watch(matchingProgressProvider),
        ayahCompletionCatalog: ayahCompletionCatalog,
        ayahCompletionProgress: ref.watch(ayahCompletionProgressProvider),
        hadithReflectionCatalog: hadithReflectionCatalog,
        hadithReflectionProgress: ref.watch(hadithReflectionProgressProvider),
        now: DateTime.now(),
      );
    });

final userLearningProfileProvider = Provider<UserLearningProfile>((ref) {
  ref.listen<AsyncValue<UserLearningProfile>>(computedUserLearningProfileProvider, (
    _,
    next,
  ) {
    next.whenData(
      (profile) =>
          ref.read(userLearningProfileSnapshotProvider.notifier).replace(profile),
    );
  });
  final computed = ref.watch(computedUserLearningProfileProvider);
  final stored = ref.watch(userLearningProfileSnapshotProvider);
  return computed.valueOrNull ?? stored;
});

final adaptiveLearningInsightProvider = Provider<AdaptiveLearningInsight>((ref) {
  final engine = ref.watch(adaptiveLearningEngineProvider);
  final profile = ref.watch(userLearningProfileProvider);
  return engine.buildInsight(profile);
});
