import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ocean/application/ocean_drops_provider.dart';
import '../../../../shared/persistence/local_store.dart';
import '../data/world_curriculum_data.dart';
import '../domain/world_models.dart';

class WorldProgressState {
  const WorldProgressState({
    required this.lessonProgressById,
    required this.recentLessonIds,
  });

  final Map<String, WorldLessonProgress> lessonProgressById;
  final List<String> recentLessonIds;

  WorldProgressState copyWith({
    Map<String, WorldLessonProgress>? lessonProgressById,
    List<String>? recentLessonIds,
  }) {
    return WorldProgressState(
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

  static WorldProgressState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const WorldProgressState(
        lessonProgressById: {},
        recentLessonIds: [],
      );
    }

    final map = <String, WorldLessonProgress>{};
    final raw = json['lessonProgressById'];
    if (raw is Map) {
      for (final entry in raw.entries) {
        final parsed = WorldLessonProgress.fromJson(entry.value);
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

    return WorldProgressState(lessonProgressById: map, recentLessonIds: recent);
  }
}

class WorldProgressSummary {
  const WorldProgressSummary({
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

class WorldThemeProgress {
  const WorldThemeProgress({
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

class WorldSubcategoryProgress {
  const WorldSubcategoryProgress({
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

class WorldProgressNotifier extends StateNotifier<WorldProgressState> {
  WorldProgressNotifier(this._store, this._oceanDrops)
    : super(_loadInitialState(_store));

  static const _key = 'learn.world.progress.v1';
  final LocalStore _store;
  final OceanDropService _oceanDrops;

  static WorldProgressState _loadInitialState(LocalStore store) {
    try {
      return WorldProgressState.fromJson(store.getJsonMap(_key));
    } catch (_) {
      // Reset invalid legacy progress snapshots instead of crashing provider init.
      store.remove(_key);
      return const WorldProgressState(
        lessonProgressById: {},
        recentLessonIds: [],
      );
    }
  }

  WorldLessonProgress progressFor(String lessonId) {
    return state.lessonProgressById[lessonId] ??
        WorldLessonProgress(
          lessonId: lessonId,
          status: WorldLessonStatus.notStarted,
          lastOpenedIso: null,
          completedIso: null,
          openCount: 0,
        );
  }

  void openLesson(String lessonId) {
    final current = progressFor(lessonId);
    final nextStatus = current.status == WorldLessonStatus.notStarted
        ? WorldLessonStatus.inProgress
        : current.status;

    final updated = current.copyWith(
      status: nextStatus,
      lastOpenedIso: DateTime.now().toIso8601String(),
      openCount: current.openCount + 1,
    );

    final map = Map<String, WorldLessonProgress>.from(state.lessonProgressById)
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

  void setStatus(String lessonId, WorldLessonStatus status) {
    final current = progressFor(lessonId);
    final updated = current.copyWith(
      status: status,
      lastOpenedIso: DateTime.now().toIso8601String(),
      completedIso: status == WorldLessonStatus.completed
          ? DateTime.now().toIso8601String()
          : null,
    );

    final map = Map<String, WorldLessonProgress>.from(state.lessonProgressById)
      ..[lessonId] = updated;
    state = state.copyWith(lessonProgressById: map);
    _save();
    if (status == WorldLessonStatus.completed &&
        current.status != WorldLessonStatus.completed) {
      _oceanDrops.awardDrop(
        actionType: oceanActionLessonCompleted,
        sourceModule: oceanSourceLearn,
        referenceId: lessonId,
        metadata: {
          'timestamp': updated.completedIso,
          'category': 'world',
        },
      );
    }
  }

  void _save() {
    _store.setJsonMap(_key, state.toJson());
  }
}

final worldProgressProvider =
    StateNotifierProvider<WorldProgressNotifier, WorldProgressState>(
      (ref) => WorldProgressNotifier(
        ref.watch(localStoreProvider),
        ref.read(oceanDropServiceProvider),
      ),
    );

final worldProgressSummaryProvider = Provider<WorldProgressSummary>((ref) {
  final state = ref.watch(worldProgressProvider);
  final ordered = worldCurriculum.suggestedThemeOrder
      .expand((themeId) => worldSubcategoriesForTheme(themeId))
      .expand((sub) => sub.lessonIds)
      .toList();

  var inProgress = 0;
  var completed = 0;
  String? continueLessonId;

  for (final lessonId in ordered) {
    final p = state.lessonProgressById[lessonId];
    if (p == null) continue;
    if (p.status == WorldLessonStatus.inProgress) {
      inProgress += 1;
      continueLessonId ??= lessonId;
    } else if (p.status == WorldLessonStatus.completed) {
      completed += 1;
    }
  }

  String? suggestedNext;
  for (final lessonId in ordered) {
    final p = state.lessonProgressById[lessonId];
    if (p == null || p.status != WorldLessonStatus.completed) {
      suggestedNext = lessonId;
      break;
    }
  }

  continueLessonId ??= suggestedNext;

  return WorldProgressSummary(
    totalLessons: worldCurriculum.lessons.length,
    inProgressCount: inProgress,
    completedCount: completed,
    continueLessonId: continueLessonId,
    recentLessonIds: state.recentLessonIds.take(5).toList(),
    suggestedNextLessonId: suggestedNext,
  );
});

final worldThemeProgressProvider = Provider.family<WorldThemeProgress, String>((
  ref,
  themeId,
) {
  final state = ref.watch(worldProgressProvider);
  final subcategories = worldSubcategoriesForTheme(themeId);
  final lessonIds = subcategories.expand((item) => item.lessonIds).toList();

  var completed = 0;
  var inProgress = 0;
  for (final id in lessonIds) {
    final p = state.lessonProgressById[id];
    if (p == null) continue;
    if (p.status == WorldLessonStatus.completed) {
      completed += 1;
    } else if (p.status == WorldLessonStatus.inProgress) {
      inProgress += 1;
    }
  }

  return WorldThemeProgress(
    themeId: themeId,
    totalLessons: lessonIds.length,
    completedLessons: completed,
    inProgressLessons: inProgress,
  );
});

final worldSubcategoryProgressProvider =
    Provider.family<WorldSubcategoryProgress, String>((ref, subcategoryId) {
      final state = ref.watch(worldProgressProvider);
      final sub = worldSubcategoryById(subcategoryId);
      if (sub == null) {
        return const WorldSubcategoryProgress(
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
        if (p.status == WorldLessonStatus.completed) {
          completed += 1;
        } else if (p.status == WorldLessonStatus.inProgress) {
          inProgress += 1;
        }
      }

      return WorldSubcategoryProgress(
        subcategoryId: subcategoryId,
        totalLessons: sub.lessonIds.length,
        completedLessons: completed,
        inProgressLessons: inProgress,
      );
    });

final worldSuggestedThemeOrderProvider = Provider<List<WorldTheme>>((ref) {
  return worldThemesInSuggestedOrder();
});
