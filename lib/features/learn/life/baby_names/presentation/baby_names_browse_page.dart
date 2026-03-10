import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../../shared/widgets/premium_card.dart';
import '../application/baby_names_controller.dart';
import '../domain/baby_name_models.dart';

class BabyNamesBrowsePage extends ConsumerStatefulWidget {
  const BabyNamesBrowsePage({
    super.key,
    this.collectionId,
  });

  final String? collectionId;

  @override
  ConsumerState<BabyNamesBrowsePage> createState() => _BabyNamesBrowsePageState();
}

class _BabyNamesBrowsePageState extends ConsumerState<BabyNamesBrowsePage> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = ref.read(babyNamesControllerProvider);
    _searchCtrl.text = state.searchQuery;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(babyNamesControllerProvider);
    final controller = ref.read(babyNamesControllerProvider.notifier);
    final options = ref.watch(babyNamesFilterOptionsProvider);
    final collections = ref.watch(babyNamesCollectionsProvider);
    var results = ref.watch(babyNamesFilteredProvider);
    final collection = widget.collectionId == null
        ? null
        : collections.where((c) => c.id == widget.collectionId).firstOrNull;
    if (collection != null) {
      final ids = collection.nameIds.toSet();
      results = results.where((r) => ids.contains(r.id)).toList();
    }

    return AppPageScaffold(
      headerIcon: Icons.manage_search_rounded,
      title: l10n.babyNamesBrowseSearchTitle,
      subtitle: collection?.title ?? l10n.babyNamesBrowseSearchSubtitle,
      children: [
        PremiumCard(
          child: TextField(
            controller: _searchCtrl,
            onChanged: controller.setSearchQuery,
            decoration: InputDecoration(
              isDense: true,
              border: const OutlineInputBorder(),
              hintText: l10n.babyNamesSearchHint,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: state.searchQuery.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _searchCtrl.clear();
                        controller.setSearchQuery('');
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
              Text(l10n.babyNamesFiltersTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _FilterChip(
                    label: l10n.babyNamesGenderAny,
                    selected: state.filters.gender == null,
                    onTap: () => controller.setGender(null),
                  ),
                  _FilterChip(
                    label: l10n.babyNamesBoysLabel,
                    selected: state.filters.gender == BabyNameGender.boy,
                    onTap: () => controller.setGender(BabyNameGender.boy),
                  ),
                  _FilterChip(
                    label: l10n.babyNamesGirlsLabel,
                    selected: state.filters.gender == BabyNameGender.girl,
                    onTap: () => controller.setGender(BabyNameGender.girl),
                  ),
                  _FilterChip(
                    label: l10n.babyNamesUnisexLabel,
                    selected: state.filters.gender == BabyNameGender.unisex,
                    onTap: () => controller.setGender(BabyNameGender.unisex),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: state.filters.region,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        isDense: true,
                        labelText: l10n.babyNamesRegionFilterLabel,
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text(l10n.babyNamesAnyOption),
                        ),
                        ...options.regions.map(
                          (region) => DropdownMenuItem<String>(
                            value: region,
                            child: Text(region),
                          ),
                        ),
                      ],
                      onChanged: controller.setRegion,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: state.filters.origin,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        isDense: true,
                        labelText: l10n.babyNamesOriginFilterLabel,
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
                      onChanged: controller.setOrigin,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: state.filters.onlyQuranic,
                      title: Text(l10n.babyNamesQuranicOnlyLabel),
                      onChanged: (v) => controller.toggleOnlyQuranic(v == true),
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: state.filters.onlyCompanion,
                      title: Text(l10n.babyNamesCompanionOnlyLabel),
                      onChanged: (v) => controller.toggleOnlyCompanion(v == true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: options.meaningTags
                    .take(12)
                    .map(
                      (tag) => FilterChip(
                        label: Text(tag),
                        selected: state.filters.meaningTags.contains(tag),
                        onSelected: (_) => controller.toggleMeaningTag(tag),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<BabyNameSort>(
                      initialValue: state.sort,
                      isDense: true,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: l10n.babyNamesSortLabel,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: BabyNameSort.alphabetical,
                          child: Text(l10n.babyNamesSortAlphabetical),
                        ),
                        DropdownMenuItem(
                          value: BabyNameSort.popularity,
                          child: Text(l10n.babyNamesSortPopularity),
                        ),
                        DropdownMenuItem(
                          value: BabyNameSort.quranicPriority,
                          child: Text(l10n.babyNamesSortQuranicPriority),
                        ),
                        DropdownMenuItem(
                          value: BabyNameSort.shortest,
                          child: Text(l10n.babyNamesSortShortest),
                        ),
                        DropdownMenuItem(
                          value: BabyNameSort.mostSaved,
                          child: Text(l10n.babyNamesSortMostSaved),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) controller.setSort(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: controller.clearFilters,
                    child: Text(l10n.babyNamesClearFilters),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Row(
            children: [
              Text(
                '${results.length} ${l10n.babyNamesResultsLabel}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => context.pushNamed('babyNamesCompare'),
                icon: const Icon(Icons.compare_arrows_rounded),
                label: Text(l10n.babyNamesCompareTitle),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (results.isEmpty)
          PremiumCard(
            child: Text(l10n.babyNamesNoResults),
          ),
        ...results.map(
          (name) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _NameResultCard(name: name),
          ),
        ),
      ],
    );
  }
}

class _NameResultCard extends ConsumerWidget {
  const _NameResultCard({required this.name});

  final BabyNameRecord name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(babyNamesControllerProvider);
    final notifier = ref.read(babyNamesControllerProvider.notifier);
    final isFav = state.favorites.contains(name.id);
    final isShort = state.shortlist.contains(name.id);
    final isComp = state.compareIds.contains(name.id);

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(name.english, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text('${name.transliteration}\n${name.meaning}'),
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(name.arabic, style: const TextStyle(fontSize: 20)),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushNamed(
              'babyNameDetail',
              pathParameters: {'nameId': name.id},
            ),
          ),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ActionChip(
                avatar: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  size: 16,
                ),
                label: Text(l10n.babyNamesFavoriteAction),
                onPressed: () => notifier.toggleFavorite(name.id),
              ),
              ActionChip(
                avatar: Icon(
                  isShort ? Icons.bookmark : Icons.bookmark_border,
                  size: 16,
                ),
                label: Text(l10n.babyNamesShortlistAction),
                onPressed: () => notifier.toggleShortlist(name.id),
              ),
              ActionChip(
                avatar: Icon(
                  isComp ? Icons.check_circle_outline : Icons.add_circle_outline,
                  size: 16,
                ),
                label: Text(l10n.babyNamesCompareAction),
                onPressed: () => notifier.toggleCompare(name.id),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
