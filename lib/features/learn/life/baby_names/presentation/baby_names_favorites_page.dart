import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../../shared/widgets/premium_card.dart';
import '../application/baby_names_controller.dart';

enum _FavoritesSort { alphabetical, quranicFirst, recentlyViewed }

class BabyNamesFavoritesPage extends ConsumerStatefulWidget {
  const BabyNamesFavoritesPage({super.key});

  @override
  ConsumerState<BabyNamesFavoritesPage> createState() =>
      _BabyNamesFavoritesPageState();
}

class _BabyNamesFavoritesPageState
    extends ConsumerState<BabyNamesFavoritesPage> {
  _FavoritesSort _sort = _FavoritesSort.alphabetical;

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(babyNamesFavoritesProvider);
    final recent = ref.watch(babyNamesRecentlyViewedProvider);
    final searches = ref.watch(babyNamesControllerProvider).recentSearches;
    final controller = ref.read(babyNamesControllerProvider.notifier);

    final sortedFavorites = [...favorites];
    switch (_sort) {
      case _FavoritesSort.alphabetical:
        sortedFavorites.sort((a, b) => a.name.compareTo(b.name));
        break;
      case _FavoritesSort.quranicFirst:
        sortedFavorites.sort((a, b) {
          if (a.isQuranic != b.isQuranic) return a.isQuranic ? -1 : 1;
          return a.name.compareTo(b.name);
        });
        break;
      case _FavoritesSort.recentlyViewed:
        final order = {for (var i = 0; i < recent.length; i++) recent[i].id: i};
        sortedFavorites.sort((a, b) {
          final ai = order[a.id] ?? 9999;
          final bi = order[b.id] ?? 9999;
          if (ai != bi) return ai.compareTo(bi);
          return a.name.compareTo(b.name);
        });
        break;
    }

    return AppPageScaffold(
      headerIcon: Icons.favorite_outline_rounded,
      title: 'Saved Names',
      subtitle: 'Your personal shortlist for thoughtful comparison',
      children: [
        PremiumCard(
          child: Row(
            children: [
              Text(
                '${favorites.length} saved',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              TextButton(
                onPressed: controller.clearRecents,
                child: const Text('Clear activity'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: DropdownButtonFormField<_FavoritesSort>(
            initialValue: _sort,
            isDense: true,
            decoration: const InputDecoration(
              labelText: 'Sort shortlist',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: _FavoritesSort.alphabetical,
                child: Text('Alphabetical'),
              ),
              DropdownMenuItem(
                value: _FavoritesSort.quranicFirst,
                child: Text('Quranic first'),
              ),
              DropdownMenuItem(
                value: _FavoritesSort.recentlyViewed,
                child: Text('Recently viewed first'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => _sort = value);
              }
            },
          ),
        ),
        const SizedBox(height: 10),
        if (sortedFavorites.isEmpty)
          const PremiumCard(
            child: Text(
              'You have not saved any names yet. Favorite names from browse or detail pages to build your shortlist.',
            ),
          ),
        if (sortedFavorites.isNotEmpty)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Shortlist',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...sortedFavorites.map(
                  (name) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('${name.name} • ${name.arabic}'),
                    subtitle: Text(
                      '${name.meaning}${name.isQuranic ? ' • Quranic' : ''}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite),
                      onPressed: () => controller.toggleFavorite(name.id),
                    ),
                    onTap: () => context.pushNamed(
                      'babyNameDetail',
                      pathParameters: {'nameId': name.id},
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (sortedFavorites.length >= 2) ...[
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick comparison',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                ...sortedFavorites
                    .take(3)
                    .map(
                      (name) => Text(
                        '• ${name.name}: ${name.meaning} | ${name.origin.join('/')} | ${name.isQuranic ? 'Quranic' : 'Not marked Quranic'}',
                      ),
                    ),
              ],
            ),
          ),
        ],
        if (recent.isNotEmpty) ...[
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recently viewed',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...recent
                    .take(8)
                    .map(
                      (name) => ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text('${name.name} • ${name.arabic}'),
                        subtitle: Text(name.meaning),
                        onTap: () => context.pushNamed(
                          'babyNameDetail',
                          pathParameters: {'nameId': name.id},
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ] else ...[
          const SizedBox(height: 10),
          const PremiumCard(
            child: Text(
              'No recently viewed names yet. Open a name detail to see it here.',
            ),
          ),
        ],
        if (searches.isNotEmpty) ...[
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent searches',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: searches
                      .map(
                        (query) => ActionChip(
                          label: Text(query),
                          onPressed: () {
                            controller.setSearchQuery(query);
                            context.pushNamed('babyNamesBrowse');
                          },
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ] else ...[
          const SizedBox(height: 10),
          const PremiumCard(
            child: Text(
              'No recent searches yet. Search by meaning, origin, or a specific name.',
            ),
          ),
        ],
      ],
    );
  }
}
