import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ocean/application/ocean_drops_provider.dart';
import '../../../../shared/persistence/local_store.dart';
import '../data/life_curriculum_data.dart';
import '../domain/life_models.dart';

class LifeProgressState {
  const LifeProgressState({
    required this.lessonProgressById,
    required this.recentLessonIds,
  });

  final Map<String, LifeLessonProgress> lessonProgressById;
  final List<String> recentLessonIds;

  LifeProgressState copyWith({
    Map<String, LifeLessonProgress>? lessonProgressById,
    List<String>? recentLessonIds,
  }) {
    return LifeProgressState(
      lessonProgressById: lessonProgressById ?? this.lessonProgressById,
      recentLessonIds: recentLessonIds ?? this.recentLessonIds,
    );
  }

  Map<String, dynamic> toJson() => {
    'lessonProgressById': lessonProgressById.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
    'recentLessonIds': recentLessonIds,
  };

  static LifeProgressState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const LifeProgressState(
        lessonProgressById: {},
        recentLessonIds: [],
      );
    }

    final map = <String, LifeLessonProgress>{};
    final raw = json['lessonProgressById'];
    if (raw is Map) {
      for (final entry in raw.entries) {
        final parsed = LifeLessonProgress.fromJson(entry.value);
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

    return LifeProgressState(lessonProgressById: map, recentLessonIds: recent);
  }
}

class LifeProgressSummary {
  const LifeProgressSummary({
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

class LifeThemeProgress {
  const LifeThemeProgress({
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

class LifeSubcategoryProgress {
  const LifeSubcategoryProgress({
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

class LifeProgressNotifier extends StateNotifier<LifeProgressState> {
  LifeProgressNotifier(this._store, this._oceanDrops)
    : super(LifeProgressState.fromJson(_store.getJsonMap(_key)));

  static const _key = 'learn.life.progress.v1';
  final LocalStore _store;
  final OceanDropService _oceanDrops;

  LifeLessonProgress progressFor(String lessonId) {
    return state.lessonProgressById[lessonId] ??
        LifeLessonProgress(
          lessonId: lessonId,
          status: LifeLessonStatus.notStarted,
          lastOpenedIso: null,
          completedIso: null,
          openCount: 0,
        );
  }

  void openLesson(String lessonId) {
    final current = progressFor(lessonId);
    final nowIso = DateTime.now().toIso8601String();
    final nextStatus = current.status == LifeLessonStatus.notStarted
        ? LifeLessonStatus.inProgress
        : current.status;

    final updated = current.copyWith(
      status: nextStatus,
      lastOpenedIso: nowIso,
      openCount: current.openCount + 1,
    );

    final map = Map<String, LifeLessonProgress>.from(state.lessonProgressById)
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

  void setStatus(String lessonId, LifeLessonStatus status) {
    final current = progressFor(lessonId);
    final updated = current.copyWith(
      status: status,
      lastOpenedIso: DateTime.now().toIso8601String(),
      completedIso: status == LifeLessonStatus.completed
          ? DateTime.now().toIso8601String()
          : null,
    );
    final map = Map<String, LifeLessonProgress>.from(state.lessonProgressById)
      ..[lessonId] = updated;
    state = state.copyWith(lessonProgressById: map);
    _save();
    if (status == LifeLessonStatus.completed &&
        current.status != LifeLessonStatus.completed) {
      _oceanDrops.awardDrop(
        actionType: oceanActionLessonCompleted,
        sourceModule: oceanSourceLearn,
        referenceId: lessonId,
        metadata: {'timestamp': updated.completedIso, 'category': 'life'},
      );
    }
  }

  void _save() {
    _store.setJsonMap(_key, state.toJson());
  }
}

final lifeProgressProvider =
    StateNotifierProvider<LifeProgressNotifier, LifeProgressState>(
      (ref) => LifeProgressNotifier(
        ref.watch(localStoreProvider),
        ref.read(oceanDropServiceProvider),
      ),
    );

final lifeProgressSummaryProvider = Provider<LifeProgressSummary>((ref) {
  final state = ref.watch(lifeProgressProvider);
  final ordered = lifeCurriculum.suggestedThemeOrder
      .expand((themeId) => lifeSubcategoriesForTheme(themeId))
      .expand((sub) => sub.lessonIds)
      .toList();

  var inProgress = 0;
  var completed = 0;
  String? continueLessonId;

  for (final lessonId in ordered) {
    final p = state.lessonProgressById[lessonId];
    if (p == null) continue;
    if (p.status == LifeLessonStatus.inProgress) {
      inProgress += 1;
      continueLessonId ??= lessonId;
    } else if (p.status == LifeLessonStatus.completed) {
      completed += 1;
    }
  }

  String? suggestedNext;
  for (final lessonId in ordered) {
    final p = state.lessonProgressById[lessonId];
    if (p == null || p.status != LifeLessonStatus.completed) {
      suggestedNext = lessonId;
      break;
    }
  }

  continueLessonId ??= suggestedNext;

  return LifeProgressSummary(
    totalLessons: lifeCurriculum.lessons.length,
    inProgressCount: inProgress,
    completedCount: completed,
    continueLessonId: continueLessonId,
    recentLessonIds: state.recentLessonIds.take(5).toList(),
    suggestedNextLessonId: suggestedNext,
  );
});

final lifeThemeProgressProvider = Provider.family<LifeThemeProgress, String>((
  ref,
  themeId,
) {
  final state = ref.watch(lifeProgressProvider);
  final subcategories = lifeSubcategoriesForTheme(themeId);
  final lessonIds = subcategories.expand((item) => item.lessonIds).toList();

  var completed = 0;
  var inProgress = 0;

  for (final id in lessonIds) {
    final p = state.lessonProgressById[id];
    if (p == null) continue;
    if (p.status == LifeLessonStatus.completed) {
      completed += 1;
    } else if (p.status == LifeLessonStatus.inProgress) {
      inProgress += 1;
    }
  }

  return LifeThemeProgress(
    themeId: themeId,
    totalLessons: lessonIds.length,
    completedLessons: completed,
    inProgressLessons: inProgress,
  );
});

final lifeSubcategoryProgressProvider =
    Provider.family<LifeSubcategoryProgress, String>((ref, subcategoryId) {
      final state = ref.watch(lifeProgressProvider);
      final sub = lifeSubcategoryById(subcategoryId);
      if (sub == null) {
        return const LifeSubcategoryProgress(
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
        if (p.status == LifeLessonStatus.completed) {
          completed += 1;
        } else if (p.status == LifeLessonStatus.inProgress) {
          inProgress += 1;
        }
      }

      return LifeSubcategoryProgress(
        subcategoryId: subcategoryId,
        totalLessons: sub.lessonIds.length,
        completedLessons: completed,
        inProgressLessons: inProgress,
      );
    });

final lifeSuggestedThemeOrderProvider = Provider<List<LifeTheme>>((ref) {
  return lifeThemesInSuggestedOrder();
});
