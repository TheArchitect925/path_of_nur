import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../data/hadith_curriculum_data.dart';
import '../domain/hadith_models.dart';

class HadithProgressState {
  const HadithProgressState({
    required this.lessonProgressById,
    required this.recentLessonIds,
  });

  final Map<String, HadithLessonProgress> lessonProgressById;
  final List<String> recentLessonIds;

  HadithProgressState copyWith({
    Map<String, HadithLessonProgress>? lessonProgressById,
    List<String>? recentLessonIds,
  }) {
    return HadithProgressState(
      lessonProgressById: lessonProgressById ?? this.lessonProgressById,
      recentLessonIds: recentLessonIds ?? this.recentLessonIds,
    );
  }

  Map<String, dynamic> toJson() => {
        'lessonProgressById':
            lessonProgressById.map((key, value) => MapEntry(key, value.toJson())),
        'recentLessonIds': recentLessonIds,
      };

  static HadithProgressState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const HadithProgressState(
        lessonProgressById: {},
        recentLessonIds: [],
      );
    }

    final map = <String, HadithLessonProgress>{};
    final raw = json['lessonProgressById'];
    if (raw is Map) {
      for (final entry in raw.entries) {
        final parsed = HadithLessonProgress.fromJson(entry.value);
        if (parsed != null) {
          map[entry.key.toString()] = parsed;
        }
      }
    }

    final recent = <String>[];
    final rawRecent = json['recentLessonIds'];
    if (rawRecent is List) {
      for (final item in rawRecent) {
        final id = item.toString();
        if (id.isNotEmpty) recent.add(id);
      }
    }

    return HadithProgressState(lessonProgressById: map, recentLessonIds: recent);
  }
}

class HadithProgressSummary {
  const HadithProgressSummary({
    required this.totalLessons,
    required this.inProgressCount,
    required this.completedCount,
    required this.continueLessonId,
    required this.recentLessonIds,
    required this.suggestedNextLessonId,
  });

  final int totalLessons;
  final int inProgressCount;
  final int completedCount;
  final String? continueLessonId;
  final List<String> recentLessonIds;
  final String? suggestedNextLessonId;

  double get completionRatio {
    if (totalLessons == 0) return 0;
    return (completedCount / totalLessons).clamp(0.0, 1.0);
  }
}

class HadithThemeProgress {
  const HadithThemeProgress({
    required this.themeId,
    required this.totalLessons,
    required this.completedLessons,
    required this.inProgressLessons,
  });

  final String themeId;
  final int totalLessons;
  final int completedLessons;
  final int inProgressLessons;

  double get ratio {
    if (totalLessons == 0) return 0;
    return (completedLessons / totalLessons).clamp(0.0, 1.0);
  }
}

class HadithSubcategoryProgress {
  const HadithSubcategoryProgress({
    required this.subcategoryId,
    required this.totalLessons,
    required this.completedLessons,
    required this.inProgressLessons,
  });

  final String subcategoryId;
  final int totalLessons;
  final int completedLessons;
  final int inProgressLessons;

  double get ratio {
    if (totalLessons == 0) return 0;
    return (completedLessons / totalLessons).clamp(0.0, 1.0);
  }
}

class HadithProgressNotifier extends StateNotifier<HadithProgressState> {
  HadithProgressNotifier(this._store)
      : super(HadithProgressState.fromJson(_store.getJsonMap(_key)));

  static const _key = 'learn.hadith.progress.v1';
  final LocalStore _store;

  HadithLessonProgress progressFor(String lessonId) {
    return state.lessonProgressById[lessonId] ??
        HadithLessonProgress(
          lessonId: lessonId,
          status: HadithLessonStatus.notStarted,
          lastOpenedIso: null,
          completedIso: null,
          openCount: 0,
        );
  }

  void openLesson(String lessonId) {
    final current = progressFor(lessonId);
    final nextStatus = current.status == HadithLessonStatus.notStarted
        ? HadithLessonStatus.inProgress
        : current.status;

    final updated = current.copyWith(
      status: nextStatus,
      lastOpenedIso: DateTime.now().toIso8601String(),
      openCount: current.openCount + 1,
    );

    final map = Map<String, HadithLessonProgress>.from(state.lessonProgressById)
      ..[lessonId] = updated;

    final recent = List<String>.from(state.recentLessonIds)
      ..remove(lessonId)
      ..insert(0, lessonId);
    if (recent.length > 12) {
      recent.removeRange(12, recent.length);
    }

    state = state.copyWith(lessonProgressById: map, recentLessonIds: recent);
    _save();
  }

  void setStatus(String lessonId, HadithLessonStatus status) {
    final current = progressFor(lessonId);
    final updated = current.copyWith(
      status: status,
      lastOpenedIso: DateTime.now().toIso8601String(),
      completedIso:
          status == HadithLessonStatus.completed ? DateTime.now().toIso8601String() : null,
    );

    final map = Map<String, HadithLessonProgress>.from(state.lessonProgressById)
      ..[lessonId] = updated;
    state = state.copyWith(lessonProgressById: map);
    _save();
  }

  void _save() {
    _store.setJsonMap(_key, state.toJson());
  }
}

final hadithProgressProvider =
    StateNotifierProvider<HadithProgressNotifier, HadithProgressState>(
  (ref) => HadithProgressNotifier(ref.watch(localStoreProvider)),
);

final hadithProgressSummaryProvider = Provider<HadithProgressSummary>((ref) {
  final state = ref.watch(hadithProgressProvider);
  final ordered = hadithCurriculum.suggestedThemeOrder
      .expand((themeId) => hadithSubcategoriesForTheme(themeId))
      .expand((sub) => sub.lessonIds)
      .toList();

  var inProgress = 0;
  var completed = 0;
  String? continueLessonId;

  for (final lessonId in ordered) {
    final p = state.lessonProgressById[lessonId];
    if (p == null) continue;
    if (p.status == HadithLessonStatus.inProgress) {
      inProgress += 1;
      continueLessonId ??= lessonId;
    } else if (p.status == HadithLessonStatus.completed) {
      completed += 1;
    }
  }

  String? suggestedNext;
  for (final lessonId in ordered) {
    final p = state.lessonProgressById[lessonId];
    if (p == null || p.status != HadithLessonStatus.completed) {
      suggestedNext = lessonId;
      break;
    }
  }

  continueLessonId ??= suggestedNext;

  return HadithProgressSummary(
    totalLessons: hadithCurriculum.lessons.length,
    inProgressCount: inProgress,
    completedCount: completed,
    continueLessonId: continueLessonId,
    recentLessonIds: state.recentLessonIds.take(5).toList(),
    suggestedNextLessonId: suggestedNext,
  );
});

final hadithThemeProgressProvider =
    Provider.family<HadithThemeProgress, String>((ref, themeId) {
  final state = ref.watch(hadithProgressProvider);
  final subcategories = hadithSubcategoriesForTheme(themeId);
  final lessonIds = subcategories.expand((item) => item.lessonIds).toList();

  var completed = 0;
  var inProgress = 0;
  for (final id in lessonIds) {
    final p = state.lessonProgressById[id];
    if (p == null) continue;
    if (p.status == HadithLessonStatus.completed) {
      completed += 1;
    } else if (p.status == HadithLessonStatus.inProgress) {
      inProgress += 1;
    }
  }

  return HadithThemeProgress(
    themeId: themeId,
    totalLessons: lessonIds.length,
    completedLessons: completed,
    inProgressLessons: inProgress,
  );
});

final hadithSubcategoryProgressProvider =
    Provider.family<HadithSubcategoryProgress, String>((ref, subcategoryId) {
  final state = ref.watch(hadithProgressProvider);
  final sub = hadithSubcategoryById(subcategoryId);
  if (sub == null) {
    return const HadithSubcategoryProgress(
      subcategoryId: '',
      totalLessons: 0,
      completedLessons: 0,
      inProgressLessons: 0,
    );
  }

  var completed = 0;
  var inProgress = 0;
  for (final id in sub.lessonIds) {
    final p = state.lessonProgressById[id];
    if (p == null) continue;
    if (p.status == HadithLessonStatus.completed) {
      completed += 1;
    } else if (p.status == HadithLessonStatus.inProgress) {
      inProgress += 1;
    }
  }

  return HadithSubcategoryProgress(
    subcategoryId: subcategoryId,
    totalLessons: sub.lessonIds.length,
    completedLessons: completed,
    inProgressLessons: inProgress,
  );
});

final hadithSuggestedThemeOrderProvider = Provider<List<HadithTheme>>(
  (_) => hadithThemesInSuggestedOrder(),
);
