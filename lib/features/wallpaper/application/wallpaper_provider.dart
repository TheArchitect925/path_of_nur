import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/persistence/local_store.dart';
import '../../journey/application/journey_progression_provider.dart';
import '../../learn/content/application/learn_progress_provider.dart';

class AppWallpaper {
  const AppWallpaper({
    required this.id,
    required this.title,
    required this.assetPath,
    required this.minLevel,
    required this.category,
    required this.rewardHint,
    this.requiredMilestoneKey,
    this.requiredCompletedTopics = 0,
    this.requiresRamadanMode = false,
    this.kidsFriendly = false,
  });

  final String id;
  final String title;
  final String assetPath;
  final int minLevel;
  final String category;
  final String rewardHint;
  final String? requiredMilestoneKey;
  final int requiredCompletedTopics;
  final bool requiresRamadanMode;
  final bool kidsFriendly;
}

const stagedWallpapers = <AppWallpaper>[
  AppWallpaper(
    id: 'parchment-default',
    title: 'Parchment Dawn',
    assetPath: 'assets/images/backgrounds/bg_v1.png',
    minLevel: 1,
    category: 'default',
    rewardHint: 'Starter unlock',
  ),
  AppWallpaper(
    id: 'mist-field',
    title: 'Misty Field',
    assetPath: 'assets/images/backgrounds/bg_v1.png',
    minLevel: 2,
    category: 'nature',
    rewardHint: 'Level 2 growth',
  ),
  AppWallpaper(
    id: 'ramadan-lantern',
    title: 'Lantern Glow',
    assetPath: 'assets/images/backgrounds/bg_v1.png',
    minLevel: 4,
    category: 'seasonal',
    rewardHint: 'Ramadan reflection path',
    requiredMilestoneKey: 'fastingComplete',
    requiresRamadanMode: true,
  ),
  AppWallpaper(
    id: 'ocean-drops',
    title: 'Ocean Serenity',
    assetPath: 'assets/images/backgrounds/bg_v1.png',
    minLevel: 6,
    category: 'journey',
    rewardHint: 'Learning consistency reward',
    requiredMilestoneKey: 'learningStreak',
    requiredCompletedTopics: 3,
  ),
  AppWallpaper(
    id: 'kids-sunrise',
    title: 'Sunrise Spark',
    assetPath: 'assets/images/backgrounds/bg_v1.png',
    minLevel: 1,
    category: 'kids',
    rewardHint: 'Kids mode friendly unlock',
    kidsFriendly: true,
  ),
  AppWallpaper(
    id: 'night-study',
    title: 'Night Study',
    assetPath: 'assets/images/backgrounds/bg_v1.png',
    minLevel: 8,
    category: 'learning',
    rewardHint: 'Complete 5 learn topics',
    requiredCompletedTopics: 5,
  ),
];

class WallpaperState {
  const WallpaperState({
    required this.selectedId,
    required this.unlockedIds,
    required this.selectedCategory,
  });

  final String selectedId;
  final Set<String> unlockedIds;
  final String selectedCategory;

  WallpaperState copyWith({
    String? selectedId,
    Set<String>? unlockedIds,
    String? selectedCategory,
  }) {
    return WallpaperState(
      selectedId: selectedId ?? this.selectedId,
      unlockedIds: unlockedIds ?? this.unlockedIds,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  Map<String, dynamic> toJson() => {
    'selectedId': selectedId,
    'unlockedIds': unlockedIds.toList(),
    'selectedCategory': selectedCategory,
  };

  static WallpaperState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const WallpaperState(
        selectedId: 'parchment-default',
        unlockedIds: {'parchment-default'},
        selectedCategory: 'all',
      );
    }
    final selected = json['selectedId']?.toString() ?? 'parchment-default';
    final unlockedRaw = json['unlockedIds'];
    final unlocked = <String>{'parchment-default'};
    if (unlockedRaw is List) {
      for (final item in unlockedRaw) {
        unlocked.add(item.toString());
      }
    }
    return WallpaperState(
      selectedId: selected,
      unlockedIds: unlocked,
      selectedCategory: json['selectedCategory']?.toString() ?? 'all',
    );
  }
}

class WallpaperNotifier extends StateNotifier<WallpaperState> {
  WallpaperNotifier(this._store)
    : super(WallpaperState.fromJson(_store.getJsonMap(_key)));

  static const _key = 'appearance.wallpaper';
  final LocalStore _store;

  void select(String id) {
    if (!state.unlockedIds.contains(id)) return;
    state = state.copyWith(selectedId: id);
    _save();
  }

  void selectCategory(String category) {
    state = state.copyWith(selectedCategory: category);
    _save();
  }

  void unlock(String id) {
    if (state.unlockedIds.contains(id)) return;
    final next = Set<String>.from(state.unlockedIds)..add(id);
    state = state.copyWith(unlockedIds: next);
    if (!next.contains(state.selectedId)) {
      state = state.copyWith(selectedId: id);
    }
    _save();
  }

  void _save() {
    _store.setJsonMap(_key, state.toJson());
  }
}

class WallpaperRewardSummary {
  const WallpaperRewardSummary({
    required this.unlockedCount,
    required this.totalCount,
    required this.nextRewardHint,
  });

  final int unlockedCount;
  final int totalCount;
  final String nextRewardHint;
}

class WallpaperStoryCard {
  const WallpaperStoryCard({
    required this.wallpaperId,
    required this.title,
    required this.rewardHint,
    required this.requiredMilestoneKey,
    required this.requiredCompletedTopics,
    required this.minLevel,
    required this.currentLevel,
    required this.currentLearnCompletions,
    required this.unlocked,
  });

  final String wallpaperId;
  final String title;
  final String rewardHint;
  final String? requiredMilestoneKey;
  final int requiredCompletedTopics;
  final int minLevel;
  final int currentLevel;
  final int currentLearnCompletions;
  final bool unlocked;
}

final wallpaperProvider =
    StateNotifierProvider<WallpaperNotifier, WallpaperState>(
      (ref) => WallpaperNotifier(ref.watch(localStoreProvider)),
    );

final wallpaperAutoUnlockProvider = Provider<void>((ref) {
  void runUnlock() {
    Future<void>.microtask(() {
      final progress = ref.read(journeyComputedProgressProvider);
      final mode = ref.read(specialModeProvider);
      final learn = ref.read(learnProgressSummaryProvider);
      final notifier = ref.read(wallpaperProvider.notifier);
      final unlockedMilestones = progress.unlockedMilestoneKeys;
      for (final wallpaper in stagedWallpapers) {
        final levelMet = progress.level >= wallpaper.minLevel;
        final milestoneMet =
            wallpaper.requiredMilestoneKey == null ||
            unlockedMilestones.contains(wallpaper.requiredMilestoneKey);
        final learnMet =
            learn.completedCount >= wallpaper.requiredCompletedTopics;
        final modeMet = !wallpaper.requiresRamadanMode || mode.isRamadan;
        if (levelMet && milestoneMet && learnMet && modeMet) {
          notifier.unlock(wallpaper.id);
        }
      }
    });
  }

  ref.listen<JourneyComputedProgress>(
    journeyComputedProgressProvider,
    (_, next) => runUnlock(),
    fireImmediately: true,
  );
  ref.listen<SpecialModeState>(specialModeProvider, (_, next) => runUnlock());
  ref.listen<LearnProgressSummary>(
    learnProgressSummaryProvider,
    (_, next) => runUnlock(),
  );
});

final selectedWallpaperProvider = Provider<AppWallpaper>((ref) {
  final state = ref.watch(wallpaperProvider);
  return stagedWallpapers.firstWhere(
    (wallpaper) => wallpaper.id == state.selectedId,
    orElse: () => stagedWallpapers.first,
  );
});

final wallpaperCategoriesProvider = Provider<List<String>>((ref) {
  final categories = <String>{'all'};
  for (final wallpaper in stagedWallpapers) {
    categories.add(wallpaper.category);
  }
  return categories.toList();
});

final filteredWallpapersProvider = Provider<List<AppWallpaper>>((ref) {
  final state = ref.watch(wallpaperProvider);
  if (state.selectedCategory == 'all') return stagedWallpapers;
  return stagedWallpapers
      .where((item) => item.category == state.selectedCategory)
      .toList();
});

final wallpaperRewardSummaryProvider = Provider<WallpaperRewardSummary>((ref) {
  final state = ref.watch(wallpaperProvider);
  final next = stagedWallpapers.firstWhere(
    (item) => !state.unlockedIds.contains(item.id),
    orElse: () => stagedWallpapers.last,
  );
  return WallpaperRewardSummary(
    unlockedCount: state.unlockedIds.length,
    totalCount: stagedWallpapers.length,
    nextRewardHint: next.rewardHint,
  );
});

final wallpaperStoryCardsProvider = Provider<List<WallpaperStoryCard>>((ref) {
  final state = ref.watch(wallpaperProvider);
  final journey = ref.watch(journeyComputedProgressProvider);
  final learn = ref.watch(learnProgressSummaryProvider);
  final cards = <WallpaperStoryCard>[];
  for (final wallpaper in stagedWallpapers) {
    final unlocked = state.unlockedIds.contains(wallpaper.id);
    cards.add(
      WallpaperStoryCard(
        wallpaperId: wallpaper.id,
        title: wallpaper.title,
        rewardHint: wallpaper.rewardHint,
        requiredMilestoneKey: wallpaper.requiredMilestoneKey,
        requiredCompletedTopics: wallpaper.requiredCompletedTopics,
        minLevel: wallpaper.minLevel,
        currentLevel: journey.level,
        currentLearnCompletions: learn.completedCount,
        unlocked: unlocked,
      ),
    );
  }
  return cards;
});
