import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/special_mode_provider.dart';
import '../../../../shared/widgets/display/filter_chip_row.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../presentation/widgets/learn_discovery_search_field.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../data/glossary_catalog.dart';
import '../domain/glossary_models.dart';
import 'widgets/glossary_widgets.dart';
import '../../../../core/theme/app_icons.dart';

class GlossaryPage extends ConsumerStatefulWidget {
  const GlossaryPage({super.key});

  @override
  ConsumerState<GlossaryPage> createState() => _GlossaryPageState();
}

class _GlossaryPageState extends ConsumerState<GlossaryPage> {
  final TextEditingController _searchController = TextEditingController();
  GlossaryCategory? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = _searchController.text.trim().toLowerCase();
    final entries = GlossaryCatalog.localizedEntries(context);
    final filtered = entries
        .where((entry) {
          final matchesCategory =
              _selectedCategory == null || entry.category == _selectedCategory;
          if (!matchesCategory) return false;
          if (query.isEmpty) return true;
          final haystack = [
            entry.term,
            entry.shortDefinition,
            entry.expandedExplanation,
            entry.kidsShortDefinition,
            entry.kidsExpandedExplanation,
            entry.transliteration ?? '',
          ].join(' ').toLowerCase();
          return haystack.contains(query);
        })
        .toList(growable: false);

    return LearnHubPageScaffold(
      headerIcon: AppIcons.glossary,
      title: l10n.learnGlossaryTitle,
      subtitle: l10n.learnGlossarySubtitle,
      children: [
        PremiumCard(
          surfaceVariant: AppSurfaceVariant.panel,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LearnDiscoverySearchField(
                controller: _searchController,
                hintText: l10n.learnGlossarySearchHint,
                onChanged: (_) => setState(() {}),
                onClear: () {
                  _searchController.clear();
                  setState(() {});
                },
              ),
              const SizedBox(height: 8),
              // An optional filter over one list: FilterChipRow clears the
              // selection when the active chip is tapped again, which is what
              // the explicit "all" segment used to be for.
              FilterChipRow<GlossaryCategory>(
                items: [
                  for (final category in const [
                    GlossaryCategory.practice,
                    GlossaryCategory.sources,
                    GlossaryCategory.places,
                  ])
                    FilterChipItem(
                      value: category,
                      label: localizedGlossaryCategoryLabel(context, category),
                    ),
                ],
                selected: _selectedCategory,
                onSelected: (category) {
                  setState(() => _selectedCategory = category);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          surfaceVariant: AppSurfaceVariant.panel,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.learnGlossaryInlineHintTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(l10n.learnGlossaryInlineHintBody),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Text(l10n.learnGlossaryQuickTermsLabel),
                  const GlossaryInlineTerm(entryId: GlossaryEntryId.salah),
                  const Text('•'),
                  const GlossaryInlineTerm(entryId: GlossaryEntryId.dhikr),
                  const Text('•'),
                  const GlossaryInlineTerm(entryId: GlossaryEntryId.sunnah),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (filtered.isEmpty)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.learnGlossaryNoResultsTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(l10n.learnGlossaryNoResultsSubtitle),
              ],
            ),
          )
        else if (_selectedCategory == null && query.isEmpty)
          ..._buildGroupedSections(context, filtered)
        else
          ...filtered.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _GlossaryEntryCard(entry: entry),
            ),
          ),
      ],
    );
  }

  List<Widget> _buildGroupedSections(
    BuildContext context,
    List<LocalizedGlossaryEntry> entries,
  ) {
    final widgets = <Widget>[];
    for (final category in GlossaryCategory.values) {
      final group = entries
          .where((entry) => entry.category == category)
          .toList(growable: false);
      if (group.isEmpty) continue;
      widgets.add(
        Padding(
          padding: EdgeInsets.only(top: widgets.isEmpty ? 0 : 10, bottom: 8),
          child: Text(
            localizedGlossaryCategoryLabel(context, category),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      );
      widgets.addAll(
        group.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _GlossaryEntryCard(entry: entry),
          ),
        ),
      );
    }
    return widgets;
  }
}

class _GlossaryEntryCard extends StatelessWidget {
  const _GlossaryEntryCard({required this.entry});

  final LocalizedGlossaryEntry entry;

  @override
  Widget build(BuildContext context) {
    final isKidsMode = ProviderScope.containerOf(
      context,
      listen: false,
    ).read(specialModeProvider).isKids;
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.panel,
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () => showGlossaryEntrySheet(context, entryId: entry.id),
        onLongPress: () => showGlossaryEntrySheet(context, entryId: entry.id),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      entry.term,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Chip(
                    label: Text(
                      localizedGlossaryCategoryLabel(context, entry.category),
                    ),
                  ),
                ],
              ),
              if (entry.transliteration != null &&
                  entry.transliteration!.trim().isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(entry.transliteration!),
              ],
              const SizedBox(height: 8),
              Text(
                entry.shortDefinitionFor(isKidsMode),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
