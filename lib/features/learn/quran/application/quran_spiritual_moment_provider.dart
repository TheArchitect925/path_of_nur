import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/prayer/prayer_preferences.dart';
import '../../../../shared/application/daily_clock_provider.dart';
import '../../../../shared/application/special_mode_provider.dart';
import '../../../../shared/persistence/local_store.dart';
import '../../../../shared/utils/hijri_date_utils.dart';
import '../../../worship/data/prayer_log_repository.dart';
import '../../../worship/domain/prayer_name.dart';
import '../domain/quran_ayah_action_models.dart';
import '../domain/quran_ayah_explanation_models.dart';
import '../domain/quran_content_refs.dart';
import '../domain/quran_reference_models.dart';
import '../domain/quran_spiritual_moment_models.dart';
import 'quran_ayah_action_provider.dart';
import 'quran_ayah_explanation_provider.dart';
import 'quran_personalization_provider.dart';

const _quranSpiritualMomentStateKey = 'learn.quran.spiritual_moments.v1';

class QuranSpiritualMomentState {
  const QuranSpiritualMomentState({
    required this.dismissedAyahKeysByDateKey,
    required this.recentPrimaryAyahKeys,
    required this.lastPresentedBundleKeyBySurface,
  });

  static const initial = QuranSpiritualMomentState(
    dismissedAyahKeysByDateKey: <String, Set<String>>{},
    recentPrimaryAyahKeys: <String>[],
    lastPresentedBundleKeyBySurface: <String, String>{},
  );

  final Map<String, Set<String>> dismissedAyahKeysByDateKey;
  final List<String> recentPrimaryAyahKeys;
  final Map<String, String> lastPresentedBundleKeyBySurface;

  QuranSpiritualMomentState copyWith({
    Map<String, Set<String>>? dismissedAyahKeysByDateKey,
    List<String>? recentPrimaryAyahKeys,
    Map<String, String>? lastPresentedBundleKeyBySurface,
  }) {
    return QuranSpiritualMomentState(
      dismissedAyahKeysByDateKey:
          dismissedAyahKeysByDateKey ?? this.dismissedAyahKeysByDateKey,
      recentPrimaryAyahKeys:
          recentPrimaryAyahKeys ?? this.recentPrimaryAyahKeys,
      lastPresentedBundleKeyBySurface:
          lastPresentedBundleKeyBySurface ??
          this.lastPresentedBundleKeyBySurface,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'dismissedAyahKeysByDateKey': <String, List<String>>{
      for (final entry in dismissedAyahKeysByDateKey.entries)
        entry.key: entry.value.toList(growable: false),
    },
    'recentPrimaryAyahKeys': recentPrimaryAyahKeys,
    'lastPresentedBundleKeyBySurface': lastPresentedBundleKeyBySurface,
  };

  static QuranSpiritualMomentState fromJson(Map<String, dynamic>? json) {
    if (json == null) return initial;
    final dismissed = <String, Set<String>>{};
    final rawDismissed = json['dismissedAyahKeysByDateKey'];
    if (rawDismissed is Map) {
      for (final entry in rawDismissed.entries) {
        final dateKey = entry.key.toString().trim();
        if (dateKey.isEmpty) continue;
        final values = entry.value is List
            ? entry.value as List
            : const <dynamic>[];
        final ayahKeys = values
            .map((item) => item.toString().trim())
            .where((item) => item.isNotEmpty)
            .toSet();
        if (ayahKeys.isNotEmpty) {
          dismissed[dateKey] = ayahKeys;
        }
      }
    }
    final recentPrimary = (json['recentPrimaryAyahKeys'] as List? ?? const [])
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
    final lastPresented = <String, String>{};
    final rawPresented = json['lastPresentedBundleKeyBySurface'];
    if (rawPresented is Map) {
      for (final entry in rawPresented.entries) {
        final key = entry.key.toString().trim();
        final value = entry.value.toString().trim();
        if (key.isEmpty || value.isEmpty) continue;
        lastPresented[key] = value;
      }
    }
    return QuranSpiritualMomentState(
      dismissedAyahKeysByDateKey: dismissed,
      recentPrimaryAyahKeys: recentPrimary,
      lastPresentedBundleKeyBySurface: lastPresented,
    );
  }
}

class QuranSpiritualMomentController
    extends StateNotifier<QuranSpiritualMomentState> {
  QuranSpiritualMomentController(this._store)
    : super(
        QuranSpiritualMomentState.fromJson(
          _store.getJsonMap(_quranSpiritualMomentStateKey),
        ),
      );

  final LocalStore _store;

  void _persist() {
    _store.setJsonMap(_quranSpiritualMomentStateKey, state.toJson());
  }

  void dismissForToday({
    required QuranSpiritualMomentSurface surface,
    required String ayahKey,
    DateTime? now,
  }) {
    final dateKey = LocalStore.todayKey(now ?? DateTime.now());
    final nextDismissed = <String, Set<String>>{
      for (final entry in state.dismissedAyahKeysByDateKey.entries)
        entry.key: Set<String>.from(entry.value),
    };
    nextDismissed
        .putIfAbsent(dateKey, () => <String>{})
        .add('${surface.name}:$ayahKey');
    state = state.copyWith(dismissedAyahKeysByDateKey: nextDismissed);
    _persist();
  }

  void recordPresentationIfNeeded({
    required QuranSpiritualMomentSurface surface,
    required String ayahKey,
    DateTime? now,
  }) {
    final dateKey = LocalStore.todayKey(now ?? DateTime.now());
    final surfaceKey = surface.name;
    final bundleKey = '$dateKey:$ayahKey';
    if (state.lastPresentedBundleKeyBySurface[surfaceKey] == bundleKey) {
      return;
    }

    final nextPresented = <String, String>{
      ...state.lastPresentedBundleKeyBySurface,
      surfaceKey: bundleKey,
    };
    final nextRecent = <String>[ayahKey];
    for (final existing in state.recentPrimaryAyahKeys) {
      if (existing == ayahKey) continue;
      nextRecent.add(existing);
      if (nextRecent.length >= 12) break;
    }
    state = state.copyWith(
      recentPrimaryAyahKeys: nextRecent,
      lastPresentedBundleKeyBySurface: nextPresented,
    );
    _persist();
  }
}

final quranSpiritualMomentStateProvider =
    StateNotifierProvider<
      QuranSpiritualMomentController,
      QuranSpiritualMomentState
    >((ref) {
      return QuranSpiritualMomentController(ref.watch(localStoreProvider));
    });

final quranSpiritualMomentContextProvider =
    Provider.family<
      QuranSpiritualMomentContext,
      (QuranSpiritualMomentSurface surface, bool preferKids)
    >((ref, input) {
      final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
      final dateKey = LocalStore.todayKey(now);
      final scheduleContext = ref.watch(prayerScheduleContextProvider);
      final specialMode = ref.watch(specialModeProvider);
      final personalizationProfile = ref.watch(
        quranPersonalizationProfileProvider(input.$2),
      );
      final spiritualState = ref.watch(quranSpiritualMomentStateProvider);
      final prayerEntries = ref
          .watch(prayerLogRepositoryProvider)
          .readDayEntries(dateKey);
      final recentCompletedPrayer = _recentCompletedPrayer(prayerEntries, now);
      final isFriday = now.weekday == DateTime.friday;
      final hijriMonth = toHijriDate(now).month;
      final isRamadan =
          specialMode.isRamadan ||
          specialMode.ramadanDateWindowActive ||
          hijriMonth == 9;
      final currentPrayer = _prayerNameFromId(scheduleContext.currentPrayerId);
      final nextPrayer = _prayerNameFromId(scheduleContext.nextPrayerId);
      final momentType = _selectMomentType(
        now: now,
        preferKids: input.$2,
        recentCompletedPrayer: recentCompletedPrayer,
        currentPrayer: currentPrayer,
        nextPrayer: nextPrayer,
        isFriday: isFriday,
        isRamadan: isRamadan,
      );

      return QuranSpiritualMomentContext(
        now: now,
        dateKey: dateKey,
        surface: input.$1,
        preferKids: input.$2,
        momentType: momentType,
        reasonCode: _reasonCodeForMoment(momentType),
        timeSegment: personalizationProfile.timeSegment,
        isFriday: isFriday,
        isRamadan: isRamadan,
        currentPrayer: currentPrayer,
        nextPrayer: nextPrayer,
        recentCompletedPrayer: recentCompletedPrayer,
        cooldownAyahKeys: spiritualState.recentPrimaryAyahKeys,
        dismissedAyahKeysToday:
            spiritualState.dismissedAyahKeysByDateKey[dateKey] ??
            const <String>{},
      );
    });

final quranSpiritualMomentBundleProvider =
    Provider.family<
      QuranSpiritualMomentBundle?,
      (
        QuranSpiritualMomentSurface surface,
        bool preferKids,
        String languageCode,
      )
    >((ref, input) {
      final context = ref.watch(
        quranSpiritualMomentContextProvider((input.$1, input.$2)),
      );
      final spiritualState = ref.watch(quranSpiritualMomentStateProvider);
      final pinnedAyahKey = _pinnedAyahKeyForSurface(
        spiritualState: spiritualState,
        surface: input.$1,
        dateKey: context.dateKey,
      );
      if (pinnedAyahKey != null &&
          !context.dismissedAyahKeysToday.contains(
            '${input.$1.name}:$pinnedAyahKey',
          )) {
        final pinnedRef = _parseAyahKey(pinnedAyahKey);
        if (pinnedRef != null) {
          final pinnedEntry = ref.watch(
            quranAyahExplanationEntryProvider((pinnedRef.$1, pinnedRef.$2)),
          );
          if (pinnedEntry != null) {
            final pinnedRecommendation = _scoreEntryForMoment(
              entry: pinnedEntry,
              ref: ref,
              context: context,
              languageCode: input.$3,
            );
            if (pinnedRecommendation != null) {
              return QuranSpiritualMomentBundle(
                surface: input.$1,
                preferKids: input.$2,
                generatedDateKey: context.dateKey,
                context: context,
                primary: pinnedRecommendation,
              );
            }
          }
        }
      }
      final recommendation = _selectMomentRecommendation(
        ref: ref,
        context: context,
        languageCode: input.$3,
      );
      if (recommendation == null) return null;
      return QuranSpiritualMomentBundle(
        surface: input.$1,
        preferKids: input.$2,
        generatedDateKey: context.dateKey,
        context: context,
        primary: recommendation,
      );
    });

final quranReaderSpiritualMomentProvider =
    Provider.family<
      QuranSpiritualMomentBundle?,
      (int surah, int ayah, bool preferKids, String languageCode)
    >((ref, input) {
      final context = ref.watch(
        quranSpiritualMomentContextProvider((
          input.$3
              ? QuranSpiritualMomentSurface.kidsReader
              : QuranSpiritualMomentSurface.reader,
          input.$3,
        )),
      );
      final entry = ref.watch(
        quranAyahExplanationEntryProvider((input.$1, input.$2)),
      );
      if (entry == null) return null;
      final recommendation = _scoreEntryForMoment(
        entry: entry,
        ref: ref,
        context: context,
        languageCode: input.$4,
        requireStrongMatch: true,
      );
      if (recommendation == null) return null;
      return QuranSpiritualMomentBundle(
        surface: context.surface,
        preferKids: context.preferKids,
        generatedDateKey: context.dateKey,
        context: context,
        primary: recommendation,
      );
    });

QuranSpiritualMomentRecommendation? _selectMomentRecommendation({
  required Ref ref,
  required QuranSpiritualMomentContext context,
  required String languageCode,
}) {
  final entries = ref.watch(quranAyahExplanationRepositoryProvider).getAll();
  QuranSpiritualMomentRecommendation? best;
  for (final entry in entries) {
    final recommendation = _scoreEntryForMoment(
      entry: entry,
      ref: ref,
      context: context,
      languageCode: languageCode,
    );
    if (recommendation == null) {
      continue;
    }
    if (best == null || recommendation.priority > best.priority) {
      best = recommendation;
    }
  }
  return best;
}

QuranSpiritualMomentRecommendation? _scoreEntryForMoment({
  required QuranAyahExplanationEntry entry,
  required Ref ref,
  required QuranSpiritualMomentContext context,
  required String languageCode,
  bool requireStrongMatch = false,
}) {
  final surfaceAyahKey = '${context.surface.name}:${entry.ayahKey}';
  if (context.dismissedAyahKeysToday.contains(surfaceAyahKey)) {
    return null;
  }

  final detailLevel = _detailLevelForMoment(
    momentType: context.momentType,
    preferKids: context.preferKids,
  );
  final explanation = entry.resolve(detailLevel, languageCode: languageCode);
  if (explanation == null) {
    return null;
  }

  final action = ref
      .watch(quranAyahActionRepositoryProvider)
      .actionForEntry(
        entry,
        languageCode: languageCode,
        preferKids: context.preferKids,
      );
  if (action == null) {
    return null;
  }

  final actionState = ref.watch(quranAyahActionStateProvider);
  final isCompletedToday = actionState.isCompletedForDay(
    dateKey: context.dateKey,
    ayahKey: action.ayahKey,
  );
  final actionRecommendation = QuranAyahActionRecommendation(
    action: action,
    explanationPreview: explanation.previewText,
    explanationBody: explanation.body,
    isCompletedToday: isCompletedToday,
    score: 0,
    isDailyAnchor: false,
    isRecentReading: false,
    isFoundational:
        entry.rolloutPack == QuranAyahExplanationRolloutPack.foundations ||
        entry.rolloutPack == QuranAyahExplanationRolloutPack.commonSalahSurahs,
  );

  final debugSignals = <QuranSpiritualMomentDebugSignal>[];
  final matchedTags = <String>{};
  var score = 8;

  final categoryBonus = _categoryBonus(
    action.category,
    momentType: context.momentType,
  );
  if (categoryBonus > 0) {
    score += categoryBonus;
    debugSignals.add(
      QuranSpiritualMomentDebugSignal(
        label: 'category',
        score: categoryBonus,
        detail: action.category.name,
      ),
    );
  }

  final tagBonus = _tagBonus(
    tags: action.tags,
    momentType: context.momentType,
    matchedTags: matchedTags,
  );
  if (tagBonus > 0) {
    score += tagBonus;
    debugSignals.add(
      QuranSpiritualMomentDebugSignal(
        label: 'tags',
        score: tagBonus,
        detail: matchedTags.join(','),
      ),
    );
  }

  if (entry.ayahKey ==
      ref
          .watch(quranPersonalizationProfileProvider(context.preferKids))
          .dailyAyahKey) {
    score += 16;
    debugSignals.add(
      const QuranSpiritualMomentDebugSignal(label: 'daily_anchor', score: 16),
    );
  }

  final profile = ref.watch(
    quranPersonalizationProfileProvider(context.preferKids),
  );
  if (profile.recentAyahKeys.contains(entry.ayahKey)) {
    score += 12;
    debugSignals.add(
      const QuranSpiritualMomentDebugSignal(label: 'recent_reading', score: 12),
    );
  }

  if (profile.bookmarkedAyahKeys.contains(entry.ayahKey)) {
    score += 8;
    debugSignals.add(
      const QuranSpiritualMomentDebugSignal(label: 'bookmark', score: 8),
    );
  }

  if (profile.reflectionAyahKeys.contains(entry.ayahKey)) {
    score += 7;
    debugSignals.add(
      const QuranSpiritualMomentDebugSignal(
        label: 'reflection_history',
        score: 7,
      ),
    );
  }

  if (context.preferKids && entry.hasKidsExplanation) {
    score += 8;
    debugSignals.add(
      const QuranSpiritualMomentDebugSignal(label: 'kids_safe', score: 8),
    );
  }

  if (context.isFriday &&
      context.momentType == QuranSpiritualMomentType.friday) {
    score += 10;
    debugSignals.add(
      const QuranSpiritualMomentDebugSignal(label: 'friday_window', score: 10),
    );
  }

  if (context.isRamadan &&
      context.momentType == QuranSpiritualMomentType.ramadan) {
    score += 10;
    debugSignals.add(
      const QuranSpiritualMomentDebugSignal(label: 'ramadan_window', score: 10),
    );
  }

  var usedCooldownException = false;
  if (context.cooldownAyahKeys.contains(entry.ayahKey)) {
    final continuityException =
        entry.ayahKey == profile.dailyAyahKey ||
        profile.recentAyahKeys.contains(entry.ayahKey) ||
        context.momentType == QuranSpiritualMomentType.postPrayer;
    if (continuityException) {
      usedCooldownException = true;
      debugSignals.add(
        const QuranSpiritualMomentDebugSignal(
          label: 'cooldown_exception',
          score: 4,
        ),
      );
      score += 4;
    } else {
      score -= 14;
      debugSignals.add(
        const QuranSpiritualMomentDebugSignal(label: 'cooldown', score: -14),
      );
    }
  }

  if (isCompletedToday) {
    score -= 6;
    debugSignals.add(
      const QuranSpiritualMomentDebugSignal(
        label: 'already_completed_today',
        score: -6,
      ),
    );
  }

  if (requireStrongMatch && categoryBonus + tagBonus < 18) {
    return null;
  }
  if (score < (requireStrongMatch ? 22 : 18)) {
    return null;
  }

  final window = _windowForMoment(context.now, context.momentType);
  return QuranSpiritualMomentRecommendation(
    ref: QuranQuoteRef(surah: entry.surahNumber, ayah: entry.ayahNumber),
    explanation: explanation,
    actionRecommendation: actionRecommendation,
    recommendedDetailLevel: detailLevel,
    priority: score,
    matchedTags: matchedTags.toList(growable: false),
    reasonCode: context.reasonCode,
    debugSignals: debugSignals,
    validFrom: window.$1,
    validUntil: window.$2,
    kidsSafe: context.preferKids,
    usedCooldownException: usedCooldownException,
    reminderHookId: _reminderHookIdForMoment(context.momentType),
  );
}

QuranSpiritualMomentType _selectMomentType({
  required DateTime now,
  required bool preferKids,
  required PrayerName? recentCompletedPrayer,
  required PrayerName? currentPrayer,
  required PrayerName? nextPrayer,
  required bool isFriday,
  required bool isRamadan,
}) {
  if (preferKids) {
    return QuranSpiritualMomentType.kidsDailyMoment;
  }
  if (recentCompletedPrayer != null) {
    return QuranSpiritualMomentType.postPrayer;
  }
  if (isRamadan && (now.hour >= 16 || now.hour <= 5)) {
    return QuranSpiritualMomentType.ramadan;
  }
  if (isFriday && now.hour >= 6 && now.hour < 18) {
    return QuranSpiritualMomentType.friday;
  }
  if (now.hour <= 4) {
    return QuranSpiritualMomentType.tahajjudOrNight;
  }
  if (currentPrayer == PrayerName.fajr || nextPrayer == PrayerName.fajr) {
    return QuranSpiritualMomentType.fajr;
  }
  if (now.hour < 10) {
    return QuranSpiritualMomentType.sunriseReflection;
  }
  if (currentPrayer == PrayerName.dhuhr || nextPrayer == PrayerName.dhuhr) {
    return QuranSpiritualMomentType.dhuhrPause;
  }
  if (currentPrayer == PrayerName.asr || nextPrayer == PrayerName.asr) {
    return QuranSpiritualMomentType.asrReset;
  }
  if (currentPrayer == PrayerName.maghrib || nextPrayer == PrayerName.maghrib) {
    return QuranSpiritualMomentType.maghribGratitude;
  }
  if (currentPrayer == PrayerName.isha || nextPrayer == PrayerName.isha) {
    return QuranSpiritualMomentType.ishaWindDown;
  }
  if (now.hour >= 22) {
    return QuranSpiritualMomentType.sleepReflection;
  }
  return switch (now.hour) {
    >= 5 && < 8 => QuranSpiritualMomentType.fajr,
    >= 8 && < 11 => QuranSpiritualMomentType.sunriseReflection,
    >= 11 && < 15 => QuranSpiritualMomentType.dhuhrPause,
    >= 15 && < 18 => QuranSpiritualMomentType.asrReset,
    >= 18 && < 20 => QuranSpiritualMomentType.maghribGratitude,
    >= 20 && < 22 => QuranSpiritualMomentType.ishaWindDown,
    _ => QuranSpiritualMomentType.sleepReflection,
  };
}

PrayerName? _recentCompletedPrayer(
  Map<PrayerName, PrayerLogDayEntry> entries,
  DateTime now,
) {
  PrayerName? latestPrayer;
  DateTime? latestTime;
  for (final entry in entries.entries) {
    final completedAt = DateTime.tryParse(entry.value.completedAtIso ?? '');
    if (completedAt == null) continue;
    final minutesAgo = now.difference(completedAt).inMinutes;
    if (minutesAgo < 0 || minutesAgo > 45) continue;
    if (latestTime == null || completedAt.isAfter(latestTime)) {
      latestTime = completedAt;
      latestPrayer = entry.key;
    }
  }
  return latestPrayer;
}

PrayerName? _prayerNameFromId(String? id) {
  return switch (id) {
    'fajr' => PrayerName.fajr,
    'dhuhr' => PrayerName.dhuhr,
    'asr' => PrayerName.asr,
    'maghrib' => PrayerName.maghrib,
    'isha' => PrayerName.isha,
    _ => null,
  };
}

String? _pinnedAyahKeyForSurface({
  required QuranSpiritualMomentState spiritualState,
  required QuranSpiritualMomentSurface surface,
  required String dateKey,
}) {
  final bundleKey =
      spiritualState.lastPresentedBundleKeyBySurface[surface.name];
  if (bundleKey == null || bundleKey.isEmpty) {
    return null;
  }
  final separatorIndex = bundleKey.indexOf(':');
  if (separatorIndex <= 0 || separatorIndex >= bundleKey.length - 1) {
    return null;
  }
  final storedDateKey = bundleKey.substring(0, separatorIndex).trim();
  final ayahKey = bundleKey.substring(separatorIndex + 1).trim();
  if (storedDateKey != dateKey || ayahKey.isEmpty) {
    return null;
  }
  return ayahKey;
}

(int, int)? _parseAyahKey(String raw) {
  final parts = raw.split(':');
  if (parts.length != 2) {
    return null;
  }
  final surah = int.tryParse(parts[0]);
  final ayah = int.tryParse(parts[1]);
  if (surah == null || ayah == null || surah <= 0 || ayah <= 0) {
    return null;
  }
  return (surah, ayah);
}

QuranSpiritualMomentReasonCode _reasonCodeForMoment(
  QuranSpiritualMomentType moment,
) {
  return switch (moment) {
    QuranSpiritualMomentType.fajr ||
    QuranSpiritualMomentType.sunriseReflection =>
      QuranSpiritualMomentReasonCode.morningCalm,
    QuranSpiritualMomentType.postPrayer =>
      QuranSpiritualMomentReasonCode.afterPrayer,
    QuranSpiritualMomentType.dhuhrPause =>
      QuranSpiritualMomentReasonCode.middayPause,
    QuranSpiritualMomentType.asrReset =>
      QuranSpiritualMomentReasonCode.afternoonReset,
    QuranSpiritualMomentType.maghribGratitude =>
      QuranSpiritualMomentReasonCode.sunsetGratitude,
    QuranSpiritualMomentType.ishaWindDown =>
      QuranSpiritualMomentReasonCode.eveningCalm,
    QuranSpiritualMomentType.sleepReflection ||
    QuranSpiritualMomentType.tahajjudOrNight =>
      QuranSpiritualMomentReasonCode.quietNight,
    QuranSpiritualMomentType.friday =>
      QuranSpiritualMomentReasonCode.fridayReflection,
    QuranSpiritualMomentType.ramadan =>
      QuranSpiritualMomentReasonCode.ramadanReflection,
    QuranSpiritualMomentType.kidsDailyMoment =>
      QuranSpiritualMomentReasonCode.kidsMoment,
  };
}

QuranExplanationDetailLevel _detailLevelForMoment({
  required QuranSpiritualMomentType momentType,
  required bool preferKids,
}) {
  if (preferKids) return QuranExplanationDetailLevel.kids;
  return switch (momentType) {
    QuranSpiritualMomentType.postPrayer ||
    QuranSpiritualMomentType.sleepReflection ||
    QuranSpiritualMomentType.fajr => QuranExplanationDetailLevel.simple,
    QuranSpiritualMomentType.friday ||
    QuranSpiritualMomentType.ramadan ||
    QuranSpiritualMomentType.tahajjudOrNight =>
      QuranExplanationDetailLevel.standard,
    _ => QuranExplanationDetailLevel.standard,
  };
}

int _categoryBonus(
  QuranAyahActionCategory category, {
  required QuranSpiritualMomentType momentType,
}) {
  final preferred = switch (momentType) {
    QuranSpiritualMomentType.fajr ||
    QuranSpiritualMomentType.sunriseReflection => <QuranAyahActionCategory>{
      QuranAyahActionCategory.guidance,
      QuranAyahActionCategory.worship,
      QuranAyahActionCategory.knowledge,
    },
    QuranSpiritualMomentType.dhuhrPause => <QuranAyahActionCategory>{
      QuranAyahActionCategory.prayer,
      QuranAyahActionCategory.remembrance,
      QuranAyahActionCategory.guidance,
    },
    QuranSpiritualMomentType.asrReset => <QuranAyahActionCategory>{
      QuranAyahActionCategory.patience,
      QuranAyahActionCategory.repentance,
      QuranAyahActionCategory.truthfulness,
    },
    QuranSpiritualMomentType.maghribGratitude => <QuranAyahActionCategory>{
      QuranAyahActionCategory.gratitude,
      QuranAyahActionCategory.remembrance,
      QuranAyahActionCategory.worship,
    },
    QuranSpiritualMomentType.ishaWindDown ||
    QuranSpiritualMomentType.sleepReflection ||
    QuranSpiritualMomentType.tahajjudOrNight => <QuranAyahActionCategory>{
      QuranAyahActionCategory.protection,
      QuranAyahActionCategory.trust,
      QuranAyahActionCategory.remembrance,
      QuranAyahActionCategory.repentance,
    },
    QuranSpiritualMomentType.postPrayer => <QuranAyahActionCategory>{
      QuranAyahActionCategory.prayer,
      QuranAyahActionCategory.remembrance,
      QuranAyahActionCategory.gratitude,
      QuranAyahActionCategory.guidance,
    },
    QuranSpiritualMomentType.friday => <QuranAyahActionCategory>{
      QuranAyahActionCategory.worship,
      QuranAyahActionCategory.truthfulness,
      QuranAyahActionCategory.gratitude,
      QuranAyahActionCategory.remembrance,
    },
    QuranSpiritualMomentType.ramadan => <QuranAyahActionCategory>{
      QuranAyahActionCategory.patience,
      QuranAyahActionCategory.repentance,
      QuranAyahActionCategory.gratitude,
      QuranAyahActionCategory.worship,
      QuranAyahActionCategory.kindness,
    },
    QuranSpiritualMomentType.kidsDailyMoment => <QuranAyahActionCategory>{
      QuranAyahActionCategory.kindness,
      QuranAyahActionCategory.gratitude,
      QuranAyahActionCategory.remembrance,
      QuranAyahActionCategory.worship,
    },
  };
  return preferred.contains(category) ? 22 : 0;
}

int _tagBonus({
  required List<String> tags,
  required QuranSpiritualMomentType momentType,
  required Set<String> matchedTags,
}) {
  final preferred = switch (momentType) {
    QuranSpiritualMomentType.fajr ||
    QuranSpiritualMomentType.sunriseReflection => <String>{
      'guidance',
      'dua',
      'knowledge',
      'beginning',
      'bismillah',
    },
    QuranSpiritualMomentType.dhuhrPause => <String>{
      'prayer',
      'dhikr',
      'guidance',
      'dua',
    },
    QuranSpiritualMomentType.asrReset => <String>{
      'patience',
      'ease',
      'repentance',
      'truth',
    },
    QuranSpiritualMomentType.maghribGratitude => <String>{
      'gratitude',
      'blessings',
      'worship',
      'remembrance',
    },
    QuranSpiritualMomentType.ishaWindDown ||
    QuranSpiritualMomentType.sleepReflection ||
    QuranSpiritualMomentType.tahajjudOrNight => <String>{
      'protection',
      'trust',
      'remembrance',
      'evening',
      'heart',
    },
    QuranSpiritualMomentType.postPrayer => <String>{
      'dua',
      'gratitude',
      'prayer',
      'guidance',
      'remembrance',
    },
    QuranSpiritualMomentType.friday => <String>{
      'worship',
      'truth',
      'community',
      'gratitude',
    },
    QuranSpiritualMomentType.ramadan => <String>{
      'patience',
      'repentance',
      'gratitude',
      'worship',
      'kindness',
    },
    QuranSpiritualMomentType.kidsDailyMoment => <String>{
      'kindness',
      'gratitude',
      'help',
      'good_deeds',
      'worship',
    },
  };
  var bonus = 0;
  for (final tag in tags) {
    if (preferred.contains(tag)) {
      matchedTags.add(tag);
      bonus += 6;
    }
  }
  return bonus.clamp(0, 18);
}

(DateTime, DateTime) _windowForMoment(
  DateTime now,
  QuranSpiritualMomentType moment,
) {
  final dayStart = DateTime(now.year, now.month, now.day);
  return switch (moment) {
    QuranSpiritualMomentType.fajr => (
      dayStart.add(const Duration(hours: 4)),
      dayStart.add(const Duration(hours: 8)),
    ),
    QuranSpiritualMomentType.sunriseReflection => (
      dayStart.add(const Duration(hours: 7)),
      dayStart.add(const Duration(hours: 10)),
    ),
    QuranSpiritualMomentType.dhuhrPause => (
      dayStart.add(const Duration(hours: 11)),
      dayStart.add(const Duration(hours: 15)),
    ),
    QuranSpiritualMomentType.asrReset => (
      dayStart.add(const Duration(hours: 15)),
      dayStart.add(const Duration(hours: 18)),
    ),
    QuranSpiritualMomentType.maghribGratitude => (
      dayStart.add(const Duration(hours: 18)),
      dayStart.add(const Duration(hours: 20)),
    ),
    QuranSpiritualMomentType.ishaWindDown => (
      dayStart.add(const Duration(hours: 20)),
      dayStart.add(const Duration(hours: 22)),
    ),
    QuranSpiritualMomentType.sleepReflection => (
      dayStart.add(const Duration(hours: 21)),
      dayStart.add(const Duration(hours: 24)),
    ),
    QuranSpiritualMomentType.postPrayer => (
      now.subtract(const Duration(minutes: 5)),
      now.add(const Duration(minutes: 40)),
    ),
    QuranSpiritualMomentType.friday => (
      dayStart.add(const Duration(hours: 6)),
      dayStart.add(const Duration(hours: 18)),
    ),
    QuranSpiritualMomentType.ramadan => (
      dayStart,
      dayStart.add(const Duration(hours: 24)),
    ),
    QuranSpiritualMomentType.tahajjudOrNight => (
      dayStart,
      dayStart.add(const Duration(hours: 5)),
    ),
    QuranSpiritualMomentType.kidsDailyMoment => (
      dayStart.add(const Duration(hours: 7)),
      dayStart.add(const Duration(hours: 20)),
    ),
  };
}

String _reminderHookIdForMoment(QuranSpiritualMomentType moment) {
  return switch (moment) {
    QuranSpiritualMomentType.fajr => 'morning_ayah',
    QuranSpiritualMomentType.postPrayer => 'post_prayer_ayah',
    QuranSpiritualMomentType.friday => 'friday_reflection',
    QuranSpiritualMomentType.ramadan => 'ramadan_reflection',
    QuranSpiritualMomentType.sleepReflection ||
    QuranSpiritualMomentType.ishaWindDown => 'sleep_reflection',
    _ => 'spiritual_moment',
  };
}
