import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/persistence/local_store.dart';
import '../../../ayah_completion/application/ayah_completion_progress_provider.dart';
import '../../../ayah_completion/application/ayah_completion_repository.dart';
import '../../../ayah_completion/domain/ayah_completion_models.dart';
import '../../../crossword/application/crossword_progress_provider.dart';
import '../../../crossword/application/crossword_repository.dart';
import '../../../crossword/domain/crossword_models.dart';
import '../../../hadith_reflection/application/hadith_reflection_progress_provider.dart';
import '../../../hadith_reflection/application/hadith_reflection_repository.dart';
import '../../../hadith_reflection/domain/hadith_reflection_models.dart';
import '../../adaptive/application/user_learning_profile_provider.dart';
import '../../application/knowledge_game_variation_engine.dart';
import '../../domain/knowledge_game_variations.dart';
import '../../../matching/application/matching_progress_provider.dart';
import '../../../matching/application/matching_repository.dart';
import '../../../matching/domain/matching_models.dart';
import '../../../word_search/application/word_search_progress_provider.dart';
import '../../../word_search/application/word_search_repository.dart';
import '../../../word_search/domain/word_search_models.dart';
import '../domain/daily_knowledge_challenge_models.dart';

const _dailyKnowledgeChallengeHubKey = 'learn.knowledge_games.daily_hub.v1';

class DailyKnowledgeChallengeHubRepository {
  const DailyKnowledgeChallengeHubRepository();

  DailyChallengeBundle buildBundle({
    required String dateKey,
    required KnowledgeGameRef crossword,
    required KnowledgeGameRef wordSearch,
    required KnowledgeGameRef matching,
    required KnowledgeGameRef ayahCompletion,
    required KnowledgeGameRef hadithReflection,
    required Set<DailyKnowledgeGameType> completedGameTypes,
  }) {
    final games = <KnowledgeGameRef>[
      crossword,
      wordSearch,
      matching,
      ayahCompletion,
      hadithReflection,
    ];
    final completedCount = completedGameTypes.length;
    return DailyChallengeBundle(
      dateKey: dateKey,
      games: games,
      completedGameTypes: completedGameTypes,
      isCompleted: completedCount == games.length,
      completedCount: completedCount,
    );
  }

  Set<DailyKnowledgeGameType> completedGameTypesForDate({
    required String dateKey,
    required CrosswordProgressState crossword,
    required WordSearchProgressState wordSearch,
    required MatchingProgressState matching,
    required AyahCompletionProgressState ayahCompletion,
    required HadithReflectionProgressState hadithReflection,
  }) {
    final completed = <DailyKnowledgeGameType>{};
    if (crossword.dailyProgressFor(dateKey)?.isCompleted == true) {
      completed.add(DailyKnowledgeGameType.crossword);
    }
    if (wordSearch.dailyProgressFor(dateKey)?.isCompleted == true) {
      completed.add(DailyKnowledgeGameType.wordSearch);
    }
    if (matching.dailyProgressFor(dateKey)?.isCompleted == true) {
      completed.add(DailyKnowledgeGameType.matching);
    }
    if (ayahCompletion.dailyProgressFor(dateKey)?.isCompleted == true) {
      completed.add(DailyKnowledgeGameType.ayahCompletion);
    }
    if (hadithReflection.dailyProgressFor(dateKey)?.isCompleted == true) {
      completed.add(DailyKnowledgeGameType.hadithReflection);
    }
    return completed;
  }

  KnowledgeGameRef crosswordRef(
    CrosswordDailyPuzzle daily, {
    required KnowledgeGameConfig config,
  }) {
    return KnowledgeGameRef(
      gameType: DailyKnowledgeGameType.crossword,
      puzzleId: daily.puzzle.id,
      routeName: 'learnCrosswordDaily',
      category: daily.puzzle.category,
      difficulty: daily.puzzle.difficulty,
      config: config,
    );
  }

  KnowledgeGameRef wordSearchRef(
    WordSearchDailyPuzzle daily, {
    required KnowledgeGameConfig config,
  }) {
    return KnowledgeGameRef(
      gameType: DailyKnowledgeGameType.wordSearch,
      puzzleId: daily.puzzle.id,
      routeName: 'learnWordSearchDaily',
      category: daily.puzzle.category,
      difficulty: daily.puzzle.difficulty,
      config: config,
    );
  }

  KnowledgeGameRef matchingRef(
    MatchingDailyPuzzle daily, {
    required KnowledgeGameConfig config,
  }) {
    return KnowledgeGameRef(
      gameType: DailyKnowledgeGameType.matching,
      puzzleId: daily.puzzle.id,
      routeName: 'learnMatchingDaily',
      category: daily.puzzle.category,
      difficulty: daily.puzzle.difficulty,
      config: config,
    );
  }

  KnowledgeGameRef ayahCompletionRef(
    AyahCompletionDailyPuzzle daily, {
    required KnowledgeGameConfig config,
  }) {
    return KnowledgeGameRef(
      gameType: DailyKnowledgeGameType.ayahCompletion,
      puzzleId: daily.puzzle.id,
      routeName: 'learnAyahCompletionDaily',
      category: daily.puzzle.category,
      difficulty: daily.puzzle.difficulty,
      config: config,
    );
  }

  KnowledgeGameRef hadithReflectionRef(
    HadithReflectionDailyPuzzle daily, {
    required KnowledgeGameConfig config,
  }) {
    return KnowledgeGameRef(
      gameType: DailyKnowledgeGameType.hadithReflection,
      puzzleId: daily.puzzle.id,
      routeName: 'learnHadithReflectionDaily',
      category: daily.puzzle.category,
      difficulty: daily.puzzle.difficulty,
      config: config,
    );
  }
}

final dailyKnowledgeChallengeHubRepositoryProvider =
    Provider<DailyKnowledgeChallengeHubRepository>(
      (_) => const DailyKnowledgeChallengeHubRepository(),
    );

final dailyKnowledgeChallengeHubProgressProvider =
    StateNotifierProvider<
      DailyKnowledgeChallengeHubProgressNotifier,
      DailyChallengeHubProgressState
    >((ref) {
      return DailyKnowledgeChallengeHubProgressNotifier(
        ref.watch(localStoreProvider),
      );
    });

final dailyKnowledgeChallengeHubStreakProvider =
    Provider<DailyChallengeBundleStreakSummary>((ref) {
      final progress = ref.watch(dailyKnowledgeChallengeHubProgressProvider);
      return progress.streakSummary(DateTime.now());
    });

final dailyKnowledgeChallengeHubRecentHistoryProvider =
    Provider<List<DailyChallengeBundleProgress>>((ref) {
      final progress = ref.watch(dailyKnowledgeChallengeHubProgressProvider);
      return progress.recentHistory(limit: 7);
    });

final dailyKnowledgeChallengeHubRecentHistoryCountProvider = Provider<int>((
  ref,
) {
  return ref.watch(
    dailyKnowledgeChallengeHubRecentHistoryProvider.select(
      (value) => value.length,
    ),
  );
});

class DailyKnowledgeChallengeHubProgressNotifier
    extends StateNotifier<DailyChallengeHubProgressState> {
  DailyKnowledgeChallengeHubProgressNotifier(this._store)
    : super(DailyChallengeHubProgressState.initial()) {
    _load();
  }

  final LocalStore _store;

  void _load() {
    state = DailyChallengeHubProgressState.fromJson(
      _store.getJsonMap(_dailyKnowledgeChallengeHubKey),
    );
  }

  void _save() {
    _store.setJsonMap(_dailyKnowledgeChallengeHubKey, state.toJson());
  }

  DailyChallengeBundleProgress _update(
    String dateKey,
    DailyChallengeBundleProgress Function(DailyChallengeBundleProgress current)
    update,
  ) {
    final current = state.progressFor(dateKey);
    final next = update(current);
    state = state.copyWith(
      progressByDateKey: {...state.progressByDateKey, dateKey: next},
    );
    _save();
    return next;
  }

  void markBundleViewed({
    required String dateKey,
    required DateTime occurredAt,
  }) {
    _update(dateKey, (current) {
      return current.copyWith(
        startedAtIso: current.startedAtIso ?? occurredAt.toIso8601String(),
      );
    });
  }

  bool markBundleCompleted({
    required String dateKey,
    required DateTime occurredAt,
  }) {
    var changed = false;
    _update(dateKey, (current) {
      if (current.isCompleted) return current;
      changed = true;
      return current.copyWith(
        startedAtIso: current.startedAtIso ?? occurredAt.toIso8601String(),
        completedAtIso: occurredAt.toIso8601String(),
      );
    });
    return changed;
  }

  bool markBundleRewardGranted({
    required String dateKey,
    required DateTime occurredAt,
  }) {
    var changed = false;
    _update(dateKey, (current) {
      if ((current.rewardGrantedAtIso ?? '').isNotEmpty) return current;
      changed = true;
      return current.copyWith(rewardGrantedAtIso: occurredAt.toIso8601String());
    });
    return changed;
  }
}

final dailyKnowledgeChallengeBundleProvider =
    FutureProvider<DailyChallengeBundle>((ref) async {
      final repository = ref.watch(
        dailyKnowledgeChallengeHubRepositoryProvider,
      );
      final variationEngine = ref.watch(knowledgeGameVariationEngineProvider);
      final profile = ref.watch(userLearningProfileProvider);
      final crossword = await ref.watch(crosswordDailyPuzzleProvider.future);
      final wordSearch = await ref.watch(wordSearchDailyPuzzleProvider.future);
      final matching = await ref.watch(matchingDailyPuzzleProvider.future);
      final ayahCompletion = await ref.watch(
        ayahCompletionDailyPuzzleProvider.future,
      );
      final hadithReflection = await ref.watch(
        hadithReflectionDailyPuzzleProvider.future,
      );
      final dateKey = crossword.dateKey;
      final completedTypes = repository.completedGameTypesForDate(
        dateKey: dateKey,
        crossword: ref.watch(crosswordProgressProvider),
        wordSearch: ref.watch(wordSearchProgressProvider),
        matching: ref.watch(matchingProgressProvider),
        ayahCompletion: ref.watch(ayahCompletionProgressProvider),
        hadithReflection: ref.watch(hadithReflectionProgressProvider),
      );
      return repository.buildBundle(
        dateKey: dateKey,
        crossword: repository.crosswordRef(
          crossword,
          config: variationEngine.resolveDailyConfig(
            gameType: DailyKnowledgeGameType.crossword,
            dateKey: dateKey,
            profile: profile,
          ),
        ),
        wordSearch: repository.wordSearchRef(
          wordSearch,
          config: variationEngine.resolveDailyConfig(
            gameType: DailyKnowledgeGameType.wordSearch,
            dateKey: dateKey,
            profile: profile,
          ),
        ),
        matching: repository.matchingRef(
          matching,
          config: variationEngine.resolveDailyConfig(
            gameType: DailyKnowledgeGameType.matching,
            dateKey: dateKey,
            profile: profile,
          ),
        ),
        ayahCompletion: repository.ayahCompletionRef(
          ayahCompletion,
          config: variationEngine.resolveDailyConfig(
            gameType: DailyKnowledgeGameType.ayahCompletion,
            dateKey: dateKey,
            profile: profile,
          ),
        ),
        hadithReflection: repository.hadithReflectionRef(
          hadithReflection,
          config: variationEngine.resolveDailyConfig(
            gameType: DailyKnowledgeGameType.hadithReflection,
            dateKey: dateKey,
            profile: profile,
          ),
        ),
        completedGameTypes: completedTypes,
      );
    });
