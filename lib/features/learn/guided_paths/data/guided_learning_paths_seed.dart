import '../../../../features/ocean/application/ocean_drops_provider.dart';
import '../domain/guided_learning_path_models.dart';

const List<GuidedLearningPath> kGuidedLearningPaths = <GuidedLearningPath>[
  GuidedLearningPath(
    id: 'foundations-starter',
    audience: GuidedLearningPathAudience.general,
    bucketId: 'foundations',
    iconCodePoint: 0xe318,
    highlight: true,
    tags: <String>['foundations', 'beginner'],
    steps: <GuidedLearningPathStep>[
      GuidedLearningPathStep(
        id: 'foundations-overview',
        pathId: 'foundations-starter',
        type: GuidedLearningPathStepType.lesson,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'learnJourneyStage',
          pathParameters: <String, String>{
            'journeyId': 'islam-foundations',
            'stageId': 'islam-what-is-islam',
          },
        ),
        estimatedMinutes: 8,
        reward: GuidedLearningPathStepReward(
          learningXp: 8,
          oceanActionType: oceanActionLessonCompleted,
          oceanSourceModule: oceanSourceLearn,
        ),
      ),
      GuidedLearningPathStep(
        id: 'foundations-daily-duas',
        pathId: 'foundations-starter',
        type: GuidedLearningPathStepType.lesson,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'learnJourneyStage',
          pathParameters: <String, String>{
            'journeyId': 'islam-foundations',
            'stageId': 'islam-who-is-allah',
          },
        ),
        estimatedMinutes: 6,
        reward: GuidedLearningPathStepReward(
          learningXp: 6,
          oceanActionType: oceanActionDuaLessonCompleted,
          oceanSourceModule: oceanSourceDua,
        ),
      ),
      GuidedLearningPathStep(
        id: 'foundations-salah-basics',
        pathId: 'foundations-starter',
        type: GuidedLearningPathStepType.lesson,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'learnJourneyStage',
          pathParameters: <String, String>{
            'journeyId': 'islam-foundations',
            'stageId': 'islam-five-pillars',
          },
        ),
        estimatedMinutes: 10,
        reward: GuidedLearningPathStepReward(
          learningXp: 10,
          oceanActionType: oceanActionLearningSegmentCompleted,
          oceanSourceModule: oceanSourceLearn,
        ),
      ),
      GuidedLearningPathStep(
        id: 'foundations-hadith-essentials',
        pathId: 'foundations-starter',
        type: GuidedLearningPathStepType.review,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'learnFoundationsNextSteps',
        ),
        estimatedMinutes: 8,
        reward: GuidedLearningPathStepReward(
          learningXp: 8,
          oceanActionType: oceanActionHadithLessonCompleted,
          oceanSourceModule: oceanSourceLearn,
        ),
      ),
    ],
  ),
  GuidedLearningPath(
    id: 'salah-starter',
    audience: GuidedLearningPathAudience.general,
    bucketId: 'worship',
    iconCodePoint: 0xe25a,
    highlight: true,
    tags: <String>['salah', 'worship'],
    steps: <GuidedLearningPathStep>[
      GuidedLearningPathStep(
        id: 'salah-learn-hub',
        pathId: 'salah-starter',
        type: GuidedLearningPathStepType.lesson,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'learnJourneyStage',
          pathParameters: <String, String>{
            'journeyId': 'salah-foundations',
            'stageId': 'salah-hub',
          },
        ),
        estimatedMinutes: 8,
        reward: GuidedLearningPathStepReward(
          learningXp: 8,
          oceanActionType: oceanActionSalahTrainingCompleted,
          oceanSourceModule: oceanSourceSalahTrainer,
        ),
      ),
      GuidedLearningPathStep(
        id: 'salah-wudu-guide',
        pathId: 'salah-starter',
        type: GuidedLearningPathStepType.lesson,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(routeName: 'learnWuduGuide'),
        estimatedMinutes: 6,
        reward: GuidedLearningPathStepReward(
          learningXp: 6,
          oceanActionType: oceanActionSalahTrainingCompleted,
          oceanSourceModule: oceanSourceSalahTrainer,
        ),
      ),
      GuidedLearningPathStep(
        id: 'salah-wudu-trainer',
        pathId: 'salah-starter',
        type: GuidedLearningPathStepType.practice,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'learnWuduTrainer',
        ),
        estimatedMinutes: 8,
        reward: GuidedLearningPathStepReward(
          learningXp: 8,
          oceanActionType: oceanActionSalahTrainingCompleted,
          oceanSourceModule: oceanSourceSalahTrainer,
        ),
      ),
      GuidedLearningPathStep(
        id: 'salah-guided-prayer',
        pathId: 'salah-starter',
        type: GuidedLearningPathStepType.practice,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'learnSalahGuidedPrayer',
          pathParameters: <String, String>{'prayerId': 'fajr'},
        ),
        estimatedMinutes: 10,
        reward: GuidedLearningPathStepReward(
          learningXp: 10,
          oceanActionType: oceanActionSalahTrainingCompleted,
          oceanSourceModule: oceanSourceSalahTrainer,
        ),
      ),
    ],
  ),
  GuidedLearningPath(
    id: 'quran-beginner-starter',
    audience: GuidedLearningPathAudience.general,
    bucketId: 'quran',
    iconCodePoint: 0xe865,
    highlight: true,
    tags: <String>['quran', 'beginner'],
    steps: <GuidedLearningPathStep>[
      GuidedLearningPathStep(
        id: 'quran-beginner-summary',
        pathId: 'quran-beginner-starter',
        type: GuidedLearningPathStepType.reading,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'learnQuranBeginnerSoftBridge',
        ),
        estimatedMinutes: 8,
        reward: GuidedLearningPathStepReward(
          learningXp: 8,
          oceanActionType: oceanActionQuranPageCompleted,
          oceanSourceModule: oceanSourceQuran,
        ),
      ),
      GuidedLearningPathStep(
        id: 'quran-beginner-daily',
        pathId: 'quran-beginner-starter',
        type: GuidedLearningPathStepType.reflection,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'quranSummaryPage',
        ),
        estimatedMinutes: 6,
        reward: GuidedLearningPathStepReward(
          learningXp: 6,
          oceanActionType: oceanActionReflectionCompleted,
          oceanSourceModule: oceanSourceQuran,
        ),
      ),
      GuidedLearningPathStep(
        id: 'quran-beginner-reader',
        pathId: 'quran-beginner-starter',
        type: GuidedLearningPathStepType.reading,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(routeName: 'quranExplorer'),
        estimatedMinutes: 8,
        reward: GuidedLearningPathStepReward(
          learningXp: 8,
          oceanActionType: oceanActionQuranPageCompleted,
          oceanSourceModule: oceanSourceQuran,
        ),
      ),
      GuidedLearningPathStep(
        id: 'quran-beginner-pathways',
        pathId: 'quran-beginner-starter',
        type: GuidedLearningPathStepType.review,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'quranLearningPaths',
        ),
        estimatedMinutes: 10,
        reward: GuidedLearningPathStepReward(
          learningXp: 10,
          oceanActionType: oceanActionLearningPathPhaseCompleted,
          oceanSourceModule: oceanSourceQuran,
        ),
      ),
    ],
  ),
  GuidedLearningPath(
    id: 'daily-dhikr-starter',
    audience: GuidedLearningPathAudience.general,
    bucketId: 'worship',
    iconCodePoint: 0xe06d,
    tags: <String>['dhikr', 'dua', 'worship'],
    steps: <GuidedLearningPathStep>[
      GuidedLearningPathStep(
        id: 'dhikr-intro-dua-hub',
        pathId: 'daily-dhikr-starter',
        type: GuidedLearningPathStepType.lesson,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'learnJourneyStage',
          pathParameters: <String, String>{
            'journeyId': 'daily-dhikr',
            'stageId': 'dhikr-what-is',
          },
        ),
        estimatedMinutes: 6,
        reward: GuidedLearningPathStepReward(
          learningXp: 6,
          oceanActionType: oceanActionLessonCompleted,
          oceanSourceModule: oceanSourceLearn,
        ),
      ),
      GuidedLearningPathStep(
        id: 'dhikr-counter',
        pathId: 'daily-dhikr-starter',
        type: GuidedLearningPathStepType.lesson,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'learnJourneyStage',
          pathParameters: <String, String>{
            'journeyId': 'daily-dhikr',
            'stageId': 'dhikr-morning-adhkar',
          },
        ),
        estimatedMinutes: 5,
        reward: GuidedLearningPathStepReward(
          learningXp: 4,
          oceanActionType: oceanActionLessonCompleted,
          oceanSourceModule: oceanSourceLearn,
        ),
      ),
      GuidedLearningPathStep(
        id: 'dhikr-after-salah',
        pathId: 'daily-dhikr-starter',
        type: GuidedLearningPathStepType.lesson,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'learnJourneyStage',
          pathParameters: <String, String>{
            'journeyId': 'daily-dhikr',
            'stageId': 'dhikr-simple-routine',
          },
        ),
        estimatedMinutes: 7,
        reward: GuidedLearningPathStepReward(
          learningXp: 6,
          oceanActionType: oceanActionLearningSegmentCompleted,
          oceanSourceModule: oceanSourceLearn,
        ),
      ),
      GuidedLearningPathStep(
        id: 'dhikr-routine',
        pathId: 'daily-dhikr-starter',
        type: GuidedLearningPathStepType.reflection,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'learnDailyDhikrNextSteps',
        ),
        estimatedMinutes: 8,
        reward: GuidedLearningPathStepReward(
          learningXp: 8,
          oceanActionType: oceanActionLearningPathPhaseCompleted,
          oceanSourceModule: oceanSourceLearn,
        ),
      ),
    ],
  ),
  GuidedLearningPath(
    id: 'character-starter',
    audience: GuidedLearningPathAudience.general,
    bucketId: 'character',
    iconCodePoint: 0xe7fd,
    tags: <String>['character', 'adab'],
    steps: <GuidedLearningPathStep>[
      GuidedLearningPathStep(
        id: 'character-companion',
        pathId: 'character-starter',
        type: GuidedLearningPathStepType.lesson,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'learnCharacterCompanion',
        ),
        estimatedMinutes: 6,
        reward: GuidedLearningPathStepReward(
          learningXp: 6,
          oceanActionType: oceanActionLessonCompleted,
          oceanSourceModule: oceanSourceLearn,
        ),
      ),
      GuidedLearningPathStep(
        id: 'character-life-lessons',
        pathId: 'character-starter',
        type: GuidedLearningPathStepType.lesson,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'learnCharacterCompanion',
          queryParameters: <String, String>{'focus': 'sabr'},
        ),
        estimatedMinutes: 8,
        reward: GuidedLearningPathStepReward(
          learningXp: 8,
          oceanActionType: oceanActionLessonCompleted,
          oceanSourceModule: oceanSourceLearn,
        ),
      ),
      GuidedLearningPathStep(
        id: 'character-quran-reflection',
        pathId: 'character-starter',
        type: GuidedLearningPathStepType.reflection,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'learnJourneyStage',
          pathParameters: <String, String>{
            'journeyId': 'beautiful-character',
            'stageId': 'character-kindness',
          },
        ),
        estimatedMinutes: 9,
        reward: GuidedLearningPathStepReward(
          learningXp: 9,
          oceanActionType: oceanActionReflectionCompleted,
          oceanSourceModule: oceanSourceLearn,
        ),
      ),
      GuidedLearningPathStep(
        id: 'character-guided-journey',
        pathId: 'character-starter',
        type: GuidedLearningPathStepType.reflection,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'learnJourneyStage',
          pathParameters: <String, String>{
            'journeyId': 'beautiful-character',
            'stageId': 'character-completion',
          },
        ),
        estimatedMinutes: 8,
        reward: GuidedLearningPathStepReward(
          learningXp: 8,
          oceanActionType: oceanActionReflectionCompleted,
          oceanSourceModule: oceanSourceLearn,
        ),
      ),
    ],
  ),
  GuidedLearningPath(
    id: 'stories-starter',
    audience: GuidedLearningPathAudience.general,
    bucketId: 'stories',
    iconCodePoint: 0xe865,
    highlight: true,
    tags: <String>['stories', 'prophets', 'seerah', 'beginner'],
    steps: <GuidedLearningPathStep>[
      GuidedLearningPathStep(
        id: 'stories-intro',
        pathId: 'stories-starter',
        type: GuidedLearningPathStepType.lesson,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'learnStoriesPathBridge',
        ),
        estimatedMinutes: 4,
        reward: GuidedLearningPathStepReward(
          learningXp: 4,
          oceanActionType: oceanActionLessonCompleted,
          oceanSourceModule: oceanSourceLearn,
        ),
      ),
      GuidedLearningPathStep(
        id: 'stories-prophets-entry',
        pathId: 'stories-starter',
        type: GuidedLearningPathStepType.reading,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'learnJourneyStage',
          pathParameters: <String, String>{
            'journeyId': 'prophets-journey',
            'stageId': 'prophets-overview',
          },
        ),
        estimatedMinutes: 6,
        reward: GuidedLearningPathStepReward(
          learningXp: 6,
          oceanActionType: oceanActionProphetStoryCompleted,
          oceanSourceModule: oceanSourceLearn,
        ),
      ),
      GuidedLearningPathStep(
        id: 'stories-prophets-journey',
        pathId: 'stories-starter',
        type: GuidedLearningPathStepType.reading,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'learnJourneyStage',
          pathParameters: <String, String>{
            'journeyId': 'prophets-journey',
            'stageId': 'prophets-journey-map',
          },
        ),
        estimatedMinutes: 8,
        reward: GuidedLearningPathStepReward(
          learningXp: 8,
          oceanActionType: oceanActionProphetStoryCompleted,
          oceanSourceModule: oceanSourceLearn,
        ),
      ),
      GuidedLearningPathStep(
        id: 'stories-seerah-intro',
        pathId: 'stories-starter',
        type: GuidedLearningPathStepType.lesson,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'learnJourneyStage',
          pathParameters: <String, String>{
            'journeyId': 'seerah-journey',
            'stageId': 'seerah-early-life',
          },
        ),
        estimatedMinutes: 7,
        reward: GuidedLearningPathStepReward(
          learningXp: 7,
          oceanActionType: oceanActionLessonCompleted,
          oceanSourceModule: oceanSourceLearn,
        ),
      ),
      GuidedLearningPathStep(
        id: 'stories-seerah-key-moment',
        pathId: 'stories-starter',
        type: GuidedLearningPathStepType.lesson,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'learnJourneyStage',
          pathParameters: <String, String>{
            'journeyId': 'seerah-journey',
            'stageId': 'seerah-hijrah',
          },
        ),
        estimatedMinutes: 8,
        reward: GuidedLearningPathStepReward(
          learningXp: 8,
          oceanActionType: oceanActionLessonCompleted,
          oceanSourceModule: oceanSourceLearn,
        ),
      ),
      GuidedLearningPathStep(
        id: 'stories-reflection',
        pathId: 'stories-starter',
        type: GuidedLearningPathStepType.reflection,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'learnJourneyStage',
          pathParameters: <String, String>{
            'journeyId': 'seerah-journey',
            'stageId': 'seerah-leadership-character',
          },
        ),
        estimatedMinutes: 7,
        reward: GuidedLearningPathStepReward(
          learningXp: 7,
          oceanActionType: oceanActionReflectionCompleted,
          oceanSourceModule: oceanSourceLearn,
        ),
      ),
      GuidedLearningPathStep(
        id: 'stories-next-steps',
        pathId: 'stories-starter',
        type: GuidedLearningPathStepType.review,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'learnStoriesPathNextSteps',
        ),
        estimatedMinutes: 6,
        reward: GuidedLearningPathStepReward(
          learningXp: 6,
          oceanActionType: oceanActionLearningPathPhaseCompleted,
          oceanSourceModule: oceanSourceLearn,
        ),
      ),
    ],
  ),
  GuidedLearningPath(
    id: 'kids-starter',
    audience: GuidedLearningPathAudience.kids,
    bucketId: 'kids',
    iconCodePoint: 0xe87c,
    highlight: true,
    tags: <String>['kids', 'starter'],
    steps: <GuidedLearningPathStep>[
      GuidedLearningPathStep(
        id: 'kids-quran',
        pathId: 'kids-starter',
        type: GuidedLearningPathStepType.lesson,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'learnKidsStarterBridge',
        ),
        estimatedMinutes: 4,
        reward: GuidedLearningPathStepReward(
          learningXp: 4,
          oceanActionType: oceanActionLessonCompleted,
          oceanSourceModule: oceanSourceLearn,
        ),
      ),
      GuidedLearningPathStep(
        id: 'kids-arabic',
        pathId: 'kids-starter',
        type: GuidedLearningPathStepType.lesson,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'kidsArabicLesson',
          pathParameters: <String, String>{'letterId': 'alif'},
        ),
        estimatedMinutes: 6,
        reward: GuidedLearningPathStepReward(
          learningXp: 6,
          oceanActionType: oceanActionLearningSegmentCompleted,
          oceanSourceModule: oceanSourceLearn,
        ),
      ),
      GuidedLearningPathStep(
        id: 'kids-stories',
        pathId: 'kids-starter',
        type: GuidedLearningPathStepType.reading,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'kidsStoryDetail',
          pathParameters: <String, String>{
            'storyId': 'story_bismillah_before_eating_v1',
          },
        ),
        estimatedMinutes: 5,
        reward: GuidedLearningPathStepReward(
          learningXp: 6,
          oceanActionType: oceanActionProphetStoryCompleted,
          oceanSourceModule: oceanSourceLearn,
        ),
      ),
      GuidedLearningPathStep(
        id: 'kids-games',
        pathId: 'kids-starter',
        type: GuidedLearningPathStepType.lesson,
        completionMode: GuidedLearningPathCompletionMode.explicit,
        routeTarget: GuidedLearningPathRouteTarget(
          routeName: 'learnKidsStarterNextSteps',
        ),
        estimatedMinutes: 8,
        reward: GuidedLearningPathStepReward(
          learningXp: 6,
          oceanActionType: oceanActionDuaLessonCompleted,
          oceanSourceModule: oceanSourceDua,
        ),
      ),
    ],
  ),
];
