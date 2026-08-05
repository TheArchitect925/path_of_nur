import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../bedtime_stories/application/bedtime_active_learner_service.dart';
import '../../bedtime_stories/application/bedtime_story_repository.dart';
import '../../bedtime_stories/domain/bedtime_story_models.dart';
import '../../../kids_dua_learning/application/kids_dua_repository.dart';
import '../../../kids_dua_learning/domain/kids_dua_models.dart';
import '../data/bedtime_routine_seed.dart';
import '../domain/bedtime_routine_models.dart';

final bedtimeRoutineRepositoryProvider = Provider<BedtimeRoutineRepository>((
  ref,
) {
  return BedtimeRoutineRepository(ref);
});

final bedtimeRoutinePlanProvider = Provider<BedtimeRoutinePlan>((ref) {
  return ref.watch(bedtimeRoutineRepositoryProvider).defaultPlan();
});

final bedtimePrimaryDuaProvider = Provider<SuggestedBedtimeDua?>((ref) {
  return ref.watch(bedtimeRoutineRepositoryProvider).primaryBedtimeDua();
});

final bedtimeSecondaryDuasProvider = Provider<List<SuggestedBedtimeDua>>((ref) {
  return ref.watch(bedtimeRoutineRepositoryProvider).secondaryBedtimeDuas();
});

class BedtimeRoutineRepository {
  BedtimeRoutineRepository(this._ref);

  final Ref _ref;

  BedtimeRoutinePlan defaultPlan() {
    final learner = _ref.watch(bedtimeActiveLearnerProvider);
    final prefersDuaFirst = learner.preferences.prefersBedtimeDuaFirst;
    final simplified = learner.preferences.simplifiedBedtimeRoutine;
    final steps = [...kDefaultBedtimeRoutinePlan.steps]
      ..sort((a, b) {
        final aOrder = _orderFor(a, prefersDuaFirst: prefersDuaFirst);
        final bOrder = _orderFor(b, prefersDuaFirst: prefersDuaFirst);
        return aOrder.compareTo(bOrder);
      });
    final filteredSteps = simplified
        ? steps
              .where((item) {
                return item.stepType !=
                    BedtimeRoutineStepType.gratitudeReflection;
              })
              .toList(growable: false)
        : steps;
    return BedtimeRoutinePlan(
      planId: kDefaultBedtimeRoutinePlan.planId,
      titleKey: kDefaultBedtimeRoutinePlan.titleKey,
      learnerId: learner.learnerId,
      languageCode: learner.preferences.bedtimeLanguageTag ?? 'en',
      steps: filteredSteps,
      isDefault: true,
      recommendedAgeGroup: kDefaultBedtimeRoutinePlan.recommendedAgeGroup,
      bedtimeWindowLabel: learner.preferences.bedtimeMinutesPreference == null
          ? null
          : '${learner.preferences.bedtimeMinutesPreference}m',
      narrationPreferenceLabel:
          learner.preferences.preferTranscriptWhenAudioMissing
          ? 'transcript_ok'
          : null,
    );
  }

  SuggestedBedtimeDua? primaryBedtimeDua() {
    final lesson = _ref.watch(kidsDuaLessonByIdProvider('before-sleep'));
    if (lesson == null) {
      return null;
    }
    return _mapKidsLessonToSuggestedDua(
      lesson,
      bedtimeUseCase: 'primary_sleep_dua',
    );
  }

  List<SuggestedBedtimeDua> secondaryBedtimeDuas() {
    const ids = <String>['astaghfirullah'];
    return ids
        .map((id) => _ref.watch(kidsDuaLessonByIdProvider(id)))
        .whereType<KidsDuaLessonContent>()
        .map(
          (lesson) => _mapKidsLessonToSuggestedDua(
            lesson,
            bedtimeUseCase: 'quiet_dhikr',
          ),
        )
        .toList(growable: false);
  }

  BedtimeStorySeed? tonightStory() {
    final learner = _ref.watch(bedtimeActiveLearnerProvider);
    final storyRepo = _ref.watch(bedtimeStoryRepositoryProvider);
    if (learner.preferences.alwaysResumeBedtimeStory) {
      final continueStory = storyRepo.continueStory();
      if (continueStory != null) {
        return continueStory;
      }
    }
    return storyRepo.tonightStory();
  }

  SuggestedBedtimeDua _mapKidsLessonToSuggestedDua(
    KidsDuaLessonContent lesson, {
    required String bedtimeUseCase,
  }) {
    return SuggestedBedtimeDua(
      duaId: lesson.id,
      title: lesson.title,
      arabicText: lesson.arabic,
      transliteration: lesson.transliteration,
      translation: lesson.meaning,
      shortMeaning: lesson.miniLesson,
      sourceReference: lesson.sourceReference,
      bedtimeUseCase: bedtimeUseCase,
      ageGroup: BedtimeStoryAgeGroup.kids,
      audioAssetPath: lesson.audioAssetPath.isEmpty
          ? null
          : lesson.audioAssetPath,
      tags: <String>[lesson.categoryId, lesson.sourceType],
    );
  }

  int _orderFor(BedtimeRoutineStep step, {required bool prefersDuaFirst}) {
    if (prefersDuaFirst) {
      return step.sortOrder;
    }
    if (step.stepType == BedtimeRoutineStepType.storyTime) {
      return 2;
    }
    if (step.stepType == BedtimeRoutineStepType.bedtimeDua) {
      return 3;
    }
    return step.sortOrder == 2
        ? 3
        : step.sortOrder == 3
        ? 2
        : step.sortOrder;
  }
}
