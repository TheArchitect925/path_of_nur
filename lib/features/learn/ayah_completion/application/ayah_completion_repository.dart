import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../knowledge_games/adaptive/application/adaptive_learning_engine.dart';
import '../../knowledge_games/adaptive/application/user_learning_profile_provider.dart';
import '../../knowledge_games/adaptive/domain/user_learning_profile_models.dart';
import '../../journey/application/family_learning_provider.dart';
import '../../quran/application/quran_providers.dart';
import '../../quran/data/quran_repository.dart';
import '../../quran/domain/quran_ayah.dart';
import '../../quran/domain/quran_content_refs.dart';
import '../data/ayah_completion_seed_data.dart';
import '../domain/ayah_completion_models.dart';
import 'ayah_completion_progress_provider.dart';
import 'ayah_completion_validation.dart';

String normalizeAyahToken(String input) {
  return input.replaceAll(RegExp(r'\s+'), ' ').trim();
}

class AyahCompletionRepository {
  const AyahCompletionRepository({required QuranRepository quranRepository})
    : _quranRepository = quranRepository;

  final QuranRepository _quranRepository;

  static const Map<int, String> weekdayThemes = <int, String>{
    DateTime.monday: 'quran',
    DateTime.tuesday: 'mercy',
    DateTime.wednesday: 'patience',
    DateTime.thursday: 'gratitude',
    DateTime.friday: 'memorization',
    DateTime.saturday: 'mixed',
    DateTime.sunday: 'mixed',
  };

  AyahCompletionCatalog buildCatalog({required String translationCode}) {
    final packIdsByPuzzleId = <String, List<String>>{};
    for (final pack in ayahCompletionPuzzlePacks) {
      for (final puzzleId in pack.puzzleIds) {
        packIdsByPuzzleId.update(
          puzzleId,
          (value) => [...value, pack.id],
          ifAbsent: () => <String>[pack.id],
        );
      }
    }

    final allBlankWords = _allBlankWordsByMode(translationCode);
    final puzzles =
        ayahCompletionPuzzleSeeds
            .map(
              (seed) => _buildPuzzle(
                seed,
                translationCode: translationCode,
                packIds: packIdsByPuzzleId[seed.id] ?? const <String>[],
                allBlankWords: allBlankWords,
              ),
            )
            .toList(growable: false)
          ..sort((a, b) {
            final modeCompare = a.mode.index.compareTo(b.mode.index);
            if (modeCompare != 0) return modeCompare;
            return a.difficulty.compareTo(b.difficulty);
          });

    final catalog = AyahCompletionCatalog(
      puzzles: puzzles,
      packs: ayahCompletionPuzzlePacks,
    );
    AyahCompletionValidation.debugReport(
      AyahCompletionValidation.validateCatalog(catalog),
    );
    return catalog;
  }

  String weekdayThemeFor(DateTime date) =>
      weekdayThemes[date.weekday] ?? 'mixed';

  int dailyTargetDifficultyForDate(DateTime date, AyahCompletionMode mode) {
    final bands = mode == AyahCompletionMode.kids
        ? const <int>[8, 10, 12]
        : const <int>[30, 34, 38, 40];
    return bands[(_weekOfYear(date) + date.weekday) % bands.length];
  }

  AyahCompletionDailyPuzzle dailyPuzzleForDate(
    AyahCompletionCatalog catalog,
    DateTime date, {
    required AyahCompletionMode mode,
    AyahCompletionProgressState? progressState,
    UserLearningProfile? adaptiveProfile,
  }) {
    final weekdayTheme = weekdayThemeFor(date);
    final dateKey = LocalStore.todayKey(date);
    final existingDaily = progressState?.dailyProgressFor(dateKey);
    if (existingDaily != null &&
        existingDaily.puzzleId.isNotEmpty &&
        catalog.puzzlesById.containsKey(existingDaily.puzzleId)) {
      final puzzle = catalog.puzzlesById[existingDaily.puzzleId]!;
      return AyahCompletionDailyPuzzle(
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
            gameType: 'ayah_completion',
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
    return AyahCompletionDailyPuzzle(
      puzzle: puzzle,
      dateKey: dateKey,
      weekdayTheme: weekdayTheme,
      targetDifficulty: targetDifficulty,
    );
  }

  List<AyahCompletionPuzzle> dailyPuzzlePoolForTheme(
    AyahCompletionCatalog catalog,
    String weekdayTheme, {
    required AyahCompletionMode mode,
    AyahCompletionProgressState? progressState,
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
            gameType: 'ayah_completion',
            category: a.category,
            difficulty: a.difficulty,
            targetDifficulty: target,
          );
          final bPriority = engine.selectionPriority(
            profile: adaptiveProfile,
            gameType: 'ayah_completion',
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
    AyahCompletionProgressState state, {
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

  AyahCompletionPuzzle _buildPuzzle(
    AyahCompletionPuzzleSeed seed, {
    required String translationCode,
    required List<String> packIds,
    required Map<AyahCompletionMode, List<String>> allBlankWords,
  }) {
    final ayah = _ayahForRef(seed.ref, translationCode: translationCode);
    final words = ayah.arabic.split(RegExp(r'\s+')).toList(growable: false);
    final blanks = <AyahCompletionBlank>[];
    final usedWords = <String>{};
    for (
      var blankIndex = 0;
      blankIndex < seed.blankWordIndexes.length;
      blankIndex += 1
    ) {
      final wordIndex = seed.blankWordIndexes[blankIndex];
      if (wordIndex < 0 || wordIndex >= words.length) {
        throw StateError(
          'AyahCompletion seed ${seed.id} has invalid word index $wordIndex.',
        );
      }
      final correctWord = words[wordIndex];
      if (!_isBlankableToken(correctWord)) {
        throw StateError(
          'AyahCompletion seed ${seed.id} targets a non-blankable token at $wordIndex.',
        );
      }
      final options = _optionsForBlank(
        correctWord: correctWord,
        mode: seed.mode,
        allBlankWords: allBlankWords,
        excluded: usedWords,
      );
      usedWords.add(correctWord);
      blanks.add(
        AyahCompletionBlank(
          blankIndex: blankIndex,
          wordIndex: wordIndex,
          correctWord: correctWord,
          options: options,
        ),
      );
    }
    return AyahCompletionPuzzle(
      id: seed.id,
      ref: seed.ref,
      mode: seed.mode,
      category: seed.category,
      difficulty: seed.difficulty,
      arabicWords: words,
      fullArabicText: ayah.arabic,
      translation: ayah.translation,
      blanks: blanks,
      tags: seed.tags,
      levelBandMin: seed.levelBandMin,
      levelBandMax: seed.levelBandMax,
      isDailyEligible: seed.isDailyEligible,
      dailyThemes: seed.dailyThemes,
      packIds: packIds,
    );
  }

  Map<AyahCompletionMode, List<String>> _allBlankWordsByMode(
    String translationCode,
  ) {
    final byMode = <AyahCompletionMode, List<String>>{
      AyahCompletionMode.kids: <String>[],
      AyahCompletionMode.adult: <String>[],
    };
    for (final seed in ayahCompletionPuzzleSeeds) {
      final ayah = _ayahForRef(seed.ref, translationCode: translationCode);
      final words = ayah.arabic.split(RegExp(r'\s+'));
      for (final index in seed.blankWordIndexes) {
        if (index >= 0 &&
            index < words.length &&
            _isBlankableToken(words[index])) {
          byMode[seed.mode]!.add(words[index]);
        }
      }
    }
    return byMode.map(
      (key, value) => MapEntry(key, {...value}.toList(growable: false)),
    );
  }

  List<String> _optionsForBlank({
    required String correctWord,
    required AyahCompletionMode mode,
    required Map<AyahCompletionMode, List<String>> allBlankWords,
    required Set<String> excluded,
  }) {
    final localPool = allBlankWords[mode] ?? const <String>[];
    final distractors = localPool
        .where((item) => item != correctWord && !excluded.contains(item))
        .take(mode == AyahCompletionMode.kids ? 3 : 5)
        .toList(growable: true);
    while (distractors.length < (mode == AyahCompletionMode.kids ? 3 : 5)) {
      final fallback = localPool.firstWhere(
        (item) => item != correctWord && !distractors.contains(item),
        orElse: () => '',
      );
      if (fallback.isEmpty) break;
      distractors.add(fallback);
    }
    final options = {correctWord, ...distractors}.toList(growable: false);
    options.sort((a, b) => a.compareTo(b));
    return options;
  }

  int _weekOfYear(DateTime date) {
    final start = DateTime(date.year, 1, 1);
    final offset = start.weekday - DateTime.monday;
    final firstMonday = start.subtract(Duration(days: offset));
    return ((date.difference(firstMonday).inDays) ~/ 7) + 1;
  }

  QuranAyah _ayahForRef(QuranQuoteRef ref, {required String translationCode}) {
    final ayahs = _quranRepository.getAyahsForSurah(
      ref.surah,
      translationCode: translationCode,
    );
    return ayahs.firstWhere(
      (item) => item.ayahNumber == ref.ayah,
      orElse: () =>
          throw StateError('Missing Qur’an ayah for ${ref.surah}:${ref.ayah}.'),
    );
  }
}

bool _isBlankableToken(String token) {
  return RegExp(r'[\u0621-\u064A]').hasMatch(token);
}

final ayahCompletionRepositoryProvider = Provider<AyahCompletionRepository>((
  ref,
) {
  return AyahCompletionRepository(
    quranRepository: ref.watch(quranRepositoryProvider),
  );
});

final ayahCompletionCatalogProvider = FutureProvider<AyahCompletionCatalog>((
  ref,
) async {
  final repository = ref.watch(ayahCompletionRepositoryProvider);
  final translationCode = ref.watch(
    quranReaderSettingsProvider.select((state) => state.translationCode),
  );
  return repository.buildCatalog(translationCode: translationCode);
});

final ayahCompletionValidationReportProvider =
    FutureProvider<AyahCompletionValidationReport>((ref) async {
      final catalog = await ref.watch(ayahCompletionCatalogProvider.future);
      return AyahCompletionValidation.validateCatalog(catalog);
    });

final ayahCompletionPuzzleByIdProvider =
    FutureProvider.family<AyahCompletionPuzzle?, String>((ref, puzzleId) async {
      final catalog = await ref.watch(ayahCompletionCatalogProvider.future);
      return catalog.puzzlesById[puzzleId];
    });

final ayahCompletionPackByIdProvider =
    FutureProvider.family<AyahCompletionPuzzlePack?, String>((
      ref,
      packId,
    ) async {
      final catalog = await ref.watch(ayahCompletionCatalogProvider.future);
      return catalog.packsById[packId];
    });

final ayahCompletionDailyPuzzleProvider =
    FutureProvider<AyahCompletionDailyPuzzle>((ref) async {
      final catalog = await ref.watch(ayahCompletionCatalogProvider.future);
      final repository = ref.watch(ayahCompletionRepositoryProvider);
      final progress = ref.watch(ayahCompletionProgressProvider);
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
            ? AyahCompletionMode.kids
            : AyahCompletionMode.adult,
        progressState: progress,
        adaptiveProfile: adaptiveProfile,
      );
    });
