import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/seeded_prophets_data.dart';
import '../domain/prophet_entry.dart';

abstract class ProphetsRepository {
  const ProphetsRepository();

  List<ProphetEntry> all();
  ProphetEntry? byId(String id);
}

class SeededProphetsRepository extends ProphetsRepository {
  const SeededProphetsRepository();

  @override
  List<ProphetEntry> all() {
    final list = [...seededProphets];
    list.sort((a, b) {
      final order = a.timelineOrder.compareTo(b.timelineOrder);
      if (order != 0) return order;
      return a.sortOrder.compareTo(b.sortOrder);
    });
    return list;
  }

  @override
  ProphetEntry? byId(String id) {
    for (final item in seededProphets) {
      if (item.id == id) return item;
    }
    return null;
  }
}

final prophetsRepositoryProvider = Provider<ProphetsRepository>((ref) {
  return const SeededProphetsRepository();
});

final prophetsProvider = Provider<List<ProphetEntry>>((ref) {
  return ref.watch(prophetsRepositoryProvider).all();
});

final prophetsByIdProvider = Provider<Map<String, ProphetEntry>>((ref) {
  final map = <String, ProphetEntry>{};
  for (final item in ref.watch(prophetsProvider)) {
    map[item.id] = item;
  }
  return map;
});
