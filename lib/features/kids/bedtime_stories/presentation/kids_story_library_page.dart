import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/bedtime_story_media_resolver.dart';
import '../application/bedtime_story_progress_service.dart';
import '../application/bedtime_story_repository.dart';
import '../domain/bedtime_story_models.dart';
import '../../seerah/application/seerah_journey_progress_service.dart';
import '../../seerah/application/seerah_journey_repository.dart';
import 'bedtime_story_cover_card.dart';
import 'bedtime_story_mini_player.dart';
import '../../../../core/theme/app_icons.dart';

class KidsStoryLibraryPage extends ConsumerWidget {
  const KidsStoryLibraryPage({super.key, this.initialCollectionId});

  final String? initialCollectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selectedCollection = _collectionFromId(initialCollectionId);
    if (selectedCollection != null) {
      final stories = ref.watch(
        kidsStoriesByCollectionProvider(selectedCollection),
      );
      final seerahJourney = ref.watch(featuredKidsSeerahJourneyProvider);
      return LearnHubPageScaffold(
        headerIcon: AppIcons.stories,
        title: _collectionTitle(l10n, selectedCollection),
        subtitle: _collectionSubtitle(l10n, selectedCollection),
        floatingBottom: const BedtimeStoryMiniPlayer(),
        children: [
          _HeroCard(
            title: _collectionTitle(l10n, selectedCollection),
            subtitle: _collectionSubtitle(l10n, selectedCollection),
          ),
          if (selectedCollection == KidsIslamicStoryCollectionType.prophets &&
              seerahJourney != null) ...[
            const SizedBox(height: 12),
            _JourneyCard(
              title: l10n.kidsSeerahFeaturedJourneyTitle,
              subtitle: l10n.kidsSeerahFeaturedJourneySubtitle,
              journeyId: seerahJourney.journeyId,
            ),
          ],
          const SizedBox(height: 18),
          ...stories.map(
            (story) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _StoryListTile(story: story),
            ),
          ),
        ],
      );
    }
    final featured = ref.watch(featuredKidsStoryProvider);
    final continueStory = ref.watch(continueKidsStoryProvider);
    final bedtimeStories = ref.watch(bedtimeEligibleStoriesProvider);
    final featuredStories = ref.watch(featuredKidsStoriesProvider);
    final seerahJourney = ref.watch(featuredKidsSeerahJourneyProvider);
    final continueSeerah = ref.watch(kidsSeerahContinueJourneyProvider);

    final collections = <_CollectionSectionData>[
      _CollectionSectionData(
        type: KidsIslamicStoryCollectionType.prophets,
        title: l10n.kidsStoryCollectionProphets,
        subtitle: l10n.kidsStoryCollectionProphetsSubtitle,
      ),
      _CollectionSectionData(
        type: KidsIslamicStoryCollectionType.companions,
        title: l10n.kidsStoryCollectionCompanions,
        subtitle: l10n.kidsStoryCollectionCompanionsSubtitle,
      ),
      _CollectionSectionData(
        type: KidsIslamicStoryCollectionType.characterAdab,
        title: l10n.kidsStoryCollectionCharacterAdab,
        subtitle: l10n.kidsStoryCollectionCharacterAdabSubtitle,
      ),
      _CollectionSectionData(
        type: KidsIslamicStoryCollectionType.dailyLifeDuas,
        title: l10n.kidsStoryCollectionDailyLife,
        subtitle: l10n.kidsStoryCollectionDailyLifeSubtitle,
      ),
      _CollectionSectionData(
        type: KidsIslamicStoryCollectionType.ramadanEid,
        title: l10n.kidsStoryCollectionRamadanEid,
        subtitle: l10n.kidsStoryCollectionRamadanEidSubtitle,
      ),
      _CollectionSectionData(
        type: KidsIslamicStoryCollectionType.familyKindness,
        title: l10n.kidsStoryCollectionFamilyKindness,
        subtitle: l10n.kidsStoryCollectionFamilyKindnessSubtitle,
      ),
    ];

    return LearnHubPageScaffold(
      headerIcon: AppIcons.stories,
      title: l10n.kidsStoryLibraryTitle,
      subtitle: l10n.kidsStoryLibrarySubtitle,
      floatingBottom: const BedtimeStoryMiniPlayer(),
      children: [
        _HeroCard(
          title: l10n.kidsStoryLibraryHeroTitle,
          subtitle: l10n.kidsStoryLibraryHeroSubtitle,
        ),
        const SizedBox(height: 12),
        if (continueStory != null) ...[
          _StoryHighlightCard(
            title: l10n.kidsStoryContinueTitle,
            subtitle: l10n.kidsStoryContinueSubtitle,
            story: continueStory,
          ),
          const SizedBox(height: 12),
        ],
        if (featured != null) ...[
          _StoryHighlightCard(
            title: l10n.kidsStoryFeaturedTitle,
            subtitle: l10n.kidsStoryFeaturedSubtitle,
            story: featured,
          ),
          const SizedBox(height: 18),
        ],
        if (seerahJourney != null) ...[
          _JourneyCard(
            title: continueSeerah != null
                ? l10n.kidsSeerahContinueJourneyTitle
                : l10n.kidsSeerahFeaturedJourneyTitle,
            subtitle: continueSeerah != null
                ? l10n.kidsSeerahContinueJourneySubtitle
                : l10n.kidsSeerahFeaturedJourneySubtitle,
            journeyId: (continueSeerah ?? seerahJourney).journeyId,
          ),
          const SizedBox(height: 18),
        ],
        _SectionHeader(
          title: l10n.kidsStoryBrowseCollectionsTitle,
          subtitle: l10n.kidsStoryBrowseCollectionsSubtitle,
        ),
        const SizedBox(height: 10),
        ...collections.map(
          (section) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _CollectionCard(section: section),
          ),
        ),
        const SizedBox(height: 18),
        _SectionHeader(
          title: l10n.kidsStoryBedtimeEligibleTitle,
          subtitle: l10n.kidsStoryBedtimeEligibleSubtitle,
        ),
        const SizedBox(height: 10),
        ...bedtimeStories
            .take(6)
            .map(
              (story) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _StoryListTile(story: story),
              ),
            ),
        const SizedBox(height: 18),
        _SectionHeader(
          title: l10n.kidsStoryFeaturedStoriesTitle,
          subtitle: l10n.kidsStoryFeaturedStoriesSubtitle,
        ),
        const SizedBox(height: 10),
        ...featuredStories
            .take(8)
            .map(
              (story) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _StoryListTile(story: story),
              ),
            ),
      ],
    );
  }

  KidsIslamicStoryCollectionType? _collectionFromId(String? value) {
    switch (value) {
      case 'prophets':
        return KidsIslamicStoryCollectionType.prophets;
      case 'companions':
        return KidsIslamicStoryCollectionType.companions;
      case 'character-adab':
        return KidsIslamicStoryCollectionType.characterAdab;
      case 'daily-life-duas':
        return KidsIslamicStoryCollectionType.dailyLifeDuas;
      case 'ramadan-eid':
        return KidsIslamicStoryCollectionType.ramadanEid;
      case 'family-kindness':
        return KidsIslamicStoryCollectionType.familyKindness;
      default:
        return null;
    }
  }

  String _collectionTitle(
    AppLocalizations l10n,
    KidsIslamicStoryCollectionType type,
  ) {
    switch (type) {
      case KidsIslamicStoryCollectionType.prophets:
        return l10n.kidsStoryCollectionProphets;
      case KidsIslamicStoryCollectionType.companions:
        return l10n.kidsStoryCollectionCompanions;
      case KidsIslamicStoryCollectionType.characterAdab:
        return l10n.kidsStoryCollectionCharacterAdab;
      case KidsIslamicStoryCollectionType.dailyLifeDuas:
        return l10n.kidsStoryCollectionDailyLife;
      case KidsIslamicStoryCollectionType.ramadanEid:
        return l10n.kidsStoryCollectionRamadanEid;
      case KidsIslamicStoryCollectionType.familyKindness:
        return l10n.kidsStoryCollectionFamilyKindness;
      case KidsIslamicStoryCollectionType.bedtime:
        return l10n.kidsStoryBedtimeEligibleTitle;
    }
  }

  String _collectionSubtitle(
    AppLocalizations l10n,
    KidsIslamicStoryCollectionType type,
  ) {
    switch (type) {
      case KidsIslamicStoryCollectionType.prophets:
        return l10n.kidsStoryCollectionProphetsSubtitle;
      case KidsIslamicStoryCollectionType.companions:
        return l10n.kidsStoryCollectionCompanionsSubtitle;
      case KidsIslamicStoryCollectionType.characterAdab:
        return l10n.kidsStoryCollectionCharacterAdabSubtitle;
      case KidsIslamicStoryCollectionType.dailyLifeDuas:
        return l10n.kidsStoryCollectionDailyLifeSubtitle;
      case KidsIslamicStoryCollectionType.ramadanEid:
        return l10n.kidsStoryCollectionRamadanEidSubtitle;
      case KidsIslamicStoryCollectionType.familyKindness:
        return l10n.kidsStoryCollectionFamilyKindnessSubtitle;
      case KidsIslamicStoryCollectionType.bedtime:
        return l10n.kidsStoryBedtimeEligibleSubtitle;
    }
  }
}

class _JourneyCard extends ConsumerWidget {
  const _JourneyCard({
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
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.island,
      child: Column(
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
          if (summary != null) ...[
            const SizedBox(height: 10),
            Text(
              l10n.kidsSeerahJourneyProgressLabel(
                summary.completedStageCount,
                summary.stages.length,
              ),
            ),
          ],
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: () => context.pushNamed(
              'kidsSeerahJourney',
              pathParameters: {'journeyId': journeyId},
            ),
            icon: const Icon(Icons.route_rounded),
            label: Text(l10n.kidsSeerahOpenJourneyAction),
          ),
        ],
      ),
    );
  }
}

class _CollectionSectionData {
  const _CollectionSectionData({
    required this.type,
    required this.title,
    required this.subtitle,
  });

  final KidsIslamicStoryCollectionType type;
  final String title;
  final String subtitle;
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.island,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
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

class _StoryHighlightCard extends ConsumerWidget {
  const _StoryHighlightCard({
    required this.title,
    required this.subtitle,
    required this.story,
  });

  final String title;
  final String subtitle;
  final BedtimeStorySeed story;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaAsync = ref.watch(bedtimeStoryResolvedMediaProvider(story));
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.island,
      child: Column(
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
          const SizedBox(height: 12),
          mediaAsync.when(
            loading: () => const SizedBox(height: 220),
            error: (_, _) => const SizedBox(height: 220),
            data: (media) => BedtimeStoryCoverCard(
              story: story,
              media: media,
              overlayTitle: story.shortTitle,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            story.summary.isNotEmpty ? story.summary : story.lesson,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonal(
                onPressed: () => context.pushNamed(
                  'kidsStoryDetail',
                  pathParameters: {'storyId': story.id},
                ),
                child: Text(AppLocalizations.of(context).kidsStoryOpenAction),
              ),
              if (story.bedtimeEligible)
                FilledButton.tonalIcon(
                  onPressed: () => context.pushNamed('kidsBedtimeCompanion'),
                  icon: const Icon(Icons.bedtime_rounded),
                  label: Text(
                    AppLocalizations.of(context).kidsStoryBedtimeChip,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CollectionCard extends ConsumerWidget {
  const _CollectionCard({required this.section});

  final _CollectionSectionData section;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stories = ref.watch(kidsStoriesByCollectionProvider(section.type));
    if (stories.isEmpty) {
      return const SizedBox.shrink();
    }
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.panel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(section.subtitle),
          const SizedBox(height: 10),
          ...stories
              .take(3)
              .map(
                (story) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _StoryListTile(story: story, dense: true),
                ),
              ),
        ],
      ),
    );
  }
}

class _StoryListTile extends ConsumerWidget {
  const _StoryListTile({required this.story, this.dense = false});

  final BedtimeStorySeed story;
  final bool dense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final progress = ref.watch(
      bedtimeStoryProgressProvider.select(
        (value) =>
            value.storyProgressById[story.id] ?? const BedtimeStoryProgress(),
      ),
    );
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.panel,
      child: InkWell(
        onTap: () => context.pushNamed(
          'kidsStoryDetail',
          pathParameters: {'storyId': story.id},
        ),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: EdgeInsets.all(dense ? 12 : 14),
          child: Row(
            children: [
              Container(
                width: dense ? 46 : 54,
                height: dense ? 46 : 54,
                decoration: _kidsNoorPanelDecoration(context),
                child: const Icon(AppIcons.stories),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.shortTitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      story.summary.isNotEmpty ? story.summary : story.lesson,
                      maxLines: dense ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _InfoChip(
                          label: _collectionLabel(l10n, story.collectionType),
                        ),
                        if (story.bedtimeEligible)
                          _InfoChip(label: l10n.kidsStoryBedtimeChip),
                        _InfoChip(
                          label: _statusLabel(l10n, progress.completionState),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel(
    AppLocalizations l10n,
    BedtimeStoryCompletionState state,
  ) {
    switch (state) {
      case BedtimeStoryCompletionState.notStarted:
        return l10n.bedtimeStoriesStatusNotStarted;
      case BedtimeStoryCompletionState.inProgress:
        return l10n.bedtimeStoriesStatusInProgress;
      case BedtimeStoryCompletionState.completed:
        return l10n.bedtimeStoriesStatusCompleted;
    }
  }

  String _collectionLabel(
    AppLocalizations l10n,
    KidsIslamicStoryCollectionType type,
  ) {
    switch (type) {
      case KidsIslamicStoryCollectionType.prophets:
        return l10n.kidsStoryCollectionProphets;
      case KidsIslamicStoryCollectionType.companions:
        return l10n.kidsStoryCollectionCompanions;
      case KidsIslamicStoryCollectionType.characterAdab:
        return l10n.kidsStoryCollectionCharacterAdab;
      case KidsIslamicStoryCollectionType.dailyLifeDuas:
        return l10n.kidsStoryCollectionDailyLife;
      case KidsIslamicStoryCollectionType.ramadanEid:
        return l10n.kidsStoryCollectionRamadanEid;
      case KidsIslamicStoryCollectionType.familyKindness:
        return l10n.kidsStoryCollectionFamilyKindness;
      case KidsIslamicStoryCollectionType.bedtime:
        return l10n.kidsStoryBedtimeChip;
    }
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: _kidsNoorPillDecoration(context),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

BoxDecoration _kidsNoorPillDecoration(
  BuildContext context, {
  Color? tintColor,
}) {
  final style = AppSurfaceTheme.resolve(
    context,
    variant: AppSurfaceVariant.pill,
    tintColor: tintColor,
  );
  return style.decoration(radius: 999);
}

BoxDecoration _kidsNoorPanelDecoration(
  BuildContext context, {
  double radius = 16,
  Color? tintColor,
}) {
  final style = AppSurfaceTheme.resolve(
    context,
    variant: AppSurfaceVariant.panel,
    tintColor: tintColor,
  );
  return style.decoration(radius: radius);
}
