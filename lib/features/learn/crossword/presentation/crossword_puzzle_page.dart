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
import '../../knowledge_games/presentation/knowledge_game_screen.dart';
import '../../knowledge_games/application/knowledge_game_variation_engine.dart';
import '../../knowledge_games/daily/domain/daily_knowledge_challenge_models.dart';
import '../../knowledge_games/domain/knowledge_game_variations.dart';
import '../application/crossword_progress_provider.dart';
import '../application/crossword_game_adapter.dart';
import '../application/crossword_repository.dart';
import '../domain/crossword_models.dart';
import 'crossword_ui_helpers.dart';

class CrosswordPuzzlePage extends ConsumerStatefulWidget {
  const CrosswordPuzzlePage({
    super.key,
    this.puzzleId,
    this.dailyMode = false,
    this.packId,
  });

  final String? puzzleId;
  final bool dailyMode;
  final String? packId;

  @override
  ConsumerState<CrosswordPuzzlePage> createState() =>
      _CrosswordPuzzlePageState();
}

class _CrosswordPuzzlePageState extends ConsumerState<CrosswordPuzzlePage> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  CrosswordPuzzle? _boundPuzzle;
  String? _selectedCellKey;
  CrosswordDirection _direction = CrosswordDirection.across;

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    for (final node in _focusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dailyMode) {
      final dailyAsync = ref.watch(crosswordDailyPuzzleProvider);
      return dailyAsync.when(
        loading: () => _buildLoading(context),
        error: (_, _) => _buildLoadError(context),
        data: (daily) => _buildLoaded(context, daily.puzzle, daily: daily),
      );
    }

    final puzzleAsync = ref.watch(
      crosswordPuzzleByIdProvider(widget.puzzleId ?? ''),
    );
    return puzzleAsync.when(
      loading: () => _buildLoading(context),
      error: (_, _) => _buildLoadError(context),
      data: (puzzle) {
        if (puzzle == null) {
          return _buildNotFound(context);
        }
        return _buildLoaded(context, puzzle);
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
    return AppPageScaffold(
      title: AppLocalizations.of(context).crosswordHomeTitle,
      subtitle: AppLocalizations.of(context).crosswordLoadingSubtitle,
      children: const [Center(child: CircularProgressIndicator())],
    );
  }

  Widget _buildLoadError(BuildContext context) {
    return AppPageScaffold(
      title: AppLocalizations.of(context).crosswordHomeTitle,
      subtitle: AppLocalizations.of(context).crosswordLoadErrorSubtitle,
      children: [
        PremiumCard(
          child: Text(AppLocalizations.of(context).crosswordLoadErrorTitle),
        ),
      ],
    );
  }

  Widget _buildNotFound(BuildContext context) {
    return AppPageScaffold(
      title: AppLocalizations.of(context).crosswordHomeTitle,
      subtitle: AppLocalizations.of(context).crosswordNotFoundSubtitle,
      children: [
        PremiumCard(
          child: Text(AppLocalizations.of(context).crosswordNotFoundTitle),
        ),
      ],
    );
  }

  Widget _buildLoaded(
    BuildContext context,
    CrosswordPuzzle puzzle, {
    CrosswordDailyPuzzle? daily,
  }) {
    final l10n = AppLocalizations.of(context);
    final isChildProfile = ref.watch(
      activeFamilyLearningContextProvider.select(
        (value) => value.visibilityPolicy.isChildProfile,
      ),
    );
    if (isChildProfile && puzzle.mode != CrosswordMode.kids) {
      return AppPageScaffold(
        title: l10n.crosswordHomeTitle,
        subtitle: l10n.crosswordNotFoundSubtitle,
        children: [PremiumCard(child: Text(l10n.crosswordKidsOnlyTitle))],
      );
    }

    final progressState = ref.watch(crosswordProgressProvider);
    final progress = progressState.progressFor(puzzle.id);
    final dailyProgress = daily == null
        ? null
        : progressState.dailyProgressFor(daily.dateKey);
    final dailyStreak = daily == null
        ? null
        : progressState.dailyStreakSummary(DateTime.now());
    _bindPuzzleIfNeeded(puzzle, progress, daily: daily);

    final currentClue = _currentClue(puzzle);
    final solvedCount = progress.solvedClueIds.length;
    final totalCount = puzzle.clues.length;
    final adapter = ref.watch(crosswordGameAdapterProvider);
    final variationConfig = _variationConfig(daily);
    final knowledgeGame = adapter
        .toGame(puzzle)
        .copyWith(config: variationConfig);
    final session = adapter
        .createSession(game: puzzle, progress: progress)
        .copyWith(config: variationConfig);
    final result = adapter
        .evaluate(
          game: puzzle,
          progress: progress,
          xpEarned: progress.isCompleted ? (progress.isPerfect ? 2 : 1) : 0,
          dropsEarned: progress.solvedClueIds.length,
        )
        .copyWith(config: variationConfig);
    final catalog = ref.watch(crosswordCatalogProvider).valueOrNull;
    final pack = widget.packId == null || catalog == null
        ? null
        : catalog.packsById[widget.packId!];
    String? nextPackPuzzleId;
    if (pack != null && catalog != null) {
      nextPackPuzzleId = pack.puzzleIds
          .where((id) => id != puzzle.id)
          .firstWhere(
            (id) => !progressState.progressFor(id).isCompleted,
            orElse: () => '',
          )
          .trim();
    }

    final title = crosswordPuzzleTitle(l10n, puzzle);
    final subtitle = daily != null
        ? l10n.crosswordDailyPuzzleSubtitle(
            crosswordLocalizedCategory(l10n, daily.weekdayTheme),
          )
        : l10n.crosswordPuzzleSubtitle(
            crosswordLocalizedCategory(l10n, puzzle.category),
            puzzle.gridSize.toString(),
          );

    return KnowledgeGameScreen(
      title: title,
      subtitle: subtitle,
      game: knowledgeGame,
      session: session,
      result: result,
      children: [
        PremiumCard(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _modeChip(
                context,
                _direction == CrosswordDirection.across
                    ? l10n.crosswordAcrossLabel
                    : l10n.crosswordDownLabel,
                selected: true,
                onTap: () {
                  setState(() {
                    _direction = _direction == CrosswordDirection.across
                        ? CrosswordDirection.down
                        : CrosswordDirection.across;
                  });
                  _persistSelection(puzzle.id);
                },
              ),
              _modeChip(
                context,
                l10n.crosswordSolvedCountLabel(
                  solvedCount.toString(),
                  totalCount.toString(),
                ),
              ),
              if (daily != null)
                _modeChip(
                  context,
                  l10n.crosswordDailyThemeLabel(
                    crosswordLocalizedCategory(l10n, daily.weekdayTheme),
                  ),
                ),
              if (dailyStreak != null && dailyStreak.currentStreak > 0)
                _modeChip(
                  context,
                  l10n.crosswordDailyStreakLabel(
                    dailyStreak.currentStreak.toString(),
                  ),
                ),
              if (pack != null)
                _modeChip(context, crosswordPackTitle(l10n, pack)),
              if (progress.isPerfect)
                _modeChip(context, l10n.crosswordPerfectBadge),
              if (!session.isCompleted &&
                  (progress.startedAtIso ?? '').isNotEmpty)
                _modeChip(context, l10n.crosswordResumeBadge),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (currentClue != null &&
            !variationConfig.hasVariation(GameVariationType.noClue)) ...[
          if (daily != null) ...[
            _buildDailyChallengeCard(
              context,
              puzzle: puzzle,
              progress: progress,
              daily: daily,
              dailyProgress: dailyProgress,
            ),
            const SizedBox(height: 12),
          ],
          _buildCurrentClueCard(
            context,
            puzzle: puzzle,
            clue: currentClue,
            progress: progress,
            daily: daily,
          ),
          const SizedBox(height: 12),
        ],
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.crosswordGridSectionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.crosswordProgressSavedSubtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              _buildGrid(context, puzzle, progress),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (variationConfig.hasVariation(GameVariationType.noClue))
          PremiumCard(child: Text(l10n.gameVariationNoClueActiveSubtitle))
        else
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.crosswordCluesSectionTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                ...puzzle.clues.map(
                  (clue) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildClueTile(
                      context,
                      clue: clue,
                      progress: progress,
                      isSelected: currentClue?.id == clue.id,
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
                  key: const ValueKey('crossword-complete'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.crosswordCompletionTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        result.perfect
                            ? l10n.crosswordPerfectSubtitle
                            : l10n.crosswordCompletionSubtitle,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        buildCompactRewardSummary(
                          l10n,
                          xp: result.xpEarned,
                          drops: result.dropsEarned,
                        ),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (dailyProgress?.isCompleted == true) ...[
                        const SizedBox(height: 10),
                        Text(
                          l10n.crosswordDailyCompleteBadge,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                      if (pack != null ||
                          (nextPackPuzzleId?.isNotEmpty ?? false)) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (nextPackPuzzleId?.isNotEmpty == true)
                              FilledButton.tonalIcon(
                                onPressed: () => context.pushReplacementNamed(
                                  'learnCrosswordPuzzle',
                                  pathParameters: {
                                    'puzzleId': nextPackPuzzleId!,
                                  },
                                  queryParameters: {
                                    if (pack != null) 'pack': pack.id,
                                  },
                                ),
                                icon: const Icon(Icons.arrow_forward_rounded),
                                label: Text(l10n.crosswordNextPuzzleAction),
                              ),
                            if (pack != null)
                              FilledButton.tonalIcon(
                                onPressed: () => context.pushReplacementNamed(
                                  'learnCrosswordPack',
                                  pathParameters: {'packId': pack.id},
                                ),
                                icon: const Icon(Icons.view_agenda_rounded),
                                label: Text(l10n.crosswordReturnToPackAction),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                )
              : PremiumCard(
                  key: const ValueKey('crossword-pending'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.crosswordResumeTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(l10n.crosswordResumeSubtitle),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  void _bindPuzzleIfNeeded(
    CrosswordPuzzle puzzle,
    CrosswordPuzzleProgress progress, {
    CrosswordDailyPuzzle? daily,
  }) {
    if (_boundPuzzle?.id == puzzle.id) return;
    _boundPuzzle = puzzle;
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    for (final node in _focusNodes.values) {
      node.dispose();
    }
    _controllers.clear();
    _focusNodes.clear();
    for (var row = 0; row < puzzle.gridSize; row += 1) {
      for (var col = 0; col < puzzle.gridSize; col += 1) {
        if (puzzle.solutionGrid[row][col].isEmpty) continue;
        final key = _cellKey(row, col);
        _controllers[key] = TextEditingController(
          text: _prefilledValueForCell(puzzle, progress, key),
        );
        _focusNodes[key] = FocusNode();
      }
    }
    final initialClue = puzzle.clues.firstOrNull;
    if (initialClue != null) {
      _selectedCellKey = _cellKey(initialClue.row, initialClue.col);
      _direction = initialClue.direction;
    }
    final restoredDirection = switch (progress.selectedDirection) {
      'down' => CrosswordDirection.down,
      'across' => CrosswordDirection.across,
      _ => null,
    };
    final restoredCellKey = progress.selectedCellKey;
    if (restoredCellKey != null && _controllers.containsKey(restoredCellKey)) {
      _selectedCellKey = restoredCellKey;
      if (restoredDirection != null) {
        _direction = restoredDirection;
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final now = DateTime.now();
      final notifier = ref.read(crosswordProgressProvider.notifier);
      notifier.markPuzzlePlayed(puzzleId: puzzle.id, occurredAt: now);
      if (daily != null) {
        notifier.markDailyStarted(
          dateKey: daily.dateKey,
          puzzleId: puzzle.id,
          weekdayTheme: daily.weekdayTheme,
          occurredAt: now,
        );
      }
    });
  }

  String _prefilledValueForCell(
    CrosswordPuzzle puzzle,
    CrosswordPuzzleProgress progress,
    String key,
  ) {
    final entry = progress.enteredLettersByCell[key];
    if ((entry ?? '').isNotEmpty) {
      return entry!;
    }
    for (final clue in puzzle.clues) {
      if (!progress.solvedClueIds.contains(clue.id) &&
          !progress.revealedClueIds.contains(clue.id)) {
        continue;
      }
      for (var index = 0; index < clue.answer.length; index += 1) {
        final row = clue.row + (clue.isAcross ? 0 : index);
        final col = clue.col + (clue.isAcross ? index : 0);
        if (_cellKey(row, col) == key) {
          return clue.answer[index];
        }
      }
    }
    return '';
  }

  Widget _buildDailyChallengeCard(
    BuildContext context, {
    required CrosswordPuzzle puzzle,
    required CrosswordPuzzleProgress progress,
    required CrosswordDailyPuzzle daily,
    required CrosswordDailyProgress? dailyProgress,
  }) {
    final l10n = AppLocalizations.of(context);
    final timeTakenSeconds =
        dailyProgress?.timeTakenSeconds ??
        _elapsedDailySeconds(
          startedAtIso: dailyProgress?.startedAtIso,
          endedAtIso: dailyProgress?.completedAtIso,
        );
    final achieved =
        dailyProgress?.bonusCompletedObjectiveIds ??
        ref
            .read(crosswordRepositoryProvider)
            .evaluateDailyObjectives(
              puzzle: puzzle,
              puzzleProgress: progress,
              timeTakenSeconds: timeTakenSeconds,
            );
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.crosswordDailyChallengeTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            l10n.crosswordDailyChallengeSubtitle(
              crosswordLocalizedCategory(l10n, daily.weekdayTheme),
            ),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _modeChip(
                context,
                l10n.crosswordDailyTargetDifficultyLabel(
                  daily.targetDifficulty.toString(),
                ),
              ),
              if (timeTakenSeconds != null && timeTakenSeconds > 0)
                _modeChip(
                  context,
                  l10n.crosswordDailyTimeTakenLabel(
                    _formatDuration(timeTakenSeconds),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ...daily.objectives.map(
            (objective) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildDailyObjectiveRow(
                context,
                objective: objective,
                achieved: achieved.contains(objective.id),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyObjectiveRow(
    BuildContext context, {
    required CrosswordDailyObjective objective,
    required bool achieved,
  }) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            achieved
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 18,
            color: achieved ? Theme.of(context).colorScheme.primary : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _dailyObjectiveTitle(l10n, objective),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  _dailyObjectiveSubtitle(l10n, objective),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentClueCard(
    BuildContext context, {
    required CrosswordPuzzle puzzle,
    required CrosswordClue clue,
    required CrosswordPuzzleProgress progress,
    CrosswordDailyPuzzle? daily,
  }) {
    final l10n = AppLocalizations.of(context);
    final revealLetterLimit = _revealLetterLimit(puzzle);
    final revealWordLimit = _revealWordLimit(puzzle);
    final extraHintLimit = _extraHintLimit(puzzle);
    final canRevealLetter =
        !progress.solvedClueIds.contains(clue.id) &&
        progress.revealLetterUses < revealLetterLimit;
    final canRevealWord =
        !progress.solvedClueIds.contains(clue.id) &&
        !progress.revealedClueIds.contains(clue.id) &&
        progress.revealWordUses < revealWordLimit;
    final hasExtraHint = (clue.hint ?? '').trim().isNotEmpty;
    final extraHintViewed = progress.extraHintViewedClueIds.contains(clue.id);
    final canViewExtraHint =
        hasExtraHint &&
        (extraHintViewed || progress.extraHintUses < extraHintLimit);

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.crosswordCurrentClueTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (daily != null)
                _modeChip(context, l10n.crosswordDailyModeTitle),
              if (progress.solvedClueIds.contains(clue.id))
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _modeChip(context, l10n.crosswordSolvedClueBadge),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(clue.clue, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 6),
          Text(
            l10n.crosswordClueMetaLabel(
              clue.answer.length.toString(),
              clue.isAcross
                  ? l10n.crosswordAcrossLabel
                  : l10n.crosswordDownLabel,
            ),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (extraHintViewed && hasExtraHint) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.18),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline_rounded, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      clue.hint!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: canRevealLetter
                    ? () => _handleRevealLetter(
                        puzzle: puzzle,
                        clue: clue,
                        progress: progress,
                        daily: daily,
                      )
                    : null,
                icon: const Icon(Icons.auto_fix_high_rounded),
                label: Text(
                  l10n.crosswordRevealLetterAction(
                    (revealLetterLimit - progress.revealLetterUses).toString(),
                  ),
                ),
              ),
              FilledButton.tonalIcon(
                onPressed: canRevealWord
                    ? () => _handleRevealWord(
                        puzzle: puzzle,
                        clue: clue,
                        daily: daily,
                      )
                    : null,
                icon: const Icon(Icons.visibility_rounded),
                label: Text(
                  l10n.crosswordRevealWordAction(
                    (revealWordLimit - progress.revealWordUses).toString(),
                  ),
                ),
              ),
              if (hasExtraHint)
                FilledButton.tonalIcon(
                  onPressed: canViewExtraHint
                      ? () => _handleViewExtraHint(puzzle: puzzle, clue: clue)
                      : null,
                  icon: const Icon(Icons.tips_and_updates_rounded),
                  label: Text(
                    extraHintViewed
                        ? l10n.crosswordExtraHintViewedAction
                        : l10n.crosswordExtraHintAction(
                            (extraHintLimit - progress.extraHintUses)
                                .toString(),
                          ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClueTile(
    BuildContext context, {
    required CrosswordClue clue,
    required CrosswordPuzzleProgress progress,
    required bool isSelected,
  }) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      button: true,
      selected: isSelected,
      label: l10n.crosswordClueSemanticsLabel(
        clue.clue,
        clue.answer.length.toString(),
        clue.isAcross ? l10n.crosswordAcrossLabel : l10n.crosswordDownLabel,
      ),
      child: InkWell(
        onTap: () => _focusClue(clue),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.06)
                : null,
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
                  : Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                clue.isAcross
                    ? Icons.arrow_forward_rounded
                    : Icons.arrow_downward_rounded,
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clue.clue,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.crosswordClueMetaLabel(
                        clue.answer.length.toString(),
                        clue.isAcross
                            ? l10n.crosswordAcrossLabel
                            : l10n.crosswordDownLabel,
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (isSelected) ...[
                      const SizedBox(height: 6),
                      Text(
                        l10n.crosswordSelectedClueBadge,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              if (progress.solvedClueIds.contains(clue.id))
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(
    BuildContext context,
    CrosswordPuzzle puzzle,
    CrosswordPuzzleProgress progress,
  ) {
    final size = MediaQuery.of(context).size.width;
    final maxGridWidth = math.min(size - 56, 440.0);
    final cellSize = math.max(maxGridWidth / puzzle.gridSize, 42.0);
    final lockedCells = _lockedCellKeys(puzzle, progress);
    final highlightedCells = currentClueCellKeys(puzzle);
    return Center(
      child: SizedBox(
        width: maxGridWidth,
        child: Column(
          children: List.generate(puzzle.gridSize, (row) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(puzzle.gridSize, (col) {
                final solution = puzzle.solutionGrid[row][col];
                if (solution.isEmpty) {
                  return Container(
                    width: cellSize,
                    height: cellSize,
                    margin: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }
                final key = _cellKey(row, col);
                final selected = _selectedCellKey == key;
                final controller = _controllers[key]!;
                final focusNode = _focusNodes[key]!;
                final highlighted = highlightedCells.contains(key);
                final isLocked = lockedCells.contains(key);
                return Semantics(
                  textField: true,
                  focused: selected,
                  enabled: !isLocked,
                  label: AppLocalizations.of(context)
                      .crosswordCellSemanticsLabel(
                        (row + 1).toString(),
                        (col + 1).toString(),
                        controller.text.isEmpty
                            ? AppLocalizations.of(
                                context,
                              ).crosswordCellEmptyValue
                            : controller.text,
                      ),
                  hint: highlighted
                      ? AppLocalizations.of(
                          context,
                        ).crosswordCellCurrentWordHint
                      : null,
                  child: Container(
                    width: cellSize,
                    height: cellSize,
                    margin: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: selected
                          ? Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.14)
                          : highlighted
                          ? Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.08)
                          : null,
                      border: Border.all(
                        color: selected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(
                                context,
                              ).colorScheme.outline.withValues(alpha: 0.25),
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        readOnly: isLocked,
                        onTap: () => _selectCell(puzzle.id, key),
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.characters,
                        maxLength: 1,
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                        onChanged: (value) => _handleCellChanged(
                          puzzle: puzzle,
                          row: row,
                          col: col,
                          rawValue: value,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ),
      ),
    );
  }

  Set<String> _lockedCellKeys(
    CrosswordPuzzle puzzle,
    CrosswordPuzzleProgress progress,
  ) {
    final keys = <String>{...progress.revealedCellKeys};
    for (final clue in puzzle.clues) {
      final isLocked =
          progress.solvedClueIds.contains(clue.id) ||
          progress.revealedClueIds.contains(clue.id);
      if (!isLocked) continue;
      keys.addAll(_cellKeysForClue(clue));
    }
    return keys;
  }

  Set<String> currentClueCellKeys(CrosswordPuzzle puzzle) {
    final clue = _currentClue(puzzle);
    if (clue == null) return const <String>{};
    return _cellKeysForClue(clue);
  }

  void _handleCellChanged({
    required CrosswordPuzzle puzzle,
    required int row,
    required int col,
    required String rawValue,
  }) {
    final sanitized = normalizeCrosswordAnswer(rawValue);
    final value = sanitized.isEmpty ? '' : sanitized[0];
    final key = _cellKey(row, col);
    final controller = _controllers[key]!;
    if (controller.text != value) {
      controller.value = TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    }
    final now = DateTime.now();
    ref
        .read(crosswordProgressProvider.notifier)
        .setCellEntry(
          puzzleId: puzzle.id,
          cellKey: key,
          value: value,
          occurredAt: now,
        );
    _selectCell(puzzle.id, key);
    _evaluatePuzzle(puzzle);
    if (value.isNotEmpty) {
      _moveToNextCell(puzzle, row, col);
    }
  }

  void _handleRevealLetter({
    required CrosswordPuzzle puzzle,
    required CrosswordClue clue,
    required CrosswordPuzzleProgress progress,
    CrosswordDailyPuzzle? daily,
  }) {
    final now = DateTime.now();
    for (var index = 0; index < clue.answer.length; index += 1) {
      final row = clue.row + (clue.isAcross ? 0 : index);
      final col = clue.col + (clue.isAcross ? index : 0);
      final key = _cellKey(row, col);
      final target = clue.answer[index];
      final current = normalizeCrosswordAnswer(_controllers[key]?.text ?? '');
      if (current == target) {
        continue;
      }
      final changed = ref
          .read(crosswordProgressProvider.notifier)
          .revealLetter(
            puzzleId: puzzle.id,
            clueId: clue.id,
            cellKey: key,
            occurredAt: now,
          );
      if (!changed) {
        continue;
      }
      _setControllerValue(key, target);
      ref
          .read(crosswordProgressProvider.notifier)
          .setCellEntry(
            puzzleId: puzzle.id,
            cellKey: key,
            value: target,
            occurredAt: now,
          );
      _selectCell(puzzle.id, key);
      _evaluatePuzzle(puzzle, daily: daily);
      return;
    }
  }

  void _handleRevealWord({
    required CrosswordPuzzle puzzle,
    required CrosswordClue clue,
    CrosswordDailyPuzzle? daily,
  }) {
    final now = DateTime.now();
    final cellKeys = _cellKeysForClue(clue);
    final changed = ref
        .read(crosswordProgressProvider.notifier)
        .revealWord(
          puzzleId: puzzle.id,
          clueId: clue.id,
          cellKeys: cellKeys,
          occurredAt: now,
        );
    if (!changed) return;
    for (var index = 0; index < clue.answer.length; index += 1) {
      final row = clue.row + (clue.isAcross ? 0 : index);
      final col = clue.col + (clue.isAcross ? index : 0);
      final key = _cellKey(row, col);
      final target = clue.answer[index];
      _setControllerValue(key, target);
      ref
          .read(crosswordProgressProvider.notifier)
          .setCellEntry(
            puzzleId: puzzle.id,
            cellKey: key,
            value: target,
            occurredAt: now,
          );
    }
    _selectCell(puzzle.id, _cellKey(clue.row, clue.col));
    _evaluatePuzzle(puzzle, daily: daily);
  }

  void _handleViewExtraHint({
    required CrosswordPuzzle puzzle,
    required CrosswordClue clue,
  }) {
    final viewed = ref
        .read(crosswordProgressProvider.notifier)
        .viewExtraHint(
          puzzleId: puzzle.id,
          clueId: clue.id,
          occurredAt: DateTime.now(),
        );
    if (viewed && mounted) {
      setState(() {});
    }
  }

  void _focusClue(CrosswordClue clue) {
    setState(() {
      _direction = clue.direction;
      _selectedCellKey = _cellKey(clue.row, clue.col);
    });
    _persistSelection(_boundPuzzle?.id);
    _focusNodes[_selectedCellKey!]?.requestFocus();
  }

  void _moveToNextCell(CrosswordPuzzle puzzle, int row, int col) {
    final next = _nextActiveCell(
      puzzle,
      row: row,
      col: col,
      direction: _direction,
    );
    if (next == null) return;
    final key = _cellKey(next.$1, next.$2);
    _selectCell(puzzle.id, key);
    _focusNodes[key]?.requestFocus();
  }

  void _selectCell(String puzzleId, String key) {
    setState(() => _selectedCellKey = key);
    _persistSelection(puzzleId);
  }

  void _persistSelection(String? puzzleId) {
    final cellKey = _selectedCellKey;
    if (puzzleId == null || cellKey == null) return;
    ref
        .read(crosswordProgressProvider.notifier)
        .setSelection(
          puzzleId: puzzleId,
          cellKey: cellKey,
          direction: _direction,
          occurredAt: DateTime.now(),
        );
  }

  (int, int)? _nextActiveCell(
    CrosswordPuzzle puzzle, {
    required int row,
    required int col,
    required CrosswordDirection direction,
  }) {
    var nextRow = row;
    var nextCol = col;
    for (var step = 0; step < puzzle.gridSize; step += 1) {
      nextRow += direction == CrosswordDirection.across ? 0 : 1;
      nextCol += direction == CrosswordDirection.across ? 1 : 0;
      if (nextRow >= puzzle.gridSize || nextCol >= puzzle.gridSize) {
        return null;
      }
      if (puzzle.solutionGrid[nextRow][nextCol].isNotEmpty) {
        return (nextRow, nextCol);
      }
    }
    return null;
  }

  CrosswordClue? _currentClue(CrosswordPuzzle puzzle) {
    if (_variationConfig(
      widget.dailyMode
          ? ref.read(crosswordDailyPuzzleProvider).valueOrNull
          : null,
    ).hasVariation(GameVariationType.sequential)) {
      final progress = ref
          .read(crosswordProgressProvider)
          .progressFor(puzzle.id);
      return puzzle.clues.firstWhere(
        (clue) => !progress.solvedClueIds.contains(clue.id),
        orElse: () => puzzle.clues.first,
      );
    }
    final selected = _selectedCellKey;
    if (selected != null) {
      final candidates = puzzle.clues
          .where((clue) => _cellKeysForClue(clue).contains(selected))
          .toList(growable: false);
      if (candidates.isNotEmpty) {
        return candidates
                .where((clue) => clue.direction == _direction)
                .firstOrNull ??
            candidates.first;
      }
    }
    return puzzle.clues.firstOrNull;
  }

  Set<String> _cellKeysForClue(CrosswordClue clue) {
    final keys = <String>{};
    for (var index = 0; index < clue.answer.length; index += 1) {
      final row = clue.row + (clue.isAcross ? 0 : index);
      final col = clue.col + (clue.isAcross ? index : 0);
      keys.add(_cellKey(row, col));
    }
    return keys;
  }

  void _evaluatePuzzle(CrosswordPuzzle puzzle, {CrosswordDailyPuzzle? daily}) {
    final notifier = ref.read(crosswordProgressProvider.notifier);
    final now = DateTime.now();
    for (final clue in puzzle.clues) {
      final latest = ref.read(crosswordProgressProvider).progressFor(puzzle.id);
      if (latest.solvedClueIds.contains(clue.id)) {
        continue;
      }
      final letters = <String>[];
      var fullyFilled = true;
      for (var index = 0; index < clue.answer.length; index += 1) {
        final row = clue.row + (clue.isAcross ? 0 : index);
        final col = clue.col + (clue.isAcross ? index : 0);
        final key = _cellKey(row, col);
        final value = normalizeCrosswordAnswer(_controllers[key]?.text ?? '');
        if (value.isEmpty) {
          fullyFilled = false;
          break;
        }
        letters.add(value);
      }
      if (!fullyFilled) continue;
      final attempted = letters.join();
      if (attempted == clue.answer) {
        if (notifier.markClueSolved(
          puzzleId: puzzle.id,
          clueId: clue.id,
          occurredAt: now,
        )) {
          ref
              .read(journeyDropSummaryProvider.notifier)
              .awardLearningDrop(
                sourceRef: 'crossword:${puzzle.id}:clue:${clue.id}',
                occurredAt: now,
                metadata: {
                  'feature': 'crossword',
                  'puzzleId': puzzle.id,
                  'clueId': clue.id,
                  'category': puzzle.category,
                },
              );
        }
      } else {
        notifier.markMistake(puzzleId: puzzle.id, occurredAt: now);
      }
    }

    final latest = ref.read(crosswordProgressProvider).progressFor(puzzle.id);
    final perfect = !latest.hadMistake && !latest.usedAnyHint;
    if (latest.solvedClueIds.length != puzzle.clues.length) {
      if (mounted) setState(() {});
      return;
    }

    notifier.markPuzzleCompleted(
      puzzleId: puzzle.id,
      perfect: perfect,
      occurredAt: now,
    );
    if (notifier.markCompletionRewardGranted(
      puzzleId: puzzle.id,
      occurredAt: now,
    )) {
      ref
          .read(journeyXpSummaryProvider.notifier)
          .awardLearningXp(
            sourceRef: 'crossword:${puzzle.id}:complete',
            occurredAt: now,
            sourceModule: 'crossword',
            metadata: {
              'feature': 'crossword',
              'puzzleId': puzzle.id,
              'category': puzzle.category,
              'mode': widget.dailyMode ? 'daily' : puzzle.mode.name,
            },
          );
      ref
          .read(journeyProgressUpdateHelperProvider)
          .addLearningStageCompletions(1);
    }
    if (perfect &&
        notifier.markPerfectRewardGranted(
          puzzleId: puzzle.id,
          occurredAt: now,
        )) {
      ref
          .read(journeyXpSummaryProvider.notifier)
          .awardLearningXp(
            sourceRef: 'crossword:${puzzle.id}:perfect',
            occurredAt: now,
            sourceModule: 'crossword',
            metadata: {
              'feature': 'crossword',
              'puzzleId': puzzle.id,
              'bonus': 'perfect',
            },
          );
    }
    final variationConfig = _variationConfig(daily);
    final variationBonusXp = ref
        .read(knowledgeGameVariationEngineProvider)
        .completionBonusXp(
          config: variationConfig,
          startedAt: DateTime.tryParse(latest.startedAtIso ?? '') ?? now,
          completedAt: now,
          perfect: perfect,
          usedAnyHint: latest.usedAnyHint,
        );
    if (variationBonusXp > 0) {
      ref
          .read(journeyXpSummaryProvider.notifier)
          .awardLearningXp(
            sourceRef: 'crossword:${puzzle.id}:variation_bonus',
            occurredAt: now,
            sourceModule: 'crossword',
            metadata: {
              'feature': 'crossword',
              'puzzleId': puzzle.id,
              'variationBonusXp': variationBonusXp,
              'variations': variationConfig.variations
                  .map((item) => item.name)
                  .toList(growable: false),
            },
          );
    }
    if (daily != null) {
      final timeTakenSeconds = _elapsedDailySeconds(
        startedAtIso: ref
            .read(crosswordProgressProvider)
            .dailyProgressFor(daily.dateKey)
            ?.startedAtIso,
        endedAtIso: now.toIso8601String(),
      );
      final achievedBonusObjectiveIds = ref
          .read(crosswordRepositoryProvider)
          .evaluateDailyObjectives(
            puzzle: puzzle,
            puzzleProgress: latest,
            timeTakenSeconds: timeTakenSeconds,
          );
      notifier.markDailyCompleted(
        dateKey: daily.dateKey,
        puzzleId: puzzle.id,
        weekdayTheme: daily.weekdayTheme,
        perfect: perfect,
        achievedBonusObjectiveIds: achievedBonusObjectiveIds,
        timeTakenSeconds: timeTakenSeconds,
        occurredAt: now,
      );
      if (notifier.markDailyRewardGranted(
        dateKey: daily.dateKey,
        puzzleId: puzzle.id,
        occurredAt: now,
      )) {
        ref
            .read(journeyXpSummaryProvider.notifier)
            .awardLearningXp(
              sourceRef: 'crossword:daily:${daily.dateKey}:complete',
              occurredAt: now,
              sourceModule: 'crossword',
              metadata: {
                'feature': 'crossword',
                'puzzleId': puzzle.id,
                'daily': true,
                'theme': daily.weekdayTheme,
              },
            );
      }
      if (achievedBonusObjectiveIds.length == daily.objectives.length &&
          notifier.markDailyBonusRewardGranted(
            dateKey: daily.dateKey,
            puzzleId: puzzle.id,
            occurredAt: now,
          )) {
        ref
            .read(journeyDropSummaryProvider.notifier)
            .awardLearningDrop(
              sourceRef: 'crossword:daily:${daily.dateKey}:bonus',
              occurredAt: now,
              metadata: {
                'feature': 'crossword',
                'puzzleId': puzzle.id,
                'daily': true,
                'bonusObjectives': achievedBonusObjectiveIds.length,
              },
            );
        ref
            .read(journeyDropSummaryProvider.notifier)
            .awardLearningDrop(
              sourceRef: 'crossword:daily:${daily.dateKey}:bonus:extra',
              occurredAt: now,
              metadata: {
                'feature': 'crossword',
                'puzzleId': puzzle.id,
                'daily': true,
                'bonus': 'complete_all',
              },
            );
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  int _revealLetterLimit(CrosswordPuzzle puzzle) {
    final config = _variationConfig(
      widget.dailyMode
          ? ref.read(crosswordDailyPuzzleProvider).valueOrNull
          : null,
    );
    if (config.hasVariation(GameVariationType.challenge) &&
        config.boolSetting('hintDisabled')) {
      return 0;
    }
    if (puzzle.mode == CrosswordMode.kids) return 5;
    if (puzzle.difficulty >= 50 || widget.dailyMode) return 2;
    return 3;
  }

  int _revealWordLimit(CrosswordPuzzle puzzle) {
    if (puzzle.mode == CrosswordMode.kids) return 2;
    return 1;
  }

  int _extraHintLimit(CrosswordPuzzle puzzle) {
    if (puzzle.mode == CrosswordMode.kids) return 3;
    if (puzzle.difficulty >= 50 || widget.dailyMode) return 1;
    return 2;
  }

  int? _elapsedDailySeconds({
    required String? startedAtIso,
    required String? endedAtIso,
  }) {
    final startedAt = DateTime.tryParse(startedAtIso ?? '');
    final endedAt = DateTime.tryParse(endedAtIso ?? '');
    if (startedAt == null || endedAt == null) return null;
    final seconds = endedAt.difference(startedAt).inSeconds;
    return seconds <= 0 ? null : seconds;
  }

  String _dailyObjectiveTitle(
    AppLocalizations l10n,
    CrosswordDailyObjective objective,
  ) {
    return switch (objective.type) {
      CrosswordDailyObjectiveType.perfect =>
        l10n.crosswordDailyObjectivePerfectTitle,
      CrosswordDailyObjectiveType.hintFree =>
        l10n.crosswordDailyObjectiveHintFreeTitle,
      CrosswordDailyObjectiveType.quickSolve =>
        l10n.crosswordDailyObjectiveQuickSolveTitle,
    };
  }

  String _dailyObjectiveSubtitle(
    AppLocalizations l10n,
    CrosswordDailyObjective objective,
  ) {
    return switch (objective.type) {
      CrosswordDailyObjectiveType.perfect =>
        l10n.crosswordDailyObjectivePerfectSubtitle,
      CrosswordDailyObjectiveType.hintFree =>
        l10n.crosswordDailyObjectiveHintFreeSubtitle,
      CrosswordDailyObjectiveType.quickSolve =>
        l10n.crosswordDailyObjectiveQuickSolveSubtitle(
          _formatDuration(objective.targetSeconds ?? 0),
        ),
    };
  }

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    if (minutes <= 0) {
      return '${seconds}s';
    }
    return '${minutes}m ${seconds.toString().padLeft(2, '0')}s';
  }

  KnowledgeGameConfig _variationConfig(CrosswordDailyPuzzle? daily) {
    if (daily == null) return const KnowledgeGameConfig.standard();
    return ref
        .read(knowledgeGameVariationEngineProvider)
        .resolveDailyConfig(
          gameType: DailyKnowledgeGameType.crossword,
          dateKey: daily.dateKey,
          profile: ref.read(userLearningProfileProvider),
        );
  }

  void _setControllerValue(String key, String value) {
    final controller = _controllers[key];
    if (controller == null) return;
    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  Widget _modeChip(
    BuildContext context,
    String label, {
    bool selected = false,
    VoidCallback? onTap,
  }) {
    final color = selected
        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12)
        : Theme.of(context).colorScheme.surface.withValues(alpha: 0.45);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  String _cellKey(int row, int col) => '$row:$col';
}
