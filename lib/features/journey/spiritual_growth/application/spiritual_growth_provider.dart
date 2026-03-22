import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../../learn/journey/application/family_learning_provider.dart';
import '../../../learn/knowledge_games/adaptive/application/user_learning_profile_provider.dart';
import '../../../learn/knowledge_games/daily/application/daily_knowledge_challenge_hub_provider.dart';
import '../../application/growth_models.dart';
import '../../application/growth_providers.dart';
import '../../application/journey_progression_provider.dart';
import '../../drops/application/journey_drops_providers.dart';
import '../../xp/application/journey_xp_providers.dart';
import '../domain/spiritual_growth_models.dart';
import 'spiritual_growth_engine.dart';
import 'spiritual_growth_validation.dart';

const _spiritualGrowthStateKey = 'journey.spiritual_growth.v1';

final spiritualGrowthCatalogProvider = Provider<SpiritualGrowthCatalog>((ref) {
  final catalog = spiritualGrowthSeedCatalog;
  SpiritualGrowthValidation.debugReport(
    SpiritualGrowthValidation.validateCatalog(catalog),
  );
  return catalog;
});

final spiritualGrowthValidationReportProvider =
    Provider<SpiritualGrowthValidationReport>((ref) {
      return SpiritualGrowthValidation.validateCatalog(
        ref.watch(spiritualGrowthCatalogProvider),
      );
    });

final spiritualGrowthEngineProvider = Provider<SpiritualGrowthEngine>(
  (_) => const SpiritualGrowthEngine(),
);

class SpiritualGrowthController extends StateNotifier<SpiritualGrowthState> {
  SpiritualGrowthController(this._ref, this._store)
    : super(
        SpiritualGrowthState.fromJson(_store.getJsonMap(_spiritualGrowthStateKey)),
      );

  final Ref _ref;
  final LocalStore _store;

  void _persist() {
    _store.setJsonMap(_spiritualGrowthStateKey, state.toJson());
  }

  void chooseIntention({
    required String dateKey,
    required String intentionId,
  }) {
    state = state.copyWith(
      selectedIntentionIdByDateKey: {
        ...state.selectedIntentionIdByDateKey,
        dateKey: intentionId,
      },
    );
    _persist();
  }

  void toggleManualAction({
    required String dateKey,
    required String actionId,
  }) {
    final current = Set<String>.from(state.manualActionIdsFor(dateKey));
    if (!current.add(actionId)) {
      current.remove(actionId);
    }
    state = state.copyWith(
      manualActionIdsByDateKey: {
        ...state.manualActionIdsByDateKey,
        dateKey: current,
      },
    );
    _persist();
  }

  void submitReflection({
    required DateTime date,
    required String promptId,
    required String responseId,
    required List<String> completedActionIds,
    required String? moodTag,
    required String? note,
  }) {
    final dateKey = LocalStore.todayKey(date);
    final occurredAt = DateTime.now();
    final selectedIntentionId = state.selectedIntentionFor(dateKey);
    final entry = DailyReflectionEntry(
      dateKey: dateKey,
      intentionId: selectedIntentionId,
      completedActionIds: completedActionIds,
      moodTag: moodTag,
      reflectionPromptId: promptId,
      selectedReflectionResponse: responseId,
      note: note?.trim().isEmpty == true ? null : note?.trim(),
      isCompleted: true,
      completedAtIso: occurredAt.toIso8601String(),
    );
    state = state.copyWith(
      reflectionEntryByDateKey: {
        ...state.reflectionEntryByDateKey,
        dateKey: entry,
      },
    );
    _persist();

    final catalog = _ref.read(spiritualGrowthCatalogProvider);
    final prompt = catalog.reflectionPrompts
        .where((item) => item.id == promptId)
        .firstOrNull;
    final selectedIntention = catalog.intentions
        .where((item) => item.id == selectedIntentionId)
        .firstOrNull;
    _ref.read(growthControllerProvider.notifier).addReflection(
      date: date,
      prompt: prompt?.id ?? promptId,
      gratitude: selectedIntention?.id ?? '',
      tawbah: moodTag ?? '',
      note: note?.trim() ?? '',
      entrustToAllah: prompt?.theme == 'trust_in_allah',
      mood: _growthMoodFromTag(moodTag),
      linkedHabitId: null,
    );
    _ref.read(journeyProgressUpdateHelperProvider).addReflectionEntries(1);

    if ((state.reflectionRewardGrantedAtIsoByDateKey[dateKey] ?? '').isEmpty) {
      state = state.copyWith(
        reflectionRewardGrantedAtIsoByDateKey: {
          ...state.reflectionRewardGrantedAtIsoByDateKey,
          dateKey: occurredAt.toIso8601String(),
        },
      );
      _persist();
      _ref.read(journeyXpSummaryProvider.notifier).awardLearningXp(
        sourceRef: 'spiritual_growth:reflection:$dateKey',
        sourceModule: 'journey',
        occurredAt: occurredAt,
        metadata: <String, Object?>{
          'promptId': promptId,
          'responseId': responseId,
          'theme': prompt?.theme,
        },
      );
      _ref.read(journeyDropSummaryProvider.notifier).awardLearningDrop(
        sourceRef: 'spiritual_growth:reflection:$dateKey',
        occurredAt: occurredAt,
        metadata: <String, Object?>{
          'promptId': promptId,
          'responseId': responseId,
          'theme': prompt?.theme,
        },
      );
    }
  }

  GrowthMoodState? _growthMoodFromTag(String? tag) {
    return switch (tag) {
      'calm' => GrowthMoodState.calm,
      'grateful' => GrowthMoodState.grateful,
      'hopeful' => GrowthMoodState.hopeful,
      'tired' => GrowthMoodState.tired,
      'heavy' => GrowthMoodState.heavy,
      _ => null,
    };
  }
}

final spiritualGrowthControllerProvider =
    StateNotifierProvider<SpiritualGrowthController, SpiritualGrowthState>((ref) {
      return SpiritualGrowthController(ref, ref.watch(localStoreProvider));
    });

final spiritualGrowthAudienceProvider = Provider<String>((ref) {
  final isChildProfile = ref.watch(
    activeFamilyLearningContextProvider.select(
      (value) => value.visibilityPolicy.isChildProfile,
    ),
  );
  return isChildProfile ? 'kids' : 'adult';
});

final spiritualGrowthTodayKeyProvider = Provider<String>(
  (_) => LocalStore.todayKey(),
);

final spiritualGrowthTodayActionStatusesProvider =
    Provider<List<GrowthActionStatus>>((ref) {
      final catalog = ref.watch(spiritualGrowthCatalogProvider);
      final snapshot = ref.watch(journeyActivitySnapshotProvider);
      final hubProgress = ref.watch(dailyKnowledgeChallengeHubProgressProvider);
      final todayKey = ref.watch(spiritualGrowthTodayKeyProvider);
      final manualIds = ref.watch(
        spiritualGrowthControllerProvider.select(
          (value) => value.manualActionIdsFor(todayKey),
        ),
      );
      final bundleCompleted = hubProgress.progressFor(todayKey).isCompleted;

      return catalog.actions.map((action) {
        final isCompleted = switch (action.id) {
          'salah_presence' => snapshot.prayerCompletedToday > 0,
          'dhikr_remembrance' => snapshot.dhikrSessionsToday > 0,
          'quran_connection' => snapshot.quranEngagementsToday > 0,
          'learning_consistency' => snapshot.learningStageCompletionsToday > 0,
          'daily_bundle' => bundleCompleted,
          _ => manualIds.contains(action.id),
        };
        return GrowthActionStatus(
          action: action,
          isCompleted: isCompleted,
          isManual: action.isManual,
        );
      }).toList(growable: false);
    });

final spiritualGrowthSuggestedIntentionProvider = Provider<DailyIntention>((ref) {
  final engine = ref.watch(spiritualGrowthEngineProvider);
  final catalog = ref.watch(spiritualGrowthCatalogProvider);
  final audience = ref.watch(spiritualGrowthAudienceProvider);
  final adaptiveProfile = ref.watch(userLearningProfileProvider);
  final snapshot = ref.watch(journeyActivitySnapshotProvider);
  final todayKey = ref.watch(spiritualGrowthTodayKeyProvider);
  final hubProgress = ref.watch(dailyKnowledgeChallengeHubProgressProvider);
  return engine.suggestedIntention(
    catalog: catalog,
    date: DateTime.parse(todayKey),
    audience: audience,
    adaptiveProfile: adaptiveProfile,
    snapshot: snapshot,
    dailyBundleCompleted: hubProgress.progressFor(todayKey).isCompleted,
  );
});

final spiritualGrowthRankedIntentionsProvider = Provider<List<DailyIntention>>((
  ref,
) {
  final engine = ref.watch(spiritualGrowthEngineProvider);
  final catalog = ref.watch(spiritualGrowthCatalogProvider);
  final audience = ref.watch(spiritualGrowthAudienceProvider);
  final adaptiveProfile = ref.watch(userLearningProfileProvider);
  final snapshot = ref.watch(journeyActivitySnapshotProvider);
  final todayKey = ref.watch(spiritualGrowthTodayKeyProvider);
  final hubProgress = ref.watch(dailyKnowledgeChallengeHubProgressProvider);
  return engine.rankedIntentions(
    catalog: catalog,
    date: DateTime.parse(todayKey),
    audience: audience,
    adaptiveProfile: adaptiveProfile,
    snapshot: snapshot,
    dailyBundleCompleted: hubProgress.progressFor(todayKey).isCompleted,
  );
});

final spiritualGrowthActiveIntentionProvider = Provider<DailyIntention>((ref) {
  final catalog = ref.watch(spiritualGrowthCatalogProvider);
  final todayKey = ref.watch(spiritualGrowthTodayKeyProvider);
  final selectedId = ref.watch(
    spiritualGrowthControllerProvider.select(
      (value) => value.selectedIntentionFor(todayKey),
    ),
  );
  if (selectedId != null) {
    final selected = catalog.intentions.where((item) => item.id == selectedId).firstOrNull;
    if (selected != null) return selected;
  }
  return ref.watch(spiritualGrowthSuggestedIntentionProvider);
});

final spiritualGrowthSuggestedReflectionPromptProvider =
    Provider<SpiritualReflectionPrompt>((ref) {
      final engine = ref.watch(spiritualGrowthEngineProvider);
      final catalog = ref.watch(spiritualGrowthCatalogProvider);
      final audience = ref.watch(spiritualGrowthAudienceProvider);
      final todayKey = ref.watch(spiritualGrowthTodayKeyProvider);
      final activeIntention = ref.watch(spiritualGrowthActiveIntentionProvider);
      return engine.suggestedReflectionPrompt(
        catalog: catalog,
        date: DateTime.parse(todayKey),
        audience: audience,
        selectedTheme: activeIntention.theme,
      );
    });

final spiritualGrowthProfileProvider = Provider<SpiritualGrowthProfile>((ref) {
  final engine = ref.watch(spiritualGrowthEngineProvider);
  final catalog = ref.watch(spiritualGrowthCatalogProvider);
  final state = ref.watch(spiritualGrowthControllerProvider);
  final todayKey = ref.watch(spiritualGrowthTodayKeyProvider);
  final actions = ref.watch(spiritualGrowthTodayActionStatusesProvider);
  return engine.buildProfile(
    catalog: catalog,
    state: state,
    todayKey: todayKey,
    todayActions: actions,
  );
});

final spiritualGrowthThemeSummariesProvider =
    Provider<List<SpiritualGrowthThemeSummary>>((ref) {
      final engine = ref.watch(spiritualGrowthEngineProvider);
      return engine.buildThemeSummaries(
        profile: ref.watch(spiritualGrowthProfileProvider),
      );
    });
