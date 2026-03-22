import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../domain/crossword_models.dart';

const _crosswordProgressKey = 'learn.crossword.progress.v1';

final crosswordProgressProvider =
    StateNotifierProvider<CrosswordProgressNotifier, CrosswordProgressState>((
      ref,
    ) {
      return CrosswordProgressNotifier(ref.watch(localStoreProvider));
    });

class CrosswordProgressNotifier extends StateNotifier<CrosswordProgressState> {
  CrosswordProgressNotifier(this._store)
    : super(CrosswordProgressState.initial()) {
    _load();
  }

  final LocalStore _store;

  void _load() {
    state = CrosswordProgressState.fromJson(
      _store.getJsonMap(_crosswordProgressKey),
    );
  }

  void _save() {
    _store.setJsonMap(_crosswordProgressKey, state.toJson());
  }

  CrosswordPuzzleProgress _updatePuzzleProgress(
    String puzzleId,
    CrosswordPuzzleProgress Function(CrosswordPuzzleProgress current) update,
  ) {
    final current = state.progressFor(puzzleId);
    final next = update(current);
    state = state.copyWith(
      progressByPuzzleId: {...state.progressByPuzzleId, puzzleId: next},
    );
    _save();
    return next;
  }

  CrosswordDailyProgress _updateDailyProgress(
    String dateKey,
    CrosswordDailyProgress Function(CrosswordDailyProgress current) update,
  ) {
    final current =
        state.dailyProgressFor(dateKey) ??
        CrosswordDailyProgress(dateKey: dateKey, puzzleId: '');
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

  void setCellEntry({
    required String puzzleId,
    required String cellKey,
    required String value,
    required DateTime occurredAt,
  }) {
    _updatePuzzleProgress(puzzleId, (current) {
      final nextCells = Map<String, String>.from(current.enteredLettersByCell);
      final normalized = value.trim().toUpperCase();
      if (normalized.isEmpty) {
        nextCells.remove(cellKey);
      } else {
        nextCells[cellKey] = normalized;
      }
      return current.copyWith(
        enteredLettersByCell: nextCells,
        startedAtIso: current.startedAtIso ?? occurredAt.toIso8601String(),
        lastPlayedAtIso: occurredAt.toIso8601String(),
      );
    });
  }

  void setSelection({
    required String puzzleId,
    required String cellKey,
    required CrosswordDirection direction,
    required DateTime occurredAt,
  }) {
    _updatePuzzleProgress(puzzleId, (current) {
      return current.copyWith(
        selectedCellKey: cellKey,
        selectedDirection: direction.name,
        startedAtIso: current.startedAtIso ?? occurredAt.toIso8601String(),
        lastPlayedAtIso: occurredAt.toIso8601String(),
      );
    });
  }

  void markMistake({required String puzzleId, required DateTime occurredAt}) {
    _updatePuzzleProgress(puzzleId, (current) {
      if (current.hadMistake) {
        return current.copyWith(lastPlayedAtIso: occurredAt.toIso8601String());
      }
      return current.copyWith(
        hadMistake: true,
        lastPlayedAtIso: occurredAt.toIso8601String(),
      );
    });
  }

  bool markClueSolved({
    required String puzzleId,
    required String clueId,
    required DateTime occurredAt,
  }) {
    var changed = false;
    _updatePuzzleProgress(puzzleId, (current) {
      if (current.solvedClueIds.contains(clueId)) {
        return current.copyWith(lastPlayedAtIso: occurredAt.toIso8601String());
      }
      changed = true;
      final solved = Set<String>.from(current.solvedClueIds)..add(clueId);
      return current.copyWith(
        solvedClueIds: solved,
        lastPlayedAtIso: occurredAt.toIso8601String(),
      );
    });
    return changed;
  }

  bool revealLetter({
    required String puzzleId,
    required String clueId,
    required String cellKey,
    required DateTime occurredAt,
  }) {
    var changed = false;
    _updatePuzzleProgress(puzzleId, (current) {
      if (current.revealedCellKeys.contains(cellKey)) {
        return current.copyWith(lastPlayedAtIso: occurredAt.toIso8601String());
      }
      changed = true;
      final revealedCells = Set<String>.from(current.revealedCellKeys)
        ..add(cellKey);
      return current.copyWith(
        revealedCellKeys: revealedCells,
        revealLetterUses: current.revealLetterUses + 1,
        usedAnyHint: true,
        lastPlayedAtIso: occurredAt.toIso8601String(),
      );
    });
    return changed;
  }

  bool revealWord({
    required String puzzleId,
    required String clueId,
    required Set<String> cellKeys,
    required DateTime occurredAt,
  }) {
    var changed = false;
    _updatePuzzleProgress(puzzleId, (current) {
      final revealedClues = Set<String>.from(current.revealedClueIds);
      if (!revealedClues.add(clueId)) {
        return current.copyWith(lastPlayedAtIso: occurredAt.toIso8601String());
      }
      changed = true;
      final revealedCells = Set<String>.from(current.revealedCellKeys)
        ..addAll(cellKeys);
      return current.copyWith(
        revealedClueIds: revealedClues,
        revealedCellKeys: revealedCells,
        revealWordUses: current.revealWordUses + 1,
        usedAnyHint: true,
        lastPlayedAtIso: occurredAt.toIso8601String(),
      );
    });
    return changed;
  }

  bool viewExtraHint({
    required String puzzleId,
    required String clueId,
    required DateTime occurredAt,
  }) {
    var changed = false;
    _updatePuzzleProgress(puzzleId, (current) {
      final viewed = Set<String>.from(current.extraHintViewedClueIds);
      if (!viewed.add(clueId)) {
        return current.copyWith(lastPlayedAtIso: occurredAt.toIso8601String());
      }
      changed = true;
      return current.copyWith(
        extraHintViewedClueIds: viewed,
        extraHintUses: current.extraHintUses + 1,
        usedAnyHint: true,
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
      final wasCompleted = current.isCompleted;
      final nextPerfectIso = perfect
          ? (current.perfectCompletedAtIso ?? stamp)
          : current.perfectCompletedAtIso;
      if (!wasCompleted || (perfect && current.perfectCompletedAtIso == null)) {
        changed = true;
      }
      return current.copyWith(
        completedAtIso: current.completedAtIso ?? stamp,
        perfectCompletedAtIso: nextPerfectIso,
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
      return CrosswordDailyProgress(
        dateKey: dateKey,
        puzzleId: puzzleId,
        weekdayTheme: current.weekdayTheme ?? weekdayTheme,
        startedAtIso: current.startedAtIso ?? occurredAt.toIso8601String(),
        completedAtIso: current.completedAtIso,
        perfectCompletedAtIso: current.perfectCompletedAtIso,
        bonusCompletedObjectiveIds: current.bonusCompletedObjectiveIds,
        timeTakenSeconds: current.timeTakenSeconds,
        dailyRewardGrantedAtIso: current.dailyRewardGrantedAtIso,
        dailyBonusRewardGrantedAtIso: current.dailyBonusRewardGrantedAtIso,
      );
    });
  }

  bool markDailyCompleted({
    required String dateKey,
    required String puzzleId,
    required String weekdayTheme,
    required bool perfect,
    required Set<String> achievedBonusObjectiveIds,
    required int? timeTakenSeconds,
    required DateTime occurredAt,
  }) {
    var changed = false;
    _updateDailyProgress(dateKey, (current) {
      final stamp = occurredAt.toIso8601String();
      if ((current.completedAtIso ?? '').isEmpty) {
        changed = true;
      }
      return CrosswordDailyProgress(
        dateKey: dateKey,
        puzzleId: puzzleId,
        weekdayTheme: current.weekdayTheme ?? weekdayTheme,
        startedAtIso: current.startedAtIso ?? stamp,
        completedAtIso: current.completedAtIso ?? stamp,
        perfectCompletedAtIso: perfect
            ? (current.perfectCompletedAtIso ?? stamp)
            : current.perfectCompletedAtIso,
        bonusCompletedObjectiveIds: achievedBonusObjectiveIds.isEmpty
            ? current.bonusCompletedObjectiveIds
            : achievedBonusObjectiveIds,
        timeTakenSeconds: timeTakenSeconds ?? current.timeTakenSeconds,
        dailyRewardGrantedAtIso: current.dailyRewardGrantedAtIso,
        dailyBonusRewardGrantedAtIso: current.dailyBonusRewardGrantedAtIso,
      );
    });
    return changed;
  }

  bool markDailyRewardGranted({
    required String dateKey,
    required String puzzleId,
    required DateTime occurredAt,
  }) {
    var changed = false;
    _updateDailyProgress(dateKey, (current) {
      if ((current.dailyRewardGrantedAtIso ?? '').isNotEmpty) {
        return current;
      }
      changed = true;
      return CrosswordDailyProgress(
        dateKey: dateKey,
        puzzleId: puzzleId,
        weekdayTheme: current.weekdayTheme,
        startedAtIso: current.startedAtIso ?? occurredAt.toIso8601String(),
        completedAtIso: current.completedAtIso,
        perfectCompletedAtIso: current.perfectCompletedAtIso,
        bonusCompletedObjectiveIds: current.bonusCompletedObjectiveIds,
        timeTakenSeconds: current.timeTakenSeconds,
        dailyRewardGrantedAtIso: occurredAt.toIso8601String(),
        dailyBonusRewardGrantedAtIso: current.dailyBonusRewardGrantedAtIso,
      );
    });
    return changed;
  }

  bool markDailyBonusRewardGranted({
    required String dateKey,
    required String puzzleId,
    required DateTime occurredAt,
  }) {
    var changed = false;
    _updateDailyProgress(dateKey, (current) {
      if ((current.dailyBonusRewardGrantedAtIso ?? '').isNotEmpty) {
        return current;
      }
      changed = true;
      return CrosswordDailyProgress(
        dateKey: dateKey,
        puzzleId: puzzleId,
        weekdayTheme: current.weekdayTheme,
        startedAtIso: current.startedAtIso ?? occurredAt.toIso8601String(),
        completedAtIso: current.completedAtIso,
        perfectCompletedAtIso: current.perfectCompletedAtIso,
        bonusCompletedObjectiveIds: current.bonusCompletedObjectiveIds,
        timeTakenSeconds: current.timeTakenSeconds,
        dailyRewardGrantedAtIso: current.dailyRewardGrantedAtIso,
        dailyBonusRewardGrantedAtIso: occurredAt.toIso8601String(),
      );
    });
    return changed;
  }
}
