import '../domain/learner_progression_models.dart';

const List<LearnerProgressionBadgeDefinition> learnerProgressionBadgeCatalog =
    <LearnerProgressionBadgeDefinition>[
      LearnerProgressionBadgeDefinition(
        badgeId: 'badge_first_story',
        titleKey: 'progressionBadgeFirstStoryTitle',
        descriptionKey: 'progressionBadgeFirstStoryDescription',
        category: LearnerProgressionBadgeCategory.story,
        iconName: 'auto_stories_rounded',
      ),
      LearnerProgressionBadgeDefinition(
        badgeId: 'badge_first_quiz',
        titleKey: 'progressionBadgeFirstQuizTitle',
        descriptionKey: 'progressionBadgeFirstQuizDescription',
        category: LearnerProgressionBadgeCategory.story,
        iconName: 'quiz_rounded',
      ),
      LearnerProgressionBadgeDefinition(
        badgeId: 'badge_first_memory',
        titleKey: 'progressionBadgeFirstMemoryTitle',
        descriptionKey: 'progressionBadgeFirstMemoryDescription',
        category: LearnerProgressionBadgeCategory.story,
        iconName: 'style_rounded',
      ),
      LearnerProgressionBadgeDefinition(
        badgeId: 'badge_first_dua',
        titleKey: 'progressionBadgeFirstDuaTitle',
        descriptionKey: 'progressionBadgeFirstDuaDescription',
        category: LearnerProgressionBadgeCategory.dua,
        iconName: 'favorite_border_rounded',
      ),
      LearnerProgressionBadgeDefinition(
        badgeId: 'badge_first_seerah_stage',
        titleKey: 'progressionBadgeFirstSeerahStageTitle',
        descriptionKey: 'progressionBadgeFirstSeerahStageDescription',
        category: LearnerProgressionBadgeCategory.seerah,
        iconName: 'timeline_rounded',
      ),
      LearnerProgressionBadgeDefinition(
        badgeId: 'badge_first_bedtime_routine',
        titleKey: 'progressionBadgeFirstRoutineTitle',
        descriptionKey: 'progressionBadgeFirstRoutineDescription',
        category: LearnerProgressionBadgeCategory.routine,
        iconName: 'nightlight_round_rounded',
      ),
      LearnerProgressionBadgeDefinition(
        badgeId: 'badge_bedtime_streak_7',
        titleKey: 'progressionBadgeBedtimeWeekTitle',
        descriptionKey: 'progressionBadgeBedtimeWeekDescription',
        category: LearnerProgressionBadgeCategory.consistency,
        iconName: 'bedtime_rounded',
      ),
      LearnerProgressionBadgeDefinition(
        badgeId: 'badge_stories_10',
        titleKey: 'progressionBadgeStoriesTenTitle',
        descriptionKey: 'progressionBadgeStoriesTenDescription',
        category: LearnerProgressionBadgeCategory.milestone,
        iconName: 'menu_book_rounded',
      ),
      LearnerProgressionBadgeDefinition(
        badgeId: 'badge_journey_complete',
        titleKey: 'progressionBadgeJourneyCompleteTitle',
        descriptionKey: 'progressionBadgeJourneyCompleteDescription',
        category: LearnerProgressionBadgeCategory.seerah,
        iconName: 'flag_rounded',
      ),
    ];

const List<LearnerProgressionMilestoneDefinition>
learnerProgressionMilestoneCatalog = <LearnerProgressionMilestoneDefinition>[
  LearnerProgressionMilestoneDefinition(
    milestoneId: 'milestone_stories_10',
    titleKey: 'progressionMilestoneStoriesTenTitle',
    descriptionKey: 'progressionMilestoneStoriesTenDescription',
    metric: LearnerProgressionMilestoneMetric.storiesCompleted,
    threshold: 10,
  ),
  LearnerProgressionMilestoneDefinition(
    milestoneId: 'milestone_stories_50',
    titleKey: 'progressionMilestoneStoriesFiftyTitle',
    descriptionKey: 'progressionMilestoneStoriesFiftyDescription',
    metric: LearnerProgressionMilestoneMetric.storiesCompleted,
    threshold: 50,
  ),
  LearnerProgressionMilestoneDefinition(
    milestoneId: 'milestone_quizzes_10',
    titleKey: 'progressionMilestoneQuizzesTenTitle',
    descriptionKey: 'progressionMilestoneQuizzesTenDescription',
    metric: LearnerProgressionMilestoneMetric.quizzesCompleted,
    threshold: 10,
  ),
  LearnerProgressionMilestoneDefinition(
    milestoneId: 'milestone_duas_10',
    titleKey: 'progressionMilestoneDuasTenTitle',
    descriptionKey: 'progressionMilestoneDuasTenDescription',
    metric: LearnerProgressionMilestoneMetric.duaLessonsCompleted,
    threshold: 10,
  ),
  LearnerProgressionMilestoneDefinition(
    milestoneId: 'milestone_seerah_stage_1',
    titleKey: 'progressionMilestoneSeerahStageTitle',
    descriptionKey: 'progressionMilestoneSeerahStageDescription',
    metric: LearnerProgressionMilestoneMetric.seerahStagesCompleted,
    threshold: 1,
  ),
  LearnerProgressionMilestoneDefinition(
    milestoneId: 'milestone_seerah_journey_1',
    titleKey: 'progressionMilestoneSeerahJourneyTitle',
    descriptionKey: 'progressionMilestoneSeerahJourneyDescription',
    metric: LearnerProgressionMilestoneMetric.seerahJourneysCompleted,
    threshold: 1,
  ),
  LearnerProgressionMilestoneDefinition(
    milestoneId: 'milestone_bedtime_routine_7',
    titleKey: 'progressionMilestoneBedtimeWeekTitle',
    descriptionKey: 'progressionMilestoneBedtimeWeekDescription',
    metric: LearnerProgressionMilestoneMetric.bedtimeRoutineCompleted,
    threshold: 7,
  ),
  LearnerProgressionMilestoneDefinition(
    milestoneId: 'milestone_learning_streak_30',
    titleKey: 'progressionMilestoneLearningMonthTitle',
    descriptionKey: 'progressionMilestoneLearningMonthDescription',
    metric: LearnerProgressionMilestoneMetric.learningStreakDays,
    threshold: 30,
  ),
];
