import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../arabic/data/arabic_beginner_content_catalog.dart';
import '../../../journey/drops/application/journey_drops_providers.dart';
import '../../../../shared/persistence/local_store.dart';
import '../data/quran_teaching_seed_data.dart';
import '../domain/quran_teaching_models.dart';

const _quranTeachingProgressKey = 'learn.quran.teaching.progress.v1';
const _quranTeachingListenOnlyKey = 'learn.quran.teaching.listen_only.v1';
const _quranTeachingMistakesKey = 'learn.quran.teaching.mistakes.v1';
const _quranTeachingBeginnerWordsProgressKey =
    'learn.quran.teaching.beginner_words.v1';

class QuranTeachingProgressController
    extends StateNotifier<QuranTeachingProgressState> {
  QuranTeachingProgressController(this._store, this._dropController)
    : super(
        QuranTeachingProgressState.fromJson(
          _store.getJsonMap(_quranTeachingProgressKey),
        ),
      );

  final LocalStore _store;
  final JourneyDropController _dropController;

  void _save() {
    _store.setJsonMap(_quranTeachingProgressKey, state.toJson());
  }

  void setLearnerLevel(QuranTeachingLearnerLevel level) {
    state = state.copyWith(learnerLevel: level);
    _save();
  }

  void setVisualMode(bool enabled) {
    state = state.copyWith(visualModeEnabled: enabled);
    _save();
  }

  void markLessonStarted(String lessonId) {
    final started = {
      ...state.startedLessonIds,
      lessonId,
    }.toList(growable: false);
    final recent = _pushRecent(state.recentLessonIds, lessonId);
    state = state.copyWith(
      startedLessonIds: started,
      recentLessonIds: recent,
      lastLessonId: lessonId,
      lastPracticedAt: DateTime.now(),
    );
    _save();
  }

  void completeLesson(String lessonId) {
    final alreadyCompleted = state.completedLessonIds.contains(lessonId);
    final completed = {
      ...state.completedLessonIds,
      lessonId,
    }.toList(growable: false);
    final started = {
      ...state.startedLessonIds,
      lessonId,
    }.toList(growable: false);
    final occurredAt = DateTime.now();
    final recent = _pushRecent(state.recentLessonIds, lessonId);
    state = state.copyWith(
      completedLessonIds: completed,
      startedLessonIds: started,
      recentLessonIds: recent,
      lastLessonId: lessonId,
      lastPracticedAt: occurredAt,
    );
    _save();
    if (!alreadyCompleted) {
      _dropController.awardQuranDrop(
        sourceRef: 'quran_teaching:$lessonId',
        occurredAt: occurredAt,
        metadata: <String, Object?>{
          'lessonId': lessonId,
          'timestamp': occurredAt.toIso8601String(),
        },
      );
    }
  }

  void toggleReviewLater(String lessonId) {
    final reviewLater = {...state.reviewLaterLessonIds};
    if (!reviewLater.add(lessonId)) {
      reviewLater.remove(lessonId);
    }
    state = state.copyWith(
      reviewLaterLessonIds: reviewLater.toList(growable: false),
    );
    _save();
  }

  void recordQuizScore(String quizId, double score, {String? lessonId}) {
    final nextScores = {...state.quizBestScores};
    final current = nextScores[quizId] ?? 0;
    if (score > current) {
      nextScores[quizId] = score;
    }
    state = state.copyWith(
      quizBestScores: nextScores,
      lastLessonId: lessonId ?? state.lastLessonId,
      lastPracticedAt: DateTime.now(),
    );
    _save();
  }

  List<String> _pushRecent(List<String> recent, String lessonId) {
    final next = <String>[lessonId, ...recent.where((id) => id != lessonId)];
    if (next.length > 8) {
      return next.take(8).toList(growable: false);
    }
    return next;
  }
}

final quranTeachingCatalogProvider = Provider<QuranTeachingCatalog>((ref) {
  return quranTeachingCatalog;
});

final quranTeachingProgressProvider =
    StateNotifierProvider<
      QuranTeachingProgressController,
      QuranTeachingProgressState
    >((ref) {
      return QuranTeachingProgressController(
        ref.watch(localStoreProvider),
        ref.read(journeyDropSummaryProvider.notifier),
      );
    });

class QuranTeachingBeginnerWordsProgressController
    extends StateNotifier<QuranTeachingBeginnerWordsProgressState> {
  QuranTeachingBeginnerWordsProgressController(this._store)
    : super(
        QuranTeachingBeginnerWordsProgressState.fromJson(
          _store.getJsonMap(_quranTeachingBeginnerWordsProgressKey),
        ),
      );

  final LocalStore _store;

  void _save() {
    _store.setJsonMap(_quranTeachingBeginnerWordsProgressKey, state.toJson());
  }

  void recordWordOpened(String wordId) {
    state = state.copyWith(lastWordId: wordId, lastOpenedAt: DateTime.now());
    _save();
  }
}

final quranTeachingBeginnerWordsProgressProvider =
    StateNotifierProvider<
      QuranTeachingBeginnerWordsProgressController,
      QuranTeachingBeginnerWordsProgressState
    >((ref) {
      return QuranTeachingBeginnerWordsProgressController(
        ref.watch(localStoreProvider),
      );
    });

final quranTeachingRecommendedLessonProvider = Provider<QuranTeachingLesson?>((
  ref,
) {
  final catalog = ref.watch(quranTeachingCatalogProvider);
  final progress = ref.watch(quranTeachingProgressProvider);
  final completed = progress.completedLessonIds.toSet();
  final modules = [...catalog.modules]
    ..sort((a, b) => a.order.compareTo(b.order));

  for (final module in modules) {
    final lessons = catalog.lessonsForModule(module.id);
    for (final lesson in lessons) {
      if (!completed.contains(lesson.id) &&
          isLessonUnlocked(
            lesson: lesson,
            module: module,
            catalog: catalog,
            progress: progress,
          )) {
        return lesson;
      }
    }
  }
  return catalog.lessons.isEmpty ? null : catalog.lessons.first;
});

final quranTeachingWeakLessonsProvider = Provider<List<QuranTeachingLesson>>((
  ref,
) {
  final catalog = ref.watch(quranTeachingCatalogProvider);
  final progress = ref.watch(quranTeachingProgressProvider);
  final weak = <QuranTeachingLesson>[];
  for (final lesson in catalog.lessons) {
    if (lesson.quizzes.isEmpty) continue;
    var total = 0.0;
    for (final quiz in lesson.quizzes) {
      total += progress.quizBestScores[quiz.id] ?? 0;
    }
    final average = total / lesson.quizzes.length;
    if (average > 0 && average < 0.8) {
      weak.add(lesson);
    }
  }
  return weak;
});

class QuranTeachingListenOnlyController
    extends StateNotifier<QuranTeachingListenOnlyState> {
  QuranTeachingListenOnlyController(this._store)
    : super(
        QuranTeachingListenOnlyState.fromJson(
          _store.getJsonMap(_quranTeachingListenOnlyKey),
        ),
      );

  final LocalStore _store;

  void _save() {
    _store.setJsonMap(_quranTeachingListenOnlyKey, state.toJson());
  }

  void selectPack(String packId) {
    state = state.copyWith(
      selectedPackId: packId,
      currentIndex: 0,
      isPlaying: false,
      lastPlayedAt: DateTime.now(),
    );
    _save();
  }

  void setPlaying(bool playing) {
    state = state.copyWith(isPlaying: playing, lastPlayedAt: DateTime.now());
    _save();
  }

  void toggleAutoAdvance(bool enabled) {
    state = state.copyWith(autoAdvance: enabled);
    _save();
  }

  void toggleRepeatCurrent(bool enabled) {
    state = state.copyWith(repeatCurrent: enabled);
    _save();
  }

  void toggleShuffle(bool enabled) {
    state = state.copyWith(shuffle: enabled);
    _save();
  }

  void toggleVisualMode(bool enabled) {
    state = state.copyWith(visualModeEnabled: enabled);
    _save();
  }

  void setTextVisibility(QuranTeachingTextVisibility visibility) {
    state = state.copyWith(textVisibility: visibility);
    _save();
  }

  void setPlaybackSpeed(double speed) {
    state = state.copyWith(playbackSpeed: speed);
    _save();
  }

  void next(int itemCount) {
    if (itemCount <= 0) return;
    final current = state.currentIndex;
    final nextIndex = state.shuffle
        ? (current + 1) % itemCount
        : (current + 1).clamp(0, itemCount - 1);
    state = state.copyWith(
      currentIndex: nextIndex,
      lastPlayedAt: DateTime.now(),
    );
    _save();
  }

  void previous(int itemCount) {
    if (itemCount <= 0) return;
    final previousIndex = (state.currentIndex - 1).clamp(0, itemCount - 1);
    state = state.copyWith(
      currentIndex: previousIndex,
      lastPlayedAt: DateTime.now(),
    );
    _save();
  }

  void replay() {
    state = state.copyWith(lastPlayedAt: DateTime.now());
    _save();
  }
}

class QuranTeachingMistakeReviewController
    extends StateNotifier<Map<String, QuranTeachingMistakeItem>> {
  QuranTeachingMistakeReviewController(this._store)
    : super(_load(_store.getJsonMap(_quranTeachingMistakesKey)));

  final LocalStore _store;

  static Map<String, QuranTeachingMistakeItem> _load(
    Map<String, dynamic>? json,
  ) {
    if (json == null) return <String, QuranTeachingMistakeItem>{};
    final output = <String, QuranTeachingMistakeItem>{};
    for (final entry in json.entries) {
      final parsed = QuranTeachingMistakeItem.fromJson(
        entry.value as Map<String, dynamic>?,
      );
      if (parsed != null) {
        output[entry.key] = parsed;
      }
    }
    return output;
  }

  void _save() {
    final payload = state.map((key, value) => MapEntry(key, value.toJson()));
    _store.setJsonMap(_quranTeachingMistakesKey, payload);
  }

  void recordMistake({
    required QuranTeachingLesson lesson,
    required QuranTeachingQuizItem quiz,
    String? selectedOptionId,
    List<String> selectedTokens = const <String>[],
  }) {
    final existing = state[quiz.id];
    final now = DateTime.now();
    final nextDue = now.add(
      Duration(
        hours: existing == null ? 4 : (existing.totalWrongCount + 1) * 3,
      ),
    );
    final updated =
        (existing ??
                QuranTeachingMistakeItem(
                  quizId: quiz.id,
                  lessonId: lesson.id,
                  moduleId: lesson.moduleId,
                  quizType: quiz.type,
                  prompt: quiz.prompt,
                  promptArabic: quiz.promptArabic,
                  promptSecondary: quiz.promptSecondary,
                  audio: quiz.audio,
                  promptImageAssetPath: quiz.promptImageAssetPath,
                  options: quiz.options,
                  correctOptionIds: quiz.correctOptionIds,
                  buildOrder: quiz.buildOrder,
                  truthAnswer: quiz.truthAnswer,
                  feedbackCorrect: quiz.feedbackCorrect,
                  feedbackIncorrect: quiz.feedbackIncorrect,
                  lastWrongAt: now,
                ))
            .copyWith(
              lastSelectedOptionId: selectedOptionId,
              lastSelectedTokens: selectedTokens,
              lastWrongAt: now,
              totalWrongCount: (existing?.totalWrongCount ?? 0) + 1,
              successStreak: 0,
              state: existing == null
                  ? QuranTeachingMistakeState.newMistake
                  : QuranTeachingMistakeState.dueReview,
              nextDueAt: nextDue,
            );
    state = {...state, quiz.id: updated};
    _save();
  }

  void recordReviewResult(String quizId, {required bool correct}) {
    final item = state[quizId];
    if (item == null) return;
    final now = DateTime.now();
    if (!correct) {
      state = {
        ...state,
        quizId: item.copyWith(
          lastWrongAt: now,
          totalWrongCount: item.totalWrongCount + 1,
          totalReviewCount: item.totalReviewCount + 1,
          successStreak: 0,
          state: QuranTeachingMistakeState.dueReview,
          nextDueAt: now.add(Duration(hours: 6 + item.totalWrongCount)),
        ),
      };
      _save();
      return;
    }

    final nextStreak = item.successStreak + 1;
    final nextState = nextStreak >= 3
        ? QuranTeachingMistakeState.mastered
        : (nextStreak == 1
              ? QuranTeachingMistakeState.improving
              : QuranTeachingMistakeState.dueReview);
    final updated = item.copyWith(
      totalReviewCount: item.totalReviewCount + 1,
      successStreak: nextStreak,
      state: nextState,
      nextDueAt: nextStreak >= 3
          ? now.add(const Duration(days: 30))
          : now.add(Duration(hours: 12 * nextStreak)),
    );
    state = {...state, quizId: updated};
    _save();
  }
}

final quranTeachingListenOnlyProvider =
    StateNotifierProvider<
      QuranTeachingListenOnlyController,
      QuranTeachingListenOnlyState
    >((ref) {
      return QuranTeachingListenOnlyController(ref.watch(localStoreProvider));
    });

final quranTeachingMistakeQueueProvider =
    StateNotifierProvider<
      QuranTeachingMistakeReviewController,
      Map<String, QuranTeachingMistakeItem>
    >((ref) {
      return QuranTeachingMistakeReviewController(
        ref.watch(localStoreProvider),
      );
    });

final quranTeachingActiveMistakesProvider =
    Provider<List<QuranTeachingMistakeItem>>((ref) {
      final items =
          ref
              .watch(quranTeachingMistakeQueueProvider)
              .values
              .where((item) => item.state != QuranTeachingMistakeState.mastered)
              .toList(growable: true)
            ..sort((a, b) {
              final score = b.priorityScore.compareTo(a.priorityScore);
              if (score != 0) return score;
              return b.lastWrongAt.compareTo(a.lastWrongAt);
            });
      return items;
    });

final quranTeachingRecentLessonsProvider = Provider<List<QuranTeachingLesson>>((
  ref,
) {
  final catalog = ref.watch(quranTeachingCatalogProvider);
  final progress = ref.watch(quranTeachingProgressProvider);
  return progress.recentLessonIds
      .map(catalog.lessonById)
      .whereType<QuranTeachingLesson>()
      .toList(growable: false);
});

final quranTeachingBeginnerWordsProvider = Provider<List<QuranWordEntry>>((
  ref,
) {
  final catalog = ref.watch(quranTeachingCatalogProvider);
  final module = catalog.moduleById('recognize_words');
  final adultWordsBySharedId = <String, QuranWordEntry>{};
  if (module != null) {
    for (final group in module.wordGroups) {
      for (final word in group.words) {
        if (word.sharedBeginnerWordId != null) {
          adultWordsBySharedId[word.sharedBeginnerWordId!] = word;
        }
      }
    }
  }

  return arabicSharedBeginnerWordOrderIds
      .map((sharedId) {
        final shared = arabicSharedBeginnerWordById(sharedId)!;
        final existing = adultWordsBySharedId[sharedId];
        if (existing != null) {
          return existing;
        }
        return QuranWordEntry(
          id: 'shared_$sharedId',
          arabic: shared.arabicText,
          transliteration:
              '${shared.transliteration[0].toUpperCase()}${shared.transliteration.substring(1)}',
          meaning: shared.simpleMeaning,
          frequencyLabel: 'Beginner word',
          audio: QuranAudioCue(
            id: shared.audioLookupId ?? 'shared_$sharedId',
            label:
                '${shared.transliteration[0].toUpperCase()}${shared.transliteration.substring(1)}',
            assetPath: shared.audioAssetPath,
            fallbackTextLabel: shared.arabicText,
          ),
          exampleReference: shared.sourceReference,
          categoryTag: shared.categoryTag,
          sharedBeginnerWordId: shared.id,
          letterIds: shared.letterIds,
        );
      })
      .toList(growable: false);
});

bool isModuleUnlocked({
  required QuranTeachingModule module,
  required QuranTeachingCatalog catalog,
  required QuranTeachingProgressState progress,
}) {
  switch (progress.accessMode) {
    case QuranTeachingAccessMode.open:
      return true;
    case QuranTeachingAccessMode.broad:
      return module.order <= 4 || progress.completedLessonIds.length >= 4;
    case QuranTeachingAccessMode.guided:
      if (module.order == 0) return true;
      final previousModules = catalog.modules.where(
        (item) => item.order < module.order,
      );
      for (final previousModule in previousModules) {
        final previousLessons = catalog.lessonsForModule(previousModule.id);
        if (previousLessons.isEmpty) continue;
        final done = previousLessons.where(
          (lesson) => progress.completedLessonIds.contains(lesson.id),
        );
        if (done.length < previousLessons.length) {
          return false;
        }
      }
      return true;
  }
}

bool isLessonUnlocked({
  required QuranTeachingLesson lesson,
  required QuranTeachingModule module,
  required QuranTeachingCatalog catalog,
  required QuranTeachingProgressState progress,
}) {
  if (!isModuleUnlocked(module: module, catalog: catalog, progress: progress)) {
    return false;
  }

  switch (progress.accessMode) {
    case QuranTeachingAccessMode.open:
      return true;
    case QuranTeachingAccessMode.broad:
      return lesson.order <= 1 ||
          progress.completedLessonIds.length >= lesson.order;
    case QuranTeachingAccessMode.guided:
      if (lesson.order == 0) return true;
      final lessons = catalog.lessonsForModule(module.id);
      final previous = lessons.where((item) => item.order < lesson.order);
      for (final item in previous) {
        if (!progress.completedLessonIds.contains(item.id)) {
          return false;
        }
      }
      return true;
  }
}

double moduleCompletionPercent({
  required QuranTeachingModule module,
  required QuranTeachingCatalog catalog,
  required QuranTeachingProgressState progress,
}) {
  final lessons = catalog.lessonsForModule(module.id);
  if (lessons.isEmpty) return 0;
  final completed = lessons.where(
    (lesson) => progress.completedLessonIds.contains(lesson.id),
  );
  return completed.length / lessons.length;
}
