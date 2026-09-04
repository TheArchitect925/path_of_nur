import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/locale_provider.dart';
import '../../../../core/prayer/prayer_preferences.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/persistence/local_store.dart';
import '../../shared/application/learn_system_engine_provider.dart';
import '../data/salah_trainer_data.dart';
import '../models/salah_trainer_models.dart';

const _storageKey = 'learn.salah.trainer.progress.v1';
const _guidanceNoticeKey = 'learn.salah.trainer.guidanceNoticeAccepted.v1';

/// The short surahs a learner may be given in guided prayer: the starter
/// three, plus the next surah in the pool for every surah practiced or
/// memorized.
Set<String> salahUnlockedSurahIdsFor(SalahTrainerProgressState state) {
  final practicedCount = state.surahProgressById.values
      .where(
        (value) =>
            value == SalahSurahProgress.practiced ||
            value == SalahSurahProgress.memorized,
      )
      .length;
  final unlocked = <String>{
    for (final id in initialUnlockedSurahIds)
      if (salahShortSurahIds.contains(id)) id,
  };
  final target = (unlocked.length + practicedCount).clamp(
    0,
    salahShortSurahIds.length,
  );
  for (final id in salahShortSurahIds) {
    if (unlocked.length >= target) break;
    unlocked.add(id);
  }
  return unlocked;
}

class SalahTrainerProgressNotifier
    extends StateNotifier<SalahTrainerProgressState> {
  SalahTrainerProgressNotifier(
    this._store,
    this._ref, {
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now,
       super(
         SalahTrainerProgressState.fromJson(_store.getJsonMap(_storageKey)),
       );

  final LocalStore _store;
  final Ref _ref;
  final DateTime Function() _now;

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
    final sessions = Map<String, SalahGuidedSession>.from(
      state.sessionsByPrayerId,
    )..remove(id);
    state = state.copyWith(
      completedPrayerIds: completed,
      sessionsByPrayerId: sessions,
    );
    _persist();
    final progress = _ref.read(learnUnifiedProgressProvider.notifier);
    progress.markCompleted(_prayerItemId(id));
    progress.markPracticed(_prayerItemId(id));
  }

  /// Remembers where the learner is in a guided prayer. The first step is
  /// nothing to resume, so it clears any earlier session instead.
  void saveGuidedSession({
    required SalahPrayerId prayerId,
    required String surahId,
    required int stepIndex,
    required int totalSteps,
  }) {
    final sessions = Map<String, SalahGuidedSession>.from(
      state.sessionsByPrayerId,
    );
    if (stepIndex <= 0 || stepIndex >= totalSteps) {
      sessions.remove(prayerId.name);
    } else {
      sessions[prayerId.name] = SalahGuidedSession(
        prayerId: prayerId,
        surahId: surahId,
        stepIndex: stepIndex,
        totalSteps: totalSteps,
        updatedAt: _now(),
      );
    }
    state = state.copyWith(sessionsByPrayerId: sessions);
    _persist();
  }

  void clearGuidedSession(SalahPrayerId prayerId) {
    if (!state.sessionsByPrayerId.containsKey(prayerId.name)) return;
    final sessions = Map<String, SalahGuidedSession>.from(
      state.sessionsByPrayerId,
    )..remove(prayerId.name);
    state = state.copyWith(sessionsByPrayerId: sessions);
    _persist();
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

  /// The surah for a guided prayer: the saved session's surah when resuming,
  /// otherwise the learner's fixed or practice choice, otherwise a random
  /// unlocked one.
  String chooseGuidedSurahId({
    required SalahPrayerId prayerId,
    int? seed,
    bool preferSession = true,
  }) {
    final unlocked = salahUnlockedSurahIdsFor(state);
    if (unlocked.isEmpty) {
      return initialUnlockedSurahIds.first;
    }

    final session = state.sessionFor(prayerId);
    if (preferSession &&
        session != null &&
        session.hasProgress &&
        unlocked.contains(session.surahId)) {
      return session.surahId;
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
    final effectiveSeed = seed ?? _now().millisecondsSinceEpoch;
    return sorted[Random(
      effectiveSeed + prayerId.index,
    ).nextInt(sorted.length)];
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

/// The trainer's content in the app language. Rebuilds when the learner
/// changes language, so every open page re-reads its copy.
final salahTrainerContentProvider = Provider<SalahTrainerContent>((ref) {
  final locale = ref.watch(appLocaleProvider) ?? defaultAppLocale;
  AppLocalizations l10n;
  try {
    l10n = lookupAppLocalizations(locale);
  } catch (_) {
    l10n = lookupAppLocalizations(defaultAppLocale);
  }
  return buildSalahTrainerContent(l10n);
});

/// The school the trainer follows: the learner's madhhab from Salah
/// settings.
final salahTrainerMadhhabProvider = Provider<PrayerMadhab>((ref) {
  return ref.watch(
    prayerSettingsProvider.select((state) => state.preferences.madhab),
  );
});

/// A prayer's rakahs as the learner's school performs them.
final salahPrayerRakahsProvider =
    Provider.family<List<RakaaModel>, SalahPrayerId>((ref, prayerId) {
      final content = ref.watch(salahTrainerContentProvider);
      final prayer = content.prayerById(prayerId);
      if (prayer == null) return const <RakaaModel>[];
      return content.rakahsFor(prayer, ref.watch(salahTrainerMadhhabProvider));
    });

final salahTrainerPrayersProvider = Provider<List<PrayerModel>>((ref) {
  return ref.watch(salahTrainerContentProvider).prayers;
});

final salahTrainerSurahsProvider = Provider<List<SurahModel>>((ref) {
  return ref.watch(salahTrainerContentProvider).surahs;
});

final salahTrainerRecitationsProvider = Provider<List<RecitationModel>>((ref) {
  return ref.watch(salahTrainerContentProvider).recitations;
});

final salahTrainerEssentialsProvider = Provider<List<SalahEssentialTopic>>((
  ref,
) {
  return ref.watch(salahTrainerContentProvider).essentials;
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
  return salahUnlockedSurahIdsFor(ref.watch(salahTrainerProgressProvider));
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

/// The guided prayer flattened to one list of steps. Surah steps carry the
/// surah's ayahs as their segments: al-Fatihah always, and the chosen short
/// surah wherever the prayer calls for an additional one.
final salahGuidedStepsProvider =
    Provider.family<
      List<GuidedPrayerStep>,
      ({SalahPrayerId prayerId, String surahId})
    >((ref, args) {
      final prayer = ref.watch(salahTrainerPrayerByIdProvider(args.prayerId));
      if (prayer == null) return const <GuidedPrayerStep>[];

      final steps = <GuidedPrayerStep>[];
      for (final rakah in ref.watch(salahPrayerRakahsProvider(args.prayerId))) {
        for (final step in rakah.steps) {
          final surahId = step.isDynamicSurah ? args.surahId : step.surahId;
          final surah = surahId == null
              ? null
              : ref.watch(salahTrainerSurahByIdProvider(surahId));
          if (surah != null) {
            steps.add(
              GuidedPrayerStep(
                prayerId: prayer.id,
                rakahNumber: rakah.index,
                surahId: surah.id,
                step: step.copyWith(segments: surah.segments, isSilent: false),
              ),
            );
            continue;
          }
          if (step.isDynamicSurah) {
            // No unlocked surah resolved; the placeholder stays silent and the
            // learner recites a surah of their own.
            steps.add(
              GuidedPrayerStep(
                prayerId: prayer.id,
                rakahNumber: rakah.index,
                step: step,
              ),
            );
            continue;
          }
          steps.add(
            GuidedPrayerStep(
              prayerId: prayer.id,
              rakahNumber: rakah.index,
              step: step,
            ),
          );
        }
      }
      return steps;
    });
