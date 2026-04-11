import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';
import '../../content_linking/application/editorial_relation_providers.dart';
import '../../content_linking/domain/editorial_relation_models.dart';
import '../../learn/dua/application/dua_repository.dart';
import '../../learn/hadith/application/hadith_search_repository.dart';
import '../../learn/hadith/application/hadith_search_support.dart';
import '../../learn/presentation/application/learn_discovery_providers.dart';
import '../../learn/quran/application/quran_providers.dart';

const _allSearchRecentQueriesKey = 'search.all.recentQueries.v1';
const _allSearchRecentQueriesLimit = 8;

enum AllSearchDomain { quran, hadith, dua, learn }

class AllSearchRequest {
  const AllSearchRequest({required this.query, this.maxResultsPerDomain = 4});

  final String query;
  final int maxResultsPerDomain;

  @override
  bool operator ==(Object other) {
    return other is AllSearchRequest &&
        other.query == query &&
        other.maxResultsPerDomain == maxResultsPerDomain;
  }

  @override
  int get hashCode => Object.hash(query, maxResultsPerDomain);
}

class AllSearchStoredQuery {
  const AllSearchStoredQuery({required this.query, required this.updatedAtIso});

  final String query;
  final String updatedAtIso;

  Map<String, Object> toJson() => <String, Object>{
    'query': query,
    'updatedAtIso': updatedAtIso,
  };

  static AllSearchStoredQuery? fromJson(Map<String, dynamic> json) {
    final query = json['query']?.toString().trim() ?? '';
    if (query.isEmpty) return null;
    return AllSearchStoredQuery(
      query: query,
      updatedAtIso:
          json['updatedAtIso']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }
}

class AllSearchResult {
  const AllSearchResult({
    required this.domain,
    required this.id,
    required this.title,
    required this.snippet,
    required this.highlightTerms,
    required this.routeName,
    this.subtitle,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
    this.relationLinks = const <AllSearchRelationPreview>[],
  });

  final AllSearchDomain domain;
  final String id;
  final String title;
  final String? subtitle;
  final String snippet;
  final List<String> highlightTerms;
  final String routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
  final List<AllSearchRelationPreview> relationLinks;
}

class AllSearchRelationPreview {
  const AllSearchRelationPreview({
    required this.domain,
    required this.title,
    required this.relationType,
  });

  final AllSearchDomain domain;
  final String title;
  final EditorialRelationType relationType;
}

class AllSearchGroupedResults {
  const AllSearchGroupedResults({required this.query, required this.sections});

  final String query;
  final List<AllSearchSection> sections;

  bool get isEmpty => sections.every((section) => section.results.isEmpty);
}

class AllSearchSection {
  const AllSearchSection({
    required this.domain,
    required this.results,
    required this.viewAllRouteName,
    this.viewAllPathParameters = const <String, String>{},
    this.viewAllQueryParameters = const <String, String>{},
  });

  final AllSearchDomain domain;
  final List<AllSearchResult> results;
  final String viewAllRouteName;
  final Map<String, String> viewAllPathParameters;
  final Map<String, String> viewAllQueryParameters;
}

enum AllSearchSuggestion {
  mercy,
  patience,
  intentions,
  repentance,
  dua,
  prophets,
  gratitude,
  justice,
}

final allSearchQueryProvider = StateProvider.autoDispose<String>((_) => '');

class AllSearchRecentQueriesNotifier
    extends StateNotifier<List<AllSearchStoredQuery>> {
  AllSearchRecentQueriesNotifier(this._store)
    : super(const <AllSearchStoredQuery>[]) {
    _load();
  }

  final LocalStore _store;

  void addQuery(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final normalized = trimmed.toLowerCase();
    final next = <AllSearchStoredQuery>[
      AllSearchStoredQuery(
        query: trimmed,
        updatedAtIso: DateTime.now().toIso8601String(),
      ),
      ...state.where((item) => item.query.trim().toLowerCase() != normalized),
    ].take(_allSearchRecentQueriesLimit).toList(growable: false);
    state = next;
    _persist();
  }

  void removeQuery(String query) {
    final normalized = query.trim().toLowerCase();
    state = state
        .where((item) => item.query.trim().toLowerCase() != normalized)
        .toList(growable: false);
    _persist();
  }

  void clear() {
    state = const <AllSearchStoredQuery>[];
    _store.remove(_allSearchRecentQueriesKey);
  }

  void _load() {
    final data = _store.getJsonList(_allSearchRecentQueriesKey);
    if (data == null) return;
    final loaded = <AllSearchStoredQuery>[];
    for (final item in data) {
      final parsed = item is Map<String, dynamic>
          ? AllSearchStoredQuery.fromJson(item)
          : item is Map
          ? AllSearchStoredQuery.fromJson(
              item.map((key, value) => MapEntry(key.toString(), value)),
            )
          : null;
      if (parsed != null) {
        loaded.add(parsed);
      }
    }
    state = loaded.take(_allSearchRecentQueriesLimit).toList(growable: false);
  }

  void _persist() {
    if (state.isEmpty) {
      _store.remove(_allSearchRecentQueriesKey);
      return;
    }
    _store.setJsonList(
      _allSearchRecentQueriesKey,
      state.map((item) => item.toJson()).toList(growable: false),
    );
  }
}

final allSearchRecentQueriesProvider =
    StateNotifierProvider<
      AllSearchRecentQueriesNotifier,
      List<AllSearchStoredQuery>
    >((ref) {
      final store = ref.watch(localStoreProvider);
      return AllSearchRecentQueriesNotifier(store);
    });

final allSearchSuggestionsProvider = Provider<List<AllSearchSuggestion>>((ref) {
  return const <AllSearchSuggestion>[
    AllSearchSuggestion.mercy,
    AllSearchSuggestion.patience,
    AllSearchSuggestion.intentions,
    AllSearchSuggestion.repentance,
    AllSearchSuggestion.dua,
    AllSearchSuggestion.prophets,
    AllSearchSuggestion.gratitude,
    AllSearchSuggestion.justice,
  ];
});

final allSearchRequestProvider = Provider.autoDispose<AllSearchRequest>((ref) {
  final query = ref.watch(allSearchQueryProvider);
  return AllSearchRequest(query: query);
});

final allSearchQuranResultsProvider =
    FutureProvider.family<List<AllSearchResult>, AllSearchRequest>((
      ref,
      request,
    ) async {
      final query = request.query.trim();
      if (query.isEmpty) return const <AllSearchResult>[];
      final quranResults = await ref.watch(
        quranTextSearchResultsProvider(
          QuranTextSearchQuery(
            query: query,
            maxResults: request.maxResultsPerDomain,
          ),
        ).future,
      );
      final output = <AllSearchResult>[];
      for (final result in quranResults) {
        final ayah = result.ayah;
        final queryParameters = <String, String>{};
        if (ayah != null) {
          queryParameters['ayah'] = ayah.ayahNumber.toString();
        }
        output.add(
          AllSearchResult(
            domain: AllSearchDomain.quran,
            id: ayah == null
                ? 'surah:${result.surah.number}'
                : 'ayah:${result.surah.number}:${ayah.ayahNumber}',
            title: ayah == null
                ? result.surah.transliteratedName
                : '${result.surah.transliteratedName} ${ayah.ayahNumber}',
            subtitle: '${result.surah.number}. ${result.surah.englishName}',
            snippet: result.snippetText,
            highlightTerms: result.highlightTerms,
            routeName: 'quranReader',
            pathParameters: {'surahNumber': result.surah.number.toString()},
            queryParameters: queryParameters,
            relationLinks: ayah == null
                ? const <AllSearchRelationPreview>[]
                : await _relationPreviewsForQuranVerse(
                    ref,
                    surahNumber: result.surah.number,
                    ayahNumber: ayah.ayahNumber,
                  ),
          ),
        );
      }
      return output;
    });

final allSearchHadithResultsProvider =
    Provider.family<List<AllSearchResult>, AllSearchRequest>((ref, request) {
      final query = request.query.trim();
      if (query.isEmpty) return const <AllSearchResult>[];
      final results = ref.watch(
        hadithSearchResultsForRequestProvider(
          HadithSearchRequest(
            query: query,
            maxResults: request.maxResultsPerDomain,
          ),
        ),
      );
      return results
          .map(
            (result) => AllSearchResult(
              domain: AllSearchDomain.hadith,
              id: result.entry.id,
              title: result.entry.title,
              subtitle: result.entry.displaySourceCollectionTitle,
              snippet: result.result.snippetText,
              highlightTerms: result.result.highlightTerms,
              routeName: 'hadithLessonDetail',
              pathParameters: {'lessonId': result.entry.id},
            ),
          )
          .toList(growable: false);
    });

final allSearchDuaResultsProvider =
    FutureProvider.family<List<AllSearchResult>, AllSearchRequest>((
      ref,
      request,
    ) async {
      final query = request.query.trim();
      if (query.isEmpty) return const <AllSearchResult>[];
      final results = await ref.watch(
        duaSearchResultsProvider(
          DuaSearchRequest(
            query: query,
            maxResults: request.maxResultsPerDomain,
          ),
        ).future,
      );
      return results
          .map(
            (result) => AllSearchResult(
              domain: AllSearchDomain.dua,
              id: result.item.id,
              title: result.item.title,
              subtitle: result.item.subcategoryLabel,
              snippet: result.snippet,
              highlightTerms: result.highlightTerms,
              routeName: 'learnDuaDetail',
              pathParameters: {'duaId': result.item.id},
            ),
          )
          .toList(growable: false);
    });

final allSearchLearnResultsProvider =
    Provider.family<List<AllSearchResult>, AllSearchRequest>((ref, request) {
      final query = request.query.trim();
      if (query.isEmpty) return const <AllSearchResult>[];
      final index = ref.watch(learnDiscoveryIndexProvider);
      final results = searchLearnDiscoveryEntries(
        entries: index,
        query: query,
      ).take(request.maxResultsPerDomain).toList(growable: false);
      return results
          .map(
            (result) => AllSearchResult(
              domain: AllSearchDomain.learn,
              id: result.entry.id,
              title: result.entry.title,
              subtitle: result.entry.subtitle,
              snippet: result.entry.summary,
              highlightTerms: result.matchedTerms.toList(growable: false),
              routeName: result.entry.routeTarget.routeName,
              pathParameters: result.entry.routeTarget.pathParameters,
              queryParameters: result.entry.routeTarget.queryParameters,
            ),
          )
          .toList(growable: false);
    });

final allSearchResultsForRequestProvider =
    FutureProvider.family<AllSearchGroupedResults, AllSearchRequest>((
      ref,
      request,
    ) async {
      final query = request.query.trim();
      final quran = await ref.watch(
        allSearchQuranResultsProvider(request).future,
      );
      final dua = await ref.watch(allSearchDuaResultsProvider(request).future);
      final hadith = ref.watch(allSearchHadithResultsProvider(request));
      final learn = ref.watch(allSearchLearnResultsProvider(request));

      return AllSearchGroupedResults(
        query: query,
        sections: <AllSearchSection>[
          AllSearchSection(
            domain: AllSearchDomain.quran,
            results: quran,
            viewAllRouteName: 'quranSearch',
            viewAllQueryParameters: {'q': query},
          ),
          AllSearchSection(
            domain: AllSearchDomain.hadith,
            results: hadith,
            viewAllRouteName: 'hadithSearch',
            viewAllQueryParameters: {'q': query},
          ),
          AllSearchSection(
            domain: AllSearchDomain.dua,
            results: dua,
            viewAllRouteName: 'learnDuaHub',
            viewAllQueryParameters: {'q': query},
          ),
          AllSearchSection(
            domain: AllSearchDomain.learn,
            results: learn,
            viewAllRouteName: 'learnExploreAllKnowledge',
            viewAllQueryParameters: {'q': query},
          ),
        ],
      );
    });

final allSearchResultsProvider =
    FutureProvider.autoDispose<AllSearchGroupedResults>((ref) async {
      final request = ref.watch(allSearchRequestProvider);
      return ref.watch(allSearchResultsForRequestProvider(request).future);
    });

Future<List<AllSearchRelationPreview>> _relationPreviewsForQuranVerse(
  Ref ref, {
  required int surahNumber,
  required int ayahNumber,
}) async {
  final links = await ref.watch(
    editorialResolvedLinksForQuranVerseProvider((
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    )).future,
  );
  return links
      .take(2)
      .map(
        (link) => AllSearchRelationPreview(
          domain: _domainFromEditorialDomain(link.domain),
          title: link.title,
          relationType: link.relationType,
        ),
      )
      .toList(growable: false);
}

AllSearchDomain _domainFromEditorialDomain(EditorialRelationDomain domain) {
  switch (domain) {
    case EditorialRelationDomain.quran:
      return AllSearchDomain.quran;
    case EditorialRelationDomain.hadith:
      return AllSearchDomain.hadith;
    case EditorialRelationDomain.dua:
      return AllSearchDomain.dua;
    case EditorialRelationDomain.worldCreation:
    case EditorialRelationDomain.learnContent:
      return AllSearchDomain.learn;
  }
}
