import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/section_hub_scaffold.dart';
import '../../journey/application/family_learning_provider.dart';
import '../../knowledge_games/daily/application/daily_knowledge_challenge_hub_provider.dart';
import '../data/games_island_catalog.dart';
import '../models/game_discovery_models.dart';
import '../widgets/learn_hub_page_scaffold.dart';

class GamesIslandPage extends ConsumerWidget {
  const GamesIslandPage({super.key, this.initialSectionId});

  final String? initialSectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final visibilityPolicy = ref.watch(
      activeFamilyLearningContextProvider.select(
        (value) => value.visibilityPolicy,
      ),
    );
    final sections = GamesIslandCatalog.sections(l10n);
    GameDiscoverySection? selectedSection;
    if (initialSectionId != null) {
      for (final section in sections) {
        if (section.id == initialSectionId) {
          selectedSection = section;
          break;
        }
      }
    }
    final visibleSections = selectedSection == null
        ? sections
        : [selectedSection];

    return LearnHubPageScaffold(
      headerIcon: Icons.sports_esports_rounded,
      title: l10n.learnGamesIslandTitle,
      subtitle: l10n.learnGamesIslandSubtitle,
      children: [
        if (visibilityPolicy.isChildProfile)
          const _KidsRedirectCard()
        else ...[
          const _DailyHeroCard(),
          const SizedBox(height: 18),
          _SectionHeader(
            title: l10n.learnGamesIslandSectionsTitle,
            subtitle: l10n.learnGamesIslandSectionsSubtitle,
          ),
          const SizedBox(height: 10),
          SectionHubActionGrid(
            actions: [
              for (final section in sections)
                SectionHubAction(
                  title: section.title,
                  subtitle: section.subtitle,
                  icon: section.icon,
                  color: section.baseColor,
                  accentColor: section.accentColor,
                  onTap: () => context.pushNamed(
                    'learnGamesSection',
                    pathParameters: {'sectionId': section.id},
                  ),
                ),
            ],
          ),
          for (final section in visibleSections) ...[
            const SizedBox(height: 18),
            _SectionHeader(title: section.title, subtitle: section.subtitle),
            const SizedBox(height: 10),
            SectionHubActionGrid(
              actions: [
                for (final card in section.cards)
                  SectionHubAction(
                    title: card.badgeLabel == null
                        ? card.title
                        : '${card.title} • ${card.badgeLabel}',
                    subtitle: card.subtitle,
                    icon: card.icon,
                    color: card.baseColor,
                    accentColor: card.accentColor,
                    onTap: () => context.pushNamed(
                      card.routeTarget.routeName,
                      pathParameters: card.routeTarget.pathParameters,
                      queryParameters: card.routeTarget.queryParameters,
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 18),
          _SectionHeader(
            title: l10n.learnGamesIslandKidsEntryTitle,
            subtitle: l10n.learnGamesIslandKidsEntrySubtitle,
          ),
          const SizedBox(height: 10),
          SectionHubActionGrid(
            actions: [
              SectionHubAction(
                title: l10n.learnGamesIslandKidsEntryAction,
                subtitle: l10n.learnGamesIslandKidsEntryActionSubtitle,
                icon: Icons.child_care_rounded,
                color: const Color(0xFFF8E7D7),
                accentColor: const Color(0xFFBF6F1F),
                onTap: () => context.pushNamed('learnKidsGames'),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _DailyHeroCard extends ConsumerWidget {
  const _DailyHeroCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final bundleAsync = ref.watch(dailyKnowledgeChallengeBundleProvider);
    final hubProgress = ref.watch(dailyKnowledgeChallengeHubProgressProvider);
    final streak = ref.watch(dailyKnowledgeChallengeHubStreakProvider);
    final recentHistoryCount = ref.watch(
      dailyKnowledgeChallengeHubRecentHistoryCountProvider,
    );

    return bundleAsync.when(
      data: (bundle) {
        final progress = hubProgress.progressFor(bundle.dateKey);
        final inProgress = bundle.completedCount > 0 && !bundle.isCompleted;
        return PremiumCard(
          surfaceVariant: AppSurfaceVariant.panel,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.learnGamesIslandDailyHeroTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                inProgress
                    ? l10n.learnGamesIslandDailyHeroInProgressSubtitle(
                        bundle.completedCount,
                        bundle.games.length,
                      )
                    : (bundle.isCompleted
                          ? l10n.learnGamesIslandDailyHeroCompletedSubtitle
                          : l10n.learnGamesIslandDailyHeroSubtitle),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _infoChip(
                    context,
                    l10n.learnGamesIslandDailyProgressLabel(
                      bundle.completedCount,
                      bundle.games.length,
                    ),
                  ),
                  _infoChip(
                    context,
                    l10n.learnGamesIslandDailyStreakLabel(streak.currentStreak),
                  ),
                  _infoChip(
                    context,
                    l10n.learnGamesIslandDailyHistoryLabel(recentHistoryCount),
                  ),
                  if (progress.startedAtIso != null && !bundle.isCompleted)
                    _infoChip(context, l10n.learnGamesIslandInProgressBadge),
                ],
              ),
              const SizedBox(height: 14),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed('learnDailyKnowledgeHub'),
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(
                  inProgress
                      ? l10n.learnGamesIslandContinueDailyAction
                      : l10n.learnGamesIslandOpenDailyAction,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => PremiumCard(
        surfaceVariant: AppSurfaceVariant.panel,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.learnGamesIslandDailyHeroTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(l10n.learnGamesIslandLoadingSubtitle),
          ],
        ),
      ),
      error: (_, _) => PremiumCard(
        surfaceVariant: AppSurfaceVariant.panel,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.learnGamesIslandDailyHeroTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(l10n.learnGamesIslandDailyFallbackSubtitle),
            const SizedBox(height: 14),
            FilledButton.tonal(
              onPressed: () => context.pushNamed('learnDailyKnowledgeHub'),
              child: Text(l10n.learnGamesIslandOpenDailyAction),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label),
    );
  }
}

class _KidsRedirectCard extends StatelessWidget {
  const _KidsRedirectCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.panel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.learnGamesIslandKidsRedirectTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(l10n.learnGamesIslandKidsRedirectSubtitle),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonal(
                onPressed: () => context.pushNamed('learnKidsGames'),
                child: Text(l10n.learnGamesIslandKidsEntryAction),
              ),
              FilledButton.tonal(
                onPressed: () => context.pushNamed('learnKidsArabicLearning'),
                child: Text(l10n.learnHubSubcategoryKidsArabicLearningTitle),
              ),
              FilledButton.tonal(
                onPressed: () => context.pushNamed('learnKidsFunLearning'),
                child: Text(l10n.learnHubSubcategoryKidsFunLearningTitle),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(subtitle),
      ],
    );
  }
}
