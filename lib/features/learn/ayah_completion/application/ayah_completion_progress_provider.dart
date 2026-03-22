import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../domain/ayah_completion_models.dart';

const _ayahCompletionProgressKey = 'learn.ayah_completion.progress.v1';

final ayahCompletionProgressProvider =
    StateNotifierProvider<
      AyahCompletionProgressNotifier,
      AyahCompletionProgressState
    >((ref) {
      return AyahCompletionProgressNotifier(ref.watch(localStoreProvider));
    });

class AyahCompletionProgressNotifier
    extends StateNotifier<AyahCompletionProgressState> {
  AyahCompletionProgressNotifier(this._store)
    : super(AyahCompletionProgressState.initial()) {
    _load();
  }

  final LocalStore _store;

  void _load() {
    state = AyahCompletionProgressState.fromJson(
      _store.getJsonMap(_ayahCompletionProgressKey),
    );
  }

  void _save() {
    _store.setJsonMap(_ayahCompletionProgressKey, state.toJson());
  }

  AyahCompletionPuzzleProgress _updatePuzzleProgress(
    String puzzleId,
    AyahCompletionPuzzleProgress Function(AyahCompletionPuzzleProgress current)
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

  AyahCompletionDailyProgress _updateDailyProgress(
    String dateKey,
    AyahCompletionDailyProgress Function(AyahCompletionDailyProgress current)
    update,
  ) {
    final current =
        state.dailyProgressFor(dateKey) ??
        AyahCompletionDailyProgress(dateKey: dateKey, puzzleId: '');
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

  void setSelectedBlank({
    required String puzzleId,
    required int? blankIndex,
    required DateTime occurredAt,
  }) {
    _updatePuzzleProgress(puzzleId, (current) {
      return current.copyWith(
        selectedBlankIndex: blankIndex,
        clearSelectedBlankIndex: blankIndex == null,
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

  bool fillBlank({
    required String puzzleId,
    required int blankIndex,
    required String word,
    required DateTime occurredAt,
  }) {
    var changed = false;
    _updatePuzzleProgress(puzzleId, (current) {
      final key = blankIndex.toString();
      final updated = Map<String, String>.from(current.filledWordsByBlankIndex);
      if (updated[key] == word) {
        return current.copyWith(lastPlayedAtIso: occurredAt.toIso8601String());
      }
      updated[key] = word;
      changed = true;
      return current.copyWith(
        filledWordsByBlankIndex: updated,
        lastPlayedAtIso: occurredAt.toIso8601String(),
      );
    });
    return changed;
  }

  bool revealBlank({
    required String puzzleId,
    required int blankIndex,
    required String word,
    required DateTime occurredAt,
  }) {
    var changed = false;
    _updatePuzzleProgress(puzzleId, (current) {
      final revealed = Set<String>.from(current.revealedBlankIndexes);
      final key = blankIndex.toString();
      final filled = Map<String, String>.from(current.filledWordsByBlankIndex);
      final inserted = revealed.add(key);
      final previous = filled[key];
      filled[key] = word;
      if (inserted || previous != word) {
        changed = true;
      }
      return current.copyWith(
        revealedBlankIndexes: revealed,
        filledWordsByBlankIndex: filled,
        revealBlankUses: inserted
            ? current.revealBlankUses + 1
            : current.revealBlankUses,
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
      return AyahCompletionDailyProgress(
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
      return AyahCompletionDailyProgress(
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
      return AyahCompletionDailyProgress(
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
