import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/display/progress_bar.dart';
import '../../../../shared/content/learning_quote.dart';
import '../../../../shared/persistence/local_store.dart';
import '../../../../shared/widgets/app_hero_glass_shell.dart';
import '../../../../shared/widgets/display/art_header_card.dart';
import '../../../../shared/widgets/display/compact_list_tile.dart';
import '../../../../shared/widgets/display/hub_list_group.dart';
import '../../../kids/bedtime_stories/application/bedtime_story_repository.dart';
import '../../analytics/application/learn_analytics_service.dart';
import '../../analytics/domain/learn_analytics_models.dart';
import '../../guided_paths/application/guided_learning_paths_provider.dart';
import '../../journey/application/family_learning_provider.dart';
import '../../journey/application/learning_path_provider.dart';
import '../../journey/data/learning_journey_localized_metadata.dart';
import '../../journey/data/learning_path_registry.dart';
import '../../journey/domain/family_learning_models.dart';

import '../../journey/domain/learning_journey_models.dart';
import '../../journey/domain/learning_path_models.dart';
import '../../shared/learn_art_assets.dart';
import '../data/learn_hub_taxonomy.dart';
import '../models/learn_hub_models.dart';
import '../widgets/learn_hub_page_scaffold.dart';

class LearningSectionLandingPage extends ConsumerStatefulWidget {
  const LearningSectionLandingPage({super.key});

  @override
  ConsumerState<LearningSectionLandingPage> createState() =>
      _LearningSectionLandingPageState();
}

class _LearningSectionLandingPageState
    extends ConsumerState<LearningSectionLandingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(learnAnalyticsServiceProvider)
          .logLandingViewed(surface: 'learn_landing');
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final visibilityPolicy = ref.watch(learnHubVisibilityPolicyProvider);

    return LearnHubPageScaffold(
      headerIcon: Icons.school_rounded,
      title: l10n.learnHubTitle,
      subtitle: l10n.learnHubLandingCalmSubtitle,
      quoteHeader: const LearningHubRabbiZidniIlmaHeader(),
      showDefaultQuote: true,
      headerActions: [
        IconButton(
          onPressed: () {
            ref
                .read(learnAnalyticsServiceProvider)
                .logSearchOpened(surface: 'learn_landing');
            context.pushNamed('learnExploreAllKnowledge');
          },
          icon: const Icon(Icons.search_rounded),
          tooltip: l10n.learnHubSearchHint,
        ),
      ],
      children: visibilityPolicy.isChildProfile
          ? _buildKidsChildren(context, l10n)
          : _buildAdultChildren(context, l10n),
    );
  }

  List<Widget> _buildAdultChildren(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return [
      const _PathMigrationCard(),
      const _LearnPathHeroCard(),
      const SizedBox(height: 14),
      const _TodayLearningSection(),
      HubListGroup(
        title: l10n.learnLandingBrowseTitle,
        children: [
          for (final group in _browseGroups)
            _buildGroupRow(context, l10n, group),
          _buildExploreAllRow(context, l10n),
        ],
      ),
    ];
  }

  static const List<_LearnBrowseGroup> _browseGroups = [
    _LearnBrowseGroup(
      categoryId: LearnHubCategoryId.quranHadith,
      artAsset: 'assets/images/learn_art/island_quran.webp',
    ),
    _LearnBrowseGroup(
      categoryId: LearnHubCategoryId.foundations,
      artAsset: 'assets/images/learn_art/island_foundations.webp',
    ),
    _LearnBrowseGroup(
      categoryId: LearnHubCategoryId.worshipPractice,
      artAsset: 'assets/images/learn_art/island_worship.webp',
    ),
    _LearnBrowseGroup(
      categoryId: LearnHubCategoryId.characterAdab,
      artAsset: 'assets/images/learn_art/island_character.webp',
    ),
    _LearnBrowseGroup(
      categoryId: LearnHubCategoryId.prophetsStories,
      artAsset: 'assets/images/learn_art/island_stories.webp',
    ),
    _LearnBrowseGroup(
      categoryId: LearnHubCategoryId.quizzesChallenges,
      artAsset: 'assets/images/learn_art/island_games.webp',
      // The dedicated games hub is richer than the generic category page.
      routeNameOverride: 'learnQuizzesHub',
    ),
  ];

  Widget _buildGroupRow(
    BuildContext context,
    AppLocalizations l10n,
    _LearnBrowseGroup group,
  ) {
    final style = LearnHubTaxonomy.styleFor(group.categoryId);
    final target = LearnHubTaxonomy.categoryRouteTarget(group.categoryId);
    return CompactListTile(
      leading: ArtLeadingThumb(
        imageAsset: group.artAsset,
        fallbackIcon: style.icon,
        fallbackColor: style.accentColor,
      ),
      title: LearnHubTaxonomy.categoryTitle(l10n, group.categoryId),
      subtitle: LearnHubTaxonomy.categorySubtitle(l10n, group.categoryId),
      onTap: () {
        ref
            .read(learnAnalyticsServiceProvider)
            .logPrimaryCardOpened(
              cardId:
                  'group_${LearnHubTaxonomy.categorySlug(group.categoryId)}',
              sourceSurface: 'learn_landing',
              domain: group.categoryId.name,
            );
        if (group.routeNameOverride != null) {
          context.pushNamed(group.routeNameOverride!);
          return;
        }
        context.pushNamed(
          target.routeName,
          pathParameters: target.pathParameters,
          queryParameters: target.queryParameters,
        );
      },
    );
  }

  Widget _buildExploreAllRow(BuildContext context, AppLocalizations l10n) {
    return CompactListTile(
      leading: const HubLeadingIcon(Icons.travel_explore_rounded),
      title: l10n.learnHubLandingExploreAllTitle,
      subtitle: l10n.learnHubLandingExploreAllSubtitle,
      onTap: () {
        ref
            .read(learnAnalyticsServiceProvider)
            .logExploreSectionOpened(
              sectionId: 'landing_explore_all',
              sourceSurface: 'learn_landing',
            );
        context.pushNamed('learnExploreAllKnowledge');
      },
    );
  }

  List<Widget> _buildKidsChildren(BuildContext context, AppLocalizations l10n) {
    return [
      const _KidsStarterPathHero(),
      const SizedBox(height: 14),
      const _KidsTonightStoryRow(),
      HubListGroup(
        title: l10n.kidsLandingExploreTitle,
        children: const [_KidsAdventureGrid()],
      ),
    ];
  }
}

/// The Kids Starter Path as the child-profile hero: its scene art, live step
/// progress, and a tap straight into the guided path.
class _KidsStarterPathHero extends ConsumerWidget {
  const _KidsStarterPathHero();

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
      fallbackIcon: Icons.flag_rounded,
      fallbackColor: Theme.of(context).colorScheme.primary,
      aspectRatio: 16 / 9,
      onTap: () {
        ref
            .read(learnAnalyticsServiceProvider)
            .logPrimaryCardOpened(
              cardId: 'kids_starter_hero',
              sourceSurface: 'learn_landing',
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

/// Tonight's featured bedtime story, one calm row. Hidden when the library
/// has no featured pick.
class _KidsTonightStoryRow extends ConsumerWidget {
  const _KidsTonightStoryRow();

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
                imageAsset: kidsSubcategoryArtAsset('kids-stories')!,
                fallbackIcon: Icons.auto_stories_rounded,
                fallbackColor: Theme.of(context).colorScheme.primary,
              ),
              title: story.title,
              subtitle: story.summary.isEmpty ? null : story.summary,
              onTap: () {
                ref
                    .read(learnAnalyticsServiceProvider)
                    .logPrimaryCardOpened(
                      cardId: 'kids_tonight_story',
                      sourceSurface: 'learn_landing',
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

/// The ten kids destinations as illustrated storybook tiles, two per row —
/// each subcategory wearing its own scene instead of the shared peach chip.
class _KidsAdventureGrid extends ConsumerWidget {
  const _KidsAdventureGrid();

  static const List<String> _tileOrder = [
    'kids-quran',
    'kids-arabic-learning',
    'kids-stories',
    'kids-prophet-stories',
    'kids-dua-learning',
    'kids-hadith',
    'kids-hadith-stories',
    'kids-seerah-journeys',
    'kids-fun-learning',
    'kids-games',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final subcategories = LearnHubTaxonomy.subcategories(l10n)
        .where((item) => item.categoryId == LearnHubCategoryId.kidsLearning)
        .toList(growable: false);
    final byId = {for (final item in subcategories) item.id: item};
    final tiles = _tileOrder
        .map((id) => byId[id])
        .whereType<LearnHubSubcategoryDescriptor>()
        .toList(growable: false);
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 4 / 3,
      children: [
        for (final tile in tiles)
          ArtHeaderCard(
            imageAsset:
                kidsSubcategoryArtAsset(tile.id) ??
                kidsSubcategoryArtAsset('kids-stories')!,
            title: tile.title,
            fallbackIcon: Icons.auto_awesome_rounded,
            fallbackColor: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            onTap: () {
              ref
                  .read(learnAnalyticsServiceProvider)
                  .logPrimaryCardOpened(
                    cardId: 'kids_tile_${tile.id}',
                    sourceSurface: 'learn_landing',
                    domain: 'kids',
                    audience: LearnAnalyticsAudience.kids,
                  );
              context.pushNamed(
                tile.routeTarget.routeName,
                pathParameters: tile.routeTarget.pathParameters,
                queryParameters: tile.routeTarget.queryParameters,
              );
            },
          ),
      ],
    );
  }
}

final learnHubVisibilityPolicyProvider =
    Provider<FamilyLearningVisibilityPolicy>(
      (ref) => ref.watch(
        activeFamilyLearningContextProvider.select(
          (value) => value.visibilityPolicy,
        ),
      ),
    );

class _LearnBrowseGroup {
  const _LearnBrowseGroup({
    required this.categoryId,
    required this.artAsset,
    this.routeNameOverride,
  });

  final LearnHubCategoryId categoryId;
  final String artAsset;
  final String? routeNameOverride;
}

/// One-time "Your path is ready" moment for existing users after the path
/// merge: shows the level their history mapped onto, then never returns.
class _PathMigrationCard extends ConsumerStatefulWidget {
  const _PathMigrationCard();

  @override
  ConsumerState<_PathMigrationCard> createState() => _PathMigrationCardState();
}

class _PathMigrationCardState extends ConsumerState<_PathMigrationCard> {
  static const _seenKey = 'learn.pathMigrationCard.v1';
  bool _dismissed = false;

  void _markSeen() {
    ref.read(localStoreProvider).setBool(_seenKey, true);
    setState(() => _dismissed = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();
    final store = ref.watch(localStoreProvider);
    if (store.getBool(_seenKey) ?? false) return const SizedBox.shrink();
    final pathState = ref.watch(learningPathStateProvider);
    if (pathState == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final levelName = LearningPathRegistry.localizedPathTitle(
      l10n,
      pathState.path,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: AppHeroGlassShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.learnPathMigrationTitle,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(l10n.learnPathMigrationBody(levelName)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _markSeen,
                  child: Text(l10n.learnPathMigrationDismiss),
                ),
                const SizedBox(width: 8),
                FilledButton.tonal(
                  onPressed: () {
                    _markSeen();
                    context.pushNamed('learnPathDetail');
                  },
                  child: Text(l10n.learnPathMigrationAction),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// The leveled learning path as the landing hero: scenic level art, the
/// current phase with its progress, and the next journey to continue. Without
/// a chosen path it becomes the invitation to pick one.
class _LearnPathHeroCard extends ConsumerWidget {
  const _LearnPathHeroCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final pathState = ref.watch(learningPathStateProvider);
    final accent = Theme.of(context).colorScheme.primary;

    void openPathDetail() {
      ref
          .read(learnAnalyticsServiceProvider)
          .logPrimaryCardOpened(
            cardId: 'path_hero',
            sourceSurface: 'learn_landing',
            domain: 'journeys',
            audience: LearnAnalyticsAudience.beginner,
          );
      context.pushNamed('learnPathDetail');
    }

    if (pathState == null) {
      return ArtHeaderCard(
        imageAsset: levelArtAsset(LearningPathLevel.beginner),
        eyebrow: l10n.learnLandingPathEyebrow,
        title: l10n.learnLandingChoosePathTitle,
        subtitle: l10n.learnLandingChoosePathSubtitle,
        fallbackIcon: Icons.flag_rounded,
        fallbackColor: accent,
        aspectRatio: 16 / 9,
        onTap: () {
          ref
              .read(learnAnalyticsServiceProvider)
              .logPrimaryCardOpened(
                cardId: 'path_hero_choose',
                sourceSurface: 'learn_landing',
                domain: 'journeys',
                audience: LearnAnalyticsAudience.beginner,
              );
          context.pushNamed('learnLearningPath');
        },
      );
    }

    final level = pathState.persistedState.selectedLevel;
    final phaseJourneyIds = pathState.currentPhase.journeyIds;
    final completedInPhase = phaseJourneyIds
        .where(pathState.completedJourneyIds.contains)
        .length;
    final phaseProgress = phaseJourneyIds.isEmpty
        ? 0.0
        : completedInPhase / phaseJourneyIds.length;
    final LearningJourney? nextJourney = pathState.activeJourneys.isEmpty
        ? null
        : pathState.activeJourneys.first;

    return AppHeroGlassShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ArtHeaderCard(
            imageAsset: levelArtAsset(level),
            eyebrow: l10n.learnLandingPathEyebrow,
            title: LearningPathRegistry.localizedPathTitle(
              l10n,
              pathState.path,
            ),
            subtitle: LearningPathRegistry.localizedPhaseTitle(
              l10n,
              pathState.currentPhase,
            ),
            fallbackIcon: Icons.flag_rounded,
            fallbackColor: accent,
            aspectRatio: 16 / 9,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            onTap: openPathDetail,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: ProgressBar(value: phaseProgress, height: 6)),
              const SizedBox(width: 10),
              Text(
                l10n.learnLandingPhaseOfLabel(
                  pathState.phaseIndex + 1,
                  pathState.path.phases.length,
                ),
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          if (nextJourney != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.learnLandingNextUpLabel,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        localizedJourneyTitle(context, nextJourney),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton.tonal(
                  onPressed: () {
                    ref
                        .read(learnAnalyticsServiceProvider)
                        .logPrimaryCardOpened(
                          cardId: 'path_hero_continue',
                          sourceSurface: 'learn_landing',
                          domain: 'journeys',
                        );
                    context.pushNamed(
                      'learnJourneyDetail',
                      pathParameters: {'journeyId': nextJourney.id},
                    );
                  },
                  child: Text(l10n.learnLandingContinueAction),
                ),
              ],
            ),
          ],
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: openPathDetail,
              child: Text(l10n.learnLandingViewPathAction),
            ),
          ),
        ],
      ),
    );
  }
}

/// One calm suggestion for today, from the path's adaptive guidance. Hidden
/// when no path is chosen or nothing is recommended.
class _TodayLearningSection extends ConsumerWidget {
  const _TodayLearningSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final guidance = ref.watch(learningPathAdaptiveGuidanceProvider);
    final journey = guidance?.personalizedTodayJourney;
    if (journey == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HubListGroup(
          title: l10n.learnLandingTodayTitle,
          children: [
            CompactListTile(
              leading: const HubLeadingIcon(Icons.wb_sunny_rounded),
              title: localizedJourneyTitle(context, journey),
              subtitle: localizedJourneySubtitle(context, journey),
              onTap: () {
                ref
                    .read(learnAnalyticsServiceProvider)
                    .logPrimaryCardOpened(
                      cardId: 'today_learning',
                      sourceSurface: 'learn_landing',
                      domain: 'journeys',
                    );
                context.pushNamed(
                  'learnJourneyDetail',
                  pathParameters: {'journeyId': journey.id},
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
