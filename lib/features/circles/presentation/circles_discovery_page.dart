import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/circles_provider.dart';

class CirclesDiscoveryPage extends ConsumerWidget {
  const CirclesDiscoveryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(circlesProvider);
    final notifier = ref.read(circlesProvider.notifier);
    final categories = ref.watch(circleCategoriesProvider);
    final circles = ref.watch(filteredCirclesProvider);
    final recommended = ref.watch(recommendedCirclesProvider);

    return AppPageScaffold(
      headerIcon: Icons.groups_rounded,
      title: l10n.circlesTitle,
      subtitle: l10n.circlesSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.circlesJoinedCount(state.joinedIds.length)),
              const SizedBox(height: 4),
              Text(
                l10n.circlesV2HubSubtitle,
                style: const TextStyle(
                  color: Color(0xFF6A5A4A),
                  fontSize: 12.5,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () => context.pushNamed('circlesJoined'),
                      child: Text(l10n.circlesJoinedPageTitle),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonal(
                    onPressed: () => context.pushNamed('circlesEventsCalendar'),
                    child: Text(l10n.circlesEventsCalendarTitle),
                  ),
                  FilledButton.tonal(
                    onPressed: () => context.pushNamed('mosqueBuddyPrefs'),
                    child: Text(l10n.circlesMosqueBuddyPrefsTitle),
                  ),
                  FilledButton.tonal(
                    onPressed: () => context.pushNamed('communityModeration'),
                    child: Text(l10n.circlesModerationTitle),
                  ),
                  FilledButton.tonal(
                    onPressed: () => context.pushNamed('accountabilityGroups'),
                    child: Text(l10n.circlesAccountabilityTitle),
                  ),
                  FilledButton.tonal(
                    onPressed: () => context.pushNamed('nearbyMosques'),
                    child: Text(l10n.circlesNearbyMosquesTitle),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories
                .map(
                  (item) => ChoiceChip(
                    label: Text(item),
                    selected: state.selectedCategory == item,
                    onSelected: (_) => notifier.selectCategory(item),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 12),
        if (recommended.isNotEmpty)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.circlesRecommendedTitle,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...recommended.map(
                  (circle) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(circle.title),
                      subtitle: Text(
                        '${circle.description}\n${circle.city} • ${circle.focus}',
                      ),
                      isThreeLine: true,
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.pushNamed(
                        'circleDetail',
                        pathParameters: {'circleId': circle.id},
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (recommended.isNotEmpty) const SizedBox(height: 12),
        if (circles.isEmpty)
          PremiumCard(child: Text(l10n.circlesNotFound))
        else
          ...circles.map(
            (circle) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(circle.title),
                  subtitle: Text(
                    '${circle.description}\n${circle.city} • ${circle.focus}',
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed(
                    'circleDetail',
                    pathParameters: {'circleId': circle.id},
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
