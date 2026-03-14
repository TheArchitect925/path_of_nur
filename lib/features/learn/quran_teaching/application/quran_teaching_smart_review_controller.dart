import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../domain/quran_teaching_models.dart';
import '../domain/quran_teaching_review_models.dart';
import 'quran_teaching_controller.dart';

const _quranTeachingSmartReviewKey = 'learn.quran.teaching.smart_review.v1';

const Map<QuranTeachingMemoryState, Duration> _reviewIntervals =
    <QuranTeachingMemoryState, Duration>{
      QuranTeachingMemoryState.newItem: Duration(hours: 8),
      QuranTeachingMemoryState.practicing: Duration(days: 1),
      QuranTeachingMemoryState.familiar: Duration(days: 3),
      QuranTeachingMemoryState.recognized: Duration(days: 7),
      QuranTeachingMemoryState.mastered: Duration(days: 14),
    };

class QuranTeachingDailyReviewSummary {
  const QuranTeachingDailyReviewSummary({
    required this.itemCount,
    required this.estimatedMinutes,
    required this.mixSummary,
    required this.hasAnyLearnedItems,
    required this.isComplete,
    required this.hasDueItems,
    required this.completedCount,
    required this.inProgress,
  });

  final int itemCount;
  final int estimatedMinutes;
  final String mixSummary;
  final bool hasAnyLearnedItems;
  final bool isComplete;
  final bool hasDueItems;
  final int completedCount;
  final bool inProgress;
}

class QuranTeachingReviewDashboardStats {
  const QuranTeachingReviewDashboardStats({
    required this.lettersReviewed,
    required this.wordsRecognized,
    required this.phrasesPracticed,
    required this.itemsDueToday,
    required this.trickyItems,
    required this.masteredCount,
  });

  final int lettersReviewed;
  final int wordsRecognized;
  final int phrasesPracticed;
  final int itemsDueToday;
  final int trickyItems;
  final int masteredCount;
}

class QuranTeachingPracticeRecommendation {
  const QuranTeachingPracticeRecommendation({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}

class QuranTeachingSmartReviewController
    extends StateNotifier<QuranTeachingSmartReviewState> {
  QuranTeachingSmartReviewController(this._store)
      : super(
          QuranTeachingSmartReviewState.fromJson(
            _store.getJsonMap(_quranTeachingSmartReviewKey),
          ),
        );

  final LocalStore _store;

  void _save() {
    _store.setJsonMap(_quranTeachingSmartReviewKey, state.toJson());
  }

  void registerLessonCompletion(QuranTeachingLesson lesson) {
    final now = DateTime.now();
    final updated = {...state.records};
    for (final step in lesson.steps) {
      final recordId = 'step:${lesson.id}:${step.id}';
      final existing = updated[recordId];
      updated[recordId] = (existing ??
              QuranTeachingReviewRecord(
                id: recordId,
                lessonId: lesson.id,
                moduleId: lesson.moduleId,
                contentType: _contentTypeForStep(lesson, step),
                prompt: _promptForStep(step),
                promptArabic: step.focusArabic,
                promptSecondary: step.title,
                transliteration: step.transliteration,
                meaning: step.examples.firstWhere(
                  (example) => example.meaning != null,
                  orElse: () => const QuranTeachingExample(arabic: ''),
                ).meaning,
                hintText: step.explanation,
                audio: step.audio,
                promptImageAssetPath:
                    step.visualAnchor?.imageAssetPath ??
                    step.examples.firstWhere(
                      (example) => example.imageAssetPath != null,
                      orElse: () => const QuranTeachingExample(arabic: ''),
                    ).imageAssetPath,
                tags: _tagsForLessonAndStep(lesson, step),
                availableInVisualMode: step.visualAnchor != null,
                memoryState: QuranTeachingMemoryState.newItem,
                nextDueAt: now.add(_reviewIntervals[QuranTeachingMemoryState.newItem]!),
              ))
          .copyWith(
            prompt: _promptForStep(step),
            promptArabic: step.focusArabic,
            promptSecondary: step.title,
            transliteration: step.transliteration,
            hintText: step.explanation,
            audio: step.audio,
            promptImageAssetPath:
                step.visualAnchor?.imageAssetPath ?? existing?.promptImageAssetPath,
            tags: _tagsForLessonAndStep(lesson, step),
            availableInVisualMode:
                existing?.availableInVisualMode == true || step.visualAnchor != null,
          );

      for (var i = 0; i < step.examples.length; i++) {
        final example = step.examples[i];
        if (example.arabic.trim().isEmpty) continue;
        final exampleId = 'example:${lesson.id}:${step.id}:$i';
        final exampleExisting = updated[exampleId];
        updated[exampleId] = (exampleExisting ??
                QuranTeachingReviewRecord(
                  id: exampleId,
                  lessonId: lesson.id,
                  moduleId: lesson.moduleId,
                  contentType: _contentTypeForExample(lesson, example),
                  prompt: _promptForExample(lesson, example),
                  promptArabic: example.arabic,
                  promptSecondary: example.note ?? step.title,
                  transliteration: example.transliteration,
                  meaning: example.meaning,
                  hintText: example.note ?? step.explanation,
                  audio: example.audio,
                  promptImageAssetPath:
                      example.imageAssetPath ?? example.visualAnchor?.imageAssetPath,
                  tags: _tagsForExample(lesson, step, example),
                  availableInVisualMode: example.visualAnchor != null,
                  memoryState: QuranTeachingMemoryState.newItem,
                  nextDueAt:
                      now.add(_reviewIntervals[QuranTeachingMemoryState.newItem]!),
                ))
            .copyWith(
              promptArabic: example.arabic,
              promptSecondary: example.note ?? step.title,
              transliteration: example.transliteration,
              meaning: example.meaning,
              hintText: example.note ?? step.explanation,
              audio: example.audio,
              promptImageAssetPath:
                  example.imageAssetPath ??
                  example.visualAnchor?.imageAssetPath ??
                  exampleExisting?.promptImageAssetPath,
              tags: _tagsForExample(lesson, step, example),
              availableInVisualMode:
                  exampleExisting?.availableInVisualMode == true ||
                  example.visualAnchor != null,
            );
      }
    }

    state = state.copyWith(records: updated);
    _save();
  }

  void recordQuizAttempt({
    required QuranTeachingLesson lesson,
    required QuranTeachingQuizItem quiz,
    required bool correct,
    required QuranTeachingReviewSource source,
  }) {
    final now = DateTime.now();
    final recordId = 'quiz:${quiz.id}';
    final existing = state.records[recordId];
    final tags = _tagsForQuiz(lesson, quiz);
    final updatedRecord = _applyOutcome(
      (existing ??
              QuranTeachingReviewRecord(
                id: recordId,
                lessonId: lesson.id,
                moduleId: lesson.moduleId,
                contentType: _contentTypeForQuiz(quiz, lesson),
                prompt: quiz.prompt,
                promptArabic: quiz.promptArabic,
                promptSecondary: quiz.promptSecondary,
                audio: quiz.audio,
                promptImageAssetPath: quiz.promptImageAssetPath,
                options: quiz.options,
                correctOptionIds: quiz.correctOptionIds,
                buildOrder: quiz.buildOrder,
                truthAnswer: quiz.truthAnswer,
                hintText: correct ? quiz.feedbackCorrect : quiz.feedbackIncorrect,
                tags: tags,
                availableInVisualMode: _supportsVisualMode(quiz),
                memoryState: QuranTeachingMemoryState.newItem,
                nextDueAt:
                    now.add(_reviewIntervals[QuranTeachingMemoryState.newItem]!),
              ))
          .copyWith(
            prompt: quiz.prompt,
            promptArabic: quiz.promptArabic,
            promptSecondary: quiz.promptSecondary,
            audio: quiz.audio,
            promptImageAssetPath: quiz.promptImageAssetPath,
            options: quiz.options,
            correctOptionIds: quiz.correctOptionIds,
            buildOrder: quiz.buildOrder,
            truthAnswer: quiz.truthAnswer,
            hintText: correct ? quiz.feedbackCorrect : quiz.feedbackIncorrect,
            tags: tags,
            availableInVisualMode: _supportsVisualMode(quiz),
          ),
      correct: correct,
      source: source,
      dateKey: _todayKey(now),
    );

    final updatedRecords = {...state.records, recordId: updatedRecord};
    final updatedWeakAreas = _updateWeakAreas(
      weakAreas: state.weakAreas,
      tags: tags,
      correct: correct,
      now: now,
    );
    state = state.copyWith(records: updatedRecords, weakAreas: updatedWeakAreas);
    _save();
  }

  void recordMistakeReviewOutcome({
    required QuranTeachingMistakeItem item,
    required bool correct,
  }) {
    final now = DateTime.now();
    final recordId = 'mistake:${item.quizId}';
    final tags = _tagsForMistake(item);
    final updatedRecord = _applyOutcome(
      (state.records[recordId] ??
              QuranTeachingReviewRecord(
                id: recordId,
                lessonId: item.lessonId,
                moduleId: item.moduleId,
                contentType: QuranTeachingReviewContentType.mistakeReviewItem,
                prompt: item.prompt,
                promptArabic: item.promptArabic,
                promptSecondary: item.promptSecondary,
                audio: item.audio,
                promptImageAssetPath: item.promptImageAssetPath,
                options: item.options,
                correctOptionIds: item.correctOptionIds,
                buildOrder: item.buildOrder,
                truthAnswer: item.truthAnswer,
                hintText:
                    correct ? item.feedbackCorrect : item.feedbackIncorrect,
                tags: tags,
                availableInVisualMode: _supportsVisualModeFromOptions(item.options),
                memoryState: QuranTeachingMemoryState.practicing,
                nextDueAt:
                    now.add(_reviewIntervals[QuranTeachingMemoryState.practicing]!),
              ))
          .copyWith(
            hintText: correct ? item.feedbackCorrect : item.feedbackIncorrect,
            tags: tags,
          ),
      correct: correct,
      source: QuranTeachingReviewSource.mistakeReview,
      dateKey: _todayKey(now),
    );

    state = state.copyWith(
      records: {...state.records, recordId: updatedRecord},
      weakAreas: _updateWeakAreas(
        weakAreas: state.weakAreas,
        tags: tags,
        correct: correct,
        now: now,
      ),
    );
    _save();
  }

  void ensureTodaySession({
    required QuranTeachingCatalog catalog,
    required QuranTeachingProgressState progress,
    required List<QuranTeachingMistakeItem> mistakes,
  }) {
    final todayKey = _todayKey(DateTime.now());
    final current = state.todaySession;
    if (current != null &&
        current.dateKey == todayKey &&
        current.itemRefs.isNotEmpty) {
      return;
    }
    if (current != null &&
        current.dateKey == todayKey &&
        current.itemRefs.isEmpty &&
        state.records.isEmpty) {
      return;
    }

    final visualModeEnabled = progress.visualModeEnabled;
    final dueRecords = state.records.values.where((record) {
      if (visualModeEnabled == false && record.contentType == QuranTeachingReviewContentType.visualModeItem) {
        return false;
      }
      return record.isDue || record.reviewCount == 0;
    }).toList(growable: true)
      ..sort((a, b) => b.priorityScore.compareTo(a.priorityScore));

    final selected = <String>[];

    void addMatching(
      bool Function(QuranTeachingReviewRecord record) predicate,
      int target,
    ) {
      for (final record in dueRecords) {
        if (selected.length >= 7) return;
        if (selected.where((item) => item.startsWith('record:')).length >=
                dueRecords.length &&
            dueRecords.isNotEmpty) {
          return;
        }
        final ref = 'record:${record.id}';
        if (!predicate(record) || selected.contains(ref)) continue;
        selected.add(ref);
        if (selected.where((item) => item.startsWith('record:')).length >= target) {
          break;
        }
      }
    }

    addMatching(_isLetterLike, 2);
    addMatching(_isWordLike, math.min(4, dueRecords.length));
    addMatching(_isPhraseLike, math.min(5, dueRecords.length));

    if (mistakes.isNotEmpty) {
      selected.add('mistake:${mistakes.first.quizId}');
    }

    final topWeakTag = state.weakAreas.values.isEmpty
        ? null
        : (state.weakAreas.values.toList(growable: false)
              ..sort((a, b) => b.priorityScore.compareTo(a.priorityScore)))
            .first
            .tag;

    if (topWeakTag != null) {
      for (final record in dueRecords) {
        final ref = 'record:${record.id}';
        if (selected.contains(ref)) continue;
        if (record.tags.contains(topWeakTag)) {
          selected.add(ref);
          break;
        }
      }
    }

    for (final record in dueRecords) {
      if (selected.length >= 7) break;
      final ref = 'record:${record.id}';
      if (!selected.contains(ref)) {
        selected.add(ref);
      }
    }

    final mixSummary = _buildMixSummary(
      selected: selected,
      records: state.records,
      mistakes: mistakes,
    );
    final estimatedMinutes = math.max(1, (selected.length * 25 / 60).ceil());
    state = state.copyWith(
      todaySession: QuranTeachingDailyReviewSession(
        dateKey: todayKey,
        itemRefs: selected,
        estimatedMinutes: estimatedMinutes,
        mixSummary: mixSummary,
      ),
    );
    _save();
  }

  void startTodaySession() {
    final session = state.todaySession;
    if (session == null || session.startedAt != null) return;
    state = state.copyWith(
      todaySession: session.copyWith(startedAt: DateTime.now()),
    );
    _save();
  }

  void completeTodayItem({
    required String itemRef,
    required bool correct,
  }) {
    final session = state.todaySession;
    if (session == null || session.completedItemRefs.contains(itemRef)) return;
    final completed = [...session.completedItemRefs, itemRef];
    final updatedSession = session.copyWith(
      completedItemRefs: completed,
      correctCount: session.correctCount + (correct ? 1 : 0),
      needsMoreCount: session.needsMoreCount + (correct ? 0 : 1),
      completedAt: completed.length >= session.itemRefs.length
          ? DateTime.now()
          : session.completedAt,
    );
    final updatedHistory = [...state.completedSessions];
    if (updatedSession.completedAt != null) {
      updatedHistory.removeWhere((item) => item.dateKey == updatedSession.dateKey);
      updatedHistory.insert(
        0,
        QuranTeachingCompletedReviewSession(
          dateKey: updatedSession.dateKey,
          itemCount: updatedSession.itemRefs.length,
          correctCount: updatedSession.correctCount,
          needsMoreCount: updatedSession.needsMoreCount,
          completedAt: updatedSession.completedAt!,
        ),
      );
    }
    state = state.copyWith(
      todaySession: updatedSession,
      completedSessions: updatedHistory.take(14).toList(growable: false),
    );
    _save();
  }

  void recordDailyReviewOutcome({
    required String recordId,
    required bool correct,
  }) {
    final existing = state.records[recordId];
    if (existing == null) return;
    final now = DateTime.now();
    final updated = _applyOutcome(
      existing,
      correct: correct,
      source: QuranTeachingReviewSource.dailyReview,
      dateKey: _todayKey(now),
    );
    state = state.copyWith(
      records: {...state.records, recordId: updated},
      weakAreas: _updateWeakAreas(
        weakAreas: state.weakAreas,
        tags: updated.tags,
        correct: correct,
        now: now,
      ),
    );
    _save();
  }
}

final quranTeachingSmartReviewProvider = StateNotifierProvider<
  QuranTeachingSmartReviewController,
  QuranTeachingSmartReviewState
>((ref) {
  return QuranTeachingSmartReviewController(ref.watch(localStoreProvider));
});

final quranTeachingDailyReviewSummaryProvider =
    Provider<QuranTeachingDailyReviewSummary>((ref) {
      final review = ref.watch(quranTeachingSmartReviewProvider);
      final session = review.todaySession;
      final hasAnyLearnedItems = review.records.isNotEmpty;
      final dueItems = review.records.values.where((record) => record.isDue).length;
      return QuranTeachingDailyReviewSummary(
        itemCount: session?.itemRefs.length ?? 0,
        estimatedMinutes: session?.estimatedMinutes ?? 0,
        mixSummary: session?.mixSummary ?? '',
        hasAnyLearnedItems: hasAnyLearnedItems,
        isComplete: session?.isComplete == true,
        hasDueItems: dueItems > 0 || (session?.itemRefs.isNotEmpty ?? false),
        completedCount: session?.completedItemRefs.length ?? 0,
        inProgress: session != null &&
            session.completedItemRefs.isNotEmpty &&
            session.isComplete == false,
      );
    });

final quranTeachingReviewDashboardStatsProvider =
    Provider<QuranTeachingReviewDashboardStats>((ref) {
      final review = ref.watch(quranTeachingSmartReviewProvider);
      final activeMistakes = ref.watch(quranTeachingActiveMistakesProvider);
      final records = review.records.values.toList(growable: false);
      return QuranTeachingReviewDashboardStats(
        lettersReviewed: records
            .where((item) => _isLetterLike(item) && item.reviewCount > 0)
            .length,
        wordsRecognized: records
            .where(
              (item) =>
                  _isWordLike(item) &&
                  item.memoryState.index >=
                      QuranTeachingMemoryState.familiar.index,
            )
            .length,
        phrasesPracticed: records
            .where((item) => _isPhraseLike(item) && item.reviewCount > 0)
            .length,
        itemsDueToday:
            records.where((item) => item.isDue).length + activeMistakes.length,
        trickyItems: records
                .where((item) => item.failureCount > item.successCount)
                .length +
            review.weakAreas.values
                .where((item) => item.failureCount > item.successCount)
                .length,
        masteredCount: records
            .where((item) => item.memoryState == QuranTeachingMemoryState.mastered)
            .length,
      );
    });

final quranTeachingPracticeRecommendationsProvider =
    Provider<List<QuranTeachingPracticeRecommendation>>((ref) {
      final review = ref.watch(quranTeachingSmartReviewProvider);
      final recommendations = <QuranTeachingPracticeRecommendation>[];
      final weakAreas = review.weakAreas.values.toList(growable: true)
        ..sort((a, b) => b.priorityScore.compareTo(a.priorityScore));

      if (weakAreas.isNotEmpty) {
        recommendations.add(
          QuranTeachingPracticeRecommendation(
            title: _recommendationTitleForTag(weakAreas.first.tag),
            subtitle:
                'A few recent misses suggest this area needs another calm pass.',
            icon: Icons.auto_fix_high_rounded,
          ),
        );
      }

      final dueWords = review.records.values.where(_isWordLike).where((r) => r.isDue).length;
      if (dueWords > 0) {
        recommendations.add(
          QuranTeachingPracticeRecommendation(
            title: 'Revisit learned words',
            subtitle: '$dueWords word items are ready for another look.',
            icon: Icons.menu_book_rounded,
          ),
        );
      }

      final duePhrases =
          review.records.values.where(_isPhraseLike).where((r) => r.isDue).length;
      if (duePhrases > 0) {
        recommendations.add(
          QuranTeachingPracticeRecommendation(
            title: 'Read these phrases again',
            subtitle: '$duePhrases phrase items are ready for review.',
            icon: Icons.short_text_rounded,
          ),
        );
      }

      if (recommendations.isEmpty && review.records.isNotEmpty) {
        recommendations.add(
          const QuranTeachingPracticeRecommendation(
            title: 'Keep today light',
            subtitle: 'A short mixed review will keep recent lessons fresh.',
            icon: Icons.wb_twilight_rounded,
          ),
        );
      }

      return recommendations.take(3).toList(growable: false);
    });

QuranTeachingReviewRecord _applyOutcome(
  QuranTeachingReviewRecord record, {
  required bool correct,
  required QuranTeachingReviewSource source,
  required String dateKey,
}) {
  final now = DateTime.now();
  final nextSuccess = record.successCount + (correct ? 1 : 0);
  final nextFailure = record.failureCount + (correct ? 0 : 1);
  final nextStreak = correct ? record.correctStreak + 1 : 0;
  final nextState = _nextMemoryState(
    current: record.memoryState,
    correct: correct,
    streak: nextStreak,
  );
  final baseInterval = _reviewIntervals[nextState]!;
  final interval = correct
      ? baseInterval
      : Duration(hours: math.max(6, baseInterval.inHours ~/ 2));

  return record.copyWith(
    memoryState: nextState,
    lastReviewedAt: now,
    nextDueAt: now.add(interval),
    lastSessionDateKey: dateKey,
    lastReviewSource: source,
    reviewCount: record.reviewCount + 1,
    successCount: nextSuccess,
    failureCount: nextFailure,
    correctStreak: nextStreak,
    priorityBoost: correct
        ? math.max(0, record.priorityBoost - 1)
        : record.priorityBoost + 2,
  );
}

Map<String, QuranTeachingWeakArea> _updateWeakAreas({
  required Map<String, QuranTeachingWeakArea> weakAreas,
  required List<String> tags,
  required bool correct,
  required DateTime now,
}) {
  final updated = {...weakAreas};
  for (final tag in tags) {
    final current =
        updated[tag] ??
        const QuranTeachingWeakArea(
          tag: '',
          failureCount: 0,
          successCount: 0,
          reviewCount: 0,
        );
    updated[tag] = QuranTeachingWeakArea(
      tag: tag,
      failureCount: current.failureCount + (correct ? 0 : 1),
      successCount: current.successCount + (correct ? 1 : 0),
      reviewCount: current.reviewCount + 1,
      lastSeenAt: now,
    );
  }
  return updated;
}

QuranTeachingMemoryState _nextMemoryState({
  required QuranTeachingMemoryState current,
  required bool correct,
  required int streak,
}) {
  if (!correct) {
    switch (current) {
      case QuranTeachingMemoryState.mastered:
        return QuranTeachingMemoryState.recognized;
      case QuranTeachingMemoryState.recognized:
        return QuranTeachingMemoryState.familiar;
      case QuranTeachingMemoryState.familiar:
      case QuranTeachingMemoryState.practicing:
      case QuranTeachingMemoryState.newItem:
        return QuranTeachingMemoryState.practicing;
    }
  }

  switch (current) {
    case QuranTeachingMemoryState.newItem:
      return QuranTeachingMemoryState.practicing;
    case QuranTeachingMemoryState.practicing:
      return streak >= 2
          ? QuranTeachingMemoryState.familiar
          : QuranTeachingMemoryState.practicing;
    case QuranTeachingMemoryState.familiar:
      return streak >= 3
          ? QuranTeachingMemoryState.recognized
          : QuranTeachingMemoryState.familiar;
    case QuranTeachingMemoryState.recognized:
      return streak >= 4
          ? QuranTeachingMemoryState.mastered
          : QuranTeachingMemoryState.recognized;
    case QuranTeachingMemoryState.mastered:
      return QuranTeachingMemoryState.mastered;
  }
}

QuranTeachingReviewContentType _contentTypeForStep(
  QuranTeachingLesson lesson,
  QuranTeachingStep step,
) {
  switch (step.type) {
    case QuranTeachingStepType.letterIntroduction:
      return QuranTeachingReviewContentType.letter;
    case QuranTeachingStepType.letterShapes:
      return QuranTeachingReviewContentType.letterForm;
    case QuranTeachingStepType.harakat:
      return lesson.tags.contains('long_vowel')
          ? QuranTeachingReviewContentType.longVowel
          : QuranTeachingReviewContentType.harakahSound;
    case QuranTeachingStepType.wordFormation:
      return step.focusArabic.contains(' ')
          ? QuranTeachingReviewContentType.phrase
          : QuranTeachingReviewContentType.shortWord;
    case QuranTeachingStepType.rule:
      return QuranTeachingReviewContentType.rule;
    case QuranTeachingStepType.phrase:
      return QuranTeachingReviewContentType.phrase;
  }
}

QuranTeachingReviewContentType _contentTypeForExample(
  QuranTeachingLesson lesson,
  QuranTeachingExample example,
) {
  if (example.visualAnchor != null) {
    return QuranTeachingReviewContentType.visualModeItem;
  }
  if (lesson.moduleId == 'recognize_quran_words') {
    return QuranTeachingReviewContentType.quranWord;
  }
  if (example.arabic.contains(' ')) {
    return QuranTeachingReviewContentType.phrase;
  }
  return QuranTeachingReviewContentType.shortWord;
}

QuranTeachingReviewContentType _contentTypeForQuiz(
  QuranTeachingQuizItem quiz,
  QuranTeachingLesson lesson,
) {
  switch (quiz.type) {
    case QuranTeachingQuizType.audioSelectLetter:
    case QuranTeachingQuizType.identifyLetter:
      return QuranTeachingReviewContentType.letter;
    case QuranTeachingQuizType.audioSelectHarakahForm:
    case QuranTeachingQuizType.promptSelectCorrectForm:
      return lesson.tags.contains('long_vowel')
          ? QuranTeachingReviewContentType.longVowel
          : QuranTeachingReviewContentType.harakahSound;
    case QuranTeachingQuizType.matchLetterToPicture:
    case QuranTeachingQuizType.matchPictureToLetter:
      return QuranTeachingReviewContentType.visualModeItem;
    case QuranTeachingQuizType.wordAudio:
      return lesson.moduleId == 'recognize_quran_words'
          ? QuranTeachingReviewContentType.quranWord
          : QuranTeachingReviewContentType.shortWord;
    case QuranTeachingQuizType.ruleIdentification:
      return QuranTeachingReviewContentType.rule;
    case QuranTeachingQuizType.tapInOrderBuildWord:
      return QuranTeachingReviewContentType.phrase;
    case QuranTeachingQuizType.trueFalse:
      return QuranTeachingReviewContentType.quizItem;
  }
}

String _promptForStep(QuranTeachingStep step) {
  switch (step.type) {
    case QuranTeachingStepType.letterIntroduction:
      return 'Remember this letter.';
    case QuranTeachingStepType.letterShapes:
      return 'Notice this letter shape.';
    case QuranTeachingStepType.harakat:
      return 'Listen and remember this sound.';
    case QuranTeachingStepType.wordFormation:
      return 'Read this short form again.';
    case QuranTeachingStepType.rule:
      return 'Recall what this rule does.';
    case QuranTeachingStepType.phrase:
      return 'Read this phrase calmly.';
  }
}

String _promptForExample(
  QuranTeachingLesson lesson,
  QuranTeachingExample example,
) {
  if (lesson.moduleId == 'recognize_quran_words') {
    return 'Remember this Qur’an word.';
  }
  if (example.arabic.contains(' ')) {
    return 'Read this phrase again.';
  }
  return 'Practice this example.';
}

List<String> _tagsForLessonAndStep(
  QuranTeachingLesson lesson,
  QuranTeachingStep step,
) {
  final tags = <String>{...lesson.tags, lesson.moduleId, step.type.name};
  switch (step.type) {
    case QuranTeachingStepType.letterIntroduction:
      tags.add('alphabet');
      break;
    case QuranTeachingStepType.letterShapes:
      tags.add('similar_letters');
      break;
    case QuranTeachingStepType.harakat:
      tags.add(lesson.tags.contains('long_vowel') ? 'long_vowel' : 'harakat');
      break;
    case QuranTeachingStepType.wordFormation:
      tags.add('word_reading');
      break;
    case QuranTeachingStepType.rule:
      tags.add('reading_rules');
      break;
    case QuranTeachingStepType.phrase:
      tags.add('phrase_reading');
      break;
  }
  return tags.toList(growable: false);
}

List<String> _tagsForExample(
  QuranTeachingLesson lesson,
  QuranTeachingStep step,
  QuranTeachingExample example,
) {
  final tags = <String>{..._tagsForLessonAndStep(lesson, step)};
  if (lesson.moduleId == 'recognize_quran_words') {
    tags.add('word_meaning');
  }
  if (example.visualAnchor != null) {
    tags.add('visual_mode');
  }
  if (example.arabic.contains(' ')) {
    tags.add('phrase_reading');
  }
  return tags.toList(growable: false);
}

List<String> _tagsForQuiz(
  QuranTeachingLesson lesson,
  QuranTeachingQuizItem quiz,
) {
  final tags = <String>{...lesson.tags, lesson.moduleId, quiz.type.name};
  switch (quiz.type) {
    case QuranTeachingQuizType.audioSelectLetter:
    case QuranTeachingQuizType.identifyLetter:
      tags.add('alphabet');
      break;
    case QuranTeachingQuizType.audioSelectHarakahForm:
    case QuranTeachingQuizType.promptSelectCorrectForm:
      tags.add('harakat');
      break;
    case QuranTeachingQuizType.matchLetterToPicture:
    case QuranTeachingQuizType.matchPictureToLetter:
      tags.addAll(<String>['visual_mode', 'similar_letters']);
      break;
    case QuranTeachingQuizType.wordAudio:
      tags.addAll(<String>['word_meaning', 'word_recognition']);
      break;
    case QuranTeachingQuizType.ruleIdentification:
      tags.add('reading_rules');
      break;
    case QuranTeachingQuizType.tapInOrderBuildWord:
      tags.add('phrase_reading');
      break;
    case QuranTeachingQuizType.trueFalse:
      tags.add('quick_review');
      break;
  }
  return tags.toList(growable: false);
}

List<String> _tagsForMistake(QuranTeachingMistakeItem item) {
  final tags = <String>{'mistake_review', item.quizType.name};
  switch (item.quizType) {
    case QuranTeachingQuizType.audioSelectLetter:
    case QuranTeachingQuizType.identifyLetter:
      tags.add('alphabet');
      break;
    case QuranTeachingQuizType.audioSelectHarakahForm:
    case QuranTeachingQuizType.promptSelectCorrectForm:
      tags.add('harakat');
      break;
    case QuranTeachingQuizType.matchLetterToPicture:
    case QuranTeachingQuizType.matchPictureToLetter:
      tags.addAll(<String>['visual_mode', 'similar_letters']);
      break;
    case QuranTeachingQuizType.wordAudio:
      tags.addAll(<String>['word_meaning', 'word_recognition']);
      break;
    case QuranTeachingQuizType.ruleIdentification:
      tags.add('reading_rules');
      break;
    case QuranTeachingQuizType.tapInOrderBuildWord:
      tags.add('phrase_reading');
      break;
    case QuranTeachingQuizType.trueFalse:
      tags.add('quick_review');
      break;
  }
  return tags.toList(growable: false);
}

bool _supportsVisualMode(QuranTeachingQuizItem quiz) {
  if (quiz.promptImageAssetPath != null) return true;
  for (final option in quiz.options) {
    if (option.imageAssetPath != null) return true;
  }
  return false;
}

bool _supportsVisualModeFromOptions(List<QuranTeachingQuizOption> options) {
  for (final option in options) {
    if (option.imageAssetPath != null) return true;
  }
  return false;
}

String _todayKey(DateTime value) {
  final date = DateUtils.dateOnly(value);
  return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

bool _isLetterLike(QuranTeachingReviewRecord record) {
  return record.contentType == QuranTeachingReviewContentType.letter ||
      record.contentType == QuranTeachingReviewContentType.letterForm ||
      record.contentType == QuranTeachingReviewContentType.harakahSound ||
      record.contentType == QuranTeachingReviewContentType.longVowel;
}

bool _isWordLike(QuranTeachingReviewRecord record) {
  return record.contentType == QuranTeachingReviewContentType.shortWord ||
      record.contentType == QuranTeachingReviewContentType.quranWord;
}

bool _isPhraseLike(QuranTeachingReviewRecord record) {
  return record.contentType == QuranTeachingReviewContentType.phrase ||
      record.contentType == QuranTeachingReviewContentType.rule;
}

String _buildMixSummary({
  required List<String> selected,
  required Map<String, QuranTeachingReviewRecord> records,
  required List<QuranTeachingMistakeItem> mistakes,
}) {
  var letters = 0;
  var words = 0;
  var phrases = 0;
  var tricky = 0;

  for (final ref in selected) {
    if (ref.startsWith('mistake:')) {
      tricky += 1;
      continue;
    }
    final record = records[ref.replaceFirst('record:', '')];
    if (record == null) continue;
    if (_isLetterLike(record)) {
      letters += 1;
    } else if (_isWordLike(record)) {
      words += 1;
    } else if (_isPhraseLike(record)) {
      phrases += 1;
    }
    if (record.failureCount > record.successCount) {
      tricky += 1;
    }
  }

  final parts = <String>[];
  if (letters > 0) parts.add('$letters letters');
  if (words > 0) parts.add('$words words');
  if (phrases > 0) parts.add('$phrases phrases');
  if (tricky > 0 || mistakes.isNotEmpty) {
    parts.add('${math.max(tricky, mistakes.isNotEmpty ? 1 : 0)} tricky item${math.max(tricky, mistakes.isNotEmpty ? 1 : 0) == 1 ? '' : 's'}');
  }
  return parts.isEmpty ? 'A short mixed review.' : parts.join(', ');
}

String _recommendationTitleForTag(String tag) {
  switch (tag) {
    case 'harakat':
      return 'Review Harakat Sounds';
    case 'similar_letters':
      return 'Practice Similar Letters';
    case 'word_meaning':
    case 'word_recognition':
      return 'Revisit Learned Words';
    case 'phrase_reading':
      return 'Read Short Phrases Again';
    case 'reading_rules':
      return 'Go Over Reading Rules';
    default:
      return 'Practice Weak Areas';
  }
}
