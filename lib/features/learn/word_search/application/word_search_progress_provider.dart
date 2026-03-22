import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../domain/word_search_models.dart';

const _wordSearchProgressKey = 'learn.word_search.progress.v1';

final wordSearchProgressProvider =
    StateNotifierProvider<WordSearchProgressNotifier, WordSearchProgressState>((
      ref,
    ) {
      return WordSearchProgressNotifier(ref.watch(localStoreProvider));
    });

class WordSearchProgressNotifier
    extends StateNotifier<WordSearchProgressState> {
  WordSearchProgressNotifier(this._store)
    : super(WordSearchProgressState.initial()) {
    _load();
  }

  final LocalStore _store;

  void _load() {
    state = WordSearchProgressState.fromJson(
      _store.getJsonMap(_wordSearchProgressKey),
    );
  }

  void _save() {
    _store.setJsonMap(_wordSearchProgressKey, state.toJson());
  }

  WordSearchPuzzleProgress _updatePuzzleProgress(
    String puzzleId,
    WordSearchPuzzleProgress Function(WordSearchPuzzleProgress current) update,
  ) {
    final current = state.progressFor(puzzleId);
    final next = update(current);
    state = state.copyWith(
      progressByPuzzleId: {...state.progressByPuzzleId, puzzleId: next},
    );
    _save();
    return next;
  }

  WordSearchDailyProgress _updateDailyProgress(
    String dateKey,
    WordSearchDailyProgress Function(WordSearchDailyProgress current) update,
  ) {
    final current =
        state.dailyProgressFor(dateKey) ??
        WordSearchDailyProgress(dateKey: dateKey, puzzleId: '');
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
    required String? startCellKey,
    required String? endCellKey,
    required List<String> cellKeys,
    required DateTime occurredAt,
  }) {
    _updatePuzzleProgress(puzzleId, (current) {
      return current.copyWith(
        selectedStartCellKey: startCellKey,
        clearSelectedStartCellKey: startCellKey == null,
        selectedEndCellKey: endCellKey,
        clearSelectedEndCellKey: endCellKey == null,
        recentSelectionCellKeys: cellKeys,
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

  bool markWordFound({
    required String puzzleId,
    required String wordId,
    required DateTime occurredAt,
  }) {
    var changed = false;
    _updatePuzzleProgress(puzzleId, (current) {
      if (current.foundWordIds.contains(wordId)) {
        return current.copyWith(lastPlayedAtIso: occurredAt.toIso8601String());
      }
      changed = true;
      final found = Set<String>.from(current.foundWordIds)..add(wordId);
      return current.copyWith(
        foundWordIds: found,
        recentSelectionCellKeys: const <String>[],
        selectedStartCellKey: null,
        clearSelectedStartCellKey: true,
        selectedEndCellKey: null,
        clearSelectedEndCellKey: true,
        lastPlayedAtIso: occurredAt.toIso8601String(),
      );
    });
    return changed;
  }

  bool revealFirstLetter({
    required String puzzleId,
    required String wordId,
    required DateTime occurredAt,
  }) {
    var changed = false;
    _updatePuzzleProgress(puzzleId, (current) {
      final revealed = Set<String>.from(current.revealedFirstLetterWordIds);
      if (!revealed.add(wordId)) {
        return current.copyWith(lastPlayedAtIso: occurredAt.toIso8601String());
      }
      changed = true;
      return current.copyWith(
        revealedFirstLetterWordIds: revealed,
        revealFirstLetterUses: current.revealFirstLetterUses + 1,
        lastPlayedAtIso: occurredAt.toIso8601String(),
      );
    });
    return changed;
  }

  bool highlightWord({
    required String puzzleId,
    required String wordId,
    required DateTime occurredAt,
  }) {
    var changed = false;
    _updatePuzzleProgress(puzzleId, (current) {
      final highlighted = Set<String>.from(current.highlightedWordIds);
      if (!highlighted.add(wordId)) {
        return current.copyWith(lastPlayedAtIso: occurredAt.toIso8601String());
      }
      changed = true;
      return current.copyWith(
        highlightedWordIds: highlighted,
        highlightWordUses: current.highlightWordUses + 1,
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
      return WordSearchDailyProgress(
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
      return WordSearchDailyProgress(
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
      return WordSearchDailyProgress(
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
