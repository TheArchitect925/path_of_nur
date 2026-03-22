import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/bedtime_story_learning_progress_service.dart';
import '../application/bedtime_story_learning_repository.dart';
import '../application/bedtime_story_repository.dart';
import '../domain/bedtime_story_learning_models.dart';

class BedtimeStoryMemoryCardsPage extends ConsumerStatefulWidget {
  const BedtimeStoryMemoryCardsPage({super.key, required this.storyId});

  final String storyId;

  @override
  ConsumerState<BedtimeStoryMemoryCardsPage> createState() =>
      _BedtimeStoryMemoryCardsPageState();
}

class _BedtimeStoryMemoryCardsPageState
    extends ConsumerState<BedtimeStoryMemoryCardsPage> {
  String? _selectedPromptId;
  String? _selectedAnswerId;
  String? _feedbackKey;
  bool _lastMatchCorrect = false;
  bool _didOpenActivity = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final story = ref.watch(bedtimeStoryByIdProvider(widget.storyId));
    final deck = ref.watch(bedtimeStoryMemoryDeckByStoryIdProvider(widget.storyId));

    if (story == null) {
      return AppPageScaffold(
        title: l10n.bedtimeStoriesTitle,
        subtitle: l10n.routerNotFoundTitle,
        children: [Text(l10n.routerNotFoundTitle)],
      );
    }

    if (deck == null) {
      return AppPageScaffold(
        title: l10n.bedtimeStoryMemoryTitle,
        subtitle: story.shortTitle,
        children: [
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.bedtimeStoryLearningUnavailableTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(l10n.bedtimeStoryMemoryUnavailableSubtitle),
              ],
            ),
          ),
        ],
      );
    }

    if (deck.pairs.isEmpty) {
      return AppPageScaffold(
        title: l10n.bedtimeStoryMemoryTitle,
        subtitle: story.shortTitle,
        children: [
          PremiumCard(
            child: Text(l10n.bedtimeStoryMemoryUnavailableSubtitle),
          ),
        ],
      );
    }

    final progress = ref.watch(
      bedtimeStoryLearningProgressProvider.select(
        (value) =>
            value.progressByActivityId[deck.deckId] ??
            BedtimeStoryLearningActivityProgress(
              storyId: deck.storyId,
              mode: BedtimeStoryLearningMode.memoryCards,
            ),
      ),
    );
    final matchedIds = progress.completedStepIds.toSet();
    final remainingPairs = deck.pairs
        .where((pair) => !matchedIds.contains(pair.pairId))
        .toList(growable: false);

    if (!_didOpenActivity) {
      _didOpenActivity = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(bedtimeStoryLearningProgressProvider.notifier).openActivity(
          activityId: deck.deckId,
          storyId: story.id,
          mode: BedtimeStoryLearningMode.memoryCards,
          totalSteps: deck.pairs.length,
        );
      });
    }

    return AppPageScaffold(
      title: l10n.bedtimeStoryMemoryTitle,
      subtitle: story.shortTitle,
      headerIcon: Icons.style_rounded,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                deck.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(deck.shortDescription),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: deck.pairs.isEmpty
                    ? 0
                    : matchedIds.length / deck.pairs.length,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.bedtimeStoryMemoryProgressLabel(
                  matchedIds.length,
                  deck.pairs.length,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (progress.isCompleted || remainingPairs.isEmpty) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.bedtimeStoryMemoryCompleteTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(l10n.bedtimeStoryMemoryCompleteSubtitle),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => context.pushNamed(
                    'kidsBedtimeStoryDetail',
                    pathParameters: {'storyId': story.id},
                  ),
                  icon: const Icon(Icons.menu_book_rounded),
                  label: Text(l10n.bedtimeStoryBackToStoryAction),
                ),
              ],
            ),
          ),
        ] else ...[
          Text(
            l10n.bedtimeStoryMemoryPromptLabel,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          ...remainingPairs.map(
            (pair) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _MemoryChoiceCard(
                label: pair.prompt,
                selected: _selectedPromptId == pair.pairId,
                onTap: () {
                  setState(() {
                    _selectedPromptId = pair.pairId;
                  });
                  _tryResolveMatch(deck, pairId: pair.pairId, selectingPrompt: true);
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.bedtimeStoryMemoryAnswerLabel,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          ...remainingPairs.reversed.map(
            (pair) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _MemoryChoiceCard(
                label: pair.answer,
                selected: _selectedAnswerId == pair.pairId,
                onTap: () {
                  setState(() {
                    _selectedAnswerId = pair.pairId;
                  });
                  _tryResolveMatch(deck, pairId: pair.pairId, selectingPrompt: false);
                },
              ),
            ),
          ),
          if (_feedbackKey != null) ...[
            const SizedBox(height: 12),
            PremiumCard(
              child: Text(
                _lastMatchCorrect
                    ? l10n.bedtimeStoryMemoryMatchCorrect
                    : l10n.bedtimeStoryMemoryMatchTryAgain,
              ),
            ),
          ],
        ],
      ],
    );
  }

  void _tryResolveMatch(
    BedtimeStoryMemoryDeckSeed deck, {
    required String pairId,
    required bool selectingPrompt,
  }) {
    final promptId = selectingPrompt ? pairId : _selectedPromptId;
    final answerId = selectingPrompt ? _selectedAnswerId : pairId;
    if (promptId == null || answerId == null) {
      return;
    }
    final matched = promptId == answerId;
    setState(() {
      _feedbackKey = matched ? 'correct' : 'tryAgain';
      _lastMatchCorrect = matched;
    });
    if (!matched) {
      return;
    }
    final current = ref.read(bedtimeStoryLearningProgressProvider);
    final previous = current.progressByActivityId[deck.deckId];
    final completedCount = (previous?.completedStepIds.length ?? 0) + 1;
    ref.read(bedtimeStoryLearningProgressProvider.notifier).recordStepProgress(
          activityId: deck.deckId,
          storyId: deck.storyId,
          mode: BedtimeStoryLearningMode.memoryCards,
          currentStepIndex: completedCount,
          totalSteps: deck.pairs.length,
          completedStepId: promptId,
        );
    if (completedCount >= deck.pairs.length) {
      final outcome = ref
          .read(bedtimeStoryLearningProgressProvider.notifier)
          .completeActivity(
            activityId: deck.deckId,
            storyId: deck.storyId,
            mode: BedtimeStoryLearningMode.memoryCards,
            totalSteps: deck.pairs.length,
            xpReward: deck.reward.xpReward,
            sourceRef: 'bedtime_story_memory:${deck.deckId}:complete',
            metadata: <String, Object?>{
              'feature': 'kids_bedtime_story_memory',
              'storyId': deck.storyId,
              'deckId': deck.deckId,
              'prophetId': deck.prophetId,
            },
          );
      if (outcome.firstCompletion) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.bedtimeStoryLearningCompletionSnack(outcome.xpAwarded),
            ),
          ),
        );
      }
    }
    setState(() {
      _selectedPromptId = null;
      _selectedAnswerId = null;
    });
  }
}

class _MemoryChoiceCard extends StatelessWidget {
  const _MemoryChoiceCard({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: PremiumCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Expanded(child: Text(label)),
            const SizedBox(width: 8),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.touch_app_rounded,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
