import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/display/progress_bar.dart';
import '../../../../shared/content/learning_quote.dart';
import '../../../../shared/widgets/app_hero_glass_shell.dart';
import '../../../../shared/widgets/app_layered_glass_pill_button.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../analytics/application/learn_analytics_service.dart';
import '../../analytics/domain/learn_analytics_models.dart';
import '../../enrichment/application/learn_enrichment_provider.dart';
import '../../enrichment/presentation/widgets/learn_enrichment_cards.dart';
import '../../guided_paths/application/guided_learning_paths_provider.dart';
import '../../guided_paths/domain/guided_learning_path_icon_registry.dart';
import '../../guided_paths/domain/guided_learning_path_models.dart';
import '../../journey/application/family_learning_provider.dart';
import '../../personalization/application/learning_personalization_provider.dart';
import '../../shared/application/learn_system_engine_provider.dart';
import '../../shared/domain/learn_system_models.dart';
import '../widgets/learn_hub_page_scaffold.dart';
import '../widgets/learn_personalized_next_step_card.dart';

class LearningJourneyIslandHubPage extends ConsumerWidget {
  const LearningJourneyIslandHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final analytics = ref.read(learnAnalyticsServiceProvider);
    final summary = ref.watch(learnUnifiedSummaryV2Provider);
    final pathResume = ref.watch(guidedLearningPathResumeProvider);
    final localizedPaths = ref.watch(localizedGuidedLearningPathsProvider);
    final personalizedNextStep = ref.watch(
      localizedLearningPersonalizationSummaryProvider,
    );
    final pendingMilestone = ref.watch(
      localizedPendingLearningMilestoneProvider,
    );
    final learningMemories = ref.watch(localizedLearningMemoriesProvider);
    final encouragement = ref.watch(localizedLearningEncouragementProvider);
    final visibilityPolicy = ref.watch(
      activeFamilyLearningContextProvider.select(
        (value) => value.visibilityPolicy,
      ),
    );
    final visiblePaths = localizedPaths
        .where(
          (path) =>
              !visibilityPolicy.isChildProfile ||
              path.path.audience == GuidedLearningPathAudience.kids,
        )
        .toList(growable: false);

    LocalizedGuidedLearningPath? activeLocalizedPath;
    LocalizedGuidedLearningPathStep? nextGuidedStep;
    if (pathResume.hasActivePath && pathResume.activePath != null) {
      activeLocalizedPath = localizedPaths
          .cast<LocalizedGuidedLearningPath?>()
          .firstWhere(
            (path) => path?.path.id == pathResume.activePath!.id,
            orElse: () => null,
          );
      if (activeLocalizedPath != null && pathResume.nextStep != null) {
        nextGuidedStep = activeLocalizedPath.steps
            .cast<LocalizedGuidedLearningPathStep?>()
            .firstWhere(
              (step) => step?.step.id == pathResume.nextStep!.id,
              orElse: () => null,
            );
      }
    }

    return LearnHubPageScaffold(
      headerIcon: Icons.route_rounded,
      title: l10n.learnHubMainIslandLearningPathTitle,
      subtitle: l10n.learnHubMainIslandLearningPathSubtitle,
      quoteHeader: const LearningHubRabbiZidniIlmaHeader(),
      showDefaultQuote: true,
      children: [
        _SectionHeader(
          title: l10n.learnPersonalizationSectionTitle,
          subtitle: l10n.learnPersonalizationSectionSubtitle,
        ),
        const SizedBox(height: 10),
        LearnPersonalizedNextStepCard(summary: personalizedNextStep),
        if (pendingMilestone != null || learningMemories.isNotEmpty) ...[
          const SizedBox(height: 18),
          _SectionHeader(
            title: l10n.learnEnrichmentSectionTitle,
            subtitle: l10n.learnEnrichmentSectionSubtitle,
          ),
          const SizedBox(height: 10),
          if (pendingMilestone != null) ...[
            LearnMilestoneMomentCard(moment: pendingMilestone),
            if (learningMemories.isNotEmpty) const SizedBox(height: 12),
          ],
          if (learningMemories.isNotEmpty)
            LearnMemoryHighlightsCard(
              memories: learningMemories,
              encouragement: encouragement,
            ),
        ],
        const SizedBox(height: 18),
        _SectionHeader(
          title: l10n.learnHubContinueJourneyTitle,
          subtitle: l10n.learnHubContinueJourneySubtitle,
        ),
        const SizedBox(height: 10),
        if (activeLocalizedPath != null && nextGuidedStep != null)
          _ContinueGuidedPathCard(
            localizedPath: activeLocalizedPath,
            nextStep: nextGuidedStep,
            onContinueTracked: () => analytics.logPrimaryCardOpened(
              cardId: 'continue_guided_path',
              sourceSurface: 'learn_journey_island',
              domain: activeLocalizedPath!.path.bucketId,
            ),
          )
        else if (summary.continueItem != null)
          _ContinueLearningCard(
            item: summary.continueItem!,
            onOpenTracked: () => analytics.logPrimaryCardOpened(
              cardId: 'continue_learning',
              sourceSurface: 'learn_journey_island',
            ),
          )
        else
          _BrowseJourneysCard(
            title: l10n.learnHubLandingBrowseJourneysTitle,
            subtitle: l10n.learnHubLandingBrowseJourneysSubtitle,
            onOpenTracked: () => analytics.logPrimaryCardOpened(
              cardId: 'browse_guided_paths',
              sourceSurface: 'learn_journey_island',
            ),
          ),
        const SizedBox(height: 18),
        _SectionHeader(
          title: l10n.learnHubDailyLearningTitle,
          subtitle: l10n.learnHubDailyLearningLandingSubtitle,
        ),
        const SizedBox(height: 10),
        _DailyLearningCard(summary: summary),
        const SizedBox(height: 18),
        _SectionHeader(
          title: l10n.learnHubStartJourneyTitle,
          subtitle: visibilityPolicy.isChildProfile
              ? l10n.guidedLearningPathsSectionKidsSubtitle
              : l10n.guidedLearningPathsSectionSubtitle,
        ),
        const SizedBox(height: 10),
        _GuidedLearningPathsGrid(
          paths: visiblePaths,
          activePathId: pathResume.activePath?.id,
        ),
      ],
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

class _DailyLearningCard extends StatelessWidget {
  const _DailyLearningCard({required this.summary});

  final LearnUnifiedSummaryV2 summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _LearnLandingNoorCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.learnHubDailyThemeLabel(summary.dailyItem.theme.label),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            summary.dailyItem.item.title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            summary.dailyItem.item.summary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppLayeredGlassPillButton(
                onPressed: summary.dailyItem.item.routeName == null
                    ? null
                    : () => context.pushNamed(
                        summary.dailyItem.item.routeName!,
                        pathParameters: summary.dailyItem.item.pathParameters,
                        queryParameters: summary.dailyItem.item.queryParameters,
                      ),
                leading: const Icon(Icons.auto_awesome_rounded, size: 18),
                label: l10n.learnHubOpenDailyLearningAction,
              ),
              AppLayeredGlassPillButton(
                onPressed: () => context.pushNamed('journalCreate'),
                leading: const Icon(Icons.edit_note_rounded, size: 18),
                label: l10n.learnHubWriteReflectionAction,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BrowseJourneysCard extends StatelessWidget {
  const _BrowseJourneysCard({
    required this.title,
    required this.subtitle,
    required this.onOpenTracked,
  });

  final String title;
  final String subtitle;
  final VoidCallback onOpenTracked;

  @override
  Widget build(BuildContext context) {
    return _LearnLandingNoorCard(
      child: Row(
        children: [
          const Icon(Icons.route_rounded),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(subtitle),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.tonalIcon(
            onPressed: () {
              onOpenTracked();
              context.pushNamed('learnJourneyHome');
            },
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text(title),
          ),
        ],
      ),
    );
  }
}

class _ContinueLearningCard extends StatelessWidget {
  const _ContinueLearningCard({
    required this.item,
    required this.onOpenTracked,
  });

  final LearnUnifiedContentItem item;
  final VoidCallback onOpenTracked;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: item.routeName == null
          ? null
          : () {
              onOpenTracked();
              context.pushNamed(
                item.routeName!,
                pathParameters: item.pathParameters,
                queryParameters: item.queryParameters,
              );
            },
      child: _LearnLandingNoorCard(
        child: Row(
          children: [
            const Icon(Icons.menu_book_rounded),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContinueGuidedPathCard extends ConsumerWidget {
  const _ContinueGuidedPathCard({
    required this.localizedPath,
    required this.nextStep,
    required this.onContinueTracked,
  });

  final LocalizedGuidedLearningPath localizedPath;
  final LocalizedGuidedLearningPathStep nextStep;
  final VoidCallback onContinueTracked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(guidedLearningPathsControllerProvider.notifier);
    final progress = ref.watch(
      guidedLearningPathProgressProvider(localizedPath.path.id),
    );
    final completedCount = progress.completedStepIds.length;
    final totalCount = localizedPath.path.steps.length;
    final progressValue = totalCount == 0 ? 0.0 : completedCount / totalCount;
    return _LearnLandingNoorCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.alt_route_rounded),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizedPath.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.guidedLearningPathCurrentStepLabel,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(nextStep.title),
                    const SizedBox(height: 4),
                    Text(
                      nextStep.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.tonalIcon(
                onPressed: () {
                  onContinueTracked();
                  controller.markStepOpened(
                    localizedPath.path,
                    nextStep.step,
                    sourceSurface: 'learn_journey_island_continue',
                  );
                  context.pushNamed(
                    nextStep.step.routeTarget.routeName,
                    pathParameters: nextStep.step.routeTarget.pathParameters,
                    queryParameters: nextStep.step.routeTarget.queryParameters,
                  );
                },
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(l10n.guidedLearningPathContinueAction),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.guidedLearningPathStepOfTotal(completedCount + 1, totalCount),
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          ProgressBar(
            value: progressValue.clamp(0, 1),
            height: 8,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest,
          ),
          const SizedBox(height: 6),
          Text(
            l10n.guidedLearningPathProgressValue(completedCount, totalCount),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _LearnLandingNoorCard extends StatelessWidget {
  const _LearnLandingNoorCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppHeroGlassShell(child: child);
  }
}

class _GuidedLearningPathsGrid extends StatelessWidget {
  const _GuidedLearningPathsGrid({
    required this.paths,
    required this.activePathId,
  });

  final List<LocalizedGuidedLearningPath> paths;
  final String? activePathId;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 720
            ? 3
            : constraints.maxWidth >= 460
            ? 2
            : 1;
        final itemWidth = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - (12 * (columns - 1))) / columns;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: paths
              .map(
                (path) => SizedBox(
                  width: itemWidth,
                  child: _GuidedLearningPathCard(
                    localizedPath: path,
                    isActive: activePathId == path.path.id,
                  ),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }
}

class _GuidedLearningPathCard extends ConsumerWidget {
  const _GuidedLearningPathCard({
    required this.localizedPath,
    required this.isActive,
  });

  final LocalizedGuidedLearningPath localizedPath;
  final bool isActive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final analytics = ref.read(learnAnalyticsServiceProvider);
    final contentColors = AppSurfaceTheme.contentColors(context);
    final progress = ref.watch(
      guidedLearningPathProgressProvider(localizedPath.path.id),
    );
    final completedCount = progress.completedStepIds.length;
    final totalCount = localizedPath.path.steps.length;
    final statusLabel = progress.isCompleted
        ? l10n.guidedLearningPathStatusCompleted
        : progress.isStarted
        ? l10n.guidedLearningPathStatusInProgress
        : l10n.guidedLearningPathStatusNotStarted;
    final nextStep = localizedPath.steps.firstWhere(
      (step) => !progress.completedStepIds.contains(step.step.id),
      orElse: () => localizedPath.steps.last,
    );
    final progressValue = totalCount == 0 ? 0.0 : completedCount / totalCount;
    final accent = switch (localizedPath.path.bucketId) {
      'quran' => const Color(0xFF2C6E5B),
      'worship' => const Color(0xFF2A7A78),
      'character' => const Color(0xFF8A5A44),
      'kids' => const Color(0xFF7A61D1),
      _ => const Color(0xFF8B6B44),
    };
    final iconBase = switch (localizedPath.path.bucketId) {
      'quran' => const Color(0xFFE2ECE8),
      'worship' => const Color(0xFFE1ECEA),
      'character' => const Color(0xFFF0E2D6),
      'kids' => const Color(0xFFE7E0F7),
      _ => const Color(0xFFECE5D7),
    };
    final surfaceStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.island,
      tintColor: accent,
    );
    final statusStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: accent,
    );
    final innerCardTop =
        Color.lerp(iconBase, Colors.white, 0.38) ?? Colors.white;
    final innerCardBottom = Color.lerp(iconBase, accent, 0.16) ?? accent;
    final innerBorderColor =
        Color.lerp(
          Colors.white.withValues(alpha: 0.88),
          accent.withValues(alpha: 0.30),
          0.36,
        ) ??
        Colors.white.withValues(alpha: 0.88);
    return AnimatedScale(
      scale: isActive ? 1.01 : 1,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: surfaceStyle.splashColor,
          highlightColor: surfaceStyle.highlightColor,
          onTap: () {
            analytics.logPrimaryCardOpened(
              cardId: 'guided_path_${localizedPath.path.id}',
              sourceSurface: 'learn_journey_island_paths',
              domain: localizedPath.path.bucketId,
              audience: switch (localizedPath.path.audience) {
                GuidedLearningPathAudience.kids => LearnAnalyticsAudience.kids,
                GuidedLearningPathAudience.general =>
                  localizedPath.path.bucketId == 'foundations'
                      ? LearnAnalyticsAudience.beginner
                      : LearnAnalyticsAudience.general,
              },
            );
            context.pushNamed(
              'learnGuidedPathDetail',
              pathParameters: <String, String>{'pathId': localizedPath.path.id},
            );
          },
          child: PremiumCard(
            padding: const EdgeInsets.all(4),
            surfaceVariant: AppSurfaceVariant.island,
            surfaceTintColor: accent,
            includeShadow: true,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: innerBorderColor),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    innerCardTop.withValues(alpha: 0.94),
                    innerCardBottom.withValues(alpha: 0.88),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Color.alphaBlend(
                            iconBase.withValues(alpha: 0.88),
                            surfaceStyle.iconBackgroundColor,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: surfaceStyle.borderColor),
                        ),
                        child: Icon(
                          GuidedLearningPathIconRegistry.iconForPathId(
                            localizedPath.path.id,
                          ),
                          color: accent,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: statusStyle.decoration(
                          radius: 999,
                          includeShadow: false,
                        ),
                        child: Text(
                          statusLabel,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: accent,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    localizedPath.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: accent,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    localizedPath.subtitle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: contentColors.subtleForeground,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ProgressBar(
                    value: progressValue.clamp(0, 1),
                    height: 7,
                    color: accent,
                    backgroundColor: surfaceStyle.iconBackgroundColor,
                  ),
                  Text(
                    l10n.guidedLearningPathProgressValue(
                      completedCount,
                      totalCount,
                    ),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (!progress.isCompleted) ...[
                    const SizedBox(height: 6),
                    Text(
                      l10n.guidedLearningPathNextStepLabel(nextStep.title),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
