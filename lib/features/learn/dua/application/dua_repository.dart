import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/dua_seed_data.dart';
import '../domain/dua_models.dart';

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
