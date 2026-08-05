import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../domain/hadith_reflection_models.dart';

const _hadithReflectionProgressKey = 'learn.hadith_reflection.progress.v1';

final hadithReflectionProgressProvider =
    StateNotifierProvider<
      HadithReflectionProgressNotifier,
      HadithReflectionProgressState
    >((ref) {
      return HadithReflectionProgressNotifier(ref.watch(localStoreProvider));
    });

class HadithReflectionProgressNotifier
    extends StateNotifier<HadithReflectionProgressState> {
  HadithReflectionProgressNotifier(this._store)
    : super(HadithReflectionProgressState.initial()) {
    _load();
  }

  final LocalStore _store;

  void _load() {
    state = HadithReflectionProgressState.fromJson(
      _store.getJsonMap(_hadithReflectionProgressKey),
    );
  }

  void _save() {
    _store.setJsonMap(_hadithReflectionProgressKey, state.toJson());
  }

  HadithReflectionPuzzleProgress _updatePuzzleProgress(
    String puzzleId,
    HadithReflectionPuzzleProgress Function(HadithReflectionPuzzleProgress)
    update,
  ) {
    final current = state.progressFor(puzzleId);
    final next = update(current);
    state = state.copyWith(
      progressByPuzzleId: {...state.progressByPuzzleId, puzzleId: next},
    );
    _save();
    return next;
  }

  HadithReflectionDailyProgress _updateDailyProgress(
    String dateKey,
    HadithReflectionDailyProgress Function(HadithReflectionDailyProgress)
    update,
  ) {
    final current =
        state.dailyProgressFor(dateKey) ??
        HadithReflectionDailyProgress(dateKey: dateKey, puzzleId: '');
    final next = update(current);
    state = state.copyWith(
      dailyProgressByDateKey: {...state.dailyProgressByDateKey, dateKey: next},
    );
    _save();
    return next;
  }

  void markPuzzlePlayed({
    required String puzzleId,
    required DateTime occurredAt,
  }) {
    _updatePuzzleProgress(puzzleId, (current) {
      final stamp = occurredAt.toIso8601String();
      return current.copyWith(
        startedAtIso: current.startedAtIso ?? stamp,
        lastPlayedAtIso: stamp,
      );
    });
  }

  void selectChoice({
    required String puzzleId,
    required String choiceId,
    required DateTime occurredAt,
  }) {
    _updatePuzzleProgress(puzzleId, (current) {
      final stamp = occurredAt.toIso8601String();
      return current.copyWith(
        selectedChoiceId: choiceId,
        feedbackViewed: true,
        startedAtIso: current.startedAtIso ?? stamp,
        lastPlayedAtIso: stamp,
      );
    });
  }

  void markHelpViewed({
    required String puzzleId,
    required DateTime occurredAt,
  }) {
    _updatePuzzleProgress(puzzleId, (current) {
      final stamp = occurredAt.toIso8601String();
      return current.copyWith(
        helpViewed: true,
        startedAtIso: current.startedAtIso ?? stamp,
        lastPlayedAtIso: stamp,
      );
    });
  }

  bool markPuzzleCompleted({
    required String puzzleId,
    required bool bestChoice,
    required DateTime occurredAt,
  }) {
    var changed = false;
    _updatePuzzleProgress(puzzleId, (current) {
      final stamp = occurredAt.toIso8601String();
      if (!current.isCompleted || (bestChoice && !current.isBestChoice)) {
        changed = true;
      }
      return current.copyWith(
        completedAtIso: current.completedAtIso ?? stamp,
        bestChoiceCompletedAtIso: bestChoice
            ? (current.bestChoiceCompletedAtIso ?? stamp)
            : current.bestChoiceCompletedAtIso,
        lastPlayedAtIso: stamp,
      );
    });
    return changed;
  }

  bool markCompletionRewardGranted({
    required String puzzleId,
    required DateTime occurredAt,
  }) {
    var changed = false;
    _updatePuzzleProgress(puzzleId, (current) {
      if ((current.completionRewardGrantedAtIso ?? '').isNotEmpty) {
        return current;
      }
      changed = true;
      return current.copyWith(
        completionRewardGrantedAtIso: occurredAt.toIso8601String(),
      );
    });
    return changed;
  }

  bool markBestChoiceRewardGranted({
    required String puzzleId,
    required DateTime occurredAt,
  }) {
    var changed = false;
    _updatePuzzleProgress(puzzleId, (current) {
      if ((current.bestChoiceRewardGrantedAtIso ?? '').isNotEmpty) {
        return current;
      }
      changed = true;
      return current.copyWith(
        bestChoiceRewardGrantedAtIso: occurredAt.toIso8601String(),
      );
    });
    return changed;
  }

  void markDailyStarted({
    required String dateKey,
    required String puzzleId,
    required String weekdayTheme,
    required DateTime occurredAt,
  }) {
    _updateDailyProgress(dateKey, (current) {
      return HadithReflectionDailyProgress(
        dateKey: dateKey,
        puzzleId: puzzleId,
        weekdayTheme: current.weekdayTheme ?? weekdayTheme,
        startedAtIso: current.startedAtIso ?? occurredAt.toIso8601String(),
        completedAtIso: current.completedAtIso,
        bestChoiceCompletedAtIso: current.bestChoiceCompletedAtIso,
        dailyRewardGrantedAtIso: current.dailyRewardGrantedAtIso,
      );
    });
  }

  bool markDailyCompleted({
    required String dateKey,
    required String puzzleId,
    required String weekdayTheme,
    required bool bestChoice,
    required DateTime occurredAt,
  }) {
    var changed = false;
    _updateDailyProgress(dateKey, (current) {
      final stamp = occurredAt.toIso8601String();
      if ((current.completedAtIso ?? '').isEmpty) {
        changed = true;
      }
      return HadithReflectionDailyProgress(
        dateKey: dateKey,
        puzzleId: puzzleId,
        weekdayTheme: current.weekdayTheme ?? weekdayTheme,
        startedAtIso: current.startedAtIso ?? stamp,
        completedAtIso: current.completedAtIso ?? stamp,
        bestChoiceCompletedAtIso: bestChoice
            ? (current.bestChoiceCompletedAtIso ?? stamp)
            : current.bestChoiceCompletedAtIso,
        dailyRewardGrantedAtIso: current.dailyRewardGrantedAtIso,
      );
    });
    return changed;
  }

  bool markDailyRewardGranted({
    required String dateKey,
    required DateTime occurredAt,
  }) {
    var changed = false;
    _updateDailyProgress(dateKey, (current) {
      if ((current.dailyRewardGrantedAtIso ?? '').isNotEmpty) {
        return current;
      }
      changed = true;
      return HadithReflectionDailyProgress(
        dateKey: current.dateKey,
        puzzleId: current.puzzleId,
        weekdayTheme: current.weekdayTheme,
        startedAtIso: current.startedAtIso,
        completedAtIso: current.completedAtIso,
        bestChoiceCompletedAtIso: current.bestChoiceCompletedAtIso,
        dailyRewardGrantedAtIso: occurredAt.toIso8601String(),
      );
    });
    return changed;
  }
}
