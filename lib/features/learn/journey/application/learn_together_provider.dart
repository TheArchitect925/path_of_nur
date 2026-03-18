import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/persistence/local_store.dart';
import '../domain/learn_together_models.dart';
import '../domain/learning_path_models.dart';

const _learnTogetherStorageKey = 'accounts_sync.learn_together.v1';

class LearnTogetherNotifier extends StateNotifier<LearnTogetherState> {
  LearnTogetherNotifier(this._store) : super(LearnTogetherState.initial()) {
    _load();
  }

  final LocalStore _store;

  void _load() {
    state = LearnTogetherState.fromJson(
      _store.getJsonMap(_learnTogetherStorageKey),
    );
  }

  Future<void> startSession({
    required String childProfileId,
    required String journeyId,
    required String stageId,
  }) async {
    final now = DateTime.now().toIso8601String();
    final record = LearnTogetherSessionRecord(
      childProfileId: childProfileId,
      journeyId: journeyId,
      stageId: stageId,
      startedAtIso: now,
    );
    state = state.copyWith(
      sessions: {
        ...state.sessions,
        record.id: record,
      },
    );
    await _save();
  }

  Future<void> markLearnedTogether({
    required String childProfileId,
    required String journeyId,
    required String stageId,
  }) async {
    final sessionId = '$childProfileId::$stageId';
    final existing = state.sessions[sessionId];
    final nextSessions = {...state.sessions};
    if (existing != null) {
      nextSessions[sessionId] = existing.copyWith(
        completedAtIso: DateTime.now().toIso8601String(),
      );
    } else {
      nextSessions[sessionId] = LearnTogetherSessionRecord(
        childProfileId: childProfileId,
        journeyId: journeyId,
        stageId: stageId,
        startedAtIso: DateTime.now().toIso8601String(),
        completedAtIso: DateTime.now().toIso8601String(),
      );
    }
    final learned = {
      ...state.learnedTogetherStageIds,
      childProfileId: <String>[
        ...state.learnedTogetherStageIds[childProfileId] ?? const <String>[],
        if (!(state.learnedTogetherStageIds[childProfileId] ?? const <String>[])
            .contains(stageId))
          stageId,
      ],
    };
    state = state.copyWith(
      sessions: nextSessions,
      learnedTogetherStageIds: learned,
    );
    await _save();
  }

  Future<void> _save() {
    return _store.setJsonMap(_learnTogetherStorageKey, state.toJson());
  }
}

final learnTogetherProvider =
    StateNotifierProvider<LearnTogetherNotifier, LearnTogetherState>(
      (ref) => LearnTogetherNotifier(ref.watch(localStoreProvider)),
    );

final learnTogetherEligibleJourneyIdsProvider = Provider<Set<String>>((ref) {
  return const <String>{
    'prophets-journey',
    'seerah-journey',
    'beautiful-character',
    'duas-daily-life',
    'daily-dhikr',
    'stories-signs',
  };
});

final learnTogetherPromptProvider = Provider.family<
    LearnTogetherPromptSet?,
    ({
      String journeyId,
      String stageId,
      LearningAgeGroup ageGroup,
      AppLocalizations l10n,
    })>((ref, args) {
  final l10n = args.l10n;
  final isKids = args.ageGroup == LearningAgeGroup.kids;
  switch (args.journeyId) {
    case 'prophets-journey':
    case 'seerah-journey':
      return LearnTogetherPromptSet(
        discussionPrompts: [
          isKids
              ? l10n.learnTogetherPromptStoryKids1
              : l10n.learnTogetherPromptStory1,
          isKids
              ? l10n.learnTogetherPromptStoryKids2
              : l10n.learnTogetherPromptStory2,
        ],
        parentGuidance: l10n.learnTogetherGuidancePatience,
        familyPrompt: l10n.learnTogetherFamilyPromptStory,
      );
    case 'beautiful-character':
      return LearnTogetherPromptSet(
        discussionPrompts: [
          l10n.learnTogetherPromptCharacter1,
          l10n.learnTogetherPromptCharacter2,
        ],
        parentGuidance: l10n.learnTogetherGuidanceCharacter,
        familyPrompt: l10n.learnTogetherFamilyPromptCharacter,
      );
    case 'duas-daily-life':
      return LearnTogetherPromptSet(
        discussionPrompts: [
          l10n.learnTogetherPromptDua1,
          l10n.learnTogetherPromptDua2,
        ],
        parentGuidance: l10n.learnTogetherGuidanceDua,
        familyPrompt: l10n.learnTogetherFamilyPromptDua,
      );
    case 'daily-dhikr':
      return LearnTogetherPromptSet(
        discussionPrompts: [
          l10n.learnTogetherPromptDhikr1,
          l10n.learnTogetherPromptDhikr2,
        ],
        parentGuidance: l10n.learnTogetherGuidanceDhikr,
        familyPrompt: l10n.learnTogetherFamilyPromptDhikr,
      );
    case 'stories-signs':
      return LearnTogetherPromptSet(
        discussionPrompts: [
          l10n.learnTogetherPromptSigns1,
          l10n.learnTogetherPromptSigns2,
        ],
        parentGuidance: l10n.learnTogetherGuidanceSigns,
        familyPrompt: l10n.learnTogetherFamilyPromptSigns,
      );
    default:
      return null;
  }
});
