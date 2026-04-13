import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';

const _hadithReadingStatusKey = 'learn.hadith.reading.status.v1';

List<dynamic> _asDynamicList(dynamic value) {
  if (value is List<dynamic>) return value;
  if (value is List) return List<dynamic>.from(value);
  return const [];
}

class HadithReadingStatusState {
  const HadithReadingStatusState({
    required this.openedLessonIds,
    required this.completedLessonIds,
    required this.openedAtByLessonId,
    required this.completedAtByLessonId,
  });

  final Set<String> openedLessonIds;
  final Set<String> completedLessonIds;
  final Map<String, String> openedAtByLessonId;
  final Map<String, String> completedAtByLessonId;

  bool isCompleted(String lessonId) => completedLessonIds.contains(lessonId);
  bool isOpened(String lessonId) => openedLessonIds.contains(lessonId);
  bool isReviewing(String lessonId) =>
      openedLessonIds.contains(lessonId) &&
      !completedLessonIds.contains(lessonId);
  bool isNotReviewed(String lessonId) => !openedLessonIds.contains(lessonId);

  HadithReadingStatusState copyWith({
    Set<String>? openedLessonIds,
    Set<String>? completedLessonIds,
    Map<String, String>? openedAtByLessonId,
    Map<String, String>? completedAtByLessonId,
  }) {
    return HadithReadingStatusState(
      openedLessonIds: openedLessonIds ?? this.openedLessonIds,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      openedAtByLessonId: openedAtByLessonId ?? this.openedAtByLessonId,
      completedAtByLessonId:
          completedAtByLessonId ?? this.completedAtByLessonId,
    );
  }

  Map<String, dynamic> toJson() => {
    'openedLessonIds': openedLessonIds.toList(growable: false),
    'completedLessonIds': completedLessonIds.toList(growable: false),
    'openedAtByLessonId': openedAtByLessonId,
    'completedAtByLessonId': completedAtByLessonId,
  };

  static HadithReadingStatusState fromJson(Map<String, dynamic>? json) {
    final rawOpenedAt = json?['openedAtByLessonId'];
    final rawCompletedAt = json?['completedAtByLessonId'];

    final openedAt = <String, String>{};
    if (rawOpenedAt is Map) {
      for (final item in rawOpenedAt.entries) {
        openedAt[item.key.toString()] = item.value.toString();
      }
    }

    final completedAt = <String, String>{};
    if (rawCompletedAt is Map) {
      for (final item in rawCompletedAt.entries) {
        completedAt[item.key.toString()] = item.value.toString();
      }
    }

    return HadithReadingStatusState(
      openedLessonIds: _asDynamicList(
        json?['openedLessonIds'],
      ).map((item) => item.toString()).toSet(),
      completedLessonIds: _asDynamicList(
        json?['completedLessonIds'],
      ).map((item) => item.toString()).toSet(),
      openedAtByLessonId: openedAt,
      completedAtByLessonId: completedAt,
    );
  }
}

class HadithReadingStatusController
    extends StateNotifier<HadithReadingStatusState> {
  HadithReadingStatusController(this._store)
    : super(
        HadithReadingStatusState.fromJson(
          _store.getJsonMap(_hadithReadingStatusKey),
        ),
      );

  final LocalStore _store;

  void _persist() {
    _store.setJsonMap(_hadithReadingStatusKey, state.toJson());
  }

  void markOpened(String lessonId, {DateTime? now}) {
    if (state.openedLessonIds.contains(lessonId)) return;
    final openedLessonIds = Set<String>.from(state.openedLessonIds)
      ..add(lessonId);
    final openedAtByLessonId = Map<String, String>.from(
      state.openedAtByLessonId,
    )..[lessonId] = (now ?? DateTime.now()).toIso8601String();
    state = state.copyWith(
      openedLessonIds: openedLessonIds,
      openedAtByLessonId: openedAtByLessonId,
    );
    _persist();
  }

  void setCompleted(String lessonId, bool completed, {DateTime? now}) {
    final openedLessonIds = Set<String>.from(state.openedLessonIds)
      ..add(lessonId);
    final openedAtByLessonId = Map<String, String>.from(
      state.openedAtByLessonId,
    );
    openedAtByLessonId.putIfAbsent(
      lessonId,
      () => (now ?? DateTime.now()).toIso8601String(),
    );

    final completedLessonIds = Set<String>.from(state.completedLessonIds);
    final completedAtByLessonId = Map<String, String>.from(
      state.completedAtByLessonId,
    );

    if (completed) {
      completedLessonIds.add(lessonId);
      completedAtByLessonId[lessonId] = (now ?? DateTime.now())
          .toIso8601String();
    } else {
      completedLessonIds.remove(lessonId);
      completedAtByLessonId.remove(lessonId);
    }

    state = state.copyWith(
      openedLessonIds: openedLessonIds,
      completedLessonIds: completedLessonIds,
      openedAtByLessonId: openedAtByLessonId,
      completedAtByLessonId: completedAtByLessonId,
    );
    _persist();
  }

  void toggleCompleted(String lessonId, {DateTime? now}) {
    setCompleted(
      lessonId,
      !state.completedLessonIds.contains(lessonId),
      now: now,
    );
  }
}

final hadithReadingStatusProvider =
    StateNotifierProvider<
      HadithReadingStatusController,
      HadithReadingStatusState
    >((ref) {
      return HadithReadingStatusController(ref.watch(localStoreProvider));
    });
