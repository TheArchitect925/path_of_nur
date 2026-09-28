// FREE ACCESS: no path-gating — all content accessible ✓
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/display/compact_list_tile.dart';
import '../../../../shared/widgets/display/hub_list_group.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../creation_challenges/application/creation_challenge_services.dart';
import '../../../creation_challenges/domain/creation_challenge_models.dart';
import '../application/world_creation_provider.dart';
import '../data/world_creation_data.dart';
import '../domain/world_creation_models.dart';
import 'widgets/world_creation_cards.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_icons.dart';

/// The landing's four destinations. [id] is what appears in the route, so
/// these values are part of the URL contract and must not be renamed freely.
enum _WorldHubSection {
  lessons('lessons'),
  explore('explore'),
  reflection('reflection'),
  scientists('scientists');

  const _WorldHubSection(this.id);

  final String id;

  static _WorldHubSection? fromId(String? id) {
    for (final section in values) {
      if (section.id == id) return section;
    }
    return null;
  }
}

class WorldLandingPage extends ConsumerStatefulWidget {
  const WorldLandingPage({super.key, this.section});

  /// When null the page is the hub — a list of its four destinations. When set
  /// it renders that one destination, so each is a real place you can link to
  /// and come back from, rather than a tab you have to re-find.
  final String? section;

  @override
  ConsumerState<WorldLandingPage> createState() => _WorldLandingPageState();
}

class _WorldLandingPageState extends ConsumerState<WorldLandingPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categories = ref.watch(worldCreationCategoriesProvider);
    final recentLessons = ref.watch(worldCreationRecentLessonsProvider);
    final progress = ref.watch(worldCreationProgressProvider);
    final dailySign = ref.watch(worldDailySignProvider);
    final scientists = ref.watch(worldCreationScientistsProvider);
    final challengeSummaries = ref.watch(currentCreationChallengesProvider);
    final dailyChallenge = challengeSummaries.firstWhere(
      (item) => item.slot == ChallengeSlot.daily,
    );

    final section = _WorldHubSection.fromId(widget.section);

    return AppPageScaffold(
      headerIcon: AppIcons.world,
      title: section == null
          ? l10n.worldLandingTitle
          : _sectionLabel(l10n, section),
      subtitle: l10n.worldLandingSubtitle,
      children: [
        PremiumCard(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _metricPill(
                l10n.worldLessonsTitle,
                '${worldCreationLessons.length}',
              ),
              _metricPill(
                l10n.worldLandingMetricCompleted,
                '${progress.completedLessonIds.length}',
              ),
              _metricPill(
                l10n.worldLandingMetricSaved,
                '${progress.savedLessonIds.length}',
              ),
              _metricPill(
                l10n.worldLandingMetricObservations,
                '${progress.observations.length}',
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (section == null)
          HubListGroup(
            title: l10n.learnLandingBrowseTitle,
            children: [
              for (final item in _WorldHubSection.values)
                CompactListTile(
                  title: _sectionLabel(l10n, item),
                  leading: HubLeadingIcon(_sectionIcon(item)),
                  onTap: () => context.pushNamed(
                    'learnWorldLanding',
                    queryParameters: {'section': item.id},
                  ),
                ),
            ],
          ),
        if (section == _WorldHubSection.lessons) ...[
          _DailySignCard(sign: dailySign),
          const SizedBox(height: 10),
          if (recentLessons.isNotEmpty)
            HubListGroup(
              title: l10n.worldContinueLearningTitle,
              children: [
                for (final lesson in recentLessons.take(3))
                  CompactListTile(
                    title: lesson.title,
                    subtitle: l10n.quranReferenceViewerReferenceLabel(
                      lesson.quranVerses.first.referenceLabel,
                    ),
                    onTap: () => context.pushNamed(
                      'worldCreationLessonDetail',
                      pathParameters: {'lessonId': lesson.id},
                    ),
                  ),
              ],
            ),
          if (recentLessons.isNotEmpty) const SizedBox(height: 10),
          ...categories.map(
            (category) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: WorldCategoryHeroCard(
                title: category.title,
                description: category.description,
                lessonCount: category.lessonIds.length,
                progress: ref.watch(
                  worldCreationProgressByCategoryProvider(category.id),
                ),
                featuredVerse: category.featuredVerse,
                onTap: () => _openCategory(context, category.id),
              ),
            ),
          ),
        ],
        if (section == _WorldHubSection.explore) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.worldLandingDailyChallengeTitle,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(dailyChallenge.challenge.title),
                const SizedBox(height: 4),
                Text(dailyChallenge.challenge.subtitle),
                const SizedBox(height: 10),
                FilledButton.tonalIcon(
                  onPressed: () => context.pushNamed('creationChallenges'),
                  icon: Icon(
                    dailyChallenge.isCompleted
                        ? Icons.check_circle_rounded
                        : Icons.flag_circle_rounded,
                  ),
                  label: Text(
                    dailyChallenge.isCompleted
                        ? l10n.worldLandingViewChallengeHistoryAction
                        : l10n.worldLandingOpenChallengesAction,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.worldLandingExploreCreationTitle,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(l10n.worldLandingExploreCreationSubtitle),
                const SizedBox(height: 10),
                _ExploreActionGrid(
                  actions: [
                    _ExploreActionData(
                      title: l10n.worldLandingExploreCreationAction,
                      icon: Icons.travel_explore_rounded,
                      emphasis: _ExploreActionEmphasis.tonal,
                      onTap: () => context.pushNamed('creationExplorer'),
                    ),
                    _ExploreActionData(
                      title: l10n.creationChallengesPageTitle,
                      icon: Icons.flag_circle_rounded,
                      emphasis: _ExploreActionEmphasis.tonal,
                      onTap: () => context.pushNamed('creationChallenges'),
                    ),
                    _ExploreActionData(
                      title: l10n.worldLandingSkyExplorerAction,
                      icon: Icons.nights_stay_rounded,
                      emphasis: _ExploreActionEmphasis.tonal,
                      onTap: () => context.pushNamed('skyExplorer'),
                    ),
                    _ExploreActionData(
                      title: l10n.worldLandingSignsExplorerAction,
                      icon: Icons.hub_rounded,
                      onTap: () => context.pushNamed('worldSignsExplorer'),
                    ),
                    _ExploreActionData(
                      title: l10n.worldLandingCosmicScaleAction,
                      icon: Icons.straighten_rounded,
                      onTap: () => context.pushNamed('worldCosmicScale'),
                    ),
                    _ExploreActionData(
                      title: l10n.worldLandingDeepOceanAction,
                      icon: Icons.water_rounded,
                      onTap: () => context.pushNamed('worldDeepOcean'),
                    ),
                    _ExploreActionData(
                      title: l10n.worldLandingAtmosphereLayersAction,
                      icon: Icons.layers_rounded,
                      onTap: () => context.pushNamed('worldAtmosphereLayers'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.worldLandingExploreDomainsTitle,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ref
                      .watch(worldCreationExploreDomainsProvider)
                      .map(
                        (domain) => ActionChip(
                          label: Text(domain.$1),
                          onPressed: () {
                            final category = WorldCreationCategoryId.values
                                .firstWhere(
                                  (item) => item.name == domain.$2,
                                  orElse: () =>
                                      WorldCreationCategoryId.reflectionSigns,
                                );
                            _openCategory(context, category);
                          },
                        ),
                      )
                      .toList(growable: false),
                ),
              ],
            ),
          ),
        ],
        if (section == _WorldHubSection.reflection) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.worldLandingReflectionModeTitle,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(l10n.worldLandingReflectionModeSubtitle),
                const SizedBox(height: 10),
                FilledButton.tonalIcon(
                  onPressed: () =>
                      context.pushNamed('worldCreationReflectionMode'),
                  icon: const Icon(AppIcons.reflection),
                  label: Text(l10n.worldLandingStartReflectionModeAction),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ...worldCreationLessons
              .where((l) => l.featured)
              .take(6)
              .map(
                (lesson) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ReflectionCard(text: lesson.reflection),
                ),
              ),
        ],
        if (section == _WorldHubSection.scientists) ...[
          CompactListTile(
            title: l10n.worldLandingMuslimScientistsTitle,
            subtitle: l10n.worldLandingMuslimScientistsSubtitle,
            onTap: () => context.pushNamed('worldMuslimScientists'),
          ),
          const SizedBox(height: 10),
          ...scientists
              .take(4)
              .map(
                (profile) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CompactListTile(
                    title: profile.name,
                    subtitle: '${profile.discipline} • ${profile.era}',
                    onTap: () => context.pushNamed('worldMuslimScientists'),
                  ),
                ),
              ),
        ],
      ],
    );
  }

  Widget _metricPill(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: context.palette.caution),
      ),
      child: Text('$label: $value'),
    );
  }

  void _openCategory(BuildContext context, WorldCreationCategoryId category) {
    if (category == WorldCreationCategoryId.exploreCreation) {
      context.pushNamed('creationExplorer');
      return;
    }
    if (category == WorldCreationCategoryId.muslimScientists) {
      context.pushNamed('worldMuslimScientists');
      return;
    }
    context.pushNamed(
      'worldCreationCategory',
      pathParameters: {'categoryName': category.name},
    );
  }

  String _sectionLabel(AppLocalizations l10n, _WorldHubSection section) {
    switch (section) {
      case _WorldHubSection.lessons:
        return l10n.worldLessonsTitle;
      case _WorldHubSection.explore:
        return l10n.worldLandingTabExplore;
      case _WorldHubSection.reflection:
        return l10n.worldLandingTabReflection;
      case _WorldHubSection.scientists:
        return l10n.worldLandingTabScientists;
    }
  }

  IconData _sectionIcon(_WorldHubSection section) {
    switch (section) {
      case _WorldHubSection.lessons:
        return Icons.menu_book_rounded;
      case _WorldHubSection.explore:
        return Icons.travel_explore_rounded;
      case _WorldHubSection.reflection:
        return AppIcons.reflection;
      case _WorldHubSection.scientists:
        return Icons.science_rounded;
    }
  }
}

enum _ExploreActionEmphasis { outlined, tonal }

class _ExploreActionData {
  const _ExploreActionData({
    required this.title,
    required this.icon,
    required this.onTap,
    this.emphasis = _ExploreActionEmphasis.outlined,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final _ExploreActionEmphasis emphasis;
}

class _ExploreActionGrid extends StatelessWidget {
  const _ExploreActionGrid({required this.actions});

  final List<_ExploreActionData> actions;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    return LayoutBuilder(
      builder: (context, constraints) {
        final useSingleColumn = constraints.maxWidth < 420 || textScale > 1.1;
        final spacing = useSingleColumn ? 0.0 : 8.0;
        final itemWidth = useSingleColumn
            ? constraints.maxWidth
            : (constraints.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing,
          runSpacing: 8,
          children: actions
              .map(
                (action) => SizedBox(
                  width: itemWidth,
                  child: _ExploreActionCard(action: action),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }
}

class _ExploreActionCard extends StatelessWidget {
  const _ExploreActionCard({required this.action});

  final _ExploreActionData action;

  @override
  Widget build(BuildContext context) {
    final isTonal = action.emphasis == _ExploreActionEmphasis.tonal;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isTonal ? const Color(0xFFF3EEE6) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.palette.border),
          ),
          child: Row(
            children: [
              Icon(action.icon, size: 18, color: const Color(0xFF6A553E)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  action.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailySignCard extends StatelessWidget {
  const _DailySignCard({required this.sign});

  final WorldDailySign sign;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.worldLandingDailySignTitle,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.quranReferenceViewerReferenceLabel(sign.verse.referenceLabel),
          ),
          const SizedBox(height: 6),
          Text(sign.reflection),
          const SizedBox(height: 8),
          Text(l10n.worldLandingObservePromptValue(sign.prompt)),
          const SizedBox(height: 10),
          FilledButton.tonalIcon(
            onPressed: () => context.pushNamed(
              'worldCreationLessonDetail',
              pathParameters: {'lessonId': sign.lessonId},
            ),
            icon: const Icon(Icons.auto_stories_rounded),
            label: Text(l10n.worldLandingOpenLessonAction),
          ),
        ],
      ),
    );
  }
}
