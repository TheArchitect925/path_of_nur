import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/dua_seed_data.dart';
import '../domain/dua_models.dart';

class DuaSearchRequest {
  const DuaSearchRequest({required this.query, this.maxResults = 20});

  final String query;
  final int maxResults;

  @override
  bool operator ==(Object other) {
    return other is DuaSearchRequest &&
        other.query == query &&
        other.maxResults == maxResults;
  }

  @override
  int get hashCode => Object.hash(query, maxResults);
}

class DuaSearchResolvedResult {
  const DuaSearchResolvedResult({
    required this.item,
    required this.snippet,
    required this.highlightTerms,
  });

  final DuaItem item;
  final String snippet;
  final List<String> highlightTerms;
}

final duaDatasetProvider = FutureProvider<DuaDataset>((ref) async {
  return duaSeedDataset;
});

final duaCategorySummariesProvider =
    Provider<AsyncValue<List<DuaCategorySummary>>>((ref) {
      final datasetAsync = ref.watch(duaDatasetProvider);
      return datasetAsync.whenData((dataset) {
        final byCategory = <String, List<DuaItem>>{};
        for (final item in dataset.items) {
          byCategory.putIfAbsent(item.category, () => <DuaItem>[]).add(item);
        }
        final summaries =
            byCategory.entries
                .map((entry) {
                  final bySubcategory = <String, List<DuaItem>>{};
                  var completeCount = 0;
                  var stubCount = 0;
                  final searchParts = <String>[
                    dataset.categoryLabel(entry.key),
                  ];
                  for (final item in entry.value) {
                    bySubcategory
                        .putIfAbsent(item.subcategory, () => <DuaItem>[])
                        .add(item);
                    if (item.completionStatus == DuaCompletionStatus.complete) {
                      completeCount += 1;
                    } else {
                      stubCount += 1;
                    }
                    searchParts.addAll(<String>[
                      item.title,
                      dataset.primaryCategoryLabel(
                        item.effectivePrimaryCategory,
                      ),
                      ...item.secondaryCategories.map(
                        dataset.primaryCategoryLabel,
                      ),
                      item.subcategoryLabel,
                      item.transliteration,
                      item.translation,
                      item.whenToSay,
                      ...item.tags,
                    ]);
                  }
                  final subcategories =
                      bySubcategory.entries
                          .map((subcategoryEntry) {
                            var subcategoryCompleteCount = 0;
                            var subcategoryStubCount = 0;
                            final subcategorySearchParts = <String>[
                              dataset.categoryLabel(entry.key),
                              _subcategoryLabel(subcategoryEntry.key),
                            ];
                            for (final item in subcategoryEntry.value) {
                              if (item.completionStatus ==
                                  DuaCompletionStatus.complete) {
                                subcategoryCompleteCount += 1;
                              } else {
                                subcategoryStubCount += 1;
                              }
                              subcategorySearchParts.addAll(<String>[
                                item.title,
                                dataset.primaryCategoryLabel(
                                  item.effectivePrimaryCategory,
                                ),
                                ...item.secondaryCategories.map(
                                  dataset.primaryCategoryLabel,
                                ),
                                item.transliteration,
                                item.translation,
                                item.whenToSay,
                                ...item.tags,
                              ]);
                            }
                            return DuaSubcategorySummary(
                              id: subcategoryEntry.key,
                              label: _subcategoryLabel(subcategoryEntry.key),
                              completeCount: subcategoryCompleteCount,
                              stubCount: subcategoryStubCount,
                              searchableText: _searchableText(
                                subcategorySearchParts,
                              ),
                            );
                          })
                          .toList(growable: false)
                        ..sort((a, b) {
                          final countComparison = b.completeCount.compareTo(
                            a.completeCount,
                          );
                          if (countComparison != 0) return countComparison;
                          return a.label.compareTo(b.label);
                        });
                  return DuaCategorySummary(
                    id: entry.key,
                    label: dataset.categoryLabel(entry.key),
                    completeCount: completeCount,
                    stubCount: stubCount,
                    searchableText: _searchableText(searchParts),
                    subcategories: subcategories,
                  );
                })
                .toList(growable: false)
              ..sort((a, b) {
                final countComparison = b.completeCount.compareTo(
                  a.completeCount,
                );
                if (countComparison != 0) return countComparison;
                return a.label.compareTo(b.label);
              });
        return summaries;
      });
    });

final duaItemByIdProvider = Provider.family<AsyncValue<DuaItem?>, String>((
  ref,
  duaId,
) {
  final datasetAsync = ref.watch(duaDatasetProvider);
  return datasetAsync.whenData((dataset) {
    for (final item in dataset.items) {
      if (item.id == duaId) return item;
    }
    return null;
  });
});

final duaSearchResultsProvider =
    FutureProvider.family<List<DuaSearchResolvedResult>, DuaSearchRequest>((
      ref,
      request,
    ) async {
      final query = request.query.trim();
      if (query.isEmpty) return const <DuaSearchResolvedResult>[];

      final dataset = await ref.watch(duaDatasetProvider.future);
      final normalizedQuery = _normalizeDuaSearchText(query);
      final matches = <DuaSearchResolvedResult>[];

      for (final item in dataset.verifiedItems) {
        final categoryLabel = dataset.categoryLabel(item.category);
        final primaryCategoryLabel = dataset.primaryCategoryLabel(
          item.effectivePrimaryCategory,
        );
        final secondaryCategoryLabels = item.secondaryCategories.map(
          dataset.primaryCategoryLabel,
        );

        if (!item.matchesQuery(
          normalizedQuery,
          categoryLabel: categoryLabel,
          primaryCategoryLabel: primaryCategoryLabel,
          secondaryCategoryLabels: secondaryCategoryLabels,
        )) {
          continue;
        }

        final presentation = _buildDuaSearchPresentation(
          item: item,
          normalizedQuery: normalizedQuery,
          categoryLabel: categoryLabel,
          primaryCategoryLabel: primaryCategoryLabel,
          secondaryCategoryLabels: secondaryCategoryLabels,
        );
        matches.add(
          DuaSearchResolvedResult(
            item: item,
            snippet: presentation.$1,
            highlightTerms: presentation.$2,
          ),
        );
      }

      matches.sort((a, b) {
        if (a.item.isCore != b.item.isCore) {
          return a.item.isCore ? -1 : 1;
        }
        return a.item.title.compareTo(b.item.title);
      });

      if (matches.length <= request.maxResults) {
        return List<DuaSearchResolvedResult>.unmodifiable(matches);
      }
      return List<DuaSearchResolvedResult>.unmodifiable(
        matches.take(request.maxResults),
      );
    });

String _subcategoryLabel(String raw) {
  return raw
      .split('_')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}

String _searchableText(Iterable<String> values) {
  return values
      .map((value) => value.trim().toLowerCase())
      .where((value) => value.isNotEmpty)
      .join(' ');
}

String _normalizeDuaSearchText(String value) {
  return value.trim().toLowerCase();
}

(String, List<String>) _buildDuaSearchPresentation({
  required DuaItem item,
  required String normalizedQuery,
  required String categoryLabel,
  required String primaryCategoryLabel,
  required Iterable<String> secondaryCategoryLabels,
}) {
  final candidates = <String>[
    item.title,
    item.translation,
    item.transliteration,
    item.arabic,
    item.sourceRef,
    categoryLabel,
    primaryCategoryLabel,
    ...secondaryCategoryLabels,
    item.subcategoryLabel,
    item.whenToSay,
  ];

  for (final candidate in candidates) {
    final normalizedCandidate = candidate.trim();
    if (normalizedCandidate.isEmpty) continue;
    if (_normalizeDuaSearchText(
      normalizedCandidate,
    ).contains(normalizedQuery)) {
      return (
        normalizedCandidate,
        _extractDuaHighlightTerms(
          query: normalizedQuery,
          sourceText: normalizedCandidate,
        ),
      );
    }
  }

  return (item.title, const <String>[]);
}

List<String> _extractDuaHighlightTerms({
  required String query,
  required String sourceText,
}) {
  final normalizedSource = _normalizeDuaSearchText(sourceText);
  final terms = query
      .split(RegExp(r'\s+'))
      .map(_normalizeDuaSearchText)
      .where((term) => term.isNotEmpty && normalizedSource.contains(term))
      .toSet()
      .toList(growable: false);
  return terms;
}
