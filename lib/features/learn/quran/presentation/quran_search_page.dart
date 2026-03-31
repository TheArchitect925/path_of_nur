import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_fonts.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../../../../shared/widgets/quran_navigation.dart';
import '../application/quran_ayah_enrichment_provider.dart';
import '../application/quran_providers.dart';
import '../application/quran_surah_insights_provider.dart';
import '../application/quran_theme_discovery_provider.dart';
import '../application/quran_words_provider.dart';
import '../domain/quran_ayah_enrichment_models.dart';
import '../domain/quran_core_word.dart';
import '../domain/quran_surah.dart';
import '../domain/quran_surah_insight_models.dart';
import '../domain/quran_theme_discovery_models.dart';

class QuranSearchPage extends ConsumerWidget {
  const QuranSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(quranSearchQueryProvider);
    final resultsAsync = ref.watch(quranSearchResultsProvider);
    final results = resultsAsync.asData?.value ?? const <QuranSearchResult>[];
    final recent = ref.watch(quranRecentSearchesProvider);
    final languageCode = Localizations.localeOf(context).languageCode;
    final entries = ref.watch(
      quranAyahEnrichmentEntriesForLanguageProvider(languageCode),
    );
    final paths = ref.watch(quranAyahInsightResolvedPathsProvider);
    final surahInsights = ref.watch(quranSurahInsightsBrowseProvider);
    final surahMap = ref.watch(quranSurahMapProvider);
    final topics = ref.watch(quranResolvedThemesProvider);
    final wordsAsync = ref.watch(quranCoreWordsProvider);
    final normalizedQuery = _normalizeForSearch(query);
    final learningResults = normalizedQuery.isEmpty
        ? const <_QuranSupplementalSearchResult>[]
        : _buildLearningResults(
            query: normalizedQuery,
            l10n: l10n,
            entries: entries,
            paths: paths,
            surahInsights: surahInsights,
            surahMap: surahMap,
          );
    final topicResults = normalizedQuery.isEmpty
        ? const <_QuranSupplementalSearchResult>[]
        : _buildTopicResults(
            query: normalizedQuery,
            l10n: l10n,
            topics: topics,
          );
    final wordResults = wordsAsync.maybeWhen(
      data: (words) => normalizedQuery.isEmpty
          ? const <_QuranSupplementalSearchResult>[]
          : _buildWordResults(query: normalizedQuery, words: words),
      orElse: () => const <_QuranSupplementalSearchResult>[],
    );
    final hasSupplementalResults =
        learningResults.isNotEmpty ||
        topicResults.isNotEmpty ||
        wordResults.isNotEmpty;
    final hasAnyResults = results.isNotEmpty || hasSupplementalResults;
    final isLoadingPrimaryResults =
        resultsAsync.isLoading && query.trim().isNotEmpty && results.isEmpty;

    return AppPageScaffold(
      headerIcon: Icons.search,
      title: l10n.quranSearchTitle,
      subtitle: l10n.quranSearchSubtitle,
      children: [
        PremiumCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: TextField(
            autofocus: true,
            onChanged: (value) =>
                ref.read(quranSearchQueryProvider.notifier).state = value,
            onSubmitted: (value) =>
                ref.read(quranRecentSearchesProvider.notifier).addSearch(value),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintText: l10n.quranSearchHint,
              suffixIcon: IconButton(
                onPressed: () =>
                    ref.read(quranSearchQueryProvider.notifier).state = '',
                icon: const Icon(Icons.close, size: 18),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (query.trim().isEmpty) ...[
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
                          (item) => ActionChip(
                            label: Text(item),
                            onPressed: () {
                              ref
                                      .read(quranSearchQueryProvider.notifier)
                                      .state =
                                  item;
                            },
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
        ] else if (isLoadingPrimaryResults) ...[
          const PremiumCard(
            child: Center(child: CircularProgressIndicator.adaptive()),
          ),
        ] else if (!hasAnyResults) ...[
          PremiumCard(child: Text(l10n.quranSearchNoResults)),
        ] else ...[
          if (results.isNotEmpty)
            _SearchSection(
              title: l10n.quranSearchTitle,
              children: results
                  .map(
                    (result) => _TextSearchResultTile(
                      result: result,
                      onTap: () {
                        ref
                            .read(quranRecentSearchesProvider.notifier)
                            .addSearch(query);
                        context.pushNamed(
                          'quranReader',
                          pathParameters: {
                            'surahNumber': result.surah.number.toString(),
                          },
                          queryParameters: result.ayah == null
                              ? const {}
                              : {'ayah': result.ayah!.ayahNumber.toString()},
                        );
                      },
                    ),
                  )
                  .toList(growable: false),
            ),
          if (learningResults.isNotEmpty)
            _SearchSection(
              title: l10n.quranKnowledgeSearchTitle,
              children: learningResults
                  .map(
                    (result) => _SupplementalSearchResultTile(
                      result: result,
                      onTap: () {
                        ref
                            .read(quranRecentSearchesProvider.notifier)
                            .addSearch(query);
                        result.open(context);
                      },
                    ),
                  )
                  .toList(growable: false),
            ),
          if (topicResults.isNotEmpty)
            _SearchSection(
              title: l10n.quranHubTopicsTitle,
              children: topicResults
                  .map(
                    (result) => _SupplementalSearchResultTile(
                      result: result,
                      onTap: () {
                        ref
                            .read(quranRecentSearchesProvider.notifier)
                            .addSearch(query);
                        result.open(context);
                      },
                    ),
                  )
                  .toList(growable: false),
            ),
          if (wordResults.isNotEmpty)
            _SearchSection(
              title: l10n.quranHubWordsTitle,
              children: wordResults
                  .map(
                    (result) => _SupplementalSearchResultTile(
                      result: result,
                      onTap: () {
                        ref
                            .read(quranRecentSearchesProvider.notifier)
                            .addSearch(query);
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

class _SearchResultSubtitle extends StatelessWidget {
  const _SearchResultSubtitle({required this.result});

  final QuranSearchResult result;

  @override
  Widget build(BuildContext context) {
    final lines = <Widget>[];
    final ayah = result.ayah;

    if (ayah != null && ayah.arabic.trim().isNotEmpty) {
      lines.add(
        Text(
          ayah.arabic,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: const TextStyle(fontFamily: AppFonts.quranArabic),
        ),
      );
    }
    if (ayah != null && (ayah.transliteration ?? '').trim().isNotEmpty) {
      lines.add(
        Text(
          ayah.transliteration!.trim(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
    lines.add(
      Text(
        result.reference == null
            ? result.matchText
            : '${result.matchText}\n${result.connectedKnowledgeCount} connected links • ${result.knowledgeHint ?? 'knowledge graph'}',
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

List<_QuranSupplementalSearchResult> _buildLearningResults({
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
    final haystack = _combineSearchFields([
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
    final haystack = _combineSearchFields([
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
    final haystack = _combineSearchFields([
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

List<_QuranSupplementalSearchResult> _buildTopicResults({
  required String query,
  required AppLocalizations l10n,
  required List<QuranThemeResolvedTopic> topics,
}) {
  final output = <_QuranSupplementalSearchResult>[];

  for (final topic in topics) {
    final localizedTitle = topic.definition.title;
    final localizedDescription = topic.definition.subtitle;
    final haystack = _combineSearchFields([
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

List<_QuranSupplementalSearchResult> _buildWordResults({
  required String query,
  required List<QuranCoreWord> words,
}) {
  final output = <_QuranSupplementalSearchResult>[];

  for (final word in words) {
    final haystack = _combineSearchFields([
      word.arabic,
      word.transliteration,
      word.meaning,
      word.rootLetters ?? '',
      word.meaningExpansion ?? '',
      '${word.occurrences}',
    ]);
    final score = _scoreSearchMatch(
      query: query,
      title: '${word.transliteration} ${word.arabic}',
      supporting: word.meaning,
      haystack: haystack,
    );
    if (score == 0) continue;
    output.add(
      _QuranSupplementalSearchResult(
        score: score,
        title: '${word.transliteration} • ${word.arabic}',
        summary: word.meaning,
        supportingLabel: word.hasRootLetters
            ? word.rootLetters!
            : word.transliteration,
        open: (context) => context.pushNamed(
          'quranTopWordDetail',
          pathParameters: {'rank': word.rank.toString()},
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

int _scoreSearchMatch({
  required String query,
  required String title,
  required String supporting,
  required String haystack,
}) {
  if (query.isEmpty) return 0;
  final normalizedTitle = _normalizeForSearch(title);
  final normalizedSupporting = _normalizeForSearch(supporting);
  final normalizedHaystack = _normalizeForSearch(haystack);
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

String _combineSearchFields(List<String> values) {
  return values.where((value) => value.trim().isNotEmpty).join(' ');
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

String _normalizeForSearch(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp(r'[^\p{L}\p{N}: ]', unicode: true), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}
