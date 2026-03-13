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
                  final subcategories = <String, int>{};
                  var completeCount = 0;
                  var stubCount = 0;
                  for (final item in entry.value) {
                    subcategories.update(
                      item.subcategoryLabel,
                      (count) => count + 1,
                      ifAbsent: () => 1,
                    );
                    if (item.completionStatus == DuaCompletionStatus.complete) {
                      completeCount += 1;
                    } else {
                      stubCount += 1;
                    }
                  }
                  return DuaCategorySummary(
                    id: entry.key,
                    label: dataset.categoryLabel(entry.key),
                    completeCount: completeCount,
                    stubCount: stubCount,
                    subcategories: subcategories,
                  );
                })
                .toList(growable: false)
              ..sort((a, b) => a.label.compareTo(b.label));
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
