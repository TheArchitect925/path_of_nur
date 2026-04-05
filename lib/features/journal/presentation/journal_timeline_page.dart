import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_surfaces.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/content/page_description_copy.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/journal_provider.dart';

class JournalTimelinePage extends ConsumerStatefulWidget {
  const JournalTimelinePage({super.key});

  @override
  ConsumerState<JournalTimelinePage> createState() =>
      _JournalTimelinePageState();
}

class _JournalTimelinePageState extends ConsumerState<JournalTimelinePage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(journalProvider);
    final notifier = ref.read(journalProvider.notifier);
    final memory = ref.watch(journalMemoryPreviewProvider);
    final grouped = ref.watch(journalTimelineGroupedProvider);
    final isKidsMode = ref.watch(
      specialModeProvider.select((mode) => mode.isKids),
    );

    return AppPageScaffold(
      headerIcon: Icons.auto_stories_outlined,
      title: l10n.journalTitle,
      subtitle: localizedAppPageDescription(
        context,
        AppPageDescriptionKey.journalTimeline,
        kidsMode: isKidsMode,
      ),
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.journalTimelineIntro),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  TextButton(
                    onPressed: () => context.pushNamed('quranReflections'),
                    child: Text(l10n.quranReflectionsTitle),
                  ),
                  FilledButton.tonal(
                    onPressed: () => context.pushNamed('journalCreate'),
                    child: Text(l10n.journalCreateAction),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: l10n.journalSearchLabel,
                  suffixIcon: IconButton(
                    onPressed: () {
                      _searchController.clear();
                      notifier.setSearchQuery('');
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
                onSubmitted: notifier.setSearchQuery,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: JournalFilter.values
                    .map(
                      (filter) => ChoiceChip(
                        label: Text(_filterLabel(l10n, filter)),
                        selected: state.selectedFilter == filter,
                        onSelected: (_) => notifier.setFilter(filter),
                      ),
                    )
                    .toList(),
              ),
              if (state.searchHistory.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: state.searchHistory
                      .map(
                        (item) => ActionChip(
                          label: Text(item),
                          onPressed: () {
                            _searchController.text = item;
                            notifier.setSearchQuery(item);
                          },
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (memory != null)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.journalMemoryResurfaceTitle,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(memory.body, maxLines: 3, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        if (memory != null) const SizedBox(height: 12),
        if (grouped.isEmpty)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.journalEmptyStateTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(l10n.journalEmptyStateSubtitle),
                const SizedBox(height: 10),
                FilledButton.tonal(
                  onPressed: () => context.pushNamed('journalCreate'),
                  child: Text(l10n.journalCreateAction),
                ),
              ],
            ),
          )
        else
          ...grouped.entries.map(
            (group) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.key,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    ...group.value.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => context.pushNamed(
                            'journalEntryDetail',
                            pathParameters: {'entryId': entry.id},
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry.title.isEmpty
                                            ? l10n.journalUntitled
                                            : entry.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        entry.body,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: [
                                          _tinyChip(
                                            _typeLabel(l10n, entry.type),
                                          ),
                                          if (entry.linkedTopic != null &&
                                              entry.linkedTopic!.isNotEmpty)
                                            _tinyChip(entry.linkedTopic!),
                                          if (entry.photoPath != null &&
                                              entry.photoPath!.isNotEmpty)
                                            _tinyChip(
                                              l10n.journalPhotoAttached,
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      notifier.toggleFavorite(entry.id),
                                  icon: Icon(
                                    entry.favorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _typeLabel(AppLocalizations l10n, JournalEntryType type) {
    switch (type) {
      case JournalEntryType.reflection:
        return l10n.journalTypeReflection;
      case JournalEntryType.gratitude:
        return l10n.journalTypeGratitude;
      case JournalEntryType.observation:
        return l10n.journalTypeObservation;
      case JournalEntryType.learning:
        return l10n.journalTypeLearning;
      case JournalEntryType.memory:
        return l10n.journalTypeMemory;
    }
  }

  String _filterLabel(AppLocalizations l10n, JournalFilter filter) {
    switch (filter) {
      case JournalFilter.all:
        return l10n.journalFilterAll;
      case JournalFilter.favorites:
        return l10n.journalFilterFavorites;
      case JournalFilter.reflection:
        return l10n.journalTypeReflection;
      case JournalFilter.gratitude:
        return l10n.journalTypeGratitude;
      case JournalFilter.observation:
        return l10n.journalTypeObservation;
      case JournalFilter.learning:
        return l10n.journalTypeLearning;
      case JournalFilter.memory:
        return l10n.journalTypeMemory;
    }
  }

  Widget _tinyChip(String label) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: style.decoration(radius: 999, includeShadow: false),
      child: Text(label, style: const TextStyle(fontSize: 11)),
    );
  }
}
