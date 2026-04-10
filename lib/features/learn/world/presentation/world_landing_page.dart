// FREE ACCESS: no path-gating — all content accessible ✓
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/segmented_pill_control.dart';
import '../../../creation_challenges/application/creation_challenge_services.dart';
import '../../../creation_challenges/domain/creation_challenge_models.dart';
import '../application/world_creation_provider.dart';
import '../data/world_creation_data.dart';
import '../domain/world_creation_models.dart';
import 'widgets/world_creation_cards.dart';

enum _WorldHubTab { lessons, explore, reflection, scientists }

class WorldLandingPage extends ConsumerStatefulWidget {
  const WorldLandingPage({super.key});

  @override
  ConsumerState<WorldLandingPage> createState() => _WorldLandingPageState();
}

class _WorldLandingPageState extends ConsumerState<WorldLandingPage> {
  _WorldHubTab _tab = _WorldHubTab.lessons;

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

    return AppPageScaffold(
      headerIcon: Icons.public_rounded,
      title: l10n.worldLandingTitle,
      subtitle: l10n.worldLandingSubtitle,
      children: [
        SegmentedPillControl<_WorldHubTab>(
          items: _WorldHubTab.values,
          selectedItem: _tab,
          labelBuilder: (tab) => _tabLabel(l10n, tab),
          onChanged: (value) => setState(() => _tab = value),
        ),
        const SizedBox(height: 10),
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
        if (_tab == _WorldHubTab.lessons) ...[
          _DailySignCard(sign: dailySign),
          const SizedBox(height: 10),
          if (recentLessons.isNotEmpty)
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.worldContinueLearningTitle,
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  ...recentLessons
                      .take(3)
                      .map(
                        (lesson) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(lesson.title),
                          subtitle: Text(
                            l10n.quranReferenceViewerReferenceLabel(
                              lesson.quranVerses.first.referenceLabel,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => context.pushNamed(
                            'worldCreationLessonDetail',
                            pathParameters: {'lessonId': lesson.id},
                          ),
                        ),
                      ),
                ],
              ),
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
        if (_tab == _WorldHubTab.explore) ...[
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
                      icon: Icons.hub_outlined,
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
        if (_tab == _WorldHubTab.reflection) ...[
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
                  icon: const Icon(Icons.self_improvement_rounded),
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
        if (_tab == _WorldHubTab.scientists) ...[
          PremiumCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                l10n.worldLandingMuslimScientistsTitle,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(l10n.worldLandingMuslimScientistsSubtitle),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.pushNamed('worldMuslimScientists'),
            ),
          ),
          const SizedBox(height: 10),
          ...scientists
              .take(4)
              .map(
                (profile) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: PremiumCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(profile.name),
                      subtitle: Text('${profile.discipline} • ${profile.era}'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => context.pushNamed('worldMuslimScientists'),
                    ),
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
        color: const Color(0xFFFAF3E8),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFCEB07D)),
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

  String _tabLabel(AppLocalizations l10n, _WorldHubTab tab) {
    switch (tab) {
      case _WorldHubTab.lessons:
        return l10n.worldLessonsTitle;
      case _WorldHubTab.explore:
        return l10n.worldLandingTabExplore;
      case _WorldHubTab.reflection:
        return l10n.worldLandingTabReflection;
      case _WorldHubTab.scientists:
        return l10n.worldLandingTabScientists;
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
            border: Border.all(color: const Color(0xFFE3D6C4)),
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
