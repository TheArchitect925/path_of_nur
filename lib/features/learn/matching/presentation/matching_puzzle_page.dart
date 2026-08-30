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
import '../application/matching_game_adapter.dart';
import '../application/matching_progress_provider.dart';
import '../application/matching_repository.dart';
import '../domain/matching_models.dart';
import 'matching_ui_helpers.dart';

class MatchingPuzzlePage extends ConsumerStatefulWidget {
  const MatchingPuzzlePage({
    super.key,
    this.puzzleId,
    this.dailyMode = false,
    this.packId,
  });

  final String? puzzleId;
  final bool dailyMode;
  final String? packId;

  @override
  ConsumerState<MatchingPuzzlePage> createState() => _MatchingPuzzlePageState();
}

class _MatchingPuzzlePageState extends ConsumerState<MatchingPuzzlePage> {
  MatchingPuzzle? _boundPuzzle;
  String? _transientErrorPairId;

  @override
  Widget build(BuildContext context) {
    if (widget.dailyMode) {
      final dailyAsync = ref.watch(matchingDailyPuzzleProvider);
      return dailyAsync.when(
        loading: () => _buildLoading(context),
        error: (_, _) => _buildLoadError(context),
        data: (daily) => _buildLoaded(context, daily.puzzle, daily: daily),
      );
    }
    final puzzleAsync = ref.watch(
      matchingPuzzleByIdProvider(widget.puzzleId ?? ''),
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
      title: AppLocalizations.of(context).matchingHomeTitle,
      subtitle: AppLocalizations.of(context).matchingLoadingSubtitle,
      children: const [Center(child: CircularProgressIndicator())],
    );
  }

  Widget _buildLoadError(BuildContext context) {
    return AppPageScaffold(
      title: AppLocalizations.of(context).matchingHomeTitle,
      subtitle: AppLocalizations.of(context).matchingLoadErrorSubtitle,
      children: [
        PremiumCard(
          child: Text(AppLocalizations.of(context).matchingLoadErrorTitle),
        ),
      ],
    );
  }

  Widget _buildNotFound(BuildContext context) {
    return AppPageScaffold(
      title: AppLocalizations.of(context).matchingHomeTitle,
      subtitle: AppLocalizations.of(context).matchingNotFoundSubtitle,
      children: [
        PremiumCard(
          child: Text(AppLocalizations.of(context).matchingNotFoundTitle),
        ),
      ],
    );
  }

  Widget _buildLoaded(
    BuildContext context,
    MatchingPuzzle puzzle, {
    MatchingDailyPuzzle? daily,
  }) {
    final l10n = AppLocalizations.of(context);
    final isChildProfile = ref.watch(
      activeFamilyLearningContextProvider.select(
        (value) => value.visibilityPolicy.isChildProfile,
      ),
    );
    if (isChildProfile && puzzle.mode != MatchingMode.kids) {
      return AppPageScaffold(
        title: l10n.matchingHomeTitle,
        subtitle: l10n.matchingNotFoundSubtitle,
        children: [PremiumCard(child: Text(l10n.matchingKidsOnlyTitle))],
      );
    }

    final progressState = ref.watch(matchingProgressProvider);
    final progress = progressState.progressFor(puzzle.id);
    final dailyProgress = daily == null
        ? null
        : progressState.dailyProgressFor(daily.dateKey);
    final dailyStreak = daily == null
        ? null
        : progressState.dailyStreakSummary(DateTime.now());
    _bindPuzzleIfNeeded(puzzle, daily: daily);

    final repository = ref.watch(matchingRepositoryProvider);
    final rightIds = repository.shuffledRightPairIds(
      puzzle,
      seedKey: daily?.dateKey ?? puzzle.id,
    );
    final adapter = ref.watch(matchingGameAdapterProvider);
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
          dropsEarned: progress.matchedPairIds.length,
        )
        .copyWith(config: variationConfig);

    final catalog = ref.watch(matchingCatalogProvider).valueOrNull;
    final pack = catalog?.packsById[widget.packId ?? ''];
    final nextPackPuzzleId = pack?.puzzleIds.firstWhere(
      (id) => id != puzzle.id && !progressState.progressFor(id).isCompleted,
      orElse: () => '',
    );

    final title = matchingPuzzleTitle(l10n, puzzle);
    final subtitle = daily != null
        ? l10n.matchingDailyPuzzleSubtitle(
            matchingLocalizedCategory(l10n, daily.weekdayTheme),
          )
        : l10n.matchingPuzzleSubtitle(
            matchingLocalizedCategory(l10n, puzzle.category),
            puzzle.pairs.length.toString(),
          );

    return KnowledgeGameScreen(
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
                l10n.matchingFoundCountLabel(
                  progress.matchedPairIds.length.toString(),
                  puzzle.pairs.length.toString(),
                ),
              ),
              _chip(context, matchingDifficultyLabel(l10n, puzzle.difficulty)),
              if (daily != null)
                _chip(
                  context,
                  l10n.matchingDailyThemeLabel(
                    matchingLocalizedCategory(l10n, daily.weekdayTheme),
                  ),
                ),
              if (dailyStreak != null && dailyStreak.currentStreak > 0)
                _chip(
                  context,
                  l10n.matchingDailyStreakLabel(
                    dailyStreak.currentStreak.toString(),
                  ),
                ),
              if (pack != null) _chip(context, matchingPackTitle(l10n, pack)),
              if (progress.isPerfect) _chip(context, l10n.matchingPerfectBadge),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.matchingHintSectionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: _canRevealPair(puzzle, progress)
                        ? () => _useRevealPair(puzzle)
                        : null,
                    icon: const Icon(Icons.lightbulb_outline_rounded),
                    label: Text(l10n.matchingHintRevealPair),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: _canRemoveWrongOption(puzzle, progress)
                        ? () => _useRemoveWrongOption(puzzle, rightIds)
                        : null,
                    icon: const Icon(Icons.remove_circle_outline_rounded),
                    label: Text(l10n.matchingHintRemoveOption),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                l10n.matchingHintUsageLabel(
                  progress.revealPairUses.toString(),
                  progress.removeWrongOptionUses.toString(),
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      variationConfig.hasVariation(GameVariationType.reverse)
                          ? l10n.matchingRightColumnTitle
                          : l10n.matchingLeftColumnTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    ...puzzle.pairs.map(
                      (pair) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildChoiceCard(
                          context,
                          label:
                              variationConfig.hasVariation(
                                GameVariationType.reverse,
                              )
                              ? pair.rightItem
                              : pair.leftItem,
                          subtitle:
                              variationConfig.hasVariation(
                                GameVariationType.memory,
                              )
                              ? null
                              : pair.hint,
                          selected: progress.selectedLeftPairId == pair.id,
                          matched: progress.matchedPairIds.contains(pair.id),
                          revealed: progress.revealedPairIds.contains(pair.id),
                          error: _transientErrorPairId == pair.id,
                          onTap: progress.matchedPairIds.contains(pair.id)
                              ? null
                              : () => _selectLeft(puzzle, pair.id),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      variationConfig.hasVariation(GameVariationType.reverse)
                          ? l10n.matchingLeftColumnTitle
                          : l10n.matchingRightColumnTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    ...rightIds.map((pairId) {
                      final pair = puzzle.pairs.firstWhere(
                        (item) => item.id == pairId,
                      );
                      final isHidden =
                          progress.hiddenRightItemIds.contains(pairId) &&
                          !progress.matchedPairIds.contains(pairId);
                      if (isHidden) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildChoiceCard(
                          context,
                          label:
                              variationConfig.hasVariation(
                                GameVariationType.reverse,
                              )
                              ? pair.leftItem
                              : pair.rightItem,
                          subtitle: null,
                          selected: progress.selectedRightPairId == pair.id,
                          matched: progress.matchedPairIds.contains(pair.id),
                          revealed: progress.revealedPairIds.contains(pair.id),
                          error: _transientErrorPairId == pair.id,
                          onTap: progress.matchedPairIds.contains(pair.id)
                              ? null
                              : () => _selectRight(puzzle, pair.id),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
          child: result.completed
              ? PremiumCard(
                  key: const ValueKey('matching-complete'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.matchingCompletionTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        result.perfect
                            ? l10n.matchingPerfectSubtitle
                            : l10n.matchingCompletionSubtitle,
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
                          l10n.matchingDailyCompleteBadge,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
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
                                'learnMatchingPuzzle',
                                pathParameters: {'puzzleId': nextPackPuzzleId!},
                                queryParameters: pack == null
                                    ? const <String, String>{}
                                    : {'pack': pack.id},
                              ),
                              icon: const Icon(Icons.arrow_forward_rounded),
                              label: Text(l10n.matchingNextPuzzleAction),
                            ),
                          if (pack != null)
                            FilledButton.tonalIcon(
                              onPressed: () => context.pop(),
                              icon: const Icon(Icons.view_week_rounded),
                              label: Text(l10n.matchingReturnToPackAction),
                            ),
                          FilledButton.tonalIcon(
                            onPressed: () =>
                                context.goNamed('learnMatchingHome'),
                            icon: const Icon(Icons.home_rounded),
                            label: Text(l10n.matchingBackHomeAction),
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

  Widget _buildChoiceCard(
    BuildContext context, {
    required String label,
    required String? subtitle,
    required bool selected,
    required bool matched,
    required bool revealed,
    required bool error,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: matched
                ? Theme.of(context).colorScheme.tertiaryContainer
                : error
                ? Theme.of(context).colorScheme.errorContainer
                : selected
                ? Theme.of(context).colorScheme.secondaryContainer
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: matched
                  ? Theme.of(context).colorScheme.primary
                  : selected
                  ? Theme.of(context).colorScheme.secondary
                  : error
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.18),
            ),
          ),
          child: Semantics(
            button: true,
            label: AppLocalizations.of(context).matchingCardSemanticsLabel(
              label,
              matched
                  ? AppLocalizations.of(context).matchingFoundBadge
                  : selected
                  ? AppLocalizations.of(context).matchingSelectedBadge
                  : '',
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (matched)
                      _chip(
                        context,
                        AppLocalizations.of(context).matchingFoundBadge,
                      ),
                    if (selected)
                      _chip(
                        context,
                        AppLocalizations.of(context).matchingSelectedBadge,
                      ),
                    if (revealed)
                      _chip(
                        context,
                        AppLocalizations.of(context).matchingRevealedBadge,
                      ),
                  ],
                ),
                if (matched || selected || revealed) const SizedBox(height: 8),
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                if ((subtitle ?? '').isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(subtitle!),
                ],
              ],
            ),
          ),
        ),
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
    MatchingPuzzle puzzle, {
    MatchingDailyPuzzle? daily,
  }) {
    if (_boundPuzzle?.id == puzzle.id) return;
    _boundPuzzle = puzzle;
    final now = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(matchingProgressProvider.notifier)
          .markPuzzlePlayed(puzzleId: puzzle.id, occurredAt: now);
      if (daily != null) {
        ref
            .read(matchingProgressProvider.notifier)
            .markDailyStarted(
              dateKey: daily.dateKey,
              puzzleId: puzzle.id,
              weekdayTheme: daily.weekdayTheme,
              occurredAt: now,
            );
      }
    });
  }

  void _selectLeft(MatchingPuzzle puzzle, String pairId) {
    final notifier = ref.read(matchingProgressProvider.notifier);
    final progress = ref.read(matchingProgressProvider).progressFor(puzzle.id);
    notifier.setSelection(
      puzzleId: puzzle.id,
      leftPairId: pairId,
      rightPairId: progress.selectedRightPairId,
      occurredAt: DateTime.now(),
    );
    _tryResolveMatch(puzzle);
  }

  void _selectRight(MatchingPuzzle puzzle, String pairId) {
    final notifier = ref.read(matchingProgressProvider.notifier);
    final progress = ref.read(matchingProgressProvider).progressFor(puzzle.id);
    notifier.setSelection(
      puzzleId: puzzle.id,
      leftPairId: progress.selectedLeftPairId,
      rightPairId: pairId,
      occurredAt: DateTime.now(),
    );
    _tryResolveMatch(puzzle);
  }

  void _tryResolveMatch(MatchingPuzzle puzzle) {
    final now = DateTime.now();
    final progress = ref.read(matchingProgressProvider).progressFor(puzzle.id);
    final leftId = progress.selectedLeftPairId;
    final rightId = progress.selectedRightPairId;
    if (leftId == null || rightId == null) return;

    if (leftId == rightId) {
      final changed = ref
          .read(matchingProgressProvider.notifier)
          .markPairMatched(
            puzzleId: puzzle.id,
            pairId: leftId,
            occurredAt: now,
          );
      if (changed) {
        ref
            .read(journeyDropSummaryProvider.notifier)
            .awardLearningDrop(
              sourceRef: 'matching:pair:${puzzle.id}:$leftId',
              occurredAt: now,
              metadata: {
                'gameType': 'matching',
                'puzzleId': puzzle.id,
                'pairId': leftId,
              },
            );
      }
      _checkCompletion(puzzle);
      return;
    }

    ref
        .read(matchingProgressProvider.notifier)
        .markMistake(puzzleId: puzzle.id, occurredAt: now);
    setState(() {
      _transientErrorPairId = rightId;
    });
    ref
        .read(matchingProgressProvider.notifier)
        .setSelection(
          puzzleId: puzzle.id,
          leftPairId: null,
          rightPairId: null,
          occurredAt: now,
        );
    Future<void>.delayed(const Duration(milliseconds: 420), () {
      if (!mounted) return;
      setState(() {
        _transientErrorPairId = null;
      });
    });
  }

  void _checkCompletion(MatchingPuzzle puzzle) {
    final progress = ref.read(matchingProgressProvider).progressFor(puzzle.id);
    if (progress.matchedPairIds.length < puzzle.pairs.length) return;
    final now = DateTime.now();
    final perfect = !progress.hadMistake && !progress.usedAnyHint;
    final notifier = ref.read(matchingProgressProvider.notifier);
    final changed = notifier.markPuzzleCompleted(
      puzzleId: puzzle.id,
      perfect: perfect,
      occurredAt: now,
    );
    if (!changed) return;
    if (notifier.markCompletionRewardGranted(
      puzzleId: puzzle.id,
      occurredAt: now,
    )) {
      ref
          .read(journeyXpSummaryProvider.notifier)
          .awardLearningXp(
            sourceRef: 'matching:completion:${puzzle.id}',
            occurredAt: now,
            metadata: {'gameType': 'matching', 'puzzleId': puzzle.id},
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
            sourceRef: 'matching:perfect:${puzzle.id}',
            occurredAt: now,
            metadata: {'gameType': 'matching', 'puzzleId': puzzle.id},
          );
    }
    final variationBonusXp = ref
        .read(knowledgeGameVariationEngineProvider)
        .completionBonusXp(
          config: _variationConfig(
            widget.dailyMode
                ? ref.read(matchingDailyPuzzleProvider).valueOrNull
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
            sourceRef: 'matching:variation_bonus:${puzzle.id}',
            occurredAt: now,
            metadata: {
              'gameType': 'matching',
              'puzzleId': puzzle.id,
              'variationBonusXp': variationBonusXp,
            },
          );
    }
    if (widget.dailyMode) {
      final daily = ref.read(matchingDailyPuzzleProvider).valueOrNull;
      if (daily != null) {
        final startedAt = DateTime.tryParse(progress.startedAtIso ?? '') ?? now;
        final timeTaken = now.difference(startedAt).inSeconds;
        final dailyChanged = notifier.markDailyCompleted(
          dateKey: daily.dateKey,
          puzzleId: puzzle.id,
          weekdayTheme: daily.weekdayTheme,
          perfect: perfect,
          timeTakenSeconds: timeTaken,
          occurredAt: now,
        );
        if (dailyChanged &&
            notifier.markDailyRewardGranted(
              dateKey: daily.dateKey,
              occurredAt: now,
            )) {
          ref
              .read(journeyXpSummaryProvider.notifier)
              .awardLearningXp(
                sourceRef: 'matching:daily:${daily.dateKey}',
                occurredAt: now,
                metadata: {'gameType': 'matching', 'puzzleId': puzzle.id},
              );
        }
      }
    }
  }

  bool _canRevealPair(MatchingPuzzle puzzle, MatchingPuzzleProgress progress) {
    final limit = puzzle.mode == MatchingMode.kids ? 2 : 1;
    return progress.revealPairUses < limit &&
        puzzle.pairs.any((pair) => !progress.matchedPairIds.contains(pair.id));
  }

  bool _canRemoveWrongOption(
    MatchingPuzzle puzzle,
    MatchingPuzzleProgress progress,
  ) {
    final limit = puzzle.mode == MatchingMode.kids ? 2 : 1;
    return progress.removeWrongOptionUses < limit &&
        puzzle.pairs.any((pair) => !progress.matchedPairIds.contains(pair.id));
  }

  void _useRevealPair(MatchingPuzzle puzzle) {
    final progress = ref.read(matchingProgressProvider).progressFor(puzzle.id);
    final target = puzzle.pairs.firstWhere(
      (pair) =>
          !progress.matchedPairIds.contains(pair.id) &&
          !progress.revealedPairIds.contains(pair.id),
      orElse: () => puzzle.pairs.first,
    );
    ref
        .read(matchingProgressProvider.notifier)
        .revealPair(
          puzzleId: puzzle.id,
          pairId: target.id,
          occurredAt: DateTime.now(),
        );
  }

  void _useRemoveWrongOption(MatchingPuzzle puzzle, List<String> rightIds) {
    final progress = ref.read(matchingProgressProvider).progressFor(puzzle.id);
    final target = rightIds.firstWhere(
      (pairId) =>
          !progress.matchedPairIds.contains(pairId) &&
          !progress.hiddenRightItemIds.contains(pairId) &&
          pairId != progress.selectedLeftPairId,
      orElse: () => '',
    );
    if (target.isEmpty) return;
    ref
        .read(matchingProgressProvider.notifier)
        .removeWrongOption(
          puzzleId: puzzle.id,
          rightPairId: target,
          occurredAt: DateTime.now(),
        );
  }

  KnowledgeGameConfig _variationConfig(MatchingDailyPuzzle? daily) {
    if (daily == null) return const KnowledgeGameConfig.standard();
    return ref
        .read(knowledgeGameVariationEngineProvider)
        .resolveDailyConfig(
          gameType: DailyKnowledgeGameType.matching,
          dateKey: daily.dateKey,
          profile: ref.read(userLearningProfileProvider),
        );
  }
}
