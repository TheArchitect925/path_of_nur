import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../bedtime_stories/application/bedtime_story_repository.dart';
import '../domain/bedtime_routine_models.dart';
import 'bedtime_routine_repository.dart';
import 'bedtime_session_service.dart';

final bedtimeCompanionRecommendationProvider =
    Provider<BedtimeCompanionRecommendation?>((ref) {
  final session = ref.watch(bedtimeCompanionSessionProvider).activeSession;
  final storyRepo = ref.watch(bedtimeStoryRepositoryProvider);
  final routineRepo = ref.watch(bedtimeRoutineRepositoryProvider);
  final currentStory = session?.suggestedStoryId == null
      ? null
      : storyRepo.storyById(session!.suggestedStoryId!);

  final continueStory = storyRepo.continueStory();
  if (continueStory != null) {
    return BedtimeCompanionRecommendation(
      type: BedtimeRecommendationType.resumeStory,
      titleKey: 'bedtimeCompanionRecommendationResumeTitle',
      subtitle: continueStory.shortTitle,
      storyId: continueStory.id,
    );
  }

  final primaryDua = routineRepo.primaryBedtimeDua();
  if (primaryDua != null) {
    return BedtimeCompanionRecommendation(
      type: BedtimeRecommendationType.bedtimeDua,
      titleKey: 'bedtimeCompanionRecommendationDuaTitle',
      subtitle: primaryDua.title,
      duaId: primaryDua.duaId,
    );
  }

  if (currentStory != null) {
    return BedtimeCompanionRecommendation(
      type: BedtimeRecommendationType.featuredStory,
      titleKey: 'bedtimeCompanionRecommendationStoryTitle',
      subtitle: currentStory.shortTitle,
      storyId: currentStory.id,
    );
  }

  return const BedtimeCompanionRecommendation(
    type: BedtimeRecommendationType.quietReflection,
    titleKey: 'bedtimeCompanionRecommendationReflectionTitle',
    subtitle: '',
  );
});
