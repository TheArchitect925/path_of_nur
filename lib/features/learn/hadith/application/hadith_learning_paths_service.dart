import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../../journey/application/journey_progression_provider.dart';
import '../data/seeded_hadith_learning_paths_data.dart';
import '../domain/hadith_foundation_models.dart';
import '../domain/hadith_learning_path.dart';
import 'hadith_foundation_repository.dart';

const _hadithPathsProgressKey = 'learn.hadith.paths.progress.v1';

List<dynamic> _asDynamicList(dynamic value) {
  if (value is List<dynamic>) return value;
  if (value is List) return List<dynamic>.from(value);
  return const [];
}

class HadithLearningPathsProgressState {
  const HadithLearningPathsProgressState({
    required this.completedLessonIds,
    required this.completedAtByLessonId,
    required this.completionDayKeys,
    required this.currentStreakDays,
    required this.bestStreakDays,
  });

  final Set<String> completedLessonIds;
  final Map<String, String> completedAtByLessonId;
  final Set<String> completionDayKeys;
  final int currentStreakDays;
  final int bestStreakDays;

  HadithLearningPathsProgressState copyWith({
    Set<String>? completedLessonIds,
    Map<String, String>? completedAtByLessonId,
    Set<String>? completionDayKeys,
    int? currentStreakDays,
    int? bestStreakDays,
  }) {
    return HadithLearningPathsProgressState(
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      completedAtByLessonId:
          completedAtByLessonId ?? this.completedAtByLessonId,
      completionDayKeys: completionDayKeys ?? this.completionDayKeys,
      currentStreakDays: currentStreakDays ?? this.currentStreakDays,
      bestStreakDays: bestStreakDays ?? this.bestStreakDays,
    );
  }

  Map<String, dynamic> toJson() => {
    'completedLessonIds': completedLessonIds.toList(growable: false),
    'completedAtByLessonId': completedAtByLessonId,
    'completionDayKeys': completionDayKeys.toList(growable: false),
    'currentStreakDays': currentStreakDays,
    'bestStreakDays': bestStreakDays,
  };

  static HadithLearningPathsProgressState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const HadithLearningPathsProgressState(
        completedLessonIds: <String>{},
        completedAtByLessonId: <String, String>{},
        completionDayKeys: <String>{},
        currentStreakDays: 0,
        bestStreakDays: 0,
      );
    }

    final rawCompleted = _asDynamicList(json['completedLessonIds']);
    final rawCompletedAt = json['completedAtByLessonId'];
    final rawCompletionDays = _asDynamicList(json['completionDayKeys']);

    final completedAt = <String, String>{};
    if (rawCompletedAt is Map) {
      for (final item in rawCompletedAt.entries) {
        completedAt[item.key.toString()] = item.value.toString();
      }
    }

    return HadithLearningPathsProgressState(
      completedLessonIds: rawCompleted.map((item) => item.toString()).toSet(),
      completedAtByLessonId: completedAt,
      completionDayKeys: rawCompletionDays
          .map((item) => item.toString())
          .toSet(),
      currentStreakDays:
          int.tryParse(json['currentStreakDays']?.toString() ?? '') ?? 0,
      bestStreakDays:
          int.tryParse(json['bestStreakDays']?.toString() ?? '') ?? 0,
    );
  }
}

class HadithLearningPathProgressSummary {
  const HadithLearningPathProgressSummary({
    required this.path,
    required this.totalLessons,
    required this.completedLessons,
    required this.completedChapterIds,
  });

  final HadithLearningPath path;
  final int totalLessons;
  final int completedLessons;
  final Set<String> completedChapterIds;

  bool get isCompleted => totalLessons > 0 && completedLessons >= totalLessons;
  double get ratio {
    if (totalLessons == 0) return 0;
    return (completedLessons / totalLessons).clamp(0.0, 1.0);
  }
}

class HadithPathMilestone {
  const HadithPathMilestone({
    required this.id,
    required this.label,
    required this.threshold,
    required this.unlocked,
  });

  final String id;
  final String label;
  final int threshold;
  final bool unlocked;
}

class HadithLearningPathsProgressController
    extends StateNotifier<HadithLearningPathsProgressState> {
  HadithLearningPathsProgressController(this._store)
    : super(
        HadithLearningPathsProgressState.fromJson(
          _store.getJsonMap(_hadithPathsProgressKey),
        ),
      );

  final LocalStore _store;

  void _save() {
    _store.setJsonMap(_hadithPathsProgressKey, state.toJson());
  }

  bool isLessonCompleted(String lessonId) =>
      state.completedLessonIds.contains(lessonId);

  bool markLessonCompleted(String lessonId, {DateTime? now}) {
    if (isLessonCompleted(lessonId)) return false;
    final timestamp = (now ?? DateTime.now()).toIso8601String();
    final dayKey = LocalStore.todayKey(now);

    final completedLessonIds = Set<String>.from(state.completedLessonIds)
      ..add(lessonId);
    final completedAtByLessonId = Map<String, String>.from(
      state.completedAtByLessonId,
    )..[lessonId] = timestamp;
    final completionDayKeys = Set<String>.from(state.completionDayKeys)
      ..add(dayKey);

    final streak = _computeStreak(completionDayKeys, now: now);
    final best = streak > state.bestStreakDays ? streak : state.bestStreakDays;

    state = state.copyWith(
      completedLessonIds: completedLessonIds,
      completedAtByLessonId: completedAtByLessonId,
      completionDayKeys: completionDayKeys,
      currentStreakDays: streak,
      bestStreakDays: best,
    );
    _save();
    return true;
  }

  int _computeStreak(Set<String> completionDayKeys, {DateTime? now}) {
    var cursor = DateTime(
      (now ?? DateTime.now()).year,
      (now ?? DateTime.now()).month,
      (now ?? DateTime.now()).day,
    );
    var streak = 0;
    while (true) {
      final dayKey = LocalStore.todayKey(cursor);
      if (!completionDayKeys.contains(dayKey)) break;
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }
}

final hadithLearningPathsProvider = Provider<List<HadithLearningPath>>((ref) {
  final allEntries = ref.watch(hadithEntriesProvider);
  final entryIds = allEntries.map((entry) => entry.id).toSet();
  return seededHadithLearningPaths
      .map((path) {
        final filteredLessonIds = path.lessonIds
            .where(entryIds.contains)
            .toList(growable: false);
        final filteredChapters = path.chapters
            .map(
              (chapter) => HadithLearningPathChapter(
                id: chapter.id,
                title: chapter.title,
                intro: chapter.intro,
                hasReviewShell: chapter.hasReviewShell,
                lessonIds: chapter.lessonIds
                    .where(filteredLessonIds.contains)
                    .toList(growable: false),
              ),
            )
            .where((chapter) => chapter.lessonIds.isNotEmpty)
            .toList(growable: false);
        return HadithLearningPath(
          id: path.id,
          title: path.title,
          subtitle: path.subtitle,
          description: path.description,
          lessonIds: filteredLessonIds,
          chapters: filteredChapters,
        );
      })
      .where((path) => path.lessonIds.isNotEmpty)
      .toList(growable: false);
});

final hadithLearningPathByIdProvider =
    Provider.family<HadithLearningPath?, String>((ref, id) {
      final paths = ref.watch(hadithLearningPathsProvider);
      for (final path in paths) {
        if (path.id == id) return path;
      }
      return null;
    });

final hadithLearningPathEntriesProvider =
    Provider.family<List<HadithEntry>, String>((ref, pathId) {
      final path = ref.watch(hadithLearningPathByIdProvider(pathId));
      if (path == null) return const [];
      return path.lessonIds
          .map((id) => ref.watch(hadithEntryByIdProvider(id)))
          .whereType<HadithEntry>()
          .where((entry) => entry.quranConnections.isNotEmpty)
          .toList(growable: false);
    });

final hadithLearningPathsProgressProvider =
    StateNotifierProvider<
      HadithLearningPathsProgressController,
      HadithLearningPathsProgressState
    >((ref) {
      return HadithLearningPathsProgressController(
        ref.watch(localStoreProvider),
      );
    });

final hadithLearningPathProgressProvider =
    Provider.family<HadithLearningPathProgressSummary?, String>((ref, pathId) {
      final path = ref.watch(hadithLearningPathByIdProvider(pathId));
      if (path == null) return null;
      final state = ref.watch(hadithLearningPathsProgressProvider);
      var completed = 0;
      for (final lessonId in path.lessonIds) {
        if (state.completedLessonIds.contains(lessonId)) {
          completed += 1;
        }
      }
      final completedChapters = <String>{};
      for (final chapter in path.chapters) {
        if (chapter.lessonIds.isNotEmpty &&
            chapter.lessonIds.every(state.completedLessonIds.contains)) {
          completedChapters.add(chapter.id);
        }
      }
      return HadithLearningPathProgressSummary(
        path: path,
        totalLessons: path.lessonIds.length,
        completedLessons: completed,
        completedChapterIds: completedChapters,
      );
    });

final hadithPathMilestonesProvider =
    Provider.family<List<HadithPathMilestone>, String>((ref, pathId) {
      final summary = ref.watch(hadithLearningPathProgressProvider(pathId));
      if (summary == null) return const <HadithPathMilestone>[];
      final completed = summary.completedLessons;
      final total = summary.totalLessons;
      final thresholds = <(String, String, int)>[
        ('start', 'Started Journey', 1),
        ('steady_10', 'Steady Learner', 10),
        ('halfway', 'Halfway Marker', (total / 2).ceil()),
        ('thirty', 'Deepening Practice', 30),
        ('complete', 'Path Completed', total),
      ];
      return thresholds
          .map(
            (item) => HadithPathMilestone(
              id: item.$1,
              label: item.$2,
              threshold: item.$3,
              unlocked: completed >= item.$3,
            ),
          )
          .toList(growable: false);
    });

bool isPathLessonUnlocked(
  HadithLearningPath path,
  Set<String> completedLessonIds,
  String lessonId,
) {
  final index = path.lessonIds.indexOf(lessonId);
  if (index <= 0) return true;
  for (var i = 0; i < index; i += 1) {
    if (!completedLessonIds.contains(path.lessonIds[i])) return false;
  }
  return true;
}

Future<bool> completeHadithPathLesson(WidgetRef ref, String lessonId) async {
  final newlyCompleted = ref
      .read(hadithLearningPathsProgressProvider.notifier)
      .markLessonCompleted(lessonId);
  if (!newlyCompleted) return false;

  final snapshot = ref.read(journeyActivitySnapshotProvider);
  final nextReflectionEntries = snapshot.reflectionEntriesToday + 1;
  final adjusted = JourneyActivitySnapshot(
    now: snapshot.now,
    prayerCompletedToday: snapshot.prayerCompletedToday,
    prayerProgress: snapshot.prayerProgress,
    dhikrSessionsToday: snapshot.dhikrSessionsToday,
    dhikrProgress: snapshot.dhikrProgress,
    fastingStatus: snapshot.fastingStatus,
    quranEngagementsToday: snapshot.quranEngagementsToday,
    quranProgress: snapshot.quranProgress,
    reflectionEntriesToday: nextReflectionEntries,
    reflectionProgress: (nextReflectionEntries / 2).clamp(0.0, 1.0).toDouble(),
  );
  ref.read(journeyProgressProvider.notifier).syncFromSnapshot(adjusted);
  return true;
}
