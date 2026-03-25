import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/locale_provider.dart';
import '../../features/journey/application/journey_progression_provider.dart';
import '../../features/learn/quran/application/quran_providers.dart';
import '../../features/learn/content/application/learn_progress_provider.dart';
import '../../features/learn/content/data/learn_content_catalog.dart';
import '../../features/learn/content/domain/learn_topic_category.dart';
import '../../features/learn/shared/application/learn_unified_provider.dart';
import '../../features/ocean/application/ocean_drops_provider.dart';
import '../../features/wallpaper/application/wallpaper_provider.dart';
import '../../features/assistant/application/assistant_provider.dart';
import '../../features/circles/application/circles_provider.dart';
import '../../features/journal/application/journal_provider.dart';
import '../../features/worship/application/dhikr_controller.dart';
import '../../features/worship/application/fasting_controller.dart';
import '../../features/worship/application/prayer_controller.dart';
import '../../features/worship/domain/fasting_status.dart';
import '../persistence/local_store.dart';
import '../state/user_profile_state.dart';
import 'special_mode_provider.dart';

const _reflectionDraftSentinel = '__reflection_draft__';

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
    required this.unlockedMilestoneKeys,
    required this.upcomingMilestoneKeys,
    required this.unlockedRewardKeys,
    required this.upcomingRewardKeys,
    required this.growthStageKey,
    required this.localDropsContributionCount,
    required this.monthlyBadges,
    required this.dailyBadges,
    required this.graceTokensRemaining,
    required this.graceTokenMonthlyAllowance,
    required this.weeklyProtectedDays,
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
  final List<String> unlockedMilestoneKeys;
  final List<String> upcomingMilestoneKeys;
  final List<String> unlockedRewardKeys;
  final List<String> upcomingRewardKeys;
  final String growthStageKey;
  final int localDropsContributionCount;
  final List<JourneyMonthlyBadge> monthlyBadges;
  final List<JourneyDailyBadge> dailyBadges;
  final int graceTokensRemaining;
  final int graceTokenMonthlyAllowance;
  final int weeklyProtectedDays;

  double get xpProgress =>
      (xp / (xp + nextLevelXpRemaining)).clamp(0, 1).toDouble();
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
    required this.startedTopics,
    required this.completedTopics,
    required this.favoriteTopics,
    required this.resumeTopicId,
  });

  final String continueSurahName;
  final int continueAyah;
  final LearnLifeTopic featuredLifeTopic;
  final LearnWorldTopic featuredWorldTopic;
  final LearnHadithTopic featuredHadithTopic;
  final String resumeNoteTitle;
  final int startedTopics;
  final int completedTopics;
  final int favoriteTopics;
  final String? resumeTopicId;
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
    required this.mode,
    required this.ocean,
    required this.wallpaper,
    required this.assistant,
    required this.circles,
    required this.journal,
  });

  final WorshipSummary worship;
  final JourneySummary journey;
  final LearnSummary learn;
  final ModeSummary mode;
  final OceanSummary ocean;
  final WallpaperSummary wallpaper;
  final AssistantSummary assistant;
  final CirclesSummary circles;
  final JournalSummary journal;
}

class ModeSummary {
  const ModeSummary({
    required this.activeMode,
    required this.isRamadanDateWindowActive,
    required this.isKidsMode,
  });

  final AppSpecialMode activeMode;
  final bool isRamadanDateWindowActive;
  final bool isKidsMode;
}

class OceanSummary {
  const OceanSummary({
    required this.totalDrops,
    required this.todayDrops,
    required this.weekDrops,
  });

  final int totalDrops;
  final int todayDrops;
  final int weekDrops;
}

class WallpaperSummary {
  const WallpaperSummary({
    required this.selectedTitle,
    required this.unlockedCount,
  });

  final String selectedTitle;
  final int unlockedCount;
}

class AssistantSummary {
  const AssistantSummary({
    required this.recentMessages,
    required this.quickPrompts,
    required this.recentPrompts,
  });

  final int recentMessages;
  final int quickPrompts;
  final int recentPrompts;
}

class CirclesSummary {
  const CirclesSummary({
    required this.joinedCount,
    required this.favoriteCount,
    required this.savedCount,
    required this.featuredCircleTitle,
  });

  final int joinedCount;
  final int favoriteCount;
  final int savedCount;
  final String featuredCircleTitle;
}

class JournalSummary {
  const JournalSummary({
    required this.entriesCount,
    required this.hasMemoryPreview,
    required this.favoriteEntries,
  });

  final int entriesCount;
  final bool hasMemoryPreview;
  final int favoriteEntries;
}

class WeeklyReflectionReviewSummary {
  const WeeklyReflectionReviewSummary({
    required this.titleHighlight,
    required this.worshipCompletions,
    required this.learningCompletions,
    required this.journalEntries,
    required this.favoriteReflections,
    required this.topTags,
  });

  final String titleHighlight;
  final int worshipCompletions;
  final int learningCompletions;
  final int journalEntries;
  final int favoriteReflections;
  final List<String> topTags;
}

final worshipSummaryProvider = Provider<WorshipSummary>((ref) {
  final prayerSummary = ref.watch(prayerSummaryProvider);
  final dhikr = ref.watch(dhikrControllerProvider);
  final fasting = ref.watch(fastingControllerProvider);
  final todayKey = LocalStore.todayKey(DateTime.now());
  final dhikrCountToday =
      dhikr.recentSessions
          .where((session) => LocalStore.todayKey(session.finishedAt) == todayKey)
          .fold<int>(0, (sum, session) => sum + session.count) +
      dhikr.currentCount;

  final dhikrProgress = dhikr.target <= 0
      ? 0.0
      : (dhikrCountToday / dhikr.target).clamp(0.0, 1.0).toDouble();

  return WorshipSummary(
    prayerCompleted: prayerSummary.completed,
    prayerTotal: prayerSummary.total,
    prayerProgress: prayerSummary.progress,
    dhikrCount: dhikrCountToday,
    dhikrTarget: dhikr.target,
    dhikrProgress: dhikrProgress,
    fastingStatus: fasting.todayStatus,
    khusuQuickReady: true,
  );
});

final journeySummaryProvider = Provider<JourneySummary>((ref) {
  final progress = ref.watch(journeyComputedProgressProvider);

  return JourneySummary(
    level: progress.level,
    xp: progress.xp,
    nextLevelXpRemaining: progress.nextLevelXpRemaining,
    currentStreakDays: progress.currentStreakDays,
    bestStreakDays: progress.bestStreakDays,
    ringPrayer: progress.ringPrayer,
    ringDhikr: progress.ringDhikr,
    ringQuran: progress.ringQuran,
    ringReflection: progress.ringReflection,
    ringFasting: progress.ringFasting,
    nextUnlockPreviewKey: progress.nextUnlockPreviewKey,
    weeklyConsistencyBars: progress.weeklyConsistencyBars,
    unlockedMilestoneKeys: progress.unlockedMilestoneKeys,
    upcomingMilestoneKeys: progress.upcomingMilestoneKeys,
    unlockedRewardKeys: progress.unlockedRewardKeys,
    upcomingRewardKeys: progress.upcomingRewardKeys,
    growthStageKey: progress.growthStageKey,
    localDropsContributionCount: progress.localDropsContributionCount,
    monthlyBadges: progress.monthlyBadges,
    dailyBadges: progress.dailyBadges,
    graceTokensRemaining: progress.graceTokensRemaining,
    graceTokenMonthlyAllowance: progress.graceTokenMonthlyAllowance,
    weeklyProtectedDays: progress.weeklyProtectedDays,
  );
});

final weeklyReflectionReviewSummaryProvider =
    Provider<WeeklyReflectionReviewSummary>((ref) {
      final now = DateTime.now();
      final threshold = now.subtract(const Duration(days: 6));
      final journey = ref.watch(journeyProgressProvider);
      final journal = ref.watch(journalProvider);
      final learn = ref.watch(learnProgressSummaryProvider);
      final worship = ref.watch(worshipSummaryProvider);

      var worshipCompletions = 0;
      for (final entry in journey.dayMetricsByKey.entries) {
        final day = DateTime.tryParse('${entry.key}T00:00:00');
        if (day == null ||
            day.isBefore(
              DateTime(threshold.year, threshold.month, threshold.day),
            )) {
          continue;
        }
        final value = entry.value;
        worshipCompletions +=
            value.prayerCompleted +
            value.dhikrSessions +
            value.fastingCompleted +
            value.fastingIntending;
      }

      final weeklyJournal = journal.entries.where((entry) {
        final created = DateTime.tryParse(entry.createdAtIso);
        return created != null && !created.isBefore(threshold);
      }).toList();
      final favoriteReflections = weeklyJournal
          .where((entry) => entry.favorite)
          .length;

      final tagCounts = <String, int>{};
      for (final entry in weeklyJournal) {
        for (final tag in entry.tags) {
          final clean = tag.trim();
          if (clean.isEmpty) continue;
          tagCounts[clean] = (tagCounts[clean] ?? 0) + 1;
        }
      }
      final topTags = tagCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      final highlight = worship.prayerProgress >= 0.8
          ? 'steady_worship'
          : learn.completedCount > 0
          ? 'learning_growth'
          : weeklyJournal.isNotEmpty
          ? 'reflection_presence'
          : 'small_steps';

      return WeeklyReflectionReviewSummary(
        titleHighlight: highlight,
        worshipCompletions: worshipCompletions,
        learningCompletions: learn.completedCount,
        journalEntries: weeklyJournal.length,
        favoriteReflections: favoriteReflections,
        topTags: topTags.take(3).map((entry) => entry.key).toList(),
      );
    });

final learnSummaryProvider = Provider<LearnSummary>((ref) {
  final continueSummary = ref.watch(quranContinueReadingSummaryProvider);
  final notes = ref.watch(quranNotesProvider);
  final learnProgress = ref.watch(learnProgressSummaryProvider);
  final unified = ref.watch(learnUnifiedSummaryProvider);
  final mode = ref.watch(specialModeProvider);
  final modeCatalog = catalogForMode(mode.activeMode, kidsMode: mode.isKids);
  final featured = modeCatalog.isEmpty ? learnExpansionCatalog : modeCatalog;

  LearnLifeTopic life = LearnLifeTopic.patience;
  LearnWorldTopic world = LearnWorldTopic.mountains;
  LearnHadithTopic hadith = LearnHadithTopic.characterAndManners;

  for (final item in featured) {
    if (item.category == LearnTopicCategory.life) {
      life = _lifeFromTopicId(item.topicId);
      break;
    }
  }
  for (final item in featured) {
    if (item.category == LearnTopicCategory.world) {
      world = _worldFromTopicId(item.topicId);
      break;
    }
  }
  for (final item in featured) {
    if (item.category == LearnTopicCategory.hadith) {
      hadith = _hadithFromTopicId(item.topicId);
      break;
    }
  }

  return LearnSummary(
    continueSurahName: continueSummary.surahName,
    continueAyah: continueSummary.ayahNumber,
    featuredLifeTopic: life,
    featuredWorldTopic: world,
    featuredHadithTopic: hadith,
    resumeNoteTitle: notes.isEmpty
        ? (unified.recentItems.isEmpty
              ? _reflectionDraftSentinel
              : unified.recentItems.first.title)
        : notes.first.text,
    startedTopics: learnProgress.startedCount,
    completedTopics: learnProgress.completedCount,
    favoriteTopics: learnProgress.favoriteCount,
    resumeTopicId:
        unified.continueItem?.title ?? learnProgress.lastResumedTopicId,
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

final modeSummaryProvider = Provider<ModeSummary>((ref) {
  final mode = ref.watch(specialModeProvider);
  return ModeSummary(
    activeMode: mode.activeMode,
    isRamadanDateWindowActive: mode.ramadanDateWindowActive,
    isKidsMode: mode.isKids,
  );
});

final oceanSummaryProvider = Provider<OceanSummary>((ref) {
  final ocean = ref.watch(oceanDropsProvider);
  return OceanSummary(
    totalDrops: ocean.totalLocalDrops,
    todayDrops: ocean.todayDrops,
    weekDrops: ocean.weekDrops,
  );
});

final wallpaperSummaryProvider = Provider<WallpaperSummary>((ref) {
  final selected = ref.watch(selectedWallpaperProvider);
  final state = ref.watch(wallpaperProvider);
  return WallpaperSummary(
    selectedTitle: selected.title,
    unlockedCount: state.unlockedIds.length,
  );
});

final assistantSummaryProvider = Provider<AssistantSummary>((ref) {
  final assistant = ref.watch(assistantProvider);
  return AssistantSummary(
    recentMessages: assistant.messages.length,
    quickPrompts: assistant.quickPrompts.length,
    recentPrompts: assistant.recentPrompts.length,
  );
});

final circlesSummaryProvider = Provider<CirclesSummary>((ref) {
  final circles = ref.watch(circlesProvider);
  final featured = ref.watch(recommendedCirclesProvider);
  return CirclesSummary(
    joinedCount: circles.joinedIds.length,
    favoriteCount: circles.favoritedIds.length,
    savedCount: circles.savedIds.length,
    featuredCircleTitle: featured.isEmpty ? '' : featured.first.title,
  );
});

final journalSummaryProvider = Provider<JournalSummary>((ref) {
  final journal = ref.watch(journalProvider);
  final memory = ref.watch(journalMemoryPreviewProvider);
  final favorites = journal.entries.where((item) => item.favorite).length;
  return JournalSummary(
    entriesCount: journal.entries.length,
    hasMemoryPreview: memory != null,
    favoriteEntries: favorites,
  );
});

final homeDashboardSummaryProvider = Provider<HomeDashboardSummary>((ref) {
  return HomeDashboardSummary(
    worship: ref.watch(worshipSummaryProvider),
    journey: ref.watch(journeySummaryProvider),
    learn: ref.watch(learnSummaryProvider),
    mode: ref.watch(modeSummaryProvider),
    ocean: ref.watch(oceanSummaryProvider),
    wallpaper: ref.watch(wallpaperSummaryProvider),
    assistant: ref.watch(assistantSummaryProvider),
    circles: ref.watch(circlesSummaryProvider),
    journal: ref.watch(journalSummaryProvider),
  );
});

LearnLifeTopic _lifeFromTopicId(String id) {
  switch (id) {
    case 'marriage':
      return LearnLifeTopic.marriage;
    case 'parents':
      return LearnLifeTopic.parents;
    case 'children':
      return LearnLifeTopic.children;
    case 'wealth':
      return LearnLifeTopic.wealth;
    case 'justice':
      return LearnLifeTopic.justice;
    case 'character':
      return LearnLifeTopic.character;
    case 'gratitude':
      return LearnLifeTopic.gratitude;
    case 'patience':
    default:
      return LearnLifeTopic.patience;
  }
}

LearnWorldTopic _worldFromTopicId(String id) {
  switch (id) {
    case 'moon':
      return LearnWorldTopic.moon;
    case 'bees':
      return LearnWorldTopic.bees;
    case 'rain':
      return LearnWorldTopic.rain;
    case 'oceans':
      return LearnWorldTopic.oceans;
    case 'animals':
      return LearnWorldTopic.animals;
    case 'plants':
      return LearnWorldTopic.plants;
    case 'night-day':
      return LearnWorldTopic.nightAndDay;
    case 'mountains':
    default:
      return LearnWorldTopic.mountains;
  }
}

LearnHadithTopic _hadithFromTopicId(String id) {
  switch (id) {
    case 'life-lessons':
      return LearnHadithTopic.lifeLessons;
    case 'world-lessons':
      return LearnHadithTopic.worldLessons;
    case 'worship-intention':
      return LearnHadithTopic.worshipAndIntention;
    case 'family-society':
      return LearnHadithTopic.familyAndSociety;
    case 'character-manners':
    default:
      return LearnHadithTopic.characterAndManners;
  }
}
