import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/locale_provider.dart';
import '../../features/worship/application/dhikr_controller.dart';
import '../../features/worship/application/fasting_controller.dart';
import '../../features/worship/application/prayer_controller.dart';
import '../../features/worship/domain/fasting_status.dart';
import '../persistence/local_store.dart';
import '../state/user_profile_state.dart';

class WorshipSummary {
  const WorshipSummary({
    required this.prayerCompleted,
    required this.prayerTotal,
    required this.prayerProgress,
    required this.dhikrCount,
    required this.dhikrTarget,
    required this.dhikrProgress,
    required this.fastingStatus,
    required this.khusuQuickReady,
  });

  final int prayerCompleted;
  final int prayerTotal;
  final double prayerProgress;
  final int dhikrCount;
  final int dhikrTarget;
  final double dhikrProgress;
  final FastingStatus fastingStatus;
  final bool khusuQuickReady;
}

class JourneySummary {
  const JourneySummary({
    required this.level,
    required this.xp,
    required this.nextLevelXpRemaining,
    required this.currentStreakDays,
    required this.bestStreakDays,
    required this.ringPrayer,
    required this.ringDhikr,
    required this.ringQuran,
    required this.ringReflection,
    required this.ringFasting,
    required this.nextUnlockPreviewKey,
    required this.weeklyConsistencyBars,
  });

  final int level;
  final int xp;
  final int nextLevelXpRemaining;
  final int currentStreakDays;
  final int bestStreakDays;
  final double ringPrayer;
  final double ringDhikr;
  final double ringQuran;
  final double ringReflection;
  final double ringFasting;
  final String nextUnlockPreviewKey;
  final List<double> weeklyConsistencyBars;

  double get xpProgress =>
      (xp / (xp + nextLevelXpRemaining)).clamp(0, 1).toDouble();
}

class JourneyProgressState {
  const JourneyProgressState({
    required this.level,
    required this.xp,
    required this.nextLevelXpRemaining,
    required this.currentStreakDays,
    required this.bestStreakDays,
    required this.nextUnlockPreviewKey,
  });

  final int level;
  final int xp;
  final int nextLevelXpRemaining;
  final int currentStreakDays;
  final int bestStreakDays;
  final String nextUnlockPreviewKey;

  JourneyProgressState copyWith({
    int? level,
    int? xp,
    int? nextLevelXpRemaining,
    int? currentStreakDays,
    int? bestStreakDays,
    String? nextUnlockPreviewKey,
  }) {
    return JourneyProgressState(
      level: level ?? this.level,
      xp: xp ?? this.xp,
      nextLevelXpRemaining: nextLevelXpRemaining ?? this.nextLevelXpRemaining,
      currentStreakDays: currentStreakDays ?? this.currentStreakDays,
      bestStreakDays: bestStreakDays ?? this.bestStreakDays,
      nextUnlockPreviewKey: nextUnlockPreviewKey ?? this.nextUnlockPreviewKey,
    );
  }
}

class JourneyProgressNotifier extends StateNotifier<JourneyProgressState> {
  JourneyProgressNotifier(this._store)
      : super(
          const JourneyProgressState(
            level: 7,
            xp: 1620,
            nextLevelXpRemaining: 380,
            currentStreakDays: 6,
            bestStreakDays: 18,
            nextUnlockPreviewKey: 'wallpaper',
          ),
        ) {
    _load();
  }

  final LocalStore _store;

  void setProgress({
    int? level,
    int? xp,
    int? nextLevelXpRemaining,
    int? currentStreakDays,
    int? bestStreakDays,
    String? nextUnlockPreviewKey,
  }) {
    state = state.copyWith(
      level: level,
      xp: xp,
      nextLevelXpRemaining: nextLevelXpRemaining,
      currentStreakDays: currentStreakDays,
      bestStreakDays: bestStreakDays,
      nextUnlockPreviewKey: nextUnlockPreviewKey,
    );
    _save();
  }

  void _load() {
    final data = _store.getJsonMap('journey.progress');
    if (data == null) return;
    state = state.copyWith(
      level: data['level'] as int?,
      xp: data['xp'] as int?,
      nextLevelXpRemaining: data['nextLevelXpRemaining'] as int?,
      currentStreakDays: data['currentStreakDays'] as int?,
      bestStreakDays: data['bestStreakDays'] as int?,
      nextUnlockPreviewKey: data['nextUnlockPreviewKey'] as String?,
    );
  }

  void _save() {
    _store.setJsonMap('journey.progress', {
      'level': state.level,
      'xp': state.xp,
      'nextLevelXpRemaining': state.nextLevelXpRemaining,
      'currentStreakDays': state.currentStreakDays,
      'bestStreakDays': state.bestStreakDays,
      'nextUnlockPreviewKey': state.nextUnlockPreviewKey,
    });
  }
}

enum LearnLifeTopic {
  marriage,
  parents,
  children,
  wealth,
  patience,
  justice,
  character,
  gratitude,
}

enum LearnWorldTopic {
  moon,
  bees,
  mountains,
  rain,
  oceans,
  animals,
  plants,
  nightAndDay,
}

enum LearnHadithTopic {
  lifeLessons,
  worldLessons,
  characterAndManners,
  worshipAndIntention,
  familyAndSociety,
}

class LearnSummary {
  const LearnSummary({
    required this.continueSurahName,
    required this.continueAyah,
    required this.featuredLifeTopic,
    required this.featuredWorldTopic,
    required this.featuredHadithTopic,
    required this.resumeNoteTitle,
  });

  final String continueSurahName;
  final int continueAyah;
  final LearnLifeTopic featuredLifeTopic;
  final LearnWorldTopic featuredWorldTopic;
  final LearnHadithTopic featuredHadithTopic;
  final String resumeNoteTitle;
}

class ProfileSummary {
  const ProfileSummary({
    required this.name,
    required this.sex,
    required this.selectedLocale,
    required this.level,
    required this.currentStreakDays,
  });

  final String name;
  final UserSex sex;
  final Locale selectedLocale;
  final int level;
  final int currentStreakDays;
}

class HomeDashboardSummary {
  const HomeDashboardSummary({
    required this.worship,
    required this.journey,
    required this.learn,
  });

  final WorshipSummary worship;
  final JourneySummary journey;
  final LearnSummary learn;
}

final worshipSummaryProvider = Provider<WorshipSummary>((ref) {
  final prayerSummary = ref.watch(prayerSummaryProvider);
  final dhikr = ref.watch(dhikrControllerProvider);
  final fasting = ref.watch(fastingControllerProvider);

  final dhikrProgress = dhikr.target <= 0
      ? 0.0
      : (dhikr.currentCount / dhikr.target).clamp(0.0, 1.0).toDouble();

  return WorshipSummary(
    prayerCompleted: prayerSummary.completed,
    prayerTotal: prayerSummary.total,
    prayerProgress: prayerSummary.progress,
    dhikrCount: dhikr.currentCount,
    dhikrTarget: dhikr.target,
    dhikrProgress: dhikrProgress,
    fastingStatus: fasting.todayStatus,
    khusuQuickReady: true,
  );
});

final journeyProgressProvider =
    StateNotifierProvider<JourneyProgressNotifier, JourneyProgressState>((ref) {
  return JourneyProgressNotifier(ref.watch(localStoreProvider));
});

final journeySummaryProvider = Provider<JourneySummary>((ref) {
  final worship = ref.watch(worshipSummaryProvider);
  final progress = ref.watch(journeyProgressProvider);

  return JourneySummary(
    level: progress.level,
    xp: progress.xp,
    nextLevelXpRemaining: progress.nextLevelXpRemaining,
    currentStreakDays: progress.currentStreakDays,
    bestStreakDays: progress.bestStreakDays,
    ringPrayer: worship.prayerProgress,
    ringDhikr: worship.dhikrProgress,
    ringQuran: 0.35,
    ringReflection: 0.28,
    ringFasting: worship.fastingStatus == FastingStatus.completed
        ? 1
        : worship.fastingStatus == FastingStatus.intending
            ? 0.55
            : worship.fastingStatus == FastingStatus.notFasting
                ? 0.12
                : 0.2,
    nextUnlockPreviewKey: progress.nextUnlockPreviewKey,
    weeklyConsistencyBars: const [0.55, 0.72, 0.48, 0.9, 0.67, 0.4, 0.78],
  );
});

final learnSummaryProvider = Provider<LearnSummary>((ref) {
  return const LearnSummary(
    continueSurahName: 'Al-Baqarah',
    continueAyah: 152,
    featuredLifeTopic: LearnLifeTopic.patience,
    featuredWorldTopic: LearnWorldTopic.mountains,
    featuredHadithTopic: LearnHadithTopic.characterAndManners,
    resumeNoteTitle: 'Reflection Draft',
  );
});

final profileSummaryProvider = Provider<ProfileSummary>((ref) {
  final user = ref.watch(userProfileProvider);
  final locale = ref.watch(appLocaleProvider) ?? const Locale('en');
  final journey = ref.watch(journeySummaryProvider);

  return ProfileSummary(
    name: user.name,
    sex: user.sex,
    selectedLocale: locale,
    level: journey.level,
    currentStreakDays: journey.currentStreakDays,
  );
});

final homeDashboardSummaryProvider = Provider<HomeDashboardSummary>((ref) {
  return HomeDashboardSummary(
    worship: ref.watch(worshipSummaryProvider),
    journey: ref.watch(journeySummaryProvider),
    learn: ref.watch(learnSummaryProvider),
  );
});
