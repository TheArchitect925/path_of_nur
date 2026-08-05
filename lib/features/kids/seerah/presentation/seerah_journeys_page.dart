import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../../bedtime_stories/application/bedtime_story_repository.dart';
import '../../bedtime_stories/presentation/bedtime_story_mini_player.dart';
import '../application/seerah_journey_progress_service.dart';
import '../application/seerah_journey_repository.dart';

class KidsSeerahJourneysPage extends ConsumerWidget {
  const KidsSeerahJourneysPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final journeys = ref.watch(kidsSeerahJourneysProvider);
    final continueJourney = ref.watch(kidsSeerahContinueJourneyProvider);
    final companionStories = ref.watch(kidsSeerahCompanionStoriesProvider);
    final featuredJourney = ref.watch(featuredKidsSeerahJourneyProvider);
    final muhammadSeries = ref.watch(bedtimeStorySeriesProvider('muhammad'));

    return LearnHubPageScaffold(
      headerIcon: Icons.route_rounded,
      title: l10n.kidsSeerahJourneysTitle,
      subtitle: l10n.kidsSeerahJourneysSubtitle,
      floatingBottom: const BedtimeStoryMiniPlayer(),
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.kidsSeerahJourneysHeroTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(l10n.kidsSeerahJourneysHeroSubtitle),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (continueJourney != null) ...[
          _JourneyHighlightCard(
            title: l10n.kidsSeerahContinueJourneyTitle,
            subtitle: l10n.kidsSeerahContinueJourneySubtitle,
            journeyId: continueJourney.journeyId,
          ),
          const SizedBox(height: 12),
        ],
        if (featuredJourney != null) ...[
          _JourneyHighlightCard(
            title: l10n.kidsSeerahFeaturedJourneyTitle,
            subtitle: l10n.kidsSeerahFeaturedJourneySubtitle,
            journeyId: featuredJourney.journeyId,
          ),
          const SizedBox(height: 18),
        ],
        _SectionHeader(
          title: l10n.kidsSeerahStagesPreviewTitle,
          subtitle: l10n.kidsSeerahStagesPreviewSubtitle(muhammadSeries.length),
        ),
        const SizedBox(height: 10),
        ...muhammadSeries.map(
          (story) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _SimpleStoryCard(
              title: story.shortTitle,
              subtitle: story.summary.isNotEmpty ? story.summary : story.lesson,
              onTap: () => context.pushNamed(
                'kidsStoryDetail',
                pathParameters: {'storyId': story.id},
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        _SectionHeader(
          title: l10n.kidsSeerahCompanionStoriesTitle,
          subtitle: l10n.kidsSeerahCompanionStoriesSubtitle,
        ),
        const SizedBox(height: 10),
        ...companionStories.map(
          (companion) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _SimpleStoryCard(
              title: companion.name,
              subtitle: companion.shortSummary,
              onTap: () => context.pushNamed(
                'kidsStoryDetail',
                pathParameters: {'storyId': companion.storyId},
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        _SectionHeader(
          title: l10n.kidsSeerahJourneysAllTitle,
          subtitle: l10n.kidsSeerahJourneysAllSubtitle,
        ),
        const SizedBox(height: 10),
        ...journeys.map(
          (journey) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _JourneyHighlightCard(
              title: journey.title,
              subtitle: journey.description,
              journeyId: journey.journeyId,
            ),
          ),
        ),
      ],
    );
  }
}

class _JourneyHighlightCard extends ConsumerWidget {
  const _JourneyHighlightCard({
    required this.title,
    required this.subtitle,
    required this.journeyId,
  });

  final String title;
  final String subtitle;
  final String journeyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(kidsSeerahJourneySummaryProvider(journeyId));
    final progressText = summary == null
        ? l10n.kidsSeerahJourneyUnavailableSubtitle
        : l10n.kidsSeerahJourneyProgressLabel(
            summary.completedStageCount,
            summary.stages.length,
          );
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(subtitle),
          const SizedBox(height: 12),
          Text(progressText),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: () => context.pushNamed(
              'kidsSeerahJourney',
              pathParameters: {'journeyId': journeyId},
            ),
            icon: const Icon(Icons.timeline_rounded),
            label: Text(l10n.kidsSeerahOpenJourneyAction),
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
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(subtitle),
      ],
    );
  }
}

class _SimpleStoryCard extends StatelessWidget {
  const _SimpleStoryCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
