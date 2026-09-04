import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../../shared/widgets/premium_card.dart';
import '../data/baby_names_repository.dart';
import '../domain/baby_name_models.dart';
import '../../../../../core/theme/app_icons.dart';

class BabyNamesMeaningExplorerPage extends ConsumerWidget {
  const BabyNamesMeaningExplorerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexAsync = ref.watch(babyNamesIndexProvider);

    return AppPageScaffold(
      title: 'Meaning Explorer',
      subtitle: 'Browse names by spiritual and character themes',
      children: [
        indexAsync.when(
          data: (index) {
            final themes = _themeDefinitions;
            return Column(
              children: themes.map((theme) {
                final ids = index.byMeaningTheme[theme.id] ?? const <String>{};
                final names =
                    ids
                        .map((id) => index.byId[id])
                        .whereType<BabyNameEntry>()
                        .toList()
                      ..sort(
                        (a, b) =>
                            b.popularityScore.compareTo(a.popularityScore),
                      );
                final preview = names.take(6).toList();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: PremiumCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(theme.icon, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                theme.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Text('${names.length}'),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(theme.description),
                        const SizedBox(height: 8),
                        if (preview.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: preview
                                .map(
                                  (entry) => ActionChip(
                                    label: Text(entry.name),
                                    onPressed: () => context.pushNamed(
                                      'babyNameDetail',
                                      pathParameters: {'nameId': entry.id},
                                    ),
                                  ),
                                )
                                .toList(),
                          )
                        else
                          const Text(
                            'No names currently indexed for this theme.',
                          ),
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => context.pushNamed(
                              'babyNamesBrowse',
                              queryParameters: {'theme': theme.id},
                            ),
                            child: const Text('View all names'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const PremiumCard(
            child: SizedBox(
              height: 110,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          ),
          error: (_, _) => const PremiumCard(
            child: Text('Unable to load meaning explorer right now.'),
          ),
        ),
      ],
    );
  }
}

class _ThemeDefinition {
  const _ThemeDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
}

const _themeDefinitions = <_ThemeDefinition>[
  _ThemeDefinition(
    id: 'light',
    title: 'Light',
    description: 'Names associated with illumination, guidance, and radiance.',
    icon: Icons.light_mode_rounded,
  ),
  _ThemeDefinition(
    id: 'mercy',
    title: 'Mercy',
    description: 'Names carrying compassion, gentleness, and care.',
    icon: Icons.favorite_outline_rounded,
  ),
  _ThemeDefinition(
    id: 'faith',
    title: 'Faith',
    description: 'Names connected to belief, devotion, and sincerity.',
    icon: AppIcons.mosque,
  ),
  _ThemeDefinition(
    id: 'guidance',
    title: 'Guidance',
    description: 'Names reflecting direction, clarity, and right path.',
    icon: Icons.explore_rounded,
  ),
  _ThemeDefinition(
    id: 'wisdom',
    title: 'Wisdom',
    description: 'Names linked to insight, understanding, and sound judgment.',
    icon: Icons.auto_stories_rounded,
  ),
  _ThemeDefinition(
    id: 'patience',
    title: 'Patience',
    description: 'Names representing endurance, steadiness, and restraint.',
    icon: Icons.hourglass_bottom_rounded,
  ),
  _ThemeDefinition(
    id: 'strength',
    title: 'Strength',
    description: 'Names associated with courage, resolve, and dignity.',
    icon: Icons.shield_rounded,
  ),
  _ThemeDefinition(
    id: 'beauty',
    title: 'Beauty',
    description: 'Names reflecting grace, elegance, and goodness.',
    icon: AppIcons.reflection,
  ),
  _ThemeDefinition(
    id: 'purity',
    title: 'Purity',
    description: 'Names tied to inner cleanliness and upright character.',
    icon: Icons.water_drop_rounded,
  ),
  _ThemeDefinition(
    id: 'hope',
    title: 'Hope',
    description: 'Names expressing optimism, glad tidings, and renewal.',
    icon: Icons.wb_twilight_rounded,
  ),
  _ThemeDefinition(
    id: 'gratitude',
    title: 'Gratitude',
    description: 'Names connected to praise, thanks, and appreciation.',
    icon: Icons.volunteer_activism_rounded,
  ),
  _ThemeDefinition(
    id: 'peace',
    title: 'Peace',
    description: 'Names carrying calm, safety, and wholeness.',
    icon: AppIcons.reflection,
  ),
  _ThemeDefinition(
    id: 'generosity',
    title: 'Generosity',
    description:
        'Names associated with giving, kindness, and open-heartedness.',
    icon: Icons.card_giftcard_rounded,
  ),
  _ThemeDefinition(
    id: 'nobility',
    title: 'Nobility',
    description: 'Names linked with honor, dignity, and elevated character.',
    icon: Icons.workspace_premium_rounded,
  ),
  _ThemeDefinition(
    id: 'joy',
    title: 'Joy',
    description: 'Names reflecting happiness, delight, and positive spirit.',
    icon: Icons.sentiment_satisfied_alt_rounded,
  ),
  _ThemeDefinition(
    id: 'protection',
    title: 'Protection',
    description: 'Names associated with safety, care, and guardianship.',
    icon: Icons.health_and_safety_rounded,
  ),
  _ThemeDefinition(
    id: 'blessing',
    title: 'Blessing',
    description: 'Names connected to increase, barakah, and goodness.',
    icon: Icons.auto_awesome_rounded,
  ),
  _ThemeDefinition(
    id: 'knowledge',
    title: 'Knowledge',
    description: 'Names connected with learning, understanding, and clarity.',
    icon: Icons.menu_book_rounded,
  ),
  _ThemeDefinition(
    id: 'devotion',
    title: 'Devotion',
    description: 'Names that reflect worship, commitment, and sincerity.',
    icon: Icons.nightlight_rounded,
  ),
  _ThemeDefinition(
    id: 'kindness',
    title: 'Kindness',
    description: 'Names associated with gentleness, warmth, and care.',
    icon: Icons.front_hand_rounded,
  ),
];
