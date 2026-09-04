import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../journey/drops/application/journey_drops_providers.dart';
import '../../journey/xp/application/journey_xp_providers.dart';
import 'dhikr_anti_rush_detector.dart';
import '../data/dhikr_repository.dart';
import '../domain/dhikr_day_total.dart';
import '../domain/dhikr_preset.dart';
import '../domain/dhikr_session.dart';
import '../domain/dhikr_summary.dart';
import 'dhikr_history_math.dart';

class DhikrSessionState {
  const DhikrSessionState({
    required this.selectedPreset,
    required this.target,
    required this.currentCount,
    required this.currentSessionStartedAt,
    required this.recentSessions,
    this.showAntiRushReminder = false,
    this.antiRushReminderCount = 0,
    this.dailyTotals = const <String, DhikrDayTotal>{},
    this.phraseTotals = const <String, int>{},
  });

  final DhikrPreset selectedPreset;
  final int target;
  final int currentCount;
  final DateTime? currentSessionStartedAt;
  final List<DhikrSession> recentSessions;
  final bool showAntiRushReminder;
  final int antiRushReminderCount;

  /// Every day with remembrance, keyed by `yyyy-MM-dd`. Unlike
  /// [recentSessions] this is never trimmed.
  final Map<String, DhikrDayTotal> dailyTotals;

  /// Lifetime count per phrase label.
  final Map<String, int> phraseTotals;

  DhikrDayTotal? totalForDay(DateTime day) => dailyTotals[dhikrDayKey(day)];

  bool get hasTargetReached => currentCount >= target;

  DhikrSession? get activeSession {
    final startedAt = currentSessionStartedAt;
    if (currentCount <= 0 || startedAt == null) return null;
    final finishedAt = DateTime.now();
    return DhikrSession(
      phraseLabel: selectedPreset.label,
      count: currentCount,
      target: target,
      startedAt: startedAt,
      finishedAt: finishedAt.isBefore(startedAt) ? startedAt : finishedAt,
    );
  }

  List<DhikrSession> get allSessions {
    final active = activeSession;
    if (active == null) return recentSessions;
    return <DhikrSession>[active, ...recentSessions];
  }

  DhikrSummary get summary {
    final sessions = allSessions;
    final totals = sessions.fold<int>(0, (acc, session) => acc + session.count);
    final top = _favoriteLabel(sessions);
    return DhikrSummary(
      totalCount: totals,
      sessionsCompleted: sessions.length,
      favoritePhrase: top,
    );
  }

  String _favoriteLabel(List<DhikrSession> sessions) {
    if (sessions.isEmpty) {
      return 'Alhamdulillah';
    }
    final counts = <String, int>{};
    for (final session in sessions) {
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
    DateTime? currentSessionStartedAt,
    bool clearCurrentSessionStartedAt = false,
    List<DhikrSession>? recentSessions,
    bool? showAntiRushReminder,
    int? antiRushReminderCount,
    Map<String, DhikrDayTotal>? dailyTotals,
    Map<String, int>? phraseTotals,
  }) {
    return DhikrSessionState(
      selectedPreset: selectedPreset ?? this.selectedPreset,
      target: target ?? this.target,
      currentCount: currentCount ?? this.currentCount,
      currentSessionStartedAt: clearCurrentSessionStartedAt
          ? null
          : currentSessionStartedAt ?? this.currentSessionStartedAt,
      recentSessions: recentSessions ?? this.recentSessions,
      showAntiRushReminder: showAntiRushReminder ?? this.showAntiRushReminder,
      antiRushReminderCount:
          antiRushReminderCount ?? this.antiRushReminderCount,
      dailyTotals: dailyTotals ?? this.dailyTotals,
      phraseTotals: phraseTotals ?? this.phraseTotals,
    );
  }

  factory DhikrSessionState.initial() {
    return DhikrSessionState(
      selectedPreset: DhikrPreset.defaults.first,
      target: 33,
      currentCount: 0,
      currentSessionStartedAt: null,
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
    final archivedSessions = _archiveCurrentSessionIfNeeded();
    state = state.copyWith(
      selectedPreset: preset,
      showAntiRushReminder: false,
      currentCount: 0,
      clearCurrentSessionStartedAt: true,
      recentSessions: archivedSessions,
    );
    _save();
  }

  void setTarget(int target) {
    if (target <= 0) return;
    _antiRushDetector.reset();
    final archivedSessions = _archiveCurrentSessionIfNeeded();
    state = state.copyWith(
      target: target,
      currentCount: 0,
      showAntiRushReminder: false,
      clearCurrentSessionStartedAt: true,
      recentSessions: archivedSessions,
    );
    _save();
  }

  void increment() {
    final shouldPrompt = _antiRushDetector.registerTap(DateTime.now());
    final startedAt = state.currentSessionStartedAt ?? DateTime.now();
    state = state.copyWith(
      currentCount: state.currentCount + 1,
      currentSessionStartedAt: startedAt,
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
    final startedAt = state.currentSessionStartedAt ?? DateTime.now();
    state = state.copyWith(
      currentCount: state.currentCount + count,
      currentSessionStartedAt: startedAt,
      showAntiRushReminder: false,
    );
    _save();
  }

  void undo() {
    if (state.currentCount <= 0) return;
    final nextCount = state.currentCount - 1;
    state = state.copyWith(
      currentCount: nextCount,
      clearCurrentSessionStartedAt: nextCount <= 0,
    );
    _save();
  }

  void reset() {
    _antiRushDetector.reset();
    final archivedSessions = _archiveCurrentSessionIfNeeded();
    state = state.copyWith(
      currentCount: 0,
      showAntiRushReminder: false,
      clearCurrentSessionStartedAt: true,
      recentSessions: archivedSessions,
    );
    _save();
  }

  void dismissAntiRushReminder() {
    if (!state.showAntiRushReminder) return;
    state = state.copyWith(showAntiRushReminder: false);
  }

  void finishSession() {
    if (state.currentCount <= 0 || state.currentSessionStartedAt == null) {
      return;
    }
    _antiRushDetector.reset();

    final now = DateTime.now();
    final completed = _activeSessionSnapshot(finishedAt: now);
    if (completed == null) return;

    state = state.copyWith(
      currentCount: 0,
      clearCurrentSessionStartedAt: true,
      recentSessions: _prependSession(completed),
      showAntiRushReminder: false,
    );
    _save();
    _recordCompletion(completed);
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

  bool logLinkedSession({
    required String phraseLabel,
    required int count,
    required int target,
    required String sourceRef,
    required DateTime occurredAt,
    Duration duration = const Duration(seconds: 60),
    String? routineEntry,
  }) {
    if (count <= 0 || target <= 0) return false;

    final safeDuration = duration.isNegative ? Duration.zero : duration;
    final startedAt = occurredAt.subtract(safeDuration);
    final completed = DhikrSession(
      phraseLabel: phraseLabel,
      count: count,
      target: target,
      startedAt: startedAt,
      finishedAt: occurredAt,
    );

    state = state.copyWith(
      recentSessions: [completed, ...state.recentSessions],
      showAntiRushReminder: false,
    );
    _save();
    _recordCompletion(completed, routineEntry: routineEntry);
    _dropController.awardDhikrDrop(
      sourceRef: sourceRef,
      occurredAt: occurredAt,
      completed: true,
      metadata: <String, Object?>{
        'target': target,
        'phraseLabel': phraseLabel,
        'timestamp': occurredAt.toIso8601String(),
      },
    );
    _xpController.awardDhikrXp(
      sourceRef: sourceRef,
      occurredAt: occurredAt,
      completed: true,
      metadata: <String, Object?>{'target': target, 'phraseLabel': phraseLabel},
    );
    return true;
  }

  /// A guided routine finished: log it as one session under the routine's
  /// canonical label and remember which routine (and, after salah, which
  /// prayer) it was, so the landing can show it as done.
  bool logRoutineSession({
    required String routineId,
    required String phraseLabel,
    required int count,
    required DateTime startedAt,
    required DateTime finishedAt,
    String? prayerId,
  }) {
    final entry = prayerId == null ? routineId : '$routineId:$prayerId';
    return logLinkedSession(
      phraseLabel: phraseLabel,
      count: count,
      target: count,
      sourceRef: 'dhikr-routine:$routineId:${finishedAt.toIso8601String()}',
      occurredAt: finishedAt,
      duration: finishedAt.difference(startedAt),
      routineEntry: entry,
    );
  }

  void _recordCompletion(DhikrSession session, {String? routineEntry}) {
    if (session.count <= 0) return;
    final totals = dhikrTotalsWithSession(
      state.dailyTotals,
      finishedAt: session.finishedAt,
      count: session.count,
      routineEntry: routineEntry,
    );
    final phraseCount =
        (state.phraseTotals[session.phraseLabel] ?? 0) + session.count;
    state = state.copyWith(
      dailyTotals: totals,
      phraseTotals: <String, int>{
        ...state.phraseTotals,
        session.phraseLabel: phraseCount,
      },
    );
    _repository.upsertDayTotal(totals[dhikrDayKey(session.finishedAt)]!);
    _repository.setPhraseTotal(session.phraseLabel, phraseCount);
  }

  DhikrSession? _activeSessionSnapshot({DateTime? finishedAt}) {
    final startedAt = state.currentSessionStartedAt;
    if (state.currentCount <= 0 || startedAt == null) return null;
    final endedAt = finishedAt ?? DateTime.now();
    return DhikrSession(
      phraseLabel: state.selectedPreset.label,
      count: state.currentCount,
      target: state.target,
      startedAt: startedAt,
      finishedAt: endedAt.isBefore(startedAt) ? startedAt : endedAt,
    );
  }

  List<DhikrSession> _archiveCurrentSessionIfNeeded() {
    final snapshot = _activeSessionSnapshot();
    if (snapshot == null) return state.recentSessions;
    return _prependSession(snapshot);
  }

  List<DhikrSession> _prependSession(DhikrSession session) {
    return <DhikrSession>[
      session,
      ...state.recentSessions.where(
        (item) =>
            item.startedAt != session.startedAt ||
            item.finishedAt != session.finishedAt ||
            item.count != session.count ||
            item.target != session.target ||
            item.phraseLabel != session.phraseLabel,
      ),
    ];
  }

  bool logPostSalahDhikrBundle({
    required String sourceRef,
    required DateTime occurredAt,
  }) {
    return logLinkedSession(
      phraseLabel: 'Post-Salah Dhikr',
      count: 100,
      target: 100,
      sourceRef: sourceRef,
      occurredAt: occurredAt,
      duration: const Duration(minutes: 2),
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
      currentSessionStartedAt: data.currentSessionStartedAt,
      recentSessions: data.recentSessions,
      dailyTotals: data.dailyTotals,
      phraseTotals: data.phraseTotals,
    );
  }

  void _save() {
    _repository.saveState(
      selectedPresetId: state.selectedPreset.id,
      target: state.target,
      currentCount: state.currentCount,
      currentSessionStartedAt: state.currentSessionStartedAt,
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
