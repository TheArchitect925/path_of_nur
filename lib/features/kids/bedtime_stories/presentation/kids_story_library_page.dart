import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/display/art_header_card.dart';
import '../../../../shared/widgets/display/compact_list_tile.dart';
import '../../../../shared/widgets/display/hub_list_group.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../learn/shared/learn_art_assets.dart';
import '../../seerah/application/seerah_journey_progress_service.dart';
import '../../seerah/application/seerah_journey_repository.dart';
import '../../shared/application/kids_age_band_provider.dart';
import '../../shared/domain/kids_age_band.dart';
import '../../shared/presentation/kids_page_scaffold.dart';
import '../application/bedtime_story_learning_loop_service.dart';
import '../application/bedtime_story_player_controller.dart';
import '../application/bedtime_story_progress_service.dart';
import '../application/bedtime_story_repository.dart';
import '../domain/bedtime_story_learning_models.dart';
import '../domain/bedtime_story_models.dart';
import 'bedtime_story_mini_player.dart';

/// The one library for every kids story. The landing is a set of shelves
/// (collections) plus what to open right now; a shelf opens as this same
/// page with [initialCollectionId] set. The bedtime, prophet and hadith
/// story pages that used to be separate libraries are shelves here.
class KidsStoryLibraryPage extends ConsumerWidget {
  const KidsStoryLibraryPage({super.key, this.initialCollectionId});

  final String? initialCollectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selectedCollection = _collectionFromId(initialCollectionId);
    if (selectedCollection != null) {
      return _CollectionView(collection: selectedCollection);
    }

    final continueStory = ref.watch(continueKidsStoryProvider);
    final tonight = ref.watch(tonightBedtimeStoryProvider);
    final featured = ref.watch(featuredKidsStoryProvider);
    final seerahJourney = ref.watch(featuredKidsSeerahJourneyProvider);
    final continueSeerah = ref.watch(kidsSeerahContinueJourneyProvider);
    final continueLearning = ref.watch(
      bedtimeStoryContinueLearningSuggestionProvider,
    );
    final tonightLearning = ref.watch(
      bedtimeStoryTonightLearningSuggestionProvider,
    );

    // One story to open now: the one in progress, else tonight's pick, else
    // the featured one. Never three cards saying "read this".
    final openNow = continueStory ?? tonight ?? featured;
    final openNowEyebrow = continueStory != null
        ? l10n.kidsStoryContinueTitle
        : (tonight != null
              ? l10n.kidsLandingTonightTitle
              : l10n.kidsStoryFeaturedTitle);

    return KidsPageScaffold(
      headerIcon: AppIcons.stories,
      title: l10n.kidsStoryLibraryTitle,
      subtitle: l10n.kidsStoryLibrarySubtitle,
      floatingBottom: const BedtimeStoryMiniPlayer(),
      children: [
        if (openNow != null) ...[
          _StoryHeroCard(
            story: openNow,
            eyebrow: openNowEyebrow,
            startsTonightQueue: continueStory == null && tonight != null,
          ),
          const SizedBox(height: 14),
        ],
        if (continueLearning != null) ...[
          _LearningLoopCard(
            title: l10n.bedtimeStoryContinueLearningTitle,
            suggestion: continueLearning,
          ),
          const SizedBox(height: 12),
        ],
        if (tonightLearning != null &&
            continueLearning?.activityId != tonightLearning.activityId) ...[
          _LearningLoopCard(
            title: l10n.bedtimeStoryTonightQuestionTitle,
            suggestion: tonightLearning,
          ),
          const SizedBox(height: 12),
        ],
        HubListGroup(
          title: l10n.kidsStoryBrowseCollectionsTitle,
          children: [
            for (final type in _shelfOrder) _CollectionCard(type: type),
          ],
        ),
        if (seerahJourney != null) ...[
          const SizedBox(height: 14),
          _JourneyCard(
            title: continueSeerah != null
                ? l10n.kidsSeerahContinueJourneyTitle
                : l10n.kidsSeerahFeaturedJourneyTitle,
            journeyId: (continueSeerah ?? seerahJourney).journeyId,
          ),
        ],
        const SizedBox(height: 14),
        HubListGroup(
          title: l10n.kidsStoryFeaturedStoriesTitle,
          children: [
            CompactListTile(
              leading: ArtLeadingThumb(
                imageAsset:
                    kidsSubcategoryArtAsset('kids-hadith-stories') ??
                    _fallbackArt,
                fallbackIcon: AppIcons.hadith,
                fallbackColor: Theme.of(context).colorScheme.primary,
              ),
              title: l10n.learnHubSubcategoryKidsHadithStoriesTitleText,
              subtitle: l10n.learnHubSubcategoryKidsHadithStoriesSubtitleText,
              onTap: () => context.pushNamed('learnKidsHadithStories'),
            ),
            CompactListTile(
              leading: ArtLeadingThumb(
                imageAsset:
                    kidsSubcategoryArtAsset('kids-quran') ?? _fallbackArt,
                fallbackIcon: AppIcons.quran,
                fallbackColor: Theme.of(context).colorScheme.primary,
              ),
              title: l10n.learnHubSubcategoryKidsQuranTitleText,
              subtitle: l10n.learnHubSubcategoryKidsQuranSubtitleText,
              onTap: () => context.pushNamed('learnKidsQuran'),
            ),
            CompactListTile(
              leading: ArtLeadingThumb(
                imageAsset:
                    kidsSubcategoryArtAsset('kids-hadith') ?? _fallbackArt,
                fallbackIcon: AppIcons.hadith,
                fallbackColor: Theme.of(context).colorScheme.primary,
              ),
              title: l10n.learnHubSubcategoryKidsHadithTitleText,
              subtitle: l10n.learnHubSubcategoryKidsHadithSubtitleText,
              onTap: () => context.pushNamed('learnKidsHadith'),
            ),
          ],
        ),
      ],
    );
  }

  static const _shelfOrder = <KidsIslamicStoryCollectionType>[
    KidsIslamicStoryCollectionType.bedtime,
    KidsIslamicStoryCollectionType.prophets,
    KidsIslamicStoryCollectionType.foundations,
    KidsIslamicStoryCollectionType.companions,
    KidsIslamicStoryCollectionType.characterAdab,
    KidsIslamicStoryCollectionType.dailyLifeDuas,
    KidsIslamicStoryCollectionType.familyKindness,
    KidsIslamicStoryCollectionType.ramadanEid,
  ];

  KidsIslamicStoryCollectionType? _collectionFromId(String? value) {
    switch (value) {
      case 'bedtime':
        return KidsIslamicStoryCollectionType.bedtime;
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
      case 'first-steps':
        return KidsIslamicStoryCollectionType.foundations;
      default:
        return null;
    }
  }
}

const String _fallbackArt = 'assets/images/learn_art/kids_story_library.webp';

/// The stories on a shelf. Bedtime is not a collection in the seed but a
/// flag on any story, so it reads the bedtime-eligible list.
ProviderListenable<List<BedtimeStorySeed>> _shelfStoriesProvider(
  KidsIslamicStoryCollectionType type,
) {
  return type == KidsIslamicStoryCollectionType.bedtime
      ? bedtimeEligibleStoriesProvider
      : kidsStoriesByCollectionProvider(type);
}

String _collectionId(KidsIslamicStoryCollectionType type) {
  switch (type) {
    case KidsIslamicStoryCollectionType.bedtime:
      return 'bedtime';
    case KidsIslamicStoryCollectionType.prophets:
      return 'prophets';
    case KidsIslamicStoryCollectionType.companions:
      return 'companions';
    case KidsIslamicStoryCollectionType.characterAdab:
      return 'character-adab';
    case KidsIslamicStoryCollectionType.dailyLifeDuas:
      return 'daily-life-duas';
    case KidsIslamicStoryCollectionType.ramadanEid:
      return 'ramadan-eid';
    case KidsIslamicStoryCollectionType.familyKindness:
      return 'family-kindness';
    case KidsIslamicStoryCollectionType.foundations:
      return 'first-steps';
  }
}

/// Every shelf wears one of its own covers.
String _collectionArt(KidsIslamicStoryCollectionType type) {
  switch (type) {
    case KidsIslamicStoryCollectionType.bedtime:
      return _fallbackArt;
    case KidsIslamicStoryCollectionType.prophets:
      return kidsSubcategoryArtAsset('kids-prophet-stories') ?? _fallbackArt;
    case KidsIslamicStoryCollectionType.companions:
      return kidsSubcategoryArtAsset('kids-seerah-journeys') ?? _fallbackArt;
    case KidsIslamicStoryCollectionType.characterAdab:
      return 'assets/images/kids_stories/covers/telling_the_truth_cover.webp';
    case KidsIslamicStoryCollectionType.dailyLifeDuas:
      return 'assets/images/kids_stories/covers/bismillah_before_eating_cover.webp';
    case KidsIslamicStoryCollectionType.ramadanEid:
      return 'assets/images/kids_stories/covers/ramadan_kindness_cover.webp';
    case KidsIslamicStoryCollectionType.familyKindness:
      return 'assets/images/kids_stories/covers/helping_parents_cover.webp';
    case KidsIslamicStoryCollectionType.foundations:
      return 'assets/images/kids_books/covers/five_pillars_cover.webp';
  }
}

String _collectionTitle(
  AppLocalizations l10n,
  KidsIslamicStoryCollectionType type,
) {
  switch (type) {
    case KidsIslamicStoryCollectionType.bedtime:
      return l10n.kidsStoryBedtimeEligibleTitle;
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
    case KidsIslamicStoryCollectionType.foundations:
      return l10n.kidsStoryCollectionFoundations;
  }
}

String _collectionSubtitle(
  AppLocalizations l10n,
  KidsIslamicStoryCollectionType type,
) {
  switch (type) {
    case KidsIslamicStoryCollectionType.bedtime:
      return l10n.kidsStoryBedtimeEligibleSubtitle;
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
    case KidsIslamicStoryCollectionType.foundations:
      return l10n.kidsStoryCollectionFoundationsSubtitle;
  }
}

/// One shelf: its cover art, then every story on it.
class _CollectionView extends ConsumerWidget {
  const _CollectionView({required this.collection});

  final KidsIslamicStoryCollectionType collection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // The child's own age band reads first on every shelf (K6).
    final stories = kidsStoriesOrderedForBand(
      ref.watch(_shelfStoriesProvider(collection)),
      ref.watch(kidsAgeBandProvider),
    );
    final seerahJourney = ref.watch(featuredKidsSeerahJourneyProvider);
    final tonight = collection == KidsIslamicStoryCollectionType.bedtime
        ? ref.watch(tonightBedtimeStoryProvider)
        : null;
    final title = _collectionTitle(l10n, collection);
    return KidsPageScaffold(
      headerIcon: AppIcons.stories,
      title: title,
      subtitle: _collectionSubtitle(l10n, collection),
      heroAsset: _collectionArt(collection),
      heroTitle: title,
      heroSubtitle: l10n.bedtimeStoriesCountLabel(stories.length),
      floatingBottom: const BedtimeStoryMiniPlayer(),
      children: [
        if (tonight != null) ...[
          _StoryHeroCard(
            story: tonight,
            eyebrow: l10n.kidsLandingTonightTitle,
            startsTonightQueue: true,
          ),
          const SizedBox(height: 14),
        ],
        if (collection == KidsIslamicStoryCollectionType.prophets &&
            seerahJourney != null) ...[
          _JourneyCard(
            title: l10n.kidsSeerahFeaturedJourneyTitle,
            journeyId: seerahJourney.journeyId,
          ),
          const SizedBox(height: 14),
        ],
        ...stories.map(
          (story) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _StoryListTile(story: story),
          ),
        ),
      ],
    );
  }
}

/// The story to open now, on its own cover.
class _StoryHeroCard extends ConsumerWidget {
  const _StoryHeroCard({
    required this.story,
    required this.eyebrow,
    required this.startsTonightQueue,
  });

  final BedtimeStorySeed story;
  final String eyebrow;

  /// Tonight's pick also arms the bedtime queue so the next story follows.
  final bool startsTonightQueue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ArtHeaderCard(
      imageAsset: story.coverAssetPath,
      eyebrow: eyebrow,
      title: story.title,
      subtitle: story.summary.isNotEmpty ? story.summary : story.lesson,
      fallbackIcon: AppIcons.stories,
      fallbackColor: Theme.of(context).colorScheme.primary,
      aspectRatio: 16 / 9,
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      onTap: () async {
        if (startsTonightQueue) {
          await ref
              .read(bedtimeStoryQueueControllerProvider.notifier)
              .startTonightStory();
        }
        if (context.mounted) {
          context.pushNamed(
            'kidsStoryDetail',
            pathParameters: {'storyId': story.id},
          );
        }
      },
    );
  }
}

class _LearningLoopCard extends StatelessWidget {
  const _LearningLoopCard({required this.title, required this.suggestion});

  final String title;
  final BedtimeStoryLearningSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isQuiz = suggestion.mode == BedtimeStoryLearningMode.quiz;
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.island,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(suggestion.title),
          const SizedBox(height: 4),
          Text(suggestion.subtitle),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => context.pushNamed(
              isQuiz ? 'kidsBedtimeStoryQuiz' : 'kidsBedtimeStoryMemory',
              pathParameters: {'storyId': suggestion.storyId},
            ),
            icon: Icon(isQuiz ? AppIcons.quiz : AppIcons.games),
            label: Text(
              isQuiz
                  ? l10n.bedtimeStoryQuizStartAction
                  : l10n.bedtimeStoryMemoryStartAction,
            ),
          ),
        ],
      ),
    );
  }
}

class _JourneyCard extends ConsumerWidget {
  const _JourneyCard({required this.title, required this.journeyId});

  final String title;
  final String journeyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(kidsSeerahJourneySummaryProvider(journeyId));
    return ArtHeaderCard(
      imageAsset:
          kidsSubcategoryArtAsset('kids-seerah-journeys') ?? _fallbackArt,
      eyebrow: l10n.kidsSeerahJourneysTitle,
      title: title,
      subtitle: summary == null
          ? null
          : l10n.kidsSeerahJourneyProgressLabel(
              summary.completedStageCount,
              summary.stages.length,
            ),
      fallbackIcon: AppIcons.seerah,
      fallbackColor: Theme.of(context).colorScheme.primary,
      aspectRatio: 16 / 9,
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      onTap: () => context.pushNamed(
        'kidsSeerahJourney',
        pathParameters: {'journeyId': journeyId},
      ),
    );
  }
}

/// A shelf on the landing: cover, name, how many stories are on it.
class _CollectionCard extends ConsumerWidget {
  const _CollectionCard({required this.type});

  final KidsIslamicStoryCollectionType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final stories = ref.watch(_shelfStoriesProvider(type));
    if (stories.isEmpty) return const SizedBox.shrink();
    return CompactListTile(
      leading: ArtLeadingThumb(
        imageAsset: _collectionArt(type),
        fallbackIcon: AppIcons.stories,
        fallbackColor: Theme.of(context).colorScheme.primary,
      ),
      title: _collectionTitle(l10n, type),
      subtitle: l10n.bedtimeStoriesCountLabel(stories.length),
      onTap: () => context.pushNamed(
        'kidsStoryLibrary',
        queryParameters: {'collection': _collectionId(type)},
      ),
    );
  }
}

class _StoryListTile extends ConsumerWidget {
  const _StoryListTile({required this.story});

  final BedtimeStorySeed story;

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
      onTap: () => context.pushNamed(
        'kidsStoryDetail',
        pathParameters: {'storyId': story.id},
      ),
      child: Row(
        children: [
          ArtLeadingThumb(
            imageAsset: story.coverAssetPath,
            fallbackIcon: AppIcons.stories,
            fallbackColor: Theme.of(context).colorScheme.primary,
            size: 64,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story.shortTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  story.summary.isNotEmpty ? story.summary : story.lesson,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (progress.completionState !=
                    BedtimeStoryCompletionState.notStarted) ...[
                  const SizedBox(height: 6),
                  _InfoChip(
                    label: _statusLabel(l10n, progress.completionState),
                  ),
                ],
              ],
            ),
          ),
        ],
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
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: style.decoration(radius: 999),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
