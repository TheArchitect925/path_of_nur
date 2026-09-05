import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/display/art_header_card.dart';
import '../../../../shared/widgets/display/compact_list_tile.dart';
import '../../../../shared/widgets/display/hub_list_group.dart';
import '../../../learn/analytics/application/learn_analytics_service.dart';
import '../../../learn/analytics/domain/learn_analytics_models.dart';
import '../../../learn/guided_paths/application/guided_learning_paths_provider.dart';
import '../../../learn/journey/domain/learning_path_models.dart';
import '../../../learn/shared/learn_art_assets.dart';
import '../../bedtime_stories/application/bedtime_story_repository.dart';
import '../../rewards/presentation/kids_reward_strip.dart';
import 'kids_door_card.dart';

/// The kids world in one screen: today's path, tonight's story, four doors
/// and a way for a parent in. Rendered by the Learn tab for a child profile
/// and by the Kids Learning category route for everyone else, so the two
/// front doors open onto the same room.
class KidsLandingBody extends ConsumerWidget {
  const KidsLandingBody({super.key, this.sourceSurface = 'learn_landing'});

  final String sourceSurface;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KidsStarterPathHero(sourceSurface: sourceSurface),
        const SizedBox(height: 14),
        KidsTonightStoryRow(sourceSurface: sourceSurface),
        HubListGroup(
          title: l10n.kidsLandingExploreTitle,
          children: [_KidsDoors(sourceSurface: sourceSurface)],
        ),
        const SizedBox(height: 14),
        const KidsRewardStrip(),
        const SizedBox(height: 10),
        CompactListTile(
          leading: const HubLeadingIcon(AppIcons.family),
          title: l10n.kidsDoorParentsTitle,
          subtitle: l10n.kidsDoorParentsSubtitle,
          onTap: () => context.pushNamed('kidsBedtimeStoriesParentDashboard'),
        ),
      ],
    );
  }
}

/// Stories, Letters, Duʿās, Play — each wearing its own scene.
class _KidsDoors extends ConsumerWidget {
  const _KidsDoors({required this.sourceSurface});

  final String sourceSurface;

  static const _fallbackArt = 'assets/images/learn_art/kids_story_library.webp';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    void open(String doorId, String routeName) {
      ref
          .read(learnAnalyticsServiceProvider)
          .logPrimaryCardOpened(
            cardId: 'kids_door_$doorId',
            sourceSurface: sourceSurface,
            domain: 'kids',
            audience: LearnAnalyticsAudience.kids,
          );
      context.pushNamed(routeName);
    }

    return KidsDoorGrid(
      doors: [
        KidsDoorCard(
          imageAsset: kidsSubcategoryArtAsset('kids-stories') ?? _fallbackArt,
          title: l10n.kidsDoorStoriesTitle,
          subtitle: l10n.kidsDoorStoriesSubtitle,
          fallbackIcon: AppIcons.stories,
          onTap: () => open('stories', 'kidsStoryLibrary'),
        ),
        KidsDoorCard(
          imageAsset:
              kidsSubcategoryArtAsset('kids-arabic-learning') ?? _fallbackArt,
          title: l10n.kidsDoorLettersTitle,
          subtitle: l10n.kidsDoorLettersSubtitle,
          fallbackIcon: AppIcons.letters,
          onTap: () => open('letters', 'kidsArabicHome'),
        ),
        KidsDoorCard(
          imageAsset:
              kidsSubcategoryArtAsset('kids-dua-learning') ?? _fallbackArt,
          title: l10n.kidsDoorDuasTitle,
          subtitle: l10n.kidsDoorDuasSubtitle,
          fallbackIcon: AppIcons.dua,
          onTap: () => open('duas', 'kidsDuaLanding'),
        ),
        KidsDoorCard(
          imageAsset: kidsSubcategoryArtAsset('kids-games') ?? _fallbackArt,
          title: l10n.kidsDoorPlayTitle,
          subtitle: l10n.kidsDoorPlaySubtitle,
          fallbackIcon: AppIcons.games,
          onTap: () => open('play', 'learnKidsGames'),
        ),
      ],
    );
  }
}

/// The Kids Starter Path as the hero: its scene art, live step progress, and
/// a tap straight into the guided path.
class KidsStarterPathHero extends ConsumerWidget {
  const KidsStarterPathHero({super.key, required this.sourceSurface});

  final String sourceSurface;

  static const _pathId = 'kids-starter';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final path = ref
        .watch(guidedLearningPathsProvider)
        .where((item) => item.id == _pathId)
        .firstOrNull;
    final completed = ref.watch(
      guidedLearningPathsControllerProvider.select(
        (state) => state.progressByPathId[_pathId]?.completedStepIds.length,
      ),
    );
    return ArtHeaderCard(
      imageAsset:
          guidedPathArtAsset(_pathId) ??
          levelArtAsset(LearningPathLevel.beginner),
      eyebrow: l10n.kidsLandingStarterEyebrow,
      title: localizedGuidedLearningPathTitle(l10n, _pathId),
      subtitle: path == null
          ? null
          : l10n.guidedLearningPathProgressValue(
              completed ?? 0,
              path.steps.length,
            ),
      fallbackIcon: AppIcons.kids,
      fallbackColor: Theme.of(context).colorScheme.primary,
      aspectRatio: 16 / 9,
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      onTap: () {
        ref
            .read(learnAnalyticsServiceProvider)
            .logPrimaryCardOpened(
              cardId: 'kids_starter_hero',
              sourceSurface: sourceSurface,
              domain: 'kids',
              audience: LearnAnalyticsAudience.kids,
            );
        context.pushNamed(
          'learnGuidedPathDetail',
          pathParameters: {'pathId': _pathId},
        );
      },
    );
  }
}

/// Tonight's featured story, one row with its cover. Hidden when the library
/// has no featured pick.
class KidsTonightStoryRow extends ConsumerWidget {
  const KidsTonightStoryRow({super.key, required this.sourceSurface});

  final String sourceSurface;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final story = ref.watch(featuredKidsStoryProvider);
    if (story == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HubListGroup(
          title: l10n.kidsLandingTonightTitle,
          children: [
            CompactListTile(
              leading: ArtLeadingThumb(
                imageAsset: story.coverAssetPath,
                fallbackIcon: AppIcons.stories,
                fallbackColor: Theme.of(context).colorScheme.primary,
              ),
              title: story.title,
              subtitle: story.summary.isEmpty ? null : story.summary,
              onTap: () {
                ref
                    .read(learnAnalyticsServiceProvider)
                    .logPrimaryCardOpened(
                      cardId: 'kids_tonight_story',
                      sourceSurface: sourceSurface,
                      domain: 'stories',
                      audience: LearnAnalyticsAudience.kids,
                    );
                context.pushNamed(
                  'kidsBedtimeStoryDetail',
                  pathParameters: {'storyId': story.id},
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}
