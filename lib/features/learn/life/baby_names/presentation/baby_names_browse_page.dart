import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../l10n/app_localizations.dart';
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
    AppLocalizations l10n,
    BabyNamesState state,
    BabyNamesController controller,
  ) {
    final chips = <Widget>[];
    void add(String label, VoidCallback onDeleted) {
      chips.add(InputChip(label: Text(label), onDeleted: onDeleted));
    }

    if (state.filters.gender != null) {
      add(
        l10n.babyNamesFilterChipGender(
          _genderLabel(l10n, state.filters.gender!),
        ),
        () => controller.setFilters(state.filters.copyWith(gender: null)),
      );
    }
    if (state.filters.category != null) {
      add(
        l10n.babyNamesFilterChipCategory(
          _categoryLabel(l10n, state.filters.category!),
        ),
        () => controller.setFilters(state.filters.copyWith(category: null)),
      );
    }
    if (state.filters.quranicOnly) {
      add(
        l10n.babyNamesQuranicLabel,
        () => controller.setFilters(state.filters.copyWith(quranicOnly: false)),
      );
    }
    if (state.filters.prophetAssociationOnly) {
      add(
        l10n.babyNamesFilterChipProphetLinked,
        () => controller.setFilters(
          state.filters.copyWith(prophetAssociationOnly: false),
        ),
      );
    }
    if (state.filters.companionAssociationOnly) {
      add(
        l10n.babyNamesFilterChipCompanionLinked,
        () => controller.setFilters(
          state.filters.copyWith(companionAssociationOnly: false),
        ),
      );
    }
    if (state.filters.origin != null) {
      add(
        l10n.babyNamesFilterChipOrigin(state.filters.origin!),
        () => controller.setFilters(state.filters.copyWith(origin: null)),
      );
    }
    if (state.filters.meaningTheme != null) {
      add(
        l10n.babyNamesFilterChipTheme(state.filters.meaningTheme!),
        () => controller.setFilters(state.filters.copyWith(meaningTheme: null)),
      );
    }
    if (state.filters.startingLetter != null) {
      add(
        l10n.babyNamesFilterChipLetter(state.filters.startingLetter!),
        () =>
            controller.setFilters(state.filters.copyWith(startingLetter: null)),
      );
    }
    if (state.filters.favoritesOnly) {
      add(
        l10n.babyNamesFavoritesLabel,
        () =>
            controller.setFilters(state.filters.copyWith(favoritesOnly: false)),
      );
    }
    if (state.filters.featuredOnly) {
      add(
        l10n.babyNamesFeaturedLabel,
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
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(babyNamesControllerProvider.notifier);
    final state = ref.watch(babyNamesControllerProvider);
    final options = ref.watch(babyNamesFilterOptionsProvider);
    final allAsync = ref.watch(babyNamesEntriesProvider);
    final collectionsAsync = ref.watch(babyNamesCollectionsProvider);

    return AppPageScaffold(
      title: l10n.babyNamesBrowseSearchTitle,
      subtitle: l10n.babyNamesBrowseSearchSubtitle,
      children: [
        PremiumCard(
          child: TextField(
            controller: _searchCtrl,
            onChanged: controller.setSearchQuery,
            onSubmitted: controller.submitSearch,
            decoration: InputDecoration(
              isDense: true,
              hintText: l10n.babyNamesSearchHint,
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
              Text(
                l10n.babyNamesFiltersTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: Text(l10n.babyNamesAllLabel),
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
                    label: Text(l10n.babyNamesBoysLabel),
                    selected: state.filters.gender == BabyNameGender.male,
                    onSelected: (_) => controller.setFilters(
                      state.filters.copyWith(gender: BabyNameGender.male),
                    ),
                  ),
                  FilterChip(
                    label: Text(l10n.babyNamesGirlsLabel),
                    selected: state.filters.gender == BabyNameGender.female,
                    onSelected: (_) => controller.setFilters(
                      state.filters.copyWith(gender: BabyNameGender.female),
                    ),
                  ),
                  FilterChip(
                    label: Text(l10n.babyNamesUnisexLabel),
                    selected: state.filters.gender == BabyNameGender.unisex,
                    onSelected: (_) => controller.setFilters(
                      state.filters.copyWith(gender: BabyNameGender.unisex),
                    ),
                  ),
                  FilterChip(
                    label: Text(l10n.babyNamesQuranicLabel),
                    selected: state.filters.quranicOnly,
                    onSelected: (selected) => controller.setFilters(
                      state.filters.copyWith(quranicOnly: selected),
                    ),
                  ),
                  FilterChip(
                    label: Text(l10n.babyNamesProphetAssociationLabel),
                    selected: state.filters.prophetAssociationOnly,
                    onSelected: (selected) => controller.setFilters(
                      state.filters.copyWith(prophetAssociationOnly: selected),
                    ),
                  ),
                  FilterChip(
                    label: Text(l10n.babyNamesCompanionAssociationLabel),
                    selected: state.filters.companionAssociationOnly,
                    onSelected: (selected) => controller.setFilters(
                      state.filters.copyWith(
                        companionAssociationOnly: selected,
                      ),
                    ),
                  ),
                  FilterChip(
                    label: Text(l10n.babyNamesFavoritesLabel),
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
                      label: l10n.babyNamesAllLabel,
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
                      decoration: InputDecoration(
                        labelText: l10n.babyNamesOriginFilterLabel,
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text(l10n.babyNamesAnyOption),
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
                      decoration: InputDecoration(
                        labelText: l10n.babyNamesMeaningThemeLabel,
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text(l10n.babyNamesAnyOption),
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
                      decoration: InputDecoration(
                        labelText: l10n.babyNamesStartsWithLabel,
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text(l10n.babyNamesAnyOption),
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
                      decoration: InputDecoration(
                        labelText: l10n.babyNamesSortLabel,
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: BabyNameSort.alphabeticalAz,
                          child: Text(l10n.babyNamesSortAlphabeticalAz),
                        ),
                        DropdownMenuItem(
                          value: BabyNameSort.alphabeticalZa,
                          child: Text(l10n.babyNamesSortAlphabeticalZa),
                        ),
                        DropdownMenuItem(
                          value: BabyNameSort.mostPopular,
                          child: Text(l10n.babyNamesSortMostPopular),
                        ),
                        DropdownMenuItem(
                          value: BabyNameSort.classicFirst,
                          child: Text(l10n.babyNamesSortClassicFirst),
                        ),
                        DropdownMenuItem(
                          value: BabyNameSort.modernFirst,
                          child: Text(l10n.babyNamesSortModernFirst),
                        ),
                        DropdownMenuItem(
                          value: BabyNameSort.shortestFirst,
                          child: Text(l10n.babyNamesSortShortestFirst),
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
                  child: Text(l10n.babyNamesResetFiltersAction),
                ),
              ),
              if (_buildActiveFilterChips(
                l10n,
                state,
                controller,
              ).isNotEmpty) ...[
                const SizedBox(height: 2),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _buildActiveFilterChips(l10n, state, controller),
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
                        '${results.length} ${l10n.babyNamesResultsLabel}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () =>
                            context.pushNamed('babyNamesFavorites'),
                        icon: const Icon(Icons.favorite_outline_rounded),
                        label: Text(l10n.babyNamesFavoritesLabel),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                if (results.isEmpty)
                  PremiumCard(
                    child: Column(
                      children: [
                        Text(l10n.babyNamesNoResults),
                        const SizedBox(height: 6),
                        Text(
                          l10n.babyNamesNoResultsHint,
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
                              child: Text(l10n.babyNamesResetFiltersAction),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () =>
                                  context.pushNamed('babyNamesMeaningExplorer'),
                              child: Text(l10n.babyNamesExploreMeaningsAction),
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
          error: (_, _) => PremiumCard(child: Text(l10n.babyNamesLoadError)),
        ),
      ],
    );
  }
}

String _genderLabel(AppLocalizations l10n, BabyNameGender gender) {
  switch (gender) {
    case BabyNameGender.male:
      return l10n.babyNamesBoysLabel;
    case BabyNameGender.female:
      return l10n.babyNamesGirlsLabel;
    case BabyNameGender.unisex:
      return l10n.babyNamesUnisexLabel;
  }
}

String _categoryLabel(AppLocalizations l10n, BabyNameCategory category) {
  switch (category) {
    case BabyNameCategory.quranic:
      return l10n.babyNamesQuranicLabel;
    case BabyNameCategory.prophet:
      return l10n.babyNamesProphetsLabel;
    case BabyNameCategory.companions:
      return l10n.babyNamesCompanionsLabel;
    case BabyNameCategory.popular:
      return l10n.babyNamesPopularLabel;
    case BabyNameCategory.classic:
      return l10n.babyNamesClassicLabel;
    case BabyNameCategory.modern:
      return l10n.babyNamesModernLabel;
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
