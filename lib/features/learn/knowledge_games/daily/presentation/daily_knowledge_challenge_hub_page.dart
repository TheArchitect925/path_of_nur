import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/display/progress_bar.dart';
import '../../../../../shared/utils/reward_feedback.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../../../journey/drops/application/journey_drops_providers.dart';
import '../../../../journey/xp/application/journey_xp_providers.dart';
import '../../adaptive/application/user_learning_profile_provider.dart';
import '../../domain/knowledge_game_variations.dart';
import '../../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../../../presentation/widgets/learn_section_header.dart';
import '../application/daily_knowledge_challenge_hub_provider.dart';
import '../domain/daily_knowledge_challenge_models.dart';

class DailyKnowledgeChallengeHubPage extends ConsumerStatefulWidget {
  const DailyKnowledgeChallengeHubPage({super.key});

  @override
  ConsumerState<DailyKnowledgeChallengeHubPage> createState() =>
      _DailyKnowledgeChallengeHubPageState();
}

class _DailyKnowledgeChallengeHubPageState
    extends ConsumerState<DailyKnowledgeChallengeHubPage> {
  String? _syncFingerprint;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bundleAsync = ref.watch(dailyKnowledgeChallengeBundleProvider);
    final hubProgress = ref.watch(dailyKnowledgeChallengeHubProgressProvider);
    final adaptiveInsight = ref.watch(adaptiveLearningInsightProvider);
    final streak = ref.watch(dailyKnowledgeChallengeHubStreakProvider);
    final recentHistory = ref.watch(
      dailyKnowledgeChallengeHubRecentHistoryProvider,
    );

    return LearnHubPageScaffold(
      headerIcon: Icons.today_rounded,
      title: l10n.dailyKnowledgeHubTitle,
      subtitle: l10n.dailyKnowledgeHubSubtitle,
      children: [
        bundleAsync.when(
          loading: () => const PremiumCard(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.dailyKnowledgeHubLoadErrorTitle),
                const SizedBox(height: 6),
                Text(l10n.dailyKnowledgeHubLoadErrorSubtitle),
              ],
            ),
          ),
          data: (bundle) {
            _syncBundleState(bundle, hubProgress);
            final bundleProgress = hubProgress.progressFor(bundle.dateKey);

            return Column(
              children: [
                PremiumCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _chip(
                            context,
                            l10n.dailyKnowledgeHubDateLabel(bundle.dateKey),
                          ),
                          _chip(
                            context,
                            l10n.dailyKnowledgeHubProgressLabel(
                              bundle.completedCount.toString(),
                              bundle.games.length.toString(),
                            ),
                          ),
                          if (streak.currentStreak > 0)
                            _chip(
                              context,
                              l10n.dailyKnowledgeHubStreakLabel(
                                streak.currentStreak.toString(),
                              ),
                            ),
                          if (bundleProgress.isCompleted)
                            _chip(
                              context,
                              l10n.dailyKnowledgeHubCompletedBadge,
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ProgressBar(
                        value: bundle.games.isEmpty
                            ? 0
                            : bundle.completedCount / bundle.games.length,
                        height: 8,
                      ),
                      const SizedBox(height: 10),
                      Text(l10n.dailyKnowledgeHubJourneySummary),
                    ],
                  ),
                ),
                if (adaptiveInsight.hasAdaptiveData) ...[
                  const SizedBox(height: 12),
                  PremiumCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.dailyKnowledgeHubAdaptiveTitle,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(l10n.dailyKnowledgeHubAdaptiveSubtitle),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (adaptiveInsight.supportGameType != null)
                              _chip(
                                context,
                                l10n.dailyKnowledgeHubAdaptiveSupportLabel(
                                  _adaptiveGameLabel(
                                    l10n,
                                    adaptiveInsight.supportGameType!,
                                  ),
                                ),
                              ),
                            if (adaptiveInsight.challengeGameType != null)
                              _chip(
                                context,
                                l10n.dailyKnowledgeHubAdaptiveChallengeLabel(
                                  _adaptiveGameLabel(
                                    l10n,
                                    adaptiveInsight.challengeGameType!,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                LearnSectionHeader(
                  title: l10n.dailyKnowledgeHubTodayTitle,
                  subtitle: l10n.dailyKnowledgeHubTodaySubtitle,
                ),
                const SizedBox(height: 8),
                ...bundle.games.map(
                  (game) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _GameCard(
                      game: game,
                      isCompleted: bundle.completedGameTypes.contains(
                        game.gameType,
                      ),
                    ),
                  ),
                ),
                if (bundleProgress.isCompleted) ...[
                  const SizedBox(height: 12),
                  PremiumCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.dailyKnowledgeHubCompletionTitle,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(l10n.dailyKnowledgeHubCompletionSubtitle),
                        const SizedBox(height: 10),
                        Text(
                          buildCompactRewardSummary(l10n, xp: 1, drops: 1),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (recentHistory.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  LearnSectionHeader(
                    title: l10n.dailyKnowledgeHubHistoryTitle,
                    subtitle: l10n.dailyKnowledgeHubHistorySubtitle,
                  ),
                  const SizedBox(height: 8),
                  ...recentHistory.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: PremiumCard(
                        child: Row(
                          children: [
                            Icon(
                              item.isCompleted
                                  ? Icons.check_circle_rounded
                                  : Icons.circle_outlined,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item.isCompleted
                                    ? l10n.dailyKnowledgeHubHistoryDone(
                                        item.dateKey,
                                      )
                                    : l10n.dailyKnowledgeHubHistoryOpen(
                                        item.dateKey,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  void _syncBundleState(
    DailyChallengeBundle bundle,
    DailyChallengeHubProgressState hubProgress,
  ) {
    final existing = hubProgress.progressFor(bundle.dateKey);
    final fingerprint =
        '${bundle.dateKey}:${bundle.completedCount}:${existing.rewardGrantedAtIso ?? ''}:${existing.completedAtIso ?? ''}';
    if (_syncFingerprint == fingerprint) return;
    _syncFingerprint = fingerprint;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final now = DateTime.now();
      final notifier = ref.read(
        dailyKnowledgeChallengeHubProgressProvider.notifier,
      );
      notifier.markBundleViewed(dateKey: bundle.dateKey, occurredAt: now);
      if (!bundle.isCompleted) return;
      notifier.markBundleCompleted(dateKey: bundle.dateKey, occurredAt: now);
      final current = ref
          .read(dailyKnowledgeChallengeHubProgressProvider)
          .progressFor(bundle.dateKey);
      if ((current.rewardGrantedAtIso ?? '').isNotEmpty) return;
      if (notifier.markBundleRewardGranted(
        dateKey: bundle.dateKey,
        occurredAt: now,
      )) {
        ref
            .read(journeyXpSummaryProvider.notifier)
            .awardLearningXp(
              sourceRef: 'knowledge_games:daily_bundle:${bundle.dateKey}',
              occurredAt: now,
              metadata: {
                'bundleType': 'daily_knowledge_challenge',
                'gameCount': bundle.games.length,
              },
            );
        ref
            .read(journeyDropSummaryProvider.notifier)
            .awardLearningDrop(
              sourceRef: 'knowledge_games:daily_bundle:${bundle.dateKey}',
              occurredAt: now,
              metadata: {
                'bundleType': 'daily_knowledge_challenge',
                'gameCount': bundle.games.length,
              },
            );
      }
    });
  }

  String _adaptiveGameLabel(AppLocalizations l10n, String gameType) {
    return switch (gameType) {
      'crossword' => l10n.dailyKnowledgeHubAdaptiveGameCrossword,
      'word_search' => l10n.dailyKnowledgeHubAdaptiveGameWordSearch,
      'matching' => l10n.dailyKnowledgeHubAdaptiveGameMatching,
      'ayah_completion' => l10n.dailyKnowledgeHubAdaptiveGameAyahCompletion,
      'hadith_reflection' => l10n.dailyKnowledgeHubAdaptiveGameHadithReflection,
      _ => l10n.dailyKnowledgeHubAdaptiveGameCrossword,
    };
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({required this.game, required this.isCompleted});

  final KnowledgeGameRef game;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.pushNamed(game.routeName),
      child: PremiumCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 20, child: Icon(_iconForGame(game.gameType))),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _titleForGame(l10n, game.gameType),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _subtitleForGame(l10n, game),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _chip(context, _categoryForGame(l10n, game)),
                      _chip(
                        context,
                        l10n.dailyKnowledgeHubDifficultyLabel(
                          game.difficulty.toString(),
                        ),
                      ),
                      _chip(
                        context,
                        isCompleted
                            ? l10n.dailyKnowledgeHubGameDone
                            : l10n.dailyKnowledgeHubGameOpen,
                      ),
                      if (!game.config.isStandard)
                        _chip(
                          context,
                          _variationLabel(
                            l10n,
                            game.config.variations.firstWhere(
                              (item) => item != GameVariationType.standard,
                              orElse: () => GameVariationType.standard,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForGame(DailyKnowledgeGameType type) {
    switch (type) {
      case DailyKnowledgeGameType.crossword:
        return Icons.grid_4x4_rounded;
      case DailyKnowledgeGameType.wordSearch:
        return Icons.search_rounded;
      case DailyKnowledgeGameType.matching:
        return Icons.view_module_rounded;
      case DailyKnowledgeGameType.ayahCompletion:
        return Icons.auto_stories_rounded;
      case DailyKnowledgeGameType.hadithReflection:
        return Icons.menu_book_rounded;
    }
  }

  String _titleForGame(AppLocalizations l10n, DailyKnowledgeGameType type) {
    switch (type) {
      case DailyKnowledgeGameType.crossword:
        return l10n.crosswordHomeTitle;
      case DailyKnowledgeGameType.wordSearch:
        return l10n.wordSearchHomeTitle;
      case DailyKnowledgeGameType.matching:
        return l10n.matchingHomeTitle;
      case DailyKnowledgeGameType.ayahCompletion:
        return l10n.ayahCompletionHomeTitle;
      case DailyKnowledgeGameType.hadithReflection:
        return l10n.hadithReflectionHomeTitle;
    }
  }

  String _subtitleForGame(AppLocalizations l10n, KnowledgeGameRef game) {
    switch (game.gameType) {
      case DailyKnowledgeGameType.crossword:
        return l10n.dailyKnowledgeHubGameSubtitleCrossword;
      case DailyKnowledgeGameType.wordSearch:
        return l10n.dailyKnowledgeHubGameSubtitleWordSearch;
      case DailyKnowledgeGameType.matching:
        return l10n.dailyKnowledgeHubGameSubtitleMatching;
      case DailyKnowledgeGameType.ayahCompletion:
        return l10n.dailyKnowledgeHubGameSubtitleAyahCompletion;
      case DailyKnowledgeGameType.hadithReflection:
        return l10n.dailyKnowledgeHubGameSubtitleHadithReflection;
    }
  }

  String _categoryForGame(AppLocalizations l10n, KnowledgeGameRef game) {
    switch (game.category) {
      case 'quran':
        return l10n.crosswordCategoryQuran;
      case 'hadith':
        return l10n.crosswordCategoryHadith;
      case 'letters':
        return l10n.crosswordCategoryLetters;
      case 'prophets':
        return l10n.crosswordCategoryProphets;
      case 'duas':
        return l10n.crosswordCategoryDuas;
      case 'worship':
        return l10n.crosswordCategoryWorship;
      case 'character':
        return l10n.crosswordCategoryCharacter;
      case 'mercy':
        return l10n.ayahCompletionCategoryMercy;
      case 'patience':
        return l10n.ayahCompletionCategoryPatience;
      case 'gratitude':
        return l10n.ayahCompletionCategoryGratitude;
      case 'memorization':
        return l10n.ayahCompletionCategoryMemorization;
      case 'kindness':
        return l10n.hadithReflectionCategoryKindness;
      case 'honesty':
        return l10n.hadithReflectionCategoryHonesty;
      case 'family':
        return l10n.hadithReflectionCategoryFamily;
      case 'community':
        return l10n.hadithReflectionCategoryCommunity;
      case 'speech':
        return l10n.hadithReflectionCategorySpeech;
      case 'repentance':
        return l10n.hadithReflectionCategoryRepentance;
      case 'mixed':
        return l10n.crosswordCategoryMixed;
      default:
        return game.category;
    }
  }

  String _variationLabel(AppLocalizations l10n, GameVariationType variation) {
    return switch (variation) {
      GameVariationType.standard => l10n.gameVariationStandard,
      GameVariationType.timed => l10n.gameVariationTimed,
      GameVariationType.memory => l10n.gameVariationMemory,
      GameVariationType.sequential => l10n.gameVariationSequential,
      GameVariationType.reflection => l10n.gameVariationReflection,
      GameVariationType.audio => l10n.gameVariationAudio,
      GameVariationType.challenge => l10n.gameVariationChallenge,
      GameVariationType.fog => l10n.gameVariationFog,
      GameVariationType.noClue => l10n.gameVariationNoClue,
      GameVariationType.reverse => l10n.gameVariationReverse,
    };
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
