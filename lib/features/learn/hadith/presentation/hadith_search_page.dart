import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/segmented_pill_control.dart';
import '../application/hadith_search_repository.dart';
import '../application/hadith_search_support.dart';
import '../domain/hadith_foundation_models.dart';
import 'widgets/hadith_search_highlight_text.dart';

class HadithSearchPage extends ConsumerStatefulWidget {
  const HadithSearchPage({
    super.key,
    this.initialQuery = '',
    this.initialFilter = HadithSearchFilter.all,
  });

  final String initialQuery;
  final HadithSearchFilter initialFilter;

  @override
  ConsumerState<HadithSearchPage> createState() => _HadithSearchPageState();
}

class _HadithSearchPageState extends ConsumerState<HadithSearchPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _scheduleInitialStateSync();
  }

  @override
  void didUpdateWidget(covariant HadithSearchPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialQuery != widget.initialQuery) {
      _searchController.value = TextEditingValue(
        text: widget.initialQuery,
        selection: TextSelection.collapsed(offset: widget.initialQuery.length),
      );
    }
    Future<void>.microtask(() {
      if (!mounted) return;
      ref.read(hadithSearchQueryProvider.notifier).state = widget.initialQuery;
      ref.read(hadithSearchFilterProvider.notifier).state =
          widget.initialFilter;
    });
  }

  void _scheduleInitialStateSync() {
    Future<void>.microtask(() {
      if (!mounted) return;
      ref.read(hadithSearchQueryProvider.notifier).state = widget.initialQuery;
      ref.read(hadithSearchFilterProvider.notifier).state =
          widget.initialFilter;
    });
  }

  void _syncRoute({required String query, required HadithSearchFilter filter}) {
    final queryParameters = <String, String>{};
    final trimmedQuery = query.trim();
    if (trimmedQuery.isNotEmpty) {
      queryParameters['q'] = trimmedQuery;
    }
    if (filter != HadithSearchFilter.all) {
      queryParameters['filter'] = filter.wireValue;
    }
    final currentParameters = GoRouterState.of(context).uri.queryParameters;
    if (mapEquals(currentParameters, queryParameters)) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    Future<void>.microtask(() {
      if (!mounted) return;
      context.replaceNamed('hadithSearch', queryParameters: queryParameters);
    });
  }

  void _runSearch({
    required String query,
    required HadithSearchFilter filter,
    bool storeRecent = true,
  }) {
    final trimmed = query.trim();
    _searchController.value = TextEditingValue(
      text: trimmed,
      selection: TextSelection.collapsed(offset: trimmed.length),
    );
    ref.read(hadithSearchQueryProvider.notifier).state = trimmed;
    ref.read(hadithSearchFilterProvider.notifier).state = filter;
    if (storeRecent && trimmed.isNotEmpty) {
      ref
          .read(hadithRecentSearchesProvider.notifier)
          .addSearch(trimmed, filter: filter);
    }
    _syncRoute(query: trimmed, filter: filter);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(hadithSearchQueryProvider);
    final filter = ref.watch(hadithSearchFilterProvider);
    final results = ref.watch(hadithSearchResultsProvider);
    final sources = ref.watch(hadithSearchAvailableSourceTitlesProvider);
    final categories = ref.watch(hadithSearchAvailableCategoriesProvider);
    final recents = ref.watch(hadithRecentSearchesProvider);
    final suggestions = ref.watch(hadithSuggestedSearchesProvider);
    final trimmedQuery = query.trim();
    final groupedResults = _groupResults(results);

    if (_searchController.text != query) {
      _searchController.value = TextEditingValue(
        text: query,
        selection: TextSelection.collapsed(offset: query.length),
      );
    }

    return AppPageScaffold(
      headerIcon: Icons.search_rounded,
      title: l10n.hadithSearchTitle,
      subtitle: l10n.hadithSearchSubtitle,
      children: [
        PremiumCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: TextField(
            autofocus: true,
            controller: _searchController,
            onChanged: (value) =>
                ref.read(hadithSearchQueryProvider.notifier).state = value,
            onSubmitted: (value) {
              _runSearch(query: value, filter: filter);
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintText: l10n.searchHadithHint,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: query.trim().isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _searchController.clear();
                        ref.read(hadithSearchQueryProvider.notifier).state = '';
                        _syncRoute(query: '', filter: filter);
                      },
                      icon: const Icon(Icons.close_rounded, size: 18),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SegmentedPillControl<HadithSearchFilter>(
          items: HadithSearchFilter.values,
          selectedItem: filter,
          labelBuilder: (item) => item.label(l10n),
          onChanged: (value) {
            ref.read(hadithSearchFilterProvider.notifier).state = value;
            _syncRoute(query: query, filter: value);
          },
        ),
        const SizedBox(height: 12),
        if (trimmedQuery.isEmpty) ...[
          _HadithSearchEmptyState(
            recentSearches: recents,
            suggestions: suggestions,
            sourceTitles: sources.take(4).toList(growable: false),
            categories: categories.take(4).toList(growable: false),
            onSelectSuggestion: (suggestion, nextFilter) =>
                _runSearch(query: suggestion, filter: nextFilter),
            onSelectRecent: (recent) =>
                _runSearch(query: recent.query, filter: recent.filter),
            onRemoveRecent: (recent) => ref
                .read(hadithRecentSearchesProvider.notifier)
                .removeSearch(recent.query),
            onClearRecents: () =>
                ref.read(hadithRecentSearchesProvider.notifier).clear(),
          ),
        ] else if (results.isEmpty) ...[
          _HadithSearchNoResultsState(
            suggestions: suggestions.take(3).toList(growable: false),
            onSelectSuggestion: (suggestion, nextFilter) =>
                _runSearch(query: suggestion, filter: nextFilter),
          ),
        ] else ...[
          Text(
            l10n.hadithSearchResultsCount(results.length),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ...groupedResults.entries.map(
            (entry) => _HadithSearchResultGroupSection(
              group: entry.key,
              results: entry.value,
              onTapResult: (resolved) {
                ref
                    .read(hadithRecentSearchesProvider.notifier)
                    .addSearch(trimmedQuery, filter: filter);
                context.pushNamed(
                  'hadithLessonDetail',
                  pathParameters: {'lessonId': resolved.entry.id},
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _HadithSearchEmptyState extends StatelessWidget {
  const _HadithSearchEmptyState({
    required this.recentSearches,
    required this.suggestions,
    required this.sourceTitles,
    required this.categories,
    required this.onSelectSuggestion,
    required this.onSelectRecent,
    required this.onRemoveRecent,
    required this.onClearRecents,
  });

  final List<HadithStoredSearch> recentSearches;
  final List<HadithSuggestedSearch> suggestions;
  final List<String> sourceTitles;
  final List<HadithCategory> categories;
  final void Function(String suggestion, HadithSearchFilter filter)
  onSelectSuggestion;
  final ValueChanged<HadithStoredSearch> onSelectRecent;
  final ValueChanged<HadithStoredSearch> onRemoveRecent;
  final VoidCallback onClearRecents;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.hadithSearchEmptyQueryTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.hadithSearchEmptyQuerySubtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          Text(
            l10n.hadithSearchSuggestionsTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions
                .map(
                  (suggestion) => ActionChip(
                    label: Text(suggestion.query(context)),
                    onPressed: () =>
                        onSelectSuggestion(
                          suggestion.query(context),
                          HadithSearchFilter.all,
                        ),
                  ),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.hadithSearchRecentTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              if (recentSearches.isNotEmpty)
                TextButton(
                  onPressed: onClearRecents,
                  child: Text(l10n.hadithSearchClearRecents),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (recentSearches.isEmpty)
            Text(
              l10n.hadithSearchNoRecent,
              style: Theme.of(context).textTheme.bodyMedium,
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recentSearches
                  .map(
                    (recent) => InputChip(
                      label: Text(recent.query),
                      onPressed: () => onSelectRecent(recent),
                      onDeleted: () => onRemoveRecent(recent),
                      deleteIcon: const Icon(Icons.close_rounded, size: 16),
                    ),
                  )
                  .toList(growable: false),
            ),
          if (sourceTitles.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              l10n.hadithSearchSuggestedSourcesTitle,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sourceTitles
                  .map(
                    (source) => ActionChip(
                      label: Text(source),
                      onPressed: () =>
                          onSelectSuggestion(source, HadithSearchFilter.source),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
          if (categories.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              l10n.hadithSearchSuggestedCategoriesTitle,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories
                  .map(
                    (category) => ActionChip(
                      label: Text(category.title),
                      onPressed: () => onSelectSuggestion(
                        category.title,
                        HadithSearchFilter.category,
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ],
      ),
    );
  }
}

class _HadithSearchNoResultsState extends StatelessWidget {
  const _HadithSearchNoResultsState({
    required this.suggestions,
    required this.onSelectSuggestion,
  });

  final List<HadithSuggestedSearch> suggestions;
  final void Function(String suggestion, HadithSearchFilter filter)
  onSelectSuggestion;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.hadithSearchNoResultsTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.hadithSearchNoResultsSubtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.hadithSearchNoResultsTryBroader,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.hadithSearchNoResultsTrySource,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.hadithSearchNoResultsTryCategory,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...suggestions.map(
                (suggestion) => ActionChip(
                  label: Text(suggestion.query(context)),
                  onPressed: () => onSelectSuggestion(
                    suggestion.query(context),
                    HadithSearchFilter.all,
                  ),
                ),
              ),
              ActionChip(
                label: const Text('Riyad as-Salihin'),
                onPressed: () => onSelectSuggestion(
                  'Riyad as-Salihin',
                  HadithSearchFilter.source,
                ),
              ),
              ActionChip(
                label: Text(
                  AppLocalizations.of(context).hadithSearchSuggestionCharacter,
                ),
                onPressed: () => onSelectSuggestion(
                  AppLocalizations.of(context).hadithSearchSuggestionCharacter,
                  HadithSearchFilter.category,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HadithSearchResultGroupSection extends StatelessWidget {
  const _HadithSearchResultGroupSection({
    required this.group,
    required this.results,
    required this.onTapResult,
  });

  final HadithSearchResultGroup group;
  final List<HadithSearchResolvedResult> results;
  final ValueChanged<HadithSearchResolvedResult> onTapResult;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          group.label(l10n),
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        ...results.map(
          (resolved) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _HadithSearchResultCard(
              result: resolved,
              onTap: () => onTapResult(resolved),
            ),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

class _HadithSearchResultCard extends StatelessWidget {
  const _HadithSearchResultCard({required this.result, required this.onTap});

  final HadithSearchResolvedResult result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entry = result.entry;
    final matchedFieldLabel = result.result.matchedField.label(l10n);
    final titleHighlightTerms =
        result.result.matchedField == HadithSearchMatchField.title
        ? result.result.highlightTerms
        : const <String>[];
    final snippet = result.result.snippetText.trim();

    return PremiumCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HadithSearchHighlightedText(
                text: entry.title,
                highlightTerms: titleHighlightTerms,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _HadithMetadataChip(
                    label: l10n.hadithSourceLabel,
                    value: entry.displaySourceCollectionTitle,
                  ),
                  if ((entry.displaySourceReference ?? '').trim().isNotEmpty)
                    _HadithMetadataChip(
                      label: l10n.hadithReferenceLabel,
                      value: entry.displaySourceReference!,
                    ),
                  if (entry.standardizedGrade.displayLabel.trim().isNotEmpty)
                    _HadithMetadataChip(
                      label: l10n.hadithGradeShortLabel,
                      value: entry.standardizedGrade.displayLabel,
                    ),
                ],
              ),
              if (snippet.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  matchedFieldLabel,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                HadithSearchHighlightedText(
                  text: snippet,
                  highlightTerms: result.result.highlightTerms,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _HadithMetadataChip extends StatelessWidget {
  const _HadithMetadataChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$label: $value',
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

Map<HadithSearchResultGroup, List<HadithSearchResolvedResult>> _groupResults(
  List<HadithSearchResolvedResult> results,
) {
  final grouped = <HadithSearchResultGroup, List<HadithSearchResolvedResult>>{};
  for (final result in results) {
    final group = result.result.matchedField.group;
    grouped.putIfAbsent(group, () => <HadithSearchResolvedResult>[]).add(result);
  }
  return grouped;
}

extension on HadithSearchFilter {
  String label(AppLocalizations l10n) {
    switch (this) {
      case HadithSearchFilter.all:
        return l10n.hadithSearchFilterAll;
      case HadithSearchFilter.source:
        return l10n.hadithSearchFilterSource;
      case HadithSearchFilter.category:
        return l10n.hadithSearchFilterCategory;
      case HadithSearchFilter.subcategory:
        return l10n.hadithSearchFilterSubcategory;
      case HadithSearchFilter.grade:
        return l10n.hadithSearchFilterGrade;
    }
  }
}

extension on HadithSearchResultGroup {
  String label(AppLocalizations l10n) {
    switch (this) {
      case HadithSearchResultGroup.text:
        return l10n.hadithSearchGroupText;
      case HadithSearchResultGroup.source:
        return l10n.hadithSearchGroupSource;
      case HadithSearchResultGroup.topical:
        return l10n.hadithSearchGroupTopical;
      case HadithSearchResultGroup.grade:
        return l10n.hadithSearchGroupGrade;
    }
  }
}

extension on HadithSuggestedSearch {
  String query(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case HadithSuggestedSearch.intentions:
        return l10n.hadithSearchSuggestionIntentions;
      case HadithSuggestedSearch.sincerity:
        return l10n.hadithSearchSuggestionSincerity;
      case HadithSuggestedSearch.mercy:
        return l10n.hadithSearchSuggestionMercy;
      case HadithSuggestedSearch.repentance:
        return l10n.hadithSearchSuggestionRepentance;
      case HadithSuggestedSearch.dua:
        return l10n.hadithSearchSuggestionDua;
      case HadithSuggestedSearch.character:
        return l10n.hadithSearchSuggestionCharacter;
      case HadithSuggestedSearch.justice:
        return l10n.hadithSearchSuggestionJustice;
      case HadithSuggestedSearch.gratitude:
        return l10n.hadithSearchSuggestionGratitude;
    }
  }
}

extension on HadithSearchMatchField {
  String label(AppLocalizations l10n) {
    switch (this) {
      case HadithSearchMatchField.title:
        return l10n.hadithSearchMatchTitle;
      case HadithSearchMatchField.excerpt:
        return l10n.hadithSearchMatchExcerpt;
      case HadithSearchMatchField.translation:
        return l10n.hadithSearchMatchTranslation;
      case HadithSearchMatchField.arabic:
        return l10n.hadithSearchMatchArabic;
      case HadithSearchMatchField.transliteration:
        return l10n.hadithSearchMatchTransliteration;
      case HadithSearchMatchField.sourceCollection:
        return l10n.hadithSearchMatchSource;
      case HadithSearchMatchField.reference:
        return l10n.hadithSearchMatchReference;
      case HadithSearchMatchField.narrator:
        return l10n.hadithSearchMatchNarrator;
      case HadithSearchMatchField.category:
        return l10n.hadithSearchMatchCategory;
      case HadithSearchMatchField.subcategory:
        return l10n.hadithSearchMatchSubcategory;
      case HadithSearchMatchField.grade:
        return l10n.hadithSearchMatchGrade;
    }
  }
}
