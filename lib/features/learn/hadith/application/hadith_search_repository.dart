import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../domain/hadith_foundation_models.dart';
import 'hadith_foundation_repository.dart';
import 'hadith_search_support.dart';

const _hadithRecentSearchesKey = 'learn.hadith.recentSearches.v1';
const _hadithRecentSearchesLimit = 8;

enum HadithSuggestedSearch {
  intentions,
  sincerity,
  mercy,
  repentance,
  dua,
  character,
  justice,
  gratitude,
}

final hadithSearchQueryProvider = StateProvider.autoDispose<String>((_) => '');

final hadithSearchFilterProvider =
    StateProvider.autoDispose<HadithSearchFilter>(
      (_) => HadithSearchFilter.all,
    );

class HadithStoredSearch {
  const HadithStoredSearch({
    required this.query,
    required this.filter,
    required this.updatedAtIso,
  });

  final String query;
  final HadithSearchFilter filter;
  final String updatedAtIso;

  Map<String, Object> toJson() => <String, Object>{
    'query': query,
    'filter': filter.wireValue,
    'updatedAtIso': updatedAtIso,
  };

  static HadithStoredSearch? fromJson(Map<String, dynamic> json) {
    final query = json['query']?.toString().trim() ?? '';
    if (query.isEmpty) return null;
    return HadithStoredSearch(
      query: query,
      filter: HadithSearchFilterX.fromWireValue(json['filter']?.toString()),
      updatedAtIso:
          json['updatedAtIso']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }
}

class HadithRecentSearchesNotifier
    extends StateNotifier<List<HadithStoredSearch>> {
  HadithRecentSearchesNotifier(this._store)
    : super(const <HadithStoredSearch>[]) {
    _load();
  }

  final LocalStore _store;

  void addSearch(
    String query, {
    HadithSearchFilter filter = HadithSearchFilter.all,
  }) {
    final trimmed = query.trim();
    final normalized = normalizeHadithSearchText(trimmed);
    if (trimmed.isEmpty || normalized.isEmpty) return;

    final nextEntry = HadithStoredSearch(
      query: trimmed,
      filter: filter,
      updatedAtIso: DateTime.now().toIso8601String(),
    );
    final next = <HadithStoredSearch>[
      nextEntry,
      ...state.where(
        (item) => normalizeHadithSearchText(item.query) != normalized,
      ),
    ].take(_hadithRecentSearchesLimit).toList(growable: false);
    state = next;
    _persist();
  }

  void removeSearch(String query) {
    final normalized = normalizeHadithSearchText(query);
    final next = state
        .where((item) => normalizeHadithSearchText(item.query) != normalized)
        .toList(growable: false);
    state = next;
    _persist();
  }

  void clear() {
    state = const <HadithStoredSearch>[];
    _store.remove(_hadithRecentSearchesKey);
  }

  void _persist() {
    if (state.isEmpty) {
      _store.remove(_hadithRecentSearchesKey);
      return;
    }
    _store.setJsonList(
      _hadithRecentSearchesKey,
      state.map((entry) => entry.toJson()).toList(growable: false),
    );
  }

  void _load() {
    final data = _store.getJsonList(_hadithRecentSearchesKey);
    if (data == null) return;

    final loaded = <HadithStoredSearch>[];
    for (final item in data) {
      if (item is String) {
        final query = item.trim();
        if (query.isNotEmpty) {
          loaded.add(
            HadithStoredSearch(
              query: query,
              filter: HadithSearchFilter.all,
              updatedAtIso: DateTime.now().toIso8601String(),
            ),
          );
        }
        continue;
      }
      final parsed = item is Map<String, dynamic>
          ? HadithStoredSearch.fromJson(item)
          : item is Map
          ? HadithStoredSearch.fromJson(
              item.map((key, value) => MapEntry(key.toString(), value)),
            )
          : null;
      if (parsed != null) {
        loaded.add(parsed);
      }
    }
    state = loaded.take(_hadithRecentSearchesLimit).toList(growable: false);
  }
}

final hadithRecentSearchesProvider =
    StateNotifierProvider<
      HadithRecentSearchesNotifier,
      List<HadithStoredSearch>
    >((ref) {
      final store = ref.watch(localStoreProvider);
      return HadithRecentSearchesNotifier(store);
    });

final hadithSuggestedSearchesProvider = Provider<List<HadithSuggestedSearch>>((
  ref,
) {
  return const <HadithSuggestedSearch>[
    HadithSuggestedSearch.intentions,
    HadithSuggestedSearch.sincerity,
    HadithSuggestedSearch.mercy,
    HadithSuggestedSearch.repentance,
    HadithSuggestedSearch.dua,
    HadithSuggestedSearch.character,
    HadithSuggestedSearch.justice,
    HadithSuggestedSearch.gratitude,
  ];
});

final hadithSearchRequestProvider = Provider.autoDispose<HadithSearchRequest>((
  ref,
) {
  final query = ref.watch(hadithSearchQueryProvider);
  final filter = ref.watch(hadithSearchFilterProvider);
  return HadithSearchRequest(query: query, filter: filter);
});

final hadithSearchResultsForRequestProvider =
    Provider.family<List<HadithSearchResolvedResult>, HadithSearchRequest>((
      ref,
      request,
    ) {
      final entries = ref.watch(hadithEntriesProvider);
      return searchHadithEntries(entries: entries, request: request);
    });

final hadithSearchResultsProvider =
    Provider.autoDispose<List<HadithSearchResolvedResult>>((ref) {
      final request = ref.watch(hadithSearchRequestProvider);
      return ref.watch(hadithSearchResultsForRequestProvider(request));
    });

final hadithSearchAvailableSourceTitlesProvider = Provider<List<String>>((ref) {
  final entries = ref.watch(hadithEntriesProvider);
  final values =
      entries
          .map((entry) => entry.displaySourceCollectionTitle)
          .where((value) => value.trim().isNotEmpty)
          .toSet()
          .toList(growable: false)
        ..sort();
  return values;
});

final hadithSearchAvailableCategoriesProvider = Provider<List<HadithCategory>>((
  ref,
) {
  return ref.watch(hadithCategoriesProvider);
});

final hadithSearchAvailableSubcategoriesProvider =
    Provider<List<HadithSubcategory>>((ref) {
      return ref.watch(hadithSubcategoriesProvider);
    });
