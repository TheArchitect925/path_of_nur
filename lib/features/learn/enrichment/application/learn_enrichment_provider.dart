import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/locale_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/persistence/local_store.dart';
import '../../guided_paths/application/guided_learning_paths_provider.dart';
import '../../guided_paths/domain/guided_learning_path_models.dart';
import '../../personalization/data/learning_path_sequence_registry.dart';
import '../../personalization/domain/learning_personalization_models.dart';
import '../domain/learn_enrichment_models.dart';

const _learnEnrichmentStateKey = 'learn.enrichment.state.v1';

final learnEnrichmentControllerProvider =
    StateNotifierProvider<LearnEnrichmentController, LearnEnrichmentState>((
      ref,
    ) {
      return LearnEnrichmentController(ref.watch(localStoreProvider));
    });

class LearnEnrichmentController extends StateNotifier<LearnEnrichmentState> {
  LearnEnrichmentController(this._store)
    : super(
        LearnEnrichmentState.fromJson(
          _store.getJsonMap(_learnEnrichmentStateKey),
        ),
      );

  final LocalStore _store;

  void _persist() {
    _store.setJsonMap(_learnEnrichmentStateKey, state.toJson());
  }

  void recordPathStarted({
    required GuidedLearningPath path,
    required GuidedLearningPathProgress previousProgress,
    required DateTime occurredAt,
  }) {
    if (!previousProgress.isStarted) {
      _unlockMilestone(
        milestoneId: 'learn_milestone_first_path_started',
        occurredAt: occurredAt,
        pathId: path.id,
      );
    }

    final lastActiveAt = previousProgress.lastUpdatedAtIso == null
        ? null
        : DateTime.tryParse(previousProgress.lastUpdatedAtIso!);
    if (lastActiveAt != null &&
        occurredAt.difference(lastActiveAt) >= const Duration(days: 7)) {
      _unlockMilestone(
        milestoneId: 'learn_milestone_return_after_break',
        occurredAt: occurredAt,
        pathId: path.id,
      );
    }
  }

  void recordStepCompleted({
    required GuidedLearningPath path,
    required GuidedLearningPathProgress previousProgress,
    required DateTime occurredAt,
  }) {
    final nextRecent = <String>[
      occurredAt.toIso8601String(),
      ...state.recentStepCompletedAtIsos,
    ].take(40).toList(growable: false);
    state = state.copyWith(recentStepCompletedAtIsos: nextRecent);

    if (previousProgress.completedStepIds.isEmpty) {
      _unlockMilestone(
        milestoneId: 'learn_milestone_first_step_completed',
        occurredAt: occurredAt,
        pathId: path.id,
      );
    }
    if (path.bucketId == 'quran') {
      _unlockMilestone(
        milestoneId: 'learn_milestone_first_quran_step_completed',
        occurredAt: occurredAt,
        pathId: path.id,
      );
    }
    final weekCutoff = occurredAt.subtract(const Duration(days: 7));
    final weeklyCount = nextRecent
        .map(DateTime.tryParse)
        .whereType<DateTime>()
        .where((item) => !item.isBefore(weekCutoff))
        .length;
    if (weeklyCount >= 3) {
      _unlockMilestone(
        milestoneId: 'learn_milestone_three_steps_week',
        occurredAt: occurredAt,
        pathId: path.id,
      );
    }
    _persist();
  }

  void recordPathCompleted({
    required GuidedLearningPath path,
    required DateTime occurredAt,
  }) {
    _unlockMilestone(
      milestoneId: 'learn_milestone_first_path_completed',
      occurredAt: occurredAt,
      pathId: path.id,
    );
    if (path.id == 'foundations-starter') {
      _unlockMilestone(
        milestoneId: 'learn_milestone_foundations_completed',
        occurredAt: occurredAt,
        pathId: path.id,
      );
    }
    if (path.id == 'stories-starter') {
      _unlockMilestone(
        milestoneId: 'learn_milestone_stories_completed',
        occurredAt: occurredAt,
        pathId: path.id,
      );
    }
    if (path.audience == GuidedLearningPathAudience.kids) {
      _unlockMilestone(
        milestoneId: 'learn_milestone_first_kids_path_completed',
        occurredAt: occurredAt,
        pathId: path.id,
      );
    }
    _persist();
  }

  void acknowledgeMilestone(String milestoneId) {
    if (!state.unlockedAtByMilestoneId.containsKey(milestoneId)) return;
    final nextAcknowledged = Map<String, String>.from(
      state.acknowledgedAtByMilestoneId,
    )..[milestoneId] = DateTime.now().toIso8601String();
    state = state.copyWith(acknowledgedAtByMilestoneId: nextAcknowledged);
    _persist();
  }

  void _unlockMilestone({
    required String milestoneId,
    required DateTime occurredAt,
    String? pathId,
  }) {
    if (state.unlockedAtByMilestoneId.containsKey(milestoneId)) return;
    final nextUnlocked = Map<String, String>.from(state.unlockedAtByMilestoneId)
      ..[milestoneId] = occurredAt.toIso8601String();
    final nextMemories = <LearningMemoryRecord>[
      LearningMemoryRecord(
        id: 'memory:$milestoneId',
        milestoneId: milestoneId,
        occurredAtIso: occurredAt.toIso8601String(),
        pathId: pathId,
      ),
      ...state.memories.where((item) => item.milestoneId != milestoneId),
    ].take(12).toList(growable: false);
    state = state.copyWith(
      unlockedAtByMilestoneId: nextUnlocked,
      memories: nextMemories,
    );
  }
}

final pendingLearningMilestoneProvider = Provider<LearningMemoryRecord?>((ref) {
  final state = ref.watch(learnEnrichmentControllerProvider);
  final pending = state.memories.where(
    (memory) =>
        state.unlockedAtByMilestoneId.containsKey(memory.milestoneId) &&
        !state.acknowledgedAtByMilestoneId.containsKey(memory.milestoneId),
  );
  if (pending.isEmpty) return null;
  return pending.first;
});

final localizedPendingLearningMilestoneProvider =
    Provider<LocalizedLearningMilestoneMoment?>((ref) {
      final locale =
          ref.watch(appLocaleProvider) ??
          AppLocalizations.supportedLocales.first;
      final l10n = lookupAppLocalizations(locale);
      final record = ref.watch(pendingLearningMilestoneProvider);
      if (record == null) return null;
      return _localizedMilestoneMoment(
        l10n: l10n,
        record: record,
        pathLookup: (pathId) =>
            ref.read(localizedGuidedLearningPathByIdProvider(pathId)),
      );
    });

final localizedLearningMemoriesProvider =
    Provider<List<LocalizedLearningMemoryCard>>((ref) {
      final locale =
          ref.watch(appLocaleProvider) ??
          AppLocalizations.supportedLocales.first;
      final l10n = lookupAppLocalizations(locale);
      final state = ref.watch(learnEnrichmentControllerProvider);
      return state.memories
          .map(
            (record) => _localizedMemoryCard(
              l10n: l10n,
              record: record,
              pathLookup: (pathId) =>
                  ref.read(localizedGuidedLearningPathByIdProvider(pathId)),
            ),
          )
          .whereType<LocalizedLearningMemoryCard>()
          .toList(growable: false);
    });

final localizedLearningEncouragementProvider = Provider<String?>((ref) {
  final locale =
      ref.watch(appLocaleProvider) ?? AppLocalizations.supportedLocales.first;
  final l10n = lookupAppLocalizations(locale);
  final pending = ref.watch(localizedPendingLearningMilestoneProvider);
  if (pending != null) return pending.encouragement;

  final resume = ref.watch(guidedLearningPathResumeProvider);
  if (resume.hasActivePath) {
    return l10n.learnEnrichmentEncouragementSmallStep;
  }

  final memories = ref.watch(localizedLearningMemoriesProvider);
  if (memories.isNotEmpty) {
    return l10n.learnEnrichmentEncouragementNextChapter;
  }
  return null;
});

final localizedPathCompletionEnrichmentProvider =
    Provider.family<LocalizedLearningPathCompletionEnrichment?, String>((
      ref,
      pathId,
    ) {
      final locale =
          ref.watch(appLocaleProvider) ??
          AppLocalizations.supportedLocales.first;
      final l10n = lookupAppLocalizations(locale);
      final path = ref.watch(localizedGuidedLearningPathByIdProvider(pathId));
      if (path == null) return null;
      final progress = ref.watch(guidedLearningPathProgressProvider(pathId));
      if (!progress.isCompleted) return null;

      final enrichmentState = ref.watch(learnEnrichmentControllerProvider);
      final pathMemoryRecord = enrichmentState.memories.firstWhere(
        (item) => item.pathId == pathId,
        orElse: () => const LearningMemoryRecord(
          id: '',
          milestoneId: '',
          occurredAtIso: '',
        ),
      );
      final pathMemory = pathMemoryRecord.id.isEmpty
          ? null
          : _localizedMemoryCard(
              l10n: l10n,
              record: pathMemoryRecord,
              pathLookup: (nextPathId) =>
                  ref.read(localizedGuidedLearningPathByIdProvider(nextPathId)),
            );

      LearningPathSequenceDefinition? sequence;
      for (final item in kLearningPathSequenceDefinitions) {
        if (item.pathId == pathId) {
          sequence = item;
          break;
        }
      }
      final nextSuggestions = <LocalizedLearningPathSuggestion>[];
      for (final nextPathId in sequence?.nextPathIds ?? const <String>[]) {
        if (nextPathId == pathId) continue;
        final localizedNext = ref.read(
          localizedGuidedLearningPathByIdProvider(nextPathId),
        );
        if (localizedNext == null) continue;
        nextSuggestions.add(
          LocalizedLearningPathSuggestion(
            pathId: localizedNext.path.id,
            title: localizedNext.title,
          ),
        );
        if (nextSuggestions.length >= 2) break;
      }

      final isKids = path.path.audience == GuidedLearningPathAudience.kids;
      return LocalizedLearningPathCompletionEnrichment(
        title: isKids
            ? l10n.learnEnrichmentCompletionKidsTitle
            : l10n.learnEnrichmentCompletionTitle(path.title),
        subtitle: isKids
            ? l10n.learnEnrichmentCompletionKidsSubtitle
            : l10n.learnEnrichmentCompletionSubtitle,
        body: isKids
            ? l10n.learnEnrichmentCompletionKidsBody
            : l10n.learnEnrichmentCompletionBody,
        encouragement: isKids
            ? l10n.learnEnrichmentEncouragementKids
            : l10n.learnEnrichmentEncouragementNextChapter,
        memoryLine: pathMemory?.body,
        primarySuggestions: nextSuggestions,
        isKids: isKids,
      );
    });

LocalizedLearningMilestoneMoment _localizedMilestoneMoment({
  required AppLocalizations l10n,
  required LearningMemoryRecord record,
  required LocalizedGuidedLearningPath? Function(String pathId) pathLookup,
}) {
  final occurredAt = DateTime.tryParse(record.occurredAtIso) ?? DateTime.now();
  final pathTitle = record.pathId == null
      ? null
      : pathLookup(record.pathId!)?.title;
  final isKids =
      record.milestoneId == 'learn_milestone_first_kids_path_completed';
  return switch (record.milestoneId) {
    'learn_milestone_first_path_started' => LocalizedLearningMilestoneMoment(
      id: record.id,
      title: l10n.learnEnrichmentMilestoneFirstPathStartedTitle(
        pathTitle ?? l10n.guidedLearningPathsTitle,
      ),
      body: l10n.learnEnrichmentMilestoneFirstPathStartedBody,
      encouragement: l10n.learnEnrichmentEncouragementSmallStep,
      iconCodePoint: _iconFor(record.milestoneId),
      pathId: record.pathId,
      occurredAt: occurredAt,
      isKids: false,
    ),
    'learn_milestone_first_step_completed' => LocalizedLearningMilestoneMoment(
      id: record.id,
      title: l10n.learnEnrichmentMilestoneFirstStepCompletedTitle,
      body: l10n.learnEnrichmentMilestoneFirstStepCompletedBody,
      encouragement: l10n.learnEnrichmentEncouragementSmallStep,
      iconCodePoint: _iconFor(record.milestoneId),
      pathId: record.pathId,
      occurredAt: occurredAt,
      isKids: false,
    ),
    'learn_milestone_first_path_completed' => LocalizedLearningMilestoneMoment(
      id: record.id,
      title: l10n.learnEnrichmentMilestoneFirstPathCompletedTitle,
      body: l10n.learnEnrichmentMilestoneFirstPathCompletedBody,
      encouragement: l10n.learnEnrichmentEncouragementNextChapter,
      iconCodePoint: _iconFor(record.milestoneId),
      pathId: record.pathId,
      occurredAt: occurredAt,
      isKids: false,
    ),
    'learn_milestone_foundations_completed' => LocalizedLearningMilestoneMoment(
      id: record.id,
      title: l10n.learnEnrichmentMilestoneFoundationsCompletedTitle,
      body: l10n.learnEnrichmentMilestoneFoundationsCompletedBody,
      encouragement: l10n.learnEnrichmentEncouragementReadyForNextPath,
      iconCodePoint: _iconFor(record.milestoneId),
      pathId: record.pathId,
      occurredAt: occurredAt,
      isKids: false,
    ),
    'learn_milestone_first_quran_step_completed' =>
      LocalizedLearningMilestoneMoment(
        id: record.id,
        title: l10n.learnEnrichmentMilestoneFirstQuranStepCompletedTitle,
        body: l10n.learnEnrichmentMilestoneFirstQuranStepCompletedBody,
        encouragement: l10n.learnEnrichmentEncouragementQuran,
        iconCodePoint: _iconFor(record.milestoneId),
        pathId: record.pathId,
        occurredAt: occurredAt,
        isKids: false,
      ),
    'learn_milestone_first_kids_path_completed' =>
      LocalizedLearningMilestoneMoment(
        id: record.id,
        title: l10n.learnEnrichmentMilestoneFirstKidsPathCompletedTitle,
        body: l10n.learnEnrichmentMilestoneFirstKidsPathCompletedBody,
        encouragement: l10n.learnEnrichmentEncouragementKids,
        iconCodePoint: _iconFor(record.milestoneId),
        pathId: record.pathId,
        occurredAt: occurredAt,
        isKids: true,
      ),
    'learn_milestone_stories_completed' => LocalizedLearningMilestoneMoment(
      id: record.id,
      title: l10n.learnEnrichmentMilestoneStoriesCompletedTitle,
      body: l10n.learnEnrichmentMilestoneStoriesCompletedBody,
      encouragement: l10n.learnEnrichmentEncouragementStories,
      iconCodePoint: _iconFor(record.milestoneId),
      pathId: record.pathId,
      occurredAt: occurredAt,
      isKids: false,
    ),
    'learn_milestone_three_steps_week' => LocalizedLearningMilestoneMoment(
      id: record.id,
      title: l10n.learnEnrichmentMilestoneThreeStepsWeekTitle,
      body: l10n.learnEnrichmentMilestoneThreeStepsWeekBody,
      encouragement: l10n.learnEnrichmentEncouragementSteadyRhythm,
      iconCodePoint: _iconFor(record.milestoneId),
      pathId: record.pathId,
      occurredAt: occurredAt,
      isKids: false,
    ),
    'learn_milestone_return_after_break' => LocalizedLearningMilestoneMoment(
      id: record.id,
      title: l10n.learnEnrichmentMilestoneReturnAfterBreakTitle,
      body: l10n.learnEnrichmentMilestoneReturnAfterBreakBody,
      encouragement: l10n.learnEnrichmentEncouragementWelcomeBack,
      iconCodePoint: _iconFor(record.milestoneId),
      pathId: record.pathId,
      occurredAt: occurredAt,
      isKids: false,
    ),
    _ => LocalizedLearningMilestoneMoment(
      id: record.id,
      title: l10n.learnEnrichmentMilestoneGenericTitle,
      body: l10n.learnEnrichmentMilestoneGenericBody,
      encouragement: l10n.learnEnrichmentEncouragementSmallStep,
      iconCodePoint: _iconFor(record.milestoneId),
      pathId: record.pathId,
      occurredAt: occurredAt,
      isKids: isKids,
    ),
  };
}

LocalizedLearningMemoryCard? _localizedMemoryCard({
  required AppLocalizations l10n,
  required LearningMemoryRecord record,
  required LocalizedGuidedLearningPath? Function(String pathId) pathLookup,
}) {
  final occurredAt = DateTime.tryParse(record.occurredAtIso);
  if (occurredAt == null) return null;
  final moment = _localizedMilestoneMoment(
    l10n: l10n,
    record: record,
    pathLookup: pathLookup,
  );
  return LocalizedLearningMemoryCard(
    id: record.id,
    title: moment.title,
    body: moment.body,
    occurredAt: occurredAt,
    iconCodePoint: moment.iconCodePoint,
    isKids: moment.isKids,
  );
}

int _iconFor(String milestoneId) {
  for (final item in kLearningMilestoneDefinitions) {
    if (item.id == milestoneId) return item.iconCodePoint;
  }
  return 0xe86c;
}
