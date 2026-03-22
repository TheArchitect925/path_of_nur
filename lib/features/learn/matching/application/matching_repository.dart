import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../knowledge_games/adaptive/application/adaptive_learning_engine.dart';
import '../../knowledge_games/adaptive/application/user_learning_profile_provider.dart';
import '../../knowledge_games/adaptive/domain/user_learning_profile_models.dart';
import '../../journey/application/family_learning_provider.dart';
import '../data/matching_seed_data.dart';
import '../domain/matching_models.dart';
import 'matching_progress_provider.dart';
import 'matching_validation.dart';

class MatchingRepository {
  const MatchingRepository();

  static const Map<int, String> weekdayThemes = <int, String>{
    DateTime.monday: 'quran',
    DateTime.tuesday: 'hadith',
    DateTime.wednesday: 'prophets',
    DateTime.thursday: 'duas',
    DateTime.friday: 'jummah',
    DateTime.saturday: 'mixed',
    DateTime.sunday: 'mixed',
  };

  MatchingCatalog buildCatalog() {
    final pairsById = {for (final pair in matchingSeedPairs) pair.id: pair};
    final packIdsByPuzzleId = <String, List<String>>{};
    for (final pack in matchingPuzzlePacks) {
      for (final puzzleId in pack.puzzleIds) {
        packIdsByPuzzleId.update(
          puzzleId,
          (value) => [...value, pack.id],
          ifAbsent: () => <String>[pack.id],
        );
      }
    }
    final puzzles = matchingPuzzleSeeds
        .map((seed) {
          final pairs = seed.pairIds
              .map((id) => pairsById[id])
              .whereType<MatchingPair>()
              .toList(growable: false);
          if (pairs.length != seed.pairIds.length) {
            throw StateError('Missing matching pairs for ${seed.id}.');
          }
          return MatchingPuzzle(
            id: seed.id,
            mode: seed.mode,
            category: seed.category,
            difficulty: seed.difficulty,
            pairs: pairs,
            tags: seed.tags,
            levelBandMin: seed.levelBandMin,
            levelBandMax: seed.levelBandMax,
            isDailyEligible: seed.isDailyEligible,
            dailyThemes: seed.dailyThemes,
            packIds: packIdsByPuzzleId[seed.id] ?? const <String>[],
          );
        })
        .toList(growable: false);
    final catalog = MatchingCatalog(
      pairs: matchingSeedPairs,
      puzzles: puzzles,
      packs: matchingPuzzlePacks,
    );
    MatchingValidation.debugReport(MatchingValidation.validateCatalog(catalog));
    return catalog;
  }

  String weekdayThemeFor(DateTime date) =>
      weekdayThemes[date.weekday] ?? 'mixed';

  int dailyTargetDifficultyForDate(DateTime date, MatchingMode mode) {
    final bands = mode == MatchingMode.kids
        ? const <int>[8, 10, 12, 14, 16]
        : const <int>[28, 30, 34, 36, 40];
    return bands[(_weekOfYear(date) + date.weekday) % bands.length];
  }

  MatchingDailyPuzzle dailyPuzzleForDate(
    MatchingCatalog catalog,
    DateTime date, {
    required MatchingMode mode,
    MatchingProgressState? progressState,
    UserLearningProfile? adaptiveProfile,
  }) {
    final weekdayTheme = weekdayThemeFor(date);
    final dateKey = LocalStore.todayKey(date);
    final existingDaily = progressState?.dailyProgressFor(dateKey);
    if (existingDaily != null &&
        existingDaily.puzzleId.isNotEmpty &&
        catalog.puzzlesById.containsKey(existingDaily.puzzleId)) {
      final puzzle = catalog.puzzlesById[existingDaily.puzzleId]!;
      return MatchingDailyPuzzle(
        puzzle: puzzle,
        dateKey: dateKey,
        weekdayTheme: existingDaily.weekdayTheme ?? weekdayTheme,
        targetDifficulty: dailyTargetDifficultyForDate(date, mode),
      );
    }
    final baseTargetDifficulty = dailyTargetDifficultyForDate(date, mode);
    final targetDifficulty = adaptiveProfile == null
        ? baseTargetDifficulty
        : const AdaptiveLearningEngine().personalizedTargetDifficulty(
            profile: adaptiveProfile,
            gameType: 'matching',
            baseTarget: baseTargetDifficulty,
          );
    final pool = dailyPuzzlePoolForTheme(
      catalog,
      weekdayTheme,
      mode: mode,
      progressState: progressState,
      date: date,
      targetDifficulty: targetDifficulty,
      adaptiveProfile: adaptiveProfile,
    );
    final seed = '$dateKey:$weekdayTheme:${mode.name}:${_weekOfYear(date)}'
        .codeUnits
        .fold<int>(0, (sum, item) => sum + item);
    final puzzle = pool[seed % pool.length];
    return MatchingDailyPuzzle(
      puzzle: puzzle,
      dateKey: dateKey,
      weekdayTheme: weekdayTheme,
      targetDifficulty: targetDifficulty,
    );
  }

  List<MatchingPuzzle> dailyPuzzlePoolForTheme(
    MatchingCatalog catalog,
    String weekdayTheme, {
    required MatchingMode mode,
    MatchingProgressState? progressState,
    DateTime? date,
    int? targetDifficulty,
    UserLearningProfile? adaptiveProfile,
  }) {
    final modePuzzles = catalog.puzzles.where((item) => item.mode == mode);
    final themed = modePuzzles
        .where(
          (puzzle) =>
              puzzle.isDailyEligible &&
              (puzzle.dailyThemes.contains(weekdayTheme) ||
                  puzzle.category == weekdayTheme ||
                  puzzle.tags.contains(weekdayTheme)),
        )
        .toList(growable: false);
    final eligible = themed.isNotEmpty
        ? themed
        : modePuzzles
              .where((puzzle) => puzzle.isDailyEligible)
              .toList(growable: false);
    final fallback = eligible.isNotEmpty
        ? eligible
        : modePuzzles.toList(growable: false);
    final recentIds = progressState == null
        ? const <String>{}
        : _recentDailyPuzzleIds(
            progressState,
            upToDate: date ?? DateTime.now(),
            limit: 7,
          );
    final withoutRecent = fallback
        .where((puzzle) => !recentIds.contains(puzzle.id))
        .toList(growable: false);
    final pool = withoutRecent.isNotEmpty ? withoutRecent : fallback;
    final target =
        targetDifficulty ??
        dailyTargetDifficultyForDate(date ?? DateTime.now(), mode);
    final sorted = [...pool]
      ..sort((a, b) {
        if (adaptiveProfile != null) {
          final engine = const AdaptiveLearningEngine();
          final aPriority = engine.selectionPriority(
            profile: adaptiveProfile,
            gameType: 'matching',
            category: a.category,
            difficulty: a.difficulty,
            targetDifficulty: target,
          );
          final bPriority = engine.selectionPriority(
            profile: adaptiveProfile,
            gameType: 'matching',
            category: b.category,
            difficulty: b.difficulty,
            targetDifficulty: target,
          );
          if (aPriority != bPriority) {
            return aPriority.compareTo(bPriority);
          }
        }
        final aGap = (a.difficulty - target).abs();
        final bGap = (b.difficulty - target).abs();
        if (aGap != bGap) return aGap.compareTo(bGap);
        return a.id.compareTo(b.id);
      });
    return sorted;
  }

  Set<String> _recentDailyPuzzleIds(
    MatchingProgressState state, {
    required DateTime upToDate,
    int limit = 7,
  }) {
    final cutoffKey = LocalStore.todayKey(upToDate);
    final sorted =
        state.dailyProgressByDateKey.values
            .where((item) => item.dateKey.compareTo(cutoffKey) < 0)
            .toList(growable: false)
          ..sort((a, b) => b.dateKey.compareTo(a.dateKey));
    return sorted
        .take(limit)
        .map((item) => item.puzzleId)
        .where((id) => id.isNotEmpty)
        .toSet();
  }

  List<String> shuffledRightPairIds(MatchingPuzzle puzzle, {String? seedKey}) {
    final ids = puzzle.pairs.map((pair) => pair.id).toList(growable: true);
    final seed = (seedKey ?? puzzle.id).codeUnits.fold<int>(
      0,
      (sum, item) => sum + item,
    );
    ids.sort((a, b) {
      final aSeed = a.codeUnits.fold(seed, (sum, item) => sum + item);
      final bSeed = b.codeUnits.fold(seed, (sum, item) => sum + item);
      return aSeed.compareTo(bSeed);
    });
    return ids;
  }

  int _weekOfYear(DateTime date) {
    final start = DateTime(date.year, 1, 1);
    final offset = start.weekday - DateTime.monday;
    final firstMonday = start.subtract(Duration(days: offset));
    return ((date.difference(firstMonday).inDays) ~/ 7) + 1;
  }
}

final matchingRepositoryProvider = Provider<MatchingRepository>(
  (_) => const MatchingRepository(),
);

final matchingCatalogProvider = FutureProvider<MatchingCatalog>((ref) async {
  final repository = ref.watch(matchingRepositoryProvider);
  return repository.buildCatalog();
});

final matchingValidationReportProvider =
    FutureProvider<MatchingValidationReport>((ref) async {
      final catalog = await ref.watch(matchingCatalogProvider.future);
      return MatchingValidation.validateCatalog(catalog);
    });

final matchingPuzzleByIdProvider =
    FutureProvider.family<MatchingPuzzle?, String>((ref, puzzleId) async {
      final catalog = await ref.watch(matchingCatalogProvider.future);
      return catalog.puzzlesById[puzzleId];
    });

final matchingPackByIdProvider =
    FutureProvider.family<MatchingPuzzlePack?, String>((ref, packId) async {
      final catalog = await ref.watch(matchingCatalogProvider.future);
      return catalog.packsById[packId];
    });

final matchingDailyPuzzleProvider = FutureProvider<MatchingDailyPuzzle>((
  ref,
) async {
  final catalog = await ref.watch(matchingCatalogProvider.future);
  final repository = ref.watch(matchingRepositoryProvider);
  final progress = ref.watch(matchingProgressProvider);
  final adaptiveProfile = ref.watch(userLearningProfileProvider);
  final isChildProfile = ref.watch(
    activeFamilyLearningContextProvider.select(
      (value) => value.visibilityPolicy.isChildProfile,
    ),
  );
  return repository.dailyPuzzleForDate(
    catalog,
    DateTime.now(),
    mode: isChildProfile ? MatchingMode.kids : MatchingMode.adult,
    progressState: progress,
    adaptiveProfile: adaptiveProfile,
  );
});
