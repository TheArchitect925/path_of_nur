import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/utils/reward_feedback.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../journey/application/journey_progression_provider.dart';
import '../../../journey/drops/application/journey_drops_providers.dart';
import '../../../journey/xp/application/journey_xp_providers.dart';
import '../../journey/application/family_learning_provider.dart';
import '../../knowledge_games/adaptive/application/user_learning_profile_provider.dart';
import '../../knowledge_games/application/knowledge_game_variation_engine.dart';
import '../../knowledge_games/daily/domain/daily_knowledge_challenge_models.dart';
import '../../knowledge_games/domain/knowledge_game_variations.dart';
import '../application/word_search_game_adapter.dart';
import '../application/word_search_progress_provider.dart';
import '../application/word_search_repository.dart';
import '../data/word_search_seed_data.dart';
import '../domain/word_search_models.dart';
import 'word_search_ui_helpers.dart';

class WordSearchPuzzlePage extends ConsumerStatefulWidget {
  const WordSearchPuzzlePage({
    super.key,
    this.puzzleId,
    this.dailyMode = false,
    this.packId,
  });

  final String? puzzleId;
  final bool dailyMode;
  final String? packId;

  @override
  ConsumerState<WordSearchPuzzlePage> createState() =>
      _WordSearchPuzzlePageState();
}

class _WordSearchPuzzlePageState extends ConsumerState<WordSearchPuzzlePage> {
  final GlobalKey _gridKey = GlobalKey();
  WordSearchPuzzle? _boundPuzzle;
  (int, int)? _selectionStart;
  (int, int)? _selectionCurrent;

  @override
  Widget build(BuildContext context) {
    if (widget.dailyMode) {
      final dailyAsync = ref.watch(wordSearchDailyPuzzleProvider);
      return dailyAsync.when(
        loading: () => _buildLoading(context),
        error: (_, _) => _buildLoadError(context),
        data: (daily) => _buildLoaded(context, daily.puzzle, daily: daily),
      );
    }
    final puzzleAsync = ref.watch(
      wordSearchPuzzleByIdProvider(widget.puzzleId ?? ''),
    );
    return puzzleAsync.when(
      loading: () => _buildLoading(context),
      error: (_, _) => _buildLoadError(context),
      data: (puzzle) {
        if (puzzle == null) return _buildNotFound(context);
        return _buildLoaded(context, puzzle);
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
    return AppPageScaffold(
      title: AppLocalizations.of(context).wordSearchHomeTitle,
      subtitle: AppLocalizations.of(context).wordSearchLoadingSubtitle,
      children: const [Center(child: CircularProgressIndicator())],
    );
  }

  Widget _buildLoadError(BuildContext context) {
    return AppPageScaffold(
      title: AppLocalizations.of(context).wordSearchHomeTitle,
      subtitle: AppLocalizations.of(context).wordSearchLoadErrorSubtitle,
      children: [
        PremiumCard(
          child: Text(AppLocalizations.of(context).wordSearchLoadErrorTitle),
        ),
      ],
    );
  }

  Widget _buildNotFound(BuildContext context) {
    return AppPageScaffold(
      title: AppLocalizations.of(context).wordSearchHomeTitle,
      subtitle: AppLocalizations.of(context).wordSearchNotFoundSubtitle,
      children: [
        PremiumCard(
          child: Text(AppLocalizations.of(context).wordSearchNotFoundTitle),
        ),
      ],
    );
  }

  Widget _buildLoaded(
    BuildContext context,
    WordSearchPuzzle puzzle, {
    WordSearchDailyPuzzle? daily,
  }) {
    final l10n = AppLocalizations.of(context);
    final isChildProfile = ref.watch(
      activeFamilyLearningContextProvider.select(
        (value) => value.visibilityPolicy.isChildProfile,
      ),
    );
    if (isChildProfile && puzzle.mode != WordSearchMode.kids) {
      return AppPageScaffold(
        title: l10n.wordSearchHomeTitle,
        subtitle: l10n.wordSearchNotFoundSubtitle,
        children: [PremiumCard(child: Text(l10n.wordSearchKidsOnlyTitle))],
      );
    }

    final progressState = ref.watch(wordSearchProgressProvider);
    final progress = progressState.progressFor(puzzle.id);
    final dailyProgress = daily == null
        ? null
        : progressState.dailyProgressFor(daily.dateKey);
    final dailyStreak = daily == null
        ? null
        : progressState.dailyStreakSummary(DateTime.now());
    _bindPuzzleIfNeeded(puzzle, progress, daily: daily);

    final adapter = ref.watch(wordSearchGameAdapterProvider);
    final variationConfig = _variationConfig(daily);
    final game = adapter.toGame(puzzle).copyWith(config: variationConfig);
    final session = adapter
        .createSession(game: puzzle, progress: progress)
        .copyWith(config: variationConfig);
    final result = adapter
        .evaluate(
          game: puzzle,
          progress: progress,
          xpEarned: progress.isCompleted ? (progress.isPerfect ? 2 : 1) : 0,
          dropsEarned: progress.foundWordIds.length,
        )
        .copyWith(config: variationConfig);
    final currentPath = _currentPath();
    final currentSelectionPlacement = _matchingPlacement(puzzle, currentPath);
    final title = wordSearchPuzzleTitle(l10n, puzzle);
    final subtitle = daily != null
        ? l10n.wordSearchDailyPuzzleSubtitle(
            wordSearchLocalizedCategory(l10n, daily.weekdayTheme),
          )
        : l10n.wordSearchPuzzleSubtitle(
            wordSearchLocalizedCategory(l10n, puzzle.category),
            puzzle.gridSize.toString(),
          );

    final catalog = ref.watch(wordSearchCatalogProvider).valueOrNull;
    final pack = catalog?.packsById[widget.packId ?? ''];
    final nextPackPuzzleId = pack?.puzzleIds.firstWhere(
      (id) => id != puzzle.id && !progressState.progressFor(id).isCompleted,
      orElse: () => '',
    );

    return adapter.buildScreen(
      context: context,
      title: title,
      subtitle: subtitle,
      game: game,
      session: session,
      result: result,
      children: [
        PremiumCard(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip(
                context,
                l10n.wordSearchFoundCountLabel(
                  progress.foundWordIds.length.toString(),
                  puzzle.targetWords.length.toString(),
                ),
              ),
              _chip(
                context,
                wordSearchDifficultyLabel(l10n, puzzle.difficulty),
              ),
              if (daily != null)
                _chip(
                  context,
                  l10n.wordSearchDailyThemeLabel(
                    wordSearchLocalizedCategory(l10n, daily.weekdayTheme),
                  ),
                ),
              if (dailyStreak != null && dailyStreak.currentStreak > 0)
                _chip(
                  context,
                  l10n.wordSearchDailyStreakLabel(
                    dailyStreak.currentStreak.toString(),
                  ),
                ),
              if (pack != null) _chip(context, wordSearchPackTitle(l10n, pack)),
              if (progress.isPerfect)
                _chip(context, l10n.wordSearchPerfectBadge),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.wordSearchHintSectionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (variationConfig.hasVariation(GameVariationType.fog)) ...[
                const SizedBox(height: 6),
                Text(l10n.gameVariationFogActiveSubtitle),
              ],
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: _canUseRevealFirstLetter(puzzle, progress)
                        ? () => _useRevealFirstLetter(puzzle)
                        : null,
                    icon: const Icon(Icons.lightbulb_outline_rounded),
                    label: Text(l10n.wordSearchHintRevealLetter),
                  ),
                  FilledButton.tonalIcon(
                    onPressed:
                        _canUseHighlightWord(
                          puzzle,
                          progress,
                          sequential: variationConfig.hasVariation(
                            GameVariationType.sequential,
                          ),
                        )
                        ? () => _useHighlightWord(puzzle)
                        : null,
                    icon: const Icon(Icons.highlight_alt_rounded),
                    label: Text(l10n.wordSearchHintHighlightWord),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                l10n.wordSearchHintUsageLabel(
                  progress.revealFirstLetterUses.toString(),
                  progress.highlightWordUses.toString(),
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.wordSearchGridSectionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                currentSelectionPlacement == null && currentPath.isNotEmpty
                    ? l10n.wordSearchSelectionHint
                    : l10n.wordSearchSelectionReady,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              _buildGrid(context, puzzle, progress, currentPath),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.wordSearchWordListTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (variationConfig.hasVariation(
                GameVariationType.sequential,
              )) ...[
                const SizedBox(height: 6),
                Text(l10n.gameVariationSequentialActiveSubtitle),
              ],
              const SizedBox(height: 12),
              ...puzzle.placements.map(
                (placement) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildWordTile(
                    context,
                    puzzle: puzzle,
                    placement: placement,
                    progress: progress,
                    isSelected:
                        currentSelectionPlacement?.entryId == placement.entryId,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
          child: result.completed
              ? PremiumCard(
                  key: const ValueKey('word-search-complete'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.wordSearchCompletionTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        result.perfect
                            ? l10n.wordSearchPerfectSubtitle
                            : l10n.wordSearchCompletionSubtitle,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        buildCompactRewardSummary(
                          l10n,
                          xp: result.xpEarned,
                          drops: result.dropsEarned,
                        ),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (dailyProgress?.isCompleted == true) ...[
                        const SizedBox(height: 10),
                        Text(
                          l10n.wordSearchDailyCompleteBadge,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if ((nextPackPuzzleId ?? '').isNotEmpty)
                            FilledButton.tonalIcon(
                              onPressed: () => context.pushNamed(
                                'learnWordSearchPuzzle',
                                pathParameters: {'puzzleId': nextPackPuzzleId!},
                                queryParameters: pack == null
                                    ? const <String, String>{}
                                    : {'pack': pack.id},
                              ),
                              icon: const Icon(Icons.arrow_forward_rounded),
                              label: Text(l10n.wordSearchNextPuzzleAction),
                            ),
                          if (pack != null)
                            FilledButton.tonalIcon(
                              onPressed: () => context.pop(),
                              icon: const Icon(Icons.grid_view_rounded),
                              label: Text(l10n.wordSearchReturnToPackAction),
                            ),
                          FilledButton.tonalIcon(
                            onPressed: () =>
                                context.goNamed('learnWordSearchHome'),
                            icon: const Icon(Icons.home_rounded),
                            label: Text(l10n.wordSearchBackHomeAction),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildGrid(
    BuildContext context,
    WordSearchPuzzle puzzle,
    WordSearchPuzzleProgress progress,
    List<(int, int)> currentPath,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final cellSize = math.max(40.0, width / puzzle.gridSize);
        final highlightedCells = _highlightedCellsForProgress(puzzle, progress);
        return RepaintBoundary(
          child: GestureDetector(
            key: _gridKey,
            behavior: HitTestBehavior.opaque,
            onPanStart: (details) =>
                _handleGridPan(puzzle, details.localPosition),
            onPanUpdate: (details) =>
                _handleGridPan(puzzle, details.localPosition),
            onPanEnd: (_) => _finalizeSelection(puzzle),
            onTapUp: (details) => _handleGridTap(puzzle, details.localPosition),
            child: SizedBox(
              width: puzzle.gridSize * cellSize,
              height: puzzle.gridSize * cellSize,
              child: Column(
                children: List.generate(puzzle.gridSize, (row) {
                  return Expanded(
                    child: Row(
                      children: List.generate(puzzle.gridSize, (col) {
                        final key = '$row:$col';
                        final isInCurrentPath = currentPath.contains((
                          row,
                          col,
                        ));
                        final isFoundCell = highlightedCells.contains(key);
                        final isAnchor = _selectionStart == (row, col);
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: isAnchor
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer
                                  : isInCurrentPath
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.secondaryContainer
                                  : isFoundCell
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.tertiaryContainer
                                  : Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    isInCurrentPath || isFoundCell || isAnchor
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.outline
                                          .withValues(alpha: 0.18),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Semantics(
                              label: AppLocalizations.of(context)
                                  .wordSearchCellSemanticsLabel(
                                    (row + 1).toString(),
                                    (col + 1).toString(),
                                    puzzle.letterGrid[row][col],
                                  ),
                              child: Text(
                                puzzle.letterGrid[row][col],
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWordTile(
    BuildContext context, {
    required WordSearchPuzzle puzzle,
    required WordSearchPlacement placement,
    required WordSearchPuzzleProgress progress,
    required bool isSelected,
  }) {
    final l10n = AppLocalizations.of(context);
    final variationConfig = _variationConfig(
      widget.dailyMode
          ? ref.read(wordSearchDailyPuzzleProvider).valueOrNull
          : null,
    );
    final entry = wordSearchSeedEntries.firstWhere(
      (item) => item.id == placement.entryId,
    );
    final isFound = progress.foundWordIds.contains(placement.entryId);
    final revealUsed = progress.revealedFirstLetterWordIds.contains(
      placement.entryId,
    );
    final highlightUsed = progress.highlightedWordIds.contains(
      placement.entryId,
    );
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.secondaryContainer
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isFound
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip(context, wordSearchLocalizedCategory(l10n, entry.category)),
              if (isFound) _chip(context, l10n.wordSearchFoundBadge),
              if (revealUsed)
                _chip(
                  context,
                  l10n.wordSearchRevealedLetterBadge(entry.normalizedAnswer[0]),
                ),
              if (highlightUsed)
                _chip(context, l10n.wordSearchHighlightedBadge),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            variationConfig.hasVariation(GameVariationType.fog) && !isFound
                ? '${entry.displayLabel.substring(0, 1)} •••'
                : entry.displayLabel,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          if (!variationConfig.hasVariation(GameVariationType.memory) ||
              isFound)
            Text(entry.clue)
          else
            Text(l10n.gameVariationMemoryActiveSubtitle),
          if ((entry.hint ?? '').isNotEmpty &&
              !variationConfig.hasVariation(GameVariationType.memory)) ...[
            const SizedBox(height: 4),
            Text(
              l10n.wordSearchExtraHint(entry.hint!),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label),
    );
  }

  void _bindPuzzleIfNeeded(
    WordSearchPuzzle puzzle,
    WordSearchPuzzleProgress progress, {
    WordSearchDailyPuzzle? daily,
  }) {
    if (_boundPuzzle?.id == puzzle.id) return;
    _boundPuzzle = puzzle;
    _selectionStart = _cellFromKey(progress.selectedStartCellKey);
    _selectionCurrent = _cellFromKey(progress.selectedEndCellKey);
    final now = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(wordSearchProgressProvider.notifier)
          .markPuzzlePlayed(puzzleId: puzzle.id, occurredAt: now);
      if (daily != null) {
        ref
            .read(wordSearchProgressProvider.notifier)
            .markDailyStarted(
              dateKey: daily.dateKey,
              puzzleId: puzzle.id,
              weekdayTheme: daily.weekdayTheme,
              occurredAt: now,
            );
      }
    });
  }

  void _handleGridTap(WordSearchPuzzle puzzle, Offset localPosition) {
    final cell = _cellForLocalPosition(puzzle, localPosition);
    if (cell == null) return;
    setState(() {
      if (_selectionStart == null) {
        _selectionStart = cell;
        _selectionCurrent = cell;
      } else {
        _selectionCurrent = cell;
      }
    });
    _persistSelection(puzzle.id);
    if (_selectionStart != null &&
        _selectionCurrent != null &&
        _selectionStart != _selectionCurrent) {
      _finalizeSelection(puzzle);
    }
  }

  void _handleGridPan(WordSearchPuzzle puzzle, Offset localPosition) {
    final cell = _cellForLocalPosition(puzzle, localPosition);
    if (cell == null) return;
    setState(() {
      _selectionStart ??= cell;
      _selectionCurrent = cell;
    });
    _persistSelection(puzzle.id);
  }

  void _finalizeSelection(WordSearchPuzzle puzzle) {
    final path = _currentPath();
    if (path.length < 2) {
      setState(() {
        _selectionCurrent = _selectionStart;
      });
      _persistSelection(puzzle.id);
      return;
    }
    final placement = _matchingPlacement(puzzle, path);
    final now = DateTime.now();
    if (placement == null) {
      ref
          .read(wordSearchProgressProvider.notifier)
          .markMistake(puzzleId: puzzle.id, occurredAt: now);
      _clearSelection(puzzle.id);
      return;
    }
    final config = _variationConfig(
      widget.dailyMode
          ? ref.read(wordSearchDailyPuzzleProvider).valueOrNull
          : null,
    );
    if (config.hasVariation(GameVariationType.sequential)) {
      final progress = ref
          .read(wordSearchProgressProvider)
          .progressFor(puzzle.id);
      final expected = puzzle.placements.firstWhere(
        (item) => !progress.foundWordIds.contains(item.entryId),
        orElse: () => placement,
      );
      if (expected.entryId != placement.entryId) {
        ref
            .read(wordSearchProgressProvider.notifier)
            .markMistake(puzzleId: puzzle.id, occurredAt: now);
        _clearSelection(puzzle.id);
        return;
      }
    }
    final changed = ref
        .read(wordSearchProgressProvider.notifier)
        .markWordFound(
          puzzleId: puzzle.id,
          wordId: placement.entryId,
          occurredAt: now,
        );
    if (changed) {
      ref
          .read(journeyDropSummaryProvider.notifier)
          .awardLearningDrop(
            sourceRef: 'word_search:word:${puzzle.id}:${placement.entryId}',
            occurredAt: now,
            metadata: {
              'gameType': 'word_search',
              'puzzleId': puzzle.id,
              'wordId': placement.entryId,
            },
          );
    }
    _clearSelection(puzzle.id);
    _checkCompletion(puzzle);
  }

  void _checkCompletion(WordSearchPuzzle puzzle) {
    final progress = ref
        .read(wordSearchProgressProvider)
        .progressFor(puzzle.id);
    if (progress.foundWordIds.length < puzzle.placements.length) return;
    final now = DateTime.now();
    final perfect = !progress.hadMistake && !progress.usedAnyHint;
    final progressNotifier = ref.read(wordSearchProgressProvider.notifier);
    final changed = progressNotifier.markPuzzleCompleted(
      puzzleId: puzzle.id,
      perfect: perfect,
      occurredAt: now,
    );
    if (!changed) return;
    if (progressNotifier.markCompletionRewardGranted(
      puzzleId: puzzle.id,
      occurredAt: now,
    )) {
      ref
          .read(journeyXpSummaryProvider.notifier)
          .awardLearningXp(
            sourceRef: 'word_search:completion:${puzzle.id}',
            occurredAt: now,
            metadata: {'gameType': 'word_search', 'puzzleId': puzzle.id},
          );
      ref
          .read(journeyProgressUpdateHelperProvider)
          .addLearningStageCompletions(1);
    }
    if (perfect &&
        progressNotifier.markPerfectRewardGranted(
          puzzleId: puzzle.id,
          occurredAt: now,
        )) {
      ref
          .read(journeyXpSummaryProvider.notifier)
          .awardLearningXp(
            sourceRef: 'word_search:perfect:${puzzle.id}',
            occurredAt: now,
            metadata: {'gameType': 'word_search', 'puzzleId': puzzle.id},
          );
    }
    final variationBonusXp = ref
        .read(knowledgeGameVariationEngineProvider)
        .completionBonusXp(
          config: _variationConfig(
            widget.dailyMode
                ? ref.read(wordSearchDailyPuzzleProvider).valueOrNull
                : null,
          ),
          startedAt: DateTime.tryParse(progress.startedAtIso ?? '') ?? now,
          completedAt: now,
          perfect: perfect,
          usedAnyHint: progress.usedAnyHint,
        );
    if (variationBonusXp > 0) {
      ref
          .read(journeyXpSummaryProvider.notifier)
          .awardLearningXp(
            sourceRef: 'word_search:variation_bonus:${puzzle.id}',
            occurredAt: now,
            metadata: {
              'gameType': 'word_search',
              'puzzleId': puzzle.id,
              'variationBonusXp': variationBonusXp,
            },
          );
    }

    if (widget.dailyMode) {
      final daily = ref.read(wordSearchDailyPuzzleProvider).valueOrNull;
      if (daily != null) {
        final startedAt = DateTime.tryParse(progress.startedAtIso ?? '') ?? now;
        final timeTaken = now.difference(startedAt).inSeconds;
        final dailyChanged = progressNotifier.markDailyCompleted(
          dateKey: daily.dateKey,
          puzzleId: puzzle.id,
          weekdayTheme: daily.weekdayTheme,
          perfect: perfect,
          timeTakenSeconds: timeTaken,
          occurredAt: now,
        );
        if (dailyChanged &&
            progressNotifier.markDailyRewardGranted(
              dateKey: daily.dateKey,
              occurredAt: now,
            )) {
          ref
              .read(journeyXpSummaryProvider.notifier)
              .awardLearningXp(
                sourceRef: 'word_search:daily:${daily.dateKey}',
                occurredAt: now,
                metadata: {'gameType': 'word_search', 'puzzleId': puzzle.id},
              );
        }
      }
    }
  }

  void _useRevealFirstLetter(WordSearchPuzzle puzzle) {
    final progress = ref
        .read(wordSearchProgressProvider)
        .progressFor(puzzle.id);
    final target = puzzle.placements.firstWhere(
      (item) =>
          !progress.foundWordIds.contains(item.entryId) &&
          !progress.revealedFirstLetterWordIds.contains(item.entryId),
      orElse: () => puzzle.placements.first,
    );
    ref
        .read(wordSearchProgressProvider.notifier)
        .revealFirstLetter(
          puzzleId: puzzle.id,
          wordId: target.entryId,
          occurredAt: DateTime.now(),
        );
  }

  void _useHighlightWord(WordSearchPuzzle puzzle) {
    final progress = ref
        .read(wordSearchProgressProvider)
        .progressFor(puzzle.id);
    final target = puzzle.placements.firstWhere(
      (item) =>
          !progress.foundWordIds.contains(item.entryId) &&
          !progress.highlightedWordIds.contains(item.entryId),
      orElse: () => puzzle.placements.first,
    );
    ref
        .read(wordSearchProgressProvider.notifier)
        .highlightWord(
          puzzleId: puzzle.id,
          wordId: target.entryId,
          occurredAt: DateTime.now(),
        );
  }

  bool _canUseRevealFirstLetter(
    WordSearchPuzzle puzzle,
    WordSearchPuzzleProgress progress,
  ) {
    final limit = puzzle.mode == WordSearchMode.kids ? 3 : 2;
    return progress.revealFirstLetterUses < limit &&
        puzzle.placements.any(
          (item) => !progress.foundWordIds.contains(item.entryId),
        );
  }

  bool _canUseHighlightWord(
    WordSearchPuzzle puzzle,
    WordSearchPuzzleProgress progress, {
    bool sequential = false,
  }) {
    final limit = puzzle.mode == WordSearchMode.kids ? 2 : 1;
    return progress.highlightWordUses < limit &&
        puzzle.placements.any((item) {
          if (progress.foundWordIds.contains(item.entryId)) return false;
          if (!sequential) return true;
          final firstUnfound = puzzle.placements.firstWhere(
            (placement) => !progress.foundWordIds.contains(placement.entryId),
            orElse: () => item,
          );
          return item.entryId == firstUnfound.entryId;
        });
  }

  void _persistSelection(String puzzleId) {
    ref
        .read(wordSearchProgressProvider.notifier)
        .setSelection(
          puzzleId: puzzleId,
          startCellKey: _selectionStart == null
              ? null
              : '${_selectionStart!.$1}:${_selectionStart!.$2}',
          endCellKey: _selectionCurrent == null
              ? null
              : '${_selectionCurrent!.$1}:${_selectionCurrent!.$2}',
          cellKeys: _currentPath()
              .map((item) => '${item.$1}:${item.$2}')
              .toList(),
          occurredAt: DateTime.now(),
        );
  }

  void _clearSelection(String puzzleId) {
    setState(() {
      _selectionStart = null;
      _selectionCurrent = null;
    });
    _persistSelection(puzzleId);
  }

  List<(int, int)> _currentPath() {
    final start = _selectionStart;
    final end = _selectionCurrent;
    if (start == null || end == null) return const <(int, int)>[];
    return _pathBetween(start, end);
  }

  List<(int, int)> _pathBetween((int, int) start, (int, int) end) {
    final rowDelta = end.$1 - start.$1;
    final colDelta = end.$2 - start.$2;
    final rowStep = rowDelta == 0 ? 0 : rowDelta ~/ rowDelta.abs();
    final colStep = colDelta == 0 ? 0 : colDelta ~/ colDelta.abs();
    if (!(rowDelta == 0 || colDelta == 0 || rowDelta.abs() == colDelta.abs())) {
      return const <(int, int)>[];
    }
    final length = math.max(rowDelta.abs(), colDelta.abs()) + 1;
    return List.generate(
      length,
      (index) => (start.$1 + (rowStep * index), start.$2 + (colStep * index)),
      growable: false,
    );
  }

  WordSearchPlacement? _matchingPlacement(
    WordSearchPuzzle puzzle,
    List<(int, int)> path,
  ) {
    if (path.length < 2) return null;
    for (final placement in puzzle.placements) {
      final placementPath = _pathBetween(
        (placement.startRow, placement.startCol),
        (placement.endRow, placement.endCol),
      );
      if (_samePath(placementPath, path) ||
          _samePath(placementPath.reversed.toList(growable: false), path)) {
        return placement;
      }
    }
    return null;
  }

  bool _samePath(List<(int, int)> a, List<(int, int)> b) {
    if (a.length != b.length) return false;
    for (var index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }

  Set<String> _highlightedCellsForProgress(
    WordSearchPuzzle puzzle,
    WordSearchPuzzleProgress progress,
  ) {
    final cells = <String>{};
    for (final placement in puzzle.placements) {
      final shouldShow =
          progress.foundWordIds.contains(placement.entryId) ||
          progress.highlightedWordIds.contains(placement.entryId);
      if (!shouldShow) continue;
      final path = _pathBetween(
        (placement.startRow, placement.startCol),
        (placement.endRow, placement.endCol),
      );
      for (final cell in path) {
        cells.add('${cell.$1}:${cell.$2}');
      }
    }
    return cells;
  }

  (int, int)? _cellForLocalPosition(
    WordSearchPuzzle puzzle,
    Offset localPosition,
  ) {
    final box = _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || box.size.width == 0 || box.size.height == 0) return null;
    final cellWidth = box.size.width / puzzle.gridSize;
    final cellHeight = box.size.height / puzzle.gridSize;
    final col = (localPosition.dx / cellWidth).floor();
    final row = (localPosition.dy / cellHeight).floor();
    if (row < 0 ||
        col < 0 ||
        row >= puzzle.gridSize ||
        col >= puzzle.gridSize) {
      return null;
    }
    return (row, col);
  }

  (int, int)? _cellFromKey(String? value) {
    if (value == null || value.isEmpty || !value.contains(':')) return null;
    final parts = value.split(':');
    if (parts.length != 2) return null;
    final row = int.tryParse(parts[0]);
    final col = int.tryParse(parts[1]);
    if (row == null || col == null) return null;
    return (row, col);
  }

  KnowledgeGameConfig _variationConfig(WordSearchDailyPuzzle? daily) {
    if (daily == null) return const KnowledgeGameConfig.standard();
    return ref
        .read(knowledgeGameVariationEngineProvider)
        .resolveDailyConfig(
          gameType: DailyKnowledgeGameType.wordSearch,
          dateKey: daily.dateKey,
          profile: ref.read(userLearningProfileProvider),
        );
  }
}
