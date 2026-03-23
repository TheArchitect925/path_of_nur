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
    required QuranQuoteRef ref,
    String? sourceEnrichmentId,
  }) {
    for (final entry in state) {
      if (_matchesIdentity(entry, ref, sourceEnrichmentId)) {
        return entry;
      }
    }
    return null;
  }

  bool isSaved({required QuranQuoteRef ref, String? sourceEnrichmentId}) {
    return findEntry(ref: ref, sourceEnrichmentId: sourceEnrichmentId) != null;
  }

  String save({
    required QuranQuoteRef ref,
    required QuranReflectionSourceType sourceType,
    required String title,
    required String summary,
    String? sourceEnrichmentId,
    String? note,
    DateTime? now,
  }) {
    final timestamp = (now ?? DateTime.now()).toIso8601String();
    final existing = findEntry(
      ref: ref,
      sourceEnrichmentId: sourceEnrichmentId,
    );
    if (existing != null) {
      final updated = existing.copyWith(
        sourceType: sourceType,
        title: title.trim(),
        summary: summary.trim(),
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
      note: _normalizedNote(note),
      savedAtIso: timestamp,
      updatedAtIso: timestamp,
    );
    state = [entry, ...state];
    _save();
    return entry.id;
  }

  bool toggleSaved({
    required QuranQuoteRef ref,
    required QuranReflectionSourceType sourceType,
    required String title,
    required String summary,
    String? sourceEnrichmentId,
  }) {
    final existing = findEntry(
      ref: ref,
      sourceEnrichmentId: sourceEnrichmentId,
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
    );
    return true;
  }

  String upsertNote({
    required QuranQuoteRef ref,
    required QuranReflectionSourceType sourceType,
    required String title,
    required String summary,
    String? sourceEnrichmentId,
    String? note,
    DateTime? now,
  }) {
    final existing = findEntry(
      ref: ref,
      sourceEnrichmentId: sourceEnrichmentId,
    );
    final normalized = _normalizedNote(note);
    if (existing == null) {
      return save(
        ref: ref,
        sourceType: sourceType,
        title: title,
        summary: summary,
        sourceEnrichmentId: sourceEnrichmentId,
        note: normalized,
        now: now,
      );
    }
    final timestamp = (now ?? DateTime.now()).toIso8601String();
    final updated = existing.copyWith(
      sourceType: sourceType,
      title: title.trim(),
      summary: summary.trim(),
      note: normalized,
      updatedAtIso: timestamp,
    );
    _replace(updated);
    return updated.id;
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
    QuranReflectionEntry entry,
    QuranQuoteRef ref,
    String? sourceEnrichmentId,
  ) {
    if (sourceEnrichmentId != null && entry.sourceEnrichmentId != null) {
      return entry.sourceEnrichmentId == sourceEnrichmentId;
    }
    return entry.ref.surah == ref.surah &&
        entry.ref.ayah == ref.ayah &&
        entry.ref.ayahEnd == ref.ayahEnd;
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
