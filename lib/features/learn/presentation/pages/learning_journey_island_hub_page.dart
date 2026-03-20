import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/content/learning_quote.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../journey/application/learning_journey_progress_provider.dart';
import '../../journey/data/learning_journey_localized_metadata.dart';
import '../application/learn_hub_providers.dart';
import '../widgets/learn_hub_page_scaffold.dart';

class LearningJourneyIslandHubPage extends ConsumerWidget {
  const LearningJourneyIslandHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final continueState = ref.watch(learningJourneyContinueProvider);
    final recommendations = ref.watch(learningJourneyRecommendationsProvider);
    final journeyProgress = ref.watch(learningJourneyProgressProvider);

    return LearnHubPageScaffold(
      headerIcon: Icons.route_rounded,
      title: l10n.learnHubJourneyIslandTitle,
      subtitle: l10n.learnHubJourneysSectionSubtitle,
      quoteHeader: const LearningHubRabbiZidniIlmaHeader(),
      children: [
        _SectionHeader(
          title: l10n.learnHubJourneysSectionTitle,
          subtitle: l10n.learnHubJourneysSectionSubtitle,
        ),
        const SizedBox(height: 10),
        _JourneySection(
          continueState: continueState,
          recommendations: recommendations,
          completedStageIds: journeyProgress.completedStageIds,
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

class _JourneySection extends StatelessWidget {
  const _JourneySection({
    required this.continueState,
    required this.recommendations,
    required this.completedStageIds,
  });

  final LearningJourneyContinueState continueState;
  final LearningJourneyRecommendationSet recommendations;
  final Set<String> completedStageIds;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentJourney = continueState.journey;
    final recommended = recommendations.journeys.isEmpty
        ? null
        : recommendations.journeys.first;

    if (currentJourney == null && recommended == null) {
      return PremiumCard(
        surfaceVariant: AppSurfaceVariant.panel,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.learnHubJourneysBrowseAction,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(l10n.learnHubJourneysSectionSubtitle),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: () => context.pushNamed('learnJourneyHome'),
              icon: const Icon(Icons.grid_view_rounded),
              label: Text(l10n.learnHubJourneysBrowseAction),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (currentJourney != null)
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => context.pushNamed(
              'learnJourneyDetail',
              pathParameters: {'journeyId': currentJourney.id},
            ),
            child: PremiumCard(
              surfaceVariant: AppSurfaceVariant.panel,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.learnHubJourneysCurrentLabel,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    localizedJourneyTitle(context, currentJourney),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(localizedJourneySubtitle(context, currentJourney)),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: journeyProgressRatio(
                      completedStageIds: completedStageIds,
                      stageIds: currentJourney.stageIds,
                    ),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: continueState.stage == null
                            ? null
                            : () => context.pushNamed(
                                'learnJourneyStage',
                                pathParameters: {
                                  'journeyId': currentJourney.id,
                                  'stageId': continueState.stage!.id,
                                },
                              ),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: Text(l10n.learnHubJourneysContinueAction),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () => context.pushNamed(
                          'learnJourneyDetail',
                          pathParameters: {'journeyId': currentJourney.id},
                        ),
                        icon: const Icon(Icons.route_rounded),
                        label: Text(l10n.learnHubJourneysCurrentAction),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () => context.pushNamed('learnJourneyHome'),
                        icon: const Icon(Icons.swap_horiz_rounded),
                        label: Text(l10n.learnHubJourneysChangeAction),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () => context.pushNamed('learnJourneyHome'),
                        icon: const Icon(Icons.grid_view_rounded),
                        label: Text(l10n.learnHubJourneysBrowseAction),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        if (recommended != null) ...[
          const SizedBox(height: 10),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => context.pushNamed(
              'learnJourneyDetail',
              pathParameters: {'journeyId': recommended.id},
            ),
            child: PremiumCard(
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.learnHubJourneysRecommendedLabel,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          localizedJourneyTitle(context, recommended),
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          localizedJourneySubtitle(context, recommended),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
