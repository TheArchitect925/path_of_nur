import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../content_linking/domain/editorial_relation_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/all_search_repository.dart';

class AllSearchPage extends ConsumerStatefulWidget {
  const AllSearchPage({super.key, this.initialQuery = ''});

  final String initialQuery;

  @override
  ConsumerState<AllSearchPage> createState() => _AllSearchPageState();
}

class _AllSearchPageState extends ConsumerState<AllSearchPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _scheduleInitialStateSync();
  }

  @override
  void didUpdateWidget(covariant AllSearchPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialQuery != widget.initialQuery) {
      _searchController.value = TextEditingValue(
        text: widget.initialQuery,
        selection: TextSelection.collapsed(offset: widget.initialQuery.length),
      );
    }
    _scheduleInitialStateSync();
  }

  void _scheduleInitialStateSync() {
    Future<void>.microtask(() {
      if (!mounted) return;
      ref.read(allSearchQueryProvider.notifier).state = widget.initialQuery;
    });
  }

  void _syncRoute(String query) {
    final queryParameters = <String, String>{};
    final trimmed = query.trim();
    if (trimmed.isNotEmpty) {
      queryParameters['q'] = trimmed;
    }
    final currentParameters = GoRouterState.of(context).uri.queryParameters;
    if (mapEquals(currentParameters, queryParameters)) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    Future<void>.microtask(() {
      if (!mounted) return;
      context.replaceNamed('allSearch', queryParameters: queryParameters);
    });
  }

  void _runSearch(String query, {bool storeRecent = true}) {
    final trimmed = query.trim();
    _searchController.value = TextEditingValue(
      text: trimmed,
      selection: TextSelection.collapsed(offset: trimmed.length),
    );
    ref.read(allSearchQueryProvider.notifier).state = trimmed;
    if (storeRecent && trimmed.isNotEmpty) {
      ref.read(allSearchRecentQueriesProvider.notifier).addQuery(trimmed);
    }
    _syncRoute(trimmed);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(allSearchQueryProvider);
    final resultsAsync = ref.watch(allSearchResultsProvider);
    final recents = ref.watch(allSearchRecentQueriesProvider);
    final suggestions = ref.watch(allSearchSuggestionsProvider);
    final trimmedQuery = query.trim();

    if (_searchController.text != query) {
      _searchController.value = TextEditingValue(
        text: query,
        selection: TextSelection.collapsed(offset: query.length),
      );
    }

    return AppPageScaffold(
      title: l10n.allSearchTitle,
      subtitle: l10n.allSearchSubtitle,
      children: [
        PremiumCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: TextField(
            autofocus: true,
            controller: _searchController,
            onChanged: (value) =>
                ref.read(allSearchQueryProvider.notifier).state = value,
            onSubmitted: _runSearch,
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintText: l10n.allSearchHint,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: trimmedQuery.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _searchController.clear();
                        ref.read(allSearchQueryProvider.notifier).state = '';
                        _syncRoute('');
                      },
                      icon: const Icon(Icons.close_rounded, size: 18),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (trimmedQuery.isEmpty) ...[
          _AllSearchEmptyQueryState(
            recents: recents,
            suggestions: suggestions,
            onSelectQuery: _runSearch,
            onRemoveRecent: (recent) => ref
                .read(allSearchRecentQueriesProvider.notifier)
                .removeQuery(recent.query),
            onClearRecents: () =>
                ref.read(allSearchRecentQueriesProvider.notifier).clear(),
          ),
        ] else ...[
          resultsAsync.when(
            data: (results) {
              if (results.isEmpty) {
                return _AllSearchNoResultsState(
                  suggestions: suggestions.take(4).toList(growable: false),
                  onSelectQuery: _runSearch,
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.allSearchResultsFor(trimmedQuery),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...results.sections
                      .where((section) => section.results.isNotEmpty)
                      .map(
                        (section) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _AllSearchSectionCard(
                            section: section,
                            onTapResult: (result) {
                              ref
                                  .read(allSearchRecentQueriesProvider.notifier)
                                  .addQuery(trimmedQuery);
                              context.pushNamed(
                                result.routeName,
                                pathParameters: result.pathParameters,
                                queryParameters: result.queryParameters,
                              );
                            },
                            onTapViewAll: () {
                              context.pushNamed(
                                section.viewAllRouteName,
                                pathParameters: section.viewAllPathParameters,
                                queryParameters: section.viewAllQueryParameters,
                              );
                            },
                          ),
                        ),
                      ),
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) =>
                PremiumCard(child: Text(l10n.allSearchError(error.toString()))),
          ),
        ],
      ],
    );
  }
}

class _AllSearchEmptyQueryState extends StatelessWidget {
  const _AllSearchEmptyQueryState({
    required this.recents,
    required this.suggestions,
    required this.onSelectQuery,
    required this.onRemoveRecent,
    required this.onClearRecents,
  });

  final List<AllSearchStoredQuery> recents;
  final List<AllSearchSuggestion> suggestions;
  final ValueChanged<String> onSelectQuery;
  final ValueChanged<AllSearchStoredQuery> onRemoveRecent;
  final VoidCallback onClearRecents;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.allSearchEmptyTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.allSearchEmptySubtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.allSearchSuggestionsTitle,
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
                    label: Text(suggestion.label(l10n)),
                    onPressed: () => onSelectQuery(suggestion.label(l10n)),
                  ),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.allSearchRecentTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              if (recents.isNotEmpty)
                TextButton(
                  onPressed: onClearRecents,
                  child: Text(l10n.allSearchClearRecent),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (recents.isEmpty)
            Text(
              l10n.allSearchNoRecent,
              style: Theme.of(context).textTheme.bodyMedium,
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recents
                  .map(
                    (recent) => InputChip(
                      label: Text(recent.query),
                      onPressed: () => onSelectQuery(recent.query),
                      onDeleted: () => onRemoveRecent(recent),
                    ),
                  )
                  .toList(growable: false),
            ),
        ],
      ),
    );
  }
}

class _AllSearchNoResultsState extends StatelessWidget {
  const _AllSearchNoResultsState({
    required this.suggestions,
    required this.onSelectQuery,
  });

  final List<AllSearchSuggestion> suggestions;
  final ValueChanged<String> onSelectQuery;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.allSearchNoResultsTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.allSearchNoResultsSubtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.allSearchNoResultsTipBroader,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.allSearchNoResultsTipDomain,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions
                .map(
                  (suggestion) => ActionChip(
                    label: Text(suggestion.label(l10n)),
                    onPressed: () => onSelectQuery(suggestion.label(l10n)),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _AllSearchSectionCard extends StatelessWidget {
  const _AllSearchSectionCard({
    required this.section,
    required this.onTapResult,
    required this.onTapViewAll,
  });

  final AllSearchSection section;
  final ValueChanged<AllSearchResult> onTapResult;
  final VoidCallback onTapViewAll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  section.domain.title(l10n),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: onTapViewAll,
                child: Text(section.domain.viewAllLabel(l10n)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ...section.results.map(
            (result) => ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () => onTapResult(result),
              title: Text(result.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if ((result.subtitle ?? '').trim().isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      result.subtitle!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  _AllSearchHighlightText(
                    text: result.snippet,
                    highlightTerms: result.highlightTerms,
                  ),
                  if (result.relationLinks.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: result.relationLinks
                          .map(
                            (relation) => Chip(
                              visualDensity: VisualDensity.compact,
                              label: Text(
                                '${relation.relationType.label(l10n)}: ${relation.title}',
                              ),
                            ),
                          )
                          .toList(growable: false),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AllSearchHighlightText extends StatelessWidget {
  const _AllSearchHighlightText({
    required this.text,
    required this.highlightTerms,
  });

  final String text;
  final List<String> highlightTerms;

  @override
  Widget build(BuildContext context) {
    final spans = _buildHighlightSpans(
      text: text,
      highlightTerms: highlightTerms,
      defaultStyle: Theme.of(context).textTheme.bodyMedium,
      highlightStyle: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
    );
    return Text.rich(TextSpan(children: spans));
  }
}

List<TextSpan> _buildHighlightSpans({
  required String text,
  required List<String> highlightTerms,
  required TextStyle? defaultStyle,
  required TextStyle? highlightStyle,
}) {
  if (text.isEmpty || highlightTerms.isEmpty) {
    return <TextSpan>[TextSpan(text: text, style: defaultStyle)];
  }

  final normalizedTerms =
      highlightTerms
          .map((term) => term.trim())
          .where((term) => term.isNotEmpty)
          .toSet()
          .toList(growable: false)
        ..sort((a, b) => b.length.compareTo(a.length));
  if (normalizedTerms.isEmpty) {
    return <TextSpan>[TextSpan(text: text, style: defaultStyle)];
  }

  final pattern = RegExp(
    normalizedTerms.map(RegExp.escape).join('|'),
    caseSensitive: false,
  );
  final spans = <TextSpan>[];
  var start = 0;
  for (final match in pattern.allMatches(text)) {
    if (match.start > start) {
      spans.add(
        TextSpan(text: text.substring(start, match.start), style: defaultStyle),
      );
    }
    spans.add(
      TextSpan(
        text: text.substring(match.start, match.end),
        style: highlightStyle,
      ),
    );
    start = match.end;
  }
  if (start < text.length) {
    spans.add(TextSpan(text: text.substring(start), style: defaultStyle));
  }
  return spans;
}

extension _AllSearchDomainX on AllSearchDomain {
  String title(AppLocalizations l10n) {
    switch (this) {
      case AllSearchDomain.quran:
        return l10n.allSearchDomainQuran;
      case AllSearchDomain.hadith:
        return l10n.allSearchDomainHadith;
      case AllSearchDomain.dua:
        return l10n.allSearchDomainDua;
      case AllSearchDomain.learn:
        return l10n.allSearchDomainLearn;
    }
  }

  String viewAllLabel(AppLocalizations l10n) {
    switch (this) {
      case AllSearchDomain.quran:
        return l10n.allSearchViewAllQuran;
      case AllSearchDomain.hadith:
        return l10n.allSearchViewAllHadith;
      case AllSearchDomain.dua:
        return l10n.allSearchViewAllDua;
      case AllSearchDomain.learn:
        return l10n.allSearchViewAllLearn;
    }
  }
}

extension _AllSearchSuggestionX on AllSearchSuggestion {
  String label(AppLocalizations l10n) {
    switch (this) {
      case AllSearchSuggestion.mercy:
        return l10n.allSearchSuggestionMercy;
      case AllSearchSuggestion.patience:
        return l10n.allSearchSuggestionPatience;
      case AllSearchSuggestion.intentions:
        return l10n.allSearchSuggestionIntentions;
      case AllSearchSuggestion.repentance:
        return l10n.allSearchSuggestionRepentance;
      case AllSearchSuggestion.dua:
        return l10n.allSearchSuggestionDua;
      case AllSearchSuggestion.prophets:
        return l10n.allSearchSuggestionProphets;
      case AllSearchSuggestion.gratitude:
        return l10n.allSearchSuggestionGratitude;
      case AllSearchSuggestion.justice:
        return l10n.allSearchSuggestionJustice;
    }
  }
}

extension _EditorialRelationTypeLabelX on EditorialRelationType {
  String label(AppLocalizations l10n) {
    switch (this) {
      case EditorialRelationType.explains:
        return l10n.editorialRelationTypeExplains;
      case EditorialRelationType.reinforces:
        return l10n.editorialRelationTypeReinforces;
      case EditorialRelationType.sameTheme:
        return l10n.editorialRelationTypeSameTheme;
      case EditorialRelationType.relatedPractice:
        return l10n.editorialRelationTypeRelatedPractice;
      case EditorialRelationType.relatedDua:
        return l10n.editorialRelationTypeRelatedDua;
      case EditorialRelationType.relatedCreationSign:
        return l10n.editorialRelationTypeRelatedCreationSign;
      case EditorialRelationType.sameLesson:
        return l10n.editorialRelationTypeSameLesson;
      case EditorialRelationType.readerFollowUp:
        return l10n.editorialRelationTypeReaderFollowUp;
    }
  }
}
