import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../data/seeded_quran_guided_learning_paths_data.dart';
import '../domain/quran_guided_learning_path_models.dart';

const _quranGuidedLearningContinuityKey = 'learn.quran.guided_paths.v1';

class QuranGuidedLearningContinuityState {
  const QuranGuidedLearningContinuityState({
    this.lastPathId,
    this.lastStepId,
    this.updatedAtIso,
  });

  final String? lastPathId;
  final String? lastStepId;
  final String? updatedAtIso;

  bool get hasContinuePath => lastPathId?.trim().isNotEmpty ?? false;

  QuranGuidedLearningContinuityState copyWith({
    String? lastPathId,
    String? lastStepId,
    String? updatedAtIso,
  }) {
    return QuranGuidedLearningContinuityState(
      lastPathId: lastPathId ?? this.lastPathId,
      lastStepId: lastStepId ?? this.lastStepId,
      updatedAtIso: updatedAtIso ?? this.updatedAtIso,
    );
  }

  Map<String, dynamic> toJson() => {
    'lastPathId': lastPathId,
    'lastStepId': lastStepId,
    'updatedAtIso': updatedAtIso,
  };

  static QuranGuidedLearningContinuityState fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) return const QuranGuidedLearningContinuityState();
    return QuranGuidedLearningContinuityState(
      lastPathId: json['lastPathId']?.toString(),
      lastStepId: json['lastStepId']?.toString(),
      updatedAtIso: json['updatedAtIso']?.toString(),
    );
  }
}

class QuranGuidedLearningContinuityNotifier
    extends StateNotifier<QuranGuidedLearningContinuityState> {
  QuranGuidedLearningContinuityNotifier(this._store)
    : super(
        QuranGuidedLearningContinuityState.fromJson(
          _store.getJsonMap(_quranGuidedLearningContinuityKey),
        ),
      );

  final LocalStore _store;

  void markStepOpened({required String pathId, required String stepId}) {
    state = state.copyWith(
      lastPathId: pathId,
      lastStepId: stepId,
      updatedAtIso: DateTime.now().toIso8601String(),
    );
    _store.setJsonMap(_quranGuidedLearningContinuityKey, state.toJson());
  }
}

final quranGuidedLearningPathsProvider =
    Provider<List<QuranGuidedLearningPath>>((_) {
      return seededQuranGuidedLearningPaths;
    });

final quranGuidedLearningPathByIdProvider =
    Provider.family<QuranGuidedLearningPath?, String>((ref, pathId) {
      for (final path in ref.watch(quranGuidedLearningPathsProvider)) {
        if (path.id == pathId) return path;
      }
      return null;
    });

final quranGuidedFeaturedLearningPathsProvider =
    Provider<List<QuranGuidedLearningPath>>((ref) {
      return ref.watch(quranGuidedLearningPathsProvider);
    });

final quranGuidedLearningContinuityProvider =
    StateNotifierProvider<
      QuranGuidedLearningContinuityNotifier,
      QuranGuidedLearningContinuityState
    >((ref) {
      return QuranGuidedLearningContinuityNotifier(
        ref.watch(localStoreProvider),
      );
    });

final quranGuidedContinuePathProvider = Provider<QuranGuidedLearningPath?>((
  ref,
) {
  final continuity = ref.watch(quranGuidedLearningContinuityProvider);
  final lastPathId = continuity.lastPathId;
  if (lastPathId == null || lastPathId.trim().isEmpty) return null;
  return ref.watch(quranGuidedLearningPathByIdProvider(lastPathId));
});
