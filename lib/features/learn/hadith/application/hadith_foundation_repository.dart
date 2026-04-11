import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../../editorial_dashboard/application/editorial_content_versions_provider.dart';
import '../data/hadith_taxonomy.dart';
import '../data/seeded_hadith_foundation_data.dart';
import '../domain/hadith_foundation_models.dart';
import '../domain/hadith_source_browse_models.dart';
import 'hadith_public_content_policy.dart';

const _savedHadithKey = 'learn.hadith.saved.v2';

final hadithAllEntriesProvider = Provider<List<HadithEntry>>((ref) {
  final entries = ref.watch(editorialHadithEntriesProvider);
  return entries.map(_normalizeHadithEntry).toList(growable: false);
});

final hadithPublicEntriesProvider = Provider<List<HadithEntry>>((ref) {
  final entries = ref.watch(hadithAllEntriesProvider);
  final policy = ref.watch(hadithPublicContentPolicyProvider);
  return entries
      .where(policy.allowsDefaultPublicSurfacing)
      .toList(growable: false);
});

final hadithEntriesProvider = Provider<List<HadithEntry>>(
  (ref) => ref.watch(hadithPublicEntriesProvider),
);

final hadithThemesProvider = Provider<List<HadithTheme>>((ref) {
  final publicIds = ref
      .watch(hadithEntriesProvider)
      .map((entry) => entry.id)
      .toSet();
  return seededHadithThemes
      .where((theme) => theme.hadithIds.any(publicIds.contains))
      .toList(growable: false);
});

final hadithCollectionsProvider = Provider<List<HadithCollection>>((ref) {
  final publicIds = ref
      .watch(hadithEntriesProvider)
      .map((entry) => entry.id)
      .toSet();
  return seededHadithCollections
      .where((collection) => collection.hadithIds.any(publicIds.contains))
      .toList(growable: false);
});

final hadithCategoriesProvider = Provider<List<HadithCategory>>((ref) {
  final usedCategoryIds = ref
      .watch(hadithEntriesProvider)
      .map((entry) => entry.normalizedCategoryId)
      .whereType<String>()
      .toSet();
  return seededHadithCategories
      .where((category) => usedCategoryIds.contains(category.id))
      .toList(growable: false);
});

final hadithSubcategoriesProvider = Provider<List<HadithSubcategory>>((ref) {
  final usedSubcategoryIds = ref
      .watch(hadithEntriesProvider)
      .map((entry) => entry.normalizedSubcategoryId)
      .whereType<String>()
      .toSet();
  return seededHadithSubcategories
      .where((subcategory) => usedSubcategoryIds.contains(subcategory.id))
      .toList(growable: false);
});

final hadithAllEntryByIdProvider = Provider.family<HadithEntry?, String>((
  ref,
  id,
) {
  final entries = ref.watch(hadithAllEntriesProvider);
  for (final entry in entries) {
    if (entry.id == id) return entry;
  }
  return null;
});

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

final hadithCollectionByIdProvider = Provider.family<HadithCollection?, String>(
  (ref, id) {
    final collections = ref.watch(hadithCollectionsProvider);
    for (final collection in collections) {
      if (collection.id == id) return collection;
    }
    return null;
  },
);

final hadithCategoryByIdProvider = Provider.family<HadithCategory?, String>((
  ref,
  id,
) {
  final categories = ref.watch(hadithCategoriesProvider);
  for (final category in categories) {
    if (category.id == id) return category;
  }
  return null;
});

final hadithSubcategoryByIdProvider =
    Provider.family<HadithSubcategory?, String>((ref, id) {
      final subcategories = ref.watch(hadithSubcategoriesProvider);
      for (final subcategory in subcategories) {
        if (subcategory.id == id) return subcategory;
      }
      return null;
    });

final hadithEntryByIdProvider = Provider.family<HadithEntry?, String>((
  ref,
  id,
) {
  final entries = ref.watch(hadithEntriesProvider);
  for (final entry in entries) {
    if (entry.id == id) return entry;
  }
  return null;
});

final hadithEntriesForThemeProvider =
    Provider.family<List<HadithEntry>, String>((ref, themeId) {
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

final hadithEntriesForCategoryProvider =
    Provider.family<List<HadithEntry>, String>((ref, categoryId) {
      final entries = ref.watch(hadithEntriesProvider);
      return entries
          .where((entry) => entry.normalizedCategoryId == categoryId)
          .toList(growable: false);
    });

final hadithEntriesForSubcategoryProvider =
    Provider.family<List<HadithEntry>, String>((ref, subcategoryId) {
      final entries = ref.watch(hadithEntriesProvider);
      return entries
          .where((entry) => entry.normalizedSubcategoryId == subcategoryId)
          .toList(growable: false);
    });

final hadithSourceBrowseCollectionsProvider =
    Provider<List<HadithSourceBrowseCollection>>((ref) {
      final entries = ref.watch(hadithEntriesProvider);
      final groups = <String, List<HadithEntry>>{};
      for (final entry in entries) {
        final sourceId = entry.primarySourceCollectionId;
        if (sourceId == null || sourceId.trim().isEmpty) continue;
        groups.putIfAbsent(sourceId, () => <HadithEntry>[]).add(entry);
      }

      final collections = groups.entries.map((entry) {
        final sortedEntries = _sortHadithEntriesForBrowse(entry.value);
        final title = sortedEntries.first.primarySourceCollectionTitle;
        final chapterCount = _buildSourceBrowseChapters(sortedEntries).length;
        return HadithSourceBrowseCollection(
          id: entry.key,
          title: title,
          entryCount: sortedEntries.length,
          chapterCount: chapterCount,
        );
      }).toList(growable: false)
        ..sort((a, b) {
          final countCompare = b.entryCount.compareTo(a.entryCount);
          if (countCompare != 0) return countCompare;
          return a.title.compareTo(b.title);
        });
      return collections;
    });

final hadithSourceBrowseCollectionByIdProvider =
    Provider.family<HadithSourceBrowseCollection?, String>((ref, sourceId) {
      final collections = ref.watch(hadithSourceBrowseCollectionsProvider);
      for (final collection in collections) {
        if (collection.id == sourceId) return collection;
      }
      return null;
    });

final hadithEntriesForSourceCollectionProvider =
    Provider.family<List<HadithEntry>, String>((ref, sourceId) {
      final entries = ref.watch(hadithEntriesProvider);
      return _sortHadithEntriesForBrowse(
        entries
            .where((entry) => entry.primarySourceCollectionId == sourceId)
            .toList(growable: false),
      );
    });

final hadithSourceBrowseChaptersProvider =
    Provider.family<List<HadithSourceBrowseChapter>, String>((ref, sourceId) {
      final entries = ref.watch(hadithEntriesForSourceCollectionProvider(sourceId));
      return _buildSourceBrowseChapters(entries);
    });

final hadithSourceBrowseChapterByIdProvider =
    Provider.family<HadithSourceBrowseChapter?, ({String sourceId, String chapterId})>((
      ref,
      args,
    ) {
      final chapters = ref.watch(hadithSourceBrowseChaptersProvider(args.sourceId));
      for (final chapter in chapters) {
        if (chapter.id == args.chapterId) return chapter;
      }
      return null;
    });

final hadithEntriesForSourceChapterProvider =
    Provider.family<List<HadithEntry>, ({String sourceId, String chapterId})>((
      ref,
      args,
    ) {
      final entries = ref.watch(hadithEntriesForSourceCollectionProvider(args.sourceId));
      final hasMeaningfulChapters = entries.any(_hasMeaningfulChapterMetadata);
      return _sortHadithEntriesForBrowse(
        entries.where((entry) {
          final bucket = _browseChapterBucketForEntry(
            entry,
            hasMeaningfulChapters: hasMeaningfulChapters,
          );
          return bucket.id == args.chapterId;
        }).toList(growable: false),
      );
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

HadithEntry _normalizeHadithEntry(HadithEntry entry) {
  final taxonomy = resolveHadithTaxonomyAssignment(entry);
  return entry.copyWith(
    sourceCollectionIds: entry.normalizedSourceCollections
        .map((item) => item.id)
        .toList(growable: false),
    sourceCollectionId: entry.primarySourceCollectionId,
    sourceCollectionTitle: entry.primarySourceCollectionTitle,
    sourceChapterId: entry.normalizedSourceChapterId,
    sourceChapterTitle: entry.normalizedSourceChapterTitle,
    sourceChapterNumber: entry.normalizedSourceChapterNumber,
    sourceHadithNumbers: entry.normalizedSourceHadithNumbers,
    sourceImportSource: entry.effectiveSourceImportSource,
    categoryId: taxonomy?.categoryId,
    categoryTitle: taxonomy?.categoryTitle,
    subcategoryId: taxonomy?.subcategoryId,
    subcategoryTitle: taxonomy?.subcategoryTitle,
  );
}

List<HadithEntry> _sortHadithEntriesForBrowse(List<HadithEntry> entries) {
  final next = List<HadithEntry>.from(entries);
  next.sort((a, b) {
    final chapterCompare = (a.normalizedSourceChapterNumber ?? 1 << 30)
        .compareTo(b.normalizedSourceChapterNumber ?? 1 << 30);
    if (chapterCompare != 0) return chapterCompare;

    final aHadith = int.tryParse(a.primaryHadithNumber ?? '') ?? (1 << 30);
    final bHadith = int.tryParse(b.primaryHadithNumber ?? '') ?? (1 << 30);
    final hadithCompare = aHadith.compareTo(bHadith);
    if (hadithCompare != 0) return hadithCompare;

    return a.title.compareTo(b.title);
  });
  return List<HadithEntry>.unmodifiable(next);
}

List<HadithSourceBrowseChapter> _buildSourceBrowseChapters(List<HadithEntry> entries) {
  if (entries.isEmpty) {
    return const <HadithSourceBrowseChapter>[];
  }
  final hasMeaningfulChapters = entries.any(_hasMeaningfulChapterMetadata);
  final groups = <String, _HadithBrowseChapterBucketState>{};
  for (final entry in entries) {
    final bucket = _browseChapterBucketForEntry(
      entry,
      hasMeaningfulChapters: hasMeaningfulChapters,
    );
    groups.update(
      bucket.id,
      (existing) => existing.copyWith(entryCount: existing.entryCount + 1),
      ifAbsent: () => _HadithBrowseChapterBucketState(
        id: bucket.id,
        title: bucket.title,
        number: bucket.number,
        kind: bucket.kind,
        entryCount: 1,
      ),
    );
  }

  final chapters = groups.values.map((bucket) {
    return HadithSourceBrowseChapter(
      id: bucket.id,
      title: bucket.title,
      number: bucket.number,
      entryCount: bucket.entryCount,
      kind: bucket.kind,
    );
  }).toList(growable: false)
    ..sort((a, b) {
      if (a.kind != b.kind) {
        if (a.kind == HadithSourceBrowseChapterKind.canonical) return -1;
        if (b.kind == HadithSourceBrowseChapterKind.canonical) return 1;
        if (a.kind == HadithSourceBrowseChapterKind.uncategorized) return -1;
        if (b.kind == HadithSourceBrowseChapterKind.uncategorized) return 1;
      }
      final aNumber = a.number ?? 1 << 30;
      final bNumber = b.number ?? 1 << 30;
      final numberCompare = aNumber.compareTo(bNumber);
      if (numberCompare != 0) return numberCompare;
      return a.title.compareTo(b.title);
    });
  return List<HadithSourceBrowseChapter>.unmodifiable(chapters);
}

bool _hasMeaningfulChapterMetadata(HadithEntry entry) {
  final chapterNumber = entry.normalizedSourceChapterNumber;
  if (chapterNumber != null) return true;

  final title = entry.normalizedSourceChapterTitle?.trim();
  final collectionTitle = entry.primarySourceCollectionTitle.trim();
  if (title == null || title.isEmpty) return false;
  if (title.toLowerCase() == collectionTitle.toLowerCase()) return false;
  return true;
}

_HadithBrowseChapterBucket _browseChapterBucketForEntry(
  HadithEntry entry, {
  required bool hasMeaningfulChapters,
}) {
  if (_hasMeaningfulChapterMetadata(entry)) {
    final title =
        entry.normalizedSourceChapterTitle ??
        entry.sourceMetadata.chapter?.title ??
        entry.displaySourceReference ??
        entry.title;
    final number = entry.normalizedSourceChapterNumber;
    final fallbackId = number != null
        ? 'chapter_$number'
        : _browseSlug(title.isEmpty ? entry.id : title);
    return _HadithBrowseChapterBucket(
      id: entry.normalizedSourceChapterId ?? fallbackId,
      title: title,
      number: number,
      kind: HadithSourceBrowseChapterKind.canonical,
    );
  }

  if (hasMeaningfulChapters) {
    return const _HadithBrowseChapterBucket(
      id: '_uncategorized',
      title: 'Uncategorized',
      number: null,
      kind: HadithSourceBrowseChapterKind.uncategorized,
    );
  }

  return const _HadithBrowseChapterBucket(
    id: '_general',
    title: 'General chapter',
    number: null,
    kind: HadithSourceBrowseChapterKind.general,
  );
}

class _HadithBrowseChapterBucket {
  const _HadithBrowseChapterBucket({
    required this.id,
    required this.title,
    required this.number,
    required this.kind,
  });

  final String id;
  final String title;
  final int? number;
  final HadithSourceBrowseChapterKind kind;
}

class _HadithBrowseChapterBucketState extends _HadithBrowseChapterBucket {
  const _HadithBrowseChapterBucketState({
    required super.id,
    required super.title,
    required super.number,
    required super.kind,
    required this.entryCount,
  });

  final int entryCount;

  _HadithBrowseChapterBucketState copyWith({int? entryCount}) {
    return _HadithBrowseChapterBucketState(
      id: id,
      title: title,
      number: number,
      kind: kind,
      entryCount: entryCount ?? this.entryCount,
    );
  }
}

String _browseSlug(String value) {
  final normalized = value.trim().toLowerCase();
  final slug = normalized.replaceAll(RegExp(r'[^a-z0-9]+'), '_');
  return slug.replaceAll(RegExp(r'^_+|_+$'), '');
}
