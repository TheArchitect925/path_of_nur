import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../../journey/application/journey_progression_provider.dart';
import '../../../ocean/application/ocean_drops_provider.dart';
import '../data/seeded_hadith_path_quiz_data.dart';
import '../domain/hadith_foundation_models.dart';
import '../domain/hadith_quiz_models.dart';
import 'hadith_foundation_repository.dart';
import 'hadith_learning_paths_service.dart';

const _hadithQuizReviewStateKey = 'learn.hadith.path.quiz.review.v1';

enum HadithReviewQuizMode { byTheme, byPath, random, weekly }

Map<String, dynamic>? _asStringDynamicMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
  }
  return null;
}

List<dynamic> _asDynamicList(dynamic value) {
  if (value is List<dynamic>) return value;
  if (value is List) return List<dynamic>.from(value);
  return const [];
}

class HadithQuizReviewState {
  const HadithQuizReviewState({
    required this.completedQuizIds,
    required this.lastScoreByQuizId,
    required this.bestScoreByQuizId,
    required this.chapterBadgeQuizIds,
    required this.pathBadgeIds,
    required this.weeklyCompletionKeys,
    required this.reviewScheduleByLessonId,
  });

  final Set<String> completedQuizIds;
  final Map<String, int> lastScoreByQuizId;
  final Map<String, int> bestScoreByQuizId;
  final Set<String> chapterBadgeQuizIds;
  final Set<String> pathBadgeIds;
  final Set<String> weeklyCompletionKeys;
  final Map<String, HadithReviewSchedule> reviewScheduleByLessonId;

  HadithQuizReviewState copyWith({
    Set<String>? completedQuizIds,
    Map<String, int>? lastScoreByQuizId,
    Map<String, int>? bestScoreByQuizId,
    Set<String>? chapterBadgeQuizIds,
    Set<String>? pathBadgeIds,
    Set<String>? weeklyCompletionKeys,
    Map<String, HadithReviewSchedule>? reviewScheduleByLessonId,
  }) {
    return HadithQuizReviewState(
      completedQuizIds: completedQuizIds ?? this.completedQuizIds,
      lastScoreByQuizId: lastScoreByQuizId ?? this.lastScoreByQuizId,
      bestScoreByQuizId: bestScoreByQuizId ?? this.bestScoreByQuizId,
      chapterBadgeQuizIds: chapterBadgeQuizIds ?? this.chapterBadgeQuizIds,
      pathBadgeIds: pathBadgeIds ?? this.pathBadgeIds,
      weeklyCompletionKeys: weeklyCompletionKeys ?? this.weeklyCompletionKeys,
      reviewScheduleByLessonId:
          reviewScheduleByLessonId ?? this.reviewScheduleByLessonId,
    );
  }

  Map<String, dynamic> toJson() => {
    'completedQuizIds': completedQuizIds.toList(growable: false),
    'lastScoreByQuizId': lastScoreByQuizId,
    'bestScoreByQuizId': bestScoreByQuizId,
    'chapterBadgeQuizIds': chapterBadgeQuizIds.toList(growable: false),
    'pathBadgeIds': pathBadgeIds.toList(growable: false),
    'weeklyCompletionKeys': weeklyCompletionKeys.toList(growable: false),
    'reviewScheduleByLessonId': reviewScheduleByLessonId.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
  };

  static HadithQuizReviewState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const HadithQuizReviewState(
        completedQuizIds: <String>{},
        lastScoreByQuizId: <String, int>{},
        bestScoreByQuizId: <String, int>{},
        chapterBadgeQuizIds: <String>{},
        pathBadgeIds: <String>{},
        weeklyCompletionKeys: <String>{},
        reviewScheduleByLessonId: <String, HadithReviewSchedule>{},
      );
    }

    final rawLast = json['lastScoreByQuizId'];
    final rawBest = json['bestScoreByQuizId'];
    final rawSchedule = json['reviewScheduleByLessonId'];

    final last = <String, int>{};
    if (rawLast is Map) {
      for (final item in rawLast.entries) {
        final parsed = int.tryParse(item.value?.toString() ?? '');
        if (parsed != null) {
          last[item.key.toString()] = parsed;
        }
      }
    }

    final best = <String, int>{};
    if (rawBest is Map) {
      for (final item in rawBest.entries) {
        final parsed = int.tryParse(item.value?.toString() ?? '');
        if (parsed != null) {
          best[item.key.toString()] = parsed;
        }
      }
    }

    final schedules = <String, HadithReviewSchedule>{};
    if (rawSchedule is Map) {
      for (final item in rawSchedule.entries) {
        final parsed = HadithReviewSchedule.fromJson(
          _asStringDynamicMap(item.value),
        );
        if (parsed != null) {
          schedules[item.key.toString()] = parsed;
        }
      }
    }

    return HadithQuizReviewState(
      completedQuizIds: _asDynamicList(
        json['completedQuizIds'],
      ).map((item) => item.toString()).toSet(),
      lastScoreByQuizId: last,
      bestScoreByQuizId: best,
      chapterBadgeQuizIds: _asDynamicList(
        json['chapterBadgeQuizIds'],
      ).map((item) => item.toString()).toSet(),
      pathBadgeIds: _asDynamicList(
        json['pathBadgeIds'],
      ).map((item) => item.toString()).toSet(),
      weeklyCompletionKeys: _asDynamicList(
        json['weeklyCompletionKeys'],
      ).map((item) => item.toString()).toSet(),
      reviewScheduleByLessonId: schedules,
    );
  }
}

class HadithChapterQuizStatus {
  const HadithChapterQuizStatus({
    required this.quiz,
    required this.unlocked,
    required this.completed,
    required this.lastScore,
    required this.bestScore,
  });

  final HadithChapterQuiz? quiz;
  final bool unlocked;
  final bool completed;
  final int? lastScore;
  final int? bestScore;
}

class HadithQuizSubmissionOutcome {
  const HadithQuizSubmissionOutcome({
    required this.result,
    required this.firstChapterCompletion,
    required this.pathCompletionMilestone,
  });

  final HadithQuizResultSummary result;
  final bool firstChapterCompletion;
  final bool pathCompletionMilestone;
}

class HadithQuizReviewController extends StateNotifier<HadithQuizReviewState> {
  HadithQuizReviewController(this._store)
    : super(
        HadithQuizReviewState.fromJson(
          _store.getJsonMap(_hadithQuizReviewStateKey),
        ),
      );

  final LocalStore _store;

  void _persist() {
    _store.setJsonMap(_hadithQuizReviewStateKey, state.toJson());
  }

  void registerLessonCompletion(String lessonId, {DateTime? now}) {
    if (state.reviewScheduleByLessonId.containsKey(lessonId)) return;
    final anchorDate = _startOfDay(now ?? DateTime.now());
    final next = anchorDate.add(const Duration(days: 1));
    final updated =
        Map<String, HadithReviewSchedule>.from(state.reviewScheduleByLessonId)
          ..[lessonId] = HadithReviewSchedule(
            lessonId: lessonId,
            nextReviewDate: next,
            intervalDays: 1,
            reviewCount: 0,
          );

    state = state.copyWith(reviewScheduleByLessonId: updated);
    _persist();
  }

  HadithQuizSubmissionOutcome recordQuizResult({
    required HadithQuizSession session,
    required int score,
    required String encouragement,
    required String? weeklyKey,
    required List<String> relatedPathQuizIds,
    required DateTime now,
  }) {
    final normalizedScore = score.clamp(0, session.questions.length);
    final lastScore = Map<String, int>.from(state.lastScoreByQuizId)
      ..[session.id] = normalizedScore;
    final bestSoFar = state.bestScoreByQuizId[session.id] ?? 0;
    final bestScore = Map<String, int>.from(state.bestScoreByQuizId)
      ..[session.id] = math.max(bestSoFar, normalizedScore);

    final completedQuizIds = Set<String>.from(state.completedQuizIds);
    final chapterBadgeQuizIds = Set<String>.from(state.chapterBadgeQuizIds);
    final pathBadgeIds = Set<String>.from(state.pathBadgeIds);
    final weeklyCompletionKeys = Set<String>.from(state.weeklyCompletionKeys);

    final firstChapterCompletion = completedQuizIds.add(session.id);
    var pathCompletionMilestone = false;

    if (session.pathId != null && session.pathId!.isNotEmpty) {
      final pathDone =
          relatedPathQuizIds.isNotEmpty &&
          relatedPathQuizIds.every(completedQuizIds.contains);
      if (pathDone && !pathBadgeIds.contains(session.pathId)) {
        pathBadgeIds.add(session.pathId!);
        pathCompletionMilestone = true;
      }
    }

    if (firstChapterCompletion) {
      chapterBadgeQuizIds.add(session.id);
    }

    var weeklyAwarded = false;
    if (weeklyKey != null && weeklyKey.isNotEmpty) {
      weeklyAwarded = weeklyCompletionKeys.add(weeklyKey);
    }

    final successRatio = session.questions.isEmpty
        ? 0.0
        : normalizedScore / session.questions.length;
    final passed = successRatio >= 0.6;
    final scheduleUpdated = _updateReviewSchedule(
      state.reviewScheduleByLessonId,
      session.questions.map((item) => item.lessonId).toSet(),
      passed: passed,
      now: now,
    );

    state = state.copyWith(
      completedQuizIds: completedQuizIds,
      lastScoreByQuizId: lastScore,
      bestScoreByQuizId: bestScore,
      chapterBadgeQuizIds: chapterBadgeQuizIds,
      pathBadgeIds: pathBadgeIds,
      weeklyCompletionKeys: weeklyCompletionKeys,
      reviewScheduleByLessonId: scheduleUpdated,
    );
    _persist();

    var xpUnits = 0;
    if (firstChapterCompletion) xpUnits += 1;
    if (pathCompletionMilestone) xpUnits += 2;
    if (weeklyAwarded) xpUnits += 1;

    final xpAwarded = xpUnits * JourneyXpRules.xpPerReflectionEntry;

    return HadithQuizSubmissionOutcome(
      result: HadithQuizResultSummary(
        score: normalizedScore,
        total: session.questions.length,
        xpAwarded: xpAwarded,
        encouragement: encouragement,
        quranReflection: session.quranReflection,
        chapterMilestoneUnlocked: firstChapterCompletion,
        pathMilestoneUnlocked: pathCompletionMilestone,
      ),
      firstChapterCompletion: firstChapterCompletion,
      pathCompletionMilestone: pathCompletionMilestone,
    );
  }

  Map<String, HadithReviewSchedule> _updateReviewSchedule(
    Map<String, HadithReviewSchedule> existing,
    Set<String> lessonIds, {
    required bool passed,
    required DateTime now,
  }) {
    final today = _startOfDay(now);
    final updated = Map<String, HadithReviewSchedule>.from(existing);
    for (final lessonId in lessonIds) {
      if (lessonId.trim().isEmpty) continue;
      final current =
          updated[lessonId] ??
          HadithReviewSchedule(
            lessonId: lessonId,
            nextReviewDate: today,
            intervalDays: 1,
            reviewCount: 0,
          );

      final nextInterval = passed
          ? (current.intervalDays <= 0
                ? 1
                : (current.intervalDays * 2).clamp(1, 28))
          : 1;

      updated[lessonId] = current.copyWith(
        intervalDays: nextInterval,
        nextReviewDate: today.add(Duration(days: nextInterval)),
        reviewCount: current.reviewCount + 1,
      );
    }
    return updated;
  }

  DateTime _startOfDay(DateTime value) =>
      DateTime(value.year, value.month, value.day);
}

final hadithChapterQuizzesProvider = Provider<List<HadithChapterQuiz>>((_) {
  return seededHadithChapterQuizzes;
});

final hadithChapterQuizByChapterProvider =
    Provider.family<HadithChapterQuiz?, ({String pathId, String chapterId})>((
      ref,
      args,
    ) {
      final quizzes = ref.watch(hadithChapterQuizzesProvider);
      for (final quiz in quizzes) {
        if (quiz.pathId == args.pathId && quiz.chapterId == args.chapterId) {
          return quiz;
        }
      }
      return null;
    });

final hadithQuizQuestionPoolProvider = Provider<List<HadithQuizQuestion>>((
  ref,
) {
  final quizzes = ref.watch(hadithChapterQuizzesProvider);
  return quizzes.expand((item) => item.questions).toList(growable: false);
});

final hadithQuizReviewControllerProvider =
    StateNotifierProvider<HadithQuizReviewController, HadithQuizReviewState>(
      (ref) => HadithQuizReviewController(ref.watch(localStoreProvider)),
    );

final hadithChapterQuizStatusProvider =
    Provider.family<
      HadithChapterQuizStatus,
      ({String pathId, String chapterId})
    >((ref, args) {
      final quiz = ref.watch(hadithChapterQuizByChapterProvider(args));
      final pathSummary = ref.watch(
        hadithLearningPathProgressProvider(args.pathId),
      );
      final reviewState = ref.watch(hadithQuizReviewControllerProvider);
      final chapterCompleted =
          pathSummary?.completedChapterIds.contains(args.chapterId) ?? false;

      if (quiz == null) {
        return HadithChapterQuizStatus(
          quiz: null,
          unlocked: chapterCompleted,
          completed: false,
          lastScore: null,
          bestScore: null,
        );
      }

      return HadithChapterQuizStatus(
        quiz: quiz,
        unlocked: chapterCompleted,
        completed: reviewState.completedQuizIds.contains(quiz.id),
        lastScore: reviewState.lastScoreByQuizId[quiz.id],
        bestScore: reviewState.bestScoreByQuizId[quiz.id],
      );
    });

final hadithDueReviewsProvider = Provider<List<HadithReviewSchedule>>((ref) {
  final state = ref.watch(hadithQuizReviewControllerProvider);
  final today = DateTime.now();
  final start = DateTime(today.year, today.month, today.day);

  final due =
      state.reviewScheduleByLessonId.values
          .where((item) {
            final target = DateTime(
              item.nextReviewDate.year,
              item.nextReviewDate.month,
              item.nextReviewDate.day,
            );
            return !target.isAfter(start);
          })
          .toList(growable: false)
        ..sort((a, b) => a.nextReviewDate.compareTo(b.nextReviewDate));

  return due;
});

final hadithDueReviewEntriesProvider = Provider<List<HadithEntry>>((ref) {
  final due = ref.watch(hadithDueReviewsProvider);
  return due
      .map((item) => ref.watch(hadithEntryByIdProvider(item.lessonId)))
      .whereType<HadithEntry>()
      .toList(growable: false);
});

final hadithReviewEligibleThemeIdsProvider = Provider<List<String>>((ref) {
  final pool = ref.watch(hadithQuizQuestionPoolProvider);
  final byLesson = {
    for (final entry in ref.watch(hadithEntriesProvider)) entry.id: entry,
  };
  final ids = <String>{};
  for (final question in pool) {
    final lesson = byLesson[question.lessonId];
    if (lesson != null) {
      ids.add(lesson.themeId);
    }
  }
  return ids.toList(growable: false)..sort();
});

HadithQuizSession? buildHadithReviewSession(
  WidgetRef ref, {
  required HadithReviewQuizMode mode,
  String? themeId,
  String? pathId,
  int questionCount = 5,
  DateTime? now,
}) {
  final chapterQuizzes = ref.read(hadithChapterQuizzesProvider);
  final pathProgress = ref.read(hadithLearningPathsProgressProvider);
  final byLesson = {
    for (final entry in ref.read(hadithEntriesProvider)) entry.id: entry,
  };

  var pool = chapterQuizzes
      .expand((item) => item.questions)
      .where(
        (question) =>
            pathProgress.completedLessonIds.contains(question.lessonId),
      )
      .toList(growable: false);

  if (pool.isEmpty) {
    pool = chapterQuizzes
        .expand((item) => item.questions)
        .toList(growable: false);
  }

  switch (mode) {
    case HadithReviewQuizMode.byTheme:
      if (themeId == null || themeId.isEmpty) return null;
      pool = pool
          .where((item) => byLesson[item.lessonId]?.themeId == themeId)
          .toList(growable: false);
      break;
    case HadithReviewQuizMode.byPath:
      if (pathId == null || pathId.isEmpty) return null;
      final path = ref.read(hadithLearningPathByIdProvider(pathId));
      if (path == null) return null;
      final allowed = path.lessonIds.toSet();
      pool = pool
          .where((item) => allowed.contains(item.lessonId))
          .toList(growable: false);
      break;
    case HadithReviewQuizMode.random:
      break;
    case HadithReviewQuizMode.weekly:
      break;
  }

  if (pool.isEmpty) return null;

  final selected = _deterministicQuestions(
    source: pool,
    count: questionCount,
    seed: _sessionSeed(mode: mode, id: themeId ?? pathId ?? 'all', now: now),
  );

  final reflection = _pickReflectionForQuestions(selected, byLesson);
  final modeTitle = switch (mode) {
    HadithReviewQuizMode.byTheme => 'Theme Review Quiz',
    HadithReviewQuizMode.byPath => 'Learning Path Review Quiz',
    HadithReviewQuizMode.random => 'Random Hadith Review',
    HadithReviewQuizMode.weekly => 'Weekly Knowledge Check',
  };
  final modeSubtitle = switch (mode) {
    HadithReviewQuizMode.byTheme => 'Focused revision by hadith theme.',
    HadithReviewQuizMode.byPath => 'Focused revision by curated path.',
    HadithReviewQuizMode.random => 'Mixed review from your completed lessons.',
    HadithReviewQuizMode.weekly =>
      'A weekly reflection check from learned material.',
  };

  return HadithQuizSession(
    id: 'review_${mode.name}_${themeId ?? pathId ?? 'all'}_${_sessionSeed(mode: mode, id: themeId ?? pathId ?? 'all', now: now)}',
    title: modeTitle,
    subtitle: modeSubtitle,
    questions: selected,
    quranReflection: reflection,
    pathId: mode == HadithReviewQuizMode.byPath ? pathId : null,
  );
}

Future<HadithQuizSubmissionOutcome> submitHadithQuizSession(
  WidgetRef ref, {
  required HadithQuizSession session,
  required int score,
  required bool isWeekly,
}) async {
  final controller = ref.read(hadithQuizReviewControllerProvider.notifier);
  final quizzes = ref.read(hadithChapterQuizzesProvider);
  final pathQuizIds = session.pathId == null
      ? const <String>[]
      : quizzes
            .where((item) => item.pathId == session.pathId)
            .map((item) => item.id)
            .toList(growable: false);

  final encouragement = _encouragementFor(
    score: score,
    total: session.questions.length,
  );

  final now = DateTime.now();
  final weeklyKey = isWeekly ? _weekKey(now) : null;

  final outcome = controller.recordQuizResult(
    session: session,
    score: score,
    encouragement: encouragement,
    weeklyKey: weeklyKey,
    relatedPathQuizIds: pathQuizIds,
    now: now,
  );

  final xp = outcome.result.xpAwarded;
  if (xp > 0) {
    final bonusEntries = (xp / JourneyXpRules.xpPerReflectionEntry).round();
    ref.read(journeyProgressUpdateHelperProvider).addReflectionEntries(
      bonusEntries,
    );
  }

  ref.read(oceanDropServiceProvider).awardDrop(
    actionType: oceanActionQuizCompleted,
    sourceModule: oceanSourceQuiz,
    referenceId: session.id,
    metadata: {
      'timestamp': now.toIso8601String(),
      'score': score,
      'questionCount': session.questions.length,
    },
  );

  return outcome;
}

List<HadithQuizQuestion> _deterministicQuestions({
  required List<HadithQuizQuestion> source,
  required int count,
  required int seed,
}) {
  if (source.length <= count) return List<HadithQuizQuestion>.from(source);
  final working = List<HadithQuizQuestion>.from(source)
    ..sort((a, b) => a.id.compareTo(b.id));

  final picked = <HadithQuizQuestion>[];
  var cursor = seed.abs();
  while (working.isNotEmpty && picked.length < count) {
    final index = cursor % working.length;
    picked.add(working.removeAt(index));
    cursor = (cursor * 31) + 7;
  }
  return picked;
}

int _sessionSeed({
  required HadithReviewQuizMode mode,
  required String id,
  DateTime? now,
}) {
  final date = now ?? DateTime.now();
  switch (mode) {
    case HadithReviewQuizMode.weekly:
      final week = _weekStart(date);
      return week.year * 10000 + (week.month * 100) + week.day + id.hashCode;
    case HadithReviewQuizMode.byTheme:
    case HadithReviewQuizMode.byPath:
    case HadithReviewQuizMode.random:
      final day = DateTime(date.year, date.month, date.day);
      return day.year * 10000 + (day.month * 100) + day.day + id.hashCode;
  }
}

QuranConnection _pickReflectionForQuestions(
  List<HadithQuizQuestion> questions,
  Map<String, HadithEntry> byLesson,
) {
  for (final question in questions) {
    final item = byLesson[question.lessonId];
    if (item != null && item.quranConnections.isNotEmpty) {
      return item.quranConnections.first;
    }
  }
  return const QuranConnection(
    surahName: 'Al-\'Asr',
    surahNumber: 103,
    verseRange: '1-3',
    label: 'Steadfast faith, truth, and patience',
  );
}

String _encouragementFor({required int score, required int total}) {
  if (total <= 0) return 'Keep a steady rhythm of review.';
  final ratio = score / total;
  if (ratio >= 0.9) {
    return 'Strong retention. Continue with humility and consistency.';
  }
  if (ratio >= 0.7) {
    return 'Good progress. A short review will strengthen long-term recall.';
  }
  if (ratio >= 0.5) {
    return 'You are building foundations. Revisit the lessons calmly and continue.';
  }
  return 'Every review is a step forward. Reopen the lessons and try again.';
}

DateTime _weekStart(DateTime date) {
  final day = DateTime(date.year, date.month, date.day);
  final offset = day.weekday - DateTime.monday;
  return day.subtract(Duration(days: offset < 0 ? 0 : offset));
}

String _weekKey(DateTime date) {
  final week = _weekStart(date);
  return LocalStore.todayKey(week);
}
