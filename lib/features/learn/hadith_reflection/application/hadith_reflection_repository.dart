import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../hadith/data/generated_hadith_foundation_data.dart';
import '../../hadith/domain/hadith_foundation_models.dart';
import '../../journey/application/family_learning_provider.dart';
import '../../knowledge_games/adaptive/application/adaptive_learning_engine.dart';
import '../../knowledge_games/adaptive/application/user_learning_profile_provider.dart';
import '../../knowledge_games/adaptive/domain/user_learning_profile_models.dart';
import '../data/hadith_reflection_seed_data.dart';
import '../domain/hadith_reflection_models.dart';
import 'hadith_reflection_progress_provider.dart';
import 'hadith_reflection_validation.dart';

class HadithReflectionRepository {
  const HadithReflectionRepository();

  static const Map<int, String> weekdayThemes = <int, String>{
    DateTime.monday: 'honesty',
    DateTime.tuesday: 'kindness',
    DateTime.wednesday: 'patience',
    DateTime.thursday: 'family',
    DateTime.friday: 'sincerity',
    DateTime.saturday: 'community',
    DateTime.sunday: 'mixed',
  };

  HadithReflectionCatalog buildCatalog() {
    final entriesById = {
      for (final entry in generatedHadithEntries) entry.id: entry,
    };
    final packIdsByPuzzleId = <String, List<String>>{};
    for (final pack in hadithReflectionPuzzlePacks) {
      for (final puzzleId in pack.puzzleIds) {
        packIdsByPuzzleId.update(
          puzzleId,
          (value) => [...value, pack.id],
          ifAbsent: () => <String>[pack.id],
        );
      }
    }
    final puzzles = hadithReflectionScenarioSeeds
        .map((seed) {
          final entry = entriesById[seed.hadithId];
          if (entry == null) {
            throw StateError(
              'Missing HadithEntry ${seed.hadithId} for puzzle ${seed.id}.',
            );
          }
          return _buildPuzzle(
            seed,
            entry,
            packIdsByPuzzleId[seed.id] ?? const [],
          );
        })
        .toList(growable: false);
    final catalog = HadithReflectionCatalog(
      puzzles: puzzles,
      packs: hadithReflectionPuzzlePacks,
    );
    HadithReflectionValidation.debugReport(
      HadithReflectionValidation.validateCatalog(catalog),
    );
    return catalog;
  }

  HadithReflectionPuzzle _buildPuzzle(
    HadithReflectionScenarioSeed seed,
    HadithEntry entry,
    List<String> packIds,
  ) {
    return HadithReflectionPuzzle(
      id: seed.id,
      hadithId: seed.hadithId,
      mode: seed.mode,
      category: seed.category,
      theme: seed.theme,
      difficulty: seed.difficulty,
      hadithTitle: entry.title,
      hadithTextEnglish: entry.translation,
      hadithTextArabic: entry.arabicMatn,
      sourceBook: entry.displaySourceCollection,
      referenceNumber: entry.displaySourceReference ?? entry.source,
      grading: entry.grading,
      shortTeachingSummary: seed.shortTeachingSummary,
      reflectionPrompt: seed.reflectionPrompt,
      scenarioTitle: seed.scenarioTitle,
      scenarioDescription: seed.scenarioDescription,
      choices: seed.choices,
      tags: {...seed.tags, ...entry.tags}.toList(growable: false),
      levelBandMin: seed.levelBandMin,
      levelBandMax: seed.levelBandMax,
      packIds: packIds,
      isDailyEligible: seed.isDailyEligible,
      dailyThemes: seed.dailyThemes,
      followUpReflection:
          seed.followUpReflection ??
          entry.reflectionPrompts.firstWhere(
            (item) => item.trim().isNotEmpty,
            orElse: () => '',
          ),
      helpText:
          seed.helpText ??
          (entry.meaning.trim().isNotEmpty ? entry.meaning.trim() : null),
    );
  }

  String weekdayThemeFor(DateTime date) =>
      weekdayThemes[date.weekday] ?? 'mixed';

  int dailyTargetDifficultyForDate(DateTime date, HadithReflectionMode mode) {
    final bands = mode == HadithReflectionMode.kids
        ? const <int>[8, 10, 12]
        : const <int>[28, 32, 36, 40];
    return bands[(_weekOfYear(date) + date.weekday) % bands.length];
  }

  HadithReflectionDailyPuzzle dailyPuzzleForDate(
    HadithReflectionCatalog catalog,
    DateTime date, {
    required HadithReflectionMode mode,
    HadithReflectionProgressState? progressState,
    UserLearningProfile? adaptiveProfile,
  }) {
    final weekdayTheme = weekdayThemeFor(date);
    final dateKey = LocalStore.todayKey(date);
    final existingDaily = progressState?.dailyProgressFor(dateKey);
    if (existingDaily != null &&
        existingDaily.puzzleId.isNotEmpty &&
        catalog.puzzlesById.containsKey(existingDaily.puzzleId)) {
      return HadithReflectionDailyPuzzle(
        puzzle: catalog.puzzlesById[existingDaily.puzzleId]!,
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
            gameType: 'hadith_reflection',
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
    return HadithReflectionDailyPuzzle(
      puzzle: puzzle,
      dateKey: dateKey,
      weekdayTheme: weekdayTheme,
      targetDifficulty: targetDifficulty,
    );
  }

  List<HadithReflectionPuzzle> dailyPuzzlePoolForTheme(
    HadithReflectionCatalog catalog,
    String weekdayTheme, {
    required HadithReflectionMode mode,
    HadithReflectionProgressState? progressState,
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
                  puzzle.theme == weekdayTheme ||
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
            gameType: 'hadith_reflection',
            category: a.category,
            difficulty: a.difficulty,
            targetDifficulty: target,
          );
          final bPriority = engine.selectionPriority(
            profile: adaptiveProfile,
            gameType: 'hadith_reflection',
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
    HadithReflectionProgressState state, {
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

  int _weekOfYear(DateTime date) {
    final start = DateTime(date.year, 1, 1);
    final offset = start.weekday - DateTime.monday;
    final firstMonday = start.subtract(Duration(days: offset));
    return ((date.difference(firstMonday).inDays) ~/ 7) + 1;
  }
}

final hadithReflectionRepositoryProvider = Provider<HadithReflectionRepository>(
  (_) => const HadithReflectionRepository(),
);

final hadithReflectionCatalogProvider = FutureProvider<HadithReflectionCatalog>(
  (ref) async {
    final repository = ref.watch(hadithReflectionRepositoryProvider);
    return repository.buildCatalog();
  },
);

final hadithReflectionValidationReportProvider =
    FutureProvider<HadithReflectionValidationReport>((ref) async {
      final catalog = await ref.watch(hadithReflectionCatalogProvider.future);
      return HadithReflectionValidation.validateCatalog(catalog);
    });

final hadithReflectionPuzzleByIdProvider =
    FutureProvider.family<HadithReflectionPuzzle?, String>((
      ref,
      puzzleId,
    ) async {
      final catalog = await ref.watch(hadithReflectionCatalogProvider.future);
      return catalog.puzzlesById[puzzleId];
    });

final hadithReflectionPackByIdProvider =
    FutureProvider.family<HadithReflectionPuzzlePack?, String>((
      ref,
      packId,
    ) async {
      final catalog = await ref.watch(hadithReflectionCatalogProvider.future);
      return catalog.packsById[packId];
    });

final hadithReflectionDailyPuzzleProvider =
    FutureProvider<HadithReflectionDailyPuzzle>((ref) async {
      final catalog = await ref.watch(hadithReflectionCatalogProvider.future);
      final repository = ref.watch(hadithReflectionRepositoryProvider);
      final progress = ref.watch(hadithReflectionProgressProvider);
      final adaptiveProfile = ref.watch(userLearningProfileProvider);
      final isChildProfile = ref.watch(
        activeFamilyLearningContextProvider.select(
          (value) => value.visibilityPolicy.isChildProfile,
        ),
      );
      return repository.dailyPuzzleForDate(
        catalog,
        DateTime.now(),
        mode: isChildProfile
            ? HadithReflectionMode.kids
            : HadithReflectionMode.adult,
        progressState: progress,
        adaptiveProfile: adaptiveProfile,
      );
    });
