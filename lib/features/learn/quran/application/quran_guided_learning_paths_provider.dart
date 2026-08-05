import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../data/seeded_quran_guided_learning_paths_data.dart';
import '../domain/quran_guided_learning_path_models.dart';

const _quranGuidedLearningContinuityKey = 'learn.quran.guided_paths.v1';

typedef QuranGuidedLearningContinuityState = QuranGuidedLearningProgressState;

class QuranGuidedLearningProgressNotifier
    extends StateNotifier<QuranGuidedLearningProgressState> {
  QuranGuidedLearningProgressNotifier(this._store)
    : super(
        QuranGuidedLearningProgressState.fromJson(
          _store.getJsonMap(_quranGuidedLearningContinuityKey),
        ),
      );

  final LocalStore _store;

  void _save() {
    _store.setJsonMap(_quranGuidedLearningContinuityKey, state.toJson());
  }

  QuranGuidedLearningPathProgressEntry _entryFor(String pathId) {
    return state.entriesByPath[pathId] ??
        QuranGuidedLearningPathProgressEntry(pathId: pathId);
  }

  void markPathStarted({required String pathId, String? stepId}) {
    final now = DateTime.now().toIso8601String();
    final current = _entryFor(pathId);
    final nextEntries =
        Map<String, QuranGuidedLearningPathProgressEntry>.from(
            state.entriesByPath,
          )
          ..[pathId] = current.copyWith(
            startedAtIso: current.startedAtIso ?? now,
            lastOpenedStopId: stepId ?? current.lastOpenedStopId,
            lastAccessedAtIso: now,
          );

    state = state.copyWith(
      entriesByPath: nextEntries,
      lastPathId: pathId,
      lastStepId: stepId ?? state.lastStepId,
      updatedAtIso: now,
    );
    _save();
  }

  void markStepOpened({required String pathId, required String stepId}) {
    final now = DateTime.now().toIso8601String();
    final current = _entryFor(pathId);
    final nextEntries =
        Map<String, QuranGuidedLearningPathProgressEntry>.from(
            state.entriesByPath,
          )
          ..[pathId] = current.copyWith(
            startedAtIso: current.startedAtIso ?? now,
            lastOpenedStopId: stepId,
            lastAccessedAtIso: now,
          );

    state = state.copyWith(
      entriesByPath: nextEntries,
      lastPathId: pathId,
      lastStepId: stepId,
      updatedAtIso: now,
    );
    _save();
  }

  void markStepCompleted({
    required QuranGuidedLearningPath path,
    required String stepId,
  }) {
    final now = DateTime.now().toIso8601String();
    final current = _entryFor(path.id);
    final completed = Set<String>.from(current.completedStopIds)..add(stepId);
    final isCompleted = completed.length >= path.steps.length;

    final nextEntries =
        Map<String, QuranGuidedLearningPathProgressEntry>.from(
            state.entriesByPath,
          )
          ..[path.id] = current.copyWith(
            startedAtIso: current.startedAtIso ?? now,
            lastOpenedStopId: stepId,
            completedStopIds: completed,
            lastAccessedAtIso: now,
            completedAtIso: isCompleted ? now : current.completedAtIso,
            clearCompletedAtIso: !isCompleted,
          );

    state = state.copyWith(
      entriesByPath: nextEntries,
      lastPathId: path.id,
      lastStepId: stepId,
      updatedAtIso: now,
    );
    _save();
  }
}

final quranGuidedLearningPathsProvider =
    Provider<List<QuranGuidedLearningPath>>((_) {
      final items = [...seededQuranGuidedLearningPaths]
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      return items;
    });

final quranGuidedLearningPathByIdProvider =
    Provider.family<QuranGuidedLearningPath?, String>((ref, pathId) {
      final normalizedId = _normalizePathId(pathId);
      for (final path in ref.watch(quranGuidedLearningPathsProvider)) {
        if (path.id == normalizedId) return path;
      }
      return null;
    });

final quranGuidedFeaturedLearningPathsProvider =
    Provider<List<QuranGuidedLearningPath>>((ref) {
      return ref
          .watch(quranGuidedLearningPathsProvider)
          .where((path) => path.featured)
          .toList(growable: false);
    });

final quranGuidedPathsByCategoryProvider =
    Provider<
      Map<QuranGuidedLearningPathCategory, List<QuranGuidedLearningPath>>
    >((ref) {
      final grouped =
          <QuranGuidedLearningPathCategory, List<QuranGuidedLearningPath>>{};
      for (final path in ref.watch(quranGuidedLearningPathsProvider)) {
        grouped
            .putIfAbsent(path.category, () => <QuranGuidedLearningPath>[])
            .add(path);
      }
      return grouped;
    });

final quranGuidedLearningContinuityProvider =
    StateNotifierProvider<
      QuranGuidedLearningProgressNotifier,
      QuranGuidedLearningProgressState
    >((ref) {
      return QuranGuidedLearningProgressNotifier(ref.watch(localStoreProvider));
    });

final quranGuidedPathProgressByIdProvider =
    Provider.family<QuranGuidedLearningPathProgressEntry?, String>((
      ref,
      pathId,
    ) {
      return ref
          .watch(quranGuidedLearningContinuityProvider)
          .entriesByPath[pathId];
    });

final quranGuidedNextStepForPathProvider =
    Provider.family<QuranGuidedLearningPathStep?, String>((ref, pathId) {
      final path = ref.watch(quranGuidedLearningPathByIdProvider(pathId));
      if (path == null) return null;
      final progress = ref.watch(quranGuidedPathProgressByIdProvider(pathId));
      if (progress == null || !progress.isStarted) {
        return path.steps.isEmpty ? null : path.steps.first;
      }

      if (progress.lastOpenedStopId != null &&
          !progress.completedStopIds.contains(progress.lastOpenedStopId)) {
        for (final step in path.steps) {
          if (step.id == progress.lastOpenedStopId) return step;
        }
      }

      for (final step in path.steps) {
        if (!progress.completedStopIds.contains(step.id)) {
          return step;
        }
      }
      return path.steps.isEmpty ? null : path.steps.last;
    });

final quranGuidedContinuePathProvider = Provider<QuranGuidedLearningPath?>((
  ref,
) {
  final state = ref.watch(quranGuidedLearningContinuityProvider);
  final paths = ref.watch(quranGuidedLearningPathsProvider);

  QuranGuidedLearningPath? fallback;
  String? fallbackTime;

  for (final path in paths) {
    final progress = state.entriesByPath[path.id];
    if (progress == null || !progress.isStarted || progress.isCompleted) {
      continue;
    }
    if (state.lastPathId == path.id) return path;
    final accessed = progress.lastAccessedAtIso ?? progress.startedAtIso;
    if (fallback == null) {
      fallback = path;
      fallbackTime = accessed;
      continue;
    }
    if ((accessed ?? '').compareTo(fallbackTime ?? '') > 0) {
      fallback = path;
      fallbackTime = accessed;
    }
  }

  if (fallback != null) return fallback;
  final lastPathId = state.lastPathId;
  if (lastPathId == null || lastPathId.trim().isEmpty) return null;
  return ref.watch(quranGuidedLearningPathByIdProvider(lastPathId));
});

String _normalizePathId(String pathId) {
  return switch (pathId) {
    'beginner-understanding' => 'tawhid-foundations',
    'theme-study-gratitude' => 'gratitude-and-blessings',
    'memorization-support' => 'verses-for-hard-times',
    'reflection-journey' => 'mercy-and-hope',
    'surah-study-starter' => 'character-and-adab',
    _ => pathId,
  };
}
