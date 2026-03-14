import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/diagnostics/app_telemetry.dart';
import '../../../features/ocean/application/ocean_drops_provider.dart';
import '../../../shared/persistence/local_store.dart';
import '../../creation_explorer/domain/creation_explorer_models.dart';
import '../data/creation_challenge_catalog.dart';
import '../domain/creation_challenge_models.dart';

final creationChallengeRepositoryProvider = Provider<CreationChallengeRepository>((ref) {
  return CreationChallengeRepository(ref.watch(localStoreProvider));
});

final creationChallengeEngineProvider = Provider<CreationChallengeEngine>((ref) {
  return const CreationChallengeEngine();
});

final creationChallengeServiceProvider =
    StateNotifierProvider<CreationChallengeService, CreationChallengeState>((ref) {
      return CreationChallengeService(
        repository: ref.watch(creationChallengeRepositoryProvider),
        engine: ref.watch(creationChallengeEngineProvider),
        oceanDrops: ref.watch(oceanDropsProvider.notifier),
      );
    });

final currentCreationChallengesProvider = Provider<List<CreationChallengeSummary>>((ref) {
  final service = ref.watch(creationChallengeServiceProvider.notifier);
  final state = ref.watch(creationChallengeServiceProvider);
  return service.currentSummaries(state);
});

final creationChallengeStreakProvider = Provider<int>((ref) {
  final state = ref.watch(creationChallengeServiceProvider);
  final service = ref.watch(creationChallengeServiceProvider.notifier);
  return service.currentDailyStreak(state);
});

class CreationChallengeRepository {
  const CreationChallengeRepository(this._store);

  final LocalStore _store;
  static const _key = 'creation_challenges.state.v1';

  CreationChallengeState load() {
    return CreationChallengeState.fromJson(_store.getJsonMap(_key));
  }

  Future<void> save(CreationChallengeState state) {
    return _store.setJsonMap(_key, state.toJson());
  }
}

class CreationChallengeEngine {
  const CreationChallengeEngine();

  List<CreationChallenge> get dailyPool => creationChallengePool
      .where((item) => !item.isBonus && item.challengeType != CreationChallengeType.reflect)
      .toList(growable: false);

  List<CreationChallenge> get bonusPool => creationChallengePool
      .where((item) => item.isBonus)
      .toList(growable: false);

  List<CreationChallenge> get weeklyPool => creationChallengePool
      .where((item) => item.challengeType == CreationChallengeType.reflect && item.difficulty == CreationChallengeDifficulty.deeper)
      .toList(growable: false);

  CreationChallengeAssignment assignFor({
    required ChallengeSlot slot,
    required DateTime now,
    required List<ChallengeHistoryEntry> history,
  }) {
    final startAt = slot == ChallengeSlot.weekly ? _startOfWeek(now) : DateTime(now.year, now.month, now.day);
    final endAt = slot == ChallengeSlot.weekly
        ? startAt.add(const Duration(days: 7))
        : startAt.add(const Duration(days: 1));
    final previous = history.where((entry) => entry.completed || entry.skipped).take(8).toList(growable: false);
    final pool = switch (slot) {
      ChallengeSlot.daily => dailyPool,
      ChallengeSlot.bonus => bonusPool,
      ChallengeSlot.weekly => weeklyPool,
    };
    final selected = _pickChallenge(pool, slot: slot, anchor: startAt, recentHistory: previous);
    return CreationChallengeAssignment(
      slot: slot,
      challengeId: selected.id,
      startAt: startAt,
      endAt: endAt,
    );
  }

  CreationChallenge _pickChallenge(
    List<CreationChallenge> pool, {
    required ChallengeSlot slot,
    required DateTime anchor,
    required List<ChallengeHistoryEntry> recentHistory,
  }) {
    final recentChallengeIds = recentHistory.map((item) => item.challengeId).toSet();
    final recentCategories = recentHistory
        .map((item) => item.categoryId)
        .whereType<CreationCategoryId>()
        .take(3)
        .toSet();
    final filtered = pool.where((item) {
      if (recentChallengeIds.contains(item.id)) return false;
      if (item.targetCategoryId != null && recentCategories.contains(item.targetCategoryId)) {
        return false;
      }
      return true;
    }).toList(growable: false);
    final candidates = filtered.isEmpty ? pool : filtered;
    final seed = anchor.year * 10000 + anchor.month * 100 + anchor.day + slot.index * 97;
    return candidates[seed % candidates.length];
  }

  DateTime _startOfWeek(DateTime value) {
    final day = DateTime(value.year, value.month, value.day);
    return day.subtract(Duration(days: day.weekday - 1));
  }
}

class CreationChallengeService extends StateNotifier<CreationChallengeState> {
  CreationChallengeService({
    required CreationChallengeRepository repository,
    required CreationChallengeEngine engine,
    required OceanDropService oceanDrops,
  }) : _repository = repository,
       _engine = engine,
       _oceanDrops = oceanDrops,
       super(repository.load()) {
    _ensureAssignments();
  }

  final CreationChallengeRepository _repository;
  final CreationChallengeEngine _engine;
  final OceanDropService _oceanDrops;

  void _ensureAssignments([DateTime? now]) {
    final effectiveNow = now ?? DateTime.now();
    final nextAssignments = Map<ChallengeSlot, CreationChallengeAssignment>.from(state.assignments);
    var changed = false;
    for (final slot in ChallengeSlot.values) {
      final existing = nextAssignments[slot];
      if (existing == null || effectiveNow.isBefore(existing.startAt) || !effectiveNow.isBefore(existing.endAt)) {
        nextAssignments[slot] = _engine.assignFor(slot: slot, now: effectiveNow, history: state.history);
        changed = true;
      }
    }
    if (changed) {
      state = state.copyWith(assignments: nextAssignments);
      _persist();
    }
  }

  List<CreationChallengeSummary> currentSummaries(CreationChallengeState state) {
    return ChallengeSlot.values.map((slot) {
      final assignment = this.state.assignments[slot]!;
      final challenge = creationChallengePool.firstWhere((item) => item.id == assignment.challengeId);
      final completion = this.state.completions.where((item) => item.challengeId == challenge.id).firstOrNull;
      final status = completion != null
          ? CreationChallengeStatus.completed
          : DateTime.now().isAfter(assignment.endAt)
              ? CreationChallengeStatus.expired
              : CreationChallengeStatus.available;
      return CreationChallengeSummary(
        slot: slot,
        challenge: challenge,
        assignment: assignment,
        status: status,
        completion: completion,
      );
    }).toList(growable: false);
  }

  int currentDailyStreak(CreationChallengeState state) {
    final completionsByDay = <String>{};
    for (final completion in state.completions) {
      final summary = creationChallengePool.where((item) => item.id == completion.challengeId).firstOrNull;
      if (summary == null || summary.isBonus) continue;
      completionsByDay.add(LocalStore.todayKey(completion.completedAt));
    }
    var streak = 0;
    var cursor = DateTime.now();
    while (true) {
      final dayKey = LocalStore.todayKey(cursor);
      if (!completionsByDay.contains(dayKey)) {
        if (streak == 0) {
          cursor = cursor.subtract(const Duration(days: 1));
          final previousKey = LocalStore.todayKey(cursor);
          if (completionsByDay.contains(previousKey)) {
            streak += 1;
            cursor = cursor.subtract(const Duration(days: 1));
            continue;
          }
        }
        break;
      }
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  Future<void> markViewed() async {
    AppTelemetry.logEvent('creation_challenge_viewed');
  }

  Future<void> startChallenge(String challengeId) async {
    AppTelemetry.logEvent('creation_challenge_started', metadata: <String, Object?>{'challengeId': challengeId});
  }

  Future<bool> processEvidence(CreationChallengeEvidence evidence) async {
    _ensureAssignments(evidence.occurredAt);
    var completedAny = false;
    for (final summary in currentSummaries(state)) {
      if (summary.isCompleted) continue;
      if (!_matches(summary.challenge, evidence)) continue;
      await _completeChallenge(summary, evidence: evidence);
      completedAny = true;
    }
    return completedAny;
  }

  Future<void> completeManually(String challengeId, {String? notes}) async {
    _ensureAssignments();
    final summary = currentSummaries(state).where((item) => item.challenge.id == challengeId).firstOrNull;
    if (summary == null || summary.isCompleted) return;
    if (summary.challenge.completionRule != CreationChallengeRuleType.manualConfirm) return;
    await _completeChallenge(
      summary,
      evidence: CreationChallengeEvidence(
        ruleType: CreationChallengeRuleType.manualConfirm,
        source: summary.challenge.targetExplorerMode ?? CreationExplorerMode.creationExplorer,
        occurredAt: DateTime.now(),
        categoryId: summary.challenge.targetCategoryId,
        notes: notes,
      ),
    );
  }

  Future<void> skipChallenge(ChallengeSlot slot) async {
    _ensureAssignments();
    final assignment = state.assignments[slot];
    if (assignment == null) return;
    final challenge = creationChallengePool.firstWhere((item) => item.id == assignment.challengeId);
    final history = <ChallengeHistoryEntry>[
      ChallengeHistoryEntry(
        id: 'skip_${assignment.challengeId}_${DateTime.now().millisecondsSinceEpoch}',
        date: DateTime.now(),
        challengeId: assignment.challengeId,
        completed: false,
        skipped: true,
        explorerSource: challenge.targetExplorerMode ?? CreationExplorerMode.creationExplorer,
        categoryId: challenge.targetCategoryId,
      ),
      ...state.history,
    ].take(180).toList(growable: false);
    state = state.copyWith(history: history);
    _persist();
    AppTelemetry.logEvent('creation_challenge_skipped', metadata: <String, Object?>{'challengeId': challenge.id, 'slot': slot.name});
    _ensureAssignments(DateTime.now().add(const Duration(days: 1)));
  }

  bool _matches(CreationChallenge challenge, CreationChallengeEvidence evidence) {
    if (challenge.targetExplorerMode != null && challenge.targetExplorerMode != evidence.source) {
      if (!(challenge.completionRule == CreationChallengeRuleType.saveReflection && evidence.ruleType == CreationChallengeRuleType.saveReflection)) {
        return false;
      }
    }
    switch (challenge.completionRule) {
      case CreationChallengeRuleType.openExplorer:
        return evidence.ruleType == CreationChallengeRuleType.openExplorer;
      case CreationChallengeRuleType.detectCategory:
        return evidence.ruleType == CreationChallengeRuleType.detectCategory && challenge.targetCategoryId == evidence.categoryId;
      case CreationChallengeRuleType.saveObservation:
        if (evidence.ruleType != CreationChallengeRuleType.saveObservation) return false;
        return challenge.targetCategoryId == null || challenge.targetCategoryId == evidence.categoryId;
      case CreationChallengeRuleType.saveReflection:
        if (evidence.ruleType != CreationChallengeRuleType.saveReflection) return false;
        return challenge.targetCategoryId == null || challenge.targetCategoryId == evidence.categoryId;
      case CreationChallengeRuleType.checkSkyEvent:
        return evidence.ruleType == CreationChallengeRuleType.checkSkyEvent || evidence.ruleType == CreationChallengeRuleType.openExplorer;
      case CreationChallengeRuleType.manualConfirm:
        return evidence.ruleType == CreationChallengeRuleType.manualConfirm;
    }
  }

  Future<void> _completeChallenge(
    CreationChallengeSummary summary, {
    required CreationChallengeEvidence evidence,
  }) async {
    final completion = ChallengeCompletion(
      id: 'challenge_${summary.challenge.id}_${DateTime.now().millisecondsSinceEpoch}',
      challengeId: summary.challenge.id,
      completedAt: evidence.occurredAt,
      evidenceType: _evidenceTypeFor(evidence.ruleType),
      evidenceRefId: evidence.refId,
      notes: evidence.notes,
      awardedDrops: summary.challenge.rewardDrops,
    );
    final updatedCompletions = <ChallengeCompletion>[completion, ...state.completions]
        .take(240)
        .toList(growable: false);
    final updatedHistory = <ChallengeHistoryEntry>[
      ChallengeHistoryEntry(
        id: 'history_${summary.challenge.id}_${DateTime.now().millisecondsSinceEpoch}',
        date: evidence.occurredAt,
        challengeId: summary.challenge.id,
        completed: true,
        skipped: false,
        explorerSource: summary.challenge.targetExplorerMode ?? evidence.source,
        categoryId: summary.challenge.targetCategoryId ?? evidence.categoryId,
      ),
      ...state.history,
    ].take(180).toList(growable: false);
    state = state.copyWith(completions: updatedCompletions, history: updatedHistory);
    _persist();
    _oceanDrops.awardDrop(
      actionType: oceanActionCreationChallengeCompleted,
      sourceModule: oceanSourceCreation,
      referenceId: summary.challenge.id,
    );
    AppTelemetry.logEvent(
      summary.slot == ChallengeSlot.weekly
          ? 'creation_weekly_reflection_completed'
          : 'creation_challenge_completed',
      metadata: <String, Object?>{
        'challengeId': summary.challenge.id,
        'slot': summary.slot.name,
        'rule': summary.challenge.completionRule.name,
      },
    );
  }

  ChallengeEvidenceType _evidenceTypeFor(CreationChallengeRuleType ruleType) {
    switch (ruleType) {
      case CreationChallengeRuleType.openExplorer:
      case CreationChallengeRuleType.checkSkyEvent:
        return ChallengeEvidenceType.explorerOpen;
      case CreationChallengeRuleType.detectCategory:
        return ChallengeEvidenceType.detection;
      case CreationChallengeRuleType.saveObservation:
        return ChallengeEvidenceType.observation;
      case CreationChallengeRuleType.saveReflection:
        return ChallengeEvidenceType.reflection;
      case CreationChallengeRuleType.manualConfirm:
        return ChallengeEvidenceType.manual;
    }
  }

  void _persist() {
    _repository.save(state);
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
