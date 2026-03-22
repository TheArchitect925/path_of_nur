import '../../bedtime_stories/domain/bedtime_story_models.dart';
import '../domain/bedtime_routine_models.dart';

const kBedtimeRoutineReflectionChoiceIds = <String>[
  'gratitude_family',
  'gratitude_story_lesson',
  'gratitude_rest',
];

const BedtimeRoutinePlan kDefaultBedtimeRoutinePlan = BedtimeRoutinePlan(
  planId: 'default_bedtime_routine_v1',
  titleKey: 'bedtimeRoutineDefaultPlanTitle',
  languageCode: 'en',
  isDefault: true,
  recommendedAgeGroup: BedtimeStoryAgeGroup.kids,
  steps: <BedtimeRoutineStep>[
    BedtimeRoutineStep(
      stepId: 'step_get_ready',
      titleKey: 'bedtimeRoutineStepGetReadyTitle',
      shortDescriptionKey: 'bedtimeRoutineStepGetReadySubtitle',
      stepType: BedtimeRoutineStepType.getReadyForBed,
      sortOrder: 1,
      isOptional: false,
      estimatedDurationSeconds: 60,
      iconName: 'bed',
    ),
    BedtimeRoutineStep(
      stepId: 'step_bedtime_dua',
      titleKey: 'bedtimeRoutineStepDuaTitle',
      shortDescriptionKey: 'bedtimeRoutineStepDuaSubtitle',
      stepType: BedtimeRoutineStepType.bedtimeDua,
      sortOrder: 2,
      isOptional: false,
      estimatedDurationSeconds: 45,
      relatedDuaId: 'before-sleep',
      iconName: 'dua',
    ),
    BedtimeRoutineStep(
      stepId: 'step_story_time',
      titleKey: 'bedtimeRoutineStepStoryTitle',
      shortDescriptionKey: 'bedtimeRoutineStepStorySubtitle',
      stepType: BedtimeRoutineStepType.storyTime,
      sortOrder: 3,
      isOptional: false,
      estimatedDurationSeconds: 480,
      iconName: 'story',
    ),
    BedtimeRoutineStep(
      stepId: 'step_reflection',
      titleKey: 'bedtimeRoutineStepReflectionTitle',
      shortDescriptionKey: 'bedtimeRoutineStepReflectionSubtitle',
      stepType: BedtimeRoutineStepType.gratitudeReflection,
      sortOrder: 4,
      isOptional: true,
      estimatedDurationSeconds: 30,
      iconName: 'reflection',
    ),
    BedtimeRoutineStep(
      stepId: 'step_sleep_ready',
      titleKey: 'bedtimeRoutineStepSleepReadyTitle',
      shortDescriptionKey: 'bedtimeRoutineStepSleepReadySubtitle',
      stepType: BedtimeRoutineStepType.sleepReadyFinish,
      sortOrder: 5,
      isOptional: false,
      estimatedDurationSeconds: 15,
      iconName: 'moon',
    ),
  ],
);
