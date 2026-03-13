import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/dua_models.dart';

const _duaAssetPath = 'assets/data/duas/dua_master_dataset_scaffold_v0_2.json';

final duaDatasetProvider = FutureProvider<DuaDataset>((ref) async {
  final raw = await rootBundle.loadString(_duaAssetPath);
  final decoded = jsonDecode(raw);
  if (decoded is! Map<String, dynamic>) {
    throw const FormatException('Invalid dua dataset payload.');
  }
  return DuaDataset.fromJson(decoded);
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
