import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    final categories = ref.watch(worldCreationCategoriesProvider);
    final recentLessons = ref.watch(worldCreationRecentLessonsProvider);
    final progress = ref.watch(worldCreationProgressProvider);
    final dailySign = ref.watch(worldDailySignProvider);
    final scientists = ref.watch(worldCreationScientistsProvider);
    final challengeSummaries = ref.watch(currentCreationChallengesProvider);
    final dailyChallenge = challengeSummaries.firstWhere((item) => item.slot == ChallengeSlot.daily);

    return AppPageScaffold(
      headerIcon: Icons.public_rounded,
      title: 'World & Creation',
      subtitle:
          'Explore the signs of Allah in the universe, nature, life, and the world around you.',
      children: [
        SegmentedPillControl<_WorldHubTab>(
          items: _WorldHubTab.values,
          selectedItem: _tab,
          labelBuilder: _tabLabel,
          onChanged: (value) => setState(() => _tab = value),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _metricPill('Lessons', '${worldCreationLessons.length}'),
              _metricPill('Completed', '${progress.completedLessonIds.length}'),
              _metricPill('Saved', '${progress.savedLessonIds.length}'),
              _metricPill('Observations', '${progress.observations.length}'),
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
                  const Text(
                    'Continue Learning',
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
                            'Quran ${lesson.quranVerses.first.referenceLabel}',
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
                const Text(
                  'Daily Creation Challenge',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(dailyChallenge.challenge.title),
                const SizedBox(height: 4),
                Text(dailyChallenge.challenge.subtitle),
                const SizedBox(height: 10),
                FilledButton.tonalIcon(
                  onPressed: () => context.pushNamed('creationChallenges'),
                  icon: Icon(dailyChallenge.isCompleted ? Icons.check_circle_rounded : Icons.flag_circle_rounded),
                  label: Text(dailyChallenge.isCompleted ? 'View challenge history' : 'Open challenges'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Explore Creation',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Move from reading to direct observation with guided prompts, private capture, and reflection.',
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: () =>
                          context.pushNamed('creationExplorer'),
                      icon: const Icon(Icons.travel_explore_rounded),
                      label: const Text('Explore Creation'),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: () => context.pushNamed('creationChallenges'),
                      icon: const Icon(Icons.flag_circle_rounded),
                      label: const Text('Creation Challenges'),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: () => context.pushNamed('skyExplorer'),
                      icon: const Icon(Icons.nights_stay_rounded),
                      label: const Text('Sky Explorer'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => context.pushNamed('worldSignsExplorer'),
                      icon: const Icon(Icons.hub_outlined),
                      label: const Text('Signs Explorer'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => context.pushNamed('worldCosmicScale'),
                      icon: const Icon(Icons.straighten_rounded),
                      label: const Text('Cosmic Scale'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => context.pushNamed('worldDeepOcean'),
                      icon: const Icon(Icons.water_rounded),
                      label: const Text('Deep Ocean'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () =>
                          context.pushNamed('worldAtmosphereLayers'),
                      icon: const Icon(Icons.layers_rounded),
                      label: const Text('Atmosphere Layers'),
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
                const Text(
                  'Explore Domains',
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
                const Text(
                  'Reflection Mode',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const Text(
                  'A quiet reading experience with verse, observation, and reflection, designed for slow contemplative review.',
                ),
                const SizedBox(height: 10),
                FilledButton.tonalIcon(
                  onPressed: () =>
                      context.pushNamed('worldCreationReflectionMode'),
                  icon: const Icon(Icons.self_improvement_rounded),
                  label: const Text('Start Reflection Mode'),
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
              title: const Text(
                'Muslim Scientists',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: const Text(
                'How Quranic curiosity inspired inquiry, observation, and learning.',
              ),
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

  String _tabLabel(_WorldHubTab tab) {
    switch (tab) {
      case _WorldHubTab.lessons:
        return 'Lessons';
      case _WorldHubTab.explore:
        return 'Explore';
      case _WorldHubTab.reflection:
        return 'Reflection';
      case _WorldHubTab.scientists:
        return 'Scientists';
    }
  }
}

class _DailySignCard extends StatelessWidget {
  const _DailySignCard({required this.sign});

  final WorldDailySign sign;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Sign of Creation',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text('Quran ${sign.verse.referenceLabel}'),
          const SizedBox(height: 6),
          Text(sign.reflection),
          const SizedBox(height: 8),
          Text('Observe: ${sign.prompt}'),
          const SizedBox(height: 10),
          FilledButton.tonalIcon(
            onPressed: () => context.pushNamed(
              'worldCreationLessonDetail',
              pathParameters: {'lessonId': sign.lessonId},
            ),
            icon: const Icon(Icons.auto_stories_rounded),
            label: const Text('Open lesson'),
          ),
        ],
      ),
    );
  }
}
