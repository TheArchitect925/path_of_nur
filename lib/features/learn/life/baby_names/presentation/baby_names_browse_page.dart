import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../../shared/widgets/premium_card.dart';
import '../application/baby_names_controller.dart';
import '../data/baby_names_repository.dart';
import '../domain/baby_name_models.dart';

class BabyNamesBrowsePage extends ConsumerStatefulWidget {
  const BabyNamesBrowsePage({
    super.key,
    this.collectionId,
    this.meaningTheme,
    this.startingLetter,
  });

  final String? collectionId;
  final String? meaningTheme;
  final String? startingLetter;

  @override
  ConsumerState<BabyNamesBrowsePage> createState() =>
      _BabyNamesBrowsePageState();
}

class _BabyNamesBrowsePageState extends ConsumerState<BabyNamesBrowsePage> {
  final _searchCtrl = TextEditingController();

  List<Widget> _buildActiveFilterChips(
    BabyNamesState state,
    BabyNamesController controller,
  ) {
    final chips = <Widget>[];
    void add(String label, VoidCallback onDeleted) {
      chips.add(InputChip(label: Text(label), onDeleted: onDeleted));
    }

    if (state.filters.gender != null) {
      add(
        'Gender: ${state.filters.gender!.name}',
        () => controller.setFilters(state.filters.copyWith(gender: null)),
      );
    }
    if (state.filters.category != null) {
      add(
        'Category: ${state.filters.category!.name}',
        () => controller.setFilters(state.filters.copyWith(category: null)),
      );
    }
    if (state.filters.quranicOnly) {
      add(
        'Quranic',
        () => controller.setFilters(state.filters.copyWith(quranicOnly: false)),
      );
    }
    if (state.filters.prophetAssociationOnly) {
      add(
        'Prophet linked',
        () => controller.setFilters(
          state.filters.copyWith(prophetAssociationOnly: false),
        ),
      );
    }
    if (state.filters.companionAssociationOnly) {
      add(
        'Companion linked',
        () => controller.setFilters(
          state.filters.copyWith(companionAssociationOnly: false),
        ),
      );
    }
    if (state.filters.origin != null) {
      add(
        'Origin: ${state.filters.origin}',
        () => controller.setFilters(state.filters.copyWith(origin: null)),
      );
    }
    if (state.filters.meaningTheme != null) {
      add(
        'Theme: ${state.filters.meaningTheme}',
        () => controller.setFilters(state.filters.copyWith(meaningTheme: null)),
      );
    }
    if (state.filters.startingLetter != null) {
      add(
        'Letter: ${state.filters.startingLetter}',
        () =>
            controller.setFilters(state.filters.copyWith(startingLetter: null)),
      );
    }
    if (state.filters.favoritesOnly) {
      add(
        'Favorites',
        () =>
            controller.setFilters(state.filters.copyWith(favoritesOnly: false)),
      );
    }
    if (state.filters.featuredOnly) {
      add(
        'Featured',
        () =>
            controller.setFilters(state.filters.copyWith(featuredOnly: false)),
      );
    }
    return chips;
  }

  @override
  void initState() {
    super.initState();
    final controller = ref.read(babyNamesControllerProvider.notifier);
    final existing = ref.read(babyNamesControllerProvider);
    _searchCtrl.text = existing.searchQuery;

    if (widget.meaningTheme != null || widget.startingLetter != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.setFilters(
          existing.filters.copyWith(
            meaningTheme: widget.meaningTheme ?? existing.filters.meaningTheme,
            startingLetter:
                widget.startingLetter ?? existing.filters.startingLetter,
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(babyNamesControllerProvider.notifier);
    final state = ref.watch(babyNamesControllerProvider);
    final options = ref.watch(babyNamesFilterOptionsProvider);
    final allAsync = ref.watch(babyNamesEntriesProvider);
    final collectionsAsync = ref.watch(babyNamesCollectionsProvider);

    return AppPageScaffold(
      headerIcon: Icons.manage_search_rounded,
      title: 'Browse Baby Names',
      subtitle: 'Search and filter across the full offline dataset',
      children: [
        PremiumCard(
          child: TextField(
            controller: _searchCtrl,
            onChanged: controller.setSearchQuery,
            onSubmitted: controller.submitSearch,
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Search by name, Arabic, meaning, theme, or origin',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: state.searchQuery.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _searchCtrl.clear();
                        controller.clearSearch();
                      },
                    ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quick filters',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected:
                        state.filters.gender == null &&
                        state.filters.category == null &&
                        !state.filters.quranicOnly &&
                        !state.filters.prophetAssociationOnly &&
                        !state.filters.companionAssociationOnly &&
                        state.filters.origin == null &&
                        state.filters.meaningTheme == null &&
                        state.filters.startingLetter == null &&
                        !state.filters.favoritesOnly &&
                        !state.filters.featuredOnly,
                    onSelected: (_) => controller.clearFilters(),
                  ),
                  FilterChip(
                    label: const Text('Boys'),
                    selected: state.filters.gender == BabyNameGender.male,
                    onSelected: (_) => controller.setFilters(
                      state.filters.copyWith(gender: BabyNameGender.male),
                    ),
                  ),
                  FilterChip(
                    label: const Text('Girls'),
                    selected: state.filters.gender == BabyNameGender.female,
                    onSelected: (_) => controller.setFilters(
                      state.filters.copyWith(gender: BabyNameGender.female),
                    ),
                  ),
                  FilterChip(
                    label: const Text('Unisex'),
                    selected: state.filters.gender == BabyNameGender.unisex,
                    onSelected: (_) => controller.setFilters(
                      state.filters.copyWith(gender: BabyNameGender.unisex),
                    ),
                  ),
                  FilterChip(
                    label: const Text('Quranic'),
                    selected: state.filters.quranicOnly,
                    onSelected: (selected) => controller.setFilters(
                      state.filters.copyWith(quranicOnly: selected),
                    ),
                  ),
                  FilterChip(
                    label: const Text('Prophet Association'),
                    selected: state.filters.prophetAssociationOnly,
                    onSelected: (selected) => controller.setFilters(
                      state.filters.copyWith(prophetAssociationOnly: selected),
                    ),
                  ),
                  FilterChip(
                    label: const Text('Companion Association'),
                    selected: state.filters.companionAssociationOnly,
                    onSelected: (selected) => controller.setFilters(
                      state.filters.copyWith(
                        companionAssociationOnly: selected,
                      ),
                    ),
                  ),
                  FilterChip(
                    label: const Text('Favorites'),
                    selected: state.filters.favoritesOnly,
                    onSelected: (selected) => controller.setFilters(
                      state.filters.copyWith(favoritesOnly: selected),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _LetterChip(
                      label: 'All',
                      selected: state.filters.startingLetter == null,
                      onTap: () => controller.setFilters(
                        state.filters.copyWith(startingLetter: null),
                      ),
                    ),
                    ...options.startingLetters.map(
                      (letter) => _LetterChip(
                        label: letter,
                        selected: state.filters.startingLetter == letter,
                        onTap: () => controller.setFilters(
                          state.filters.copyWith(startingLetter: letter),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: state.filters.origin,
                      isExpanded: true,
                      isDense: true,
                      decoration: const InputDecoration(
                        labelText: 'Origin',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('Any'),
                        ),
                        ...options.origins.map(
                          (origin) => DropdownMenuItem<String>(
                            value: origin,
                            child: Text(origin),
                          ),
                        ),
                      ],
                      onChanged: (value) => controller.setFilters(
                        state.filters.copyWith(origin: value),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: state.filters.meaningTheme,
                      isExpanded: true,
                      isDense: true,
                      decoration: const InputDecoration(
                        labelText: 'Meaning theme',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('Any'),
                        ),
                        ...options.meaningThemes.map(
                          (theme) => DropdownMenuItem<String>(
                            value: theme,
                            child: Text(theme),
                          ),
                        ),
                      ],
                      onChanged: (value) => controller.setFilters(
                        state.filters.copyWith(meaningTheme: value),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: state.filters.startingLetter,
                      isExpanded: true,
                      isDense: true,
                      decoration: const InputDecoration(
                        labelText: 'Starts with',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('Any'),
                        ),
                        ...options.startingLetters.map(
                          (letter) => DropdownMenuItem<String>(
                            value: letter,
                            child: Text(letter),
                          ),
                        ),
                      ],
                      onChanged: (value) => controller.setFilters(
                        state.filters.copyWith(startingLetter: value),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<BabyNameSort>(
                      initialValue: state.sort,
                      isExpanded: true,
                      isDense: true,
                      decoration: const InputDecoration(
                        labelText: 'Sort',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: BabyNameSort.alphabeticalAz,
                          child: Text('Alphabetical A-Z'),
                        ),
                        DropdownMenuItem(
                          value: BabyNameSort.alphabeticalZa,
                          child: Text('Alphabetical Z-A'),
                        ),
                        DropdownMenuItem(
                          value: BabyNameSort.mostPopular,
                          child: Text('Most popular'),
                        ),
                        DropdownMenuItem(
                          value: BabyNameSort.classicFirst,
                          child: Text('Classic first'),
                        ),
                        DropdownMenuItem(
                          value: BabyNameSort.modernFirst,
                          child: Text('Modern first'),
                        ),
                        DropdownMenuItem(
                          value: BabyNameSort.shortestFirst,
                          child: Text('Shortest first'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) controller.setSort(value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: controller.clearFilters,
                  child: const Text('Reset filters'),
                ),
              ),
              if (_buildActiveFilterChips(state, controller).isNotEmpty) ...[
                const SizedBox(height: 2),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _buildActiveFilterChips(state, controller),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),
        allAsync.when(
          data: (_) {
            var results = ref.watch(babyNamesFilteredProvider);
            final selectedCollectionId = widget.collectionId;

            if (selectedCollectionId != null) {
              final collections =
                  collectionsAsync.value ?? const <BabyNameCollection>[];
              BabyNameCollection? current;
              for (final collection in collections) {
                if (collection.id == selectedCollectionId) {
                  current = collection;
                  break;
                }
              }
              if (current != null) {
                final ids = current.nameIds.toSet();
                results = results
                    .where((item) => ids.contains(item.id))
                    .toList();
              }
            }

            return Column(
              children: [
                PremiumCard(
                  child: Row(
                    children: [
                      Text(
                        '${results.length} names',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () =>
                            context.pushNamed('babyNamesFavorites'),
                        icon: const Icon(Icons.favorite_outline_rounded),
                        label: const Text('Favorites'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                if (results.isEmpty)
                  PremiumCard(
                    child: Column(
                      children: [
                        const Text('No names match these filters.'),
                        const SizedBox(height: 6),
                        const Text(
                          'Try removing a filter or exploring by meaning instead.',
                          style: TextStyle(color: Color(0xFF6B604E)),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                controller.clearSearch();
                                controller.clearFilters();
                                _searchCtrl.clear();
                              },
                              child: const Text('Reset filters'),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () =>
                                  context.pushNamed('babyNamesMeaningExplorer'),
                              child: const Text('Explore meanings'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ...results.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _NameListCard(entry: entry),
                  ),
                ),
              ],
            );
          },
          loading: () => const PremiumCard(
            child: SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          ),
          error: (_, _) => const PremiumCard(
            child: Text('Unable to load names at the moment.'),
          ),
        ),
      ],
    );
  }
}

class _NameListCard extends ConsumerWidget {
  const _NameListCard({required this.entry});

  final BabyNameEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(babyNamesControllerProvider);
    final notifier = ref.read(babyNamesControllerProvider.notifier);
    final isFavorite = state.favorites.contains(entry.id);

    return PremiumCard(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          '${entry.name} • ${entry.arabic}',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          '${entry.transliteration} • ${entry.meaning}\n${entry.meaningThemes.take(3).join(' • ')}',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
          ),
          onPressed: () => notifier.toggleFavorite(entry.id),
        ),
        onTap: () => context.pushNamed(
          'babyNameDetail',
          pathParameters: {'nameId': entry.id},
        ),
      ),
    );
  }
}

class _LetterChip extends StatelessWidget {
  const _LetterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}
