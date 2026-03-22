import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../journey/application/journey_progression_provider.dart';
import '../../../journey/drops/application/journey_drops_providers.dart';
import '../../../journey/xp/application/journey_xp_providers.dart';
import '../../hadith/application/hadith_foundation_repository.dart';
import '../../hadith/presentation/widgets/hadith_content_block.dart';
import '../../journey/application/family_learning_provider.dart';
import '../../knowledge_games/adaptive/application/user_learning_profile_provider.dart';
import '../../knowledge_games/application/knowledge_game_variation_engine.dart';
import '../../knowledge_games/daily/domain/daily_knowledge_challenge_models.dart';
import '../../knowledge_games/domain/knowledge_game_variations.dart';
import '../application/hadith_reflection_game_adapter.dart';
import '../application/hadith_reflection_progress_provider.dart';
import '../application/hadith_reflection_repository.dart';
import '../domain/hadith_reflection_models.dart';
import 'hadith_reflection_ui_helpers.dart';

class HadithReflectionPuzzlePage extends ConsumerStatefulWidget {
  const HadithReflectionPuzzlePage({
    super.key,
    this.puzzleId,
    this.dailyMode = false,
    this.packId,
  });

  final String? puzzleId;
  final bool dailyMode;
  final String? packId;

  @override
  ConsumerState<HadithReflectionPuzzlePage> createState() =>
      _HadithReflectionPuzzlePageState();
}

class _HadithReflectionPuzzlePageState
    extends ConsumerState<HadithReflectionPuzzlePage> {
  HadithReflectionPuzzle? _boundPuzzle;

  @override
  Widget build(BuildContext context) {
    if (widget.dailyMode) {
      final dailyAsync = ref.watch(hadithReflectionDailyPuzzleProvider);
      return dailyAsync.when(
        loading: () => _buildLoading(context),
        error: (_, _) => _buildLoadError(context),
        data: (daily) => _buildLoaded(context, daily.puzzle, daily: daily),
      );
    }
    final puzzleAsync = ref.watch(
      hadithReflectionPuzzleByIdProvider(widget.puzzleId ?? ''),
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
      title: AppLocalizations.of(context).hadithReflectionHomeTitle,
      subtitle: AppLocalizations.of(context).hadithReflectionLoadingSubtitle,
      children: const [Center(child: CircularProgressIndicator())],
    );
  }

  Widget _buildLoadError(BuildContext context) {
    return AppPageScaffold(
      title: AppLocalizations.of(context).hadithReflectionHomeTitle,
      subtitle: AppLocalizations.of(context).hadithReflectionLoadErrorSubtitle,
      children: [
        PremiumCard(
          child: Text(
            AppLocalizations.of(context).hadithReflectionLoadErrorTitle,
          ),
        ),
      ],
    );
  }

  Widget _buildNotFound(BuildContext context) {
    return AppPageScaffold(
      title: AppLocalizations.of(context).hadithReflectionHomeTitle,
      subtitle: AppLocalizations.of(context).hadithReflectionNotFoundSubtitle,
      children: [
        PremiumCard(
          child: Text(
            AppLocalizations.of(context).hadithReflectionNotFoundTitle,
          ),
        ),
      ],
    );
  }

  Widget _buildLoaded(
    BuildContext context,
    HadithReflectionPuzzle puzzle, {
    HadithReflectionDailyPuzzle? daily,
  }) {
    final l10n = AppLocalizations.of(context);
    final isChildProfile = ref.watch(
      activeFamilyLearningContextProvider.select(
        (value) => value.visibilityPolicy.isChildProfile,
      ),
    );
    if (isChildProfile && puzzle.mode != HadithReflectionMode.kids) {
      return AppPageScaffold(
        title: l10n.hadithReflectionHomeTitle,
        subtitle: l10n.hadithReflectionNotFoundSubtitle,
        children: [
          PremiumCard(child: Text(l10n.hadithReflectionKidsOnlyTitle)),
        ],
      );
    }

    final progressState = ref.watch(hadithReflectionProgressProvider);
    final progress = progressState.progressFor(puzzle.id);
    final hadithEntry = ref.watch(hadithEntryByIdProvider(puzzle.hadithId));
    final dailyProgress = daily == null
        ? null
        : progressState.dailyProgressFor(daily.dateKey);
    final dailyStreak = daily == null
        ? null
        : progressState.dailyStreakSummary(DateTime.now());
    _bindPuzzleIfNeeded(puzzle, daily: daily);

    final adapter = ref.watch(hadithReflectionGameAdapterProvider);
    final variationConfig = _variationConfig(daily);
    final game = adapter.toGame(puzzle).copyWith(config: variationConfig);
    final session = adapter
        .createSession(game: puzzle, progress: progress)
        .copyWith(config: variationConfig);
    final result = adapter
        .evaluate(
          game: puzzle,
          progress: progress,
          xpEarned: progress.isCompleted ? (progress.isBestChoice ? 2 : 1) : 0,
          dropsEarned: progress.isCompleted ? 1 : 0,
        )
        .copyWith(config: variationConfig);

    final catalog = ref.watch(hadithReflectionCatalogProvider).valueOrNull;
    final pack = catalog?.packsById[widget.packId ?? ''];
    final nextPackPuzzleId = pack?.puzzleIds.firstWhere(
      (id) => id != puzzle.id && !progressState.progressFor(id).isCompleted,
      orElse: () => '',
    );

    final subtitle = daily != null
        ? l10n.hadithReflectionDailyPuzzleSubtitle(
            hadithReflectionLocalizedCategory(l10n, daily.weekdayTheme),
          )
        : l10n.hadithReflectionPuzzleSubtitle(
            hadithReflectionLocalizedCategory(l10n, puzzle.category),
          );

    return adapter.buildScreen(
      context: context,
      title: hadithReflectionPuzzleTitle(l10n, puzzle),
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
                hadithReflectionLocalizedCategory(l10n, puzzle.category),
              ),
              _chip(
                context,
                hadithReflectionDifficultyLabel(l10n, puzzle.difficulty),
              ),
              if (daily != null)
                _chip(
                  context,
                  l10n.hadithReflectionDailyThemeLabel(
                    hadithReflectionLocalizedCategory(l10n, daily.weekdayTheme),
                  ),
                ),
              if (dailyStreak != null && dailyStreak.currentStreak > 0)
                _chip(
                  context,
                  l10n.hadithReflectionDailyStreakLabel(
                    dailyStreak.currentStreak.toString(),
                  ),
                ),
              if (progress.isBestChoice)
                _chip(context, l10n.hadithReflectionBestChoiceBadge)
              else if (progress.isCompleted)
                _chip(context, l10n.hadithReflectionCompletedBadge),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.hadithReflectionScenarioTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                puzzle.scenarioTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 6),
              Text(puzzle.scenarioDescription),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (hadithEntry != null)
          HadithContentBlock(
            entry: hadithEntry,
            showUnavailablePlaceholders: false,
          )
        else
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  puzzle.hadithTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if ((puzzle.hadithTextArabic ?? '').trim().isNotEmpty) ...[
                  Text(puzzle.hadithTextArabic!),
                  const SizedBox(height: 8),
                ],
                Text(puzzle.hadithTextEnglish),
                const SizedBox(height: 8),
                Text(
                  '${puzzle.sourceBook} • ${puzzle.referenceNumber}',
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
                l10n.hadithReflectionTeachingSummaryTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(puzzle.shortTeachingSummary),
              const SizedBox(height: 10),
              Text(
                l10n.hadithReflectionReflectionPromptTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 6),
              Text(puzzle.reflectionPrompt),
              if ((puzzle.helpText ?? '').trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                FilledButton.tonalIcon(
                  onPressed:
                      variationConfig.hasVariation(
                            GameVariationType.challenge,
                          ) &&
                          variationConfig.boolSetting('hintDisabled')
                      ? null
                      : () => _showHelp(context, puzzle),
                  icon: const Icon(Icons.lightbulb_outline_rounded),
                  label: Text(
                    progress.helpViewed
                        ? l10n.hadithReflectionHelpViewedAction
                        : l10n.hadithReflectionHelpAction,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.hadithReflectionChoiceSectionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              ...puzzle.choices.map(
                (choice) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ChoiceCard(
                    choice: choice,
                    selected: progress.selectedChoiceId == choice.id,
                    onTap: progress.isCompleted
                        ? null
                        : () => _selectChoice(
                            context,
                            puzzle,
                            choice,
                            daily: daily,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (progress.selectedChoiceId != null) ...[
          const SizedBox(height: 12),
          _FeedbackCard(puzzle: puzzle, choiceId: progress.selectedChoiceId!),
        ],
        if (progress.isCompleted) ...[
          const SizedBox(height: 12),
          if (variationConfig.hasVariation(GameVariationType.reflection) &&
              (puzzle.followUpReflection ?? '').trim().isNotEmpty) ...[
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.gameVariationReflectionFollowUpTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(puzzle.followUpReflection!),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.hadithReflectionCompletionTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  progress.isBestChoice
                      ? l10n.hadithReflectionCompletionBestSubtitle
                      : l10n.hadithReflectionCompletionSubtitle,
                ),
                if ((puzzle.followUpReflection ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    l10n.hadithReflectionTakeawayTitle,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(puzzle.followUpReflection!.trim()),
                ],
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _chip(
                      context,
                      l10n.hadithReflectionCompletionXpReward(
                        result.xpEarned.toString(),
                      ),
                    ),
                    _chip(
                      context,
                      l10n.hadithReflectionCompletionDropReward(
                        result.dropsEarned.toString(),
                      ),
                    ),
                    if (progress.isBestChoice)
                      _chip(
                        context,
                        l10n.hadithReflectionBestChoiceReward('1'),
                      ),
                    if (dailyProgress?.isCompleted == true)
                      _chip(context, l10n.hadithReflectionDailyCompleteBadge),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if ((nextPackPuzzleId ?? '').isNotEmpty)
                      FilledButton.tonalIcon(
                        onPressed: () => context.goNamed(
                          'learnHadithReflectionPuzzle',
                          pathParameters: {'puzzleId': nextPackPuzzleId!},
                          queryParameters: {
                            if (widget.packId != null) 'pack': widget.packId!,
                          },
                        ),
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: Text(l10n.hadithReflectionNextPuzzleAction),
                      ),
                    if (widget.packId != null)
                      FilledButton.tonalIcon(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.view_list_rounded),
                        label: Text(l10n.hadithReflectionReturnToPackAction),
                      ),
                    FilledButton.tonalIcon(
                      onPressed: () =>
                          context.goNamed('learnHadithReflectionHome'),
                      icon: const Icon(Icons.home_outlined),
                      label: Text(l10n.hadithReflectionBackHomeAction),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _bindPuzzleIfNeeded(
    HadithReflectionPuzzle puzzle, {
    HadithReflectionDailyPuzzle? daily,
  }) {
    if (_boundPuzzle?.id == puzzle.id) return;
    _boundPuzzle = puzzle;
    final now = DateTime.now();
    ref
        .read(hadithReflectionProgressProvider.notifier)
        .markPuzzlePlayed(puzzleId: puzzle.id, occurredAt: now);
    if (daily != null) {
      ref
          .read(hadithReflectionProgressProvider.notifier)
          .markDailyStarted(
            dateKey: daily.dateKey,
            puzzleId: puzzle.id,
            weekdayTheme: daily.weekdayTheme,
            occurredAt: now,
          );
    }
  }

  void _showHelp(BuildContext context, HadithReflectionPuzzle puzzle) {
    ref
        .read(hadithReflectionProgressProvider.notifier)
        .markHelpViewed(puzzleId: puzzle.id, occurredAt: DateTime.now());
    showDialog<void>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(l10n.hadithReflectionHelpDialogTitle),
          content: Text((puzzle.helpText ?? '').trim()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(MaterialLocalizations.of(context).okButtonLabel),
            ),
          ],
        );
      },
    );
  }

  void _selectChoice(
    BuildContext context,
    HadithReflectionPuzzle puzzle,
    HadithReflectionChoice choice, {
    HadithReflectionDailyPuzzle? daily,
  }) {
    final now = DateTime.now();
    final progressNotifier = ref.read(
      hadithReflectionProgressProvider.notifier,
    );
    progressNotifier.selectChoice(
      puzzleId: puzzle.id,
      choiceId: choice.id,
      occurredAt: now,
    );
    progressNotifier.markPuzzleCompleted(
      puzzleId: puzzle.id,
      bestChoice: choice.isBestChoice,
      occurredAt: now,
    );
    if (daily != null) {
      progressNotifier.markDailyCompleted(
        dateKey: daily.dateKey,
        puzzleId: puzzle.id,
        weekdayTheme: daily.weekdayTheme,
        bestChoice: choice.isBestChoice,
        occurredAt: now,
      );
    }

    final xpNotifier = ref.read(journeyXpSummaryProvider.notifier);
    final dropNotifier = ref.read(journeyDropSummaryProvider.notifier);
    final progression = ref.read(journeyProgressUpdateHelperProvider);

    if (progressNotifier.markCompletionRewardGranted(
      puzzleId: puzzle.id,
      occurredAt: now,
    )) {
      xpNotifier.awardLearningXp(
        sourceRef: 'hadith_reflection:${puzzle.id}:completion',
        occurredAt: now,
        metadata: {'gameType': 'hadith_reflection', 'puzzleId': puzzle.id},
      );
      dropNotifier.awardLearningDrop(
        sourceRef: 'hadith_reflection:${puzzle.id}:completion',
        occurredAt: now,
        metadata: {'gameType': 'hadith_reflection', 'puzzleId': puzzle.id},
      );
      progression.addLearningStageCompletions(1);
    }
    if (choice.isBestChoice &&
        progressNotifier.markBestChoiceRewardGranted(
          puzzleId: puzzle.id,
          occurredAt: now,
        )) {
      xpNotifier.awardLearningXp(
        sourceRef: 'hadith_reflection:${puzzle.id}:best_choice',
        occurredAt: now,
        metadata: {'gameType': 'hadith_reflection', 'puzzleId': puzzle.id},
      );
    }
    final progress = ref
        .read(hadithReflectionProgressProvider)
        .progressFor(puzzle.id);
    final variationBonusXp = ref
        .read(knowledgeGameVariationEngineProvider)
        .completionBonusXp(
          config: _variationConfig(daily),
          startedAt: DateTime.tryParse(progress.startedAtIso ?? '') ?? now,
          completedAt: now,
          perfect: choice.isBestChoice,
          usedAnyHint: progress.helpViewed,
        );
    if (variationBonusXp > 0) {
      xpNotifier.awardLearningXp(
        sourceRef: 'hadith_reflection:${puzzle.id}:variation_bonus',
        occurredAt: now,
        metadata: {
          'gameType': 'hadith_reflection',
          'puzzleId': puzzle.id,
          'variationBonusXp': variationBonusXp,
        },
      );
    }
    if (daily != null &&
        progressNotifier.markDailyRewardGranted(
          dateKey: daily.dateKey,
          occurredAt: now,
        )) {
      xpNotifier.awardLearningXp(
        sourceRef: 'hadith_reflection:${daily.dateKey}:daily',
        occurredAt: now,
        metadata: {'gameType': 'hadith_reflection', 'puzzleId': puzzle.id},
      );
    }
  }

  KnowledgeGameConfig _variationConfig(HadithReflectionDailyPuzzle? daily) {
    if (daily == null) return const KnowledgeGameConfig.standard();
    return ref
        .read(knowledgeGameVariationEngineProvider)
        .resolveDailyConfig(
          gameType: DailyKnowledgeGameType.hadithReflection,
          dateKey: daily.dateKey,
          profile: ref.read(userLearningProfileProvider),
        );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.choice,
    required this.selected,
    required this.onTap,
  });

  final HadithReflectionChoice choice;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.25),
            ),
            color: selected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
                : Theme.of(context).colorScheme.surface.withValues(alpha: 0.35),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.circle_outlined,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(choice.label)),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedbackCard extends ConsumerWidget {
  const _FeedbackCard({required this.puzzle, required this.choiceId});

  final HadithReflectionPuzzle puzzle;
  final String choiceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final choice = puzzle.choices.firstWhere((item) => item.id == choiceId);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip(
                context,
                hadithReflectionOutcomeLabel(l10n, choice.outcome),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l10n.hadithReflectionFeedbackTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(choice.feedbackText),
        ],
      ),
    );
  }
}

Widget _chip(BuildContext context, String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
      ),
    ),
    child: Text(label),
  );
}
