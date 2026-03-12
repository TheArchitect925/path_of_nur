import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../../shared/widgets/premium_card.dart';
import '../application/baby_names_controller.dart';
import '../data/baby_names_repository.dart';
import '../domain/baby_name_models.dart';

class BabyNamesHomePage extends ConsumerStatefulWidget {
  const BabyNamesHomePage({super.key});

  @override
  ConsumerState<BabyNamesHomePage> createState() => _BabyNamesHomePageState();
}

class _BabyNamesHomePageState extends ConsumerState<BabyNamesHomePage> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final namesAsync = ref.watch(babyNamesEntriesProvider);
    final collectionsAsync = ref.watch(babyNamesCollectionsProvider);
    final state = ref.watch(babyNamesControllerProvider);
    final favorites = ref.watch(babyNamesFavoritesProvider);
    final recentlyViewed = ref.watch(babyNamesRecentlyViewedProvider);
    final nameOfDay = ref.watch(babyNamesNameOfDayProvider);
    final notifier = ref.read(babyNamesControllerProvider.notifier);

    return AppPageScaffold(
      headerIcon: Icons.child_care_rounded,
      title: 'Baby Names',
      subtitle:
          'Discover meaningful Muslim names through themes, origins, and Quranic associations.',
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchCtrl,
                onChanged: notifier.setSearchQuery,
                onSubmitted: (value) {
                  notifier.submitSearch(value);
                  context.pushNamed('babyNamesBrowse');
                },
                decoration: InputDecoration(
                  isDense: true,
                  hintText:
                      'Search name, Arabic spelling, transliteration, meaning, or theme',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: state.searchQuery.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            _searchCtrl.clear();
                            notifier.clearSearch();
                          },
                        ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _QuickChip(
                    label: 'Boys',
                    onTap: () {
                      notifier.setFilters(
                        state.filters.copyWith(gender: BabyNameGender.male),
                      );
                      context.pushNamed('babyNamesBrowse');
                    },
                  ),
                  _QuickChip(
                    label: 'Girls',
                    onTap: () {
                      notifier.setFilters(
                        state.filters.copyWith(gender: BabyNameGender.female),
                      );
                      context.pushNamed('babyNamesBrowse');
                    },
                  ),
                  _QuickChip(
                    label: 'Unisex',
                    onTap: () {
                      notifier.setFilters(
                        state.filters.copyWith(gender: BabyNameGender.unisex),
                      );
                      context.pushNamed('babyNamesBrowse');
                    },
                  ),
                  _QuickChip(
                    label: 'Quranic',
                    onTap: () {
                      notifier.setFilters(
                        state.filters.copyWith(quranicOnly: true),
                      );
                      context.pushNamed('babyNamesBrowse');
                    },
                  ),
                  _QuickChip(
                    label: 'Prophets',
                    onTap: () {
                      notifier.setFilters(
                        state.filters.copyWith(
                          category: BabyNameCategory.prophet,
                        ),
                      );
                      context.pushNamed('babyNamesBrowse');
                    },
                  ),
                  _QuickChip(
                    label: 'Companions',
                    onTap: () {
                      notifier.setFilters(
                        state.filters.copyWith(
                          category: BabyNameCategory.companions,
                        ),
                      );
                      context.pushNamed('babyNamesBrowse');
                    },
                  ),
                  _QuickChip(
                    label: 'Popular',
                    onTap: () {
                      notifier.setFilters(
                        state.filters.copyWith(
                          category: BabyNameCategory.popular,
                        ),
                      );
                      context.pushNamed('babyNamesBrowse');
                    },
                  ),
                  _QuickChip(
                    label: 'By Meaning',
                    onTap: () => context.pushNamed('babyNamesMeaningExplorer'),
                  ),
                  _QuickChip(
                    label: 'By Origin',
                    onTap: () => context.pushNamed('babyNamesBrowse'),
                  ),
                  _QuickChip(
                    label: 'Favorites',
                    onTap: () => context.pushNamed('babyNamesFavorites'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (nameOfDay != null)
          PremiumCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Today\'s highlighted name',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                '${nameOfDay.name} • ${nameOfDay.arabic}\n${nameOfDay.meaning}',
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.pushNamed(
                'babyNameDetail',
                pathParameters: {'nameId': nameOfDay.id},
              ),
            ),
          ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _ActionTile(
                title: 'Favorites',
                subtitle: '${favorites.length} saved names',
                icon: Icons.favorite_outline_rounded,
                onTap: () => context.pushNamed('babyNamesFavorites'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ActionTile(
                title: 'Parent Tool',
                subtitle: 'Get ranked suggestions',
                icon: Icons.auto_awesome_rounded,
                onTap: () => context.pushNamed('babyNamesFinder'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _ActionTile(
                title: 'Meaning Explorer',
                subtitle: 'Browse by themes like light and mercy',
                icon: Icons.auto_awesome_mosaic_rounded,
                onTap: () => context.pushNamed('babyNamesMeaningExplorer'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ActionTile(
                title: 'Name Generator',
                subtitle: 'Generate 1–3 suggestions',
                icon: Icons.casino_outlined,
                onTap: () => context.pushNamed('babyNamesGenerator'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        collectionsAsync.when(
          data: (collections) {
            final index = ref.watch(babyNamesIndexProvider).value;
            return Column(
              children: collections
                  .map(
                    (collection) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: PremiumCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                collection.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Text(collection.subtitle),
                              trailing: const Icon(Icons.chevron_right_rounded),
                              onTap: () => context.pushNamed(
                                'babyNamesBrowse',
                                queryParameters: {'collection': collection.id},
                              ),
                            ),
                            if (index != null)
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: collection.nameIds
                                    .take(5)
                                    .map((id) => index.byId[id])
                                    .whereType<BabyNameEntry>()
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
                              ),
                            const SizedBox(height: 2),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => context.pushNamed(
                                  'babyNamesBrowse',
                                  queryParameters: {
                                    'collection': collection.id,
                                  },
                                ),
                                child: const Text('See all'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
          loading: () => const _LoadingBlock(),
          error: (error, _) => PremiumCard(
            child: Text('Unable to load featured collections right now.'),
          ),
        ),
        const SizedBox(height: 2),
        if (state.recentSearches.isNotEmpty)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Recent searches',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: notifier.clearRecents,
                      child: const Text('Clear'),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: state.recentSearches
                      .map(
                        (query) => ActionChip(
                          label: Text(query),
                          onPressed: () {
                            _searchCtrl.text = query;
                            notifier.setSearchQuery(query);
                            context.pushNamed('babyNamesBrowse');
                          },
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        if (state.recentSearches.isEmpty)
          const PremiumCard(
            child: Text(
              'No recent searches yet. Search by meaning, origin, or a specific name.',
            ),
          ),
        if (recentlyViewed.isNotEmpty) ...[
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
                ...recentlyViewed
                    .take(6)
                    .map(
                      (entry) => ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text('${entry.name} • ${entry.arabic}'),
                        subtitle: Text(entry.meaning),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => context.pushNamed(
                          'babyNameDetail',
                          pathParameters: {'nameId': entry.id},
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ],
        if (recentlyViewed.isEmpty) ...[
          const SizedBox(height: 10),
          const PremiumCard(
            child: Text(
              'No recently viewed names yet. Open any name to build your recent activity.',
            ),
          ),
        ],
        const SizedBox(height: 4),
        namesAsync.when(
          data: (all) => PremiumCard(
            child: Text(
              '${all.length} names available offline',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(label: Text(label), onPressed: onTap);
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Color(0xFF6B604E))),
          ],
        ),
      ),
    );
  }
}

class _LoadingBlock extends StatelessWidget {
  const _LoadingBlock();

  @override
  Widget build(BuildContext context) {
    return const PremiumCard(
      child: SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
    );
  }
}
