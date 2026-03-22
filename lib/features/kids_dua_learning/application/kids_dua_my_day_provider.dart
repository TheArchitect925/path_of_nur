import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/accounts_sync/application/accounts_sync_controller.dart';
import '../../../features/kids/activity/application/kids_activity_log_service.dart';
import '../../../features/kids/activity/domain/kids_activity_models.dart';
import '../../../features/progression/application/learner_progression_service.dart';
import '../../../features/progression/domain/learner_progression_models.dart';
import '../../../shared/persistence/local_store.dart';
import '../domain/kids_dua_models.dart';
import 'kids_dua_active_learner_service.dart';
import 'kids_dua_my_day_service.dart';
import 'kids_dua_progress_provider.dart';
import 'kids_dua_repository.dart';

const int kidsDuaMyDayXpBonus = 5;
const int kidsDuaMyDayDropsBonus = 1;

final kidsDuaMyDayServiceProvider = Provider<KidsDuaMyDayService>(
  (ref) => const KidsDuaMyDayService(),
);

final kidsDuaMyDayProvider =
    StateNotifierProvider<KidsDuaMyDayNotifier, DailyUsageState>((ref) {
      final controller = KidsDuaMyDayNotifier(ref);
      ref.listen<String>(
        kidsDuaActiveLearnerProvider.select((value) => value.learnerId),
        (_, nextLearnerId) => controller.updateActiveLearner(nextLearnerId),
      );
      return controller;
    });

final kidsDuaMyDaySectionsProvider = Provider<List<KidsDuaDaySection>>((ref) {
  return ref.watch(kidsDuaMyDayServiceProvider).getSections();
});

final kidsDuaMyDayGuidanceProvider = Provider<KidsDuaMyDayGuidance>((ref) {
  return ref
      .watch(kidsDuaMyDayServiceProvider)
      .buildGuidance(
        lessons: ref.watch(kidsDuaLessonsProvider),
        progress: ref.watch(kidsDuaLearningProvider),
        state: ref.watch(kidsDuaMyDayProvider),
        now: ref.watch(kidsDuaNowProvider)(),
      );
});

final kidsDuaMyDayNextSectionProvider = Provider<KidsDuaDaySection?>((ref) {
  return ref.watch(kidsDuaMyDayGuidanceProvider).nextUpSection ??
      ref
          .watch(kidsDuaMyDayServiceProvider)
          .nextIncompleteSection(ref.watch(kidsDuaMyDayProvider));
});

class KidsDuaMyDayNotifier extends StateNotifier<DailyUsageState> {
  KidsDuaMyDayNotifier(this._ref)
    : _store = _ref.read(localStoreProvider),
      _activeLearnerId = _ref.read(kidsDuaActiveLearnerProvider).learnerId,
      super(
        _syncGuidance(
          _ref,
          DailyUsageState.fromJson(
            _ref.read(localStoreProvider).getJsonMap(
              kidsDuaMyDayStorageKeyForLearner(
                _ref.read(kidsDuaActiveLearnerProvider).learnerId,
              ),
            ),
            _ref
                .read(kidsDuaMyDayServiceProvider)
                .todayKey(_ref.read(kidsDuaNowProvider)()),
          ),
        ),
      ) {
    _migrateLegacyStateIfNeeded();
    state = _syncGuidance(
      _ref,
      _ref
          .read(kidsDuaMyDayServiceProvider)
          .ensureToday(state: state, now: _ref.read(kidsDuaNowProvider)()),
    );
  }

  final Ref _ref;
  final LocalStore _store;
  String _activeLearnerId;

  KidsDuaMyDayCompletionResult completeDuaForToday(String duaId) {
    final service = _ref.read(kidsDuaMyDayServiceProvider);
    final now = _ref.read(kidsDuaNowProvider)();
    final current = service.ensureToday(state: state, now: now);
    final next = _syncGuidance(
      _ref,
      service.completeDua(state: current, duaId: duaId),
    );
    var xpAwarded = 0;
    var dropsAwarded = 0;
    if (next.isDayComplete && !current.dayCompletionRewarded) {
      _ref
          .read(kidsDuaLearningProvider.notifier)
          .registerMeaningfulActivity(
            KidsDuaDailyActivityType.myDaySectionCompleted,
          );
      _ref.read(kidsDuaLearningProvider.notifier).recordActivity(
        type: KidsDuaActivityLogType.myDayCompleted,
        duaId: duaId,
      );
      final reward = _ref
          .read(
            learnerProgressionControllerProvider(_activeLearnerId).notifier,
          )
          .award(
            sourceRef: 'kids_dua_my_day:${service.todayKey(now)}',
            activityType: LearnerProgressionActivityType.duaMyDayCompletion,
            sourceModule: 'kids_dua_learning',
            xp: kidsDuaMyDayXpBonus,
            drops: kidsDuaMyDayDropsBonus,
            occurredAt: now,
            metadata: <String, Object?>{
              'feature': 'kids_dua_my_day',
              'dateKey': service.todayKey(now),
            },
            mirrorToJourney: _shouldMirrorRewardsToJourney(_ref),
          );
      _ref
          .read(kidsDuaLearningProvider.notifier)
          .awardMyDayBonus(
            xp: reward.awardedXp,
            drops: reward.awardedDrops,
          );
      final lesson = _ref
          .read(kidsDuaLessonsProvider)
          .where((item) => item.id == duaId)
          .firstOrNull;
      _ref.read(kidsActivityLogProvider.notifier).log(
        type: KidsActivityType.duaMyDayCompleted,
        domain: KidsActivityDomain.duas,
        sourceRef: 'kids_dua_my_day_complete:${service.todayKey(now)}',
        contentId: duaId,
        titleSnapshot: lesson?.title,
        subtitleSnapshot: lesson?.miniLesson,
        occurredAt: now,
        metadata: <String, Object?>{
          'feature': 'kids_dua_my_day',
          'dateKey': service.todayKey(now),
          'duaId': duaId,
        },
      );
      xpAwarded = reward.awardedXp;
      dropsAwarded = reward.awardedDrops;
      state = next.copyWith(dayCompletionRewarded: true);
    } else {
      if (next.completedSectionIds.length >
              current.completedSectionIds.length ||
          next.completedDuaIds.length > current.completedDuaIds.length) {
        _ref
            .read(kidsDuaLearningProvider.notifier)
            .registerMeaningfulActivity(
              KidsDuaDailyActivityType.todayFocusCompleted,
            );
        _ref.read(kidsDuaLearningProvider.notifier).recordActivity(
          type: KidsDuaActivityLogType.myDayStepCompleted,
          duaId: duaId,
        );
      }
      state = next;
    }
    _persist();
    return KidsDuaMyDayCompletionResult(
      dayCompletedNow: next.isDayComplete && !current.isDayComplete,
      xpAwarded: xpAwarded,
      oceanDropsAwarded: dropsAwarded,
    );
  }

  void resetIfNeeded() {
    final next = _ref
        .read(kidsDuaMyDayServiceProvider)
        .ensureToday(state: state, now: _ref.read(kidsDuaNowProvider)());
    if (next.date == state.date &&
        next.completedDuaIds.length == state.completedDuaIds.length &&
        next.completedSectionIds.length == state.completedSectionIds.length) {
      return;
    }
    state = _syncGuidance(_ref, next);
    _persist();
  }

  void updateActiveLearner(String learnerId) {
    if (learnerId == _activeLearnerId) {
      return;
    }
    _activeLearnerId = learnerId;
    state = _syncGuidance(
      _ref,
      DailyUsageState.fromJson(
        _store.getJsonMap(kidsDuaMyDayStorageKeyForLearner(learnerId)),
        _ref
            .read(kidsDuaMyDayServiceProvider)
            .todayKey(_ref.read(kidsDuaNowProvider)()),
      ),
    );
    _migrateLegacyStateIfNeeded();
    resetIfNeeded();
  }

  void _persist() {
    _store.setJsonMap(
      kidsDuaMyDayStorageKeyForLearner(_activeLearnerId),
      state.toJson(),
    );
  }

  void _migrateLegacyStateIfNeeded() {
    final scopedKey = kidsDuaMyDayStorageKeyForLearner(_activeLearnerId);
    final scoped = _store.getJsonMap(scopedKey);
    if (scoped != null) {
      state = _syncGuidance(
        _ref,
        DailyUsageState.fromJson(
          scoped,
          _ref
              .read(kidsDuaMyDayServiceProvider)
              .todayKey(_ref.read(kidsDuaNowProvider)()),
        ),
      );
      return;
    }
    final legacy = _store.getJsonMap(legacyKidsDuaMyDayStateKey);
    if (legacy != null) {
      state = _syncGuidance(
        _ref,
        DailyUsageState.fromJson(
          legacy,
          _ref
              .read(kidsDuaMyDayServiceProvider)
              .todayKey(_ref.read(kidsDuaNowProvider)()),
        ),
      );
      _store.setJsonMap(scopedKey, state.toJson());
      _store.remove(legacyKidsDuaMyDayStateKey);
      return;
    }

    final legacyScopedLearnerId = legacyKidsDuaScopedLearnerIdForCurrent(
      _activeLearnerId,
    );
    if (legacyScopedLearnerId == null) {
      return;
    }
    final legacyScoped = _store.getJsonMap(
      kidsDuaMyDayStorageKeyForLearner(legacyScopedLearnerId),
    );
    if (legacyScoped == null) {
      return;
    }
    state = _syncGuidance(
      _ref,
      DailyUsageState.fromJson(
        legacyScoped,
        _ref
            .read(kidsDuaMyDayServiceProvider)
            .todayKey(_ref.read(kidsDuaNowProvider)()),
      ),
    );
    _store.setJsonMap(scopedKey, state.toJson());
    _store.remove(kidsDuaMyDayStorageKeyForLearner(legacyScopedLearnerId));
  }
}

bool _shouldMirrorRewardsToJourney(Ref ref) {
  final accounts = ref.read(accountsSyncControllerProvider);
  final learner = ref.read(kidsDuaActiveLearnerProvider);
  return learner.isChildProfile && accounts.activeProfileId == learner.learnerId;
}

DailyUsageState _syncGuidance(Ref ref, DailyUsageState value) {
  final guidance = ref
      .read(kidsDuaMyDayServiceProvider)
      .buildGuidance(
        lessons: ref.read(kidsDuaLessonsProvider),
        progress: ref.read(kidsDuaLearningProvider),
        state: value,
        now: ref.read(kidsDuaNowProvider)(),
      );
  return value.copyWith(
    currentSuggestedDuaId: guidance.rightNowLesson?.id,
    nextSuggestedDuaId: guidance.nextUpLesson?.id,
    clearCurrentSuggestedDuaId: guidance.rightNowLesson == null,
    clearNextSuggestedDuaId: guidance.nextUpLesson == null,
  );
}
