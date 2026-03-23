import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/bedtime_story_media_manifest.dart';
import '../data/bedtime_story_seed.dart';
import '../data/kids_islamic_story_seed.dart';
import '../domain/bedtime_story_models.dart';
import '../../seerah/data/companion_story_seed.dart';
import 'bedtime_story_progress_service.dart';

final bedtimeStoryRepositoryProvider = Provider<BedtimeStoryRepository>((ref) {
  return BedtimeStoryRepository(ref);
});

final bedtimeStoriesProvider = Provider<List<BedtimeStorySeed>>((ref) {
  return ref.watch(bedtimeStoryRepositoryProvider).bedtimeStories;
});

final kidsIslamicStoriesProvider = Provider<List<BedtimeStorySeed>>((ref) {
  return ref.watch(bedtimeStoryRepositoryProvider).allStories;
});

final featuredKidsStoryProvider = Provider<BedtimeStorySeed?>((ref) {
  return ref.watch(bedtimeStoryRepositoryProvider).featuredLibraryStory();
});

final continueKidsStoryProvider = Provider<BedtimeStorySeed?>((ref) {
  return ref.watch(bedtimeStoryRepositoryProvider).continueStory();
});

final bedtimeEligibleStoriesProvider = Provider<List<BedtimeStorySeed>>((ref) {
  return ref.watch(bedtimeStoryRepositoryProvider).bedtimeEligibleStories;
});

final kidsStoriesByCollectionProvider =
    Provider.family<List<BedtimeStorySeed>, KidsIslamicStoryCollectionType>((
      ref,
      collectionType,
    ) {
      return ref
          .watch(bedtimeStoryRepositoryProvider)
          .storiesForCollection(collectionType);
    });

final featuredKidsStoriesProvider = Provider<List<BedtimeStorySeed>>((ref) {
  return ref.watch(bedtimeStoryRepositoryProvider).featuredLibraryStories();
});

final kidsHadithStoriesProvider = Provider<List<BedtimeStorySeed>>((ref) {
  return ref.watch(bedtimeStoryRepositoryProvider).hadithStories;
});

final bedtimeStoryByIdProvider = Provider.family<BedtimeStorySeed?, String>((
  ref,
  storyId,
) {
  return ref.watch(bedtimeStoryRepositoryProvider).storyById(storyId);
});

final featuredBedtimeStoryProvider = Provider<BedtimeStorySeed?>((ref) {
  return ref.watch(bedtimeStoryRepositoryProvider).featuredStory();
});

final tonightBedtimeStoryProvider = Provider<BedtimeStorySeed?>((ref) {
  return ref.watch(bedtimeStoryRepositoryProvider).tonightStory();
});

final continueBedtimeStoryProvider = Provider<BedtimeStorySeed?>((ref) {
  return ref
      .watch(bedtimeStoryRepositoryProvider)
      .continueStory(bedtimeOnly: true);
});

final relatedBedtimeStoriesProvider =
    Provider.family<List<BedtimeStorySeed>, String>((ref, storyId) {
      return ref.watch(bedtimeStoryRepositoryProvider).relatedStories(storyId);
    });

final bedtimeStorySeriesProvider =
    Provider.family<List<BedtimeStorySeed>, String>((ref, prophetId) {
      return ref
          .watch(bedtimeStoryRepositoryProvider)
          .storiesForProphet(prophetId);
    });

final bedtimeStorySeriesCompletionProvider = Provider.family<bool, String>((
  ref,
  prophetId,
) {
  return ref.watch(bedtimeStoryRepositoryProvider).isSeriesCompleted(prophetId);
});

class BedtimeStoryRepository {
  BedtimeStoryRepository(this._ref);

  final Ref _ref;

  List<BedtimeStorySeed> get allStories => [
    ...kBedtimeProphetStories,
    ...kKidsIslamicStories,
    ...kKidsSeerahCompanionStories,
  ]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  List<BedtimeStorySeed> get bedtimeStories => bedtimeEligibleStories;

  List<BedtimeStorySeed> get hadithStories =>
      allStories
          .where(
            (story) =>
                story.sourceCategory == KidsIslamicStorySourceCategory.hadith,
          )
          .toList(growable: false)
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  List<BedtimeStorySeed> get bedtimeEligibleStories =>
      allStories.where((story) => story.bedtimeEligible).toList(growable: false)
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  List<BedtimeStorySeed> get stories => bedtimeStories;

  List<BedtimeStorySeed> storiesForCollection(
    KidsIslamicStoryCollectionType collectionType,
  ) {
    return allStories
        .where((story) => story.collectionType == collectionType)
        .toList(growable: false)
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  BedtimeStorySeed? storyById(String id) {
    for (final story in allStories) {
      if (story.id == id) {
        return story;
      }
    }
    return null;
  }

  BedtimeStorySeed? featuredStory() {
    final progressState = _ref.watch(bedtimeStoryProgressProvider);
    for (final story in bedtimeStories) {
      final progress = progressState.storyProgressById[story.id];
      if (story.isFeatured && !(progress?.isCompleted ?? false)) {
        return story;
      }
    }
    return bedtimeStories.isEmpty ? null : bedtimeStories.first;
  }

  BedtimeStorySeed? featuredLibraryStory() {
    final progressState = _ref.watch(bedtimeStoryProgressProvider);
    for (final story in allStories) {
      final progress = progressState.storyProgressById[story.id];
      if (story.isFeatured && !(progress?.isCompleted ?? false)) {
        return story;
      }
    }
    return allStories.isEmpty ? null : allStories.first;
  }

  List<BedtimeStorySeed> featuredLibraryStories() {
    return allStories
        .where((story) => story.isFeatured)
        .take(8)
        .toList(growable: false);
  }

  BedtimeStorySeed? tonightStory() {
    final progressState = _ref.watch(bedtimeStoryProgressProvider);
    for (final story in bedtimeStories) {
      final progress = progressState.storyProgressById[story.id];
      if (story.recommendedForTonight && !(progress?.isCompleted ?? false)) {
        return story;
      }
    }
    return featuredStory();
  }

  BedtimeStorySeed? continueStory({bool bedtimeOnly = false}) {
    final progressState = _ref.watch(bedtimeStoryProgressProvider);
    for (final storyId in progressState.recentStoryIds) {
      final progress = progressState.storyProgressById[storyId];
      if (progress == null ||
          progress.completionState != BedtimeStoryCompletionState.inProgress) {
        continue;
      }
      final story = storyById(storyId);
      if (story == null) {
        continue;
      }
      if (bedtimeOnly && !story.bedtimeEligible) {
        continue;
      }
      return story;
    }
    return null;
  }

  List<BedtimeStorySeed> relatedStories(String storyId) {
    final story = storyById(storyId);
    if (story == null) {
      return const <BedtimeStorySeed>[];
    }
    final explicit = story.relatedStoryIds
        .map(storyById)
        .whereType<BedtimeStorySeed>()
        .toList(growable: false);
    if (explicit.isNotEmpty) {
      return explicit;
    }
    return allStories
        .where((item) => item.id != storyId)
        .where(
          (item) =>
              item.collectionType == story.collectionType ||
              item.storyType == story.storyType ||
              item.themes.any(story.themes.contains),
        )
        .take(3)
        .toList(growable: false);
  }

  List<BedtimeStorySeed> storiesForProphet(String prophetId) {
    return allStories
        .where(
          (story) =>
              story.isProphetStory && story.effectiveStoryFamilyId == prophetId,
        )
        .toList(growable: false)
      ..sort((a, b) => a.partNumber.compareTo(b.partNumber));
  }

  List<BedtimeStorySeed> storiesForFamily(String familyId) {
    return allStories
        .where((story) => story.effectiveStoryFamilyId == familyId)
        .toList(growable: false)
      ..sort((a, b) => a.partNumber.compareTo(b.partNumber));
  }

  bool isSeriesCompleted(String prophetId) {
    final seriesStories = storiesForProphet(prophetId);
    if (seriesStories.length <= 1) {
      return false;
    }
    final progressState = _ref.watch(bedtimeStoryProgressProvider);
    return seriesStories.every(
      (story) =>
          progressState.storyProgressById[story.id]?.isCompleted ?? false,
    );
  }

  String audioAssetPathFor(BedtimeStorySeed story) {
    return bedtimeStoryAudioManifestEntryFor(story).assetPath;
  }
}
