import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../journey/drops/application/journey_drops_providers.dart';
import '../../journey/xp/application/journey_xp_providers.dart';
import 'dhikr_anti_rush_detector.dart';
import '../data/dhikr_repository.dart';
import '../domain/dhikr_preset.dart';
import '../domain/dhikr_session.dart';
import '../domain/dhikr_summary.dart';

class DhikrSessionState {
  const DhikrSessionState({
    required this.selectedPreset,
    required this.target,
    required this.currentCount,
    required this.recentSessions,
    this.showAntiRushReminder = false,
    this.antiRushReminderCount = 0,
  });

  final DhikrPreset selectedPreset;
  final int target;
  final int currentCount;
  final List<DhikrSession> recentSessions;
  final bool showAntiRushReminder;
  final int antiRushReminderCount;

  bool get hasTargetReached => currentCount >= target;

  DhikrSummary get summary {
    final totals = recentSessions.fold<int>(
      0,
      (acc, session) => acc + session.count,
    );
    final top = _favoriteLabel();
    return DhikrSummary(
      totalCount: totals,
      sessionsCompleted: recentSessions.length,
      favoritePhrase: top,
    );
  }

  String _favoriteLabel() {
    if (recentSessions.isEmpty) {
      return 'Alhamdulillah';
    }
    final counts = <String, int>{};
    for (final session in recentSessions) {
      counts.update(
        session.phraseLabel,
        (value) => value + session.count,
        ifAbsent: () => session.count,
      );
    }
    return counts.entries
        .reduce((left, right) => left.value >= right.value ? left : right)
        .key;
  }

  DhikrSessionState copyWith({
    DhikrPreset? selectedPreset,
    int? target,
    int? currentCount,
    List<DhikrSession>? recentSessions,
    bool? showAntiRushReminder,
    int? antiRushReminderCount,
  }) {
    return DhikrSessionState(
      selectedPreset: selectedPreset ?? this.selectedPreset,
      target: target ?? this.target,
      currentCount: currentCount ?? this.currentCount,
      recentSessions: recentSessions ?? this.recentSessions,
      showAntiRushReminder:
          showAntiRushReminder ?? this.showAntiRushReminder,
      antiRushReminderCount:
          antiRushReminderCount ?? this.antiRushReminderCount,
    );
  }

  factory DhikrSessionState.initial() {
    return DhikrSessionState(
      selectedPreset: DhikrPreset.defaults.first,
      target: 33,
      currentCount: 0,
      recentSessions: const [],
    );
  }
}

class DhikrController extends StateNotifier<DhikrSessionState> {
  DhikrController(this._repository, this._dropController, this._xpController)
    : super(DhikrSessionState.initial()) {
    _load();
  }

  final DhikrRepository _repository;
  final JourneyDropController _dropController;
  final JourneyXpController _xpController;
  final DhikrAntiRushDetector _antiRushDetector = DhikrAntiRushDetector();

  void selectPreset(DhikrPreset preset) {
    _antiRushDetector.reset();
    state = state.copyWith(
      selectedPreset: preset,
      showAntiRushReminder: false,
    );
    _save();
  }

  void setTarget(int target) {
    if (target <= 0) return;
    _antiRushDetector.reset();
    state = state.copyWith(
      target: target,
      currentCount: 0,
      showAntiRushReminder: false,
    );
    _save();
  }

  void increment() {
    final shouldPrompt = _antiRushDetector.registerTap(DateTime.now());
    state = state.copyWith(
      currentCount: state.currentCount + 1,
      showAntiRushReminder: shouldPrompt,
      antiRushReminderCount: shouldPrompt
          ? state.antiRushReminderCount + 1
          : state.antiRushReminderCount,
    );
    _save();
  }

  void addManualCount(int count) {
    if (count <= 0) return;
    _antiRushDetector.reset();
    state = state.copyWith(
      currentCount: state.currentCount + count,
      showAntiRushReminder: false,
    );
    _save();
  }

  void undo() {
    if (state.currentCount <= 0) return;
    state = state.copyWith(currentCount: state.currentCount - 1);
    _save();
  }

  void reset() {
    _antiRushDetector.reset();
    state = state.copyWith(currentCount: 0, showAntiRushReminder: false);
    _save();
  }

  void dismissAntiRushReminder() {
    if (!state.showAntiRushReminder) return;
    state = state.copyWith(showAntiRushReminder: false);
  }

  void finishSession() {
    if (state.currentCount <= 0) return;
    _antiRushDetector.reset();

    final now = DateTime.now();
    final completed = DhikrSession(
      phraseLabel: state.selectedPreset.label,
      count: state.currentCount,
      target: state.target,
      startedAt: now.subtract(Duration(seconds: state.currentCount)),
      finishedAt: now,
    );

    state = state.copyWith(
      currentCount: 0,
      recentSessions: [completed, ...state.recentSessions],
      showAntiRushReminder: false,
    );
    _save();
    _dropController.awardDhikrDrop(
      sourceRef: 'dhikr:${completed.finishedAt.toIso8601String()}',
      occurredAt: completed.finishedAt,
      completed: completed.target < 100,
      metadata: <String, Object?>{
        'target': completed.target,
        'phraseLabel': completed.phraseLabel,
        'timestamp': completed.finishedAt.toIso8601String(),
      },
    );
    _xpController.awardDhikrXp(
      sourceRef: 'dhikr:${completed.finishedAt.toIso8601String()}',
      occurredAt: completed.finishedAt,
      completed: true,
      metadata: <String, Object?>{
        'target': completed.target,
        'phraseLabel': completed.phraseLabel,
      },
    );
  }

  void reloadFromStorage() {
    _antiRushDetector.reset();
    state = DhikrSessionState.initial();
    _load();
  }

  void _load() {
    final data = _repository.load();
    final presetId = data.selectedPresetId;
    DhikrPreset? preset;
    for (final item in DhikrPreset.defaults) {
      if (item.id == presetId) {
        preset = item;
        break;
      }
    }

    state = state.copyWith(
      selectedPreset: preset ?? state.selectedPreset,
      target: data.target,
      currentCount: data.currentCount,
      recentSessions: data.recentSessions,
    );
  }

  void _save() {
    _repository.saveState(
      selectedPresetId: state.selectedPreset.id,
      target: state.target,
      currentCount: state.currentCount,
    );
    _repository.replaceRecentSessions(state.recentSessions);
  }
}

final dhikrControllerProvider =
    StateNotifierProvider<DhikrController, DhikrSessionState>(
      (ref) => DhikrController(
        ref.watch(dhikrRepositoryProvider),
        ref.read(journeyDropSummaryProvider.notifier),
        ref.read(journeyXpSummaryProvider.notifier),
      ),
    );
