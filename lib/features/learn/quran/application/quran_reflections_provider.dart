import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../domain/quran_content_refs.dart';
import '../domain/quran_reflection_entry.dart';

const _quranReflectionsKey = 'learn.quran.reflections.v1';

class QuranReflectionsNotifier
    extends StateNotifier<List<QuranReflectionEntry>> {
  QuranReflectionsNotifier(this._store) : super(const []) {
    _load();
  }

  final LocalStore _store;

  QuranReflectionEntry? findEntry({
    QuranQuoteRef? ref,
    String? sourceEnrichmentId,
    QuranReflectionSourceType? sourceType,
    String? sourceId,
  }) {
    for (final entry in state) {
      if (_matchesIdentity(
        entry,
        ref: ref,
        sourceEnrichmentId: sourceEnrichmentId,
        sourceType: sourceType,
        sourceId: sourceId,
      )) {
        return entry;
      }
    }
    return null;
  }

  bool isSaved({
    QuranQuoteRef? ref,
    String? sourceEnrichmentId,
    QuranReflectionSourceType? sourceType,
    String? sourceId,
  }) {
    return findEntry(
          ref: ref,
          sourceEnrichmentId: sourceEnrichmentId,
          sourceType: sourceType,
          sourceId: sourceId,
        ) !=
        null;
  }

  String save({
    QuranQuoteRef? ref,
    required QuranReflectionSourceType sourceType,
    required String title,
    required String summary,
    String? sourceEnrichmentId,
    String? sourceId,
    String? sourceLabel,
    int? surahNumber,
    String? themeId,
    String? pathwayId,
    String? pathwayStopId,
    String? promptLabel,
    String? routeName,
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    bool isFavorite = false,
    String? note,
    DateTime? now,
  }) {
    final timestamp = (now ?? DateTime.now()).toIso8601String();
    final existing = findEntry(
      ref: ref,
      sourceEnrichmentId: sourceEnrichmentId,
      sourceType: sourceType,
      sourceId: sourceId,
    );
    if (existing != null) {
      final updated = existing.copyWith(
        ref: ref,
        sourceType: sourceType,
        title: title.trim(),
        summary: summary.trim(),
        sourceId: sourceId,
        sourceLabel: sourceLabel,
        surahNumber: surahNumber,
        themeId: themeId,
        pathwayId: pathwayId,
        pathwayStopId: pathwayStopId,
        promptLabel: promptLabel,
        routeName: routeName,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        isFavorite: isFavorite || existing.isFavorite,
        note: _normalizedNote(note) ?? existing.note,
        updatedAtIso: timestamp,
      );
      _replace(updated);
      return updated.id;
    }

    final entry = QuranReflectionEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      ref: ref,
      sourceType: sourceType,
      title: title.trim(),
      summary: summary.trim(),
      sourceEnrichmentId: sourceEnrichmentId,
      sourceId: sourceId,
      sourceLabel: sourceLabel,
      surahNumber: surahNumber,
      themeId: themeId,
      pathwayId: pathwayId,
      pathwayStopId: pathwayStopId,
      promptLabel: promptLabel,
      routeName: routeName,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      isFavorite: isFavorite,
      note: _normalizedNote(note),
      savedAtIso: timestamp,
      updatedAtIso: timestamp,
    );
    state = [entry, ...state];
    _save();
    return entry.id;
  }

  bool toggleSaved({
    QuranQuoteRef? ref,
    required QuranReflectionSourceType sourceType,
    required String title,
    required String summary,
    String? sourceEnrichmentId,
    String? sourceId,
    String? sourceLabel,
    int? surahNumber,
    String? themeId,
    String? pathwayId,
    String? pathwayStopId,
    String? promptLabel,
    String? routeName,
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
  }) {
    final existing = findEntry(
      ref: ref,
      sourceEnrichmentId: sourceEnrichmentId,
      sourceType: sourceType,
      sourceId: sourceId,
    );
    if (existing != null) {
      removeById(existing.id);
      return false;
    }
    save(
      ref: ref,
      sourceType: sourceType,
      title: title,
      summary: summary,
      sourceEnrichmentId: sourceEnrichmentId,
      sourceId: sourceId,
      sourceLabel: sourceLabel,
      surahNumber: surahNumber,
      themeId: themeId,
      pathwayId: pathwayId,
      pathwayStopId: pathwayStopId,
      promptLabel: promptLabel,
      routeName: routeName,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
    );
    return true;
  }

  String upsertNote({
    QuranQuoteRef? ref,
    required QuranReflectionSourceType sourceType,
    required String title,
    required String summary,
    String? sourceEnrichmentId,
    String? sourceId,
    String? sourceLabel,
    int? surahNumber,
    String? themeId,
    String? pathwayId,
    String? pathwayStopId,
    String? promptLabel,
    String? routeName,
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    bool isFavorite = false,
    String? note,
    DateTime? now,
  }) {
    final existing = findEntry(
      ref: ref,
      sourceEnrichmentId: sourceEnrichmentId,
      sourceType: sourceType,
      sourceId: sourceId,
    );
    final normalized = _normalizedNote(note);
    if (existing == null) {
      return save(
        ref: ref,
        sourceType: sourceType,
        title: title,
        summary: summary,
        sourceEnrichmentId: sourceEnrichmentId,
        sourceId: sourceId,
        sourceLabel: sourceLabel,
        surahNumber: surahNumber,
        themeId: themeId,
        pathwayId: pathwayId,
        pathwayStopId: pathwayStopId,
        promptLabel: promptLabel,
        routeName: routeName,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        isFavorite: isFavorite,
        note: normalized,
        now: now,
      );
    }
    final timestamp = (now ?? DateTime.now()).toIso8601String();
    final updated = existing.copyWith(
      ref: ref,
      sourceType: sourceType,
      title: title.trim(),
      summary: summary.trim(),
      sourceId: sourceId,
      sourceLabel: sourceLabel,
      surahNumber: surahNumber,
      themeId: themeId,
      pathwayId: pathwayId,
      pathwayStopId: pathwayStopId,
      promptLabel: promptLabel,
      routeName: routeName,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      isFavorite: isFavorite || existing.isFavorite,
      note: normalized,
      updatedAtIso: timestamp,
    );
    _replace(updated);
    return updated.id;
  }

  void updateEntry({required String id, String? note, bool? isFavorite}) {
    final existing = findById(id);
    if (existing == null) {
      return;
    }
    final updated = existing.copyWith(
      note: _normalizedNote(note),
      isFavorite: isFavorite ?? existing.isFavorite,
      updatedAtIso: DateTime.now().toIso8601String(),
    );
    _replace(updated);
  }

  void toggleFavorite(String id) {
    final existing = findById(id);
    if (existing == null) {
      return;
    }
    _replace(
      existing.copyWith(
        isFavorite: !existing.isFavorite,
        updatedAtIso: DateTime.now().toIso8601String(),
      ),
    );
  }

  QuranReflectionEntry? findById(String id) {
    for (final entry in state) {
      if (entry.id == id) {
        return entry;
      }
    }
    return null;
  }

  void removeById(String id) {
    state = state.where((entry) => entry.id != id).toList(growable: false);
    _save();
  }

  void _replace(QuranReflectionEntry updated) {
    state = [updated, ...state.where((entry) => entry.id != updated.id)];
    _save();
  }

  bool _matchesIdentity(
    QuranReflectionEntry entry, {
    required QuranQuoteRef? ref,
    required String? sourceEnrichmentId,
    required QuranReflectionSourceType? sourceType,
    required String? sourceId,
  }) {
    if (sourceEnrichmentId != null && entry.sourceEnrichmentId != null) {
      return entry.sourceEnrichmentId == sourceEnrichmentId;
    }
    if (sourceType != null &&
        sourceId != null &&
        entry.sourceType == sourceType &&
        entry.sourceId == sourceId) {
      return true;
    }
    if (ref == null || entry.ref == null) {
      return false;
    }
    return entry.ref!.surah == ref.surah &&
        entry.ref!.ayah == ref.ayah &&
        entry.ref!.ayahEnd == ref.ayahEnd;
  }

  String? _normalizedNote(String? note) {
    final trimmed = note?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }

  void _load() {
    final data = _store.getJsonList(_quranReflectionsKey);
    if (data == null) return;
    final items = data
        .map(
          (row) => row is Map<String, dynamic>
              ? QuranReflectionEntry.fromJson(row)
              : row is Map
              ? QuranReflectionEntry.fromJson(
                  row.map((key, value) => MapEntry(key.toString(), value)),
                )
              : null,
        )
        .whereType<QuranReflectionEntry>()
        .toList(growable: false);
    state = items;
  }

  void _save() {
    _store.setJsonList(
      _quranReflectionsKey,
      state.map((entry) => entry.toJson()).toList(growable: false),
    );
  }
}

final quranReflectionsProvider =
    StateNotifierProvider<QuranReflectionsNotifier, List<QuranReflectionEntry>>(
      (ref) => QuranReflectionsNotifier(ref.watch(localStoreProvider)),
    );

final quranReflectionByIdProvider =
    Provider.family<QuranReflectionEntry?, String>((ref, id) {
      for (final entry in ref.watch(quranReflectionsProvider)) {
        if (entry.id == id) {
          return entry;
        }
      }
      return null;
    });
