import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';
import '../../../shared/persistence/structured_data_scope.dart';
import '../../accounts_sync/application/accounts_sync_controller.dart';
import '../domain/dhikr_routine.dart';
import 'dhikr_controller.dart';

enum DhikrRoutineTapOutcome { counted, stepAdvanced, completed }

/// What finished when a routine completed: the player shows it on the
/// completion sheet.
class DhikrRoutineCompletion {
  const DhikrRoutineCompletion({
    required this.routine,
    required this.startedAt,
    required this.finishedAt,
    this.prayerId,
  });

  final DhikrRoutine routine;
  final DateTime startedAt;
  final DateTime finishedAt;
  final String? prayerId;

  Duration get duration => finishedAt.difference(startedAt);
}

class DhikrRoutineTapResult {
  const DhikrRoutineTapResult(this.outcome, {this.completion});

  final DhikrRoutineTapOutcome outcome;
  final DhikrRoutineCompletion? completion;
}

/// Drives one routine at a time. Progress persists per data scope so a
/// routine left half-way resumes at the same bead.
class DhikrRoutineController extends StateNotifier<DhikrRoutineProgress?> {
  DhikrRoutineController(this._store, this._scopeId, this._dhikrController)
    : super(null) {
    state = DhikrRoutineProgress.fromJson(_store.getJsonMap(_key));
  }

  final LocalStore _store;
  final String _scopeId;
  final DhikrController _dhikrController;

  String get _key => 'worship.dhikr.routine.active.v1.$_scopeId';

  /// Starts [routine], or resumes it when it is already the active one.
  /// Starting a different routine abandons the previous run.
  void start(DhikrRoutine routine, {String? prayerId, DateTime? now}) {
    final current = state;
    if (current != null && current.routineId == routine.id) {
      if (prayerId != null && current.prayerId != prayerId) {
        _write(current.copyWith(prayerId: prayerId));
      }
      return;
    }
    _write(
      DhikrRoutineProgress(
        routineId: routine.id,
        stepIndex: 0,
        stepCount: 0,
        startedAt: now ?? DateTime.now(),
        prayerId: prayerId,
      ),
    );
  }

  DhikrRoutineTapResult tap(DhikrRoutine routine, {DateTime? now}) {
    var progress = state;
    if (progress == null || progress.routineId != routine.id) {
      start(routine, now: now);
      progress = state!;
    }
    if (routine.steps.isEmpty) {
      return const DhikrRoutineTapResult(DhikrRoutineTapOutcome.counted);
    }
    final stepIndex = progress.stepIndex.clamp(0, routine.steps.length - 1);
    final step = routine.steps[stepIndex];
    final nextCount = progress.stepCount + 1;
    if (nextCount < step.count) {
      _write(progress.copyWith(stepIndex: stepIndex, stepCount: nextCount));
      return const DhikrRoutineTapResult(DhikrRoutineTapOutcome.counted);
    }
    return _advance(routine, progress.copyWith(stepIndex: stepIndex), now: now);
  }

  /// Marks the current step done without counting the rest of it.
  DhikrRoutineTapResult skipStep(DhikrRoutine routine, {DateTime? now}) {
    final progress = state;
    if (progress == null || progress.routineId != routine.id) {
      return const DhikrRoutineTapResult(DhikrRoutineTapOutcome.counted);
    }
    return _advance(routine, progress, now: now);
  }

  DhikrRoutineTapResult _advance(
    DhikrRoutine routine,
    DhikrRoutineProgress progress, {
    DateTime? now,
  }) {
    final isLast = progress.stepIndex >= routine.steps.length - 1;
    if (!isLast) {
      _write(
        progress.copyWith(stepIndex: progress.stepIndex + 1, stepCount: 0),
      );
      return const DhikrRoutineTapResult(DhikrRoutineTapOutcome.stepAdvanced);
    }
    final finishedAt = now ?? DateTime.now();
    final completion = DhikrRoutineCompletion(
      routine: routine,
      startedAt: progress.startedAt,
      finishedAt: finishedAt.isBefore(progress.startedAt)
          ? progress.startedAt
          : finishedAt,
      prayerId: progress.prayerId,
    );
    _dhikrController.logRoutineSession(
      routineId: routine.id,
      phraseLabel: routine.sessionLabel,
      count: routine.totalCount,
      startedAt: completion.startedAt,
      finishedAt: completion.finishedAt,
      prayerId: progress.prayerId,
    );
    _clear();
    return DhikrRoutineTapResult(
      DhikrRoutineTapOutcome.completed,
      completion: completion,
    );
  }

  void undo(DhikrRoutine routine) {
    final progress = state;
    if (progress == null || progress.routineId != routine.id) return;
    if (progress.stepCount > 0) {
      _write(progress.copyWith(stepCount: progress.stepCount - 1));
      return;
    }
    if (progress.stepIndex > 0) {
      final previousIndex = progress.stepIndex - 1;
      final previous = routine.steps[previousIndex];
      _write(
        progress.copyWith(
          stepIndex: previousIndex,
          stepCount: previous.count > 0 ? previous.count - 1 : 0,
        ),
      );
    }
  }

  void abandon() => _clear();

  void _write(DhikrRoutineProgress progress) {
    state = progress;
    _store.setJsonMap(_key, progress.toJson());
  }

  void _clear() {
    state = null;
    _store.remove(_key);
  }
}

final dhikrRoutineControllerProvider =
    StateNotifierProvider<DhikrRoutineController, DhikrRoutineProgress?>((ref) {
      ref.watch(profileScopeVersionProvider);
      return DhikrRoutineController(
        ref.watch(localStoreProvider),
        ref.watch(structuredDataScopeProvider),
        ref.read(dhikrControllerProvider.notifier),
      );
    });
