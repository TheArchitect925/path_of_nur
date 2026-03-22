import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/kids_arabic/data/kids_arabic_letters_data.dart';
import '../../../../shared/persistence/local_store.dart';
import '../../knowledge_games/adaptive/application/adaptive_learning_engine.dart';
import '../../knowledge_games/adaptive/application/user_learning_profile_provider.dart';
import '../../knowledge_games/adaptive/domain/user_learning_profile_models.dart';
import '../../dua/data/dua_seed_data.dart';
import '../../hadith/application/hadith_foundation_repository.dart';
import '../../hadith/domain/hadith_foundation_models.dart';
import '../../journey/application/family_learning_provider.dart';
import '../../prophets/application/prophets_repository.dart';
import '../../prophets/domain/prophet_entry.dart';
import '../../quran/application/quran_words_provider.dart';
import '../../quran/domain/quran_core_word.dart';
import '../data/crossword_seed_data.dart';
import '../domain/crossword_models.dart';
import 'crossword_progress_provider.dart';
import 'crossword_validation.dart';

String normalizeCrosswordAnswer(String input) {
  return input.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
}

class CrosswordRepository {
  const CrosswordRepository();

  static const Map<int, String> weekdayThemes = <int, String>{
    DateTime.monday: 'quran',
    DateTime.tuesday: 'hadith',
    DateTime.wednesday: 'prophets',
    DateTime.thursday: 'duas',
    DateTime.friday: 'jummah',
    DateTime.saturday: 'mixed',
    DateTime.sunday: 'mixed',
  };

  CrosswordCatalog buildCatalog({
    required List<ProphetEntry> prophets,
    required List<HadithEntry> hadithEntries,
    required List<QuranCoreWord> quranWords,
  }) {
    final entries = <CrosswordEntry>[
      ..._kidsEntries(),
      ..._prophetEntries(prophets),
      ..._hadithEntries(hadithEntries),
      ..._quranAndDuaEntries(quranWords),
    ];
    final entryById = {for (final entry in entries) entry.id: entry};
    final templates = crosswordLayoutTemplates;

    final seededPuzzles = [
      ...kidsCrosswordPuzzleSeeds,
      ...adultCrosswordPuzzleSeeds,
    ].map((seed) => _buildPuzzle(seed, entryById)).toList(growable: false);

    final assembledPuzzles = _buildAssembledPuzzles(
      entries: entries,
      templates: templates,
      fallbackPuzzles: seededPuzzles,
    );

    final puzzles = [...seededPuzzles, ...assembledPuzzles]
      ..sort((a, b) {
        final modeCompare = a.mode.index.compareTo(b.mode.index);
        if (modeCompare != 0) return modeCompare;
        return a.difficulty.compareTo(b.difficulty);
      });

    final catalog = CrosswordCatalog(
      entries: entries,
      puzzles: puzzles,
      packs: _buildPacks(puzzles),
      templates: templates,
    );
    CrosswordValidation.debugReport(
      CrosswordValidation.validateCatalog(catalog),
    );
    return catalog;
  }

  CrosswordDailyPuzzle dailyPuzzleForDate(
    CrosswordCatalog catalog,
    DateTime date, {
    CrosswordMode mode = CrosswordMode.adult,
    CrosswordProgressState? progressState,
    UserLearningProfile? adaptiveProfile,
  }) {
    final weekdayTheme = weekdayThemeFor(date);
    final dateKey = LocalStore.todayKey(date);
    final existingDaily = progressState?.dailyProgressFor(dateKey);
    if (existingDaily != null &&
        existingDaily.puzzleId.isNotEmpty &&
        catalog.puzzlesById.containsKey(existingDaily.puzzleId)) {
      final puzzle = catalog.puzzlesById[existingDaily.puzzleId]!;
      return CrosswordDailyPuzzle(
        puzzle: puzzle,
        weekdayTheme: existingDaily.weekdayTheme ?? weekdayTheme,
        dateKey: dateKey,
        objectives: dailyObjectivesForPuzzle(puzzle),
        targetDifficulty: dailyTargetDifficultyForDate(date, mode),
      );
    }
    final baseTargetDifficulty = dailyTargetDifficultyForDate(date, mode);
    final targetDifficulty = adaptiveProfile == null
        ? baseTargetDifficulty
        : const AdaptiveLearningEngine().personalizedTargetDifficulty(
            profile: adaptiveProfile,
            gameType: 'crossword',
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
    final seed = '$dateKey:$weekdayTheme:${_weekOfYear(date)}'.codeUnits
        .fold<int>(0, (sum, item) => sum + item);
    final puzzle = pool[seed % pool.length];
    return CrosswordDailyPuzzle(
      puzzle: puzzle,
      weekdayTheme: weekdayTheme,
      dateKey: dateKey,
      objectives: dailyObjectivesForPuzzle(puzzle),
      targetDifficulty: targetDifficulty,
    );
  }

  String weekdayThemeFor(DateTime date) =>
      weekdayThemes[date.weekday] ?? 'mixed';

  int dailyTargetDifficultyForDate(DateTime date, CrosswordMode mode) {
    final bands = mode == CrosswordMode.kids
        ? const <int>[6, 8, 10, 12]
        : const <int>[18, 28, 38, 48, 58];
    return bands[(_weekOfYear(date) + date.weekday) % bands.length];
  }

  List<CrosswordDailyObjective> dailyObjectivesForPuzzle(
    CrosswordPuzzle puzzle,
  ) {
    final quickSolveTarget = switch (puzzle.difficulty) {
      <= 20 => 300,
      <= 40 => 420,
      <= 55 => 540,
      _ => 660,
    };
    return <CrosswordDailyObjective>[
      const CrosswordDailyObjective(
        id: 'perfect',
        type: CrosswordDailyObjectiveType.perfect,
        titleKey: 'crosswordDailyObjectivePerfectTitle',
        descriptionKey: 'crosswordDailyObjectivePerfectSubtitle',
      ),
      const CrosswordDailyObjective(
        id: 'hint_free',
        type: CrosswordDailyObjectiveType.hintFree,
        titleKey: 'crosswordDailyObjectiveHintFreeTitle',
        descriptionKey: 'crosswordDailyObjectiveHintFreeSubtitle',
      ),
      CrosswordDailyObjective(
        id: 'quick_solve',
        type: CrosswordDailyObjectiveType.quickSolve,
        titleKey: 'crosswordDailyObjectiveQuickSolveTitle',
        descriptionKey: 'crosswordDailyObjectiveQuickSolveSubtitle',
        targetSeconds: quickSolveTarget,
      ),
    ];
  }

  Set<String> evaluateDailyObjectives({
    required CrosswordPuzzle puzzle,
    required CrosswordPuzzleProgress puzzleProgress,
    required int? timeTakenSeconds,
  }) {
    final achieved = <String>{};
    if (!puzzleProgress.hadMistake) {
      achieved.add('perfect');
    }
    if (!puzzleProgress.usedAnyHint) {
      achieved.add('hint_free');
    }
    final quickSolveTarget = dailyObjectivesForPuzzle(puzzle)
        .where((item) => item.type == CrosswordDailyObjectiveType.quickSolve)
        .firstOrNull
        ?.targetSeconds;
    if (quickSolveTarget != null &&
        timeTakenSeconds != null &&
        timeTakenSeconds > 0 &&
        timeTakenSeconds <= quickSolveTarget) {
      achieved.add('quick_solve');
    }
    return achieved;
  }

  List<CrosswordPuzzle> dailyPuzzlePoolForTheme(
    CrosswordCatalog catalog,
    String weekdayTheme, {
    CrosswordMode mode = CrosswordMode.adult,
    CrosswordProgressState? progressState,
    DateTime? date,
    int? targetDifficulty,
    UserLearningProfile? adaptiveProfile,
  }) {
    final visiblePuzzles = mode == CrosswordMode.kids
        ? catalog.kidsPuzzles
        : catalog.adultPuzzles;
    final themed = visiblePuzzles
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
        : visiblePuzzles
              .where((puzzle) => puzzle.isDailyEligible)
              .toList(growable: false);
    final fallback = eligible.isNotEmpty ? eligible : visiblePuzzles;
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
            gameType: 'crossword',
            category: a.category,
            difficulty: a.difficulty,
            targetDifficulty: target,
          );
          final bPriority = engine.selectionPriority(
            profile: adaptiveProfile,
            gameType: 'crossword',
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
    CrosswordProgressState state, {
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

  CrosswordPuzzle _buildPuzzle(
    CrosswordPuzzleSeed seed,
    Map<String, CrosswordEntry> entryById,
  ) {
    final grid = List.generate(
      seed.gridSize,
      (_) => List<String>.filled(seed.gridSize, ''),
      growable: false,
    );
    final clues = <CrosswordClue>[];
    for (final placement in seed.placements) {
      final entry = entryById[placement.entryId];
      if (entry == null) {
        throw StateError('Missing crossword entry: ${placement.entryId}');
      }
      final answer = normalizeCrosswordAnswer(entry.answer);
      for (var index = 0; index < answer.length; index += 1) {
        final row = placement.row + (placement.isAcross ? 0 : index);
        final col = placement.col + (placement.isAcross ? index : 0);
        if (row >= seed.gridSize || col >= seed.gridSize) {
          throw StateError('Placement overflow for ${seed.id} / ${entry.id}');
        }
        final current = grid[row][col];
        final nextLetter = answer[index];
        if (current.isNotEmpty && current != nextLetter) {
          throw StateError(
            'Placement collision for ${seed.id} at $row,$col on ${entry.id}',
          );
        }
        grid[row][col] = nextLetter;
      }
      clues.add(
        CrosswordClue(
          id: '${seed.id}:${entry.id}',
          entryId: entry.id,
          clue: entry.clue,
          answer: answer,
          row: placement.row,
          col: placement.col,
          isAcross: placement.isAcross,
          category: entry.category,
          sourceType: entry.sourceType,
          tags: entry.tags,
          hint: entry.hint,
          imageKey: entry.imageKey,
          audioKey: entry.audioKey,
          theme: entry.theme,
          clueType: entry.clueType,
        ),
      );
    }
    return CrosswordPuzzle(
      id: seed.id,
      mode: seed.mode,
      category: seed.category,
      difficulty: seed.difficulty,
      gridSize: seed.gridSize,
      clues: clues,
      solutionGrid: grid,
      tags: seed.tags,
      levelBandMin: seed.levelBandMin,
      levelBandMax: seed.levelBandMax,
      clueType: seed.clueType,
      dailyThemes: seed.dailyThemes,
      isDailyEligible: seed.isDailyEligible,
      layoutKey: seed.layoutKey,
    );
  }

  List<CrosswordPuzzle> _buildAssembledPuzzles({
    required List<CrosswordEntry> entries,
    required List<CrosswordLayoutTemplate> templates,
    required List<CrosswordPuzzle> fallbackPuzzles,
  }) {
    final requests = <_CrosswordAssemblyRequest>[
      const _CrosswordAssemblyRequest(
        id: 'assembled_kids_letters',
        templateId: 'kids_pair_5x5',
        mode: CrosswordMode.kids,
        category: 'letters',
        difficulty: 6,
        levelBandMin: 1,
        levelBandMax: 10,
        clueType: CrosswordClueType.direct,
        tags: ['kids', 'letters', 'assembled'],
        fallbackPuzzleId: 'kids_alif_allah',
      ),
      const _CrosswordAssemblyRequest(
        id: 'assembled_kids_worship',
        templateId: 'kids_pair_6x6',
        mode: CrosswordMode.kids,
        category: 'worship',
        difficulty: 8,
        levelBandMin: 1,
        levelBandMax: 10,
        clueType: CrosswordClueType.direct,
        tags: ['kids', 'worship', 'assembled'],
        fallbackPuzzleId: 'kids_salah_sujood',
      ),
      const _CrosswordAssemblyRequest(
        id: 'assembled_prophets_focus',
        templateId: 'adult_pair_6x6',
        mode: CrosswordMode.adult,
        category: 'prophets',
        difficulty: 18,
        levelBandMin: 10,
        levelBandMax: 25,
        clueType: CrosswordClueType.contextual,
        tags: ['adult', 'prophets', 'assembled'],
        dailyThemes: ['prophets'],
        isDailyEligible: true,
        fallbackPuzzleId: 'adult_prophets_adam_ayyub',
      ),
      const _CrosswordAssemblyRequest(
        id: 'assembled_quran_reflection',
        templateId: 'adult_pair_7x7',
        mode: CrosswordMode.adult,
        category: 'quran',
        difficulty: 38,
        levelBandMin: 25,
        levelBandMax: 50,
        clueType: CrosswordClueType.contextual,
        tags: ['adult', 'quran', 'assembled'],
        dailyThemes: ['quran'],
        isDailyEligible: true,
        fallbackPuzzleId: 'adult_quran_sabr_rahmah',
      ),
      const _CrosswordAssemblyRequest(
        id: 'assembled_hadith_character',
        templateId: 'adult_pair_6x6',
        mode: CrosswordMode.adult,
        category: 'hadith',
        difficulty: 34,
        levelBandMin: 25,
        levelBandMax: 50,
        clueType: CrosswordClueType.contextual,
        tags: ['adult', 'hadith', 'character', 'assembled'],
        dailyThemes: ['hadith'],
        isDailyEligible: true,
        fallbackPuzzleId: 'adult_hadith_halal_ihsan',
      ),
      const _CrosswordAssemblyRequest(
        id: 'assembled_dua_family',
        templateId: 'adult_pair_10x10',
        mode: CrosswordMode.adult,
        category: 'duas',
        difficulty: 48,
        levelBandMin: 25,
        levelBandMax: 50,
        clueType: CrosswordClueType.contextual,
        tags: ['adult', 'duas', 'family', 'assembled'],
        dailyThemes: ['duas'],
        isDailyEligible: true,
        fallbackPuzzleId: 'adult_dua_rabbana_offspring',
      ),
      const _CrosswordAssemblyRequest(
        id: 'assembled_worship_jummah',
        templateId: 'adult_pair_8x8',
        mode: CrosswordMode.adult,
        category: 'worship',
        difficulty: 55,
        levelBandMin: 50,
        levelBandMax: 75,
        clueType: CrosswordClueType.conceptual,
        tags: ['adult', 'worship', 'jummah', 'assembled'],
        dailyThemes: ['jummah'],
        isDailyEligible: true,
        fallbackPuzzleId: 'adult_jummah_khutbah',
      ),
    ];

    final fallbackById = {
      for (final puzzle in fallbackPuzzles) puzzle.id: puzzle,
    };
    return requests
        .map(
          (request) => _assemblePuzzle(
            request: request,
            entries: entries,
            templates: templates,
            fallbackById: fallbackById,
          ),
        )
        .whereType<CrosswordPuzzle>()
        .toList(growable: false);
  }

  CrosswordPuzzle? _assemblePuzzle({
    required _CrosswordAssemblyRequest request,
    required List<CrosswordEntry> entries,
    required List<CrosswordLayoutTemplate> templates,
    required Map<String, CrosswordPuzzle> fallbackById,
  }) {
    final template = templates
        .where((item) => item.id == request.templateId)
        .firstOrNull;
    if (template == null || template.mode != request.mode) {
      return _fallbackAssembledPuzzle(
        request,
        fallbackById,
        reason: 'template missing or incompatible',
      );
    }

    final eligible =
        entries
            .where((entry) => entry.mode == request.mode)
            .where(
              (entry) =>
                  entry.category == request.category ||
                  entry.theme == request.category ||
                  entry.tags.contains(request.category) ||
                  request.tags.any(entry.tags.contains) ||
                  entry.packTags.any(request.tags.contains),
            )
            .where(
              (entry) =>
                  entry.difficulty >= request.levelBandMin &&
                  entry.difficulty <= request.levelBandMax,
            )
            .toList(growable: false)
          ..sort((a, b) {
            final difficultyCompare = a.difficulty.compareTo(b.difficulty);
            if (difficultyCompare != 0) return difficultyCompare;
            return a.id.compareTo(b.id);
          });

    final selected = <CrosswordEntry>[];
    final usedIds = <String>{};
    for (final slot in template.slots) {
      final match = eligible.where((entry) {
        return !usedIds.contains(entry.id) &&
            entry.normalizedAnswer.length == slot.length;
      }).firstOrNull;
      if (match == null) {
        return _fallbackAssembledPuzzle(
          request,
          fallbackById,
          reason: 'no entry for slot length ${slot.length}',
        );
      }
      selected.add(match);
      usedIds.add(match.id);
    }

    final grid = List.generate(
      template.gridSize,
      (_) => List<String>.filled(template.gridSize, ''),
      growable: false,
    );
    final clues = <CrosswordClue>[];
    for (var index = 0; index < template.slots.length; index += 1) {
      final slot = template.slots[index];
      final entry = selected[index];
      final answer = entry.normalizedAnswer;
      for (var letterIndex = 0; letterIndex < answer.length; letterIndex += 1) {
        final row = slot.row + (slot.isAcross ? 0 : letterIndex);
        final col = slot.col + (slot.isAcross ? letterIndex : 0);
        if (row >= template.gridSize || col >= template.gridSize) {
          return _fallbackAssembledPuzzle(
            request,
            fallbackById,
            reason: 'template overflow at $row,$col',
          );
        }
        final current = grid[row][col];
        final nextLetter = answer[letterIndex];
        if (current.isNotEmpty && current != nextLetter) {
          return _fallbackAssembledPuzzle(
            request,
            fallbackById,
            reason: 'template collision at $row,$col',
          );
        }
        grid[row][col] = nextLetter;
      }
      clues.add(
        CrosswordClue(
          id: '${request.id}:${entry.id}',
          entryId: entry.id,
          clue: entry.clue,
          answer: answer,
          row: slot.row,
          col: slot.col,
          isAcross: slot.isAcross,
          category: entry.category,
          sourceType: entry.sourceType,
          tags: entry.tags,
          hint: entry.hint,
          imageKey: entry.imageKey,
          audioKey: entry.audioKey,
          theme: entry.theme,
          clueType: entry.clueType,
        ),
      );
    }

    return CrosswordPuzzle(
      id: request.id,
      mode: request.mode,
      category: request.category,
      difficulty: request.difficulty,
      gridSize: template.gridSize,
      clues: clues,
      solutionGrid: grid,
      tags: request.tags,
      levelBandMin: request.levelBandMin,
      levelBandMax: request.levelBandMax,
      clueType: request.clueType,
      dailyThemes: request.dailyThemes,
      isDailyEligible: request.isDailyEligible,
      layoutKey: template.id,
      isAssembled: true,
      sourcePackIds: [request.packId],
    );
  }

  CrosswordPuzzle? _fallbackAssembledPuzzle(
    _CrosswordAssemblyRequest request,
    Map<String, CrosswordPuzzle> fallbackById, {
    required String reason,
  }) {
    assert(() {
      debugPrint(
        'Crossword assembly fallback for ${request.id}: $reason -> ${request.fallbackPuzzleId}',
      );
      return true;
    }());
    final fallback = fallbackById[request.fallbackPuzzleId];
    if (fallback == null) return null;
    return CrosswordPuzzle(
      id: request.id,
      mode: fallback.mode,
      category: request.category,
      difficulty: request.difficulty,
      gridSize: fallback.gridSize,
      clues: fallback.clues,
      solutionGrid: fallback.solutionGrid,
      tags: request.tags,
      levelBandMin: request.levelBandMin,
      levelBandMax: request.levelBandMax,
      clueType: request.clueType,
      dailyThemes: request.dailyThemes,
      isDailyEligible: request.isDailyEligible,
      layoutKey: fallback.layoutKey,
      isAssembled: true,
      sourcePackIds: [request.packId],
    );
  }

  List<CrosswordPuzzlePack> _buildPacks(List<CrosswordPuzzle> puzzles) {
    List<String> idsFor({
      CrosswordMode? mode,
      String? category,
      Iterable<String> tags = const <String>[],
      bool? dailyEligible,
    }) {
      return puzzles
          .where((puzzle) => mode == null || puzzle.mode == mode)
          .where((puzzle) => category == null || puzzle.category == category)
          .where(
            (puzzle) =>
                tags.isEmpty || tags.any((tag) => puzzle.tags.contains(tag)),
          )
          .where(
            (puzzle) =>
                dailyEligible == null ||
                puzzle.isDailyEligible == dailyEligible,
          )
          .map((puzzle) => puzzle.id)
          .toList(growable: false);
    }

    final packs = <CrosswordPuzzlePack>[
      CrosswordPuzzlePack(
        id: 'kids_basics',
        titleKey: 'crosswordPackKidsBasicsTitle',
        descriptionKey: 'crosswordPackKidsBasicsSubtitle',
        mode: 'kids',
        category: 'letters',
        minDifficulty: 1,
        maxDifficulty: 10,
        puzzleIds: idsFor(mode: CrosswordMode.kids),
        tags: const ['featured', 'kids'],
        isDailyEligible: false,
        isFeatured: true,
      ),
      CrosswordPuzzlePack(
        id: 'adult_foundations',
        titleKey: 'crosswordPackAdultFoundationsTitle',
        descriptionKey: 'crosswordPackAdultFoundationsSubtitle',
        mode: 'adult',
        category: 'mixed',
        minDifficulty: 10,
        maxDifficulty: 75,
        puzzleIds: idsFor(mode: CrosswordMode.adult),
        tags: const ['featured', 'adult'],
        isDailyEligible: true,
        isFeatured: true,
      ),
      CrosswordPuzzlePack(
        id: 'daily_rotation',
        titleKey: 'crosswordPackDailyTitle',
        descriptionKey: 'crosswordPackDailySubtitle',
        mode: 'daily',
        category: 'mixed',
        minDifficulty: 10,
        maxDifficulty: 75,
        puzzleIds: idsFor(mode: CrosswordMode.adult, dailyEligible: true),
        tags: const ['daily'],
        isDailyEligible: true,
        isFeatured: true,
      ),
      CrosswordPuzzlePack(
        id: 'quran_reflection',
        titleKey: 'crosswordPackQuranTitle',
        descriptionKey: 'crosswordPackQuranSubtitle',
        mode: 'adult',
        category: 'quran',
        minDifficulty: 25,
        maxDifficulty: 50,
        puzzleIds: idsFor(category: 'quran'),
        tags: const ['quran'],
        isDailyEligible: true,
        isFeatured: false,
      ),
      CrosswordPuzzlePack(
        id: 'hadith_reflection',
        titleKey: 'crosswordPackHadithTitle',
        descriptionKey: 'crosswordPackHadithSubtitle',
        mode: 'adult',
        category: 'hadith',
        minDifficulty: 25,
        maxDifficulty: 50,
        puzzleIds: idsFor(category: 'hadith'),
        tags: const ['hadith', 'character'],
        isDailyEligible: true,
        isFeatured: false,
      ),
      CrosswordPuzzlePack(
        id: 'prophet_stories',
        titleKey: 'crosswordPackProphetsTitle',
        descriptionKey: 'crosswordPackProphetsSubtitle',
        mode: 'adult',
        category: 'prophets',
        minDifficulty: 10,
        maxDifficulty: 25,
        puzzleIds: idsFor(category: 'prophets'),
        tags: const ['prophets'],
        isDailyEligible: true,
        isFeatured: false,
      ),
      CrosswordPuzzlePack(
        id: 'dua_words',
        titleKey: 'crosswordPackDuasTitle',
        descriptionKey: 'crosswordPackDuasSubtitle',
        mode: 'adult',
        category: 'duas',
        minDifficulty: 25,
        maxDifficulty: 50,
        puzzleIds: idsFor(category: 'duas'),
        tags: const ['duas'],
        isDailyEligible: true,
        isFeatured: false,
      ),
      CrosswordPuzzlePack(
        id: 'worship_practice',
        titleKey: 'crosswordPackWorshipTitle',
        descriptionKey: 'crosswordPackWorshipSubtitle',
        mode: 'adult',
        category: 'worship',
        minDifficulty: 25,
        maxDifficulty: 75,
        puzzleIds: idsFor(category: 'worship'),
        tags: const ['worship', 'jummah'],
        isDailyEligible: true,
        isFeatured: false,
      ),
      CrosswordPuzzlePack(
        id: 'character_adab',
        titleKey: 'crosswordPackCharacterTitle',
        descriptionKey: 'crosswordPackCharacterSubtitle',
        mode: 'mixed',
        category: 'character',
        minDifficulty: 1,
        maxDifficulty: 50,
        puzzleIds: idsFor(tags: const ['character']),
        tags: const ['character', 'adab'],
        isDailyEligible: false,
        isFeatured: false,
      ),
      CrosswordPuzzlePack(
        id: 'mixed_challenge',
        titleKey: 'crosswordPackMixedTitle',
        descriptionKey: 'crosswordPackMixedSubtitle',
        mode: 'adult',
        category: 'mixed',
        minDifficulty: 50,
        maxDifficulty: 75,
        puzzleIds: idsFor(category: 'mixed'),
        tags: const ['mixed', 'history'],
        isDailyEligible: true,
        isFeatured: false,
      ),
    ];
    return packs
        .where((pack) => pack.puzzleIds.isNotEmpty)
        .toList(growable: false);
  }

  List<CrosswordEntry> _kidsEntries() {
    String childClue(String label) => 'Find the simple word linked to $label.';

    final lookup = {for (final letter in kidsArabicLetters) letter.id: letter};

    CrosswordEntry fromLetterName(String id, String answer) {
      final letter = lookup[id]!;
      return CrosswordEntry(
        id: 'kids_$id',
        mode: CrosswordMode.kids,
        category: 'letters',
        difficulty: 1,
        clue: childClue(letter.nameEn),
        answer: answer,
        hint: letter.childFriendlyLine,
        imageKey: letter.id,
        sourceType: 'kids_arabic',
        tags: [letter.nameEn, letter.exampleWordEn, 'kids', 'letters'],
        theme: 'letters',
        levelBandMin: 1,
        levelBandMax: 10,
        packTags: const ['kids', 'letters'],
        sourceId: letter.id,
      );
    }

    CrosswordEntry fromExampleWord(String id, String answer) {
      final letter = lookup[id]!;
      return CrosswordEntry(
        id: 'kids_${normalizeCrosswordAnswer(answer).toLowerCase()}',
        mode: CrosswordMode.kids,
        category: 'worship',
        difficulty: 2,
        clue: 'Complete the friendly word from the ${letter.nameEn} lesson.',
        answer: answer,
        hint: letter.childFriendlyLine,
        imageKey: letter.id,
        audioKey: letter.id,
        sourceType: 'kids_arabic',
        tags: [letter.exampleWordEn, letter.nameEn, 'kids'],
        theme: 'kids',
        levelBandMin: 1,
        levelBandMax: 10,
        packTags: const ['kids', 'worship'],
        sourceId: letter.id,
      );
    }

    return [
      fromLetterName('alif', 'ALIF'),
      fromExampleWord('alif', 'ALLAH'),
      fromLetterName('ba', 'BA'),
      fromLetterName('fa', 'FA'),
      fromExampleWord('dal', 'DEEN'),
      fromExampleWord('dhal', 'DHIKR'),
      fromExampleWord('ha', 'HALAL'),
      fromExampleWord('ha2', 'HUDA'),
      fromExampleWord('kha', 'KHAYR'),
      fromExampleWord('kaf', 'KITAB'),
      fromLetterName('noon', 'NOON'),
      fromExampleWord('noon', 'NOOR'),
      fromLetterName('qaf', 'QAF'),
      fromExampleWord('qaf', 'QURAN'),
      fromExampleWord('sad', 'SALAH'),
      fromExampleWord('seen', 'SUJOOD'),
      fromLetterName('waw', 'WAW'),
      fromExampleWord('waw', 'WUDU'),
      fromLetterName('ya', 'YA'),
      fromExampleWord('ya', 'YAQEEN'),
      fromExampleWord('fa', 'FAJR'),
      fromExampleWord('meem', 'MASJID'),
      fromExampleWord('ain', 'ILM'),
    ];
  }

  List<CrosswordEntry> _prophetEntries(List<ProphetEntry> prophets) {
    CrosswordEntry? fromProphet(String id, CrosswordMode mode, int difficulty) {
      final prophet = prophets.where((entry) => entry.id == id).firstOrNull;
      if (prophet == null) return null;
      return CrosswordEntry(
        id: 'prophet_$id',
        mode: mode,
        category: 'prophets',
        difficulty: difficulty,
        clue: prophet.shortSummary,
        answer: prophet.name,
        hint: prophet.regionLabel,
        sourceType: 'prophets',
        tags: [prophet.eraTitle, prophet.regionLabel, ...prophet.keyLessons],
        theme: 'prophets',
        clueType: difficulty >= 46
            ? CrosswordClueType.conceptual
            : CrosswordClueType.contextual,
        levelBandMin: difficulty < 25 ? 10 : 50,
        levelBandMax: difficulty < 25 ? 25 : 75,
        packTags: const ['adult', 'prophets'],
        sourceId: prophet.id,
      );
    }

    return [
      fromProphet('adam', CrosswordMode.adult, 12),
      fromProphet('ayyub', CrosswordMode.adult, 12),
      fromProphet('ibrahim', CrosswordMode.adult, 16),
      fromProphet('isa', CrosswordMode.adult, 16),
      fromProphet('musa', CrosswordMode.adult, 20),
      fromProphet('muhammad', CrosswordMode.adult, 20),
      fromProphet('yahya', CrosswordMode.adult, 24),
      fromProphet('yunus', CrosswordMode.adult, 24),
      fromProphet('dawud', CrosswordMode.adult, 46),
      fromProphet('salih', CrosswordMode.adult, 46),
    ].whereType<CrosswordEntry>().toList(growable: false);
  }

  List<CrosswordEntry> _hadithEntries(List<HadithEntry> hadithEntries) {
    HadithEntry? find(String id) =>
        hadithEntries.where((entry) => entry.id == id).firstOrNull;

    final intentions = find('intentions_core');
    final sincerity = find('religion_sincerity');
    final lawful = find('lawful_unlawful_clear');
    final ihsan = find('leave_what_not_concern');

    return [
      if (intentions != null)
        CrosswordEntry(
          id: 'hadith_intention',
          mode: CrosswordMode.adult,
          category: 'hadith',
          difficulty: 28,
          clue: intentions.title,
          answer: 'INTENTION',
          hint: intentions.sourceLabel,
          sourceType: 'hadith',
          tags: intentions.tags,
          theme: 'hadith',
          clueType: CrosswordClueType.contextual,
          levelBandMin: 25,
          levelBandMax: 50,
          packTags: const ['adult', 'hadith', 'character'],
          sourceId: intentions.id,
        ),
      if (sincerity != null)
        CrosswordEntry(
          id: 'hadith_sincerity',
          mode: CrosswordMode.adult,
          category: 'hadith',
          difficulty: 28,
          clue: sincerity.title,
          answer: 'SINCERITY',
          hint: sincerity.sourceLabel,
          sourceType: 'hadith',
          tags: sincerity.tags,
          theme: 'hadith',
          clueType: CrosswordClueType.contextual,
          levelBandMin: 25,
          levelBandMax: 50,
          packTags: const ['adult', 'hadith', 'character'],
          sourceId: sincerity.id,
        ),
      if (lawful != null)
        CrosswordEntry(
          id: 'hadith_halal',
          mode: CrosswordMode.adult,
          category: 'hadith',
          difficulty: 32,
          clue: lawful.title,
          answer: 'HALAL',
          hint: lawful.sourceLabel,
          sourceType: 'hadith',
          tags: [...lawful.tags, 'character'],
          theme: 'hadith',
          clueType: CrosswordClueType.contextual,
          levelBandMin: 25,
          levelBandMax: 50,
          packTags: const ['adult', 'hadith', 'character'],
          sourceId: lawful.id,
        ),
      if (ihsan != null)
        CrosswordEntry(
          id: 'hadith_ihsan',
          mode: CrosswordMode.adult,
          category: 'hadith',
          difficulty: 32,
          clue:
              'Excellence in Islam hinted in the teaching about leaving what does not concern you.',
          answer: 'IHSAN',
          hint: ihsan.sourceLabel,
          sourceType: 'hadith',
          tags: [...ihsan.tags, 'character'],
          theme: 'hadith',
          clueType: CrosswordClueType.contextual,
          levelBandMin: 25,
          levelBandMax: 50,
          packTags: const ['adult', 'hadith', 'character'],
          sourceId: ihsan.id,
        ),
    ];
  }

  List<CrosswordEntry> _quranAndDuaEntries(List<QuranCoreWord> quranWords) {
    final byNormalizedWord = {
      for (final word in quranWords)
        normalizeCrosswordAnswer(word.transliteration): word,
    };

    QuranCoreWord? quranWord(String normalized) => byNormalizedWord[normalized];

    final sabrWord = quranWord('SABR');
    final rahmahWord = quranWord('RAHMAH');
    final hudaWord = quranWord('HUDA');

    final quranSalah = duaSeedDataset.items
        .where((item) => item.id == 'quran_014_040_establish_prayer')
        .firstOrNull;
    final quranSabr = duaSeedDataset.items
        .where((item) => item.id == 'quran_002_250_pour_patience')
        .firstOrNull;
    final quranRahmah = duaSeedDataset.items
        .where((item) => item.id == 'quran_003_008_no_deviation')
        .firstOrNull;
    final quranOffspring = duaSeedDataset.items
        .where((item) => item.id == 'quran_003_038_pious_offspring')
        .firstOrNull;

    return [
      if (quranSabr != null)
        CrosswordEntry(
          id: 'quran_sabr',
          mode: CrosswordMode.adult,
          category: 'quran',
          difficulty: 36,
          clue: quranSabr.title,
          answer: 'SABR',
          hint: quranSabr.sourceRef,
          sourceType: 'quran',
          tags: quranSabr.tags,
          theme: 'quran',
          clueType: CrosswordClueType.contextual,
          levelBandMin: 25,
          levelBandMax: 50,
          packTags: const ['adult', 'quran'],
          sourceId: quranSabr.id,
        ),
      if (quranRahmah != null)
        CrosswordEntry(
          id: 'quran_rahmah',
          mode: CrosswordMode.adult,
          category: 'quran',
          difficulty: 36,
          clue: quranRahmah.title,
          answer: 'RAHMAH',
          hint: quranRahmah.sourceRef,
          sourceType: 'quran',
          tags: quranRahmah.tags,
          theme: 'quran',
          clueType: CrosswordClueType.contextual,
          levelBandMin: 25,
          levelBandMax: 50,
          packTags: const ['adult', 'quran'],
          sourceId: quranRahmah.id,
        ),
      if (quranSalah != null)
        CrosswordEntry(
          id: 'quran_salah',
          mode: CrosswordMode.adult,
          category: 'worship',
          difficulty: 40,
          clue: quranSalah.title,
          answer: 'SALAH',
          hint: quranSalah.sourceRef,
          sourceType: 'dua',
          tags: [...quranSalah.tags, 'worship'],
          theme: 'quran',
          clueType: CrosswordClueType.contextual,
          levelBandMin: 25,
          levelBandMax: 50,
          packTags: const ['adult', 'worship', 'quran'],
          sourceId: quranSalah.id,
        ),
      CrosswordEntry(
        id: 'quran_huda',
        mode: CrosswordMode.adult,
        category: 'worship',
        difficulty: 40,
        clue: 'A Qur’anic word for guidance and right direction.',
        answer: 'HUDA',
        hint: hudaWord?.meaning ?? 'Guidance',
        sourceType: 'quran_word',
        tags: [
          if (hudaWord != null) hudaWord.meaning,
          'guidance',
          'quran',
          'worship',
        ],
        theme: 'quran',
        clueType: CrosswordClueType.contextual,
        levelBandMin: 25,
        levelBandMax: 50,
        packTags: const ['adult', 'quran', 'worship'],
        sourceId: hudaWord?.rank.toString(),
      ),
      CrosswordEntry(
        id: 'dua_rabbana',
        mode: CrosswordMode.adult,
        category: 'duas',
        difficulty: 46,
        clue:
            'Many Qur’anic supplications begin with this address to our Lord.',
        answer: 'RABBANA',
        hint: 'A common opening in Qur’anic duas.',
        sourceType: 'dua',
        tags: const ['dua', 'quran', 'supplication'],
        theme: 'duas',
        clueType: CrosswordClueType.contextual,
        levelBandMin: 25,
        levelBandMax: 50,
        packTags: const ['adult', 'duas'],
      ),
      if (quranOffspring != null)
        CrosswordEntry(
          id: 'dua_offspring',
          mode: CrosswordMode.adult,
          category: 'duas',
          difficulty: 46,
          clue: quranOffspring.title,
          answer: 'OFFSPRING',
          hint: quranOffspring.sourceRef,
          sourceType: 'dua',
          tags: quranOffspring.tags,
          theme: 'duas',
          clueType: CrosswordClueType.contextual,
          levelBandMin: 25,
          levelBandMax: 50,
          packTags: const ['adult', 'duas'],
          sourceId: quranOffspring.id,
        ),
      if (sabrWord != null)
        CrosswordEntry(
          id: 'quran_word_sabr',
          mode: CrosswordMode.adult,
          category: 'quran',
          difficulty: 30,
          clue: 'A core Qur’anic word meaning patient perseverance.',
          answer: sabrWord.transliteration,
          hint: sabrWord.meaning,
          sourceType: 'quran_word',
          tags: [sabrWord.meaning, 'quran'],
          theme: 'quran',
          clueType: CrosswordClueType.contextual,
          levelBandMin: 25,
          levelBandMax: 50,
          packTags: const ['adult', 'quran'],
          sourceId: sabrWord.rank.toString(),
        ),
      if (rahmahWord != null)
        CrosswordEntry(
          id: 'quran_word_rahmah',
          mode: CrosswordMode.adult,
          category: 'quran',
          difficulty: 30,
          clue: 'A core Qur’anic word for mercy.',
          answer: rahmahWord.transliteration,
          hint: rahmahWord.meaning,
          sourceType: 'quran_word',
          tags: [rahmahWord.meaning, 'quran'],
          theme: 'quran',
          clueType: CrosswordClueType.contextual,
          levelBandMin: 25,
          levelBandMax: 50,
          packTags: const ['adult', 'quran'],
          sourceId: rahmahWord.rank.toString(),
        ),
      CrosswordEntry(
        id: 'word_jummah',
        mode: CrosswordMode.adult,
        category: 'worship',
        difficulty: 55,
        clue: 'The blessed weekly congregational day for Muslims.',
        answer: 'JUMMAH',
        hint: 'The weekly day of gathering and khutbah.',
        sourceType: 'learn',
        tags: const ['worship', 'friday', 'jummah'],
        theme: 'jummah',
        clueType: CrosswordClueType.conceptual,
        isDailyEligible: true,
        levelBandMin: 50,
        levelBandMax: 75,
        packTags: const ['adult', 'worship', 'jummah'],
      ),
      CrosswordEntry(
        id: 'word_khutbah',
        mode: CrosswordMode.adult,
        category: 'worship',
        difficulty: 55,
        clue: 'The sermon delivered before the Friday prayer.',
        answer: 'KHUTBAH',
        hint: 'It comes before Jumu‘ah prayer.',
        sourceType: 'learn',
        tags: const ['worship', 'friday', 'sermon'],
        theme: 'jummah',
        clueType: CrosswordClueType.conceptual,
        isDailyEligible: true,
        levelBandMin: 50,
        levelBandMax: 75,
        packTags: const ['adult', 'worship', 'jummah'],
      ),
      CrosswordEntry(
        id: 'word_hira',
        mode: CrosswordMode.adult,
        category: 'mixed',
        difficulty: 58,
        clue: 'The cave associated with the first revelation.',
        answer: 'HIRA',
        hint: 'A cave near Makkah.',
        sourceType: 'history',
        tags: const ['history', 'revelation', 'makkah'],
        theme: 'mixed',
        clueType: CrosswordClueType.conceptual,
        isDailyEligible: true,
        levelBandMin: 50,
        levelBandMax: 75,
        packTags: const ['adult', 'mixed', 'history'],
      ),
      CrosswordEntry(
        id: 'word_badr',
        mode: CrosswordMode.adult,
        category: 'mixed',
        difficulty: 58,
        clue: 'The famous early battle remembered in Ramadan.',
        answer: 'BADR',
        hint: 'A major victory in early Islamic history.',
        sourceType: 'history',
        tags: const ['history', 'battle', 'ramadan'],
        theme: 'mixed',
        clueType: CrosswordClueType.conceptual,
        isDailyEligible: true,
        levelBandMin: 50,
        levelBandMax: 75,
        packTags: const ['adult', 'mixed', 'history'],
      ),
    ];
  }
}

int _weekOfYear(DateTime date) {
  final firstDay = DateTime(date.year, 1, 1);
  return ((date.difference(firstDay).inDays) / 7).floor() + 1;
}

class _CrosswordAssemblyRequest {
  const _CrosswordAssemblyRequest({
    required this.id,
    required this.templateId,
    required this.mode,
    required this.category,
    required this.difficulty,
    required this.levelBandMin,
    required this.levelBandMax,
    required this.clueType,
    required this.tags,
    required this.fallbackPuzzleId,
    this.dailyThemes = const <String>[],
    this.isDailyEligible = false,
  });

  final String id;
  final String templateId;
  final CrosswordMode mode;
  final String category;
  final int difficulty;
  final int levelBandMin;
  final int levelBandMax;
  final CrosswordClueType clueType;
  final List<String> tags;
  final List<String> dailyThemes;
  final bool isDailyEligible;
  final String fallbackPuzzleId;

  String get packId => mode == CrosswordMode.kids
      ? 'kids_basics'
      : switch (category) {
          'quran' => 'quran_reflection',
          'hadith' => 'hadith_reflection',
          'prophets' => 'prophet_stories',
          'duas' => 'dua_words',
          'worship' => 'worship_practice',
          'character' => 'character_adab',
          'mixed' => 'mixed_challenge',
          _ => 'adult_foundations',
        };
}

final crosswordRepositoryProvider = Provider<CrosswordRepository>(
  (_) => const CrosswordRepository(),
);

final crosswordContentBundleProvider = Provider<CrosswordContentBundle>(
  (_) => crosswordContentBundle,
);

final crosswordCatalogProvider = FutureProvider<CrosswordCatalog>((ref) async {
  final repository = ref.watch(crosswordRepositoryProvider);
  final prophets = ref.watch(prophetsProvider);
  final hadithEntries = ref.watch(hadithEntriesProvider);
  final quranWords = await ref.watch(quranCoreWordsProvider.future);
  return repository.buildCatalog(
    prophets: prophets,
    hadithEntries: hadithEntries,
    quranWords: quranWords,
  );
});

final crosswordValidationReportProvider =
    Provider<AsyncValue<CrosswordValidationReport>>((ref) {
      final catalogAsync = ref.watch(crosswordCatalogProvider);
      return catalogAsync.whenData(CrosswordValidation.validateCatalog);
    });

final crosswordPuzzleByIdProvider =
    FutureProvider.family<CrosswordPuzzle?, String>((ref, puzzleId) async {
      final catalog = await ref.watch(crosswordCatalogProvider.future);
      return catalog.puzzlesById[puzzleId];
    });

final crosswordPackByIdProvider =
    FutureProvider.family<CrosswordPuzzlePack?, String>((ref, packId) async {
      final catalog = await ref.watch(crosswordCatalogProvider.future);
      return catalog.packsById[packId];
    });

final crosswordDailyPuzzleProvider = FutureProvider<CrosswordDailyPuzzle>((
  ref,
) async {
  final catalog = await ref.watch(crosswordCatalogProvider.future);
  final repository = ref.watch(crosswordRepositoryProvider);
  final progress = ref.watch(crosswordProgressProvider);
  final adaptiveProfile = ref.watch(userLearningProfileProvider);
  final isChildProfile = ref.watch(
    activeFamilyLearningContextProvider.select(
      (value) => value.visibilityPolicy.isChildProfile,
    ),
  );
  return repository.dailyPuzzleForDate(
    catalog,
    DateTime.now(),
    mode: isChildProfile ? CrosswordMode.kids : CrosswordMode.adult,
    progressState: progress,
    adaptiveProfile: adaptiveProfile,
  );
});
