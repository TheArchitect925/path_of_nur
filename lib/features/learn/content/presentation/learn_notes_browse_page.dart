import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/learn_notes_provider.dart';
import '../domain/learn_note_category.dart';
import 'learn_notes_localizations.dart';

class LearnNotesBrowsePage extends ConsumerStatefulWidget {
  const LearnNotesBrowsePage({super.key});

  @override
  ConsumerState<LearnNotesBrowsePage> createState() =>
      _LearnNotesBrowsePageState();
}

class _LearnNotesBrowsePageState extends ConsumerState<LearnNotesBrowsePage> {
  final _searchController = TextEditingController();
  LearnNoteCategory? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = ref.watch(learnNotesBrowseItemsProvider);
    final filtered = items.where(_matchesCurrentFilter).toList(growable: false);

    return AppPageScaffold(
      title: l10n.learnNotesBrowseAllTitleText,
      subtitle: l10n.learnNotesBrowseAllSubtitleText,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: l10n.learnNotesBrowseSearchLabelText,
                  hintText: l10n.learnNotesBrowseSearchHintText,
                  suffixIcon: IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                    icon: const Icon(Icons.close_rounded),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: Text(l10n.learnNotesCategoryAllText),
                    selected: _selectedCategory == null,
                    onSelected: (_) => setState(() => _selectedCategory = null),
                  ),
                  ...LearnNoteCategory.values.map(
                    (category) => ChoiceChip(
                      label: Text(l10n.localizedLearnNoteCategory(category)),
                      selected: _selectedCategory == category,
                      onSelected: (_) =>
                          setState(() => _selectedCategory = category),
                    ),
                  ),
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
                  l10n.learnNotesBrowseEmptyTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(l10n.learnNotesBrowseEmptyText),
              ],
            ),
          )
        else
          ...filtered.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => _openItem(context, item),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Chip(
                              visualDensity: VisualDensity.compact,
                              label: Text(
                                item.sourceType == LearnNotesSourceType.quran
                                    ? l10n.learnNotesSourceQuranText
                                    : l10n.learnNotesSourceJournalText,
                              ),
                            ),
                            Chip(
                              visualDensity: VisualDensity.compact,
                              label: Text(
                                l10n.localizedLearnNoteCategory(item.category),
                              ),
                            ),
                            if ((item.referenceLabel ?? '').isNotEmpty)
                              Chip(
                                visualDensity: VisualDensity.compact,
                                label: Text(item.referenceLabel!),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.title,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.body,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.tags.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: item.tags
                                .take(4)
                                .map(
                                  (tag) => Chip(
                                    visualDensity: VisualDensity.compact,
                                    label: Text('#$tag'),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  bool _matchesCurrentFilter(LearnNotesBrowseItem item) {
    if (_selectedCategory != null && item.category != _selectedCategory) {
      return false;
    }
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return true;
    final haystack = <String>[
      item.title,
      item.body,
      item.referenceLabel ?? '',
      ...item.tags,
      item.category.id,
      item.sourceType.name,
    ].join(' ').toLowerCase();
    return haystack.contains(query);
  }

  void _openItem(BuildContext context, LearnNotesBrowseItem item) {
    switch (item.sourceType) {
      case LearnNotesSourceType.quran:
        context.pushNamed(
          'quranReader',
          pathParameters: {'surahNumber': item.surahNumber.toString()},
          queryParameters: {'ayah': item.ayahNumber.toString()},
        );
      case LearnNotesSourceType.journal:
        context.pushNamed(
          'journalEntryDetail',
          pathParameters: {'entryId': item.id},
        );
    }
  }
}
