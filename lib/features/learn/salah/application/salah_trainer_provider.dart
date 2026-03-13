import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../shared/application/learn_system_engine_provider.dart';
import '../data/salah_trainer_data.dart';
import '../models/salah_trainer_models.dart';

const _storageKey = 'learn.salah.trainer.progress.v1';
const _guidanceNoticeKey = 'learn.salah.trainer.guidanceNoticeAccepted.v1';

class SalahTrainerProgressNotifier
    extends StateNotifier<SalahTrainerProgressState> {
  SalahTrainerProgressNotifier(this._store, this._ref)
    : super(SalahTrainerProgressState.fromJson(_store.getJsonMap(_storageKey)));

  final LocalStore _store;
  final Ref _ref;

  void openPrayer(SalahPrayerId prayerId) {
    final id = prayerId.name;
    final recent = [...state.recentPrayerIds]..remove(id);
    recent.insert(0, id);
    if (recent.length > 8) {
      recent.removeRange(8, recent.length);
    }
    state = state.copyWith(recentPrayerIds: recent);
    _persist();
    _ref
        .read(learnUnifiedProgressProvider.notifier)
        .markStarted(_prayerItemId(id));
  }

  void completePrayer(SalahPrayerId prayerId) {
    final id = prayerId.name;
    final completed = {...state.completedPrayerIds, id};
    state = state.copyWith(completedPrayerIds: completed);
    _persist();
    final progress = _ref.read(learnUnifiedProgressProvider.notifier);
    progress.markCompleted(_prayerItemId(id));
    progress.markPracticed(_prayerItemId(id));
  }

  void markRecitationLearned(String recitationId) {
    final learned = {...state.learnedRecitationIds, recitationId};
    state = state.copyWith(learnedRecitationIds: learned);
    _persist();
    _ref
        .read(learnUnifiedProgressProvider.notifier)
        .markReviewed('salah:recitation:$recitationId');
  }

  void setSurahProgress(String surahId, SalahSurahProgress progress) {
    final next = Map<String, SalahSurahProgress>.from(state.surahProgressById)
      ..[surahId] = progress;
    state = state.copyWith(surahProgressById: next);
    _persist();

    final controller = _ref.read(learnUnifiedProgressProvider.notifier);
    final itemId = 'salah:surah:$surahId';
    controller.markStarted(itemId);
    switch (progress) {
      case SalahSurahProgress.notStarted:
        break;
      case SalahSurahProgress.learning:
        controller.markReviewed(itemId);
      case SalahSurahProgress.practiced:
        controller.markPracticed(itemId);
      case SalahSurahProgress.memorized:
        controller.markMemorized(itemId);
    }
  }

  void setGuidedSurahMode(GuidedSurahMode mode) {
    state = state.copyWith(guidedSurahMode: mode);
    _persist();
  }

  void setFixedSurah(String? surahId) {
    state = state.copyWith(
      fixedSurahId: surahId,
      clearFixedSurah: surahId == null,
    );
    _persist();
  }

  void setPracticeSurah(String? surahId) {
    state = state.copyWith(
      practiceSurahId: surahId,
      clearPracticeSurah: surahId == null,
    );
    _persist();
  }

  String chooseGuidedSurahId({required SalahPrayerId prayerId, int? seed}) {
    final unlocked = _unlockedSurahIds();
    if (unlocked.isEmpty) {
      return initialUnlockedSurahIds.first;
    }

    if (state.guidedSurahMode == GuidedSurahMode.fixed &&
        state.fixedSurahId != null &&
        unlocked.contains(state.fixedSurahId)) {
      return state.fixedSurahId!;
    }

    if (state.guidedSurahMode == GuidedSurahMode.practiceSpecific &&
        state.practiceSurahId != null &&
        unlocked.contains(state.practiceSurahId)) {
      return state.practiceSurahId!;
    }

    final sorted = unlocked.toList(growable: false)..sort();
    final effectiveSeed = seed ?? DateTime.now().millisecondsSinceEpoch;
    return sorted[Random(
      effectiveSeed + prayerId.index,
    ).nextInt(sorted.length)];
  }

  Set<String> _unlockedSurahIds() {
    final shortSurahPool = salahSurahs
        .where((surah) => surah.id != 'al_fatihah')
        .toList(growable: false);
    final practicedCount = state.surahProgressById.values
        .where(
          (value) =>
              value == SalahSurahProgress.practiced ||
              value == SalahSurahProgress.memorized,
        )
        .length;
    final totalUnlocked = (initialUnlockedSurahIds.length + practicedCount)
        .clamp(0, shortSurahPool.length);
    return shortSurahPool.take(totalUnlocked).map((surah) => surah.id).toSet();
  }

  void _persist() {
    _store.setJsonMap(_storageKey, state.toJson());
  }
}

String _prayerItemId(String prayerId) => 'salah:prayer:$prayerId';

final salahTrainerProgressProvider =
    StateNotifierProvider<
      SalahTrainerProgressNotifier,
      SalahTrainerProgressState
    >((ref) {
      return SalahTrainerProgressNotifier(ref.watch(localStoreProvider), ref);
    });

class SalahTrainerGuidanceNoticeNotifier extends StateNotifier<bool> {
  SalahTrainerGuidanceNoticeNotifier(this._store)
    : super(_store.getBool(_guidanceNoticeKey) ?? false);

  final LocalStore _store;

  void acknowledge() {
    if (state) return;
    state = true;
    _store.setBool(_guidanceNoticeKey, true);
  }
}

final salahTrainerGuidanceNoticeProvider =
    StateNotifierProvider<SalahTrainerGuidanceNoticeNotifier, bool>((ref) {
      return SalahTrainerGuidanceNoticeNotifier(ref.watch(localStoreProvider));
    });

final salahTrainerPrayersProvider = Provider<List<PrayerModel>>((ref) {
  return salahPrayers;
});

final salahTrainerSurahsProvider = Provider<List<SurahModel>>((ref) {
  return salahSurahs;
});

final salahTrainerRecitationsProvider = Provider<List<RecitationModel>>((ref) {
  return salahRecitations;
});

final salahTrainerEssentialsProvider = Provider<List<SalahEssentialTopic>>((
  ref,
) {
  return salahEssentials;
});

final salahTrainerPrayerByIdProvider =
    Provider.family<PrayerModel?, SalahPrayerId>((ref, prayerId) {
      for (final prayer in ref.watch(salahTrainerPrayersProvider)) {
        if (prayer.id == prayerId) return prayer;
      }
      return null;
    });

final salahTrainerSurahByIdProvider = Provider.family<SurahModel?, String>((
  ref,
  surahId,
) {
  for (final surah in ref.watch(salahTrainerSurahsProvider)) {
    if (surah.id == surahId) return surah;
  }
  return null;
});

final salahUnlockedSurahIdsProvider = Provider<Set<String>>((ref) {
  final state = ref.watch(salahTrainerProgressProvider);
  final shortSurahPool = salahSurahs
      .where((surah) => surah.id != 'al_fatihah')
      .toList(growable: false);
  final practicedCount = state.surahProgressById.values
      .where(
        (value) =>
            value == SalahSurahProgress.practiced ||
            value == SalahSurahProgress.memorized,
      )
      .length;
  final totalUnlocked = (initialUnlockedSurahIds.length + practicedCount).clamp(
    0,
    shortSurahPool.length,
  );
  return shortSurahPool.take(totalUnlocked).map((surah) => surah.id).toSet();
});

final salahMemorizedSurahCountProvider = Provider<int>((ref) {
  return ref
      .watch(salahTrainerProgressProvider)
      .surahProgressById
      .values
      .where((value) => value == SalahSurahProgress.memorized)
      .length;
});

final salahRecentPrayerModelsProvider = Provider<List<PrayerModel>>((ref) {
  final recentIds = ref.watch(salahTrainerProgressProvider).recentPrayerIds;
  final prayers = ref.watch(salahTrainerPrayersProvider);
  final output = <PrayerModel>[];
  for (final id in recentIds) {
    for (final prayer in prayers) {
      if (prayer.id.name == id) {
        output.add(prayer);
        break;
      }
    }
  }
  return output;
});

final salahGuidedStepsProvider =
    Provider.family<
      List<GuidedPrayerStep>,
      ({SalahPrayerId prayerId, String surahId})
    >((ref, args) {
      final prayer = ref.watch(salahTrainerPrayerByIdProvider(args.prayerId));
      final surah = ref.watch(salahTrainerSurahByIdProvider(args.surahId));
      if (prayer == null) return const <GuidedPrayerStep>[];

      final steps = <GuidedPrayerStep>[];
      for (final rakah in prayer.guidedRakahs) {
        for (final step in rakah.steps) {
          steps.add(
            GuidedPrayerStep(
              prayerId: prayer.id,
              rakahNumber: rakah.index,
              step: step,
            ),
          );
          if (step.isDynamicSurah && surah != null) {
            for (final verse in surah.verses) {
              steps.add(
                GuidedPrayerStep(
                  prayerId: prayer.id,
                  rakahNumber: rakah.index,
                  surahId: surah.id,
                  step: PrayerStepModel(
                    id: '${surah.id}_${verse.ayahNumber}',
                    title: '${surah.name} - Ayah ${verse.ayahNumber}',
                    kind: SalahRecitationKind.additionalSurah,
                    posture: PrayerPostureType.qiyam,
                    arabicText: verse.arabicText,
                    transliteration: verse.transliteration,
                    translation: verse.translation,
                    pauseAfterMs: 1600,
                    audioAssetPath: verse.audio.localAudioAssetPath,
                    ttsText: verse.arabicText,
                  ),
                ),
              );
            }
          }
        }
      }
      return steps;
    });
