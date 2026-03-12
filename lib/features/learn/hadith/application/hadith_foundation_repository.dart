import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../data/seeded_hadith_foundation_data.dart';
import '../domain/hadith_foundation_models.dart';

const _savedHadithKey = 'learn.hadith.saved.v2';

final hadithThemesProvider = Provider<List<HadithTheme>>(
  (_) => seededHadithThemes,
);

final hadithCollectionsProvider = Provider<List<HadithCollection>>(
  (_) => seededHadithCollections,
);

final hadithEntriesProvider = Provider<List<HadithEntry>>(
  (_) => seededHadithEntries,
);

final hadithThemeByIdProvider = Provider.family<HadithTheme?, String>((
  ref,
  id,
) {
  final themes = ref.watch(hadithThemesProvider);
  for (final theme in themes) {
    if (theme.id == id) return theme;
  }
  return null;
});

final hadithCollectionByIdProvider = Provider.family<HadithCollection?, String>((
  ref,
  id,
) {
  final collections = ref.watch(hadithCollectionsProvider);
  for (final collection in collections) {
    if (collection.id == id) return collection;
  }
  return null;
});

final hadithEntryByIdProvider = Provider.family<HadithEntry?, String>((ref, id) {
  final entries = ref.watch(hadithEntriesProvider);
  for (final entry in entries) {
    if (entry.id == id) return entry;
  }
  return null;
});

final hadithEntriesForThemeProvider = Provider.family<List<HadithEntry>, String>((
  ref,
  themeId,
) {
  final entries = ref.watch(hadithEntriesProvider);
  return entries.where((entry) => entry.themeId == themeId).toList();
});

final hadithEntriesForCollectionProvider =
    Provider.family<List<HadithEntry>, String>((ref, collectionId) {
      final entries = ref.watch(hadithEntriesProvider);
      return entries
          .where((entry) => entry.collectionIds.contains(collectionId))
          .toList();
    });

class HadithSavedController extends StateNotifier<Set<String>> {
  HadithSavedController(this._store) : super(<String>{}) {
    _load();
  }

  final LocalStore _store;

  void _load() {
    final raw = _store.getJsonList(_savedHadithKey) ?? const <dynamic>[];
    state = raw.map((item) => item.toString()).toSet();
  }

  Future<void> _persist() async {
    await _store.setJsonList(_savedHadithKey, state.toList(growable: false));
  }

  bool isSaved(String hadithId) => state.contains(hadithId);

  Future<void> toggle(String hadithId) async {
    final next = Set<String>.from(state);
    if (next.contains(hadithId)) {
      next.remove(hadithId);
    } else {
      next.add(hadithId);
    }
    state = next;
    await _persist();
  }
}

final hadithSavedIdsProvider =
    StateNotifierProvider<HadithSavedController, Set<String>>((ref) {
      final store = ref.watch(localStoreProvider);
      return HadithSavedController(store);
    });

final savedHadithEntriesProvider = Provider<List<HadithEntry>>((ref) {
  final savedIds = ref.watch(hadithSavedIdsProvider);
  final entries = ref.watch(hadithEntriesProvider);
  return entries.where((entry) => savedIds.contains(entry.id)).toList();
});

