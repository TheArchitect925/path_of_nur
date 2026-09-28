import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../kids_arabic/application/kids_arabic_achievements_provider.dart';
import '../../../kids_arabic/application/kids_arabic_progress_provider.dart';
import '../../../kids_dua_learning/application/kids_dua_progress_provider.dart';
import '../../../kids_dua_learning/application/kids_dua_repository.dart';
import '../../../kids_dua_learning/application/kids_dua_sticker_service.dart';
import '../../../kids_dua_learning/domain/kids_dua_models.dart';
import '../../activity/application/kids_activity_log_service.dart';
import '../../activity/domain/kids_activity_models.dart';
import '../../bedtime_stories/application/bedtime_story_progress_service.dart';
import '../../bedtime_stories/application/bedtime_story_repository.dart';
import '../domain/kids_sticker_models.dart';

/// The clock the streak is measured against; tests pin it.
final kidsRewardNowProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

/// The activity-log entries that mean "finished something today".
const Set<KidsActivityType> kidsCompletionActivityTypes = {
  KidsActivityType.storyCompleted,
  KidsActivityType.quizCompleted,
  KidsActivityType.memoryCompleted,
  KidsActivityType.duaLessonCompleted,
  KidsActivityType.duaPracticeCompleted,
  KidsActivityType.duaMyDayCompleted,
  KidsActivityType.arabicLetterCompleted,
  KidsActivityType.arabicReviewCompleted,
  KidsActivityType.arabicDailyMissionCompleted,
  KidsActivityType.seerahNodeCompleted,
  KidsActivityType.seerahStageCompleted,
  KidsActivityType.seerahJourneyCompleted,
  KidsActivityType.bedtimeRoutineCompleted,
};

/// One reward world over the stores that already exist.
///
/// Nothing is migrated: a completed story, a completed letter and a learned
/// duʿā already live in their own progress providers, and every completion
/// already lands in the kids activity log. This provider reads them as one
/// sticker book and one streak, so XP, ocean drops, "light" and the two
/// achievement lists can leave the child's screens without losing anything.
final kidsRewardWorldProvider = Provider<KidsRewardWorld>((ref) {
  final now = ref.watch(kidsRewardNowProvider)();
  final stickers = <KidsSticker>[];

  // Stories: one sticker per completed story, wearing its cover.
  final storyProgress = ref.watch(
    bedtimeStoryProgressProvider.select((state) => state.storyProgressById),
  );
  for (final story in ref.watch(kidsIslamicStoriesProvider)) {
    final progress = storyProgress[story.id];
    if (progress == null || !progress.isCompleted) continue;
    stickers.add(
      KidsSticker(
        id: 'story:${story.id}',
        kind: KidsStickerKind.story,
        title: story.shortTitle,
        imageAsset: story.coverAssetPath.isEmpty ? null : story.coverAssetPath,
        icon: AppIcons.stories,
        earnedAtIso: progress.completedAtIso,
      ),
    );
  }

  // Letters: one sticker per completed letter, wearing its glyph.
  final completedLetterIds = ref.watch(
    kidsArabicProgressProvider.select((state) => state.completedLetterIds),
  );
  for (final letter in ref.watch(kidsArabicLettersProvider)) {
    if (!completedLetterIds.contains(letter.id)) continue;
    stickers.add(
      KidsSticker(
        id: 'letter:${letter.id}',
        kind: KidsStickerKind.letter,
        title: letter.nameEn,
        subtitle: letter.transliteration,
        glyph: letter.glyph,
      ),
    );
  }

  // Duʿās: one sticker per learned duʿā.
  final duaState = ref.watch(kidsDuaLearningProvider);
  for (final lesson in ref.watch(kidsDuaLessonsProvider)) {
    final progress = duaState.progressByLessonId[lesson.id];
    if (progress == null || progress.status != KidsDuaLessonStatus.learned) {
      continue;
    }
    stickers.add(
      KidsSticker(
        id: 'dua:${lesson.id}',
        kind: KidsStickerKind.dua,
        title: lesson.title,
        subtitle: lesson.arabic,
        icon: AppIcons.dua,
      ),
    );
  }

  // Special: the milestone stickers the two older systems already grant.
  for (final status in ref.watch(kidsArabicAchievementStatusesProvider)) {
    if (!status.unlocked) continue;
    stickers.add(
      KidsSticker(
        id: 'arabic-achievement:${status.definition.id}',
        kind: KidsStickerKind.special,
        title: status.definition.id,
        labelKey: 'arabic-achievement:${status.definition.id}',
        icon: status.definition.icon,
        color: status.definition.color,
      ),
    );
  }
  for (final sticker in kidsDuaCategoryStickers) {
    final unlockedAt = duaState.stickerUnlockedAtById[sticker.id];
    if (unlockedAt == null) continue;
    stickers.add(
      KidsSticker(
        id: 'dua-sticker:${sticker.id}',
        kind: KidsStickerKind.special,
        title: sticker.id,
        labelKey: sticker.titleKey,
        icon: sticker.icon,
        color: sticker.color,
        earnedAtIso: unlockedAt,
      ),
    );
  }

  // One streak over everything the child finishes.
  final moments = <DateTime>[
    for (final entry in ref.watch(kidsActivityLogProvider).entries)
      if (kidsCompletionActivityTypes.contains(entry.type))
        ?DateTime.tryParse(entry.occurredAtIso),
  ];
  final today = DateTime(now.year, now.month, now.day);
  final completedToday = moments.any(
    (moment) => DateTime(moment.year, moment.month, moment.day) == today,
  );

  return KidsRewardWorld(
    stickers: stickers,
    streakDays: kidsStreakDaysFrom(moments, now),
    completedToday: completedToday,
  );
});
