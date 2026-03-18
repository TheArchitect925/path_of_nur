import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/ocean/application/ocean_drops_provider.dart';
import '../../../shared/persistence/local_store.dart';
import '../domain/kids_dua_models.dart';
import 'kids_dua_my_day_service.dart';
import 'kids_dua_progress_provider.dart';
import 'kids_dua_repository.dart';

const _kidsDuaMyDayStateKey = 'kids.dua.my_day.v1';
const int kidsDuaMyDayXpBonus = 5;
const int kidsDuaMyDayDropsBonus = 1;

final kidsDuaMyDayServiceProvider = Provider<KidsDuaMyDayService>(
  (ref) => const KidsDuaMyDayService(),
);

final kidsDuaMyDayProvider =
    StateNotifierProvider<KidsDuaMyDayNotifier, DailyUsageState>((ref) {
      return KidsDuaMyDayNotifier(ref);
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
      super(
        _syncGuidance(
          _ref,
          DailyUsageState.fromJson(
            _ref.read(localStoreProvider).getJsonMap(_kidsDuaMyDayStateKey),
            _ref
                .read(kidsDuaMyDayServiceProvider)
                .todayKey(_ref.read(kidsDuaNowProvider)()),
          ),
        ),
      ) {
    state = _syncGuidance(
      _ref,
      _ref
          .read(kidsDuaMyDayServiceProvider)
          .ensureToday(state: state, now: _ref.read(kidsDuaNowProvider)()),
    );
  }

  final Ref _ref;
  final LocalStore _store;

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
      final oceanDropsAwarded = _ref
          .read(oceanDropServiceProvider)
          .awardDrop(
            actionType: oceanActionLessonCompleted,
            sourceModule: oceanSourceLearn,
            referenceId: 'kids_dua_my_day_${service.todayKey(now)}',
            metadata: <String, dynamic>{
              'timestamp': now.toIso8601String(),
              'feature': 'kids_dua_my_day',
            },
          );
      _ref
          .read(kidsDuaLearningProvider.notifier)
          .awardMyDayBonus(
            xp: kidsDuaMyDayXpBonus,
            drops: oceanDropsAwarded > 0 ? kidsDuaMyDayDropsBonus : 0,
          );
      xpAwarded = kidsDuaMyDayXpBonus;
      dropsAwarded = oceanDropsAwarded > 0 ? kidsDuaMyDayDropsBonus : 0;
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

  void _persist() {
    _store.setJsonMap(_kidsDuaMyDayStateKey, state.toJson());
  }
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
