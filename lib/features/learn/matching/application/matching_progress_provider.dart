import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../domain/matching_models.dart';

const _matchingProgressKey = 'learn.matching.progress.v1';

final matchingProgressProvider =
    StateNotifierProvider<MatchingProgressNotifier, MatchingProgressState>((
      ref,
    ) {
      return MatchingProgressNotifier(ref.watch(localStoreProvider));
    });

class MatchingProgressNotifier extends StateNotifier<MatchingProgressState> {
  MatchingProgressNotifier(this._store)
    : super(MatchingProgressState.initial()) {
    _load();
  }

  final LocalStore _store;

  void _load() {
    state = MatchingProgressState.fromJson(
      _store.getJsonMap(_matchingProgressKey),
    );
  }

  void _save() {
    _store.setJsonMap(_matchingProgressKey, state.toJson());
  }

  MatchingPuzzleProgress _updatePuzzleProgress(
    String puzzleId,
    MatchingPuzzleProgress Function(MatchingPuzzleProgress current) update,
  ) {
    final current = state.progressFor(puzzleId);
    final next = update(current);
    state = state.copyWith(
      progressByPuzzleId: {...state.progressByPuzzleId, puzzleId: next},
    );
    _save();
    return next;
  }

  MatchingDailyProgress _updateDailyProgress(
    String dateKey,
    MatchingDailyProgress Function(MatchingDailyProgress current) update,
  ) {
    final current =
        state.dailyProgressFor(dateKey) ??
        MatchingDailyProgress(dateKey: dateKey, puzzleId: '');
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

  void setSelection({
    required String puzzleId,
    String? leftPairId,
    String? rightPairId,
    required DateTime occurredAt,
  }) {
    _updatePuzzleProgress(puzzleId, (current) {
      return current.copyWith(
        selectedLeftPairId: leftPairId,
        clearSelectedLeftPairId: leftPairId == null,
        selectedRightPairId: rightPairId,
        clearSelectedRightPairId: rightPairId == null,
        startedAtIso: current.startedAtIso ?? occurredAt.toIso8601String(),
        lastPlayedAtIso: occurredAt.toIso8601String(),
      );
    });
  }

  void markMistake({required String puzzleId, required DateTime occurredAt}) {
    _updatePuzzleProgress(puzzleId, (current) {
      return current.copyWith(
        hadMistake: true,
        lastPlayedAtIso: occurredAt.toIso8601String(),
      );
    });
  }

  bool markPairMatched({
    required String puzzleId,
    required String pairId,
    required DateTime occurredAt,
  }) {
    var changed = false;
    _updatePuzzleProgress(puzzleId, (current) {
      if (current.matchedPairIds.contains(pairId)) {
        return current.copyWith(lastPlayedAtIso: occurredAt.toIso8601String());
      }
      changed = true;
      final matched = Set<String>.from(current.matchedPairIds)..add(pairId);
      return current.copyWith(
        matchedPairIds: matched,
        selectedLeftPairId: null,
        clearSelectedLeftPairId: true,
        selectedRightPairId: null,
        clearSelectedRightPairId: true,
        lastPlayedAtIso: occurredAt.toIso8601String(),
      );
    });
    return changed;
  }

  bool revealPair({
    required String puzzleId,
    required String pairId,
    required DateTime occurredAt,
  }) {
    var changed = false;
    _updatePuzzleProgress(puzzleId, (current) {
      final revealed = Set<String>.from(current.revealedPairIds);
      if (!revealed.add(pairId)) {
        return current.copyWith(lastPlayedAtIso: occurredAt.toIso8601String());
      }
      changed = true;
      return current.copyWith(
        revealedPairIds: revealed,
        revealPairUses: current.revealPairUses + 1,
        lastPlayedAtIso: occurredAt.toIso8601String(),
      );
    });
    return changed;
  }

  bool removeWrongOption({
    required String puzzleId,
    required String rightPairId,
    required DateTime occurredAt,
  }) {
    var changed = false;
    _updatePuzzleProgress(puzzleId, (current) {
      final hidden = Set<String>.from(current.hiddenRightItemIds);
      if (!hidden.add(rightPairId)) {
        return current.copyWith(lastPlayedAtIso: occurredAt.toIso8601String());
      }
      changed = true;
      return current.copyWith(
        hiddenRightItemIds: hidden,
        removeWrongOptionUses: current.removeWrongOptionUses + 1,
        lastPlayedAtIso: occurredAt.toIso8601String(),
      );
    });
    return changed;
  }

  bool markPuzzleCompleted({
    required String puzzleId,
    required bool perfect,
    required DateTime occurredAt,
  }) {
    var changed = false;
    _updatePuzzleProgress(puzzleId, (current) {
      final stamp = occurredAt.toIso8601String();
      if (!current.isCompleted || (perfect && !current.isPerfect)) {
        changed = true;
      }
      return current.copyWith(
        completedAtIso: current.completedAtIso ?? stamp,
        perfectCompletedAtIso: perfect
            ? (current.perfectCompletedAtIso ?? stamp)
            : current.perfectCompletedAtIso,
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

  bool markPerfectRewardGranted({
    required String puzzleId,
    required DateTime occurredAt,
  }) {
    var changed = false;
    _updatePuzzleProgress(puzzleId, (current) {
      if ((current.perfectRewardGrantedAtIso ?? '').isNotEmpty) {
        return current;
      }
      changed = true;
      return current.copyWith(
        perfectRewardGrantedAtIso: occurredAt.toIso8601String(),
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
      return MatchingDailyProgress(
        dateKey: dateKey,
        puzzleId: puzzleId,
        weekdayTheme: current.weekdayTheme ?? weekdayTheme,
        startedAtIso: current.startedAtIso ?? occurredAt.toIso8601String(),
        completedAtIso: current.completedAtIso,
        perfectCompletedAtIso: current.perfectCompletedAtIso,
        dailyRewardGrantedAtIso: current.dailyRewardGrantedAtIso,
        timeTakenSeconds: current.timeTakenSeconds,
      );
    });
  }

  bool markDailyCompleted({
    required String dateKey,
    required String puzzleId,
    required String weekdayTheme,
    required bool perfect,
    required int? timeTakenSeconds,
    required DateTime occurredAt,
  }) {
    var changed = false;
    _updateDailyProgress(dateKey, (current) {
      final stamp = occurredAt.toIso8601String();
      if ((current.completedAtIso ?? '').isEmpty) {
        changed = true;
      }
      return MatchingDailyProgress(
        dateKey: dateKey,
        puzzleId: puzzleId,
        weekdayTheme: current.weekdayTheme ?? weekdayTheme,
        startedAtIso: current.startedAtIso ?? stamp,
        completedAtIso: current.completedAtIso ?? stamp,
        perfectCompletedAtIso: perfect
            ? (current.perfectCompletedAtIso ?? stamp)
            : current.perfectCompletedAtIso,
        dailyRewardGrantedAtIso: current.dailyRewardGrantedAtIso,
        timeTakenSeconds: timeTakenSeconds ?? current.timeTakenSeconds,
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
      return MatchingDailyProgress(
        dateKey: current.dateKey,
        puzzleId: current.puzzleId,
        weekdayTheme: current.weekdayTheme,
        startedAtIso: current.startedAtIso,
        completedAtIso: current.completedAtIso,
        perfectCompletedAtIso: current.perfectCompletedAtIso,
        dailyRewardGrantedAtIso: occurredAt.toIso8601String(),
        timeTakenSeconds: current.timeTakenSeconds,
      );
    });
    return changed;
  }
}
