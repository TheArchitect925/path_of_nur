import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_fonts.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/app_layered_glass_pill_button.dart';
import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../../../../shared/widgets/segmented_pill_control.dart';
import '../../../../../shared/widgets/quran_navigation.dart';
import '../application/quran_ayah_enrichment_provider.dart';
import '../application/quran_providers.dart';
import '../application/quran_search_normalization.dart';
import '../application/quran_search_support.dart';
import '../application/quran_surah_insights_provider.dart';
import '../application/quran_theme_discovery_provider.dart';
import '../domain/quran_ayah_enrichment_models.dart';
import '../domain/quran_surah.dart';
import '../domain/quran_surah_insight_models.dart';
import '../domain/quran_theme_discovery_models.dart';
import 'widgets/quran_search_highlight_text.dart';

class QuranSearchPage extends ConsumerStatefulWidget {
  const QuranSearchPage({
    super.key,
    this.initialQuery = '',
    this.initialSearchType = QuranSearchType.all,
    this.initialFieldFilter = QuranSearchFieldFilter.all,
  });

  final String initialQuery;
  final QuranSearchType initialSearchType;
  final QuranSearchFieldFilter initialFieldFilter;

  @override
  ConsumerState<QuranSearchPage> createState() => _QuranSearchPageState();
}

class _QuranSearchPageState extends ConsumerState<QuranSearchPage> {
  late final TextEditingController _searchController;

  void _scheduleInitialStateSync() {
    Future<void>.microtask(() {
      if (!mounted) return;
      ref.read(quranSearchQueryProvider.notifier).state = widget.initialQuery;
      ref.read(quranSearchTypeProvider.notifier).state =
          widget.initialSearchType;
      ref.read(quranSearchFieldFilterProvider.notifier).state =
          widget.initialFieldFilter;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _scheduleInitialStateSync();
  }

  @override
  void didUpdateWidget(covariant QuranSearchPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialQuery != widget.initialQuery) {
      _searchController.value = TextEditingValue(
        text: widget.initialQuery,
        selection: TextSelection.collapsed(offset: widget.initialQuery.length),
      );
    }
    Future<void>.microtask(() {
      if (!mounted) return;
      ref.read(quranSearchQueryProvider.notifier).state = widget.initialQuery;
      ref.read(quranSearchTypeProvider.notifier).state =
          widget.initialSearchType;
      ref.read(quranSearchFieldFilterProvider.notifier).state =
          widget.initialFieldFilter;
    });
  }

  void _syncRoute({
    required String query,
    required QuranSearchType searchType,
    required QuranSearchFieldFilter fieldFilter,
  }) {
    final queryParameters = <String, String>{};
    final trimmedQuery = query.trim();
    if (trimmedQuery.isNotEmpty) {
      queryParameters['q'] = trimmedQuery;
    }
    if (searchType != QuranSearchType.all) {
      queryParameters['type'] = searchType.wireValue;
    }
    if (searchType == QuranSearchType.text &&
        fieldFilter != QuranSearchFieldFilter.all) {
      queryParameters['field'] = fieldFilter.wireValue;
    }
    final currentParameters = GoRouterState.of(context).uri.queryParameters;
    if (mapEquals(currentParameters, queryParameters)) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    Future<void>.microtask(() {
      if (!mounted) return;
      context.replaceNamed('quranSearch', queryParameters: queryParameters);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(quranSearchQueryProvider);
    final searchType = ref.watch(quranSearchTypeProvider);
    final fieldFilter = ref.watch(quranSearchFieldFilterProvider);
    final effectiveSavedFieldFilter = searchType == QuranSearchType.text
        ? fieldFilter
        : QuranSearchFieldFilter.all;
    final textResultsAsync = ref.watch(
      quranTextSearchResultsProvider(
        QuranTextSearchQuery(
          query: query,
          maxResults: 80,
          fieldFilter: searchType == QuranSearchType.text
              ? fieldFilter
              : QuranSearchFieldFilter.all,
        ),
      ),
    );
    final textResults =
        textResultsAsync.asData?.value ?? const <QuranSearchResult>[];
    final recent = ref.watch(quranRecentSearchesProvider);
    final saved = ref.watch(quranSavedSearchesProvider);
    final suggestions = ref.watch(quranSuggestedSearchesProvider);
    final languageCode = Localizations.localeOf(context).languageCode;
    final entries = ref.watch(
      quranAyahEnrichmentEntriesForLanguageProvider(languageCode),
    );
    final paths = ref.watch(quranAyahInsightResolvedPathsProvider);
    final surahInsights = ref.watch(quranSurahInsightsBrowseProvider);
    final surahMap = ref.watch(quranSurahMapProvider);
    final themes = ref.watch(quranResolvedThemesProvider);
    final surahs = ref.watch(quranSurahListProvider);
    final trimmedQuery = query.trim();
    final normalizedQuery = normalizeQuranSearchText(trimmedQuery);
    final topicResults = normalizedQuery.isEmpty
        ? const <_QuranSupplementalSearchResult>[]
        : _buildTopicResults(
            query: normalizedQuery,
            l10n: l10n,
            entries: entries,
            paths: paths,
            surahInsights: surahInsights,
            surahMap: surahMap,
          );
    final themeResults = normalizedQuery.isEmpty
        ? const <_QuranSupplementalSearchResult>[]
        : _buildThemeResults(
            query: normalizedQuery,
            l10n: l10n,
            topics: themes,
          );
    final surahResults = normalizedQuery.isEmpty
        ? const <_QuranSupplementalSearchResult>[]
        : _buildSurahResults(query: trimmedQuery, l10n: l10n, surahs: surahs);
    final isLoadingVisibleResults =
        (searchType == QuranSearchType.all ||
            searchType == QuranSearchType.text) &&
        textResultsAsync.isLoading &&
        trimmedQuery.isNotEmpty &&
        textResults.isEmpty;
    final hasVisibleResults = switch (searchType) {
      QuranSearchType.all =>
        textResults.isNotEmpty ||
            themeResults.isNotEmpty ||
            topicResults.isNotEmpty ||
            surahResults.isNotEmpty,
      QuranSearchType.text => textResults.isNotEmpty,
      QuranSearchType.theme => themeResults.isNotEmpty,
      QuranSearchType.topic => topicResults.isNotEmpty,
      QuranSearchType.surah => surahResults.isNotEmpty,
    };
    final isSavedSearch =
        trimmedQuery.isNotEmpty &&
        ref
            .read(quranSavedSearchesProvider.notifier)
            .isSaved(trimmedQuery, fieldFilter: effectiveSavedFieldFilter);

    void runStoredSearch(QuranStoredSearch entry) {
      _searchController.value = TextEditingValue(
        text: entry.query,
        selection: TextSelection.collapsed(offset: entry.query.length),
      );
      ref.read(quranSearchQueryProvider.notifier).state = entry.query;
      ref.read(quranSearchFieldFilterProvider.notifier).state =
          entry.fieldFilter;
      ref
          .read(quranRecentSearchesProvider.notifier)
          .addSearch(entry.query, fieldFilter: entry.fieldFilter);
      _syncRoute(
        query: entry.query,
        searchType: searchType,
        fieldFilter: searchType == QuranSearchType.text
            ? entry.fieldFilter
            : QuranSearchFieldFilter.all,
      );
    }

    if (_searchController.text != query) {
      _searchController.value = TextEditingValue(
        text: query,
        selection: TextSelection.collapsed(offset: query.length),
      );
    }

    return AppPageScaffold(
      title: l10n.quranSearchTitle,
      subtitle: l10n.quranSearchSubtitle,
      children: [
        PremiumCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: TextField(
            autofocus: true,
            controller: _searchController,
            onChanged: (value) =>
                ref.read(quranSearchQueryProvider.notifier).state = value,
            onSubmitted: (value) {
              final savedFieldFilter = searchType == QuranSearchType.text
                  ? fieldFilter
                  : QuranSearchFieldFilter.all;
              ref
                  .read(quranRecentSearchesProvider.notifier)
                  .addSearch(value, fieldFilter: savedFieldFilter);
              _syncRoute(
                query: value,
                searchType: searchType,
                fieldFilter: savedFieldFilter,
              );
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintText: l10n.quranSearchHint,
              suffixIcon: IconButton(
                onPressed: () {
                  _searchController.clear();
                  ref.read(quranSearchQueryProvider.notifier).state = '';
                  _syncRoute(
                    query: '',
                    searchType: searchType,
                    fieldFilter: fieldFilter,
                  );
                },
                icon: const Icon(Icons.close, size: 18),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SegmentedPillControl<QuranSearchType>(
          items: QuranSearchType.values,
          selectedItem: searchType,
          labelBuilder: (item) => _searchTypeLabel(l10n, item),
          onChanged: (item) {
            ref.read(quranSearchTypeProvider.notifier).state = item;
            _syncRoute(
              query: query,
              searchType: item,
              fieldFilter: item == QuranSearchType.text
                  ? fieldFilter
                  : QuranSearchFieldFilter.all,
            );
          },
        ),
        const SizedBox(height: 12),
        if (searchType == QuranSearchType.text) ...[
          SegmentedPillControl<QuranSearchFieldFilter>(
            items: QuranSearchFieldFilter.values,
            selectedItem: fieldFilter,
            labelBuilder: (item) => _filterLabel(l10n, item),
            onChanged: (item) {
              ref.read(quranSearchFieldFilterProvider.notifier).state = item;
              _syncRoute(
                query: query,
                searchType: searchType,
                fieldFilter: item,
              );
            },
          ),
          const SizedBox(height: 12),
        ],
        if (trimmedQuery.isNotEmpty)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                if (isSavedSearch) {
                  ref
                      .read(quranSavedSearchesProvider.notifier)
                      .remove(
                        trimmedQuery,
                        fieldFilter: effectiveSavedFieldFilter,
                      );
                  return;
                }
                ref
                    .read(quranSavedSearchesProvider.notifier)
                    .save(trimmedQuery, fieldFilter: effectiveSavedFieldFilter);
              },
              icon: Icon(
                isSavedSearch
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_add_outlined,
                size: 18,
              ),
              label: Text(
                isSavedSearch
                    ? l10n.quranSearchSavedAction
                    : l10n.quranSearchSaveAction,
              ),
            ),
          ),
        if (trimmedQuery.isNotEmpty) const SizedBox(height: 12),
        if (query.trim().isEmpty) ...[
          if (saved.isNotEmpty)
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.quranSavedSearches,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: saved
                        .map<Widget>(
                          (item) => InputChip(
                            label: Text(item.query),
                            onPressed: () => runStoredSearch(item),
                            onDeleted: () => ref
                                .read(quranSavedSearchesProvider.notifier)
                                .remove(
                                  item.query,
                                  fieldFilter: item.fieldFilter,
                                ),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ],
              ),
            ),
          if (saved.isNotEmpty) const SizedBox(height: 12),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quranRecentSearches,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                if (recent.isEmpty)
                  Text(l10n.quranSearchNoRecent)
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: recent
                        .map(
                          (item) => _SearchPill(
                            label: item.query,
                            onTap: () => runStoredSearch(item),
                          ),
                        )
                        .toList(),
                  ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () =>
                      ref.read(quranRecentSearchesProvider.notifier).clear(),
                  child: Text(l10n.quranClearRecent),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quranSuggestedSearches,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: suggestions
                      .map(
                        (item) => _SearchPill(
                          label: item.query,
                          onTap: () => runStoredSearch(item),
                        ),
                      )
                      .toList(growable: false),
                ),
              ],
            ),
          ),
        ] else if (isLoadingVisibleResults) ...[
          const PremiumCard(
            child: Center(child: CircularProgressIndicator.adaptive()),
          ),
        ] else if (!hasVisibleResults) ...[
          PremiumCard(child: Text(l10n.quranSearchNoResults)),
        ] else ...[
          if ((searchType == QuranSearchType.all ||
                  searchType == QuranSearchType.text) &&
              textResults.isNotEmpty)
            _SearchSection(
              title: _searchTypeLabel(l10n, QuranSearchType.text),
              children: textResults
                  .map(
                    (result) => _TextSearchResultTile(
                      result: result,
                      onTap: () {
                        ref
                            .read(quranRecentSearchesProvider.notifier)
                            .addSearch(
                              query,
                              fieldFilter: searchType == QuranSearchType.text
                                  ? fieldFilter
                                  : QuranSearchFieldFilter.all,
                            );
                        openQuranReaderLocation(
                          context,
                          surahNumber: result.surah.number,
                          ayahNumber: result.ayah?.ayahNumber,
                          searchQuery: query,
                          searchMatchField: result.matchField,
                        );
                      },
                    ),
                  )
                  .toList(growable: false),
            ),
          if ((searchType == QuranSearchType.all ||
                  searchType == QuranSearchType.theme) &&
              themeResults.isNotEmpty)
            _SearchSection(
              title: _searchTypeLabel(l10n, QuranSearchType.theme),
              children: themeResults
                  .map(
                    (result) => _SupplementalSearchResultTile(
                      result: result,
                      onTap: () {
                        ref
                            .read(quranRecentSearchesProvider.notifier)
                            .addSearch(query, fieldFilter: fieldFilter);
                        result.open(context);
                      },
                    ),
                  )
                  .toList(growable: false),
            ),
          if ((searchType == QuranSearchType.all ||
                  searchType == QuranSearchType.topic) &&
              topicResults.isNotEmpty)
            _SearchSection(
              title: _searchTypeLabel(l10n, QuranSearchType.topic),
              children: topicResults
                  .map(
                    (result) => _SupplementalSearchResultTile(
                      result: result,
                      onTap: () {
                        ref
                            .read(quranRecentSearchesProvider.notifier)
                            .addSearch(query, fieldFilter: fieldFilter);
                        result.open(context);
                      },
                    ),
                  )
                  .toList(growable: false),
            ),
          if ((searchType == QuranSearchType.all ||
                  searchType == QuranSearchType.surah) &&
              surahResults.isNotEmpty)
            _SearchSection(
              title: _searchTypeLabel(l10n, QuranSearchType.surah),
              children: surahResults
                  .map(
                    (result) => _SupplementalSearchResultTile(
                      result: result,
                      onTap: () {
                        ref
                            .read(quranRecentSearchesProvider.notifier)
                            .addSearch(query, fieldFilter: fieldFilter);
                        result.open(context);
                      },
                    ),
                  )
                  .toList(growable: false),
            ),
        ],
      ],
    );
  }
}

class _SearchSection extends StatelessWidget {
  const _SearchSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _TextSearchResultTile extends StatelessWidget {
  const _TextSearchResultTile({required this.result, required this.onTap});

  final QuranSearchResult result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(
        result.ayah == null
            ? result.surah.transliteratedName
            : '${result.surah.transliteratedName} ${result.ayah!.ayahNumber}',
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: _SearchResultSubtitle(result: result),
      isThreeLine: result.ayah != null || result.reference != null,
      onTap: onTap,
    );
  }
}

class _SearchPill extends StatelessWidget {
  const _SearchPill({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppLayeredGlassPillButton(
      onPressed: onTap,
      label: label,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      foregroundColor: Theme.of(context).textTheme.bodySmall?.color,
    );
  }
}

class _SearchResultSubtitle extends StatelessWidget {
  const _SearchResultSubtitle({required this.result});

  final QuranSearchResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lines = <Widget>[];
    final ayah = result.ayah;
    final showContextTranslation =
        result.reference == null &&
        (result.matchField == QuranSearchMatchField.arabic ||
            result.matchField == QuranSearchMatchField.transliteration) &&
        (ayah?.translation.trim().isNotEmpty ?? false);

    lines.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: _MatchTypePill(label: _matchTypeLabel(l10n, result.matchField)),
      ),
    );

    if (ayah != null &&
        ayah.arabic.trim().isNotEmpty &&
        result.matchField == QuranSearchMatchField.arabic) {
      lines.add(
        QuranSearchHighlightedText(
          text: result.snippetText,
          highlightTerms: result.highlightTerms,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontFamily: AppFonts.quranArabic),
        ),
      );
    }
    if (ayah != null &&
        (ayah.transliteration ?? '').trim().isNotEmpty &&
        result.matchField == QuranSearchMatchField.transliteration) {
      lines.add(
        QuranSearchHighlightedText(
          text: result.snippetText,
          highlightTerms: result.highlightTerms,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
    lines.add(
      showContextTranslation
          ? Text(
              ayah!.translation,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          : QuranSearchHighlightedText(
              text: result.reference == null
                  ? result.snippetText
                  : '${result.matchText}\n${result.connectedKnowledgeCount} connected links • ${result.knowledgeHint ?? 'knowledge graph'}',
              highlightTerms: result.reference == null
                  ? result.highlightTerms
                  : const <String>[],
              maxLines: result.reference == null ? 2 : 3,
              overflow: TextOverflow.ellipsis,
            ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: lines,
    );
  }
}

class _MatchTypePill extends StatelessWidget {
  const _MatchTypePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.18),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class _SupplementalSearchResultTile extends StatelessWidget {
  const _SupplementalSearchResultTile({
    required this.result,
    required this.onTap,
  });

  final _QuranSupplementalSearchResult result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(
        result.title,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        '${result.supportingLabel}\n${result.summary}',
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      isThreeLine: true,
      onTap: onTap,
    );
  }
}

class _QuranSupplementalSearchResult {
  const _QuranSupplementalSearchResult({
    required this.score,
    required this.title,
    required this.summary,
    required this.supportingLabel,
    required this.open,
  });

  final int score;
  final String title;
  final String summary;
  final String supportingLabel;
  final void Function(BuildContext context) open;
}

String _filterLabel(AppLocalizations l10n, QuranSearchFieldFilter filter) {
  switch (filter) {
    case QuranSearchFieldFilter.all:
      return l10n.quranSearchFilterAll;
    case QuranSearchFieldFilter.translation:
      return l10n.quranSearchFilterTranslation;
    case QuranSearchFieldFilter.transliteration:
      return l10n.quranSearchFilterTransliteration;
    case QuranSearchFieldFilter.arabic:
      return l10n.quranSearchFilterArabic;
    case QuranSearchFieldFilter.surah:
      return l10n.quranSearchFilterSurah;
  }
}

String _searchTypeLabel(AppLocalizations l10n, QuranSearchType type) {
  switch (type) {
    case QuranSearchType.all:
      return l10n.quranSearchTypeAll;
    case QuranSearchType.text:
      return l10n.quranSearchTypeText;
    case QuranSearchType.theme:
      return l10n.quranSearchTypeTheme;
    case QuranSearchType.topic:
      return l10n.quranSearchTypeTopic;
    case QuranSearchType.surah:
      return l10n.quranSearchTypeSurah;
  }
}

String _matchTypeLabel(AppLocalizations l10n, QuranSearchMatchField field) {
  switch (field) {
    case QuranSearchMatchField.translation:
      return l10n.quranSearchMatchTranslation;
    case QuranSearchMatchField.transliteration:
      return l10n.quranSearchMatchTransliteration;
    case QuranSearchMatchField.arabic:
      return l10n.quranSearchMatchArabic;
    case QuranSearchMatchField.surah:
      return l10n.quranSearchMatchSurah;
  }
}

List<_QuranSupplementalSearchResult> _buildTopicResults({
  required String query,
  required AppLocalizations l10n,
  required List<QuranAyahEnrichmentEntry> entries,
  required List<QuranAyahInsightResolvedPath> paths,
  required List<QuranResolvedSurahInsight> surahInsights,
  required Map<int, QuranSurah> surahMap,
}) {
  final output = <_QuranSupplementalSearchResult>[];

  for (final entry in entries) {
    final surah = surahMap[entry.ref.surah];
    final haystack = combineQuranSearchFields([
      entry.title,
      entry.summary,
      entry.body,
      entry.ref.locationLabel,
      surah?.transliteratedName ?? '',
      surah?.englishName ?? '',
      surah?.arabicName ?? '',
      entry.tags.map((tag) => tag.name).join(' '),
      entry.lessonType.name,
      entry.domain.name,
    ]);
    final score = _scoreSearchMatch(
      query: query,
      title: entry.title,
      supporting: '${entry.ref.locationLabel} ${entry.domain.name}',
      haystack: haystack,
    );
    if (score == 0) continue;
    output.add(
      _QuranSupplementalSearchResult(
        score: score,
        title: entry.title,
        summary: entry.summary,
        supportingLabel: '${entry.ref.locationLabel} • ${entry.domain.name}',
        open: (context) => openQuranReferenceLocation(context, ref: entry.ref),
      ),
    );
  }

  for (final resolvedPath in paths) {
    final haystack = combineQuranSearchFields([
      resolvedPath.path.id,
      resolvedPath.entries.map((entry) => entry.title).join(' '),
      resolvedPath.entries.map((entry) => entry.summary).join(' '),
      resolvedPath.entries.map((entry) => entry.ref.locationLabel).join(' '),
      resolvedPath.path.domain.name,
    ]);
    final score = _scoreSearchMatch(
      query: query,
      title: resolvedPath.path.id,
      supporting: resolvedPath.path.domain.name,
      haystack: haystack,
    );
    if (score == 0) continue;
    output.add(
      _QuranSupplementalSearchResult(
        score: score,
        title: _formatSearchLabel(resolvedPath.path.id),
        summary: resolvedPath.entries.first.summary,
        supportingLabel:
            '${resolvedPath.path.domain.name} • ${l10n.quranAyahInsightPathsCount(resolvedPath.count)}',
        open: (context) => context.pushNamed(
          'quranAyahInsightsPathDetail',
          pathParameters: {'pathId': resolvedPath.path.id},
        ),
      ),
    );
  }

  for (final insight in surahInsights) {
    final haystack = combineQuranSearchFields([
      insight.surah.transliteratedName,
      insight.surah.englishName,
      insight.surah.arabicName,
      '${insight.surah.number}',
      insight.clusters
          .map((cluster) => cluster.entries.first.summary)
          .join(' '),
      insight.clusters
          .expand((cluster) => cluster.entries.map((entry) => entry.title))
          .join(' '),
    ]);
    final score = _scoreSearchMatch(
      query: query,
      title:
          '${insight.surah.transliteratedName} ${insight.surah.englishName} ${insight.surah.arabicName}',
      supporting: 'surah ${insight.surah.number}',
      haystack: haystack,
    );
    if (score == 0) continue;
    output.add(
      _QuranSupplementalSearchResult(
        score: score,
        title:
            '${insight.surah.transliteratedName} • ${insight.surah.arabicName}',
        summary: insight.clusters.first.entries.first.summary,
        supportingLabel: insight.surah.englishName,
        open: (context) => context.pushNamed(
          'quranSurahInsights',
          pathParameters: {'surahNumber': insight.surah.number.toString()},
        ),
      ),
    );
  }

  output.sort((a, b) {
    final byScore = b.score.compareTo(a.score);
    if (byScore != 0) return byScore;
    return a.title.compareTo(b.title);
  });
  return output.take(12).toList(growable: false);
}

List<_QuranSupplementalSearchResult> _buildThemeResults({
  required String query,
  required AppLocalizations l10n,
  required List<QuranThemeResolvedTopic> topics,
}) {
  final output = <_QuranSupplementalSearchResult>[];

  for (final topic in topics) {
    final localizedTitle = topic.definition.title;
    final localizedDescription = topic.definition.subtitle;
    final haystack = combineQuranSearchFields([
      localizedTitle,
      localizedDescription,
      topic.definition.overview,
      topic.definition.searchAliases.join(' '),
      topic.relatedProphets.map((item) => item.label).join(' '),
      topic.relatedEvents.map((item) => item.label).join(' '),
      topic.relatedSurahs.map((item) => item.transliteratedName).join(' '),
    ]);
    final score = _scoreSearchMatch(
      query: query,
      title: localizedTitle,
      supporting: localizedDescription,
      haystack: haystack,
    );
    if (score == 0) continue;
    output.add(
      _QuranSupplementalSearchResult(
        score: score,
        title: localizedTitle,
        summary: localizedDescription,
        supportingLabel: l10n.quranThemeDiscoverySurahCountLabel(
          topic.relatedSurahs.length,
        ),
        open: (context) => context.pushNamed(
          'quranTopicDetail',
          pathParameters: {'topicId': topic.definition.id},
        ),
      ),
    );
  }

  output.sort((a, b) {
    final byScore = b.score.compareTo(a.score);
    if (byScore != 0) return byScore;
    return a.title.compareTo(b.title);
  });
  return output.take(8).toList(growable: false);
}

List<_QuranSupplementalSearchResult> _buildSurahResults({
  required String query,
  required AppLocalizations l10n,
  required List<QuranSurah> surahs,
}) {
  final normalized = normalizeQuranSearchText(query);
  final normalizedArabic = normalizeQuranArabicSearchText(query);
  final output = <_QuranSupplementalSearchResult>[];

  for (final surah in surahs) {
    final haystack = combineQuranSearchFields([
      surah.transliteratedName,
      surah.englishName,
      surah.arabicName,
      'surah ${surah.number}',
      '${surah.number}',
    ]);
    final score = _scoreSearchMatch(
      query: normalized,
      title:
          '${surah.transliteratedName} ${surah.englishName} ${surah.arabicName}',
      supporting: 'surah ${surah.number}',
      haystack: haystack,
    );
    final matchesArabic =
        normalizedArabic.isNotEmpty &&
        normalizeQuranArabicSearchText(
          surah.arabicName,
        ).contains(normalizedArabic);
    if (score == 0 && !matchesArabic) continue;
    output.add(
      _QuranSupplementalSearchResult(
        score: score == 0 ? 120 : score,
        title: '${surah.transliteratedName} • ${surah.arabicName}',
        summary: surah.englishName,
        supportingLabel: l10n.quranShortSurahsAyahCountValue(surah.verseCount),
        open: (context) =>
            openQuranReaderLocation(context, surahNumber: surah.number),
      ),
    );
  }

  output.sort((a, b) {
    final byScore = b.score.compareTo(a.score);
    if (byScore != 0) return byScore;
    return a.title.compareTo(b.title);
  });
  return output.take(8).toList(growable: false);
}

int _scoreSearchMatch({
  required String query,
  required String title,
  required String supporting,
  required String haystack,
}) {
  if (query.isEmpty) return 0;
  final normalizedTitle = normalizeQuranSearchText(title);
  final normalizedSupporting = normalizeQuranSearchText(supporting);
  final normalizedHaystack = normalizeQuranSearchText(haystack);
  final tokens = query.split(' ').where((token) => token.isNotEmpty).toList();
  if (tokens.isEmpty) return 0;

  final queryContained = normalizedHaystack.contains(query);
  final matchedTokens = tokens
      .where((token) => normalizedHaystack.contains(token))
      .length;
  if (!queryContained && matchedTokens < tokens.length) return 0;

  var score = 0;
  if (normalizedTitle == query) score += 160;
  if (normalizedSupporting == query) score += 120;
  if (normalizedTitle.contains(query)) score += 100;
  if (normalizedSupporting.contains(query)) score += 70;
  if (queryContained) score += 40;
  score += matchedTokens * 12;
  return score;
}

String _formatSearchLabel(String value) {
  return value
      .split('-')
      .where((part) => part.isNotEmpty)
      .map(
        (part) => '${part.substring(0, 1).toUpperCase()}${part.substring(1)}',
      )
      .join(' ');
}
