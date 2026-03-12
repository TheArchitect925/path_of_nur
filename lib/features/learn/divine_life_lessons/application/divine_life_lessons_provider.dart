import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../shared/application/learn_system_engine_provider.dart';
import '../data/divine_life_lessons_data.dart';
import '../domain/divine_life_models.dart';

const _storageKey = 'learn.divine.life.lessons.v1';

class DivineLifeProgressState {
  const DivineLifeProgressState({
    required this.bookmarkedLessonIds,
    required this.recentLessonIds,
    required this.notesByLessonId,
    required this.openedAtIsoByLessonId,
  });

  final Set<String> bookmarkedLessonIds;
  final List<String> recentLessonIds;
  final Map<String, DivineLifeNote> notesByLessonId;
  final Map<String, String> openedAtIsoByLessonId;

  DivineLifeProgressState copyWith({
    Set<String>? bookmarkedLessonIds,
    List<String>? recentLessonIds,
    Map<String, DivineLifeNote>? notesByLessonId,
    Map<String, String>? openedAtIsoByLessonId,
  }) {
    return DivineLifeProgressState(
      bookmarkedLessonIds: bookmarkedLessonIds ?? this.bookmarkedLessonIds,
      recentLessonIds: recentLessonIds ?? this.recentLessonIds,
      notesByLessonId: notesByLessonId ?? this.notesByLessonId,
      openedAtIsoByLessonId:
          openedAtIsoByLessonId ?? this.openedAtIsoByLessonId,
    );
  }

  Map<String, dynamic> toJson() => {
    'bookmarkedLessonIds': bookmarkedLessonIds.toList(growable: false),
    'recentLessonIds': recentLessonIds,
    'notesByLessonId': {
      for (final entry in notesByLessonId.entries)
        entry.key: entry.value.toJson(),
    },
    'openedAtIsoByLessonId': openedAtIsoByLessonId,
  };

  static DivineLifeProgressState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const DivineLifeProgressState(
        bookmarkedLessonIds: <String>{},
        recentLessonIds: <String>[],
        notesByLessonId: <String, DivineLifeNote>{},
        openedAtIsoByLessonId: <String, String>{},
      );
    }

    final bookmarks = <String>{};
    final rawBookmarks = json['bookmarkedLessonIds'];
    if (rawBookmarks is List) {
      for (final id in rawBookmarks) {
        final parsed = id.toString();
        if (parsed.isNotEmpty) bookmarks.add(parsed);
      }
    }

    final recent = <String>[];
    final rawRecent = json['recentLessonIds'];
    if (rawRecent is List) {
      for (final id in rawRecent) {
        final parsed = id.toString();
        if (parsed.isNotEmpty) recent.add(parsed);
      }
    }

    final notesByLessonId = <String, DivineLifeNote>{};
    final rawNotes = json['notesByLessonId'];
    if (rawNotes is Map) {
      for (final entry in rawNotes.entries) {
        final key = entry.key.toString();
        final parsed = DivineLifeNote.fromJson(entry.value);
        if (key.isEmpty || parsed == null) continue;
        notesByLessonId[key] = parsed;
      }
    }

    final openedAt = <String, String>{};
    final rawOpened = json['openedAtIsoByLessonId'];
    if (rawOpened is Map) {
      for (final entry in rawOpened.entries) {
        final key = entry.key.toString();
        final value = entry.value?.toString() ?? '';
        if (key.isNotEmpty && value.isNotEmpty) {
          openedAt[key] = value;
        }
      }
    }

    return DivineLifeProgressState(
      bookmarkedLessonIds: bookmarks,
      recentLessonIds: recent,
      notesByLessonId: notesByLessonId,
      openedAtIsoByLessonId: openedAt,
    );
  }
}

class DivineLifeProgressNotifier
    extends StateNotifier<DivineLifeProgressState> {
  DivineLifeProgressNotifier(this._store, this._ref)
    : super(DivineLifeProgressState.fromJson(_store.getJsonMap(_storageKey)));

  final LocalStore _store;
  final Ref _ref;

  void openLesson(String lessonId) {
    final nowIso = DateTime.now().toIso8601String();
    final recent = List<String>.from(state.recentLessonIds)
      ..remove(lessonId)
      ..insert(0, lessonId);
    if (recent.length > 15) {
      recent.removeRange(15, recent.length);
    }
    final openedAt = Map<String, String>.from(state.openedAtIsoByLessonId)
      ..[lessonId] = nowIso;
    state = state.copyWith(
      recentLessonIds: recent,
      openedAtIsoByLessonId: openedAt,
    );

    _markUnifiedStarted(lessonId);
    _persist();
  }

  void toggleBookmark(String lessonId) {
    final bookmarked = Set<String>.from(state.bookmarkedLessonIds);
    if (!bookmarked.remove(lessonId)) {
      bookmarked.add(lessonId);
    }
    state = state.copyWith(bookmarkedLessonIds: bookmarked);

    _markUnifiedSaved(lessonId);
    _persist();
  }

  void upsertNote(String lessonId, String noteText) {
    final trimmed = noteText.trim();
    final notes = Map<String, DivineLifeNote>.from(state.notesByLessonId);
    if (trimmed.isEmpty) {
      notes.remove(lessonId);
    } else {
      notes[lessonId] = DivineLifeNote(
        lessonId: lessonId,
        noteText: trimmed,
        updatedAtIso: DateTime.now().toIso8601String(),
      );
    }
    state = state.copyWith(notesByLessonId: notes);

    _markUnifiedReflected(lessonId, trimmed);
    _persist();
  }

  void deleteNote(String lessonId) {
    final notes = Map<String, DivineLifeNote>.from(state.notesByLessonId)
      ..remove(lessonId);
    state = state.copyWith(notesByLessonId: notes);

    _markUnifiedReflected(lessonId, '');
    _persist();
  }

  void _markUnifiedStarted(String lessonId) {
    _ref
        .read(learnUnifiedProgressProvider.notifier)
        .markStarted(_itemId(lessonId));
  }

  void _markUnifiedSaved(String lessonId) {
    _ref
        .read(learnUnifiedProgressProvider.notifier)
        .toggleSaved(_itemId(lessonId));
  }

  void _markUnifiedReflected(String lessonId, String noteText) {
    final controller = _ref.read(learnUnifiedProgressProvider.notifier);
    final itemId = _itemId(lessonId);
    controller.markReflected(itemId);
    controller.setNote(itemId, noteText);
  }

  void _persist() {
    _store.setJsonMap(_storageKey, state.toJson());
  }
}

String _itemId(String lessonId) => 'life:lesson:$lessonId';

final divineLifeProgressProvider =
    StateNotifierProvider<DivineLifeProgressNotifier, DivineLifeProgressState>((
      ref,
    ) {
      return DivineLifeProgressNotifier(ref.watch(localStoreProvider), ref);
    });

final divineLifeLessonByIdProvider = Provider.family<DivineLifeLesson?, String>(
  (ref, id) {
    return divineLifeLessonById(id);
  },
);

final divineLifeFeaturedLessonsProvider = Provider<List<DivineLifeLesson>>((
  ref,
) {
  final sorted = [...divineLifeLessons]
    ..sort((a, b) => b.featuredPriority.compareTo(a.featuredPriority));
  return sorted.take(5).toList(growable: false);
});

final divineLifeBookmarkedLessonsProvider = Provider<List<DivineLifeLesson>>((
  ref,
) {
  final ids = ref.watch(divineLifeProgressProvider).bookmarkedLessonIds;
  return divineLifeLessons
      .where((lesson) => ids.contains(lesson.id))
      .toList(growable: false);
});

final divineLifeLessonsWithNotesProvider = Provider<List<DivineLifeLesson>>((
  ref,
) {
  final notes = ref.watch(divineLifeProgressProvider).notesByLessonId;
  return divineLifeLessons
      .where((lesson) => notes.containsKey(lesson.id))
      .toList(growable: false);
});

final divineLifeRecentLessonsProvider = Provider<List<DivineLifeLesson>>((ref) {
  final recentIds = ref.watch(divineLifeProgressProvider).recentLessonIds;
  final output = <DivineLifeLesson>[];
  for (final id in recentIds) {
    final lesson = divineLifeLessonById(id);
    if (lesson != null) output.add(lesson);
  }
  return output;
});

final divineLifeDailyLessonProvider = Provider<DivineLifeLesson>((ref) {
  final now = DateTime.now();
  final seed = now.year * 372 + now.month * 31 + now.day;
  final sorted = [...divineLifeLessons]
    ..sort((a, b) => b.featuredPriority.compareTo(a.featuredPriority));
  return sorted[seed % sorted.length];
});

final divineLifeJourneyPathsProvider = Provider<Map<String, List<String>>>((
  ref,
) {
  return const {
    'Patience': [
      'patience_hardship_2_153',
      'hardship_not_end_94_5_6',
      'patience_hope_12_87',
      'forgiveness_strength_42_43',
    ],
    'Gratitude': [
      'gratitude_heart_14_7',
      'spend_what_you_love_3_92',
      'give_quietly_2_271',
      'success_without_arrogance',
    ],
    'Character': [
      'speak_well_2_83',
      'avoid_suspicion_backbiting_49_12',
      'restrain_anger_3_134',
      'walk_humbly_25_63',
    ],
    'Trust in Allah': [
      'trust_after_effort_3_159',
      'allah_sufficient_65_3',
      'decision_with_tawakkul',
      'anxious_heart_anchored',
    ],
  };
});
